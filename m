Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79ECE356AEA
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 13:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351789AbhDGLQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 07:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351780AbhDGLQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 07:16:17 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F416C061756;
        Wed,  7 Apr 2021 04:16:08 -0700 (PDT)
Received: from zn.tnic (p200300ec2f08fb002f59ec04e5c6bba4.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:fb00:2f59:ec04:e5c6:bba4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D98A11EC027D;
        Wed,  7 Apr 2021 13:16:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617794166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=D0JcvFianX0tItl+iWM+jBE8SZ1OCPp25pYI6pX32D0=;
        b=mgs8dav9hNc8eAOpB8WxPMPsJg1VfPzq/XuM5rWMQxNMq3tcDAMX7kK8HVH28QnEK7g3Mv
        3MM82xEvEJg//xOQFsPdcpFb1HCZp6Ia21vuIwn92SyqYHQkWArgBfFWk0mpKkK2nBkgdu
        F/xErIQfhRM4WqjwK+78HBJH+Tf9yq4=
Date:   Wed, 7 Apr 2021 13:16:04 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 06/13] x86/compressed: rescinds and validate
 the memory used for the GHCB
Message-ID: <20210407111604.GA25319@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-7-brijesh.singh@amd.com>
 <20210406103358.GL17806@zn.tnic>
 <c9f60432-2484-be1e-7b08-86dae5aa263f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c9f60432-2484-be1e-7b08-86dae5aa263f@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021 at 10:47:18AM -0500, Brijesh Singh wrote:
> Before the GHCB is established the caller does not need to save and
> restore MSRs. The page_state_change() uses the GHCB MSR protocol and it
> can be called before and after the GHCB is established hence I am saving
> and restoring GHCB MSRs.

I think you need to elaborate on that, maybe with an example. What the
other sites using the GHCB MSR currently do is:

1. request by writing it
2. read the response

None of them save and restore it.

So why here?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
