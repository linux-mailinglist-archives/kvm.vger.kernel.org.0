Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6811D742F
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 11:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgERJir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 05:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgERJir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 05:38:47 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00E3C061A0C;
        Mon, 18 May 2020 02:38:46 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jacE8-0006Sy-DK; Mon, 18 May 2020 11:38:28 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id D530B100606; Mon, 18 May 2020 11:38:27 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Anastassios Nanos <ananos@nubificus.co.uk>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/2] Expose KVM API to Linux Kernel
In-Reply-To: <CALRTab-mEYtRG4zQbSGoAri+jg8xNL-imODv=MWE330Hkt_t+Q@mail.gmail.com>
References: <cover.1589784221.git.ananos@nubificus.co.uk> <87y2ppy6q0.fsf@nanos.tec.linutronix.de> <CALRTab-mEYtRG4zQbSGoAri+jg8xNL-imODv=MWE330Hkt_t+Q@mail.gmail.com>
Date:   Mon, 18 May 2020 11:38:27 +0200
Message-ID: <87sgfxy44s.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anastassios Nanos <ananos@nubificus.co.uk> writes:
> On Mon, May 18, 2020 at 11:43 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> And this shows clearly how simple the user space is which is required to
>> do that. So why on earth would we want to have all of that in the
>> kernel?
>>
> well, the main idea is that all this functionality is already in the
> kernel. My view is that kvmmtest is as simple as kvmtest.

That still does not explain the purpose, the advantage and any reason
why this should be moreged.

> Moreover, it doesn't involve *any* mode switch at all while printing
> out the result of the addition of these two registers -- which I guess
> for a simple use-case like this it isn't much.  But if we were to
> scale this to a large number of exits (and their respective handling
> in user-space) that would incur significant overhead. Don't you agree?

No. I still do not see the real world use case you are trying to
solve. We are not going to accept changes like this which have no proper
justification, real world use cases and proper numbers backing it up.

Thanks,

        tglx


