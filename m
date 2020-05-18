Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0BF1D7E48
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 18:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgERQWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 12:22:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45999 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728142AbgERQWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 12:22:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589818921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=98ZpnwHAx2gFbTHwDFEFfv30HBGfx3r1A/dVzSn7Vko=;
        b=AIZHomalYmVUdnyIIitekjgQ72QJjP3MjO0eutKKMPNuO0EcYSgAgxYFAMMuTPbEpyq8Xq
        7l/wLpYdZ3+4sjQK0FKKE/zM+r/wFSqib+cxa/OuE4yxBavWo8j/Wzffx3UMca5lrBTNKv
        cPuM/fKWyCTr62E6tTEnm5P7OFs/7Og=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-f9UtuF38OvWLh8d-hklhpQ-1; Mon, 18 May 2020 12:21:57 -0400
X-MC-Unique: f9UtuF38OvWLh8d-hklhpQ-1
Received: by mail-wr1-f70.google.com with SMTP id r14so5872783wrw.8
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 09:21:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=98ZpnwHAx2gFbTHwDFEFfv30HBGfx3r1A/dVzSn7Vko=;
        b=myMu5O6Ht2gwYKxPoiarOsgItNdTTmmP6x2IE6P2V2HBHbIvLg7V0fG+/tNn1012zR
         iYOXepNKOuYHV71qFr4OYsWsdSjtHI7khNqCORPeKDng5OXOecrRTcPSoIhmnbUZfSMP
         etUoIq1RUliX9910zw3N482E1CRn9ku2HheNnjLdONItWp0wL5nq3xMM6YpD/87ydY3l
         yOHECtFEWazkiOGVjcl39p9yEAEgYTkxalaOMmEbuYmuWAcWic19kiGKD4x6yMxPG5WF
         9t5CeJv0ZFmD6SILPmKezcNvfHKViS8uWIVa0FpHMYeJC5HOjCLLRZ4hJ2X0XakOfreY
         v0gg==
X-Gm-Message-State: AOAM533AJKHC6QtAo5i69Up0kS+rmMdWiC6rYnv8AgtBZRB98N4EqWGB
        8hs4bG1U36iunZo5O5OLatQUNi5zoZLREGCp+2ohswYI3i526qqAwZ/hecISsNcBnj+Ls1+ksBx
        GFK0aLcDRg4Zr
X-Received: by 2002:a5d:56c7:: with SMTP id m7mr20425762wrw.256.1589818916436;
        Mon, 18 May 2020 09:21:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNLpin204qLIT/3CoZ4qali1DTnEcMIdk0nKim3vnvtnA0qpBpc+ZafDtFysGupxsVNwrq6Q==
X-Received: by 2002:a5d:56c7:: with SMTP id m7mr20425739wrw.256.1589818916248;
        Mon, 18 May 2020 09:21:56 -0700 (PDT)
Received: from [192.168.1.38] (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id d4sm11139955wre.22.2020.05.18.09.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 09:21:55 -0700 (PDT)
Subject: Re: KVM call for agenda for 2020-05-19
To:     quintela@redhat.com, kvm-devel <kvm@vger.kernel.org>,
        qemu-devel@nongnu.org, "Daniel P . Berrange" <berrange@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Cleber Rosa <crosa@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Bin Meng <bin.meng@windriver.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        John Snow <jsnow@redhat.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Erik Skultety <eskultet@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Andrea Bolognani <abologna@redhat.com>,
        Bin Meng <bmeng.cn@gmail.com>
References: <87o8r24p2a.fsf@secure.mitica>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <133d4900-c852-f45d-ab19-a9253013fd20@redhat.com>
Date:   Mon, 18 May 2020 18:21:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87o8r24p2a.fsf@secure.mitica>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/20 1:08 PM, Juan Quintela wrote:
> 
> 
> Hi
> 
> Please, send any topic that you are interested in covering.

Last minute suggestion after recent IRC chat with Alex Bennée and Thomas 
Huth:

"Move some of the build/CI infrastructure to GitLab."

Pro/Con?

  - GitLab does not offer s390x/ppc64el => keep Travis for these?

How to coordinate efforts?

What we want to improve? Priorities?

Who can do which task / is motivated.

What has bugged us recently:
- Cross-build images (currently rebuilt all the time on Shippable)

Long term interests:

- Collect quality metrics
   . build time
   . test duration
   . performances
   . binary size
   . runtime memory used

- Collect code coverage

Note, this is orthogonal to the "Gating CI" task Cleber is working on:
https://www.mail-archive.com/qemu-devel@nongnu.org/msg688150.html

> 
> At the end of Monday I will send an email with the agenda or the
> cancellation of the call, so hurry up.
> 
> After discussions on the QEMU Summit, we are going to have always open a
> KVM call where you can add topics.
> 
>   Call details:
> 
> By popular demand, a google calendar public entry with it
> 
>    https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ
> 
> (Let me know if you have any problems with the calendar entry.  I just
> gave up about getting right at the same time CEST, CET, EDT and DST).
> 
> If you need phone number details,  contact me privately
> 
> Thanks, Juan.
> 
> 

