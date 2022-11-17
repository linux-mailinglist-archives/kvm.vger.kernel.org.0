Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB0062E531
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 20:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240412AbiKQTZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 14:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240024AbiKQTZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 14:25:21 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DE5716FF;
        Thu, 17 Nov 2022 11:25:20 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 6so2890880pgm.6;
        Thu, 17 Nov 2022 11:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9BbiMwqmTAJ3D3PlFYxcNLvKRHhmP8V9s6Y91GUa+uU=;
        b=UTk4paU86RhKfSq6l9FT46qZ2+bU8y1qfcolsDC4UEG70V+wapMsqd370h03I/1RxE
         aatF+MJZo8e/1lLJ8/Sxn0YsBOiiqYRHLnV7OWfSp+JVjawzaVjx+qaLdxWrzV8bWPQ3
         IyRjRAYCuQzEDBANx1IOT/GiSy8B5OqXI56DEKRdvGyr4YVWquMbXT7qUW8zyuaWNtr7
         bstXDohWVs3S4wvqcxAj8kQDVFvZvd1gHZF2+3rAaX0xCpxzZ20LV19hEDvL+2qCceY8
         EcmfUDWm6sNHWuktTEfQUUCv85wYHuR9f2QMGdfb/NdZNUvUUEw0UaiPpM0eHDhfrq+0
         LqxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9BbiMwqmTAJ3D3PlFYxcNLvKRHhmP8V9s6Y91GUa+uU=;
        b=0Xw7GsXeEeDcXu5gmZJp+3/79QRjosYuJJo19E3B5TuIaNHiu6/4uael9ATd/SL2CJ
         yWN5S4IDZtvWiVVX7FLbYE1Llzf9H9bmmX7xkGLyLuPvLhfqtX8TDP4GrpIRMfdHu95M
         re2uHKZFeSggK2LE3PPMMGsJRa2u2V0zMaBlKPotrXTRfPkl7OlkTx9yuhabBsLAxuz5
         O6dUDyCs2LLHw8Y6yxEVBTsuYCashcfTQa/V8Amb/6YHLL7MS3rZt4cD/TaLcg+cTk/9
         aR5ZBfREm/acgr20twd8iHeIGamGtn9ROwi+nblYQlEYq31lUvr07HIY1w0B78ei4g1m
         HuuA==
X-Gm-Message-State: ANoB5pmSnq94qJtNdiA2eoug3P8TwXUWQFBLnyt+LB9caHyo49j/yF3q
        b0JlKwqCahNy/+CBBY67wOA=
X-Google-Smtp-Source: AA0mqf4JN6PrHt5GcHLASAoZYSaX5RcxCGq6zvB6+7FIHWz3eV5IKn9pMMbljnZZxo1x6l+OolVWCg==
X-Received: by 2002:a63:4e0e:0:b0:46e:bfec:d611 with SMTP id c14-20020a634e0e000000b0046ebfecd611mr3333428pgb.281.1668713120213;
        Thu, 17 Nov 2022 11:25:20 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id w8-20020a1709026f0800b001780a528540sm1771287plk.93.2022.11.17.11.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 11:25:19 -0800 (PST)
Date:   Thu, 17 Nov 2022 11:25:18 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v10 045/108] KVM: x86/mmu: Add a private pointer to
 struct kvm_mmu_page
Message-ID: <20221117192518.GL2350331@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <f2e0790612bb86bf1ebc2d5f5d94d72cc28dd1fd.1667110240.git.isaku.yamahata@intel.com>
 <00fc2a80784f9e007cffa9790c3dbd3109c3bec6.camel@intel.com>
 <19527bcd4dcd4667cc863bea1647b5a4a824e216.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19527bcd4dcd4667cc863bea1647b5a4a824e216.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 11:53:47AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Wed, 2022-11-16 at 10:32 +0000, Huang, Kai wrote:
> > > +
> > > +static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu,
> > > +					     struct kvm_mmu_memory_cache
> > > *private_spt_cache,
> > > +					     struct kvm_mmu_page *sp)
> > 
> > This function is very weird in the context of this patch.  _Only_ a new vcpu-
> > scope 'mmu_private_spte_cache' is added in this patch, but here you allow
> > caller
> > to pass an additional argument of private_spt_cache.  So there must be another
> > cache which is not introduced in this patch?
> > 
> > > +{
> > > +	/*
> > > +	 * vcpu == NULL means non-root SPT:
> > > +	 * vcpu == NULL is used to split a large SPT into smaller SPT. 
> > > Root SPT
> > > +	 * is not a large SPT.
> > 
> > I am guessing this "vcpu == NULL" case is for "Eager Splitting"?
> > 
> > If so, why not adding a global MMU cache for private_spt allocation, and make
> > vcpu->arch.mmu_private_spt_cache point to the global cache?  In this case, in
> > the context where you only have 'kvm', you can use the global cache directly. 
> > And in the context where you have a 'vcpu', you just use vcpu's cache.
> 
> So I went through all MMU related patches in this series, but I cannot find a
> place where this function is called with 'vcpu == NULL' and a valid cache is
> passed in, if I am reading correctly.
> 
> Also checked that "Eager Splitting" uses a kvm-scope cache for legacy MMU, but
> just uses __get_free_page() for TDP MMU.  And in later patch "KVM: x86/tdp_mmu:
> Support TDX private mapping for TDP MMU", __get_free_page() is also used to
> allocate the private_spt (which is consistent with existing eager splitting
> code).
> 
> So IIUC only legacy MMU code will call this function with 'vcpu == NULL' and a
> valid cache.  In this case, please remove the 'private_spt_cache' argument for
> now, and make the function always allocate from the vcpu-
> >arch.mmu_private_spt_cache.  
> 
> You can add the additional argument when TDX gets legacy MMU support.
> 
> Also, I think you need to move eager splitting support part (whether that
> handling is correct is another story) from the later patch to this patch. 
> Otherwise this patch is not complete.

Yes, you're right. Somehow legacy mmu part is crept in. I'll remove those from
this patch series.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
