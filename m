Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E08A42A9DE
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 18:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhJLQsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 12:48:03 -0400
Received: from mail.skyhub.de ([5.9.137.197]:39336 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229996AbhJLQsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 12:48:03 -0400
Received: from zn.tnic (p200300ec2f19420044c1262ed1e42b8c.dip0.t-ipconnect.de [IPv6:2003:ec:2f19:4200:44c1:262e:d1e4:2b8c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 15ECB1EC0295;
        Tue, 12 Oct 2021 18:46:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634057160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=0YXv+LtBs1VFcaBEIJLdx3R96cV6B6FVy/GIzso/ifg=;
        b=FZdujRWw1jN+b0uc3fmR2F9k8Yrk/v0gzxjgzWY5JXvcyHABz4Vonyt/fQCnbnY7uF0wt2
        z0miD6gzSwHRM0IExAjIQmSsQHFbPDIlBSfWCoFZsyfMRGJKF4qHC6ycES5NLRVQepblCd
        j9fZzFpWysokbuiGz2hhy7QSXm8Bsgw=
Date:   Tue, 12 Oct 2021 18:45:56 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [patch 11/31] x86/fpu/xstate: Provide and use for_each_xfeature()
Message-ID: <YWW7xGPosnlXOiQl@zn.tnic>
References: <20211011215813.558681373@linutronix.de>
 <20211011223610.950054267@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211011223610.950054267@linutronix.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021 at 02:00:14AM +0200, Thomas Gleixner wrote:
> These loops evaluating xfeature bits are really hard to read. Create an
> iterator and use for_each_set_bit_from() inside which already does the right
> thing.

<--- No functional changes.

> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/kernel/fpu/xstate.c |   56 +++++++++++++++++--------------------------
>  1 file changed, 23 insertions(+), 33 deletions(-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
