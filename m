Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECA347556F
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 10:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241295AbhLOJtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 04:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241287AbhLOJtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 04:49:21 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AB2C06173F;
        Wed, 15 Dec 2021 01:49:20 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639561758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1lCJ3NbjTqIwHu6whJDvCeBv8J9e+geodL4/RUvckeU=;
        b=KbUEIBYMpT20qDzlouknlVuJRNIVD7Rx7y3C2/eRqLGl6za7spUkeOe239BHH+OZuILXpp
        DfzsWUbdE5QIPVNCTfaLSTogDYVQKDHOv2rvZjC8d6sfTb5mFq36UlhtQLcAs9W0g+rVuo
        vE2ruHl0Y5oaWAMQXNeNp9eHnheaq03e+oVKRa7XCcTRqDQOrDjS7fmVjojx9gI7NVWoOj
        TH5xyTnUZbw6iEzoQqBYVkOy4PgfesX0Me7GoH2VQhEpmE2G1QvjnctY3QsssQtbEgrLd9
        tS66oMXylHzFCMyMaRWMIVs+Alijn0w7fsbalSA5DZiqbPn4Km28gN+wq6lZ+Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639561758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1lCJ3NbjTqIwHu6whJDvCeBv8J9e+geodL4/RUvckeU=;
        b=g3rT5ofNlaqDZp1E32XFw+fcsJfmDupQEbTtEwjHrlZ7ok3Ulp8PYWlyn/BM1gW9PPblqC
        svQm90/tvCOu1SDw==
To:     "Liu, Jing2" <jing2.liu@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, Sean Christoperson <seanjc@google.com>,
        Jin Nakajima <jun.nakajima@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [patch 6/6] x86/fpu: Provide kvm_sync_guest_vmexit_xfd_state()
In-Reply-To: <62cc7ba5-8a46-2396-e728-cf5902c22306@linux.intel.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.108057289@linutronix.de>
 <62cc7ba5-8a46-2396-e728-cf5902c22306@linux.intel.com>
Date:   Wed, 15 Dec 2021 10:49:18 +0100
Message-ID: <87ee6erye9.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jing,

On Wed, Dec 15 2021 at 14:35, Jing2 Liu wrote:
> On 12/14/2021 10:50 AM, Thomas Gleixner wrote:
>> KVM can disable the write emulation for the XFD MSR when the vCPU's fpstate
>> is already correctly sized to reduce the overhead.
>>
>> When write emulation is disabled the XFD MSR state after a VMEXIT is
>> unknown and therefore not in sync with the software states in fpstate and
>> the per CPU XFD cache.
>>
>> Provide kvm_sync_guest_vmexit_xfd_state() which has to be invoked after a
>> VMEXIT before enabling interrupts when write emulation is disabled for the
>> XFD MSR.
> Thanks for this function.
>
> s/kvm_sync_guest_vmexit_xfd_state/fpu_sync_guest_vmexit_xfd_state
> in subject and changelog.

I clearly need more sleep.
