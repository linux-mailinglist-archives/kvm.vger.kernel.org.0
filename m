Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3EC465AE4
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 01:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354574AbhLBAfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 19:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354555AbhLBAfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 19:35:05 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CCCC061748;
        Wed,  1 Dec 2021 16:31:43 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id g9so21510077qvd.2;
        Wed, 01 Dec 2021 16:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=UYmHlVbMSQbQAn62a50WlYWlw5WYikEw/HKO8MU8o20=;
        b=d9ufFBZIjBeCnfJhxkhOJHR4U6gA3sYY5/+OartHrmtyqhNuwpEH+tfc93YA7tEDao
         yOKDodcNFRle3eMMLCg2FH/Tcgr7cW593yntXLl1utZLUJtVShRNQEOc9NvEo4hEL1rm
         L2l6bxTExKPSRmbnMRKqIcZhoOpd63W1ZKagDrFCRbYIcYvSgN+CxBxrwTxGRSsHeVKf
         UXZK5TS9EbCKBOwmJzZ51FgzKmkah4fU/bnP1hNtNTskTK6qjluwzPEk7uWUTAkKCdZ1
         XxzA5TtEBQPg9PU9R4bStLW9Ne4zdJoIM+RpRwYI7AmQcqEYlTEIoOnEsCuvtTzXmNFj
         00eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=UYmHlVbMSQbQAn62a50WlYWlw5WYikEw/HKO8MU8o20=;
        b=DqgKolkPKqrXWQ9HL31Gh9PdPZs17c/UeEKZhGq60VRHXQ6uTNba6E/gNEUxut08dv
         BHOQn9E98Ihcvm1zXUgxhpbpnnEjF0jlav6odkYf/Joq6Rr7OvVz5ikG1n3dScMllSfV
         bbib4a7agBzI+XqmGmgPWRjrmrEbqzKgWOQs9W9OXoh95Jeb73VIC5Ybs0Cf8BEJN7zO
         dw6xVat2T54fpTuZzynPwMSsduLVyroCpi+LqLusdQDuUXsk3/Lfup4/2g+Aik850tNm
         vsC1vU3KSAOFl9M0aptStnfAVXSUAL9aj52YcX/gpW68+Od52EgD/S5I7nmCouZhGygC
         KWlA==
X-Gm-Message-State: AOAM531xs/j1H7toXiM+CsSCkZxtlJtD5205OnDQr9ckExVG1T5rtFcu
        djcGDJZSzKqo5WWxMOuislJkR1zSj3cXaQ==
X-Google-Smtp-Source: ABdhPJwpuPpSi7n83vlL+jLX5fyPRTIJyAHbiKfUe+xvjm76YV/xzPPNg/iMW1GhI6PSi3iKc0YBEA==
X-Received: by 2002:a05:6214:ccc:: with SMTP id 12mr9930154qvx.8.1638405102640;
        Wed, 01 Dec 2021 16:31:42 -0800 (PST)
Received: from localhost ([66.216.211.25])
        by smtp.gmail.com with ESMTPSA id l1sm690890qkp.125.2021.12.01.16.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 16:31:42 -0800 (PST)
Date:   Wed, 1 Dec 2021 16:31:40 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Alexey Klimov <aklimov@redhat.com>,
        linux-alpha@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Gross <agross@kernel.org>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Petr Mladek <pmladek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Lunn <andrew@lunn.ch>, Andi Kleen <ak@linux.intel.com>,
        Tejun Heo <tj@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Anup Patel <anup.patel@wdc.com>, linux-ia64@vger.kernel.org,
        Andy Shevchenko <andy@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Matti Vaittinen <mazziesaccount@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Christoph Hellwig <hch@lst.de>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Borislav Petkov <bp@alien8.de>, Arnd Bergmann <arnd@arndb.de>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Laight <David.Laight@aculab.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        bcm-kernel-feedback-list@broadcom.com,
        Christoph Lameter <cl@linux.com>, linux-crypto@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>, linux-mm@kvack.org,
        Guo Ren <guoren@kernel.org>,
        linux-snps-arc@lists.infradead.org,
        Geetha sowjanya <gakula@marvell.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dennis Zhou <dennis@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <hca@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Roy Pledge <Roy.Pledge@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>, Jens Axboe <axboe@fb.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jonathan Cameron <jic23@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Vineet Gupta <vgupta@kernel.org>,
        Solomon Peachy <pizza@shaftnet.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Will Deacon <will@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        kvm@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        linux-csky@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        linux-mips@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        linux-perf-users@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-s390@vger.kernel.org, Mark Gross <markgross@kernel.org>,
        linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 0/9] lib/bitmap: optimize bitmap_weight() usage
