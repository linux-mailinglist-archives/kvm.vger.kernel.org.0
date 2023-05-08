Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0603C6FB486
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 17:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbjEHP6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 11:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234080AbjEHP6B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 11:58:01 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5D36A69
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 08:57:59 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so50182230a12.0
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 08:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1683561478; x=1686153478;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0NGQDvN9IIkEhPKwPSHnoa4oqCVhjUMQuHf+poaFyCA=;
        b=l3GvYBY5YrYD1qJF+TlIR3teiLKEz6ya2aK9IxnBAZKhGxMqbWqfMrCtzh3F/+sXc8
         YKfH3x/VvKbQem8T4mQdhH8XzHmv14dfEfRoe9Y3bZqbvEkZmTRp3CVQkzW/3h/BaPu5
         ywvw9Qm7tyKhHHL/xhQvjhQF4s67oE4HidtjhrryvKhs04y3mrSCA2c+WdD78+lGR/mw
         FOeU1jlNUyIQVM4QoxGhKHGlj7cnk9/p15EhFBGR3MpJLNTTos+EmC0lI4tHtn1zyzST
         gYdCIq0vVSwgkGg3ez1KAf+IVFmE9KW7fMbpf8KwIowNAAKprMhSK2jJ0p7FkffiogP5
         CeMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683561478; x=1686153478;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0NGQDvN9IIkEhPKwPSHnoa4oqCVhjUMQuHf+poaFyCA=;
        b=Wl4CgMlm3YnGTkr+41X4DhR8ohh/vndsKOcN6RyflId7QXT+Lpzmw+ZbH5PW768FCo
         Es4NCvFK6BHOx9QLcWnOCmSkiE/Ved/6mOT50ZTTfNXUP/K3aCX/jt2XZ4b+oxm7lSH3
         lT1/5rwkBacf85+bxu6RNUNYtDevtflm0NUkP1/wGl5j72cgNBnH5zlcEzLGRBnbWqx2
         p4R4Zb0oLa2OGLOyiusyaf/Sy23SwSA0ODDXTRPXI7pnRMCsqTpE1d6Vl73inomHL116
         b+7cmPZGfT2BpSn6Jtnl4GKEJT+fZbgl6URvCbRSLFpZtleg/AhhB6xsOI/rAS2VnDGF
         NMDQ==
X-Gm-Message-State: AC+VfDx/2S8jAxA6UcPT833OKWy2V/WZmIoJeH82xEkmyfG4WkWJV98v
        TEmbF/gwLNESk4ihkfmIyYXod8aRGnqsl5bovQE=
X-Google-Smtp-Source: ACHHUZ7ZnnXE+LKy+j2KEExj9B/MeNo0MxRWxSZW03cWEvawuRrKGaz0IyffWn7CXDG5UEz7ZXR8YA==
X-Received: by 2002:a17:907:7baa:b0:966:1484:469e with SMTP id ne42-20020a1709077baa00b009661484469emr6236204ejc.17.1683561478460;
        Mon, 08 May 2023 08:57:58 -0700 (PDT)
Received: from ?IPV6:2003:f6:af27:500:653d:9c74:8bdf:2820? (p200300f6af270500653d9c748bdf2820.dip0.t-ipconnect.de. [2003:f6:af27:500:653d:9c74:8bdf:2820])
        by smtp.gmail.com with ESMTPSA id n5-20020a1709065da500b0096616adc0d5sm130991ejv.104.2023.05.08.08.57.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 08:57:57 -0700 (PDT)
Message-ID: <a452659a-56ec-1eb8-7db2-f5fc155a82d9@grsecurity.net>
Date:   Mon, 8 May 2023 17:57:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 0/6] KVM: MMU: performance tweaks for heavy CR0.WP
 users
Content-Language: en-US, de-DE
From:   Mathias Krause <minipli@grsecurity.net>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Greg KH <greg@kroah.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, stable@vger.kernel.org,
        Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <167949641597.2215962.13042575709754610384.b4-ty@google.com>
 <190509c8-0f05-d05c-831c-596d2c9664ac@grsecurity.net>
 <ZB7oKD6CHa6f2IEO@kroah.com> <ZC4tocf+PeuUEe4+@google.com>
 <0c47acc0-1f13-ebe5-20e5-524e5b6930e3@grsecurity.net>
 <026dcbfe-a306-85c3-600e-17cae3d3b7c5@grsecurity.net>
 <ZDmEGM+CgYpvDLh6@google.com>
 <773d257a-a4ca-23c6-9421-c2805423aa0e@grsecurity.net>
In-Reply-To: <773d257a-a4ca-23c6-9421-c2805423aa0e@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08.05.23 11:19, Mathias Krause wrote:
> [...]
> 
> I'll post the backports I did and maybe can convince you as well that
> it's not all that bad ;) But I see your proposal patch [3] got merged in
> the meantime and is cc:stable. Might make sense to re-do my benchmarks
> after it got applied to the older kernels.

I just sent out the backports to the mailing list, please have a look!

The benchmark numbers are still the old ones I did three weeks ago.
However, seeing what's needed for the backport might give you a better
feeling for the impact.

I'll refresh the series if there's demand and when edbdb43fc96b ("KVM:
x86: Preserve TDP MMU roots until they are explicitly invalidated") got
merged into the relevant kernels.

v6.2:
https://lore.kernel.org/stable/20230508154457.29956-1-minipli@grsecurity.net/
v6.1:
https://lore.kernel.org/stable/20230508154602.30008-1-minipli@grsecurity.net/
v5.15:
https://lore.kernel.org/stable/20230508154709.30043-1-minipli@grsecurity.net/
v5.10:
https://lore.kernel.org/stable/20230508154804.30078-1-minipli@grsecurity.net/
v5.4:
https://lore.kernel.org/stable/20230508154943.30113-1-minipli@grsecurity.net/

Thanks,
Mathias
