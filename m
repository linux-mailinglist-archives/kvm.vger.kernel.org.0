Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63821DCEE2
	for <lists+kvm@lfdr.de>; Thu, 21 May 2020 16:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbgEUOFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 10:05:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38245 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728630AbgEUOFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 10:05:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590069903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1KWrwV1dtFMtu/4KkYPjzJvXwhFfafM3w3HVZXPt+m8=;
        b=EHN6x2U+DP2wbOTuhlLTgSwt2e2oGGRknOyKldqFxwzN/XZZxQSnGpVyaRwdiuv8njE7To
        AEstxiBLCSxysfxQAOT1QgmBsJZhIPiCEtcQjWruWUI9TM7Kig+lJDjRNGm7SNz2Zxa8v2
        TT9Lvf2QFJFMresMXC9QgrIX8WSnOso=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-kCHB4qmpP8K0quN8azbVpQ-1; Thu, 21 May 2020 10:05:01 -0400
X-MC-Unique: kCHB4qmpP8K0quN8azbVpQ-1
Received: by mail-wm1-f69.google.com with SMTP id b142so1168875wmb.6
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 07:05:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1KWrwV1dtFMtu/4KkYPjzJvXwhFfafM3w3HVZXPt+m8=;
        b=MI2/7XoJhK1+J5Ubp9N/H8JweeBBDdZjE9E5VfP40NlTt7ArvuNs5Kg8JhG7Odb8Mg
         keA4PYLHDvBvFgwzMDhIjq/qTDICdUVZf5VCyrE+VVlqT501NlcV288QYRxa463g+TXn
         BTNflABWRFXtlvVjNkcccWYkrbxdiI244WiitjpZhap1WrDrq0I6qeZ/MZmdqptkMI1h
         wTDlP8VesUpxgoPG1Amc0CzFHH4HOibP8M+Zcxglp6XVZHeK1GmenH3nVR/zya0uN5G4
         klK5/BFXIP+r9CkJ4TGE+zlo27nhAms2iMRqXBD0Rf1fxw0quz+bM6PenW8gVcpWiFoI
         PvkQ==
X-Gm-Message-State: AOAM5317Bs6QxUKQ7qyW7hQMkBRaWnA5JNqAA7NDx4oZR8h9XPjmwcVv
        5RnXJPbXI0heKiOVJnmrbMFJmXvu47C0UpsZhgN4ZzncKKHwNNKy1sSDPRG838PKyKUjyJoz3uS
        Qwaksew2Z1Ia7
X-Received: by 2002:a7b:c14e:: with SMTP id z14mr9629559wmi.9.1590069899879;
        Thu, 21 May 2020 07:04:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxdBRXiG4LHaSz6Ah14kKzAPztUjfiFhdLpLThi6vY3VpDKZLovxV3YoQOhhMpmNWwxtOi7HA==
X-Received: by 2002:a7b:c14e:: with SMTP id z14mr9629538wmi.9.1590069899623;
        Thu, 21 May 2020 07:04:59 -0700 (PDT)
Received: from [192.168.178.58] ([151.30.94.134])
        by smtp.gmail.com with ESMTPSA id 10sm6740082wmw.26.2020.05.21.07.04.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 07:04:59 -0700 (PDT)
Subject: Re: [PATCH V6 15/15] MAINTAINERS: Update KVM/MIPS maintainers
To:     Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Huacai Chen <chenhuacai@gmail.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <23cbe8a9-21a9-93a3-79aa-8ab17818a585@redhat.com>
Date:   Thu, 21 May 2020 16:04:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAHiYmc7ykeeF_w25785yiDjJf3AwOzfJybiS=LxfjYizn_2zEQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/20 13:04, Aleksandar Markovic wrote:
> I agree. E-mail address can be easily changed later.
> 
> I think it is reasonable that minor email tech problems should not stop
> this series.
> 
> I gather that at least approximate consensus is that v6 is "good to go".
> 
> While I am at this series, I just want to let everybody that there is a
> long-standing practice in QEMU for MIPS that we don't upstream
> changes that depend on kernel support that is not yet upstreamed
> in kernel - and I want to keep that practice in future (and not limited
> to KVM, but for all kernel/QEMU interdependant code).
> 
> In other words, corresponding Huacai's changes in QEMU will be
> kept on hold as long as this series is still not upstreamed in kernel.
> But, that was the original Huacai's plan anyway.

I am going to queue them for 5.8.

Thanks,

Paolo

