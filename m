Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB50B6D1DAE
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 12:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbjCaKL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 06:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjCaKKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 06:10:48 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A9F20D8D
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 03:05:34 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id h8so87522936ede.8
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 03:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680257133;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7g8ugW+x6UOUbo4yqdCyL6fYPFKO8DirYDBnGWNfRHU=;
        b=SCs9YdLqfae4MuXLCdF8XWIfFBe/sF7hTjXrWcYZQzJgF4JYlItvnEqyqdKrVlkiPm
         rrDOSdhmOndCvmX/UPFJjhQDHjIfCtBLylpsFREy3ISevVU89uAjSrf3WVn/1FLrPwTR
         ODwqhmXXQxofQTQbLOIi5UYt/+3DmBtDxWGU5ibJhEObpOGsGcZIbT+45pj9vCrDnerZ
         245yQvyPoA0RHQA4Ldqu329VZMaolTz4R3x3hxc/6aeiVQ8rDBvisQxNor+8auXrSw9b
         tguRD7mtwImGoHT+kqJM4IIwa+K50JwDLCmASnAGkjWmXUzzPF4nV/eXUcOgypws6r5a
         uxDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680257133;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7g8ugW+x6UOUbo4yqdCyL6fYPFKO8DirYDBnGWNfRHU=;
        b=1xn1BrD0eRO6bT/75Fnh2FvhjeSzqUqdVhobJFJBRpy/s2MNTkA/WrVHC/XVZfqV26
         v6ZVWj6QJIG3iaBYGdJiMtXGNKAF1KHIyurLw7lRX4SvwMj3ALf6bJQB4FJpyNIWq463
         Cufc4/trBDZkxWz6YrbjBL4A8Tm3j3fMjZhtAqi1Y1SBjTAAZsnZrRgvKXCe7OHriv/r
         qywN64m1446hGdHYH7myP4FSwlux71WkSQbVH6IYjRqpGcYyI730DcYWu5rYeuhTzGx2
         5jApIbC+N/CFGghP6P5uOyj42rKkQnk2l+TeLS32E+KXIxFbhNEivKd4hWiRV9VutxeX
         3/2Q==
X-Gm-Message-State: AAQBX9csXHXddBZX8DEHF8zwb3jLDddEQlMHTN8UPoD8/xV/pZ4LbEpZ
        Zbfxt4p5ZVEl3t9naSkPOtYAF8qJwlgUO1BsWHsQ/A==
X-Google-Smtp-Source: AKy350bzvSM+9rGt+OmeuRAFDUeqmtGiKhVL/MKZIZK4abJRfEXIWkG5NVC3AAeZxvx3wOK6+lo0cg==
X-Received: by 2002:aa7:d806:0:b0:4fc:3777:f630 with SMTP id v6-20020aa7d806000000b004fc3777f630mr25245803edq.0.1680257132941;
        Fri, 31 Mar 2023 03:05:32 -0700 (PDT)
Received: from ?IPV6:2003:f6:af1a:5100:d774:c595:6e3b:4e1e? (p200300f6af1a5100d774c5956e3b4e1e.dip0.t-ipconnect.de. [2003:f6:af1a:5100:d774:c595:6e3b:4e1e])
        by smtp.gmail.com with ESMTPSA id cw10-20020a056402228a00b0050234b3fecesm842870edb.73.2023.03.31.03.05.32
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 03:05:32 -0700 (PDT)
Message-ID: <af03f148-118a-7c70-ba34-f22b6036c55c@grsecurity.net>
Date:   Fri, 31 Mar 2023 12:05:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests PATCH 2/2] x86/access: CR0.WP toggling write
 access test
Content-Language: en-US, de-DE
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
References: <20230327181911.51655-1-minipli@grsecurity.net>
 <20230327181911.51655-3-minipli@grsecurity.net>
 <3d8f51a2-dd64-0ae0-652e-15cf99954829@grsecurity.net>
In-Reply-To: <3d8f51a2-dd64-0ae0-652e-15cf99954829@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31.03.23 12:03, Mathias Krause wrote:
> This test is insufficient to test all corner cases, as noted in [1].
> [...]

Forgot the link:

[1]
https://lore.kernel.org/kvm/ea3a8fbc-2bf8-7442-e498-3e5818384c83@grsecurity.net/
