Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D61356501A
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 10:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbiGDIzn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 04:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbiGDIzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 04:55:42 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77D2BC8F
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 01:55:40 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id j7so4975087wmp.2
        for <kvm@vger.kernel.org>; Mon, 04 Jul 2022 01:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+WUk2xbSNyQngKIivfsXkipatMQggMur8+BOotuvHrc=;
        b=I7qyhjG6jBNxmRdhxRv7bSrBYl/an7f47BUlAO4CoMaUp35DhiQc1WklO1A3X9KgFr
         KgixjZCXScgpgzaAZTKNKUF1cafhKonSncRrH3Tlh86o8wAUhb0Ato6yf83K3VAmXjx+
         yDuP7wLig/HBvvmwVl7lwSnaZZ6Wrcrwjz7DkS+076rrBPoIQCnPMdIQuwOboOlBhNH0
         1Oj/xADDiskvpdMddxyqwDvL6LukZXR+ni+WBWM2EplzeT9W/UPrnBESCmTQzth0w36l
         k/xRbN5Zbjmbb5Wk8PRLllsFeB2cTX65LYp8NuNXbg+yZZhPTjwipD6neU34NEAx8/xO
         mKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+WUk2xbSNyQngKIivfsXkipatMQggMur8+BOotuvHrc=;
        b=UXUFXcathG94PBDMqPApWUXrdCtAi8DqEf8cGLYd62IgbECqt97X2/EXsYF8cUu91+
         jjONNpDjItgibxBWKlTm3N6IBrYCZSMszcDSYohhb7fVGQsdJzX6zP+PVhS4Mm9Qz4S9
         n6E5+60a13I3XvNKDUacuEacdMMvuZj4DDfugSuvEGZvVPisTJV2FmOJPR8qv3IzFdXa
         GuwS1CC7iz7r2sBEH0moU7pJ1WFxCX2BsIhD6J4cpOJoSUZaYlxGVZX/3nEJJ614jPs6
         LuMipi20OFnhAFozBYcYdqSMA/Qn9KwXlR6qTV/6TqCPPkth4tU4OP7+LA8f0XDHhG17
         SH/Q==
X-Gm-Message-State: AJIora+CGl+eGaLMQe/BU8lGQDFQeRDXC4oZapdR9fXWv31jd77UIGi/
        5UpL93W9CnLG9JyBCnKra92gVoR0AJs9vwcfWBIZFGVczcI8fvBo
X-Google-Smtp-Source: AGRyM1tAlyg1H8gH5YntBMpGkdfmwiBuamQeAqvrlLD4YmVGtiukeSDtVS5Eyf0W7mkd8HIXVdbklSWVanqziQ2dtJc=
X-Received: by 2002:a05:600c:a192:b0:3a0:433a:9ca with SMTP id
 id18-20020a05600ca19200b003a0433a09camr31615081wmb.108.1656924939080; Mon, 04
 Jul 2022 01:55:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220701062838.6727-1-jiaming@nfschina.com>
In-Reply-To: <20220701062838.6727-1-jiaming@nfschina.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Mon, 4 Jul 2022 14:25:26 +0530
Message-ID: <CAAhSdy1_TVdvGEWQ=kTzp5_S_ACCuHxjYk3goe39V8YiwqUY_w@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Fix variable spelling mistake
To:     Zhang Jiaming <jiaming@nfschina.com>
Cc:     Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        liqiong@nfschina.com, renyu@nfschina.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 1, 2022 at 11:58 AM Zhang Jiaming <jiaming@nfschina.com> wrote:
>
> There is a spelling mistake in mmu.c and vcpu_exit.c. Fix it.
>
> Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>

Looks good to me.

I have queued this for 5.20

Thanks,
Anup

> ---
>  arch/riscv/kvm/mmu.c       | 8 ++++----
>  arch/riscv/kvm/vcpu_exit.c | 6 +++---
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index 1c00695ebee7..2965284a490d 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -611,7 +611,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>  {
>         int ret;
>         kvm_pfn_t hfn;
> -       bool writeable;
> +       bool writable;
>         short vma_pageshift;
>         gfn_t gfn = gpa >> PAGE_SHIFT;
>         struct vm_area_struct *vma;
> @@ -659,7 +659,7 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>
>         mmu_seq = kvm->mmu_notifier_seq;
>
> -       hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writeable);
> +       hfn = gfn_to_pfn_prot(kvm, gfn, is_write, &writable);
>         if (hfn == KVM_PFN_ERR_HWPOISON) {
>                 send_sig_mceerr(BUS_MCEERR_AR, (void __user *)hva,
>                                 vma_pageshift, current);
> @@ -673,14 +673,14 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
>          * for write faults.
>          */
>         if (logging && !is_write)
> -               writeable = false;
> +               writable = false;
>
>         spin_lock(&kvm->mmu_lock);
>
>         if (mmu_notifier_retry(kvm, mmu_seq))
>                 goto out_unlock;
>
> -       if (writeable) {
> +       if (writable) {
>                 kvm_set_pfn_dirty(hfn);
>                 mark_page_dirty(kvm, gfn);
>                 ret = gstage_map_page(kvm, pcache, gpa, hfn << PAGE_SHIFT,
> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> index dbb09afd7546..f4e569688619 100644
> --- a/arch/riscv/kvm/vcpu_exit.c
> +++ b/arch/riscv/kvm/vcpu_exit.c
> @@ -417,17 +417,17 @@ static int gstage_page_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
>  {
>         struct kvm_memory_slot *memslot;
>         unsigned long hva, fault_addr;
> -       bool writeable;
> +       bool writable;
>         gfn_t gfn;
>         int ret;
>
>         fault_addr = (trap->htval << 2) | (trap->stval & 0x3);
>         gfn = fault_addr >> PAGE_SHIFT;
>         memslot = gfn_to_memslot(vcpu->kvm, gfn);
> -       hva = gfn_to_hva_memslot_prot(memslot, gfn, &writeable);
> +       hva = gfn_to_hva_memslot_prot(memslot, gfn, &writable);
>
>         if (kvm_is_error_hva(hva) ||
> -           (trap->scause == EXC_STORE_GUEST_PAGE_FAULT && !writeable)) {
> +           (trap->scause == EXC_STORE_GUEST_PAGE_FAULT && !writable)) {
>                 switch (trap->scause) {
>                 case EXC_LOAD_GUEST_PAGE_FAULT:
>                         return emulate_load(vcpu, run, fault_addr,
> --
> 2.25.1
>
