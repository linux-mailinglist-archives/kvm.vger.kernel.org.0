Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1638C461BDC
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 17:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346560AbhK2Qjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 11:39:47 -0500
Received: from rere.qmqm.pl ([91.227.64.183]:50146 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345506AbhK2Qhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 11:37:46 -0500
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 4J2rXL58g0z9h;
        Mon, 29 Nov 2021 17:34:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1638203665; bh=qlu3mL+FOvVS9aPE/gZoS7KdAdQ/avBctxZ8QxqT38I=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=GV8Md+4wLJhNSJZqrJvdjyVU0DlzlhbpPkGnTNqVApkG+uUQ6A+MoaqEQT9dgrjXq
         q+escBY9SwJTtDVYNHqesyY22ZcfBKeLVi2I4yINeaBpICc3EsCTOMz8/JkEhkxKwH
         5jlUqEb0yuAf8eVUX8cWy9bi6RovdDbzWpM+g8ZdNeFAwiFdkLHHM+FUiQ+x0Dv37t
         bEpCos1VGSJffWt42H8cWp9GNUDKdAgiFLCcBLScmau30GyMgUFylkw6qvpMGUFype
         xiTzGA2klsrhcAXTQoeGJ7H6y00R/3ukWQ3tN7aMIYo31vE1Ni41oAjMZVdXQclWDE
         FhYcDpXStxEZw==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.103.3 at mail
Date:   Mon, 29 Nov 2021 16:34:07 +0000
From:   =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
To:     Yury Norov <yury.norov@gmail.com>
CC:     linux-kernel@vger.kernel.org,
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
User-Agent: K-9 Mail for Android
In-Reply-To: <20211129063839.GA338729@lapt>
References: <20211128035704.270739-1-yury.norov@gmail.com> <YaPEfZ0t9UFGwpml@qmqm.qmqm.pl> <20211129063839.GA338729@lapt>
Message-ID: <3CD9ECD8-901E-497B-9AE1-0DDB02346892@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dnia 29 listopada 2021 06:38:39 UTC, Yury Norov <yury=2Enorov@gmail=2Ecom> =
napisa=C5=82/a:
>On Sun, Nov 28, 2021 at 07:03:41PM +0100, mirq-test@rere=2Eqmqm=2Epl wrot=
e:
>> On Sat, Nov 27, 2021 at 07:56:55PM -0800, Yury Norov wrote:
>> > In many cases people use bitmap_weight()-based functions like this:
>> >=20
>> > 	if (num_present_cpus() > 1)
>> > 		do_something();
>> >=20
>> > This may take considerable amount of time on many-cpus machines becau=
se
>> > num_present_cpus() will traverse every word of underlying cpumask
>> > unconditionally=2E
>> >=20
>> > We can significantly improve on it for many real cases if stop traver=
sing
>> > the mask as soon as we count present cpus to any number greater than =
1:
>> >=20
>> > 	if (num_present_cpus_gt(1))
>> > 		do_something();
>> >=20
>> > To implement this idea, the series adds bitmap_weight_{eq,gt,le}
>> > functions together with corresponding wrappers in cpumask and nodemas=
k=2E
>>=20
>> Having slept on it I have more structured thoughts:
>>=20
>> First, I like substituting bitmap_empty/full where possible - I think
>> the change stands on its own, so could be split and sent as is=2E
>
>Ok, I can do it=2E
>
>> I don't like the proposed API very much=2E One problem is that it hides
>> the comparison operator and makes call sites less readable:
>>=20
>> 	bitmap_weight(=2E=2E=2E) > N
>>=20
>> becomes:
>>=20
>> 	bitmap_weight_gt(=2E=2E=2E, N)
>>=20
>> and:
>> 	bitmap_weight(=2E=2E=2E) <=3D N
>>=20
>> becomes:
>>=20
>> 	bitmap_weight_lt(=2E=2E=2E, N+1)
>> or:
>> 	!bitmap_weight_gt(=2E=2E=2E, N)
>>=20
>> I'd rather see something resembling memcmp() API that's known enough
>> to be easier to grasp=2E For above examples:
>>=20
>> 	bitmap_weight_cmp(=2E=2E=2E, N) > 0
>> 	bitmap_weight_cmp(=2E=2E=2E, N) <=3D 0
>> 	=2E=2E=2E
>
>bitmap_weight_cmp() cannot be efficient=2E Consider this example:
>
>bitmap_weight_lt(1000 0000 0000 0000, 1) =3D=3D false
>                 ^
>                 stop here
>
>bitmap_weight_cmp(1000 0000 0000 0000, 1) =3D=3D 0
>                                 ^
>                                 stop here
>
>I agree that '_gt' is less verbose than '>', but the advantage of=20
>'_gt' over '>' is proportional to length of bitmap, and it means
>that this API should exist=2E

Thank you for the example=2E Indeed, for less-than to be efficient here yo=
u would need to replace
 bitmap_weight_cmp(=2E=2E=2E, N) < 0
with
 bitmap_weight_cmp(=2E=2E=2E, N-1) <=3D 0

It would still be more readable, I think=2E

Best Regards
Micha=C5=82 Miros=C5=82aw
