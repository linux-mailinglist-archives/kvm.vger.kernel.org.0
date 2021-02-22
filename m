Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47603321EC9
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 19:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhBVSGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 13:06:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23965 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230437AbhBVSGI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 13:06:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614017081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SSsnX5SjnKwxu3rr90T4nBZzi1MZ/dtXAKPK6GY/CHA=;
        b=OZiOmE6m/jD0XPsSqTgs66nSkG6nyiMaWcOsKpFfBz5UPyABejUi0e8Varm93xYrgJOxal
        xiHSXD4vO0TF+T45VaXvDYKOmJQkO7pB5/n7eR53+VTVkYk2ZdiKy0vCT77QaiLrvP2eB7
        0tjoJY4pqI1lIdLhFMbXuQA+jThdjmE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-Ke7zSFnMMP2VDhwauLITQw-1; Mon, 22 Feb 2021 13:04:37 -0500
X-MC-Unique: Ke7zSFnMMP2VDhwauLITQw-1
Received: by mail-ed1-f71.google.com with SMTP id d3so7457632edk.22
        for <kvm@vger.kernel.org>; Mon, 22 Feb 2021 10:04:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SSsnX5SjnKwxu3rr90T4nBZzi1MZ/dtXAKPK6GY/CHA=;
        b=mh3pmwws9abvtMVhfpUGFR6AC39SEIO1/Xgyvmqc18VkVhnlRgznRMG6WmMNfcCVT7
         GdXT2hX1+5ASqsYY7mkRQiVcatQFsnOuBTkC202RC8dLFZRyrhrESSAoHAusrm5mItqh
         CMhth6+zDvGQuM6aSlfa7+rUJP7QsaL54oZmQRI5cAay9HHIcWL9yQSDvpT8tN7ZLIdh
         q78uBpvxEv4JxJh4zoRazSDXc779iRpgPdfr4lHntzchXGIJ6A5qdtdBx4Kyl3rZmKRB
         RxXk9RqQeR7UzlQ/Z3C6uqcTvtGpDlXIP3NaLkuJa4YgpO4EKAD12dzzHnDaC1pSZdYg
         HzPw==
X-Gm-Message-State: AOAM5301+mvhJLWb/c4k6IUYjFzB3CLcfObrXxQEkagQlN2EvgHowWeq
        lMRYpfaWJr9rByY8QdGHephhjXQuJJnOEjWfoqPy6GzIbj0bh8Ontguyid/yFELSHMB0KsEx1wd
        ozoP5DsdICo5N
X-Received: by 2002:a17:906:7e42:: with SMTP id z2mr21995943ejr.177.1614017076007;
        Mon, 22 Feb 2021 10:04:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz/JC++82lk2ObRrXbPMXgvjOy+aii8aMRtQqY2wAzax0ZKP5G6jLvuYpnN+D+qmV72Wu/wKA==
X-Received: by 2002:a17:906:7e42:: with SMTP id z2mr21995909ejr.177.1614017075776;
        Mon, 22 Feb 2021 10:04:35 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id b27sm7825403eja.64.2021.02.22.10.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 10:04:35 -0800 (PST)
Subject: Re: [PATCH v2 01/11] accel/kvm: Check MachineClass kvm_type() return
 value
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     qemu-devel@nongnu.org, Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Leif Lindholm <leif@nuviainc.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alistair Francis <alistair@alistair23.me>,
        Paul Durrant <paul@xen.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
References: <20210219173847.2054123-1-philmd@redhat.com>
 <20210219173847.2054123-2-philmd@redhat.com>
 <20210222182405.3e6e9a6f.cohuck@redhat.com>
 <bc37276d-74cc-22f0-fcc0-4ee5e62cf1df@redhat.com>
 <20210222185044.23fccecc.cohuck@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <0f2a252e-34d8-6714-d1fd-d4e3764feef7@redhat.com>
Date:   Mon, 22 Feb 2021 19:04:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210222185044.23fccecc.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/21 6:50 PM, Cornelia Huck wrote:
> On Mon, 22 Feb 2021 18:41:07 +0100
> Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
> 
>> On 2/22/21 6:24 PM, Cornelia Huck wrote:
>>> On Fri, 19 Feb 2021 18:38:37 +0100
>>> Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
>>>   
>>>> MachineClass::kvm_type() can return -1 on failure.
>>>> Document it, and add a check in kvm_init().
>>>>
>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>>> ---
>>>>  include/hw/boards.h | 3 ++-
>>>>  accel/kvm/kvm-all.c | 6 ++++++
>>>>  2 files changed, 8 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/hw/boards.h b/include/hw/boards.h
>>>> index a46dfe5d1a6..68d3d10f6b0 100644
>>>> --- a/include/hw/boards.h
>>>> +++ b/include/hw/boards.h
>>>> @@ -127,7 +127,8 @@ typedef struct {
>>>>   *    implement and a stub device is required.
>>>>   * @kvm_type:
>>>>   *    Return the type of KVM corresponding to the kvm-type string option or
>>>> - *    computed based on other criteria such as the host kernel capabilities.
>>>> + *    computed based on other criteria such as the host kernel capabilities
>>>> + *    (which can't be negative), or -1 on error.
>>>>   * @numa_mem_supported:
>>>>   *    true if '--numa node.mem' option is supported and false otherwise
>>>>   * @smp_parse:
>>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>>> index 84c943fcdb2..b069938d881 100644
>>>> --- a/accel/kvm/kvm-all.c
>>>> +++ b/accel/kvm/kvm-all.c
>>>> @@ -2057,6 +2057,12 @@ static int kvm_init(MachineState *ms)
>>>>                                                              "kvm-type",
>>>>                                                              &error_abort);
>>>>          type = mc->kvm_type(ms, kvm_type);
>>>> +        if (type < 0) {
>>>> +            ret = -EINVAL;
>>>> +            fprintf(stderr, "Failed to detect kvm-type for machine '%s'\n",
>>>> +                    mc->name);
>>>> +            goto err;
>>>> +        }
>>>>      }
>>>>  
>>>>      do {  
>>>
>>> No objection to this patch; but I'm wondering why some non-pseries
>>> machines implement the kvm_type callback, when I see the kvm-type
>>> property only for pseries? Am I holding my git grep wrong?  
>>
>> Can it be what David commented here?
>> https://www.mail-archive.com/qemu-devel@nongnu.org/msg784508.html
>>
> 
> Ok, I might be confused about the other ppc machines; but I'm wondering
> about the kvm_type callback for mips and arm/virt. Maybe I'm just
> confused by the whole mechanism?

For MIPS see https://www.linux-kvm.org/images/f/f2/01x08a-MIPS.pdf
and Jiaxun comment here:
https://lore.kernel.org/linux-mips/a2a2cfe3-5618-43b1-a6a4-cc768fc1b9fb@www.fastmail.com/

TE KVM: Trap-and-Emul guest kernel
VZ KVM: HW Virtualized

For "the whole mechanism" I'll defer to Paolo =)

