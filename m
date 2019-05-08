Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 574DC17EEE
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 19:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbfEHRO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 13:14:57 -0400
Received: from mail.skyhub.de ([5.9.137.197]:54892 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbfEHRO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 13:14:57 -0400
Received: from zn.tnic (p200300EC2F0F5800A4469260603C8E24.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:5800:a446:9260:603c:8e24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DA17B1EC027A;
        Wed,  8 May 2019 19:14:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1557335696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=qfc81kpXJcD0kZBxSWIYwIoKQZBpvRTR4z46Qw5UiZU=;
        b=FCzvq9/8m8fHtA38lqOwB6h58NCCCnrZ96YwqQxoKZlMTaDBuhP1GkHKO+ta6u51rv/Oc0
        gsJI86aoA3A86kGRjO6JbHW1yKKPjFVD9aicqZK4WKKGEZPDHiNix/nDc1t8xFNnZ81o0d
        QvtfrLwhgtxXkVZZS1ZRNRvFCyJHV9A=
Date:   Wed, 8 May 2019 19:14:50 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Liran Alon <liran.alon@oracle.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86/kvm/pmu: Set AMD's virt PMU version to 1
Message-ID: <20190508171450.GG19015@zn.tnic>
References: <20190508170248.15271-1-bp@alien8.de>
 <aba3fd5b-e1ba-df66-2414-3f1109b68bbb@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aba3fd5b-e1ba-df66-2414-3f1109b68bbb@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:08:44PM +0000, Lendacky, Thomas wrote:
> On 5/8/19 12:02 PM, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > After commit:
> > 
> >   672ff6cff80c ("KVM: x86: Raise #GP when guest vCPU do not support PMU")
> 
> You should add this commit as a fixes tag. Since that commit went into 5.1
> it would be worth this fix going into the 5.1 stable tree.

Paolo, Radim, can you do that pls, when applying?

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
