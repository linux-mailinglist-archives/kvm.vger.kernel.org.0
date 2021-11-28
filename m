Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7214603B9
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 05:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352564AbhK1EDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Nov 2021 23:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346786AbhK1EBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Nov 2021 23:01:23 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9ECDC061763;
        Sat, 27 Nov 2021 19:57:22 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id a11so19016455qkh.13;
        Sat, 27 Nov 2021 19:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hB7XWgK7LBArYWsovgo0hsN0mrEB+cbVCvcU6LAXOLQ=;
        b=bkO3RJSSz1q8yvgEs+aBx5zXdnHBh9vFE6t8K7gDrhv51/j08hfhIkoHZaR/hn0oT/
         R5HW1Le+kJ7J5+j08nxMmOUbGwurX3jUtdCYh4qnp093YPNTDx3I2obkRNvgb1w4e6pj
         20cOR+h9Hj8GDzSc89ENg7eJfWrZuKRaBeX9GAKduwkkEgkAkB7qN396A8vk8b/gpptx
         lWvzTq98DWDhCaiZGFj4lz8We1hTY+eK3ZvJ8DsZ97WxcyB1Qm6Iy+DeJcwlAc16vl5d
         v0TmwDCWDRdqoBv9V5pT7/kRMNKnADy/OKnNxEaVc6tfFvf0HsopsZA5YMI6DSLZ3NwQ
         BUew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hB7XWgK7LBArYWsovgo0hsN0mrEB+cbVCvcU6LAXOLQ=;
        b=UHAf+7w0QX6tqoF4AxXsOciPYgSpbfNPuBflijlyAajK6xYytvngPMp2fd7rsoQzW4
         e4VHAM8z5ncWQN8dAtEL3UjeSExEjSRX/QrzaWSpZtkiLpMnLhT6GzfcoE+bprNpxc14
         Pa42a9/dc//Kdbv8IeRl7+5l1/nl76wJiVJ/T2MSNi39SArI4zkae7bszZiK1E0xgzA2
         rniShnyS/oeSyb/BuhCNc/9A6+wH4nSVWhJTVB/Qber2Z+nfawGpllVcCTM1liQSkr0e
         FyGPZ3Kyc6DxMu2Rb8pfURS6EL4HkgLWpeztuFe/zstkQSTWUPFYqvsZan/+qLsFa/3y
         8/nA==
X-Gm-Message-State: AOAM532oGNGmwZKhrShKWtadTlOdRp26bEUCstN38YZB8PDPsg3KoTVi
        jdf6vlSpQSmOMGIDGkfmsbzk9hPkZ8B1xA==
X-Google-Smtp-Source: ABdhPJyFEyV7d/B7VRKVyGGE2Y5zpuLAq61KyIGr2PtJ6cIeT64BguOqkxtxJnawWvNd51HKw7WvIQ==
X-Received: by 2002:a05:620a:1713:: with SMTP id az19mr31179988qkb.297.1638071841520;
        Sat, 27 Nov 2021 19:57:21 -0800 (PST)
Received: from localhost ([66.216.211.25])
        by smtp.gmail.com with ESMTPSA id c11sm6161985qtb.8.2021.11.27.19.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 19:57:21 -0800 (PST)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
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
        David Laight <David.Laight@ACULAB.COM>,
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
Subject: [PATCH 8/9] lib/nodemask: add num_node_state_eq()
Date:   Sat, 27 Nov 2021 19:57:03 -0800
Message-Id: <20211128035704.270739-9-yury.norov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211128035704.270739-1-yury.norov@gmail.com>
References: <20211128035704.270739-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add num_node_state_eq() and replace num_node_state() with it in
page_alloc_init().

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 include/linux/nodemask.h | 5 +++++
 mm/page_alloc.c          | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 3801ec5b06f4..b68ee2a80164 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -455,6 +455,11 @@ static inline int num_node_state(enum node_states state)
 	return nodes_weight(node_states[state]);
 }
 
+static inline int num_node_state_eq(enum node_states state, unsigned int num)
+{
+	return nodes_weight_eq(node_states[state], num);
+}
+
 #define for_each_node_state(__node, __state) \
 	for_each_node_mask((__node), node_states[__state])
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 91c1105a9efe..81d111155ffb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8323,7 +8323,7 @@ void __init page_alloc_init(void)
 	int ret;
 
 #ifdef CONFIG_NUMA
-	if (num_node_state(N_MEMORY) == 1)
+	if (num_node_state_eq(N_MEMORY, 1))
 		hashdist = 0;
 #endif
 
-- 
2.25.1

