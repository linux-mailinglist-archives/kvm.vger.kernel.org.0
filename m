Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45CE35C040A
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 18:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbiIUQZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 12:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiIUQZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 12:25:20 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AAEB277B;
        Wed, 21 Sep 2022 09:08:11 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e77f329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e77f:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7F05D1EC04E4;
        Wed, 21 Sep 2022 18:06:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663776398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=OiOyemOYE7YQPB2li6S2lfuxJt+qSMzE4RjxoZKsaMY=;
        b=GYdfpiX0cNttTHDXgLEWPxBJETS7tIOMadrfr9fyrJCUY4U+YnvMadOo8vxXR8GyLHDLMa
        A7r4HHtbUDw3chb8eXRtMtO0+GmHvAQCPwuzgNFolRZ7Qrz7ZXdiDG8Y8LssooML+S6Lv5
        KbDwFitSF5kzP5nlFTVkBs+rHxV6La4=
Date:   Wed, 21 Sep 2022 18:06:34 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: EFER.LMSLE cleanup
Message-ID: <Yys2ikzV73upzlEj@zn.tnic>
References: <20220920205922.1564814-1-jmattson@google.com>
 <Yyot34LGkFR2/j5f@zn.tnic>
 <CALMp9eQijCKS-E_OWJkxdqAur3BthciOWEtEPH5YKd0-HJiQQA@mail.gmail.com>
 <YyrZOLq8z+lIORvP@zn.tnic>
 <CALMp9eRG6g-95zCxTD1NnxpZ+Vm6VMTA0_uaHV=b-hDkeOYSuA@mail.gmail.com>
 <YysXeXKY36yXj68q@zn.tnic>
 <CALMp9eTuO79+NfHxLi8FnqdOpzXO7eQUntvN23EfR+shg+wg2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALMp9eTuO79+NfHxLi8FnqdOpzXO7eQUntvN23EfR+shg+wg2Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 08:11:29AM -0700, Jim Mattson wrote:
> Yes, after the revert, KVM will treat the bit as reserved, and it will
> synthesize a #GP, *in violation of the architectural specification.*

Architectural, schmarchitectural... Intel hasn't implemented it so meh.

> KVM can't just decide willy nilly to reserve arbitrary bits. If it is
> in violation of AMD's architectural specification, the virtual CPU is
> defective.

Grrr, after your revert that this bit was *only* reserved and nothing
else to KVM. Like every other reserved bit in EFER. Yeah, yeah, AMD
specified it as architectural but Intel didn't implement it so there's
this thing on paper and there's reality...

Anyway, enough about this - we're on the same page.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
