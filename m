Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76F562CC12
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 22:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbiKPVDH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 16:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239207AbiKPVCE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 16:02:04 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63D66A774;
        Wed, 16 Nov 2022 13:01:08 -0800 (PST)
Received: from zn.tnic (p200300ea9733e7de329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7de:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 984171EC053B;
        Wed, 16 Nov 2022 22:01:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668632466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=NBEEXpGTiWMBqGkZSXJIcp3Aux0K0hBIQVUOau59K5c=;
        b=SVKOkRpJm3z2Saj+3kXAm8kuZvdvbPET4ANah0ZAhAkZ26zoKmIYUTjBUuCAYp3+0oedxW
        IqNr0MQEr40VubBuJVLOGrPnb7F39oKDZUTpgvhFWemD4ffdYuKuZO05wWa3zpIiKlE6nC
        xYeYBZfWV1UNPUgVov0MAIXuepra3kg=
Date:   Wed, 16 Nov 2022 22:01:02 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kim Phillips <kim.phillips@amd.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/cpufeatures: Add support for cpuid leaf
 80000021/EAX (FeatureExt2Eax)
Message-ID: <Y3VPjvajrzhfRz6d@zn.tnic>
References: <20221104213651.141057-1-kim.phillips@amd.com>
 <20221104213651.141057-2-kim.phillips@amd.com>
 <Y2WIy2A1RuQE/9SK@zn.tnic>
 <c00b1a65-c885-c874-79cb-16011ac82eb3@amd.com>
 <Y3TQsUmTieC4NnO/@zn.tnic>
 <Y3VGf8WsvxZ/S1aI@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3VGf8WsvxZ/S1aI@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 08:22:23PM +0000, Sean Christopherson wrote:
> > Sean, can you pls check the KVM bits whether I've done them all right?
> 
> Looks correct.

Thanks!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
