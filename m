Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A951245B39
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 13:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfFNLNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 07:13:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47758 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbfFNLNF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 07:13:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=i1QliRSRssHtMj47mzR6P+jISSuYGuhNkArj40f45F8=; b=DnjUInTHYTgYwyh7pongXj5/T
        Ay8lbubOYGhAWlhVvM886c+bKs/VCukcuX65+3paFYKGGBEeGVcsJIe2KC7j00yZd6L2aKstuoSKu
        3fBIKkyP/CFoy+Q3If93I8UX68YZmXW6qMiO06TBw/NRzwl9/nqXH6s5ZLrD6t3JxDh61Anxa+EcA
        ZaR6RGKOmIUeg9XOimSWcemzSR1iRSOxKbLooKwqeiarY03HnJauyAnA4lOuxvby+wb18EZL0YA2j
        Z1uw0FsV4IKCM8P717wtGATtTFbXI3LzDPvs4QzF/9BWifaGUkYR1xyAV60XwsvT3L7IJNsQ+IFvn
        M5ejZNvJg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbk8j-00013Z-1D; Fri, 14 Jun 2019 11:13:01 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 58A1420A29B4F; Fri, 14 Jun 2019 13:12:59 +0200 (CEST)
Date:   Fri, 14 Jun 2019 13:12:59 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
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
Message-ID: <20190614111259.GA3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-21-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-21-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:43:40PM +0300, Kirill A. Shutemov wrote:
> page_keyid() is inline funcation that uses lookup_page_ext(). KVM is
> going to use page_keyid() and since KVM can be built as a module
> lookup_page_ext() has to be exported.

I _really_ hate having to export world+dog for KVM. This one might not
be a real issue, but I itch every time I see an export for KVM these
days.
