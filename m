Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BF04C2E75
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 15:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbiBXObY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 09:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbiBXObW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 09:31:22 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B0E17C41E;
        Thu, 24 Feb 2022 06:30:52 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21ODMMTK006853;
        Thu, 24 Feb 2022 14:30:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=+mwhPK4wD59YL/YoLAXpcdHpTqcwUkZ9gbxdHcDOzBU=;
 b=AD6T7KAdBIc7qBcXrnCF41wsRf3vBXkTDT8SZ4Z5kQAE6BOxE7IMpFt6hs23TFtN253w
 3NLJKdVog2ixeZzpdSvizYKanOWsfekbbNhYRvzIhIWutVvKUsx68Jd9dhZY3nxv3kbk
 AcRPyWqsqhpVv+BOeRJupnUMwjKbuXD0X0YKbo1dW+AJi79LcB2a1IjditJjaI7wrGzI
 ALRy5Z8npzfJDoRFdY33m1dyE6Y0mirZh1h7+XVbPyNQyScmjjwNrUs2Pk2WtTVL5hE9
 kz4kXqbae4Atxvs3BOhPVNHOhSvDKMcY47c0vjZe8Y5JfcA383u+JmnYltVNtFBLDZFT bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edv9pub4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 14:30:51 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21ODc7UB034790;
        Thu, 24 Feb 2022 14:30:50 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edv9pub3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 14:30:50 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21OEF3cw005566;
        Thu, 24 Feb 2022 14:30:49 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3ear69ra0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 14:30:48 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21OEK2cp49086730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 14:20:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 867EC11C050;
        Thu, 24 Feb 2022 14:30:44 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31E5E11C05E;
        Thu, 24 Feb 2022 14:30:44 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.54])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Feb 2022 14:30:44 +0000 (GMT)
Date:   Thu, 24 Feb 2022 15:30:41 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] s390x: Test effect of storage keys on
 some instructions
Message-ID: <20220224153041.5e99c0b3@p-imbrenda>
In-Reply-To: <20220224110950.3401748-1-scgl@linux.ibm.com>
References: <20220224110950.3401748-1-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: V3uErLFWqD9ZQ0Bu_I8r2GuTCdcpTXiQ
X-Proofpoint-GUID: _liUi7LWeB6wb3QPm_3obsJilzu5A8Ta
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_02,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 adultscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240087
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 24 Feb 2022 12:09:50 +0100
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
> 
>  	*entry_0_p = entry_pagebuf;
> 
> I'm wondering if we need a barrier here, or would if set_prefix_key_1
> wasn't made up of an asm volatile. But the mmu code seems to not have a
> barrier in the equivalent code, so maybe it's never needed.
> 
>  	set_prefix_key_1(0);
> 
>  lib/s390x/asm/arch_def.h |  20 ++---
>  s390x/skey.c             | 169 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 180 insertions(+), 9 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 40626d72..e443a9cd 100644
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
> index 58a55436..6ae2d026 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -10,7 +10,10 @@
>  #include <libcflat.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
> +#include <vmalloc.h>
> +#include <mmu.h>
>  #include <asm/page.h>
> +#include <asm/pgtable.h>
>  #include <asm/facility.h>
>  #include <asm/mem.h>
>  
> @@ -147,6 +150,167 @@ static void test_invalid_address(void)
>  	report_prefix_pop();
>  }
>  
> +static void test_test_protection(void)
> +{
> +	unsigned long addr = (unsigned long)pagebuf;
> +
> +	report_prefix_push("TPROT");
> +	set_storage_key(pagebuf, 0x10, 0);
> +	report(tprot(addr, 0) == 0, "access key 0 -> no protection");
> +	report(tprot(addr, 1) == 0, "access key matches -> no protection");
> +	report(tprot(addr, 2) == 1, "access key mismatches, no fetch protection -> store protection");
> +	set_storage_key(pagebuf, 0x18, 0);
> +	report(tprot(addr, 2) == 2, "access key mismatches, fetch protection -> fetch & store protection");
> +	report_prefix_pop();

is there a reason why you don't set the storage key back to 0 once
you're done?

> +}
> +
> +static void store_cpu_address_key_1(uint16_t *out)
> +{
> +	asm volatile (
> +		"spka 0x10(0)\n\t"
> +		"stap %0\n\t"
> +		"spka 0(0)\n"
> +	     : "=Q" (*out)
> +	);
> +}
> +
> +static void test_store_cpu_address(void)
> +{
> +	uint16_t *out = (uint16_t *)pagebuf;
> +	uint16_t cpu_addr;
> +
> +	asm ("stap %0" : "=Q" (cpu_addr));
> +
> +	report_prefix_push("STORE CPU ADDRESS, zero key");
> +	set_storage_key(pagebuf, 0x20, 0);
> +	*out = 0xbeef;
> +	asm ("stap %0" : "=Q" (*out));
> +	report(*out == cpu_addr, "store occurred");
> +	report_prefix_pop();
> +
> +	report_prefix_push("STORE CPU ADDRESS, matching key");
> +	set_storage_key(pagebuf, 0x10, 0);
> +	*out = 0xbeef;
> +	store_cpu_address_key_1(out);
> +	report(*out == cpu_addr, "store occurred");
> +	report_prefix_pop();
> +
> +	report_prefix_push("STORE CPU ADDRESS, mismatching key");
> +	set_storage_key(pagebuf, 0x20, 0);
> +	expect_pgm_int();
> +	store_cpu_address_key_1(out);
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);

