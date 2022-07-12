Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBEA570F28
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 03:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiGLBBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 21:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiGLBBS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 21:01:18 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08FC7286C9;
        Mon, 11 Jul 2022 18:01:18 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id y14-20020a17090a644e00b001ef775f7118so9912803pjm.2;
        Mon, 11 Jul 2022 18:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bvp3wu4wvbE8hhMk+DgAvueV8tuT4a+wJKMjNTMnRM0=;
        b=bBl+bfRtZ/ZRnREkYT+fEDLVy8MHBJPvknPsTKNhltAj2rX1WQTUN1CfSOajfG1AgS
         JIpgwy1kbwwu8UK1PAOcNtGxtJbcU5EZrWzYqpJLYdnzQDpFBBSwOGrzw8HoZoPTLtrO
         oYeBloFyP+1HnqwiGnlluEHORjDOAPkmzYJZhu/DHHbimeTfzi42N+xVMbyPV8oSX9co
         4w9civRIcHMdxWi+7/5gA3lt4sUz9tIVYv6sV6i2fY9eD/+AvHZer7kcPgWCKhQdT9J0
         KtSDeuc8t8nVNV/OW+6vvQZk2Yd0kbxutmuHIHUs2m2/YUsIkvhVRV9fjy08hPbwG5Wc
         Gisg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bvp3wu4wvbE8hhMk+DgAvueV8tuT4a+wJKMjNTMnRM0=;
        b=H0qetRe3HOllaOH19g8nMgOqkT7tXVpnb6I88O/MPIkUP+9vOMWOdb2KP51lrhKQ76
         zDZEJBlpaw5cBPRBnnV4c3X/WZ/jki7EStRJJePI3rauwHzBWZJZD77ouprAt6Ppvlyb
         5NvZLjkxRUoisGJgihQDMIQrZ9YN1UR1CoUXChDArDUryJ1R3NTv0kMvi3I2004wAUEq
         aijqa8M7YwPUKDy9BvhLNBRgnLqSlY0NKErmfJnq3rWSXEVJE+sxtKCcLICby176U7Mr
         6RHYCS7AgxPe7Do5z/0JHTlyJ6ZBdQxOQTv6RXc5gR6EdpR8nMcV6mged3duwqLYe0DW
         jtcA==
X-Gm-Message-State: AJIora/8aXu2aGCil1U8alVQMd3l8A/Je8lfgQghRAjxCFWyypqYn7Tr
        fi3/0q/+FxMnZg9dVuExxe8=
X-Google-Smtp-Source: AGRyM1vC91h0jT4qKOlk4wLtW7UBF2WYLP90yacuKU8RGsXRiO/oP/4iMOCLGbasYWtKcS5yDCFOKQ==
X-Received: by 2002:a17:90b:c89:b0:1ef:b042:e618 with SMTP id o9-20020a17090b0c8900b001efb042e618mr1280703pjz.70.1657587677375;
        Mon, 11 Jul 2022 18:01:17 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id p3-20020a62d003000000b0052ab5d2d398sm5390494pfg.47.2022.07.11.18.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 18:01:16 -0700 (PDT)
Date:   Mon, 11 Jul 2022 18:01:15 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v7 012/102] KVM: x86: Introduce vm_type to differentiate
 default VMs from confidential VMs
Message-ID: <20220712010115.GE1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <5979d880dc074c7fa57e02da34a41a6905ebd89d.1656366338.git.isaku.yamahata@intel.com>
 <3c5d4e38b631a921006e44551fe1249339393e41.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3c5d4e38b631a921006e44551fe1249339393e41.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 02:52:28PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > Unlike default VMs, confidential VMs (Intel TDX and AMD SEV-ES) don't allow
