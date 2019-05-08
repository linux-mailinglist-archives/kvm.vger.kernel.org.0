Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3056718151
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 22:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbfEHUtg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 16:49:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:26952 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726727AbfEHUtf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 16:49:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 13:49:35 -0700
X-ExtLoop1: 1
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 08 May 2019 13:49:34 -0700
Date:   Wed, 8 May 2019 13:52:25 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH, RFC 52/62] x86/mm: introduce common code for mem
 encryption
Message-ID: <20190508135225.3cb0e638@jacob-builder>
In-Reply-To: <20190508165830.GA11815@infradead.org>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
        <20190508144422.13171-53-kirill.shutemov@linux.intel.com>
        <20190508165830.GA11815@infradead.org>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 May 2019 09:58:30 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, May 08, 2019 at 05:44:12PM +0300, Kirill A. Shutemov wrote:
> > +EXPORT_SYMBOL_GPL(__mem_encrypt_dma_set);
> > +
> > +phys_addr_t __mem_encrypt_dma_clear(phys_addr_t paddr)
> > +{
> > +	if (sme_active())
> > +		return __sme_clr(paddr);
> > +
> > +	return paddr & ~mktme_keyid_mask;
> > +}
> > +EXPORT_SYMBOL_GPL(__mem_encrypt_dma_clear);  
> 
> In general nothing related to low-level dma address should ever
> be exposed to modules.  What is your intended user for these two?

Right no need to export. It will be used by IOMMU drivers.
