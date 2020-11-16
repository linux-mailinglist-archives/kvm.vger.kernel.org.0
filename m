Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5452B4AE1
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 17:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732029AbgKPQXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 11:23:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21246 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731899AbgKPQXr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Nov 2020 11:23:47 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGG2xeo137471;
        Mon, 16 Nov 2020 11:23:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=g/EvCmxS1ToBMSBs+cRtaO5J5ilferer+np5wtLzoIQ=;
 b=dAXo1zbpYaYLmM69j5TstSV2rDH3nFtoYmvMnIhi0GmsV86jfG9OahiPaWo9zX+76uY2
 MIs8Y7p2oMdWoVAsWZgHXYRTNW9zJyMvZ/YNerMP8m3QEBiHVgubyuSsL+yXsIVmc2VW
 VWT5s1HCKpDqslsuv+HtLO9vbU1G8+25WgH+rV1dEy0ibY2UeOKUxvb6J/viq+Ncw1xV
 4utJtXSxF5uo+Gn2wCX3feLuHOgeIj8FpJWSoU6O36LxIMtpWuWxNwrKPQIsul2pMSr6
 hZsk2NMk7FW4zAroRoKq5JPPyO0xDwcHYwY5yi0NWwsSxjfTzym5Ys1Zi5yRG3TO2nX0 mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34uupnjcm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 11:23:45 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AGG3CT7138845;
        Mon, 16 Nov 2020 11:23:45 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34uupnjckt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 11:23:45 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AGGHc0q006003;
        Mon, 16 Nov 2020 16:23:44 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 34t6v943w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Nov 2020 16:23:44 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AGGNfmE59441488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Nov 2020 16:23:41 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CA106E04E;
        Mon, 16 Nov 2020 16:23:41 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA3E36E059;
        Mon, 16 Nov 2020 16:23:39 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.152.80])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 16 Nov 2020 16:23:39 +0000 (GMT)
Subject: Re: [PATCH v11 04/14] s390/zcrypt: driver callback to indicate
 resource in use
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
 <20201022171209.19494-5-akrowiak@linux.ibm.com>
 <42f3f4f9-6263-cb1e-d882-30b62236a594@linux.ibm.com>
 <dcdb9c78-daf8-1f25-f59a-903f0db96ada@linux.ibm.com>
 <20201114010020.381277c2.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <1e6387bc-3bc0-f244-17ae-7acc88cd3f1b@linux.ibm.com>
Date:   Mon, 16 Nov 2020 11:23:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201114010020.381277c2.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_08:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011160095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/13/20 7:00 PM, Halil Pasic wrote:
> On Fri, 13 Nov 2020 16:30:31 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> We will be using the mutex_trylock() function in our sysfs
>> assignment
>> interfaces which make the call to the AP bus to check permissions (which
>> also
>> locks ap_perms). If the mutex_trylock() fails, we return from the assignment
>> function with -EBUSY. This should resolve that potential deadlock issue.
> It resolves the deadlock issue only if in_use() is also doing
> mutex_trylock(), but the if in_use doesn't take the lock it
> needs to back off (and so does it's client code) i.e. a boolean as
> return value won't do.

Makes sense. I'll change the in_use callback to return an int and use
mutex_trylock() for the vfio_ap_mdev_in_use() function. If the lock
can not be obtained, the function will return -EBUSY.

>
> Regards,
> Halil

