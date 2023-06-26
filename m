Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A8573E691
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 19:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbjFZRe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 13:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjFZReR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 13:34:17 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B2EC2
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 10:34:16 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-56ff7b4feefso33700027b3.0
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 10:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687800856; x=1690392856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C69XInp0wICRbOpkfYjSxGQ6Ixd6KtkmGO4PCkEo8n0=;
        b=bwoKhPSbWox2m1zh2KruqyMiMuvq6Q4cogbm3zpRuUe7yh83xGm9HfYq+M9tnxjI1G
         Sj3u4wWteXweU19vK1QtxC5Go2JKQbIX/eALES++0Vd75jX2qwCQE4oXY0jV7ffxL9We
         avHP8m1ug+9RhJvQV//YAHqbVPbrp7ZY92O/B6LeDNZNg9O/dQqOH54USSGsDFQalf/t
         s/hnza1o7viPad+132CsvMyeU1dor4gXFod54UuMMFGjgpefDdzJjlX8DgatdWjhBkS6
         LzBw5FQWOW2mQ/kZdNUCfpU25k2kGqKkTcHvxt6V7jHPs1aKBA5zPd9SITQWEDdltsd/
         jQmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687800856; x=1690392856;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C69XInp0wICRbOpkfYjSxGQ6Ixd6KtkmGO4PCkEo8n0=;
        b=gfmmIKntk9+BrE5OH2TC7F/1egoPwTwJDjftor0iS1OCdTjROxPASbFC40ml1Pj5eI
         arwV4oG+u/SrsYzzSx1aM2RVtyDPgAfFK5na5MoQ8KGew1Y4TS0rM1qR5sl7rl272+DT
         alFn3dJ7PMvm60/nAJQD7scb+tNBIvXnXnIef7z2iqX/zVcWbW8hMSadG4rosCbRo0jv
         42bCyIifGCexdMOd5KA+wfE54QfSejwFQzZgNao0rUCdfQ4jjvlyDNJhHmfUriS2oGeD
         SJ0FWfsYX/nA6JwBiL4+MpKQUhX1xyJQq66XWaEY5Dnu+l3AMAsgf5qEnb440vzIwjbg
         WFog==
X-Gm-Message-State: AC+VfDzo9VO0Lh8XEDppf1X516eYGJifujYF0es5atOF8zkGmCRt1Rh6
        Hrh4AUWxg1jtSXYpADzueVPTFlUHjZo=
X-Google-Smtp-Source: ACHHUZ51V3Kiv8m1FOZGGhbPviSCx+GJDADabe6eJiyXexMK/hPGkFMHHaUtx/OzOsnuvWoQm7JT/+CBAj4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:e24a:0:b0:56d:2abf:f0c with SMTP id
 z10-20020a81e24a000000b0056d2abf0f0cmr12812727ywl.10.1687800855885; Mon, 26
 Jun 2023 10:34:15 -0700 (PDT)
Date:   Mon, 26 Jun 2023 10:34:14 -0700
In-Reply-To: <CAAAPnDEb0dwdWsF6K9s1r=gZSQHXwo5Y8U9FWGzX52_KSFk_hw@mail.gmail.com>
Mime-Version: 1.0
References: <20230623123522.4185651-2-aaronlewis@google.com>
 <ZJW9uBPssAtHY4h+@google.com> <CAAAPnDEb0dwdWsF6K9s1r=gZSQHXwo5Y8U9FWGzX52_KSFk_hw@mail.gmail.com>
Message-ID: <ZJnMFq+BQF46NGut@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: SRCU protect the PMU event filter in the
 fast path
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023, Aaron Lewis wrote:
> As a separate issue, shouldn't we restrict the MSR filter from being
> able to intercept MSRs handled by the fast path?  I see that we do
> that for the APIC MSRs, but if MSR_IA32_TSC_DEADLINE is handled by the
> fast path, I don't see a way for userspace to override that behavior.
> So maybe it shouldn't?  E.g.
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 439312e04384..dd0a314da0a3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1787,7 +1787,7 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32
> index, u32 type)
>         u32 i;
> 
>         /* x2APIC MSRs do not support filtering. */
> -       if (index >= 0x800 && index <= 0x8ff)
> +       if (index >= 0x800 && index <= 0x8ff || index == MSR_IA32_TSC_DEADLINE)
>                 return true;
> 
>         idx = srcu_read_lock(&kvm->srcu);

Yeah, I saw that flaw too :-/  I'm not entirely sure what to do about MSRs that
can be handled in the fastpath.

On one hand, intercepting those MSRs probably doesn't make much sense.  On the
other hand, the MSR filter needs to be uABI, i.e. we can't make the statement
"MSRs handled in KVM's fastpath can't be filtered", because either every new
fastpath MSRs will potentially break userspace, or KVM will be severely limited
with respect to what can be handled in the fastpath.

From an ABI perspective, the easiest thing is to fix the bug and enforce any
filter that affects MSR_IA32_TSC_DEADLINE.  If we ignore performance, the fix is
trivial.  E.g.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5f220c04624e..3ef903bb78ce 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2174,6 +2174,9 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
 
        kvm_vcpu_srcu_read_lock(vcpu);
 
+       if (!kvm_msr_allowed(vcpu, msr, KVM_MSR_FILTER_WRITE))
+               goto out;
+
        switch (msr) {
        case APIC_BASE_MSR + (APIC_ICR >> 4):
                data = kvm_read_edx_eax(vcpu);
@@ -2196,6 +2199,7 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu)
        if (ret != EXIT_FASTPATH_NONE)
                trace_kvm_msr_write(msr, data);
 
+out:
        kvm_vcpu_srcu_read_unlock(vcpu);
 
        return ret;

But I don't love the idea of searching through the filters for an MSR that is
pretty much guaranteed to be allowed.  Since x2APIC MSRs can't be filtered, we
could add a per-vCPU flag to track if writes to TSC_DEADLINE are allowed, i.e.
if TSC_DEADLINE can be handled in the fastpath.

However, at some point Intel and/or AMD will (hopefully) add support for full
virtualization of TSC_DEADLINE, and then TSC_DEADLINE will be in the same boat as
the x2APIC MSRs, i.e. allowing userspace to filter TSC_DEADLINE when it's fully
virtualized would be nonsensical.  And depending on how hardware behaves, i.e. how
a virtual TSC_DEADLINE interacts with the MSR bitmaps, *enforcing* userspace's
filtering might require a small amount of additional complexity.

And any MSR that is performance sensitive enough to be handled in the fastpath is
probably worth virtualizing in hardware, i.e. we'll end up revisiting this topic
every time we add an MSR to the fastpath :-(

I'm struggling to come up with an idea that won't create an ABI nightmare, won't
be subject to the whims of AMD and Intel, and won't saddle KVM with complexity to
support behavior that in all likelihood no one wants.

I'm leaning toward enforcing the filter for TSC_DEADLINE, and crossing my fingers
that neither AMD nor Intel implements TSC_DEADLINE virtualization in such a way
that it changes the behavior of WRMSR interception.
