Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CFC36801D
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 14:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbhDVMQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 08:16:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:57988 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235232AbhDVMQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 08:16:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AC4C1AF03;
        Thu, 22 Apr 2021 12:16:23 +0000 (UTC)
Date:   Thu, 22 Apr 2021 14:16:18 +0200
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
Subject: Re: [PATCH v5 06/15] x86/sev: Drop redundant and potentially
 misleading 'sev_enabled'
Message-ID: <20210422121618.GC6361@zn.tnic>
References: <20210422021125.3417167-1-seanjc@google.com>
 <20210422021125.3417167-7-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210422021125.3417167-7-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021 at 07:11:16PM -0700, Sean Christopherson wrote:
> Drop the sev_enabled flag and switch its one user over to sev_active().
> sev_enabled was made redundant with the introduction of sev_status in
> commit b57de6cd1639 ("x86/sev-es: Add SEV-ES Feature Detection").
> sev_enabled and sev_active() are guaranteed to be equivalent, as each is
> true iff 'sev_status & MSR_AMD64_SEV_ENABLED' is true, and are only ever
> written in tandem (ignoring compressed boot's version of sev_status).
> 
> Removing sev_enabled avoids confusion over whether it refers to the guest
> or the host, and will also allow KVM to usurp "sev_enabled" for its own
> purposes.
> 
> No functional change intended.
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/mem_encrypt.h |  1 -
>  arch/x86/mm/mem_encrypt.c          | 12 +++++-------
>  arch/x86/mm/mem_encrypt_identity.c |  1 -
>  3 files changed, 5 insertions(+), 9 deletions(-)

Acked-by: Borislav Petkov <bp@suse.de>

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
