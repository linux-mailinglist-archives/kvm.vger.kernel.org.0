Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57752D373E
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 00:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbgLHX4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 18:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730710AbgLHX4P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 18:56:15 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64173C0613CF
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 15:55:29 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id q25so472257otn.10
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 15:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=in1cgibS8mfB63jOjh9ssiTrUqauLz5o77iYCzjNbTY=;
        b=qO8U3nr4f9PpcL3OUo3MBn35zBBGz+dPN/upiCFtQewNKn6UmGfabJ1ANDdwgM9FAI
         ohXGZULAi5Gij0kWJAA1LtEiLnzVIpSxGH+oLLm61/7AeyJmlNYzIvlabUWLYe3Pw2Qh
         gTVLiFhep559mEMZ894mfD6oK+Ra8TBzpAjXCnuCkf9tvqjCEWLAPqf39KzRp1UYAfI+
         lgeP8OViZ7yJjZVZTIxCeOAZjxPiCxIgovvujJfOiFINDyXH/hdXkw4M2ezhhd0271ID
         70JyqWYQvpkWbFHjZWeNyLS0LmL40bOD2lhycBwZtVnoRBT9d5zbjx1FKR5GDvSKgspd
         l6pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=in1cgibS8mfB63jOjh9ssiTrUqauLz5o77iYCzjNbTY=;
        b=TTnyC+zHPSu8UL6h6IV9bF4gPJzucN8OiWzZacpYVLBb7h8i9jEJOqoekGgP3hhNhU
         Wco/jsVj/UuZPNN4jYtmu1RP6ENH+r75ELAv9+Lagyw/Iz2jhgWgNcvJnmfjAQQoeWK8
         LUwuPrOKTJzHCglRBFC+dfWjgVg+K5ycaR6as7Q9B2nNeav/P+XgpwZVYmM2B3ySpSYK
         rAPlMbECgOw7ojZm7KngAdschJS+4PLtv8ga0iNNWxSt5Em8/nKLyHe28p2cfbQmAD0j
         YsGfdYnweegeAM5gLHt7ekim4T/EfQoqBsNVAUAOwGALPhnXvt7MB0aURDHsIm6EbIJa
         6YzA==
X-Gm-Message-State: AOAM531CgYhMzRtjeDENh130HYFRNXaNExoKUsU8PIdcdcYsIMbS5Clr
        msFb/jRnDRqjnpEe2WQxAg0nBA==
X-Google-Smtp-Source: ABdhPJy2R+cvCFa7QJFtR0bYqwWYUD5y0el8HP6/5ia3sxCMJQTP8glNuiuCYpw+Il/WVvR/jAYi3Q==
X-Received: by 2002:a05:6830:1c3d:: with SMTP id f29mr479570ote.47.1607471728854;
        Tue, 08 Dec 2020 15:55:28 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id c18sm84135oib.31.2020.12.08.15.55.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 15:55:28 -0800 (PST)
Subject: Re: [PATCH 11/17] target/mips: Move msa_reset() to mod-msa_helper.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20201208003702.4088927-1-f4bug@amsat.org>
 <20201208003702.4088927-12-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <503795ea-e68b-a78a-d65f-39cce13a619b@linaro.org>
Date:   Tue, 8 Dec 2020 17:55:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201208003702.4088927-12-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 6:36 PM, Philippe Mathieu-Daudé wrote:
> translate_init.c.inc mostly contains CPU definitions.
> msa_reset() doesn't belong here, move it with the MSA
> helpers.
> 
> One comment style is updated to avoid checkpatch.pl warning.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/internal.h           |  2 ++
>  target/mips/mod-msa_helper.c     | 36 ++++++++++++++++++++++++++++++++
>  target/mips/translate_init.c.inc | 34 ------------------------------
>  3 files changed, 38 insertions(+), 34 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
