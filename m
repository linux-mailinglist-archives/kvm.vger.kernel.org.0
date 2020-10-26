Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98CB2988F0
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 09:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770025AbgJZI7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 04:59:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38306 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1769813AbgJZI7B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 04:59:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603702739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0W2XV7td4g59j+SiwCCjGLZgDGW6nxbV5ceZZFZ+5jU=;
        b=RD+XD0rmE041DblMQJjWH3AyLRUb49UgS6N+RQCe4R22lzXgA9GcVNHD8Kp2MixriHFbj0
        Vpkt9FIinwEv+9XbDFt7VgTRTXMVUp+9u1hZH6jdDOtKe/Z9DsszH2XIfusisCPxsMaUZA
        eJg3dbkmfiLQtC69DlONwvaYLjNlMC0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-ydRrNbYkNXCgjUmMPLjRVA-1; Mon, 26 Oct 2020 04:58:57 -0400
X-MC-Unique: ydRrNbYkNXCgjUmMPLjRVA-1
Received: by mail-ej1-f69.google.com with SMTP id c20so4535216ejs.12
        for <kvm@vger.kernel.org>; Mon, 26 Oct 2020 01:58:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0W2XV7td4g59j+SiwCCjGLZgDGW6nxbV5ceZZFZ+5jU=;
        b=C7VUQKq3Jk3wLVtfQVSNbrv9JsLhij84S9FRhsK+6dqC0Wz/fHX7fl7NsQIsSD5sZK
         xe3l7zm07TVbdA7pyYBPwKAS0DfsJKpDvy+LFRIZW4u+VvXXA7sBKIBDnGUGWE/SFHFG
         p55imnpz/ik1Zr3vDtZlNFbmlFiW0HHrc9wfB2xRu3QuwF2MjcxEIDA5tZZWo0FqUB2j
         QqI5VwCqGg5A7ZxehMMVPkymLsNkG0SDAih9y32HlgaCYoqUb4cDwdG8zx9ZrNxRuwG2
         QDhJtBx3zJTiIbu1M9gwdW7QqXgGiUQBb/z1YRWNAESMpdhXlDsRjWWcrjb4/LozA1BJ
         y31A==
X-Gm-Message-State: AOAM532OFdUAv+3QwaIRLEnVeoxZof0DZWh6A/qks2Q3YJUh57tGYK8s
        0aE1TZg0DjDea65fCfNX1nKSZNhvG1na+sbCZ8+ydxO1qrM0F/UaTNr4fe9MOeGMC8ekekZ6FC4
        2WAsQ33RSLced
X-Received: by 2002:a17:906:ae09:: with SMTP id le9mr14268842ejb.425.1603702736214;
        Mon, 26 Oct 2020 01:58:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7/gViufjlDk0R/qXYVAbxhJp+F9jCWBIBk7lqRPPHeMS/KzUmAt2aAnWxoUOMKzZYuuYRbA==
X-Received: by 2002:a17:906:ae09:: with SMTP id le9mr14268833ejb.425.1603702735966;
        Mon, 26 Oct 2020 01:58:55 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id f7sm5457783ejz.23.2020.10.26.01.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 01:58:55 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: selftests: Add get featured msrs test case
In-Reply-To: <20201025185334.389061-2-peterx@redhat.com>
References: <20201025185334.389061-1-peterx@redhat.com> <20201025185334.389061-2-peterx@redhat.com>
Date:   Mon, 26 Oct 2020 09:58:54 +0100
Message-ID: <874kmh2wj5.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu <peterx@redhat.com> writes:

> Try to fetch any supported featured msr.  Currently it won't fail, so at least
> we can check against valid ones (which should be >0).
>
> This reproduces [1] too by trying to fetch one invalid msr there.
>
> [1] https://bugzilla.kernel.org/show_bug.cgi?id=209845
>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  3 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 14 +++++
>  .../testing/selftests/kvm/x86_64/state_test.c | 58 +++++++++++++++++++
>  3 files changed, 75 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 919e161dd289..e34cf263b20a 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -66,6 +66,9 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
>  
>  struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
>  struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm);
> +void kvm_vm_get_msr_feature_index_list(struct kvm_vm *vm,
> +				       struct kvm_msr_list *list);
> +int kvm_vm_get_feature_msrs(struct kvm_vm *vm, struct kvm_msrs *msrs);
>  void kvm_vm_free(struct kvm_vm *vmp);
>  void kvm_vm_restart(struct kvm_vm *vmp, int perm);
>  void kvm_vm_release(struct kvm_vm *vmp);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 74776ee228f2..3c16fa044335 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -132,6 +132,20 @@ static const struct vm_guest_mode_params vm_guest_mode_params[] = {
>  _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
>  	       "Missing new mode params?");
>  
> +void kvm_vm_get_msr_feature_index_list(struct kvm_vm *vm,
> +				       struct kvm_msr_list *list)
> +{
> +	int r = ioctl(vm->kvm_fd, KVM_GET_MSR_FEATURE_INDEX_LIST, list);
> +
> +	TEST_ASSERT(r == 0, "KVM_GET_MSR_FEATURE_INDEX_LIST failed: %d\n",
> +		    -errno);
> +}
> +
> +int kvm_vm_get_feature_msrs(struct kvm_vm *vm, struct kvm_msrs *msrs)
> +{
> +	return ioctl(vm->kvm_fd, KVM_GET_MSRS, msrs);
> +}

