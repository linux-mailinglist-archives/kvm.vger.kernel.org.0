Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3997F4E57E3
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 18:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244724AbiCWRz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 13:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234034AbiCWRz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 13:55:27 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44111B7D8;
        Wed, 23 Mar 2022 10:53:52 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso2568836pjb.5;
        Wed, 23 Mar 2022 10:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=av3oVTkIuwelRb9H5lhGzDrkVDnLj9TLsCFgqEGBm3c=;
        b=nc042apVOa/LPU90QaefUbTbXVcxNcYhxef20yaJri9DYzk5KjZyCYFhFzV5HSeJY0
         GbjKDOeKzgXufOPBUPQikaXjZM4KsvVmrY//P3Lbyg4g1Kf0zRPJk31rA/c/7g1mBlEA
         BSDnY5k4WtMcxH+cbQuAMifTDFN25f8iVglUiDfQZjUUNOQyjDPdlRCDadw38jAE4EAW
         di8V6uxednFOWFHWlDaQi54GWtzxf8d97d/r7QguBDTudmaZhqyfL7BpWqZ6EZP6mfev
         ax85S7N/bmznNFwyv5+aARRMOUqb3IUFA3B1ihvzaGyGKXHtL0BtBqLEGU/C017eu8//
         AjOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=av3oVTkIuwelRb9H5lhGzDrkVDnLj9TLsCFgqEGBm3c=;
        b=3V7hZYnmiIIhKg1CDP/EAwTkcZJUvsfBrBqkimlbDB3wjd+RIGbJPg14naoii+RDMt
         8H9waH2o7ND8X4QG3sa04ZVXoNA/IqjDzzoQdPaQXmzJji+blUNkihEbFsSiLVlPmiAe
         DXKDAymz3S830CNbA+uTVxbhaa9wZp1TI75TO+UmzDxvaDbaKxwJ5Qna+mKJtvoNbTEg
         8bLjSZ43MG1Owxv3tNA7RY+S4r/Eupj+D6vaxe7qE0bIQDHKZd/wD5IzvkXGbj74dN0R
         wfNF+acs7/3dhDAcQWPc2wi3fcVyyUM6gJZERbc7hJpW0KDyXnAujK5vifbNKFKySfYL
         2D8w==
X-Gm-Message-State: AOAM533OfHPSH1e4KMzcLOejfTnRj60+lGM1B5v5up9Lb2K9ECcE2YUh
        iKHGmheWpWkSpdxItI6vahbIvMwFbUx1lw==
X-Google-Smtp-Source: ABdhPJwtek/jzM+i/NJAZJiG4Q0/h0XtOVsWkXP6Z2u1dbugLKkEqG75TZ4D62RL+m8bI88br8iQwQ==
X-Received: by 2002:a17:902:ea0c:b0:154:16a6:7025 with SMTP id s12-20020a170902ea0c00b0015416a67025mr1332608plg.104.1648058032076;
        Wed, 23 Mar 2022 10:53:52 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id s30-20020a056a001c5e00b004f73f27aa40sm515081pfw.161.2022.03.23.10.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 10:53:51 -0700 (PDT)
Date:   Wed, 23 Mar 2022 10:53:49 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 083/104] KVM: x86: Split core of hypercall
 emulation to helper function
Message-ID: <20220323175349.GF1964605@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <f3293bd872a916bf33165a2ec0d6fc50533b817f.1646422845.git.isaku.yamahata@intel.com>
 <CAAhR5DFPsmxYXXXZ9WNW=MDWRRz5jrntPvsnKw7VTrRh5CbohQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhR5DFPsmxYXXXZ9WNW=MDWRRz5jrntPvsnKw7VTrRh5CbohQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 21, 2022 at 11:32:21AM -0700,
Sagi Shahar <sagis@google.com> wrote:

> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 314ae43e07bf..9acb33a17445 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9090,26 +9090,15 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
> >         return kvm_skip_emulated_instruction(vcpu);
> >  }
> >
> > -int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> > +unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> > +                                     unsigned long a0, unsigned long a1,
> > +                                     unsigned long a2, unsigned long a3,
> > +                                     int op_64_bit)
> >  {
> > -       unsigned long nr, a0, a1, a2, a3, ret;
> > -       int op_64_bit;
> > -
> > -       if (kvm_xen_hypercall_enabled(vcpu->kvm))
> > -               return kvm_xen_hypercall(vcpu);
> > -
> > -       if (kvm_hv_hypercall_enabled(vcpu))
> > -               return kvm_hv_hypercall(vcpu);
> > -
> > -       nr = kvm_rax_read(vcpu);
> > -       a0 = kvm_rbx_read(vcpu);
> > -       a1 = kvm_rcx_read(vcpu);
> > -       a2 = kvm_rdx_read(vcpu);
> > -       a3 = kvm_rsi_read(vcpu);
> > +       unsigned long ret;
> >
> >         trace_kvm_hypercall(nr, a0, a1, a2, a3);
> >
> > -       op_64_bit = is_64_bit_hypercall(vcpu);
> >         if (!op_64_bit) {
> >                 nr &= 0xFFFFFFFF;
> >                 a0 &= 0xFFFFFFFF;
> > @@ -9118,11 +9107,6 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >                 a3 &= 0xFFFFFFFF;
> >         }
> >
> > -       if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
> > -               ret = -KVM_EPERM;
> > -               goto out;
> > -       }
> > -
> >         ret = -KVM_ENOSYS;
> >
> >         switch (nr) {
> > @@ -9181,6 +9165,34 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >                 ret = -KVM_ENOSYS;
> >                 break;
> >         }
> > +       return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
> > +
> > +int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> > +{
> > +       unsigned long nr, a0, a1, a2, a3, ret;
> > +       int op_64_bit;
> > +
> > +       if (kvm_xen_hypercall_enabled(vcpu->kvm))
> > +               return kvm_xen_hypercall(vcpu);
> > +
> > +       if (kvm_hv_hypercall_enabled(vcpu))
> > +               return kvm_hv_hypercall(vcpu);
> > +
> > +       nr = kvm_rax_read(vcpu);
> > +       a0 = kvm_rbx_read(vcpu);
> > +       a1 = kvm_rcx_read(vcpu);
> > +       a2 = kvm_rdx_read(vcpu);
> > +       a3 = kvm_rsi_read(vcpu);
> > +       op_64_bit = is_64_bit_mode(vcpu);
> 
> I think this should be "op_64_bit = is_64_bit_hypercall(vcpu);"
> is_64_bit_mode was replaced with is_64_bit_hypercall to support
> protected guests here:
> https://lore.kernel.org/all/87cztf8h43.fsf@vitty.brq.redhat.com/T/
> 
> Without it, op_64_bit will be set to 0 for TD VMs which will cause the
> upper 32 bit of the registers to be cleared in __kvm_emulate_hypercall

Oops, thanks for pointing it out.  I'll fix it up with next respin.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
