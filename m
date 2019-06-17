Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2F547E77
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 11:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfFQJbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 05:31:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50838 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbfFQJbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 05:31:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=S6Eux1+C4YWs/QuUA6SdliFdoSV6T3YyLMZZE5kCxoc=; b=RUBMKb3UfCdPutyLXQFsDEmKI
        Re6hCejTEV4R0QEWXbWr1K++kvxXqJmFehO8gKOWiiMoNlpMiQPU+ntcT1yCXHePZ+lHyf05s/0+t
        fKrO5mJAjcBO15sERkJaSnBM4UW4zaBb179cK8DbMSoNLkX2HexrlSQqGTuph4i1O5UO6U0qHoi9e
        vSrciALv3UC2tHwFxGamq+atN57Vg+H1QVVTmxGbEIo5TB4/1qBj5abfZsIVz58l6JsblHdBNTn0u
        Md3uulXM/xZzWdYAX50mjrdreT/YH0//O2BAS4Me5fkXCfird5wtoe2TiAmFC9N3ytSAqd+X7ce2n
        zPvKrDuzg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hcnyZ-0005HC-RB; Mon, 17 Jun 2019 09:30:56 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 487DA20144539; Mon, 17 Jun 2019 11:30:54 +0200 (CEST)
Date:   Mon, 17 Jun 2019 11:30:54 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 20/62] mm/page_ext: Export lookup_page_ext() symbol
Message-ID: <20190617093054.GB3419@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-21-kirill.shutemov@linux.intel.com>
 <20190614111259.GA3436@hirez.programming.kicks-ass.net>
 <20190614224443.qmqolaigu5wnf75p@box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614224443.qmqolaigu5wnf75p@box>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 15, 2019 at 01:44:43AM +0300, Kirill A. Shutemov wrote:
> On Fri, Jun 14, 2019 at 01:12:59PM +0200, Peter Zijlstra wrote:
> > On Wed, May 08, 2019 at 05:43:40PM +0300, Kirill A. Shutemov wrote:
> > > page_keyid() is inline funcation that uses lookup_page_ext(). KVM is
> > > going to use page_keyid() and since KVM can be built as a module
> > > lookup_page_ext() has to be exported.
> > 
> > I _really_ hate having to export world+dog for KVM. This one might not
> > be a real issue, but I itch every time I see an export for KVM these
> > days.
> 
> Is there any better way? Do we need to invent EXPORT_SYMBOL_KVM()? :P

Or disallow KVM (or parts thereof) from being a module anymore.
