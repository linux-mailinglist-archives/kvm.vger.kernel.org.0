Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5FE39C25C
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 23:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhFDV3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 17:29:52 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:43917 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbhFDV3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 17:29:46 -0400
Received: by mail-pj1-f51.google.com with SMTP id l10-20020a17090a150ab0290162974722f2so6618823pja.2
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 14:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KdxZDkEntGS0nA5o93T1CW9hGc+4zm0nz/HKMuSuGpg=;
        b=U5Jns4RTTA8K1CnPOyIi6KCIfFcFhB2QnO0MiSYgvaltz7OU7gZQPC7oPqfb04uGph
         z1sPLgJyHxFmPu43OePS6sFlBOidnE/VQvQTjspdVCX331ZefrA7cL5JjVopDH5ziYDY
         4wjbjx3ROlI3qXcH9TDsUnCraq/oOvsrKzY0Bqg1345pcOpR+9t1L2iG5PuJgH+xrtfO
         fJav0dVabf7wwmva/9Ur13lbKgVWHg/zCffNsT9COCmJwwu10IvxWeCzujJq7fC1llst
         NXFFY6OyPM/goRC5LR0eIsj9eyX1pXTdi06fjtl8wD1UpYOSf9YVkNhNeVVqQsTg1BLu
         QEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KdxZDkEntGS0nA5o93T1CW9hGc+4zm0nz/HKMuSuGpg=;
        b=YF/8FATUzHhPXVn5hJAu2ccJtnl1JK+9B5IHmA8iPu5dAddqBD1zNhJK61F/H68eqe
         podo5DQCOUZeQqftyDmxgOpdgA44wC3gOLzWQGCAvrRSsY7BNcH7GjL9LJNEwf1bIy8n
         KZyyCAC3T/i8TSuQUdY/JslQW/k12p3I38aPk4DmVQs8SpKDIG8p1kOSO9wKWEAKg3KX
         qzM9UTVgonbWTUFSycICB0WIO8L7dDqXJ+nal8DOl61En0z/lx11PGFeWkqepwwAVA4x
         oPRLb8Zw69MHIYEMasloadBZQj8ZFz6iWskN6RgZiDlsr83g0nB9J8TRvM48efiWUl2l
         FytQ==
X-Gm-Message-State: AOAM531iSWQp/DsSd/agrgcnXFStJRl4gF9yT68ZS/unxySt6tZKva5a
        l0kk15D/jsH6rds6TGa14+ZaSA==
X-Google-Smtp-Source: ABdhPJwwyaNlt+dV//igiWvw6mNBax9yV5Ayyt3CnAE93mtTqXOrQ3np37iux+pWfuB/2XJJq5dReg==
X-Received: by 2002:a17:90a:b94c:: with SMTP id f12mr6658726pjw.32.1622842019070;
        Fri, 04 Jun 2021 14:26:59 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id ga23sm3809986pjb.0.2021.06.04.14.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 14:26:58 -0700 (PDT)
Date:   Fri, 4 Jun 2021 21:26:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        pbonzini@redhat.com, drjones@redhat.com, eric.auger@redhat.com,
        kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] KVM: selftests: Rename vm_handle_exception in evmcs test
Message-ID: <YLqanpE8tdiNeoaN@google.com>
References: <20210604181833.1769900-1-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604181833.1769900-1-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 04, 2021, Ricardo Koller wrote:
> Kernel test robot reports this:
> 
> > /usr/bin/ld: tools/testing/selftests/kvm/x86_64/evmcs_test.c:157: undefined reference to `vm_handle_exception'
> > /usr/bin/ld: tools/testing/selftests/kvm/x86_64/evmcs_test.c:158: undefined reference to `vm_handle_exception'
> > collect2: error: ld returned 1 exit status
> 
> Fix it by renaming vm_handle_exception to vm_install_vector_handler in
> evmcs_test.c.
> 
> Fixes: a2bad6a990a4 ("KVM: selftests: Rename vm_handle_exception")

Belated code review... Can we rename the helper to vm_install_exception_handler()?

In x86, "vector" is the number of the exception and "vectoring" is the process
of determining the resulting vector that gets delivered to software (e.g. when
dealing with contributory faults like #GP->#PF->#DF), but the thing that's being
handled is an exception.

arm appears to have similar terminology.  And looking at the arm code, it's very
confusing to have a helper vm_install_vector_handler() install into
exception_handlers, _not_ into vector_handlers.  Calling the vector_handlers
"default" handlers is also confusing, as "default" usually implies the thing can
be overwritten.  But in this case, the "default" handler is just another layer
in the routing.

The multiple layers of routing is also confusing and a bit hard to wade through
for the uninitiated.  The whole thing can be made more straightfoward by doing
away with the intermediate routing, whacking ~50 lines of code in the process.
E.g. (definitely not functional code):

diff --git a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
index 51c42ac24dca..c784e4b770cf 100644
--- a/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
+++ b/tools/testing/selftests/kvm/aarch64/debug-exceptions.c
@@ -212,15 +212,15 @@ int main(int argc, char *argv[])
                exit(KSFT_SKIP);
        }
 
