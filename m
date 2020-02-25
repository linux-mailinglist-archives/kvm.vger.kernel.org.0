Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD9316E93E
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 16:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730952AbgBYPC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 10:02:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29178 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730807AbgBYPC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 10:02:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582642977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QsUuUqLhrHe8PUYsgfmY/tzShcrlmSfcdDzSbxrzr9g=;
        b=GH43+Gi2soCzu5IBWmG4jViMShCNS+sDicbCvbMuGXGxalhs3DRAF7+no73SOu8xDAnwFM
        ZQl7UyXkk8hPesbwkK8RtYdOg0UQlC064OFsFF30kO9FC2xTvAH2MjM746qSyIou7V5eQt
        /UTWz/U6018QSKN2zOOjY0iT3S4i9pI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-CW5mk9G4Mbez6k5Pf3ptdg-1; Tue, 25 Feb 2020 10:02:56 -0500
X-MC-Unique: CW5mk9G4Mbez6k5Pf3ptdg-1
Received: by mail-wm1-f69.google.com with SMTP id y125so702302wmg.1
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 07:02:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QsUuUqLhrHe8PUYsgfmY/tzShcrlmSfcdDzSbxrzr9g=;
        b=LTgsQnLUr5k7qUXFkGexyHxpsBARLUEiVv9pkEp3NxN0Ij5hJONoSA7uvpHY1MbhiB
         MRFujzowJ1ER8D/1yP81itrQoYAREaQokrZqphVF+rroK4LDinkiH5scUBtZVGF5HdQt
         cR8fMmd4fmmy74N+FXn5hs9e7hMbZP72rF4r/geGg6uEUs+QKj4EqvitXL9ANbWVCN0H
         Daw2y291xl8VMSeCDSWTwRDkVn9L9m99PqSPGlMAs+YZ6VTjS7qgtB8oOO97PbTAwX3u
         BmlExHB5vyIEl3x94nAXWYWXwJ7StdI4IjEuT9pONQv5vK+O83A5S6KIejO7E77FvIvV
         vXvA==
X-Gm-Message-State: APjAAAU5QUYsMTMpfWzgwWJ7NGT1oYmoijaAUt5eAVCyatYf7bwOf2GQ
        0O1KJuc6NxYsOPv8dfQNSCjpXxcHbIC1IfhxdBcgHByXl+ztebped3fbsZiiDgssGfJsnTqMHCF
        9msHCGD4c6CX2
X-Received: by 2002:a5d:6191:: with SMTP id j17mr70305548wru.427.1582642974717;
        Tue, 25 Feb 2020 07:02:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqzus9h6OKiJ36YQf4+GPEntJYdPgq2qYygP3Yinuve1nFXgN3mUnuND1RVVgpSgd5fqWu9wqQ==
X-Received: by 2002:a5d:6191:: with SMTP id j17mr70305526wru.427.1582642974464;
        Tue, 25 Feb 2020 07:02:54 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z8sm24250673wrv.74.2020.02.25.07.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 07:02:53 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 61/61] KVM: x86: Move VMX's host_efer to common x86 code
In-Reply-To: <20200201185218.24473-62-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-62-sean.j.christopherson@intel.com>
Date:   Tue, 25 Feb 2020 16:02:53 +0100
Message-ID: <8736aylnfm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move host_efer to common x86 code and use it for CPUID's is_efer_nx() to
> avoid constantly re-reading the MSR.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 ++
>  arch/x86/kvm/cpuid.c            | 5 +----
>  arch/x86/kvm/vmx/vmx.c          | 3 ---
>  arch/x86/kvm/vmx/vmx.h          | 1 -
>  arch/x86/kvm/x86.c              | 5 +++++
>  5 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4165d3ef11e4..a2a091d328c6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1257,6 +1257,8 @@ struct kvm_arch_async_pf {
>  	bool direct_map;
>  };
>  
> +extern u64 __read_mostly host_efer;
> +

I'm surprised we don't actually cache MSR_EFER in some common x86 code
already.

>  extern struct kvm_x86_ops *kvm_x86_ops;
>  extern struct kmem_cache *x86_fpu_cache;
>  
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 3d287fc6eb6e..e8beb1e542a8 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -134,10 +134,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>  
>  static int is_efer_nx(void)
>  {
> -	unsigned long long efer = 0;
> -
> -	rdmsrl_safe(MSR_EFER, &efer);
> -	return efer & EFER_NX;
> +	return host_efer & EFER_NX;
>  }
>  
>  static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e349689ac0cf..0009066e2009 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -433,7 +433,6 @@ static const struct kvm_vmx_segment_field {
>  	VMX_SEGMENT_FIELD(LDTR),
>  };
>  
> -u64 host_efer;
>  static unsigned long host_idt_base;
>  
>  /*
> @@ -7577,8 +7576,6 @@ static __init int hardware_setup(void)
>  	struct desc_ptr dt;
>  	int r, i, ept_lpage_level;
>  
> -	rdmsrl_safe(MSR_EFER, &host_efer);
> -
>  	store_idt(&dt);
>  	host_idt_base = dt.address;
>  
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 70eafa88876a..0e50fbcb8413 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -12,7 +12,6 @@
>  #include "vmcs.h"
>  
>  extern const u32 vmx_msr_index[];
> -extern u64 host_efer;
>  
>  extern u32 get_umwait_control_msr(void);
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b40488fd2969..2103101eca78 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -185,6 +185,9 @@ static struct kvm_shared_msrs __percpu *shared_msrs;
>  				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>  				| XFEATURE_MASK_PKRU)
>  
> +u64 __read_mostly host_efer;
> +EXPORT_SYMBOL_GPL(host_efer);
> +
>  static u64 __read_mostly host_xss;
>  
>  struct kvm_stats_debugfs_item debugfs_entries[] = {
> @@ -9590,6 +9593,8 @@ int kvm_arch_hardware_setup(void)
>  {
>  	int r;
>  
> +	rdmsrl_safe(MSR_EFER, &host_efer);
> +
>  	kvm_set_cpu_caps();
>  
>  	r = kvm_x86_ops->hardware_setup();

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

