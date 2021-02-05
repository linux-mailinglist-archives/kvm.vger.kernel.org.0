Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87FC310A53
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 12:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhBELfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 06:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbhBELa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 06:30:26 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DF3C06178C;
        Fri,  5 Feb 2021 03:29:46 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1612524584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=25MzDHo8cvo805GqTp3ymG5etlk+7u28hiYRA4P/Uhw=;
        b=kvhJSIUqC/tY5pvHIf/BYbV6yMCjpZgPRahiBzAZu5HLoP4wjR0Hut5ytENaFrnGBHNjPT
        p8hxa6wXv7M2VVsBmdIybKr7XSx83HJp8M/u9ouAJ1MN4ZTlC7AfkQF2xILXdrq1NMlQ3o
        E73n7/vHDfPsdi6nkvTS7w1HHMdPABXku7g4vjJBEyMop1bC892EsQDGl3h4fJjkm5lC+9
        6tkxjDNAFfQryMozD0UzuCiGF9NfiCZ5rkp9RUbEQJ3a36ykE8K9Hhmc1qECZjwLJ9bvUs
        DvYOfZ/NngS7/EzSwqDtRd6Q1EZ7d6w92zfVGNMi9sLxCrPXmvziMLgSelP+2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1612524584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=25MzDHo8cvo805GqTp3ymG5etlk+7u28hiYRA4P/Uhw=;
        b=zTO0EUpz6sP08Ly0QDpE+JohhFmbCtYWqVY/pjligeYGx6RQQ62GesGFiFILguAVUvhocq
        aFlJiSmqBek8mdBw==
To:     Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "x86\@kernel.org" <x86@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v4 2/5] KVM: X86: Expose PKS to guest
In-Reply-To: <e90dadf9-a4ad-96f2-01fd-9f57b284fa3f@redhat.com>
References: <20210205083706.14146-1-chenyi.qiang@intel.com> <20210205083706.14146-3-chenyi.qiang@intel.com> <8768ad06-e051-250d-93ec-fa4d684bc7b0@redhat.com> <20210205095603.GB17488@zn.tnic> <e90dadf9-a4ad-96f2-01fd-9f57b284fa3f@redhat.com>
Date:   Fri, 05 Feb 2021 12:29:44 +0100
Message-ID: <87czxeah1z.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05 2021 at 11:10, Paolo Bonzini wrote:
> On 05/02/21 10:56, Borislav Petkov wrote:
>>> This would need an ack from the x86 people.  Andy, Boris?
>> 
>> This looks like the PKS baremetal pile needs to be upstream first.
>
> Yes, it does.  I would like to have an ack for including the above two 
> hunks once PKS is upstream.
>
> I also have CET and bus lock #DB queued and waiting for the bare metal 
> functionality, however they do not touch anything outside arch/x86/kvm.

What's the exact point of queueing random stuff which lacks bare metal
support?

Once PKS, CET or whatever is merged into tip then it's the point for
resending the KVM patches for inclusion and that's the point where it
gets acked and not $N month ahead when everything is still in flux.

Thanks,

        tglx


