Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4459F2181FE
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 10:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgGHIFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 04:05:03 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:34891 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGHIFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 04:05:02 -0400
Received: by mail-il1-f196.google.com with SMTP id t18so18384149ilh.2;
        Wed, 08 Jul 2020 01:05:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=teq7RG3NOrPAL3T2QqpzCt3GlBCAE6hS9MR0+SaSIe0=;
        b=A8Hpp1qZm11v+u/conzEa2iQ3+1QUy8wKigr+ar4DPLuyyJRaIIrjqIoi3rlFLltAK
         y3ZG3PNQAKIjYOw9HjwlqEfEZCeDKB2i12W4mUpN5d11sFUdFdwEvFbj1dDTPvWFr6uE
         Y/Bnqa66AmLKQ83x7BYR7rquhYgtjxiCmATgSWQtdyUwjzTEROfsjfvoLx/nwB8wOdiH
         SaymnKbLOWPbY0plnGF9kfBWeYdFshIb8ZEGaDTgZ1VTOcgnJP9PmuORQUocdzV//XIf
         E22VIs4VCFmbCgP+u+ncafhtctSuK6S1Wy4lRFAcT2Ef62UWQfl0sncqgMPBTP1prkLE
         M1Eg==
X-Gm-Message-State: AOAM531WVrMb0nsUlO65EzwHDXbKxSkv33oZ4AGhzDJSIDBc1AqHjvHk
        +YYhhFnOjWG8b0TxrUM2iDHzvDoRU51/Db8R534=
X-Google-Smtp-Source: ABdhPJyX+rvgLwsdzJMlMpE6da/7orHPbs6idGJ8KQ5jJQN/eXYhEdHVRMVcIIV1Xf4248xEOn8Ftw4wKjY0e+LriGc=
X-Received: by 2002:a05:6e02:103:: with SMTP id t3mr6082091ilm.147.1594195501767;
 Wed, 08 Jul 2020 01:05:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200706014534.352509-1-jiaxun.yang@flygoat.com>
In-Reply-To: <20200706014534.352509-1-jiaxun.yang@flygoat.com>
From:   Huacai Chen <chenhc@lemote.com>
Date:   Wed, 8 Jul 2020 16:04:49 +0800
Message-ID: <CAAhV-H753naJOe9BnHTr-OoWDo=Bg-PAVpTNFU5fk0MB-pP5zA@mail.gmail.com>
Subject: Re: [PATCH] MIPS: KVM: Convert a fallthrough comment to fallthrough
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     kvm <kvm@vger.kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Huacai Chen <chenhc@lemote.com>

On Mon, Jul 6, 2020 at 9:53 AM Jiaxun Yang <jiaxun.yang@flygoat.com> wrote:
>
> There is a fallthrough comment being forgotten,
> GCC complains about it:
>
> arch/mips/kvm/emulate.c: In function kvm_mips_emulate_load:
> arch/mips/kvm/emulate.c:1936:21: error: this statement may fall through
>  1936 |   vcpu->mmio_needed = 1; /* unsigned */
>       |   ~~~~~~~~~~~~~~~~~~^~~
> arch/mips/kvm/emulate.c:1939:2: note: here
>  1939 |  case lw_op:
>
> Just fix it.
>
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  arch/mips/kvm/emulate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
> index 5ae82d925197..bb17d8274462 100644
> --- a/arch/mips/kvm/emulate.c
> +++ b/arch/mips/kvm/emulate.c
> @@ -1934,7 +1934,7 @@ enum emulation_result kvm_mips_emulate_load(union mips_instruction inst,
>
>         case lwu_op:
>                 vcpu->mmio_needed = 1;  /* unsigned */
> -               /* fall through */
> +               fallthrough;
>  #endif
>         case lw_op:
>                 run->mmio.len = 4;
> --
> 2.27.0
>
