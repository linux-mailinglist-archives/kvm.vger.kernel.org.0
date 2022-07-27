Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BA4581CCF
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 02:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240087AbiG0Ajq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 20:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240078AbiG0Ajn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 20:39:43 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC8AE3AB37;
        Tue, 26 Jul 2022 17:39:41 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y9so14675781pff.12;
        Tue, 26 Jul 2022 17:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mn4mZGsZDMSKfZTb6AER+YiLIYXnjjMoa26anY5HGMs=;
        b=dJlFuWbQ05X08BQz3811oG9mFM+n3+agpjtO1jg7KYkcvOV07jHfPLrBTu53WWRLVz
         bs4wx6irFMwxxlbPMjSB5UK3y6kkLAaBT4+3EmVy2GcTJiaL2R52XrzBP1+j3Z1/7+PZ
         2bA/bNFC7wj3KMhHN21FV1Bn2KLe9efu5NGkdyI47aL64+Ol/wbzOri23Lz5GDvnqqja
         QL+UpuzJOtJDfgvndyq91C11/gF0oShvM4/FSBRsBXwV8DEOgoUU/8Q6eoieB4LMufTy
         3WGSL0hqC5b74o7swQ5Hrqlay+dw6YXyBijfnvRnt9rm8/Wmb/5XUwro9C8NFfa+4dGK
         7FPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mn4mZGsZDMSKfZTb6AER+YiLIYXnjjMoa26anY5HGMs=;
        b=iJzh5fgWb/Y9KfoQWoaq4u7waIXCgiitIUbxCx5ijTayYMCvsPBZeBqzqFV3Ddil3D
         xLFAyJiXe0qeulNMxpGKGth3+HBXTn7rDL4vcgtFC5xuwhcfrd08qw7viOpVGKdgGfNm
         Fj5jDApddkO+ot9vUM+fDjAdX/eqm8/mLlChlsnGwdB0lLfQ3u5xtAcy/B9R5zXYyt4/
         HG0w52EnIXhPE/sWoC/azzgOrA5GSStomfFSpKrYeUqmX6mFPMw9HUkKDfd4FmQQBKn7
         AOb+jv+ImdY2IpwADzJ3cP5ONeqY9dsw88j4a1Y+1R159SsuSev+wtUKMD0Jf4B4w/qZ
         2VSw==
X-Gm-Message-State: AJIora9u4UBYdLdXbkP+NCun7yLo8G4in8GYEWbQQpg68WDCivmbJAH0
        C83l1SZWxWg1p2r3yNGNBRAXz0HEIL0DCQ==
X-Google-Smtp-Source: AGRyM1tgohxIsG+pNdz9ifuAEth9RL4RrVbXVDGd7SsMood2egCs9M31XI8dTrhAWUQFqAq89IIFJQ==
X-Received: by 2002:a63:4f06:0:b0:41a:529b:b47b with SMTP id d6-20020a634f06000000b0041a529bb47bmr16426863pgb.243.1658882380893;
        Tue, 26 Jul 2022 17:39:40 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id gb7-20020a17090b060700b001ef9659d711sm188758pjb.48.2022.07.26.17.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 17:39:40 -0700 (PDT)
Date:   Tue, 26 Jul 2022 17:39:38 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v7 011/102] KVM: TDX: Initialize TDX module when loading
 kvm_intel.ko
Message-ID: <20220727003938.GG1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <d933e5f16ff8cb58020f1479b7af35196f0ef61e.1656366338.git.isaku.yamahata@intel.com>
 <81ea5068b890400ca4064781f7d2221826701020.camel@intel.com>
 <20220712004640.GD1379820@ls.amr.corp.intel.com>
 <d495a777f31df86271f1c4511b2f521adfa867d1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d495a777f31df86271f1c4511b2f521adfa867d1.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022 at 01:13:10PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> >     To use TDX functionality, TDX module needs to be loaded and initialized.
> >     This patch is to call a function, tdx_init(), when loading kvm_intel.ko.
> 
> Could you add explain why we need to init TDX module when loading KVM module?

Makes sense. Added a paragraph for it.


> >     Add a hook, kvm_arch_post_hardware_enable_setup, to module initialization
> >     while hardware is enabled, i.e. after hardware_enable_all() and before
> >     hardware_disable_all().  Because TDX requires all present CPUs to enable
> >     VMX (VMXON).
> 
> Please explicitly say it is a replacement of the default __weak version, so
> people can know there's already a default one.  Otherwise people may wonder why
> this isn't called in this patch (i.e. I skipped patch 03 as it looks not
> directly related to TDX).
> 
> That being said, why cannot you send out that patch separately but have to
> include it into TDX series?
> 
> Looking at it, the only thing that is related to TDX is an empty
> kvm_arch_post_hardware_enable_setup() with a comment saying TDX needs to do
> something there.  This logic has nothing to do with the actual job in that
> patch. 
> 
> So why cannot we introduce that __weak version in this patch, so that the rest
> of it can be non-TDX related at all and can be upstreamed separately?

The patch that adds weak kvm_arch_post_hardware_enable_setup() doesn't make
sense without the hook because it only enable_hardware and then disable hardware
immediately.
The patch touches multiple kvm arch.  and I split out TDX specific part in this
patch.  Ideally those two patch should be near. But I move it early to draw
attention for reviewers from multiple kvm arch.

Here is the updated version.

    KVM: TDX: Initialize the TDX module when loading the KVM intel kernel module
    
    To use TDX, the TDX module needs to be loaded and initialized.  This patch
    is to call a function to initialize the TDX module when loading KVM intel
    kernel module.
    
    There are several options on when to initialize the TDX module.  A.)
    kernel boot time as builtin, B.) kernel module loading time, C.) the first
    guest TD creation time.  B.) was chosen.  A.) causes unnecessary overhead
    (boot time and memory) even when TDX isn't used.  With C.), a user may hit
    an error of the TDX initialization when trying to create the first guest
    TD.  The machine that fails to initialize the TDX module can't boot any
    guest TD further.  Such failure is undesirable.  B.) has a good balance
    between them.
    
    Add a hook, kvm_arch_post_hardware_enable_setup, to module initialization
    while hardware is enabled, i.e. after hardware_enable_all() and before
    hardware_disable_all().  Because TDX requires all present CPUs to enable
    VMX (VMXON).  The x86 specific kvm_arch_post_hardware_enable_setup overrides
    the existing weak symbol of kvm_arch_post_hardware_enable_setup which is
    called at the KVM module initialization.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
