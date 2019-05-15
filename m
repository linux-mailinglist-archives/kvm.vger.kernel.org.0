Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1CBD1FCC7
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 01:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfEOX37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 19:29:59 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37718 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfEOX16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 19:27:58 -0400
Received: by mail-pf1-f194.google.com with SMTP id g3so777383pfi.4;
        Wed, 15 May 2019 16:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=okDJOcLTw50sbIY4czXBkDRFjJplAdmZ5Oir4pfxoyw=;
        b=fIUfYQnKdJ8g50+Sqk62eXHWZNn4IGXFSaHeUsAcMZMEuEvUlTC+MSIPVLUMimamG6
         qTqgKxbVFkHA/O8xEwTBWQw2kjOAG/omPAdG5acze/XdtZXJfNa4hAeNNs4Co5v4ACvv
         07VT0Pn4664G/zYmGXlNW8i/59kYRiJCgWQv+QOnhuRh1m4dQjyYEW+o2cxmv9Jc7t1g
         lSNeYEzoAwWuc3dvLHxCtpWUTkoj/H5dH4TZABiqzQbvu7IxNQWAgKt0m8/TydBY06YX
         4+kEN8aXPl0EWlLVFxZdU0tiNnzTsHaK/fbOw09djpK4QkqD9ol0cEf//HeJQZQVuwK+
         ujXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=okDJOcLTw50sbIY4czXBkDRFjJplAdmZ5Oir4pfxoyw=;
        b=g7BH0SyoAG3p1yUETsdKslSElPe8BORutJib+vxIfXXsRJx5wTZ6xLd5HEFrb7ltP6
         /rUMo4Gga43Tk/hAkL22HN0R+Hx4CETgrW1OUH+gVV9KzJ4Z0AmABOfdUCmabC1c317H
         qFbg+Jd095/6dJtMD2jBwIaOy3nX/wndF8UMqEJJbehByYRSVt+1ke8G6fejpjNAW4Q2
         lietPAhBNiRksPqclKnP4zIzg60IEEhtVZ9NxWMrhfXK4M+NP5VvqJ865bM1PWUztCmZ
         ELM4qFtlBa5goU/xcD2WWYK6axPhLXLfxVqcfBoFhhN30KqJTr0DFMfz3t4vnJaJiX4D
         0KoQ==
X-Gm-Message-State: APjAAAW7QzASSXjfwl3YmN27dpP88NBjeZP85HbJqYy5ipvRwe6fzksu
        kfC+vXKBSpkYlyIc4CbCi0G5WZpI
X-Google-Smtp-Source: APXvYqyGhDNLrM1M+gSFTydAFpgMMp90nk2hB1n6TJO+Ep574sGD4/pBdjoifk0kf4pDSrbaF2NFJg==
X-Received: by 2002:a63:231c:: with SMTP id j28mr46927988pgj.430.1557962877747;
        Wed, 15 May 2019 16:27:57 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.googlemail.com with ESMTPSA id j19sm4318421pfr.155.2019.05.15.16.27.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 May 2019 16:27:56 -0700 (PDT)
Message-ID: <1557962870.1877.1.camel@gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/2] powerpc: Allow for a custom decr
 value to be specified to load on decr excp
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, thuth@redhat.com, dgibson@redhat.com
Date:   Thu, 16 May 2019 09:27:50 +1000
In-Reply-To: <132d5cba-1b9e-0be9-848b-676848af7c48@redhat.com>
References: <20190515002801.20517-1-sjitindarsingh@gmail.com>
         <132d5cba-1b9e-0be9-848b-676848af7c48@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2019-05-15 at 18:22 +0200, Laurent Vivier wrote:
> On 15/05/2019 02:28, Suraj Jitindar Singh wrote:
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
> > 
> > ---
> > 
> > V1 -> V2:
> > - Make decr variables static
> > - Load intial decr value in tm test to ensure known value present
> > ---
> >  lib/powerpc/handlers.c | 7 ++++---
> >  powerpc/sprs.c         | 5 +++--
> >  powerpc/tm.c           | 4 +++-
> >  3 files changed, 10 insertions(+), 6 deletions(-)
> > 
> > diff --git a/lib/powerpc/handlers.c b/lib/powerpc/handlers.c
> > index be8226a..c8721e0 100644
> > --- a/lib/powerpc/handlers.c
> > +++ b/lib/powerpc/handlers.c
> > @@ -12,11 +12,12 @@
> >  
> >  /*
> >   * Generic handler for decrementer exceptions (0x900)
> > - * Just reset the decrementer back to its maximum value
> > (0x7FFFFFFF)
> > + * Just reset the decrementer back to the value specified when
> > registering the
> > + * handler
> >   */
> > -void dec_except_handler(struct pt_regs *regs __unused, void *data
> > __unused)
> > +void dec_except_handler(struct pt_regs *regs __unused, void *data)
> >  {
> > -	uint32_t dec = 0x7FFFFFFF;
> > +	uint64_t dec = *((uint64_t *) data);
> >  
> >  	asm volatile ("mtdec %0" : : "r" (dec));
> >  }
> > diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> > index 6744bd8..0e2e1c9 100644
> > --- a/powerpc/sprs.c
> > +++ b/powerpc/sprs.c
> > @@ -253,6 +253,7 @@ int main(int argc, char **argv)
> >  		0x1234567890ABCDEFULL, 0xFEDCBA0987654321ULL,
> >  		-1ULL,
> >  	};
> > +	static uint64_t decr = 0x7FFFFFFF; /* Max value */
> >  
> >  	for (i = 1; i < argc; i++) {
> >  		if (!strcmp(argv[i], "-w")) {
> > @@ -288,8 +289,8 @@ int main(int argc, char **argv)
> >  		(void) getchar();
> >  	} else {
> >  		puts("Sleeping...\n");
> > -		handle_exception(0x900, &dec_except_handler,
> > NULL);
> > -		asm volatile ("mtdec %0" : : "r" (0x3FFFFFFF));
> > +		handle_exception(0x900, &dec_except_handler,
> > &decr);
> > +		asm volatile ("mtdec %0" : : "r" (decr));
> 
> why do you replace the 0x3FFFFFFF by decr which is 0x7FFFFFFF?

Oh yeah, my mistake. I mis-read and thought they were the same. Is
there any reason it was 0x3FFFFFFF? Can this be fixed up when applying
or should I resend?

> 
> >  		hcall(H_CEDE);
> >  	}
> >  
> > diff --git a/powerpc/tm.c b/powerpc/tm.c
> > index bd56baa..c588985 100644
> > --- a/powerpc/tm.c
> > +++ b/powerpc/tm.c
> > @@ -95,11 +95,13 @@ static bool enable_tm(void)
> >  static void test_h_cede_tm(int argc, char **argv)
> >  {
> >  	int i;
> > +	static uint64_t decr = 0x3FFFFF; /* ~10ms */
> >  
> >  	if (argc > 2)
> >  		report_abort("Unsupported argument: '%s'",
> > argv[2]);
> >  
> > -	handle_exception(0x900, &dec_except_handler, NULL);
> > +	handle_exception(0x900, &dec_except_handler, &decr);
> > +	asm volatile ("mtdec %0" : : "r" (decr));
> >  
> >  	if (!start_all_cpus(halt, 0))
> >  		report_abort("Failed to start secondary cpus");
> > 
> 
> Thanks,
> Laurent
