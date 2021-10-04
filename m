Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C554215E6
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 20:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbhJDSDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 14:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbhJDSDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 14:03:30 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07144C061745
        for <kvm@vger.kernel.org>; Mon,  4 Oct 2021 11:01:41 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id 72so17358704qkk.7
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 11:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=CQjISX4cpePeXQAfVi2rLJCncJ5gVzXwhTOkI28aziE=;
        b=fSXFDdNKvyMK/yaCgGoXJ6m72aKBTdReBKGveeCC29x6MdScWA111agI+MsjJ090+g
         0DTYK3TyPADTYrrih61nPgTCVJtxE6pKAW07d7vWYFaBBtThsyoK9j2V+H4vnWeCsY8E
         svpFmFYwQuEpR18LI75/EQZVeSJ8+d90tfH/O1eB8/KVf8l6ScA3eLd1pQAHrToxBC3+
         /oEWXTW8Q4EO1A1X7HjNfzyr7Z+t+/n2JgSWq5mBTISjtGlyHZdCHsj79DqGGIlU2uqG
         uHsGvv3Hf1QYn2cNPWYvlX2IyKJ/geE8eLgQnCXLL4QkFdTL/2Zj6FYEDEIyACQVlhui
         eMZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=CQjISX4cpePeXQAfVi2rLJCncJ5gVzXwhTOkI28aziE=;
        b=xRNwvYKAXyrK4t0lPbVWn2e4cNPs3gtt6WkFzbBTxpjjCD2B3ps1TnPT5T2S93rmja
         9gDBn7nWPZdq1asN8uwY/yhgQGqZLvAsDWrf1LyyQecS+piS5YzME76ezj+NpFTS/GDK
         4vJmm6+mBHpkAIiqy+BX2eAqsfktg6OOx24DtM3cvi6yGtSwOiiX4pU3j4xMeOqZnSji
         Gv0A1WquSH5laTyX2i5ZeM2OM+NAl7godol8M5PeFUsEj1Viv+pD2iuBpVOjTHMKZ7WU
         YpuruBAcC4txjfG4ZTmOLq4i5SYHzGxvN0e0KLnpNSq25fkAS23gapGaqw7kzX+imnqp
         uO8Q==
X-Gm-Message-State: AOAM530JfXr3tgA8G+1Mml91YOMzhjaZH6ZUanLezdq+PE2Q7EshBW1C
        Co/WwJ77vEl5+N7ZmQDMTdQoHg==
X-Google-Smtp-Source: ABdhPJyW3XAlloMgTj6KKo74FXq7cHjymNK0JudtpTQypDKmPZqhjg7xC61tUHm+paNlCQeO8fWElg==
X-Received: by 2002:a37:6147:: with SMTP id v68mr11510781qkb.154.1633370499899;
        Mon, 04 Oct 2021 11:01:39 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id v2sm9541297qtw.8.2021.10.04.11.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 11:01:39 -0700 (PDT)
