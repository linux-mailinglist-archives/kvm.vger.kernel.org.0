Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB7D5BB44B
	for <lists+kvm@lfdr.de>; Sat, 17 Sep 2022 00:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiIPWJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 18:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiIPWJt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 18:09:49 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6D81209A;
        Fri, 16 Sep 2022 15:09:43 -0700 (PDT)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8B2D71EC0754;
        Sat, 17 Sep 2022 00:09:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663366177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=pi/ThYMMvWpMaKV1N3tail3zxhGqRMvrp+4EnPCu9OM=;
        b=jgHcd7ncTZaHyhMNg/eVeEADeladLatoLsLZViRGZoyhpbq8Vt1twRP/LQTFOpKzJkmm8f
        TrSWRqKGczffo+4tCK5/VUQ4JdxTJwInmmNLhckfVDpxA/Cy/pVHV11zJrS+RhmxFC9ney
        z84WGAWpfYiB0M2Sy3u9noW2Lm2U/y4=
Date:   Sat, 17 Sep 2022 00:09:31 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Avi Kivity <avi@redhat.com>, Babu Moger <babu.moger@amd.com>,
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
Message-ID: <YyT0G9y0RRyBDiPD@zn.tnic>
References: <20220916045832.461395-1-jmattson@google.com>
 <20220916045832.461395-3-jmattson@google.com>
 <YyTZFzaDOufASxqd@google.com>
 <CALMp9eQXroxQYiWUCejd0Cj7kD5g5navWY_E2O_vzbVAQjLyNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALMp9eQXroxQYiWUCejd0Cj7kD5g5navWY_E2O_vzbVAQjLyNg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 16, 2022 at 02:00:26PM -0700, Jim Mattson wrote:
> It's possible that SLES11 Xen 4.0 sets the bit, but never actually
> uses truncated segments in 64-bit mode. In any case, according to the
> original commit, it won't boot if setting EFER.LMSLE is not allowed.

How is SLE11 at all relevant to the upstream kernel?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