-       vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
+       vm_install_exception_handler_ec(vm, VECTOR_SYNC_CURRENT,
                                ESR_EC_BRK_INS, guest_sw_bp_handler);
-       vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
+       vm_install_exception_handler_ec(vm, VECTOR_SYNC_CURRENT,
                                ESR_EC_HW_BP_CURRENT, guest_hw_bp_handler);
-       vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
+       vm_install_exception_handler_ec(vm, VECTOR_SYNC_CURRENT,
                                ESR_EC_WP_CURRENT, guest_wp_handler);
-       vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
+       vm_install_exception_handler_ec(vm, VECTOR_SYNC_CURRENT,
                                ESR_EC_SSTEP_CURRENT, guest_ss_handler);
-       vm_install_exception_handler(vm, VECTOR_SYNC_CURRENT,
+       vm_install_exception_handler_ec(vm, VECTOR_SYNC_CURRENT,
                                ESR_EC_SVC64, guest_svc_handler);
 
        for (stage = 0; stage < 7; stage++) {
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 1a3abe1037b0..211cb684577a 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -110,10 +110,10 @@ void vm_init_descriptor_tables(struct kvm_vm *vm);
 void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid);
 
 typedef void(*handler_fn)(struct ex_regs *);
-void vm_install_exception_handler(struct kvm_vm *vm,
-               int vector, int ec, handler_fn handler);
-void vm_install_vector_handler(struct kvm_vm *vm,
-               int vector, handler_fn handler);
+void vm_install_exception_handler_ec(struct kvm_vm *vm, int vector, int ec,
+                                    handler_fn handler);
+void vm_install_exception_handler(struct kvm_vm *vm, int vector,
+                                 handler_fn handler);
 
 #define write_sysreg(reg, val)                                           \
 ({                                                                       \
diff --git a/tools/testing/selftests/kvm/lib/aarch64/handlers.S b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
index 49bf8827c6ab..fee0c3155ec7 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/handlers.S
+++ b/tools/testing/selftests/kvm/lib/aarch64/handlers.S
@@ -93,7 +93,8 @@ handler_\label:
 .balign 0x80
 /* This will abort so no need to save and restore registers. */
        mov     x0, #vector
-       b       kvm_exit_unexpected_vector
+       <sean doesn't know what goes here>
+       b       kvm_exit_unexpected_exception
 .popsection
 
 .set   vector, vector + 1
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 03ce507d49d2..ff63e66e2c5d 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -337,16 +337,9 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
        va_end(ap);
 }
 
-void kvm_exit_unexpected_vector(int vector)
+void kvm_exit_unexpected_exception(int vector, uint64_t ec, bool valid_ec)
 {
-       ucall(UCALL_UNHANDLED, 3, vector, 0, false /* !valid_ec */);
-       while (1)
-               ;
-}
-
-static void kvm_exit_unexpected_exception(int vector, uint64_t ec)
-{
-       ucall(UCALL_UNHANDLED, 3, vector, ec, true /* valid_ec */);
+       ucall(UCALL_UNHANDLED, 3, vector, ec, valid_ec);
        while (1)
                ;
 }
@@ -369,18 +362,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid)
        }
 }
 
-/*
- * This exception handling code was heavily inspired on kvm-unit-tests. There
- * is a set of default vector handlers stored in vector_handlers. These default
- * vector handlers call user-installed handlers stored in exception_handlers.
- * Synchronous handlers are indexed by (vector, ec), and irq handlers by
- * (vector, ec=0).
- */
-
-typedef void(*vector_fn)(struct ex_regs *, int vector);
-
 struct handlers {
-       vector_fn vector_handlers[VECTOR_NUM];
        handler_fn exception_handlers[VECTOR_NUM][ESR_EC_NUM];
 };
 
@@ -391,80 +373,56 @@ void vcpu_init_descriptor_tables(struct kvm_vm *vm, uint32_t vcpuid)
        set_reg(vm, vcpuid, ARM64_SYS_REG(VBAR_EL1), (uint64_t)&vectors);
 }
 
