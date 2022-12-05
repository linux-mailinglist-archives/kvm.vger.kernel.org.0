Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E29A642C35
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiLEPq4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiLEPqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:46:54 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE697674;
        Mon,  5 Dec 2022 07:46:53 -0800 (PST)
Received: from zn.tnic (p200300ea9733e72f329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e72f:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 25DE81EC06C0;
        Mon,  5 Dec 2022 16:46:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1670255212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=RDclFLuRpV1DaR1+wbzZWBt8G924zSymdLgD/1sLPGQ=;
        b=mDYiNrRpxM6eo58PnW9ouDXyVK0sJsicgWX2LIQe625M3zloUbAXPnMfxt2LigkmafoO7u
        iq30zEWp4lf15F1tTaOqTgcA0oqlVB1BgAIW27N4FY8laz9ZBPU+TO80yXIwJe0lqQO8L2
        wc5sAUZMiGZwv12oFmr0n7AoqzfSbsk=
Date:   Mon, 5 Dec 2022 16:46:48 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
        tglx@linutronix.de, dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, michael.roth@amd.com, stable@kernel.org
Subject: Re: [PATCH v2] x86/sev: Add SEV-SNP guest feature negotiation support
Message-ID: <Y44SaBfAG4D9t0Xr@zn.tnic>
References: <20221201100423.7117-1-nikunj@amd.com>
 <Y44Amf9MJIIi4Ric@zn.tnic>
 <896d1b00-1602-2a0f-b50c-0582d5219039@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <896d1b00-1602-2a0f-b50c-0582d5219039@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 05, 2022 at 09:23:17AM -0600, Tom Lendacky wrote:
> This makes it sound like these features are required to run SNP, which
> they're not. It's that we can't run SNP with these features without support
> in the guest. So while the patch name is long, it is accurate.

Maybe, but it is a mouthful this way. And unreadable. And there's plenty
of comments explaining what it is. And it is used in one place only.

> Maybe SNP_FEATURES_NEED_IMPLEMENTATION if you want to shorten it a little?

"need implementation" where? Host? Guest?

I.e., we're relying on comments to explain what the name is, one way or
the other.

How about a short and sweet:

		if (sev_status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_PRESENT)

along with the explanation in a comment above it. Comment which is a
must regardless.

Hmm.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
