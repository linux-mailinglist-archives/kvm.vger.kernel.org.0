Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014BB4F8BC9
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbiDHA6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 20:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiDHA6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 20:58:20 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B650198ED6;
        Thu,  7 Apr 2022 17:56:18 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w7so7030637pfu.11;
        Thu, 07 Apr 2022 17:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gYy1RY/9HkfjcF3Ldhjsvsm+TQLUoZ8H3KH69eKqzfo=;
        b=TOdZwlMcc2cGURTj7ApxQ973uSCng4g7kGVT1kCxEWBVFs1VrJtvFdzkvOW42Oc0ZZ
         B0IiaMFXLaL3gkrOrj3CmLR4S6+OqJbws8ZJMSs6kJYLcrRF+ZwR5RBvCZ4YBwEacVsf
         gyVLCuEKoAxV87iifCy8kpAPDbBrDrCdyUhUxPJsIzZ3ptRWrirwqdi++7U/0qj04ECk
         BH7AOZeAa+ZMenTvCU6aLxjm38l+FGOnxtx3iHasfsDVcmucJExoxuTTuntRZAsXIwA5
         RkQKTp+OLcAm6o58PqTit5qvPB2WKF/J9tMsLvRKC3P2Eo1Y2RVrFdUL7wcDXznxii+x
         q6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gYy1RY/9HkfjcF3Ldhjsvsm+TQLUoZ8H3KH69eKqzfo=;
        b=OQKqB9mBBmG4F3HQaYTInQLQfphTPqgChV1fWMFJ8Cesb4yjlSLpgh6Q6XQDfD4ptx
         6EMcloK5ifqefcyBO9SbTjdjozUpmOilpFeceC6/QOOipKkyUPHIvumLS12uCekmZ956
         Guk8n2fa+m6mt+d7wU5tQQRsDO/aL0yTij/J0Z/V4a9bluaN/0oR02orghtdyxiDGOoD
         qm5DWqw38IfIDQk6UXxN6WJ682Hk3PZIXjxONUI0NgtN1xJSBa47LCIy+MLhzvDE6dP3
         t/RWOhf+QCxSjW319tziICpDWl/JutTtKqYHH+xoiJctCiTyp5BwBDGRGfNyXzQyID/1
         qUtQ==
X-Gm-Message-State: AOAM531c4qkg9JXbIELYIpNf4yia6PaXnQoyGjBvfAHA6K+t4vDu/VPl
        ubculKfjassgZdbKgpCgYTTPgBT5e48=
X-Google-Smtp-Source: ABdhPJwkQXo6O5M7p/yXjDM2BYRQgPCyP295kWZzT+kCVWz6lHa/OVbBCnUOWeZ2vATECieK7Cm6SQ==
X-Received: by 2002:a05:6a00:3406:b0:505:7a1c:c553 with SMTP id cn6-20020a056a00340600b005057a1cc553mr1312631pfb.2.1649379377936;
        Thu, 07 Apr 2022 17:56:17 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090a890c00b001b8efcf8e48sm9798997pjn.14.2022.04.07.17.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 17:56:17 -0700 (PDT)
Date:   Thu, 7 Apr 2022 17:56:16 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 025/104] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
Message-ID: <20220408005616.GC2864606@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <156ab9c6979c4b70e3d0d76e55e3aba370f58cea.1646422845.git.isaku.yamahata@intel.com>
 <9c6e6892-7c0c-124c-b534-8b7c3c6dafb5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9c6e6892-7c0c-124c-b534-8b7c3c6dafb5@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 05, 2022 at 02:50:29PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Add a place holder function for TDX specific VM-scoped ioctl as mem_enc_op.
> > TDX specific sub-commands will be added to retrieve/pass TDX specific
> > parameters.
> > 
> > KVM_MEMORY_ENCRYPT_OP was introduced for VM-scoped operations specific for
> > guest state-protected VM.  It defined subcommands for technology-specific
> > operations under KVM_MEMORY_ENCRYPT_OP.  Despite its name, the subcommands
> > are not limited to memory encryption, but various technology-specific
> > operations are defined.  It's natural to repurpose KVM_MEMORY_ENCRYPT_OP
> > for TDX specific operations and define subcommands.
> > 
> > TDX requires VM-scoped, and VCPU-scoped TDX-specific operations for device
> > model, for example, qemu.  Getting system-wide parameters, TDX-specific VM
> > initialization, and TDX-specific vCPU initialization.  Which requires KVM
> > vCPU-scoped operations in addition to the existing VM-scoped operations.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/include/uapi/asm/kvm.h       | 11 +++++++++++
> >   arch/x86/kvm/vmx/main.c               | 10 ++++++++++
> >   arch/x86/kvm/vmx/tdx.c                | 24 ++++++++++++++++++++++++
> >   arch/x86/kvm/vmx/x86_ops.h            |  4 ++++
> >   tools/arch/x86/include/uapi/asm/kvm.h | 11 +++++++++++
> >   5 files changed, 60 insertions(+)
> > 
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 71a5851475e7..2ad61caf4e0b 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -528,4 +528,15 @@ struct kvm_pmu_event_filter {
> >   #define KVM_X86_DEFAULT_VM	0
> >   #define KVM_X86_TDX_VM		1
> > +/* Trust Domain eXtension sub-ioctl() commands. */
> > +enum kvm_tdx_cmd_id {
> > +	KVM_TDX_CMD_NR_MAX,
> > +};
> > +
> > +struct kvm_tdx_cmd {
> > +	__u32 id;
> > +	__u32 metadata;
> > +	__u64 data;
> > +};
> 
> Please include some initial documentation here already, for example it is
> not clear what "metadata" is.
> 
> Also please add
> 
> 	u32 error;
> 	u32 unused;
> 
> for two reasons: 1) consistency with kvm_sev_cmd 2) error codes should be
> returned to userspace and not just sent through pr_tdx_error.

Sure.
For now metadata is only used to specify flags specific to id.
So I'll rename it to flags.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