> > some operations (e.g., memory read/write, register state access, etc).
> > 
> > Introduce vm_type to track the type of the VM to x86 KVM.  Other arch KVMs
> > already use vm_type, KVM_INIT_VM accepts vm_type, and x86 KVM callback
> > vm_init accepts vm_type.  So follow them.  Further, a different policy can
> > be made based on vm_type.  Define KVM_X86_DEFAULT_VM for default VM as
> > default and define KVM_X86_TDX_VM for Intel TDX VM.  The wrapper function
> > will be defined as "bool is_td(kvm) { return vm_type == VM_TYPE_TDX; }"
> > 
> > Add a capability KVM_CAP_VM_TYPES to effectively allow device model,
> > e.g. qemu, to query what VM types are supported by KVM.  This (introduce a
> > new capability and add vm_type) is chosen to align with other arch KVMs
> > that have VM types already.  Other arch KVMs uses different name to query
> > supported vm types and there is no common name for it, so new name was
> > chosen.
> > 
> > Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  Documentation/virt/kvm/api.rst        | 21 +++++++++++++++++++++
> >  arch/x86/include/asm/kvm-x86-ops.h    |  1 +
> >  arch/x86/include/asm/kvm_host.h       |  2 ++
> >  arch/x86/include/uapi/asm/kvm.h       |  3 +++
> >  arch/x86/kvm/svm/svm.c                |  6 ++++++
> >  arch/x86/kvm/vmx/main.c               |  1 +
> >  arch/x86/kvm/vmx/tdx.h                |  6 +-----
> >  arch/x86/kvm/vmx/vmx.c                |  5 +++++
> >  arch/x86/kvm/vmx/x86_ops.h            |  1 +
> >  arch/x86/kvm/x86.c                    |  9 ++++++++-
> >  include/uapi/linux/kvm.h              |  1 +
> >  tools/arch/x86/include/uapi/asm/kvm.h |  3 +++
> >  tools/include/uapi/linux/kvm.h        |  1 +
> >  13 files changed, 54 insertions(+), 6 deletions(-)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 9cbbfdb663b6..b9ab598883b2 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -147,10 +147,31 @@ described as 'basic' will be available.
> >  The new VM has no virtual cpus and no memory.
> >  You probably want to use 0 as machine type.
> >  
> > +X86:
> > +^^^^
> > +
> > +Supported vm type can be queried from KVM_CAP_VM_TYPES, which returns the
> > +bitmap of supported vm types. The 1-setting of bit @n means vm type with
> > +value @n is supported.
> 
> 
> Perhaps I am missing something, but I don't understand how the below changes
> (except the x86 part above) in Documentation are related to this patch.

This is to summarize divergence of archs.  Those archs (s390, mips, and
arm64) introduce essentially same KVM capabilities, but different names. This
patch makes things worse.  So I thought it's good idea to summarize it. Probably
this documentation part can be split out into its own patch. thoughts?


> > diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> > index 54d7a26ed9ee..2f43db5bbefb 100644
> > --- a/arch/x86/kvm/vmx/tdx.h
> > +++ b/arch/x86/kvm/vmx/tdx.h
> > @@ -17,11 +17,7 @@ struct vcpu_tdx {
> >  
> >  static inline bool is_td(struct kvm *kvm)
> >  {
> > -	/*
> > -	 * TDX VM type isn't defined yet.
> > -	 * return kvm->arch.vm_type == KVM_X86_TDX_VM;
> > -	 */
> > -	return false;
> > +	return kvm->arch.vm_type == KVM_X86_TDX_VM;
> >  }
> 
> If you put this patch before patch:
> 
> 	[PATCH v7 009/102] KVM: TDX: Add placeholders for TDX VM/vcpu structure
> 
> Then you don't need to introduce this chunk in above patch and then remove it
> here, which is unnecessary and ugly.
> 
> And you can even only introduce KVM_X86_DEFAULT_VM but not KVM_X86_TDX_VM in
> this patch, so you can make this patch as a infrastructural patch to report VM
> type.  The KVM_X86_TDX_VM can come with the patch where is_td() is introduced
> (in your above patch 9).  
> 
> To me, it's more clean way to write patch.  For instance, this infrastructural
> patch can be theoretically used by other series if they have similar thing to
> support, but doesn't need to carry is_td() and KVM_X86_TDX_VM burden that you
> made.

There are two choices. One is to put this patch before 9 as you suggested, other
is to  put it here right before the patch 13 that uses vm_type_supported().

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
