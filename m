Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB132D9A6C
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 15:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407791AbgLNO5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 09:57:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408264AbgLNOzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 09:55:49 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EC3C0617A7
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 06:54:43 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id r3so16736723wrt.2
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 06:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4DaLqvsDm5SqCzWwMhnyPtFEtL70bMDG+mFsDKou0X4=;
        b=UJR/wKdU6rPLN4XQ3J0CDWMk263//v8P+bzOWQhJFiDK7OEBa3DuB1QqwJ9FhLwnBU
         sVYRyqltLyyrCEquXvzE1avw0uaZ/7GIeZsXUMYNR13u7QsAxv1Kpts39QRlHYUJjMMw
         4ZO7U8o2c+gnn08eeunaQ3NbLBwWFp+UQfbvTeDiEOXdK0qYT4R+hJaVehV7fhKcQtEz
         qIZO4zp0dM1YCew+9lZM+4ZGxz7yabrnCZqaEUT2O6oRTjtc9aNrujj2zWCy2Y7eOv2q
         eqVjfJnpDlYtv4xIBSx6G5RV6AjtnmL+0bsAD+OX2Bcs3F/ZoE1qIGzK3+KSiBhFGEFe
         ZynA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4DaLqvsDm5SqCzWwMhnyPtFEtL70bMDG+mFsDKou0X4=;
        b=qfMv2Mt6OOoLHgD6Z4/SzzkIr7hBbpyVYlEy3Ken3uPPLz04mfz6Ex4yNJalNlORa0
         5tPnLv+j70KOKt3oc8XOlj2HIfEvbvi5VC256A4xhLwzDJe2WilZ2IfnlCLC8Lq0aYFr
         OtIaKmouf81SmvS3vo7PYRnm0xPEdOEqmURCny9vm+RPSD4d1weandg+5f4pGHPQxn4o
         PI6kjsrJwiP53JpoeT0qiWnKV2uLsUiKd/LamybCIqBj8g9uZK5eMXcuiDQDmB034oP9
         KVW4AxWQITaFi72yszBgrRl4siDaAlwoc5jyjrsonvDXtuq19BfxYJv+Gi+rUu9HyiG4
         tH5g==
X-Gm-Message-State: AOAM530LzE/DSeIt821kiswpMgZC/Ph/0Su4sX8dM9+kWFg85wSKfWw6
        IF65NDb/b46Uz01DJHf9Klw=
X-Google-Smtp-Source: ABdhPJx7e+I0xjoB2By16ZZyhXRHSXtUxgskPOphW25lvrTalpUyK5RyKtestnWlQd/kWiJWMBFQlQ==
X-Received: by 2002:adf:9e4d:: with SMTP id v13mr28765704wre.135.1607957682692;
        Mon, 14 Dec 2020 06:54:42 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id o13sm29553783wmc.44.2020.12.14.06.54.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 06:54:42 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH 11/19] target/mips: Extract common helpers from helper.c
 to common_helper.c
To:     luoyonggang@gmail.com,
        Richard Henderson <richard.henderson@linaro.org>
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        qemu-level <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-12-f4bug@amsat.org>
 <ac8afc12-2ab4-a2a3-81b5-b9d75314bf6f@linaro.org>
 <CAE2XoE_WzMzCbvxtPdQfbU2rs-wd26GXpds9VypW7B-ik7qWJA@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <8021bdf5-bc67-9029-b9af-0b9ee3b0d4dd@amsat.org>
Date:   Mon, 14 Dec 2020 15:54:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CAE2XoE_WzMzCbvxtPdQfbU2rs-wd26GXpds9VypW7B-ik7qWJA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 3:51 PM, 罗勇刚(Yonggang Luo) wrote:
> On Wed, Dec 9, 2020 at 6:09 AM Richard Henderson
> <richard.henderson@linaro.org <mailto:richard.henderson@linaro.org>> wrote:
>>
>> On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
>> > The rest of helper.c is TLB related. Extract the non TLB
>> > specific functions to a new file, so we can rename helper.c
>> > as tlb_helper.c in the next commit.
>> >
>> > Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org
> <mailto:f4bug@amsat.org>>
>> > ---
>> > Any better name? xxx_helper.c are usually TCG helpers.
>>
>> *shrug* perhaps cpu_common.c, no "helper" at all?
>> Perhaps just move these bits to cpu.c?
>>
>>
>> r~
>>
> Does these are general cpu bits or misp_cpu bits?
> if only misp cpu related, prefer misp_cpu.c
> or cpu.c under misp folder.

Yes, as the patch subject prefix implies, this is a change
local to the target/mips/ directory.

Regards,

Phil.
