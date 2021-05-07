Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388C8376B17
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 22:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhEGUPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 16:15:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50056 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229905AbhEGUPs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 16:15:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620418488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TnHESXa93QYCM8UH+VCHFhVjEIMfUQrgYtHFTFsHEvo=;
        b=TyMqaJBgPFHvZV4TM981+yRJlNHIcTngyuoUp/xM5plzkgAahWAwckvGEIGq9riMweHNyM
        thV9xmsBlKJ6l2IM1VxwZLPQn0TqVxGr0kR0rvy6ViAMPjZLvVLE2ql6afsiT6YedzLt5S
        NYQNuI+NJo3PHyS4Mzj3uQaW7ur53fI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-AHEFTwThP92dJzG-vAwfKA-1; Fri, 07 May 2021 16:14:46 -0400
X-MC-Unique: AHEFTwThP92dJzG-vAwfKA-1
Received: by mail-ed1-f69.google.com with SMTP id y19-20020a0564022713b029038a9f36060dso5019272edd.4
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 13:14:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TnHESXa93QYCM8UH+VCHFhVjEIMfUQrgYtHFTFsHEvo=;
        b=RWGr8WKmb2iIZeDke9qZKwqdqaFI6sWSkWGtChqoGpsX3ZajgbjLVX2VyrT4vk0z+n
         eM65Qw0PuKKQWFeewevKvQvXvRFPE41EeFy6olKC3hvpcGPI1XcHVcJcFuBpZqknINqp
         88pFzb9GVyuWachTlixtHyDeJKy2ySMnDpqMrG8GlVD9l+5dE8KOyKu1iA3cdMfqKLDj
         AuDYiAYqpLRXChZDYvbdI5EGG+lAnHvxkx8/lX6iRgykrucbwjqLieW53RgT9z9bN1AD
         PmKlUFluMGPLXnBJTHtdygXOUmCkefk7o1Y29uZBWVGBP+19A7yQ82/n25DdkAe4sNqP
         cQOg==
X-Gm-Message-State: AOAM530XeQJnNDeK4PuiyG5I/+x5oCXuW9ovjAv++ia1w98wNSjfS77I
        szeBrqKrIxy6yYjfj+lt2TD+R67ynesXaEBz9xXhCEu7dTls3WQMmO923W1+38mo1MnZvZ+pg3s
        Xob6/SEn/oON6
X-Received: by 2002:a05:6402:2d6:: with SMTP id b22mr13644434edx.274.1620418485596;
        Fri, 07 May 2021 13:14:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwd5KZIwYKeFk7YYMqZhKIaiBTKb6DcFk7gfUDyJtCHsVrAH3r1gHjxpLOkBznW3F4hf6bQqA==
X-Received: by 2002:a05:6402:2d6:: with SMTP id b22mr13644409edx.274.1620418485395;
        Fri, 07 May 2021 13:14:45 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id b8sm4003865ejc.29.2021.05.07.13.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 13:14:44 -0700 (PDT)
Date:   Fri, 7 May 2021 22:14:43 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH] KVM: selftests: Print a message if /dev/kvm is missing
Message-ID: <20210507201443.nvtmntp3tgeapwnw@gator.home>
References: <20210507190559.425518-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507190559.425518-1-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021 at 07:05:59PM +0000, David Matlack wrote:
> If a KVM selftest is run on a machine without /dev/kvm, it will exit
> silently. Make it easy to tell what's happening by printing an error
> message.
> 
> Opportunistically consolidate all codepaths that open /dev/kvm into a
> single function so they all print the same message.
> 
> This slightly changes the semantics of vm_is_unrestricted_guest() by
> changing a TEST_ASSERT() to exit(KSFT_SKIP). However
> vm_is_unrestricted_guest() is only called in one place
> (x86_64/mmio_warning_test.c) and that is to determine if the test should
> be skipped or not.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 35 +++++++++++--------
>  .../selftests/kvm/lib/x86_64/processor.c      | 16 +++------
>  .../kvm/x86_64/get_msr_index_features.c       |  8 ++---
>  4 files changed, 28 insertions(+), 32 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index a8f022794ce3..84982eb02b29 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -77,6 +77,7 @@ struct vm_guest_mode_params {
>  };
>  extern const struct vm_guest_mode_params vm_guest_mode_params[];
>  
> +int open_kvm_dev_path_or_exit(void);
>  int kvm_check_cap(long cap);
>  int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
>  int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index fc83f6c5902d..bb7dc65d7fb5 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -31,6 +31,23 @@ static void *align(void *x, size_t size)
>  	return (void *) (((size_t) x + mask) & ~mask);
>  }
>  
> +/* Open KVM_DEV_PATH if available, otherwise exit the entire program.
> + *
> + * Return:
> + *   The opened file descriptor of /dev/kvm.
> + */
> +int open_kvm_dev_path_or_exit(void) {
> +  int fd;
> +
> +  fd = open(KVM_DEV_PATH, O_RDONLY);
> +  if (fd < 0) {
> +    print_skip("%s not available", KVM_DEV_PATH);
> +    exit(KSFT_SKIP);
> +  }
> +
> +  return fd;
> +}

