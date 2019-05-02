Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2BB124D8
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 00:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfEBWzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 18:55:20 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39400 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfEBWzT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 18:55:19 -0400
Received: by mail-pf1-f196.google.com with SMTP id z26so1855287pfg.6;
        Thu, 02 May 2019 15:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5GXQIbVXA5kN1c3RZLp2JpQgT7akX3+Cx9Zb1NRwUpk=;
        b=D/Rm5eXzhoNZ5XUDIYmERoJPDqy8P5QN6ZSNCd1PphqasamA/Yd4mkpbxfUJPjXP8T
         mG6CembNOdRN0GY/CwG4NqSAoCAGkaQ6syJWIrYZp4NhnBAr2BI1rOFjKbtleIh05NuL
         W3JGEqfPafb3PnFvzTrD3By+i9To9UDqtAmC8otifzY7lE73NvqxlWpiabwTmwwhPm0N
         umihs0sbBLcQbU/xVicSvXuUOj0WjkZkNZu4nElhaY1jMOyaKClGPOkV8D+9aUmAQ6tJ
         r0fuPtrexPqinCJlL1MJpCCQGpWL44ZbWh6JHaJtuHPEOcr1LkteKaP4IzWhlhwKxxd0
         IiDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5GXQIbVXA5kN1c3RZLp2JpQgT7akX3+Cx9Zb1NRwUpk=;
        b=J/5D8wF8TK1E55t3YDnhiKaSKUdP31QjFi/0cM/C+x0rAuF0YCUnw3CwYuXGjKZe0S
         L9kv2m6GXSUTLCx+aljGWlEcjHhZrSOZ18BxmBwcKbeSV9b8B4BG+h9BZSnQEhVwm5I1
         ZBqtLGd5tFOMVOr8TSq3iuwwFzpmkyQm00p2b3gyy6aPoXOmWKJPJKNmthfIG02fcSc2
         XHBJsUj1JaszODnN9oFWKEnYejW3AXIGYUQWkT1XFP44K0Y1xc5tN0F6BA9zbJ7x1VWR
         vg99sgwcIi+czRLiufu57hlwMOM1m/JpUovneZwJ9rAO1pQfHN99TROj6N3WCCa+Vmm0
         K5nw==
X-Gm-Message-State: APjAAAViu3jJnmbL6nOZSU/pYtYtK9FjYvaqNHvt4OF/OOeG42Yq+ulG
        q291lyvtzECF5eisNxjKhuv6HYaX
X-Google-Smtp-Source: APXvYqzv1P11m53zwhZTszMBzUkJLIpIjLti64U4K8C/XSSnawUOkuplUkApgtCtntf2n9ekYTJL5A==
X-Received: by 2002:a63:8342:: with SMTP id h63mr6748361pge.251.1556837718587;
        Thu, 02 May 2019 15:55:18 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.googlemail.com with ESMTPSA id r87sm291565pfa.71.2019.05.02.15.55.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 May 2019 15:55:17 -0700 (PDT)
Message-ID: <1556837714.1887.3.camel@gmail.com>
Subject: Re: [kvm-unit-tests PATCH] powerpc: Allow for a custom decr value
 to be specified to load on decr excp
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, kvm-ppc@vger.kernel.org, dgibson@redhat.com
Date:   Fri, 03 May 2019 08:55:14 +1000
In-Reply-To: <ec8d1a58-e066-f61a-ad28-92b82fccdbff@redhat.com>
References: <20190501070039.2903-1-sjitindarsingh@gmail.com>
         <ec8d1a58-e066-f61a-ad28-92b82fccdbff@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2019-05-02 at 10:01 +0200, Laurent Vivier wrote:
