Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8895E41359E
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 16:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbhIUOxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 10:53:04 -0400
Received: from mail.skyhub.de ([5.9.137.197]:54178 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233689AbhIUOxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 10:53:03 -0400
Received: from zn.tnic (p200300ec2f0d060045983051645feb8a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:600:4598:3051:645f:eb8a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F0F071EC0298;
        Tue, 21 Sep 2021 16:51:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632235890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=0tySSr94j0qUYtXGolsce93msuCdyyz2sqwhXQ9+Bes=;
        b=EJQOmTG5tVchKBo5DTrA4Ye/B7/qnkYFKoZYsbAmqoVHquC1gOD6Ue85L5Nk3mPnbCuSt+
        XVWyfwqisvYxlyGp7A6hlETsfCrCo6HVdwIeRZyKKlb5XqbO9Bv2Gp9Jpgo71EmXD8loCC
        MhyUvHntAC/Z2r8QmsoXEED+q8Q8DSU=
Date:   Tue, 21 Sep 2021 16:51:23 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        Steve Rutherford <srutherford@google.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        brijesh.singh@amd.com, dovmurik@linux.ibm.com, tobin@linux.ibm.com,
        jejb@linux.ibm.com, dgilbert@redhat.com
Subject: Re: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
Message-ID: <YUnxa2gy4DzEI2uY@zn.tnic>
References: <cover.1629726117.git.ashish.kalra@amd.com>
 <6fd25c749205dd0b1eb492c60d41b124760cc6ae.1629726117.git.ashish.kalra@amd.com>
 <CABayD+fnZ+Ho4qoUjB6YfWW+tFGUuftpsVBF3d=-kcU0-CEu0g@mail.gmail.com>
 <YUixqL+SRVaVNF07@google.com>
 <20210921095838.GA17357@ashkalra_ubuntu_server>
 <YUnjEU+1icuihmbR@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YUnjEU+1icuihmbR@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21, 2021 at 01:50:09PM +0000, Sean Christopherson wrote:
> apply_alternatives() is a generic helper that can work on any struct alt_instr
> array, e.g. KVM_HYPERCALL can put its alternative into a different section that's
> patched as soon as the VMM is identified.

Where exactly in the boot process you wanna move it?

As Ashish says, you need the boot_cpu_data bits properly set before it
runs.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
