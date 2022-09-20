Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6415D5BEF0C
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 23:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiITVRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 17:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiITVRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 17:17:31 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2635FAD8;
        Tue, 20 Sep 2022 14:17:30 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e791329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e791:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3189D1EC01D4;
        Tue, 20 Sep 2022 23:17:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663708644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=zkNVIW7XMP+DXz/zp8bGb1+4u+ta+XVJ1+LgT7xDrEg=;
        b=DgPfkNhN5dT+kTg1a0yH2OY/0HhEvqFh4aa+SBDfIrOClKTQEgZdxZaQaF0TMlzT0XmVLq
        tlIYO81XrkYy0Ro0ay5sQaqu9uNV4sp+D87QoHAqP3yMFYTv/pPi8j6HlwXnLLmXF6bpdi
        /pBuMqnelm1XMRyNgt+96tisQeY2aG8=
Date:   Tue, 20 Sep 2022 23:17:19 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jim Mattson <jmattson@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: EFER.LMSLE cleanup
Message-ID: <Yyot34LGkFR2/j5f@zn.tnic>
References: <20220920205922.1564814-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220920205922.1564814-1-jmattson@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 20, 2022 at 01:59:19PM -0700, Jim Mattson wrote:
> Jim Mattson (3):
>   Revert "KVM: SVM: Allow EFER.LMSLE to be set with nested svm"
>   x86/cpufeatures: Introduce X86_FEATURE_NO_LMSLE
>   KVM: SVM: Unconditionally enumerate EferLmsleUnsupported

Why do you need those two if you revert the hack? After the revert,
anything that tries to set LMSLE should get a #GP anyway, no?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
