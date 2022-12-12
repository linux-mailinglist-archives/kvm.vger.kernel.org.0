Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363E664A804
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 20:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbiLLTRH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 14:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbiLLTQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 14:16:47 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB89EE06
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 11:16:33 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id jr11so9233992qtb.7
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 11:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7FMUUUtCYecfXpbEXjiOLj576wn1MKIcly3I5EGbnCU=;
        b=l/2Fzg7K2w6LeoqTVQRvr6MNT6h2CWF7uWpi6AcpSeXPJLWs93b53h4/DaxEs3S7yg
         FmBJ/eQjHKTHyIyyljJe+i4llG7szE8ICe++PVGg48c7nvViW1blvdm1AR6l1CmHD6AX
         kFg6hl4Vs3u7X1Twn6fsy9hoN7ccZU342euVFVUW7uX/cmNpk616/caD/CinGqNjNJTs
         QTXe7MFJ/La+/mPWZPg9ETEbrRrOv6B0InpYW9oHi8Mnc2qFUGeBchwY4K2AfUssSRcy
         qozMFX4bvtu0bwAtdxAWkGgcgPw5BFdhXNT0jyS/Adf7ohyw+Ajj3xoMSPGHpP0wiv8S
         7Qfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7FMUUUtCYecfXpbEXjiOLj576wn1MKIcly3I5EGbnCU=;
        b=FwfzkaLRjgB2+Uylt+pF8wkfW1d0Gd09FEU4dQT9LVR+IJuM9LK0y2Dmkf6BQbAaOM
         HKodb4lKOu7p1TyTYgYpCu09GfqsGnfjj4kbnAOvdMyEOAlSLQ+2UOek5jeEX6JU4D3b
         8t1RylJNsi2jCDfi6NbkzfgTDmTWyM0fUmJmT5L5IQlY5OBQPe0NOai1kJWk6fyA2IYN
         yEl3O8me/PHAKzCm7PUlzalqwX06Hr5KBUU3MBcv7dt4LgxCba01pYtBKNCJ3J/6ovdZ
         So1UyYNT2/BqrLO3Np0NK4SnYd0QrNRrgIie9emZjJI6n35Jr47leUhTQ7er0epyz2Oo
         h8JA==
X-Gm-Message-State: ANoB5pma1oNxDVSBCq9e96ZSSn6ajvPaErxqG53yEXnGZxw5dELsTjl2
        pVbmGw2X1BbxgytljgrDzGQHPT8jckNoRdYlspJv4Q==
X-Google-Smtp-Source: AA0mqf4WGpfWfLWnwQ8p9857/jw1O9njOLrhyCmKuR5bGk3QqXvLgKt7CBUEWjv6tK1F7/dZkHnouU9Un9Kr3J8bgV4=
X-Received: by 2002:ac8:4415:0:b0:3a6:a81b:c971 with SMTP id
 j21-20020ac84415000000b003a6a81bc971mr18259926qtn.437.1670872592731; Mon, 12
 Dec 2022 11:16:32 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com> <20221208193857.4090582-18-dmatlack@google.com>
In-Reply-To: <20221208193857.4090582-18-dmatlack@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 12 Dec 2022 11:16:21 -0800
Message-ID: <CANgfPd_JKw+Vtzk30GE1R3_zphOD19w4XYZ6uXQsU0AmZrXo9Q@mail.gmail.com>
Subject: Re: [RFC PATCH 17/37] KVM: Move struct kvm_gfn_range to kvm_types.h
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Nadav Amit <namit@vmware.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>, xu xin <cgel.zte@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Yu Zhao <yuzhao@google.com>,
        Colin Cross <ccross@google.com>,
        Hugh Dickins <hughd@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 8, 2022 at 11:39 AM David Matlack <dmatlack@google.com> wrote:
>
> Move struct kvm_gfn_range to kvm_types.h so that it's definition can be
> accessed in a future commit by arch/x86/include/asm/kvm/tdp_pgtable.h
> without needing to include the mega-header kvm_host.h.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Ben Gardon <bgardon@google.com>

> ---
>  include/linux/kvm_host.h  | 7 -------
>  include/linux/kvm_types.h | 8 ++++++++
>  2 files changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 22ecb7ce4d31..469ff4202a0d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -256,13 +256,6 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
>  #endif
>
>  #ifdef KVM_ARCH_WANT_MMU_NOTIFIER

I don't have any problem with always having this defined, but might be
worth noting that it's now defined on all archs, regardless of
KVM_ARCH_WANT_MMU_NOTIFIER.

> -struct kvm_gfn_range {
> -       struct kvm_memory_slot *slot;
> -       gfn_t start;
> -       gfn_t end;
> -       pte_t pte;
> -       bool may_block;
> -};
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
>  bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 59cf958d69df..001aad9ea987 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -132,4 +132,12 @@ struct kvm_vcpu_stat_generic {
>
>  #define KVM_STATS_NAME_SIZE    48
>
> +struct kvm_gfn_range {
> +       struct kvm_memory_slot *slot;
> +       gfn_t start;
> +       gfn_t end;
> +       pte_t pte;
> +       bool may_block;
> +};
> +
>  #endif /* __KVM_TYPES_H__ */
> --
> 2.39.0.rc1.256.g54fd8350bd-goog
>
