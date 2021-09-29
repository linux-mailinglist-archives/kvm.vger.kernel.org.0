Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766E741C505
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 14:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343965AbhI2M6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 08:58:39 -0400
Received: from mail.skyhub.de ([5.9.137.197]:37772 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343889AbhI2M6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 08:58:38 -0400
Received: from zn.tnic (p200300ec2f0bd1007899710aba6f35e5.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:d100:7899:710a:ba6f:35e5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DAA481EC0570;
        Wed, 29 Sep 2021 14:56:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632920216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=2BP/UXowSthxUNPAy3ZuvlIlMNxQstja9jGS9Mw4h+Q=;
        b=nrMuwfMvh0EJaU3jF7q6cS/9YbvzmA9n+Rmh931iVSFZWHQ+k+EmvHUF9nnWWKLL62ybpG
        8/dGU8a2XKqRUgFNbyXdkHTVfd2SRK/F93Ag45XxqoGuDS3Ocr8xrh1u5ColtvHMDTpSs0
        xV6X1ElJQzk8fuMsivGo0JSKoCDwn20=
Date:   Wed, 29 Sep 2021 14:56:46 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 04/45] x86/sev: Add RMP entry lookup helpers
Message-ID: <YVRijqnxzd8y7gcD@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-5-brijesh.singh@amd.com>
 <YU2fQMgw+PIBzSE4@zn.tnic>
 <a5be6103-f643-fed2-b01a-d0310f447d7a@amd.com>
 <2041d0d2-a0f8-d063-13c0-79b5bbcc8b83@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2041d0d2-a0f8-d063-13c0-79b5bbcc8b83@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 11:04:04AM -0500, Brijesh Singh wrote:
> Currently, we have only x86 drivers using it, are you thinking to move
> this to arch/x86/include/asm/ ?

arch/x86/include/asm/sev.h, yap.

We can always create it later if needed by other architectures.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
