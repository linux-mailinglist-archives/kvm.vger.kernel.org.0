Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322A83D1845
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 22:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhGUUBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 16:01:10 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49480 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhGUUBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 16:01:09 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1626900104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pYyuPW5FJIu3tgCq8FKCorVxxp/vMvZIWdfln22leig=;
        b=e9LBD9HlyFp6DpiTJ1PWnyzDvZmgj2a4WNyCsLKJdEqHKrPgYEmnYBtKCO9PaZDb9cXQxa
        K3d3LdF0ymF+11ucI39AH+KK4tN1EGY3tZXcy4mTmij9LUD4J1d+2UJxd4wdisibQ5WAIa
        I8LSoywSYR89igrTrBIKC6GRpo6HRHV8BzhhkSRzeI11vPFdAw1AwdXz5v574Jmir9HHkO
        o0bX7vLnZK7l+ZzRHXSRW2hfAYV4t4rnFPuwRqHPOOA/iihBcK0KUJQPfPiOuGjO457nJK
        uzZIFChshy3BWoG77MnwExvuvxs0XQ188t3LxNO4Xzlmu0r7z+20dIyUqhpewg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1626900104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pYyuPW5FJIu3tgCq8FKCorVxxp/vMvZIWdfln22leig=;
        b=fftqG2Cd14+qBetFEvC+XZswiGbHcFqDGZqpWoJp8dLjUSREim3tSBJ5OWfgwKAa3rHPQK
        T8wWIP84syRRx+BA==
To:     Bjorn Helgaas <helgaas@kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     Nikolai Zhubr <zhubr.2@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] x86: PIRQ/ELCR-related fixes and updates
In-Reply-To: <20210721001237.GA144325@bjorn-Precision-5520>
References: <20210721001237.GA144325@bjorn-Precision-5520>
Date:   Wed, 21 Jul 2021 22:41:43 +0200
Message-ID: <87mtqfpfg8.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 20 2021 at 19:12, Bjorn Helgaas wrote:
> On Tue, Jul 20, 2021 at 05:27:43AM +0200, Maciej W. Rozycki wrote:
>> -- a lot of sharing and swizzling here. :)  You'd most definitely need: 
>> <https://lore.kernel.org/patchwork/patch/1454747/> for that though, as I 
>> can't imagine PCI BIOS 2.1 PIRQ routers to commonly enumerate devices 
>> behind PCI-to-PCI bridges, given that they fail to cope with more complex 
>> bus topologies created by option devices in the first place.
>
> Looks nicely done but I have no ability to review or test, so I assume
> the x86 folks will take care of this.

I can review it and pick it up, but for testing I have to rely on the
reporter/submitters.

Thanks,

        tglx
