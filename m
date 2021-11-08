Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93777449CFA
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 21:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbhKHUSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 15:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238806AbhKHUS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 15:18:29 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37D9C061714
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 12:15:44 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id i11so9045850ilv.13
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 12:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lCTOidaZajv7DxRrGkK5E30Y+aKj9uf2F6iDIjFDoo0=;
        b=IPRxyCY6FnjvRfUORiItGiJ4keTVi1pv2WDaoiPx/gK+OBR1SAVKKVStpo6uhsg+t8
         zG+kmCC882BYG68WqLF0dCmVnvcxWo82KQuZDKGLb5cwx/FIyHkESmXAPJnuM4vkd6k1
         Mqvnwc5LaIDtNj8kAV/qzoRmHGkhnOaCDWDksvUFeSQBVa+7chFeZlB06S+9b1V1r+gx
         iQAziNWdh1b6vLaCJtQSn3GDDZBMlFPMZdKHUe2JG9VUg2FAzLX/IDXr5/0SoEfH64LP
         K8rWi7XkgrRx7XhTq5T0L1C3gMfP6HuqWXuKPFIbWaxidaUXwCclfWk9nnEKeXJ9SDxd
         DHZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lCTOidaZajv7DxRrGkK5E30Y+aKj9uf2F6iDIjFDoo0=;
        b=z5lF6iPgb4b1fwIKb9A5xjwhygd5hgf3BS8gg9obdi29pKlILSAC7STxhF/kZn7PkC
         TP45ENmMA3ipoo1+7P09xkufDomZwVhHAngsp4FA5jVSxNsLSS0ZXoOzjoZ+w4B9Ln9Z
         GuiTetRT1iZL/yLZQddK+o96BrokxKvXxAaXaDuFM000jdDs6S1LO/jjw6a8vAsxoWB5
         1wS4z6vuKKsp/b4ru8UA9+n8nFfsQwAIsYZ7r4/k/JrrPwkwpKaO7ax9RPGEBh04xtDD
         LOSybEdK/I0MKb1UW21686vnWTsyTAj125PYssoYF3xcizxvEskod4o44GVxDqCWSazo
         HNrQ==
X-Gm-Message-State: AOAM531ZRGvQNBI6M6Wju9sijczBWbghl2Q1KaYea5yFknd0rHVO9t1t
        EMiKeko/LNGFYvlP5PHAs15CY9tM7xxBy2A56/xAgg==
X-Google-Smtp-Source: ABdhPJxm5ew/EklYukdHTfmEkmMrj87CAR5uYqp8lbP8/DfE75V4ejatD3BTFf5i4NgLR9gqVLt7Jl9xXi1ZHopbDso=
X-Received: by 2002:a05:6e02:604:: with SMTP id t4mr1240795ils.129.1636402543150;
 Mon, 08 Nov 2021 12:15:43 -0800 (PST)
MIME-Version: 1.0
References: <20210913135745.13944-1-jgross@suse.com> <20210913135745.13944-2-jgross@suse.com>
 <CANgfPd-DjawJpZDAFzwS54yukPSsUAU+rWsais2_FCeLCZuY0A@mail.gmail.com>
In-Reply-To: <CANgfPd-DjawJpZDAFzwS54yukPSsUAU+rWsais2_FCeLCZuY0A@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 8 Nov 2021 12:15:32 -0800
Message-ID: <CANgfPd-njeSYSiytAYEXLG8wwTmLBA6viV7YAHj5uVeukPde=g@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86/kvm: revert commit 76b4f357d0e7d8f6f00
To:     Juergen Gross <jgross@suse.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 8, 2021 at 12:14 PM Ben Gardon <bgardon@google.com> wrote:
>
> On Mon, Sep 13, 2021 at 7:51 AM Juergen Gross <jgross@suse.com> wrote:
> >
> > Commit 76b4f357d0e7d8f6f00 ("x86/kvm: fix vcpu-id indexed array sizes")
> > has wrong reasoning, as KVM_MAX_VCPU_ID is not defining the maximum
> > allowed vcpu-id as its name suggests, but the number of vcpu-ids.
> >
> > So revert this patch again.
> >
> > Suggested-by: Eduardo Habkost <ehabkost@redhat.com>
> > Signed-off-by: Juergen Gross <jgross@suse.com>
>
> The original commit 76b4f357d0e7d8f6f00 CC'ed Stable but this revert
> does not. Looking at the stable branches, I see the original has been
> reverted but this hasn't. Should this be added to Stable as well?

*the original has been incorporated into the stable branches but this hasn't.

>
> > ---
> >  arch/x86/kvm/ioapic.c | 2 +-
> >  arch/x86/kvm/ioapic.h | 4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> > index ff005fe738a4..698969e18fe3 100644
> > --- a/arch/x86/kvm/ioapic.c
> > +++ b/arch/x86/kvm/ioapic.c
> > @@ -96,7 +96,7 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
> >  static void rtc_irq_eoi_tracking_reset(struct kvm_ioapic *ioapic)
> >  {
> >         ioapic->rtc_status.pending_eoi = 0;
> > -       bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID + 1);
> > +       bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID);
> >  }
> >
> >  static void kvm_rtc_eoi_tracking_restore_all(struct kvm_ioapic *ioapic);
> > diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
> > index bbd4a5d18b5d..27e61ff3ac3e 100644
> > --- a/arch/x86/kvm/ioapic.h
> > +++ b/arch/x86/kvm/ioapic.h
> > @@ -39,13 +39,13 @@ struct kvm_vcpu;
> >
> >  struct dest_map {
> >         /* vcpu bitmap where IRQ has been sent */
> > -       DECLARE_BITMAP(map, KVM_MAX_VCPU_ID + 1);
> > +       DECLARE_BITMAP(map, KVM_MAX_VCPU_ID);
> >
> >         /*
> >          * Vector sent to a given vcpu, only valid when
> >          * the vcpu's bit in map is set
> >          */
> > -       u8 vectors[KVM_MAX_VCPU_ID + 1];
> > +       u8 vectors[KVM_MAX_VCPU_ID];
> >  };
> >
> >
> > --
> > 2.26.2
> >
