Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E510C34AF0D
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 20:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhCZTM5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 15:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhCZTMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 15:12:40 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5897FC0613AA;
        Fri, 26 Mar 2021 12:12:40 -0700 (PDT)
Received: from zn.tnic (p200300ec2f075f009137b2b45d3c68fe.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:5f00:9137:b2b4:5d3c:68fe])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D92241EC0535;
        Fri, 26 Mar 2021 20:12:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616785959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=xPoD7Y7agYIOnUh5UGVci7NJzqRAA7R3UL2aY0ysLXQ=;
        b=pkPIi/ODjRlP0l7fE4c5U8L5CQc/kikY71qzYMM9vH0UkxdaEvvBb4MXbg5LwPTIbzfFFs
        z8Ly2eld96S01DDWL2TPkAzgDk2bsgVww4qmktE2knmpkOLL4E3ySb0qAFnXSB6Ny663Z8
        Dzcbedwjtzz4IbnwWhlyUY7io+pPTHs=
Date:   Fri, 26 Mar 2021 20:12:41 +0100
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
Subject: Re: [RFC Part1 PATCH 03/13] x86: add a helper routine for the
 PVALIDATE instruction
Message-ID: <20210326191241.GJ25229@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-4-brijesh.singh@amd.com>
 <20210326143026.GB27507@zn.tnic>
 <9c9773d1-c494-2dfe-cd2a-95e3cfdfa09f@amd.com>
 <bddf2257-4178-c230-c40f-389db529a950@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bddf2257-4178-c230-c40f-389db529a950@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 26, 2021 at 01:22:24PM -0500, Brijesh Singh wrote:
> Should I do the same for the sev-es.c ? Currently, I am keeping all the
> SEV-SNP specific changes in sev-snp.{c,h}. After a rename of
> sev-es.{c,h} from both the arch/x86/kernel and arch-x86/boot/compressed
> I can add the SNP specific stuff to it.
> 
> Thoughts ?

SNP depends on the whole functionality in SEV-ES, right? Which means,
SNP will need all the functionality of sev-es.c.

But sev-es.c is a lot more code than the header and snp is

 arch/x86/kernel/sev-snp.c               | 269 ++++++++++++++++++++++++

oh well, not so much.

I guess a single

arch/x86/kernel/sev.c

is probably ok.

We can always do arch/x86/kernel/sev/ later and split stuff then when it
starts getting real fat and impacts complication times.

Btw, there's also arch/x86/kernel/sev-es-shared.c and that can be

arch/x86/kernel/sev-shared.c

then.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
