Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8A030AA11
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 15:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhBAOmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 09:42:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33718 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231337AbhBAOmU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 09:42:20 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 111EVrH0079834;
        Mon, 1 Feb 2021 09:41:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TU3NyM68sAIZL9EFcGmmh9iUmXw/QQ+1LWXS/0Vd/KY=;
 b=hqsFVpQfQ0p9Lz7ZKCbd0lSgD1PrHnWdL3I1PQZ0czuHvMEb09WkNhUCksTW2jxw2WtM
 6fC90N7GZ8QbYnm9R94RKWcR9V+Ldovds+w2j+tmn2RHzF44BHFzi7kITugSxrAfcRoQ
 9YKIKGC87/NYjtouJSZTMAhUMO1tCBY/g/y4t2TQKXiZBXXQjRKO3qbX1B/e/iuwXwDc
 z4wfOoKMc2VTF8Kl0Vx1f7Gq0/tRpSqWpXf4TJXYSKgiIMmUx96SeL0o9AX4FhvFzbdQ
 3wUJNxeLiDqQGG3W0DijEaca+5BddKw04sgJdzAOUKmeaUzjS+Mp+lQH22EBBX7BgKuW 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36ek8c8yxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 09:41:34 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 111EWQlu083514;
        Mon, 1 Feb 2021 09:41:33 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36ek8c8ywy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 09:41:33 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 111EbkOY011553;
        Mon, 1 Feb 2021 14:41:32 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 36cy38tv3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 14:41:32 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 111EfU1j22217124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Feb 2021 14:41:30 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A10D0124054;
        Mon,  1 Feb 2021 14:41:30 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD644124058;
        Mon,  1 Feb 2021 14:41:29 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.203.235])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  1 Feb 2021 14:41:29 +0000 (GMT)
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
Message-ID: <5a221fb3-4dc0-0aef-7910-51f395ba1bcd@linux.ibm.com>
Date:   Mon, 1 Feb 2021 09:41:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210112185550.1ac49768.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_05:2021-01-29,2021-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 spamscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 malwarescore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010073
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

Yes, that's probably the order in which  it should be done.
I'll change it.

>
> Regards,
> Halil

