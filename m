Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5D7570F0F
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 02:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbiGLAqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 20:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbiGLAqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 20:46:44 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A584C638;
        Mon, 11 Jul 2022 17:46:43 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id bf13so6153208pgb.11;
        Mon, 11 Jul 2022 17:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PmFaKZIjci33tQMvV6r2y1+5A3/n4Qt8XlR0JqP9Soo=;
        b=em5AoywgWgeV/BIPYdR55C7ss6CjjZ57gc78SzsmuWvB5XPZwoG9lxaVWSgSjGXN1k
         P1p5Pedj8X4hXsxpvn/z1SfqxrUEg3o6mUStujpg2s6whJ8vzOBg00hKYtMPas/hxz8z
         Wz3FI9QBvoQNwtHMTOIv5uAt4lOAza5awDc95CMGVUbiL5GYLtB7Hr039IhW6OTmhg7f
         bR/fFGqsX710vfz5Su0iqN9vfFa7YKLooz/n1S/FTEf7IK5t1veZUHIT4slGMxfOVCaR
         l4sbAKtaqRqHcUJJb806Q9l/6lqIUHmSr9Uke3stDIcw0Fn1PZ8qPHmob1ITZBSNTnRo
         6RCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PmFaKZIjci33tQMvV6r2y1+5A3/n4Qt8XlR0JqP9Soo=;
        b=fBCwyzjeqcoWIjlWXyZko9J4htaM195YtKjk8VGT6YUjvJQR8RkDsFeQmB37Hthvu4
         370jZ8gQCvJ92Q4XvQ2/GBj06Hw87NVasDB2+g+a9hLgcL5GyW+Yv0fxIYwehR+1FQ16
         7o2NFe+0fMjuUSUp3TxDWI5TTAs44s/eh9JeliO6TkXaxWNW55Iv+OqDiq4EuLzqrns5
         zGOC+oEFhv1GSejo5HeyZKqWovsOQA45STtjX2T4rmXT6618GJOk5zaHUsvALvtwypLn
         A7TSGEVINPkAIHpoIz616iN7WgiSV0ZYOOBIEgdyeoYYVsc4WZ+UiEX1nVw8ws+Q3mPf
         kC4g==
X-Gm-Message-State: AJIora9PDKg3xgSXFK4hqGpVOpbM5wsXHk5+0i4OsMPXES1wtHUVHLP2
        Qa4TdocWEykRG7Osaj3dhjg=
X-Google-Smtp-Source: AGRyM1sgWFD82sJAnjUHLpUJRE5ZpCKHmslCMduE2reCuVjh0MSxkOFC4eJWC0AmT/Ndqdb1vjrv9Q==
X-Received: by 2002:a05:6a00:1592:b0:525:7809:42c6 with SMTP id u18-20020a056a00159200b00525780942c6mr21461491pfk.64.1657586802386;
        Mon, 11 Jul 2022 17:46:42 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id ml5-20020a17090b360500b001ef82d23125sm7597781pjb.25.2022.07.11.17.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 17:46:41 -0700 (PDT)
Date:   Mon, 11 Jul 2022 17:46:40 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v7 011/102] KVM: TDX: Initialize TDX module when loading
 kvm_intel.ko
Message-ID: <20220712004640.GD1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <d933e5f16ff8cb58020f1479b7af35196f0ef61e.1656366338.git.isaku.yamahata@intel.com>
 <81ea5068b890400ca4064781f7d2221826701020.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <81ea5068b890400ca4064781f7d2221826701020.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 28, 2022 at 04:31:35PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > To use TDX functionality, TDX module needs to be loaded and initialized.
> > A TDX host patch series[1] implements the detection of the TDX module,
> > tdx_detect() and its initialization, tdx_init().
> 
> "A TDX host patch series[1]" really isn't a commit message material.  You can
> put it to the cover letter, but not here.
> 
> Also tdx_detect() is removed in latest code.

How about the followings?

    KVM: TDX: Initialize TDX module when loading kvm_intel.ko
    
    To use TDX functionality, TDX module needs to be loaded and initialized.
    This patch is to call a function, tdx_init(), when loading kvm_intel.ko.
    
    Add a hook, kvm_arch_post_hardware_enable_setup, to module initialization
    while hardware is enabled, i.e. after hardware_enable_all() and before
    hardware_disable_all().  Because TDX requires all present CPUs to enable
    VMX (VMXON).

> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 30af2bd0b4d5..fb7a33fbc136 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11792,6 +11792,14 @@ int kvm_arch_hardware_setup(void *opaque)
> >  	return 0;
> >  }
> >  
> > +int kvm_arch_post_hardware_enable_setup(void *opaque)
> > +{
> > +	struct kvm_x86_init_ops *ops = opaque;
> > +	if (ops->post_hardware_enable_setup)
> > +		return ops->post_hardware_enable_setup();
> > +	return 0;
> > +}
> > +
> 
> Where is this kvm_arch_post_hardware_enable_setup() called?
> 
> Shouldn't the code change which calls it be part of this patch?

The patch of "4/102 KVM: Refactor CPU compatibility check on module
initialiization" introduces it.  Because the patch affects multiple archs
(mips, x86, poerpc, s390, and arm), I deliberately put it in early.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
