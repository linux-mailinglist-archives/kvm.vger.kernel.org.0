Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE31D35D449
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 02:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238497AbhDMAGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 20:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237765AbhDMAGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 20:06:23 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2FEC061756
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:06:04 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id c18so12596527iln.7
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 17:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oc8KDiOWuwADnzIA25HidDazWPNHccWEXTYmACDczag=;
        b=G3MmhBQSxPp8hy3RJxE7/AHj5wYLU/wal3dtuc+Hu1ED8dOFUsVkmKd59y17amn7N4
         Y3glEJBHd+euhT/qra+SIse7JEnBa1xLscQG0ZDaHDtGLJVczImyM0f/uA4arFYxj/OD
         wz0xIbIt7a5dn8sojVg6bE5+8ppSTgNF22T3zD6mw1b8dYOrIwZKUjqYuaSAU8wHaqTy
         d/qpCxTFw9TtC7Ld24iZrIAV5qlZr/4IA8I1KwXkyD2w0zfEiILC3A9DWc83msK5u0ce
         GEV9F7s4m5NUhXs3N9th7yzL91/vVUQzruX47ztxAYV1eFDQ6iJQR3UEAAUYXVUH2Bff
         1X+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oc8KDiOWuwADnzIA25HidDazWPNHccWEXTYmACDczag=;
        b=LVZt0PH28FvHo+w05Xk0FSV55pPsdoGXy7yvEjm9nOCQdNx3PRO+oEXL0br12WVR4v
         ceK+C+7bKMSBYmHETMTR39ZQYlw0H1wWJnWlhxDRupW+Fe0jULneWuPRI9yK6QhkdbHb
         agb/ucd7GW+rfr881JaGIkZ/Cj86rQTOy8H43wNfnoSUgffttgrvwDPrcq3ZQW1kCoVz
         O1A8YpXifU9Ms5jOhaAec0s5wTbd5wz7HOGoVxJ0IfzbAs62ZHQqhoOHDNk5Gcefcugw
         FIKVrLx7z2xhgGDF05dcMRvk4c7pNQ53zk/2OZqo79Zpdm/VVTF7rW7IRpUEKQdcfeZr
         JW2A==
X-Gm-Message-State: AOAM531PaVJ8fIqD9MzqcSg5AmaQJzKdJu2ha/FDpv+KX6dytBdXFbCe
        cwuvOrmZVywCBLBt1WNo9tZvkoRIg3NkNgvYnF9d0w==
X-Google-Smtp-Source: ABdhPJwt3lAnilBhiJwW5hW0wvM9UynrbmdkqL8tSyjQF+bL5upsICRlEi6khnogCFg89M5espWn2e0B99MVXdu8Y8E=
X-Received: by 2002:a05:6e02:eb4:: with SMTP id u20mr26826705ilj.182.1618272364171;
 Mon, 12 Apr 2021 17:06:04 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1618254007.git.ashish.kalra@amd.com> <ae8924d0dcac0b397295f53f7bd3ff06f6a9ff12.1618254007.git.ashish.kalra@amd.com>
In-Reply-To: <ae8924d0dcac0b397295f53f7bd3ff06f6a9ff12.1618254007.git.ashish.kalra@amd.com>
From:   Steve Rutherford <srutherford@google.com>
Date:   Mon, 12 Apr 2021 17:05:28 -0700
Message-ID: <CABayD+chYok0LCxk6Z763D+SFHKnYcu9ERc39OOai0=davDCqA@mail.gmail.com>
Subject: Re: [PATCH v12 11/13] EFI: Introduce the new AMD Memory Encryption GUID.
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021 at 12:46 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> Introduce a new AMD Memory Encryption GUID which is currently
> used for defining a new UEFI environment variable which indicates
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
> index 6b5d36babfcc..6f364ace82cb 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -362,6 +362,7 @@ void efi_native_runtime_setup(void);
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

Reviewed-by: Steve Rutherford <srutherford@google.com>
