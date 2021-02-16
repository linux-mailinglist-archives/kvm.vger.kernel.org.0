Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3B631CA2C
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 12:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhBPLvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Feb 2021 06:51:18 -0500
Received: from mail.skyhub.de ([5.9.137.197]:58288 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229917AbhBPLtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Feb 2021 06:49:42 -0500
Received: from zn.tnic (p200300ec2f07cd0057261f4475df3a88.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:cd00:5726:1f44:75df:3a88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 036B11EC0513;
        Tue, 16 Feb 2021 12:48:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1613476128;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=EjcN+C9OEcip32uXphpwWcG+iA24+Mq+utGWrVnGSsY=;
        b=Gm0IvgZYIbndQN0RxRNcBt+ubgcBh0zl5auGOLptSWzyf7A1W24A86mRReovwI6Da4eH8z
        GO2U1weGN0AEDYKsm3QoDTMGeF1Oz2S+OBw3jPCeU7Dakv9WXDcI0dQ2iUvQE5iSbObksH
        7JE/P66jUWtbldpEwo4FWZKrr7/1P2w=
Date:   Tue, 16 Feb 2021 12:48:51 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [RFC PATCH v5 08/26] x86/sgx: Expose SGX architectural
 definitions to the kernel
Message-ID: <20210216114851.GD10592@zn.tnic>
References: <cover.1613221549.git.kai.huang@intel.com>
 <1d6fe6bd392b604091b57842c15cc5460aa92593.1613221549.git.kai.huang@intel.com>
 <YCsrNqcB1C0Tyxz9@kernel.org>
 <cdc73d737d634e778de4c691ca4fd080@intel.com>
 <20210216103218.GB10592@zn.tnic>
 <a792bf6271da4fddb537085845cf868f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a792bf6271da4fddb537085845cf868f@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 16, 2021 at 11:15:35AM +0000, Huang, Kai wrote:
> Sorry I am not sure I understand your question. Could you elaborate?
>
> IMHO it's better to put architectural staff (such as data structures
> defined in SDM and used by hardware) into one header, and other
> non-architectural staff into another header, so that the user can
> include the one that is actually required, but doesn't have to include
> one big header which includes all SGX related data structures and
> functions.

And including one big - (not sure about "big" - we have a lot bigger) -
header is an actual problem because?

What I'm trying to point you at is, to not give some artificial reasons
why the headers should be separate - artificial as the SDM says it
is architectural and so on - but give a reason from software design
perspective why the separation is needed: better build times, less
symbols exposed to modules, blabla and so on.

If you don't have such reasons, then it all is just unnecessary and
not needed churn. And in that case, keeping it simple is the proper
approach.

Those headers can always be split later, when really needed.

HTH.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
