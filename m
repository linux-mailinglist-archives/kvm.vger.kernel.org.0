Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C3C2BA7D4
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 11:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbgKTKzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 05:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbgKTKzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 05:55:15 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41E1C0613CF
        for <kvm@vger.kernel.org>; Fri, 20 Nov 2020 02:55:14 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id r17so9625507wrw.1
        for <kvm@vger.kernel.org>; Fri, 20 Nov 2020 02:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xegj5JQ49GKHqGAXzz8gAZ1DY5LujJVgAIPZFdhOM48=;
        b=khE5rZYdcIAYRHncJd3g84jMHMi6sYINNMQRM3ddveU4a6WIeEjWZVMyUV/aOSzRxa
         SCP0oXtj348TM/lamxSWHwNGV0ZSLEVvLFShpuCqRuHeOJ0hew2hlsxrdGYV3spSs+oo
         +jVHOg9w/OpxpoDsWjHFFLQq1uB9vl+KQxvMnhDu9YTYsd4CnI6D7wwPn69MN6r86So8
         cSyghPxHZLw0bnZSUD0M7OEegnpt1U4uztN7y0O2P9cgMnlSs3URfXBxxAoyiHEMaLQL
         fdrT586UMDUrRIRw/3cG72rXETj0a3Qh3iuX+azx6FVx0h6jujyxpHjSCNHc4IZKvrj+
         5+qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xegj5JQ49GKHqGAXzz8gAZ1DY5LujJVgAIPZFdhOM48=;
        b=TQilV9lcnpIGUsOh8HnesMDRi7F657XKqHzbeSzKcMrKPhLMS6omSYRuWNGpZ1iR9T
         xK7ciocLJq8XrLfBTObPdjrvVaLqXIAz8sBrazcHDAUWhbBEUIGOSeePC9MmvO8Slixu
         6hGhPCgaGuzytdmZDL2qeQ2hCb3x0r/Yej+FJy2XAj9mBI8YZX35HR/cOhbk35Ud9QfI
         q0gRvga9SfTCwDo8L5bfLqjzdhMi9jcVUnFZNUt4GVLvTV8y84yjjhgLTKOvM9c3SdnN
         YHnajoF8Hlr0IAsWEftYfjMmV0tiQ6npNgeum81xZPI6zpJgQYbSOvwopErP3ICzi42o
         ON2w==
X-Gm-Message-State: AOAM533uNEd15U11Zv1CGA3N9aHhNTX9qfZEim4ipnSETaJDg211owMi
        BV68s29vsYYjayfb9LWqeWwXurqUnXo=
X-Google-Smtp-Source: ABdhPJx0EipjX4t399BIPjYxrECHma65KFQdU7n3dKcbzivp+b4NE1RibcdvoVhUMI42c+8VZVqQSQ==
X-Received: by 2002:a5d:438f:: with SMTP id i15mr15328794wrq.121.1605869713252;
        Fri, 20 Nov 2020 02:55:13 -0800 (PST)
Received: from [192.168.1.36] (234.red-83-42-66.dynamicip.rima-tde.net. [83.42.66.234])
        by smtp.gmail.com with ESMTPSA id e4sm2301525wrr.32.2020.11.20.02.55.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 02:55:12 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH V13 2/9] meson.build: Re-enable KVM support for MIPS
To:     Huacai Chen <chenhuacai@gmail.com>,
        Huacai Chen <chenhc@lemote.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Huacai Chen <zltjiangshi@gmail.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1602059975-10115-1-git-send-email-chenhc@lemote.com>
 <1602059975-10115-3-git-send-email-chenhc@lemote.com>
 <0dfbe14a-9ddb-0069-9d86-62861c059d12@amsat.org>
 <CAAhV-H63zhXyUizwOxUtXdQQOR=r82493tgH8NfLmgXF0g8row@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <9fc6161e-cf27-b636-97c0-9aca77d0f9cd@amsat.org>
