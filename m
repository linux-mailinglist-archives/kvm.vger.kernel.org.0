Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE24335A13F
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 16:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhDIOiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 10:38:03 -0400
Received: from mail.skyhub.de ([5.9.137.197]:43246 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhDIOiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 10:38:02 -0400
Received: from zn.tnic (p200300ec2f0be1008c36e9c40e111c65.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:e100:8c36:e9c4:e11:1c65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6D7D11EC04A9;
        Fri,  9 Apr 2021 16:37:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617979068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=/tfcyJXvXhNZLReR1htttf0UwfGGssjKO1d9l61G0Cc=;
        b=m2dw4XzUKula8B2dsTyQD+VYSfLSxCqY8SqdIRzbQSWNLxiRf7SDhSavwjvNSnDVvbvoxI
        0/pTN2qfZfnumeSjwGSS3mdEbhgAGogMHWA8GkpkD3buCnQFNKESkBjFCs5LSeB6mdLbQe
        EiacvRj5D+MEk1Pf3ZQNg9u5YA8cf8k=
Date:   Fri, 9 Apr 2021 16:37:46 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFCv1 2/7] x86/kvm: Introduce KVM memory protection feature
Message-ID: <20210409143746.GE15567@zn.tnic>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
 <20210402152645.26680-3-kirill.shutemov@linux.intel.com>
 <20210408095235.GH10192@zn.tnic>
 <20210409133601.2qepfc77stujulhf@box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210409133601.2qepfc77stujulhf@box>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 09, 2021 at 04:36:01PM +0300, Kirill A. Shutemov wrote:
> The patchset is still in path-finding stage. I'll be more specific once we
> settle on how the feature works.

This is not why I'm asking: these feature bits are visible to userspace
in /proc/cpuinfo and if you don't have a use case to show this to
userspace, use the "" in the comment.

And if you don't need that feature bit at all (you're only setting it
but not querying it) you should not add it at all.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
