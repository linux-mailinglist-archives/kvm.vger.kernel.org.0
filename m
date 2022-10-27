Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D1860ECD9
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 02:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbiJ0AJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 20:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbiJ0AJq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 20:09:46 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42B11C932
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 17:09:43 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d10so17198561pfh.6
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 17:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wTlBrCwJCiqm4qgW+Kqhp/t9YirXcw72f/o9+Q65cAk=;
        b=PJUdMX7rqK8ojWNaObFA0K+NUSzbhkq2m4qukO0HXsNoPPD3vgXn18Xduwu+q10KZq
         wFSdN/ZkCjhc9neFlTJ7xf8VDXOf0XzW6X+h6JGge3Jupke4f2bd6rZMuyboykWhXBi5
         6c09TF4QraBddkzJxCcZIP87ZtjSYHfE78yaYxQTXC+4Kwcies8PmMKkCpqNgcKr+B+u
         F+GFOTz4c2tZ7vy+miBoAfia+XCnYTXpcW+wiQ2y4NQAPVkONhVF2dMNAxFwDGk+Z/d+
         dq5f6PVEjR9R4zkFHLw8kr6+c6teQz4CZhGLRz9RKFhlVFatHBiq2g/tAzG7xF5xTHHK
         k3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wTlBrCwJCiqm4qgW+Kqhp/t9YirXcw72f/o9+Q65cAk=;
        b=EMzCvqfYWbs5niDqSPV17YNSNPWkJSFMhD4uGSKQINMSMAg/7PmTsibiDO+adQNaWs
         sUZCxapMXIOpPXo4sq96cNCPNTcatC6pGR7xebhQVi9haFc1Z+YwEF1Nt9QeVdDIQOUX
         f9ctMMpFHnohNS1Fsa+ClCiQPf0z6Nm7AiK/c5sFG/nlruGEWJmWCT0LqkS0cfEF9xn5
         9HTmbAoQmviIDH7d27CvvZJbACMjJs2DkihxsD01ei10UDvXsNSPCKPmDGRBFEcgAzA4
         eHkeClBDp1cn8R3dWDZ5Zujqu2Tv/RLklvx7rPG8YouvjP6eyFXB0UFYJoR2u0TFsU19
         4jjw==
X-Gm-Message-State: ACrzQf3vN3j+R//3hOltRxozmC7EgQk1GCf/2uj3cuHI2GbtxssSZsDD
        xGNOo4h6oJAsTCx7Aq7rSUiAUQ==
X-Google-Smtp-Source: AMsMyM7dnb8oQgpA8KuYsV3JG5P6fLYeKC/AhK7EE2xTFrF/m+jhFnTTpZnjyRnFquteWADRb8Ao2w==
X-Received: by 2002:a05:6a02:113:b0:43f:3554:ff9c with SMTP id bg19-20020a056a02011300b0043f3554ff9cmr12446892pgb.578.1666829383137;
        Wed, 26 Oct 2022 17:09:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q11-20020a170902f34b00b00177324a7862sm3456406ple.45.2022.10.26.17.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 17:09:42 -0700 (PDT)
Date:   Thu, 27 Oct 2022 00:09:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, vipinsh@google.com,
        ajones@ventanamicro.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 03/18] KVM: selftests/kvm_util: helper functions for
 vcpus and threads
Message-ID: <Y1nMQp11RKTDX7HX@google.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <20221024113445.1022147-4-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024113445.1022147-4-wei.w.wang@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 24, 2022, Wei Wang wrote:
> @@ -14,4 +15,23 @@
>  	for (i = 0, vcpu = vm->vcpus[0];				\
>  		vcpu && i < KVM_MAX_VCPUS; vcpu = vm->vcpus[++i])
>  
> +void __pthread_create_with_name(pthread_t *thread, const pthread_attr_t *attr,

Can these return pthread_t instead of taking them as a param and have a "void"
return?  I'm pretty sure pthread_t is an integer type in most implementations,
i.e. can be cheaply copied by value.

> +			void *(*start_routine)(void *), void *arg, char *name);

Add a typedef for the payload, both to make it harder to screw up, and to make the
code more readable.  Does pthread really not provide one already?

> +void pthread_create_with_name(pthread_t *thread,
> +			void *(*start_routine)(void *), void *arg, char *name);

Align params, e.g.

void pthread_create_with_name(pthread_t *thread, void *(*start_routine)(void *),
			      void *arg, char *name);

Poking out past the 80 char soft limit is much preferable to arbitrary indentation.
Please fix this in all patches.
  
>  struct userspace_mem_regions {
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 1f69f5ca8356..ba3e774087fb 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2006,3 +2006,175 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
>  		break;
>  	}
>  }
> +
> +/*
> + * Create a named thread with user's attribute
> + *
> + * Input Args:
> + *   attr - the attribute of the thread to create
> + *   start_routine - the routine to run in the thread context
> + *   arg - the argument passed to start_routine
> + *   name - the name of the thread
> + *
> + * Output Args:
> + *   thread - the thread to be created
> + *
> + * Create a thread with a user specified name.
> + */

Please don't add function comments, we're opportunistically removing the existing
boilerplate ones as we go.  Most of the comments, like this one, add very little
value as it's pretty obvious what the function does and what the params are.

> +void __pthread_create_with_name(pthread_t *thread, const pthread_attr_t *attr,
> +			void *(*start_routine)(void *), void *arg, char *name)
> +{
> +	int r;
> +
> +	r = pthread_create(thread, NULL, start_routine, arg);
> +	TEST_ASSERT(!r, "thread(%s) creation failed, r = %d", name, r);

Assuming 'r' is an errno, pretty print its name with strerror().

> +	r = pthread_setname_np(*thread, name);
> +	TEST_ASSERT(!r, "thread(%s) setting name failed, r = %d", name, r);

Same here.

> +}

...

> +void vm_vcpu_threads_create(struct kvm_vm *vm,
> +		void *(*start_routine)(void *), uint32_t private_data_size)

I vote (very strongly) to not deal with allocating private data.  The private data
isn't strictly related to threads, and the vast majority of callers don't need
private data, i.e. the param is dead weight in most cases.

And unless I'm missing something, it's trivial to move to a separate helper,
though honestly even that seems like overkill.

Wait, looking further, it already is a separate helper...  Forcing a bunch of
callers to specify '0' just to eliminate one function call in a handful of cases
is not a good tradeoff.

> +void vm_vcpu_threads_private_data_alloc(struct kvm_vm *vm, uint32_t data_size)

As above, this isn't strictly related to threads, e.g. vm_alloc_vcpu_private_data()

> +{
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	vm_iterate_over_vcpus(vm, vcpu, i) {
> +		vcpu->private_data = calloc(1, data_size);
> +		TEST_ASSERT(vcpu->private_data, "%s: failed", __func__);
> +	}
> +}
> -- 
> 2.27.0
> 
