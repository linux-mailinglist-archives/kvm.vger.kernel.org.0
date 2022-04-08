Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1860E4F9142
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 11:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbiDHJCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 05:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiDHJCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 05:02:06 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC46BFFF9F;
        Fri,  8 Apr 2022 02:00:03 -0700 (PDT)
Received: from zn.tnic (p200300ea971561a9329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9715:61a9:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 449621EC0494;
        Fri,  8 Apr 2022 10:59:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1649408398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=b4fNiNEwz7DtWWeA5HYkgByr+NGOkAtmuLSwF4XS2Do=;
        b=U6qiue3iJxkix6Fl6xYq+9YZRkBU4ktyROnc5Auy8ISzWECqA7+KouJ+HQESMlr7vg5j0w
        9K4KhZ/wfQIbTk6fwHD20EUVQPX7IVFu+sHqOLBi0/6EgNuv5F5LZFE+bM22OgeWfPpx9L
        ekbrTlYMRuZs/Hh0ZsmJbdn6LJO7Ua8=
Date:   Fri, 8 Apr 2022 11:00:00 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Babu Moger <babu.moger@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        hpa@zytor.com, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, joro@8bytes.org,
        wanpengli@tencent.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/2] x86/cpufeatures: Add virtual TSC_AUX feature bit
Message-ID: <Yk/5kIlcAuW/RuDj@zn.tnic>
References: <164937947020.1047063.14919887750944564032.stgit@bmoger-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <164937947020.1047063.14919887750944564032.stgit@bmoger-ubuntu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022 at 07:57:50PM -0500, Babu Moger wrote:
> The TSC_AUX Virtualization feature allows AMD SEV-ES guests to securely use
> TSC_AUX (auxiliary time stamp counter data) MSR in RDTSCP and RDPID
> instructions.
> 
> The TSC_AUX MSR is typically initialized to APIC ID or another unique
> identifier so that software can quickly associate returned TSC value
> with the logical processor.
> 
> Adds the feature bit and also include it in the kvm for detection.

s/Adds/Add/

> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h |    1 +
>  arch/x86/kvm/cpuid.c               |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)

With that fixed:

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
