Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B330685E9
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 11:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbfGOJCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 05:02:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:44199 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbfGOJCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 05:02:53 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 02:02:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,493,1557212400"; 
   d="scan'208";a="365809173"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 15 Jul 2019 02:02:48 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id DF2ED14B; Mon, 15 Jul 2019 12:02:47 +0300 (EEST)
Date:   Mon, 15 Jul 2019 12:02:47 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Alison Schofield <alison.schofield@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
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
Subject: Re: [PATCH, RFC 57/62] x86/mktme: Overview of Multi-Key Total Memory
 Encryption
Message-ID: <20190715090247.lclzdru5gqowweis@black.fi.intel.com>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-58-kirill.shutemov@linux.intel.com>
 <a2d2ac19-1dfe-6f85-df83-d72de4d5fcbf@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a2d2ac19-1dfe-6f85-df83-d72de4d5fcbf@infradead.org>
User-Agent: NeoMutt/20170714-126-deb55f (1.8.3)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jul 14, 2019 at 06:16:49PM +0000, Randy Dunlap wrote:
> On 5/8/19 7:44 AM, Kirill A. Shutemov wrote:
> > From: Alison Schofield <alison.schofield@intel.com>
> > 
> > Provide an overview of MKTME on Intel Platforms.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  Documentation/x86/mktme/index.rst          |  8 +++
> >  Documentation/x86/mktme/mktme_overview.rst | 57 ++++++++++++++++++++++
> >  2 files changed, 65 insertions(+)
> >  create mode 100644 Documentation/x86/mktme/index.rst
> >  create mode 100644 Documentation/x86/mktme/mktme_overview.rst
> 
> 
> > diff --git a/Documentation/x86/mktme/mktme_overview.rst b/Documentation/x86/mktme/mktme_overview.rst
> > new file mode 100644
> > index 000000000000..59c023965554
> > --- /dev/null
> > +++ b/Documentation/x86/mktme/mktme_overview.rst
> > @@ -0,0 +1,57 @@
> > +Overview
> > +=========
> ...
> > +--
> > +1. https://software.intel.com/sites/default/files/managed/a5/16/Multi-Key-Total-Memory-Encryption-Spec.pdf
> > +2. The MKTME architecture supports up to 16 bits of KeyIDs, so a
> > +   maximum of 65535 keys on top of the “TME key” at KeyID-0.  The
> > +   first implementation is expected to support 5 bits, making 63
> 
> Hi,
> How do 5 bits make 63 keys available?

Yep, typo. It has to be 6 bits.

Alison, please correct this.

-- 
 Kirill A. Shutemov
