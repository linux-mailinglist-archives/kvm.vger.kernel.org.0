Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8FB754B860
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 20:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245409AbiFNSPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 14:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242307AbiFNSPM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 14:15:12 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2BBE19F80
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 11:15:11 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-30c2f288f13so38228527b3.7
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 11:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X8/2+wu+PsORoT0rrjFQwUQli114atWqejDxqt8afco=;
        b=BFx2nJFuweeoIaiSk88tCK+Zvw/48JIpbtu0DqX6f/hV+jNuutdiHEAglJEN3NBoDU
         t1VXH8kqiON/rit1qB1/lZ/zauzkEapcDmpRo6A/gozVX61yAIfYE8N7WeRDRT1ZTYEL
         LM7k4VXG88rZ21uChYEzNZphXMtmzUGZ/nMgAr+lvM00cgknWByKrHMEGd6QBptun3YW
         qmRPuBmHQqJW8ZARpdFifG4e2nEkENmFsELeBnylz/XzT+jkn+BZFNh+ujTONbSQI5pV
         xxP7nK7Fw3aZYfrdt2qEaQY3TRXip1WYtiYQKe3Qdo9qNBliA1j8ZaDPB1JgGfbA4GRD
         UOrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X8/2+wu+PsORoT0rrjFQwUQli114atWqejDxqt8afco=;
        b=3wf65jkZRZXyffqabj4ZnHVfFpwqhgySAhC5QLaWjOcoX6OLP2gdWymJrzBbWYo8tR
         SWeDkVjwfsCZ5hbA2mCy2CJT2Pt+V+20fYnDmFidnusQhjkyrRw3EcdF2VKVxa7AS0wJ
         7XqPVc7D0m+26/eYa4h/To//5R39j58y3oIEXT1SV56mJShIN2QHexeokY7YDdtdY9bn
         OKgEIZUXW/0am0/3tRB2Ohh1NP7frGnWi60kr2EAU/oQDpvEKSXo95J9EzFdDvq8Dyxr
         Gz9JkbAsK3zIL9hXUqZZkth5yIasHY655pwbjGeV93OFPGyOGNWaCVW2TY3WzYLv9RLn
         wKrQ==
X-Gm-Message-State: AJIora/47BlRQEBT3JdWTUxN0PwR+9AdRfzB1FwrhY7TEaflET3wsWIN
        s/O8aPbzsA3rPikpR1pWeuojfGi7RqayRWXn8lsWzw==
X-Google-Smtp-Source: AGRyM1tCLsG24HvArA2qQ8N8ID4VHNuExsG9weA5PfeXAdVigd9V2muc6YeDqSqskiWnDsCe6UppeJ+sTve5pmlxZQw=
X-Received: by 2002:a81:1294:0:b0:313:f850:53b1 with SMTP id
 142-20020a811294000000b00313f85053b1mr6960671yws.181.1655230510732; Tue, 14
 Jun 2022 11:15:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1651774250.git.isaku.yamahata@intel.com> <98939c0ec83a109c8f49045e82096d6cdd5dafa3.1651774251.git.isaku.yamahata@intel.com>
In-Reply-To: <98939c0ec83a109c8f49045e82096d6cdd5dafa3.1651774251.git.isaku.yamahata@intel.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Tue, 14 Jun 2022 11:15:00 -0700
Message-ID: <CAAhR5DHPk2no0PVFX6P1NnZdwtVccjmdn4RLg4wKSmfpjD6Qkg@mail.gmail.com>
Subject: Re: [RFC PATCH v6 090/104] KVM: TDX: Handle TDX PV CPUID hypercall
To:     "Yamahata, Isaku" <isaku.yamahata@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Thu, May 5, 2022 at 11:16 AM <isaku.yamahata@intel.com> wrote:
>
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Wire up TDX PV CPUID hypercall to the KVM backend function.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 9c712f661a7c..c7cdfee397ec 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -946,12 +946,34 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
>         return 1;
>  }
>
> +static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
> +{
> +       u32 eax, ebx, ecx, edx;
> +
> +       /* EAX and ECX for cpuid is stored in R12 and R13. */
> +       eax = tdvmcall_a0_read(vcpu);
> +       ecx = tdvmcall_a1_read(vcpu);
> +
> +       kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, true);

According to the GHCI spec section 3.6
(TDG.VP.VMCALL<Instruction.CPUID>) we should return
VMCALL_INVALID_OPERAND if an invalid CPUID is requested.

kvm_cpuid already returns false in this case so we should use that
return value to set the tdvmcall return code in case of invalid leaf.
> +
> +       tdvmcall_a0_write(vcpu, eax);
> +       tdvmcall_a1_write(vcpu, ebx);
> +       tdvmcall_a2_write(vcpu, ecx);
> +       tdvmcall_a3_write(vcpu, edx);
> +
> +       tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_SUCCESS);
> +
> +       return 1;
> +}
> +
>  static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>  {
>         if (tdvmcall_exit_type(vcpu))
>                 return tdx_emulate_vmcall(vcpu);
>
>         switch (tdvmcall_leaf(vcpu)) {
> +       case EXIT_REASON_CPUID:
> +               return tdx_emulate_cpuid(vcpu);
>         default:
>                 break;
>         }
> --
> 2.25.1
>

Sagi