Message-ID: <20211202003140.GA430494@lapt>
References: <20211128035704.270739-1-yury.norov@gmail.com>
 <YaPEfZ0t9UFGwpml@qmqm.qmqm.pl>
 <20211129063839.GA338729@lapt>
 <3CD9ECD8-901E-497B-9AE1-0DDB02346892@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3CD9ECD8-901E-497B-9AE1-0DDB02346892@rere.qmqm.pl>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 04:34:07PM +0000, Michał Mirosław wrote:
> Dnia 29 listopada 2021 06:38:39 UTC, Yury Norov <yury.norov@gmail.com> napisał/a:
> >On Sun, Nov 28, 2021 at 07:03:41PM +0100, mirq-test@rere.qmqm.pl wrote:
> >> On Sat, Nov 27, 2021 at 07:56:55PM -0800, Yury Norov wrote:
> >> > In many cases people use bitmap_weight()-based functions like this:
> >> > 
> >> > 	if (num_present_cpus() > 1)
> >> > 		do_something();
> >> > 
> >> > This may take considerable amount of time on many-cpus machines because
> >> > num_present_cpus() will traverse every word of underlying cpumask
> >> > unconditionally.
> >> > 
> >> > We can significantly improve on it for many real cases if stop traversing
> >> > the mask as soon as we count present cpus to any number greater than 1:
> >> > 
> >> > 	if (num_present_cpus_gt(1))
> >> > 		do_something();
> >> > 
> >> > To implement this idea, the series adds bitmap_weight_{eq,gt,le}
> >> > functions together with corresponding wrappers in cpumask and nodemask.
> >> 
> >> Having slept on it I have more structured thoughts:
> >> 
> >> First, I like substituting bitmap_empty/full where possible - I think
> >> the change stands on its own, so could be split and sent as is.
> >
> >Ok, I can do it.
> >
> >> I don't like the proposed API very much. One problem is that it hides
> >> the comparison operator and makes call sites less readable:
> >> 
> >> 	bitmap_weight(...) > N
> >> 
> >> becomes:
> >> 
> >> 	bitmap_weight_gt(..., N)
> >> 
> >> and:
> >> 	bitmap_weight(...) <= N
> >> 
> >> becomes:
> >> 
> >> 	bitmap_weight_lt(..., N+1)
> >> or:
> >> 	!bitmap_weight_gt(..., N)
> >> 
> >> I'd rather see something resembling memcmp() API that's known enough
> >> to be easier to grasp. For above examples:
> >> 
> >> 	bitmap_weight_cmp(..., N) > 0
> >> 	bitmap_weight_cmp(..., N) <= 0
> >> 	...
> >
> >bitmap_weight_cmp() cannot be efficient. Consider this example:
> >
> >bitmap_weight_lt(1000 0000 0000 0000, 1) == false
> >                 ^
> >                 stop here
> >
> >bitmap_weight_cmp(1000 0000 0000 0000, 1) == 0
> >                                 ^
> >                                 stop here
> >
> >I agree that '_gt' is less verbose than '>', but the advantage of 
> >'_gt' over '>' is proportional to length of bitmap, and it means
> >that this API should exist.
> 
> Thank you for the example. Indeed, for less-than to be efficient here you would need to replace
>  bitmap_weight_cmp(..., N) < 0
> with
>  bitmap_weight_cmp(..., N-1) <= 0

Indeed, thanks for pointing to it.
 
> It would still be more readable, I think.

To be honest, I'm not sure that
        bitmap_weight_cmp(..., N-1) <= 0
would be an obvious replacement for the original
        bitmap_weight(...) < N
comparing to 
        bitmap_weight_lt(..., N)

I think the best thing I can do is to add bitmap_weight_cmp() as
you suggested, and turn lt and others to be wrappers on it. This
will let people choose a better function in each case.

I also think that for v2 it would be better to drop the conversion
for short bitmaps, except for switching to bitmap_empty(), because
in that case readability wins over performance; if no objections. 

Thanks,
Yury
