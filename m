Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8655A43E48C
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 17:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhJ1PHh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 11:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbhJ1PHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 11:07:36 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E5FC061745
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 08:05:08 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so4957695pjb.3
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 08:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=4gMtHi9lx++3HO8vHpSr1p/5SUEC9v5TgkpF9eatiFk=;
        b=K+NZNuK0NEy7CWaSV4JOiMoT1ySYl6N3psbfIWxFVz1dNkttxp8v1yfcGJYuRN1wQ2
         qTBQdAU/viqVKYgueJn3+kUsPZyTErYkXStWjxkMnERO/TJ7TAIEJkb9uJ3NnyvedF15
         KGXi3XJTzqFVc2DL7LV6IEeYXkcEGk137v0IxMTPxmToOcUxs0S5AlHrLaWddDVEjYZN
         Jh/93FheIbHdWy7RcEmassxL63YQ3P5YuPUqPH0uH9S4lqAI/kG1X7xn2cGnopL49tnN
         rqfwiTUqrN3qQ2VpvNF30j5y/hBy9Ziey8OVbNXJ+fv/M51074tMETY59y+ZI7cllj7a
         nEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=4gMtHi9lx++3HO8vHpSr1p/5SUEC9v5TgkpF9eatiFk=;
        b=JzoZjbgLzl4Ymqul/RChJXc0KAptpxBBvk/yNl74O+8qiAXNqGzpggarVwcDCyZgUI
         GNQK/E7Cfah8xK8ngWj4WAAUU3rYsiIquSTSrKZxJkxqIumbnED8rC6Ro6Guohr3/pRz
         InAO4Hyhfxhhsey3QK9zJ36XzftTu9idinccxBBidLmaCvGEU7Zy2jN1t2lh123qF2Jh
         +ILYC18hTNiu0wU6WsoECdmlr+w1tfxAG6rGOkLn6q7Jnx3iBkKmL5/p85xgzoIMp95C
         5SjOSLMaYJ3XUNcphU0VfJ6aqexPI4maaIvT7ljqKfLiAlruitneEdWu8ibbACHlblMO
         FYDQ==
X-Gm-Message-State: AOAM533qb8i46VdG/bZpv1wtnXC0GW+5YXgCdElgRue8dgpjnNEMtvpa
        ZhRWBnPHt6nOafJt56GSRb28ug==
X-Google-Smtp-Source: ABdhPJxjB/bUKH1oax3ewBcarZQQHiVnAU8V8Q1ZM8DOQgZjlVjFf7NuLsk1V8PGZf2QWwCTX3AR1g==
X-Received: by 2002:a17:902:ab50:b0:13f:4c70:9322 with SMTP id ij16-20020a170902ab5000b0013f4c709322mr4222731plb.89.1635433507260;
        Thu, 28 Oct 2021 08:05:07 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id o22sm4215280pfu.50.2021.10.28.08.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 08:05:06 -0700 (PDT)
Date:   Thu, 28 Oct 2021 08:05:06 -0700 (PDT)
X-Google-Original-Date: Thu, 28 Oct 2021 08:05:03 PDT (-0700)
Subject:     Re: [PATCH 0/3] RISC-V: KVM: Few assorted changes
In-Reply-To: <62fe1c8e-abe0-5de9-5c00-3549faae1dba@redhat.com>
CC:     Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, Atish Patra <Atish.Patra@wdc.com>,
        anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     pbonzini@redhat.com
Message-ID: <mhng-e9d8caea-eae9-45dc-8072-cde5e275833f@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Oct 2021 07:07:33 PDT (-0700), pbonzini@redhat.com wrote:
> On 26/10/21 19:01, Anup Patel wrote:
>> I had a few assorted KVM RISC-V changes which I wanted to sent after
>> KVM RISC-V was merged hence this series.
>>
>> These patches can also be found in riscv_kvm_assorted_v1 branch at:
>> https://github.com/avpatel/linux.git
>>
>> Anup Patel (3):
>>    RISC-V: Enable KVM in RV64 and RV32 defconfigs as a module
>>    RISC-V: KVM: Factor-out FP virtualization into separate sources
>>    RISC-V: KVM: Fix GPA passed to __kvm_riscv_hfence_gvma_xyz() functions
>>
>>   arch/riscv/configs/defconfig         |  15 ++-
>>   arch/riscv/configs/rv32_defconfig    |   8 +-
>>   arch/riscv/include/asm/kvm_host.h    |  10 +-
>>   arch/riscv/include/asm/kvm_vcpu_fp.h |  59 +++++++++
>>   arch/riscv/kvm/Makefile              |   1 +
>>   arch/riscv/kvm/tlb.S                 |   4 +-
>>   arch/riscv/kvm/vcpu.c                | 172 ---------------------------
>>   arch/riscv/kvm/vcpu_fp.c             | 167 ++++++++++++++++++++++++++
>>   8 files changed, 244 insertions(+), 192 deletions(-)
>>   create mode 100644 arch/riscv/include/asm/kvm_vcpu_fp.h
>>   create mode 100644 arch/riscv/kvm/vcpu_fp.c
>>
>
> Queued 2+3, thanks.

Thanks.  I'll pick up 1, as per the thread.
