Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854C4519275
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 01:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241688AbiECXzy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 19:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiECXzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 19:55:53 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823EB2D1C4
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 16:52:19 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id p6so16726511pjm.1
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 16:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dIl0jSqv+1IgIMRFplOI2lNE+rXmcECLP08qxYwGJc0=;
        b=Jlr89hpZSSeBwdTt2G8dGUNqx50RzYQ2avJ34UjBJBOjpoemfQ3SDw5njPWuKl3mZ7
         SFoXUJ9fjz/960VbtmnV/RLfqLoz/BF81W048v560CA4f3aVV+Ofcw+iwK3DoRSl5ihM
         sRM5Jar9mB8/zyhK7WTAoSvTWYhlwsKbqYi4ET9ojQCYtjA01r+Avxls3u6W0Pyd9JH9
         aFUmDU6IIO1tGgqcHlX3yCp9oeVCnErTMfk6LsbGXHlFd4gQzpNhRoN6pPbV/iIuH7W7
         ZQ3ibuKe/danGYxshGOSQDX4K+3wh7Z5R3Lrrv8NeQnJ6eBq54jlnWMRISeEIcW6qSVU
         a8jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dIl0jSqv+1IgIMRFplOI2lNE+rXmcECLP08qxYwGJc0=;
        b=VVewGy2Uoi5PB3aWEhI1xZZnIR7nW0o/DmeBEyjp1EV7kNjeiphxSDGEAtSNaVuREk
         xmoULRjXbXIMKRVoESaaH9wPf3lbiz6AYLQjQhB29dAmRRb6pGfZOkKLwP8hXvLatJ/b
         2f1/iYErz6khYIcZOolAjFz6ajODR2VPRsUNhM4+C+9JatXrKeFmZYcmr4gupjEbvog2
         LyMRuh02VbJkp/6eIuY0omLkNUyNv1fk/cpZaXQUDbNn+34k5fLAMSq7+JQO31M05ZpO
         0IDbaneQ1FRePWnktoe71h3CqhsqIMmtVMpDz1kGlWxvwdJrh8TPopP46OOfNRmLvC1P
         idEA==
X-Gm-Message-State: AOAM531o9vDItOj2cUDZgzSCF4cAZkKJxsA+kqNC3jCXmijYiKrsaOHq
        AHjGbF4wY1b5zWYR+TA+n6ttTQ==
X-Google-Smtp-Source: ABdhPJywm9YWJHmbRUz5spi3dSy1OeaSeyXk5Q5GTVC6rernTTo6prNWFLy2KZDG0qUtIoX6JccFyQ==
X-Received: by 2002:a17:90a:b285:b0:1d9:aee3:fabd with SMTP id c5-20020a17090ab28500b001d9aee3fabdmr7519129pjr.72.1651621938791;
        Tue, 03 May 2022 16:52:18 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902b60700b0015e8d4eb256sm6899015pls.160.2022.05.03.16.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 16:52:18 -0700 (PDT)
Date:   Tue, 3 May 2022 23:52:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zdenek Kaspar <zkaspar82@gmail.com>
Cc:     kvm@vger.kernel.org
Subject: Re: Core2 and v5.18-rc5 troubles
Message-ID: <YnHALvjWw6E94K53@google.com>
References: <20220502022959.18aafe13.zkaspar82@gmail.com>
 <20220502190010.7ff820e3.zkaspar82@gmail.com>
 <YnFWT+OdBAOPpZfi@google.com>
 <20220503230727.54476050.zkaspar82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503230727.54476050.zkaspar82@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 03, 2022, Zdenek Kaspar wrote:
> On Tue, 3 May 2022 16:20:31 +0000 Sean Christopherson <seanjc@google.com> wrote:
> Bisect is later on my TODO if needed... I build this kernel now on
> debian/sid (saw some compiler/binutils updates) and added KASAN as
> Maciej pointed out.
> [  229.423151] ==================================================================
> [  229.423284] BUG: KASAN: slab-out-of-bounds in fpu_copy_uabi_to_guest_fpstate+0x86/0x130

Aha!  A clue, Sherlock!  I can reproduce in a VM by hiding XSAVE from the VM; that's
why this only repros on Core2.

KASAN blames fpu_copy_uabi_to_guest_fpstate() first, but the '3' data corruption
likely comes from this line in fpu_copy_guest_fpstate_to_uabi(), as the FP+SEE
mask == 3.

		/* Make it restorable on a XSAVE enabled host */
		ustate->xsave.header.xfeatures = XFEATURE_MASK_FPSSE;

One or both of these commits is/are to blame, depending on whether we want to blame
the bad calculation, the first use of the bad calculation, or yell at both.

  be50b2065dfa ("kvm: x86: Add support for getting/setting expanded xstate buffer")
  c60427dd50ba ("x86/fpu: Add uabi_size to guest_fpu")

I believe the right way to fix this is to set the starting uABI size to KVM's
actual base uABI size, struct kvm_xsave.  I'll test the below more broadly and
send a patch.

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index c049561f373a..99caae7e8b01 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -14,6 +14,8 @@
 #include <asm/traps.h>
 #include <asm/irq_regs.h>
 
+#include <uapi/asm/kvm.h>
+
 #include <linux/hardirq.h>
 #include <linux/pkeys.h>
 #include <linux/vmalloc.h>
@@ -247,7 +249,20 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
        gfpu->fpstate           = fpstate;
        gfpu->xfeatures         = fpu_user_cfg.default_features;
        gfpu->perm              = fpu_user_cfg.default_features;
-       gfpu->uabi_size         = fpu_user_cfg.default_size;
+
+       /*
+        * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
+        * to userspace, even when XSAVE is unsupported, so that restoring FPU
+        * state on a different CPU that does support XSAVE can cleanly load
+        * the incoming state using its natural XSAVE.  In other words, KVM's
+        * uABI size may be larger than this host's default size.  Conversely,
+        * the default size should never be larger than KVM's base uABI size;
+        * all features that can expand the uABI size must be opt-in.
+        */
+       gfpu->uabi_size         = sizeof(struct kvm_xsave);
+       if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
+               gfpu->uabi_size = fpu_user_cfg.default_size;
+
        fpu_init_guest_permissions(gfpu);
 
        return true;
