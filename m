Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8486C35F9F2
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 19:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350589AbhDNRdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 13:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350550AbhDNRdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 13:33:49 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5A4C061574;
        Wed, 14 Apr 2021 10:33:27 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1618421604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VHYkutWhd3XDOHxlhaYrs/eOb/mUiSIbGoHrBUbGwd4=;
        b=L54ms7ECGAf//q0lab9ZXEz1wsAg3l9see3RQlKuL3b8ijGGUHLfKlUnAu8kL8Ddmy6FY9
        98N3I6Kk92jYD3LpJ7TxInbrvHxOmJ7mk9dopZDSrJjylzbhZiVlbtInuRdAgqp2VScuo1
        EmyOWY237KjPQ4GQ7XLFsdu9Cjc2Rs+xKa3AgW0gGtbd/AldTIWaV4banGQsLUszPU0rsp
        iF2fW4iy3EtU0MiKhUZ9IqmS/XHf+O4M12wKzaWcyAlOGyRhMz04dXqx050lAVu2+PuL4W
        OjP6pkxHanOoum3ceSWYn1W4YpMYWKq+HuMLLEn+RcAcnkPuMFqpkHBeTDXU+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1618421604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VHYkutWhd3XDOHxlhaYrs/eOb/mUiSIbGoHrBUbGwd4=;
        b=rPOxa3y3ojWkMOvYA0c0C46EBxdEXw8lCR9Q6jYr8/ePSALndzKSmfkN1sEPXnf5OqOlra
        azekQMN69oq80qAQ==
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [RFC PATCH 0/7] KVM: Fix tick-based vtime accounting on x86
In-Reply-To: <20210413182933.1046389-1-seanjc@google.com>
References: <20210413182933.1046389-1-seanjc@google.com>
Date:   Wed, 14 Apr 2021 19:33:24 +0200
Message-ID: <87wnt4vkij.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 13 2021 at 11:29, Sean Christopherson wrote:
> This is an alternative to Wanpeng's series[*] to fix tick-based accounting
> on x86.  The approach for fixing the bug is identical: defer accounting
> until after tick IRQs are handled.  The difference is purely in how the
> context tracking and vtime code is refactored in order to give KVM the
> hooks it needs to fix the x86 bug.
>
> x86 compile tested only, hence the RFC.  If folks like the direction and
> there are no unsolvable issues, I'll cross-compile, properly test on x86,
> and post an "official" series.

I like the final outcome of this, but we really want a small set of
patches first which actually fix the bug and is easy to backport and
then the larger consolidation on top.

Can you sort that out with Wanpeng please?

Thanks,

        tglx
