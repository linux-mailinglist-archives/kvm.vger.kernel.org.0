Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7BA34AB86
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 16:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCZP3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 11:29:55 -0400
Received: from mail.skyhub.de ([5.9.137.197]:50494 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230253AbhCZP3k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 11:29:40 -0400
Received: from zn.tnic (p200300ec2f075f0023f9e598b0fb3457.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:5f00:23f9:e598:b0fb:3457])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 22ABF1EC0535;
        Fri, 26 Mar 2021 16:29:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616772575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=cqvuHaVCz1IyEwsTEq5kO93EhDOmf5i2QyW1Km+NGe8=;
        b=P7PLJcFpAbyZUI8gxyUXx/Hy/IFJuSi1hLpzov97jL2HyCadAnsfup52I1bnecKNlCE9TT
        LhOAQBRTi3MjPF6UP6AOhpoJFnD6JSREhisFCRYW3Q9V9BH83y6LYuvbBKxBBYkIPK94no
        ijoxGDuQ2maZ+wLn0kzL4kcGqiQZxHA=
Date:   Fri, 26 Mar 2021 16:29:31 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     seanjc@google.com, Kai Huang <kai.huang@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH v3 05/25] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-ID: <20210326152931.GG25229@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com>
 <20210326150320.GF25229@zn.tnic>
 <db27d34f-60f9-a8e8-270e-7152bce81a12@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <db27d34f-60f9-a8e8-270e-7152bce81a12@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 26, 2021 at 08:17:38AM -0700, Dave Hansen wrote:
> We're working on a cgroup controller just for enclave pages that will
> apply to guest use and bare metal.  It would have been nice to have up
> front, but we're trying to do things incrementally.  A cgroup controller
> should solve he vast majority of these issues where users are quarreling
> about who gets enclave memory.

Maybe I'm missing something but why do you need a cgroup controller
instead of controlling that resource sharing in the sgx core? Or the
cgroup thing has additional functionality which is good to have anyway?

> BTW, we probably should have laid this out up front in the original
> merge, but the plans in order were roughly:
> 
> 1. Core SGX functionality (merged into 5.11)
> 2. NUMA and KVM work
> 3. cgroup controller for enclave pages
> 4. EDMM support (lets you add/remove pages and change permissions while
>    enclave runs.  Current enclaves are stuck with the same memory they
>    start with)

Oh yeah, that helps, thanks!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
