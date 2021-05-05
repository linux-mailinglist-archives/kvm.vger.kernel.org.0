Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014EF374929
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 22:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbhEEUPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 16:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbhEEUPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 16:15:24 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C90AC061574;
        Wed,  5 May 2021 13:14:27 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620245662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AbGmMRiNMKB+TZlw4snRiE2422HlNMLdmQwwFPhOAp8=;
        b=Xrr954UAwj8T1t7PO1ed0sVw273t0gmUMHWznnFfDwl9/vgXcZ5aPCZs2kqZXwEtWorMC3
        O20goFrHIFOISoijtX+p1nPK7DGHi61p8PoXToYiTIDDwUQ3jWxuIkuT/FdiGziTY5IA0t
        zBxDog4Hs/+BreNaz5ObLMm4ZuXS/AJpmH9HHTbtgoZSVWqf096j/8Vvp3IofcxMUvZw5P
        D5L03tsQLDPZt/ZkOmLuUgSFZeb0o9VEc5RTT1TxjsUXQeDHGDqUO1BqNPQI5TorkhHnel
        NyoC2f/Uswa5s6e7dIZxQP2VzwtQVAD3hbl2e90ofrUvXt9C4JSsVUZJyI4cfw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620245662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AbGmMRiNMKB+TZlw4snRiE2422HlNMLdmQwwFPhOAp8=;
        b=bkHqfFa5jTvCQPivTjd6tHJs/DQAW9Lj4dkC6x380RcSpoDRCg0/ntH2757eUspirG3EYx
        SGsWPnSnXeI7QIDw==
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Frederic Weisbecker <frederic@kernel.org>
Subject: Re: [PATCH v4 3/8] KVM: x86: Defer vtime accounting 'til after IRQ handling
In-Reply-To: <20210505002735.1684165-4-seanjc@google.com>
References: <20210505002735.1684165-1-seanjc@google.com> <20210505002735.1684165-4-seanjc@google.com>
Date:   Wed, 05 May 2021 22:14:21 +0200
Message-ID: <87h7jhndk2.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 04 2021 at 17:27, Sean Christopherson wrote:
> Fixes: 87fa7f3e98a131 ("x86/kvm: Move context tracking where it belongs")
...
> Cc: stable@vger.kernel.org#v5.9-rc1+

Bah. Breaks skripts as this is really not a valid email address and
aside of that the Fixes tag already identifies clearly which kernel
versions this affects.

Thanks,

        tglx
