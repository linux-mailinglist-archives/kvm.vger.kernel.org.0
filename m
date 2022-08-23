Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7456159D075
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 07:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239987AbiHWF1R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 01:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238497AbiHWF1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 01:27:15 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C0D5C9CD;
        Mon, 22 Aug 2022 22:27:14 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id c24so11326067pgg.11;
        Mon, 22 Aug 2022 22:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=AFLQ1ngUxF6RYmBCeC6lzMbI2cVcQMBjUiqpc+zgUEc=;
        b=IVOpZW78dn6kTTFZQXcZ4xXAXMVwGIFiAKFseZz04aGxn5XaobtOhHsYE4HchJlq8O
         1rYyGYFvJinjIq+JmX3zh0XP5Y9BKF8YiYlVwxh2NaWhvpinRFJATqkKiLd4CUewqpl+
         SA8/pFgGqnNmaitEGQOaaT7KMsahvlNJfTuOFgtxwcbdLLDT+ioGh2zs8fNzqMS8Iz0e
         42gMAc01oB6vUtPELDFggTa+pU0pZlQquCPr/cLlUWs147wWdX4mbb5NhaUpCP0Oz8tX
         ucfa1HCxvfUXRe2/Z90LrYyhn31k1wllpcbBHHl4DcBqSxPRWN6qiGLPUe65rthRx3W5
         W5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=AFLQ1ngUxF6RYmBCeC6lzMbI2cVcQMBjUiqpc+zgUEc=;
        b=QFmQwhXwPQhK/+TANrakAUdPFptn30EqUjeCC7aCaFm9ArFwpZ4duNbl2dFY5TiGlp
         Ab9OMiyDBidicvfzea0okzN2LyPODudficvSmYfSUxg1Oo7WWg6f+gxvbS9m07S5EGUT
         uDzlukrDBhO7sGho6RruW1XH5Y8O2WlPeFiV4GDxYxXWAsLvEtbRO4moJsfY57a+oUP3
         rWFXYNLCqwi+VOFH7L6XpNjR9WPReEPouFdeGCHC6B8oJzhNPiOq4gRj2V1SEwVxcRwH
         ltQNEUkf2S2wx2Iun+e6m5bw2bcno2I27s/OlYyB1uw+sM77/QvgTm/vjOaQeXNlcqC5
         QrBA==
X-Gm-Message-State: ACgBeo0BU3fD8ZCQYpi8cKiHzpBTW4u/P67VUJMHg4Hs6De5DN1Qe1e1
        NVx+tr5rBT+gRy0K1wsLH35D8orGu+0=
X-Google-Smtp-Source: AA6agR7zWg1w4M7hLKlcUwLEMhl4BX7t4A/JcE8I8i0rkTw4NjHB/e/hRRhk5FLM6OhEUnrj2oWCcg==
X-Received: by 2002:a62:3086:0:b0:52b:fd6c:a49d with SMTP id w128-20020a623086000000b0052bfd6ca49dmr23521423pfw.26.1661232433713;
        Mon, 22 Aug 2022 22:27:13 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id jc3-20020a17090325c300b00172b42c1a02sm9225968plb.83.2022.08.22.22.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 22:27:13 -0700 (PDT)
Date:   Mon, 22 Aug 2022 22:27:11 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "will@kernel.org" <will@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 003/103] KVM: Refactor CPU compatibility check on
 module initialization
Message-ID: <20220823052711.GB2147148@ls.amr.corp.intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <4092a37d18f377003c6aebd9ced1280b0536c529.1659854790.git.isaku.yamahata@intel.com>
 <d36802ee3d96d0fdac00d2c11be341f94a362ef9.camel@intel.com>
 <YvU+6fdkHaqQiKxp@google.com>
 <283c3155f6f27229d507e6e0efc5179594a36855.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <283c3155f6f27229d507e6e0efc5179594a36855.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 12, 2022 at 11:35:29AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> >   3.  Provide arch hooks that are invoked for "power management" operations (including
> >       CPU hotplug and host reboot, hence the quotes).  Note, there's both a platform-
> >       wide PM notifier and a per-CPU notifier...
> > 
> >   4.  Rename kvm_arch_post_init_vm() to e.g. kvm_arch_add_vm(), call it under
> >       kvm_lock, and pass in kvm_usage_count.
> > 
> >   5a. Drop cpus_hardware_enabled and drop the common hardware enable/disable code.
> > 
> >  or 
> > 
> >   5b. Expose kvm_hardware_enable_all() and/or kvm_hardware_enable() so that archs
> >       don't need to implement their own error handling and per-CPU flags.
> > 
> > I.e. give each architecture hooks to handle possible transition points, but otherwise
> > let arch code decide when and how to do hardware enabling/disabling. 
> > 
> > I'm very tempted to vote for (5a); x86 is the only architecture has an error path
> > in kvm_arch_hardware_enable(), and trying to get common code to play nice with arm's
> > kvm_arm_hardware_enabled logic is probably going to be weird.
> > 

I ended up with (5a) with the following RFC patches.
https://lore.kernel.org/kvm/cover.1660974106.git.isaku.yamahata@intel.com/T/#m0239e7800b66174b49c5b1049462aad50293a994


> > E.g. if we can get the back half kvm_create_vm() to look like the below, then arch
> > code can enable hardware during kvm_arch_add_vm() if the existing count is zero
> > without generic KVM needing to worry about when hardware needs to be enabled and
> > disabled.
> > 
> > 	r = kvm_arch_init_vm(kvm, type);
> > 	if (r)
> > 		goto out_err_no_arch_destroy_vm;
> > 
> > 	r = kvm_init_mmu_notifier(kvm);
> > 	if (r)
> > 		goto out_err_no_mmu_notifier;
> > 
> > 	/*
> > 	 * When the fd passed to this ioctl() is opened it pins the module,
> > 	 * but try_module_get() also prevents getting a reference if the module
> > 	 * is in MODULE_STATE_GOING (e.g. if someone ran "rmmod --wait").
> > 	 */
> > 	if (!try_module_get(kvm_chardev_ops.owner)) {
> > 		r = -ENODEV;
> > 		goto out_err;
> > 	}
> > 
> > 	mutex_lock(&kvm_lock);
> > 	cpus_read_lock();
> > 	r = kvm_arch_add_vm(kvm, kvm_usage_count);
> 
> Holding cpus_read_lock() here implies CPU hotplug cannot happen during
> kvm_arch_add_vm().  This needs a justification/comment to explain why.  
> 
> Also, assuming we have a justification, since (based on your description above)
> arch _may_ choose to enable hardware within it, but it is not a _must_.  So
> maybe remove cpus_read_lock() here and let kvm_arch_add_vm() to decide whether
> to use it?

For now, I put locking outside of kvm_arch_{add, del}_vm().  But I haven't looked
at non-x86 arch.  Probably arm code has its preference for its implementation.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
