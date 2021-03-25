Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA73B349302
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 14:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhCYNXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 09:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhCYNWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 09:22:51 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CD4C06174A;
        Thu, 25 Mar 2021 06:22:50 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id o19so1147057qvu.0;
        Thu, 25 Mar 2021 06:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FoPot4yn/913q2goHqTcmxadnQAVEQfJX7+M8LxXsgE=;
        b=rBvpd6eAuDPCtv4GTnHqF5cEnKcd/vYdb7zaF/LQKNiEGr98XHARNeSQ+kqA4w/BrJ
         vE8hAmHrarxvYnSGG2nrpeJbNjzsIiH5JJBd3ayc0XgQZ8Wm6emdqFCEUIGWGK/VD1qG
         6kGxKnBfuLwUazgMHHl42Dd+0HR4RkmPMVOehCmOlpyhaypT4QgGADQHXi8KsFq3tsfm
         EMFXQxWtmhCgqPP7WAHfrvnCQ69aQ1sFT9aVHLqsLEYuNyNwKonloXJmitUzF6PaLRVm
         RVRnsUY3j74Z1uLw3Xn1gofGAl3IdgKmJUSJQ4st9Hvhw2Ue/r7bPF6xhRM1CY1yfzF5
         eBIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FoPot4yn/913q2goHqTcmxadnQAVEQfJX7+M8LxXsgE=;
        b=Va3iC0JEBP60CMW8WBzOnpt3kIGkCn7jdlx+gbXYayErxCmM/EQRjl1gxyaloLk3fx
         4pI20ikMlenEPK+nnCQSiPdYNUr3Y/xHXO2rXW4pd8YwZhYPLqMfevCyIf2GSfAbS3Pf
         n/526uGcbEi2SZEkCWn09TVIxgbO58aGEPEcR0lAg4ojBkNT6QrpSTR8F17n3LLe9QGP
         nMucNUVLpbcHlkRccOZQ/XSROK0/SW1wJfp/0jO/Jc0OlFED7lsSTjEWaQqzKJEfK1m2
         DrrprB1gJZe+2VuKPYv6MifeW+B8GWuvzmPtA7cwwokaqcJNi5SP+yNBgjVcKbHsongx
         RLsg==
X-Gm-Message-State: AOAM532btL+6FmaW82LTmEG1y+uj0nlhfF6N34br4oEaDHMm2dFeYfXj
        6jsUQzXlrgr4LSIOzuUkJlhHx/BUlPA8Ysyj+PO+RuU=
X-Google-Smtp-Source: ABdhPJza7igFu6VWFELWk0EHwwg70GuMYwiDkMzucnIWAMJnCS4eY5JJWo2E4NCvJGdV20Z2V2hPkoXKhvsze2FWDuc=
X-Received: by 2002:ad4:4904:: with SMTP id bh4mr8207440qvb.53.1616678569993;
 Thu, 25 Mar 2021 06:22:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210323023726.28343-1-lihaiwei.kernel@gmail.com>
In-Reply-To: <20210323023726.28343-1-lihaiwei.kernel@gmail.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Thu, 25 Mar 2021 21:22:11 +0800
Message-ID: <CAB5KdOZq+2ETburoMv6Vnnj3MFAuvwnSBsSmiBO=nH1Ajdp5_g@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Check the corresponding bits according to the
 intel sdm
To:     LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 10:37 AM <lihaiwei.kernel@gmail.com> wrote:
>
> From: Haiwei Li <lihaiwei@tencent.com>
>
> According to IA-32 SDM Vol.3D "A.1 BASIC VMX INFORMATION", two inspections
> are missing.
> * Bit 31 is always 0. Earlier versions of this manual specified that the
> VMCS revision identifier was a 32-bit field in bits 31:0 of this MSR. For
> all processors produced prior to this change, bit 31 of this MSR was read
> as 0.
> * The values of bits 47:45 and bits 63:57 are reserved and are read as 0.
>
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 32cf828..0d6d13c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2577,6 +2577,20 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>
>         rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
>
> +       /*
> +        * IA-32 SDM Vol 3D: Bit 31 is always 0.
> +        * For all earlier processors, bit 31 of this MSR was read as 0.
> +        */
> +       if (vmx_msr_low & (1u<<31))
> +               return -EIO;

Drop this code as Jim said.

> +
> +       /*
> +        * IA-32 SDM Vol 3D: bits 47:45 and bits 63:57 are reserved and are read
> +        * as 0.
> +        */
> +       if (vmx_msr_high & 0xfe00e000)
> +               return -EIO;

Is this ok? Can we pick up the part? :)

--
Haiwei Li
