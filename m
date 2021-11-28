Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EA0460531
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 09:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356812AbhK1IHG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 03:07:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39560 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356924AbhK1IFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 03:05:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1043B80B51;
        Sun, 28 Nov 2021 08:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E507C004E1;
        Sun, 28 Nov 2021 08:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638086506;
        bh=b48YjTY/pVez8afNE+wzU+3WaQKxxQEURvaxADRtwDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cf1UpbBDGUG/i+3B7710UJDtWCf5AiS+xYwJdJrswHkaMxwXqtghSrAeHqtG4ZEHm
         kjNjM7/02WtoShcjN6FHzZa/U5USbrnlhn4XjHsJy9PjfumjC3FQHsmSzJbZZYb97a
         uqjFGttZAm3d3AQ44noz4515EJlyQkKjujhY+AU0=
Date:   Sun, 28 Nov 2021 09:01:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Yury Norov <yury.norov@gmail.com>
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
Subject: Re: [PATCH 3/9] all: replace bitmap_weigth() with
 bitmap_{empty,full,eq,gt,le}
Message-ID: <YaM3ZeQS4tHzsRkK@kroah.com>
References: <20211128035704.270739-1-yury.norov@gmail.com>
 <20211128035704.270739-4-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211128035704.270739-4-yury.norov@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 27, 2021 at 07:56:58PM -0800, Yury Norov wrote:
> bitmap_weight() counts all set bits in the bitmap unconditionally.
> However in some cases we can traverse a part of bitmap when we
> only need to check if number of set bits is greater, less or equal
> to some number.
> 
> This patch replaces bitmap_weight() with one of
> bitmap_{empty,full,eq,gt,le), as appropriate.
> 
> In some places driver code has been optimized further, where it's
> trivial.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  arch/nds32/kernel/perf_event_cpu.c                 |  4 +---
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c             |  4 ++--
>  arch/x86/kvm/hyperv.c                              |  8 ++++----
>  drivers/crypto/ccp/ccp-dev-v5.c                    |  5 +----
>  drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c           |  2 +-
>  drivers/iio/adc/mxs-lradc-adc.c                    |  3 +--
>  drivers/iio/dummy/iio_simple_dummy_buffer.c        |  4 ++--
>  drivers/iio/industrialio-buffer.c                  |  2 +-
>  drivers/iio/industrialio-trigger.c                 |  2 +-
>  drivers/memstick/core/ms_block.c                   |  4 ++--
>  drivers/net/dsa/b53/b53_common.c                   |  2 +-
>  drivers/net/ethernet/broadcom/bcmsysport.c         |  6 +-----
>  drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  4 ++--
>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |  2 +-
>  .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |  2 +-
>  .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  8 ++++----
>  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  2 +-
>  drivers/net/ethernet/mellanox/mlx4/cmd.c           | 10 +++-------
>  drivers/net/ethernet/mellanox/mlx4/eq.c            |  4 ++--
>  drivers/net/ethernet/mellanox/mlx4/main.c          |  2 +-
>  .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  2 +-
>  drivers/net/ethernet/qlogic/qed/qed_dev.c          |  3 +--
>  drivers/net/ethernet/qlogic/qed/qed_rdma.c         |  4 ++--
>  drivers/net/ethernet/qlogic/qed/qed_roce.c         |  2 +-
>  drivers/perf/arm-cci.c                             |  2 +-
>  drivers/perf/arm_pmu.c                             |  4 ++--
>  drivers/perf/hisilicon/hisi_uncore_pmu.c           |  2 +-
>  drivers/perf/thunderx2_pmu.c                       |  3 +--
>  drivers/perf/xgene_pmu.c                           |  2 +-
>  drivers/pwm/pwm-pca9685.c                          |  2 +-
>  drivers/staging/media/tegra-video/vi.c             |  2 +-
>  drivers/thermal/intel/intel_powerclamp.c           | 10 ++++------
>  fs/ocfs2/cluster/heartbeat.c                       | 14 +++++++-------
>  33 files changed, 57 insertions(+), 75 deletions(-)

After you get the new functions added to the kernel tree, this patch
should be broken up into one-patch-per-subsystem and submitted through
the various subsystem trees.

thanks,

greg k-h
