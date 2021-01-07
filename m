Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638DB2EE8CA
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728250AbhAGWfK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbhAGWfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:35:10 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26201C0612F5
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:34:30 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id y17so7111154wrr.10
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=inqzMwIbHEhRmksZNhY+RmQT7ewMopiNiKoEKcrtGWM=;
        b=JiyCv3tdWrY+W5IV38jqazvljTzNfUHsq+psZAIQXltf092zx8U/7jnY6jFigsTLu/
         Af1im/EfzDETWNX/rNRlJpVLXZzgyCEIl5RTAHNMEnS8dkvmQwMXQ1DLwRcs6fvmDE3Q
         dAvn/d9HBou87Kw96w4UP6JHxJTfUDjU8G1ulVap8v8TU9F7RcXetfIIusAljjQvIA93
         hJQtWLac4j7kZsaLdmXvwql8Z13zvmV1Q+HS9ChBcj+2HFRLlDQDNzLsNGeCyUcm9z9J
         U6W6gtdlPG7/J+VxC4RSeBXpgU+S7Bp7T7H60QZDOB3zMpOoV3yAHKEANl5wzgyzJ5cA
         MbAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=inqzMwIbHEhRmksZNhY+RmQT7ewMopiNiKoEKcrtGWM=;
        b=g0il1HFMS1OBd9fSouTmkstrR+3dCPO2cVa+O0anWVJS5M1vStT0Sec8uECcUNSJiV
         V7s/kT+2QY54FLFrcfBfLIOoghAlztzdWW16H0paf9YHJp/Z3eieCCaN69Xuy8+IR2F9
         KSHHroG3ptB3WjAjqbFzfj6+v9ivMY2J+mXCrkC+6l3H635OahQVRFCbgVo4dZhjABCM
         NEBwi+bv3gb2P3mALeOdpDdv9Xx77XHs3U0Qv21VzXUwm+Ckuvq10UNp3fEOAzC1ezoc
         LPPTFHA+fLt/BUa2WRvYrze19TIuERgX9khsuyy/5fkYpodxcyVcZg2xBI4ZMvqo6MuD
         lRHg==
X-Gm-Message-State: AOAM533X90ByYrieiUko0hNlVEB5qYaJfOAVKA2QyQVD8ZHByJdQw4n4
        AnXvAoHG934LC6gRjq+x67VbP6pu1VA=
X-Google-Smtp-Source: ABdhPJycQl81Bme+Z5yIogCRUT3pvwazj0aT9qsxJ1Cd0z2OTNpcqKMmLAozmUsiXByrA4E1RpM5NQ==
X-Received: by 2002:adf:9b98:: with SMTP id d24mr720081wrc.240.1610058868959;
        Thu, 07 Jan 2021 14:34:28 -0800 (PST)
Received: from [192.168.1.36] (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id g5sm10477744wro.60.2021.01.07.14.34.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 14:34:27 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PULL 00/66] MIPS patches for 2021-01-07
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        libvir-list@redhat.com, Huacai Chen <chenhuacai@kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20210107222253.20382-1-f4bug@amsat.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <e658e795-63ff-eb0f-1ff0-dcf93fd77384@amsat.org>
Date:   Thu, 7 Jan 2021 23:34:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/21 11:21 PM, Philippe Mathieu-Daudé wrote:
> The following changes since commit 470dd6bd360782f5137f7e3376af6a44658eb1d3:
> 
>   Merge remote-tracking branch 'remotes/stsquad/tags/pull-testing-060121-4' into staging (2021-01-06 22:18:36 +0000)
> 
> are available in the Git repository at:
> 
>   https://gitlab.com/philmd/qemu.git tags/mips-20210107
> 
> for you to fetch changes up to f97d339d612b86d8d336a11f01719a10893d6707:
> 
>   docs/system: Remove deprecated 'fulong2e' machine alias (2021-01-07 22:57:49 +0100)
> 
> ----------------------------------------------------------------
> MIPS patches queue
> 
> - Simplify CPU/ISA definitions
> - Various maintenance code movements in translate.c
> - Convert part of the MSA ASE instructions to decodetree
> - Convert some instructions removed from Release 6 to decodetree
> - Remove deprecated 'fulong2e' machine alias
> 
> ----------------------------------------------------------------

I forgot to mention there is a checkpatch.pl error with
patch 23 ("Move common helpers from helper.c to cpu.c")
due to code movement:

ERROR: space prohibited after that '&' (ctx:WxW)
#52: FILE: target/mips/cpu.c:53:
+    cu = (v >> CP0St_CU0) & 0xf;
                           ^

ERROR: space prohibited after that '&' (ctx:WxW)
#53: FILE: target/mips/cpu.c:54:
+    mx = (v >> CP0St_MX) & 0x1;
                          ^

ERROR: space prohibited after that '&' (ctx:WxW)
#54: FILE: target/mips/cpu.c:55:
+    ksu = (v >> CP0St_KSU) & 0x3;
                            ^

ERROR: space prohibited after that '&' (ctx:WxW)
#81: FILE: target/mips/cpu.c:82:
+        uint32_t ksux = (1 << CP0St_KX) & val;
                                         ^

ERROR: space prohibited after that '&' (ctx:WxW)
#89: FILE: target/mips/cpu.c:90:
+        mask &= ~(((1 << CP0St_SR) | (1 << CP0St_NMI)) & val);
                                                        ^

ERROR: space prohibited after that '&' (ctx:WxW)
#116: FILE: target/mips/cpu.c:117:
+        mask &= ~((1 << CP0Ca_WP) & val);
                                   ^

ERROR: space prohibited after that '&' (ctx:WxW)
#121: FILE: target/mips/cpu.c:122:
+    if ((old ^ env->CP0_Cause) & (1 << CP0Ca_DC)) {
                                ^

ERROR: space prohibited after that '&' (ctx:WxW)
#131: FILE: target/mips/cpu.c:132:
+        if ((old ^ env->CP0_Cause) & (1 << (CP0Ca_IP + i))) {
                                    ^

total: 8 errors, 0 warnings, 433 lines checked
