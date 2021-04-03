Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D7035321A
	for <lists+kvm@lfdr.de>; Sat,  3 Apr 2021 04:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhDCC2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 22:28:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235598AbhDCC2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 22:28:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BA85611CC;
        Sat,  3 Apr 2021 02:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617416898;
        bh=oq6vr8YY/B+/RkR42rRprhRdAtANYREmsKpfBvtZsoY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=k+WHDjQ5PPIk5N3l6509ffX/czFyMEYniHyQKHYjc+bJ1uW8niBsRqMK2wXK0IdIG
         hASmNADMF5CKxA/duRVuy3GfHAwbISra0/JjM6wNXSgxPKn5UTQy/htOSG+rXpy8w8
         0+LlJfAvtu4n4GdnAiE/bsS1aULSxDGf6uLyf6y4/L+rGneJNuVO14CtdMeSueJC4l
         F+LCEaH2Aw9VdCpe3lT/0UUgaz8y359orZ09CAsvpWtD4Cj+uXOxq3S+Qt7UJIW0dx
         PN4lfZzhmXl3v7u+8GYxZ8xgdHVLK2bfIClMzcKqS8F6ual7RhH37oHfIGkaUOWEoP
         nCHnUwQNcT6jw==
Received: by mail-il1-f170.google.com with SMTP id r17so6002690ilt.0;
        Fri, 02 Apr 2021 19:28:18 -0700 (PDT)
X-Gm-Message-State: AOAM532Z/4EhN9E8Pzw1qznqPPeCBa9FzDFcgS1/cHFVtiT2frYO/Jnc
        71/ZMepy6ckHXnLeG/b0ahL5pBHlq3yfkzgwu8A=
X-Google-Smtp-Source: ABdhPJzB5/qn76EMf7QaKOqzT9W6sX0AEeXFk7rKego8k0wlVuG/wLf2PPeH+vJwOn1QlWb0FUCizh9UxYWiCEFJCKM=
X-Received: by 2002:a05:6e02:1286:: with SMTP id y6mr12948678ilq.270.1617416897956;
 Fri, 02 Apr 2021 19:28:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210402155807.49976-1-pbonzini@redhat.com> <20210402155807.49976-2-pbonzini@redhat.com>
In-Reply-To: <20210402155807.49976-2-pbonzini@redhat.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Sat, 3 Apr 2021 10:28:06 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7Sr8V7A4DdXx158PJ1dT+9zSgUsFQa1LLuZnq+TFR0aw@mail.gmail.com>
Message-ID: <CAAhV-H7Sr8V7A4DdXx158PJ1dT+9zSgUsFQa1LLuZnq+TFR0aw@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: constify kvm_arch_flush_remote_tlbs_memslot
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        seanjc@google.com, "open list:MIPS" <linux-mips@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Huacai Chen <chenhuacai@kernel.org>

On Fri, Apr 2, 2021 at 11:58 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> memslots are stored in RCU and there should be no need to
> change them.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/arm64/kvm/arm.c     | 2 +-
>  arch/mips/kvm/mips.c     | 2 +-
>  arch/x86/kvm/mmu/mmu.c   | 2 +-
>  include/linux/kvm_host.h | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 7f06ba76698d..9141730b7963 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1268,7 +1268,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>  }
>
>  void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -                                       struct kvm_memory_slot *memslot)
> +                                       const struct kvm_memory_slot *memslot)
>  {
>         kvm_flush_remote_tlbs(kvm);
>  }
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 58a8812e2fa5..7db8234a4407 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -997,7 +997,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>  }
>
>  void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -                                       struct kvm_memory_slot *memslot)
> +                                       const struct kvm_memory_slot *memslot)
>  {
>         /* Let implementation handle TLB/GVA invalidation */
>         kvm_mips_callbacks->flush_shadow_memslot(kvm, memslot);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0d92a269c5fa..f75c677910c9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5616,7 +5616,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>  }
>
>  void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -                                       struct kvm_memory_slot *memslot)
> +                                       const struct kvm_memory_slot *memslot)
>  {
>         /*
>          * All current use cases for flushing the TLBs for a specific memslot
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e6d77353025c..34a974ffc882 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -894,7 +894,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot);
>
>  #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
>  void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -                                       struct kvm_memory_slot *memslot);
> +                                       const struct kvm_memory_slot *memslot);
>  #else /* !CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
>  int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log);
>  int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
> --
> 2.30.1
>
>
