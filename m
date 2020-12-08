Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9E02D2FB9
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 17:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgLHQbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 11:31:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbgLHQbX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 11:31:23 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BDDC061794
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 08:30:43 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id jx16so25395481ejb.10
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 08:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O6d8/sZG3A5xoCVUYV5vAwfGwQR5n1cU4F9BmRSseSk=;
        b=BBxVb3vGtsOOtw1311vylJ0YOChBxANfKrMdmycMi3OAvUTVGMpZ8SxbJIsm+sVepb
         AdGNKypDNFvmwhAwK5Q0GK00Ya9hCOCShhZPg+ZZQQOtIrw0vxUlDmORxCdcviIsi2S0
         9n1ErNx8knmMJesNRhL8zfo7fdLRwmWAWV6foEgmJYOcAyQNgfuM7m4u1FC/RjE/ztRx
         kD2vpyEHGiMzUKCuVh9ix2rcIqJ6WIy5GBKBkRZKRidGk72i03dnLpJ6Qok2fgXXLcpE
         gHAFrJ5HwX6wIUBNEs0JoBm4bYbxM0/Smq7CVrlYhfC9exhpmPwj4bQzyE8Igmrwm0cP
         z2eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O6d8/sZG3A5xoCVUYV5vAwfGwQR5n1cU4F9BmRSseSk=;
        b=LGNwfBR4E95AhwvKOKt+n4NX3/g19wzvtJRbTuhcLEA+Zi6P5NHUixi8S2zmfo0cSa
         WEEa0Z5iEcdBq69wFlk4jv+M+uc1TQFPeI/G6ajdz7g8i+8oVERJcDrUvfPT0TFHYm6B
         DhydcvC8DyJ/EZzqcMZLoDhXB8sszEFwla+7mbuYNUkv9230X9gHEEXSHtMVRj1FrL0p
         bEWmeCqR2XbfXAhZh7uAvnt/EDxM5EL/A9jStOmU5xDpQuppyQCKRhJ6YuPCXG25xGd6
         YeQVM5HtKlmdHSWpzNKTIi0+fIdOkULke2eYL5HrOuSPWSc0SS2yZIryCef3SVKNTRBT
         ZrmQ==
X-Gm-Message-State: AOAM5301X2rJr5HchC1ND5kvao/AVuh8gdwzZDR8nZQ6Ii2s1QByEyrH
        ZsHTwxSoScJ0q2AX3oFdHIM=
X-Google-Smtp-Source: ABdhPJwNNItsXNMXYvb17v+JQzXFi1XmjmQaADDh0N9cTR9eyEJQ3Z3KTUIRhwUpmN3smg77Pjv7ZA==
X-Received: by 2002:a17:906:8354:: with SMTP id b20mr23948190ejy.397.1607445041952;
        Tue, 08 Dec 2020 08:30:41 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id t26sm16081856eji.22.2020.12.08.08.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 08:30:41 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH 00/17] target/mips: Convert MSA ASE to decodetree
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
To:     "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20201208003702.4088927-1-f4bug@amsat.org>
 <CAAdtpL69-8DEYb2832fcZosNjMogPGt1a9HNT7NdLVvnbKZBFQ@mail.gmail.com>
Message-ID: <489ecbec-ca9e-85a2-b0c9-508319a25288@amsat.org>
Date:   Tue, 8 Dec 2020 17:30:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAAdtpL69-8DEYb2832fcZosNjMogPGt1a9HNT7NdLVvnbKZBFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/20 1:39 AM, Philippe Mathieu-Daudé wrote:
> On Tue, Dec 8, 2020 at 1:37 AM Philippe Mathieu-Daudé <f4bug@amsat.org> wrote:
>>
>> Finally, we use decodetree with the MIPS target.
>>
>> Starting easy with the MSA ASE. 2700+ lines extracted
>> from helper.h and translate.c, now built as an new
>> object: mod-msa_translate.o.
>>
>> While the diff stat is positive by 86 lines, we actually
>> (re)moved code, but added (C) notices.
>>
>> The most interesting patches are the 2 last ones.
>>
>> Please review,
> 
> I forgot to mention, only 4/17 patches miss review!
> - 11, 14, 16, 17

Full series available here:
https://gitlab.com/philmd/qemu/-/tags/20201208003702.4088927-1-f4bug@amsat.org
