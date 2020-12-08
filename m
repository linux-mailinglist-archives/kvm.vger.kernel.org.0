Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED99E2D3686
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731526AbgLHWyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731300AbgLHWym (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:54:42 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5272C061793
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:54:02 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id o11so378016ote.4
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=naAuxiTlTlYmaaUOq7EgPw6gS27NcD7+9riFEuxemwM=;
        b=uuUal6899hgmSVKJ8le8gGP/L6WssC+TCUwO/nBQkRKVKwOcF+3pG8sjdITGQr2dZD
         3z58+RRLtG1SV7xpP9e7UJh6OkRgGSsxDdG6vxqEEZLa7ESvk+viud/jTt0U1pkKWJ2B
         or6eFMVyyYtFz4QFD5zb+QWcDei7WWNVm6ZfRq9HXADej5NflhBbCcisYNf3buGjA8Y1
         qytFOAWQYZuwRqpSNq1sz7Z4e1KOcv92/CfS8SP39lAFDpjVeUEaRwh0NAWOkpWgUfO7
         9RY7pFP1MNR3EJMv/MwI0QEetNg463srIzlU6zziFTd4DcJvHbCDUXopKpXhR4So9l7E
         HDHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=naAuxiTlTlYmaaUOq7EgPw6gS27NcD7+9riFEuxemwM=;
        b=lISjcHMEPqd7CE5dzB+ZzO6TPgU5/fZS5SSqE48NZev124A84HIoyPNf0/oRpFUHNq
         hsgM6+eVP9nNlvCDdh7t0rRDkSHOYgPgbJ+S61PSZLHMa1Ig2dbaTRhnWIPSE5IhcTeI
         s8qVf4vYWfvdxMW3z/+5H9a26YY2Yr4KfcHk9ITFd7XnwfT1ajYN3SEZ3nIxwiGmLAut
         1kgsTvKamvDNDs8o6TapcjyTdMEY95LNpFjPXiNUp6YeXVGr9Fe4DLAfLVgu35uHyd7Q
         qG6Uzo/fzmtyrZDhhQRWeh8tr1IMwmxyS5gYoxYXorcDXwpQ/oGQe5A6Pq/1bklO2wJx
         ZeHA==
X-Gm-Message-State: AOAM531kzKuHA9zHmGbZ+WX9Hq2Jqurx6MZbRWfz9O0JfIKo4wGmbfRL
        2cgJQcXVNydAPze/JKrdRMnh/63ona199kVs
X-Google-Smtp-Source: ABdhPJyKBu6+rpCR7nBMhLy43ocWnnbE1kFSBn0xvq++ymwDW02SzgMmCaFAzNuZe/dQ2bjLbHP6Hg==
X-Received: by 2002:a9d:23e3:: with SMTP id t90mr285417otb.51.1607468041939;
        Tue, 08 Dec 2020 14:54:01 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id m47sm94136ooi.12.2020.12.08.14.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:54:01 -0800 (PST)
Subject: Re: [PATCH 5/7] target/mips/fpu_helper: Remove unused headers
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org
References: <20201207235539.4070364-1-f4bug@amsat.org>
 <20201207235539.4070364-6-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <f64ee653-02b0-7e43-ed3a-12aefc59e2ac@linaro.org>
Date:   Tue, 8 Dec 2020 16:53:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201207235539.4070364-6-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 5:55 PM, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/fpu_helper.c | 4 ----
>  1 file changed, 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