Date:   Fri, 20 Nov 2020 11:55:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H63zhXyUizwOxUtXdQQOR=r82493tgH8NfLmgXF0g8row@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/20/20 5:28 AM, Huacai Chen wrote:
> On Wed, Nov 18, 2020 at 1:17 AM Philippe Mathieu-Daudé <f4bug@amsat.org> wrote:
>> On 10/7/20 10:39 AM, Huacai Chen wrote:
>>> After converting from configure to meson, KVM support is lost for MIPS,
>>> so re-enable it in meson.build.
>>>
>>> Fixes: fdb75aeff7c212e1afaaa3a43 ("configure: remove target configuration")
>>> Fixes: 8a19980e3fc42239aae054bc9 ("configure: move accelerator logic to meson")
>>> Cc: aolo Bonzini <pbonzini@redhat.com>
>>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
>>> ---
>>>  meson.build | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/meson.build b/meson.build
>>> index 17c89c8..b407ff4 100644
>>> --- a/meson.build
>>> +++ b/meson.build
>>> @@ -59,6 +59,8 @@ elif cpu == 's390x'
>>>    kvm_targets = ['s390x-softmmu']
>>>  elif cpu in ['ppc', 'ppc64']
>>>    kvm_targets = ['ppc-softmmu', 'ppc64-softmmu']
>>> +elif cpu in ['mips', 'mips64']
>>> +  kvm_targets = ['mips-softmmu', 'mipsel-softmmu', 'mips64-softmmu', 'mips64el-softmmu']
>>
>> Are you sure both 32-bit hosts and targets are supported?
>>
>> I don't have hardware to test. If you are not working with
>> 32-bit hardware I'd remove them.
> When I add MIPS64 KVM support (Loongson-3 is MIPS64), MIPS32 KVM is
> already there. On the kernel side, MIPS32 KVM is supported, but I
> don't know whether it can work well.

Well, from the history, you inherited from it:

commit 1fa639e5618029e944ac68d27e32a99dcb85a349
Author: James Hogan <jhogan@kernel.org>
Date:   Sat Dec 21 15:53:06 2019 +0000

    MAINTAINERS: Orphan MIPS KVM CPUs

    I haven't been active for 18 months, and don't have the hardware
    set up to test KVM for MIPS, so mark it as orphaned and remove
    myself as maintainer. Hopefully somebody from MIPS can pick this up.


commit 134f7f7da12aad99daafbeb2a7ba9dbc6bd40abc
Author: Aleksandar Markovic <aleksandar.m.mail@gmail.com>
Date:   Mon Feb 24 12:50:58 2020 +0100

    MAINTAINERS: Reactivate MIPS KVM CPUs

    Reactivate MIPS KVM maintainership with a modest goal of keeping
    the support alive, checking common KVM code changes against MIPS
    functionality, etc. (hence the status "Odd Fixes"), with hope that
    this component will be fully maintained at some further, but not
    distant point in future.


commit 15d983dee95edff1dc4c0bed71ce02fff877e766
Author: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Wed Jul 1 20:25:58 2020 +0200

    MAINTAINERS: Adjust MIPS maintainership (Huacai Chen & Jiaxun Yang)

    Huacai Chen and Jiaxun Yang step in as new energy [1].


commit ca263c0fb9f33cc746e6e3d968b7db80072ecf86
Author: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Date:   Wed Oct 7 22:37:21 2020 +0200

    MAINTAINERS: Remove myself

    I have been working on project other than QEMU for some time,
    and would like to devote myself to that project. It is impossible
    for me to find enough time to perform maintainer's duties with
    needed meticulousness and patience.


QEMU deprecation process is quite slow, if we release mips-softmmu
and mipsel-softmmu binaries with KVM support in 5.2, and you can not
test them, you will still have to maintain them during 2021...

If you don't have neither the hardware nor the time, I suggest you
to only release it on 64-bit hosts. Personally I'd even only
announce KVM supported on the little-endian binary only, because
AFAIK you don't test big-endian KVM neither.

Your call as a maintainer, but remember last RC tag is next
Tuesday (Nov 24) in *4* days, then we release 5.2:
https://wiki.qemu.org/Planning/5.2#Release_Schedule

Regards,

Phil.
