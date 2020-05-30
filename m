Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC791E8D15
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 04:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgE3CIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 22:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgE3CIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 22:08:32 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD623C08C5C9
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:08:32 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id j8so1338187iog.13
        for <kvm@vger.kernel.org>; Fri, 29 May 2020 19:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JGlgROHSovsEF4bMgP89pW+8Pij7QZBFzzTXzjSt4uE=;
        b=Z/o+wW+Dx/McvSxo/vn8yYtIZxJaH8N6GRqo+aXvlqSz3x/Sjz5OCrDfNKGG46sDy7
         UQcIM2rc7QTjGIlkNqjbuWUw1C5jrHsaieg3xwZ661p3FBA0/+T4A7HggUETi+cLOVi6
         3tw4IE8IXPLbABQFMY7jpp0+QQSBHPE39SiM8XwbUpiO5ej8HtIEax9BruoxUemYOYtE
         GeSQRcgF778oValHxiPKTOTuIdPb0fGdxYrUTau8rh7gcY3BNJMJlIBo+OHjgydEGnjQ
         nLAGc6Or3Q48f6XkxgMqtpifSgHKjr/87Uxf7VYTeV2Q+jFZ4c3XQgqvg+Fd1CJNc+HK
         Re2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JGlgROHSovsEF4bMgP89pW+8Pij7QZBFzzTXzjSt4uE=;
        b=RIZxPd/1OTb8Wl/9XC4EbF1hfuLwwkyPmKBlZe19vmcXQxi6SIaUNvSCrt7kxkxAK5
         eMpkODgEHvEI+sJuJXCVkj84AcJ1Ou/OE7/5eSfEZxSVJazO1l821zCkqBDkmVwqp7c2
         ym3gozjp2kju77MQdqDbHDa3IrOXF1DLOSoMIMz1b91edmLjwv3okJ56jMMrLaFlVndb
         OgN2mMlfaj1OgHvB8aHVnImDCulrsouXZ1tip76+FawoNDmY6CLIEn+LV3UEsDA6ogHQ
         xv8X3euMDIVhYSN2nY+NyTTvz25SR901uL6692tGTKbduOwSs84SAfYZ3UoS+G7JE+87
         rw9w==
X-Gm-Message-State: AOAM5334Dr9De4I/0T49DBG9H8BfNOunYc6+Bc3XdWC5powZg8M1b/BB
        B5lrblAxGrdUJq3wWXvJXvfQXMZRgJksJNs3CQgkVA==
X-Google-Smtp-Source: ABdhPJwm1KgZnRuBHWDLttsOH2fpKKstKDUsD4DfLIV7tDl54dh0cp8sxNR+w1vUHA5eY+MpfyrulwEuAxa9nXxiuuw=
X-Received: by 2002:a6b:38c4:: with SMTP id f187mr9015617ioa.205.1590804511839;
 Fri, 29 May 2020 19:08:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1588711355.git.ashish.kalra@amd.com> <abeea5c7dc54cf86e74bc9d658cef9b25a8fac6e.1588711355.git.ashish.kalra@amd.com>
In-Reply-To: <abeea5c7dc54cf86e74bc9d658cef9b25a8fac6e.1588711355.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Fri, 29 May 2020 19:07:56 -0700
Message-ID: <CABayD+eFyWG0-Pa6hX1_HLGG6oyq=cVG1skpvJomhfpBhifoHQ@mail.gmail.com>
Subject: Re: [PATCH v8 14/18] EFI: Introduce the new AMD Memory Encryption GUID.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 5, 2020 at 2:20 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Introduce a new AMD Memory Encryption GUID which is currently
> used for defining a new UEFI enviroment variable which indicates
> UEFI/OVMF support for the SEV live migration feature. This variable
> is setup when UEFI/OVMF detects host/hypervisor support for SEV
> live migration and later this variable is read by the kernel using
> EFI runtime services to verify if OVMF supports the live migration
> feature.
>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  include/linux/efi.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 251f1f783cdf..2efb42ccf3a8 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -358,6 +358,7 @@ void efi_native_runtime_setup(void);
>
>  /* OEM GUIDs */
>  #define DELLEMC_EFI_RCI2_TABLE_GUID            EFI_GUID(0x2d9f28a2, 0xa886, 0x456a,  0x97, 0xa8, 0xf1, 0x1e, 0xf2, 0x4f, 0xf4, 0x55)
> +#define MEM_ENCRYPT_GUID                       EFI_GUID(0x0cf29b71, 0x9e51, 0x433a,  0xa3, 0xb7, 0x81, 0xf3, 0xab, 0x16, 0xb8, 0x75)
>
>  typedef struct {
>         efi_guid_t guid;
> --
> 2.17.1
>
Have you gotten this GUID upstreamed into edk2?

Reviewed-by: Steve Rutherford <srutherford@google.com>
