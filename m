Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B70B4DB7C3
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 19:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352900AbiCPSJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 14:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346985AbiCPSJx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 14:09:53 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAC540912
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 11:08:35 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2e5757b57caso32865207b3.4
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 11:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3CDjfOL4XFTPKtqkiMbluAfDpGLLRX/OLiG6A0cIlYo=;
        b=hExUsyci03m5zCmQTtzwqNbi3CA3fC0gMNnhcGQdonXMlNIbl4bgAgKnIUpYUrjCc7
         xIbiBH+T4/jr8APBvlkTpLWt0hBd7IjhkDZQSOM3GL0AEHXWOw7xfr/iCAk10ANXl4mO
         sorBYvHdq3G+xzlYmVaoVyE3LCLUN2q0mn/3CCUl9eddB+QwsGD8mIgGhCRlpilm9Nj1
         8cNvAuKoTKvKldjxZgITbTtauRs5g+pLfgDLrwU7OqeeuptXG1/m04e3+yS24y7cQ3X4
         eHV1ISKFEac0LgYamNGi83NBHcYRi0oGLWrbmINJV2Xk5Di24z2B2tj95dldAyeAz/Jf
         +oLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3CDjfOL4XFTPKtqkiMbluAfDpGLLRX/OLiG6A0cIlYo=;
        b=faXzS5ZMCKDpSvT5EnMHGmdEU5aAoyma8u0aynHYoIz5H8ZsBRc2nVWnsdjDyDHXhm
         5MBOGENOuAd6jRa1cBMtbQ9Vhy8ADrqdbKblGVGTBlCmjdeWNdhYNnkdSmbz0w9NKFtO
         NZEZ3RHr7uWnM9BVpi2RGdAmvWlh0whXZxFZaaCP7DM5Vt0O66Eb6hZ5MBqusaWl4SGw
         Rcb/6/Scwn/zOiBSWYXrd8L3RBfWsA8GyKXktNfeJBYMjrOp62Fz8EhFQu+v5CBq5WRP
         TCCao4q5FQNMEahR9nR3a+4POI1jpfT7tbDZVXFdpADObAnlZik0d33/QDz4/CkU+9Cc
         2+Kg==
X-Gm-Message-State: AOAM532i0unnsom4RK3BWFesn0hzOaPU25vkQytBnit3VAVRVd0UiIGo
        C/XFBNL+L3I99ldOzvS28M4Vae4RUwBVVkbW9tF/Vg==
X-Google-Smtp-Source: ABdhPJyDTOAGXwtrebGZcXucTwsLsj1Q/imZHVIr0HVDQ+3kr7CTR5NCgMAPcperilieXGykzEPRF8KMiwEtvNQRIpE=
X-Received: by 2002:a81:53c2:0:b0:2dc:3600:7db3 with SMTP id
 h185-20020a8153c2000000b002dc36007db3mr1455805ywb.23.1647454114295; Wed, 16
 Mar 2022 11:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220311060207.2438667-1-ricarkol@google.com> <20220311060207.2438667-3-ricarkol@google.com>
In-Reply-To: <20220311060207.2438667-3-ricarkol@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 16 Mar 2022 12:08:23 -0600
Message-ID: <CANgfPd_iRBDX=mtBy80G0R9U-BfukLV0H3SyrBr+jvK1e8BRvA@mail.gmail.com>
Subject: Re: [PATCH 02/11] KVM: selftests: Add vm_mem_region_get_src_fd
 library function
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 12:02 AM Ricardo Koller <ricarkol@google.com> wrote:
>
> Add a library function to get the backing source FD of a memslot.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

This appears to be dead code as of this commit, would recommend
merging it into the commit in which it's actually used.

> ---
>  .../selftests/kvm/include/kvm_util_base.h     |  1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 23 +++++++++++++++++++
>  2 files changed, 24 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 4ed6aa049a91..d6acec0858c0 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -163,6 +163,7 @@ int _kvm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
>  void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
>  void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
>  void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
> +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot);
>  void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
>  vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
>  vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index d8cf851ab119..64ef245b73de 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -580,6 +580,29 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
>         return &region->region;
>  }
>
> +/*
> + * KVM Userspace Memory Get Backing Source FD
> + *
> + * Input Args:
> + *   vm - Virtual Machine
> + *   memslot - KVM memory slot ID
> + *
> + * Output Args: None
> + *
> + * Return:
> + *   Backing source file descriptor, -1 if the memslot is an anonymous region.
> + *
> + * Returns the backing source fd of a memslot, so tests can use it to punch
> + * holes, or to setup permissions.
> + */
> +int vm_mem_region_get_src_fd(struct kvm_vm *vm, uint32_t memslot)
> +{
> +       struct userspace_mem_region *region;
> +
> +       region = memslot2region(vm, memslot);
> +       return region->fd;
> +}
> +
>  /*
>   * VCPU Find
>   *
> --
> 2.35.1.723.g4982287a31-goog
>
