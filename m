Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4314356AA
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 02:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhJUAJb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 20:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhJUAJ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 20:09:28 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980F1C06161C
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 17:07:13 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id v2-20020a05683018c200b0054e3acddd91so8149146ote.8
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 17:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/GQ115CFAa8AK9LaaP5H4I0R+3z7qFiHdrwfmjyTNac=;
        b=XDGv5+U/eYYVSMCHXEw6qf14yMd5D5l5Fl7EBedjbmijCfzA/uFoqfS/K2VVtjHprL
         tPZz2kU28TPIvFkMdNWwLKCBbXJl8v1ijnC+6bCCgnXRMqbT8TG5KLFVF/VLdrq2hqhR
         CwLO7KWLuxlSaXoHoKkBqwcN+B5cvDFNnQr4H1lp5usyGN/AGxQTq6F2ux3byGtknnBv
         dtk1uHaoNFdpB8+JOoBASyuiYPo0RaOzUYddQVSsPW9W5QBEznzQb3JlqcicNnNx3ITD
         hdZkHnKRU9rTwtydiGfj0YtCoeBqpnnj3wufn4cYA6gh8wkuC213oNa+OnNGj119p0FG
         OYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/GQ115CFAa8AK9LaaP5H4I0R+3z7qFiHdrwfmjyTNac=;
        b=GVy+im5WREqVr62SmYGs/36dGWvKHwmnzYnSYRbmxwnE0kikztuKXSJMRC9ksfAxhH
         2s7lxUoA+72EBGX1R83Dz0R8gRGU2zyJgvmjhOxvJjWFcSDScF/z+Xzur3/GYI2nL1IM
         XCl/rPubkqlxLLZa4AvjD2Bp+FOLY38txdLALujLyGok7CdAZojweeoQhskW5jsXkmyR
         uLJICZNziklvz2zRw9qOAA1J9J52MmuEX4WfwdONhmnxiikh5yd7MHQurYdIC1cj7L+d
         AKkd53NSG8rbzEP/Ah89Pvp4WBoGVk2LcSbjDYN7tqViXpXtQcvNoH3IPxVXVm5uxg76
         MeJA==
X-Gm-Message-State: AOAM5304spbUx8y44dBjH2mlG48fr3bVi5a3isBIfkmcfLesShKmq1xF
        IToY/ZG1sTKfyadu8OKVh5NtiHzUZPQ9vZEsmHOVKg==
X-Google-Smtp-Source: ABdhPJzreVyHPsv1SyTIMkS+x2UZ7EjnFw0hfNoRnYuCZ6AhaRDfO0yYS6k2qIxyirv/iDuHWO7OzlXauKVP3F4XFig=
X-Received: by 2002:a05:6830:2492:: with SMTP id u18mr1959290ots.29.1634774832716;
 Wed, 20 Oct 2021 17:07:12 -0700 (PDT)
MIME-Version: 1.0
References: <20211020192732.960782-1-pbonzini@redhat.com> <20211020192732.960782-2-pbonzini@redhat.com>
In-Reply-To: <20211020192732.960782-2-pbonzini@redhat.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 20 Oct 2021 17:07:01 -0700
Message-ID: <CAA03e5HDO=Hj5xmv6=YX1tjNTm7yw2qSLjVN0PhtANY-iA=yng@mail.gmail.com>
Subject: Re: [PATCH v2 kvm-unit-tests 1/2] unify field names and definitions
 for GDT descriptors
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <jroedel@suse.de>,
        Varad Gautam <varad.gautam@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021 at 12:27 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Use the same names and definitions (apart from the high base field)
