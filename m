Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9E86697F1
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 14:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241338AbjAMNE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 08:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240603AbjAMNDP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 08:03:15 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61AC55BA1B;
        Fri, 13 Jan 2023 04:47:31 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id bp15so32954080lfb.13;
        Fri, 13 Jan 2023 04:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IEq2QVvNTIs2aFvCR54FRAq229D98dMIY7JkgaeUBBI=;
        b=GlwGrViS6nigmIVsVN4sXo0B6eP6OnwLnKq8QZ6E+yYLN6xPA4q6tcDxqCGwhHgkUF
         n0crzJwG2QLVLBHUeY9ptDz1Wn+65NsgcsghuZR50x+Xp97xr5ZhsavYhPK3YWJmkvRQ
         UMaW72DHodER+1guniKWo6sEtG+rZ+/mOtrjhgrvM/uGm6siDjobh2NCF6sDmEbbqnvD
         TAIQL08rRKSTrE3bNeS+ZsKVtVAQrjsO4p44nj60Sl8YnuFJZof7ixI7XSh5sodZs3QO
         1JtLoK/n2LuAQ/KFw3E+gXVKGIlxC6lhXBUIcR/vsR8GvKL+xdaubcC4GjkHtD9NiScN
         t/Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IEq2QVvNTIs2aFvCR54FRAq229D98dMIY7JkgaeUBBI=;
        b=p5+hCqAOf6jlhhMeUxferkazEnXsL3fatoi2pUcry5GirDPhOJAHCmoWNRJ20PILHI
         ynvPSZevKxCsJZJBOQDRc14hl9d5f3bBpIaKHztONjYLn9cyQL4WZWnNuHYvhTovRnqg
         uWm5E1ZzzGA4Nc63GNLFQIqSMdAqNseABhSe3yLAuy9vgxpAMc3P5RQdP0JSLtSVyRvM
         iuH8umNvoFSZ/1JtHorUTPLACyW57iHifo6gUePhC5JQZGkF98H2VNJTSX2gXUJxKBQ8
         o4zaM+eimsx5Oyu+teOfX08Ip64jqQR1vgwjgpLyykpicoKTIfJk/2Pv4ohkYqQ8WIyG
         kVQg==
X-Gm-Message-State: AFqh2kqUafTHaKxqASGuczzsSVMBWOjVrI1lCOUMOWAUDyulwz4z0SvR
        NUzpLAPlcqDzwDjC7lp5Qpc=
X-Google-Smtp-Source: AMrXdXtZzNTVb98//F8BC8feIfDYHihih8IYihAI8Ege1urRyrRZG+CW9oviZ7S2uKh5ExKe3s31ng==
X-Received: by 2002:a05:6512:b9b:b0:4cc:98fe:191b with SMTP id b27-20020a0565120b9b00b004cc98fe191bmr887268lfv.5.1673614034287;
        Fri, 13 Jan 2023 04:47:14 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id o16-20020ac24e90000000b004b5323639d8sm3834569lfr.155.2023.01.13.04.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 04:47:14 -0800 (PST)
Date:   Fri, 13 Jan 2023 14:47:12 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 013/113] x86/cpu: Add helper functions to
 allocate/free TDX private host key id
