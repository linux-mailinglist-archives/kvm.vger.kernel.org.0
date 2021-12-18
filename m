Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C16F479D25
	for <lists+kvm@lfdr.de>; Sat, 18 Dec 2021 22:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhLRVVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Dec 2021 16:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbhLRVUj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Dec 2021 16:20:39 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B350C061746;
        Sat, 18 Dec 2021 13:20:39 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id m6so9357878oim.2;
        Sat, 18 Dec 2021 13:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GUqPfWmU6f9MK/QXiRQLZcQ9F1QsVSWWK571Ot9oIxE=;
        b=hfcawraa9tTE2tV32Lqk+3wfPsGEMDYsM0IK6gUmsFmGNuwLZjW0huAN9qU8EwuPoo
         5k7MSSEqu01CZYqfeU5LSK/e8D6uuRrmxwt9qDMnJa1I80ulPtLA2GtHdI5tPQK1BzRX
         at6dD7gTWW2fpasNYFbDYAhyy8of2TpYtGAllUu8hD+hDyH0tj6cTs2or3r30/AlnrIa
         autdfD/MUkFDBqV3AuVQKfMwo3c48fzfkaZ+di2R+D2G00hS2LPKPzOThGTpvNs4snIb
         ac4DTnMzgL2cMGCL8bdEtgRm3hqd60/4HvGqQQMJNjdiYo3rtzwfmA/hx3zgDTZC+SKy
         Vs7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GUqPfWmU6f9MK/QXiRQLZcQ9F1QsVSWWK571Ot9oIxE=;
        b=h7nCUYz+rnFBNUJ+3fZT+dVYuPMaOCyHpsmEK+U9pKwS4L4BDlYbBNi1acxq3xK9Jp
         qYeUznkhAKidKYMPy9IE6kqs0pElH2w0F9H9NvkeFOzlMgk/F1HNpK2j7Q7ZEBwuYkZ4
         iJzk5M7xUXxGIYmmIaheiFW7CjHMVU33mfdU+Klcfr0Q9XmsPxKHbOgarWyXQWgWSCsh
         7BBrcthT/Plr9zJHz/D6WfXYS+p5ynlSMatYXBINd/7YferUf7UiPzw0cDphNRUl16Lj
         hEO0np88f+WaT6iAhAgnYP64JsBMcDlnjPdjkwXezRq///dMjZlvB7g83JsPd4OFe0Kd
         x03A==
X-Gm-Message-State: AOAM53197XsPpDrC7PpwRMsDJVI3uNDFdJQ+iexyr8l9niJ/Do9tOpPu
        M6e1IVHKr3SoMIYaBTdJFqrgmsAwlEKzAg==
X-Google-Smtp-Source: ABdhPJwMghCWSAXUdG9w873jzrPra4gD4vLC9CVG4QJCBThdyFFc0fiXAMtWvAylP2GRwZ72nMb1wQ==
X-Received: by 2002:a05:6808:1914:: with SMTP id bf20mr6913245oib.7.1639862436787;
        Sat, 18 Dec 2021 13:20:36 -0800 (PST)
Received: from localhost (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id d11sm2335240otu.36.2021.12.18.13.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 13:20:36 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
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
        David Laight <David.Laight@ACULAB.COM>,
        Dennis Zhou <dennis@kernel.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Geetha sowjanya <gakula@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: [PATCH 06/17] all: replace nodes_weight with nodes_empty where appropriate
Date:   Sat, 18 Dec 2021 13:20:02 -0800
Message-Id: <20211218212014.1315894-7-yury.norov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211218212014.1315894-1-yury.norov@gmail.com>
References: <20211218212014.1315894-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kernel code calls nodes_weight() to check if any bit of a given nodemask is
set. We can do it more efficiently with nodes_empty() because nodes_empty()
stops traversing the nodemask as soon as it finds first set bit, while
nodes_weight() counts all bits unconditionally.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 arch/x86/mm/amdtopology.c    | 2 +-
 arch/x86/mm/numa_emulation.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/amdtopology.c b/arch/x86/mm/amdtopology.c
index 058b2f36b3a6..b3ca7d23e4b0 100644
--- a/arch/x86/mm/amdtopology.c
+++ b/arch/x86/mm/amdtopology.c
@@ -154,7 +154,7 @@ int __init amd_numa_init(void)
 		node_set(nodeid, numa_nodes_parsed);
 	}
 
-	if (!nodes_weight(numa_nodes_parsed))
+	if (nodes_empty(numa_nodes_parsed))
 		return -ENOENT;
 
 	/*
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index 1a02b791d273..9a9305367fdd 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -123,7 +123,7 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 	 * Continue to fill physical nodes with fake nodes until there is no
 	 * memory left on any of them.
 	 */
-	while (nodes_weight(physnode_mask)) {
+	while (!nodes_empty(physnode_mask)) {
 		for_each_node_mask(i, physnode_mask) {
 			u64 dma32_end = PFN_PHYS(MAX_DMA32_PFN);
 			u64 start, limit, end;
@@ -270,7 +270,7 @@ static int __init split_nodes_size_interleave_uniform(struct numa_meminfo *ei,
 	 * Fill physical nodes with fake nodes of size until there is no memory
 	 * left on any of them.
 	 */
-	while (nodes_weight(physnode_mask)) {
+	while (!nodes_empty(physnode_mask)) {
 		for_each_node_mask(i, physnode_mask) {
 			u64 dma32_end = PFN_PHYS(MAX_DMA32_PFN);
 			u64 start, limit, end;
-- 
2.30.2

