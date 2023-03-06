Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E65C6AD0E6
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 22:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCFVyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 16:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjCFVyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 16:54:53 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D874E5F4;
        Mon,  6 Mar 2023 13:54:52 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DE15A1EC0373;
        Mon,  6 Mar 2023 22:54:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1678139690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=9pGyAdmsQDmfnIw6UPkfHo8gBZoi4g0acS6myxehQUE=;
        b=ct+VQC3mXM9cIAwtZVnPH64+DubbftOPBbUFpPTw7MmQf25I4qxsjRXPyVJHJl0GrwhOob
        AIU6qaikFre8yWzu8IiMTvVO+LN7mJRv0B3WX+f8WyVpiVDS3/HKc84tXj1G+5Yp2A1z8X
        L2CsjK8nt61VGRMorqcGRNZgYhy+MLY=
Date:   Mon, 6 Mar 2023 22:54:50 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Takahiro Itazuri <itazur@amazon.com>,
        dave.hansen@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, zulinx86@gmail.com
Subject: Re: [PATCH 0/2] KVM: x86: Propagate AMD-specific IBRS bits to guests
Message-ID: <20230306215450.GFZAZhKnr6zMCeeDNd@fat_crate.local>
References: <Y/5oBKi6vjZe83ac@zn.tnic>
 <20230228222416.61484-1-itazur@amazon.com>
 <Y/6FIeJ5KCOfKEPN@zn.tnic>
 <ZAZYKe4L8jhMG4An@google.com>
 <20230306214419.GDZAZes941k+4NPgDL@fat_crate.local>
 <25249e7d-4fd9-e1c1-8efb-31750740ec27@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <25249e7d-4fd9-e1c1-8efb-31750740ec27@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 06, 2023 at 10:47:18PM +0100, Paolo Bonzini wrote:
> It's very rare that KVM can provide a CPUID feature if the kernel has
> masked it,

I'm talking about pure hw feature bits which don't need any enablement.
Like AVX512 insns subset support or something else which the hw does
without the need for the kernel.

Those should be KVM-only if baremetal doesn't use them.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
