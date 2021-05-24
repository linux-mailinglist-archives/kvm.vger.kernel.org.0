Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C28138E84A
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 16:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhEXOJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 10:09:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20063 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232462AbhEXOJU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 10:09:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621865271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PmdSHtTkwkFmxgRAW17we1Xe0gyNirpn5W8SbwW+rOk=;
        b=g5GypMIQVw9oHFO48mZESFn54fukQ1FuNbuHkJyDRmHih/D8T9jOIyM9unY3iJjWqD33jH
        X9b7lLgWbU6Ln+evNEI9iz+xiv/s1+4grZepSBZWANHcR2InTiJ8HMfuYrZkoCKTw9vkuO
        3frcH8k+NaBG/cnL6dGGvprrPlajwx0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-PgLNLNdRNtq_AFo6Hk8k0g-1; Mon, 24 May 2021 10:07:50 -0400
X-MC-Unique: PgLNLNdRNtq_AFo6Hk8k0g-1
Received: by mail-ed1-f72.google.com with SMTP id i3-20020aa7dd030000b029038ce772ffe4so15754079edv.12
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 07:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PmdSHtTkwkFmxgRAW17we1Xe0gyNirpn5W8SbwW+rOk=;
        b=hZoK0kzoQpVddzYZD1ZmsNPIE2ypTipxm1Jf4ljm/wBT7dSwwoHnFaYk0wwnRylx0L
         Q8W4nqWXZBXrYpMxXK9DZDR7MezP+X7MrjZR1eHRNMftx2E+OS68IgTmEEU5tm6aSQdi
         56/ezejlJHyd1/JAHswRf8M4CiWozHZ/wo0WY7uFVAnHmVhyuueDQJ09Y6iMjwWde1hy
         F8LIO06V4WaCVoTORRH41DzratDc1yEdqzAP8L3Dv8sNq8XVSw0dM7GG5pDUvQvLCVv2
         rI592Qkb83D8Om1EkMIbjjCRI2W5Fqc4u0zhZBMfOmhV82+rzKbZ/svGaIEpmxNmkGYw
         q31g==
X-Gm-Message-State: AOAM53005UkipGb/gb/ccc6tpnlIOg/W4/tUG9CIf0OlmElDw2Ek9wtT
        c2gsCcjUgqzKlYlZmMQ2Xxs7I97/HRyt9v99DccRj6MqhnFQHgoOpGE3fjaeNo6GfL3As4z74me
        yun7FPQIzJH1i
X-Received: by 2002:a05:6402:c7:: with SMTP id i7mr26360621edu.194.1621865267764;
        Mon, 24 May 2021 07:07:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDcrI3PsxwyKlgZqwEv0QjZm1vpCt+2wNYhB+gw0bIGpGvke7QN7xpUzqaIqsiyVgjimz9Zg==
X-Received: by 2002:a05:6402:c7:: with SMTP id i7mr26360592edu.194.1621865267526;
        Mon, 24 May 2021 07:07:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id sb14sm3501142ejb.106.2021.05.24.07.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 07:07:46 -0700 (PDT)
