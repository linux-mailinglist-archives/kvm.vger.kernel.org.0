Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA2238FEF4
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 12:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhEYKV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 06:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbhEYKVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 06:21:55 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B376C061574;
        Tue, 25 May 2021 03:20:24 -0700 (PDT)
Received: from zn.tnic (p4fed31b3.dip0.t-ipconnect.de [79.237.49.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1549A1EC0249;
        Tue, 25 May 2021 12:20:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1621938020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fGrCayp66cgHTxO8nrBmCrkie2Nar3xGkMKSmgVgaMw=;
        b=pnMzekdarafVVULSBhst4uXxGpj8q/Kpbg2hGrEvEoz/hRr9oDuiKTfuAa0G4O8FHCUbfQ
        HJFucU7u5Aqdx8Q98FnT4zF40vc/qAmNZxVcumgog7v2yyEssfyysGPEJTRSMdCcW3ZUoC
        P7+2Agyc/BaR5UeC3qEnznDFlVoZ1Aw=
Date:   Tue, 25 May 2021 12:18:03 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 11/20] x86/compressed: Add helper for
 validating pages in the decompression stage
Message-ID: <YKzO2+Dwb5ABKFyF@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-12-brijesh.singh@amd.com>
 <YKah5QInPK4+7xaC@zn.tnic>
 <921408d1-a399-7089-8647-f9617eb12919@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <921408d1-a399-7089-8647-f9617eb12919@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 20, 2021 at 01:05:15PM -0500, Brijesh Singh wrote:
> Maybe I am missing something, the statement above was executed for
> either set or clr but the page shared need to happen only for clr. So,
> from code readability point I kept it outside of that if().
> 
> Otherwise we may have to do something like.
> 
> ...
> 
> if ((set | clr) & _PAGE_EN) {
> 
>    if (clr)
> 
>     snp_set_page_shared(pte_pfn(*ptep) << PAGE_SHIFT);
> 
>   }
> 
> I am okay with above is the preferred approach.

Yes pls, because it keeps the _PAGE_ENC handling together in one
statement.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