> On 01/05/2019 09:00, Suraj Jitindar Singh wrote:
> > Currently the handler for a decrementer exception will simply
> > reload the
> > maximum value (0x7FFFFFFF), which will take ~4 seconds to expire
> > again.
> > This means that if a vcpu cedes, it will be ~4 seconds between
> > wakeups.
> > 
> > The h_cede_tm test is testing a known breakage when a guest cedes
> > while
> > suspended. To be sure we cede 500 times to check for the bug.
> > However
> > since it takes ~4 seconds to be woken up once we've ceded, we only
> > get
> > through ~20 iterations before we reach the 90 seconds timeout and
> > the
> > test appears to fail.
> > 
> > Add an option when registering the decrementer handler to specify
> > the
> > value which should be reloaded by the handler, allowing the timeout
> > to be
> > chosen.
> > 
> > Modify the spr test to use the max timeout to preserve existing
> > behaviour.
> > Modify the h_cede_tm test to use a 10ms timeout to ensure we can
> > perform
> > 500 iterations before hitting the 90 second time limit for a test.
> > 
> > This means the h_cede_tm test now succeeds rather than timing out.
> > 
> > Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> > ---
> >   lib/powerpc/handlers.c | 7 ++++---
> >   powerpc/sprs.c         | 3 ++-
> >   powerpc/tm.c           | 3 ++-
> >   3 files changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/lib/powerpc/handlers.c b/lib/powerpc/handlers.c
> > index be8226a..c8721e0 100644
> > --- a/lib/powerpc/handlers.c
> > +++ b/lib/powerpc/handlers.c
> > @@ -12,11 +12,12 @@
> >   
> >   /*
> >    * Generic handler for decrementer exceptions (0x900)
> > - * Just reset the decrementer back to its maximum value
> > (0x7FFFFFFF)
> > + * Just reset the decrementer back to the value specified when
> > registering the
> > + * handler
> >    */
> > -void dec_except_handler(struct pt_regs *regs __unused, void *data
> > __unused)
> > +void dec_except_handler(struct pt_regs *regs __unused, void *data)
> >   {
> > -	uint32_t dec = 0x7FFFFFFF;
> > +	uint64_t dec = *((uint64_t *) data);
> >   
> >   	asm volatile ("mtdec %0" : : "r" (dec));
> >   }
> > diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> > index 6744bd8..3bd6ac7 100644
> > --- a/powerpc/sprs.c
> > +++ b/powerpc/sprs.c
> > @@ -253,6 +253,7 @@ int main(int argc, char **argv)
> >   		0x1234567890ABCDEFULL, 0xFEDCBA0987654321ULL,
> >   		-1ULL,
> >   	};
> > +	uint64_t decr = 0x7FFFFFFF;
> >   
> >   	for (i = 1; i < argc; i++) {
> >   		if (!strcmp(argv[i], "-w")) {
> > @@ -288,7 +289,7 @@ int main(int argc, char **argv)
> >   		(void) getchar();
> >   	} else {
> >   		puts("Sleeping...\n");
> > -		handle_exception(0x900, &dec_except_handler,
> > NULL);
> > +		handle_exception(0x900, &dec_except_handler,
> > &decr);
> >   		asm volatile ("mtdec %0" : : "r" (0x3FFFFFFF));
> >   		hcall(H_CEDE);
> >   	}
> > diff --git a/powerpc/tm.c b/powerpc/tm.c
> > index bd56baa..0f3f543 100644
> > --- a/powerpc/tm.c
> > +++ b/powerpc/tm.c
> > @@ -95,11 +95,12 @@ static bool enable_tm(void)
> >   static void test_h_cede_tm(int argc, char **argv)
> >   {
> >   	int i;
> > +	uint64_t decr = 0x3FFFFF;
> >   
> >   	if (argc > 2)
> >   		report_abort("Unsupported argument: '%s'",
> > argv[2]);
> >   
> > -	handle_exception(0x900, &dec_except_handler, NULL);
> > +	handle_exception(0x900, &dec_except_handler, &decr);
> 
> Maybe you should also need here:
> 
>      asm volatile ("mtdec %0" : : "r" (decr));
> 
> To set the first one to the same values as the following ones?

I guess we could get a case where the decrementer is really large (if
large decrementer is enabled for example) and otherwise we just don't
wake up...

In practise I'm not sure. But I'll add it if you like

Suraj.

> 
> Thanks,
> Laurent
