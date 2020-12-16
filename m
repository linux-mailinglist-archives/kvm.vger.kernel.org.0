Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935C02DC799
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 21:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgLPUPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 15:15:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8060 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727389AbgLPUPh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 15:15:37 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK2hOF112528;
        Wed, 16 Dec 2020 15:14:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=bYRIMadoXkFGSArVFTCW4u/G0vOScXCr43xte1fl7BI=;
 b=ZlVzI4f7Hjb91eQo6Cy5IKDUV/zlHYaM1o3RmBS5litqnqCWWIiKGw1lJo/8sbZp2nv5
 fBTXIA9CtLge6obuak6nxbiDN+K5PJ3LqflKfwcajsK5TQ6gH/nkn17hzbUHoHnZ/d2f
 11yP7p3A9LOnsfAhHyI/SugFa94083682li53WMw31Y4i+IXqNdce5cfH3FbhTcLfDIH
 PIFMT3Sa+XGbebSxWUGuvm2FQ+Sa3uiyVTDZPp/cFG4tT9kFbrK+3/lg9WaZebbghYMr
 937Z4TEx6OEN0qcFAdvrXNE2Pmyactuyrz8tdLg+MtLJ9VXfSDb5kMR6GO/EwqqNBrg1 OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35fp0bnwua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:14:54 -0500
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BGK5PhM129326;
        Wed, 16 Dec 2020 15:14:54 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35fp0bnwu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 15:14:54 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BGK6sYg017890;
        Wed, 16 Dec 2020 20:14:53 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 35cng9tybw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 20:14:53 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BGKEov68520248
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 20:14:50 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 189B5BE056;
        Wed, 16 Dec 2020 20:14:50 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A404FBE04F;
        Wed, 16 Dec 2020 20:14:48 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.193.150])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 16 Dec 2020 20:14:48 +0000 (GMT)
Subject: Re: [PATCH v12 11/17] s390/vfio-ap: allow assignment of unavailable
 AP queues to mdev device
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201124214016.3013-1-akrowiak@linux.ibm.com>
 <20201124214016.3013-12-akrowiak@linux.ibm.com>
 <20201129021717.5683e779.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <b94f220b-37c4-abce-432d-5304d22f65b9@linux.ibm.com>
Date:   Wed, 16 Dec 2020 15:14:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201129021717.5683e779.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
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



On 11/28/20 8:17 PM, Halil Pasic wrote:
> On Tue, 24 Nov 2020 16:40:10 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The current implementation does not allow assignment of an AP adapter or
>> domain to an mdev device if each APQN resulting from the assignment
>> does not reference an AP queue device that is bound to the vfio_ap device
>> driver. This patch allows assignment of AP resources to the matrix mdev as
>> long as the APQNs resulting from the assignment:
>>     1. Are not reserved by the AP BUS for use by the zcrypt device drivers.
>>     2. Are not assigned to another matrix mdev.
>>
>> The rationale behind this is twofold:
>>     1. The AP architecture does not preclude assignment of APQNs to an AP
>>        configuration that are not available to the system.
>>     2. APQNs that do not reference a queue device bound to the vfio_ap
>>        device driver will not be assigned to the guest's CRYCB, so the
>>        guest will not get access to queues not bound to the vfio_ap driver.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Again code looks good. I'm still worried about all the incremental
> changes (good for review) and their testability.

I'm not sure what your concern is here. Is there an expectation
that each patch needs to be testable by itself, or whether the
functionality in each patch can be easily tested en masse?

I'm not sure some of these changes can be tested with an
automated test because the test code would have to be able to
dynamically change the host's AP configuration and I don't know
if there is currently a way to do this programmatically. In order to
test the effects of dynamic host crypto configuration manually, one
needs access to an SE or HMC with DPM.


