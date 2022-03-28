Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407EB4EA195
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 22:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345075AbiC1UgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 16:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345053AbiC1UgO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 16:36:14 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F1C6660B
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 13:34:26 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x31so7268456pfh.9
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 13:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z8M2eaDrvySsRMoJDq3gdwHu0GI4WHy75G6qEWnfrak=;
        b=UDUMifkjplq8rJ6a+odmLYcEQAXp6T6HvU89gOcSXenZ++rWsksgkLUZHakIakEqoM
         092VAJn5hHH1DhG0qyrYvjjdzUBUTzHhobRgl4mFji/FjDh8x4ji3NraIQTC3GliwDWV
         Xz3nb7KzKPHat9T11HkkwoXt7zfpxcv+nKihAI4qEYPEXpAKFTNHpb+z4qaARrxt8mNy
         CjGeqFlOnjfbLFi5dMUza92eKf5khfq56qwIkGTtR8EEgTZedFRT/D/1Z5cL+i4JFiag
         4pISPz3r8REj3A3chZuksVXQ6ivqXOxmhTgSlwb46eNpPu8JcJLx+83en6zYNBX5jV78
         ZCig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z8M2eaDrvySsRMoJDq3gdwHu0GI4WHy75G6qEWnfrak=;
        b=DD7Zc6ppP648M2Pp+f9XHz/iD+PIEw9d6NKUuDCjVK0qlm1B2gcpEkPHOTRVs7k0nR
         1h/RqzoPrUPgMyICZ1euc4SnQiZv5dBwo9fY0oqwBDTzYY+9RGLiTEt0iqHuJ60zxqKu
         QZaj/ry3KZvFQ4BhXdQ1Vh1o9Ms6o/4jsOKme4+WdPw8snoAoiAoPgbBkejtu5jx4gxc
         mm2buTB7A1hfeoRmpoMoNFzblbap97Xw+grN9El9yCYJWLWvrdsF/qt+7imQs/gCR9Yy
         pUif9L98UZ7z8CAkKriZOjHAAdHs+PwD1M2xDXllF1pWGuzFqoPfize7rNk7xzQfATGW
         udlQ==
X-Gm-Message-State: AOAM5300WB/q0giSkUFOGWB4Y8YkBGysaUJXwwuSvCS5nYysxSs5NzKy
        X7KL0CCIqQp9mBsUlA06lqVI6ntGOHpgTQ==
X-Google-Smtp-Source: ABdhPJyAHodgi4WXMqBDST8LyTg3i4XZ/SS4vBU9UigkT8BaXibKIqaOWnSK6pOBC4R3tdkj8P6aHA==
X-Received: by 2002:aa7:8556:0:b0:4fa:6d38:95e3 with SMTP id y22-20020aa78556000000b004fa6d3895e3mr24967832pfn.54.1648499665428;
        Mon, 28 Mar 2022 13:34:25 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id j9-20020a056a00130900b004f73df40914sm16770458pfu.82.2022.03.28.13.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 13:34:24 -0700 (PDT)
Date:   Mon, 28 Mar 2022 20:34:21 +0000
From:   David Matlack <dmatlack@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 11/11] KVM: x86/MMU: Require reboot permission to
 disable NX hugepages
Message-ID: <YkIbzWcC36w9vqng@google.com>
References: <20220321234844.1543161-1-bgardon@google.com>
 <20220321234844.1543161-12-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321234844.1543161-12-bgardon@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 21, 2022 at 04:48:44PM -0700, Ben Gardon wrote:
> Ensure that the userspace actor attempting to disable NX hugepages has
> permission to reboot the system. Since disabling NX hugepages would
> allow a guest to crash the system, it is similar to reboot permissions.
> 
> This approach is the simplest permission gating, but passing a file
> descriptor opened for write for the module parameter would also work
> well and be more precise.
> The latter approach was suggested by Sean Christopherson.
> 
> Suggested-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/x86.c                            | 18 ++++++-
>  .../selftests/kvm/include/kvm_util_base.h     |  2 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  7 +++
>  .../selftests/kvm/x86_64/nx_huge_pages_test.c | 49 ++++++++++++++-----
>  .../kvm/x86_64/nx_huge_pages_test.sh          |  2 +-
>  5 files changed, 65 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 74351cbb9b5b..995f30667619 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4256,7 +4256,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_SYS_ATTRIBUTES:
>  	case KVM_CAP_VAPIC:
>  	case KVM_CAP_ENABLE_CAP:
> -	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
>  		r = 1;
>  		break;
>  	case KVM_CAP_EXIT_HYPERCALL:
> @@ -4359,6 +4358,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_DISABLE_QUIRKS2:
>  		r = KVM_X86_VALID_QUIRKS;
>  		break;
> +	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
> +		/*
> +		 * Since the risk of disabling NX hugepages is a guest crashing
> +		 * the system, ensure the userspace process has permission to
> +		 * reboot the system.
> +		 */
> +		r = capable(CAP_SYS_BOOT);

Duplicating this check and comment isn't ideal. I think it would be fine
to unconditionally return true here (KVM, after all, does support the
capability) and only check for CAP_SYS_BOOT when userspace attempts to
enable the capability.

