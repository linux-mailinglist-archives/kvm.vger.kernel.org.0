Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B426CF871
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 03:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjC3BEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 21:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjC3BEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 21:04:41 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE5D4EDB;
        Wed, 29 Mar 2023 18:04:40 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id y19so10405565pgk.5;
        Wed, 29 Mar 2023 18:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680138280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/eWdlLP1MP1yZejY0zNtzFCFxrL3Lo+DsUvtYHUea2w=;
        b=LdoAehIKRG756eSRt70+TVOULlcLmpNQs5ZivpRN3S0Cq93DCl8yOEhAqTEVsRZuRE
         R6Sf8TM6rlLIs13bjN3cR+3PVsxa0J0z5hhVdfQjZBph/gTf/tHM6DQHPwiCmBKuK5ke
         GiK3DaZxUam6zxYX6q6jTAOWUca4El7izKu/CNozjYTpeIMJn3oaYqenFb05GVimtRAS
         mVAhOeDAzlMQp9Y+8Nct9rsyckGONBBfKWEWJrA5qiraMttZgnzs56xHo+BFgg9u0qmA
         3O2cq97auevw7aoe4XXczbHHRi8R1NXpli2PkYowgUcq6n1R0rICYrLrVLlL9IL3mE5J
         Yu7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680138280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/eWdlLP1MP1yZejY0zNtzFCFxrL3Lo+DsUvtYHUea2w=;
        b=BQWja13ny5HgVXz0ctPrURpSHUuetjCDBGwl61XdhMcf3EBo3LHcb1ycuEgOLgbqey
         KS/hspXffizAXQjUR5d9ImpY0iezLXTbTgajOOjSR0VtYLzthPfVhC5ahtSz0fG3HcR9
         8f/o9i0s0AGrnSO3rLsHIfeUf7gChOlI4La6NIQMod+l9m80+uAzpbQz313+CQbykDvs
         TNRxVNIvZYqDeU8ZhhPZKWrzf60i/4fIYhnRec27/TKN8tQtPV4iVWEd9RFFAO4/b9hX
         4D1shSaeJYxe/E7rlSValAPIFyO+F3bpwxUD1zP+YIK3bSr0gPbJ0frwP6XM716zQCXC
         gjtg==
X-Gm-Message-State: AAQBX9fCwNsB6/kR//fnCW46HckH5cV/GhXf/dNQKdkw/mfMWfIEH/Y+
        KGayVeHagw7LPZyPl+jjv23SjuMEqZg=
X-Google-Smtp-Source: AKy350b+PtEj1wZxOyuaNcqXmqy7hZ7gcYgnNP4ESNogR9RN8acUQZnQwtmDzb7VouLlYZOs0D2zcQ==
X-Received: by 2002:a62:1ad7:0:b0:62d:b4ae:e48c with SMTP id a206-20020a621ad7000000b0062db4aee48cmr3075992pfa.23.1680138280217;
        Wed, 29 Mar 2023 18:04:40 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id w5-20020aa78585000000b005a8dd86018dsm18473777pfn.64.2023.03.29.18.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 18:04:39 -0700 (PDT)
Date:   Wed, 29 Mar 2023 18:04:38 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v13 003/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20230330010438.GC1112017@ls.amr.corp.intel.com>
References: <44f7fe9f235e29f2193eaac5890a4dede22c324c.1678643052.git.isaku.yamahata@intel.com>
 <20ebae70fd625f8a0fe87f98c25613a2d4dc5792.camel@intel.com>
 <20230315072711.GF3922605@ls.amr.corp.intel.com>
 <8ee89a1376babf0a5dbc2feb614890b7e2ccf2f8.camel@intel.com>
 <20230316002702.GA197448@ls.amr.corp.intel.com>
 <3ebe8d34ecf199b924f4892ce911077005526628.camel@intel.com>
 <20230328235839.GA1069687@ls.amr.corp.intel.com>
 <5896fb851d20de4aab55307a73e2b4a4243ca155.camel@intel.com>
 <20230329215609.GB1069687@ls.amr.corp.intel.com>
 <f02637a56848cff1a39a2c7e2350c11b180a87ea.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f02637a56848cff1a39a2c7e2350c11b180a87ea.camel@intel.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023 at 11:17:31PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Wed, 2023-03-29 at 14:56 -0700, Isaku Yamahata wrote:
