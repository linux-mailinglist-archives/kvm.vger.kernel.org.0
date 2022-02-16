Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F004B8D79
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 17:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbiBPQLo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 11:11:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiBPQLm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 11:11:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2184615A08
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 08:11:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B145861AA6
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 16:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5870EC004E1;
        Wed, 16 Feb 2022 16:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645027888;
        bh=T55G/11Y1oiYmF+1j/uPL7cCs5GJVxmzOFnwXcSCwxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FnR12cvKX97Jqj0O2e87vd18jVujAjsE8oswjwBnnbJsx9nEPusSxE3lLp1ySYp5s
         FPovzwJqGyPsOLxPx3broUxLD48exc3AoBCMjG08p1BateqRIYNAapOGGyv1jwc0a1
         X2T41saN8Sw2kIAaq4y66uNCE3gaLwJndDRWRYlOzLly2Qxon+bjAmFJimJiBWZwJ6
         Kr7Ue+tW/K6dq0UOKVoilw4MOp9KGtGO0KlHn9HM5oFhIbjmU64ujFoy9xVoz9aICR
         AEgM505brdL84b1rdh/i95Kdb1M+iD4ZCyCor6msN560UdBE/ofaxfrMef6bduRQNv
         pgN/og9TTgsrw==
From:   Will Deacon <will@kernel.org>
To:     andre.przywara@arm.com,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        pierre.gondois@arm.com, kvmarm@lists.cs.columbia.edu,
        julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH kvmtool 0/3] Misc fixes
Date:   Wed, 16 Feb 2022 16:11:19 +0000
Message-Id: <164502718020.1969392.9699126746620631658.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220214165830.69207-1-alexandru.elisei@arm.com>
References: <20220214165830.69207-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Feb 2022 16:58:27 +0000, Alexandru Elisei wrote:
> These are a handful of small fixes for random stuff which I found while
> using kvmtool.
> 
> Patch #1 is actually needed to use kvmtool as a test runner for
> kvm-unit-tests (more detailed explanation in the commit message).
> 
> Patch #2 is more like a quality of life improvement for users.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/3] Remove initrd magic check
      https://git.kernel.org/will/kvmtool/c/9b681b0827d7
[2/3] arm: Use pr_debug() to print memory layout when loading a firmware image
      https://git.kernel.org/will/kvmtool/c/c334a68e202e
[3/3] arm: pci: Generate "msi-parent" property only with a MSI controller
      https://git.kernel.org/will/kvmtool/c/95f47968a1d3

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
