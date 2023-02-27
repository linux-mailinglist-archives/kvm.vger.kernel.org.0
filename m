Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A216D6A4FA9
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 00:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjB0XbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 18:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjB0XbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 18:31:00 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A82C1C7E0;
        Mon, 27 Feb 2023 15:30:59 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id bh1so8539989plb.11;
        Mon, 27 Feb 2023 15:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=emzKQEZEK1f8jAf8bULtQV5jNFQ3wM/05AWToSpzXYM=;
        b=FOAYuX9TWAHLeXJBAN0GZUx8AYuIU70g/AhZ1+jf0uzNA/2+DaJdrgrM8Ws4G99vuD
         r6N2rk6lpZjYdouI+XnvtqdZUMAlHa4ViF1RBPYGjcn9hmP66LCmh6bGOBxUfM1Cf2lT
         FIW2AliSn8KC3wQnprOtXk5p7MR5VYbg94hc2dq+8kbSNKDomPedbYrS3WaSQ+8MiRjK
         42NX5C1RblWOJZTuCo8rDGaLc6BQE2qqM2s7pWwohFmjXV2TIVBtyo2c1dkIdq2jWT73
         cifTJrFxXxtIAM1xKhS5MjUFEHY7BmVXLi6DnSXAHCbGySLW3F0krkXBTuVrE1QmaJA2
         5PRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=emzKQEZEK1f8jAf8bULtQV5jNFQ3wM/05AWToSpzXYM=;
        b=xzURQr6U6MVGIywl9YmBgN+Is5G52bsP2m0YqDZa0sAM72kbgwo/hM4bkfFoPdR2j9
         w7VpG/T5jQ0DjYyKuREbv70voyI3RoNUbUsri131+Q6eSZcGh0OmbJ9cqEkXe4mZgfT1
         1bAV5hHTiK5sXaF3l5rDqlMleK1bgIMVWm0I/bCxlX6kXumhu36rvnamTWxw4nTm5o9e
         OgM32er4UbblxExsj1FFZLRhdHc4P9mkYCWlN9TxEKB+eCJQeTa+b9HHvzrbfv+5lumz
         fMgrQWxKXMznvBKrWZKX5kBDvuw8zCvDKElDJEgM8UwE8JI8RoBwFdM+AgkNiVQt7LOm
         VumA==
X-Gm-Message-State: AO0yUKU3Q+JwcT1YuN4lxXXaAo0tJyngV7Ic+tIu/JSSGRQS/IYyftN9
        qXuClScCJ8dztJm3JbFJG7s=
X-Google-Smtp-Source: AK7set//Dgr8W+5J/yRWe2lIxX5azB3y8WUjSkhLhZzznPGm1IKUKVQdowz65usft+svvgLfM99EvA==
X-Received: by 2002:a05:6a20:29a9:b0:cc:ba66:88a1 with SMTP id f41-20020a056a2029a900b000ccba6688a1mr892391pzh.60.1677540658774;
        Mon, 27 Feb 2023 15:30:58 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id d18-20020aa78152000000b00590ede84b1csm4882437pfn.147.2023.02.27.15.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 15:30:57 -0800 (PST)
Date:   Mon, 27 Feb 2023 15:30:56 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
Subject: Re: [PATCH v11 058/113] KVM: TDX: MTRR: implement get_mt_mask() for
 TDX
Message-ID: <20230227233056.GT4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <21e0d94ccf2fd3d766d6aa7b45441791c04e5e4f.1673539699.git.isaku.yamahata@intel.com>
 <1a32f2570f13fa0125ddbbceeabcd36fc4beb9db.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1a32f2570f13fa0125ddbbceeabcd36fc4beb9db.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 17, 2023 at 03:11:46AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Thu, 2023-01-12 at 08:32 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Although TDX supports only WB for private GPA, MTRR/PAT for shared GPA
> > should be supported. Implement get_mt_mask() following vmx case.
> 
> By far this is the first patch to handle MTRR/PAT.  There's absolutely no
> background have been explained.
> 
> So what about MTRR/PAT related MSRs handling?  No code needed to handle?
> 
> I was expecting there should be at least some words here to explain how TDX
> handles them, and if no handling is required in KVM, why.
> 
> W/o those, I don't think this patch is reviewable.  

I've updated the commit message.


> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/vmx/main.c    | 10 +++++++++-
> >  arch/x86/kvm/vmx/tdx.c     | 19 +++++++++++++++++++
> >  arch/x86/kvm/vmx/x86_ops.h |  2 ++
> >  3 files changed, 30 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 770d1b29d1c3..4319f6d7a4da 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -158,6 +158,14 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> >  	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
> >  }
> >  
> > +static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > +{
> > +	if (is_td_vcpu(vcpu))
> > +		return tdx_get_mt_mask(vcpu, gfn, is_mmio);
> > +
> > +	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
> > +}
> > +
> >  static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
> >  {
> >  	if (!is_td(kvm))
> > @@ -267,7 +275,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >  
> >  	.set_tss_addr = vmx_set_tss_addr,
> >  	.set_identity_map_addr = vmx_set_identity_map_addr,
> > -	.get_mt_mask = vmx_get_mt_mask,
> > +	.get_mt_mask = vt_get_mt_mask,
> >  
> >  	.get_exit_info = vmx_get_exit_info,
> >  
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index e68816999387..c4c5a8f786c1 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -309,6 +309,25 @@ int tdx_vm_init(struct kvm *kvm)
> >  	return 0;
> >  }
> >  
> > +u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > +{
> > +	/* TDX private GPA is always WB. */
> > +	if (gfn & kvm_gfn_shared_mask(vcpu->kvm)) {
> 
> First of all, private GPA doesn't have 'shared bit' set, so comment  doesn't
> reflect code.
> 
> Secondly (and again), IIUC the shared bit of the gfn has been stripped out long
> time ago, so this is incorrect.
> 
> Please don't sliently ignore other people's comment:
> 
> https://lore.kernel.org/lkml/Y19NzlQcwhV%2F2wl3@debian.me/T/#mf319d5b718519709362f9f094bfc5b53fd870241

Make the logic common for vmx and tdx. the difference is to check cr0.cd.

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
