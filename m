Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FDE6CCE6B
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 01:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjC1X7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 19:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjC1X7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 19:59:22 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823263C31;
        Tue, 28 Mar 2023 16:58:48 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o2so13302325plg.4;
        Tue, 28 Mar 2023 16:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680047922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LkFN7H2PytEXuKDycRyGAldh/6JJOL2ZUvn2tVr7QFo=;
        b=is6DVluW+AV1GZK3OSOeMcu3FKaxqigpbdV1G9moVsrobpffKbCUejI3Ox/yz4wZcr
         IYFIlGPEJuQ4dCX4j+Qxs/i5wT4SKI3GhvXZ9Sr1K/MLMgi5dOCoWqONzt1cFCX/k3qS
         pcw+ZJ5FfOMy0kKRxAl1qJ3jIaqP9CUTwbW+be7UhIL47VGu0LR++gadV/cGsZJsKq7U
         GQbqomynkWfby8rRAk2ebHADRlWy0kSsjh/lmtn5/Gzo4GJki1NGVxKIA8hRKff2gqsk
         5XHwVrBjBzRqM9h1Wbs+wfF/9a9sWnoDiXSk2uXziAtwkeXVAP0wIXELdAxX4OliT+j+
         aKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680047922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LkFN7H2PytEXuKDycRyGAldh/6JJOL2ZUvn2tVr7QFo=;
        b=VVImgljf2S82sOOiBTfSPaeQFZFBv/cQDk6NXrzL57uZpzZWqwM1t9kpBMFRNyzupX
         UI46wReUuH/bPqx+NzlchIbeOrlpmhW9R10F5mu5oGDJSwnO38LdGwbkR4hGgF0k4B1A
         WA/p1kohNODg+gv8VVEr1eWKjGSOxZ/CUwIKDG5ycT3TfpMrlMn9Hb7NMGiEZrU2tyY/
         CJGrVU63Cv8QhSDcPgTSbWvCr02yN0x9q1qnIRpeE1JJiOOWXwasAOu8GMMI4oKstgzB
         rRAt/GZtdUAAtvNxN/4ZOR33cN0dkHOA4L7bUwK1OKQlHkOf5h4EAEHn0H3f5ybtlHNE
         0TNg==
X-Gm-Message-State: AAQBX9f2w8MdaTJm3IR0SyXBIuoJN+nv+D+Ubf5zxz+TxgrocZKnkvf1
        KDK/8jKtgvjx+l1pTBsyspI=
X-Google-Smtp-Source: AKy350bibwVs0CQNJ3urAW1SgBLIoTWqs8Q50uOWDZD500mzJzkRQDVHxvQ6z4clVhwb9iqIAijOWw==
X-Received: by 2002:a05:6a20:7491:b0:da:35d1:c46a with SMTP id p17-20020a056a20749100b000da35d1c46amr392937pzd.9.1680047921926;
        Tue, 28 Mar 2023 16:58:41 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id x19-20020a631713000000b005033e653a17sm3407911pgl.85.2023.03.28.16.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 16:58:41 -0700 (PDT)
Date:   Tue, 28 Mar 2023 16:58:39 -0700
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
Message-ID: <20230328235839.GA1069687@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <44f7fe9f235e29f2193eaac5890a4dede22c324c.1678643052.git.isaku.yamahata@intel.com>
 <20ebae70fd625f8a0fe87f98c25613a2d4dc5792.camel@intel.com>
 <20230315072711.GF3922605@ls.amr.corp.intel.com>
 <8ee89a1376babf0a5dbc2feb614890b7e2ccf2f8.camel@intel.com>
 <20230316002702.GA197448@ls.amr.corp.intel.com>
 <3ebe8d34ecf199b924f4892ce911077005526628.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3ebe8d34ecf199b924f4892ce911077005526628.camel@intel.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 24, 2023 at 10:41:56AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> > +static int __init tdx_module_setup(void)
