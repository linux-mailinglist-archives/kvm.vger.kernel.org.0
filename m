Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C411037C031
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 16:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhELOcR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 10:32:17 -0400
Received: from mail.skyhub.de ([5.9.137.197]:52190 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230347AbhELOcQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 10:32:16 -0400
Received: from zn.tnic (p200300ec2f0bb800c6bc209d75c80142.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:b800:c6bc:209d:75c8:142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 432F41EC046E;
        Wed, 12 May 2021 16:31:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1620829866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=sH1fnhjM7cZz9QEE54H+quyulj+UQHZBIMnPp2FOud4=;
        b=E2oxhHIBzBfQCFRLuWw+j2m5/FrUVFuIFUmoP+gsmfRlYvNrNW/0g6C6VFAH4XNSklkrYF
        hXqwk6zOf7GuIRaIm4QgAUpKd+FAYpKBBbKO4WnLfHt+wgtvb6CTRrHjjdR04K870kIcqB
        UnEJB+Pxm25SuSkKGC+gLRfzqoC+hcM=
Date:   Wed, 12 May 2021 16:31:03 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 02/20] x86/sev: Save the negotiated GHCB
 version
Message-ID: <YJvmp3ELvej0ydnL@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-3-brijesh.singh@amd.com>
 <YJpM+VZaEr68hTwZ@zn.tnic>
 <36add6ab-0115-d290-facd-2709e3c93fb9@amd.com>
 <YJrP1vTXmtzXYapq@zn.tnic>
 <0f7abbc3-5ad4-712c-e669-d41fd83b9ed3@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0f7abbc3-5ad4-712c-e669-d41fd83b9ed3@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 09:03:41AM -0500, Brijesh Singh wrote:
> Version 2 of the spec adds bunch of NAEs, and several of them are
> optional except the hyervisor features NAE. IMO, a guest should bump the
> GHCB version only after it has implemented all the required NAEs from
> the version 2. It may help during the git bisect of the guest kernel --
> mainly when the hypervisor supports the higher version.

Aha, so AFAICT, the version bump should happen in patch 3 which adds
that HV features NAE - not in a separate one after that. The logic
being, with the patch which adds the functionality needed, you mark the
guest as supporting v2.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
