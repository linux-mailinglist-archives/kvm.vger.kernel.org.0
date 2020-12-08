Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A251F2D35B4
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbgLHWAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728964AbgLHWAb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:00:31 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF28DC0613CF
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 13:59:51 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id y24so252562otk.3
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 13:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0P4LgLAwd23RvZRpXo4n9bDoeMvsbtK2X5N+B4o2WS8=;
        b=QKk+zgC0v/TuRgR0tH8ShBc9XymN0M/NYnr3xrXjOvokyOJO9wsHjkcg20MNSEoqoR
         sOGDIN6uGqD2XMo2/QYk0xeQeTaubkROAB7UuFPkMPZB8b9sWyPX38Zaofmtfi050idT
         nFQeDqVyO3t3pcijnADFuRdlCCsIEQuVIYk7y78Wn67dXA43tb3wxxZKE/VKhIzO/M0T
         r4bQNSIyTVAMjTqG6gkq/zqs8c+i7RQ81DK1lx37hlJwpHSIQgc69YVBTElJSXZG828P
         3UtKbNGz1ssgx09csY470X8PARUPJAT8Bl46UbXof7K7H9APlGm3bPjqu6l3iWImV1t6
         tdsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0P4LgLAwd23RvZRpXo4n9bDoeMvsbtK2X5N+B4o2WS8=;
        b=KiHAlfmswvjLnL0aTbx8SHwweZm9DvxmYrb9OKPL4Y+EweYy9wDZTBKBXqB++lYann
         Xth7O3TKd6S5DSsYpL4J1FiEL0wvO3+LGmqCA9husnbIjObrRB440KRFlJ56yxq0g108
         ms3FmhxKjCIw7emjBEgbHDueV7mW7awS725wkUJa03u1JYIKeKsjxOl+ddw0PO+6wd21
         UvOTMDo4L5TCmAsMLrHoGPzaha3MlAxWqkFMxJtC9PbaPw+Ydwe9KcqtfPrv69UJ5qC6
         k40y8CgrBYZSF7x5QY/cTLZtdqjaytOVYwf0ENGUX3OLmIPHgr8bBDq9Lh1BAkjimG94
         L1gQ==
X-Gm-Message-State: AOAM5319p251PZaL7iGm5AHNvvphQzQoD+yAvIRbxMdetbOdHvBXo8BG
        8eeU/WC2hlE5WKKDYjWb0L2VSw==
X-Google-Smtp-Source: ABdhPJx+Y9zpLRfi6TECmsaeVWuPFjVtd8A+zbPdCw3e4gsvOOeW5QBDnedsiZDc+ccxdvkZGtyekw==
X-Received: by 2002:a9d:5909:: with SMTP id t9mr88508oth.263.1607464791245;
        Tue, 08 Dec 2020 13:59:51 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id j204sm18833oih.15.2020.12.08.13.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 13:59:50 -0800 (PST)
Subject: Re: [PATCH 10/19] target/mips: Add !CONFIG_USER_ONLY comment after
 #endif
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-11-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <b31cd1bd-fd5f-f05b-e0a6-0df83035d5f8@linaro.org>
Date:   Tue, 8 Dec 2020 15:59:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-11-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> To help understand ifdef'ry, add comment after #endif.

This does more than that.

> @@ -550,9 +552,7 @@ hwaddr mips_cpu_get_phys_page_debug(CPUState *cs, vaddr addr)
>      }
>      return phys_addr;
>  }
> -#endif
>  
> -#if !defined(CONFIG_USER_ONLY)


r~
