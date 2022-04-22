Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2F350B6A3
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 13:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447216AbiDVL7a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 07:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447214AbiDVL72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 07:59:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBF53ED01;
        Fri, 22 Apr 2022 04:56:34 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23MAhWSo004886;
        Fri, 22 Apr 2022 11:56:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=RT6oPqeQSd4c9iCOsvA7HDET4GrJHZ0J6tmMwXBm//A=;
 b=EB/xd3uxtueGfWZgh6oujSDfTrIfUIzKG5SttHVf/XqUnQfEosNmGSoLe78RJMCcFuRq
 TEwzOEOHpmjjyk5zbTvsR3bA9u0UaHRf3eJdRs4UazAG0odRrrCcb3PD6dIKBK/28bwJ
 UTU0KFq/Dw/BTvUw+yIWUIWg9k5LRoOHdNjXs1ZvZ110IzVQKevvxWMdc4VC3xyPo7On
 J8AA7p3iL4rMFFusC+Z2HETEcSJi3V1gRb2hIrAoiX9nsm3YJiofTVZO1OYzx5nTrIqp
 3Qs8blBhGwEiM8E4SpIEIEVFrfBhf1FGjf9O15cyZtmZP5OjBjVM3Ub2XthN4lWc1TVx GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjer9eh14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 11:56:33 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23MAbLnA017913;
        Fri, 22 Apr 2022 11:56:33 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fjer9eh0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 11:56:33 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23MBqjju019208;
        Fri, 22 Apr 2022 11:56:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3ffn2j1b0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Apr 2022 11:56:31 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23MBuSpQ54526230
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Apr 2022 11:56:28 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 26E32AE051;
        Fri, 22 Apr 2022 11:56:28 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0130AE045;
        Fri, 22 Apr 2022 11:56:27 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.176])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Apr 2022 11:56:27 +0000 (GMT)
Date:   Fri, 22 Apr 2022 13:56:25 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3] s390x: Test effect of storage keys on
 some instructions
