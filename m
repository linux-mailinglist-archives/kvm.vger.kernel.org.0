Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F1A52770B
	for <lists+kvm@lfdr.de>; Sun, 15 May 2022 12:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbiEOKfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 May 2022 06:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiEOKfc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 May 2022 06:35:32 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C722A279;
        Sun, 15 May 2022 03:35:31 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L1JgQ2lXhz4xZ0;
        Sun, 15 May 2022 20:35:30 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Matt Evans <matt@ozlabs.org>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <20220510123717.24508-1-graf@amazon.com>
References: <20220510123717.24508-1-graf@amazon.com>
Subject: Re: [PATCH v3] KVM: PPC: Book3S PR: Enable MSR_DR for switch_mmu_context()
Message-Id: <165261089230.1048761.8692230745966082398.b4-ty@ellerman.id.au>
Date:   Sun, 15 May 2022 20:34:52 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 May 2022 14:37:17 +0200, Alexander Graf wrote:
> Commit 863771a28e27 ("powerpc/32s: Convert switch_mmu_context() to C")
> moved the switch_mmu_context() to C. While in principle a good idea, it
> meant that the function now uses the stack. The stack is not accessible
> from real mode though.
> 
> So to keep calling the function, let's turn on MSR_DR while we call it.
> That way, all pointer references to the stack are handled virtually.
> 
> [...]

Applied to powerpc/fixes.

[1/1] KVM: PPC: Book3S PR: Enable MSR_DR for switch_mmu_context()
      https://git.kernel.org/powerpc/c/ee8348496c77e3737d0a6cda307a521f2cff954f

cheers
