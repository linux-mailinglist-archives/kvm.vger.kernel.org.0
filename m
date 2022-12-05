Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E32664357F
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 21:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbiLEUUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 15:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiLEUUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 15:20:35 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B2624BFD;
        Mon,  5 Dec 2022 12:20:34 -0800 (PST)
Received: from zn.tnic (p200300ea9733e7ff329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7ff:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 60CCD1EC0495;
        Mon,  5 Dec 2022 21:20:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1670271633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=rzSa+Wsyy/7tHolsq+uIwTLK7rgEbXkeG0z5lGgrqQk=;
        b=Wbp2YupO4ZJpe1PQtTQtkJMqQRAoJH2w2QLKQtwN14ditkcAImMfeVh2fNhqbQzUm8BnOZ
        c7aqB/ibQd87InObtHHG+XrekM285qqAzm5evmz5XesqZoes8tghvuiOr3lGZJM6L5BLkx
        VYAX0KvbAWYIs3+i1OAJUFmmON+6oKY=
Date:   Mon, 5 Dec 2022 21:20:33 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/7] x86/cpu: Define a scattered No Nested Data
 Breakpoints feature bit
Message-ID: <Y45SkWalmZJ/zB1j@zn.tnic>
References: <20221201015003.295769-1-kim.phillips@amd.com>
 <20221201015003.295769-2-kim.phillips@amd.com>
 <Y43GpD9fgnOGNEcu@zn.tnic>
 <53393726-5a8a-1a13-c620-32c65872278c@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53393726-5a8a-1a13-c620-32c65872278c@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 05, 2022 at 11:32:01AM -0600, Kim Phillips wrote:
> This is starting to get off-topic. 

What does that mean?

Are you saying I'm not allowed to ask why stuff is added?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
