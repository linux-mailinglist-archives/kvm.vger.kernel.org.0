Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC5A1873DF
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 21:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732504AbgCPUQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 16:16:36 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38436 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732448AbgCPUQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 16:16:36 -0400
Received: by mail-pj1-f67.google.com with SMTP id m15so8580642pje.3
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 13:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FhITnVcXOIhnDs6uomlU7NICQahFSW5Nno5Xh6Sq2S4=;
        b=FoJB4AMPXLMvqJ/PwEVqdjzE4axxigJIAJXVIgptDfwHvaprZTEE5YOdc/y1goBOvu
         4ZZaQY5MzFzgkwfBhc4G6K7luBCzEvSeoGcAaYETYA7PnJtCwMVh8x/6uMPN5r/rJgGe
         YvRU50ybHtZ0mOlJF+eVXe7HpEaZrykr6uypERcyCu8bFl/CtCsdL0lE+IqAYOw0mHse
         AftV/lzKuiYcwTV9dV9xl96SMyhsFYDe2VXitZfHl2W6PrAaSmtQp92OiscOzfWMIIXG
         1Ek0faM4ssdTahTxkQcazBtwMjZurKMef+/NGaY6EsxiQaKqFpYLIQQbwlUIk/7+peV1
         mfuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FhITnVcXOIhnDs6uomlU7NICQahFSW5Nno5Xh6Sq2S4=;
        b=CHWKUs30Z+rEV2zbyKxBwUH1nh/jqOQsPicX77G9Vapb5KbzWLwqIAhKDGizQjhc3b
         GhcCNDMvlgSqnviu8G9iyS+5aZH+Lvon9sO4qTrJa1OHtWOojNj3EopOXMYbfKM/xmeB
         fqw7vSKuS0AoNb91v5UyzUY28pUDzbYj6kUEGe65rO7NSV/TasIPC5zzPukoPwFsouvv
         xD6kXfkLQ5XmZP6noaIyh84/tt1eZRT04Sl2K1ZDxk9DahcOFi0JReotcNPXYHYjLUfg
         9cwMqDgbRpXyRmuDqfmAv2l1gGlqnkHarapuL3g9ZJPeRZQGsUGvs2R9lcHn7hhcIy3I
         +4Qw==
X-Gm-Message-State: ANhLgQ3uPgNN0UyqM3xhYt20Zd7q42O0d4CrcjHpXpIIB9xGovXhO5nr
        y/dgW1Fr0kEN3KH5E8CkWAp2hu7DGxM=
X-Google-Smtp-Source: ADFU+vvXz6vFHeF1yKbPbpgcnf+53vX8VlT/JrnRIIROKRDHpkh55asOanh1rtAanRMRpWVarvC1uw==
X-Received: by 2002:a17:90b:d8d:: with SMTP id bg13mr1312350pjb.29.1584389794888;
        Mon, 16 Mar 2020 13:16:34 -0700 (PDT)
Received: from [192.168.1.11] (97-126-123-70.tukw.qwest.net. [97.126.123.70])
        by smtp.gmail.com with ESMTPSA id 67sm677082pfe.168.2020.03.16.13.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2020 13:16:34 -0700 (PDT)
Subject: Re: [PATCH v3 01/19] target/arm: Rename KVM set_feature() as
 kvm_set_feature()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        qemu-arm@nongnu.org, Fam Zheng <fam@euphon.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
References: <20200316160634.3386-1-philmd@redhat.com>
 <20200316160634.3386-2-philmd@redhat.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <cb3178f1-5a0c-b11c-a012-c41beeb66cd2@linaro.org>
Date:   Mon, 16 Mar 2020 13:16:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200316160634.3386-2-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/16/20 9:06 AM, Philippe Mathieu-Daudé wrote:
> +++ b/target/arm/kvm32.c
> @@ -22,7 +22,7 @@
>  #include "internals.h"
>  #include "qemu/log.h"
>  
> -static inline void set_feature(uint64_t *features, int feature)
> +static inline void kvm_set_feature(uint64_t *features, int feature)

Why, what's wrong with the existing name?
Plus, with patch 2, you can just remove these.


r~
