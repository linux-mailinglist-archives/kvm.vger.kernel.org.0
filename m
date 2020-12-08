Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4FC72D3740
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 00:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730723AbgLHX4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 18:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730312AbgLHX4s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 18:56:48 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1915C0613D6
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 15:56:07 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id 15so485646oix.8
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 15:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DfyPBy6ACVthl5B4hPAssaAuvv+oOl0RQ7ShELX0PlM=;
        b=LEasbFfoZoL/im+sFywdc4Y3plPW3INbwEcpPaopofCSS993Qz3H96eD9fd/2ANtaC
         lUC4jxoV7ELOeUjh4WSBZE9wwY6rpCdmII4xJ3BHpW8ri4X/VfShw4HJxseHhPc/BrJ+
         zffNFMYyQNcy8hoV5dxfUw1gveda/Uclka44YQYf8r2YVtfGWXXv/qGfoeP9urjwIo9L
         YfDJYq+X4y/yOh9Xec7nUGOHpNHEfEIK3UV/CNsyo8MHMPknkaE8WcRdQuI98e1D9913
         SyGWoGamnFCuHMc43wNJjfCzEC+wCEsFQx9CaKjgmv1//oiMS5BB5YlCC/VdcrVbvAm1
         pETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DfyPBy6ACVthl5B4hPAssaAuvv+oOl0RQ7ShELX0PlM=;
        b=PFn2RkALBXvTnqjqGXhZH219eO5SzcRC6LSi1Of0ZsF5NesjdZNAKRQnp0yVhacK6i
         m3BpzO22tf7yF/Vcqh2LC52DtIBDaNaKVt/x1epsbb9JqZwDBFlsdC0z+kGvU6DEzs1N
         aFzUacG/+s46+6PrrZRiqooKkxawYcX61LOGbrnqlqqWbLqqIkhzWWcR1+/1pp6J7CCX
         sl73Rgkw6RpbLUMocLNXDHChrt4f52LFxllLmy6W7xGgSa3oUlD7L9fpYvrLiyrdbznM
         PA35sss+NuDnsR6Z5iKtidpBkbMV21rB5XlulX3Xu9HILqd42S+v6EOmpcSbyp+8Gr5t
         3Nng==
X-Gm-Message-State: AOAM5310QPpFZbzQTrMjy4jVRpKvEMutdVJvK6y7BFqdFKRswygSS63v
        3QgR//u3D+y22Vw4FleI5wzWVA==
X-Google-Smtp-Source: ABdhPJwIqzDrw5d58apyIC8szvFZUj6p1bI17dw/BcAh1TpJuIN/vl80n62XWPlZNa3rmhfm9lUwGQ==
X-Received: by 2002:aca:c057:: with SMTP id q84mr325534oif.86.1607471767442;
        Tue, 08 Dec 2020 15:56:07 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id s189sm92095oia.7.2020.12.08.15.56.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 15:56:06 -0800 (PST)
Subject: Re: [PATCH 14/17] target/mips: Declare gen_msa/_branch() in
 'translate.h'
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20201208003702.4088927-1-f4bug@amsat.org>
 <20201208003702.4088927-15-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <45ab33e0-f00e-097a-74fb-4c7c42e29e33@linaro.org>
Date:   Tue, 8 Dec 2020 17:56:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201208003702.4088927-15-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 6:36 PM, Philippe Mathieu-Daudé wrote:
> Make gen_msa() and gen_msa_branch() public declarations
> so we can keep calling them once extracted from the big
> translate.c in the next commit.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.h | 2 ++
>  target/mips/translate.c | 4 ++--
>  2 files changed, 4 insertions(+), 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
