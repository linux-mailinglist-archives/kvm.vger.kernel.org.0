Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E448D3D1219
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 17:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbhGUOea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 10:34:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239515AbhGUOe3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 10:34:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626880505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QaTP1Yo6qFFIt4Y2xC3JPRyG4PRe8kuKhGKAihywiRs=;
        b=Gzuac4TGVwY1idv6sM3eG7qo6UGOrsnGLnz/4ttRBze7qHrUpBSDgFTRKEaSoOw/QVLm5n
        XLmS5zOWRQXTfqI6zWoz5ffgu3yYwb0YsC+3mMWekOpToj/O+GWxEWHlImtEN0mPobC9pl
        zYqFoMP4nIxNSMhj1CIleYpd0MA2JPM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-VmG1LjKrPBCb2VKEbaZURw-1; Wed, 21 Jul 2021 11:15:02 -0400
X-MC-Unique: VmG1LjKrPBCb2VKEbaZURw-1
Received: by mail-il1-f199.google.com with SMTP id g9-20020a92cda90000b029020cc3319a86so1746752ild.18
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 08:15:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QaTP1Yo6qFFIt4Y2xC3JPRyG4PRe8kuKhGKAihywiRs=;
        b=SJ2qWU/Oe9BeOoFXUr4hGtxOs+F4Hukv1RyAkqKfOkkrBxdKldM4hBWZULP0KZODy7
         lyYeKsm6pGlkvhAsICmuti3E/Qq+P+SpsWewAGyrXy8QLPgedncDn+eGtoUVMMx9R5J9
         63lQCZt1tL20Rk9/WGtri+/xF2zcp+rCsZ9KGikz3U2ceemYq85J0+g0yWV7iIn1j4Ic
         NjopMTn2Fh5AB7JfodujAUzX4M/Vi63IskrsltkOTKqvbTbOJjeCDte+4bRS59ElOy3e
         orPKOt+7nQgKzsj1I6EhQvd3B7g1XrmTF78Br6s1TmPWoqQ7qNcDtgbzAUNUq1OuNRV0
         l8IQ==
X-Gm-Message-State: AOAM532q9w+VkF7jqWB3U/pfFpLJryVHgrgnkBjFIDB/wgpLUJ2hqtLd
        /i5yvNA8EjqeTmv+4RdK4wVztAFv2AOJ6qO95A5cY41l0td9WC3lqnhTy5qj5b/SbJbACTcc308
        NDTxFxC8maK4t
X-Received: by 2002:a92:cb52:: with SMTP id f18mr24584246ilq.97.1626880501559;
        Wed, 21 Jul 2021 08:15:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzd/FbgpVsG1uAQQs/xRFLiKXf0pWWdYmq3RBA6j5gX0EFKv9+U0ZQHs17k7En54hjmVGaIUw==
X-Received: by 2002:a92:cb52:: with SMTP id f18mr24584222ilq.97.1626880501393;
        Wed, 21 Jul 2021 08:15:01 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id p18sm13090910ile.25.2021.07.21.08.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 08:15:00 -0700 (PDT)
Date:   Wed, 21 Jul 2021 17:14:58 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Raghavendra Rao Anata <rananta@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 06/12] selftests: KVM: Add helpers for vCPU device
 attributes
Message-ID: <20210721151458.bsfbjtk7rmlupfve@gator>
References: <20210716212629.2232756-1-oupton@google.com>
 <20210716212629.2232756-7-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716212629.2232756-7-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 16, 2021 at 09:26:23PM +0000, Oliver Upton wrote:
> vCPU file descriptors are abstracted away from test code in KVM
> selftests, meaning that tests cannot directly access a vCPU's device
> attributes. Add helpers that tests can use to get at vCPU device
> attributes.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  9 +++++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 38 +++++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index a8ac5d52e17b..1b3ef5757819 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -240,6 +240,15 @@ int _kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
>  int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
>  		      void *val, bool write);
>  
> +int _vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +			  uint64_t attr);
> +int vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +			 uint64_t attr);
> +int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +			  uint64_t attr, void *val, bool write);
> +int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +			 uint64_t attr, void *val, bool write);
> +
>  const char *exit_reason_str(unsigned int exit_reason);
>  
>  void virt_pgd_alloc(struct kvm_vm *vm);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 10a8ed691c66..b595e7dc3fc5 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2040,6 +2040,44 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
>  	return ret;
>  }
>  
> +int _vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +			  uint64_t attr)
> +{
> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +
> +	TEST_ASSERT(vcpu, "nonexistent vcpu id: %d", vcpuid);
> +
> +	return _kvm_device_check_attr(vcpu->fd, group, attr);
> +}
> +
> +int vcpu_has_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +				 uint64_t attr)
> +{
> +	int ret = _vcpu_has_device_attr(vm, vcpuid, group, attr);
> +
> +	TEST_ASSERT(!ret, "KVM_HAS_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
> +	return ret;
> +}
> +
> +int _vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +			     uint64_t attr, void *val, bool write)
> +{
> +	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
> +
> +	TEST_ASSERT(vcpu, "nonexistent vcpu id: %d", vcpuid);
> +
> +	return _kvm_device_access(vcpu->fd, group, attr, val, write);
> +}
> +
> +int vcpu_access_device_attr(struct kvm_vm *vm, uint32_t vcpuid, uint32_t group,
> +			    uint64_t attr, void *val, bool write)
> +{
> +	int ret = _vcpu_access_device_attr(vm, vcpuid, group, attr, val, write);
> +
> +	TEST_ASSERT(!ret, "KVM_SET|GET_DEVICE_ATTR IOCTL failed, rc: %i errno: %i", ret, errno);
> +	return ret;
> +}


Reviewed-by: Andrew Jones <drjones@redhat.com>


The 'assert !ret's are correct here. I see they are not correct in 

 kvm_device_check_attr
 kvm_create_device
 kvm_device_access

though, as they are 'assert ret >= 0', but the documentation says 0 on
success. It'd be nice to get that fixed before we build more API on top
of it.

Thanks,
drew


> +
>  /*
>   * VM Dump
>   *
> -- 
> 2.32.0.402.g57bb445576-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

