Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896571DE0CA
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 09:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgEVHYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 03:24:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27578 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728409AbgEVHYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 03:24:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590132286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CiOMvxe2jHNY+2yIWreiVBjH4fPgrug0GPoTBvnau78=;
        b=YIdjWvqpmoCM6rX7Yz+Oxn5h/bP5YjJ/+5N/h4U+0MX7UnAaWLADK/91q8LALZTGZaVL1z
        D+Zz/kFx8Z7xTOMXbzU03SDgtj7yweQtnjFg/uMChUaVxayQg7HNxo5diYYcYbfub9MuX9
        /WxQ/WgVtU9B+05ZEG1RMb9YIwsFdOg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-tY5GdxjYPjeqsJtUN8rxEA-1; Fri, 22 May 2020 03:24:44 -0400
X-MC-Unique: tY5GdxjYPjeqsJtUN8rxEA-1
Received: by mail-ej1-f69.google.com with SMTP id pw1so4171294ejb.8
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 00:24:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CiOMvxe2jHNY+2yIWreiVBjH4fPgrug0GPoTBvnau78=;
        b=aamsgKPALWbCG3Cm34mr45PzhWyshJ2c91DR/+jhKur0A3cDNPB2KgbrHHZdrpR203
         sCloXE0d2Gym+y3jPzIrLaPwwX9KjfQZHgvHaj7l/kFhDVAkkuBNzbTZDzq6loginSBG
         YpxqdGAXBbO4npTYy/jjwBAj6oivwntZ5hAoEMxh/cAtbzVQyPJ7jirBSwfZUoY7joNH
         wHYcdMtaSR1S3L1r9vyhkLxwGH9grzr+d9qJ57kpthT240i7YfnciPpLCph8wF9GZUIK
         5z1eyvSQo6S5IFPHOUcIcBtrN8QmvU/qOkl0dz3boLHq2GYWr3lTQ/MT4TGet+5rT+Qd
         nA+A==
X-Gm-Message-State: AOAM530foCSL32L4UyLzvMXSUosUSnCkW/nln2ruWTl4bRe+rHYOwkB3
        4uaNMGGCopJci127jnyFhnD61822fDxmO/IXV/h4ozEK8g0TzIhNlUriw/Zj+4WjJoLsEHLH16b
        ZH3FS4ZCiYov0
X-Received: by 2002:a50:98a2:: with SMTP id j31mr1896937edb.79.1590132283080;
        Fri, 22 May 2020 00:24:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy2/7Lzq8aatk5F6PWyc98BYOgmkn0sJpKH2YvkgO4wyo00NuLPnQnbwFDtC82RVMWBjWDDzw==
X-Received: by 2002:a50:98a2:: with SMTP id j31mr1896925edb.79.1590132282901;
        Fri, 22 May 2020 00:24:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:71e6:9616:7fe3:7a17? ([2001:b07:6468:f312:71e6:9616:7fe3:7a17])
        by smtp.gmail.com with ESMTPSA id m11sm7116234ejq.49.2020.05.22.00.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 00:24:42 -0700 (PDT)
Subject: Re: [PATCH V6 15/15] MAINTAINERS: Update KVM/MIPS maintainers
To:     Huacai Chen <chenhuacai@gmail.com>
Cc:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
 <1589688372-3098-16-git-send-email-chenhc@lemote.com>
 <20200517082242.GA3939@alpha.franken.de>
 <CAHiYmc5m+UhWv__F_FKqhiTkJxgqErmFn5K_DAW2y5Pp6_4dyA@mail.gmail.com>
 <CAHiYmc4m7uxYU0coRGJS8ou=KyjC=DYs506NyXyw_-eKmPVJRQ@mail.gmail.com>
 <CAAhV-H4SspEUMLDTSZH3YmNbd+cRx3JK+mtsGo6cJ2NLKHPkKQ@mail.gmail.com>
 <CAHiYmc7ykeeF_w25785yiDjJf3AwOzfJybiS=LxfjYizn_2zEQ@mail.gmail.com>
 <23cbe8a9-21a9-93a3-79aa-8ab17818a585@redhat.com>
 <CAAhV-H6aGkxV41ymu+HPxiSBq9uw-QhmaxFxnZYJTfUay946cg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3269366b-7239-bb06-0bc6-cb661b9e5206@redhat.com>
Date:   Fri, 22 May 2020 09:24:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6aGkxV41ymu+HPxiSBq9uw-QhmaxFxnZYJTfUay946cg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/05/20 07:34, Huacai Chen wrote:
>> I am going to queue them for 5.8.
> Thank you for your help. But this series depends on an early patch
> from Jiaxun Yang ("MIPS: Loongson64: Probe CPU features via CPUCFG")
> which seems only in MIPS tree now. So, maybe this series is better be
> queued in Thomas's tree?
> 

That's not a problem, I can handle it during the merge window.  In the
future I'd ask for a topic branch or something like that.

Thanks for bringing KVM/MIPS back to life. :)

Paolo

