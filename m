Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15BB2DC7BC
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgLPU0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:26:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54374 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726979AbgLPU0R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 15:26:17 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK2kAG112755;
        Wed, 16 Dec 2020 15:25:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=MRagXbNZpUZTCRZfrFvrQ715I/2kkvCz52aJAo93sh4=;
 b=YGHd3uCZ4CzvP9NygJ6kQUyqEM4va5+HrYfpHB7hkQ4NG7DyvINn0anTKq1IKzK6obQN
 X9gilzw9YBljkDcN5VDfvUZ4mQAazKuzQmOu1r4wgY8ex0TDjE7J5kxxcKB8qJZIIc9j
 qE5YcS3kzqALk5SYvgiAGkC3gO0svNvURBaybCjODwXsf9x9BUYGaKUKeSCgFiF2aFp6
 gbHbSEV3kzaBcEqHsM088xz28Q+y/6oJR7+whV+2fmSLUFKThuS4xlXEVVkg3sTG86xP
 0cOwO8uVczP7a/qduO2gNlc3k1wqnFU1yat7bI4cs8d3isxAO4LkFAcJAdlJnfhxEWpd 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35fp0bp6kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:25:31 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGK2vAs114505;
        Wed, 16 Dec 2020 15:25:31 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35fp0bp6h2-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:25:31 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK7Kd2031254;
        Wed, 16 Dec 2020 20:08:55 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 35cng9jush-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 20:08:55 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGK8qZP21102868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 20:08:52 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46A27BE05F;
        Wed, 16 Dec 2020 20:08:52 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73354BE054;
        Wed, 16 Dec 2020 20:08:50 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 20:08:50 +0000 (GMT)
Subject: Re: [PATCH v12 10/17] s390/vfio-ap: initialize the guest apcb
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
 <20201124214016.3013-11-akrowiak@linux.ibm.com>
 <20201129020923.6c470310.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <d083cd18-be1a-e220-0063-94c3985deb32@linux.ibm.com>
Date:   Wed, 16 Dec 2020 15:08:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201129020923.6c470310.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_08:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0 clxscore=1015
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/28/20 8:09 PM, Halil Pasic wrote:
> On Tue, 24 Nov 2020 16:40:09 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The APCB is a control block containing the masks that specify the adapters,
>> domains and control domains to which a KVM guest is granted access. When
>> the vfio_ap device driver is notified that the KVM pointer has been set,
>> the guest's APCB is initialized from the AP configuration of adapters,
>> domains and control domains assigned to the matrix mdev. The linux device
>> model, however, precludes passing through to a guest any devices that
>> are not bound to the device driver facilitating the pass-through.
>> Consequently, APQNs assigned to the matrix mdev that do not reference
>> AP queue devices must be filtered before assigning them to the KVM guest's
>> APCB; however, the AP architecture precludes filtering individual APQNs, so
>> the APQNs will be filtered by APID. That is, if a given APQN does not
>> reference a queue device bound to the vfio_ap driver, its APID will not
>> get assigned to the guest's APCB. For example:
>>
>> Queues bound to vfio_ap:
>> 04.0004
>> 04.0022
>> 04.0035
>> 05.0004
>> 05.0022
>>
>> Adapters/domains assigned to the matrix mdev:
>> 04 0004
>>     0022
>>     0035
>> 05 0004
>>     0022
>>     0035
>>
>> APQNs assigned to APCB:
>> 04.0004
>> 04.0022
>> 04.0035
>>
>> The APID 05 was filtered from the matrix mdev's matrix because
>> queue device 05.0035 is not bound to the vfio_ap device driver.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> This adds filtering. So from here guest_matrix may be different
> than matrix also for an mdev that is associated with a guest. I'm still
> grappling with the big picture. Have you thought about testability?
> How is a testcase supposed to figure out which behavior is
> to be deemed correct?

This patch is going away for v13 which is forthcoming.
The filtering of the mdev's matrix will become part of the
hot plug patch and will be used whenever changes to the
mdev's matrix are made (i.e., assign/unassign), when
AP queue devices are bound to and unbound from the
vfio_ap device driver and when the host AP configuration
changes. This resolves a couple of issues that have been
brought up in these reviews:
1. Keeps the expected behavior across the various means of
     changing the guest's AP configuration.
2. Simplifies the code.

>
> I don't like the title line. It implies that guest apcb was
> uninitialized before. Which is not the case.

This patch is going away for v13.

>
>
>
>

