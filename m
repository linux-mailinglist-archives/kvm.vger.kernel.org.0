Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE6C377C3F
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 08:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhEJG3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 02:29:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43230 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229863AbhEJG3T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 02:29:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620628094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RNkG09jXdue5IODAH6yAx6XH7qIOae6OLEeiCuQRMDU=;
        b=OBIqynPHztPjD2zr27Dfbtjdhz2YPyF16jz+zarL7phZSuytxQH/xXIiU/hRDp7DgAzuS2
        SIKsEcY7fvE68UdSJ93moIltypbruSjKoMTrf6WhsU+Fy1Ju25RXl+i7M00YX3v5BNYywj
        2TFJoer7d9tD/lvll/D4XEuAaPWgwvM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-VRP-t6BTPVuhqsyNU1-YyQ-1; Mon, 10 May 2021 02:28:12 -0400
X-MC-Unique: VRP-t6BTPVuhqsyNU1-YyQ-1
Received: by mail-ed1-f69.google.com with SMTP id y19-20020a0564022713b029038a9f36060dso8498965edd.4
        for <kvm@vger.kernel.org>; Sun, 09 May 2021 23:28:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RNkG09jXdue5IODAH6yAx6XH7qIOae6OLEeiCuQRMDU=;
        b=C7gY4bqV6IumvkHA6iNahzNcUEBsjqw5w9h3WwzBrvI2qIkzHZUA0uKc+gPsPNEkON
         BD9HLmG5mpodqECLS6+Vk9XatAkbbNxdhDrYJoRRrMWlksgttQcu6DAFepoUhYrAN2+o
         7hNvRdlIANvzST2Wm1msqwtWwumz0/qbCBPOI37GZmnhF5XKCSdgwjH910uAhxdS7sil
         h3ZAu25SDHBnNpGJak8QUd5KIU5p+bMSlNLjfJ/ScXtDWVsWF1eFQMKBs9K9et1Vc2Qq
         oLC1qfgw6uRItpG6P7UrqkmUZdlCen9g1mSfAIPh3ZjFwB1BIWFvA9vllcU/2bN3GiyK
         o1yg==
X-Gm-Message-State: AOAM530FoxKYVgDw4kAp/V8KvyeSuQ+/eacxUPpNFxk/bmg+FOGqtGvM
        lfbvg/hbY3AhFTmgaWU4JUfKNQsBjdS7leaPGP+2uzngj/RQv+jdVGKUJLrTGqaXkE5rX68RKRD
        RVjNDlb3RJi4g
X-Received: by 2002:a17:906:ce47:: with SMTP id se7mr24267651ejb.272.1620628091637;
        Sun, 09 May 2021 23:28:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrs32TqEcs1HAeAiwxjP9oQ8rQWGGVTBtqcZg3xzdGgQ5XqHuJvcJxEcunxV1tGyggDSflhQ==
X-Received: by 2002:a17:906:ce47:: with SMTP id se7mr24267633ejb.272.1620628091417;
        Sun, 09 May 2021 23:28:11 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id e11sm10251643edq.76.2021.05.09.23.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:28:11 -0700 (PDT)
