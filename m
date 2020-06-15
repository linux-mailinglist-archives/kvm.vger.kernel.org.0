Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240B31F9358
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 11:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgFOJ0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 05:26:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48636 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728825AbgFOJ0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 05:26:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592213199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yI7E/YvuE5G4Fcq1XlBfdWH6990iBDxnfkOv+u2TlXw=;
        b=PTXwmeFBtVMuggAUQT0izOriAkfmOkHrj133IkW1tL/KtM9+tq1tcMEYXeNrMtdbzKXms9
        RvuNlBIW/TaTs1OImgXbrrGJxnc3BWf32IJIYBXi1EerQBOC7Kehz/uYkQrV3OziRkS659
        Jj3e5nQq+Rz5aX1GG2DnBOl5Dbw1Fqs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-XGwVL9T3MkCJ3roR6xQF9w-1; Mon, 15 Jun 2020 05:26:37 -0400
X-MC-Unique: XGwVL9T3MkCJ3roR6xQF9w-1
Received: by mail-wm1-f71.google.com with SMTP id a7so4769224wmf.1
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 02:26:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yI7E/YvuE5G4Fcq1XlBfdWH6990iBDxnfkOv+u2TlXw=;
        b=lkBl719XqNSGRN4c1oR1y/jC7+II0stYWSMWSjmNe3Hw6oDGneBYbrKIxhXZVQagec
         /1nqeTCGqaklRzU4tj+h8AE6lnRjwERJ4gcJR11l4iGdx4rnnJMpgt/PzEJ/tQDrrtnc
         lI86ad1zy35dVfneNqvNmZ3UWOmyo3jy/n+AANn+29HoqpABd+tRJafgRpXEfuDT9vQM
         yM9Sg7fAc3k+CiuUSbzYwCln0m0xlCen0vpSVWeDBOyyHXKh/A0Y/ZYzjdaFiZ+0cZyh
         3rvxgnzksA6QiAw8E5CI9V23BJAYU76EXLkKjA+hO8MOsA401Dlf410tfPQQbd3Lecrf
         9wXQ==
X-Gm-Message-State: AOAM530Xj3S1u6u4zh5a+CZKABgf+3zVs9pHDwfZ5T+2boPPgPehIDDB
        LIcu775eSg0MPFVvDn2hSNUwBg8EYVx492E94/vEwpUkvrCVWv5zlY5OZ7Op8jKCArtigS81x/g
        F4h4Phzh5X+1t
X-Received: by 2002:adf:f64c:: with SMTP id x12mr26458186wrp.281.1592213196406;
        Mon, 15 Jun 2020 02:26:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBtzTDMfu3sHAYPmv3xH0MlQ/aHw1xIOVTm9Cdt6pwa2j2+XFFTGe83BYVXxw0al8P+9Og3A==
X-Received: by 2002:adf:f64c:: with SMTP id x12mr26458166wrp.281.1592213196197;
        Mon, 15 Jun 2020 02:26:36 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id d63sm22753270wmc.22.2020.06.15.02.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 02:26:35 -0700 (PDT)
Subject: Re: [PATCH] KVM: MIPS: Fix a build error for !CPU_LOONGSON64
To:     Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <1592204215-28704-1-git-send-email-chenhc@lemote.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b22d90eb-5a4c-6d09-2585-f3aba45b72dc@redhat.com>
Date:   Mon, 15 Jun 2020 11:26:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1592204215-28704-1-git-send-email-chenhc@lemote.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/06/20 08:56, Huacai Chen wrote:
> During the KVM merging progress, a CONFIG_CPU_LOONGSON64 guard in commit
> 7f2a83f1c2a941ebfee53 ("KVM: MIPS: Add CPUCFG emulation for Loongson-3")
> is missing by accident. So add it to avoid building error.
> 
> Fixes: 7f2a83f1c2a941ebfee53 ("KVM: MIPS: Add CPUCFG emulation for Loongson-3")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Huacai Chen <chenhc@lemote.com>
> ---
>  arch/mips/kvm/mips.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 521bd58..666d335 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -67,8 +67,10 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	VCPU_STAT("vz_ghfc", vz_ghfc_exits),
>  	VCPU_STAT("vz_gpa", vz_gpa_exits),
>  	VCPU_STAT("vz_resvd", vz_resvd_exits),
> +#ifdef CONFIG_CPU_LOONGSON64
>  	VCPU_STAT("vz_cpucfg", vz_cpucfg_exits),
>  #endif
> +#endif
>  	VCPU_STAT("halt_successful_poll", halt_successful_poll),
>  	VCPU_STAT("halt_attempted_poll", halt_attempted_poll),
>  	VCPU_STAT("halt_poll_invalid", halt_poll_invalid),
> 


Queued, thanks.

Paolo

