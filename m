Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFA96346075
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 14:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbhCWN5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 09:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbhCWN4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 09:56:42 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FC3C061574
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 06:56:41 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id x13so20858593wrs.9
        for <kvm@vger.kernel.org>; Tue, 23 Mar 2021 06:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p3wcqQCQg37yBHPW67f5Y5HGmvZBnyBJh1NzC0FDdWM=;
        b=nVws1zt4QCqFbFBjAqJvZaG9GO+JUiTUXKAoTNM7+grxjtxBeweM7Oi1G+vqfLcFvP
         WT++2PwobsKA9fAE8U1AB4s+iOaQPp2FT6W88Kzn5sK9rHySsy+7a3hu1Hr+/l5bzkhr
         4FmEyqwJk8nyWEXJj3v0dXDcA//6KfdmZtNWS7aH7n5aZ0TMTxlQYJzbUF9zh1zY08X5
         CpfYqhC0hqBG6af7sHLW3geiGS0pkQ514W6bmtORxO1nQQCVAlesyxvnODQoTWKSZNg3
         Z9dpIumATWTe/lnZrM6jcV9PogzGVWECBMkJrPRc7UL1ZaJfMAWCEJbFfQMpWy7dcE4X
         zUUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p3wcqQCQg37yBHPW67f5Y5HGmvZBnyBJh1NzC0FDdWM=;
        b=pftg2xLXybxsNgZg/SgV+KClTZZGgrxKHyPDl645QyykCRkOIcTkEdOCx509wRJigj
         g8pbDNOIGXnrOauLiLiXoRyLXYGdQg7LPtS04LG4FgZ4ZQat5nrEdfne+D4/VFGDBRgU
         nCj/CZzOBVcHcY7KIXndsIHsh09/sspr8a3NL39ePAR9fnpvvLLJ3ySPR0wNsYghf3/R
         f28zlDM5iPLiSR21RYUwqU4UQfko5yz86/sZkL2whSmm12NddjB1WBCTHmuVENjlxIDS
         c5xaPLiT89nl5wQTn57nekWTCwstPTV5RgSAKtoL6YSi38gRrmpkHEnEhQTNfwp3e7c1
         8ujA==
X-Gm-Message-State: AOAM531UC0jF102Ny6OJhRUE2Nh5PhBRbOIv0QuSzBxHcS1+TBx4FkgF
        hwYOu/qt0lWBy2Vvqxsjw+U=
X-Google-Smtp-Source: ABdhPJyIHdexSVASH3HCw8s/LIoz+R0OlSLjWuQXAEa+nQN1EWTwdCMcfNtYeaJw+N5L3oZcM720Cg==
X-Received: by 2002:a5d:5088:: with SMTP id a8mr4193027wrt.294.1616507800291;
        Tue, 23 Mar 2021 06:56:40 -0700 (PDT)
Received: from [192.168.1.36] (17.red-88-21-201.staticip.rima-tde.net. [88.21.201.17])
        by smtp.gmail.com with ESMTPSA id w131sm2886576wmb.8.2021.03.23.06.56.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 06:56:39 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH V13 2/9] meson.build: Re-enable KVM support for MIPS
To:     Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     Huacai Chen <zltjiangshi@gmail.com>,
        Thomas Huth <thuth@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <1602059975-10115-1-git-send-email-chenhc@lemote.com>
 <1602059975-10115-3-git-send-email-chenhc@lemote.com>
 <0dfbe14a-9ddb-0069-9d86-62861c059d12@amsat.org>
 <CAAhV-H63zhXyUizwOxUtXdQQOR=r82493tgH8NfLmgXF0g8row@mail.gmail.com>
 <9fc6161e-cf27-b636-97c0-9aca77d0f9cd@amsat.org>
 <CAAhV-H5wPZQ+TGdZL=mPV4YQcjHarJFoEH-nobr10PdesR-ySg@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <62b12fe2-01db-76c0-b2fd-f730b4157285@amsat.org>
Date:   Tue, 23 Mar 2021 14:56:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5wPZQ+TGdZL=mPV4YQcjHarJFoEH-nobr10PdesR-ySg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Huacai,

We are going to tag QEMU v6.0-rc0 today.

I only have access to a 64-bit MIPS in little-endian to
test KVM.

Can you test the other configurations please?
- 32-bit BE
- 32-bit LE
- 64-bit BE

Thanks!

Phil.

