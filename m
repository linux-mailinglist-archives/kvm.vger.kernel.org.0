Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BCF47B15D
	for <lists+kvm@lfdr.de>; Mon, 20 Dec 2021 17:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhLTQlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Dec 2021 11:41:07 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60774 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbhLTQlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Dec 2021 11:41:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A788761219;
        Mon, 20 Dec 2021 16:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EC6C36AE2;
        Mon, 20 Dec 2021 16:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640018465;
        bh=TuP185pT5gdSlNtfNfQ+Kye5lOB+euhTli9+HNxshOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=enGWQQJij7Gn5KXQIvc6DgLGhW8TsmstPvfbBL0Frpv76daIROB5Wk6RyCml6X1M0
         INr/wU0RVuAcWcOkPbgbi5U7MaR0NTk6+o3rhiyEe0vywSW27g/jS59FjbvlDzhRr3
         ovNt3nB3npaxHStYKaqE8ptag4HrP8L17DKCvcbQ=
Date:   Mon, 20 Dec 2021 17:41:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
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
        Emil Renner Berthing <kernel@esmil.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Geetha sowjanya <gakula@marvell.com>,
        Guo Ren <guoren@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Jens Axboe <axboe@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Joe Perches <joe@perches.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
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
Subject: Re: [PATCH 08/17] all: replace bitmap_weight with
 bitmap_weight_{eq,gt,ge,lt,le} where appropriate
Message-ID: <YcCyHvr1f+Z8M9M1@kroah.com>
References: <20211218212014.1315894-1-yury.norov@gmail.com>
 <20211218212014.1315894-9-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211218212014.1315894-9-yury.norov@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 18, 2021 at 01:20:04PM -0800, Yury Norov wrote:
> Kernel code calls bitmap_weight() to compare the weight of bitmap with
> a given number. We can do it more efficiently with bitmap_weight_{eq, ...}
> because conditional bitmap_weight may stop traversing the bitmap earlier,
> as soon as condition is met.
> 
> This patch replaces bitmap_weight with conditional versions where possible,
> except for small bitmaps which size is not configurable and  known at
> constant time. In that case conditional version of bitmap_weight would not
> benefit due to small_const_nbits() optimization; but readability may
> suffer.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c                 |  2 +-
>  drivers/iio/dummy/iio_simple_dummy_buffer.c            |  4 ++--
>  drivers/iio/industrialio-trigger.c                     |  2 +-
>  drivers/memstick/core/ms_block.c                       |  4 ++--
>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c         |  2 +-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  2 +-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_flows.c    |  4 ++--
>  drivers/net/ethernet/mellanox/mlx4/cmd.c               | 10 +++-------
>  drivers/net/ethernet/mellanox/mlx4/eq.c                |  4 ++--
>  drivers/net/ethernet/mellanox/mlx4/fw.c                |  4 ++--
>  drivers/net/ethernet/mellanox/mlx4/main.c              |  2 +-
>  drivers/perf/thunderx2_pmu.c                           |  4 ++--
>  drivers/staging/media/tegra-video/vi.c                 |  2 +-
>  13 files changed, 21 insertions(+), 25 deletions(-)

"all" is not how to submit changes to the kernel.  Please break them up
into subsystem-specific patches, and send them after your core changes
are accepted.

good luck!

greg k-h
