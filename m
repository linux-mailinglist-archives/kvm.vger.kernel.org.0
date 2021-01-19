Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F3D2FBD56
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 18:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390498AbhASRLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 12:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730595AbhASRKp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 12:10:45 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3DCC061573;
        Tue, 19 Jan 2021 09:09:49 -0800 (PST)
Received: from zn.tnic (p200300ec2f0bca005ed5ab9a356b3c50.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:ca00:5ed5:ab9a:356b:3c50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A21C81EC0628;
        Tue, 19 Jan 2021 18:09:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1611076187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=aGYE3lrAaFtHuS6FfunC0o8NEZPPWrN9CoQB5+izi7E=;
        b=qyyuoE50Ydqnd7+nAz9H+xW8KTiOadrdi/pQqgr4R+a+Rh1R6wscH4q87wD51nLkqE+q7p
        X1cQMezfDFNAFytvW9MrYScqAlnDU8LHnkzjd9eGV6UBeUz9bc7TymdGzPetb7QcGA2Ma/
        2qzBFG5LTcRZQAitm3tmOvUXWpMIDig=
Date:   Tue, 19 Jan 2021 18:09:42 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] x86/sev: Add AMD_SEV_ES_GUEST Kconfig for including
 SEV-ES support
Message-ID: <20210119170942.GO27433@zn.tnic>
References: <20210116002517.548769-1-seanjc@google.com>
 <20210118202931.GI30090@zn.tnic>
 <5f7bbd70-35c3-24ca-7ec5-047c71b16b1f@redhat.com>
 <20210118204701.GJ30090@zn.tnic>
 <YAcHeOyluQY9C6HK@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YAcHeOyluQY9C6HK@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 19, 2021 at 08:23:20AM -0800, Sean Christopherson wrote:
> It was the AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT dependency that tripped me up.  To
> get KVM to enable SEV/SEV-ES by default,

By default? What would be the use case for that?

> Agreed, I'll send a KVM patch to remove the
> AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT dependency.

Yah, AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT came out of the initial memory
enc. SME patchset where the use case was something along the lines of
booting a kernel and SME being enabled by default. But Tom doesn't
remember exactly either. I guess that thing doesn't belong in kvm code
anyway...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
