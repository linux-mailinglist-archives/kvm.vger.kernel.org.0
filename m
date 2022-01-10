Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037D5489F09
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 19:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239012AbiAJSSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 13:18:48 -0500
Received: from mail.skyhub.de ([5.9.137.197]:35268 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238877AbiAJSSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 13:18:47 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 820621EC058B;
        Mon, 10 Jan 2022 19:18:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1641838721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=7SbeRV6UEdUsXzvAGrPNWS2oF82v/3ZWPDmaBetCX9c=;
        b=ORgY9flUVYOk47K8WIQ8w68tUAPNMKH/4Sq7uiwWHrmp7bXvKDgJD0ipPkSLf3UqvlekCJ
        A0nxvwrQVDbdVWi8w/VoeQ0m4MjmBCRWmoC2ZcWlaOjsAlSG6LxAwsU2opp0i+KVwnaMUF
        tCF5jeqa2HaoDUojVfWp4WobIGJYvtI=
Date:   Mon, 10 Jan 2022 19:18:49 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: Re: [PATCH v6 05/21] x86/fpu: Make XFD initialization in
 __fpstate_reset() a function argument
Message-ID: <Ydx4icAIOY6MFhLj@zn.tnic>
References: <20220107185512.25321-1-pbonzini@redhat.com>
 <20220107185512.25321-6-pbonzini@redhat.com>
 <YdiX5y4KxQ7GY7xn@zn.tnic>
 <BN9PR11MB527688406C0BDCF093C718858C509@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Ydvz0g+Bdys5JyS9@zn.tnic>
 <761a554a-d13f-f1fb-4faf-ca7ed28d4d3a@redhat.com>
 <YdxP0FVWEJa/vrPk@zn.tnic>
 <7994877a-0c46-07a5-eab0-0a8dd6244e9a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7994877a-0c46-07a5-eab0-0a8dd6244e9a@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 04:55:01PM +0100, Paolo Bonzini wrote:
> So this means that "the author must be the first SoB" is not an absolute
> rule.  In the case of this patch we had:
> 
> From: Jing Liu <jing2.liu@intel.com>
> ...
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Jing Liu <jing2.liu@intel.com>
> Signed-off-by: Yang Zhong <yang.zhong@intel.com>

Looking at Kevin's explanation, that should be:

Signed-off-by: Jing Liu <jing2.liu@intel.com>		# author
Signed-off-by: Yang Zhong <yang.zhong@intel.com>	# v1 submitter
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>	# handler/reviewer
Signed-off-by: Jing Liu <jing2.liu@intel.com>		# v2-v3 submitter
Signed-off-by: Yang Zhong <yang.zhong@intel.com>	# v4-v5 submitter

> and the possibilities could be:
> 
> 1) have two SoB lines for Jing (before and after Thomas)
> 
> 2) add a Co-developed-by for Thomas as the first line

If Thomas would prefer. But then it becomes:

Signed-off-by: Jing Liu <jing2.liu@intel.com>           # author
Signed-off-by: Yang Zhong <yang.zhong@intel.com>        # v1 submitter
Co-developed-by: Thomas Gleixner <tglx@linutronix.de>	# co-author
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>     # handler/reviewer
Signed-off-by: Jing Liu <jing2.liu@intel.com>           # v2-v3 submitter
Signed-off-by: Yang Zhong <yang.zhong@intel.com>        # v4-v5 submitter

and that means, Thomas worked on that patch *after* Yang submitted v1.
Which is the exact chronological order, as Kevin writes.

> 3) do exactly what the gang did ("remain practical and do only an SOB
> chain")

Yes, but not change the SOB order.

Because if you do that, then it doesn't state what the exact path was
the patch took and how it ended up upstream. And due to past fun stories
with SCO, we want to track exactly how a patch ended up upstream. And I
think this is the most important aspect of those SOB chains.

IMNSVHO.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
