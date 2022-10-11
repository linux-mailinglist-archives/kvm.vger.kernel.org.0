Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A2F5FBD39
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 23:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJKV4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 17:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiJKV4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 17:56:42 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08583FEE6
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 14:56:41 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c24so14467922pls.9
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 14:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SKoeZztmL6V88QbO/3svaXjwzvQ3Y47A//j9o1HAFhk=;
        b=cex7Bex/7Xn8kdwtRtXRWA2Hrhasiv4qVNY2MTrerdleBvCTGBCIuC5zieBRR2Ifrx
         jnyO4ZASEa44vJp3WaZ5SJ/v3CsfqpMBQJcgT2XaZlPvnpVesUlIGhXg0S+TANT99kz1
         A8qMbhBaqL/reWmkq/vk6EkAsq8T9ZciZbANMl4tpv7aev8JCfBWZj4lETNaCR+8PuJN
         G/tkci6j3COCY8gRUndEx0xlm2vFTR0Frep2I7CI10xdRRHR2mUGYbJa4Z3tG65AEDF/
         8tvnYMJFQs44W2ShwYmS6LbLNiZCcJ9bbJpq0O5LcX0KZJo9IMeaKtMJnK6k9Op6td/r
         GWyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SKoeZztmL6V88QbO/3svaXjwzvQ3Y47A//j9o1HAFhk=;
        b=YnW60X8pssKU7GxHVPeX3qah9Do1UGTBGDqdpz6MlXYg30Djid45CsD3JrbPlmlg1q
         Nz9pzPG4Nbjt6EmtBel3nhWvaxBZ3sjT2jp3/KwPzQB5UaAQQO+/1tH0NPxuoCw8H40S
         kc4XxWBYdjbFymxXj1sH3vOx1MWajFqjk5KOl/UNstFGoXej7bPJLXxR1r6t/Aj1DuZy
         gKmxuVbLFmZIDV48CZ/S3L4nMwZ1PU9PhY2Sr7y8phrcovduR/7GvofQ1nLnrBiz7Mn9
         Azd5TDYu1W4wBu9lid7d1XvANEHhh0Y4ThzvL9GXgvIWLjugia4R6PTHo867BQ8Z0K2p
         P8dQ==
X-Gm-Message-State: ACrzQf0oqhlMJ9is83zqFGPIbq8lGye6AJb2hmImso9yfECr1CWObQBa
        uYRzgYndgATIYyjZgOOwMyfUcg==
X-Google-Smtp-Source: AMsMyM51J+HiChOJUj0QeMK/Eyr8iuIsgqJjFYvaHRGN0Pu8bvKnF6E1Rq4eK7aePkRn0u63CvGt4A==
X-Received: by 2002:a17:902:db11:b0:17d:5e67:c51c with SMTP id m17-20020a170902db1100b0017d5e67c51cmr25372269plx.64.1665525401248;
        Tue, 11 Oct 2022 14:56:41 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f2-20020a170902ce8200b00177fb862a87sm6840539plg.20.2022.10.11.14.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 14:56:40 -0700 (PDT)
Date:   Tue, 11 Oct 2022 21:56:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v3 08/10] KVM: x86/mmu: Split out TDP MMU page fault
 handling
Message-ID: <Y0XmlE90yHqfnEFM@google.com>
References: <20220921173546.2674386-1-dmatlack@google.com>
 <20220921173546.2674386-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921173546.2674386-9-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022, David Matlack wrote:
> Split out the page fault handling for the TDP MMU to a separate
> function.  This creates some duplicate code, but makes the TDP MMU fault
> handler simpler to read by eliminating branches and will enable future
> cleanups by allowing the TDP MMU and non-TDP MMU fault paths to diverge.

IMO, the code duplication isn't worth the relatively minor simplification.  And
some of the "cleanups" to reduce the duplication arguably add complexity, e.g.
moving code around in "Initialize fault.{gfn,slot} earlier for direct MMUs" isn't
a net positive IMO.

