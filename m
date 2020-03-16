Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D42181873A9
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 20:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732480AbgCPTyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 15:54:11 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38010 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732436AbgCPTyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 15:54:11 -0400
Received: by mail-pg1-f196.google.com with SMTP id x7so10330499pgh.5
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 12:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J0uobKBgK4rHZ0hjWoBdZkci++dbIcJWriw2kCPQsXs=;
        b=VBoYJfmuvaGBrugdO/DrCXhiDIyTOTxyjk3+L+oRn/eFQXQK+YHtv4UMbvsiMAbZP2
         23y3Sgp5psLOea82yutv9iU8nulEA6PIOHKyZzWf3FYu1Eq9QTNxkrAQNXA/FusCZsBQ
         pHXuv/DnAeYNEjXoLBMtdhZIIkGq/8+0WKUUxFohhFFTycwg0kDBx7N6YJtoNa591ueC
         oHTG+OSIf/8BwaspwHEnXCwd/VNNyICWMyqEKj8CWBbVQGrC+E/A1JIBT2ZEuRN2WlDj
         548E5I0aeW/O+F0Goih6831O4k5Z12z5vrnW0pVVwihckLJPa6Z6W7huUE7ak0g3VmJz
         VCqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J0uobKBgK4rHZ0hjWoBdZkci++dbIcJWriw2kCPQsXs=;
        b=T3KE9QAByEkLuXd9lDqUrB88SmXEVHAvHWlMMxDxwR9bwrT5E2/xKJxOQcchPoro+P
         4iSOh3WASCqYwMU2kkHSbiF64NYZM+lDtIK2WWanRNvlKRFf3Ho6GSHg6bsqs+9/VpXl
         cExToQ1uVwS8aTbB9/6OC6nZmk2I4pEDLN55yyKqXKhkU0H2A41SoUzPwXLXKM4yrclw
         Bwk9avH82GYufdFFkdImyVDu4u4vWs28hmLt0A86Wo0xgekiBrhAGvXsC9SxT0vxPusF
         tTysMPKdEIfHV4MJmD8lRPx2yTGNze5k9yy2/9I4FDe2GKcYddrz6ZwkZ0O1iQYvCCPf
         j95Q==
X-Gm-Message-State: ANhLgQ3iRog6fwtDdRHaE7XirJyneUXKRTt/2jR5XvyOlfuR5I37HdbI
        zYs0jLVG2gOXe5FuX8p3UZBydw==
X-Google-Smtp-Source: ADFU+vszr2eVMxAjcMPZzWWCPhhjw6Y5KImoake42lZ76b/FAthTjOmvFTNUgtos8pANIhHmIZiLgw==
X-Received: by 2002:a63:3547:: with SMTP id c68mr1425842pga.380.1584388450100;
        Mon, 16 Mar 2020 12:54:10 -0700 (PDT)
Received: from [192.168.1.11] (97-126-123-70.tukw.qwest.net. [97.126.123.70])
        by smtp.gmail.com with ESMTPSA id p9sm538444pjo.28.2020.03.16.12.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:54:09 -0700 (PDT)
Subject: Re: [PATCH v3 12/19] target/arm: Restrict ARMv6 cpus to TCG accel
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-13-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <e3728368-4c23-ac70-949e-d02ea698887a@linaro.org>
Date:   Mon, 16 Mar 2020 12:54:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200316160634.3386-13-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
> +static void arm_v6_cpu_register_types(void)
> +{
> +    const ARMCPUInfo *info = arm_v6_cpus;
> +
> +    while (info->name) {
> +        arm_cpu_register(info);
> +        info++;
> +    }
> +}

Likewise wrt ARRAY_SIZE, otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

