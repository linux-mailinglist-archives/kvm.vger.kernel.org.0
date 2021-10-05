Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD6B422BC0
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 17:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhJEPF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 11:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhJEPF5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 11:05:57 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA48C061749
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 08:04:06 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id q7-20020a17090a2e0700b001a01027dd88so671506pjd.1
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 08:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=ezjhWNNLffOxacY2MX3oY+yRcl8+NMzjlUvbMffez5U=;
        b=LUivbkzaoWTjkEdbE8lk8teCg6efdKH8/wjpX2qcvCu/pkS1+s/8i5QyKFTUrnG0VA
         loD6W5+SuCiURjr21bbRCEofY/Poc3L35Mjhbi+LM9Qxd4nnDQEary3T7nRxsz/FuJF8
         Pq0Et8Z6iI3E9YAD0mtjGFlrlCLMgeAC3t4+olrHLrIZss6yBWOUe1hXJ/LElUcrW/Fi
         86A/sDgVYZDFBQIq4KsEubm//oHObpA/iag4xoHXumjUf3OXKCjht6w6rc64DRlhKe4v
         4UHewUCjNfNc+Gzid2a1wkz/K7nBAFuDx5QskA+LQexy72eDh/jgbd1VGRBtqfkwnPNX
         TLSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=ezjhWNNLffOxacY2MX3oY+yRcl8+NMzjlUvbMffez5U=;
        b=oPI1O1d3m5UuQ2ZeHNtI0gfW4lqdbaZX4drxSg9HV6tL1Vm100jKYHjiQqvBQrlufs
         ixTUtUa0DP4Bwi7sobHotI+Rf38lRS2G7Y9q2CZYZv+Y/UBvk/b1iD83jI020r6st88A
         e+nPYQG9yTBNdKIItvyN+Anb/jgubTpbdKqef4vzbWtd36gv/NcXaOwzMio6Td2xOJ9j
         oYtrK9UqGoNySnwQ2mkwpHfLdaZIVGrR6pR4CGuDxMe1MNM8je1ZrvGPeT7qS8FPu083
         rWQcBqcn0cPbASx1ZpipAKBcpnxjDiTJ0B+3DiRAmVK0N2eeOSb8aV4fbYbHjZocBCq8
         WscA==
X-Gm-Message-State: AOAM533mEdHj8NcV0yy02QndteHY4NQLhWjZQ0zl7c9oKpyqmcfNheoj
        a6ngF0BqlRHNOJUeUYGuFi3npg==
X-Google-Smtp-Source: ABdhPJzne960yQOEugoxpMdT5nmc2Pr8zbT8eorkTZOXrYJHIozaHR2Qh0E83P1AYKMiIlWKARd9xg==
X-Received: by 2002:a17:902:7fcf:b0:13e:c994:ee67 with SMTP id t15-20020a1709027fcf00b0013ec994ee67mr5679359plb.12.1633446245936;
        Tue, 05 Oct 2021 08:04:05 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id 23sm19811865pfw.97.2021.10.05.08.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 08:04:05 -0700 (PDT)
Date:   Tue, 05 Oct 2021 08:04:05 -0700 (PDT)
X-Google-Original-Date: Tue, 05 Oct 2021 08:04:03 PDT (-0700)
Subject:     Re: [PATCH v20 00/17] KVM RISC-V Support
In-Reply-To: <ea3a9bab-28f2-48e7-761e-b41d7bc7d0a5@redhat.com>
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
Message-ID: <mhng-daf7c58d-d8ef-4d68-b387-ba258be48ed3@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 05 Oct 2021 00:37:27 PDT (-0700), pbonzini@redhat.com wrote:
> On 04/10/21 20:01, Palmer Dabbelt wrote:
>> 
>> Just to make sure we're on the same page here, I've got
>> 
>>     commit 6c341a285912ddb2894ef793a58ad4f8462f26f4 (HEAD -> for-next)
>>     Merge: 08da1608a1ca 3f2401f47d29
>>     Author: Palmer Dabbelt <palmerdabbelt@google.com>
>>     Date:   Mon Oct 4 10:12:44 2021 -0700
>>         Merge tag 'for-riscv' of 
>> https://git.kernel.org/pub/scm/virt/kvm/kvm.git into for-next
>>         H extension definitions, shared by the KVM and RISC-V trees.
>>         * tag 'for-riscv' of 
>> ssh://gitolite.kernel.org/pub/scm/virt/kvm/kvm: (301 commits)
>>           RISC-V: Add hypervisor extension related CSR defines
>>           KVM: selftests: Ensure all migrations are performed when test 
>> is affined
>>           KVM: x86: Swap order of CPUID entry "index" vs. "significant 
>> flag" checks
>>           ptp: Fix ptp_kvm_getcrosststamp issue for x86 ptp_kvm
>>           x86/kvmclock: Move this_cpu_pvti into kvmclock.h
>>           KVM: s390: Function documentation fixes
>>           selftests: KVM: Don't clobber XMM register when read
>>           KVM: VMX: Fix a TSX_CTRL_CPUID_CLEAR field mask issue
>>           selftests: KVM: Explicitly use movq to read xmm registers
>>           selftests: KVM: Call ucall_init when setting up in rseq_test
>>           KVM: Remove tlbs_dirty
>>           KVM: X86: Synchronize the shadow pagetable before link it
>>           KVM: X86: Fix missed remote tlb flush in rmap_write_protect()
>>           KVM: x86: nSVM: don't copy virt_ext from vmcb12
>>           KVM: x86: nSVM: test eax for 4K alignment for GP errata 
>> workaround
>>           KVM: x86: selftests: test simultaneous uses of V_IRQ from L1 
>> and L0
>>           KVM: x86: nSVM: restore int_vector in svm_clear_vintr
>>           kvm: x86: Add AMD PMU MSRs to msrs_to_save_all[]
>>           KVM: x86: nVMX: re-evaluate emulation_required on nested VM exit
>>           KVM: x86: nVMX: don't fail nested VM entry on invalid guest 
>> state if !from_vmentry
>>           ...
>> 
>> into 
>> ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/palmer/linux.git 
>> for-next
>> (I know that's kind of a confusing name, but it's what I've been using 
>> as my short-term staging branch so I can do all my tests before saying 
>> "it's on for-next").
>> 
>> If that looks OK I can make it a touch more official by putting into the 
>> RISC-V tree.
>
> Yes.  All of the patches in there, except the last, are already in 
> Linus's tree.

Great, it's up.
