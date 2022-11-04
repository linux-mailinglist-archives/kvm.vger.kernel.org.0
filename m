Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D29EB619551
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 12:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbiKDLXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 07:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiKDLXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 07:23:48 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEB714081;
        Fri,  4 Nov 2022 04:23:48 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e72b329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e72b:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9ED461EC02DD;
        Fri,  4 Nov 2022 12:23:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1667561026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=marW4c8zTIflqJhdpTljXJjFAHNfLt0g8IVX4Ee73bo=;
        b=hbs2OlzrMbdJRJx2QOMauLOtrRIcQ6kZ2G4Pmgu1R0171rDW4vYzTPLvAm9p4vpouiH4fF
        j6W+WwFWyOd80ZkdXt+yVS0UXBK8jQMtRe4rM1rN7Y+LbiDInRqHU1Po1FQnZViFA4xP66
        T2fLnZGJuS2Cjvk+QLT6AL7QLd90uSA=
Date:   Fri, 4 Nov 2022 12:23:42 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jiaxi Chen <jiaxi.chen@linux.intel.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/8] x86: KVM: Move existing x86 CPUID leaf
 [CPUID_7_1_EAX] to kvm-only leaf
Message-ID: <Y2T2PqALCpG317F0@zn.tnic>
References: <20221103025030.78371-1-jiaxi.chen@linux.intel.com>
 <20221103025030.78371-2-jiaxi.chen@linux.intel.com>
 <Y2N/peaVRIjTMyrw@zn.tnic>
 <9197a0a4-4c15-1e6e-a44b-a8036c2104c4@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9197a0a4-4c15-1e6e-a44b-a8036c2104c4@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 04, 2022 at 10:01:55AM +0800, Jiaxi Chen wrote:
> But before new bits come, word 12 is empty in this gap. Is that ok?

Yes.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
