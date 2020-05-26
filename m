Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5223C1E20FE
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 13:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbgEZLiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 07:38:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731446AbgEZLix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 07:38:53 -0400
Received: from kernel.org (unknown [87.70.212.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C32A1207CB;
        Tue, 26 May 2020 11:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590493133;
        bh=Wajw1ceENB9jmRhxQhR29w1N42Not5ApNmO0wbs23pY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1N6YuY0hI/08pJzS1NvVuzOOBihDQpySVba0Krk295SyXzDWHiffI26uav4ppjIbs
         wQGF3JptzzAzWlYbkIxctDjMjC9vTc8hSrONfenzVWnDWmDunT42Q++sXWRJSEm7wM
         Dj6Y3E0YTUqm2BpIau0CmHykWgCcHsYOQy/5HTz4=
Date:   Tue, 26 May 2020 14:38:44 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFC 00/16] KVM protected memory extension
Message-ID: <20200526113844.GC48741@kernel.org>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <42685c32-a7a9-b971-0cf4-e8af8d9a40c6@oracle.com>
 <20200526061721.GB48741@kernel.org>
 <8866ff79-e8fd-685d-9a1d-72acff5bf6bb@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8866ff79-e8fd-685d-9a1d-72acff5bf6bb@oracle.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 01:16:14PM +0300, Liran Alon wrote:
> 
> On 26/05/2020 9:17, Mike Rapoport wrote:
> > On Mon, May 25, 2020 at 04:47:18PM +0300, Liran Alon wrote:
> > > On 22/05/2020 15:51, Kirill A. Shutemov wrote:
> > > 
> > Out of curiosity, do we actually have some numbers for the "non-trivial
> > performance cost"? For instance for KVM usecase?
> > 
> Dig into XPFO mailing-list discussions to find out...
> I just remember that this was one of the main concerns regarding XPFO.

The XPFO benchmarks measure total XPFO cost, and huge share of it comes
from TLB shootdowns.

It's not exactly measurement of the imapct of the direct map
fragmentation to workload running inside a vitrual machine.

> -Liran

-- 
Sincerely yours,
Mike.
