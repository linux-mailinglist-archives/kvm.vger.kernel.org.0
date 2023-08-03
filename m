Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2C776EFCE
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 18:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbjHCQmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 12:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235635AbjHCQm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 12:42:26 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3AE3ABE
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 09:42:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d1bcb99b518so1307736276.2
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 09:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691080921; x=1691685721;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kEfK6uXoOOqmnGh1iZAHkEy6kbDfk8RpX9kLNMH0qMw=;
        b=SxIer3Ffo+cVQaIx9FpKirNSI36AS35BlUL3j2HwGzyzwH2DNlgIFKf38mR4bcHaNH
         iQI9tI5x1dn3K0ifJAEMPuv85fSRh4B6C1GTffs6qzhVQBAEQmzNNlR9/furePi6Gu5P
         6oZ3Gg5oh/6+mtZsq/Ha15KtfIECSlxee1MSBKzK4AbNZgiH4etgUyFQUckgalUfBLLd
         n57UK5XeSGM77BrORRBpFBrP3/zJdJqteHG2xlnLvf2y/MCVyTQ8Ab061BUwOo/947S5
         PKb+7xaErpGfcugqPS0+s49xfrHDWQLcWQ2Vq0FcEb4URxs0qRxCfTRQ4wVnjgAwVqHE
         hFIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691080921; x=1691685721;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kEfK6uXoOOqmnGh1iZAHkEy6kbDfk8RpX9kLNMH0qMw=;
        b=kw7Te0uvuNl7L2d4RMG4OoLkXnFN24YOBMhH8Pt7xxr2npOicY4p/qouoXjwXbSNQ+
         xSVF+slLRAFW4dMtz+IPfyQBBJPFe7RwTnQLaXGBrvhi1++JQgrxcyKhsPZN4XFg+r6a
         yoYTYnbdWOERkJBU1EUo96wb6qJIZAcwvlV6eHKrPJnNT/Zbj/ETpcDhbAhdcb3UsajJ
         5Fq9RwgcZYTi/77mxVbUj1dY67+Lj7Ix/Afjw+ZAXlxTvIJwcE49kYIt8ngxl371+bJ+
         Z+p2VnD/X7eqH2Hti0EOsOT6EFSkqo93pbzVtFqWju5WgL8kWRGKjbgNLPPffZeYAtcy
         qASQ==
X-Gm-Message-State: AOJu0YyY7LxIr2l0hex0h1zLoHzQdXmqnTGyN/RFTFSN5oNiDf102Yls
        V+sYOfvl1dn+FPqPtJcO296emp7/5+8=
X-Google-Smtp-Source: AGHT+IFSXX3XUIFF9i1iWJqRlZSpC9uDBIJzN8GgwOUbLfO0uIP09S819pAXv9q/2/xWaTDijcgAnMG/LS0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:18d5:0:b0:d42:30b5:1b5f with SMTP id
 204-20020a2518d5000000b00d4230b51b5fmr7908yby.13.1691080920862; Thu, 03 Aug
 2023 09:42:00 -0700 (PDT)
Date:   Thu, 3 Aug 2023 09:41:59 -0700
In-Reply-To: <222888b6-0046-3351-ba2f-fe6ac863f73d@rbox.co>
Mime-Version: 1.0
References: <20230728001606.2275586-1-mhal@rbox.co> <20230728001606.2275586-3-mhal@rbox.co>
 <ZMrFmKRcsb84DaTY@google.com> <222888b6-0046-3351-ba2f-fe6ac863f73d@rbox.co>
Message-ID: <ZMvY17kJR59P2blD@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Extend x86's sync_regs_test to check
 for races
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023, Michal Luczaj wrote:
> On 8/2/23 23:07, Sean Christopherson wrote:
> > On Fri, Jul 28, 2023, Michal Luczaj wrote:
> >> +	/*
> >> +	 * If kvm->bugged then we won't survive TEST_ASSERT(). Leak.
> >> +	 *
> >> +	 * kvm_vm_free()
> >> +	 *   __vm_mem_region_delete()
> >> +	 *     vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION, &region->region)
> >> +	 *       _vm_ioctl(vm, cmd, #cmd, arg)
> >> +	 *         TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret))
> >> +	 */
> > 
> > We want the assert, it makes failures explicit.  The signature is a bit unfortunate,
> > but the WARN in the kernel log should provide a big clue.
> 
> Sure, I get it. And not that there is a way to check if VM is bugged/dead?

