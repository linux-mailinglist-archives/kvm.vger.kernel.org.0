Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF110401241
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 02:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238428AbhIFAqS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 20:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbhIFAqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 Sep 2021 20:46:17 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0838C061575;
        Sun,  5 Sep 2021 17:45:13 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id w7so5042539pgk.13;
        Sun, 05 Sep 2021 17:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ubh9Dxu334N6pDTUezOTO6r2/WGzT8aOIrCi4LnVh9s=;
        b=kFxiqVypuyuTe23+exCK4Kt/9mBbstlJIGFKtJM179Z11djHJ/nMMlrOOnRlHbSEdn
         izvGEO1SpRJg3ir0PZXBvi+83QpKXPGuQ8e7N2B4JjAk2mPPDrvOTXzWBAEa6o1pybr2
         cu8k28NoIhMJoac90dy2ymk5m5/q+Xi1cTHLlZEF3okK1zB8FLJDBzjqNIxWlgvri4jh
         U4vbrtcNSA/fWmr2/r1Y7xD8GkIrVqbj6VXNSCCarXHSu1qbPJF2E6A0tFgmpzmtmBxJ
         xzY6J02CCW1RgObQcyynxMCs+AsupKPad6CEqN49mTbk1Ut369nOH6DLtIFpdhxb9Awy
         mliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ubh9Dxu334N6pDTUezOTO6r2/WGzT8aOIrCi4LnVh9s=;
        b=r2Yi6WDOI+Rplx3FREtGwfdaRz3GKGCFQTxJTqoHgtimUsYzUqthOSsBryn3d8p7za
         adki/D0ckAHlgPfjUtlXkSPyjM964+mmvCGuPnKSUmQGyzLgef/v2zLh0hddYB5jQgKp
         /yDcGLS73BDpfu1I+dWIVIblSOTI2Ow5a5iysczFK3Td77yn5kX+fiYZ8Po+zGrXZOcR
         YM07dFgRjaeZudRE8VlnIH0vY8CNITrIx68ANl9oV8EJsAdmuEFQhBj00MS3VdkPm1X7
         kmbjv1xq2to6y7/HgXO7cQxz8DUMuW7OQAbQ6VEpBkMp4v7ECPU5NAbSr58s7K5IkNmX
         arSg==
X-Gm-Message-State: AOAM531SmkD9saOLYkjRZiP3KmLMZ1Z2kYHFym4e2PEt3r3YH0g1mDrf
        qg7+XQliOzBvesUUCmwg+Fk=
X-Google-Smtp-Source: ABdhPJxRhUA9540Wx3K8shgq/3JrqbMwNDitZ/rj5tNIPPlRfk3rgR0Z/yR1RwwzmXlzEMEEVGhbJg==
X-Received: by 2002:a05:6a00:1c58:b0:40c:b337:622c with SMTP id s24-20020a056a001c5800b0040cb337622cmr9388683pfw.3.1630889113235;
        Sun, 05 Sep 2021 17:45:13 -0700 (PDT)
Received: from localhost (176.222.229.35.bc.googleusercontent.com. [35.229.222.176])
        by smtp.gmail.com with ESMTPSA id v7sm5395753pjk.37.2021.09.05.17.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 17:45:12 -0700 (PDT)
Date:   Mon, 6 Sep 2021 08:45:10 +0800
From:   Yao Yuan <yaoyuan0329os@gmail.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org, ehabkost@redhat.com,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 6/6] x86/kvm: add boot parameter for setting max
 number of vcpus per guest
