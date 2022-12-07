Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9058A64615B
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 20:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiLGTBa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 14:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLGTB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 14:01:27 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6BD5C77E;
        Wed,  7 Dec 2022 11:01:26 -0800 (PST)
Received: from zn.tnic (p200300ea9733e711329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e711:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 02D641EC0426;
        Wed,  7 Dec 2022 20:01:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1670439685;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=P0I63OKAkNvlCHVBHDusHlnXPJvApvb5Iv1GJcbPNSQ=;
        b=OV6L3hD4mH3kTw7kFP+s0H+6SGGjOIQQYoNoTrRj0LRHUjmXnK3XdwQ2tvqGXqUzkbw7fU
        kz4EinJjOaixVyxG7GPq8mM1+f8REYU6s0dKw7bvxsQA2b3udvGV4Q9yJkZh1fBoyahemk
        oZR1qEBP3EYxDuyxfs/ykmJD5U9rnNk=
Date:   Wed, 7 Dec 2022 20:01:24 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH kernel 3/3] x86/sev: Do not handle #VC for DR7 read/write
Message-ID: <Y5DjBAH1P38hjJRP@zn.tnic>
References: <20221201021948.9259-1-aik@amd.com>
 <20221201021948.9259-4-aik@amd.com>
 <Y4jmmfrUXAzydM0G@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y4jmmfrUXAzydM0G@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 01, 2022 at 05:38:33PM +0000, Sean Christopherson wrote:
> Probably high time to add a helper/macro to convert the SEV_STATUS to
> the SEV_FEATURES field.

Nah, there's a couple of

MSR_AMD64_SEV*

defines in arch/x86/include/asm/msr-index.h.

Bit 5 should simply be added there.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
