Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C366D1EE5
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 13:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjCaLUK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 31 Mar 2023 07:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbjCaLUJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 07:20:09 -0400
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1AE1BF75
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 04:20:06 -0700 (PDT)
Received: from ip4d1634d3.dynamic.kabel-deutschland.de ([77.22.52.211] helo=diego.localnet)
        by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <heiko@sntech.de>)
        id 1piCnM-0003EW-O3; Fri, 31 Mar 2023 13:19:48 +0200
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>, guoren@linux.alibaba.com,
        Jisheng Zhang <jszhang@kernel.org>,
        Nick Knight <nick.knight@sifive.com>,
        Peter Zijlstra <peterz@infradead.org>, vineetg@rivosinc.com,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Ruinland Tsai <ruinland.tsai@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        greentime.hu@sifive.com, Dmitry Vyukov <dvyukov@google.com>,
        Andy Chiu <andy.chiu@sifive.com>
Subject: Re: [PATCH -next v17 09/20] riscv: Add task switch support for vector
Date:   Fri, 31 Mar 2023 13:19:47 +0200
Message-ID: <3155083.5fSG56mABF@diego>
In-Reply-To: <20230327164941.20491-10-andy.chiu@sifive.com>
References: <20230327164941.20491-1-andy.chiu@sifive.com>
 <20230327164941.20491-10-andy.chiu@sifive.com>
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

Am Montag, 27. März 2023, 18:49:29 CEST schrieb Andy Chiu:
> From: Greentime Hu <greentime.hu@sifive.com>
> 
> This patch adds task switch support for vector. It also supports all
> lengths of vlen.
> 
> Suggested-by: Andrew Waterman <andrew@sifive.com>
> Co-developed-by: Nick Knight <nick.knight@sifive.com>
> Signed-off-by: Nick Knight <nick.knight@sifive.com>
> Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
> Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
> Co-developed-by: Ruinland Tsai <ruinland.tsai@sifive.com>
> Signed-off-by: Ruinland Tsai <ruinland.tsai@sifive.com>
> Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> Signed-off-by: Vineet Gupta <vineetg@rivosinc.com>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Björn Töpel <bjorn@rivosinc.com>

Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>


