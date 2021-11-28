Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FACB460502
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 07:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344015AbhK1GkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 01:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbhK1GiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 01:38:05 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D87C061574;
        Sat, 27 Nov 2021 22:34:50 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id p19so13083910qtw.12;
        Sat, 27 Nov 2021 22:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=rKuklq8jxCETHcjcAENlFbP3nl/uNBZqDfuGt3bzd1Q=;
        b=N/urFmV2NmOFP42e1LVLW8fwa/hr9KDv3ZUpw+lC8WGtW8rc7tWztvbdFPuGBjub1O
         wspFhVe7cCjM3GiHaTs/o61wPhHvRulBbX8eWk+oUvPHasNmnTk9fguzetRPFqMAMSbw
         NSq70yUrota4HuwP2mw6e4EdU69PrQnC7+N7r+KW5WUjDm+ME76HZpk50UYeWuhhvrtv
         jzlo36RajlwI73FqiorEZUjBdSjpmlO3li6nkrgdjIjD0UyBvsHE9SsWB4qkZCd+owE5
         cwmTSVDOhxhxddNAGQkE0CL6sKvMvIJPhAZNBZoNO0tLt8RIHXr/GUyMzCFG050MR/6f
         IXaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=rKuklq8jxCETHcjcAENlFbP3nl/uNBZqDfuGt3bzd1Q=;
        b=Pa80BKMN59lCsJjnNbgSKArKhYsSHTbwTyZdaLszu61Eq1nWBjNEjQOHxz7EdvC7vL
         oSrFrUT8QYtWq8xbe0sRfmtof1vQjHid40cNlXnlK3Mqlrz4knwp1vv0QswMbS0LlMBb
         wpOcDBBuXSAzIB15fSgwSph31VG5R5db6uJrmjcbUlMsSK3SCAWlO8ZvXCwtWGok3Hhg
         bYYyxsuz9uJFWaVuQHyMZUTLpb7HwJapCl/iQ1CEDgtuDS6zhSe5UF0uRLR5BDgqWEBe
         DeSMR4qUsze6spOYQrbR9cg2nfwoIVXhXOIvHwD3ZvK+AzZpJh5LCC51RTpPoODwdTPs
         F1vw==
X-Gm-Message-State: AOAM5326QRBlJ8UUkGW7nDB1bnPZnFyQb+S0TIdkKqiv+KG9AYU1uGAS
        DwwMJd341SsMv1Gst8Ree84=
X-Google-Smtp-Source: ABdhPJyJzVPAC11UsMz+HJsW0TzZJUpS9rijQwW94Vpknlgpg+/mG8cwCXUq1qsThYXJdJN6S8tP7Q==
X-Received: by 2002:ac8:5fcc:: with SMTP id k12mr35432768qta.346.1638081289128;
        Sat, 27 Nov 2021 22:34:49 -0800 (PST)
Received: from localhost ([66.216.211.25])
        by smtp.gmail.com with ESMTPSA id f18sm6419326qko.34.2021.11.27.22.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 22:34:48 -0800 (PST)
Date:   Sat, 27 Nov 2021 22:34:47 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Klimov <aklimov@redhat.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Andrew Lunn <andrew@lunn.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Andy Shevchenko <andy@infradead.org>,
        Anup Patel <anup.patel@wdc.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Lameter <cl@linux.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        David Laight <David.Laight@aculab.com>,
        Dennis Zhou <dennis@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Geetha sowjanya <gakula@marvell.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Jens Axboe <axboe@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Lee Jones <lee.jones@linaro.org>,
        Marc Zyngier <maz@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Mark Gross <markgross@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matti Vaittinen <mazziesaccount@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Roy Pledge <Roy.Pledge@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Solomon Peachy <pizza@shaftnet.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>, Tejun Heo <tj@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Vineet Gupta <vgupta@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Will Deacon <will@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, kvm@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-csky@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-snps-arc@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 7/9] lib/cpumask: add
 num_{possible,present,active}_cpus_{eq,gt,le}
Message-ID: <20211128063447.GA270945@lapt>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YaMME60Jfiz5BeJF@qmqm.qmqm.pl>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(restore CC list)

On Sun, Nov 28, 2021 at 05:56:51AM +0100, Michał Mirosław wrote:
> On Sat, Nov 27, 2021 at 07:57:02PM -0800, Yury Norov wrote:
> > Add num_{possible,present,active}_cpus_{eq,gt,le} and replace num_*_cpus()
> > with one of new functions where appropriate. This allows num_*_cpus_*()
> > to return earlier depending on the condition.
> [...]
> > @@ -3193,7 +3193,7 @@ int __init pcpu_page_first_chunk(size_t reserved_size,
> >  
> >  	/* allocate pages */
> >  	j = 0;
> > -	for (unit = 0; unit < num_possible_cpus(); unit++) {
> > +	for (unit = 0; num_possible_cpus_gt(unit); unit++) {
> 
> This looks dubious.

Only this?

> The old version I could hope the compiler would call
> num_possible_cpus() only once if it's marked const or pure, but the
> alternative is going to count the bits every time making this a guaranteed
> O(n^2) even though the bitmap doesn't change.

num_possible_cpus() is not const neither pure. This is O(n^2) before and after.