for completeness, maybe also check that nothing gets stored?

> +	report_prefix_pop();
> +
> +	ctl_set_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
> +
> +	report_prefix_push("STORE CPU ADDRESS, storage-protection override, invalid key");
> +	set_storage_key(pagebuf, 0x20, 0);
> +	expect_pgm_int();
> +	store_cpu_address_key_1(out);
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);

same here

> +	report_prefix_pop();
> +
> +	report_prefix_push("STORE CPU ADDRESS, storage-protection override, override key");
> +	set_storage_key(pagebuf, 0x90, 0);
> +	*out = 0xbeef;
> +	store_cpu_address_key_1(out);
> +	report(*out == cpu_addr, "override occurred");
> +	report_prefix_pop();
> +
> +	ctl_clear_bit(0, CTL0_STORAGE_PROTECTION_OVERRIDE);
> +}
> +
> +static void set_prefix_key_1(uint32_t *out)
> +{
> +	asm volatile (
> +		"spka 0x10(0)\n\t"
> +		"spx	%0\n\t"
> +		"spka 0(0)\n"
> +	     : "=Q" (*out)
> +	);
> +}
> +
> +/*
> + * We remapped page 0, making the lowcore inaccessible, which breaks the normal
> + * hanlder and breaks skipping the faulting instruction.
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
> +	pte_t *entry_0_p;
> +	pte_t entry_lowcore, entry_pagebuf;
> +
> +	root = (pgd_t *)(stctg(1) & PAGE_MASK);
> +	entry_0_p = get_dat_entry(root, 0, pgtable_level_pte);
> +	entry_lowcore = *entry_0_p;
> +	entry_pagebuf = __pte((virt_to_pte_phys(root, out) & PAGE_MASK));
> +
> +	asm volatile("stpx	%0" : "=Q"(*out));
> +
> +	report_prefix_push("SET PREFIX, zero key");
> +	set_storage_key(pagebuf, 0x20, 0);
> +	asm volatile("spx	%0" : "=Q" (*out));
> +	report_pass("no exception");
> +	report_prefix_pop();
> +
> +	report_prefix_push("SET PREFIX, matching key");
> +	set_storage_key(pagebuf, 0x10, 0);
> +	set_prefix_key_1(out);
> +	report_pass("no exception");
> +	report_prefix_pop();
> +
> +	report_prefix_push("SET PREFIX, mismatching key, no fetch protection");
> +	set_storage_key(pagebuf, 0x20, 0);
> +	set_prefix_key_1(out);
> +	report_pass("no exception");
> +	report_prefix_pop();
> +
> +	report_prefix_push("SET PREFIX, mismatching key, fetch protection");
> +	set_storage_key(pagebuf, 0x28, 0);
> +	expect_pgm_int();
> +	set_prefix_key_1(out);
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	report_prefix_pop();
> +
> +	register_pgm_cleanup_func(dat_fixup_pgm_int);
> +	ctl_set_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
> +
> +	report_prefix_push("SET PREFIX, mismatching key, fetch protection override applies");
> +	set_storage_key(pagebuf, 0x28, 0);
> +	ipte(0, &pte_val(*entry_0_p));
> +	*entry_0_p = entry_pagebuf;
> +	set_prefix_key_1(0);
> +	ipte(0, &pte_val(*entry_0_p));
> +	*entry_0_p = entry_lowcore;
> +	report_pass("no exception");
> +	report_prefix_pop();
> +
> +	report_prefix_push("SET PREFIX, mismatching key, fetch protection override does not apply");
> +	set_storage_key(pagebuf, 0x28, 0);
> +	expect_pgm_int();
> +	ipte(0, &pte_val(*entry_0_p));
> +	*entry_0_p = entry_pagebuf;
> +	set_prefix_key_1((uint32_t *)2048);
> +	ipte(0, &pte_val(*entry_0_p));
> +	*entry_0_p = entry_lowcore;
> +	check_pgm_int_code(PGM_INT_CODE_PROTECTION);
> +	report_prefix_pop();
> +
> +	ctl_clear_bit(0, CTL0_FETCH_PROTECTION_OVERRIDE);
> +	register_pgm_cleanup_func(NULL);
> +}
> +
>  int main(void)
>  {
>  	report_prefix_push("skey");
> @@ -159,6 +323,11 @@ int main(void)
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
> base-commit: 257c962f3d1b2d0534af59de4ad18764d734903a

