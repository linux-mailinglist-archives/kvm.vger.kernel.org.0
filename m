Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676AC2D3599
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 22:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730247AbgLHVvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 16:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730199AbgLHVvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 16:51:06 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20CFC06179C
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 13:50:26 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id q25so133080oij.10
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 13:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JIS+VXsBgC4TwCzlxil8mGdtzezBpwNHWJyQ+8w+FHk=;
        b=pO/2FibH9VxoUophmQ0wZn8j87QToucv3RkGz3dIGNnx1siV4QmlDnVQfcb2/jLrQw
         BTx+kdSv4kO+eicdoi4TD4+NNlkJRFdXBbZ3x3Hm3hSh2ynW0KaGojNyBdalR3RbmUoy
         /mK6W19EsKYS5kubxhmlD8WEbj2rOLGWVBI2uAU4Ln4DI6DpmN0CYmValchHefUCyT4o
         5z/x7e+f5lz5iQmchBfKmbc1RhwOgkarv+M/lpBDQyB4mEeEcQ9MLmjPI9l8cWTjf+XM
         FAb6xIIiDFFZT2I+kxI1MyL/IC/RHn1yJcPa83Smn9iSPXj57QEQKaEBqoGFalPHzfX2
         uTXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JIS+VXsBgC4TwCzlxil8mGdtzezBpwNHWJyQ+8w+FHk=;
        b=RVYph7sD4BrZQf5+i64RRGcY0N6jagsWWAqo4qRN4ww81rAP7q6/6ehhUa0vCcKxxf
         c4FgiDMhneAXHazNQ/FwRRDW02lU+iyj3uUPnCrG12lq16OXg+HfcYszUaqqF2DArxqy
         /bMlXXwd8rRPoYWopWzKESAHwrG3HQEpY+ryd2Ow4QkwIUEDNaRr+xomy7nlbgGUS5Ww
         X83nfZZLUm+4RcGo7mPUZM2GFaqUNmAExqG3x/hg1T8Pk/gmeUPHJUq/fmEQKmF9+uic
         p6esbiM19SgXcMTSwhuCkS/xKoqoIhWwgmHhvuYueWZfKDv5W3FHCTtoyLhjWcLkRRkH
         W6Ew==
X-Gm-Message-State: AOAM530RZm2xVK6AcIHkWdDsKWynTY7sOF0QbWv/fidlf1pGhjOl+Yvt
        uv5Ial4BAGJigdSZj13XN/1gDA==
X-Google-Smtp-Source: ABdhPJzYvUk13sr+NQgFSTQCd7djbXjhnXR7QHyvrL2LjQwCynXNpAYjee8lDAmFi4B/+dMZmOlk8g==
X-Received: by 2002:aca:2418:: with SMTP id n24mr3381356oic.62.1607464226043;
        Tue, 08 Dec 2020 13:50:26 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id z10sm60770oom.3.2020.12.08.13.50.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 13:50:25 -0800 (PST)
Subject: Re: [PATCH 05/19] target/mips: Remove unused headers from op_helper.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-6-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <85f5485b-7202-0e07-e547-3587ab08bbfa@linaro.org>
Date:   Tue, 8 Dec 2020 15:50:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-6-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
>  target/mips/op_helper.c | 4 ----
>  1 file changed, 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