> +		break;
>  	default:
>  		break;
>  	}
> @@ -6050,6 +6057,15 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		mutex_unlock(&kvm->lock);
>  		break;
>  	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
> +		/*
> +		 * Since the risk of disabling NX hugepages is a guest crashing
> +		 * the system, ensure the userspace process has permission to
> +		 * reboot the system.
> +		 */
> +		if (!capable(CAP_SYS_BOOT)) {
> +			r = -EPERM;
> +			break;
> +		}
>  		kvm->arch.disable_nx_huge_pages = true;
>  		kvm_update_nx_huge_pages(kvm);
>  		r = 0;
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 72163ba2f878..4db8251c3ce5 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h

Can you split out the selftests changes to a separate commit? I have a
feeling you meant to :).

> @@ -411,4 +411,6 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name);
>  
>  uint32_t guest_get_vcpuid(void);
>  
> +void vm_disable_nx_huge_pages(struct kvm_vm *vm);
> +
>  #endif /* SELFTEST_KVM_UTIL_BASE_H */
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 9d72d1bb34fa..46a7fa08d3e0 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2765,3 +2765,10 @@ uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
>  	return value;
>  }
>  
> +void vm_disable_nx_huge_pages(struct kvm_vm *vm)
> +{
> +	struct kvm_enable_cap cap = { 0 };
> +
> +	cap.cap = KVM_CAP_VM_DISABLE_NX_HUGE_PAGES;
> +	vm_enable_cap(vm, &cap);
> +}
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> index 2bcbe4efdc6a..5ce98f759bc8 100644
> --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c

Will you add a test to exercise the CAP_SYS_BOOT check? At minimum the
selftest should check if it has CAP_SYS_BOOT and act accordingly (e.g.
exiting with KSFT_SKIP).

> @@ -57,13 +57,40 @@ static void check_split_count(struct kvm_vm *vm, int expected_splits)
>  		    expected_splits, actual_splits);
>  }
>  
> +static void help(void)
> +{
> +	puts("");
> +	printf("usage: nx_huge_pages_test.sh [-x]\n");
> +	puts("");
> +	printf(" -x: Allow executable huge pages on the VM.\n");
> +	puts("");
> +	exit(0);
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	struct kvm_vm *vm;
>  	struct timespec ts;
> +	bool disable_nx = false;
> +	int opt;
> +
> +	while ((opt = getopt(argc, argv, "x")) != -1) {
> +		switch (opt) {
> +		case 'x':
> +			disable_nx = true;
> +			break;
> +		case 'h':
> +		default:
> +			help();
> +			break;
> +		}
> +	}
>  
>  	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
>  
> +	if (disable_nx)
> +		vm_disable_nx_huge_pages(vm);
> +
>  	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS_HUGETLB,
>  				    HPAGE_PADDR_START, HPAGE_SLOT,
>  				    HPAGE_SLOT_NPAGES, 0);
> @@ -83,21 +110,21 @@ int main(int argc, char **argv)
>  	 * at 2M.
>  	 */
>  	run_guest_code(vm, guest_code0);
> -	check_2m_page_count(vm, 2);
> -	check_split_count(vm, 2);
> +	check_2m_page_count(vm, disable_nx ? 4 : 2);
> +	check_split_count(vm, disable_nx ? 0 : 2);
>  
>  	/*
>  	 * guest_code1 is in the same huge page as data1, so it will cause
>  	 * that huge page to be remapped at 4k.
>  	 */
>  	run_guest_code(vm, guest_code1);
> -	check_2m_page_count(vm, 1);
> -	check_split_count(vm, 3);
> +	check_2m_page_count(vm, disable_nx ? 4 : 1);
> +	check_split_count(vm, disable_nx ? 0 : 3);
>  
>  	/* Run guest_code0 again to check that is has no effect. */
>  	run_guest_code(vm, guest_code0);
> -	check_2m_page_count(vm, 1);
> -	check_split_count(vm, 3);
> +	check_2m_page_count(vm, disable_nx ? 4 : 1);
> +	check_split_count(vm, disable_nx ? 0 : 3);
>  
>  	/*
>  	 * Give recovery thread time to run. The wrapper script sets
> @@ -110,7 +137,7 @@ int main(int argc, char **argv)
>  	/*
>  	 * Now that the reclaimer has run, all the split pages should be gone.
>  	 */
> -	check_2m_page_count(vm, 1);
> +	check_2m_page_count(vm, disable_nx ? 4 : 1);
>  	check_split_count(vm, 0);
>  
>  	/*
> @@ -118,13 +145,13 @@ int main(int argc, char **argv)
>  	 * again to check that pages are mapped at 2M again.
>  	 */
>  	run_guest_code(vm, guest_code0);
> -	check_2m_page_count(vm, 2);
> -	check_split_count(vm, 2);
> +	check_2m_page_count(vm, disable_nx ? 4 : 2);
> +	check_split_count(vm, disable_nx ? 0 : 2);
>  
>  	/* Pages are once again split from running guest_code1. */
>  	run_guest_code(vm, guest_code1);
> -	check_2m_page_count(vm, 1);
> -	check_split_count(vm, 3);
> +	check_2m_page_count(vm, disable_nx ? 4 : 1);
> +	check_split_count(vm, disable_nx ? 0 : 3);
>  
>  	kvm_vm_free(vm);
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> index 19fc95723fcb..29f999f48848 100755
> --- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> +++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.sh
> @@ -14,7 +14,7 @@ echo 1 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
>  echo 100 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
>  echo 200 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
>  
> -./nx_huge_pages_test
> +./nx_huge_pages_test "${@}"
>  RET=$?
>  
>  echo $NX_HUGE_PAGES > /sys/module/kvm/parameters/nx_huge_pages
> -- 
> 2.35.1.894.gb6a874cedc-goog
> 
