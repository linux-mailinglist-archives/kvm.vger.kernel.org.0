Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8E05A9E75
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 19:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbiIARuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 13:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiIARt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 13:49:58 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20B9B86D;
        Thu,  1 Sep 2022 10:49:55 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x19so16298743pfr.1;
        Thu, 01 Sep 2022 10:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=qWpjRl4ZF6VPWjvFhKrl1KyHnirvLl4yMapa4BXRQks=;
        b=OJCRgC1jpyrffufXczCD7jm2h7wjD3cisOSu9PONuvqge5obk8aYt5ZSgZiv2e6otx
         VElkCUPXaoQhmYIBHDdWH+qE8Nsangsj2pLqJE8MwD65hxBhcNsdcXv3nP1TW68yRy54
         hllrf9FSwpsAbAERkXHMh9QlDEF2QBgtRxLuzkiS/14NI63dbEhs5JpWjixI4Kj+glNo
         jLel6UHLDlz0Y6z/WGGZQB96bN6wP+jGvOpgu7qd5Ela2MlQUwVhd1imDmIhDQCN6gat
         GKh8M61lJY/xEWY2TiXDVPLTkTyILboz6YKjnAQnEyC9WFYFek/5LrSJxRJsXpNG/0lw
         fR9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=qWpjRl4ZF6VPWjvFhKrl1KyHnirvLl4yMapa4BXRQks=;
        b=6tNTlALoipVcDiu1TrVcKe3V2eqf1zTs7CUx3C1ejPGM7oJr88c1wLiJZDZiNrgdUX
         V4XOdr1Zz2hvLh7403XaucsR/YxOsX1DRs2XcqQT+I9zQid7e2Jv6qCJmVBsh2sLlg0i
         1FCOaTvc4F5DsHiDGvkCBRTCSClcxObY9qUQFOICTKAS/pSuhl55W7vSwwCpfmLDmIDt
         vfyjsnqiV/NqsbyYwreNyIE9lHvVO577wXneQiJd4LqqHJCpN7ixAjpGOIV9s2+3iEMy
         4uRjYpKXCoBNn6O+QQo/CMbNCCVeXXiNqosSfPVYpIqHufYGjgAx989dWcir6CETeVO2
         MmUA==
X-Gm-Message-State: ACgBeo0y/D1vnTdJghWu/9MN8YMdN/t36w597of8GskzCGSqLH4fV5NS
        5tG1azz73f1fGej5AwaVtQ4=
X-Google-Smtp-Source: AA6agR4aO8Di/cWDdhmUMO0wTtgFwRM5MrZUvLiIlluz1xuXmuE9jKjIrBn3+UH2I03En12W+kR6yA==
X-Received: by 2002:a63:81c6:0:b0:42b:c3fa:3a0 with SMTP id t189-20020a6381c6000000b0042bc3fa03a0mr21184925pgd.72.1662054594477;
        Thu, 01 Sep 2022 10:49:54 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id d68-20020a621d47000000b00535e46171c1sm13508621pfd.117.2022.09.01.10.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 10:49:54 -0700 (PDT)
Date:   Thu, 1 Sep 2022 10:49:53 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Chao Gao <chao.gao@intel.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Kai Huang <kai.huang@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 01/19] KVM: x86: Drop kvm_user_return_msr_cpu_online()
Message-ID: <20220901174953.GH2711697@ls.amr.corp.intel.com>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
 <f63a395ead4204d44cab3b734c99b07f54c38463.1661860550.git.isaku.yamahata@intel.com>
 <YxBDRaAyRpyz/5Q+@gao-cwp>
 <YxC96HujrBAwlgK0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YxC96HujrBAwlgK0@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 02:12:56PM +0000,
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Sep 01, 2022, Chao Gao wrote:
> > On Tue, Aug 30, 2022 at 05:01:16AM -0700, isaku.yamahata@intel.com wrote:
> > >From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >
> > >KVM/X86 uses user return notifier to switch MSR for guest or user space.
> > >Snapshot host values on CPU online, change MSR values for guest, and
> > >restore them on returning to user space.  The current code abuses
> > >kvm_arch_hardware_enable() which is called on kvm module initialization or
> > >CPU online.
> > >
> > >Remove such the abuse of kvm_arch_hardware_enable by capturing the host
> > >value on the first change of the MSR value to guest VM instead of CPU
> > >online.
> > >
> > >Suggested-by: Sean Christopherson <seanjc@google.com>
> > >Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > >---
> > > arch/x86/kvm/x86.c | 43 ++++++++++++++++++++++++-------------------
> > > 1 file changed, 24 insertions(+), 19 deletions(-)
> > >
> > >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > >index 205ebdc2b11b..16104a2f7d8e 100644
> > >--- a/arch/x86/kvm/x86.c
> > >+++ b/arch/x86/kvm/x86.c
> > >@@ -200,6 +200,7 @@ struct kvm_user_return_msrs {
> > > 	struct kvm_user_return_msr_values {
> > > 		u64 host;
> > > 		u64 curr;
> > >+		bool initialized;
> > > 	} values[KVM_MAX_NR_USER_RETURN_MSRS];
> > 
> > The benefit of having an "initialized" state for each user return MSR on
> > each CPU is small. A per-cpu state looks suffice. With it, you can keep
> > kvm_user_return_msr_cpu_online() and simply call the function from
> > kvm_set_user_return_msr() if initialized is false on current CPU.
> 
> Yep, a per-CPU flag is I intended.  This is the completely untested patch that's
> sitting in a development branch of mine.

With the following fix, it worked.  I'll replace this patch with yours.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 205ebdc2b11b..0e200fe44b35 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9212,7 +9217,12 @@ int kvm_arch_init(void *opaque)
                return -ENOMEM;
        }
 
-       user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
+       /*
+        * __GFP_ZERO to ensure user_return_msrs.values[].initialized = false.
+        * See kvm_user_return_msr_init_cpu().
+        */
+       user_return_msrs = alloc_percpu_gfp(struct kvm_user_return_msrs,
+                                           GFP_KERNEL | __GFP_ZERO);
        if (!user_return_msrs) {
                printk(KERN_ERR "kvm: failed to allocate percpu kvm_user_return_msrs\n");
                r = -ENOMEM;

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
