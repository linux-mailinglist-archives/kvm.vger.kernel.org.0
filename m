Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA3F4C306C
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 16:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbiBXPz4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 10:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbiBXPzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 10:55:51 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AAC16DADC;
        Thu, 24 Feb 2022 07:55:21 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OFF1H3032369;
        Thu, 24 Feb 2022 15:55:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=y0przJE9EY3HDW35HmWsyMp5Dy3WSKZbr5ASQQsAmkY=;
 b=VXle0t3UmoHv9XaocgVlxuQ320OX/FZTTbU1mrYDwIjc1A7MMVb98u1J+fSVbW2py3tf
 7BvUZllZ2QRP+0Q3NXSOPvVKFJA7E3Bf6302mlbY1HNmhqKNXpn2T37GzJFTR9aIxN3o
 o8W68oUuPDUNtnXJFpk5ca/yQWLOslb3uSqgLnItkok90KE1Fe/oANvem+oljPKUCF5E
 /LpsBneB16kCmJv3SRf16LcDRn7lAxqO9vijVOA+vtDEREQ8cbEUNZ7LHGpbHNSc0xZv
 vq+TxlYOgwP3EGbQfNZRnRVEhcaLwUMd2M8zhIQyMryTlXZaxs/ieADk76OYUzykPYvU og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edwxu2y6d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:55:20 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21OFfC9t000891;
        Thu, 24 Feb 2022 15:55:20 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3edwxu2y5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:55:20 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21OFl5cK032412;
        Thu, 24 Feb 2022 15:55:18 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3ear69gvd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 15:55:18 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21OFtFbS52560358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 15:55:15 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 391D74C058;
        Thu, 24 Feb 2022 15:55:15 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC3DD4C046;
        Thu, 24 Feb 2022 15:55:14 +0000 (GMT)
Received: from [9.171.74.148] (unknown [9.171.74.148])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Feb 2022 15:55:14 +0000 (GMT)
Message-ID: <0616bdcb-a17a-6628-a069-f40706f9f40c@linux.ibm.com>
Date:   Thu, 24 Feb 2022 16:55:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [kvm-unit-tests PATCH] s390x: Test effect of storage keys on some
 instructions
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20220224110950.3401748-1-scgl@linux.ibm.com>
 <20220224153041.5e99c0b3@p-imbrenda>
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
In-Reply-To: <20220224153041.5e99c0b3@p-imbrenda>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7MtADrn2bR8X2yR5tmzxnNfa9WHNWmsD
X-Proofpoint-GUID: 16JAvGNVOSyYCNWY_RMcFtUKXtIObakv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_03,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/24/22 15:30, Claudio Imbrenda wrote:
> On Thu, 24 Feb 2022 12:09:50 +0100
> Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:
> 
>> Some instructions are emulated by KVM. Test that KVM correctly emulates
>> storage key checking for two of those instructions (STORE CPU ADDRESS,
>> SET PREFIX).
>> Test success and error conditions, including coverage of storage and
>> fetch protection override.
>> Also add test for TEST PROTECTION, even if that instruction will not be
>> emulated by KVM under normal conditions.
>>
>> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
>> ---
>>
>>  	*entry_0_p = entry_pagebuf;
>>
>> I'm wondering if we need a barrier here, or would if set_prefix_key_1
>> wasn't made up of an asm volatile. But the mmu code seems to not have a
>> barrier in the equivalent code, so maybe it's never needed.
>>
>>  	set_prefix_key_1(0);
>>
>>  lib/s390x/asm/arch_def.h |  20 ++---
>>  s390x/skey.c             | 169 +++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 180 insertions(+), 9 deletions(-)
>>

[...]

>> diff --git a/s390x/skey.c b/s390x/skey.c
>> index 58a55436..6ae2d026 100644
>> --- a/s390x/skey.c
>> +++ b/s390x/skey.c
>> @@ -10,7 +10,10 @@
>>  #include <libcflat.h>
>>  #include <asm/asm-offsets.h>
>>  #include <asm/interrupt.h>
>> +#include <vmalloc.h>
>> +#include <mmu.h>
>>  #include <asm/page.h>
>> +#include <asm/pgtable.h>
>>  #include <asm/facility.h>
>>  #include <asm/mem.h>
>>  
>> @@ -147,6 +150,167 @@ static void test_invalid_address(void)
>>  	report_prefix_pop();
>>  }
>>  
>> +static void test_test_protection(void)
>> +{
>> +	unsigned long addr = (unsigned long)pagebuf;
>> +
>> +	report_prefix_push("TPROT");
>> +	set_storage_key(pagebuf, 0x10, 0);
>> +	report(tprot(addr, 0) == 0, "access key 0 -> no protection");
>> +	report(tprot(addr, 1) == 0, "access key matches -> no protection");
>> +	report(tprot(addr, 2) == 1, "access key mismatches, no fetch protection -> store protection");
>> +	set_storage_key(pagebuf, 0x18, 0);
>> +	report(tprot(addr, 2) == 2, "access key mismatches, fetch protection -> fetch & store protection");
>> +	report_prefix_pop();
> 
> is there a reason why you don't set the storage key back to 0 once
> you're done?

None, other than it not being necessary, but I like the idea.
> 
>> +}
>> +
>> +static void store_cpu_address_key_1(uint16_t *out)
>> +{
>> +	asm volatile (
>> +		"spka 0x10(0)\n\t"
>> +		"stap %0\n\t"
>> +		"spka 0(0)\n"
>> +	     : "=Q" (*out)
>> +	);
>> +}
>> +
>> +static void test_store_cpu_address(void)
>> +{
>> +	uint16_t *out = (uint16_t *)pagebuf;
>> +	uint16_t cpu_addr;
>> +
>> +	asm ("stap %0" : "=Q" (cpu_addr));
>> +
>> +	report_prefix_push("STORE CPU ADDRESS, zero key");
>> +	set_storage_key(pagebuf, 0x20, 0);
>> +	*out = 0xbeef;
>> +	asm ("stap %0" : "=Q" (*out));
>> +	report(*out == cpu_addr, "store occurred");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("STORE CPU ADDRESS, matching key");
>> +	set_storage_key(pagebuf, 0x10, 0);
>> +	*out = 0xbeef;
>> +	store_cpu_address_key_1(out);
>> +	report(*out == cpu_addr, "store occurred");
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("STORE CPU ADDRESS, mismatching key");
>> +	set_storage_key(pagebuf, 0x20, 0);
>> +	expect_pgm_int();
>> +	store_cpu_address_key_1(out);
>> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> 
> for completeness, maybe also check that nothing gets stored?

Can do.
> 
>> +	report_prefix_pop();
>> +
>> +	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
>> +
>> +	report_prefix_push("STORE CPU ADDRESS, storage-protection override, invalid key");
>> +	set_storage_key(pagebuf, 0x20, 0);
>> +	expect_pgm_int();
>> +	store_cpu_address_key_1(out);
>> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> 
> same here
> 

[...]

