Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E7F2F6029
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 12:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbhANLgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 06:36:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:35768 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727052AbhANLgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 06:36:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9B82CB7A5;
        Thu, 14 Jan 2021 11:35:35 +0000 (UTC)
Date:   Thu, 14 Jan 2021 12:35:28 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2 04/14] x86/cpufeatures: Assign dedicated feature word
 for AMD mem encryption
Message-ID: <20210114113528.GC13213@zn.tnic>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-5-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210114003708.3798992-5-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 13, 2021 at 04:36:58PM -0800, Sean Christopherson wrote:
> Collect the scattered SME/SEV related feature flags into a dedicated
> word.  There are now five recognized features in CPUID.0x8000001F.EAX,
> with at least one more on the horizon (SEV-SNP).  Using a dedicated word
> allows KVM to use its automagic CPUID adjustment logic when reporting
> the set of supported features to userspace.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Subject should be:

x86/cpufeatures: Assign dedicated feature word for CPUID_0x8000001F[EAX]

but other than that, LGTM.

Anything against me taking it through tip now?

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
