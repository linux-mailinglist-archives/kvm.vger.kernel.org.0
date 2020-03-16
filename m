Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 787D11873D2
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 21:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732543AbgCPUJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 16:09:17 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39594 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732448AbgCPUJR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 16:09:17 -0400
Received: by mail-pg1-f194.google.com with SMTP id b22so4352650pgb.6
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 13:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iHWNGHwZg0b9gZmRRuZF0ElUxFU5qu0I08unHCAlUTo=;
        b=CmE9Y6GIRrEIFvCBFwc3pmjmYPqQ/MY52zfMZfNZMTcbUXhyZGGYlCZi0eVCmBVCIP
         UjA7lYlBipTKZTVo2Gs75p76wj/pRrheSrHYLUmItGJcc+gqetzboJpaJBUaGIrMSgAN
         0FTeLyZVjdPXRhJxsu6aNeWE1kO09Ftpzk+QceM+nx+SJOTKhUlrVD1tm8IBRwwNjTPn
         h49QreqTPOmHVcyCcpZqMeAgcqRGf1qVvtY4LK0JhEN3VxFuXWoCY9XltQgKBGVzsLhg
         yvm6EGvbW3L0mo22l2kWROnd/oYRhTsA4zusQ+fQfoCFE5QZys27szf2nvMqOxshtxjM
         BWMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iHWNGHwZg0b9gZmRRuZF0ElUxFU5qu0I08unHCAlUTo=;
        b=MLS3sJ0ogFlLBRmYTU0+OaAQ31Tupg76XqNVXgB/3UBwrRI4v8PRvoNSdsfTSsAFTg
         YwACtIx/swYSzJf8H7lzF4741zez1Z2Cmg/wBjeLfwbixUnvnIZ0MGXMBXkxPtE4a25s
         GhCBisbV1j32btg/3kfY7yrrm3/e2zSCmmT2UzGmIUkajdLcd9WlPkWi+PoFQkKm1JhF
         4QSROkEVuB3HHtDlVxZFGUyxuhBx7U8GbexepbGCflS+gWQleK+0PVEJ8rr1XdTi7Pdn
         gyjPQ5x2MwikwohK4RTD/7uA+WM53qYatR1WArlFxAKasjtPCVxQRRQx97YaOKa1rngH
         liLw==
X-Gm-Message-State: ANhLgQ3BumVz09JvxCuFvGlgxwXTkkK2Ke2KdAHrDz4O1jz3BSJbPDio
        fu1XZIGr1S5Ge+9kW38CUuZ/FQ==
X-Google-Smtp-Source: ADFU+vvwIq9UpPBuFyug8mpIP8LNVAnbLWqF2AkU3+pV85O/b7C5pVFS7sPIzV+bLSU23jKDsIvnSg==
X-Received: by 2002:a62:4ec4:: with SMTP id c187mr1376639pfb.223.1584389356184;
        Mon, 16 Mar 2020 13:09:16 -0700 (PDT)
Received: from [192.168.1.11] (97-126-123-70.tukw.qwest.net. [97.126.123.70])
        by smtp.gmail.com with ESMTPSA id r186sm685696pfc.181.2020.03.16.13.09.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 13:09:15 -0700 (PDT)
Subject: Re: [PATCH v3 09/19] target/arm: Move ARM_V7M Kconfig from hw/ to
 target/
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-10-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <d09210dd-2837-1fb3-2dc5-c17c2f86d908@linaro.org>
Date:   Mon, 16 Mar 2020 13:09:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200316160634.3386-10-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
> ARM_V7M is a concept tied to the architecture. Move it to the
> target/arm/ directory to keep the hardware/architecture separation
> clearer.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> ---
>  hw/arm/Kconfig     | 3 ---
>  target/Kconfig     | 2 +-
>  target/arm/Kconfig | 2 ++
>  3 files changed, 3 insertions(+), 4 deletions(-)
>  create mode 100644 target/arm/Kconfig

Acked-by: Richard Henderson <richard.henderson@linaro.org>


r~
