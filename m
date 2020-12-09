Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874E02D3E59
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 10:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgLIJSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 04:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgLIJSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 04:18:02 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C08CC0613D6
        for <kvm@vger.kernel.org>; Wed,  9 Dec 2020 01:17:22 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id d3so770972wmb.4
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 01:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DhEexIPrt7u69AggAVnat5k7tJsbULtT8rgXthgK4NI=;
        b=UY3JgWi9uEqcUQn2dQ03bjRaI7V8TuWWCJoQHjis3I7TBft5Gg05tUmLSNDm5NeQNF
         zaMfvqlkUR4Vyv8EqQbacGLasBfoYY5pJrjJ59HNctP4A1vSMveCPXRJNSYz8O8Ajp9X
         /FA5sWZfX7hv5PeqqZelWsS8sCjJXop92eQInE5kTTADL0dBQW94Rd6zibWIqAcfmxEZ
         4K9gor63LqfG+1xijbV2i+DrDGYa28O7HK/0eEb5qwJaNGYxZepbOM2ztk/k+RlOaUBW
         KvwrdkfYCS190cbUAmSUTx10FYGmRJSs8VsW5p1xwIW3+7ejgErfPdWGE9NPv+J9JZwk
         Kobw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DhEexIPrt7u69AggAVnat5k7tJsbULtT8rgXthgK4NI=;
        b=jshZ+oQegzAlwfE5S7NdXh11SwYDd1yQ5avYOwHNPRLoCtWndx48djHHsHx8pTh3hU
         4RZhKvdVxBUvZAbiSNGubQqnRBaEKH8y3paaGQlejN1QXD3F+P+HDEyXEP/RP+OGtTQ0
         +67VkHU3VWUQ41VTPqRO33c6hxDX7Jzee89DYq3+ZIMQh9AI9IlnOd90KiI5pVB10MiF
         PylkuoQ2CXDb1yxyFmpaDuNzeubc0zR8kO5zs72f3YsK6G5pQaEMedYe9PsOBmYSDTCM
         ufxCjH+tbY287esjqurfrup4kVSxzBJiLxSAFSzDSKHNDqWmrpTK66xj0RPoq+yCq2Sn
         N8Og==
X-Gm-Message-State: AOAM53080JObFUi+1pQBW7n6iGvtk6pN7R/klJ5fmCGzstL1G48wUxKy
        8IKeYMp5UTNWpAYZQWHWUBg=
X-Google-Smtp-Source: ABdhPJzIQyl2m3bRnpnQP/Mwp+WL2VZKtevGkn9HkLgfGEt6UOlC5UhJsiPrXCBqpKLzZgsQrXUOAw==
X-Received: by 2002:a1c:c254:: with SMTP id s81mr1690532wmf.132.1607505441021;
        Wed, 09 Dec 2020 01:17:21 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id h98sm2442236wrh.69.2020.12.09.01.17.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 01:17:20 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH 14/17] target/mips: Declare gen_msa/_branch() in
 'translate.h'
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201208003702.4088927-1-f4bug@amsat.org>
 <20201208003702.4088927-15-f4bug@amsat.org>
 <45ab33e0-f00e-097a-74fb-4c7c42e29e33@linaro.org>
 <b0cf35c4-a086-b704-5710-0f05bf7921bb@linaro.org>
 <58a0d6c4-fc01-3932-52b9-9deb13b43c51@linaro.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <1d2a6f44-1eab-2e92-01c2-703a2ee5bd50@amsat.org>
Date:   Wed, 9 Dec 2020 10:17:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <58a0d6c4-fc01-3932-52b9-9deb13b43c51@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Richard,

On 12/9/20 1:03 AM, Richard Henderson wrote:
> On 12/8/20 6:01 PM, Richard Henderson wrote:
>> On 12/8/20 5:56 PM, Richard Henderson wrote:
>>> On 12/7/20 6:36 PM, Philippe Mathieu-Daudé wrote:
>>>> Make gen_msa() and gen_msa_branch() public declarations
>>>> so we can keep calling them once extracted from the big
>>>> translate.c in the next commit.
>>>>
>>>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>>>> ---
>>>>  target/mips/translate.h | 2 ++
>>>>  target/mips/translate.c | 4 ++--
>>>>  2 files changed, 4 insertions(+), 2 deletions(-)
>>>
>>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>>
>> Actually, I think this should be dropped, and two other patches rearranged.
> 
> Actually, nevermind, you already get the right result in the end; there's no
> point re-rearranging.

I'm interested in looking at your idea to see if I can follow it
for the next conversions after the MSA ASE. The criteria I'm using
is (in this order):

- keep bisectability working
- keep patches trivial enough to review
- avoid moving things twice

In a previous version I tried to directly pass from

static void gen_msa(DisasContext *ctx) ...

to:

static bool trans_MSA(DisasContext *ctx, arg_MSA *a) ...

without declaring the intermediate 'void gen_msa(DisasContext)'
in "translate.h" (this patch). The result was less trivial to
review, so I went back to using an intermediate patch for
simplicity.

Is that what you were thinking about?

Thanks,

Phil.
