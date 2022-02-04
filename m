Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69ADA4A9D25
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 17:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376648AbiBDQv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 11:51:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49277 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233477AbiBDQvZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 11:51:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643993484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rzIOlYd+9ZslL42n6NRPIobhsXeoGnKPREOgdajJ/jA=;
        b=N8DKtwnO5b1Erry49LK2uIdpPEix5TX8FTdWm5iH3Z7x0xv5X/nzpQAkZQbSfj83BwJDFA
        6qmBPpsQlCuK1DAoAC2E5iLd7HvexA3T25Bv/2SyMUij67BB7ljvpnCRHCAIYYpla41vCZ
        8/kI0mCPShNHGWCZaP9xZJWIHXHhBJk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-AgFPg5QyOvKUomRCW90_Rw-1; Fri, 04 Feb 2022 11:51:22 -0500
X-MC-Unique: AgFPg5QyOvKUomRCW90_Rw-1
Received: by mail-wm1-f69.google.com with SMTP id ay8-20020a05600c1e0800b00350de81da56so1147111wmb.9
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 08:51:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rzIOlYd+9ZslL42n6NRPIobhsXeoGnKPREOgdajJ/jA=;
        b=EmTnLKuhNROsxg4VaG13YhFVB4zUDlijgDxi+63FkQyJqsJQlD6KpC4wXcfbUobBqd
         5y1RdXzSSWQ2fG4PakByEzPiSyCTnifi3+ARfCIQ9rDBhg0zJlPMs0lIAxJG9GnRWLOV
         gNnqpGMNDuhd0sfdbfOOoMFPEYfSW5s+zCc1vA5Z1o3JKnDk1GkGko+YKkz5aDOUF8JF
         sCGAyuyo84Bpn5L4A51uyU9jiHGCSu4KvzMyaLXqzkrxPbFr54n7THBsFs7a9xEqoUHW
         o13EWQYBfza1PwkEQKmKLSTA9GBVsqa8DYyHL53pw6J0+cVQwo5rObIoOUjpDmNn4mqC
         yNxQ==
X-Gm-Message-State: AOAM533FVJWhy2ianr21IlApoGO/i7Bb1qSsKBb5ww/aJjow/hr/T55V
        k8vEfu0+UwMxGlrR7u52tA6lJxYBPA7JMPDiiBa3vyeoLPfbs7Q+3hhBD9gnfPOYZLm8Sf30w7o
        ZrmZOlDMDIaww
X-Received: by 2002:adf:e281:: with SMTP id v1mr3152060wri.308.1643993481835;
        Fri, 04 Feb 2022 08:51:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyGnZ0hSDCcs1Nkw2aH151iY8NFTMcfdaigY9cFsPZHw7QFpdoSVFcIC+F5GS5jPX3O5n+uTg==
X-Received: by 2002:adf:e281:: with SMTP id v1mr3152049wri.308.1643993481688;
        Fri, 04 Feb 2022 08:51:21 -0800 (PST)
Received: from [192.168.8.100] (tmo-096-196.customers.d1-online.com. [80.187.96.196])
        by smtp.gmail.com with ESMTPSA id b15sm2325190wrs.93.2022.02.04.08.51.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 08:51:21 -0800 (PST)
Message-ID: <c3b79661-da57-354a-b766-928905354f23@redhat.com>
Date:   Fri, 4 Feb 2022 17:51:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH kvm-unit-tests v2] arm64: Fix compiling with ancient
 compiler
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20220203151344.437113-1-drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220203151344.437113-1-drjones@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/2022 16.13, Andrew Jones wrote:
> When compiling with an ancient compiler (gcc-4.8.5-36.el7_6.2.aarch64)
> the build fails with
> 
>    lib/libcflat.a(alloc.o): In function `mult_overflow':
>    /home/drjones/kvm-unit-tests/lib/alloc.c:19: undefined reference to `__multi3'
> 
> According to kernel commit fb8722735f50 ("arm64: support __int128 on
> gcc 5+") gcc older than 5 will emit __multi3 for __int128 multiplication.
> To fix this, let's just use check_mul_overflow(), which does overflow
> checking with GCC7.1+ and nothing for older gcc. We lose the fallback
> for older gcc, but oh, well, the heavily negative diffstat is just too
> tempting to go for another solution.

Sounds ok to me, too.

Reviewed-by: Thomas Huth <thuth@redhat.com>


