Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8683A35E99
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 16:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbfFEOEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 10:04:25 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:42383 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727883AbfFEOEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 10:04:25 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hYWWL-0003U6-VZ; Wed, 05 Jun 2019 16:04:06 +0200
Date:   Wed, 5 Jun 2019 16:04:05 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Borislav Petkov <bp@suse.de>, Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jann Horn <jannh@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        kvm ML <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Rik van Riel <riel@surriel.com>, x86-ml <x86@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [5.2 regression] copy_fpstate_to_sigframe() change causing crash
 in 32-bit process
Message-ID: <20190605140405.2nnpqslnjpfe2ig2@linutronix.de>
References: <20190604185358.GA820@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190604185358.GA820@sol.localdomain>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-06-04 11:53:58 [-0700], Eric Biggers wrote:
> On latest Linus' tree I'm getting a crash in a 32-bit Wine process.
> 
> I bisected it to the following commit:
> 
> commit 39388e80f9b0c3788bfb6efe3054bdce0c3ead45
> Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Date:   Wed Apr 3 18:41:35 2019 +0200
> 
>     x86/fpu: Don't save fxregs for ia32 frames in copy_fpstate_to_sigframe()
> 
> Reverting the commit by applying the following diff makes the problem go away.

This looked like a merge artifact and it has been confirmed as such. Now
you say that this was a needed piece of code. Interesting.
Is that wine process/testcase something you can share? I will try to
take a closer look.

Sebastian
