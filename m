Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 098F571F7C
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 20:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387473AbfGWSmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 14:42:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731007AbfGWSmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 14:42:40 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 95A363179150;
        Tue, 23 Jul 2019 18:42:39 +0000 (UTC)
Received: from [10.36.116.47] (ovpn-116-47.ams2.redhat.com [10.36.116.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79F2C5B685;
        Tue, 23 Jul 2019 18:42:38 +0000 (UTC)
Subject: Re: [1/1] kvm-unit-tests: s390: test for gen15a/b cpu model
 dependencies
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
References: <20190723115419.153590-1-borntraeger@de.ibm.com>
 <20190723115419.153590-2-borntraeger@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <26eb2715-c215-105c-d610-477b778623c1@redhat.com>
Date:   Tue, 23 Jul 2019 20:42:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190723115419.153590-2-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 23 Jul 2019 18:42:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23.07.19 13:54, Christian Borntraeger wrote:
> This adds a test for the cpu model gen15a/b. The test check for
> dependencies and proper subfunctions.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/gen15.c       | 191 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   4 +
>  3 files changed, 196 insertions(+)
>  create mode 100644 s390x/gen15.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 1f21ddb9c943..bc7217e0357a 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -11,6 +11,7 @@ tests += $(TEST_DIR)/cmm.elf
>  tests += $(TEST_DIR)/vector.elf
>  tests += $(TEST_DIR)/gs.elf
>  tests += $(TEST_DIR)/iep.elf
> +tests += $(TEST_DIR)/gen15.elf
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  
>  all: directories test_cases test_cases_binary
> diff --git a/s390x/gen15.c b/s390x/gen15.c
> new file mode 100644
> index 000000000000..c0bfe3ddb5fd
> --- /dev/null
> +++ b/s390x/gen15.c
> @@ -0,0 +1,191 @@
> +/*
> + * Test the facilities and subfunctions of the new gen15 cpu model
> + * Unless fully implemented this will only work with kvm as we check
> + * for all subfunctions
> + *
> + * Copyright 2019 IBM Corp.
> + *
> + * Authors:
> + *    Christian Borntraeger <borntraeger@de.ibm.com>
> + *
> + * This code is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU Library General Public License version 2.
> + */
> +
> +#include <asm/facility.h>
> +
> +static void test_minste3(void)
> +{
> +
> +	report_prefix_push("minste");
> +
> +	/* Dependency */
> +	report("facility 45 available", test_facility(45));
> +
> +	report_prefix_pop();
> +}
> +
> +static void test_vxeh2(void)
> +{
> +
> +	report_prefix_push("vxeh2");
> +
> +	/* Dependencies */
> +	report("facility 129 available", test_facility(129));
> +	report("facility 135 available", test_facility(135));
> +
> +	report_prefix_pop();
> +}
> +
> +static void query_opcode(unsigned int opcode, unsigned long query[4])
> +{
> +        register unsigned long r0 asm("0") = 0; /* query function */
> +        register unsigned long r1 asm("1") = (unsigned long) query;
> +
> +        asm volatile(
> +                /* Parameter regs are ignored */
> +                "       .insn   rrf,%[opc] << 16,2,4,6,0\n"
> +                : "=m" (*query)
> +                : "d" (r0), "a" (r1), [opc] "i" (opcode)
> +                : "cc");
> +}
> +
> +static void query_cpuid(struct cpuid *id)
> +{
> +	asm volatile ("stidp %0\n" : "+Q"(*id));
> +}
> +
> +/* Big Endian BIT macro that uses the bit value within a 64bit value */
> +#define BIT(a) (1UL << (63-(a % 64)))
> +#define DEFLTCC_GEN15 (BIT(0)  | BIT(1)  | BIT(2)  | BIT(4))
> +#define DEFLTCC_GEN15_F (BIT(0))
> +static void test_deflate(void)
> +{
> +	unsigned long query[4];
> +	struct cpuid id = {};
> +
> +	report_prefix_push("deflate");
> +
> +	query_opcode(0xb939, query);
> +	query_cpuid(&id);
> +
> +	/* check for the correct bits depending on cpu */
> +	switch(id.type) {
> +	case 0x8561:
> +	case 0x8562:
> +		report ("only functions 0,1,2,4", query[0] == DEFLTCC_GEN15 &&
> +						  query[1] == 0);
> +		report ("reserved == 0", query[2] == 0);
> +		report ("only format0", query[3] == DEFLTCC_GEN15_F);
> +		break;
> +	default:
> +		report_skip("Unknown CPU type");
> +		break;
> +	}
> +
> +	report_prefix_pop();
> +}
> +
> +static void test_vxpdeh(void)
> +{
> +	report_prefix_push("vxpdeh");
> +
> +	/* Dependencies */
> +	report("facility 129 available", test_facility(129));
> +	report("facility 134 available", test_facility(134));
> +
> +	report_prefix_pop();
> +}
> +
> +
> +#define KDSA_GEN15 (BIT(0)  | BIT(1)  | BIT(2)  | BIT(3)  | BIT(9)  | \
> +		    BIT(10) | BIT(11) | BIT(17) | BIT(18) | BIT(19) | \
> +		    BIT(32) | BIT(36) | BIT(40) | BIT(44) | BIT(48) | \
> +		    BIT(52))
> +#define PCC_GEN15_0 (BIT(0)  | BIT(1)  | BIT(2)  | BIT(3)  | BIT(9)  | \
> +		    BIT(10) | BIT(11) | BIT(18) | BIT(19) | BIT(20) | \
> +		    BIT(26) | BIT(27) | BIT(28) | BIT(50) | BIT(52) | \
> +		    BIT(58) | BIT(60))
> +#define PCC_GEN15_1 (BIT(64) | BIT(65) | BIT(66) | BIT(72) | \
> +		    BIT(73) | BIT(80) | BIT(81))
> +
> +static void test_msa9(void)
> +{
> +	unsigned long query_kdsa[4];
> +	unsigned long query_pcc[4];
> +	struct cpuid id = {};
> +
> +	report_prefix_push("msa9");
> +
> +	/* Dependencies */
> +	report("facility 76 available", test_facility(76));
> +	report("facility 77 available", test_facility(77));
> +
> +	query_opcode(0xb92c, query_pcc);
> +	query_opcode(0xb93a, query_kdsa);
> +	query_cpuid(&id);
> +	/* check for the correct bits depending on cpu */
> +	switch(id.type) {
> +	case 0x8561:
> +	case 0x8562:
> +		report ("kdsa functions 0,1,2,3,9,10,11,17,18,19,32,36,40,44,48",
> +			query_kdsa[0] == KDSA_GEN15 &&  query_kdsa[1] == 0);
> +		report ("pcc functions 0,1,2,3,9,10,11,18,19,20,26,27,28,50,52,58,60",
> +			query_pcc[0] == PCC_GEN15_0);
> +		report ("pcc functions 64,65,66,72,73,80,81",
> +			query_pcc[1] == PCC_GEN15_1);
> +		break;
> +	default:
> +		report_skip("Unknown CPU type");
> +		break;
> +	}
> +
> +	report_prefix_pop();
> +}
> +
> +static void test_etoken(void)
> +{
> +	report_prefix_push("etoken");
> +	/* Dependencies */
> +	report("facility 49 or 81 available",
> +		test_facility(49) || test_facility(81));
> +}
> +
> +int main(void)
> +{
> +	report_prefix_push("gen15 cpu model");
> +
> +	if (test_facility(61)) {
> +		test_minste3();
> +	} else {
> +		report_skip("Miscellaneous-Instruction-Extensions Facility 3 is not available");
> +	}
> +	if (test_facility(148)) {
> +		test_vxeh2();
> +	} else {
> +		report_skip("Vector Enhancements facility 2 not available");
> +	}
> +	if (test_facility(151)) {
> +		test_deflate();
> +	} else {
> +		report_skip("Deflate-Conversion-Facility not available");
> +	}
> +	if (test_facility(152)) {
> +		test_vxpdeh();
> +	} else {
> +		report_skip("Vector-Packed-Decimal-Enhancement Facility");
> +	}
> +	if (test_facility(155)) {
> +		test_msa9();
> +	} else {
> +		report_skip("Message-Security-Assist-Extenstion-9-Facility 1 not available");
> +	}
> +	if (test_facility(156)) {
> +		test_etoken();
> +	} else {
> +		report_skip("Etoken-Facility not available");
> +	}
> +
> +	report_prefix_pop();
> +	return report_summary();
> +}
> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index 546b1f281f8f..d12797036930 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -61,3 +61,7 @@ file = gs.elf
>  
>  [iep]
>  file = iep.elf
> +
> +[gen15]
> +file = gen15.elf
> +accel = kvm
> 

Two things:

1. Checking CPU model *consistency* (dependencies) makes sense. We
should move that to a test like "cpu_model.elf". We can add consistency
checks for other facilities.

2. IMHO, assuming that a certain CPU id *has to have* a certain set of
subfunctions is wrong - that's why we can query subfunctions after all.
I can understand the intuition behind that, but in this form I don't
think this is upstream material.

-- 

Thanks,

David / dhildenb
