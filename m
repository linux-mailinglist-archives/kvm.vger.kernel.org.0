Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF4360ECBB
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 01:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbiJZXsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 19:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbiJZXsH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 19:48:07 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA4ADFB79
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 16:48:03 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id l6so12056425pjj.0
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 16:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RPJfgsW8GCds2stBYuWG1R4t2YUH8WTi/WK0qloe8kE=;
        b=KzG4XSEb5Jtv47CxSQ6gk+IZdm3IW7ifGSeeW4BGFE2fg5cef4hqDoQ1OnrzDScvbg
         TOj/pmVi1xpa9CqQG6ob4976nip0lumClaVr2UD0go+rMEI9MaG6oxkCAoQYHUgiDzq3
         2LIpuVuXJ4XFxFjwdAKFtv7/kxXStClfHc//v3dElo3MXsyUkW0ae900P40p+F2XsO5S
         fxrNmp0W6VzcvcGXu3IP3SH/hHTJQEOcKefvIdBodBVXYrbK/MxPqam21WFMM1kxRkWq
         nmD5ytyINWO1SP1fwPKXGxunbVP2cQFyf+v1uuq3vDjQeRoMJu1xu3whY7kbXXCyt6AE
         V8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RPJfgsW8GCds2stBYuWG1R4t2YUH8WTi/WK0qloe8kE=;
        b=B7S9btIJM+BQ7ZOTo9mihdQFP6nW9K/u6DrOGWpIQ7nL1f/d5lstBfOdjt5rdLgDYq
         1Ljc/Eg3C3/vJZvK+aq9MB5OZM4mn5EqRMLSKYXXXIOv57z1kZah/lX4fucY8Q2ArE/A
         3GsJtucP5VdTbIq1DvQJkmu0eIxB83/2Cbd+CC+m1pV3x/LkYg1NAJQsb+YYRSoG0W7C
         au8iKIMVj1i0addK5El7dPdsdno/OGcFbUFkBmJQyImB1FqVsutMR7AcolQt1qmFH+PW
         eBadps2H1FnTnA8Q0alLBrdaDiB6Mp7MRXHaHhm+Q+M6rCCBsHLH09kPNjTZHj3/PJLI
         4D4A==
X-Gm-Message-State: ACrzQf0pfSJi764Q9drQeILc89h4EutZTe9j/zVcb84SzJXZtWdCegV/
        1F2vSCxXED65OWeSRZPwnHkqBQ==
X-Google-Smtp-Source: AMsMyM7WEr0YvVBUWuAlikGUM4QCON1Ej19mMqqNzj/VFl/ik6ajbF1ptb1yGPUqvIyZHp4Rt3QjJQ==
X-Received: by 2002:a17:90b:3b44:b0:213:34f7:facb with SMTP id ot4-20020a17090b3b4400b0021334f7facbmr7012672pjb.150.1666828083027;
        Wed, 26 Oct 2022 16:48:03 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y194-20020a6264cb000000b0053e468a78a8sm3511127pfb.158.2022.10.26.16.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 16:48:02 -0700 (PDT)
Date:   Wed, 26 Oct 2022 23:47:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, vipinsh@google.com,
        ajones@ventanamicro.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 01/18] KVM: selftests/kvm_util: use array of pointers
 to maintain vcpus in kvm_vm
Message-ID: <Y1nHL5BUoWPqUtt9@google.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <20221024113445.1022147-2-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024113445.1022147-2-wei.w.wang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 24, 2022, Wei Wang wrote:
> Each vcpu has an id associated with it and is intrinsically faster
> and easier to be referenced by indexing into an array with "vcpu->id",
> compared to using a list of vcpus in the current implementation. Change
> the vcpu list to an array of vcpu pointers. Users then don't need to
> allocate such a vcpu array on their own, and instead, they can reuse
> the one maintained in kvm_vm.
> 
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  4 +++
>  .../selftests/kvm/include/kvm_util_base.h     |  3 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 34 ++++++-------------
>  tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  2 +-
>  4 files changed, 17 insertions(+), 26 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index c9286811a4cb..5d5c8968fb06 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -10,4 +10,8 @@
>  #include "kvm_util_base.h"
>  #include "ucall_common.h"
>  
> +#define vm_iterate_over_vcpus(vm, vcpu, i)				\

vm_for_each_vcpu() is more aligned with existing KVM terminology.

> +	for (i = 0, vcpu = vm->vcpus[0];				\
> +		vcpu && i < KVM_MAX_VCPUS; vcpu = vm->vcpus[++i])

I hate pointer arithmetic more than most people, but in this case it avoids the
need to pass in 'i', which in turn cuts down on boilerplate and churn.

>  #endif /* SELFTEST_KVM_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index e42a09cd24a0..c90a9609b853 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -45,7 +45,6 @@ struct userspace_mem_region {
>  };
>  
>  struct kvm_vcpu {
> -	struct list_head list;
>  	uint32_t id;
>  	int fd;
>  	struct kvm_vm *vm;
> @@ -75,7 +74,6 @@ struct kvm_vm {
>  	unsigned int pa_bits;
>  	unsigned int va_bits;
>  	uint64_t max_gfn;
> -	struct list_head vcpus;
>  	struct userspace_mem_regions regions;
>  	struct sparsebit *vpages_valid;
>  	struct sparsebit *vpages_mapped;
> @@ -92,6 +90,7 @@ struct kvm_vm {
>  	int stats_fd;
>  	struct kvm_stats_header stats_header;
>  	struct kvm_stats_desc *stats_desc;
> +	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];

We can dynamically allocate the array without too much trouble, though I'm not
sure it's worth shaving the few KiB of memory.  For __vm_create(), the number of
vCPUs is known when the VM is created.  For vm_create_barebones(), we could do
the simple thing of allocating KVM_MAX_VCPU.

> @@ -534,6 +533,10 @@ __weak void vcpu_arch_free(struct kvm_vcpu *vcpu)
>  static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
>  {
>  	int ret;
> +	uint32_t vcpu_id = vcpu->id;
> +
> +	TEST_ASSERT(!!vm->vcpus[vcpu_id], "vCPU%d wasn't added\n", vcpu_id);

This is unecessary, there's one caller and it's iterating over the array of vCPUs.
