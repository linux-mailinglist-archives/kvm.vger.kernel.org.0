Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7DC2D455D
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 16:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgLIP0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 10:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728580AbgLIP0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 10:26:31 -0500
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5501EC0613D6
        for <kvm@vger.kernel.org>; Wed,  9 Dec 2020 07:25:51 -0800 (PST)
Received: by mail-oo1-xc42.google.com with SMTP id q20so463848oos.12
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 07:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=viI5vrk7EiAHTVvmvfnKMG6eoEpdfqILmVpNFtfqTCE=;
        b=H5ZUdumapfaNqCxjpCmTLZV+kdGTBBz2I2QEO8VQZklWt98f47yYhl259OjErEFpx7
         4+nz94Y6vbpLlcOxYRLQjbEbBXOJChXPr5sblIn9IHgw1R0vG6RzyiUmJmSL5488iIK3
         gEP76I5Vcfzf3e26ImBtFqbt+N6+3167Z/EGL5ZeF2co26oOOCtjqh7NvttGXB9OCjeO
         m46hF0dy09fsh9D6JRKIpo63W5t8p863iZAKs+IXaDhc60A6N+lVvuh8gqIh9/emjWig
         yLpb53oCCdA52lONk8daHuefb24chRYKn83HK9lKPCqv822LEgzKnYHucnpIC55AR0eu
         SDCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=viI5vrk7EiAHTVvmvfnKMG6eoEpdfqILmVpNFtfqTCE=;
        b=hngsTcuuYiVx9Ghi+GXjYrKj2uHKd22L0N69BOreuNFXQw+mycP23fopemkuldLM47
         mhMWOnCucMdRTSHtr828ViC/yNyK868naIkj7jrSBR1g81MGur/1kkbkw+FEngwZzjON
         U9t57ZJNPSlceLuhZIfz5FjzMhcMaNEBpzu68bTU8Tupj/1ABk1xbJ3BVfB9Hu9ws5j/
         kgRB34rIZAP4BNe2N2WIzaGdFJaeWJpq2/pG2I7URqWQqLXkX5cFw5Eq3UyvNaEWS4mf
         oshhB0sD/fsTaELxASrl5wLaHR7hV1d0SZz61o61whx7DUKLXlhoEQoyOoy8ElhYwCvh
         UItQ==
X-Gm-Message-State: AOAM530ZerAHvzRTiSbYwuJx1HwNCZZma86z53F6g5yvs+x8pw+DWwU5
        IMt8k4NpaHjxBa/0Wo+8nmbZ2A==
X-Google-Smtp-Source: ABdhPJxnvhlcBvObCgsIhXmcR2XwH2a7ygUMj0YUwqB7r+6uJ3ezWUuw89eCiIYnVtTVM/tGMfD2XA==
X-Received: by 2002:a4a:9502:: with SMTP id m2mr2233955ooi.93.1607527550647;
        Wed, 09 Dec 2020 07:25:50 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id 11sm433334oty.65.2020.12.09.07.25.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 07:25:49 -0800 (PST)
Subject: Re: [PATCH 14/17] target/mips: Declare gen_msa/_branch() in
 'translate.h'
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201208003702.4088927-1-f4bug@amsat.org>
 <20201208003702.4088927-15-f4bug@amsat.org>
 <45ab33e0-f00e-097a-74fb-4c7c42e29e33@linaro.org>
 <b0cf35c4-a086-b704-5710-0f05bf7921bb@linaro.org>
 <58a0d6c4-fc01-3932-52b9-9deb13b43c51@linaro.org>
 <1d2a6f44-1eab-2e92-01c2-703a2ee5bd50@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <d5f0d2ad-065e-e4bf-9eaf-1d8450aa4726@linaro.org>
Date:   Wed, 9 Dec 2020 09:25:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1d2a6f44-1eab-2e92-01c2-703a2ee5bd50@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/20 3:17 AM, Philippe Mathieu-Daudé wrote:
> Hi Richard,
> 
> On 12/9/20 1:03 AM, Richard Henderson wrote:
> In a previous version I tried to directly pass from
> 
> static void gen_msa(DisasContext *ctx) ...
> 
> to:
> 
> static bool trans_MSA(DisasContext *ctx, arg_MSA *a) ...
> 
> without declaring the intermediate 'void gen_msa(DisasContext)'
> in "translate.h" (this patch). The result was less trivial to
> review, so I went back to using an intermediate patch for
> simplicity.
> 
> Is that what you were thinking about?

Yes, exactly that.


r~
