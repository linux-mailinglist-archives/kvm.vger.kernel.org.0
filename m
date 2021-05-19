Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C2D388D5B
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 13:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346290AbhESMAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 08:00:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45874 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237480AbhESMAW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 08:00:22 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14JBqtS7102256;
        Wed, 19 May 2021 07:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=spntsKBhPCcbEDS5BqG0SOEXJdVrz3ZyeeKWYgvkAk8=;
 b=TxrfkQa+b7970wSTZ78mn/xGAyTvYiOuyazKXLMZ0x8mumMneezGWyifnpQ4zL35nDcZ
 8nJRa4jWtOUxK5n2z7jk1DGg/cBy9Po9sYACeH8S8hErUkYRmkUIir8fiABgYnJuzWbs
 FMQJMi7+98nmUj9YXrMaBsHpZHCOJ40dFHVy0a2ecg3rPFeXhpfLduYHPmEIkbobASYR
 vPihJ30eNwW9/uxssDPQY9NjvmpRpETd+fHKlJYijKMFgC4j0jDRh9jwPLQTdC9txSpS
 KC14vMWiLlp4s40ZMWBrts9C9RrduA8jO1ypnp2vxujFxHkwQHRgTyKNo34DjKMQl1xW Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38n26n83qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 07:59:01 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14JBrBuY107215;
        Wed, 19 May 2021 07:59:01 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38n26n83pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 07:59:01 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14JBnRYj021736;
        Wed, 19 May 2021 11:58:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 38j5x8a2wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 May 2021 11:58:58 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14JBwtjh65601900
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 11:58:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC94AAE053;
        Wed, 19 May 2021 11:58:55 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D83FBAE04D;
        Wed, 19 May 2021 11:58:54 +0000 (GMT)
Received: from [9.145.20.252] (unknown [9.145.20.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 May 2021 11:58:54 +0000 (GMT)
Subject: Re: [PATCH v16 10/14] s390/zcrypt: driver callback to indicate
 resource in use
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
References: <20210510164423.346858-1-akrowiak@linux.ibm.com>
 <20210510164423.346858-11-akrowiak@linux.ibm.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <f928022c-8549-9772-924c-37c0cab79b9d@linux.ibm.com>
Date:   Wed, 19 May 2021 14:58:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210510164423.346858-11-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tjCB68Yy6M6UUBIjSpDUyhCCoUW31-TW
X-Proofpoint-GUID: XKi-4Jui0TKe0BYEDhj6n7L6BBqkon2C
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-19_04:2021-05-19,2021-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 mlxscore=0 adultscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.05.21 19:44, Tony Krowiak wrote:
> Introduces a new driver callback to prevent a root user from unbinding
> an AP queue from its device driver if the queue is in use. The callback
> will be invoked whenever a change to the AP bus's sysfs apmask or aqmask
> attributes would result in one or more AP queues being removed from its
> driver. If the callback responds in the affirmative for any driver
> queried, the change to the apmask or aqmask will be rejected with a device
> busy error.
> 
> For this patch, only non-default drivers will be queried. Currently,
> there is only one non-default driver, the vfio_ap device driver. The
> vfio_ap device driver facilitates pass-through of an AP queue to a
> guest. The idea here is that a guest may be administered by a different
> sysadmin than the host and we don't want AP resources to unexpectedly
> disappear from a guest's AP configuration (i.e., adapters and domains
> assigned to the matrix mdev). This will enforce the proper procedure for
> removing AP resources intended for guest usage which is to
> first unassign them from the matrix mdev, then unbind them from the
> vfio_ap device driver.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> ---
>  drivers/s390/crypto/ap_bus.c | 160 ++++++++++++++++++++++++++++++++---
>  drivers/s390/crypto/ap_bus.h |   4 +
>  2 files changed, 154 insertions(+), 10 deletions(-)
> 

This doesn't touch the zcrypt drivers, so I _think_ the subject should
rather be "s390/ap: driver callback to indicate resource in use". Harald?

Same for patch 13.
