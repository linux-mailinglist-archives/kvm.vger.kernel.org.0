Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A411629EA0
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 17:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238214AbiKOQQZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 11:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiKOQQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 11:16:24 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFC121269;
        Tue, 15 Nov 2022 08:16:23 -0800 (PST)
Received: from zn.tnic (p200300ea9733e7da329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7da:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 514891EC02AD;
        Tue, 15 Nov 2022 17:16:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668528982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=moL1gKMqW4R5g57WXDtF4yiJKN98vtk7xkszGsGO4fo=;
        b=Qp6eHo7w65ZguQTm1d5QBmuay+l+StBUSN5myLyBorYAC9rFELw6/nlgktUathZDGZECMx
        8/PglA5XevPaPFefcl7qWMdWcdKAU2wPCmwBDykMC1s/TnbhiN/mhJG6wTuM/yvd/kde4L
        TfJFRtfb4Wt3WwoFB7GmxC8UitS6y54=
Date:   Tue, 15 Nov 2022 17:16:17 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        ndesaulniers@google.com, alexandre.belloni@bootlin.com,
        peterz@infradead.org, jpoimboe@kernel.org,
        chang.seok.bae@intel.com, pawan.kumar.gupta@linux.intel.com,
        babu.moger@amd.com, jmattson@google.com, sandipan.das@amd.com,
        tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        fenghua.yu@intel.com, keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/7] x86: KVM: Move existing x86 CPUID leaf
 [CPUID_7_1_EAX] to kvm-only leaf
Message-ID: <Y3O7UYWfOLfJkwM/@zn.tnic>
References: <20221110015252.202566-1-jiaxi.chen@linux.intel.com>
 <20221110015252.202566-2-jiaxi.chen@linux.intel.com>
 <f8607d23-afaa-2670-dd03-2ae8ec1e79a0@intel.com>
 <Y3OwaRBzVFqJ4KEs@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3OwaRBzVFqJ4KEs@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 15, 2022 at 03:29:45PM +0000, Sean Christopherson wrote:
> Heh, are any of the bits you believe Intel will add publicly documented?  :-)
> 
> LAM could be scattered, but if more bits are expected that's probably a waste of
> time and effort.

I'm being told the bigger part of that word is going to be used for
either kernel or KVM bits so we might as well use it the "normal" way
instead of doing KVM-only or scattered bits after all.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