I *think* that the non-written rule for kvm selftests is that functions
without '_' prefix check ioctl return value with TEST_ASSERT() and
functions with it don't (e.g. _vcpu_run()/vcpu_run()) but maybe it's
just me.

> +
>  /*
>   * VM Create
>   *
> diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
> index f6c8b9042f8a..7ce9920e526a 100644
> --- a/tools/testing/selftests/kvm/x86_64/state_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/state_test.c

I would not overload state_test with this new check and create a new
one. The benefit is that when one of these tests fail we still get the
result of the other one so it's not 'everything works' vs 'everything is
broken' type of log.

> @@ -152,6 +152,61 @@ static void __attribute__((__flatten__)) guest_code(void *arg)
>  	GUEST_DONE();
>  }
>  
> +#define  KVM_MSR_FEATURE_N  64
> +
> +static int test_kvm_get_feature_msr_one(struct kvm_vm *vm, __u32 index,
> +					struct kvm_msrs *msrs)
> +{
> +	msrs->nmsrs = 1;
> +	msrs->entries[0].index = index;
> +	return kvm_vm_get_feature_msrs(vm, msrs);
> +}
> +
> +static void test_kvm_get_msr_features(struct kvm_vm *vm)
> +{
> +	struct kvm_msr_list *msr_list;
> +	struct kvm_msrs *msrs;
> +	int i, ret, sum;
> +
> +	if (!kvm_check_cap(KVM_CAP_GET_MSR_FEATURES)) {
> +		pr_info("skipping kvm get msr features test\n");
> +		return;
> +	}
> +
> +	msr_list = calloc(1, sizeof(struct kvm_msr_list) +
> +			  sizeof(__u32) * KVM_MSR_FEATURE_N);
> +	msr_list->nmsrs = KVM_MSR_FEATURE_N;
> +
> +	TEST_ASSERT(msr_list, "msr_list allocation failed\n");
> +
> +	kvm_vm_get_msr_feature_index_list(vm, msr_list);
> +
> +	msrs = calloc(1, sizeof(struct kvm_msrs) +
> +		      sizeof(struct kvm_msr_entry));
> +
> +	TEST_ASSERT(msrs, "msr entries allocation failed\n");
> +
> +	sum = 0;
> +	for (i = 0; i < msr_list->nmsrs; i++) {
> +		ret = test_kvm_get_feature_msr_one(vm, msr_list->indices[i],
> +						    msrs);
> +		TEST_ASSERT(ret >= 0, "KVM_GET_MSR failed: %d\n", ret);
> +		sum += ret;
> +	}
> +	TEST_ASSERT(sum > 0, "KVM_GET_MSR has no feature msr\n");
> +
> +	/*
> +	 * Test invalid msr.  Note the retcode can be either 0 or 1 depending
> +	 * on kvm.ignore_msrs
> +	 */
> +	ret = test_kvm_get_feature_msr_one(vm, (__u32)-1, msrs);
> +	TEST_ASSERT(ret >= 0 && ret <= 1,
> +		    "KVM_GET_MSR on invalid msr error: %d\n", ret);
> +
> +	free(msrs);
> +	free(msr_list);
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	vm_vaddr_t nested_gva = 0;
> @@ -168,6 +223,9 @@ int main(int argc, char *argv[])
>  	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
>  	run = vcpu_state(vm, VCPU_ID);
>  
> +	/* Test KVM_GET_MSR for VM */
> +	test_kvm_get_msr_features(vm);
> +
>  	vcpu_regs_get(vm, VCPU_ID, &regs1);
>  
>  	if (kvm_check_cap(KVM_CAP_NESTED_STATE)) {

-- 
Vitaly

