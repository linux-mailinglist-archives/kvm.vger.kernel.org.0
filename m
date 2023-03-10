Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A293F6B51B7
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 21:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjCJUWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 15:22:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjCJUWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 15:22:21 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B2D17178
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 12:22:19 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id o3-20020a634e43000000b0050726979a86so1578233pgl.4
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 12:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678479739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X5Yz6+HvQPsyWAE0S/8SN4+hADFhL9KVUn5rqZ2PnAM=;
        b=AwhQ2spe6oVrHhpsgUsMJMehfX9YCFLrc8oa9wNOC/DG4c9P7LVJZKjtkujmuqG7gZ
         KnteA0zHJ3LkfUCgEmVN1x1Uit6g/o3+iXMYEwqkyaM6HN13nXYTMRFc+DqkC+kgwJxq
         2QJZeqWXCLpr5S+7Ar3i9PSYS4LCuUI3AI+Lwi/gL/j2EzTUx5EYqCIBzAC/fgIYJUaj
         qyXHuhEU8Q10IzuklwQaEen3CZzBzF0TL/vSNVPBYyd8qVwUpU805BJ3lfcN6TgihNUj
         gxnzhqbhTW6cv/Fil7MRsB/XI9zLb1wBbB8X3TgQM9cpAtjdXuU6m7MVuB63M+OcHzd+
         Uvsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678479739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X5Yz6+HvQPsyWAE0S/8SN4+hADFhL9KVUn5rqZ2PnAM=;
        b=FNqQc52NurHAyJf6TZF5hB/37QGm2bbgGhRCigJtrVv1basC5eb0yvvMKolZz7Dfru
         eLhPmb3+p+am8iiIj0KdnB2q+3qvCC615Y1hjidyN2iXkfbiB8MeG2woxIYhVuW8nCsT
         C+r+5HkdESW/znz2Pb26fGKA89DGsO2YuSnK7ljgi6K9xSMFQ0VdNkGtfy+8gF0uOFyb
         o3cEW1cyjo49EUGiiZka4+hiUett890JqeQ2SyqPyFctyD7J7JIOQ2DHWYG3OzvAazza
         M61gPjUFsRNVs/klnqhZo8ELWwHMFXV/9YosqpA3Dx/YgD/51/4VWemdRRX5z44Jvku/
         1Mqw==
X-Gm-Message-State: AO0yUKXp8PzIWEXY91oBWPwtakNwqCNhiUZkqXIicirEQv9ukp7xtWDl
        +xTbAAYcIMvorirDW307zjP2r4+oMwA=
X-Google-Smtp-Source: AK7set+Kfl1r8AuKrlbFGZwMOXERrMBdNazncLPYHv3nVSx6XbvAX61D+uAJEgpJ4IIjgMChMyX+P34e13M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7f5c:0:b0:503:7bb8:3c32 with SMTP id
 p28-20020a637f5c000000b005037bb83c32mr8720176pgn.0.1678479739131; Fri, 10 Mar
 2023 12:22:19 -0800 (PST)
Date:   Fri, 10 Mar 2023 12:22:17 -0800
In-Reply-To: <9db9bd3a2ade8c436a8b9ab6f61ee8dafa2e072a.camel@linux.intel.com>
Mime-Version: 1.0
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
 <20230227084547.404871-3-robert.hu@linux.intel.com> <ZABPFII40v1nQ2EV@gao-cwp>
 <9db9bd3a2ade8c436a8b9ab6f61ee8dafa2e072a.camel@linux.intel.com>
Message-ID: <ZAuRec2NkC3+4jvD@google.com>
Subject: Re: [PATCH v5 2/5] [Trivial]KVM: x86: Explicitly cast ulong to bool
 in kvm_set_cr3()
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com,
        binbin.wu@linux.intel.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As Chao pointed out, this does not belong in the LAM series.  And FWIW, I highly
recommend NOT tagging things as Trivial.  If you're wrong and the patch _isn't_
trivial, it only slows things down.  And if you're right, then expediting the
patch can't possibly be necessary.

On Fri, Mar 03, 2023, Robert Hoo wrote:
> On Thu, 2023-03-02 at 15:24 +0800, Chao Gao wrote:
> > > -	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> > > +	bool pcid_enabled = !!kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
> > > 
> > > 	if (pcid_enabled) {
> > > 		skip_tlb_flush = cr3 & X86_CR3_PCID_NOFLUSH;
> > 
> > pcid_enabled is used only once. You can drop it, i.e.,
> > 
> > 	if (kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE)) {
> > 
> Emm, that's actually another point.
> Though I won't object so, wouldn't this be compiler optimized?
> 
> And my point was: honor bool type, though in C implemention it's 0 and
> !0, it has its own type value: true, false.
> Implicit type casting always isn't good habit.

I don't disagree, but I also don't particularly want to "fix" one case while
ignoring the many others, e.g. kvm_handle_invpcid() has the exact same "buggy"
pattern.

I would be supportive of a patch that adds helpers and then converts all of the
relevant CR0/CR4 checks though...

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 4c91f626c058..6e3cb958afdd 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -157,6 +157,14 @@ static inline ulong kvm_read_cr0_bits(struct kvm_vcpu *vcpu, ulong mask)
        return vcpu->arch.cr0 & mask;
 }
 
+static __always_inline bool kvm_is_cr0_bit_set(struct kvm_vcpu *vcpu,
+                                              unsigned long cr0_bit)
+{
+       BUILD_BUG_ON(!is_power_of_2(cr0_bit));
+
+       return !!kvm_read_cr0_bits(vcpu, cr0_bit);
+}
+
 static inline ulong kvm_read_cr0(struct kvm_vcpu *vcpu)
 {
        return kvm_read_cr0_bits(vcpu, ~0UL);
@@ -178,6 +186,14 @@ static inline ulong kvm_read_cr3(struct kvm_vcpu *vcpu)
        return vcpu->arch.cr3;
 }
 
+static __always_inline bool kvm_is_cr4_bit_set(struct kvm_vcpu *vcpu,
+                                              unsigned long cr4_bit)
+{
+       BUILD_BUG_ON(!is_power_of_2(cr4_bit));
+
+       return !!kvm_read_cr4_bits(vcpu, cr4_bit);
+}
+