> > On Wed, Mar 29, 2023 at 01:13:45AM +0000,
> > "Huang, Kai" <kai.huang@intel.com> wrote:
> > 
> > > > 
> > > > > >  
> > > > > > +	/*
> > > > > > +	 * TDX requires those methods to enable VMXON by
> > > > > > +	 * kvm_hardware_enable/disable_all()
> > > > > > +	 */
> > > > > > +	static_call_update(kvm_x86_check_processor_compatibility,
> > > > > > +			   ops->runtime_ops->check_processor_compatibility);
> > > > > > +	static_call_update(kvm_x86_hardware_enable,
> > > > > > +			   ops->runtime_ops->hardware_enable);
> > > > > > +	static_call_update(kvm_x86_hardware_disable,
> > > > > > +			   ops->runtime_ops->hardware_disable);
> > > > > >  	r = ops->hardware_setup();
> > > > > >  	if (r != 0)
> > > > > >  		goto out_mmu_exit;
> > > > > 
> > > > > Hmm.. I think this is ugly.  Perhaps we should never do any
> > > > > static_call(kvm_x86_xxx)() in hardware_setup(), because hardware_setup() is
> > > > > called before kvm_ops_update() and may update vendor's kvm_x86_ops.
> > > > > 
> > > > > So probably use hardware_enable_all() in hardware_setup() is a bad idea.
> > > > > 
> > > > > I think we have below options on how to handle:
> > > > > 
> > > > > 1) Use VMX's kvm_x86_ops directly in tdx_hardware_setup().  For instance,
> > > > > something like below:
> > > > > 
> > > > > int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> > > > > {
> > > > > 	...
> > > > > 
> > > > > 	cpus_read_lock();
> > > > > 	r = on_each_cpu(vt_x86_ops.hardware_enable, ...);
> > > > > 	if (!r)
> > > > > 		r = tdx_module_setup();
> > > > > 	on_each_cpu(vt_x86_ops.hardware_disable, ...);
> > > > > 	cpus_read_unlock();
> > > > > 
> > > > > 	...
> > > > > }
> > > > > 
> > > > > But this doesn't clean up nicely when there's some particular cpus fail to do
> > > > > hardware_enable().  To clean up nicely, we do need additional things similar to
> > > > > the hardware_enable_all() code path: a per-cpu variable or a cpumask_t + a
> > > > > wrapper of vt_x86_ops->hardware_enable() to track which cpus have done
> > > > > hardware_enable() successfully.
> > > > > 
> > > > > 2) Move those static_call_update() into tdx_hardware_setup() so they are TDX
> > > > > code self-contained.  But this would require exposing kvm_x86_ops as symbol,
> > > > > which isn't nice either.
> > > > > 
> > > > > 3) Introduce another kvm_x86_init_ops->hardware_post_setup(), which is called
> > > > > after kvm_ops_update().
> > > > > 
> > > > > Personally, I think 3) perhaps is the most elegant one, but not sure whether
> > > > > Sean/Paolo has any opinion.
> > > > 
> > > > I think we can simply update the ops before calling hardware_enable() and
> > > > clean up ops on failure.
> > > > 
> > > > 
> > > 
> > > This doesn't work because hardware_setup() may update vendor's kvm_x86_ops.
> > > 
> > > If you do kvm_ops_update() before hardware_setup(), you need to manually update
> > > those updated (in hardware_setup()) callbacks again after. 
> > 
> > We can call kvm_ops_update() twice before and after hardware_setup().
> > 
> 
> Personally I think it's too ugly.  

So you prefer the option 3 to calling kvm_ops_update() twice. Okay, I'll update
the patch.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
