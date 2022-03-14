Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD294D8CA0
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243178AbiCNTq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235483AbiCNTq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:46:26 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0193DA67;
        Mon, 14 Mar 2022 12:45:16 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id z3so14432415plg.8;
        Mon, 14 Mar 2022 12:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f2mx1XUUlp12T6iVJ8ZfTCd5aF5zOWGaDksJ5HhBih0=;
        b=PUGAWiWtYQEI/LUdwRv6HXIubdu5SR1S/o23kfD/KnvlEQX6ZMpK2yoTcgoPbus2xT
         QckGUaxfeZr6pNQNNtQQfA+cOSOkGcsbjgQ+7XjISICFNcIxz62o1v/bDChAUmGvpbSU
         EnVJAMreRu7PYHGESfMx1GQ4aCDHRLFPMFNg31gtgE7HfZTGze6EbbwZnp7i6RdFSI3h
         V/MesHVQuVRbxRDwtF0JilFj2PrR2+JCPwUlvRrMTgpGQZuKJWHT3bzXgld7hPvLHryX
         t4Z66j3nmSjNuIPxGAS4qVAHj2N6sfc5VyNeHZz/ufJPDoqeBuzXKzMO3cUFbMlYKyrj
         u5ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f2mx1XUUlp12T6iVJ8ZfTCd5aF5zOWGaDksJ5HhBih0=;
        b=t9qUunt5dx2zudSw+RY1yehcugI7rFh5auqDmqkirprbCWldNwVVtRVzctZiEyq3Ac
         fXJKslX49RIW3LnDHNNlEENVd6diFz+ASxZYQg8YJNNsuU2hrAe+74/Vpbdp+fcT+bZs
         fQI+Y/5+T0/kfgCvxkt277T4XeJlGZuASeM5PicBREoBoEHguKAr+nlOGKoZVjF12Ohq
         vy7BSbd+Rx5bFefchFqZ9etVwjrrNl9ZZ3Dj2F8GWhA/AgTR6B0hR3QPGDa3s7XYGsh1
         pclP1ISNOjW7pORevRNBuhUeQwj1gxPsFaRcxQd5+XD207COOnxCGr1t93EzioUMygDE
         JQiQ==
X-Gm-Message-State: AOAM533badiUmxUOxXLvNQgqc0k1zu8Kiu8Em1Y/W5q1BMH+7eijnB4Z
        dTrdTQcgFy0C+oZDVOHvkss=
X-Google-Smtp-Source: ABdhPJyRZEyaNutfTz5mGvSc/4rUw4DvMFHvknAn9RLKhno2/pAiQQ/M1AJHGUYXvsJJa/8O1+JGMQ==
X-Received: by 2002:a17:90a:528b:b0:1bc:c5f9:82a with SMTP id w11-20020a17090a528b00b001bcc5f9082amr777771pjh.210.1647287115917;
        Mon, 14 Mar 2022 12:45:15 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id p186-20020a62d0c3000000b004f6fa49c4b9sm20134226pfg.218.2022.03.14.12.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 12:45:14 -0700 (PDT)
Date:   Mon, 14 Mar 2022 12:45:13 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 008/104] KVM: TDX: Add a function to initialize
 TDX module
Message-ID: <20220314194513.GD1964605@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <b92217283fa96b85e9a683ca3fcf1b368cf8d1c4.1646422845.git.isaku.yamahata@intel.com>
 <05aecc5a-e8d2-b357-3bf1-3d0cb247c28d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05aecc5a-e8d2-b357-3bf1-3d0cb247c28d@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 13, 2022 at 03:03:40PM +0100,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > +
> > +	if (!tdx_module_initialized) {
> > +		if (enable_tdx) {
> > +			ret = __tdx_module_setup();
> > +			if (ret)
> > +				enable_tdx = false;
> 
> "enable_tdx = false" isn't great to do only when a VM is created.  Does it
> make sense to anticipate this to the point when the kvm_intel.ko module is
> loaded?

It's possible.  I have the following two reasons to chose to defer TDX module
initialization until creating first TD.  Given those reasons, do you still want
the initialization at loading kvm_intel.ko module?  If yes, I'll change it.

- memory over head: The initialization of TDX module requires to allocate
physically contiguous memory whose size is about 0.43% of the system memory.
If user don't use TD, it will be wasted.

- VMXON on all pCPUs: The TDX module initialization requires to enable VMX
(VMXON) on all present pCPUs.  vmx_hardware_enable() which is called on creating
guest does it.  It naturally fits with the TDX module initialization at creating
first TD.  I wanted to avoid code to enable VMXON on loading the kvm_intel.ko.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
