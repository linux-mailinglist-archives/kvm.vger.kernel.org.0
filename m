Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FED4F2490
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 09:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbiDEHWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 03:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbiDEHVb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 03:21:31 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB416543
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 00:18:18 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id bi13-20020a05600c3d8d00b0038c2c33d8f3so948949wmb.4
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 00:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j5tZD+8M1iPFQIpWPsYamWZAVUcin+PVrYzA4YmgT9M=;
        b=fwxyiskvlIWhb4yoz+2d8DfK/fDF9kpIsj1v16e5zIvUjuTsRqhCJOFl05KNjnR1dw
         oonmm9pVay2hFWOiOFAbJ7dn7AHRarZUB51K/rDMrO52UGnRsj0lSzd2lgRxtb+OxIRl
         IgpXfxAnPI2wpb+5qJeC0MuWD3RZGoIQEZ+ogFkEYpSYTVQw4ABKMBca0ZXnLKFMvEQz
         QdhofkXfbLPxcHl4i2KJqdCwUeO5sC1D7G1h/tn68KmMvPa0ZOVhXIkAy7QphAYkTazb
         USrRPCFfrjAaMOaC2mAVwXLODZM++PjK43MI+M9Q3aTBfmuFw1YJzwLkykwbNCFn9o1+
         X6WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j5tZD+8M1iPFQIpWPsYamWZAVUcin+PVrYzA4YmgT9M=;
        b=gCQDGeXN+DiUp4MoBhKRixLPzhS4ls1BsYO2hrmIN4d9P0A7E6fIvgcd+FZk0EAysm
         Iqe/otwkxL6MM+iRyN1LIufiXQEI+pNSRb0KeERFhLq9uqTrWnAXupR24FIQSB9NBojU
         Pelp5pAlEXtl/kYx3BixKISUKhRnUVzOira+UaOTKpBVH4GgEbKlujJDvc5x/2OvyXKb
         YCvshkiQSn/qTKnajiRUPBQSKo7ltJ5IU0ozBThh0pbepMpHeKmW6gKZduswAYToOTcc
         vvJQnXNU6fv0YeiCXiqNuLkavCHrOroPSWYydmcGWHMnWg64A0UnRZShOOFkju35N84G
         /GCQ==
X-Gm-Message-State: AOAM531Oj1qcaHy5oDCF5+oL0XVTpEqhcFl9NurVoDnpnJVPNrIoWzr7
        grdG0SH3oIik7PYCSIwGHn1MT+S39PuxhF8WoOCnag==
X-Google-Smtp-Source: ABdhPJwdmM8TCHa4eoVn8sKC+Sod0b/E/a9HSoTDWMUxnS9+yZz84ZdrIE85cb44FScPTht6hP0nLp3dojxP605Lpt4=
X-Received: by 2002:a05:600c:3c9b:b0:38e:4c59:68b9 with SMTP id
 bg27-20020a05600c3c9b00b0038e4c5968b9mr1754749wmb.105.1649143096491; Tue, 05
 Apr 2022 00:18:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220329072911.1692766-1-apatel@ventanamicro.com> <20220329072911.1692766-2-apatel@ventanamicro.com>
In-Reply-To: <20220329072911.1692766-2-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Tue, 5 Apr 2022 12:48:03 +0530
Message-ID: <CAAhSdy2=q4u9UR7zYks5A-3k1q4srOqk14O3+a14sUS5Qa+Ppg@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: selftests: riscv: Set PTE A and D bits in
 VS-stage page table
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 29, 2022 at 12:59 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> Supporting hardware updates of PTE A and D bits is optional for any
> RISC-V implementation so current software strategy is to always set
> these bits in both G-stage (hypervisor) and VS-stage (guest kernel).
>
> If PTE A and D bits are not set by software (hypervisor or guest)
> then RISC-V implementations not supporting hardware updates of these
> bits will cause traps even for perfectly valid PTEs.
>
> Based on above explanation, the VS-stage page table created by various
> KVM selftest applications is not correct because PTE A and D bits are
> not set. This patch fixes VS-stage page table programming of PTE A and
> D bits for KVM selftests.
>
> Fixes: 3e06cdf10520 ("KVM: selftests: Add initial support for RISC-V
> 64-bit")
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>

I have queued this patch for RC fixes.

Thanks,
Anup

> ---
>  tools/testing/selftests/kvm/include/riscv/processor.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
> index dc284c6bdbc3..eca5c622efd2 100644
> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> @@ -101,7 +101,9 @@ static inline void set_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t id,
>  #define PGTBL_PTE_WRITE_SHIFT                  2
>  #define PGTBL_PTE_READ_MASK                    0x0000000000000002ULL
>  #define PGTBL_PTE_READ_SHIFT                   1
> -#define PGTBL_PTE_PERM_MASK                    (PGTBL_PTE_EXECUTE_MASK | \
> +#define PGTBL_PTE_PERM_MASK                    (PGTBL_PTE_ACCESSED_MASK | \
> +                                                PGTBL_PTE_DIRTY_MASK | \
> +                                                PGTBL_PTE_EXECUTE_MASK | \
>                                                  PGTBL_PTE_WRITE_MASK | \
>                                                  PGTBL_PTE_READ_MASK)
>  #define PGTBL_PTE_VALID_MASK                   0x0000000000000001ULL
> --
> 2.25.1
>
