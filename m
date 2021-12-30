Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6414481EBE
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 18:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhL3RuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Dec 2021 12:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbhL3RuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Dec 2021 12:50:17 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F42FC061574
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 09:50:17 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id f18-20020a17090aa79200b001ad9cb23022so23748534pjq.4
        for <kvm@vger.kernel.org>; Thu, 30 Dec 2021 09:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mpb0ULgk7PQRr0DmUxaMdI6xxfBGGaQkslgbSoCUNHA=;
        b=NgJ+9BTsMf1m7mDgCmWxYUgNlMmFrCi6HHh15cqEOb77mqDWbjEX7pJe0kgelHHqFd
         QvTqOJgFTxGy1iNkMqGH55Vzt9ChmchqkRCWlDKpBg3/5zUDLKI4HrGuXI8KXjvsxnnv
         Aefi90AUzpiPgY5r9ZTGNfpvdj/80N7mzmkZYnpL0IEooEz/8wnO5cdHJ1wJItaGzo0C
         pvL/F4a8YN8rDSQ053UsjfJKn6M8ijorEgo8h7fAioxjY5yhwIGckauasZF5HSwurfde
         B0FMSv9+B7hYuoCeNzHfQkIjYXK8KeWDbyXQ2Yly5vzEuV016nzvGTjZhwJ3Dnfl5HtQ
         EncQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mpb0ULgk7PQRr0DmUxaMdI6xxfBGGaQkslgbSoCUNHA=;
        b=d+Usl/OuvSVnuBG8Ix0Ujuqj869kKuoIM2WXjyccg+8YEIrtV7O+tETr76xkJRYPsL
         pLEYXo6StX5FNTt+4EieGDMAXEk04cIObqvFm+B2XBYt3VI6ihpc5tmIrHbNOTx01y7T
         a8IUPOmMSLGAiOSwvlDWDQqSxiYvCg9Fwpc2pKlrnjb7y3Kx4udFF17SR/5Bhpg5nwwd
         jsEbz/kX2sTTpdFHMybEbi9HdhHY/HA79vuLbg9E3yZc/hp9fn3Dw1H6beGeEjkDAhy2
         PZy3yD7pDolxWlTxmVUCqZ8YDVTFpKWyzT1ftOKkJTGq2n2/3pwdCTSJ4V4OxElYbSRf
         UoJA==
X-Gm-Message-State: AOAM530VLyYhfJWpoQ2HeA5IeGk04CP+ZB7YK0A5w8TYMqwcJjPN/Xl6
        gQL8ujcFCJBrv6VKQ9Ghq/Ti5A==
X-Google-Smtp-Source: ABdhPJxjf0uOgc15nPhgO5QF+aaJccjckY17H0t6jNHspvF8t8z0Pq6j+/m0ZvyWqDOdC7O7JadHBA==
X-Received: by 2002:a17:90a:c506:: with SMTP id k6mr39397591pjt.74.1640886616129;
        Thu, 30 Dec 2021 09:50:16 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k141sm27256560pfd.144.2021.12.30.09.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 09:50:15 -0800 (PST)
Date:   Thu, 30 Dec 2021 17:50:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhenzhong Duan <zhenzhong.duan@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] x86: Assign a canonical address before
 execute invpcid
Message-ID: <Yc3xVIo8x+4DtQwx@google.com>
References: <20211230101452.380581-1-zhenzhong.duan@intel.com>
 <Yc3VryxgJbXXwyy3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yc3VryxgJbXXwyy3@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 30, 2021, Sean Christopherson wrote:
> On Thu, Dec 30, 2021, Zhenzhong Duan wrote:
> > Occasionally we see pcid test fail as INVPCID_DESC[127:64] is
> > uninitialized before execute invpcid.
> > 
> > According to Intel spec: "#GP If INVPCID_TYPE is 0 and the linear
> > address in INVPCID_DESC[127:64] is not canonical."
> > 
> > Assign desc's address which is guaranteed to be a real memory
> > address and canonical.
> > 
> > Fixes: b44d84dae10c ("Add PCID/INVPCID test")
> > Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
> > ---
> >  x86/pcid.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/x86/pcid.c b/x86/pcid.c
> > index 527a4a9..4828bbc 100644
> > --- a/x86/pcid.c
> > +++ b/x86/pcid.c
> > @@ -75,6 +75,9 @@ static void test_invpcid_enabled(int pcid_enabled)
> >      struct invpcid_desc desc;
> >      desc.rsv = 0;
> >  
> > +    /* Initialize INVPCID_DESC[127:64] with a canonical address */
> > +    desc.addr = (u64)&desc;
> 
> Casting to a u64 is arguably wrong since the address is an unsigned long.  It
> doesn't cause problems because the test is 64-bit only, but it's a bit odd.

I take that back, "struct invpcid_desc" is the one that's "wrong".  Again, doesn't
truly matter as attempting to build on 32-bit would fail due to the bitfield values
exceeding the storage capacity of an unsigned long.  But to be pedantic, maybe this?

diff --git a/x86/pcid.c b/x86/pcid.c
index 527a4a9..fd218dd 100644
--- a/x86/pcid.c
+++ b/x86/pcid.c
@@ -5,9 +5,9 @@
 #include "desc.h"

 struct invpcid_desc {
-    unsigned long pcid : 12;
-    unsigned long rsv  : 52;
-    unsigned long addr : 64;
+    u64 pcid : 12;
+    u64 rsv  : 52;
+    u64 addr : 64;
 };

 static int write_cr0_checking(unsigned long val)
@@ -73,7 +73,8 @@ static void test_invpcid_enabled(int pcid_enabled)
     int passed = 0, i;
     ulong cr4 = read_cr4();
     struct invpcid_desc desc;
-    desc.rsv = 0;
+
+    memset(&desc, 0, sizeof(desc));

     /* try executing invpcid when CR4.PCIDE=0, desc.pcid=0 and type=0..3
      * no exception expected