KVM doesn't expost the bugged/dead information, though I suppose userspace could
probe that information by doing an ioctl() that is guaranteed to succeeed and
looking for -EIO, e.g. KVM_CHECK_EXTENSION on the VM.

I was going to say that it's not worth trying to detect a bugged/dead VM in
selftests, because it requires having the pointer to the VM, and that's not
typically available when an assert fails, but the obviously solution is to tap
into the VM and vCPU ioctl() helpers.  That's also good motivation to add helpers
and consolidate asserts for ioctls() that return fds, i.e. for which a positive
return is considered success.

With the below (partial conversion), the failing testcase yields this.  Using a
heuristic isn't ideal, but practically speaking I can't see a way for the -EIO
check to go awry, and anything to make debugging errors easier is definitely worth
doing IMO.

==== Test Assertion Failure ====
  lib/kvm_util.c:689: false
  pid=80347 tid=80347 errno=5 - Input/output error
     1	0x00000000004039ab: __vm_mem_region_delete at kvm_util.c:689 (discriminator 5)
     2	0x0000000000404660: kvm_vm_free at kvm_util.c:724 (discriminator 12)
     3	0x0000000000402ac9: race_sync_regs at sync_regs_test.c:193
     4	0x0000000000401cb7: main at sync_regs_test.c:334 (discriminator 6)
     5	0x0000000000418263: __libc_start_call_main at libc-start.o:?
     6	0x00000000004198af: __libc_start_main_impl at ??:?
     7	0x0000000000401d90: _start at ??:?
  KVM killed/bugged the VM, check kernel log for clues


diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 07732a157ccd..e48ac57be13a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -258,17 +258,42 @@ static __always_inline void static_assert_is_vm(struct kvm_vm *vm) { }
        kvm_do_ioctl((vm)->fd, cmd, arg);                       \
 })
 
+/*
+ * Assert that a VM or vCPU ioctl() succeeded (obviously), with extra magic to
+ * detect if the ioctl() failed because KVM killed/bugged the VM.  To detect a
+ * dead VM, probe KVM_CAP_USER_MEMORY, which (a) has been supported by KVM
+ * since before selftests existed and (b) should never outright fail, i.e. is
+ * supposed to return 0 or 1.  If KVM kills a VM, KVM returns -EIO for all
+ * ioctl()s for the VM and its vCPUs, including KVM_CHECK_EXTENSION.
+ */
+#define TEST_ASSERT_VM_VCPU_IOCTL_SUCCESS(name, ret, vm)                               \
+do {                                                                                   \
+       int __errno = errno;                                                            \
+                                                                                       \
+       static_assert_is_vm(vm);                                                        \
+                                                                                       \
+       if (!ret)                                                                       \
+               break;                                                                  \
+                                                                                       \
+       if (errno == EIO &&                                                             \
+           __vm_ioctl(vm, KVM_CHECK_EXTENSION, (void *)KVM_CAP_USER_MEMORY) < 0) {     \
+               TEST_ASSERT(errno == EIO, "KVM killed the VM, should return -EIO");     \
+               TEST_FAIL("KVM killed/bugged the VM, check kernel log for clues");      \
+       }                                                                               \
+       errno = __errno;                                                                \
+       TEST_FAIL(__KVM_IOCTL_ERROR(name, ret));                                        \
+} while (0)
+
 #define _vm_ioctl(vm, cmd, name, arg)                          \
 ({                                                             \
        int ret = __vm_ioctl(vm, cmd, arg);                     \
                                                                \
-       TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));        \
+       TEST_ASSERT_VM_VCPU_IOCTL_SUCCESS(name, ret, vm);       \
 })
 
 #define vm_ioctl(vm, cmd, arg)                                 \
        _vm_ioctl(vm, cmd, #cmd, arg)
 
-
 static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
 
 #define __vcpu_ioctl(vcpu, cmd, arg)                           \
@@ -281,7 +306,7 @@ static __always_inline void static_assert_is_vcpu(struct kvm_vcpu *vcpu) { }
 ({                                                             \
        int ret = __vcpu_ioctl(vcpu, cmd, arg);                 \
                                                                \
-       TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));        \
+       TEST_ASSERT_VM_VCPU_IOCTL_SUCCESS(name, ret, vcpu->vm); \
 })
 
 #define vcpu_ioctl(vcpu, cmd, arg)                             \

