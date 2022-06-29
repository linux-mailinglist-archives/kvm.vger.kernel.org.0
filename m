Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39BC55F2C8
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 03:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiF2Bcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 21:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiF2Bct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 21:32:49 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39227201AB
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 18:32:48 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x20so7042801plx.6
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 18:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=yX35fVz3Wo1ipgy4WpiLmlRXAXDcg1lRn9EVWCJIYSE=;
        b=f8U9xWZzFyMRNLUcvwJa5BUwkUZc2IOT4bI6kFh4v5foeV1oOVQuFBmG10aR3ld9fM
         1BNap0hWEibONbTovCLOPPlP19jZQQ1rr1nfBt2bg6i0JykO4wSOIuoIfKOfxOL+z9Yf
         DiAvjNIxGmxhID56fb4klB7hjIFxwEZS6QAmxsb52vp8YfwIfJHdkJC1olSTqHoqfvM1
         U9V50keWL3y9qzn0ptywUCIKyiRz5inbDhqcGtCnewtBzkcfBM2VDZi48HbxeHq+w4u7
         9AHw/MYIWLhykzCCvg2IGieTLlIS0LGlkN1qlmI+rILQt4NoEB2Sz67wKUzjttDpDenY
         eweQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=yX35fVz3Wo1ipgy4WpiLmlRXAXDcg1lRn9EVWCJIYSE=;
        b=XhMJPq89ZWLVPW662JWuNR6MH9e+QW9y+5zHaxkU1nxsQtkmPqYALb6N0rQ8kD+OFB
         iM/S/uzBxidYTCvggzdHp+x+/53ECTYNepNhVaxpdoF4a828NEkub9r/c3CXkYZqBpZM
         U8COO9bfAlsO5EfQ3S0PAewl4fC/odny1YnPXt5EUJCIp3+BamqkJvC52vUeLOKo7Bgq
         5dncuVWz2U6dTiqEuQbcm21auHDuksTvvI3y2WfBwS/YtcnTxMlIB8jLsSP0GpPn/NsC
         eWfpLpsvuS9NLLHLwqxtNubN2Zu95WajksllANohu6gDOoyiI+WLWOYhyAGu7UPdFpba
         hR1g==
X-Gm-Message-State: AJIora8nVOC/YYeInwIofOQ0jT7b46fCoknWvm3T+Re19II9CfWV4dSO
        QIOUQ/ZNp5Qf/t505qs6o+4LgQ==
X-Google-Smtp-Source: AGRyM1vvqStJT+xhMhfOUMHqrH3tL4J0maupqbenc8CsqNjssrqHdJWUP10yz0s+edAB4EpESDg16A==
X-Received: by 2002:a17:903:1246:b0:16b:7f81:138 with SMTP id u6-20020a170903124600b0016b7f810138mr7763293plh.141.1656466367411;
        Tue, 28 Jun 2022 18:32:47 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id ct8-20020a056a000f8800b005251c3e7ac5sm9986303pfb.166.2022.06.28.18.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 18:32:46 -0700 (PDT)
Date:   Tue, 28 Jun 2022 18:32:43 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, maz@kernel.org, bgardon@google.com,
        dmatlack@google.com, pbonzini@redhat.com, axelrasmussen@google.com
