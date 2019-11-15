Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A14F1FD25B
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 02:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfKOBWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 20:22:47 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35252 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727176AbfKOBWq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 20:22:46 -0500
Received: by mail-lf1-f66.google.com with SMTP id i26so6691216lfl.2
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 17:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rbE1Wcsirza2JaW+3utZn4hbrXpX5xNM8bL08eDqpyw=;
        b=qjvFTPBgFXYbB5WdseQRUdly8Y8CbuMcAAcDxORIfmdVQS99H/oqvGy8WoF96Tg7A+
         n2YmgRm6wt8AA9LrPXu2b/aspr0DYORzzcudOogpl9P9ditcW6nnwA/1v9B+MLV077dM
         MSod2kWwlGFXQQrBokWh0PhHbF6L7khF7M67SFJ6gb/MFXEocLfBhboQbz4/yF1sC9rK
         8f1/RXUBhcSFNSFfdPpc8baOHrvdGEdH5Lo8aoKcGlDBeeHB7Sr6aJF+uFvp9iPYTbuv
         5+a8xXS01xAajSZj5AiRN53uswZtj1Hltsb6Wln1LzhHdYiiXudnLqLVeBFJENJWr3g9
         ZnUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rbE1Wcsirza2JaW+3utZn4hbrXpX5xNM8bL08eDqpyw=;
        b=gSRVS//ZuMNbr5uR1udqGXAlgh9835Dx/PFry/z6V3sT0jzQVIMaXXJgOJo0sPw7u6
         6kqrRlVu7ATOifTBNM+C8XMuBYVxVI7w2HF078qQ6YNaWikZ087YtyICdF8cDOgNZQLu
         Ay0+fgoJOqLsfGHx7FctgIAr99qp6/8IZUQR9xrifQGouJaLPzv94M9xsD27xceBkjDO
         J4M8oe6IjER3M+jisItsUf9zKBzRJt2i1G0g1z1yflkFt0Rc7rf+MiuABbN1yVfMYCzo
         NACWn7YFUe6Bj+VVSB9wh4ToOXBt7GshRfFMMKfhivrbjPx9kYN6jxFl8IWUS2Fu6OHh
         KIkQ==
X-Gm-Message-State: APjAAAWxoIM1Iw00oLA4p+ODkY+z7a11qOufrl/6BlZpiBQVW7T4j2r0
        qB5w9RoiRVGDOK2zqCEKSaoIg6glkjanD1GZn+l78QVi5ag=
X-Google-Smtp-Source: APXvYqwQwGEi9KMXiJwWP1bFww1hrCBel+m7oLxDqeOryH+SK2KL+bPmaHUTPWh+0JAj/TgIbmhHhZMIwkji3C1u9sU=
X-Received: by 2002:a19:22d3:: with SMTP id i202mr8959655lfi.69.1573780962459;
 Thu, 14 Nov 2019 17:22:42 -0800 (PST)
MIME-Version: 1.0
References: <20190710201244.25195-1-brijesh.singh@amd.com> <20190710201244.25195-12-brijesh.singh@amd.com>
In-Reply-To: <20190710201244.25195-12-brijesh.singh@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Thu, 14 Nov 2019 17:22:06 -0800
Message-ID: <CABayD+ctvNszs6gVdjP+geJTk1RN3Ko-RWaRTdeU6-7G1=F=Mw@mail.gmail.com>
Subject: Re: [PATCH v3 11/11] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP ioctl
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 1:13 PM Singh, Brijesh <brijesh.singh@amd.com> wrote:
>
>  struct kvm_arch_async_pf {
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index e675fd89bb9a..31653e8d5927 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7466,6 +7466,47 @@ static int svm_get_page_enc_bitmap(struct kvm *kvm,
>         return ret;
>  }
>
> +static int svm_set_page_enc_bitmap(struct kvm *kvm,
> +                                  struct kvm_page_enc_bitmap *bmap)
> +{
> +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +       unsigned long gfn_start, gfn_end;
> +       unsigned long *bitmap;
> +       unsigned long sz, i;
> +       int ret;
> +
> +       if (!sev_guest(kvm))
> +               return -ENOTTY;
> +
> +       gfn_start = bmap->start_gfn;
> +       gfn_end = gfn_start + bmap->num_pages;
> +
> +       sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / 8;
> +       bitmap = kmalloc(sz, GFP_KERNEL);

This kmalloc should probably be either a vmalloc or kvmalloc. The max
size, if I'm reading kmalloc correctly, is 2^10 pages. That's 4MB,
which should correspond to a bitmap for a 128GB VM, which is a
plausible VM size.

--Steve
