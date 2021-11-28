Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F51F460B37
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 00:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359483AbhK1Xls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 18:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241220AbhK1Xjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 18:39:47 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898A5C06174A;
        Sun, 28 Nov 2021 15:36:30 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id 193so20935202qkh.10;
        Sun, 28 Nov 2021 15:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+pvPLMMOaG75eXeO+MYWVtFy7p98nfe1U4iD6DUFgqs=;
        b=FqHxiwrQ7QYivLGpovhQrNQCHUCj7LxMV2WH4G2Ujzkjgck5ZuLpYg6YmyS5/pcjd8
         PioI6TsqEy6uPfhoz8wEavEgHnpCryLeBpBEb8dr5G6s12WteiFVLQFxrBR47EVsTB3X
         ndIWwpq8YabRGonzz7m7f+N7UJXzBMp2vfRHxXo9M1u6ZB6qiEh6DrJAZ2z7gRkAQ5sC
         IqRPeZsbgWqH6z7gZV/iyVzYOISv9QQ48jjOTsL+5HMXkolOWVbHK0gj+h+Ra3+OPnrQ
         HZwGnjmshXRb1nFHqTfVME98Ezv2622Zg9Ol7LGc837jR3cjnZ1W8PCl/MaA7m1eTWjV
         ggTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+pvPLMMOaG75eXeO+MYWVtFy7p98nfe1U4iD6DUFgqs=;
        b=7aCKBvnO39Y1LuXAjf4CAl3P3dr+n5iUSl7lBKO5t77W1Le21lLr7YvRw5FaPKHmiq
         ShOcyu57BVIRMNdlGnbI7HN6yV8DB/P0OlwZIZSm0MdLTk/GO/V3xwjg10HglkSYi5Pe
         KrwAAOWXjINFeJyw7pAJvUpSmV+8tZGvKFTlXrPIHi044KxyTJK2kYrHPdVS+PzBJxmJ
         pbWzbRIiqHJKtcgqWhXjLSdGtZNNl/WztchxAiPoYIaXMWhM8IZ5xaQK8EkvKC6k4Sv1
         Ur5vhoAmKInmDomlj15CoBqvBDVzl9Cdf/xXZmiMwTzxKaN+tsRQDozr7sbd7WLF+IzA
         jhGg==
X-Gm-Message-State: AOAM533px3vhgBpnIVbCj0cROWTiO3A0pfax9x4pTNf3EOCzzykhbySL
        8xS7jW+rvn1ISeyXYMYWOKs=
X-Google-Smtp-Source: ABdhPJwjz8dPYMt9os+urjypBO3KPO0n0aAUmhuhKTUddMw0/hFm/BxjybZbsejId+j0oxfauAhjwQ==
X-Received: by 2002:a05:620a:4491:: with SMTP id x17mr26762094qkp.528.1638142589577;
        Sun, 28 Nov 2021 15:36:29 -0800 (PST)
Received: from localhost ([66.216.211.25])
        by smtp.gmail.com with ESMTPSA id h19sm8013261qth.63.2021.11.28.15.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 15:36:28 -0800 (PST)
Date:   Sun, 28 Nov 2021 15:36:27 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andy Gross <agross@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Alexey Klimov <aklimov@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy@infradead.org>,
        Anup Patel <anup.patel@wdc.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@fb.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Lameter <cl@linux.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Dennis Zhou <dennis@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Geetha sowjanya <gakula@marvell.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Ian Rogers <irogers@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, kvm@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-crypto@vger.kernel.org, linux-csky@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-mm@kvack.org,
        linux-perf-users@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-snps-arc@lists.infradead.org,
        Andy Lutomirski <luto@kernel.org>,
        Mark Gross <markgross@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Marc Zyngier <maz@kernel.org>,
        Matti Vaittinen <mazziesaccount@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Ingo Molnar <mingo@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Marcin Wojtas <mw@semihalf.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Solomon Peachy <pizza@shaftnet.org>,
        Petr Mladek <pmladek@suse.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roy Pledge <Roy.Pledge@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Sunil Goutham <sgoutham@marvell.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tejun Heo <tj@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vineet Gupta <vgupta@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 0/9] lib/bitmap: optimize bitmap_weight() usage
Message-ID: <20211128233627.GA323159@lapt>
References: <20211128035704.270739-1-yury.norov@gmail.com>
 <1638096766.3elxdzb8ly.astroid@bobo.none>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638096766.3elxdzb8ly.astroid@bobo.none>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 28, 2021 at 09:08:41PM +1000, Nicholas Piggin wrote:
> Excerpts from Yury Norov's message of November 28, 2021 1:56 pm:
> > In many cases people use bitmap_weight()-based functions like this:
> > 
> > 	if (num_present_cpus() > 1)
> > 		do_something();
> > 
> > This may take considerable amount of time on many-cpus machines because
> > num_present_cpus() will traverse every word of underlying cpumask
> > unconditionally.
> > 
> > We can significantly improve on it for many real cases if stop traversing
> > the mask as soon as we count present cpus to any number greater than 1:
> > 
> > 	if (num_present_cpus_gt(1))
> > 		do_something();
> > 
> > To implement this idea, the series adds bitmap_weight_{eq,gt,le}
> > functions together with corresponding wrappers in cpumask and nodemask.
> 
> There would be no change to callers if you maintain counters like what
> is done for num_online_cpus() today. Maybe some fixes to arch code that
> does not use set_cpu_possible() etc APIs required, but AFAIKS it would
> be better to fix such cases anyway.

Thanks, Nick. I'll try to do this.
