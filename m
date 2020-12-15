Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AC72DAEA2
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 15:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgLOOMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 09:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729100AbgLOOJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 09:09:37 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5FDC06138C
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:08:56 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id a109so19415723otc.1
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 06:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YRXyO+7TnIaCnGdr4kG4wDB6c58pWaVj0j0Ctcy6nPI=;
        b=vsMbo+tXy3ffLUjvJqYwzi7ZK+zNhPwZAwn8sZvWmQBQqlAZL2WLefDVpPkgq1JJa7
         DYB3q28JAqKMWU2qWLR/BH2OA4on2uY58isZuiAL9sZ6b3k9zb7E5Gpx6fB467isUinH
         nbM7jM80gAK6F08KS6sdD9GZVcFtw8sanpwm2rYYW3SHNlqBVQ3nhPecZ+8gbjcJob7z
         ZpQBXHSe3nNK0VWcDdvdw17dMmwvUYnSJiIyp2gZ3si8cNFWDnRdhfMlxkBAo4QBG40h
         Gs9V6mpCB1/sYSPCC5BWbYG9pj2i/s/fmt7/3o5tqYi4UqqnIXao8+R5obGlbRFgiW2h
         Gahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YRXyO+7TnIaCnGdr4kG4wDB6c58pWaVj0j0Ctcy6nPI=;
        b=FBpHzOL4LUA2U6Qv7BmdbB7PbvUjm/i0ktD/v1gGpNGJOpbQI2ZwgjBm82aenT5KAh
         3Y3ZgjKlDQ62GcFGSP4q1+zDHWtDXy3lBcj9aR55QPpn9AsPRHRWQ7zFXlFb5NQXvFQv
         uqJT7JJz2yrQqIcwNl9EeYSj/WnHxHYwDQ3jkgeAeoSY0P281nFHYZ5+J5QuIMpDy4RS
         49KeRtw8s1XXAvguBvK+48xRMpc23npyD1ST5NW85fzis788Cj7vcGhGTFE3OXwdWtaT
         sS5HIA/t+VwczfhmhOPJGO3DtAy25D6m+p+rBGtAFu/UzcquWHwUQCUiC3huqrpwirfB
         km5Q==
X-Gm-Message-State: AOAM531MS185MhZr6sNYMp7d9hTJSmXSDF6Zp2C2ABaQJrd9EReHJeCw
        POlhBcLolhVaOPGaI4aCNaqXYrBDnzmhVFCG
X-Google-Smtp-Source: ABdhPJyL3XxZCFlO9Uijv0lbYFXcnldsMAFK5r0ZxzlmranPzNLFSzPLcGeN55XnuP1qJz6Y/8/E8w==
X-Received: by 2002:a9d:3ee4:: with SMTP id b91mr16441000otc.86.1608041335605;
        Tue, 15 Dec 2020 06:08:55 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id r204sm4799797oif.0.2020.12.15.06.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 06:08:55 -0800 (PST)
Subject: Re: [PATCH v2 10/16] target/mips: Replace gen_exception_err(err=0) by
 gen_exception_end()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201214183739.500368-1-f4bug@amsat.org>
 <20201214183739.500368-11-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <849d30da-dfed-e588-4c7c-c140acebef4d@linaro.org>
Date:   Tue, 15 Dec 2020 08:08:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201214183739.500368-11-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 12:37 PM, Philippe Mathieu-Daudé wrote:
> generate_exception_err(err=0) is simply generate_exception_end().
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/translate.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

