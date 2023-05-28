Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F6E71380F
	for <lists+kvm@lfdr.de>; Sun, 28 May 2023 08:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjE1GKs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 May 2023 02:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjE1GKq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 May 2023 02:10:46 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D67CD8;
        Sat, 27 May 2023 23:10:45 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b01bd7093aso10263255ad.1;
        Sat, 27 May 2023 23:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685254245; x=1687846245;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xjbuJACxE78nceTqHgAJTs0Qk225dErZdIVdFRgaZoM=;
        b=bjkO6JrkbuklVBIaOoD2J9EKHnzG/mZBOCTEraV2XKf9cHYqVs8Fzfkc/fZLBuObe4
         vk3E3XwbH+XJbuPiPh5Qbudl4LsPHQcHBsXbi4ZygeR9ZJ3qYegIQ7CMYmjLjBG1exA4
         ttkMfLDM5vig21AfgLOQjUaOffGZJlEad7kjj8HFnbmcV8qb4mzIgXRF8Hd7T/J87FZ8
         4nqV6GiS2jsyVbnQkFeHCXDmkYzYuqTCwyRn8/YsuvepR/VY8pUp5M63tiddRwuNWaEk
         5bPVx8p7TgUoi1EcD3FbBeRgSmxkOTNzC3WdpUsQjlbWe3FmEXdGp6XIz60ynwi8/4BS
         0Eug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685254245; x=1687846245;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xjbuJACxE78nceTqHgAJTs0Qk225dErZdIVdFRgaZoM=;
        b=LBjtes7fXfMuHR+vQ2YwcDnZYEOxXtKoV42GHm2lgktzKNWAEtFnjYIWAjFk6DzyL8
         q6PoXOsMqmZop/LfvoQhj/KFgokRLw59Tz/cuwZmNPqwH/OLaMRThU8rmWjJIMiTw9/N
         VNLf75pSFiX6lLuOKcPnvetmdd1oaaexyDrCwPr07yrOqeUqJ46ODefpCn2bgIHpaHPa
         FPAIZdkU0IpxUSif7K19WwWtC0LqJiWm1Z04uf6e8vmm5p2xSGHGYLn7jtb6P5QwnNmi
         yvqHgGo33rFPc9/gocXmvg1o90EVwwaFrY79plqLXD2s5J6ggfeIonOl0kXXL5mCQfWK
         9OyQ==
X-Gm-Message-State: AC+VfDzC+0KxlLPWsoOceVGsI8rGBMId449MUTU2jODDlMgkvnDefm2s
        0P2NeLmifzo/budrAwvfTYo=
X-Google-Smtp-Source: ACHHUZ5YEdD+9gDbPe59k+yk3uBUX9BULbMJnPNZKAJwtdPhdl95VaEK4UR6sULyTPYncJHdBcyb7Q==
X-Received: by 2002:a17:903:32ca:b0:1ae:8b4b:327d with SMTP id i10-20020a17090332ca00b001ae8b4b327dmr9206696plr.42.1685254244441;
        Sat, 27 May 2023 23:10:44 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id ij13-20020a170902ab4d00b001a1a07d04e6sm5837393plb.77.2023.05.27.23.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 May 2023 23:10:43 -0700 (PDT)
Date:   Sat, 27 May 2023 23:10:42 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Wen, Qian" <qian.wen@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v13 002/113] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Message-ID: <20230528061042.GA1234772@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <e4d32af22f0a540c62fffaa17fe478a723e109ea.1678643052.git.isaku.yamahata@intel.com>
 <676b2b3e-b836-4b55-9772-eb6c6db82542@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <676b2b3e-b836-4b55-9772-eb6c6db82542@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 23, 2023 at 10:23:57AM +0800,
"Wen, Qian" <qian.wen@intel.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index a59559ff140e..3f49e8e38b6b 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -165,3 +165,54 @@ struct kvm_x86_init_ops vt_init_ops __initdata = {
> >  	.runtime_ops = &vt_x86_ops,
> >  	.pmu_ops = &intel_pmu_ops,
> >  };
> > +
> > +static int __init vt_init(void)
> > +{
> > +	unsigned int vcpu_size, vcpu_align;
> > +	int r;
> > +
> > +	if (!kvm_is_vmx_supported())
> > +		return -EOPNOTSUPP;
> > +
> > +	/*
> > +	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
> > +	 * to unwind if a later step fails.
> > +	 */
> > +	hv_init_evmcs();
> > +
> > +	r = kvm_x86_vendor_init(&vt_init_ops);
> > +	if (r)
> > +		return r;
> > +
> > +	r = vmx_init();
> > +	if (r)
> > +		goto err_vmx_init;
> > +
> > +	/*
> > +	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
> > +	 * exposed to userspace!
> > +	 */
> > +	vt_x86_ops.vm_size = sizeof(struct kvm_vmx);
> 
> nit: why initialize vm_size again? I noticed that it has already been assigned a value when create vt_x86_ops.

Thanks, will remove the line.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
