Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187EA48945C
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 09:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241709AbiAJIz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 03:55:28 -0500
Received: from mail.skyhub.de ([5.9.137.197]:37638 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242607AbiAJIwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 03:52:38 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 200551EC057F;
        Mon, 10 Jan 2022 09:52:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1641804751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=KbNkHqNnB4sF1Vlw447CuxYzeQqnfPld8QZoUvnjLdk=;
        b=YpjGSjRV6yq177K7f/bMLhGrp0dLiM632/jLMNEjSED7wSUK2ZDRjCrzpPt/Xt59FPZaUp
        2elDnpryvzt2aIZ+YQ4QTR/mtEqLC+C97nHhShvqald7nmAjqFH3spxgml96GN8Nc9lV9h
        vy2lXYqBquIZmWHaTVhNoNhMQADu9Eg=
Date:   Mon, 10 Jan 2022 09:52:34 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
Message-ID: <Ydvz0g+Bdys5JyS9@zn.tnic>
References: <20220107185512.25321-1-pbonzini@redhat.com>
 <20220107185512.25321-6-pbonzini@redhat.com>
 <YdiX5y4KxQ7GY7xn@zn.tnic>
 <BN9PR11MB527688406C0BDCF093C718858C509@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527688406C0BDCF093C718858C509@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 05:15:44AM +0000, Tian, Kevin wrote:
> Thanks for pointing it out! Actually this is one area which we didn't get
> a clear answer from 'submitting-patches.rst'

Are you sure?

I see

"Any further SoBs (Signed-off-by:'s) following the author's SoB are from
people handling and transporting the patch, but were not involved in its
development. SoB chains should reflect the **real** route a patch took
as it was propagated to the maintainers and ultimately to Linus, with
the first SoB entry signalling primary authorship of a single author."

Now, when you read that paragraph, what do you think is the answer to
your question and why?

And if that paragraph doesn't make it clear, we would have to improve
it...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
