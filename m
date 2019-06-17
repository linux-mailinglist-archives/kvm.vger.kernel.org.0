Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4FE47B90
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 09:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfFQHq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 03:46:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57968 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfFQHq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 03:46:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YkzG8FgrjsJE2ZjG5g7hfYDZEeo6+OA/Btz/mk5jlNA=; b=rCvYNa7/NvaIcpx/eS9RsD3zq
        AfDoAj5ne5PjHAPsNNRhWmX6hypo262EDdiDCPlHuxGce32uhXRLpzjvBzbikSRZJcmLtrNTtSVgW
        rzcyk4RJqcl8vpfFlcjxtUDMDrotaRgaducgqtG9EcCMf9RifWeZ1/mUP1sMgYNYS63w2MB3TKhdV
        WTha/hzgsuI74FPHTYlGXhMyYe7cAuTCkFuHtLtoZd2os6d3RGl5hn6JWfW+XwzYRRaOiCB6h5xJ3
        17Zg4IQ1oDzAYtM1bSfmTqu6hvkkpvEX7pt8C43DWflPBRQghgLdhMs8wX6E+Du/mc5qmpWo/q3n6
        YdnKS7szw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hcmLk-0005Pt-OF; Mon, 17 Jun 2019 07:46:44 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3D54C20961A06; Mon, 17 Jun 2019 09:46:43 +0200 (CEST)
Date:   Mon, 17 Jun 2019 09:46:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@linux.intel.com>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 49/62] mm, x86: export several MKTME variables
Message-ID: <20190617074643.GW3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-50-kirill.shutemov@linux.intel.com>
 <20190614115647.GI3436@hirez.programming.kicks-ass.net>
 <1560741269.5187.7.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560741269.5187.7.camel@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 17, 2019 at 03:14:29PM +1200, Kai Huang wrote:
> On Fri, 2019-06-14 at 13:56 +0200, Peter Zijlstra wrote:
> > On Wed, May 08, 2019 at 05:44:09PM +0300, Kirill A. Shutemov wrote:
> > > From: Kai Huang <kai.huang@linux.intel.com>
> > > 
> > > KVM needs those variables to get/set memory encryption mask.
> > > 
> > > Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
> > > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > ---
> > >  arch/x86/mm/mktme.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/arch/x86/mm/mktme.c b/arch/x86/mm/mktme.c
> > > index df70651816a1..12f4266cf7ea 100644
> > > --- a/arch/x86/mm/mktme.c
> > > +++ b/arch/x86/mm/mktme.c
> > > @@ -7,13 +7,16 @@
> > >  
> > >  /* Mask to extract KeyID from physical address. */
> > >  phys_addr_t mktme_keyid_mask;
> > > +EXPORT_SYMBOL_GPL(mktme_keyid_mask);
> > >  /*
> > >   * Number of KeyIDs available for MKTME.
> > >   * Excludes KeyID-0 which used by TME. MKTME KeyIDs start from 1.
> > >   */
> > >  int mktme_nr_keyids;
> > > +EXPORT_SYMBOL_GPL(mktme_nr_keyids);
> > >  /* Shift of KeyID within physical address. */
> > >  int mktme_keyid_shift;
> > > +EXPORT_SYMBOL_GPL(mktme_keyid_shift);
> > >  
> > >  DEFINE_STATIC_KEY_FALSE(mktme_enabled_key);
> > >  EXPORT_SYMBOL_GPL(mktme_enabled_key);
> > 
> > NAK, don't export variables. Who owns the values, who enforces this?
> > 
> 
> Both KVM and IOMMU driver need page_keyid() and mktme_keyid_shift to set page's keyID to the right
> place in the PTE (of KVM EPT and VT-d DMA page table).
> 
> MKTME key type code need to know mktme_nr_keyids in order to alloc/free keyID.
> 
> Maybe better to introduce functions instead of exposing variables directly?
> 
> Or instead of introducing page_keyid(), we use page_encrypt_mask(), which essentially holds
> "page_keyid() << mktme_keyid_shift"?

Yes, that's much better, because that strictly limits the access to R/O.
