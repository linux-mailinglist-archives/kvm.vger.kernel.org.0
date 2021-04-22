Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6302D368022
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 14:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbhDVMTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 08:19:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:33102 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235232AbhDVMTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 08:19:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DFBBBADD7;
        Thu, 22 Apr 2021 12:18:26 +0000 (UTC)
Date:   Thu, 22 Apr 2021 14:18:29 +0200
From:   Borislav Petkov <bp@suse.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
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
Message-ID: <20210422121829.GD6361@zn.tnic>
References: <20210422021125.3417167-1-seanjc@google.com>
 <20210422021125.3417167-7-seanjc@google.com>
 <8f1fa7e0-b940-6d1d-1a74-11014901fc0d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f1fa7e0-b940-6d1d-1a74-11014901fc0d@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021 at 02:05:46PM +0200, Paolo Bonzini wrote:
> Boris or another x86 maintainer, can you ack this small patch?  We would
> like to use sev_enabled as a static variable in KVM.

Yeah, all those "is anything SEV-like enabled" mechanisms would need
refactoring before it goes nuts. I think we should do this

bool sev_feature_enabled(enum sev_feature)

thing at some point:

https://lkml.kernel.org/r/20210421144402.GB5004@zn.tnic

And TDX would probably need something similar.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
