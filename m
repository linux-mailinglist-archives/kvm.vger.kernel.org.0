Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2733A6E5BEC
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 10:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjDRIU2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 04:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjDRIU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 04:20:26 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF561FF0
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:20:17 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-555bc7f6746so3166987b3.6
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 01:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681806016; x=1684398016;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IPKQOh+/dc/hqRghNq7RfRFkDmvZYeq2w5cXPUBWFTo=;
        b=ZfcShlT9AekOmUL1LevSlUE+TwXLo1JVs2x6RN6ZPY9Q5a+BLDWzyrQk5sXk3/gU5a
         WtNRuSqJqwZNFxLAXm7aXKSsoUrK/2xsW6US+x9Ji0bfDHdI4NSbgRwvp+T5KhOwf1Ug
         IaXSfsjr+6tsUSCgyuuQ/CJ07973g9VbDBM3iYvnH7rfS42JEIaK6UXQCX+B5k3kYwXo
         NUKGyDFm0xxAokxApdHD+Yk1J23hylNHIc8cMo7F6fv/0Osy/rbWhauxbdSMBzPrFdBo
         7diJeDKbLJBY+QBJYpdW375lYODmmm23KpVXjyHOQ/dXGKrV0uXQDio4bBT/1Hc0Tc11
         Ib2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681806016; x=1684398016;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IPKQOh+/dc/hqRghNq7RfRFkDmvZYeq2w5cXPUBWFTo=;
        b=Qpfzn/tnRy3HmrtfThlxK89HBjoVWqJ0z/3ancaZW8eVYVdz8QePUo1ypdhuAyCEpP
         sRHYDvOnyfDy4Xo0MrjAjgTqCnlLr4MNqq2KzzM7rBLUx1Hn2tVWdY9xz9aSvtGs1OU1
         nk18O2ST30IVHV6yQXlGXAp50120cQn/iNB/AK00Qd/rQLRKaoraPRiZ2n/EajACIoMw
         PySOr2vNL1MkgCsahb93r2oESoRXm3CdhZyso42+oMsuF2+y0Zd36aO2Q1P/cnMNsHgr
         I4wGXBFUOA6TD/sImSnzMCGE77hdMCepI7dmyR3q9/bwD6py+N++mIDuHdJuCqHtooOM
         QxPA==
X-Gm-Message-State: AAQBX9fiwE/iBIzEJM6hwXGOuJFWFfw7lbI+drbmmRHQYGGfyaoUA/HR
        +qtfy5LV3xl/1joEx9bIe2Xt8Q==
X-Google-Smtp-Source: AKy350YkhhQX1OQUgKxOQW0rPFh93SNXmWM4X4l9brWPj2Wqe/umyUTWQQOHGvpV7rgM+CulaIb9Hw==
X-Received: by 2002:a0d:c387:0:b0:54c:1405:2ce with SMTP id f129-20020a0dc387000000b0054c140502cemr20029718ywd.49.1681806016252;
        Tue, 18 Apr 2023 01:20:16 -0700 (PDT)
Received: from ?IPV6:2605:ef80:8079:8dd6:3f0f:2ab3:5c15:47fa? ([2605:ef80:8079:8dd6:3f0f:2ab3:5c15:47fa])
        by smtp.gmail.com with ESMTPSA id cd9-20020a05690c088900b0054c02f97d8dsm2902713ywb.91.2023.04.18.01.19.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 01:20:15 -0700 (PDT)
Message-ID: <a96de4ca-366b-82ae-bf80-2b183d936ba2@linaro.org>
Date:   Tue, 18 Apr 2023 10:19:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 07/17] qemu/bitops.h: Limit rotate amounts
Content-Language: en-US
To:     Lawrence Hunter <lawrence.hunter@codethink.co.uk>,
        qemu-devel@nongnu.org
Cc:     dickon.hood@codethink.co.uk, nazar.kazakov@codethink.co.uk,
        kiran.ostrolenk@codethink.co.uk, frank.chang@sifive.com,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pbonzini@redhat.com,
        philipp.tomsich@vrull.eu, kvm@vger.kernel.org,
        qemu-riscv@nongnu.org
References: <20230417135821.609964-1-lawrence.hunter@codethink.co.uk>
 <20230417135821.609964-8-lawrence.hunter@codethink.co.uk>
From:   Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20230417135821.609964-8-lawrence.hunter@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/17/23 15:58, Lawrence Hunter wrote:
> From: Dickon Hood<dickon.hood@codethink.co.uk>
> 
> Rotates have been fixed up to only allow for reasonable rotate amounts
> (ie, no rotates >7 on an 8b value etc.)  This fixes a problem with riscv
> vector rotate instructions.
> 
> Signed-off-by: Dickon Hood<dickon.hood@codethink.co.uk>
> ---
>   include/qemu/bitops.h | 24 ++++++++++++++++--------
>   1 file changed, 16 insertions(+), 8 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
