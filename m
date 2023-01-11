Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3944E66672B
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 00:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbjAKXcI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 18:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjAKXcF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 18:32:05 -0500
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BEF3590F;
        Wed, 11 Jan 2023 15:32:03 -0800 (PST)
Received: from ip5b412258.dynamic.kabel-deutschland.de ([91.65.34.88] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1pFkZb-0001Ac-W2; Thu, 12 Jan 2023 00:32:00 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jisheng Zhang <jszhang@kernel.org>
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 01/13] riscv: fix jal offsets in patched alternatives
Date:   Thu, 12 Jan 2023 00:31:59 +0100
Message-ID: <3268358.687JKscXgg@diego>
In-Reply-To: <20230111171027.2392-2-jszhang@kernel.org>
References: <20230111171027.2392-1-jszhang@kernel.org> <20230111171027.2392-2-jszhang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am Mittwoch, 11. Januar 2023, 18:10:15 CET schrieb Jisheng Zhang:
> Alternatives live in a different section, so offsets used by jal
> instruction will point to wrong locations after the patch got applied.
> 
> Similar to arm64, adjust the location to consider that offset.
> 
> Co-developed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Signed-off-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>

looks good, thanks for fixing the issues Andrew and Conor pointed
out in the variant in my zbb series. I've now switched over to this one.

I guess as you said, we really should separate this out into a single patch
[or if Palmer is fine with that, just pick this one patch to apply until the
rest is ready]


Heiko


