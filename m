Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F2C421F82
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 09:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhJEHjX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 03:39:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232630AbhJEHjW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Oct 2021 03:39:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633419451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=49p/2VYCpgzSUPriPCQYlTSgRQVf+nlRSvbtUTXuaMU=;
        b=jNHVc24MffhkHR4hCdbJHxNNd9LKdZzB+yD21lNKp9vKhkNccJU1W+myNWZHgSL4D5kD7j
        tEhI4fkFGWB5KxFHO1zC5YliGMegVZWuEB0dqDCaMDWbHAQXzyThb5uYZBZiSAAwOj/80P
        BR7+JpBLH9GDy+w1rOYV6h8/0Aq9awo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-9pBin32JMGagtqBLmZbJag-1; Tue, 05 Oct 2021 03:37:30 -0400
X-MC-Unique: 9pBin32JMGagtqBLmZbJag-1
Received: by mail-ed1-f71.google.com with SMTP id ec14-20020a0564020d4e00b003cf5630c190so19885994edb.3
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 00:37:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=49p/2VYCpgzSUPriPCQYlTSgRQVf+nlRSvbtUTXuaMU=;
        b=IcLEcjfpFL6rbEw7Thm2lg4CCj6LXiQ4prvaL0oEnnof6pjslRIlwdRuhorBKbWHWO
         q4C6LBXjPzTxNpUtlJ/X7wPD9cX0TpOw8tzIZBAgDYngIT9WKOoZwEa4glM0izdv0Q0A
         7oXwkn/YBL/vimcqAkbJtubElPrO5HuIM45/MeyBbTt3lfw0XAwG4uh3xA6YJsLL/GWW
         sl0IbC1oOkvYIXgte7CXMufAY3VBoMnk0ZfmU69mFk/IGVHL6E1g8yc/4G8iUuRPl7Nb
         PVfuAwT7tVl9VPw5eTCH3yUjNm1HJQhAiWb29R1Qj59VFSxrS85j4jEn9LLPHPfMFQ/C
         KeVw==
X-Gm-Message-State: AOAM531L7bISqzvcvYG08o0aEsG4Ps7Djm55D2aALGRX+39FFzBuybrm
        HcsMRT70BxhJucIVZHKGdqqIlswiIlHva1Szn1M5E7li/IyxAGwACvPzjPuIorS8BU1cI+0x9we
        j9Ijv4VZucfhp
X-Received: by 2002:aa7:d78e:: with SMTP id s14mr23518884edq.171.1633419449697;
        Tue, 05 Oct 2021 00:37:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYKBVFrLpIIpPhu4m8RSBp05E7KVTz4BenJWgbIUX3s52OfAYe/V6Krl1NZzZwvRsRNqEHBQ==
X-Received: by 2002:aa7:d78e:: with SMTP id s14mr23518858edq.171.1633419449429;
        Tue, 05 Oct 2021 00:37:29 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.162.200])
        by smtp.gmail.com with ESMTPSA id d10sm7349501eja.81.2021.10.05.00.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 00:37:28 -0700 (PDT)
Message-ID: <ea3a9bab-28f2-48e7-761e-b41d7bc7d0a5@redhat.com>
Date:   Tue, 5 Oct 2021 09:37:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v20 00/17] KVM RISC-V Support
Content-Language: en-US
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, graf@amazon.com,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>, anup@brainfault.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <mhng-1bfcbce2-3da3-4490-bcc5-45173ad84285@palmerdabbelt-glaptop>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <mhng-1bfcbce2-3da3-4490-bcc5-45173ad84285@palmerdabbelt-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/21 20:01, Palmer Dabbelt wrote:
> 
> Just to make sure we're on the same page here, I've got
> 
>     commit 6c341a285912ddb2894ef793a58ad4f8462f26f4 (HEAD -> for-next)
>     Merge: 08da1608a1ca 3f2401f47d29
>     Author: Palmer Dabbelt <palmerdabbelt@google.com>
>     Date:   Mon Oct 4 10:12:44 2021 -0700
>         Merge tag 'for-riscv' of 
> https://git.kernel.org/pub/scm/virt/kvm/kvm.git into for-next
>         H extension definitions, shared by the KVM and RISC-V trees.
>         * tag 'for-riscv' of 
> ssh://gitolite.kernel.org/pub/scm/virt/kvm/kvm: (301 commits)
>           RISC-V: Add hypervisor extension related CSR defines
>           KVM: selftests: Ensure all migrations are performed when test 
> is affined
>           KVM: x86: Swap order of CPUID entry "index" vs. "significant 
> flag" checks
>           ptp: Fix ptp_kvm_getcrosststamp issue for x86 ptp_kvm
>           x86/kvmclock: Move this_cpu_pvti into kvmclock.h
>           KVM: s390: Function documentation fixes
>           selftests: KVM: Don't clobber XMM register when read
>           KVM: VMX: Fix a TSX_CTRL_CPUID_CLEAR field mask issue
>           selftests: KVM: Explicitly use movq to read xmm registers
>           selftests: KVM: Call ucall_init when setting up in rseq_test
>           KVM: Remove tlbs_dirty
>           KVM: X86: Synchronize the shadow pagetable before link it
>           KVM: X86: Fix missed remote tlb flush in rmap_write_protect()
>           KVM: x86: nSVM: don't copy virt_ext from vmcb12
>           KVM: x86: nSVM: test eax for 4K alignment for GP errata 
> workaround
>           KVM: x86: selftests: test simultaneous uses of V_IRQ from L1 
> and L0
>           KVM: x86: nSVM: restore int_vector in svm_clear_vintr
>           kvm: x86: Add AMD PMU MSRs to msrs_to_save_all[]
>           KVM: x86: nVMX: re-evaluate emulation_required on nested VM exit
>           KVM: x86: nVMX: don't fail nested VM entry on invalid guest 
> state if !from_vmentry
>           ...
> 
> into 
> ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/palmer/linux.git 
> for-next
> (I know that's kind of a confusing name, but it's what I've been using 
> as my short-term staging branch so I can do all my tests before saying 
> "it's on for-next").
> 
> If that looks OK I can make it a touch more official by putting into the 
> RISC-V tree.

Yes.  All of the patches in there, except the last, are already in 
Linus's tree.

Thank you,

Paolo

