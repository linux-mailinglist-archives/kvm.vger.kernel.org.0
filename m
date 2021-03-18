Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3AA3401D1
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 10:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhCRJUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 05:20:09 -0400
Received: from 8bytes.org ([81.169.241.247]:59542 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhCRJTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Mar 2021 05:19:44 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id C40F32D8; Thu, 18 Mar 2021 10:19:42 +0100 (CET)
Date:   Thu, 18 Mar 2021 10:19:41 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/3] KVM: SVM: allow to intercept all exceptions for debug
Message-ID: <YFMbLWLlGgbOJuN/@8bytes.org>
References: <20210315221020.661693-1-mlevitsk@redhat.com>
 <20210315221020.661693-4-mlevitsk@redhat.com>
 <YFBtI55sVzIJ15U+@8bytes.org>
 <4116d6ce75a85faccfe7a2b3967528f0561974ae.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4116d6ce75a85faccfe7a2b3967528f0561974ae.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 12:51:20PM +0200, Maxim Levitsky wrote:
> I agree but what is wrong with that? 
> This is a debug feature, and it only can be enabled by the root,
> and so someone might actually want this case to happen
> (e.g to see if a SEV guest can cope with extra #VC exceptions).

That doesn't make sense, we know that and SEV-ES guest can't cope with
extra #VC exceptions, so there is no point in testing this. It is more a
way to shot oneself into the foot for the user and a potential source of
bug reports for SEV-ES guests.


> I have nothing against not allowing this for SEV-ES guests though.
> What do you think?

I think SEV-ES guests should only have the intercept bits set which
guests acutally support.

Regards,

	Joerg
