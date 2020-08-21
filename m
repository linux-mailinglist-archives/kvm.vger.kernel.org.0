Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFD724CFCE
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 09:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgHUHoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 03:44:09 -0400
Received: from mail.skyhub.de ([5.9.137.197]:54898 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbgHUHoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 03:44:07 -0400
Received: from zn.tnic (p200300ec2f0eda00b4e1d8975031aaf0.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:da00:b4e1:d897:5031:aaf0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 46E9F1EC013E;
        Fri, 21 Aug 2020 09:44:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1597995844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=/VLxr4dUi7USeeH53ZvvCwvHownlzsBvY+Xuy61UjKo=;
        b=BqtZjh0NAJScy01jzq1+qUfXSNwhfhAg3MYPqqI2PqrZxlQurET3MwL21jiIYsRyQaIgV4
        o0Ljla4bj+XoBoe8K0/oSlA5gFH6OD5DJSuoTaAUuBTimWt9idwulji0ZHii9qPzwCPkER
        aJRPGIcE3ApMQh58HS3i6pkaidchShU=
Date:   Fri, 21 Aug 2020 09:44:00 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     peterz@infradead.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@intel.com>,
        Chang Seok Bae <chang.seok.bae@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] x86/entry/64: Disallow RDPID in paranoid entry if KVM is
 enabled
Message-ID: <20200821074400.GA12181@zn.tnic>
References: <20200821025050.32573-1-sean.j.christopherson@intel.com>
 <20200821072414.GH1362448@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200821072414.GH1362448@hirez.programming.kicks-ass.net>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 21, 2020 at 09:24:14AM +0200, peterz@infradead.org wrote:
> With distro configs that's going to be a guaranteed no_rdpid. Also with
> a grand total of 0 performance numbers that RDPID is even worth it, I'd
> suggest to just unconditionally remove that thing. Simpler code
> all-around.

I was just about to say the same thing - all this dancing around just to
keep RDPID better be backed by numbers, otherwise just remove the damn
thing in that path and use LSL and be done with it.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
