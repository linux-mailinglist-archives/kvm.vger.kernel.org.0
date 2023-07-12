Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5206750E34
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbjGLQTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233076AbjGLQRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:17:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380D32139
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:17:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3006361865
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 16:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D456C433BA;
        Wed, 12 Jul 2023 16:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689178629;
        bh=qLzLge7LAAAhtS3dJV+SMyom1XFhapzYDtdMcrRpKSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A8atNcscLEUy12nsV38M8vwZCRWO6I1ak+8AOai7Cn9PRYMkss0zHiEijA+7qbmpX
         5WBlr1G0uzsI8d67aSkf69FdmQjIlOWEcQbSKvrIV9oxn0QstFwvq8Ni19L5G567Db
         gu+ZU2oT+OS5Re63KeE9RjNt689DLuPg0TT/PpkUmqx0yI9Xr4Wmc5h64gz4AdDYaX
         axC+ifYiFkT/6JJQ1wgumhapdTceBNb8iH9YYFWQWb1bxRLl27W4SEIunzs/exHFgx
         f6heGU0iFjAdaFfBRFFtlM3tHsXWKQ8aJr8n8PrAT4cfCT6IWje5ZP2+GFqvLJ5b2w
         K7Ln4fiDHsDqA==
From:   Will Deacon <will@kernel.org>
To:     apatel@ventanamicro.com, kvm@vger.kernel.org,
        andre.przywara@arm.com, julien.thierry.kdev@gmail.com,
        maz@kernel.org, Suzuki.Poulose@arm.com,
        jean-philippe.brucker@arm.com, oliver.upton@linux.dev,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH kvmtool v2 0/4] Add --loglevel argument
Date:   Wed, 12 Jul 2023 17:17:03 +0100
Message-Id: <168917831680.84384.10237636989345178047.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230707151119.81208-1-alexandru.elisei@arm.com>
References: <20230707151119.81208-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 7 Jul 2023 16:11:15 +0100, Alexandru Elisei wrote:
> kvmtool can be unnecessarily verbose at times, and Will proposed in a chat
> we had a while ago to add a --loglevel command line argument to choose
> which type of messages to silence. This is me taking a stab at it.
> 
> Build tested for all arches and run tested lightly on a rockpro64 and my
> x86 machine.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/4] util: Make pr_err() return void
      https://git.kernel.org/will/kvmtool/c/2cc4929cc6b9
[2/4] Replace printf/fprintf with pr_* macros
      https://git.kernel.org/will/kvmtool/c/72e13944777a
[3/4] util: Use __pr_debug() instead of pr_info() to print debug messages
      https://git.kernel.org/will/kvmtool/c/fc184a682a21
[4/4] Add --loglevel argument for the run command
      https://git.kernel.org/will/kvmtool/c/bd4ba57156da

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
