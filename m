Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B7A128C7C
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2019 04:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfLVDmX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Dec 2019 22:42:23 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:46361 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfLVDmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Dec 2019 22:42:23 -0500
Received: by mail-io1-f66.google.com with SMTP id t26so13186634ioi.13;
        Sat, 21 Dec 2019 19:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s8V1Uf9fkOaeCKjApUMyVRm+t9dqG3jTVUS23e14+fY=;
        b=OPFAsK6IBGaYEflQ7UhvS33I8ZfF7Hog5KOwoxX8PGR4bM5Sr+EuRFuIJBH80hjaqV
         cs2P/sn98ivs9Gbm5hhYNIFEsuC3Ae5W1gLoJnHRx2H44i02pXtDGlBulyuHeV9v7Mue
         8XXK7/0r20OL9WVh4CwwDf07OFLOFfExFEMPIKOlm4TobxUkEncmB4PXclojJ//JVUxX
         Lkoauf8XRvKowOTkfuFWc/qnwBRez3o8fxwnanC9UGCGQLH+FmgD1blSTlbG9ZpJuXfL
         CjFH/Vp/pfmacFCFAI6KR1agxBkKAlsqPKejkHvs9VcM7WwgpkM5+lbBJPzc6yqkDIVB
         axkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s8V1Uf9fkOaeCKjApUMyVRm+t9dqG3jTVUS23e14+fY=;
        b=go/3MGjGJY65MzZoP2u6CByRb8NLR9QUk5JyhMIRfTXfQveLxw5daVgQEBV9kSYQrm
         LhmJf0RfrorTvLGpIjIwtvau+1loH8crKrCj3Orq5wvtGy+CCglOQnwmBBsYuJqiKGsz
         zzLV2NLZouEotMVmzsQiF1EZ4swiM7FCxIK9Qwn/Xuennr68wM7QeWs0jgMNP1BqHdiP
         dwXlTfybgJ3O9cdxz02Lc+UsFZT85MKsLa2gNti67/557OwjiPjs/ofSm/xoWcu/K0wp
         lbGPbMxYin82fyWs/tSXYm1XRZ2WjNsX9XeMu1iaIzTCVyXz2CL/S0bgwxwTjH+DjeRE
         A5nA==
X-Gm-Message-State: APjAAAWxfY6UXFpOBgS3CD4BBQNHcNfSavjIMx48bUPlfFt/I9JgeeZ0
        4ZSp3FJcYXs+QG8BYMBxFGUmqkoaT60WzuLdYNJn9PsV
X-Google-Smtp-Source: APXvYqziLcBA/6875hpSw2Bjy0ZvGj+IlLKCRI8U9mZlg6Gsz4QKPW56u6TMkW3TgTAomm6PjtIpuNkOY4vLxG6DFCQ=
X-Received: by 2002:a02:c85b:: with SMTP id r27mr18562182jao.57.1576986142194;
 Sat, 21 Dec 2019 19:42:22 -0800 (PST)
MIME-Version: 1.0
References: <20191221155013.49080-1-jhogan@kernel.org>
In-Reply-To: <20191221155013.49080-1-jhogan@kernel.org>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Sun, 22 Dec 2019 11:47:02 +0800
Message-ID: <CAAhV-H4W0Ua4qZQgnAy1v9Mq3kxbZt3ifpLstPrc2StiitCw1g@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Orphan KVM for MIPS
To:     James Hogan <jhogan@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, kvm@vger.kernel.org,
        "open list:MIPS" <linux-mips@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, James and Paul,

Loongson-3A R2 and newer processors support VZ, and I'm working on
KVM/Loongson now. If possible, I want to maintain KVM/MIPS later on.

Thanks,
Huacai

On Sat, Dec 21, 2019 at 11:50 PM James Hogan <jhogan@kernel.org> wrote:
>
> I haven't been active for 18 months, and don't have the hardware set up
> to test KVM for MIPS, so mark it as orphaned and remove myself as
> maintainer. Hopefully somebody from MIPS can pick this up.
>
> Signed-off-by: James Hogan <jhogan@kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Kr=C4=8Dm=C3=A1=C5=99" <rkrcmar@redhat.com>
> Cc: Paul Burton <paulburton@kernel.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: kvm@vger.kernel.org
> Cc: linux-mips@vger.kernel.org
> ---
>  MAINTAINERS | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 19d17815c0fb..010bb51bedcb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9074,9 +9074,8 @@ F:        virt/kvm/arm/
>  F:     include/kvm/arm_*
>
>  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> -M:     James Hogan <jhogan@kernel.org>
>  L:     linux-mips@vger.kernel.org
> -S:     Supported
> +S:     Orphan
>  F:     arch/mips/include/uapi/asm/kvm*
>  F:     arch/mips/include/asm/kvm*
>  F:     arch/mips/kvm/
> --
> 2.24.0
>
