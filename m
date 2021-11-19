Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F294456CEF
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 11:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbhKSKFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 05:05:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229998AbhKSKFJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 05:05:09 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ8mWk0011397;
        Fri, 19 Nov 2021 10:02:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=1hKyy2Yrr24uEibF249Tb3c4EDv0PQXesXqoZiSNI6Q=;
 b=UMdqHz3MaCYxQXtp0cGUs45PpKm8C2NihTgeR06CSC5DUZPot5f8gDCHs3AJEfu3/E92
 4vArEeuorC84DSoX7Udb9Pma9XBmbbRvsW4s1kdmhyxb8SsQ1eAe7+iLiMMyhV6EcknX
 h2exa5uDiCTLwW6BcmNB1MubZMR99wPpJoC5x+LHXv0nGQAHcRK6Dv9z13MhUZ2ZI5eN
 QZkJVnS0didUrfEqA/XflW2bZwvrfErUJ0mlKH0CX4TL6Jj5ovdGRlu1ej9tt5/drwRC
 6Tub0yneCyJWzrTqjfaiHfhkiNtiVmJ8gqE2e/EROdyfxwbAgOvSphUy+b2/S6EhRI5r lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ce8r79c87-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 10:02:07 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AJ9xIVH016683;
        Fri, 19 Nov 2021 10:02:07 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ce8r79c7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 10:02:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AJ9w1vE017634;
        Fri, 19 Nov 2021 10:02:04 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3ca50by5f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 10:02:04 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AJA20hc57672124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 10:02:00 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7614A11C06E;
        Fri, 19 Nov 2021 10:02:00 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECE8F11C05E;
        Fri, 19 Nov 2021 10:01:59 +0000 (GMT)
Received: from [9.171.28.84] (unknown [9.171.28.84])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Nov 2021 10:01:59 +0000 (GMT)
Message-ID: <075d5505-33aa-3354-4ac0-4545dd51fc56@linux.vnet.ibm.com>
Date:   Fri, 19 Nov 2021 11:01:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] KVM: s390: gaccess: Refactor access address range
 check
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211028135556.1793063-1-scgl@linux.ibm.com>
 <20211028135556.1793063-3-scgl@linux.ibm.com>
 <c0f5143c-24cd-e40b-f797-23d67a22c2c6@linux.ibm.com>
From:   Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
In-Reply-To: <c0f5143c-24cd-e40b-f797-23d67a22c2c6@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RTLQWwny_rctfj-L-OfQc9KPtPH8IAME
X-Proofpoint-ORIG-GUID: FFUhqAh1NZxsRXJEi0sqIofuFlEPmBEB
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_08,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111190056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/19/21 09:56, Janosch Frank wrote:
> On 10/28/21 15:55, Janis Schoetterl-Glausch wrote:
>> Do not round down the first address to the page boundary, just translate
>> it normally, which gives the value we care about in the first place.
>> Given this, translating a single address is just the special case of
>> translating a range spanning a single page.
>>
>> Make the output optional, so the function can be used to just check a
>> range.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> 
>> ---
>>   arch/s390/kvm/gaccess.c | 122 +++++++++++++++++++++++-----------------
>>   1 file changed, 69 insertions(+), 53 deletions(-)
>>
>> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
>> index 0d11cea92603..7725dd7566ed 100644
>> --- a/arch/s390/kvm/gaccess.c
>> +++ b/arch/s390/kvm/gaccess.c
>> @@ -794,35 +794,74 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
>>       return 1;
>>   }
>>   -static int guest_page_range(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>> -                unsigned long *pages, unsigned long nr_pages,
>> -                const union asce asce, enum gacc_mode mode)
>> +/**
>> + * guest_range_to_gpas() - Calculate guest physical addresses of page fragments
>> + * covering a logical range
> 
> I'd add an empty line here.

The guide says not to.
https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html :

> Function parameters
> 
> Each function argument should be described in order,immediately following the short function description. Do not leave a blank line between the function description and the arguments, nor between the arguments.

In this case it's a static function, so not a must,
but I'll stick to it anyway.

> Apart from that this is a very nice cleanup.
>>> + * @vcpu: virtual cpu
>> + * @ga: guest address, start of range
>> + * @ar: access register
>> + * @gpas: output argument, may be NULL
>> + * @len: length of range in bytes
>> + * @asce: address-space-control element to use for translation
>> + * @mode: access mode

