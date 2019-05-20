Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9627C22AF9
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 06:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbfETErd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 00:47:33 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42449 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfETErd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 00:47:33 -0400
Received: by mail-pg1-f193.google.com with SMTP id 145so6130772pgg.9;
        Sun, 19 May 2019 21:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c+5/e4r7QURAPjgt0pstVJODTU8tXgqkX2glWZVobkM=;
        b=gMto9eoPQaIySY3QLYHKjy9iAPNrE5GjdJZihgfu6ASZxDWdkLiG/Jx37ppauLIVIq
         fjxm3/5qPKUZ7skkK3/qXSJzQqNrYOtFbBYWBtDptNA0JkM+/fHlOI40rgIfjc0XaIHj
         zqgo5aDW5uMfG0imKjTCNK9Le6JydE/KBP6YAJTOaulJb3c8lcWvcZFg1dQ7JXiuWZvw
         SjVOegc7rAcM6F4cRaUiNsF29LbogDCvo8M8lS1TlxRZ7j8GxGEfpodNKhPr3xiJYXmL
         hRWqdH55As8gwi6V0VvZFYl1GpfCx1il16tazLsekk+h8ZMJVo1fUVAq1bCH6MYx1Ixj
         zV4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c+5/e4r7QURAPjgt0pstVJODTU8tXgqkX2glWZVobkM=;
        b=Sy6NGrr036q7zwQpgx+JRJCCG3l5/VXkr/Hxd/BijWrsXivPBMM9S+bzr8M5xPeD3v
         ll+zoyOsxsZv4FjI0kENb142RAfboJ6ZxVb9DQ+bBZF/mMyBtWylnLydp4GVylbOv08k
         Powce8EMi0jGZGSFPj7qEhQG52+UsWVseg+L1jEL+jXWSHJPHysH/mjUZgoXzBAUctW8
         Pj2jEVoHRRr9RH4eA8yBzBWRugj24uXtLzAEWNJIZTyIaBTavCvynQJy98teXYMdb8hn
         E4m4MLUOfo5khK79oMxK1ti/eldWLTIvZP9dk2sqkhkKFKze/w917bXsQK9MgD/vrJYp
         c64g==
X-Gm-Message-State: APjAAAU6QkHKQJid+jggZXuy65KVDbRgffD0nSHGlsIwmqcS6lwSPtRk
        V50d2IFfzKBydoKehiN3XKk=
X-Google-Smtp-Source: APXvYqw+D6cC0nRczOxV4So/Prf6dPmIMD7sQVDc/gsxpJURxndlNNlbZ8A1oi9dk6kQ4i6fv/BvyQ==
X-Received: by 2002:a63:e52:: with SMTP id 18mr73343114pgo.3.1558327652463;
        Sun, 19 May 2019 21:47:32 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com ([122.99.82.10])
        by smtp.googlemail.com with ESMTPSA id s28sm22719117pgl.88.2019.05.19.21.47.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 19 May 2019 21:47:31 -0700 (PDT)
Message-ID: <1558327647.5110.0.camel@gmail.com>
Subject: Re: [kvm-unit-tests PULL 1/2] powerpc: Allow for a custom decr
 value to be specified to load on decr excp
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org
Date:   Mon, 20 May 2019 14:47:27 +1000
In-Reply-To: <1bea83ba-6c64-3b21-baca-8c414ea86770@redhat.com>
References: <20190517130305.32123-1-lvivier@redhat.com>
         <20190517130305.32123-2-lvivier@redhat.com>
         <1bea83ba-6c64-3b21-baca-8c414ea86770@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.24.6 (3.24.6-1.fc26) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2019-05-17 at 15:10 +0200, Thomas Huth wrote:
> On 17/05/2019 15.03, Laurent Vivier wrote:
> > From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> > 
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
> > Reviewed-by: Thomas Huth <thuth@redhat.com>
> > Reviewed-by: Laurent Vivier <lvivier@redhat.com>
> > [lv: reset initial value to 0x3FFFFFFF]
> 
> Looks like something went wrong here? There is still the 0x7FFFFFFF
> in
> the hunk below...

No, I think this is correct.
Max value is ox7FFFFFFF, but the initial value we load via mtdec is the
original 0x3FFFFFFF.

> 
> > diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> > index 6744bd8d8049..3c2d98c9ca99 100644
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
> > @@ -288,7 +289,7 @@ int main(int argc, char **argv)
> >  		(void) getchar();
> >  	} else {
> >  		puts("Sleeping...\n");
> > -		handle_exception(0x900, &dec_except_handler,
> > NULL);
> > +		handle_exception(0x900, &dec_except_handler,
> > &decr);
> >  		asm volatile ("mtdec %0" : : "r" (0x3FFFFFFF));
> >  		hcall(H_CEDE);
> >  	}
> 
>  Thomas