-static void default_sync_handler(struct ex_regs *regs, int vector)
-{
-       struct handlers *handlers = (struct handlers *)exception_handlers;
-       uint64_t esr = read_sysreg(esr_el1);
-       uint64_t ec = (esr >> ESR_EC_SHIFT) & ESR_EC_MASK;
-
-       GUEST_ASSERT(VECTOR_IS_SYNC(vector));
-
-       if (handlers && handlers->exception_handlers[vector][ec])
-               handlers->exception_handlers[vector][ec](regs);
-       else
-               kvm_exit_unexpected_exception(vector, ec);
-}
-
-static void default_handler(struct ex_regs *regs, int vector)
-{
-       struct handlers *handlers = (struct handlers *)exception_handlers;
-
-       GUEST_ASSERT(!VECTOR_IS_SYNC(vector));
-
-       if (handlers && handlers->exception_handlers[vector][0])
-               handlers->exception_handlers[vector][0](regs);
-       else
-               kvm_exit_unexpected_vector(vector);
-}
-
 void route_exception(struct ex_regs *regs, int vector)
 {
-       struct handlers *handlers = (struct handlers *)exception_handlers;
+       struct handler_fn *handlers = exception_handlers;
+       bool valid_ec;
+       int ec;
 
-       if (handlers && handlers->vector_handlers[vector])
-               handlers->vector_handlers[vector](regs, vector);
-       else
-               kvm_exit_unexpected_vector(vector);
+       switch (vector) {
+       case VECTOR_SYNC_CURRENT:
+       case VECTOR_SYNC_LOWER_64:
+               ec = (read_sysreg(esr_el1) >> ESR_EC_SHIFT) & ESR_EC_MASK;
+               valid_ec = true;
+               break;
+       case VECTOR_IRQ_CURRENT:
+       case VECTOR_IRQ_LOWER_64:
+       case VECTOR_FIQ_CURRENT:
+       case VECTOR_FIQ_LOWER_64:
+       case VECTOR_ERROR_CURRENT:
+       case VECTOR_ERROR_LOWER_64:
+               ec = 0;
+               valid_ec = false;
+               break;
+       default:
+               goto unexpected_exception;
+       }
+
+       if (handlers && handlers[vector][ec])
+               return handlers[vector][ec](regs);
+
+unexpected_exception:
+       kvm_exit_unexpected_exception(vector, ec, valid_ec);
 }
 
 void vm_init_descriptor_tables(struct kvm_vm *vm)
 {
-       struct handlers *handlers;
-
-       vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
-                       vm->page_size, 0, 0);
-
-       handlers = (struct handlers *)addr_gva2hva(vm, vm->handlers);
-       handlers->vector_handlers[VECTOR_SYNC_CURRENT] = default_sync_handler;
-       handlers->vector_handlers[VECTOR_IRQ_CURRENT] = default_handler;
-       handlers->vector_handlers[VECTOR_FIQ_CURRENT] = default_handler;
-       handlers->vector_handlers[VECTOR_ERROR_CURRENT] = default_handler;
-
-       handlers->vector_handlers[VECTOR_SYNC_LOWER_64] = default_sync_handler;
-       handlers->vector_handlers[VECTOR_IRQ_LOWER_64] = default_handler;
-       handlers->vector_handlers[VECTOR_FIQ_LOWER_64] = default_handler;
-       handlers->vector_handlers[VECTOR_ERROR_LOWER_64] = default_handler;
-
-       *(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
+       *(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = __exception_handlers;
 }
 
-void vm_install_exception_handler(struct kvm_vm *vm, int vector, int ec,
-                        void (*handler)(struct ex_regs *))
+void vm_install_exception_handler_ec(struct kvm_vm *vm, int vector, int ec,
+                                    void (*handler)(struct ex_regs *))
 {
-       struct handlers *handlers = (struct handlers *)addr_gva2hva(vm, vm->handlers);
+       struct handlers *handlers = addr_gva2hva(vm, vm->handlers);
 
-       assert(VECTOR_IS_SYNC(vector));
+       assert(!ec == !VECTOR_IS_SYNC(vector));
        assert(vector < VECTOR_NUM);
        assert(ec < ESR_EC_NUM);
-       handlers->exception_handlers[vector][ec] = handler;
+       exception_handlers[vector][ec] = handler;
 }
 
-void vm_install_vector_handler(struct kvm_vm *vm, int vector,
-                        void (*handler)(struct ex_regs *))
+void vm_install_exception_handler(struct kvm_vm *vm, int vector,
+                                 void (*handler)(struct ex_regs *))
 {
-       struct handlers *handlers = (struct handlers *)addr_gva2hva(vm, vm->handlers);
-
-       assert(!VECTOR_IS_SYNC(vector));
-       assert(vector < VECTOR_NUM);
-       handlers->exception_handlers[vector][0] = handler;
+       vm_install_exception_handler_ec(vm, vector, 0, handler);
 }
