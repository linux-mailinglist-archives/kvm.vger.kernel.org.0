Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28982151DDF
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 17:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgBDQJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 11:09:45 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20162 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727385AbgBDQJp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 11:09:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580832583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YYcsiG17pzIghdQ6UseEA9aCS5seLdWvZ4aLxJRrky0=;
        b=GgD1XbgF9GbDPo1E+zPl/Wm0HqVQK5D6LB4xt48C99dPW6ZbtC6kAKJ0/gf+SBItQQUUfR
        A6DJaMinGXHWEZWWM0Ybj8VZyOCOHef+tde+GwnP8NnigXiabGATzsg+idoxcqMe9rJxcu
        3cykqpw4Kj5fJqLyWwETnPtJeW9wNQg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-754gnUp3PZuwByv8ACuvvg-1; Tue, 04 Feb 2020 11:09:37 -0500
X-MC-Unique: 754gnUp3PZuwByv8ACuvvg-1
Received: by mail-wm1-f72.google.com with SMTP id q125so1488560wme.1
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 08:09:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YYcsiG17pzIghdQ6UseEA9aCS5seLdWvZ4aLxJRrky0=;
        b=OJlrxBHJmrtXxaILiZLc3zyC55IcZFtpZAE6hStGK/cMJE8OUCsDFU1fMusdnhOGgK
         uCuq7woauCp5kb31jktsF4ubwGuR4h8EZPf1QHklRJi9l0oNSIPdtJ3cur0lF96274MJ
         hmU8x3zFdGVoBwGrbk4ffpoK2kT5JGrtpVoAp2sFPTQrt3dcqmVP3h6PN0vCIQyu79On
         QsjInXh2obNK4zLTVa4yD0cIjH4X6orlzZgSpdc8TRz169T8o5GeCcR8QTPWhoF/Q0Ve
         1xrNJkixKgkVJGIwRP4PT8Xx65L1pQgCkaxGrBAOwDMoyegE5ZHDvN+75egystypyU63
         VNBQ==
X-Gm-Message-State: APjAAAUXmh9BqaU1434uwqcKVcLeLZ0QZBals51YZbuD0wdED/x7Q9Zi
        KqPHCkMnp/320r7b4CHJcj9/IDutmiJOmDOCgdX0IiXk63/rmGc3ZDUEjhv4Ayx2WpcrjhmLHdP
        M3K7Vq3Oz9+38
X-Received: by 2002:adf:de86:: with SMTP id w6mr24141600wrl.115.1580832575983;
        Tue, 04 Feb 2020 08:09:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqwpiUuo8DCUuI4HehnezJgwBrHQmTtGUJ/5QoB6unQFb/BNtXiX8CI3ee9lbnNFv9gHgkwF/w==
X-Received: by 2002:adf:de86:: with SMTP id w6mr24141579wrl.115.1580832575791;
        Tue, 04 Feb 2020 08:09:35 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id o189sm4499098wme.1.2020.02.04.08.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 08:09:35 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com,
        eric.auger.pro@gmail.com, eric.auger@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH v3 3/3] selftests: KVM: SVM: Add vmcall test
In-Reply-To: <20200204150040.2465-4-eric.auger@redhat.com>
References: <20200204150040.2465-1-eric.auger@redhat.com> <20200204150040.2465-4-eric.auger@redhat.com>
Date:   Tue, 04 Feb 2020 17:09:34 +0100
Message-ID: <87lfpimj0h.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Eric Auger <eric.auger@redhat.com> writes:

> L2 guest calls vmcall and L1 checks the exit status does
> correspond.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>
> ---
>
> v2 -> v3:
> - remove useless comment and add Vitaly's R-b
> ---
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../selftests/kvm/x86_64/svm_vmcall_test.c    | 85 +++++++++++++++++++
>  2 files changed, 86 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 2e770f554cae..b529d3b42c02 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -26,6 +26,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>  TEST_GEN_PROGS_x86_64 += x86_64/xss_msr_test
> +TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
>  TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
>  TEST_GEN_PROGS_x86_64 += dirty_log_test
>  TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
> diff --git a/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
> new file mode 100644
> index 000000000000..33cc26b57a73
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/svm_vmcall_test.c
> @@ -0,0 +1,85 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * svm_vmcall_test
> + *
> + * Copyright (C) 2020, Red Hat, Inc.
> + *
> + * Nested SVM testing: VMCALL
> + */
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "svm_util.h"
> +

I don't think ...

> +#include <string.h>
> +#include <sys/ioctl.h>
> +
> +#include "kselftest.h"
> +#include <linux/kernel.h>

... you need these.

> +
> +#define VCPU_ID		5
> +
> +static struct kvm_vm *vm;
> +
> +static inline void l2_vmcall(struct svm_test_data *svm)
> +{
> +	__asm__ __volatile__("vmcall");
> +}
> +
> +static void l1_guest_code(struct svm_test_data *svm)
> +{
> +	#define L2_GUEST_STACK_SIZE 64
> +	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> +	struct vmcb *vmcb = svm->vmcb;
> +
> +	/* Prepare for L2 execution. */
> +	generic_svm_setup(svm, l2_vmcall,
> +			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
> +
> +	run_guest(vmcb, svm->vmcb_gpa);
> +
> +	GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_VMMCALL);
> +	GUEST_DONE();
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	vm_vaddr_t svm_gva;
> +
> +	nested_svm_check_supported();
> +
> +	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
> +	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> +
> +	vcpu_alloc_svm(vm, &svm_gva);
> +	vcpu_args_set(vm, VCPU_ID, 1, svm_gva);
> +
> +	for (;;) {
> +		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
> +		struct ucall uc;
> +
> +		vcpu_run(vm, VCPU_ID);
> +		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
> +			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
> +			    run->exit_reason,
> +			    exit_reason_str(run->exit_reason));
> +
> +		switch (get_ucall(vm, VCPU_ID, &uc)) {
> +		case UCALL_ABORT:
> +			TEST_ASSERT(false, "%s",
> +				    (const char *)uc.args[0]);
> +			/* NOT REACHED */
> +		case UCALL_SYNC:
> +			break;
> +		case UCALL_DONE:
> +			goto done;
> +		default:
> +			TEST_ASSERT(false,
> +				    "Unknown ucall 0x%x.", uc.cmd);
> +		}
> +	}
> +done:
> +	kvm_vm_free(vm);
> +	return 0;
> +}

Apart from the above,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

