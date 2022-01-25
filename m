Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A841849B368
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 13:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384545AbiAYL5S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 06:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386397AbiAYLwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 06:52:17 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AC8C06173B
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 03:52:17 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id h21so1839876wrb.8
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 03:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UvMp193PoS06LEEbgYGKtC+blZdCQ25DvDgd/bF4SC0=;
        b=qljW6eSqw2ZAc1NQTn/fu3GiSH3VIuupNiPxMz3CQOx1FX9LPzmZWKxEt52lQyXxOO
         BNk60n32GoMBS1ypT4F8/FHt9R1X1Tvs8xR8EVrPeGNuSiseHUlBQe1ZXbmSWyvNOz9Z
         WmnOfqv1vHZNXP6SdjYNyVYmhR0Rk3sYuaWMQrE4hnSGCVA54U8/iJtlgDYC0jaCvVoK
         rlDp+dFu2CIgljeCh5uJS/9XnMusdrTOeTuR8cDSDuA/SsBOwHgLBCQoDYSk4kyvD5ec
         S3G59vBcB5vEa2NW3zHKIfORqk2PVwN3UR0h18EspZjj5WVCZMenVbmHbau23+wUt/ij
         jZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UvMp193PoS06LEEbgYGKtC+blZdCQ25DvDgd/bF4SC0=;
        b=XCEI5t4GNoleep+PUOD3Q2YIttA4qgrtuMpkhn2YVFrBGkl40XuEnYuISYYrwp57e2
         EEKZLPcfwM6PUUaGUP7/BztBPKojD31FlBWGkrH5apAFk7V/2MwsRKsRI8WiwHu8YIMY
         wEwnsxDFR1C4/hjiBe+sEzPUU70hnK3DxaE3Ir20HJBG1VfWMrH65ezub4KOPShVZa9W
         TuynBQeCn5g6MPmqIFdJdc6ailx1fpq0GM3HrJv4Chm/4Mglbtxs4pVzvt8wRPSf+HS2
         dMYRV3uMYTwS+h3FvwT49jzDha8dWjDPsggdK/dVGuBluoyTCoNNKPJ+2o8VZoCRWOK6
         VuVA==
X-Gm-Message-State: AOAM530SJ6Rc9FsdT347PIWusN/DOmcwFrLU8fCNhmbzewhdOxR/BqFr
        +ahniM2//nsl7kxyTdkjmHC2TMZXNXE=
X-Google-Smtp-Source: ABdhPJwAUw1Eo4C8TnVhJzmDB2/sDv6ZM3G61NWJa6CpLr81XPh8IQmtR2CuYtiFQWV0L9reNGoZrQ==
X-Received: by 2002:a05:6000:144f:: with SMTP id v15mr5735838wrx.423.1643111535923;
        Tue, 25 Jan 2022 03:52:15 -0800 (PST)
Received: from [192.168.1.40] (154.red-83-50-83.dynamicip.rima-tde.net. [83.50.83.154])
        by smtp.gmail.com with ESMTPSA id v124sm131315wme.30.2022.01.25.03.52.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 03:52:15 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Message-ID: <a3889b17-5976-0380-d846-dc5f84029e0c@amsat.org>
Date:   Tue, 25 Jan 2022 12:52:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: KVM call for agenda for 2022-01-25
Content-Language: en-US
To:     Markus Armbruster <armbru@redhat.com>,
        Juan Quintela <quintela@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm-devel <kvm@vger.kernel.org>
References: <87y2355xe8.fsf@secure.mitica> <87mtjk2gk8.fsf@dusky.pond.sub.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
In-Reply-To: <87mtjk2gk8.fsf@dusky.pond.sub.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 12:36, Markus Armbruster wrote:
> Juan Quintela <quintela@redhat.com> writes:
> 
>> Hi
>>
>> Please, send any topic that you are interested in covering.
>>
>> This week we have a continuation of 2 weeks ago call to discuss how to
>> enable creation of machines from QMP sooner on the boot.
>>
>> There was already a call about this 2 weeks ago where we didn't finished
>> everything.
>> I have been on vacation last week and I haven't been able to send a
>> "kind of resume" of the call.
>>
>> Basically what we need is:
>> - being able to create machines sooner that we are today
>> - being able to change the devices that are in the boards, in
>>   particular, we need to be able to create a board deciding what devices
>>   it has and how they are connected without recompiling qemu.
>>   This means to launch QMP sooner that we do today.
>> - Several options was proposed:
>>   - create a new binary that only allows QMP machine creation.
>>     and continue having the old command line
>>   - create a new binary, and change current HMP/command line to just
>>     call this new binary.  This way we make sure that everything can be
>>     done through QMP.
>>   - stay with only one binary but change it so we can call QMP sooner.
>> - There is agreement that we need to be able to call QMP sooner.
>> - There is NO agreement about how the best way to proceed:
>>   * We don't want this to be a multiyear effort, i.e. we want something
>>     that can be used relatively soon (this means that using only one
>>     binary can be tricky).
>>   * If we start with a new binary that only allows qmp and we wait until
>>     everything has been ported to QMP, it can take forever, and during
>>     that time we have to maintain two binaries.
>>   * Getting a new binary lets us to be more agreessive about what we can
>>     remove/change. i.e. easier experimentation.
>>   * Management Apps will only use QMP, not the command line, or they
>>     even use libvirt and don't care at all about qemu.  So it appears
>>     that HMP is only used for developers, so we can be loose about
>>     backwards compatibility. I.e. if we allow the same functionality,
>>     but the syntax is different, we don't care.
>>
>> Discussion was longer, but it was difficult to take notes and as I said,
>> the only thing that appears that everybody agrees is that we need an
>> agreement about what is the plan to go there.
>>
>> After discussions on the QEMU Summit, we are going to have always open a
>> KVM call where you can add topics.
>>
>>  Call details:
>>
>> By popular demand, a google calendar public entry with it
>>
>>   https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ
>>
>> (Let me know if you have any problems with the calendar entry.  I just
>> gave up about getting right at the same time CEST, CET, EDT and DST).
> 
> https://wiki.qemu.org/Contribute claims the call is at
> 
>     $ date -d 'TZ="America/New_York" Tuesday 10:00 am'
>     Tue Jan 25 16:00:00 CET 2022
> 
> Is that correct?

This was incorrect and now fixed, thanks!

Phil.
