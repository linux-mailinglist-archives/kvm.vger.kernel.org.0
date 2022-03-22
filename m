Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7134E4853
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 22:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbiCVVhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 17:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235712AbiCVVhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 17:37:23 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 625A528E1D
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 14:35:54 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id h7so14537337lfl.2
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 14:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sViZwtjH37C2XjD/KE9d074ZFGD0e8UmC54d60/mnYU=;
        b=ebY6Y8EZFsj2YWkZmzXxWKTa838I7KidQLIn4kAYg9sttbpf/NkPi3l2U1jJYTLAlB
         o3VVXMXG4KYYAZi67D6xT1lRKw/dRKgKj7EyVhkBRSgVP90yv2a8viotUNqczCnN0zhm
         hQlzeIjr5Hk8szwaGLH5ipnDoziJkZS/arKaatD1nrUwVQJCGLvVIAQi2vFLuKthMXC0
         x8VwcqbnAgE3oPNYkDWpb81BeTSuzLiBJcBS9l8ZNelR296YLxRYBUnrfzbaRwZ1U0MR
         BhGR57yCQQxMat/5AOOwVTtCLN9XAX0GqI2xqiQTmbWkEZtOc8/lNJWG4929NrQ1B4Gn
         tTTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sViZwtjH37C2XjD/KE9d074ZFGD0e8UmC54d60/mnYU=;
        b=dno4GYKfdY1lz0BPEura91/EpTA/6S7TNvFO87EKv5oPnVj5dVqy9onhzJC2+AVt7Z
         m7ZvoIeZQo4bV/po3rBG5HjxHUyF6AJOVlkF/mRXa9nrYoRqe0nnTW2yruaTQvdGPOa1
         kQ+2CM7cnuwBK34o2jtS3A1TbVY+E7Lcc7MRHssCzkNnQRgZBkY75IjRcvz36hrXomNU
         3MmESGCTIa2BofJkk7j5FsQPxomH3MBggsUF9uYMdlbSgPjt6tPZQA7iZtgzIFkgTuOA
         Nb1PzdXJDDfEggy5puiqohjHcfuJXHvzGrR6Krtd5y26R+dTg096n9OOX8A+ks8TM3qG
         AgpA==
X-Gm-Message-State: AOAM533bpBNtc5f53302n9sKsXmo1wFte8rQLzufF94XZxamU3M7bUaf
        7GUSxoE16Uqb/fYh33aMNPrU5s2vOhzJq9EhU+yO2g==
X-Google-Smtp-Source: ABdhPJwc0JSNlPahbAdqv7iJH7vq7Pz7uIXFYdwFmk0odM80FGtfrbr+pmJyyGlCdcWSaGWKIPpevvVfQwGTW0XRuvY=
X-Received: by 2002:a19:f206:0:b0:448:5b9d:811c with SMTP id
 q6-20020a19f206000000b004485b9d811cmr19184431lfh.102.1647984952540; Tue, 22
 Mar 2022 14:35:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com> <20220311002528.2230172-6-dmatlack@google.com>
 <YjBTtz6wo/zQEHCv@xz-m1.local>
In-Reply-To: <YjBTtz6wo/zQEHCv@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 22 Mar 2022 14:35:25 -0700
Message-ID: <CALzav=c0ccztDULiVMwR4K20iYc0WH53ApeOCorhjKwaMNL5Sg@mail.gmail.com>
Subject: Re: [PATCH v2 05/26] KVM: x86/mmu: Rename shadow MMU functions that
 deal with shadow pages
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 1:52 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Fri, Mar 11, 2022 at 12:25:07AM +0000, David Matlack wrote:
> > Rename 3 functions:
> >
> >   kvm_mmu_get_page()   -> kvm_mmu_get_shadow_page()
> >   kvm_mmu_alloc_page() -> kvm_mmu_alloc_shadow_page()
> >   kvm_mmu_free_page()  -> kvm_mmu_free_shadow_page()
> >
> > This change makes it clear that these functions deal with shadow pages
> > rather than struct pages. Prefer "shadow_page" over the shorter "sp"
> > since these are core routines.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Acked-by: Peter Xu <peterx@redhat.com>

What's the reason to use Acked-by for this patch but Reviewed-by for others?


>
> --
> Peter Xu
>
