Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 059C72E44F
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 20:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfE2SQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 14:16:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:36716 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfE2SQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 14:16:14 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 11:16:13 -0700
X-ExtLoop1: 1
Received: from alison-desk.jf.intel.com ([10.54.74.53])
  by fmsmga005.fm.intel.com with ESMTP; 29 May 2019 11:16:13 -0700
Date:   Wed, 29 May 2019 11:20:04 -0700
From:   Alison Schofield <alison.schofield@intel.com>
To:     Mike Rapoport <rppt@linux.ibm.com>
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
        Jacob Pan <jacob.jun.pan@linux.intel.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 00/62] Intel MKTME enabling
Message-ID: <20190529182004.GA525@alison-desk.jf.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190529073006.GG3656@rapoport-lnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529073006.GG3656@rapoport-lnx>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 29, 2019 at 10:30:07AM +0300, Mike Rapoport wrote:
> On Wed, May 08, 2019 at 05:43:20PM +0300, Kirill A. Shutemov wrote:
> > = Intro =
> > 
> > The patchset brings enabling of Intel Multi-Key Total Memory Encryption.
> > It consists of changes into multiple subsystems:
> > 
> >  * Core MM: infrastructure for allocation pages, dealing with encrypted VMAs
> >    and providing API setup encrypted mappings.
> >  * arch/x86: feature enumeration, program keys into hardware, setup
> >    page table entries for encrypted pages and more.
> >  * Key management service: setup and management of encryption keys.
> >  * DMA/IOMMU: dealing with encrypted memory on IO side.
> >  * KVM: interaction with virtualization side.
> >  * Documentation: description of APIs and usage examples.
> > 
> > The patchset is huge. This submission aims to give view to the full picture and
> > get feedback on the overall design. The patchset will be split into more
> > digestible pieces later.
> > 
> > Please review. Any feedback is welcome.
> 
> It would be nice to have a brief usage description in cover letter rather
> than in the last patches in the series ;-)
>  

Thanks for making it all the way to the last patches in the set ;)

Yes, we will certainly include that usage model in the cover letters
of future patchsets. 

Alison
