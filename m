Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E55A39BC3D
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 17:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhFDPw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 11:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhFDPw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 11:52:28 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A63C061766
        for <kvm@vger.kernel.org>; Fri,  4 Jun 2021 08:50:25 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id z3-20020a17090a3983b029016bc232e40bso2698383pjb.4
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 08:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rhqoy6MY7EfOz8skYLjiR46KThNMAlNLitSfpvspEOE=;
        b=VWs4Ft09ePRlQVMbF6OkH6QZIrxW4iolcEcZ+Nt6BAwiWfEMw4rx8ZKo3nYOouKJeH
         4o8U0ijASb+UsRT+zm68+uVMfTzT3QsDFS/ShNHG2xFNSieE8lWf2eYqNyN6VCw26v4+
         8MHrpa5LQ3uQTGpO62eoi09ZWVAvP0xfhjgS3Oe9EgJpabsxf6BDDAVZ8eBhT+ApLeof
         6jwefViyOj1YC13Q6gykLk97nE0D9desp7yRtE8USN3FPwXWJSu1jiQj72/0z2CkJU/U
         0Cf229B+b41ZRV/5sqn2LWTXZ+cZj2FYJ6/SSt4IEP7QVUk0hq2cgL7+N38aSPeKa/fX
         358w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rhqoy6MY7EfOz8skYLjiR46KThNMAlNLitSfpvspEOE=;
        b=p38SX7nPeMrdi//mhefZu1pdJshGoIQyFrKeJBotl7zjxI0dR//w2W6n9C95ak+B8b
         njE/Gep1gtJfToLIcAfn70uuwJD71rU7c03XlwZm6ItZbk1a4XQTWSj3kmvzAXxKb0Hs
         KVD7NHKEfGMP6LxKRgWBiHeOGd7bCwMPrlyjNumSi/fHuV119Xs9QtDcexxwFOTZEQBI
         RajUuOWwQxEKiIPK5M2w39swLJBI/b74d/oa3geqRrGYKCVaSf6NA8BAW+cCbfl4KB9D
         pxogcEjjw2dCvNS/fIG7ILwu+V9Cm5IiZav387LhjukyoSGprAxq8l6eQkZ2ppHaSdQE
         GD9Q==
X-Gm-Message-State: AOAM5320IBh0Z01jxL8XYg9a0ZUwu8xaSOZHxDA4GXe4yL7of5adOqH1
        YqVfvWsrEDFE2uhWV0ltp/jcIQ==
X-Google-Smtp-Source: ABdhPJxwDvhE1O00g2lojLJgHXNo1TIt6Pbg8B0Q99pRi6w4FlIw45etfKPCelL6vgMTkTwN5cYq4A==
X-Received: by 2002:a17:90a:460d:: with SMTP id w13mr5656251pjg.35.1622821825138;
        Fri, 04 Jun 2021 08:50:25 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id w26sm2529767pgl.50.2021.06.04.08.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 08:50:24 -0700 (PDT)
Date:   Fri, 4 Jun 2021 15:50:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Yang Shi <yang.shi@linux.alibaba.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>
Subject: Re: PageTransCompoundMap confusion
Message-ID: <YLpLvFPXrIp8nAK4@google.com>
References: <YLo9egOQUiGo7CBO@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLo9egOQUiGo7CBO@casper.infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Will and Marc

On Fri, Jun 04, 2021, Matthew Wilcox wrote:
> I'm a bit confused about what PageTransCompoundMap() is supposed to do.
> What it actually does is check that the specific page (which may or
> may not be a head page) is not mapped by a PTE.  I don't understand why
> you'd care how some (other?) process does or does not have it mapped.
> What I _think_ you want to know is "Can I map this page with a PMD entry
> in the guest".  And the answer to that is simply:
> 
> bool kvm_is_transparent_hugepage(kvm_pfn_t pfn)
> {
> 	struct page *head = compound_head(pfn_to_page(pfn));
> 	return compound_order(head) >= HPAGE_PMD_ORDER;
> }
> 
> but maybe there's some reason you don't want to map hugetlbfs or other
> sufficiently large compound pages with PMDs?
> 
> Looking at the one caller of kvm_is_transparent_hugepage(), I'd be
> tempted to inline the above into transparent_hugepage_adjust()
> and call get_page() directly instead of indirecting through
> kvm_get_pfn().

arm64 is the only remaining user of kvm_is_transparent_hugepage().

x86 purged its usage a while back, and instead looks at the host PTEs via
lookup_address_in_mm() to get the current mapping level.  The motivation was to
consolidate the hugepage logic for THP, HugeTLBFS, and DAX, and to naturally
support both 2mb and 1gb for all flavors of hugepages.

Could arm64 do something similar and kill off kvm_is_transparent_hugepage()
entirely?