Date:   Mon, 10 May 2021 08:28:09 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v2] KVM: selftests: Print a message if /dev/kvm is missing
Message-ID: <20210510062809.gtz35ydc3fkhptsr@gator>
References: <20210508002832.759818-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210508002832.759818-1-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 08, 2021 at 12:28:32AM +0000, David Matlack wrote:
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
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 39 ++++++++++++-------
>  .../selftests/kvm/lib/x86_64/processor.c      | 16 ++------
>  .../kvm/x86_64/get_msr_index_features.c       |  8 +---
>  4 files changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index a8f022794ce3..401393a8c2b7 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -77,6 +77,7 @@ struct vm_guest_mode_params {
>  };
>  extern const struct vm_guest_mode_params vm_guest_mode_params[];
>  
> +int open_kvm_dev_path_or_exit(int flags);
>  int kvm_check_cap(long cap);
>  int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
>  int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index fc83f6c5902d..10d488f83e3a 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -31,6 +31,27 @@ static void *align(void *x, size_t size)
>  	return (void *) (((size_t) x + mask) & ~mask);
>  }
>  
> +/* Open KVM_DEV_PATH if available, otherwise exit the entire program.

nit: We use the style where '/*' is on its own line.

> + *
> + * Input Args:
> + *   flags - The flags to pass when opening KVM_DEV_PATH.
> + *
> + * Return:
> + *   The opened file descriptor of /dev/kvm.
> + */
> +int open_kvm_dev_path_or_exit(int flags)
> +{
> +	int fd;
> +
> +	fd = open(KVM_DEV_PATH, flags);
> +	if (fd < 0) {
> +		print_skip("%s not available", KVM_DEV_PATH);
> +		exit(KSFT_SKIP);
> +	}
> +
> +	return fd;
> +}
> +
>  /*
>   * Capability
>   *
> @@ -52,10 +73,7 @@ int kvm_check_cap(long cap)
>  	int ret;
>  	int kvm_fd;
>  
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> -
> +	kvm_fd = open_kvm_dev_path_or_exit(O_RDONLY);
>  	ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
>  	TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
>  		"  rc: %i errno: %i", ret, errno);
> @@ -128,9 +146,7 @@ void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
>  
>  static void vm_open(struct kvm_vm *vm, int perm)
>  {
> -	vm->kvm_fd = open(KVM_DEV_PATH, perm);
> -	if (vm->kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	vm->kvm_fd = open_kvm_dev_path_or_exit(perm);
>  
>  	if (!kvm_check_cap(KVM_CAP_IMMEDIATE_EXIT)) {
>  		print_skip("immediate_exit not available");
> @@ -925,9 +941,7 @@ static int vcpu_mmap_sz(void)
>  {
>  	int dev_fd, ret;
>  
> -	dev_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (dev_fd < 0)
> -		exit(KSFT_SKIP);
> +	dev_fd = open_kvm_dev_path_or_exit(O_RDONLY);
>  
>  	ret = ioctl(dev_fd, KVM_GET_VCPU_MMAP_SIZE, NULL);
>  	TEST_ASSERT(ret >= sizeof(struct kvm_run),
> @@ -2015,10 +2029,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm)
>  
>  	if (vm == NULL) {
>  		/* Ensure that the KVM vendor-specific module is loaded. */
> -		f = fopen(KVM_DEV_PATH, "r");
> -		TEST_ASSERT(f != NULL, "Error in opening KVM dev file: %d",
> -			    errno);
> -		fclose(f);
> +		close(open_kvm_dev_path_or_exit(O_RDONLY));
>  	}
>  
>  	f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index a8906e60a108..1ce0a37d8a89 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -657,9 +657,7 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
>  		return cpuid;
>  
>  	cpuid = allocate_kvm_cpuid2();
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	kvm_fd = open_kvm_dev_path_or_exit(O_RDONLY);
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
> +	kvm_fd = open_kvm_dev_path_or_exit(O_RDONLY);
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
> +	kvm_fd = open_kvm_dev_path_or_exit(O_RDONLY);
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
> +	kvm_fd = open_kvm_dev_path_or_exit(O_RDONLY);
>  
>  	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
>  	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_HV_CPUID failed %d %d\n",
> diff --git a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
> index cb953df4d7d0..91373935bff6 100644
> --- a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
> @@ -37,9 +37,7 @@ static void test_get_msr_index(void)
>  	int old_res, res, kvm_fd, r;
>  	struct kvm_msr_list *list;
>  
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	kvm_fd = open_kvm_dev_path_or_exit(O_RDONLY);
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
> +	kvm_fd = open_kvm_dev_path_or_exit(O_RDONLY);
>  
>  	old_res = kvm_num_feature_msrs(kvm_fd, 0);
>  	TEST_ASSERT(old_res != 0, "Expecting nmsrs to be > 0");
> -- 
> 2.31.1.607.g51e8a6a459-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

