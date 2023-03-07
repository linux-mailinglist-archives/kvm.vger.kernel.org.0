Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2796F6AF646
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 20:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbjCGT7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 14:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbjCGT7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 14:59:00 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E604968E8;
        Tue,  7 Mar 2023 11:55:09 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AD4CC1EC0688;
        Tue,  7 Mar 2023 20:55:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1678218907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=craNlKH5R1RjI0dTvntdRneUy7nr9hMjAvrqHexPQ/g=;
        b=DlSDRhJLH4J1KbdYK+DjOFPstgnfQaHxeGKmqhG5UMlrP8YUm2KamBj6NKnPbBBOt52mgh
        1+staQ7QmLqjaqYtE6k7C0VXtGTaFzpsLoMBSEDt87OO8iV1jue/hvz2IzQg1fYPDwYS2S
        lgZG+uKnXUjm2nadoXSm0K372ZOaaqk=
Date:   Tue, 7 Mar 2023 20:55:07 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Takahiro Itazuri <itazur@amazon.com>,
        dave.hansen@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, zulinx86@gmail.com
Subject: Re: [PATCH 0/2] KVM: x86: Propagate AMD-specific IBRS bits to guests
Message-ID: <20230307195507.GHZAeWmyrhcrKm4wI1@fat_crate.local>
References: <Y/5oBKi6vjZe83ac@zn.tnic>
 <20230228222416.61484-1-itazur@amazon.com>
 <Y/6FIeJ5KCOfKEPN@zn.tnic>
 <ZAZYKe4L8jhMG4An@google.com>
 <20230306214419.GDZAZes941k+4NPgDL@fat_crate.local>
 <25249e7d-4fd9-e1c1-8efb-31750740ec27@redhat.com>
 <20230306215450.GFZAZhKnr6zMCeeDNd@fat_crate.local>
 <ZAeHMgp9U7giJpHs@google.com>
 <20230307185811.GEZAeJQ8U+NYySH8up@fat_crate.local>
 <ZAeQWre1PM7vsWd3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZAeQWre1PM7vsWd3@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 07, 2023 at 11:28:26AM -0800, Sean Christopherson wrote:
> Ah, gotcha.  We're on the same page then.  Thanks!

Yeah, now someone needs to document it.. :-)

I'll put it on my TODO.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
