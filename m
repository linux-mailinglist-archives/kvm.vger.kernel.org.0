Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7092D3600
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbgLHWMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728147AbgLHWM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:12:29 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9F7C0613CF
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:11:43 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id o11so277434ote.4
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b2C+HWDM43GOsU1SRUMnDSewUrX0ur8On93MW/ehQ2s=;
        b=AcjOBK/rmhGFw8hp5XO1ilO86Pt7OUam1wVa/jIeRSpLmwc1ZKmGTi5hGesRj9b1ra
         jyTR265P3Uu9xwydMd2HvJaP47ZHp4OmtU20U6XQ4Znm3ZzJgXgV9lSXLZFlbf8zpKCb
         vIFlYik0Lv2h2FC2tpy52LQ/fNfP4m6UReBDXjDf2SX9zzRI2PXQJXpxiHPb269apekq
         wjuD+rVnMYhP/2RgqKZStxUqJ3vooypyftjoEGHbrs3PVg26Ly1O1O6AzaIxJUwU+SGq
         AE5qGuYu/CAK3lBmHxisyyB+KcH1Vwq/DFXGG0QFCs7JCj+Q4MIsQvS86a02SuwMSsdF
         PTdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b2C+HWDM43GOsU1SRUMnDSewUrX0ur8On93MW/ehQ2s=;
        b=lEPNMdEHVjfMdXalLHCsF2pCyq/Tg+t1tVZEvmGsUT5wFazFhMBCbHZCT0j1AQuyQt
         +4e85oWzN9yxBXCpAqEtUM0Vpt8eW5M8hsMlpyx8JWDWao5LWk+xRlIXK7MEEi4EQT+/
         bGKfaWfN58sKK/OUcnHmigx0joeVlISUbxeYRJgV4KHUqqhgtfS1uSAlOYuAB8akCcCB
         rjZ9cwrQ+v/dqqeY3PiZLS4mPclU+HS+ILd9fcJ0q+EjvyH2aKpL1T01G01dyNC5Xnon
         G2MLcsXYBAcjHWjY6jTWMy/sz35rQNWWjiUH512mE36dds90AwasuUNCKv7cJdbxwlFB
         JzIQ==
X-Gm-Message-State: AOAM531R72qyB0BUNz6qKeI30qC3dkAEAgfO0oKgVaLTTYrC3t1efm2S
        EXklI31FLw1MM/6E0SMdGoOO2A==
X-Google-Smtp-Source: ABdhPJxkEDlh4O1scIg1AjQvG5hEe0Xiqb+MWnH5kdFDAGyeJYI/qHa9N9rZ75RDIWv5GZHERR1zpg==
X-Received: by 2002:a05:6830:1352:: with SMTP id r18mr153887otq.73.1607465503236;
        Tue, 08 Dec 2020 14:11:43 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id t203sm20829oib.34.2020.12.08.14.11.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:11:42 -0800 (PST)
Subject: Re: [PATCH 13/19] target/mips: Fix code style for checkpatch.pl
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-14-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <ba22f3db-9afb-b4e1-5c19-1d9f5ff000fd@linaro.org>
Date:   Tue, 8 Dec 2020 16:11:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-14-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> We are going to move this code, fix its style first.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate_init.c.inc | 36 ++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 18 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
