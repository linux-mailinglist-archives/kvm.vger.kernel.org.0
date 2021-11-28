Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717F7460874
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 19:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353068AbhK1SPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 13:15:44 -0500
Received: from rere.qmqm.pl ([91.227.64.183]:47062 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238059AbhK1SNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 13:13:44 -0500
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4J2Gjn33d2zW8;
        Sun, 28 Nov 2021 19:10:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1638123024; bh=JZhqOAoOJwkFLsUnNQo8o++CiFK7HEGKhePgc/FSOF4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BSqkw57UlW2pW1NXQ5wZ96M5n0daMnNFg3ZZGk4QpT65f28st6tvSbAjCuaDYp0Y0
         CmyX5dp3fxa/1bsCgFSoiXvYl/Ivrvk/XW5Lhr31jLklN0/6fnKbeszxM4AJMOo6b9
         hs1WVqqJVnnkAxwtLxudxAhzHN+6r0DPz2i1TcI1//mgPfBMhwBro3m3CGjmkmEKO0
         zFXYptfKQJ6Xhp//QSGLBmM8xlFJVmHJ9/rNfVpoRczyIK6/HJ5953QI6d4A5Zxyqw
         UnYVoDxFeKZcNpL0K/UJMA5pXP8gOMjtVWWYJxoXBIppSPMAs/Uq2+pv87S9vD8wOI
         LfWcTnK2w+pRg==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.103.3 at mail
Date:   Sun, 28 Nov 2021 19:10:20 +0100
From:   =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
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
Message-ID: <YaPGDOvBzhiRFcOP@qmqm.qmqm.pl>
References: <20211128035704.270739-1-yury.norov@gmail.com>
 <20211128035704.270739-3-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211128035704.270739-3-yury.norov@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 27, 2021 at 07:56:57PM -0800, Yury Norov wrote:
> Now as we have bitmap_weight_eq(), switch bitmap_full() and
> bitmap_empty() to using it.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  include/linux/bitmap.h | 26 ++++++++++----------------
>  1 file changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> index 996041f771c8..2d951e4dc814 100644
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -386,22 +386,6 @@ static inline int bitmap_subset(const unsigned long *src1,
>  		return __bitmap_subset(src1, src2, nbits);
>  }
>  
> -static inline bool bitmap_empty(const unsigned long *src, unsigned nbits)
> -{
> -	if (small_const_nbits(nbits))
> -		return ! (*src & BITMAP_LAST_WORD_MASK(nbits));
> -
> -	return find_first_bit(src, nbits) == nbits;
> -}

Since this is supposed to be an optimization, I would go all the way and
replace this with the trivial implementation instead:

bool bitmap_empty(long *bits, size_t nbits)
{
	for (; nbits >= BITS_PER_LONG; ++bits, nbits -= BITS_PER_LONG)
		if (*bits)
			return false;

	if (nbits && *bits & BITMAP_LAST_WORD_MASK(nbits))
		return false;

	return true;
}
 
Best Regards
Micha³ Miros³aw
