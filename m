Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1224F30E6F4
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 00:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbhBCXOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 18:14:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55930 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233461AbhBCXN5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 18:13:57 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 113N5mmx118502;
        Wed, 3 Feb 2021 18:13:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iKqIILtW4S73yXe1HmBJvm0g7QX89FYzx94glAKWPeE=;
 b=CBgmEx0Dp9AyA86hn6Rw6gZqRGhUo/XkpzK9EnZNsXZ8XC2mUEk+JwzkvMq1OoJb9TuA
 rhpYhbAANMu2jiyDBs1x1CiaYcyq6MIGz3arChFXqiMn5G0u+L3SYKDE4Im3b85EetwJ
 jhN6ECktcgJhrJkrlgofcd/Gdra4hiY71utK1oV/A+n6XLDVVjhoO7pcq49xunz48LCX
 2dBWJc883KFGWcCG2fMJQ4+A+xYymf2XkEPlWGqNIDr0uLp/uwNbCcjISkdtA2EB7D01
 vUR3MifTX+ZiVSMRg07/fv7GPItKICpUWsOPriPChFKagME0z/tj5vrTnv89mDYOzPnl Og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36g4w28fxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 18:13:13 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 113N5rEc118618;
        Wed, 3 Feb 2021 18:13:12 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36g4w28fxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 18:13:12 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 113N85GI016463;
        Wed, 3 Feb 2021 23:13:12 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 36f3kvg8dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 23:13:12 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 113NDAEx35979556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Feb 2021 23:13:10 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D0DD112062;
        Wed,  3 Feb 2021 23:13:10 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97444112061;
        Wed,  3 Feb 2021 23:13:09 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.203.235])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  3 Feb 2021 23:13:09 +0000 (GMT)
Subject: Re: [PATCH v13 09/15] s390/vfio-ap: allow hot plug/unplug of AP
 resources using mdev device
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
 <20201223011606.5265-10-akrowiak@linux.ibm.com>
 <20210112021251.0d989225.pasic@linux.ibm.com>
 <20210112185550.1ac49768.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <73ad5b17-f252-2aad-1d08-14635c8460ef@linux.ibm.com>
Date:   Wed, 3 Feb 2021 18:13:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210112185550.1ac49768.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-03_09:2021-02-03,2021-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030138
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/12/21 12:55 PM, Halil Pasic wrote:
> On Tue, 12 Jan 2021 02:12:51 +0100
> Halil Pasic <pasic@linux.ibm.com> wrote:
>
>>> @@ -1347,8 +1437,11 @@ void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>>>   	apqi = AP_QID_QUEUE(q->apqn);
>>>   	vfio_ap_mdev_reset_queue(apid, apqi, 1);
>>>   
>>> -	if (q->matrix_mdev)
>>> +	if (q->matrix_mdev) {
>>> +		matrix_mdev = q->matrix_mdev;
>>>   		vfio_ap_mdev_unlink_queue(q);
>>> +		vfio_ap_mdev_refresh_apcb(matrix_mdev);
>>> +	}
>>>   
>>>   	kfree(q);
>>>   	mutex_unlock(&matrix_dev->lock);
> Shouldn't we first remove the queue from the APCB and then
> reset? Sorry, I missed this one yesterday.

I agreed to move the reset, however if the remove callback is
invoked due to a manual unbind of the queue and the queue is
in use by a guest, the cleanup of the IRQ resources after the
reset of the queue will not happen because the link from the
queue to the matrix mdev was removed. Consequently, I'm going
to have to change the patch 05/15 to split the vfio_ap_mdev_unlink_queue()
function into two functions: one to remove the link from the matrix mdev to
the queue; and, one to remove the link from the queue to the matrix
mdev. Only the first will be used for the remove callback which should
be fine since the queue object is freed at the end of the remove
function anyway.

>
> Regards,
> Halil