> for GDT descriptors in both 32-bit and 64-bit code.  The next patch
> will also reuse gdt_entry_t in the 16-byte struct definition, for now
> some duplication remains.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  lib/x86/desc.c   | 16 ++++++----------
>  lib/x86/desc.h   | 28 +++++++++++++++++++++-------
>  x86/taskswitch.c |  2 +-
>  3 files changed, 28 insertions(+), 18 deletions(-)
>
> diff --git a/lib/x86/desc.c b/lib/x86/desc.c
> index e7378c1..3d38565 100644
> --- a/lib/x86/desc.c
> +++ b/lib/x86/desc.c
> @@ -285,17 +285,13 @@ void set_gdt_entry(int sel, u32 base,  u32 limit, u8 access, u8 gran)
>         int num = sel >> 3;
>
>         /* Setup the descriptor base address */
> -       gdt32[num].base_low = (base & 0xFFFF);
> -       gdt32[num].base_middle = (base >> 16) & 0xFF;
> -       gdt32[num].base_high = (base >> 24) & 0xFF;
> +       gdt32[num].base1 = (base & 0xFFFF);
> +       gdt32[num].base2 = (base >> 16) & 0xFF;
> +       gdt32[num].base3 = (base >> 24) & 0xFF;
>
> -       /* Setup the descriptor limits */
> -       gdt32[num].limit_low = (limit & 0xFFFF);
> -       gdt32[num].granularity = ((limit >> 16) & 0x0F);
> -
> -       /* Finally, set up the granularity and access flags */
> -       gdt32[num].granularity |= (gran & 0xF0);
> -       gdt32[num].access = access;
> +       /* Setup the descriptor limits, granularity and flags */
> +       gdt32[num].limit1 = (limit & 0xFFFF);
> +       gdt32[num].type_limit_flags = ((limit & 0xF0000) >> 8) | ((gran & 0xF0) << 8) | access;
>  }
>
>  void set_gdt_task_gate(u16 sel, u16 tss_sel)
> diff --git a/lib/x86/desc.h b/lib/x86/desc.h
> index a6ffb38..0af37e3 100644
> --- a/lib/x86/desc.h
> +++ b/lib/x86/desc.h
> @@ -164,14 +164,27 @@ typedef struct {
>  } idt_entry_t;
>
>  typedef struct {
> -       u16 limit_low;
> -       u16 base_low;
> -       u8 base_middle;
> -       u8 access;
> -       u8 granularity;
> -       u8 base_high;
> -} gdt_entry_t;
> +       uint16_t limit1;
> +       uint16_t base1;
> +       uint8_t  base2;
> +       union {
> +               uint16_t  type_limit_flags;      /* Type and limit flags */
> +               struct {
> +                       uint16_t type:4;
> +                       uint16_t s:1;
> +                       uint16_t dpl:2;
> +                       uint16_t p:1;
> +                       uint16_t limit:4;
> +                       uint16_t avl:1;
> +                       uint16_t l:1;
> +                       uint16_t db:1;
> +                       uint16_t g:1;
> +               } __attribute__((__packed__));
> +       } __attribute__((__packed__));
> +       uint8_t  base3;
> +} __attribute__((__packed__)) gdt_entry_t;
>
> +#ifdef __x86_64__
>  struct segment_desc64 {
>         uint16_t limit1;
>         uint16_t base1;

I had been thinking of suggesting to use `gdt_entry_t` inline, within
the `segment_desc64` struct to avoid all of this redundancy. But I see
that's done in the next patch (which I haven't reviewed yet).

> @@ -194,6 +207,7 @@ struct segment_desc64 {
>         uint32_t base4;
>         uint32_t zero;
>  } __attribute__((__packed__));
> +#endif
>
>  #define DESC_BUSY ((uint64_t) 1 << 41)
>
> diff --git a/x86/taskswitch.c b/x86/taskswitch.c
> index 889831e..b6b3451 100644
> --- a/x86/taskswitch.c
> +++ b/x86/taskswitch.c
> @@ -21,7 +21,7 @@ fault_handler(unsigned long error_code)
>
>         tss.eip += 2;
>
> -       gdt32[TSS_MAIN / 8].access &= ~2;
> +       gdt32[TSS_MAIN / 8].type &= ~2;
>
>         set_gdt_task_gate(TSS_RETURN, tss_intr.prev);
>  }
> --
> 2.27.0
>
>

Reviewed-by: Marc Orr <marcorr@google.com>