Date:   Mon, 04 Oct 2021 11:01:39 -0700 (PDT)
X-Google-Original-Date: Mon, 04 Oct 2021 11:01:35 PDT (-0700)
Subject:     Re: [PATCH v20 00/17] KVM RISC-V Support
In-Reply-To: <5cadb0b3-5e8f-110b-c6ed-4adaea033e58@redhat.com>
CC:     Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, graf@amazon.com,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>, anup@brainfault.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     pbonzini@redhat.com
Message-ID: <mhng-1bfcbce2-3da3-4490-bcc5-45173ad84285@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 04 Oct 2021 01:58:28 PDT (-0700), pbonzini@redhat.com wrote:
> On 27/09/21 13:39, Anup Patel wrote:
>> This series adds initial KVM RISC-V support. Currently, we are able to boot
>> Linux on RV64/RV32 Guest with multiple VCPUs.
>>
>> Key aspects of KVM RISC-V added by this series are:
>> 1. No RISC-V specific KVM IOCTL
>> 2. Loadable KVM RISC-V module supported
>> 3. Minimal possible KVM world-switch which touches only GPRs and few CSRs
>> 4. Both RV64 and RV32 host supported
>> 5. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure
>> 6. KVM ONE_REG interface for VCPU register access from user-space
>> 7. PLIC emulation is done in user-space
>> 8. Timer and IPI emuation is done in-kernel
>> 9. Both Sv39x4 and Sv48x4 supported for RV64 host
>> 10. MMU notifiers supported
>> 11. Generic dirtylog supported
>> 12. FP lazy save/restore supported
>> 13. SBI v0.1 emulation for KVM Guest available
>> 14. Forward unhandled SBI calls to KVM userspace
>> 15. Hugepage support for Guest/VM
>> 16. IOEVENTFD support for Vhost
>>
>> Here's a brief TODO list which we will work upon after this series:
>> 1. KVM unit test support
>> 2. KVM selftest support
>> 3. SBI v0.3 emulation in-kernel
>> 4. In-kernel PMU virtualization
>> 5. In-kernel AIA irqchip support
>> 6. Nested virtualizaiton
>> 7. ..... and more .....
>
> Looks good, I prepared a tag "for-riscv" at
> https://git.kernel.org/pub/scm/virt/kvm/kvm.git.  Palmer can pull it and
> you can use it to send me a pull request.

Thanks.  I'm assuming "you" there is Anup?

Just to make sure we're on the same page here, I've got

    commit 6c341a285912ddb2894ef793a58ad4f8462f26f4 (HEAD -> for-next)
    Merge: 08da1608a1ca 3f2401f47d29
    Author: Palmer Dabbelt <palmerdabbelt@google.com>
    Date:   Mon Oct 4 10:12:44 2021 -0700
    
        Merge tag 'for-riscv' of https://git.kernel.org/pub/scm/virt/kvm/kvm.git into for-next
    
        H extension definitions, shared by the KVM and RISC-V trees.
    
        * tag 'for-riscv' of ssh://gitolite.kernel.org/pub/scm/virt/kvm/kvm: (301 commits)
          RISC-V: Add hypervisor extension related CSR defines
          KVM: selftests: Ensure all migrations are performed when test is affined
          KVM: x86: Swap order of CPUID entry "index" vs. "significant flag" checks
          ptp: Fix ptp_kvm_getcrosststamp issue for x86 ptp_kvm
          x86/kvmclock: Move this_cpu_pvti into kvmclock.h
          KVM: s390: Function documentation fixes
          selftests: KVM: Don't clobber XMM register when read
          KVM: VMX: Fix a TSX_CTRL_CPUID_CLEAR field mask issue
          selftests: KVM: Explicitly use movq to read xmm registers
          selftests: KVM: Call ucall_init when setting up in rseq_test
          KVM: Remove tlbs_dirty
          KVM: X86: Synchronize the shadow pagetable before link it
          KVM: X86: Fix missed remote tlb flush in rmap_write_protect()
          KVM: x86: nSVM: don't copy virt_ext from vmcb12
          KVM: x86: nSVM: test eax for 4K alignment for GP errata workaround
          KVM: x86: selftests: test simultaneous uses of V_IRQ from L1 and L0
          KVM: x86: nSVM: restore int_vector in svm_clear_vintr
          kvm: x86: Add AMD PMU MSRs to msrs_to_save_all[]
          KVM: x86: nVMX: re-evaluate emulation_required on nested VM exit
          KVM: x86: nVMX: don't fail nested VM entry on invalid guest state if !from_vmentry
          ...

into ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/palmer/linux.git for-next
(I know that's kind of a confusing name, but it's what I've been using 
as my short-term staging branch so I can do all my tests before saying 
"it's on for-next").

If that looks OK I can make it a touch more official by putting into the 
RISC-V tree.

> I look forward to the test support. :)  Would be nice to have selftest
> support already in 5.16, since there are a few arch-independent
> selftests that cover the hairy parts of the MMU.

Me too ;).

I'm happy to add some KVM-related stuff to my pre-push test set, just 
LMK if there's anything specific I should be looking in to.