Subject: Re: [PATCH v4 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <Yruru5BkjKDUg/2S@google.com>
References: <20220624213257.1504783-1-ricarkol@google.com>
 <20220624213257.1504783-10-ricarkol@google.com>
 <YruSIWFCOcKdj4NW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YruSIWFCOcKdj4NW@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Oliver,

On Tue, Jun 28, 2022 at 04:43:29PM -0700, Oliver Upton wrote:
> Hi Ricardo,
> 
> On Fri, Jun 24, 2022 at 02:32:53PM -0700, Ricardo Koller wrote:
> > Add a new test for stage 2 faults when using different combinations of
> > guest accesses (e.g., write, S1PTW), backing source type (e.g., anon)
> > and types of faults (e.g., read on hugetlbfs with a hole). The next
> > commits will add different handling methods and more faults (e.g., uffd
> > and dirty logging). This first commit starts by adding two sanity checks
> > for all types of accesses: AF setting by the hw, and accessing memslots
> > with holes.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  .../selftests/kvm/aarch64/page_fault_test.c   | 695 ++++++++++++++++++
> >  .../selftests/kvm/include/aarch64/processor.h |   6 +
> >  3 files changed, 702 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > 
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index e4497a3a27d4..13b913225ae7 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -139,6 +139,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
> >  TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
> >  TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
> >  TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
> > +TEST_GEN_PROGS_aarch64 += aarch64/page_fault_test
> >  TEST_GEN_PROGS_aarch64 += aarch64/psci_test
> >  TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
> >  TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
> > diff --git a/tools/testing/selftests/kvm/aarch64/page_fault_test.c b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> > new file mode 100644
> > index 000000000000..bdda4e3fcdaa
> > --- /dev/null
> > +++ b/tools/testing/selftests/kvm/aarch64/page_fault_test.c
> 
> [...]
> 
> > +/* Compare and swap instruction. */
> > +static void guest_cas(void)
> > +{
> > +	uint64_t val;
> > +
> > +	GUEST_ASSERT_EQ(guest_check_lse(), 1);
> 
> Why not just GUEST_ASSERT(guest_check_lse()) ?
> 
> > +	asm volatile(".arch_extension lse\n"
> > +		     "casal %0, %1, [%2]\n"
> > +			:: "r" (0), "r" (TEST_DATA), "r" (guest_test_memory));
> > +	val = READ_ONCE(*guest_test_memory);
> > +	GUEST_ASSERT_EQ(val, TEST_DATA);
> > +}
> > +
> > +static void guest_read64(void)
> > +{
> > +	uint64_t val;
> > +
> > +	val = READ_ONCE(*guest_test_memory);
> > +	GUEST_ASSERT_EQ(val, 0);
> > +}
> > +
> > +/* Address translation instruction */
> > +static void guest_at(void)
> > +{
> > +	uint64_t par;
> > +	uint64_t paddr;
> > +
> > +	asm volatile("at s1e1r, %0" :: "r" (guest_test_memory));
> > +	par = read_sysreg(par_el1);
> 
> I believe you need explicit synchronization (an isb) before the fault
> information is guaranteed visibile in PAR_EL1.
> 
> > +	/* Bit 1 indicates whether the AT was successful */
> > +	GUEST_ASSERT_EQ(par & 1, 0);
> > +	/* The PA in bits [51:12] */
> > +	paddr = par & (((1ULL << 40) - 1) << 12);
> > +	GUEST_ASSERT_EQ(paddr, memslot[TEST].gpa);
> > +}
> > +
> > +/*
> > + * The size of the block written by "dc zva" is guaranteed to be between (2 <<
> > + * 0) and (2 << 9), which is safe in our case as we need the write to happen
> > + * for at least a word, and not more than a page.
> > + */
> > +static void guest_dc_zva(void)
> > +{
> > +	uint16_t val;
> > +
> > +	asm volatile("dc zva, %0\n"
> > +			"dsb ish\n"
> 
> nit: use the dsb() macro instead. Extremely minor, but makes it a bit
> more obvious to the reader. Or maybe I need to get my eyes checked ;-)
> 
> > +			:: "r" (guest_test_memory));
> > +	val = READ_ONCE(*guest_test_memory);
> > +	GUEST_ASSERT_EQ(val, 0);
> > +}
> > +
> > +/*
> > + * Pre-indexing loads and stores don't have a valid syndrome (ESR_EL2.ISV==0).
> > + * And that's special because KVM must take special care with those: they
> > + * should still count as accesses for dirty logging or user-faulting, but
> > + * should be handled differently on mmio.
> > + */
> > +static void guest_ld_preidx(void)
> > +{
> > +	uint64_t val;
> > +	uint64_t addr = TEST_GVA - 8;
> > +
> > +	/*
> > +	 * This ends up accessing "TEST_GVA + 8 - 8", where "TEST_GVA - 8" is
> > +	 * in a gap between memslots not backing by anything.
> > +	 */
> > +	asm volatile("ldr %0, [%1, #8]!"
> > +			: "=r" (val), "+r" (addr));
> > +	GUEST_ASSERT_EQ(val, 0);
> > +	GUEST_ASSERT_EQ(addr, TEST_GVA);
> > +}
> > +
> > +static void guest_st_preidx(void)
> > +{
> > +	uint64_t val = TEST_DATA;
> > +	uint64_t addr = TEST_GVA - 8;
> > +
> > +	asm volatile("str %0, [%1, #8]!"
> > +			: "+r" (val), "+r" (addr));
> > +
> > +	GUEST_ASSERT_EQ(addr, TEST_GVA);
> > +	val = READ_ONCE(*guest_test_memory);
> > +}
> > +
> > +static bool guest_set_ha(void)
> > +{
> > +	uint64_t mmfr1 = read_sysreg(id_aa64mmfr1_el1);
> > +	uint64_t hadbs, tcr;
> > +
> > +	/* Skip if HA is not supported. */
> > +	hadbs = FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR1_HADBS), mmfr1);
> > +	if (hadbs == 0)
> > +		return false;
> > +
> > +	tcr = read_sysreg(tcr_el1) | TCR_EL1_HA;
> > +	write_sysreg(tcr, tcr_el1);
> > +	isb();
> > +
> > +	return true;
> > +}
> > +
> > +static bool guest_clear_pte_af(void)
> > +{
> > +	*((uint64_t *)TEST_PTE_GVA) &= ~PTE_AF;
> > +	flush_tlb_page(TEST_PTE_GVA);
> 
> Don't you want to actually flush TEST_GVA to force the TLB fill when you
> poke the address again? This looks like you're flushing the VA of the
> *PTE* not the test address.

Yes, you are right, this was supposed to be:
flush_tlb_page(TEST_GVA);
(I could swear this was TEST_GVA at one time)

> 
> > +	return true;
> > +}
> > +
> > +static void guest_check_pte_af(void)
> 
> nit: call this guest_test_pte_af(). You use the guest_check_* pattern
> for test preconditions (like guest_check_lse()).
> 
> > +{
> > +	flush_tlb_page(TEST_PTE_GVA);
> 
> What is the purpose of this flush? I believe you are actually depending
> on a dsb(ish) between the hardware PTE update and the load below. Or,
> that's at least what I gleaned from the jargon of DDI0487H.a D5.4.13 
> 'Ordering of hardware updates to the translation tables'.

This was also supposed to be: flush_tlb_page(TEST_GVA)
But will removed based on D5.4.13, as it's indeed saying that the DSB
should be enough.

> 
> > +	GUEST_ASSERT_EQ(*((uint64_t *)TEST_PTE_GVA) & PTE_AF, PTE_AF);
> > +}
> 
> [...]
> 
> > +static void sync_stats_from_guest(struct kvm_vm *vm)
> > +{
> > +	struct event_cnt *ec = addr_gva2hva(vm, (uint64_t)&events);
> > +
> > +	events.aborts += ec->aborts;
> > +}
> 
> I believe you can use sync_global_from_guest() instead of this.
> 
> > +void fail_vcpu_run_no_handler(int ret)
> > +{
> > +	TEST_FAIL("Unexpected vcpu run failure\n");
> > +}
> > +
> > +extern unsigned char __exec_test;
> > +
> > +void noinline __return_0x77(void)
> > +{
> > +	asm volatile("__exec_test: mov x0, #0x77\n"
> > +			"ret\n");
> > +}
> > +
> > +static void load_exec_code_for_test(void)
> > +{
> > +	uint64_t *code, *c;
> > +
> > +	assert(TEST_EXEC_GVA - TEST_GVA);
> > +	code = memslot[TEST].hva + 8;
> > +
> > +	/*
> > +	 * We need the cast to be separate in order for the compiler to not
> > +	 * complain with: "‘memcpy’ forming offset [1, 7] is out of the bounds
> > +	 * [0, 1] of object ‘__exec_test’ with type ‘unsigned char’"
> > +	 */
> > +	c = (uint64_t *)&__exec_test;
> > +	memcpy(code, c, 8);
> 
> Don't you need to sync D$ and I$?

This is done before running the VM for the first time, and it's only
ever written this one time. I think KVM itself is doing the sync when
mapping new pages for the first time, which would be this case.

> 
> --
> Thanks,
> Oliver

ACK on all the other points, will fix accordingly.

Thanks for the review!
