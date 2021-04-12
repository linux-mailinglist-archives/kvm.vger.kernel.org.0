Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D87135D065
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 20:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237110AbhDLSbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 14:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbhDLSbW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 14:31:22 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FC2C061574
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 11:31:03 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id 20so2887666pll.7
        for <kvm@vger.kernel.org>; Mon, 12 Apr 2021 11:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KTXek3wu3TIvZC4D8KnpQ7WkjbGnlEOD8KPlvMfjSbE=;
        b=N2Xgo4sXOhN1wSIic0+ss421yNCI1zz0CCMMqkzu7u22Hr0fCnxY6TyNTiXhm59iKP
         pqHdoJ5vW4uCH9wX5ccxu12inS1B1w0b81tJLY0MyaLM2HlLa2sSVGuA8WPHH2q9t8WX
         bs/xh+OrQMaNpCCI6jW1mE+/ZmN3W0DAf8YOd8jwu1ooyERnye3Ms4eoGaysFaSzfRDb
         ShS5S7tt2Y8VOQGBIpKgfAiSh8FpChv2s0/VbEh0KPyeiUZj/VXsJZrsrDxAw2pqbH2Z
         4NjdYtCfey3enTI9lHEDNAZpieQAuCiDMsCHgEkZvkit3coNddwmBK7IkXhaGbIuJ6s5
         XhDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KTXek3wu3TIvZC4D8KnpQ7WkjbGnlEOD8KPlvMfjSbE=;
        b=N6pypNF4CtUYgoAeZJwRoOkLRkMDhfoSq5v3UDpOzT4GXmdUyD19o71GngSIqAbhdJ
         ZvH86NGSoBXwKvvCpf3f4jFwy5REUhS70tGJ+qOBLGeKRmsbke3zRqOiSRkYyhVypnX1
         pbacUHFXJmqQzqKbWxpBf91vL9vXt5sZEaIO+Fw+FyqK03u466HdglJNZeuJGN3X2xOk
         Gn5cI6MQK6xCH3tnH9dWDzuC6qAHwAb+NvIDBmSsZCil3I3nROwhUeTx3V5rh4h9EK1a
         SfKKfUvXSOqsA/PSi2rZSAYlyYzHshT2KlIEMLeXkRU8gpM/Rq3dRKTc/lGApKGN7TTV
         D1Yg==
X-Gm-Message-State: AOAM530Wlrybsn/fUf8KVlZ4gVluoNa3pe5gn88NuroxPMrDejFGsV2m
        AS70wRskm4tP93uFFbrcuoCybQ==
X-Google-Smtp-Source: ABdhPJxsah44wtBEgzYJCNZjjim9+OQyJ9J6BZFgAJ2ZRVjXwE9uqMbYUCm97EhSC65ptJNIa3m5RA==
X-Received: by 2002:a17:90a:29a5:: with SMTP id h34mr555735pjd.158.1618252263021;
        Mon, 12 Apr 2021 11:31:03 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id j1sm129086pjn.26.2021.04.12.11.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 11:31:02 -0700 (PDT)
Date:   Mon, 12 Apr 2021 18:30:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] [kvm-unit-tests PATCH] x86/access: Fix intermittent test
 failure
Message-ID: <YHSR4lWFupf6m9sv@google.com>
References: <20210409075518.32065-1-weijiang.yang@intel.com>
 <1c641daa-c11d-69b6-e63b-ff7d0576c093@redhat.com>
 <YHCkIRvXAFmS/hUn@google.com>
 <20210412132551.GA20077@local-michael-cet-test.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412132551.GA20077@local-michael-cet-test.sh.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 12, 2021, Yang Weijiang wrote:
> On Fri, Apr 09, 2021 at 06:59:45PM +0000, Sean Christopherson wrote:
> > On Fri, Apr 09, 2021, Paolo Bonzini wrote:
> > > On 09/04/21 09:55, Yang Weijiang wrote:
> > > > During kvm-unit-test, below failure pattern is observed, this is due to testing thread
> > > > migration + cache "lazy" flush during test, so forcely flush the cache to avoid the issue.
> > > > Pin the test app to certain physical CPU can fix the issue as well. The error report is
> > > > misleading, pke is the victim of the issue.
> > > > 
> > > > test user cr4.pke: FAIL: error code 5 expected 4
> > > > Dump mapping: address: 0x123400000000
> > > > ------L4: 21ea007
> > > > ------L3: 21eb007
> > > > ------L2: 21ec000
> > > > ------L1: 2000000
> > > > 
> > > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > > ---
> > > >   x86/access.c | 2 ++
> > > >   1 file changed, 2 insertions(+)
> > > > 
> > > > diff --git a/x86/access.c b/x86/access.c
> > > > index 7dc9eb6..379d533 100644
> > > > --- a/x86/access.c
> > > > +++ b/x86/access.c
> > > > @@ -211,6 +211,8 @@ static unsigned set_cr4_smep(int smep)
> > > >           ptl2[2] |= PT_USER_MASK;
> > > >       if (!r)
> > > >           shadow_cr4 = cr4;
> > > > +
> > > > +    invlpg((void *)(ptl2[2] & ~PAGE_SIZE));
> > > >       return r;
> > > >   }
> > > > 
> > > 
> > > Applied, thanks.
> > 
> > Egad, I can't keep up with this new Paolo :-D
> > 
> > 
> > Would it also work to move the existing invlpg() into ac_test_do_access()?
> >
> Hi, Sean,
> You patch works for the app on my side, but one thing makes my confused, my patch
> invalidates the mapping for test code(ac_test_do_access), but your patch invlidates
> at->virt, they're not mapped to the same page. Why it works?

I don't know why your patch works.  Best guess is that INVLPG on the PMD is
causing the CPU to flush the entire TLB, i.e. the problematic entry is collateral
damage.

> I simplified the test by only executing two patterns as below:
> 
> printf("\n############# start test ############\n\n");
> at.flags = 0x8000000;
> ac_test_exec(&at, &pool);
> at.flags = 0x200000; /* or 0x10200000 */
> ac_test_exec(&at, &pool);
> printf("############# end test ############\n\n");
> 
> with your patch I still got error code 5 while getting  error code 4 with my patch.
> What makes it different?

Now I'm really confused.  This:

  at.flags = 0x8000000;                                                         
  ac_test_exec(&at, &pool);

runs the test with a not-present PTE.  I don't understand how you are getting
error code '5' (USER + PRESENT) when running the user test; there shouldn't be
anything for at->virt in the TLB.

Are there tests being run before this point?  Even then, explicitly flushing
at->virt should work.  The fact that set_cr4_smep() modifies a PMD and not the
leaf PTE should be irrelevant.  Per the SDM:

  INVLPG also invalidates all entries in all paging-structure caches associated
  with the current PCID, regardless of the linear addresses to which they correspond.
