Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C13B6D87CF
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 22:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbjDEUHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 16:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjDEUHm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 16:07:42 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD944C2D;
        Wed,  5 Apr 2023 13:07:36 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d13so35163646pjh.0;
        Wed, 05 Apr 2023 13:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680725256; x=1683317256;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W0D/ZypdzGmz3BkyXnQMW4YLxz8yXoPXe9tabmL/FhY=;
        b=C59MmVtdw3j3KHBJJDfvEhtRzbsgRHSsZWeOyCfaM9Gm93UH+DyapMuT5E9dBe29ZN
         qjcpqA4pFsGNZh9ijJGr1RKFhjbX+lRzL0SKNQguN2rE5Hv3sMsHrkiXRG6AeIhzVA90
         3O5AOqIMrBJI2qhrUZOffG1F1FZSkMaUz73AKDf47t9XIlco3SPiFX26P3zMqRG9bFFE
         5G1uFQ8oeL7qb96N9/i0Bc41wA3cN6Xq4d17RWeFGgDQSqh8nc00d4E+g+7FMbeAVDGZ
         vuUER9cSMuQwxYHqtuOqmFUFAM3hUmyaxHActf92NuhiuGxDCJA98W5xE8El+zjXPP/2
         7c7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680725256; x=1683317256;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W0D/ZypdzGmz3BkyXnQMW4YLxz8yXoPXe9tabmL/FhY=;
        b=EJooMxSpqIzO+B6SQxvVVB3PDC24FoOcITdH8ZG1pCBb8If5bJugnYw3Js02QwOIGg
         yyb0vX/vtcUMkTk3TXPvlg19LMXynLGYkezE2plzpE7Q+Jtdj6beRqtqfmsHZUOMUfZu
         Mk8KPuvi9VtDjJ75jWj39QAI9JMwbTzR9eN/GTbqWPI8KZUblvcytsept5PGcYl3cpdE
         JRPL6rfspGBgyj2wGKB5JUPPhRra1lNAOqTBSvtJ1oH7q+W/U8Qz+vMvfslIboL+WWL0
         rgAqVPlSjs94um6nVB1Gv9iqjXu3g2qjOY5l9utLRCcA29leMmV9kZge/JQ89H8wepiU
         A3Jw==
X-Gm-Message-State: AAQBX9etV36Rju9T3t8W0hfFvRHCkceId0AP9c6OBfO2clzrp7O1B6UU
        mU3Sm77luiT2DFru4ZeoooOmRZlUnNY=
X-Google-Smtp-Source: AKy350YuehLdBoTCe41TTzj5Su9HfZNwrKx9j+Wgti8e207dSrOdxQOdG+gWwDSNRFgQrveVTjWbEQ==
X-Received: by 2002:a05:6a20:bf22:b0:d5:635c:eaa2 with SMTP id gc34-20020a056a20bf2200b000d5635ceaa2mr399569pzb.14.1680725255630;
        Wed, 05 Apr 2023 13:07:35 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id k24-20020aa790d8000000b0062d19179ec6sm11090359pfk.87.2023.04.05.13.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:07:34 -0700 (PDT)
Date:   Wed, 5 Apr 2023 13:07:33 -0700
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
Message-ID: <20230405200733.GJ1112017@ls.amr.corp.intel.com>
References: <20ebae70fd625f8a0fe87f98c25613a2d4dc5792.camel@intel.com>
 <20230315072711.GF3922605@ls.amr.corp.intel.com>
 <8ee89a1376babf0a5dbc2feb614890b7e2ccf2f8.camel@intel.com>
 <20230316002702.GA197448@ls.amr.corp.intel.com>
 <3ebe8d34ecf199b924f4892ce911077005526628.camel@intel.com>
 <20230328235839.GA1069687@ls.amr.corp.intel.com>
 <5896fb851d20de4aab55307a73e2b4a4243ca155.camel@intel.com>
 <20230329215609.GB1069687@ls.amr.corp.intel.com>
 <f02637a56848cff1a39a2c7e2350c11b180a87ea.camel@intel.com>
 <20230330010438.GC1112017@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230330010438.GC1112017@ls.amr.corp.intel.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023 at 06:04:38PM -0700,
Isaku Yamahata <isaku.yamahata@gmail.com> wrote:

