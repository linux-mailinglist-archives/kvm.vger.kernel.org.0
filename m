Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C5D1D6F1B
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 04:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgERCuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 May 2020 22:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726639AbgERCuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 May 2020 22:50:50 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351D3C061A0C;
        Sun, 17 May 2020 19:50:50 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id y85so3017030oie.11;
        Sun, 17 May 2020 19:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+eK6VGuEuR0GRI5R9J65CKeVkPV8II1yka+J13as0Hc=;
        b=nDZAJObBhop9kUEDGJbWMD/G7dZBMGOw6Ws+O6IBcDB8WVbVI7MNvMiKMO/2Vtohgf
         /3S3gFg3lkP3NrNUWoOeZElhCdN7sXi/YlZ1cT0GDgGK/pUrxjckaR/58EIwEZmhx8vz
         cmeeBQq1kcTcOch4fVxavwSX5sUV2Me23QWPCpaIGBXJCD5Ayrb++H+6bxiNPEPeZQ3y
         X65P8HpSsYf6PvLEvJvzOMxautWfCTSDtKatcn4cwlFCpWbS0tkc2HFwr+73PUDFJxgr
         AxbMFwqxtvvw2BCmhyceMWPyhAOsMLmb7o9iijlm4kYYT76pZdaTLRLT+UIybH18f7QV
         vxRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+eK6VGuEuR0GRI5R9J65CKeVkPV8II1yka+J13as0Hc=;
        b=krKZrLFYKu/8B3xFwpooJphFHNmm9KFuWaOA23L/9mW0IC5SWhbg2J9Jb73WFWmbz6
         csIkaz2UgC1OgIdGD78tAz0h5RnTZ3+P88975uv4eNapWKe9mB9Jj2OGmgyxDEQCZGO3
         v6Vmb9IFi2gmMS21p4HQI5/s9cFZdmbLzrm4nbIo7rcu3GY0ho0kUDpf9YjrNAXq056x
         viPXOrZnqKkQMt7OXZMVHCi7ClbE57ohVZizU8hXW5gYJvaTiiPbq0O1yBpAckH5mU8s
         VEeKNIi7wIlqnaawOT6MkF7NoPuFn9fHnr7FB3qoStpmlVTSze8lTc+BdKoVPRt3YR4x
         R+Fw==
X-Gm-Message-State: AOAM532OFG/IWACkrX0ptf+oM6GMz6yh7b8gQjKCBb8FUeK2y9W463Fd
        OkKqv0+skn5e4Yyur+8oB7SuNCt9ZmzZBhYc0iE=
X-Google-Smtp-Source: ABdhPJzvu8D92gPrVWPjVyv/fmrqksDbDke11WkKE1DH2CwV2xK1nz09HbMjrMx/KpnC5QS6xEtvwD+ZaD7M8o8+X8I=
X-Received: by 2002:aca:5296:: with SMTP id g144mr2472205oib.33.1589770249604;
 Sun, 17 May 2020 19:50:49 -0700 (PDT)
MIME-Version: 1.0
References: <2f78457e-f3a7-3bc9-e237-3132ee87f71e@gmail.com>
In-Reply-To: <2f78457e-f3a7-3bc9-e237-3132ee87f71e@gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 18 May 2020 11:00:52 +0800
Message-ID: <CANRm+CyEfmmVHLWnkJ1YHX5r5bNd+QjPQWyr+pmVWM5a6CXorQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: Fix the indentation to match coding style
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 18 May 2020 at 09:32, Haiwei Li <lihaiwei.kernel@gmail.com> wrote:
>
> From: Haiwei Li <lihaiwei@tencent.com>
>
> There is a bad indentation in next&queue branch. The patch looks like
> fixes nothing though it fixes the indentation.
>
> Before fixing:
>
>                  if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data)) {
>                          kvm_skip_emulated_instruction(vcpu);
>                          ret = EXIT_FASTPATH_EXIT_HANDLED;
>                 }
>                  break;
>          case MSR_IA32_TSCDEADLINE:
>
> After fixing:
>
>                  if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data)) {
>                          kvm_skip_emulated_instruction(vcpu);
>                          ret = EXIT_FASTPATH_EXIT_HANDLED;
>                  }
>                  break;
>          case MSR_IA32_TSCDEADLINE:
>

Reviewed-by: Wanpeng Li <wanpengli@tencent.com>

>
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>   arch/x86/kvm/x86.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 471fccf..446f747 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1631,7 +1631,7 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct
> kvm_vcpu *vcpu)
>                  if (!handle_fastpath_set_x2apic_icr_irqoff(vcpu, data)) {
>                          kvm_skip_emulated_instruction(vcpu);
>                          ret = EXIT_FASTPATH_EXIT_HANDLED;
> -               }
> +               }
>                  break;
>          case MSR_IA32_TSCDEADLINE:
>                  data = kvm_read_edx_eax(vcpu);
> --
> 1.8.3.1
