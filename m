Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE96435CA3
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 10:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhJUIK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 04:10:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38812 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231474AbhJUIKw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 04:10:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634803716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IxdPLnDhVM2NRlBbE67cvgUXyH2+5Z7DhAGYZcnVmKY=;
        b=FZV6FZ1yiLJq4JEmygEvFjRQQB+pN0vXKe77Psq/Z9KJq7LaUjGhvlXwazFjaFSy1WMYNz
        3aZnHxvP+1z8EAf1+WRwJMJc4aEQmpNBTlLY5T53Xo1jMnr7wEZZ67L22QnJ9kT9pUxErr
        hAHE7j1T92S4MISC0F+y2XAI6U+pCTI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-eiiz5LYZOZeN7X4gin_TuQ-1; Thu, 21 Oct 2021 04:08:34 -0400
X-MC-Unique: eiiz5LYZOZeN7X4gin_TuQ-1
Received: by mail-wr1-f71.google.com with SMTP id d13-20020adfa34d000000b00160aa1cc5f1so11030432wrb.14
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 01:08:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=IxdPLnDhVM2NRlBbE67cvgUXyH2+5Z7DhAGYZcnVmKY=;
        b=yeFkUrnWXrP1mOcI60sIKeKQztXwaBFALLUFfaEuYzCpwq2PRZeU51jwo95BIq36WW
         xHyPnvbHshjK2S5RAxZievulF9CmaDBBGC7Br17Aeo3GxvfOwIHp1ouKH8RPWBKl3Ug1
         OF0D3dzDCz+Pst73JEH+ZN8B2cYJZStqmfzG94W9801DKlcjChDZpfnSgFCCiBb+F7Gn
         FqMyGzxqbY38ZSXfOdXk9PI6ne+AHm4fLAGRVKfbdqeNfmNqH3kbqT5KGJtMd/e/no+i
         4ws2HxdxGv/4iYcqbWMvv+oUmEO714UizqLHlOnP1rUSiwYAhkYre5vao5bIZXxQyD88
         gmIQ==
X-Gm-Message-State: AOAM531elRhJeeTofWdPwYAk+6NM04jgUKh3Boonew5R+CGt3V19OPk6
        XN0qFniw95t5YVQM7mH//lPSJ1G+q0mPw+7qQFZ5tEM9nBzVqfL8XDoBE/sdPSS84EZC6jpF+of
        mi7AsQmYJb7SB
X-Received: by 2002:adf:e10a:: with SMTP id t10mr5400092wrz.384.1634803713461;
        Thu, 21 Oct 2021 01:08:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiuNF4xkkilzqVwocd6UV8p1JW7uWD8TQqcxyg1c53RE+iRtV5HLzuLeJn64jISdSlghiMZA==
X-Received: by 2002:adf:e10a:: with SMTP id t10mr5400060wrz.384.1634803713191;
        Thu, 21 Oct 2021 01:08:33 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u16sm6367134wmc.21.2021.10.21.01.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 01:08:32 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 1/2] KVM: x86: Add vendor name to kvm_x86_ops, use it
 for error messages
In-Reply-To: <20211018183929.897461-2-seanjc@google.com>
References: <20211018183929.897461-1-seanjc@google.com>
 <20211018183929.897461-2-seanjc@google.com>
Date:   Thu, 21 Oct 2021 10:08:31 +0200
Message-ID: <87k0i6x0jk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Paul pointed out the error messages when KVM fails to load are unhelpful
> in understanding exactly what went wrong if userspace probes the "wrong"
> module.
>
> Add a mandatory kvm_x86_ops field to track vendor module names, kvm_intel
> and kvm_amd, and use the name for relevant error message when KVM fails
> to load so that the user knows which module failed to load.
>
> Opportunistically tweak the "disabled by bios" error message to clarify
> that _support_ was disabled, not that the module itself was magically
> disabled by BIOS.
>

...

> Suggested-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 ++
>  arch/x86/kvm/svm/svm.c          | 2 ++
>  arch/x86/kvm/vmx/vmx.c          | 2 ++
>  arch/x86/kvm/x86.c              | 8 +++++---
>  4 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 80f4b8a9233c..b05bfcc72042 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1302,6 +1302,8 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
>  }
>  
>  struct kvm_x86_ops {
> +	const char *name;
> +
>  	int (*hardware_enable)(void);
>  	void (*hardware_disable)(void);
>  	void (*hardware_unsetup)(void);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 89077160d463..cee4915d2ce3 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4580,6 +4580,8 @@ static int svm_vm_init(struct kvm *kvm)
>  }
>  
>  static struct kvm_x86_ops svm_x86_ops __initdata = {
> +	.name = "kvm_amd",
> +
>  	.hardware_unsetup = svm_hardware_teardown,
>  	.hardware_enable = svm_hardware_enable,
>  	.hardware_disable = svm_hardware_disable,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1c8b2b6e7ed9..c147438eaafc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7568,6 +7568,8 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
>  }
>  
>  static struct kvm_x86_ops vmx_x86_ops __initdata = {
> +	.name = "kvm_intel",
> +
>  	.hardware_unsetup = hardware_unsetup,
>  
>  	.hardware_enable = hardware_enable,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c59b63c56af9..e966e9cdd805 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8539,18 +8539,20 @@ int kvm_arch_init(void *opaque)
>  	int r;
>  
>  	if (kvm_x86_ops.hardware_enable) {
> -		printk(KERN_ERR "kvm: already loaded the other module\n");
> +		pr_err("kvm: already loaded vendor module '%s'\n", kvm_x86_ops.name);
>  		r = -EEXIST;
>  		goto out;
>  	}
>  
>  	if (!ops->cpu_has_kvm_support()) {
> -		pr_err_ratelimited("kvm: no hardware support\n");
> +		pr_err_ratelimited("kvm: no hardware support for '%s'\n",
> +				   ops->runtime_ops->name);
>  		r = -EOPNOTSUPP;
>  		goto out;
>  	}
>  	if (ops->disabled_by_bios()) {
> -		pr_err_ratelimited("kvm: disabled by bios\n");
> +		pr_err_ratelimited("kvm: support for '%s' disabled by bios\n",
> +				   ops->runtime_ops->name);


I'd suggest we change this to 

		pr_err_ratelimited("kvm: %s: virtualization disabled in BIOS\n",
				   ops->runtime_ops->name);

or something like that as generally, it makes little sense to search for
'KVM' in BIOS settings. You need too look for either 'Virtualization' or
VT-x/AMD-v.

>  		r = -EOPNOTSUPP;
>  		goto out;
>  	}

-- 
Vitaly

