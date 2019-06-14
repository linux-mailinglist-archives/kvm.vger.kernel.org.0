Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD7B45BE8
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 13:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfFNLze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 07:55:34 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33656 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfFNLze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 07:55:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2Scd2Bpf0fSHqxbPEw6UkC56OpyXzshQKSbLT1BGTuQ=; b=SxtEFaoeA/gGdI45bl5WDh0rm
        I8rqVc2P6Ire31B/frJwfn3BZevD8+rTnnPsW81DmL1vcwL3Oroa/WTa+06mMLBfAOMXsESaJhjN9
        a9NGVOQTEB6X4Aegoqbb+TFZ99HagBthuhA9vzvY3S3/iNX7uvOOd7X/pg1x/2Dxmzp8e8uTgxpL9
        81ZTEgZxdLhnxb1L/1gBwZxfkS1ckTGyswxvZA/SieYXCt8MGN1t7v6waleq9Im39RATa/Tn5UiUr
        bFkXoa/Xp8tXJFJ6bva0NaMeh+vFMplN6lhH4kyKzdO9MMzyrWkt7X+2fLBI74i70KerNv8GQjFws
        GHtEJZjzA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbknh-0003ZT-QN; Fri, 14 Jun 2019 11:55:21 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5BB0620A15636; Fri, 14 Jun 2019 13:55:20 +0200 (CEST)
Date:   Fri, 14 Jun 2019 13:55:20 +0200
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
Subject: Re: [PATCH, RFC 47/62] mm: Restrict MKTME memory encryption to
 anonymous VMAs
Message-ID: <20190614115520.GH3436@hirez.programming.kicks-ass.net>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-48-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508144422.13171-48-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 05:44:07PM +0300, Kirill A. Shutemov wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> Memory encryption is only supported for mappings that are ANONYMOUS.
> Test the VMA's in an encrypt_mprotect() request to make sure they all
> meet that requirement before encrypting any.
> 
> The encrypt_mprotect syscall will return -EINVAL and will not encrypt
> any VMA's if this check fails.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

This should be folded back into the initial implemention, methinks.
