Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C9C1873B6
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 20:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732456AbgCPT54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 15:57:56 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33246 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732366AbgCPT5z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 15:57:55 -0400
Received: by mail-pf1-f194.google.com with SMTP id n7so10560668pfn.0
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 12:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/ZD6IBSncn3hFN7wdM3J8776A5oAwPcS5286HEhKUro=;
        b=L6zk68e1i+2AgxptxWZqB+tahbSclBRmjTHT9k7BmgQbeRJtpXFgoVql/JY4saECMo
         +Tz3UYILj7ci6nVxw4AOYExOQ1HCuTC7IjuYYJ/pDFbfJ/8Gn93bYiDUUhubSs93yY2A
         CDboSlBf8/Vn5p8VSTphl8VpaNoTChZbMrD+fgDv6jflEpFmqLhRVXgNtm3bnI+fZ9OH
         +g54ozdmT9CoMZ43w1f8W3Rw30Ve3JFzSyTCeAxHoYpv1FE4hbFhC50twXHKV7IgkqhX
         2GBGr/18eVmWaLwOTf6FuwTPcKI7LY2yhFOG963t11jEdL/4AhdC62Dvq9FpAdEVuVX2
         7F8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/ZD6IBSncn3hFN7wdM3J8776A5oAwPcS5286HEhKUro=;
        b=rfpXIOiFaZwZaXGu/QTngojh8auUDDuPPQjlFxTrFcMfcR/tuTJ9sSmoUtJEBDZQp1
         3lQKmgqKQodX/gQ4VCLi4M2zhTs+PkTXNnOxAT52jA0V7pE14/ka27m639VS+ZnI1TEt
         UarF9gZT3sIkmUYuc/AWRJNFpMK6fct8WnH+fn/o5KyvsGujaeqVsM4LAEhYYwoFAKMe
         a2sWeKOVVxGCkv8NfviHyz7cHwJrslZFVxLhxDDZTVFxT9Qdb+us1lZOphWzZ+AhObxb
         xMkPOElVXeur5VQ6cSgKsjn/HojEnUIvzBP5ZR448hLmUnyLiEWbvc37P3TRqo6OUjgy
         rh4w==
X-Gm-Message-State: ANhLgQ3wuyjcNdyFrz+yAvoBenfK2IR+JjMTFvHDiwoPL5D32C91UgsI
        3ghMXaT8DEV3vRLKaNy2e3A+rA==
X-Google-Smtp-Source: ADFU+vtAxoh3oD0q0HO9joInGqS1LhMAVfwaEPgsfQZbtnWC293MC0TDFomQja9Ca3QFZvEm1fy0/g==
X-Received: by 2002:a62:e505:: with SMTP id n5mr1351882pff.189.1584388673109;
        Mon, 16 Mar 2020 12:57:53 -0700 (PDT)
Received: from [192.168.1.11] (97-126-123-70.tukw.qwest.net. [97.126.123.70])
        by smtp.gmail.com with ESMTPSA id mq6sm575473pjb.38.2020.03.16.12.57.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:57:52 -0700 (PDT)
Subject: Re: [PATCH v3 14/19] target/arm: Restrict ARMv7 M-profile cpus to TCG
 accel
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-15-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <2b3493eb-2e15-a5a1-5034-785345420a89@linaro.org>
Date:   Mon, 16 Mar 2020 12:57:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200316160634.3386-15-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
> +static void arm_v7m_cpu_register_types(void)
> +{
> +    const ARMCPUInfo *info = arm_v7m_cpus;
> +
> +    while (info->name) {
> +        arm_cpu_register(info);
> +        info++;
> +    }
> +}

Likewise wrt ARRAY_SIZE, otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