Message-ID: <20220422135625.6e46e2e7@p-imbrenda>
In-Reply-To: <20220421090421.2425142-1-scgl@linux.ibm.com>
References: <20220421090421.2425142-1-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lO9Hr1KNr2nEXMGcsgQNCjdxxpXiOuc9
X-Proofpoint-ORIG-GUID: oquEkSwcZow0699e5QNvDkolxlhrkb6P
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-22_02,2022-04-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 priorityscore=1501 phishscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204220049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Apr 2022 11:04:21 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Some instructions are emulated by KVM. Test that KVM correctly emulates
> storage key checking for two of those instructions (STORE CPU ADDRESS,
> SET PREFIX).
> Test success and error conditions, including coverage of storage and
> fetch protection override.
> Also add test for TEST PROTECTION, even if that instruction will not be
> emulated by KVM under normal conditions.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> ---
> v2 -> v3:
>  * fix asm for SET PREFIX zero key test: make input
>  * implement Thomas' suggestions:
>    https://lore.kernel.org/kvm/f050da01-4d50-5da5-7f08-6da30f5dbbbe@redhat.com/
> 
> v1 -> v2:
>  * use install_page instead of manual page table entry manipulation
>  * check that no store occurred if none is expected
>  * try to check that no fetch occured if not expected, although in
>    practice a fetch would probably cause the test to crash
>  * reset storage key to 0 after test
> 
> Range-diff against v2:
> 1:  a2e076d3 ! 1:  dc4ae46f s390x: Test effect of storage keys on some instructions
>     @@ s390x/skey.c: static void test_invalid_address(void)
>      +	unsigned long addr = (unsigned long)pagebuf;
>      +
>      +	report_prefix_push("TPROT");
>     ++
>      +	set_storage_key(pagebuf, 0x10, 0);
>      +	report(tprot(addr, 0) == 0, "access key 0 -> no protection");
>      +	report(tprot(addr, 1) == 0, "access key matches -> no protection");
>      +	report(tprot(addr, 2) == 1, "access key mismatches, no fetch protection -> store protection");
>     ++
>      +	set_storage_key(pagebuf, 0x18, 0);
>      +	report(tprot(addr, 2) == 2, "access key mismatches, fetch protection -> fetch & store protection");
>     ++
>     ++	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
>     ++	set_storage_key(pagebuf, 0x90, 0);
>     ++	report(tprot(addr, 2) == 0, "access key mismatches, storage protection override -> no protection");
>     ++	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
>     ++
>     ++	set_storage_key(pagebuf, 0x00, 0);
>      +	report_prefix_pop();
>      +}
>      +
>     ++/*
>     ++ * Perform STORE CPU ADDRESS (STAP) instruction while temporarily executing
>     ++ * with access key 1.
>     ++ */
>      +static void store_cpu_address_key_1(uint16_t *out)
>      +{
>      +	asm volatile (
>      +		"spka 0x10(0)\n\t"
>      +		"stap %0\n\t"
>      +		"spka 0(0)\n"
>     -+	     : "+Q" (*out) /* exception: old value remains in out -> + constraint*/
>     ++	     : "+Q" (*out) /* exception: old value remains in out -> + constraint */
>      +	);
>      +}
>      +
>     @@ s390x/skey.c: static void test_invalid_address(void)
>      +	uint16_t *out = (uint16_t *)pagebuf;
>      +	uint16_t cpu_addr;
>      +
>     ++	report_prefix_push("STORE CPU ADDRESS");
>      +	asm ("stap %0" : "=Q" (cpu_addr));
>      +
>     -+	report_prefix_push("STORE CPU ADDRESS, zero key");
>     ++	report_prefix_push("zero key");
>      +	set_storage_key(pagebuf, 0x20, 0);
>     -+	*out = 0xbeef;
>     ++	WRITE_ONCE(*out, 0xbeef);
>      +	asm ("stap %0" : "=Q" (*out));
>      +	report(*out == cpu_addr, "store occurred");
>      +	report_prefix_pop();
>      +
>     -+	report_prefix_push("STORE CPU ADDRESS, matching key");
>     ++	report_prefix_push("matching key");
>      +	set_storage_key(pagebuf, 0x10, 0);
>      +	*out = 0xbeef;
>      +	store_cpu_address_key_1(out);
>      +	report(*out == cpu_addr, "store occurred");
>      +	report_prefix_pop();
>      +
>     -+	report_prefix_push("STORE CPU ADDRESS, mismatching key");
>     ++	report_prefix_push("mismatching key");
>      +	set_storage_key(pagebuf, 0x20, 0);
>      +	expect_pgm_int();
>      +	*out = 0xbeef;
>     @@ s390x/skey.c: static void test_invalid_address(void)
>      +
>      +	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
>      +
>     -+	report_prefix_push("STORE CPU ADDRESS, storage-protection override, invalid key");
>     ++	report_prefix_push("storage-protection override, invalid key");
>      +	set_storage_key(pagebuf, 0x20, 0);
>      +	expect_pgm_int();
>      +	*out = 0xbeef;
>     @@ s390x/skey.c: static void test_invalid_address(void)
>      +	report(*out == 0xbeef, "no store occurred");
>      +	report_prefix_pop();
>      +
>     -+	report_prefix_push("STORE CPU ADDRESS, storage-protection override, override key");
>     ++	report_prefix_push("storage-protection override, override key");
>      +	set_storage_key(pagebuf, 0x90, 0);
>      +	*out = 0xbeef;
>      +	store_cpu_address_key_1(out);
>     @@ s390x/skey.c: static void test_invalid_address(void)
>      +	report_prefix_pop();
>      +
>      +	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
>     ++
>     ++	report_prefix_push("storage-protection override disabled, override key");
>     ++	set_storage_key(pagebuf, 0x90, 0);
>     ++	expect_pgm_int();
>     ++	*out = 0xbeef;
>     ++	store_cpu_address_key_1(out);
>     ++	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>     ++	report(*out == 0xbeef, "no store occurred");
>     ++	report_prefix_pop();
>     ++
>      +	set_storage_key(pagebuf, 0x00, 0);
>     ++	report_prefix_pop();
>      +}
>      +
>     ++/*
>     ++ * Perform SET PREFIX (SPX) instruction while temporarily executing
>     ++ * with access key 1.
>     ++ */
>      +static void set_prefix_key_1(uint32_t *out)
>      +{
>      +	asm volatile (
>     @@ s390x/skey.c: static void test_invalid_address(void)
>      +
>      +/*
>      + * We remapped page 0, making the lowcore inaccessible, which breaks the normal
>     -+ * hanlder and breaks skipping the faulting instruction.
>     ++ * handler and breaks skipping the faulting instruction.
>      + * Just disable dynamic address translation to make things work.
>      + */
>      +static void dat_fixup_pgm_int(void)
>     @@ s390x/skey.c: static void test_invalid_address(void)
>      +	uint32_t *out = (uint32_t *)pagebuf;
>      +	pgd_t *root;
>      +
>     ++	report_prefix_push("SET PREFIX");
>      +	root = (pgd_t *)(stctg(1) & PAGE_MASK);
>      +
>      +	asm volatile("stpx	%0" : "=Q"(*out));
>      +
>     -+	report_prefix_push("SET PREFIX, zero key");
>     ++	report_prefix_push("zero key");
>      +	set_storage_key(pagebuf, 0x20, 0);
>     -+	asm volatile("spx	%0" : "=Q" (*out));
>     ++	asm volatile("spx	%0" :: "Q" (*out));
>      +	report_pass("no exception");
>      +	report_prefix_pop();
>      +
>     -+	report_prefix_push("SET PREFIX, matching key");
>     ++	report_prefix_push("matching key");
>      +	set_storage_key(pagebuf, 0x10, 0);
>      +	set_prefix_key_1(out);
>      +	report_pass("no exception");
>      +	report_prefix_pop();
>      +
>     -+	report_prefix_push("SET PREFIX, mismatching key, no fetch protection");
>     ++	report_prefix_push("mismatching key, no fetch protection");
>      +	set_storage_key(pagebuf, 0x20, 0);
>      +	set_prefix_key_1(out);
>      +	report_pass("no exception");
>      +	report_prefix_pop();
>      +
>     -+	report_prefix_push("SET PREFIX, mismatching key, fetch protection");
>     ++	report_prefix_push("mismatching key, fetch protection");
>      +	set_storage_key(pagebuf, 0x28, 0);
>      +	expect_pgm_int();
>      +	*out = 0xdeadbeef;
>     @@ s390x/skey.c: static void test_invalid_address(void)
>      +	report_prefix_pop();
>      +
>      +	register_pgm_cleanup_func(dat_fixup_pgm_int);
>     ++
>     ++	report_prefix_push("mismatching key, remapped page, fetch protection");
>     ++	set_storage_key(pagebuf, 0x28, 0);
>     ++	expect_pgm_int();
>     ++	WRITE_ONCE(*out, 0xdeadbeef);
>     ++	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>     ++	set_prefix_key_1((uint32_t *)0);
>     ++	install_page(root, 0, 0);
>     ++	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>     ++	asm volatile("stpx	%0" : "=Q"(*out));
>     ++	report(*out != 0xdeadbeef, "no fetch occurred");
>     ++	report_prefix_pop();
>     ++
>      +	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
>      +
>     -+	report_prefix_push("SET PREFIX, mismatching key, fetch protection override applies");
>     ++	report_prefix_push("mismatching key, fetch protection override applies");
>      +	set_storage_key(pagebuf, 0x28, 0);
>      +	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>     -+	set_prefix_key_1(0);
>     ++	set_prefix_key_1((uint32_t *)0);
>      +	install_page(root, 0, 0);
>      +	report_pass("no exception");
>      +	report_prefix_pop();
>      +
>     -+	report_prefix_push("SET PREFIX, mismatching key, fetch protection override does not apply");
>     ++	report_prefix_push("mismatching key, fetch protection override does not apply");
>      +	out = (uint32_t *)(pagebuf + 2048);
>      +	set_storage_key(pagebuf, 0x28, 0);
>      +	expect_pgm_int();
>     -+	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>      +	WRITE_ONCE(*out, 0xdeadbeef);
>     ++	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
>      +	set_prefix_key_1((uint32_t *)2048);
>      +	install_page(root, 0, 0);
>      +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
>     @@ s390x/skey.c: static void test_invalid_address(void)
>      +	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
>      +	set_storage_key(pagebuf, 0x00, 0);
>      +	register_pgm_cleanup_func(NULL);
>     ++	report_prefix_pop();
>      +}
>      +
>       int main(void)
> 
>  lib/s390x/asm/arch_def.h |  20 ++--
>  s390x/skey.c             | 215 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 226 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index bab3c374..676a2753 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -55,15 +55,17 @@ struct psw {
>  #define PSW_MASK_BA			0x0000000080000000UL
>  #define PSW_MASK_64			(PSW_MASK_BA | PSW_MASK_EA)
>  
> -#define CTL0_LOW_ADDR_PROT		(63 - 35)
> -#define CTL0_EDAT			(63 - 40)
> -#define CTL0_IEP			(63 - 43)
> -#define CTL0_AFP			(63 - 45)
> -#define CTL0_VECTOR			(63 - 46)
> -#define CTL0_EMERGENCY_SIGNAL		(63 - 49)
> -#define CTL0_EXTERNAL_CALL		(63 - 50)
> -#define CTL0_CLOCK_COMPARATOR		(63 - 52)
> -#define CTL0_SERVICE_SIGNAL		(63 - 54)
> +#define CTL0_LOW_ADDR_PROT			(63 - 35)
> +#define CTL0_EDAT				(63 - 40)
> +#define CTL0_FETCH_PROTECTION_OVERRIDE		(63 - 38)
> +#define CTL0_STORAGE_PROTECTION_OVERRIDE	(63 - 39)
> +#define CTL0_IEP				(63 - 43)
> +#define CTL0_AFP				(63 - 45)
> +#define CTL0_VECTOR				(63 - 46)
> +#define CTL0_EMERGENCY_SIGNAL			(63 - 49)
> +#define CTL0_EXTERNAL_CALL			(63 - 50)
> +#define CTL0_CLOCK_COMPARATOR			(63 - 52)
> +#define CTL0_SERVICE_SIGNAL			(63 - 54)
>  #define CR0_EXTM_MASK			0x0000000000006200UL /* Combined external masks */
>  
>  #define CTL2_GUARDED_STORAGE		(63 - 59)
> diff --git a/s390x/skey.c b/s390x/skey.c
> index edad53e9..849d105f 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -10,6 +10,7 @@
>  #include <libcflat.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
> +#include <vmalloc.h>
>  #include <asm/page.h>
>  #include <asm/facility.h>
>  #include <asm/mem.h>
> @@ -118,6 +119,215 @@ static void test_invalid_address(void)
>  	report_prefix_pop();
>  }
>  
> +static void test_test_protection(void)
> +{
> +	unsigned long addr = (unsigned long)pagebuf;
> +
> +	report_prefix_push("TPROT");
> +
> +	set_storage_key(pagebuf, 0x10, 0);
> +	report(tprot(addr, 0) == 0, "access key 0 -> no protection");
> +	report(tprot(addr, 1) == 0, "access key matches -> no protection");
> +	report(tprot(addr, 2) == 1, "access key mismatches, no fetch protection -> store protection");
> +
> +	set_storage_key(pagebuf, 0x18, 0);
> +	report(tprot(addr, 2) == 2, "access key mismatches, fetch protection -> fetch & store protection");
> +
> +	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
> +	set_storage_key(pagebuf, 0x90, 0);
> +	report(tprot(addr, 2) == 0, "access key mismatches, storage protection override -> no protection");
> +	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
> +
> +	set_storage_key(pagebuf, 0x00, 0);
> +	report_prefix_pop();
> +}
> +
> +/*
> + * Perform STORE CPU ADDRESS (STAP) instruction while temporarily executing
> + * with access key 1.
> + */
> +static void store_cpu_address_key_1(uint16_t *out)
> +{
> +	asm volatile (
> +		"spka 0x10(0)\n\t"
> +		"stap %0\n\t"
> +		"spka 0(0)\n"
> +	     : "+Q" (*out) /* exception: old value remains in out -> + constraint */
> +	);
> +}
> +
> +static void test_store_cpu_address(void)
> +{
> +	uint16_t *out = (uint16_t *)pagebuf;
> +	uint16_t cpu_addr;
> +
> +	report_prefix_push("STORE CPU ADDRESS");
> +	asm ("stap %0" : "=Q" (cpu_addr));
> +
> +	report_prefix_push("zero key");
> +	set_storage_key(pagebuf, 0x20, 0);
> +	WRITE_ONCE(*out, 0xbeef);
> +	asm ("stap %0" : "=Q" (*out));
> +	report(*out == cpu_addr, "store occurred");
> +	report_prefix_pop();
> +
> +	report_prefix_push("matching key");
> +	set_storage_key(pagebuf, 0x10, 0);
> +	*out = 0xbeef;
> +	store_cpu_address_key_1(out);
> +	report(*out == cpu_addr, "store occurred");
> +	report_prefix_pop();
> +
> +	report_prefix_push("mismatching key");
> +	set_storage_key(pagebuf, 0x20, 0);
> +	expect_pgm_int();
> +	*out = 0xbeef;
> +	store_cpu_address_key_1(out);
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	report(*out == 0xbeef, "no store occurred");
> +	report_prefix_pop();
> +
> +	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
> +
> +	report_prefix_push("storage-protection override, invalid key");
> +	set_storage_key(pagebuf, 0x20, 0);
> +	expect_pgm_int();
> +	*out = 0xbeef;
> +	store_cpu_address_key_1(out);
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	report(*out == 0xbeef, "no store occurred");
> +	report_prefix_pop();
> +
> +	report_prefix_push("storage-protection override, override key");
> +	set_storage_key(pagebuf, 0x90, 0);
> +	*out = 0xbeef;
> +	store_cpu_address_key_1(out);
> +	report(*out == cpu_addr, "override occurred");
> +	report_prefix_pop();
> +
> +	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
> +
> +	report_prefix_push("storage-protection override disabled, override key");
> +	set_storage_key(pagebuf, 0x90, 0);
> +	expect_pgm_int();
> +	*out = 0xbeef;
> +	store_cpu_address_key_1(out);
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	report(*out == 0xbeef, "no store occurred");
> +	report_prefix_pop();
> +
> +	set_storage_key(pagebuf, 0x00, 0);
> +	report_prefix_pop();
> +}
> +
> +/*
> + * Perform SET PREFIX (SPX) instruction while temporarily executing
> + * with access key 1.
> + */
> +static void set_prefix_key_1(uint32_t *out)
> +{
> +	asm volatile (
> +		"spka 0x10(0)\n\t"
> +		"spx	%0\n\t"
> +		"spka 0(0)\n"
> +	     :: "Q" (*out)
> +	);
> +}
> +
> +/*
> + * We remapped page 0, making the lowcore inaccessible, which breaks the normal
> + * handler and breaks skipping the faulting instruction.
> + * Just disable dynamic address translation to make things work.
> + */
> +static void dat_fixup_pgm_int(void)
> +{
> +	uint64_t psw_mask = extract_psw_mask();
> +
> +	psw_mask &= ~PSW_MASK_DAT;
> +	load_psw_mask(psw_mask);
> +}
> +
> +static void test_set_prefix(void)
> +{
> +	uint32_t *out = (uint32_t *)pagebuf;
> +	pgd_t *root;
> +
> +	report_prefix_push("SET PREFIX");
> +	root = (pgd_t *)(stctg(1) & PAGE_MASK);
> +
> +	asm volatile("stpx	%0" : "=Q"(*out));
> +
> +	report_prefix_push("zero key");
> +	set_storage_key(pagebuf, 0x20, 0);
> +	asm volatile("spx	%0" :: "Q" (*out));

so you are changing the prefix to... the old prefix (so nothing
changes). how do you know that something happened at all?

(see my longer comment below)

> +	report_pass("no exception");
> +	report_prefix_pop();
> +
> +	report_prefix_push("matching key");
> +	set_storage_key(pagebuf, 0x10, 0);
> +	set_prefix_key_1(out);
> +	report_pass("no exception");
> +	report_prefix_pop();
> +
> +	report_prefix_push("mismatching key, no fetch protection");
> +	set_storage_key(pagebuf, 0x20, 0);
> +	set_prefix_key_1(out);
> +	report_pass("no exception");
> +	report_prefix_pop();
> +
> +	report_prefix_push("mismatching key, fetch protection");
> +	set_storage_key(pagebuf, 0x28, 0);
> +	expect_pgm_int();
> +	*out = 0xdeadbeef;

so here you are trying to set 0xdeadbeef as prefix, right?
which would fail for other reasons I guess, since that would be outside
memory (unless otherwise specified, kvm unit tests run with 128M of ram)

> +	set_prefix_key_1(out);
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	asm volatile("stpx	%0" : "=Q"(*out));
> +	report(*out != 0xdeadbeef, "no fetch occurred");

and here you check that the prefix has not changed to that "wrong
value", which would be impossible anyway because it would be outside of
memory. moreover the address you give is not even in the lower 2G, so
in case the address has been changed, it would not match your magic
value anyway.

for this (and the following) tests, I propose the following:

add a new
char tmplowcore[2 * PAGE_SIZE] __attribute((aligned(2*PAGE_SIZE)));

initialize it properly (memcpy the actual lowcore into it), and use
that address for SPX. this way if SPX does not fail, at least you would
have a valid lowcore. and at that point you can check against that
address instead of your magic

> +	report_prefix_pop();
> +
> +	register_pgm_cleanup_func(dat_fixup_pgm_int);
> +
> +	report_prefix_push("mismatching key, remapped page, fetch protection");
> +	set_storage_key(pagebuf, 0x28, 0);
> +	expect_pgm_int();
> +	WRITE_ONCE(*out, 0xdeadbeef);
> +	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
> +	set_prefix_key_1((uint32_t *)0);
> +	install_page(root, 0, 0);
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	asm volatile("stpx	%0" : "=Q"(*out));
> +	report(*out != 0xdeadbeef, "no fetch occurred");
> +	report_prefix_pop();
> +
> +	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
> +
> +	report_prefix_push("mismatching key, fetch protection override applies");
> +	set_storage_key(pagebuf, 0x28, 0);
> +	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
> +	set_prefix_key_1((uint32_t *)0);
> +	install_page(root, 0, 0);
> +	report_pass("no exception");
> +	report_prefix_pop();
> +
> +	report_prefix_push("mismatching key, fetch protection override does not apply");
> +	out = (uint32_t *)(pagebuf + 2048);
> +	set_storage_key(pagebuf, 0x28, 0);
> +	expect_pgm_int();
> +	WRITE_ONCE(*out, 0xdeadbeef);
> +	install_page(root, virt_to_pte_phys(root, pagebuf), 0);
> +	set_prefix_key_1((uint32_t *)2048);
> +	install_page(root, 0, 0);
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	asm volatile("stpx	%0" : "=Q"(*out));
> +	report(*out != 0xdeadbeef, "no fetch occurred");
> +	report_prefix_pop();
> +
> +	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
> +	set_storage_key(pagebuf, 0x00, 0);
> +	register_pgm_cleanup_func(NULL);
> +	report_prefix_pop();
> +}
> +
>  int main(void)
>  {
>  	report_prefix_push("skey");
> @@ -130,6 +340,11 @@ int main(void)
>  	test_set();
>  	test_set_mb();
>  	test_chg();
> +	test_test_protection();
> +	test_store_cpu_address();
> +
> +	setup_vm();
> +	test_set_prefix();
>  done:
>  	report_prefix_pop();
>  	return report_summary();
> 
> base-commit: 6a7a83ed106211fc0ee530a3a05f171f6a4c4e66

