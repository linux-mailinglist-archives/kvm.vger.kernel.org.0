Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0941C39DE2D
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 15:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhFGOAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 10:00:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60818 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230237AbhFGOAR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 10:00:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623074305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qaZbcAf5eiKLkS93+DRSvuWGnuST7UIbnXTeiPSRJ1s=;
        b=GoQ4kFS2iDH3JHRcY1DDdeGU5nmcNfbBnkKWg+mPmz57N0PrXLArpwDxKDfLy54WX4A/1e
        04nQA3XYNzS30PCAryywRYlRxslaGUUq3UG4AGbkA/6CntwSYCfoLxa4xGPrsl7r/a5vBh
        PkDoMyWmiUEOtxEPhsF/OnEj6VIogZ0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-Fskpl6jHPNeigU8SMOnPmA-1; Mon, 07 Jun 2021 09:58:24 -0400
X-MC-Unique: Fskpl6jHPNeigU8SMOnPmA-1
Received: by mail-wm1-f71.google.com with SMTP id v2-20020a7bcb420000b0290146b609814dso12144wmj.0
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 06:58:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qaZbcAf5eiKLkS93+DRSvuWGnuST7UIbnXTeiPSRJ1s=;
        b=c8QCHhrId2VOHVQ8BY9oyNAanPILyTyofm2yLYd71DrX2Rdv1xjXlStoxuC5fUma9A
         JFZk8BXziGhk/jeR2obLBWsWJagwzjFmSAiOcqUCWlZoTYYoPh/ACrU8hJl/jveLM8cF
         /wploHAIIInFqmPhark0fJ8L1CAyL6pWbu1sMV9KBd5BiuNrWlxcbruPgZNHAAdxUMOv
         k7dyRhxvi0x8RTOWamFV/O5PfHFxi+Bd+/ymIAHOCs8F55fduldM+bGAk9GuBGOjJA5I
         9sAUuWJjTlsMpM9B01qeXZXqfoxyAls2HLKwCu2lfDh+HjdlTXxGcPsD2T50zPnNdijZ
         tBWA==
X-Gm-Message-State: AOAM533F78LSpEXW8wrJzpCf1tffBQSdehsBsfd4pfZ73PgjqiSq061q
        WUaHrsK5W9oAWe3nROl2ld+xrPAMXSHWMg2Vn2pxSrEMNhs+WqxpZowSW/u6HgfGdNc+jzvLf+E
        81Ugz9M0xfiJS
X-Received: by 2002:adf:f043:: with SMTP id t3mr16841809wro.422.1623074301930;
        Mon, 07 Jun 2021 06:58:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1MZD6Vvun57JTNyHHjVmCPd//9h6LSDBCJGLlCz6Ek50lE2EWGyJmwHb5DdxDm7nOe7TD0w==
X-Received: by 2002:adf:f043:: with SMTP id t3mr16841771wro.422.1623074301708;
        Mon, 07 Jun 2021 06:58:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id o18sm6406465wrx.59.2021.06.07.06.58.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 06:58:21 -0700 (PDT)
Subject: Re: [syzbot] WARNING in x86_emulate_instruction
To:     Dmitry Vyukov <dvyukov@google.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        syzkaller <syzkaller@googlegroups.com>
Cc:     syzbot <syzbot+71271244f206d17f6441@syzkaller.appspotmail.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, jarkko@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kan.liang@linux.intel.com,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>, steve.wahl@hpe.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        the arch/x86 maintainers <x86@kernel.org>
References: <000000000000f3fc9305c2e24311@google.com>
 <87v9737pt8.ffs@nanos.tec.linutronix.de>
 <0f6e6423-f93a-5d96-f452-4e08dbad9b23@redhat.com>
 <87sg277muh.ffs@nanos.tec.linutronix.de>
 <CANRm+CxaJ2Wu-f0Ys-1Fi7mo4FY9YBXNymdt142poSuND-K36A@mail.gmail.com>
 <CACT4Y+YDtBf1GebeAA=twsfuv9e0HN+w7Lt5ZqDJhMJ5-PWYXQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fa3c04ea-f27f-eeb2-d118-77f8fb805a8a@redhat.com>
Date:   Mon, 7 Jun 2021 15:58:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CACT4Y+YDtBf1GebeAA=twsfuv9e0HN+w7Lt5ZqDJhMJ5-PWYXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/21 12:34, Dmitry Vyukov wrote:
> On Fri, May 28, 2021 at 2:34 AM Wanpeng Li <kernellwp@gmail.com> wrote:
>>
>> On Fri, 28 May 2021 at 08:31, Thomas Gleixner <tglx@linutronix.de> wrote:
>>>
>>> On Fri, May 28 2021 at 01:21, Paolo Bonzini wrote:
>>>> On 28/05/21 00:52, Thomas Gleixner wrote:
>>>>>
>>>>> So this is stale for a week now. It's fully reproducible and nobody
>>>>> can't be bothered to look at that?
>>>>>
>>>>> What's wrong with you people?
>>>>
>>>> Actually there's a patch on list ("KVM: X86: Fix warning caused by stale
>>>> emulation context").  Take care.
>>>
>>> That's useful, but does not change the fact that nobody bothered to
>>> reply to this report ...
>>
>> Will do it next time. Have a nice evening, guys!
> 
> There was an idea to do this automatically by syzbot:
> 
> dashboard/app: notify bug report about fix patches
> https://github.com/google/syzkaller/issues/1574
> 
> Namely: if syzbot discovers a fix anywhere (by the hash), it could
> send a notification email to the bug report email thread.
> The downside is that the robot sends even more emails, so I am not
> sure how it will be accepted. Any opinions?

I would like it.  Usually somebody replies _before_ they start working 
on it, but sometimes they send a patch right away.

Paolo

