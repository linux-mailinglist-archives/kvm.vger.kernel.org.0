Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04EC366F33
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 17:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244018AbhDUPck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 11:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238663AbhDUPcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 11:32:39 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623F3C06174A;
        Wed, 21 Apr 2021 08:32:06 -0700 (PDT)
Received: from zn.tnic (p200300ec2f10df00c08862b6cef04697.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:df00:c088:62b6:cef0:4697])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 820641EC025A;
        Wed, 21 Apr 2021 17:32:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1619019124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=s8sUezfXPQv8iAJBppOiBu9E4CwEDqfiDCGzGrmwl4M=;
        b=FXU0I0XIYbTuMEf2IFWWyyoLNaFzCPPpZDQTLICw0gLJdp/Qn5soa57LIFi/mGBxULtYFx
        yIS4ZwNzvTGOYAirC3gOEaDy+AnmmQKBYHvl8bxRS0rUkbenUQoKlRM63lRloZp8YVzraa
        EzsRiVQyxE247suWLHpmrQCrR9v8AtM=
Date:   Wed, 21 Apr 2021 17:32:02 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com,
        kexec@lists.infradead.org
Subject: Re: [PATCH v13 12/12] x86/kvm: Add guest support for detecting and
 enabling SEV Live Migration feature.
Message-ID: <20210421153202.GC5004@zn.tnic>
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <ffd67dbc1ae6d3505d844e65928a7248ebaebdcc.1618498113.git.ashish.kalra@amd.com>
 <20210421144402.GB5004@zn.tnic>
 <20210421152220.GB14004@ashkalra_ubuntu_server>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210421152220.GB14004@ashkalra_ubuntu_server>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 03:22:20PM +0000, Ashish Kalra wrote:

> Yes, the above mentions to get KVM_FEATURE_CPUID and then check if live
> migration feature is supported, i.e.,
> kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION). The above comments
> are written more generically.

Do not write generic comments please - write exact comments to state
precisely why you're doing what you're doing.

> Just to ensure that the sev_live_migration_enabled is set to TRUE before
> it is used immediately next in the function.

Why wouldn't it be set to true by the time the next function runs?

Do you have any concrete observations where this is not the case?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
