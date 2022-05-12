Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC198524968
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 11:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352242AbiELJuU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 05:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351921AbiELJuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 05:50:19 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F57523BC0;
        Thu, 12 May 2022 02:50:19 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id x18so4381264plg.6;
        Thu, 12 May 2022 02:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KwLaMpQ3xn4DGyzt5xunZapwFWZ+i/mDzQmCelYbbjc=;
        b=l9+epXEShS+Y2lnnFwWxTwPngE5LsiZPGN3+2MvwCccc97ct1s5fzVJCD0UzVBhE+u
         kqQ2t2nvnRQSjdDdDnvuW00/ChQY3LBJhPJEUkk+rEIttF07nKj8n2j2dE7YnHjHpE89
         AYWUzlJYGMoQd5EPlvuqqGjoFcxue73jBOK3sy/SUJAz0oJ+XqJVl/xqUhjJjoJsXSys
         8DudTHvs240Zjs4AgIa60/YtF86BzLzCY8pcqUA8b+0dxdcTx5XOQhkfgZUmb+xBa5ps
         asBVGNj+QYSt6PkNiUIQ2yHgk3imlgX4KOD4tycoPp9n5373rDTfpYjZRcMpkPL29lS9
         Br/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KwLaMpQ3xn4DGyzt5xunZapwFWZ+i/mDzQmCelYbbjc=;
        b=QwyAQhvnbMdHMkZvQCRddwefhYKwkQ01uuf9cS1G006JskVfo0P2sZqU1cLj8ujANX
         HadWAMbJzoP7iAL9I4ADZBN8GLVhC0tu9+3b8DHwDnpX1xvJXw3ywtlTD9zcOHRSKmE2
         JTXGJ8teuMOWhw5ggpyl9XdP6xy4k4dumxJgCOGN8u1LUVHZrAU3+Vf72ZH1BVDOjmSy
         wfJiTJlhsYvxVcSW1H3ZHLuvvcUPVZ45U3/M/wc+7ORTzulg8+M8q0RZYUDBqcmhr2Ao
         ze0hU4d5G+1PZ7V7FVnP027ij42dQ6Pz7Pf6C6o17TUeCd1moU0Uie4S1Wz9wirQzkMo
         PBOw==
X-Gm-Message-State: AOAM5301YG5Z0RALA8owAGOWapp7xaWyqeANvGR9o1lxo9iIAANa9ij9
        aLtzu/wYVYNhGpGncM5gS3I=
X-Google-Smtp-Source: ABdhPJzkcTKUArxK+TpRwLapWoKy2keyzsMufXtozLzoyaqn+1UyAUAbwhmRQf9jvgEGw9Lyk5U79A==
X-Received: by 2002:a17:902:6f16:b0:15e:f719:34ec with SMTP id w22-20020a1709026f1600b0015ef71934ecmr26146731plk.166.1652349018495;
        Thu, 12 May 2022 02:50:18 -0700 (PDT)
Received: from localhost ([192.55.54.48])
        by smtp.gmail.com with ESMTPSA id w18-20020a634912000000b003c14af505f4sm1406023pga.12.2022.05.12.02.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 02:50:17 -0700 (PDT)
Date:   Thu, 12 May 2022 02:50:16 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [RFC PATCH v6 034/104] KVM: x86/mmu: Add address conversion
 functions for TDX shared bits
Message-ID: <20220512095016.GA2188642@ls.amr.corp.intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <38c30f2c5ad6f9ca018c3e990f244c9b67ef10cb.1651774250.git.isaku.yamahata@intel.com>
 <c103ce2619b0ee6d72a10c60cd12d08af112e43d.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c103ce2619b0ee6d72a10c60cd12d08af112e43d.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 12:16:58PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Thu, 2022-05-05 at 11:14 -0700, isaku.yamahata@intel.com wrote:
> > From: Rick Edgecombe <rick.p.edgecombe@intel.com>
...
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 909372762363..d1c37295bb6e 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -264,8 +264,10 @@ static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
> >  {
> >  	int ret = -ENOTSUPP;
> >  
> > -	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
> > +	if (range && kvm_available_flush_tlb_with_range()) {
> > +		/* Callback should flush both private GFN and shared GFN. */
> >  		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, range);
> > +	}
> 
> ??

Dropped this hunk.


> >  	if (ret)
> >  		kvm_flush_remote_tlbs(kvm);
> > @@ -4048,7 +4050,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >  	unsigned long mmu_seq;
> >  	int r;
> >  
> > -	fault->gfn = fault->addr >> PAGE_SHIFT;
> > +	fault->gfn = gpa_to_gfn(fault->addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
> >  	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
> >  
> >  	if (page_fault_handle_page_track(vcpu, fault))
> 
> As I said in previous version, this above change alone is broken:
> 
> https://lore.kernel.org/lkml/cover.1646422845.git.isaku.yamahata@intel.com/T/#mcd5c235e3577f5129810f3183f151a1c5f63466e
> 
> Why cannot this patch be merged to other patch(es) which truly adds
> private/shared mapping support?
> 
> Or did I get something wrong?

Oops. Somehow I missed this part. I moved this part to "TDP MMU TDX support".

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
