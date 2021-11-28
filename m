Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977EE460853
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 19:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358755AbhK1SFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 13:05:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358807AbhK1SDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 13:03:33 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA88C0617A2;
        Sun, 28 Nov 2021 09:57:02 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id b13so10249269plg.2;
        Sun, 28 Nov 2021 09:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GIVU/9w51Ef2hg0ubArEuNU4cyYrytLI0Mp9d442l5g=;
        b=MOV5U2nrdRxFhWxyR7bOZpWlabqXOjxSoT999ssZl4Mq0S6JAhQfWyHw7OPilcdHmF
         6BGRpZnEpe8f9bpa77XQqQiPPBLd4gqEwap2s83tCamJXoetkbl6hCD0wkZTc5ZtL81/
         0oBwvtx8A8nEwcdqAvCz07X70fdDjUOrb88hgxJCEmCDBMTsfM8MgzFpsGuihBTo3i4/
         BO5H2USw15PhIR9jKFnq7EoAkCha2k8c7ry0hA6yyRozC0i3UkUk9dhKZX7Fdkb9vjGS
         8k1hfy+ikEeJEGfeYwNOOXgwgIH5nCo9f2fvYp5m9MjcvWjKnN995P4PSF7zBTJOShEa
         Axzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GIVU/9w51Ef2hg0ubArEuNU4cyYrytLI0Mp9d442l5g=;
        b=SNOr0Vk7t+2s5St7ZpxT1BZXRRkotlRASZZHgItDe5FHMqh/Vq2973XYX0YxhxYV2R
         sSD1LSxcgRuDiwbVjq/mC1c6DbJVWe8L+xmJZTVdo3ds0bGOHnv2GIyOKY5IySEwYo/g
         VwAd3RoheYvjyOfH+Obm4kaTaNiOaIMTj/QOWm8SnBpkuMr5jGFKNDelpqs3RPpnFc6q
         d24W76Wx7BbvqhYICtmP7pywWQQ/bj72P92iqZbH9TCHsYqMFL00hHHn1r3J8HkN6RU2
         nX0Jy267as/4U9Y3pWCd35Qa9ILfdeqULZjpw/bnFYeyoG6tV94u63OOZdfwjSoikZpe
         vbmA==
X-Gm-Message-State: AOAM5317DfD3Phv3xb7Y2gCl7ZE7oBsX8MFIXt0fN4FF+EYD03dDAIss
        hmaH2NP1op04j4/PZ0Iwpv7D3daa+nse8bcJcqA=
X-Google-Smtp-Source: ABdhPJwg/YAIedkhsO4JO/I1SvpK80O+jGy4LgSO12zXzv7Z2PPdL5Fb+4vML+arhaNI5Rnxj3zFEocQ77wPSF7XA5Q=
X-Received: by 2002:a17:902:b581:b0:144:e601:de7 with SMTP id
 a1-20020a170902b58100b00144e6010de7mr54292000pls.71.1638122222149; Sun, 28
 Nov 2021 09:57:02 -0800 (PST)
MIME-Version: 1.0
References: <20211128035704.270739-1-yury.norov@gmail.com> <20211128035704.270739-8-yury.norov@gmail.com>
 <8f389151c39a8a5b6b31d5238cb680305225d9f2.camel@perches.com> <20211128174320.GA304543@lapt>
In-Reply-To: <20211128174320.GA304543@lapt>
From:   Emil Renner Berthing <emil.renner.berthing@gmail.com>
Date:   Sun, 28 Nov 2021 18:56:51 +0100
Message-ID: <CANBLGczYBaxES12eCurm6fELat0U-9+VbuKUG_Fea3iK6d9RVA@mail.gmail.com>
Subject: Re: [PATCH 7/9] lib/cpumask: add num_{possible,present,active}_cpus_{eq,gt,le}
To:     Yury Norov <yury.norov@gmail.com>
Cc:     Joe Perches <joe@perches.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
        linux-alpha@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-crypto@vger.kernel.org, linux-csky@vger.kernel.org,
        linux-ia64@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-s390@vger.kernel.org, linux-snps-arc@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 28 Nov 2021 at 18:43, Yury Norov <yury.norov@gmail.com> wrote:
> On Sun, Nov 28, 2021 at 09:07:52AM -0800, Joe Perches wrote:
> > On Sat, 2021-11-27 at 19:57 -0800, Yury Norov wrote:
> > > Add num_{possible,present,active}_cpus_{eq,gt,le} and replace num_*_cpus()
> > > with one of new functions where appropriate. This allows num_*_cpus_*()
> > > to return earlier depending on the condition.
> > []
> > > diff --git a/arch/arc/kernel/smp.c b/arch/arc/kernel/smp.c
> > []
> > > @@ -103,7 +103,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
> > >      * if platform didn't set the present map already, do it now
> > >      * boot cpu is set to present already by init/main.c
> > >      */
> > > -   if (num_present_cpus() <= 1)
> > > +   if (num_present_cpus_le(2))
> > >             init_cpu_present(cpu_possible_mask);
> >
> > ?  is this supposed to be 2 or 1
>
> X <= 1 is the equivalent of X < 2.

Ah, then the function is confusing. Usually it's lt = less than and lt
= less than or equal. Same idea for gt vs ge.
