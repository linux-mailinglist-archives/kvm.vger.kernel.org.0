Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CEF2F6760
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 18:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbhANRRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 12:17:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:39778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727512AbhANRRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 12:17:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0821FB718;
        Thu, 14 Jan 2021 17:16:39 +0000 (UTC)
Date:   Thu, 14 Jan 2021 18:16:31 +0100
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
Message-ID: <20210114171631.GD13213@zn.tnic>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-5-seanjc@google.com>
 <20210114113528.GC13213@zn.tnic>
 <YAB6yLXb4Es+pJ8G@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YAB6yLXb4Es+pJ8G@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 14, 2021 at 09:09:28AM -0800, Sean Christopherson wrote:
> Hmm, patch 05/14 depends on the existence of the new word.  That's a non-issue
> if you're planning on taking this for 5.11.  If it's destined for 5.12, maybe
> get an ack from Paolo on patch 05 and take both through tip? 

Yeah, I guess that. Both are not urgent 5.11 material to take 'em now.
So I guess I'll wait for Paolo's ACK.

> I can drop them from this series when I send v3. In hindsight, I
> should have split these two patches into a separate mini-series from
> the get-go.

Nah, no worries. We do patch acrobatics on a daily basis. :-)

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
