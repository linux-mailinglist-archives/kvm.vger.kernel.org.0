Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 845CD6F8DC
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 07:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfGVF2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 01:28:17 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46980 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfGVF2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 01:28:16 -0400
Received: by mail-ot1-f66.google.com with SMTP id z23so10574770ote.13;
        Sun, 21 Jul 2019 22:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h+i9jewAdtfLLPC8niA+t9B34gWGVVKpI03gRjn4UC4=;
        b=YP5cgo1NXLokkSmA5Uny5czJ4oMGoZzdhA5iLLo2LGpPM9lK51oPdM0XpbE6kFY4IG
         dKTTBfv4Q/vMXZDkJCsMKl/wYz8EhY1oq/hd9WAKSgsgtlvN/cNYMEvUH4VJpMcFNkIl
         XSMW51LZlAS1UccY1dyCXYunK+TuB5aMzjvBfdoefq0Lbu0SFMndRVNvQeBjBmgDvFY6
         wIcdh7UaTLjAYdoXGkW7QIClzl38FXzcVyKAk8VALPaD+ByDIHS41Ud7z8KSwOpo3VC9
         CYJfN/P91Q6zan0O7G4hV2VolOuX7bQefZi9trxu8zBDoALAwC1twBtFXR5KqhYYtlgS
         LOQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h+i9jewAdtfLLPC8niA+t9B34gWGVVKpI03gRjn4UC4=;
        b=hapCmWCtfHZq1ZndKEecYyiFUrz9zgOW1X3SqdJeOqDVYxCGPV3blaYQFbkJRjNpEm
         k5Tv9VhrVssa+EjgG8S6iq7qFGbRZHIhSiUcCdM/v/HAK5Xzj6C5RKvSViHgzfqdfW48
         /oQPmr+/AwopxfvMe6Fd60hh+smHQ5HDbHsvOoh04PXjPPgLuZ2vuglv/yvD8mne41Sr
         VBKu/E+AvXj5PN9WSx6wCMfv/QSVzfwkvfMDLuoaHPJOjWXKo33dkdJiHjKytFC/yFbJ
         cVAsqI7BNXzItelJnbfjpWRr8OBzheBTnRfGa51nYOS+Xp/5Y4bJ5Ote6o1mc++VbQ6h
         SrmA==
X-Gm-Message-State: APjAAAWWrPJh+p0Mb0DiPfVpx1mijariloRiLVakQAZsZNI+NY8RMxEo
        dlYS+/mQnsyzG28oNochxN3bEZQfIkHFafgniQfhGqcQ
X-Google-Smtp-Source: APXvYqz2TdTBO+yorxieSvfbToEVUV2J9chaylFyyRANU8W4nVYKtGry30Vq/MI+Jkkr4dNHSPuVU0C7JDwuIx6htOg=
X-Received: by 2002:a9d:4590:: with SMTP id x16mr373173ote.254.1563773295708;
 Sun, 21 Jul 2019 22:28:15 -0700 (PDT)
MIME-Version: 1.0
References: <1562917140-12035-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1562917140-12035-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 22 Jul 2019 13:28:07 +0800
Message-ID: <CANRm+CwfjQfjS4SvUGnCLG-JNVyBLM=NB+Eu5u-=z1KiATjFKw@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/2] KVM: LAPIC: Add pv ipi tracepoint
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping,
On Fri, 12 Jul 2019 at 15:39, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> Add pv ipi tracepoint.
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c |  2 ++
>  arch/x86/kvm/trace.h | 25 +++++++++++++++++++++++++
>  2 files changed, 27 insertions(+)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 42da7eb..403ae3f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -562,6 +562,8 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ip=
i_bitmap_low,
>         irq.level =3D (icr & APIC_INT_ASSERT) !=3D 0;
>         irq.trig_mode =3D icr & APIC_INT_LEVELTRIG;
>
> +       trace_kvm_pv_send_ipi(irq.vector, min, ipi_bitmap_low, ipi_bitmap=
_high);
> +
>         if (icr & APIC_DEST_MASK)
>                 return -KVM_EINVAL;
>         if (icr & APIC_SHORT_MASK)
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index b5c831e..ce6ee34 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -1462,6 +1462,31 @@ TRACE_EVENT(kvm_hv_send_ipi_ex,
>                   __entry->vector, __entry->format,
>                   __entry->valid_bank_mask)
>  );
> +
> +/*
> + * Tracepoints for kvm_pv_send_ipi.
> + */
> +TRACE_EVENT(kvm_pv_send_ipi,
> +       TP_PROTO(u32 vector, u32 min, unsigned long ipi_bitmap_low, unsig=
ned long ipi_bitmap_high),
> +       TP_ARGS(vector, min, ipi_bitmap_low, ipi_bitmap_high),
> +
> +       TP_STRUCT__entry(
> +               __field(u32, vector)
> +               __field(u32, min)
> +               __field(unsigned long, ipi_bitmap_low)
> +               __field(unsigned long, ipi_bitmap_high)
> +       ),
> +
> +       TP_fast_assign(
> +               __entry->vector =3D vector;
> +               __entry->min =3D min;
> +               __entry->ipi_bitmap_low =3D ipi_bitmap_low;
> +               __entry->ipi_bitmap_high =3D ipi_bitmap_high;
> +       ),
> +
> +       TP_printk("vector %d min 0x%x ipi_bitmap_low 0x%lx ipi_bitmap_hig=
h 0x%lx",
> +                 __entry->vector, __entry->min, __entry->ipi_bitmap_low,=
 __entry->ipi_bitmap_high)
> +);
>  #endif /* _TRACE_KVM_H */
>
>  #undef TRACE_INCLUDE_PATH
> --
> 2.7.4
>
