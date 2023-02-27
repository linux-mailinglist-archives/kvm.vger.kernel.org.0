Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EB46A4D90
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjB0VwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjB0VwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:52:18 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7532597B;
        Mon, 27 Feb 2023 13:52:17 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id l1so7697612pjt.2;
        Mon, 27 Feb 2023 13:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=79M5izvZlgTo6A22u+eX+TrcYuaXNkrng6+4N70gQwg=;
        b=S5er77Z/Pj5Khy6d3pJVBeblU07lDTrvAEUhTDLSpp5eLBBTdzqxBLNncBf/jlzt8N
         wT2aDkYJn/JIlM2RxkL8OomYYW9oR7dVN/amQSLKLlUG5zbaKgsWvGOJDhK/AtYXpkTy
         YzPPQAf0wuwylv1AZQxKWOheDuKqT4Q5pbHuy4g/6ZgLMsVcwy8GLf4EQP4lzchwKUbz
         KhZNDzqd3iWS22iJWoZNr5lTiapDAOPncMdNCu5BkvvCCwGHLrOPq16K9/Du8X4Kw4nv
         cVGj8vGT300IwadDJ8+EQr0+jvUHaxUCeuDgId8qmQ8vjCuNJZo9vyrUX17GztuOnSmm
         vZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=79M5izvZlgTo6A22u+eX+TrcYuaXNkrng6+4N70gQwg=;
        b=Qx2ErKdwOeAnyOUPDX9uS7kuDMO8qKrDTKFwhza/xNkR45ptlbDWEVBjAKhQMWOBQz
         4LX0CHJ/3wZaG9K1UdaZ/Z3tZZqkZrV1wFiRVjWZDuAiSUHA+cgapXw+fsZRN/8hdaWz
         W692T4XXlhWXSm1MD5v8Q7BLDpWOkGBa/DWf0iIdotvsTkvtX+NZzA8fA89mhRuLkjld
         +aS2aEoDMddkbXCHt70eMqvQY2pMw31ysZAqD28Cfr1NlX3052kASnvUHoWLOM8IHpMY
         JjexeIekhN6K1ZzgqSAPJMSsdHLYv435bw5SaGISNYhMDxSpiEAxhUIRHIAz1QWFXatF
         mbww==
X-Gm-Message-State: AO0yUKUyOeC41IvSa51gsn4SKAx0ax7OGxf6T1IFOFFXzgXM8/Z/w91r
        ya/f2DOoCaMGeeUazLHHWNs=
X-Google-Smtp-Source: AK7set/0vGzuLzCEi+0Hluan+aLL/lFF91iIavzjTWcYddq6eEciFMoXDOHY596UD/FB58S9RTfOhg==
X-Received: by 2002:a05:6a20:2444:b0:cc:ac05:88f7 with SMTP id t4-20020a056a20244400b000ccac0588f7mr1044373pzc.34.1677534737078;
        Mon, 27 Feb 2023 13:52:17 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id s17-20020a639251000000b00502ecb91940sm4461605pgn.55.2023.02.27.13.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 13:52:16 -0800 (PST)
Date:   Mon, 27 Feb 2023 13:52:15 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v11 030/113] KVM: x86/mmu: Replace hardcoded value 0 for
 the initial value for SPTE
Message-ID: <20230227215215.GL4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <dee30f0562d8be0102547d8eb9fc77736eae679d.1673539699.git.isaku.yamahata@intel.com>
 <20230125112434.0000512a@gmail.com>
 <Y9Fj/vgPEzfU1eof@google.com>
 <0be55c001aa1a538a02055aa244c655262228ce4.camel@intel.com>
 <Y9L4RQXuTJ4RTVcF@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y9L4RQXuTJ4RTVcF@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 26, 2023 at 10:01:41PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Jan 26, 2023, Huang, Kai wrote:
> > On Wed, 2023-01-25 at 17:22 +0000, Sean Christopherson wrote:
> > > I agree that handling this in the common code would be cleaner, but repurposing
> > > gfp_zero gets kludgy because it would require a magic value to say "don't initialize
> > > the data", e.g. x86's mmu_shadowed_info_cache isn't pre-filled.
> 
> ...
> 
> > > @@ -400,6 +405,13 @@ int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity,
> > >  		if (WARN_ON_ONCE(!capacity))
> > >  			return -EIO;
> > >  
> > > +		/*
> > > +		 * Custom init values can be used only for page allocations,
> > > +		 * and obviously conflict with __GFP_ZERO.
> > > +		 */
> > > +		if (WARN_ON_ONCE(mc->init_value && (mc->kmem_cache || mc->gfp_zero)))
> > > +			return -EIO;
> > > +
> > >  		mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
> > >  		if (!mc->objects)
> > >  			return -ENOMEM;
> > > 
> > > base-commit: 503f0315c97739d3f8e645c500d81757dfbf76be
> > 
> > init_value and gfp_zone is kinda redundant.  How about removing gfp_zero
> > completely?
> > 
> > 	mmu_memory_cache_alloc_obj(...)
> > 	{
> > 		...
> > 		if (!mc->init_value)
> > 			gfp_flags |= __GFP_ZERO;
> > 		...
> > 	}
> > 
> > And in kvm_mmu_create() you initialize all caches' init_value explicitly.
> 
> No, as mentioned above there's also a "don't initialize the data" case.  Leaving
> init_value=0 means those users would see unnecessary zeroing, and again I don't
> want to use a magic value to say "don't initialize".

The abuses of gfp_flags as zeroing doesn't work for Secure-EPT page table.
It doesn't need zeroing without initial value.  So I used the patch as is.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
