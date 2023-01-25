Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B11967A980
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 05:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjAYEKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 23:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYEKm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 23:10:42 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF7C3E600
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 20:10:41 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d3so16748255plr.10
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 20:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jPE1Z4AiasvWAh81482PZ75gc33qItYy0XzDyKoMixc=;
        b=oTU6Yj4hJGaiSLcbk7N2YURh0GtdwHzd2W6FgaM+BedXCoWTMzrRNSXzrA5f/m3GSU
         y1QNATWo9RrqxhYdkXDclsfMdfcHmOnboZcg+LghPsH06C2vf9dQrQ2VOThLNc3YHdRt
         GHGHYDWGMaizrgTfufgsBkciIoC5oL6ZRXSzvErIy/c8LnsLQt296DoZWy6/EyY5qUL9
         hfbUzV+OYffiSPWfUJEhIYbmKBBkjFbUbXc2HyRWzFK1HRDajP5YWmv/+F6+aAo0kBLS
         qIU28l0t68zGSTzi8ayp3qSuXI4dfNcKC3nrGV4eAN4D59jOxvu5D5d4p6sTeN6nFGb9
         R0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jPE1Z4AiasvWAh81482PZ75gc33qItYy0XzDyKoMixc=;
        b=ff79tjMyQSvhyrpGbxyEwuw/9xhKtVJtihEOZMsKTSuTodM8aggDEyD2fU10DlnEn6
         BNW0/nqF/jfYbHpKz1+6440n2p15R1kvKnOAHK1mrSgg86LFFjyd7LVt2jpO6CKSEnlw
         y1rBE5Pb1voTDVbDyA0H4pu+9s356G/sSbAfyRf2l68KKxMZPNCW94LonSLIFA+Siid9
         02yLrypAGPoQD1gyZCzeqwE77OdgH6EXhxZh9//fiveAadg8X8w6oO/7MUO72FCB3JVc
         lmC4sKgtP+ysPR1cMsWlE+nwzNbUtW1zVzz1z4HCHEMEFy0Fac5PJ/1AO2sPpQpncb3P
         ceuw==
X-Gm-Message-State: AO0yUKUx9xH812DRcMHPZz2hCJQPT4pBllcOWIidUZYvTzpUfDjfHiVM
        XjaQt7NTCyXl5kA/6UHZQRBzLg==
X-Google-Smtp-Source: AK7set+R37yXvoqhAcsjw23PODIcWIcdkiplx4QcLf83p8tO7nOgzPKY2gRqUFL8OY+Gb5g+X0QjQg==
X-Received: by 2002:a17:90b:3805:b0:22c:4e1:93e with SMTP id mq5-20020a17090b380500b0022c04e1093emr1348473pjb.15.1674619841228;
        Tue, 24 Jan 2023 20:10:41 -0800 (PST)
Received: from ?IPV6:2400:4050:a840:1e00:4457:c267:5e09:481b? ([2400:4050:a840:1e00:4457:c267:5e09:481b])
        by smtp.gmail.com with ESMTPSA id 101-20020a17090a09ee00b002276ba8fb71sm377487pjo.25.2023.01.24.20.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 20:10:40 -0800 (PST)
Message-ID: <76931dd5-e390-5055-8283-0e1cdf2ddf03@daynix.com>
Date:   Wed, 25 Jan 2023 13:10:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] target/arm: Propagate errno when writing list
Content-Language: en-US
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221201103312.70720-1-akihiko.odaki@daynix.com>
 <CAFEAcA9sj838rCyPrxAOncXKmdOftZeM16rKiXB5ww7dSYY0tA@mail.gmail.com>
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CAFEAcA9sj838rCyPrxAOncXKmdOftZeM16rKiXB5ww7dSYY0tA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/01/25 1:12, Peter Maydell wrote:
> On Thu, 1 Dec 2022 at 10:33, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> Before this change, write_kvmstate_to_list() and
>> write_list_to_kvmstate() tolerated even if it failed to access some
>> register, and returned a bool indicating whether one of the register
>> accesses failed. However, it does not make sen not to fail early as the
>> the callers check the returned value and fail early anyway.
>>
>> So let write_kvmstate_to_list() and write_list_to_kvmstate() fail early
>> too. This will allow to propagate errno to the callers and log it if
>> appropriate.
> 
> (Sorry this one didn't get reviewed earlier.)
> 
> I agree that all the callers of these functions check for
> failure, so there's no major benefit from doing the
> don't-fail-early logic. But is there a reason why we should
> actively make this change?
> 
> In particular, these functions form part of a family with the
> similar write_cpustate_to_list() and write_list_to_cpustate(),
> and it's inconsistent to have the kvmstate ones return
> negative-errno while the cpustate ones still return bool.
> For the cpustate ones we *do* rely in some places on
> the "don't fail early" behaviour. The kvmstate ones do the
> same thing I think mostly for consistency.
> 
> So unless there's a specific reason why changing these
> functions improves behaviour as seen by users, I think
> I favour retaining the consistency.
> 
> thanks
> -- PMM

I withdraw this patch. The only reason is that it allows to log errno 
when reporting the error, and the benefit is negligible when compared to 
the consistency.

Regards,
Akihiko Odaki
