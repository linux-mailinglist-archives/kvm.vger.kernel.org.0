Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E7C2D3643
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbgLHW14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730547AbgLHW14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:27:56 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1168C0613D6
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:27:10 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id f16so273938otl.11
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JdV5HFH1CsNDl8vIK1ZMy6muRFwgCtO/GfwxqVPAO6k=;
        b=dme4hkrQJfiveN1lvkRdeWn40skS4aHHpI8VfYAvn86cZs35lSVRHqksAtSNtW/OX0
         lXEe8+Y0/U/qbuwiJPpwpDo+rfTEtm+Ngq3+IjfBZm8DHI7cA9vM6T4tE4sL5QdfPA1u
         W0ZT5t/5apfRuymh4Utt231BvhrKzcqecYDrp7qqchPuLKa/K8N6xvzLKRniKgktHGuA
         fBiDIhnGU5663W7STpmboEmAUGJ62SKXBsE/RFDTktu73rkqMUh3D7iE++FH3AosM6MD
         v6HwISR3yrDIwNq6sLmEgiIZ94ZCdg2Oiw8wPhAa8sMpcLdmf3IsAyXcYALS6MBvFvKn
         tyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JdV5HFH1CsNDl8vIK1ZMy6muRFwgCtO/GfwxqVPAO6k=;
        b=jPRa39ApHGh/QTMJQVwagUNyGDq+JPZ5e4/hIudVr798AZsY9IfKOBsPTs/KPjEzmB
         o44FonsxTmb9k3G1X/VMNi0drkrX08ShtRAWkEL8cn65xOH2dgtGbrgyTwpP7RIqALpb
         e53NGgUAk9AUNsJuhk3h9zN8sg5U0fwesClP9+vkVsCrrfLtYjZTf5pxdvChxQYgQlSn
         Beya2bdn7OWaRdOWI7y2sXpsps7yRYi7xg279NeE/iHKA/6Bo0nfSGxU2BytULSK8xHL
         BzZy9rK23ip1+0i/yyPAJeQgYWHkWD874C0tkTGs6J2IiIjiSiA9cxPN3f4uBiYh/j/Y
         TwMw==
X-Gm-Message-State: AOAM533l0+Nz8n7eSwWUqlpZkXrjbY0l2Jg0LXBb9R3TuJRBeJoQxh2X
        Uz98/apxvIUjeq1msbzxqehsnA==
X-Google-Smtp-Source: ABdhPJwCzNQPWH8lhh+t1Zw+YvMtu6ySnRpW66Zw4EkvBTtFFLjlC2hJLH/tvUSamr7kWfKqLghI8w==
X-Received: by 2002:a9d:7a48:: with SMTP id z8mr243937otm.146.1607466430169;
        Tue, 08 Dec 2020 14:27:10 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id l132sm32412oia.23.2020.12.08.14.27.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:27:09 -0800 (PST)
Subject: Re: [PATCH 15/19] target/mips: Move cpu definitions, reset() and
 realize() to cpu.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-16-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <849b84a5-ee3d-daf1-4de2-cb5942eecbd0@linaro.org>
Date:   Tue, 8 Dec 2020 16:27:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-16-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> Nothing TCG specific there, move to common cpu code.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/internal.h  |   4 -
>  target/mips/cpu.c       | 243 ++++++++++++++++++++++++++++++++++++++++
>  target/mips/translate.c | 240 ---------------------------------------
>  3 files changed, 243 insertions(+), 244 deletions(-)

I see translate_init.c.inc is handled later.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
