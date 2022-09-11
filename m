Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56435B4B50
	for <lists+kvm@lfdr.de>; Sun, 11 Sep 2022 04:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiIKCjw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Sep 2022 22:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiIKCjv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Sep 2022 22:39:51 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C1A1056A;
        Sat, 10 Sep 2022 19:39:49 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso5078232pjd.4;
        Sat, 10 Sep 2022 19:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=UUuq/PLXlwBkLkLIfY/mJJB+6YLD1Vf243Iys/4Xjy0=;
        b=Ih3iCDMRR8Mb+bnWvQUIqZ8SML690b4DBTYahWeQcG2vVfkOcAYtcWzuJYojGs5yzR
         ytJvUM/WUNMGUqQ2P5PIHfcAtJxVo3L0KZPRtmZS6q75VPL7Uo4thSyEv3Au0a4V7D9M
         NGr1m0xUQF65pH+z+MKS04QABI6BuV403/2UQK4XLzj9xvILEoxTmdMI5+k6a5QM1lgv
         DAv/NbDhJHOuPriEg+AwsCRI50od9pSKwXx29ysDeTviF+t3u13JJgVeg+1lmqgUFZyF
         LsIJBrQUNAXNyhVobm55vM4yYxcNOrOOB1IQxR/Bmhg7SBwLRrCt/A/LIBTCljzkrHdJ
         AErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=UUuq/PLXlwBkLkLIfY/mJJB+6YLD1Vf243Iys/4Xjy0=;
        b=vNJDOmykunjJtymPRsUgeAEAKcea1tzNj4XNn/RReU2yerhAUzJbuZu55KHHINqdKC
         EEzADpkHJTTe6lroL6bO44b4jJme4J29QHwCsLV8zQMz4f9g1NiMPLW9/O12vNp6UkCC
         o4gMcfFv+WkTD0UJQ6aWz4riUlbgxFCRR+aaPdaSF9226+UlCpZewzVwX5VgAp29ZOZo
         wX2hnKnjhfKZK2D3cvgJG/0s9fG0odAia1uStOXIhdx9AQZPhKQ+SmQ0a//yjL8Ucj2/
         971PL9150MUFu2GoPCWRwZ/BQMFiLsFnVt0NQfNaJruhubT4ipjg1FCq+MA28ObsUezN
         UMRg==
X-Gm-Message-State: ACgBeo10Qhd/fO66SxMcbxPxpVoAa1SJ0kk5MqTrg7rnZthmWHDHbkqg
        wWWtPMNQ7rTaNNiwqB/MIbzsGhWIBlYpQw==
X-Google-Smtp-Source: AA6agR73oR4cY+tqiP/fhObQllrL4Gy4HTIsrnpq33pjpGixdQnO41ABodBF1+fFBFSsjreFo56Zww==
X-Received: by 2002:a17:90a:e7d2:b0:202:8f4b:bf6b with SMTP id kb18-20020a17090ae7d200b002028f4bbf6bmr9970404pjb.195.1662863988846;
        Sat, 10 Sep 2022 19:39:48 -0700 (PDT)
Received: from localhost ([192.55.55.56])
        by smtp.gmail.com with ESMTPSA id 38-20020a631666000000b0041d95d805d6sm2854968pgw.57.2022.09.10.19.39.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Sep 2022 19:39:48 -0700 (PDT)
Date:   Sat, 10 Sep 2022 19:39:45 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     isaku.yamahata@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: Re: [PATCH v4 11/26] KVM: Add arch hooks for PM events with empty
 stub
Message-ID: <20220911023945.GD699006@ls.amr.corp.intel.com>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
 <fa7ecd7305d011940121466f094a544c6de39ea3.1662679124.git.isaku.yamahata@intel.com>
 <YxrCX2nhOyWbbGGY@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YxrCX2nhOyWbbGGY@gao-cwp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 12:34:39PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Thu, Sep 08, 2022 at 04:25:27PM -0700, isaku.yamahata@intel.com wrote:
> >From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> >Add arch hooks for reboot, suspend, resume, and CPU-online/offline events
> >with empty stub functions.
> >
> >Suggested-by: Sean Christopherson <seanjc@google.com>
> >Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> >---
> > include/linux/kvm_host.h |  6 +++++
> > virt/kvm/Makefile.kvm    |  2 +-
> > virt/kvm/kvm_arch.c      | 44 ++++++++++++++++++++++++++++++
> > virt/kvm/kvm_main.c      | 58 +++++++++++++++++++++++++---------------
> > 4 files changed, 88 insertions(+), 22 deletions(-)
> > create mode 100644 virt/kvm/kvm_arch.c
> >
> >diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >index eab352902de7..dd2a6d98d4de 100644
> >--- a/include/linux/kvm_host.h
> >+++ b/include/linux/kvm_host.h
> >@@ -1448,6 +1448,12 @@ int kvm_arch_post_init_vm(struct kvm *kvm);
> > void kvm_arch_pre_destroy_vm(struct kvm *kvm);
> > int kvm_arch_create_vm_debugfs(struct kvm *kvm);
> > 
> >+int kvm_arch_suspend(int usage_count);
> >+void kvm_arch_resume(int usage_count);
> >+int kvm_arch_reboot(int val);
> >+int kvm_arch_online_cpu(unsigned int cpu, int usage_count);
> >+int kvm_arch_offline_cpu(unsigned int cpu, int usage_count);
> 
> Why not extract each of them with one separate patch?

Do you mean one patch for each arch callback?  They are convoluted.
See the comment below.


> >diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
> >new file mode 100644
> >index 000000000000..4748a76bcb03
> >--- /dev/null
> >+++ b/virt/kvm/kvm_arch.c
> >@@ -0,0 +1,44 @@
> >+// SPDX-License-Identifier: GPL-2.0-only
> >+/*
> >+ * kvm_arch.c: kvm default arch hooks for hardware enabling/disabling
> >+ * Copyright (c) 2022 Intel Corporation.
> >+ *
> >+ * Author:
> >+ *   Isaku Yamahata <isaku.yamahata@intel.com>
> >+ *                  <isaku.yamahata@gmail.com>
> >+ */
> >+
> >+#include <linux/kvm_host.h>
> >+
> >+/*
> >+ * Called after the VM is otherwise initialized, but just before adding it to
> >+ * the vm_list.
> >+ */
> >+__weak int kvm_arch_post_init_vm(struct kvm *kvm)
> >+{
> >+	return 0;
> >+}
> 
> use "int __weak" to comply with kernel's convension.

Will fix.

> > static int kvm_offline_cpu(unsigned int cpu)
> > {
> >+	int ret = 0;
> >+
> > 	mutex_lock(&kvm_lock);
> > 	if (kvm_usage_count) {
> > 		/*
> >@@ -5069,10 +5067,15 @@ static int kvm_offline_cpu(unsigned int cpu)
> > 		 */
> > 		preempt_disable();
> > 		hardware_disable_nolock(NULL);
> >+		ret = kvm_arch_offline_cpu(cpu, kvm_usage_count);
> >+		if (ret) {
> >+			(void)hardware_enable_nolock(NULL);
> >+			atomic_set(&hardware_enable_failed, 0);
> 
> The error-handling code ignores hardware enabling failure which looks
> weird to me. If you extract kvm_arch_offline_cpu() directly like what
> you do in patch 14 (rather than add a stub function first and then move
> some code to the stub function), the error-handling code isn't needed.

I did it for x86 tsc fix.  It relates to suspend/resume.  I would split those
- introduce suspend/resuem/reboot arch hooks
- fix x86 tsc issue
- move
- introduce cpu online/offline arch hooks
- move out PM hooks. probably this can be combined into the previous one.


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
