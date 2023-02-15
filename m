Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE47B69734D
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbjBOBQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbjBOBQh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:16:37 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43A41D91B
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:14 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id rm5-20020a17090b3ec500b0023406b78560so3273999pjb.8
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=C8zYRYKo2qpCMaVgCbanrD0ABKxCgrveHkaFS4p35L8=;
        b=Ya73y4pvAwBC1kS7/gArkfO6gsrts57fUsKBjZEx906c1BQJoEdOEJwc2E5ScKN2o/
         mGvaIgX1USgkAfRTO7aDc08MWjt7crYX3A/ddzB6A15C9mDE8RbAPQWIlPv5SX60FaMy
         jf789rYV4f0+0Z4MD6LWi92RmFYoS6s/mdGNoKk2yoXjn++wG95Fnsc+/YODb9DZa4aB
         PaIVS8ObOsI5d1iRgxebI86hrDuRd8ASWoBpvlTM0FYErk+0/JJyp0sNBn7LvHrhbtVX
         n8+PYethUjDEvABDvuk2AxtZjX6eOFC7AWh9EGJ4E8uaU8QiCCcX6SazkS9wB5HX9bvE
         Y2pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C8zYRYKo2qpCMaVgCbanrD0ABKxCgrveHkaFS4p35L8=;
        b=4aU1u5r8W5SyyDZ0v96LGVhNW8G6LveXDrvxZc0qeNs5B0d/lma1jsCdjqpPTzeFvR
         pY4uA5NtiohMa0FB4xXPWgsGZMb6P/KC01f4WctwErf5Sgvz5ebzCg9KdneIwK5U1eqL
         e7x2Sd461az8wMVsFzEL2px8f51Fmumzn0ocSGxYkGW0tkopbow4vyxv3LTlEur+ox+Z
         eUX5k+dWtOJJrTv9noXbfXmm9eb4h5MP/BC9jSBXeFudw0JSeymWk0p4ec4GYHskhVnT
         UxVVF1PlZT7PPSyqBsa78MebDS92OZwh5v4otLlibw92vYh992Nju1VEOVQ6IvFKwpF3
         S/wQ==
X-Gm-Message-State: AO0yUKUArAFoeLwIV1Z+gWT2Bf5BcpaxeDXOuZERpzoQchWb9PzxODD9
        wtmzStAB1OlfuH/GEzemZxw2SAULLlk=
X-Google-Smtp-Source: AK7set9BNNqCYdItRtpSe6gOmFfrE/sb2YCq630YaD43LnK6RB0E+0R5feVNzSQuytm9hqabKH4jamZbpCw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:3255:b0:19a:b801:13d7 with SMTP id
 ji21-20020a170903325500b0019ab80113d7mr146531plb.2.1676423320864; Tue, 14 Feb
 2023 17:08:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Feb 2023 17:07:18 -0800
In-Reply-To: <20230215010718.415413-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230215010718.415413-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215010718.415413-8-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: VMX changes for 6.3
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM VMX changes for 6.3.  The highlight is moving NMI VM-Exit handling under
the noinstr umbrella.

The following changes since commit 7cb79f433e75b05d1635aefaa851cfcd1cb7dc4f:

  KVM: PPC: Fix refactoring goof in kvmppc_e500mc_init() (2023-01-24 13:00:32 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-vmx-6.3

for you to fetch changes up to 93827a0a36396f2fd6368a54a020f420c8916e9b:

  KVM: VMX: Fix crash due to uninitialized current_vmcs (2023-02-07 09:02:50 -0800)

----------------------------------------------------------------
KVM VMX changes for 6.3:

 - Handle NMI VM-Exits before leaving the noinstr region

 - A few trivial cleanups in the VM-Enter flows

 - Stop enabling VMFUNC for L1 purely to document that KVM doesn't support
   EPTP switching (or any other VM function) for L1

 - Fix a crash when using eVMCS's enlighted MSR bitmaps

----------------------------------------------------------------
Alexandru Matei (1):
      KVM: VMX: Fix crash due to uninitialized current_vmcs

Alexey Dobriyan (1):
      KVM: VMX: don't use "unsigned long" in vmx_vcpu_enter_exit()

Sean Christopherson (8):
      KVM: VMX: Access @flags as a 32-bit value in __vmx_vcpu_run()
      KVM: x86: Make vmx_get_exit_qual() and vmx_get_intr_info() noinstr-friendly
      KVM: VMX: Allow VM-Fail path of VMREAD helper to be instrumented
      KVM: VMX: Always inline eVMCS read/write helpers
      KVM: VMX: Always inline to_vmx() and to_kvm_vmx()
      x86/entry: KVM: Use dedicated VMX NMI entry for 32-bit kernels too
      KVM: VMX: Provide separate subroutines for invoking NMI vs. IRQ handlers
      KVM: VMX: Handle NMI VM-Exits in noinstr region

Yu Zhang (2):
      KVM: VMX: Do not trap VMFUNC instructions for L1 guests.
      KVM: nVMX: Simplify the setting of SECONDARY_EXEC_ENABLE_VMFUNC for nested.

 arch/x86/include/asm/idtentry.h | 16 ++++-----
 arch/x86/kernel/nmi.c           |  8 ++---
 arch/x86/kvm/kvm_cache_regs.h   | 12 +++++++
 arch/x86/kvm/vmx/hyperv.h       | 31 ++++++----------
 arch/x86/kvm/vmx/nested.c       | 21 +++++------
 arch/x86/kvm/vmx/vmcs.h         |  4 +--
 arch/x86/kvm/vmx/vmenter.S      | 80 ++++++++++++++++++++++-------------------
 arch/x86/kvm/vmx/vmx.c          | 72 ++++++++++++++++++++++---------------
 arch/x86/kvm/vmx/vmx.h          | 18 +++++-----
 arch/x86/kvm/vmx/vmx_ops.h      |  2 ++
 arch/x86/kvm/x86.h              |  6 ++--
 11 files changed, 143 insertions(+), 127 deletions(-)
