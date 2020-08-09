Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FB023FF78
	for <lists+kvm@lfdr.de>; Sun,  9 Aug 2020 19:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgHIRXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Aug 2020 13:23:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32071 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726175AbgHIRXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Aug 2020 13:23:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596993814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=60GKudByszXzSU9r7sTdue2pMvjRmoypxp10iEs7VnI=;
        b=h2GmS3RPqL6s9RLls7FXNAj+cLer3Ytp/OMaLw9rqf/C+vV3W0Ff4BmFCVk93CXITuSCdX
        AOWnM0phSwURi+BPg8Wdc23RzFBNYnS3rVYfFgglh/vMD2VzwRgqaOlTkWzD4ueov2KiEd
        T34OuWWuVlOlm9+PIRqdqFiFSTZkSqA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-vAxNmfbqNeWHI4Yj3DbU0g-1; Sun, 09 Aug 2020 13:23:31 -0400
X-MC-Unique: vAxNmfbqNeWHI4Yj3DbU0g-1
Received: by mail-wr1-f71.google.com with SMTP id b8so3314361wrr.2
        for <kvm@vger.kernel.org>; Sun, 09 Aug 2020 10:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=60GKudByszXzSU9r7sTdue2pMvjRmoypxp10iEs7VnI=;
        b=I5VUshjpe996I1hDmPXKJbpWfo+q60oVXOwV0W+6KcegVvOAsfQNIjGS9+g1g5UFBQ
         DWnaauLzPWayJGXqJyhvTiU5jOa7/XUZoKNETZ3iQukVCkFQelWa3e5+stfoNe24E4v0
         yj7SiCAOiW8m/2r0gqOqRpdrhe2cLiEUZEi6jRluv83XBTttBF1nB7mHffvb4xl5eKYC
         8pW2l/OBf7QNoZD2fWXXlTSXVVH3BEdonRy9LPZ78uJ7T+fz32LjuEMS+wBHD+wvEvo3
         V1WEjqM0pe1xowlFjrQ01oaNrl5ajPRe2vIgbLMdtYhTJd6jh/pzXJ7KFEV/LKATH4Sw
         PSUw==
X-Gm-Message-State: AOAM530d8qzY+MzXvi/q8/3ctnxOqJXu+7X7Zm5R85RTid18tA9nB+Ho
        z7oZrvswizs99kak6eoaIYxKCpUvoConlb2RPX2vFOjugT/aPpfd6kZQUryqBSDn9ysDMHzxRzq
        aVnGKln/RGZif
X-Received: by 2002:a05:6000:118c:: with SMTP id g12mr20755650wrx.212.1596993810608;
        Sun, 09 Aug 2020 10:23:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzwEPa1MPtSV651TG2wBd2JGpLDN+D3LrImZPSbEhFkjVn/IV+rGrVC44uH0fDnj2r1OeS2g==
X-Received: by 2002:a05:6000:118c:: with SMTP id g12mr20755633wrx.212.1596993810341;
        Sun, 09 Aug 2020 10:23:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8deb:6d34:4b78:b801? ([2001:b07:6468:f312:8deb:6d34:4b78:b801])
        by smtp.gmail.com with ESMTPSA id g7sm18096445wrv.82.2020.08.09.10.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2020 10:23:29 -0700 (PDT)
Subject: Re: [PATCH] MIPS: VZ: Only include loongson_regs.h for CPU_LOONGSON64
To:     Greg KH <greg@kroah.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>, stable@vger.kernel.org
References: <1596891052-24052-1-git-send-email-chenhc@lemote.com>
 <20200808153123.GC369184@kroah.com>
 <2b2937d0-eae6-a489-07bd-c40ded02ce89@flygoat.com>
 <20200809070235.GA1098081@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5ffc7bb1-8e3f-227a-7ad0-cec5fc32a96a@redhat.com>
Date:   Sun, 9 Aug 2020 19:23:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200809070235.GA1098081@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/20 09:02, Greg KH wrote:
>>>> diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
>>>> index 3932f76..a474578 100644
>>>> --- a/arch/mips/kvm/vz.c
>>>> +++ b/arch/mips/kvm/vz.c
>>>> @@ -29,7 +29,9 @@
>>>>   #include <linux/kvm_host.h>
>>>>   #include "interrupt.h"
>>>> +#ifdef CONFIG_CPU_LOONGSON64
>>>>   #include "loongson_regs.h"
>>>> +#endif
>>> The fix for this should be in the .h file, no #ifdef should be needed in
>>> a .c file.
>> The header file can only be reached when CONFIG_CPU_LOONGSON64 is
>> selected...
>> Otherwise the include path of this file won't be a part of CFLAGS.
> That sounds like you should fix up the path of this file in the
> #include line as well :)
> 

There is more #ifdef CONFIG_CPU_LOONGSON64 in arch/mips/kvm/vz.c, and
more #include "loongson_regs.h" in arch/mips.  So while I agree with
Greg that this idiom is quite unusual, it seems to be the expected way
to use this header.  I queued the patch.

Paolo

