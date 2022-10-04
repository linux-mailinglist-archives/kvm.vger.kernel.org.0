Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9903D5F3A71
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 02:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiJDAQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 20:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJDAQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 20:16:25 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D296A23162;
        Mon,  3 Oct 2022 17:16:24 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b15so3283116pje.1;
        Mon, 03 Oct 2022 17:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=XkfaP4z8rj8m1nh6hzVG/ifhPmRZtFcqbAYS1A6pGEo=;
        b=lKYgrQhQnpLRRsjvAnLEKjzljiOftYXFK3YUYDNscfVaWakvRjcq6K41PYn/5zsJYv
         //nibRVRyneMtjhIi5meWQxp+foUp19LDSPTEOB/mM1jVUdlVmD+iqbW2nm592LFIf1w
         t4yMdwOCKYFX8QfsEH5B73FCyN5s/0QbJVI4jhaj5TTBbCCppceh/OxOVvXQBSr8zcyx
         mgjHU3rFpHqVtMVwClaouaEHj43fvxfRQFJEVLNl9PXtfHQPrbHdfpBC8bhcEYWyzLjg
         UwMWuoovtQLW8L8i5KM+xXcTzgSQPK8v4ERUFw6xSysPdHwYArR6sWOvRAPiR/u5r28O
         b5yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=XkfaP4z8rj8m1nh6hzVG/ifhPmRZtFcqbAYS1A6pGEo=;
        b=oUAcqyEw9wOhy2y/3yzkH5QlMs75ggVLYlSbJXmg9iUbXN6wZNIihVe83ogB57ujIu
         rKJkHbp5qwEOkB+HgkkvP3EztvHnus/8seqtHy6gK5g/1YpeqDq2z/Fh/1V3ZjnzoOFw
         MTpgcohp7GhFEBvwOt0HgZV9p6sQZFmUJOsuE+Ha5jWN0P4Y6f1D9b4QoaXtVVD0/o2/
         IdqyXa1B4f6NsBvlKHsLk0moChCJNzcUkqbksqPQWvBTIvJco6VaQRQncMm2GGDJ+KLx
         kIkOka6L+wBLKPKKvABbigxiXwy8wa137rRcdvQjwT2kEO9SX/bqDzcokV9jSEA/M52U
         rQ3w==
X-Gm-Message-State: ACrzQf11alvk1gtDmdxV62AQWEVM1XQZw9QEvwTqV23cxXr0O8XTnX+c
        Co1lLyruS2X4fq0YlrjbSyw=
X-Google-Smtp-Source: AMsMyM4sosEd7kzlqa8zfN+k4HCTX1fp20C+rItBZKgaFBCnAWL/PTO6jbaSlNyqa+WBAHITlPsm9w==
X-Received: by 2002:a17:90b:30d5:b0:20a:6453:43f with SMTP id hi21-20020a17090b30d500b0020a6453043fmr14904562pjb.74.1664842584177;
        Mon, 03 Oct 2022 17:16:24 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id j10-20020a17090a31ca00b0020aacde1964sm1839620pjf.32.2022.10.03.17.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 17:16:23 -0700 (PDT)
Date:   Mon, 3 Oct 2022 17:16:21 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 10/30] KVM: Add arch hooks when VM is added/deleted
Message-ID: <20221004001621.GJ2414580@ls.amr.corp.intel.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
 <aab342d576fe22b8f5b27e61d4fc635d45a4f866.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aab342d576fe22b8f5b27e61d4fc635d45a4f866.1663869838.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 11:20:39AM -0700,
isaku.yamahata@intel.com wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> and pass kvm_usage_count with kvm_lock.  Move kvm_arch_post_init_vm() under
> kvm_arch_add_vm().  Replace enable/disable_hardware_all() with the default
> implementation of kvm_arch_add/del_vm().  Later kvm_arch_post_init_vm() is
> deleted once x86 overrides kvm_arch_add_vm().
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  include/linux/kvm_host.h |   2 +
>  virt/kvm/kvm_main.c      | 121 ++++++++++++++++++++-------------------
>  2 files changed, 65 insertions(+), 58 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index eab352902de7..3fbb01bbac98 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1445,6 +1445,8 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
>  bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
>  bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
>  int kvm_arch_post_init_vm(struct kvm *kvm);
> +int kvm_arch_add_vm(struct kvm *kvm, int usage_count);
> +int kvm_arch_del_vm(int usage_count);
>  void kvm_arch_pre_destroy_vm(struct kvm *kvm);
>  int kvm_arch_create_vm_debugfs(struct kvm *kvm);
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c4b908553726..e2c8823786ff 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -142,8 +142,9 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
>  #define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
>  			.open		= kvm_no_compat_open
>  #endif
> -static int hardware_enable_all(void);
> -static void hardware_disable_all(void);
> +static void hardware_enable_nolock(void *junk);
> +static void hardware_disable_nolock(void *junk);
> +static void kvm_del_vm(void);
>  
>  static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
>  
> @@ -1106,6 +1107,41 @@ int __weak kvm_arch_post_init_vm(struct kvm *kvm)
>  	return 0;
>  }
>  
> +/*
> + * Called after the VM is otherwise initialized, but just before adding it to
> + * the vm_list.
> + */
> +int __weak kvm_arch_add_vm(struct kvm *kvm, int usage_count)
> +{
> +	int r = 0;
> +
> +	if (usage_count != 1)
> +		return 0;

Oops. This line should be.
+               return kvm_arch_post_init_vm(kvm);

"KVM: x86: Duplicate arch callbacks related to pm events and compat check"
should have same line. "KVM: Eliminate kvm_arch_post_init_vm()" should include
kvm_mmu_post_init_vm().
It creates a kernel thread. kvm unit test didn't catch it.

Thanks,

> +
> +	atomic_set(&hardware_enable_failed, 0);
> +	on_each_cpu(hardware_enable_nolock, NULL, 1);
> +
> +	if (atomic_read(&hardware_enable_failed)) {
> +		r = -EBUSY;
> +		goto err;
> +	}
> +
> +	r = kvm_arch_post_init_vm(kvm);
> +err:
> +	if (r)
> +		on_each_cpu(hardware_disable_nolock, NULL, 1);
> +	return r;
> +}
> +
> +int __weak kvm_arch_del_vm(int usage_count)
> +{
> +	if (usage_count)
> +		return 0;
> +
> +	on_each_cpu(hardware_disable_nolock, NULL, 1);
> +	return 0;
> +}
> +
>  /*
>   * Called just after removing the VM from the vm_list, but before doing any
>   * other destruction.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
