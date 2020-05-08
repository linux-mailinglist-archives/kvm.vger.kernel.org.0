Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9B11CA829
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 12:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgEHKRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 06:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgEHKRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 06:17:19 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F09C05BD43;
        Fri,  8 May 2020 03:17:18 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g12so9998562wmh.3;
        Fri, 08 May 2020 03:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wPlMYK4BGXFSp3IHXDTVLzq/iTbq1i6IWP1FINyN18k=;
        b=o3Xlt3s6++cHTq52sQjBq0wMEAi9y5SNlGe7QO0y6oq0KKhuZx3BfXIXmEfYSY8gPy
         ShBtS6suwtbVkvmGrQ2e8A/I43MBZUPQeiqtsaZJb1FFbeRZgKR8iSUOztdjptUPrT1s
         szfjPX0Z8PnOzgo33UCwDYMcUZP6OLIkuhIcL00gaWTNU9q5Q+nl4GqWCfr7c9CqUvgG
         zKWs+BsUdKrvk9WTceTlsjb87e7cZdpeYQgVn4KqtlbNHSlRBho6H31fdn4h88Y30FHx
         91pBNfpt+gcz/SqocY7WT5N5WMkUtk+GzRx6HvSfAAL8709C1ZlMtReRnBFVW1Ez2o14
         gVVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wPlMYK4BGXFSp3IHXDTVLzq/iTbq1i6IWP1FINyN18k=;
        b=osYIzTfH6Cc/z1GxNXuTKDf+F9TfAUXtbycj8nii48+VXS7LkkpGAs/R7kNTxbd8Do
         pQPRNbLpj3dX3QwZxOMbusQnFbKVRZxvrs3OZ/vrXIn9tg5blCZFMzxEw8KWwts8xpw8
         mskd86r1Rwwl6TO6NCSYbH48lKscO3euT6723Y/c4monWzGZXwp+6vnnaEmUE+304259
         0bnL3cN++K7PeP1wZ5+bw0okxgkkyJXoXgMYn4rjiEx11haHLBNSsSPV8TLxqWmfmWsV
         xBEdXvpx2aPMew2Vxb4V52A7GefDjpVSiVouECf/OIM7UTmNpz+2IMxLdRxOpBp2Iqcl
         wSkg==
X-Gm-Message-State: AGi0Pub6yrhGK8ZVXnAmDKlRZ97ASXAOX8odZ9p7V3bKmi+pDZUCDvCw
        L7/PEXcHJ1kCuZVUUym3wF442dD+4DFm3CitnrU=
X-Google-Smtp-Source: APiQypIZFqnECJhCvIGLM3lIwRn5c3Wyc+b/srmG5x5QwvCo9yi/D+GdLPFD1hEudGcor71Fg5HQOE4XHmgrsmb6bp8=
X-Received: by 2002:a1c:f211:: with SMTP id s17mr16902508wmc.168.1588933036896;
 Fri, 08 May 2020 03:17:16 -0700 (PDT)
MIME-Version: 1.0
References: <1588500367-1056-1-git-send-email-chenhc@lemote.com> <1588500367-1056-4-git-send-email-chenhc@lemote.com>
In-Reply-To: <1588500367-1056-4-git-send-email-chenhc@lemote.com>
From:   Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Fri, 8 May 2020 12:16:54 +0200
Message-ID: <CAHiYmc69=CNzXTtOSXg5ZxBy0+J4iRwct25O-ANw-=PEkcMTaA@mail.gmail.com>
Subject: Re: [PATCH V3 03/14] KVM: MIPS: Increase KVM_MAX_VCPUS and
 KVM_USER_MEM_SLOTS to 16
To:     Huacai Chen <chenhc@lemote.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        linux-mips@vger.kernel.org,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

=D0=BD=D0=B5=D0=B4, 3. =D0=BC=D0=B0=D1=98 2020. =D1=83 12:08 Huacai Chen <c=
henhc@lemote.com> =D1=98=D0=B5 =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BE/=
=D0=BB=D0=B0:
>
> Loongson-3 based machines can have as many as 16 CPUs, and so does
> memory slots, so increase KVM_MAX_VCPUS and KVM_USER_MEM_SLOTS to 16.
>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> Co-developed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  arch/mips/include/asm/kvm_host.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm=
_host.h
> index caa2b936..a7758c0 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -78,8 +78,8 @@
>  #define KVM_REG_MIPS_CP0_KSCRATCH6     MIPS_CP0_64(31, 7)
>
>
> -#define KVM_MAX_VCPUS          8
> -#define KVM_USER_MEM_SLOTS     8
> +#define KVM_MAX_VCPUS          16
> +#define KVM_USER_MEM_SLOTS     16
>  /* memory slots that does not exposed to userspace */
>  #define KVM_PRIVATE_MEM_SLOTS  0
>
> --
> 2.7.0
>
Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