With the TDP MMU being all-or-nothing, the need to check if the MMU is a TDP MMU
goes away.  If the TDP MMU is enabled, direct_page_fault() will be reached only
for non-nested TDP page faults.  Paging is required for NPT, and EPT faults will
always go through ept_page_fault(), i.e. nonpaging_page_fault() is unused.

In other words, this code

	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);

gets replaced with direct checks on is_tdp_mmu_enabled().  And because fast page
faults are used only for direct MMUs,  that code can also simply query whether or
not the TDP MMU is enabled.

Avoiding make_mmu_pages_available() for the TDP MMU is easy enough and doesn't
require any new conditionals.

	if (is_tdp_mmu_enabled()) {
		r = kvm_tdp_mmu_map(vcpu, fault);
	} else {
		r = make_mmu_pages_available(vcpu);
		if (r)
			goto out_unlock;

		r = __direct_map(vcpu, fault);
	}


That leaves the read vs. write lock as the only code that is borderline difficult
to read.  I agree that's a little ugly, but IMO it's not worth duplicating the
entire function.  If we really wanted to hide that ugliness, we could add helpers
to do the lock+unlock, but even that seems somewhat superfluous.

From a performance perspective, with the flag being read-only after the vendor
module is loaded, we can add a static key to track TDP MMU enabling, biased to the
TDP MMU being enabled.  That turns all of if-statements into NOPs for the TDP MMU.
(this is why I suggested keeping the is_tdp_mmu_enabled() wrapper in patch 1).
Static branches actually shrink the code size too (because that matters), e.g. a
5-byte nop instead of 8 bytes for TEST+Jcc.

I'll speculatively post a v4 with the static key idea, minus patches 7, 8, and 10.
I think that'll make it easier to discuss the static key/branch implementation.
If we decide we still want to split out the TDP MMU page fault handler, then it
should be relatively simple to fold back in those patches.

E.g. the generate code looks like this:

4282		if (is_tdp_mmu_enabled())
4283			read_lock(&vcpu->kvm->mmu_lock);
   0x000000000005ff7e <+494>:   nopl   0x0(%rax,%rax,1)
   0x000000000005ff83 <+499>:	mov    (%rbx),%rdi
   0x000000000005ff86 <+502>:	call   0x5ff8b <direct_page_fault+507>

4286	
4287		if (is_page_fault_stale(vcpu, fault))
   0x000000000005ff8b <+507>:	mov    %r15,%rsi
   0x000000000005ff8e <+510>:	mov    %rbx,%rdi
   0x000000000005ff91 <+513>:	call   0x558b0 <is_page_fault_stale>
   0x000000000005ff96 <+518>:	test   %al,%al
   0x000000000005ff98 <+520>:	jne    0x603e1 <direct_page_fault+1617>

4288			goto out_unlock;
4289	
4290		if (is_tdp_mmu_enabled()) {
4291			r = kvm_tdp_mmu_map(vcpu, fault);
   0x000000000005ff9e <+526>:   nopl   0x0(%rax,%rax,1)
   0x000000000005ffa3 <+531>:	mov    %rbx,%rdi
   0x000000000005ffa6 <+534>:	mov    %r15,%rsi
   0x000000000005ffa9 <+537>:	call   0x5ffae <direct_page_fault+542>
   0x000000000005ffae <+542>:	mov    (%rbx),%rdi
   0x000000000005ffb1 <+545>:	mov    %eax,%ebp


#ifdef CONFIG_X86_64
DECLARE_STATIC_KEY_TRUE(tdp_mmu_enabled);
#endif
                                     
static inline bool is_tdp_mmu_enabled(void)
{
#ifdef CONFIG_X86_64
        return static_branch_likely(&tdp_mmu_enabled);
#else
        return false;
#endif
}
                              
static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
{
        return is_tdp_mmu_enabled() && mmu->root_role.direct;
}