Message-ID: <20230113144712.00006f41@gmail.com>
In-Reply-To: <241994f1f6782753f3307fe999a3dad434477c16.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <241994f1f6782753f3307fe999a3dad434477c16.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 08:31:21 -0800
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDX private host key id (HKID) is assigned to guest TD.  The memory
> controller encrypts guest TD memory with the assigned TDX HKID.  Add
> helper functions to allocate/free TDX private HKID so that TDX KVM can
> manage it.
> 
> Also export the global TDX private HKID that is used to encrypt TDX
> module, its memory and some dynamic data (TDR).  When VMM releasing
> encrypted page to reuse it, the page needs to be flushed with the used
> HKID.  VMM needs the global TDX private HKID to flush such pages.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/tdx.h  | 12 ++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.c | 35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 0f71d3856ede..ed9cf61ff8b4 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -107,11 +107,23 @@ static inline long tdx_kvm_hypercall(unsigned int
> nr, unsigned long p1, #ifdef CONFIG_INTEL_TDX_HOST
>  bool platform_tdx_enabled(void);
>  int tdx_enable(void);
> +/*
> + * Key id globally used by TDX module: TDX module maps TDR with this
> TDX global
> + * key id.  TDR includes key id assigned to the TD.  Then TDX module
> maps other
> + * TD-related pages with the assigned key id.  TDR requires this TDX
> global key
> + * id for cache flush unlike other TD-related pages.
> + */
> +extern u32 tdx_global_keyid __read_mostly;
> +int tdx_keyid_alloc(void);
> +void tdx_keyid_free(int keyid);
> +
>  u64 __seamcall(u64 op, u64 rcx, u64 rdx, u64 r8, u64 r9,
>  	       struct tdx_module_output *out);
>  #else	/* !CONFIG_INTEL_TDX_HOST */
>  static inline bool platform_tdx_enabled(void) { return false; }
>  static inline int tdx_enable(void)  { return -EINVAL; }
> +static inline int tdx_keyid_alloc(void) { return -EOPNOTSUPP; }
> +static inline void tdx_keyid_free(int keyid) { }
>  #endif	/* CONFIG_INTEL_TDX_HOST */
>  
>  #endif /* !__ASSEMBLY__ */
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index eba7e62cebec..d18ab5c4d447 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -51,6 +51,10 @@ static DEFINE_MUTEX(tdx_module_lock);
>  /* All TDX-usable memory regions */
>  static LIST_HEAD(tdx_memlist);
>  
> +/* TDX module global KeyID.  Used in TDH.SYS.CONFIG ABI. */
> +u32 tdx_global_keyid __read_mostly;
> +EXPORT_SYMBOL_GPL(tdx_global_keyid);
> +
>  /*
>   * tdx_keyid_start and nr_tdx_keyids indicate that TDX is uninitialized.
>   * This is used in TDX initialization error paths to take it from
> @@ -132,6 +136,31 @@ static struct notifier_block tdx_memory_nb = {
>  	.notifier_call = tdx_memory_notifier,
>  };
>  
> +/* TDX KeyID pool */
> +static DEFINE_IDA(tdx_keyid_pool);
> +
> +int tdx_keyid_alloc(void)
> +{
> +	if (WARN_ON_ONCE(!tdx_keyid_start || !nr_tdx_keyids))
> +		return -EINVAL;

Better mention that tdx_keyid_start and nr_tdx_keyids are defined in
another patches.

> +
> +	/* The first keyID is reserved for the global key. */
> +	return ida_alloc_range(&tdx_keyid_pool, tdx_keyid_start + 1,
> +			       tdx_keyid_start + nr_tdx_keyids - 1,
> +			       GFP_KERNEL);
> +}
> +EXPORT_SYMBOL_GPL(tdx_keyid_alloc);
> +
> +void tdx_keyid_free(int keyid)
> +{
> +	/* keyid = 0 is reserved. */
> +	if (WARN_ON_ONCE(keyid <= 0))
> +		return;
> +
> +	ida_free(&tdx_keyid_pool, keyid);
> +}
> +EXPORT_SYMBOL_GPL(tdx_keyid_free);
> +
>  static int __init tdx_init(void)
>  {
>  	int err;
> @@ -1161,6 +1190,12 @@ static int init_tdx_module(void)
>  	if (ret)
>  		goto out_free_pamts;
>  
> +	/*
> +	 * Reserve the first TDX KeyID as global KeyID to protect
> +	 * TDX module metadata.
> +	 */
> +	tdx_global_keyid = tdx_keyid_start;
> +
>  	/* Initialize TDMRs to complete the TDX module initialization */
>  	ret = init_tdmrs(&tdmr_list);
>  	if (ret)

