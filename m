Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECBED45E327
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 00:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346283AbhKYXEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 18:04:33 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55392 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346477AbhKYXCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 18:02:30 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637881157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ugt1G/SdWBE0wiro3gWnyQg72Gn0NEL2fJxJcz59nAQ=;
        b=EDuojfhYiSNzISCNz+VyzUGoLJ9FEpyD7l8aPYYMdg9P6YyGZHsPsLB9rMmw2bDOrHbMLL
        Aqb4S9P7+VSwvtFHqxQnXGLz5Byp/GkCFZMQrnSKrWHwKlI7mEZMj0YTKP+jyPunPugHd2
        tyWlR1COg2N9Vo6ETi+MHLish+26UB6B+RizRXVepK9eLjRibZ0UDk6AaX4XVsdDCEnL84
        uzlj3Gb+5s5O5ipdFeD1X00CCIl3vQPTlsqg7ksZlzNWSN3equvuZcO24iwbHdJEz5QvwO
        uzIkXalcYCgIrW+bcSxhD+9tqv8AcTF8XeeFvKh2kkOAhh3FSH1MO5hYK+viHA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637881157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ugt1G/SdWBE0wiro3gWnyQg72Gn0NEL2fJxJcz59nAQ=;
        b=HalzZrs3HOmU+qpVCTonO9kgEGhD1BiNmidP7QG1MKXUrFerKJAAJ5akBCOV0nl5h96ZeM
        7hgEn1q2dvlo/EDA==
To:     Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC PATCH v3 54/59] KVM: X86: Introduce initial_tsc_khz in
 struct kvm_arch
In-Reply-To: <741df444-5cd0-2049-f93a-c2521e4f426d@redhat.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <5ba3573c8b82fcbdc3f3994f6d4d2a3c40445be9.1637799475.git.isaku.yamahata@intel.com>
 <875ysghrp8.ffs@tglx> <741df444-5cd0-2049-f93a-c2521e4f426d@redhat.com>
Date:   Thu, 25 Nov 2021 23:59:16 +0100
Message-ID: <87wnkvhmez.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

On Thu, Nov 25 2021 at 23:13, Paolo Bonzini wrote:

> On 11/25/21 22:05, Thomas Gleixner wrote:
>> You can argue that my request is unreasonable until you are blue in
>> your face, it's not going to lift my NAK on this.
>
> There's no need for that.  I'd be saying the same, and I don't think 
> it's particularly helpful that you made it almost a personal issue.

To be entirely clear. It's a personal issue.

Being on the receiving end of a firehose which spills liquid manure for
more than 15 years is not a pleasant experience at all.

Being accused to have unreasonable, unactionable and even bizarre review
requests (mostly behind the scenes) is not helping either.

I'm dead tired of sitting down for hours explaining basics in lengthy
emails over and over just to get yet another experience of being ignored
after a couple of months filled with silence.

While I did not do that in this particular context, I read back on the
previous incarnations of this crud and found out that you are in the
exact same situation.

So what's the difference? Nothing at all.

It's about time that someone speaks up in unambiguous words to make it
entirely clear that this is not acceptable at all in the kernel
community as a whole and not just because a single person being
unreasonable or whatever.

Both of us wasted enough time already to explain how to do it
right. There is no point anymore to proliferate any of these political
correctness games further.

Thanks,

        Thomas
