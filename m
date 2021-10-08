Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED42242688D
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 13:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240297AbhJHLUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 07:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240328AbhJHLTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 07:19:49 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBA3C061766;
        Fri,  8 Oct 2021 04:17:51 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id g15-20020a9d128f000000b0054e3d55dd81so6134586otg.12;
        Fri, 08 Oct 2021 04:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z8wscnU7EJDz1becCX4OkjLIi0fpkDjdUjiqRD+Xmzo=;
        b=RVOaWoJX6R3PfprVyoluu0LPH+X0sV+Hw50lNmpLI7p7M2Ufs+5nGaPyTt244Mh3in
         Vb0dcAv33GuvfvdbgKXELCUZsworOGRxMnlB8KuHHanXTqtD8DqOL8RASfTnbUhmheIe
         HFBdVR7ZVNbX0rVUAVCIneWdXUio6cDIycBFwKSshQo2wvGmywsGPY6xDQ0uKJZH/cDc
         Axk23a5GB/+eUEnUz2S7L7CgMTf8CFC2BnnB1YReIrLlw+bS/8+SLPoEWm5xslFM1KOm
         rsX+6P32dny+eUCGtmUqBq0sy9mgDoNM1AXkW6sWgYHL9AHkmbVAMXTStxrvabXAHuL2
         lpVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z8wscnU7EJDz1becCX4OkjLIi0fpkDjdUjiqRD+Xmzo=;
        b=Y5pWTamD9V4oZBexWZ3M3n7a5uGA0v06OIXQsKyk4HyeF1a9MOqDKf+dkgaAgQ+eAv
         rvPkhN18mpvougT6ArI/Tn7JTcR7TKpnuKl0RLCKrcsahpGNgmyLYLFWPckBvFKOcMb4
         Y13PaaUEbtp9CFxoNZDl40OHIhCHuYktW4l4ENd830x1VvXj5tWMDBoAY4eHY81lM2b2
         JdL1pCDMIf/CHVk82pLu5p64epz3qzogIjztLLtp1GsHe9ofy8zNm+54RLhPx9Jh/sW0
         NtzQgd+j6W0D/gU24MeIvxwnPjVop75m1O8G8QPRWWrcaL+PbwCpJaO5GPIbEWJK+YqV
         2usw==
X-Gm-Message-State: AOAM532nUPr+ZZU6xeJaNEBUv9X/DvY57tSR8h7rp5A5ZzShGwMqUBll
        JvU1o2Sva5Lgrlfs/YA2gF2o9cWD4IXZEMkL+0o=
X-Google-Smtp-Source: ABdhPJzQWDrlisPXjchk6Fi/EBqSZmjGWWdtVp4IBIyWMO6uj88/yoeUMogaKSDEVU0f6HJIRrE3GIAPZjK9WzuzNc0=
X-Received: by 2002:a9d:4f12:: with SMTP id d18mr8322705otl.169.1633691870634;
 Fri, 08 Oct 2021 04:17:50 -0700 (PDT)
MIME-Version: 1.0
References: <1633687054-18865-1-git-send-email-wanpengli@tencent.com>
 <1633687054-18865-2-git-send-email-wanpengli@tencent.com> <58d59149-669f-7990-4f68-05b32ed693b5@gmail.com>
In-Reply-To: <58d59149-669f-7990-4f68-05b32ed693b5@gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 8 Oct 2021 19:17:39 +0800
Message-ID: <CANRm+CwB79B3vQZF8Gu1qELAq9G-TDmi+KWnJmHQP6csx8Uo_A@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: vPMU: Fill get_msr MSR_CORE_PERF_GLOBAL_OVF_CTRL
 w/ 0
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 8 Oct 2021 at 19:02, Like Xu <like.xu.linux@gmail.com> wrote:
>
> cc Andi,
>
> On 8/10/2021 5:57 pm, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > SDM section 18.2.3 mentioned that:
> >
> >    "IA32_PERF_GLOBAL_OVF_CTL MSR allows software to clear overflow indicator(s) of
> >     any general-purpose or fixed-function counters via a single WRMSR."
> >
> > It is R/W mentioned by SDM, we read this msr on bare-metal during perf testing,
> > the value is always 0 for CLX/SKX boxes on hands. Let's fill get_msr
> > MSR_CORE_PERF_GLOBAL_OVF_CTRL w/ 0 as hardware behavior.
> >
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > Btw, xen also fills get_msr MSR_CORE_PERF_GLOBAL_OVF_CTRL 0.
> >
> >   arch/x86/kvm/vmx/pmu_intel.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > index 10cc4f65c4ef..47260a8563f9 100644
> > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > @@ -365,7 +365,7 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >               msr_info->data = pmu->global_ctrl;
> >               return 0;
> >       case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> > -             msr_info->data = pmu->global_ovf_ctrl;
> > +             msr_info->data = 0;
>
> Tested-by: Like Xu <likexu@tencent.com>

Thanks.

> Further, better to drop 'u64 global_ovf_ctrl' directly.

Good suggestion. :)

    Wanpeng
