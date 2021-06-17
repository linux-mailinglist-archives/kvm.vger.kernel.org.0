Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2321A3AAA1F
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 06:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhFQEfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 00:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbhFQEf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 00:35:29 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9068CC061574;
        Wed, 16 Jun 2021 21:33:22 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id s23so5052631oiw.9;
        Wed, 16 Jun 2021 21:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l93nAEQWQVGgYjPJ36XXH2GA9smqr9t+XyPLE0ZcqFU=;
        b=WM4BIBJYAR9/GNqzGaAm7/afPEFOtfLVJylAR7UtTxDF4EtLlXlxo2FlUkpt3eunCR
         kGlDhLJM2qDcy8mqvlWWmuqgPFBeT3nTZwv55IA1Qw4G1KvMg6iZvBa9yL2yr/d0lUpQ
         UD0Qt/0MNDJqrBKIDVG22MJaOH5WedGeDRqPDsV030xoAUugJzeQ28Bi3dxUOfdfNE/8
         n3hVYR20/20IVFUBI0HYKWpxXTNtXSNKX0gZ9vmU25Wva2QlYFiVRlGrieUNMcYGNJSv
         xknDT9lUjdBPJVO3tc3ZYk3KbdrHWUNP+t8MXQ2AN2MmOTI67G+Ffqx0pLo1hrFi8J07
         tIww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l93nAEQWQVGgYjPJ36XXH2GA9smqr9t+XyPLE0ZcqFU=;
        b=VDuvfgylk5NfYC3WmRa3chirge6iNIuwKISNSOOZtfjCv4xfxAQ8soK5S7OLcKvCAs
         xFP9WVTXo/Mo6F/IJP3cu71Xh1rggYcZ1yDK+x7UjevxDv3GOSwqIXHNfNKmzBDES5Ls
         hrdMP3iZ/dyum80bIYmngVzzKkuY083sMQjZSNLL2jscPcUzDFg0kvCmOhlq9CpAa5eA
         k9IEP8LraZCNHlHYaWjXlZjRFHhDYxeOqnfKyYzC8yHSxbPrNrWMxEEN3qKKevi2uqGf
         YwtxsTOWdQsZTalbF/n5XgjBtNaJQnM9sr3FOL3B8smtTw1MNwtGsKMKbxIpEbpVhClR
         QWWg==
X-Gm-Message-State: AOAM5309zneZPt3ezZv0t8AfLsZnvxonnLYhW2vFJAuyI3E6C4KP1mvU
        7E8Y0RJal/5b7fqYJWQ3FhtaTMuddptCRvSxWCcBN9wS
X-Google-Smtp-Source: ABdhPJxz5W3otMY5FhU2TFi+zV2IjT4OV7DdapjsYvWvoLcbPMOsT0TtS8dft+AwmFb/YRe9EzwK3aHQpnxNOgDAzlY=
X-Received: by 2002:aca:b609:: with SMTP id g9mr9310954oif.141.1623904401734;
 Wed, 16 Jun 2021 21:33:21 -0700 (PDT)
MIME-Version: 1.0
References: <1623223000-18116-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1623223000-18116-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 17 Jun 2021 12:33:09 +0800
Message-ID: <CANRm+CyO9yQk8KsNa8hKyTA3V9XnB41=roPcK8Vn0dzR7Ywktg@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: LAPIC: Keep stored TMCCT register value 0 after KVM_SET_LAPIC
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kindly ping, :)
On Wed, 9 Jun 2021 at 15:17, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> KVM_GET_LAPIC stores the current value of TMCCT and KVM_SET_LAPIC's memcpy
> stores it in vcpu->arch.apic->regs, KVM_SET_LAPIC could store zero in
> vcpu->arch.apic->regs after it uses it, and then the stored value would
> always be zero. In addition, the TMCCT is always computed on-demand and
> never directly readable.
>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 6d72d8f43310..9bd29b3ca790 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2628,6 +2628,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>         apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
>         update_divide_count(apic);
>         __start_apic_timer(apic, APIC_TMCCT);
> +       kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
>         kvm_apic_update_apicv(vcpu);
>         apic->highest_isr_cache = -1;
>         if (vcpu->arch.apicv_active) {
> --
> 2.25.1
>
