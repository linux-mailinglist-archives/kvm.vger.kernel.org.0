Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695222EC93E
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 04:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbhAGD54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jan 2021 22:57:56 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:41383 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726532AbhAGD5z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Jan 2021 22:57:55 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 44B005804CF;
        Wed,  6 Jan 2021 22:57:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 06 Jan 2021 22:57:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm1; bh=g
        tq4DjSFmmNh2QS36UUKCFmBXgbvhcLixEM16k+fVp0=; b=0fjnLsqHjLlq6pFWR
        gqMkAdvtppT4u9ugPpK1ZKpQ6Yw3CA2MFdHCGGickUomOdPwBYXWeiSO66yVxiV6
        T+9HA+1VSLHOLlK5LUvYHhcvDLuthUE7wbgVvDuFe4Z7Dm2819fEKoS06i3Ev0hH
        SQ4OzfH2HX3/jAtnbul7opltXb0f5sZDLJ8IsUHadPX3J0iKtY1RdxMOApCDB1qI
        sf5rVIjjSOd77HbBRqtoaD5rteeGnyisKHQJuaB0eiZkv69XDdKTJQuoh/j6A7Hs
        sWn6p/I1Fpc3Y4GjzFAfL7bB0C3GZolofPYccpqk+Mai6j4T3klXd6I0RAyKP9sk
        yLz4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=gtq4DjSFmmNh2QS36UUKCFmBXgbvhcLixEM16k+fV
        p0=; b=pbNEsmBxiunUMPOQRk50Qxpp6S5niIVRLBLBOGIf52cPkXJv/byRQAX3f
        vyKuLznjF2F95i0QDtrEmK0/Yn+WqwSV6lHmlXcS5TJAVGg2TRgPEkQlk7EKbWe4
        P0qvFvV1dr27ACX63yAw2uGLCWnMvo2j6bPjIFCQYRb31KAqM7RyNvYTJJW5g85T
        JPiBoCisZeKYPhtxcVbmFaursERhll2lkh+haYKkka/Z6vjNrtraVH4qy2BY8s20
        4EKBPSArwSqPdrQElamyOcbljcaPqFyoRqxmajWMbg92Yz8ZRLFEqWHmIiH9qGz3
        bOgzNzkuJ3xTA5KZQ/H8KKpP/P7oQ==
X-ME-Sender: <xms:lIb2X5biJ2kChfXPh7DfOgwQzputJsV0XQPakylPXj2nMFYHx9O7KA>
    <xme:lIb2X6Dwam23sdWND26Qh9ZqmoBzT417Blgi4Ej5PKi92UvdfcLuYGs3KX6I9BclU
    oEQt28KikweAG-UUEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegtddgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefuvfhfhffkffgfgggjtgfgsehtkeertddtfeejnecuhfhrohhmpeflihgr
    gihunhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqne
    cuggftrfgrthhtvghrnhepueeljefhheeljeekieeghefhtdelveevuddtlefgkeegtddv
    keeifeejfeevieehnecuffhomhgrihhnpehgihhtlhgrsgdrtghomhdpmhgrihhlqdgrrh
    gthhhivhgvrdgtohhmnecukfhppeeghedrfeefrdehtddrvdehgeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhgse
    hflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:lIb2X78rCvC9Ym-K9W420UgOvNR1mCHyHI0BxS-jZjERua5MOJ_u-g>
    <xmx:lIb2X69CNILCRbpRwo_E_-BVsPR3y58JQlTd4xiC6_8X1Z3iQOLPkw>
    <xmx:lIb2XyciSIhPkkYNfrkOy7yoVgqIgf0Z0B_um5H6XF5438eJQojuIw>
    <xmx:lYb2X81i7yBfLpL1aDTM9ntUeMUO34x4zhYiiHmAf-r1jfWXnellxw>
Received: from [0.0.0.0] (li1000-254.members.linode.com [45.33.50.254])
        by mail.messagingengine.com (Postfix) with ESMTPA id A73C5108005B;
        Wed,  6 Jan 2021 22:57:01 -0500 (EST)
