Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530D42FABCC
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 21:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388420AbhARUsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 15:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388413AbhARUrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 15:47:49 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2720AC061574;
        Mon, 18 Jan 2021 12:47:09 -0800 (PST)
Received: from zn.tnic (p200300ec2f069f0062c4736095b963a8.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:9f00:62c4:7360:95b9:63a8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9D02A1EC0373;
        Mon, 18 Jan 2021 21:47:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1611002827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=zSfxBvZu+voIRyjSVXiWpFkBZRJAFAAXPfJCciOg19M=;
        b=hiY2qU/APzcIBZApRkche1UxRBS28TJrmBEdDf2NVp6/NqWiU3dVbofvPq0OTZZppL9zi2
        d9ZgJ72LP50CKWb8bA/r6QVoi8hbX30WE9JQY1D6mv1BVLZR1ndfXwgmZgZ0YMkv3OQciQ
        TmdigeKKk2aGck97mNi9okeE/lfAoUY=
Date:   Mon, 18 Jan 2021 21:47:01 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
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
Message-ID: <20210118204701.GJ30090@zn.tnic>
References: <20210116002517.548769-1-seanjc@google.com>
 <20210118202931.GI30090@zn.tnic>
 <5f7bbd70-35c3-24ca-7ec5-047c71b16b1f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5f7bbd70-35c3-24ca-7ec5-047c71b16b1f@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 18, 2021 at 09:32:07PM +0100, Paolo Bonzini wrote:
> I think it makes sense because AMD_SEV_ES_GUEST's #VC handling is quite a
> bit of code that you may not want or need.

Quite a bit of code which ends up practically enabled on the majority of
distros.

And it ain't about savings of whopping KiBs. And yet another Kconfig symbol
in our gazillion Kconfig symbols space means ugly ifdeffery and paying
attention to randconfig builds.

For tailored configs you simply disable AMD_MEM_ENCRYPT on !AMD hw and
all done.

So I don't see the point for this.

Thx. 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
