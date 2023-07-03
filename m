Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410F2745511
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 07:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjGCFwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 01:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjGCFwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 01:52:42 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4B4B2
        for <kvm@vger.kernel.org>; Sun,  2 Jul 2023 22:52:40 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4QvZnz0lsnz4wqZ;
        Mon,  3 Jul 2023 15:52:39 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     linuxppc-dev@lists.ozlabs.org, Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm@vger.kernel.org
In-Reply-To: <20230608024504.58189-1-npiggin@gmail.com>
References: <20230608024504.58189-1-npiggin@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Update MAINTAINERS
Message-Id: <168836201882.50010.3420393910023246463.b4-ty@ellerman.id.au>
Date:   Mon, 03 Jul 2023 15:26:58 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 08 Jun 2023 12:45:04 +1000, Nicholas Piggin wrote:
> Michael is merging KVM PPC patches via the powerpc tree and KVM topic
> branches. He doesn't necessarily have time to be across all of KVM so
> is reluctant to call himself maintainer, but for the mechanics of how
> patches flow upstream, it is maintained and does make sense to have
> some contact people in MAINTAINERS.
> 
> So add Michael Ellerman as KVM PPC maintainer and myself as reviewer.
> Split out the subarchs that don't get so much attention.
> 
> [...]

Applied to powerpc/next.

[1/1] KVM: PPC: Update MAINTAINERS
      https://git.kernel.org/powerpc/c/7cc99ed87e4aeb3738e6ea7dc4d3ae28ad943601

cheers
