Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C942B6A62D6
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 23:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjB1WuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 17:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjB1WuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 17:50:19 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A90360A5;
        Tue, 28 Feb 2023 14:50:16 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D503C1EC04DA;
        Tue, 28 Feb 2023 23:50:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677624613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=sf2h3hi220E781ncSCCtEipOWUHmkqQMWL7hGDGs3OU=;
        b=LEYXMPAFbAW4NWRuAf3pW92Ggky+YFQ2w/c6gX6ukaNNjIMfuSn6VUMA8o3A8TsM4MMja1
        5h6UewXSwWZL6AffZ+tL3vrX+Z/nkmqybH6gqm7KoIGCahS9S6452n0QJhxqsWu4tvKGnl
        PlEt0VoBxw2lgPsNdSK6iAF0Ca00DiI=
Date:   Tue, 28 Feb 2023 23:50:09 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Takahiro Itazuri <itazur@amazon.com>
Cc:     dave.hansen@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de,
        x86@kernel.org, zulinx86@gmail.com
Subject: Re: [PATCH 0/2] KVM: x86: Propagate AMD-specific IBRS bits to guests
Message-ID: <Y/6FIeJ5KCOfKEPN@zn.tnic>
References: <Y/5oBKi6vjZe83ac@zn.tnic>
 <20230228222416.61484-1-itazur@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230228222416.61484-1-itazur@amazon.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 10:24:16PM +0000, Takahiro Itazuri wrote:
> I'm still a kernel newbie and I don't have a strong opinion for that.
> I just thought it would be helpful if the KVM_GET_SUPPORTED_CPUID API
> returns the same security information as the host, as long as it is
> harmless.

Not harmless - cpufeatures.h should contain flags which the kernel uses
and not *every* CPUID bit out there.

If you want to advertize flags to guests, see
arch/x86/kvm/reverse_cpuid.h and the KVM-only feature flags. You can add
them there.

> https://documentation.suse.com/sles/15-SP1/html/SLES-all/cha-spectre.html

Well, I was against adding that to the documentation when I was at SUSE
but ...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