Message-ID: <20210906004510.3r3cgigswbfivkeg@sapienza>
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-7-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903130808.30142-7-jgross@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 03:08:07PM +0200, Juergen Gross wrote:
> Today the maximum number of vcpus of a kvm guest is set via a #define
> in a header file.
>
> In order to support higher vcpu numbers for guests without generally
> increasing the memory consumption of guests on the host especially on
> very large systems add a boot parameter for specifying the number of
> allowed vcpus for guests.
>
> The default will still be the current setting of 288. The value 0 has
> the special meaning to limit the number of possible vcpus to the
> number of possible cpus of the host.
>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt | 7 +++++++
>  arch/x86/include/asm/kvm_host.h                 | 5 ++++-
>  arch/x86/kvm/x86.c                              | 9 ++++++++-
>  3 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 37e194299311..b9641c9989ef 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2435,6 +2435,13 @@
>           feature (tagged TLBs) on capable Intel chips.
>           Default is 1 (enabled)
>
> +	kvm.max_vcpus=	[KVM,X86] Set the maximum allowed numbers of vcpus per
> +			guest. The special value 0 sets the limit to the number
> +			of physical cpus possible on the host (including not
> +			yet hotplugged cpus). Higher values will result in
> +			slightly higher memory consumption per guest.
> +			Default: 288
> +
>   kvm.vcpu_id_add_bits=
>           [KVM,X86] The vcpu-ids of guests are sparse, as they
>           are constructed by bit-wise concatenation of the ids of
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6c28d0800208..a4ab387b0e1c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -38,7 +38,8 @@
>
>  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
>
> -#define KVM_MAX_VCPUS 288
> +#define KVM_DEFAULT_MAX_VCPUS 288
> +#define KVM_MAX_VCPUS max_vcpus
>  #define KVM_SOFT_MAX_VCPUS 240
>  #define KVM_MAX_VCPU_ID kvm_max_vcpu_id()
>  /* memory slots that are not exposed to userspace */
> @@ -1588,6 +1589,8 @@ extern u64  kvm_max_tsc_scaling_ratio;
>  extern u64  kvm_default_tsc_scaling_ratio;
>  /* bus lock detection supported? */
>  extern bool kvm_has_bus_lock_exit;
> +/* maximum number of vcpus per guest */
> +extern unsigned int max_vcpus;
>  /* maximum vcpu-id */
>  unsigned int kvm_max_vcpu_id(void);
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ff142b6dd00c..49c3d91c559e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -188,9 +188,13 @@ module_param(pi_inject_timer, bint, S_IRUGO | S_IWUSR);
>  static int __read_mostly vcpu_id_add_bits = -1;
>  module_param(vcpu_id_add_bits, int, S_IRUGO);
>
> +unsigned int __read_mostly max_vcpus = KVM_DEFAULT_MAX_VCPUS;
> +module_param(max_vcpus, uint, S_IRUGO);
> +EXPORT_SYMBOL_GPL(max_vcpus);
> +
>  unsigned int kvm_max_vcpu_id(void)
>  {
> -	int n_bits = fls(KVM_MAX_VCPUS - 1);
> +	int n_bits = fls(max_vcpus - 1);

A quesintion here: the parameter "vcpu_id_add_bits" also depends
on the "max_vcpus", we can't calculate the "vcpu_id_add_bits" from
"max_vcpus" because KVM has no topologically knowledge to determine
bits needed for each socket/core/thread level, right?

>
>   if (vcpu_id_add_bits < -1 || vcpu_id_add_bits > (32 - n_bits)) {
>       pr_err("Invalid value of vcpu_id_add_bits=%d parameter!\n",
> @@ -11033,6 +11037,9 @@ int kvm_arch_hardware_setup(void *opaque)
>   if (boot_cpu_has(X86_FEATURE_XSAVES))
>       rdmsrl(MSR_IA32_XSS, host_xss);
>
> +	if (max_vcpus == 0)
> +		max_vcpus = num_possible_cpus();
> +
>   kvm_pcpu_vcpu_mask = __alloc_percpu(KVM_VCPU_MASK_SZ,
>                       sizeof(unsigned long));
>   kvm_hv_vp_bitmap = __alloc_percpu(KVM_HV_VPMAP_SZ, sizeof(u64));
> --
> 2.26.2
>
