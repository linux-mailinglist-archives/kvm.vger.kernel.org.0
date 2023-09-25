Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15427ADEB5
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 20:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbjIYSaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 14:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjIYSaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 14:30:19 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FD29B
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 11:30:12 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-59f67676065so62681187b3.0
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 11:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695666612; x=1696271412; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q4/VvgJsZhmZcNt+Jb9cwBm667cAz2SsHu7xD+9HLQQ=;
        b=OJ9R9y7xDnvgRJqaaBJDz+6kvUORYJqSKGqM7ypDOZwbK/XVoPLv+rDdqtJ4zZ2TUw
         vH0xbchsGY4NbEXuRnBUISwQrHIKnW4n+TrDiohlkma4sm4x1drUMva029FoJomrB9bP
         m+nLklpxUuWFTlTn3fviPbAx1Egtm+rJjTvBNegCuY/unGyKfbjlpouhJh/R9Bil7WE0
         DExTs+YeJuSQuoKewYcgrrZvK7E0e9notJYXuqh6te+VUihdiUuBIvwlFN7981jbOiMg
         Ly7uCWRpmg7PnhZOCi3yBitkgallqkyojXKNOIyQQJe/m9qjKLHB1L9iBiGfAsn2K/4i
         xLng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695666612; x=1696271412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q4/VvgJsZhmZcNt+Jb9cwBm667cAz2SsHu7xD+9HLQQ=;
        b=so7QZKqa0BCdu9wtAxr4v4XnHj+/goIgDpPnbGhL9H+o5lUlSqp8NzUDlWWaeXgtYq
         NkWl48na6SfrEoRibkcWwSaDf7EMVq4xcclgDGRdBz0CcWsf1mOjql11wAiIQ8GLuQtI
         7auCf06vGoyfQvRnvv/NEFwjs2R8nvdAja7Tan3Y4w10EO0H7Z/SHMZyGm3DqnT+xisP
         nejMZttSzsB9ZXd9zDTJTEAXtI2gvjKUUCLTENLYsREbWIrF/QsPyZZZk+x3zIxyRpBB
         GubUYfcO2Q3O75+Kj333rTrgxgWYdiIvONA0SQHIybU1NMEI80udbDXRdo3xtxcT1exm
         yYAQ==
X-Gm-Message-State: AOJu0Yyrskti3ns0jjsZ0FlhE/JEgmA8y23yemVscFbM7bEGUrkWuNpH
        PKkjDpPPGBjsoTix/N7cOrGYoMmgYPA=
X-Google-Smtp-Source: AGHT+IEhT5VXT0vCcSofd7Ug07kgwzFWVTMm7KTtnD8JkrbF8xhK8ifjDU5yukAatNO361XSlcjxta1gE/o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:cacd:0:b0:d7f:2cb6:7d8a with SMTP id
 a196-20020a25cacd000000b00d7f2cb67d8amr74861ybg.11.1695666611883; Mon, 25 Sep
 2023 11:30:11 -0700 (PDT)
Date:   Mon, 25 Sep 2023 11:30:10 -0700
In-Reply-To: <0ffde769702c6cdf6b6c18e1dcb28b25309af7f7.1695659717.git.maciej.szmigiero@oracle.com>
Mime-Version: 1.0
References: <0ffde769702c6cdf6b6c18e1dcb28b25309af7f7.1695659717.git.maciej.szmigiero@oracle.com>
Message-ID: <ZRHRsgjhOmIrxo0W@google.com>
Subject: Re: [PATCH] KVM: x86: Ignore MSR_AMD64_BU_CFG access
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Hyper-V enabled Windows Server 2022 KVM VM cannot be started on Zen1 Ryzen
> since it crashes at boot with SYSTEM_THREAD_EXCEPTION_NOT_HANDLED +
> STATUS_PRIVILEGED_INSTRUCTION (in other words, because of an unexpected #GP
> in the guest kernel).
> 
> This is because Windows tries to set bit 8 in MSR_AMD64_BU_CFG and can't
> handle receiving a #GP when doing so.

Any idea why?

> Give this MSR the same treatment that commit 2e32b7190641
> ("x86, kvm: Add MSR_AMD64_BU_CFG2 to the list of ignored MSRs") gave
> MSR_AMD64_BU_CFG2 under justification that this MSR is baremetal-relevant
> only.

Ugh, that commit set a terrible example.  The kernel change should have been
conditioned on !X86_FEATURE_HYPERVISOR if the MSR only has meaning for bare metal.

> Although apparently it was then needed for Linux guests, not Windows as in
> this case.
> 
> With this change, the aforementioned guest setup is able to finish booting
> successfully.
> 
> This issue can be reproduced either on a Summit Ridge Ryzen (with
> just "-cpu host") or on a Naples EPYC (with "-cpu host,stepping=1" since
> EPYC is ordinarily stepping 2).

This seems like it needs to be tagged for stable?

> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>  arch/x86/include/asm/msr-index.h | 1 +
>  arch/x86/kvm/x86.c               | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 1d111350197f..c80a5cea80c4 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -553,6 +553,7 @@
>  #define MSR_AMD64_CPUID_FN_1		0xc0011004
>  #define MSR_AMD64_LS_CFG		0xc0011020
>  #define MSR_AMD64_DC_CFG		0xc0011022
> +#define MSR_AMD64_BU_CFG		0xc0011023

What document actually defines this MSR?  All of the PPRs I can find for Family 17h
list it as:

   MSRC001_1023 [Table Walker Configuration] (Core::X86::Msr::TW_CFG)

>  #define MSR_AMD64_DE_CFG		0xc0011029
>  #define MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT	 1
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9f18b06bbda6..2f3cdd798185 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3639,6 +3639,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_IA32_UCODE_WRITE:
>  	case MSR_VM_HSAVE_PA:
>  	case MSR_AMD64_PATCH_LOADER:
> +	case MSR_AMD64_BU_CFG:

I am sorely tempted to say that this should be solved in userspace via MSR
filtering.  IIUC, the MSR truly is model specific, and I don't love the idea of
effectively ignoring accesses to unknown MSRs.  And I really, really don't want
KVM to pivot on FMS.

Paolo, is punting to userspace reasonable, or should we just bite the bullet in
KVM and commit to ignoring MSRs like this?

>  	case MSR_AMD64_BU_CFG2:
>  	case MSR_AMD64_DC_CFG:
>  	case MSR_F15H_EX_CFG:
> @@ -4062,6 +4063,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	case MSR_K8_INT_PENDING_MSG:
>  	case MSR_AMD64_NB_CFG:
>  	case MSR_FAM10H_MMIO_CONF_BASE:
> +	case MSR_AMD64_BU_CFG:
>  	case MSR_AMD64_BU_CFG2:
>  	case MSR_IA32_PERF_CTL:
>  	case MSR_AMD64_DC_CFG:
