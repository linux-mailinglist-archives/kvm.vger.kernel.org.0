Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752AC1295D1
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 13:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfLWMGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 07:06:33 -0500
Received: from mail.skyhub.de ([5.9.137.197]:58820 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726663AbfLWMGc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 07:06:32 -0500
Received: from zn.tnic (p200300EC2F0ED6007C3BCB4901AE3123.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:d600:7c3b:cb49:1ae:3123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A35131EC0391;
        Mon, 23 Dec 2019 13:06:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1577102790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Eujr/vAbQ2+cnbA/Y/6VFm+E4rkaCIhGe6e2vcZvass=;
        b=Q98VjP1I9b3remsMyKwJzpRUKaHZAGkbkSljIct6MbXJSaxbb/Zr2/0DAvMFaDOtdO0cJ2
        8skqG+iJpT//VlShtc9qkPMGbl6+gkVrMILWj8nHb/Hg3OVvInUZoAy5St4UzTF3/TWey9
        w84WUwbP9AWTpFtlXBLnJA4uSYQ0urk=
Date:   Mon, 23 Dec 2019 13:06:22 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     John Andersen <john.s.andersen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [RESEND RFC 2/2] X86: Use KVM CR pin MSRs
Message-ID: <20191223120622.GC16710@zn.tnic>
References: <20191220192701.23415-1-john.s.andersen@intel.com>
 <20191220192701.23415-3-john.s.andersen@intel.com>
 <CALCETrV1nOpc3mqyXTXOzw-8Aa3zFpGi1cY7oc_2pz2-JVyH8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrV1nOpc3mqyXTXOzw-8Aa3zFpGi1cY7oc_2pz2-JVyH8Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 22, 2019 at 11:39:19PM -0800, Andy Lutomirski wrote:
> FWIW, I think that handling these details through Kconfig is the wrong
> choice.  Distribution kernels should enable this, and they're not
> going to turn off kexec.

Nope, the other way around is way likely.

> Arguably kexec should be made to work -- there is no fundamental
> reason that kexec should need to fiddle with CR0.WP, for example. But
> a boot option could also work as a short-term option.

The problem with short-term solutions is that they become immutable
once people start using them. So it better be done right from the very
beginning, before it gets exposed.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