> On Wed, Mar 29, 2023 at 11:17:31PM +0000,
> "Huang, Kai" <kai.huang@intel.com> wrote:
> 
> > On Wed, 2023-03-29 at 14:56 -0700, Isaku Yamahata wrote:
> > > On Wed, Mar 29, 2023 at 01:13:45AM +0000,
> > > "Huang, Kai" <kai.huang@intel.com> wrote:
> > > 
> > > > > 
> > > > > > >  
> > > > > > > +	/*
> > > > > > > +	 * TDX requires those methods to enable VMXON by
> > > > > > > +	 * kvm_hardware_enable/disable_all()
> > > > > > > +	 */
> > > > > > > +	static_call_update(kvm_x86_check_processor_compatibility,
> > > > > > > +			   ops->runtime_ops->check_processor_compatibility);
> > > > > > > +	static_call_update(kvm_x86_hardware_enable,
> > > > > > > +			   ops->runtime_ops->hardware_enable);
> > > > > > > +	static_call_update(kvm_x86_hardware_disable,
> > > > > > > +			   ops->runtime_ops->hardware_disable);
> > > > > > >  	r = ops->hardware_setup();
> > > > > > >  	if (r != 0)
> > > > > > >  		goto out_mmu_exit;
> > > > > > 
> > > > > > Hmm.. I think this is ugly.  Perhaps we should never do any
> > > > > > static_call(kvm_x86_xxx)() in hardware_setup(), because hardware_setup() is
> > > > > > called before kvm_ops_update() and may update vendor's kvm_x86_ops.
> > > > > > 
> > > > > > So probably use hardware_enable_all() in hardware_setup() is a bad idea.
> > > > > > 
> > > > > > I think we have below options on how to handle:
> > > > > > 
> > > > > > 1) Use VMX's kvm_x86_ops directly in tdx_hardware_setup().  For instance,
> > > > > > something like below:
> > > > > > 
> > > > > > int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> > > > > > {
> > > > > > 	...
> > > > > > 
> > > > > > 	cpus_read_lock();
> > > > > > 	r = on_each_cpu(vt_x86_ops.hardware_enable, ...);
> > > > > > 	if (!r)
> > > > > > 		r = tdx_module_setup();
> > > > > > 	on_each_cpu(vt_x86_ops.hardware_disable, ...);
> > > > > > 	cpus_read_unlock();
> > > > > > 
> > > > > > 	...
> > > > > > }
> > > > > > 
> > > > > > But this doesn't clean up nicely when there's some particular cpus fail to do
> > > > > > hardware_enable().  To clean up nicely, we do need additional things similar to
> > > > > > the hardware_enable_all() code path: a per-cpu variable or a cpumask_t + a
> > > > > > wrapper of vt_x86_ops->hardware_enable() to track which cpus have done
> > > > > > hardware_enable() successfully.
> > > > > > 
> > > > > > 2) Move those static_call_update() into tdx_hardware_setup() so they are TDX
> > > > > > code self-contained.  But this would require exposing kvm_x86_ops as symbol,
> > > > > > which isn't nice either.
> > > > > > 
> > > > > > 3) Introduce another kvm_x86_init_ops->hardware_post_setup(), which is called
> > > > > > after kvm_ops_update().
> > > > > > 
> > > > > > Personally, I think 3) perhaps is the most elegant one, but not sure whether
> > > > > > Sean/Paolo has any opinion.
> > > > > 
> > > > > I think we can simply update the ops before calling hardware_enable() and
> > > > > clean up ops on failure.
> > > > > 
> > > > > 
> > > > 
> > > > This doesn't work because hardware_setup() may update vendor's kvm_x86_ops.
> > > > 
> > > > If you do kvm_ops_update() before hardware_setup(), you need to manually update
> > > > those updated (in hardware_setup()) callbacks again after. 
> > > 
> > > We can call kvm_ops_update() twice before and after hardware_setup().
> > > 
> > 
> > Personally I think it's too ugly.  
> 
> So you prefer the option 3 to calling kvm_ops_update() twice. Okay, I'll update
> the patch.

After playing with hardware_post_setup(), it's inevitable to call
kvm_ops_update() twice.
When VMX initialization succeeded with hardware_setup(), but TDX initialization
with hardware_post_setup() failed, we'd like to support only VMX with warning
message.  In such case, we need to revert x86_ops to VMX only.
It doesn't make sense to introduce hardware_post_setup() to avoid calling
kvm_update_ops twice.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
