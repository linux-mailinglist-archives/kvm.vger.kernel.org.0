Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3E7578D9B
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 00:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbiGRWhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 18:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiGRWht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 18:37:49 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3FD27B38
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 15:37:48 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id l11so23468840ybu.13
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 15:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1BNdWsaF3uahy5xNZXMoCLMmRQWlXmWwGVzk7t0GH80=;
        b=joRzGhYq+1nJo3rrtfk3XF7T69GtjNsF0UwsJyiQQMCjUQofTOPho/uMz2rroFejVa
         xbOSrEbrXEhg728DZ/iz0B0lI80WGdZO0VVivd+aYCllfIGdf/FY3zcxn9lxZb2apsup
         7tdZD/eJEa5i7cKRhq4iSpBit4SFWuLcX+MOji/pb1rgk1ecGxlH6q1QiAE4D9Ik+sU6
         EnZvJ1nm73KqCXEz+JNVwFyLJYbyTtR8b0NucNkY1TXXHWJGqqkQOkGYBdePxpzH6+6X
         eVY5tgoVGslnyQxoabJfzRYpxlBcMglFyNKoX0g0Mzg5k+47JIUqUIYvI/9wjuY7He8H
         /16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1BNdWsaF3uahy5xNZXMoCLMmRQWlXmWwGVzk7t0GH80=;
        b=nPgNbvYDrjpx2nqryriypbJCryA/YSXygAF5gHwJbOdLJmUwAPFz8we8a1P/zmcDw8
         D7wvbJkeoqFLnJMrIeCtfsCbMJvcZTNKDPlk5Z5Jg06jnuJZ5993GzCLzY1k+9Ml47gy
         oZeOhU7J85fj6IAhNW2xnAsLW2KCs3crWh1qIvOQpszqEHNcFI0FX8gtcIKJnDJb+qu0
         uM3IrHe+Pd0sI8taB6V8SZn9ArtbLcs/PAt/veOeY/4nzZA7Ea5JCeZV6EZqAYrkzs9j
         e+5LLatoD3LqD4GdNGiGW8qtgF7UI9EVG+4BqbeSIkekkktEv8jOIdWiXiTvmw9AB/Vr
         EC9Q==
X-Gm-Message-State: AJIora83QmtUR5HK9ErdOFHREtVVtfvYbP+aB8dcUDdFS4PZGO9iB1Qs
        +UDtzju3lTfeD+JVUdlWqtWb6aKw+EzvGDVFXAa/Gw==
X-Google-Smtp-Source: AGRyM1sYwn5En0zgTpktu7I/Hg6nJ8yQa4ZMwZHQNIF/QCoG6aD+McW8mOoEyev33/Zzw4fsuJSlsMK4QvpJiV9of5w=
X-Received: by 2002:a5b:3ce:0:b0:66f:4692:27a2 with SMTP id
 t14-20020a5b03ce000000b0066f469227a2mr29642799ybp.167.1658183867383; Mon, 18
 Jul 2022 15:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <98939c0ec83a109c8f49045e82096d6cdd5dafa3.1651774251.git.isaku.yamahata@intel.com>
 <CAAhR5DHPk2no0PVFX6P1NnZdwtVccjmdn4RLg4wKSmfpjD6Qkg@mail.gmail.com> <20220629101356.GA882746@ls.amr.corp.intel.com>
In-Reply-To: <20220629101356.GA882746@ls.amr.corp.intel.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Mon, 18 Jul 2022 15:37:35 -0700
Message-ID: <CAAhR5DF82HO4yEmOjywXXR-_wcXT7hctib2yfRaS-nb6sGPsLw@mail.gmail.com>
Subject: Re: [RFC PATCH v6 090/104] KVM: TDX: Handle TDX PV CPUID hypercall
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 3:14 AM Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
>
> On Tue, Jun 14, 2022 at 11:15:00AM -0700,
> Sagi Shahar <sagis@google.com> wrote:
>
> > On Thu, May 5, 2022 at 11:16 AM <isaku.yamahata@intel.com> wrote:
> > >
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >
> > > Wire up TDX PV CPUID hypercall to the KVM backend function.
> > >
> > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > ---
> > >  arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++++++++
> > >  1 file changed, 22 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index 9c712f661a7c..c7cdfee397ec 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -946,12 +946,34 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
> > >         return 1;
> > >  }
> > >
> > > +static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
> > > +{
> > > +       u32 eax, ebx, ecx, edx;
> > > +
> > > +       /* EAX and ECX for cpuid is stored in R12 and R13. */
> > > +       eax = tdvmcall_a0_read(vcpu);
> > > +       ecx = tdvmcall_a1_read(vcpu);
> > > +
> > > +       kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, true);
> >
> > According to the GHCI spec section 3.6
> > (TDG.VP.VMCALL<Instruction.CPUID>) we should return
> > VMCALL_INVALID_OPERAND if an invalid CPUID is requested.
> >
> > kvm_cpuid already returns false in this case so we should use that
> > return value to set the tdvmcall return code in case of invalid leaf.
>
> Based on CPUID instruction, cpuid results in #UD when lock prefix is used or
> earlier CPU that doesn't support cpuid instruction.
> So I'm not sure what CPUID input result in INVALID_OPERAND error.
> Does the following make sense for you?
>
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1347,7 +1347,7 @@ static int tdx_emulate_cpuid(struct kvm_vcpu *vcpu)
>         eax = tdvmcall_a0_read(vcpu);
>         ecx = tdvmcall_a1_read(vcpu);
>
> -       kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, true);
> +       kvm_cpuid(vcpu, &eax, &ebx, &ecx, &edx, false);
>
>         tdvmcall_a0_write(vcpu, eax);
>         tdvmcall_a1_write(vcpu, ebx);
>
> thanks,

If any CPUID request is considered valid, then perhaps the spec itself
needs to be updated.

Right now it clearly states that TDG.VP.VMCALL_INVALID_OPERAND is
returned if "Invalid CPUID requested" which I understood as a
non-existing leaf. But if you say that a non-existing leaf is still a
valid CPUID request than I'm not sure what "Invalid CPUID requested"
means in the spec itself.

>
> --
> Isaku Yamahata <isaku.yamahata@gmail.com>