> > +{
> > +	int ret;
> > +
> > +	ret = tdx_enable();
> > +	if (ret) {
> > +		pr_info("Failed to initialize TDX module.\n");
> > +		return ret;
> > +	}
> > +
> > +	pr_info("TDX is supported.\n");
> 
> Both pr_info()s are not required, because tdx_enable() internally prints them.

Ok, will drop this line.


> >  #endif /* __KVM_X86_VMX_X86_OPS_H */
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 2125fcaa3973..b264012a8478 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9435,6 +9435,16 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> >  
> >  	kvm_init_pmu_capability(ops->pmu_ops);
> >  
> > +	/*
> > +	 * TDX requires those methods to enable VMXON by
> > +	 * kvm_hardware_enable/disable_all()
> > +	 */
> > +	static_call_update(kvm_x86_check_processor_compatibility,
> > +			   ops->runtime_ops->check_processor_compatibility);
> > +	static_call_update(kvm_x86_hardware_enable,
> > +			   ops->runtime_ops->hardware_enable);
> > +	static_call_update(kvm_x86_hardware_disable,
> > +			   ops->runtime_ops->hardware_disable);
> >  	r = ops->hardware_setup();
> >  	if (r != 0)
> >  		goto out_mmu_exit;
> 
> Hmm.. I think this is ugly.  Perhaps we should never do any
> static_call(kvm_x86_xxx)() in hardware_setup(), because hardware_setup() is
> called before kvm_ops_update() and may update vendor's kvm_x86_ops.
> 
> So probably use hardware_enable_all() in hardware_setup() is a bad idea.
> 
> I think we have below options on how to handle:
> 
> 1) Use VMX's kvm_x86_ops directly in tdx_hardware_setup().  For instance,
> something like below:
> 
> int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> {
> 	...
> 
> 	cpus_read_lock();
> 	r = on_each_cpu(vt_x86_ops.hardware_enable, ...);
> 	if (!r)
> 		r = tdx_module_setup();
> 	on_each_cpu(vt_x86_ops.hardware_disable, ...);
> 	cpus_read_unlock();
> 
> 	...
> }
> 
> But this doesn't clean up nicely when there's some particular cpus fail to do
> hardware_enable().  To clean up nicely, we do need additional things similar to
> the hardware_enable_all() code path: a per-cpu variable or a cpumask_t + a
> wrapper of vt_x86_ops->hardware_enable() to track which cpus have done
> hardware_enable() successfully.
> 
> 2) Move those static_call_update() into tdx_hardware_setup() so they are TDX
> code self-contained.  But this would require exposing kvm_x86_ops as symbol,
> which isn't nice either.
> 
> 3) Introduce another kvm_x86_init_ops->hardware_post_setup(), which is called
> after kvm_ops_update().
> 
> Personally, I think 3) perhaps is the most elegant one, but not sure whether
> Sean/Paolo has any opinion.

I think we can simply update the ops before calling hardware_enable() and
clean up ops on failure.


diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 709134e7c12e..42c9b58fd1ef 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9436,20 +9436,15 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	kvm_init_pmu_capability(ops->pmu_ops);
 
 	/*
-	 * TDX requires those methods to enable VMXON by
-	 * kvm_hardware_enable/disable_all_nolock()
+	 * Because TDX hardware_setup uses x86_ops, update ops before calling
+	 * ops->hardware_setup().
 	 */
-	static_call_update(kvm_x86_check_processor_compatibility,
-			   ops->runtime_ops->check_processor_compatibility);
-	static_call_update(kvm_x86_hardware_enable,
-			   ops->runtime_ops->hardware_enable);
-	static_call_update(kvm_x86_hardware_disable,
-			   ops->runtime_ops->hardware_disable);
+	kvm_ops_update(ops);
 	r = ops->hardware_setup();
-	if (r != 0)
+	if (r != 0) {
+		kvm_x86_ops.hardware_enable = NULL;
 		goto out_mmu_exit;
-
-	kvm_ops_update(ops);
+	}
 
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &r, 1);


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
