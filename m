Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4539449CF1
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 21:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238533AbhKHURa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 15:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbhKHUR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 15:17:26 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B05C061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 12:14:42 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id e144so20411044iof.3
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 12:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zWWZbv1VXbeiAIfJ9egbHayb1S7Nhsd/riY822fMbFM=;
        b=Afw7Z+AbCOWHXWeJR2umxo7zaJcZYAZ9IUzuhdm1uwyKjOAowlsfexwtQZijnlDMpJ
         Hbaokol5Z4xYyi47EBgEF7Ydbm+G/pF7x2qpHfhyJxszqyg3ywP0yt0AByDsMqOk02vW
         WydLb8+7qmXTQgEeQv/ysvc0IhMH2YadWe0ucUFt1WJu2F6P4BqE5f5yriQ2uPCiMH5U
         N8gAl2g8HpmHLM0uiOaBp/82MfSe8etmsceBUNTiEHZRS1NR/Bc9hMDOqyWbRS64pHBi
         9jy7ouEcuv47UxFbv4EJwiZ0LY3RKS2/Ges5jdCcdtBB5gg88L0d80/yZnTqwh0fVuQW
         Davg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zWWZbv1VXbeiAIfJ9egbHayb1S7Nhsd/riY822fMbFM=;
        b=XGUGL1Ao73pe2ykNeDioHiUdTswvTKAfwbNXhxm4RM7m6hBvyEtUHE/0dfTkjEhQUI
         9JDf2Jnm/TvvIzkW9D44Y9CfPc0ZDWbqrO303i1XrNfEQtbuxT+12ofjnYescx8TmxaF
         fKtcEeUkbMED41j3tfgUUS6lHnTyi45knvh3YT610MJa8HjWVZpokvJw+Pt8vh0Qbgn2
         uL41OaM0/Ir7UutrSILncwU/pd/7AThLv2X63cUKY4kyPcRrldda5uxPJB/EGEX4gYYx
         5tGLiUknutuPSFIdMFtpEK61vo+NSm+YS4xaWdGoYynHHOoUqFukg/I4fzTNMKiKaYYf
         Jk7g==
X-Gm-Message-State: AOAM531TG2vm+eqt4FX3tJkYxeFjjFiI0Y8cGKj+AuHdZ8a1TKO4EaQH
        3npO4P5bbUvOr0Mg/8WsbOnBLuN/jIhPyvaWfO9Ikw==
X-Google-Smtp-Source: ABdhPJxSSR8dl6zsHr9SQ3XA917DshRRXfDJnv7hmezMxKWDafEBgyx7sWpCsmnqswtVFX5d454iux9XNdQ50k78sxE=
X-Received: by 2002:a05:6638:1923:: with SMTP id p35mr1428832jal.16.1636402481497;
 Mon, 08 Nov 2021 12:14:41 -0800 (PST)
MIME-Version: 1.0
References: <20210913135745.13944-1-jgross@suse.com> <20210913135745.13944-2-jgross@suse.com>
In-Reply-To: <20210913135745.13944-2-jgross@suse.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 8 Nov 2021 12:14:30 -0800
Message-ID: <CANgfPd-DjawJpZDAFzwS54yukPSsUAU+rWsais2_FCeLCZuY0A@mail.gmail.com>
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

On Mon, Sep 13, 2021 at 7:51 AM Juergen Gross <jgross@suse.com> wrote:
>
> Commit 76b4f357d0e7d8f6f00 ("x86/kvm: fix vcpu-id indexed array sizes")
> has wrong reasoning, as KVM_MAX_VCPU_ID is not defining the maximum
> allowed vcpu-id as its name suggests, but the number of vcpu-ids.
>
> So revert this patch again.
>
> Suggested-by: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>

The original commit 76b4f357d0e7d8f6f00 CC'ed Stable but this revert
does not. Looking at the stable branches, I see the original has been
reverted but this hasn't. Should this be added to Stable as well?

> ---
>  arch/x86/kvm/ioapic.c | 2 +-
>  arch/x86/kvm/ioapic.h | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index ff005fe738a4..698969e18fe3 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -96,7 +96,7 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
>  static void rtc_irq_eoi_tracking_reset(struct kvm_ioapic *ioapic)
>  {
>         ioapic->rtc_status.pending_eoi = 0;
> -       bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID + 1);
> +       bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID);
>  }
>
>  static void kvm_rtc_eoi_tracking_restore_all(struct kvm_ioapic *ioapic);
> diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
> index bbd4a5d18b5d..27e61ff3ac3e 100644
> --- a/arch/x86/kvm/ioapic.h
> +++ b/arch/x86/kvm/ioapic.h
> @@ -39,13 +39,13 @@ struct kvm_vcpu;
>
>  struct dest_map {
>         /* vcpu bitmap where IRQ has been sent */
> -       DECLARE_BITMAP(map, KVM_MAX_VCPU_ID + 1);
> +       DECLARE_BITMAP(map, KVM_MAX_VCPU_ID);
>
>         /*
>          * Vector sent to a given vcpu, only valid when
>          * the vcpu's bit in map is set
>          */
> -       u8 vectors[KVM_MAX_VCPU_ID + 1];
> +       u8 vectors[KVM_MAX_VCPU_ID];
>  };
>
>
> --
> 2.26.2
>
