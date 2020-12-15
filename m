Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC6C2DB6F5
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 00:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729063AbgLOXMP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 18:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727106AbgLOXLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:11:36 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D60C0613D6
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:10:55 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id d8so21113166otq.6
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wTMQDLsyjqLUPdBjNd2tYsE4oew6FnlOhnAcVZzKNgU=;
        b=Xpc3DrAJ4PRP1g8NNA95kpEHtyrpHPvJaGCBbofubsxIrI7kjaSbqTWWPvWeqXFtW0
         +0WWKGn8hMRkHXeoa63PiY3RnhcraTkHJ3ecW4daktBOmGCjmTsvai5NKIlvm1y7o20v
         i5TV/EVXy0nmGx6J4O/u49W1Px6d+sijPRq01B+KU2/bfyKgs3ftdunXshclQox9eNwr
         AC+8caMMhjRdHaKjLS44LzV8SZD4+Bu0ObTfEaUhEzAXpb2pVuaqSWbnrxO/rFQqAo+j
         zFjgIdxK1LIXV6DV7m+xY1MclAPMutdO6W6yK7lM9wQbqOuhkfYbQ7gEEEP+QrxKNVPC
         GOsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wTMQDLsyjqLUPdBjNd2tYsE4oew6FnlOhnAcVZzKNgU=;
        b=IdAIj0liRcyW/ihDFw78j02G5S57FyIVbbPgTckPF0HEW7+bg1M7aD4/JxvqfkFtSM
         W7KZavRt6iiBTnwdFitVBmexNXpJ3C7FZtiz58/PDaul7RuW1MQ/axH9MmnPkp6DzNQi
         Id0pT0j5Ar0yRgF6WPfdzf1PmcBnocCEUTwkqOnaQg8G7DIOtxmK5Dkk0JqHbrwbM/aJ
         AeYD/PVhURqUs5GPF9guENtho8HiCe88GvoNkL/nq6j/r9pkP2iCSQm0GTMv3P5+gDBM
         /dmptf2+QZAk/Zq38HicS3Y0u1mnD7emL4jbKYGYpJtzlBfp5iceZNU2X1/nPplb/kfM
         DGLQ==
X-Gm-Message-State: AOAM5304h2jxMQVYDvnuiqhLoIEEb3O8XQ9UM2F6sAxROr5UCiRNbgzH
        VFpDaJTTeJqveU3A4VxF/pUJjA==
X-Google-Smtp-Source: ABdhPJwqtGGljFISM+gVi4Q2iK6ihzuMOgL1IrxJPWgK18uVDmsw7qct1hUIIKFAYWS0mCnlfNN8KQ==
X-Received: by 2002:a05:6830:458:: with SMTP id d24mr24416668otc.163.1608073855396;
        Tue, 15 Dec 2020 15:10:55 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id d62sm75839oia.6.2020.12.15.15.10.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 15:10:54 -0800 (PST)
Subject: Re: [PATCH v2 17/24] target/mips: Declare gen_msa/_branch() in
 'translate.h'
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-18-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <00d52bce-ad68-6465-cdc4-e34faa6cf4d1@linaro.org>
Date:   Tue, 15 Dec 2020 17:10:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201215225757.764263-18-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/20 4:57 PM, Philippe Mathieu-Daudé wrote:
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