Subject: Re: [PATCH v2 02/24] target/mips/translate: Expose check_mips_64() to
 32-bit mode
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201215225757.764263-1-f4bug@amsat.org>
 <20201215225757.764263-3-f4bug@amsat.org>
 <1f23c2f4-28b9-ac3b-356e-ea9cc0213690@amsat.org>
 <CAAdtpL65=s-eUGKjXe-KzyqyHs1+a1qwHyp72xNRNo0gHxE8Hg@mail.gmail.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <ae7677ba-7820-a0a1-e9b2-8373899e99b0@flygoat.com>
Date:   Thu, 7 Jan 2021 11:56:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAAdtpL65=s-eUGKjXe-KzyqyHs1+a1qwHyp72xNRNo0gHxE8Hg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

在 2021/1/7 上午2:37, Philippe Mathieu-Daudé 写道:
> On Wed, Jan 6, 2021 at 7:20 PM Philippe Mathieu-Daudé <f4bug@amsat.org> wrote:
>> Hi,
>>
>> ping for code review? :)
> FWIW the full series (rebased on mips-next) is available here:
> https://gitlab.com/philmd/qemu/-/commits/mips_msa_decodetree

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>

- Jiaxun

>
>> Due to the "Simplify ISA definitions"
>> https://www.mail-archive.com/qemu-devel@nongnu.org/msg770056.html
>> patch #3 is not necessary.
>>
>> This is the last patch unreviewed.
>>
>> On 12/15/20 11:57 PM, Philippe Mathieu-Daudé wrote:
>>> To allow compiling 64-bit specific translation code more
>>> generically (and removing #ifdef'ry), allow compiling
>>> check_mips_64() on 32-bit targets.
>>> If ever called on 32-bit, we obviously emit a reserved
>>> instruction exception.
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>>> ---
>>>   target/mips/translate.h | 2 --
>>>   target/mips/translate.c | 8 +++-----
>>>   2 files changed, 3 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/target/mips/translate.h b/target/mips/translate.h
>>> index a9eab69249f..942d803476c 100644
>>> --- a/target/mips/translate.h
>>> +++ b/target/mips/translate.h
>>> @@ -127,9 +127,7 @@ void generate_exception_err(DisasContext *ctx, int excp, int err);
>>>   void generate_exception_end(DisasContext *ctx, int excp);
>>>   void gen_reserved_instruction(DisasContext *ctx);
>>>   void check_insn(DisasContext *ctx, uint64_t flags);
>>> -#ifdef TARGET_MIPS64
>>>   void check_mips_64(DisasContext *ctx);
>>> -#endif
>>>   void check_cp1_enabled(DisasContext *ctx);
>>>
>>>   void gen_base_offset_addr(DisasContext *ctx, TCGv addr, int base, int offset);
>>> diff --git a/target/mips/translate.c b/target/mips/translate.c
>>> index 5c62b32c6ae..af543d1f375 100644
>>> --- a/target/mips/translate.c
>>> +++ b/target/mips/translate.c
>>> @@ -2972,18 +2972,16 @@ static inline void check_ps(DisasContext *ctx)
>>>       check_cp1_64bitmode(ctx);
>>>   }
>>>
>>> -#ifdef TARGET_MIPS64
>>>   /*
>>> - * This code generates a "reserved instruction" exception if 64-bit
>>> - * instructions are not enabled.
>>> + * This code generates a "reserved instruction" exception if cpu is not
>>> + * 64-bit or 64-bit instructions are not enabled.
>>>    */
>>>   void check_mips_64(DisasContext *ctx)
>>>   {
>>> -    if (unlikely(!(ctx->hflags & MIPS_HFLAG_64))) {
>>> +    if (unlikely((TARGET_LONG_BITS != 64) || !(ctx->hflags & MIPS_HFLAG_64))) {
>> Since TARGET_LONG_BITS is known at build time, this can be simplified
>> as:
>>
>> if ((TARGET_LONG_BITS != 64) || unlikely!(ctx->hflags & MIPS_HFLAG_64)))
>>
>>>           gen_reserved_instruction(ctx);
>>>       }
>>>   }
>>> -#endif
>>>
>>>   #ifndef CONFIG_USER_ONLY
>>>   static inline void check_mvh(DisasContext *ctx)
>>>

