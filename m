Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EC034ECD6
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 17:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhC3Pol (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 11:44:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232010AbhC3Poh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 11:44:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617119076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LDZJQixAiy0XP5ZNxgyq9vArrZkoQ6gGXuNpfcu1N14=;
        b=JuGUBQi0MH2bkeL9W7x+osPIYqDn+DZS5W1Kgw99vtn1awZOGxGj+3rlvqmzYmORJVE6bm
        JeQlH+J47scPJbj/1MTTT+X6RAXx6yMgZUSuP4xSU3TKXBsRAAWIBR/SS+4mXSiSKcoZlS
        FfQAgbLPKZVrT2jaD22Fmoujrnz/db8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-qEfnnAvnO1i2T8y5lJW-nw-1; Tue, 30 Mar 2021 11:44:32 -0400
X-MC-Unique: qEfnnAvnO1i2T8y5lJW-nw-1
Received: by mail-wm1-f69.google.com with SMTP id j15so851356wmq.6
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 08:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LDZJQixAiy0XP5ZNxgyq9vArrZkoQ6gGXuNpfcu1N14=;
        b=j9tfIjm78tWWUW6zQTp5xWLJgEIx2nrU1N2S6uu7fkBGVY738Fkju1iKJvUNbBG4BX
         8N6+bwvQrupbV0DXJtSiC3y/Ti6tFzlAwUuvroZ+TjwKHqQllGLOGNR5MGYprSQx9HI/
         Re0rRmIZTXtSUprEMZKzverxq8Sdb7Ct6U4Yp2QYaNgVIXBG8jxQQ3zd7eH/0pSj5EnZ
         Xp5u/xo3ORNPMvUUdVO+/ZwkV023cMnpM1b5Dp1daY5OApwXUnREtMIvuBsBWYWV56Fx
         7CDhPF2nOgbRMDtPNq4yyXEyrizy2CtCfa4dSIJs3hCGaRgeOurHGybEzfriR/SMB2e6
         6FPA==
X-Gm-Message-State: AOAM53397cpweSXKrYOHidZx1tWgPhAhDy1GFc987xmJNlfqkvZizl8i
        nhbj53gv3JTAuUntqz3NBnrd5cahHhgiU4cHcxQuRtx7gPFBI38ZmK096w3RkTddHp+ofMeyc1g
        Z0kj3HshWbGIE
X-Received: by 2002:a05:6000:1789:: with SMTP id e9mr35123699wrg.237.1617119071575;
        Tue, 30 Mar 2021 08:44:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8WgXbyYDSViIj09RvjT4RXzob1gsY6gezcgHGzEqaSixHcmurLO7LHTW37JDMK3bRpWpZjQ==
X-Received: by 2002:a05:6000:1789:: with SMTP id e9mr35123684wrg.237.1617119071372;
        Tue, 30 Mar 2021 08:44:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x14sm34691534wrw.13.2021.03.30.08.44.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 08:44:30 -0700 (PDT)
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20210329114800.164066-1-vkuznets@redhat.com>
 <20210329114800.164066-2-vkuznets@redhat.com>
 <20210330131236.GA5932@fuller.cnet> <87ft0cu2eq.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: hyper-v: Properly divide maybe-negative
 'hv_clock->system_time' in compute_tsc_page_parameters()
Message-ID: <4d7f375c-c912-fbeb-edd1-03d742d49dcb@redhat.com>
Date:   Tue, 30 Mar 2021 17:44:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <87ft0cu2eq.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/03/21 16:44, Vitaly Kuznetsov wrote:
> We could've solved the problem by reducing the precision a bit and
> instead of doing
> 
>   now_ns = get_kvmclock_ns(kvm);
> 
> in KVM_SET_CLOCK() handling we could do
> 
>   now_ns = ka->master_kernel_ns
> 
> and that would make vcpu->hv_clock.system_time == 0 after
> kvm_guest_time_update() but it'd hurt 'normal' use-cases to fix the
> corner case.

Marcelo is right, and I guess instead of a negative system time you 
*should* have a slightly larger tsc_timestamp that corresponds to a zero 
system_time.  E.g. instead of -70 ns in the system time you'd have 210 
more clock cycles in the tsc_timestamp and 0 in the system time.

In the end it's impossible to achieve absolute precision; does the 
KVM_SET_CLOCK value refer to the nanosecond value before entering the 
kernel, or after, or what?  The difference is much more than these 70 
ns.  So what you propose above seems to be really the best solution 
within the constraints of the KVM_SET_CLOCK API (a better API, which 
Maxim had started working on and I should revisit, would pass a 
TSC+nanosecond pair).

On the other hand you'd have to take into account what happens if the 
masterclock is not in use, which would make things a bit more complex 
than what you sketched.  If guests probably do not look at the 
system_time and just add it blindly to the result, then treating 
system_time as signed as in v2 is the easiest.

Paolo

