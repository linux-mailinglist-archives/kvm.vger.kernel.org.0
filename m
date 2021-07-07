Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B613BE4DA
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 10:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhGGJCR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 05:02:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230219AbhGGJCQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 05:02:16 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1678Xi62051132;
        Wed, 7 Jul 2021 04:59:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QgYglSGD24Lym5FcJPRMfrnEZE2L0FN6CiErNmTmAco=;
 b=bboyrJGneCEHRZDV2mFB6FvhWmTMUsLBXCwzPf7GXBdYtaUZSodMU7tmfaXcG9WPBKW5
 /eRYHSWp1mWPcPLESdQ8M2/3ByHg87DmW1nv59MPSfS2wrf+m0EJy8NRqlOTFHNDVA+U
 GHHAp2RYt8BIGV6HUMy9V18htw6pjQz7rxSyzJz2NfvjceosnDYAUxboTkHMA23UEvXK
 sUrCNRxffhQlK42SucRIKvCOrVb+GG8x8oEztSvhQnQp41Udvi7oc5NWpmiXFEU2ovT4
 dCX1FXuUsERyfxx2YL6O3BXJs2L9ioHAdIR6U/unu+PUqVzNuP383OP26NljzCTYhi7p 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39n28j9gpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 04:59:36 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1678Y0nn052129;
        Wed, 7 Jul 2021 04:59:36 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39n28j9gp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 04:59:35 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1678v9SF006523;
        Wed, 7 Jul 2021 08:59:33 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 39jfh8gvr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 08:59:33 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1678xUY326345802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 08:59:30 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AA7BAE06A;
        Wed,  7 Jul 2021 08:59:30 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5F14AE075;
        Wed,  7 Jul 2021 08:59:29 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.89.68])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 08:59:29 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: Enable specification exception interpretation
To:     Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "open list:KERNEL VIRTUAL MACHINE for s390 (KVM/s390)" 
        <kvm@vger.kernel.org>,
        "open list:S390" <linux-s390@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210706114714.3936825-1-scgl@linux.ibm.com>
 <05430c91-6a84-0fc9-0af4-89f408eb691f@de.ibm.com>
 <c61223e4-0076-18c1-64bd-8ba899e91eb4@linux.vnet.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <a2e3484a-34af-0bab-2fb3-b22a69361807@de.ibm.com>
Date:   Wed, 7 Jul 2021 10:59:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <c61223e4-0076-18c1-64bd-8ba899e91eb4@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XiT2ViL0tcCvvtdlW1Ov_7g-1PF_Ks8G
X-Proofpoint-ORIG-GUID: cktgOo6vzzu3BV6wCwqJK--5ejhcKKLc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_05:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 phishscore=0 malwarescore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107070050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07.07.21 10:56, Janis Schoetterl-Glausch wrote:
> On 7/7/21 10:30 AM, Christian Borntraeger wrote:
>>
>>
>> On 06.07.21 13:47, Janis Schoetterl-Glausch wrote:
>>> When this feature is enabled the hardware is free to interpret
>>> specification exceptions generated by the guest, instead of causing
>>> program interruption interceptions.
>>>
>>> This benefits (test) programs that generate a lot of specification
>>> exceptions (roughly 4x increase in exceptions/sec).
>>>
>>> Interceptions will occur as before if ICTL_PINT is set,
>>> i.e. if guest debug is enabled.
>>
>> I think I will add
>>
>> There is no indication if this feature is available or not and the hardware
>> is free to interpret or not. So we can simply set this bit and if the
>> hardware ignores it we fall back to intercept 8 handling.
> 
> Might also mention vSIE and/or incorporate into first paragraph:
> 
> When this feature is enabled the hardware is free to interpret
> specification exceptions generated by the guest, instead of causing
> program interruption interceptions, but it is not required to.
> There is no indication if this feature is available or not,
> so we can simply set this bit and if the hardware ignores it
> we fall back to intercept 8 handling.
> The same applies to vSIE, we forward the guest hypervisor's bit
> and fall back to injection if interpretation does not occur.

Can you maybe resend a v2 with all comments (and RBs) added?
