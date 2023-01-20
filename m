Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F195E67530C
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 12:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjATLIC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 06:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjATLIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 06:08:00 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3DA39297;
        Fri, 20 Jan 2023 03:07:58 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2CFAF1EC0606;
        Fri, 20 Jan 2023 12:07:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1674212877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=40oh1pHNa5pWx4jGamed6IL3y7gkerp1r2pzkAMoq2Q=;
        b=r00y4jQUVtDshG4tDAS91vdI7QjPCLD7pFdU+iVAYMASoniRY2/rbP59M/S67L5qjGNx+5
        1oOm3QQe/ipoBGU/6w8M0v5QtR2qq+nofQdVTsS1CeNYs10T2YYI3wFxzN+7Wr6ZteKYFA
        DKDwJ6NJ6CbtiorKDRcZkyYI6+RO4Eg=
Date:   Fri, 20 Jan 2023 12:07:57 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Kim Phillips <kim.phillips@amd.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/7] x86/cpu, kvm: Support AMD Automatic IBRS
Message-ID: <Y8p2DUtzoC409HYY@zn.tnic>
References: <20230116230159.1511393-1-kim.phillips@amd.com>
 <Y8aMiH74WFmVM5Rk@zn.tnic>
 <Y8nw/XLTpKhKbbdX@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y8nw/XLTpKhKbbdX@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 20, 2023 at 01:40:13AM +0000, Sean Christopherson wrote:
> Sorry, completely missed this.

Nothing to be sorry for - can't notice everything in the flood. :)

> There will be a minor conflict in KVM's reverse_cpuid, but it's trivial to resolve.
> I don't anticipate any other conflicts, so taking this through tip does seem like
> the best option.

Ok, thx.

> If possible, a new version to fix the bisection issues in patches 2 and 3 would
> be nice, but again it's not a big deal.  The breakage is very, very minor.

Yap, I've zapped them and their removal will take a bit to propagate to
linux-next.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
