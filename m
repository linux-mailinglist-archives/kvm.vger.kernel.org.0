Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08394460832
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 18:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358784AbhK1R7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 12:59:22 -0500
Received: from mail-qt1-f182.google.com ([209.85.160.182]:33414 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346095AbhK1R5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 12:57:21 -0500
Received: by mail-qt1-f182.google.com with SMTP id n15so14133120qta.0;
        Sun, 28 Nov 2021 09:54:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CTle792AODDh5EJBSlHCgdnz2AP0iG3Ix/URPyjXa5E=;
        b=ayKKcGsaMPX+AGiBixvOw9Q/wrboovbodUgIipZR+9Tq8NsRSQg3yj9Pfj9D4HZY/4
         Y3bTbs9HSxYK6ChRtkxceFNMDGPpuQNTsol38+kPYLpzB3DfTGU3J8wYixiX7pqVN9Rg
         g+RCFfY5ra3RO6Z3f5E3l/yBfe5TVRD5kAlr8RaTlIaHNlLPHJt7vuvry6rAuF3F6t/m
         jWf5k0daiSUbIoj0XvFiGHDFfs+9ye2Jaeri16diY61J9zwYkGzSxVxZcZgTHvdaUQot
         /ZoEbbT7xqFCalQYRYyPEP0zyTwzLotyfmt+xlEhFqnmYnknduM9PqjtEaexb3Fn9gNz
         MW7A==
X-Gm-Message-State: AOAM530nLHk8EO2pKIeNJ7SucYlm9M4US4hbJph4GueL4mwY+UWO6wc+
        Ux+A17VoSPgnhA8MRjzPipmdWL8kUA8CGQ==
X-Google-Smtp-Source: ABdhPJx25AEVnfH0h4sZET5x0dxImad0u4ySfFGiKfI+WvQd75qCTeFgZjdPUL+9cNE2+e8o/NeT8g==
X-Received: by 2002:ac8:5b87:: with SMTP id a7mr38253502qta.196.1638122044539;
        Sun, 28 Nov 2021 09:54:04 -0800 (PST)
Received: from fedora (pool-173-68-57-129.nycmny.fios.verizon.net. [173.68.57.129])
        by smtp.gmail.com with ESMTPSA id r16sm7298126qta.46.2021.11.28.09.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 09:54:03 -0800 (PST)
Date:   Sun, 28 Nov 2021 12:54:00 -0500
From:   Dennis Zhou <dennis@kernel.org>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <YaPCOPqpI/oKrTXl@fedora>
References: <20211128035704.270739-1-yury.norov@gmail.com>
 <20211128035704.270739-8-yury.norov@gmail.com>
 <8f389151c39a8a5b6b31d5238cb680305225d9f2.camel@perches.com>
 <20211128174320.GA304543@lapt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211128174320.GA304543@lapt>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Sun, Nov 28, 2021 at 09:43:20AM -0800, Yury Norov wrote:
> On Sun, Nov 28, 2021 at 09:07:52AM -0800, Joe Perches wrote:
> > On Sat, 2021-11-27 at 19:57 -0800, Yury Norov wrote:
> > > Add num_{possible,present,active}_cpus_{eq,gt,le} and replace num_*_cpus()
> > > with one of new functions where appropriate. This allows num_*_cpus_*()
> > > to return earlier depending on the condition.
> > []
> > > diff --git a/arch/arc/kernel/smp.c b/arch/arc/kernel/smp.c
> > []
> > > @@ -103,7 +103,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> > >  	 * if platform didn't set the present map already, do it now
> > >  	 * boot cpu is set to present already by init/main.c
> > >  	 */
> > > -	if (num_present_cpus() <= 1)
> > > +	if (num_present_cpus_le(2))
> > >  		init_cpu_present(cpu_possible_mask);
> > 
> > ?  is this supposed to be 2 or 1
> 
> X <= 1 is the equivalent of X < 2.
> 
> > > diff --git a/drivers/cpufreq/pcc-cpufreq.c b/drivers/cpufreq/pcc-cpufreq.c
> > []
> > > @@ -593,7 +593,7 @@ static int __init pcc_cpufreq_init(void)
> > >  		return ret;
> > >  	}
> > >  
> > > -	if (num_present_cpus() > 4) {
> > > +	if (num_present_cpus_gt(4)) {
> > >  		pcc_cpufreq_driver.flags |= CPUFREQ_NO_AUTO_DYNAMIC_SWITCHING;
> > >  		pr_err("%s: Too many CPUs, dynamic performance scaling disabled\n",
> > >  		       __func__);
> > 
> > It looks as if the present variants should be using the same values
> > so the _le test above with 1 changed to 2 looks odd.
>  

I think the confusion comes from le meaning less than rather than lt.
Given the general convention of: lt (<), le (<=), eg (=), ge (>=),
gt (>), I'd consider renaming your le to lt.

Thanks,
Dennis