Style issues in the function above '{' and 2 spaces vs. 1 tab.

> +
>  /*
>   * Capability
>   *
> @@ -52,10 +69,7 @@ int kvm_check_cap(long cap)
>  	int ret;
>  	int kvm_fd;
>  
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> -
> +	kvm_fd = open_kvm_dev_path_or_exit();
>  	ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
>  	TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
>  		"  rc: %i errno: %i", ret, errno);
> @@ -128,9 +142,7 @@ void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
>  
>  static void vm_open(struct kvm_vm *vm, int perm)
>  {
> -	vm->kvm_fd = open(KVM_DEV_PATH, perm);

I don't think we should change this one, otherwise the user provided
perms are ignored.

> -	if (vm->kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	vm->kvm_fd = open_kvm_dev_path_or_exit();
>  
>  	if (!kvm_check_cap(KVM_CAP_IMMEDIATE_EXIT)) {
>  		print_skip("immediate_exit not available");
> @@ -925,9 +937,7 @@ static int vcpu_mmap_sz(void)
>  {
>  	int dev_fd, ret;
>  
> -	dev_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (dev_fd < 0)
> -		exit(KSFT_SKIP);
> +        dev_fd = open_kvm_dev_path_or_exit();

spaces vs. tab here

>  
>  	ret = ioctl(dev_fd, KVM_GET_VCPU_MMAP_SIZE, NULL);
>  	TEST_ASSERT(ret >= sizeof(struct kvm_run),
> @@ -2015,10 +2025,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm)
>  
>  	if (vm == NULL) {
>  		/* Ensure that the KVM vendor-specific module is loaded. */
> -		f = fopen(KVM_DEV_PATH, "r");
> -		TEST_ASSERT(f != NULL, "Error in opening KVM dev file: %d",
> -			    errno);
> -		fclose(f);
> +                close(open_kvm_dev_path_or_exit());

spaces

>  	}
>  
>  	f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index a8906e60a108..efe235044421 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -657,9 +657,7 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
>  		return cpuid;
>  
>  	cpuid = allocate_kvm_cpuid2();
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	kvm_fd = open_kvm_dev_path_or_exit();
>  
>  	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_CPUID, cpuid);
>  	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_CPUID failed %d %d\n",
> @@ -691,9 +689,7 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index)
>  
>  	buffer.header.nmsrs = 1;
>  	buffer.entry.index = msr_index;
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	kvm_fd = open_kvm_dev_path_or_exit();
>  
>  	r = ioctl(kvm_fd, KVM_GET_MSRS, &buffer.header);
>  	TEST_ASSERT(r == 1, "KVM_GET_MSRS IOCTL failed,\n"
> @@ -986,9 +982,7 @@ struct kvm_msr_list *kvm_get_msr_index_list(void)
>  	struct kvm_msr_list *list;
>  	int nmsrs, r, kvm_fd;
>  
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	kvm_fd = open_kvm_dev_path_or_exit();
>  
>  	nmsrs = kvm_get_num_msrs_fd(kvm_fd);
>  	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
> @@ -1312,9 +1306,7 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
>  		return cpuid;
>  
>  	cpuid = allocate_kvm_cpuid2();
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	kvm_fd = open_kvm_dev_path_or_exit();
>  
>  	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
>  	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_HV_CPUID failed %d %d\n",
> diff --git a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
> index cb953df4d7d0..8aed0db1331d 100644
> --- a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
> @@ -37,9 +37,7 @@ static void test_get_msr_index(void)
>  	int old_res, res, kvm_fd, r;
>  	struct kvm_msr_list *list;
>  
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	kvm_fd = open_kvm_dev_path_or_exit();
>  
>  	old_res = kvm_num_index_msrs(kvm_fd, 0);
>  	TEST_ASSERT(old_res != 0, "Expecting nmsrs to be > 0");
> @@ -101,9 +99,7 @@ static void test_get_msr_feature(void)
>  	int res, old_res, i, kvm_fd;
>  	struct kvm_msr_list *feature_list;
>  
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	kvm_fd = open_kvm_dev_path_or_exit();
>  
>  	old_res = kvm_num_feature_msrs(kvm_fd, 0);
>  	TEST_ASSERT(old_res != 0, "Expecting nmsrs to be > 0");
> -- 
> 2.31.1.607.g51e8a6a459-goog
> 

Thanks,
drew

