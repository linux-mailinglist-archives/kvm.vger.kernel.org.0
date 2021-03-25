Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A638E3496CA
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 17:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhCYQaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 12:30:00 -0400
Received: from mail.skyhub.de ([5.9.137.197]:51932 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229666AbhCYQ32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 12:29:28 -0400
Received: from zn.tnic (p200300ec2f0d5d002e2bf1176a5b9def.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:5d00:2e2b:f117:6a5b:9def])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ACE2A1EC0324;
        Thu, 25 Mar 2021 17:29:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616689766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=U5AbQYqSWYiIyNY16bCDiOGriUAPmZSlf40Ry/wtqLY=;
        b=pvgGt8lu2T1nrG6UKKpAqFrefEPVbQlxEf8B0KE7H+xry5fswYBQ77VGZbkqlESRguu88C
        BcdoA7l9Ya8wPyloj2ZRlmpVWFw47l5Esa1k9d78sYNCOJnnQmOJu8fYCgDLR8ZKFE4g3+
        ujwyHWx2cHgWPrKiLJ7B6TYeJD82ouA=
Date:   Thu, 25 Mar 2021 17:29:30 +0100
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
Subject: Re: [RFC Part1 PATCH 01/13] x86/cpufeatures: Add SEV-SNP CPU feature
Message-ID: <20210325162930.GF31322@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-2-brijesh.singh@amd.com>
 <20210325105417.GE31322@zn.tnic>
 <98917857-69d2-971c-d78d-b1d60159c037@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <98917857-69d2-971c-d78d-b1d60159c037@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 25, 2021 at 09:50:20AM -0500, Brijesh Singh wrote:
> For the early feedback I was trying to find one tree which can be used
> for building both the guest and hypervisor at once. In future, I will
> submit the part-1 against the tip/master and part-2 against the
> kvm/master. thanks

Then I think you could base ontop of current linux-next because it has
both trees. I presume test-applying the patches on our trees then should
work. I think...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
