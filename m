Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5964604F9
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 07:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243086AbhK1Gcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 01:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbhK1Gaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 01:30:46 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80254C061574;
        Sat, 27 Nov 2021 22:27:30 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id t83so19290690qke.8;
        Sat, 27 Nov 2021 22:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=UUaWw2/vndQwOuhRc6j6PRwXuBODm2Svdcs9xeM4FlQ=;
        b=RUU7MzRkdirUtowuDWCiM08P7YQBQBC0acoWzbBj+T+XJI6vVMBSu6aGIKh4+icUwh
         a8q9bMYJuHCqFTUz0wNigsRNRIbsDwqKoKMNa0qnfF66qijICeNv/dPkbz+/087xhZlV
         f64hTvJmbUAx1It3pzpI4UUvGtwyNbU+zmtX09eMQ0ByGsuhC27g5T60WwoNMBivtuLQ
         VUm/Sp71jqGs+1C8GEcrf12fOpYmPWgYxCrrC9gGrggZZRnsjHL5/c7LM3QqhQgnqCqj
         LxxzrdrvicV7rQvSx7+bgEc8nFcDr55sjaFrS6W7kwXrGHkLvw0E6R41fTx7A36r5Slm
         hdow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=UUaWw2/vndQwOuhRc6j6PRwXuBODm2Svdcs9xeM4FlQ=;
        b=P2zgZuLkMdeIie8+ajuEUT0Z5ZPxwXdbbYZzDUyemG+xIYkV/Axp5N0JkJ97KCVz1w
         8kRuC5SAwEgLFPhudHmmCvermmeo3KBAooYslxFZgX3VIQBlYVI4sBqwGiWmw9f6keCO
         QcOiNtufyyubg/x5UKxBJyDM1ftQ9DYnsCXof4/cH0f/A0f3peLNcGxa3g737iut/aBn
         ABUeXkOw0jvdp0huHIMrvxR1UeGBPrAvNGl+MYgF1CyJkxTsxqtSiMi2XQoy1F3OkzWa
         rQU0vXxk3jMghwIhKmExeaM241tqt2PFh5CzQg8GqjLU/fmwZHyPJFCJhHRRcwrXbKII
         sS4A==
X-Gm-Message-State: AOAM530QQ+dU++2QOBYKqARdhv0mvDMMy77LZ8EaJW+Brt6aU6bIZ4iB
        rF1mWoTQd0gTTlkgqRQyXKA=
X-Google-Smtp-Source: ABdhPJxAVXtuKFpo3xQALAgWXmZbnwidtxXikhe9UCcw/0T4+58Z974u1PPCzNdv2+qiERrm5clSCw==
X-Received: by 2002:a05:620a:2153:: with SMTP id m19mr32383206qkm.77.1638080848758;
        Sat, 27 Nov 2021 22:27:28 -0800 (PST)
Received: from localhost ([66.216.211.25])
        by smtp.gmail.com with ESMTPSA id z4sm6611865qtj.42.2021.11.27.22.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 22:27:28 -0800 (PST)
Date:   Sat, 27 Nov 2021 22:27:27 -0800
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
Subject: Re: [PATCH 2/9] lib/bitmap: implement bitmap_{empty,full} with
 bitmap_weight_eq()
Message-ID: <20211128062727.GA276670@lapt>
References: <20211128035704.270739-1-yury.norov@gmail.com>
 <20211128035704.270739-3-yury.norov@gmail.com>
 <YaMHfzZ5PBn0714Z@qmqm.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YaMHfzZ5PBn0714Z@qmqm.qmqm.pl>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 28, 2021 at 05:37:19AM +0100, Michał Mirosław wrote:
> On Sat, Nov 27, 2021 at 07:56:57PM -0800, Yury Norov wrote:
> > Now as we have bitmap_weight_eq(), switch bitmap_full() and
> > bitmap_empty() to using it.
> [...]
> > -static inline bool bitmap_empty(const unsigned long *src, unsigned nbits)
> > -{
> > -	if (small_const_nbits(nbits))
> > -		return ! (*src & BITMAP_LAST_WORD_MASK(nbits));
> > -
> > -	return find_first_bit(src, nbits) == nbits;
> > -}
> [...]
> > +static __always_inline bool bitmap_empty(const unsigned long *src, unsigned int nbits)
> > +{
> > +	return bitmap_weight_eq(src, nbits, 0);
> > +}
> [..]
> 
> What's the speed difference? Have you benchmarked this?

bitmap_weight_eq() should be faster than find_first_bit(), but the
difference is few cycles, so I didn't bother measuring it.

New version looks just better.
