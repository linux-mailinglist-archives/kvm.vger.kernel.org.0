Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1961873C0
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 20:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732488AbgCPT7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 15:59:54 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44119 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732436AbgCPT7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 15:59:54 -0400
Received: by mail-pl1-f194.google.com with SMTP id d9so8480709plo.11
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 12:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X1tKqmz/aUUBrpVIGZqEIbolTnTtNvj1VUuBBuqsIao=;
        b=O1XCsAUG7KnQFPKeGcLaEnNHnts31SOTIrdIbJu3e6fk4jvtpMrwmXunYe9CL6LPSc
         NFRAaX5PcMT+2dkVmzm3w97N841SGDkQwAZwnLoGrTArmAdrrbYKPpkXcJc9Hq/BtJXq
         EBlBNq0GKrwszdKdR18nR9ZgHoUlUoJe2lyorRroTRllKUF10Le6jDA9hn0pBmG84BVS
         iNZmv0Mmvs8RFJeelNzvaeKcv26SlVeQjoCDcQjFQeZ+2Q4cpGmflCydmJoSsVHKxbfN
         8SRhC5sfUZ4rivdreL5dDeuxEYQZIMVDQcGiMFdlyFalDEseIafZ+RgjfLZD04AuaBM4
         9Cxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X1tKqmz/aUUBrpVIGZqEIbolTnTtNvj1VUuBBuqsIao=;
        b=pYHmUHR4E1mf/ZtWkj8JnXemeSd9KpJDCVk0i9Gfcrj0nn5x034rA87/PEvN1DNZHV
         AIscU+6mdYFKs+cpQxgCl7Q1fYaDEsOXKWfsHRijAxcqpqzItAK2Ue6kGHrjq46BE3r8
         bILbQKoM9fSwC3CigV7dJ6wWSLY0BK7qOG3a2Ps4PSHVyvQ7YEkgkC7+mWaastRVihFz
         TtiratSj0SgXa1pGOQ3RrVJLU0we8QBgj8iVsy9z0qSfnX8cw6xXFCy7bcXcx6B0tm9K
         2TrT+1i8+4ReXa69sXkGTo8KYjguywy1KiZCJxqmOsEvwZK5+LRjH2CvClP15Y7AhOdU
         9vwA==
X-Gm-Message-State: ANhLgQ1TqGX0FD0azkpUQ9x7WCTAyNtFuyQaFzLydpCYJeICqPlq6PNO
        4X9H+Ao1fxqytvscWePYTJArBg==
X-Google-Smtp-Source: ADFU+vua8Y62HO68abSCHtVU6brXjQrZ4youYgBHnfTiLCJjZ9G81h3Y7J8Tb2KOdrRA4wWxqf1Xuw==
X-Received: by 2002:a17:90a:d103:: with SMTP id l3mr1232122pju.91.1584388790059;
        Mon, 16 Mar 2020 12:59:50 -0700 (PDT)
Received: from [192.168.1.11] (97-126-123-70.tukw.qwest.net. [97.126.123.70])
        by smtp.gmail.com with ESMTPSA id e9sm688015pfl.179.2020.03.16.12.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 12:59:49 -0700 (PDT)
Subject: Re: [PATCH v3 15/19] target/arm: Make m_helper.c optional via
 CONFIG_ARM_V7M
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-16-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <03a44ee7-bf2c-645a-d3c5-3a4dc484e6bb@linaro.org>
Date:   Mon, 16 Mar 2020 12:59:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200316160634.3386-16-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
> @@ -1,11 +1,5 @@
>  # Default configuration for arm-softmmu
>  
> -# CONFIG_SEMIHOSTING is always required on this architecture
> -CONFIG_SEMIHOSTING=y

This doesn't belong to this patch.  Otherwise,
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~
