Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFC05E553B
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 23:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiIUVew (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 17:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiIUVet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 17:34:49 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D74A22B1B
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:34:47 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id p18so6938891plr.8
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 14:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ub8WoIp0abwg5liI/4m3sr2tp4uNXD4t2ehf1q0m6wg=;
        b=rI69Q9BxoaDNtd+yWlZdfd+fLCbIpU5l5ao+Rqz6oNxaztS8WYRZ7USrQzybEMX/J5
         HnzZQB+IkaY8nNo7h2ZITrqeQhQsuESoCahu8Ri6DqXg4vDap2DWllz9wHznYSylG3A2
         C4hzGwMMEoYzYmQuryvK+M6OqJJRukDB9Q14eD9oLl4CVImKRw5f2+d51qlDTD/UcPki
         q7zfFIjk4krXqAv4kygLKoKyyToFNuhYbf5FG2GQ81HJexLELBpRwSWhhCI5qxkTHIN1
         /PH4HgGiLr/RdxMGvuZoAdbzC9Yvp35uxcAMAMXkMoqmsOYxKLzb/XMiJsVK0XUHToBq
         EOlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ub8WoIp0abwg5liI/4m3sr2tp4uNXD4t2ehf1q0m6wg=;
        b=XfWdxk9C2fkWSzx44UcfNNWgVetKw6IPCjO+iuKd8Yq57NttrXh1Atd7YX3yG3F1M1
         ogtraLg9wtY5nVqtJZ2i2oC0A0BjrRfDSZ88fqRV8+PcaYKUQ0JdJgJg2VYlFrfWv/Sf
         8RrQt3UAcVASHL2F0FtGT51g8X8QCxLTzoU7FmPN8otZBa8vrRFwZHltt7M8TzQgOLoH
         wJ23AU0Zuys6UoPLvk+72mk4FRIRSDuP2D9Gu4hr+koPa5SsuTrljWLbB7+mDrpqqAA7
         k3BpwI+dmPtEE0hdKDXTKHCEi3eEfhbdq+UX6qT67e87BDrSSLysUQQp3ZZOntwCFJm5
         viDg==
X-Gm-Message-State: ACrzQf3Cwd4xiEinj6lm++9iV5v0Z6N4S2/NsgZ2JrkuqpYTR5KpWfob
        vCE9czaByOHEyLcXZyOW0/SFDg==
X-Google-Smtp-Source: AMsMyM5lEMgDklRZQsljsr+7PkZGmwHNKrhKQUZF9rpjOG3q6Xu1U2q2NjkwtKsQqkLF+khDK/H6AQ==
X-Received: by 2002:a17:903:41c6:b0:178:348e:f760 with SMTP id u6-20020a17090341c600b00178348ef760mr177373ple.123.1663796086674;
        Wed, 21 Sep 2022 14:34:46 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id p124-20020a62d082000000b0053e3ed14419sm2683886pfg.48.2022.09.21.14.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 14:34:46 -0700 (PDT)
Date:   Wed, 21 Sep 2022 14:34:41 -0700
From:   David Matlack <dmatlack@google.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, pbonzini@redhat.com,
        shuah@kernel.org, bgardon@google.com, seanjc@google.com,
        oupton@google.com, peterx@redhat.com, vkuznets@redhat.com
Subject: Re: [V2 PATCH 5/8] KVM: selftests: x86: delete svm_vmcall_test
Message-ID: <YyuDcXT7siGcKi3d@google.com>
References: <20220915000448.1674802-1-vannapurve@google.com>
 <20220915000448.1674802-6-vannapurve@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220915000448.1674802-6-vannapurve@google.com>
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

On Thu, Sep 15, 2022 at 12:04:45AM +0000, Vishal Annapurve wrote:
> svm_vmcall_test is superseded by fix_hypercall_test.

Please provide a more detailed description of why svm_vmcall_test is
being dropped. e.g. What do you mean by "superseded" specifically?

I ask because this will be helpful context for future readers of this
commit. I also ask because it's not clear to me that fix_hypercall_test
is a 1:1 replacement of svm_vmcall_test. e.g. svm_vmcall_test sets up an
L2 while fix_hypercall_test just executes in L1.

> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> ---
>  tools/testing/selftests/kvm/.gitignore        |  1 -
>  .../selftests/kvm/x86_64/svm_vmcall_test.c    | 74 -------------------
>  2 files changed, 75 deletions(-)
>  delete mode 100644 tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index d625a3f83780..22e9a5b5488c 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -36,7 +36,6 @@
>  /x86_64/sev_migrate_tests
>  /x86_64/smm_test
>  /x86_64/state_test
> -/x86_64/svm_vmcall_test
>  /x86_64/svm_int_ctl_test
>  /x86_64/svm_nested_soft_inject_test
>  /x86_64/sync_regs_test
> diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
> deleted file mode 100644
> index c3ac45df7483..000000000000
> --- a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
> +++ /dev/null
> @@ -1,74 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0-only
> -/*
> - * svm_vmcall_test
> - *
> - * Copyright (C) 2020, Red Hat, Inc.
> - *
> - * Nested SVM testing: VMCALL
> - */
> -
> -#include "test_util.h"
> -#include "kvm_util.h"
> -#include "processor.h"
> -#include "svm_util.h"
> -
> -static void l2_guest_code(struct svm_test_data *svm)
> -{
> -	__asm__ __volatile__("vmcall");
> -}
> -
> -static void l1_guest_code(struct svm_test_data *svm)
> -{
> -	#define L2_GUEST_STACK_SIZE 64
> -	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> -	struct vmcb *vmcb = svm->vmcb;
> -
> -	/* Prepare for L2 execution. */
> -	generic_svm_setup(svm, l2_guest_code,
> -			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
> -
> -	run_guest(vmcb, svm->vmcb_gpa);
> -
> -	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
> -	GUEST_DONE();
> -}
> -
> -int main(int argc, char *argv[])
> -{
> -	struct kvm_vcpu *vcpu;
> -	vm_vaddr_t svm_gva;
> -	struct kvm_vm *vm;
> -
> -	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
> -
> -	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
> -
> -	vcpu_alloc_svm(vm, &svm_gva);
> -	vcpu_args_set(vcpu, 1, svm_gva);
> -
> -	for (;;) {
> -		volatile struct kvm_run *run = vcpu->run;
> -		struct ucall uc;
> -
> -		vcpu_run(vcpu);
> -		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> -			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
> -			    run->exit_reason,
> -			    exit_reason_str(run->exit_reason));
> -
> -		switch (get_ucall(vcpu, &uc)) {
> -		case UCALL_ABORT:
> -			REPORT_GUEST_ASSERT(uc);
> -			/* NOT REACHED */
> -		case UCALL_SYNC:
> -			break;
> -		case UCALL_DONE:
> -			goto done;
> -		default:
> -			TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
> -		}
> -	}
> -done:
> -	kvm_vm_free(vm);
> -	return 0;
> -}
> -- 
> 2.37.2.789.g6183377224-goog
> 
