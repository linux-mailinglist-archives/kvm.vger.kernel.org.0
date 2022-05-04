Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40BBF51A20E
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 16:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351246AbiEDOVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 10:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350203AbiEDOVi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 10:21:38 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0381D19281
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 07:18:02 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id p4so1899486edx.0
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 07:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v7XnLc4saZeFB9RDPRD8YprIuEm+zX0IDCqIuGEquPE=;
        b=T28F3e9lnPjYOI6ynsxHb8F/8vNI19FusOqmvVcqNrvk4wbEXY44WXlLhuYhspj9yF
         lYTjW+4BShDtl5AsVBpsfKchbh9R/QI71tOVhoq7NlF0OGnZjvXk0cDR8Uy47HBeW4CN
         YDEKBgba1borkmPogmK1WWa2JTwtnVuAQzh+zh8S6c17XtklLoLE0JlRJadSiPrHFhFz
         se+HjcvS1G6+xqaG/GsJTS4O9idaYiMKYqesjNsGKxvBntX4yLBUrmlK9LuATGe9Ougm
         LCCIi8GzBHoUo+GbOzNMoAc253flaL+UmQVCyfogO/XVEaONvlBxSIMA0IY6Z2JW5ecd
         IIxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v7XnLc4saZeFB9RDPRD8YprIuEm+zX0IDCqIuGEquPE=;
        b=B1caunfXxhX8YFvyPDZMsEeClo6WzYOpE+6+vVwz5bRHXGO4trAnv+wHINHNl5rRlX
         /pJ0H0WGocZCM5kSA7jN/2rfKWn18YyVtmUaDR8xuxrN+aotAf81Qq9rpvABXiWigDhz
         bGOt0eIinoKaH8pCkZ+ooIYFkLkP43pQ3e1AYg+1G0RdzY+4hsPl9R95b35Jzi0J73Sr
         chmndvYY/xbp765hcu/yL/v32poAMec42mYr0cIfrsajOE6pNzm/MSFoowvQGZQUDJTw
         gUiK628d2oKK6NHEsZCCLfUyCp4imJM5RJb+qCmLK8mr0QgN0iSi5r2XYqyxDPmcqaBh
         PlLg==
X-Gm-Message-State: AOAM532usMEnWL9Bt7N9cIDjC4FA5bmoCfrKU0E1j12tEXH5tYChGBrV
        +XzAfoa9B8lufSV0CqGAFhlu5qNZlszQVw==
X-Google-Smtp-Source: ABdhPJwousYtECemrOulxbjMwLvsQO/n6Z2jVgqQz8L4SV6cvqzlRdOcjehUL2ZpK7/9wGKECbh/uA==
X-Received: by 2002:a05:6402:42c3:b0:427:d0e6:77e4 with SMTP id i3-20020a05640242c300b00427d0e677e4mr12314939edc.49.1651673880451;
        Wed, 04 May 2022 07:18:00 -0700 (PDT)
Received: from vm1 (ip-86-49-65-192.net.upcbroadband.cz. [86.49.65.192])
        by smtp.gmail.com with ESMTPSA id y20-20020aa7ce94000000b0042617ba63a3sm9248564edv.45.2022.05.04.07.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 07:17:59 -0700 (PDT)
Date:   Wed, 4 May 2022 16:17:56 +0200
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: Core2 and v5.18-rc5 troubles
Message-ID: <20220504161756.30a19ce3.zkaspar82@gmail.com>
In-Reply-To: <YnHALvjWw6E94K53@google.com>
References: <20220502022959.18aafe13.zkaspar82@gmail.com>
        <20220502190010.7ff820e3.zkaspar82@gmail.com>
        <YnFWT+OdBAOPpZfi@google.com>
        <20220503230727.54476050.zkaspar82@gmail.com>
        <YnHALvjWw6E94K53@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 3 May 2022 23:52:14 +0000
Sean Christopherson <seanjc@google.com> wrote:

> On Tue, May 03, 2022, Zdenek Kaspar wrote:
> > On Tue, 3 May 2022 16:20:31 +0000 Sean Christopherson
> > <seanjc@google.com> wrote: Bisect is later on my TODO if needed...
> > I build this kernel now on debian/sid (saw some compiler/binutils
> > updates) and added KASAN as Maciej pointed out.
> > [  229.423151]
> > ==================================================================
> > [  229.423284] BUG: KASAN: slab-out-of-bounds in
> > fpu_copy_uabi_to_guest_fpstate+0x86/0x130
> 
> Aha!  A clue, Sherlock!  I can reproduce in a VM by hiding XSAVE from
> the VM; that's why this only repros on Core2.
> 
> KASAN blames fpu_copy_uabi_to_guest_fpstate() first, but the '3' data
> corruption likely comes from this line in
> fpu_copy_guest_fpstate_to_uabi(), as the FP+SEE mask == 3.
> 
> 		/* Make it restorable on a XSAVE enabled host */
> 		ustate->xsave.header.xfeatures = XFEATURE_MASK_FPSSE;
> 
> One or both of these commits is/are to blame, depending on whether we
> want to blame the bad calculation, the first use of the bad
> calculation, or yell at both.
> 
>   be50b2065dfa ("kvm: x86: Add support for getting/setting expanded
> xstate buffer") c60427dd50ba ("x86/fpu: Add uabi_size to guest_fpu")
> 
> I believe the right way to fix this is to set the starting uABI size
> to KVM's actual base uABI size, struct kvm_xsave.  I'll test the
> below more broadly and send a patch.
> 
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index c049561f373a..99caae7e8b01 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -14,6 +14,8 @@
>  #include <asm/traps.h>
>  #include <asm/irq_regs.h>
>  
> +#include <uapi/asm/kvm.h>
> +
>  #include <linux/hardirq.h>
>  #include <linux/pkeys.h>
>  #include <linux/vmalloc.h>
> @@ -247,7 +249,20 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest
> *gfpu) gfpu->fpstate           = fpstate;
>         gfpu->xfeatures         = fpu_user_cfg.default_features;
>         gfpu->perm              = fpu_user_cfg.default_features;
> -       gfpu->uabi_size         = fpu_user_cfg.default_size;
> +
> +       /*
> +        * KVM sets the FP+SSE bits in the XSAVE header when copying
> FPU state
> +        * to userspace, even when XSAVE is unsupported, so that
> restoring FPU
> +        * state on a different CPU that does support XSAVE can
> cleanly load
> +        * the incoming state using its natural XSAVE.  In other
> words, KVM's
> +        * uABI size may be larger than this host's default size.
> Conversely,
> +        * the default size should never be larger than KVM's base
> uABI size;
> +        * all features that can expand the uABI size must be opt-in.
> +        */
> +       gfpu->uabi_size         = sizeof(struct kvm_xsave);
> +       if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
> +               gfpu->uabi_size = fpu_user_cfg.default_size;
> +
>         fpu_init_guest_permissions(gfpu);
>  
>         return true;

Patch tested, everything works fine now,

Thanks, Z.
