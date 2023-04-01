Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B346D34D7
	for <lists+kvm@lfdr.de>; Sun,  2 Apr 2023 00:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjDAWVY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 1 Apr 2023 18:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDAWVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 18:21:23 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03DE12845
        for <kvm@vger.kernel.org>; Sat,  1 Apr 2023 15:21:20 -0700 (PDT)
Received: from ip4d1634d3.dynamic.kabel-deutschland.de ([77.22.52.211] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1pijay-0004qt-Lt; Sun, 02 Apr 2023 00:21:12 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Andy Chiu <andy.chiu@sifive.com>
Subject: Re: [PATCH -next v17 12/20] riscv: signal: check fp-reserved words
 unconditionally
Date:   Sun, 02 Apr 2023 00:21:11 +0200
Message-ID: <5898720.alqRGMn8q6@diego>
In-Reply-To: <20230327164941.20491-13-andy.chiu@sifive.com>
References: <20230327164941.20491-1-andy.chiu@sifive.com>
 <20230327164941.20491-13-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_PASS,T_SPF_HELO_TEMPERROR
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am Montag, 27. März 2023, 18:49:32 CEST schrieb Andy Chiu:
> In order to let kernel/user locate and identify an extension context on
> the existing sigframe, we are going to utilize reserved space of fp and
> encode the information there. And since the sigcontext has already
> preserved a space for fp context w or w/o CONFIG_FPU, we move those
> reserved words checking/setting routine back into generic code.
> 
> This commit also undone an additional logical change carried by the
> refactor commit 007f5c3589578
> ("Refactor FPU code in signal setup/return procedures"). Originally we
> did not restore fp context if restoring of gpr have failed. And it was
> fine on the other side. In such way the kernel could keep the regfiles
> intact, and potentially react at the failing point of restore.
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>

Acked-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>



