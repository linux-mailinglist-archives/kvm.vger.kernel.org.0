Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A52CB79A1
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 14:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388228AbfISMji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 08:39:38 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33171 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387968AbfISMji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 08:39:38 -0400
Received: by mail-wr1-f65.google.com with SMTP id b9so2980864wrs.0
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 05:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=/9nzlO3catDpxNdlSs/iGbOfKBBKO21YP3lcrEeeoEQ=;
        b=fVAVkCOq71OXtZ7J4EkZQGbxKZNZc4L2c8WJZFECgaG3XjO3lNrIVHVYVh9IMMO4ZA
         AEMbIHHCpAmXbRHlDLww47nqyk/M6i4cvDy2bdZBbYNq1s5u4q00FU+zNh0S2Yp1nA4n
         SvkzakdSSmj8vYi6Ar6il9zvKCLbJwaDHnshr78mjr3P0x17Z3CufbcLB/mZSwXDj5EH
         /WplZOw3NE8LiOTVDf9UUFR/qqmcmWBsXas8QqUU6xk9S92tLgHQizN88RYDhuMS65aT
         U2bmsscollEChMPqNqFdZhT/EgQWz1m084k/kjn+s2p5SWl+QjVtuJHXpfpNQYdksxaA
         DOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=/9nzlO3catDpxNdlSs/iGbOfKBBKO21YP3lcrEeeoEQ=;
        b=Y1ZqLwhrhe2ZxIBkxtIMlktG/LS+mHYJxM98Xi59auhf8DuLIQr796yUIEhqtKCAvp
         3HqMXPxg94eO/FGwduBlYVhLXcZ4Efbq3fAiRWhKK9Uc73oqOpGNlaD+btsVpVjHkTfq
         mDAD7wTUDCO2va7TigCrBwVD7cPTXVmKZmxcHk6649zn+HChaYaPCYLzhF+p4kho5uvN
         eEbyPjM8yxpz5c1bJqaqjsTC8tcaFGCoT0QiW4w/irS5jOrKySdeUp3i1OGP+bplemv0
         wNudHUgBsj/y2VaytoIZzpu7gBv1ME9Qs8cFNAmlG9tidJlAs9FYiuGWpydKk4P1vXh8
         d/RQ==
X-Gm-Message-State: APjAAAUjBo5+CBbT46q06owSfQzisRhBqjY7UXst3mocWohZlKLlGU8i
        qquii9alvCsBMs9vAS72qo0Q8w==
X-Google-Smtp-Source: APXvYqyLGBWany8mv0R6G9JKWZdXIcvLmproKvbB56WPUT5EotusdST4NAJsi4Wf0JYw0isKvhYwOg==
X-Received: by 2002:adf:db06:: with SMTP id s6mr4131222wri.41.1568896775939;
        Thu, 19 Sep 2019 05:39:35 -0700 (PDT)
Received: from localhost ([109.190.253.11])
        by smtp.gmail.com with ESMTPSA id d193sm8966640wmd.0.2019.09.19.05.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 05:39:35 -0700 (PDT)
Date:   Thu, 19 Sep 2019 05:39:33 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Anup Patel <Anup.Patel@wdc.com>
cc:     Palmer Dabbelt <palmer@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 03/21] RISC-V: Export few kernel symbols
In-Reply-To: <20190904161245.111924-5-anup.patel@wdc.com>
Message-ID: <alpine.DEB.2.21.9999.1909190537410.12151@viisi.sifive.com>
References: <20190904161245.111924-1-anup.patel@wdc.com> <20190904161245.111924-5-anup.patel@wdc.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 4 Sep 2019, Anup Patel wrote:

> From: Atish Patra <atish.patra@wdc.com>
> 
> Export few symbols used by kvm module. Without this, kvm cannot
> be compiled as a module.
> 
> Signed-off-by: Atish Patra <atish.patra@wdc.com>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Alexander Graf <graf@amazon.com>

Thanks, have updated this patch to apply and to clarify the patch title 
and have queued the following for v5.4-rc.


- Paul

From: Atish Patra <atish.patra@wdc.com>
Date: Wed, 4 Sep 2019 16:14:06 +0000
Subject: [PATCH] RISC-V: Export kernel symbols for kvm

Export few symbols used by kvm module. Without this, kvm cannot
be compiled as a module.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
[paul.walmsley@sifive.com: updated to apply; clarified short patch 
 description]
Signed-off-by: Paul Walmsley <paul.walmsley@sifive.com>
---
 arch/riscv/kernel/smp.c  | 1 +
 arch/riscv/kernel/time.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/riscv/kernel/smp.c b/arch/riscv/kernel/smp.c
index d70e3c0ee983..f849a2480600 100644
--- a/arch/riscv/kernel/smp.c
+++ b/arch/riscv/kernel/smp.c
@@ -210,3 +210,4 @@ void smp_send_reschedule(int cpu)
 {
 	send_ipi_single(cpu, IPI_RESCHEDULE);
 }
+EXPORT_SYMBOL_GPL(smp_send_reschedule);
diff --git a/arch/riscv/kernel/time.c b/arch/riscv/kernel/time.c
index 517d2153a933..8a25d1e440ca 100644
--- a/arch/riscv/kernel/time.c
+++ b/arch/riscv/kernel/time.c
@@ -9,6 +9,7 @@
 #include <asm/processor.h>
 
 unsigned long riscv_timebase;
+EXPORT_SYMBOL_GPL(riscv_timebase);
 
 void __init time_init(void)
 {
-- 
2.23.0

