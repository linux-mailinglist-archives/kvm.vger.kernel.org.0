Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A732A32ED
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 19:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgKBSZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 13:25:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725797AbgKBSZp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Nov 2020 13:25:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604341543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+o/bB9EP07YOL4dqgg9GwgZ3GO1LsoTAhQkD4mTfT5A=;
        b=FZzvZq0HKTOXP6Wh/h3qOJFoVtMiP4rRof+MVq9Vzisf1BeHcrtJ92j1x8mR+ztVRSpygy
        yjbIGY2EwJbSWxBXK6UdSyIvqwYcE9scVAMS6WhheGtCoyE0v9cTnzDXmaF0vCRc6FtSnH
        j/tQI7fxKqw/fNSVQyw47QIGoEltV0U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-EJm2rP9OOxK84GN-nGwv2w-1; Mon, 02 Nov 2020 13:25:41 -0500
X-MC-Unique: EJm2rP9OOxK84GN-nGwv2w-1
Received: by mail-wm1-f69.google.com with SMTP id 8so777759wmg.6
        for <kvm@vger.kernel.org>; Mon, 02 Nov 2020 10:25:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+o/bB9EP07YOL4dqgg9GwgZ3GO1LsoTAhQkD4mTfT5A=;
        b=mU+qUwWCJbI87sjDsbfF7+3fiumrzAJ2A9GoqwQriiSrcA8S2BxoUhWJSbdGB8ny5Q
         ePmFfoMIxVC3KG7p4GZUeUfv8wQefTsg4nIkB3ClB5TzMGSFPi2R1fUCEPXVdgTTs/q8
         nOTzw/7zgR5cDlySFJV8FjdMgYGEtB0J2tBBWGk2wMc+7SCKZUn5XVH7RoJnfZ4FJcdq
         FhmoHiOSIS93TTPW+lFuY1Wiv0pR2uEi8XhRNFj+lI9E4mSpd8rus/AcnKSHLI1Tz4h2
         DwJafXWkXcmIEEl8pLLuqwvcXSczjbn+p+COoE3BjDY9BKasaD2tPq333/QPKJEwMrSm
         GE3w==
X-Gm-Message-State: AOAM530TVQB5BeWFi1wvfhZGaihVEAH6kT3QXAWK0wF1z8T3WButE9LB
        eMXqxM1XSK79f/gdmFC0jFYDtGvZl/w/4MAOEeZkqlkoLz3jyL+hUD6024qisBbguUch/f1C3AQ
        c9GG9wKE7up3T
X-Received: by 2002:a5d:694b:: with SMTP id r11mr22204585wrw.104.1604341539803;
        Mon, 02 Nov 2020 10:25:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXSdpsi5ZQDQAJrHzAL1GoYnCn54fkwAMr0C9bNDP+Wp//4+zuKH8Xx1x2vK2B9vH2SqxnqQ==
X-Received: by 2002:a5d:694b:: with SMTP id r11mr22204561wrw.104.1604341539641;
        Mon, 02 Nov 2020 10:25:39 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y20sm279284wma.15.2020.11.02.10.25.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 10:25:38 -0800 (PST)
Subject: Re: [PATCH] KVM: VMX: Enable Notify VM exit
To:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Tao Xu <tao3.xu@intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <20201102061445.191638-1-tao3.xu@intel.com>
 <CALCETrVqdq4zw=Dcd6dZzSmUZTMXHP50d=SRSaY2AV5sauUzOw@mail.gmail.com>
 <20201102173130.GC21563@linux.intel.com>
 <CALCETrV0ZsTcQKVCPPSKHnuVgERMC0x86G5y_6E5Rhf=h5JzsA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8e41101c-6278-3773-8754-ffe0763eaeea@redhat.com>
Date:   Mon, 2 Nov 2020 19:25:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CALCETrV0ZsTcQKVCPPSKHnuVgERMC0x86G5y_6E5Rhf=h5JzsA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/11/20 19:01, Andy Lutomirski wrote:
> What's the point?  Surely the kernel should reliably mitigate the
> flaw, and the kernel should decide how to do so.

There is some slowdown in trapping #DB and #AC unconditionally.  Though
for these two cases nobody should care so I agree with keeping the code
simple and keeping the workaround.

Also, why would this trigger after more than a few hundred cycles,
something like the length of the longest microcode loop?  HZ*10 seems
like a very generous estimate already.

Paolo

>>> I also think you should print a loud warning
>> I'm not so sure on this one, e.g. userspace could just spin up a new instance
>> if its malicious guest and spam the kernel log.
> pr_warn_once()?  If this triggers, it's a *bug*, right?  Kernel or CPU.
> 

