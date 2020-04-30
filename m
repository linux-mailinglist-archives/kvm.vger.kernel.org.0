Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4D41BEEC4
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 05:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgD3D6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 23:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726454AbgD3D6E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 23:58:04 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FFFC035494;
        Wed, 29 Apr 2020 20:58:04 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id i16so9313ils.12;
        Wed, 29 Apr 2020 20:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dOspF7w14kkeDi21u8LT7QgFXxgV7izAF+lcJJNgVGY=;
        b=bYmIRu4t+F43Br1MFoLKj/2KtO7FtPfYz9X+TyYZxoaPYs1BJ/QRXEssrU845zScpm
         qa0V8RWBlNhtqwhluBshdr6iF5yRI/eGZs2u24yuPZMqQ+zpySOdUQyENbz92ELghnyJ
         n1roMjq2pLWUd+iVOiJ9w3hgd+pPFV76mCqg5qHlQ2rWmLxYjU1hOuCOOTd8n60Eg4UT
         xDflhWEHpDN0r9htOae7GZXeeHSs5L8noBim03oMae4XfmD8Up84E/u/gVrChkjQbNR1
         9DzELnLDwSSD8Ly4o3ELww+NcXeQw626i6z6z02jx7TNdgJA/EbIdDqR19N9bnMEi+8I
         Nmhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dOspF7w14kkeDi21u8LT7QgFXxgV7izAF+lcJJNgVGY=;
        b=e7oinwA9PMVhs8NeEJHLZ40p8prz6Eh6G/TSmZIxKN5CbqBW8kzeZ0uyJttX8LEM+f
         Gk8ffUIMhvKgoArblEfEJXOfyzs5UT0jZOcwn6E2N8qhc8AIXMKNZMQZxYm4Hc8UyX+s
         7JZbu/BxlYkdxZ5aBMAgSW6ekQy6OMrCcxhOkXl1aXBlR/KwxPG8dFmG/hFCIdbgznK1
         25MNLv9eIeK3BgHwylZL/rYsb+S9HgPZiwGVIbthWRnJiScw82kNi0Yf7XX/D0NeNUts
         AVw706Qi34H5KVnvUxq23JIQVSdL/UCLSZhnPLOpdgrmE58WEA7NIaYq3xSFsHHPhuUk
         VGuQ==
X-Gm-Message-State: AGi0PuaYydQ71jcT8gvzSJhrfUPA4saQ+N3o56gc21HdAocfD/fcJ2NY
        XdnpmHAj7KuTXvoUM+DXkv9kWFkqP+1lX8xhLI6Y51DauEo=
X-Google-Smtp-Source: APiQypKBylr/J39bqvf6uVDQ/V4pYdv1udXBLc1XsqJuj//ZCLP1m9QnRnyygT4OSfyQc+kSMNAYl97AjxOzhjIIeHA=
X-Received: by 2002:a92:5d0f:: with SMTP id r15mr26441ilb.251.1588219083339;
 Wed, 29 Apr 2020 20:58:03 -0700 (PDT)
MIME-Version: 1.0
References: <1588216776-62161-1-git-send-email-zou_wei@huawei.com>
In-Reply-To: <1588216776-62161-1-git-send-email-zou_wei@huawei.com>
From:   Huacai Chen <chenhuacai@gmail.com>
Date:   Thu, 30 Apr 2020 12:05:34 +0800
Message-ID: <CAAhV-H66CA+n+FQCia-_-o0AQLJ3HZrTAufZH1CgrR+k+xRo8g@mail.gmail.com>
Subject: Re: [PATCH -next] KVM: MIPS/Emulate: Remove unneeded semicolon
To:     Zou Wei <zou_wei@huawei.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Huacai Chen <chenhc@lemote.com>

On Thu, Apr 30, 2020 at 11:13 AM Zou Wei <zou_wei@huawei.com> wrote:
>
> Fixes coccicheck warnings:
>
> arch/mips/kvm/emulate.c:1793:3-4: Unneeded semicolon
> arch/mips/kvm/emulate.c:1968:3-4: Unneeded semicolon
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>
> ---
>  arch/mips/kvm/emulate.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
> index 754094b..5c88bd1 100644
> --- a/arch/mips/kvm/emulate.c
> +++ b/arch/mips/kvm/emulate.c
> @@ -1790,7 +1790,7 @@ static enum emulation_result kvm_mips_guest_cache_op(int (*fn)(unsigned long),
>                         return EMULATE_EXCEPT;
>                 default:
>                         break;
> -               };
> +               }
>         }
>  }
>
> @@ -1965,7 +1965,7 @@ enum emulation_result kvm_mips_emulate_inst(u32 cause, u32 *opc,
>                         break;
>                 default:
>                         goto unknown;
> -               };
> +               }
>                 break;
>  unknown:
>  #endif
> --
> 2.6.2
>