Subject: Re: [PATCH v4] KVM: selftests: Print a message if /dev/kvm is missing
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
References: <20210511202120.1371800-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <76e033e3-5841-6a46-c63f-d18f759f94eb@redhat.com>
Date:   Mon, 24 May 2021 16:07:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210511202120.1371800-1-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/05/21 22:21, David Matlack wrote:
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
>   .../testing/selftests/kvm/include/kvm_util.h  |  1 +
>   tools/testing/selftests/kvm/lib/kvm_util.c    | 45 +++++++++++++------
>   .../selftests/kvm/lib/x86_64/processor.c      | 16 ++-----
>   .../kvm/x86_64/get_msr_index_features.c       |  8 +---
>   4 files changed, 38 insertions(+), 32 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index a8f022794ce3..84982eb02b29 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -77,6 +77,7 @@ struct vm_guest_mode_params {
>   };
>   extern const struct vm_guest_mode_params vm_guest_mode_params[];
>   
> +int open_kvm_dev_path_or_exit(void);
>   int kvm_check_cap(long cap);
>   int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
>   int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index fc83f6c5902d..1af1009254c4 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -31,6 +31,33 @@ static void *align(void *x, size_t size)
>   	return (void *) (((size_t) x + mask) & ~mask);
>   }
>   
> +/*
> + * Open KVM_DEV_PATH if available, otherwise exit the entire program.
> + *
> + * Input Args:
> + *   flags - The flags to pass when opening KVM_DEV_PATH.
> + *
> + * Return:
> + *   The opened file descriptor of /dev/kvm.
> + */
> +static int _open_kvm_dev_path_or_exit(int flags)
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
> +int open_kvm_dev_path_or_exit(void)
> +{
> +	return _open_kvm_dev_path_or_exit(O_RDONLY);
> +}
> +
>   /*
>    * Capability
>    *
> @@ -52,10 +79,7 @@ int kvm_check_cap(long cap)
>   	int ret;
>   	int kvm_fd;
>   
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> -
> +	kvm_fd = open_kvm_dev_path_or_exit();
>   	ret = ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
>   	TEST_ASSERT(ret != -1, "KVM_CHECK_EXTENSION IOCTL failed,\n"
>   		"  rc: %i errno: %i", ret, errno);
> @@ -128,9 +152,7 @@ void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
>   
>   static void vm_open(struct kvm_vm *vm, int perm)
>   {
> -	vm->kvm_fd = open(KVM_DEV_PATH, perm);
> -	if (vm->kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	vm->kvm_fd = _open_kvm_dev_path_or_exit(perm);
>   
>   	if (!kvm_check_cap(KVM_CAP_IMMEDIATE_EXIT)) {
>   		print_skip("immediate_exit not available");
> @@ -925,9 +947,7 @@ static int vcpu_mmap_sz(void)
>   {
>   	int dev_fd, ret;
>   
> -	dev_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (dev_fd < 0)
> -		exit(KSFT_SKIP);
> +	dev_fd = open_kvm_dev_path_or_exit();
>   
>   	ret = ioctl(dev_fd, KVM_GET_VCPU_MMAP_SIZE, NULL);
>   	TEST_ASSERT(ret >= sizeof(struct kvm_run),
> @@ -2015,10 +2035,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm)
>   
>   	if (vm == NULL) {
>   		/* Ensure that the KVM vendor-specific module is loaded. */
> -		f = fopen(KVM_DEV_PATH, "r");
> -		TEST_ASSERT(f != NULL, "Error in opening KVM dev file: %d",
> -			    errno);
> -		fclose(f);
> +		close(open_kvm_dev_path_or_exit());
>   	}
>   
>   	f = fopen("/sys/module/kvm_intel/parameters/unrestricted_guest", "r");
> diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> index a8906e60a108..efe235044421 100644
> --- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
> @@ -657,9 +657,7 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
>   		return cpuid;
>   
>   	cpuid = allocate_kvm_cpuid2();
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	kvm_fd = open_kvm_dev_path_or_exit();
>   
>   	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_CPUID, cpuid);
>   	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_CPUID failed %d %d\n",
> @@ -691,9 +689,7 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index)
>   
>   	buffer.header.nmsrs = 1;
>   	buffer.entry.index = msr_index;
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	kvm_fd = open_kvm_dev_path_or_exit();
>   
>   	r = ioctl(kvm_fd, KVM_GET_MSRS, &buffer.header);
>   	TEST_ASSERT(r == 1, "KVM_GET_MSRS IOCTL failed,\n"
> @@ -986,9 +982,7 @@ struct kvm_msr_list *kvm_get_msr_index_list(void)
>   	struct kvm_msr_list *list;
>   	int nmsrs, r, kvm_fd;
>   
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	kvm_fd = open_kvm_dev_path_or_exit();
>   
>   	nmsrs = kvm_get_num_msrs_fd(kvm_fd);
>   	list = malloc(sizeof(*list) + nmsrs * sizeof(list->indices[0]));
> @@ -1312,9 +1306,7 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
>   		return cpuid;
>   
>   	cpuid = allocate_kvm_cpuid2();
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	kvm_fd = open_kvm_dev_path_or_exit();
>   
>   	ret = ioctl(kvm_fd, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
>   	TEST_ASSERT(ret == 0, "KVM_GET_SUPPORTED_HV_CPUID failed %d %d\n",
> diff --git a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
> index cb953df4d7d0..8aed0db1331d 100644
> --- a/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/get_msr_index_features.c
> @@ -37,9 +37,7 @@ static void test_get_msr_index(void)
>   	int old_res, res, kvm_fd, r;
>   	struct kvm_msr_list *list;
>   
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	kvm_fd = open_kvm_dev_path_or_exit();
>   
>   	old_res = kvm_num_index_msrs(kvm_fd, 0);
>   	TEST_ASSERT(old_res != 0, "Expecting nmsrs to be > 0");
> @@ -101,9 +99,7 @@ static void test_get_msr_feature(void)
>   	int res, old_res, i, kvm_fd;
>   	struct kvm_msr_list *feature_list;
>   
> -	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
> -	if (kvm_fd < 0)
> -		exit(KSFT_SKIP);
> +	kvm_fd = open_kvm_dev_path_or_exit();
>   
>   	old_res = kvm_num_feature_msrs(kvm_fd, 0);
>   	TEST_ASSERT(old_res != 0, "Expecting nmsrs to be > 0");
> 

Queued, thanks.

Paolo

