Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8485BBF75
	for <lists+kvm@lfdr.de>; Sun, 18 Sep 2022 21:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiIRTEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Sep 2022 15:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIRTE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Sep 2022 15:04:29 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0A42A5;
        Sun, 18 Sep 2022 12:04:26 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e7d5329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7d5:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3BF0D1EC02F2;
        Sun, 18 Sep 2022 21:04:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663527861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=EWdwI+9F6KbF5P7EBjHLyJIqBo8SY/a75JkGfnay0dI=;
        b=U00QM7wSHikbt8CJZUY9HK8HpzlQnvUC7Msxf6QTULbZ/Qo651n+VVa/uZc/BJ+Vwn8cgi
        Kg+6Qi6TqSsIqXXSO95iiOFmeW/OusCe7Ar0JwQJNz2kEXGHTlcH44hJTDvCtnvHcR8JN6
        szhpScE/k56x/NxjnCXUvgaOC6uvYVM=
Date:   Sun, 18 Sep 2022 21:04:16 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, Avi Kivity <avi@redhat.com>,
        Babu Moger <babu.moger@amd.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org
Subject: Re: [PATCH 2/5] KVM: svm: Disallow EFER.LMSLE on hardware that
 doesn't support it
Message-ID: <YydrsMjAF5zjqTGK@zn.tnic>
References: <20220916045832.461395-1-jmattson@google.com>
 <20220916045832.461395-3-jmattson@google.com>
 <YyTZFzaDOufASxqd@google.com>
 <CALMp9eQXroxQYiWUCejd0Cj7kD5g5navWY_E2O_vzbVAQjLyNg@mail.gmail.com>
 <YyT0G9y0RRyBDiPD@zn.tnic>
 <YyT5uW8bjXae2c4l@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YyT5uW8bjXae2c4l@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 16, 2022 at 10:33:29PM +0000, Sean Christopherson wrote:
> ...
> Either way, KVM appears to be carrying a half-baked "fix" for a buggy guest that's
> long since gone.  So like we did in commit 8805875aa473 ("Revert "KVM: nVMX: Do not
> expose MPX VMX controls when guest MPX disabled""), I think we should just revert
> the "fix".

If, as message 0/5 says, setting this bit so that SLE11 Xen 4.0 boots as
a nested hypervisor is the use case, then sure, unconditional NO_LSMLE
and we all should go on with our lives.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