On 11/22/20 4:31 AM, Huacai Chen wrote:
> +CC Jiaxun
> 
> Hi, Jiaxun,
> 
> What do you think about?
> 
> Huacai
> 
> On Fri, Nov 20, 2020 at 6:55 PM Philippe Mathieu-Daudé <f4bug@amsat.org> wrote:
>>
>> On 11/20/20 5:28 AM, Huacai Chen wrote:
>>> On Wed, Nov 18, 2020 at 1:17 AM Philippe Mathieu-Daudé <f4bug@amsat.org> wrote:
>>>> On 10/7/20 10:39 AM, Huacai Chen wrote:
>>>>> After converting from configure to meson, KVM support is lost for MIPS,
>>>>> so re-enable it in meson.build.
>>>>>
>>>>> Fixes: fdb75aeff7c212e1afaaa3a43 ("configure: remove target configuration")
>>>>> Fixes: 8a19980e3fc42239aae054bc9 ("configure: move accelerator logic to meson")
>>>>> Cc: aolo Bonzini <pbonzini@redhat.com>
>>>>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
>>>>> ---
>>>>>  meson.build | 2 ++
>>>>>  1 file changed, 2 insertions(+)
>>>>>
>>>>> diff --git a/meson.build b/meson.build
>>>>> index 17c89c8..b407ff4 100644
>>>>> --- a/meson.build
>>>>> +++ b/meson.build
>>>>> @@ -59,6 +59,8 @@ elif cpu == 's390x'
>>>>>    kvm_targets = ['s390x-softmmu']
>>>>>  elif cpu in ['ppc', 'ppc64']
>>>>>    kvm_targets = ['ppc-softmmu', 'ppc64-softmmu']
>>>>> +elif cpu in ['mips', 'mips64']
>>>>> +  kvm_targets = ['mips-softmmu', 'mipsel-softmmu', 'mips64-softmmu', 'mips64el-softmmu']
>>>>
>>>> Are you sure both 32-bit hosts and targets are supported?
>>>>
>>>> I don't have hardware to test. If you are not working with
>>>> 32-bit hardware I'd remove them.
>>> When I add MIPS64 KVM support (Loongson-3 is MIPS64), MIPS32 KVM is
>>> already there. On the kernel side, MIPS32 KVM is supported, but I
>>> don't know whether it can work well.
>>
>> Well, from the history, you inherited from it:
>>
>> commit 1fa639e5618029e944ac68d27e32a99dcb85a349
>> Author: James Hogan <jhogan@kernel.org>
>> Date:   Sat Dec 21 15:53:06 2019 +0000
>>
>>     MAINTAINERS: Orphan MIPS KVM CPUs
>>
>>     I haven't been active for 18 months, and don't have the hardware
>>     set up to test KVM for MIPS, so mark it as orphaned and remove
>>     myself as maintainer. Hopefully somebody from MIPS can pick this up.
>>
>>
>> commit 134f7f7da12aad99daafbeb2a7ba9dbc6bd40abc
>> Author: Aleksandar Markovic <aleksandar.m.mail@gmail.com>
>> Date:   Mon Feb 24 12:50:58 2020 +0100
>>
>>     MAINTAINERS: Reactivate MIPS KVM CPUs
>>
>>     Reactivate MIPS KVM maintainership with a modest goal of keeping
>>     the support alive, checking common KVM code changes against MIPS
>>     functionality, etc. (hence the status "Odd Fixes"), with hope that
>>     this component will be fully maintained at some further, but not
>>     distant point in future.
>>
>>
>> commit 15d983dee95edff1dc4c0bed71ce02fff877e766
>> Author: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
>> Date:   Wed Jul 1 20:25:58 2020 +0200
>>
>>     MAINTAINERS: Adjust MIPS maintainership (Huacai Chen & Jiaxun Yang)
>>
>>     Huacai Chen and Jiaxun Yang step in as new energy [1].
>>
>>
>> commit ca263c0fb9f33cc746e6e3d968b7db80072ecf86
>> Author: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
>> Date:   Wed Oct 7 22:37:21 2020 +0200
>>
>>     MAINTAINERS: Remove myself
>>
>>     I have been working on project other than QEMU for some time,
>>     and would like to devote myself to that project. It is impossible
>>     for me to find enough time to perform maintainer's duties with
>>     needed meticulousness and patience.
>>
>>
>> QEMU deprecation process is quite slow, if we release mips-softmmu
>> and mipsel-softmmu binaries with KVM support in 5.2, and you can not
>> test them, you will still have to maintain them during 2021...
>>
>> If you don't have neither the hardware nor the time, I suggest you
>> to only release it on 64-bit hosts. Personally I'd even only
>> announce KVM supported on the little-endian binary only, because
>> AFAIK you don't test big-endian KVM neither.
>>
>> Your call as a maintainer, but remember last RC tag is next
>> Tuesday (Nov 24) in *4* days, then we release 5.2:
>> https://wiki.qemu.org/Planning/5.2#Release_Schedule
>>
>> Regards,
>>
>> Phil.
> 
