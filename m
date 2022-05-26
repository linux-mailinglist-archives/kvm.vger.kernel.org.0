Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C187B534C67
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 11:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343921AbiEZJRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 05:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiEZJRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 05:17:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F9FC6E4C
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 02:17:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA94661B9F
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 09:17:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49242C34118;
        Thu, 26 May 2022 09:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653556664;
        bh=x+lBBuqopDOuNZyM+ku5PFUpxXP459/dEt1EtMFdA/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmWpkyOqlaT3AOeKT57ufXOMyRRsfLnjauXQ6qDTW6Yc9HbMhwJf9Uwrzhzpxr8kC
         7dnc1B7uClVr8zofQMi+C0W73UuTrtSAM0LYMMAZ1oObG6Prbb3x78F2HfzJxZsUov
         btaU0/Ju/Tw/0ADV+mbKdb5KX3DIZRwJ2DebpsVsffeU3ewZSZhOBDqTqxtZ4K/w/X
         P1Y/Y6NKipu3lOWdamrRCmO4cdRakB+Au/6EwLf6SpKlt7cANy6R5CRbTa2N+DW1Kr
         LIxK6pvoEyg2esBcE9AXGmiV7jJWgT5H/CJNMiYXjX1XUh2W2pLtsPy0OuDD2eOuC1
         6GNOGbd+L9oqw==
From:   Will Deacon <will@kernel.org>
To:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andre Przywara <andre.przywara@arm.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, Keir Fraser <keirf@google.com>,
        kvmarm@lists.cs.columbia.edu,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool 0/4] Update virtio headers (to fix build)
Date:   Thu, 26 May 2022 10:17:34 +0100
Message-Id: <165355576397.3703094.17299737137964542053.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220524150611.523910-1-andre.przywara@arm.com>
References: <20220524150611.523910-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 May 2022 16:06:07 +0100, Andre Przywara wrote:
> Since we implement some virtio devices in kvmtool, we were including
> older copies of some virtio UAPI header files in our tree, but were
> relying on some other headers to be provided by the distribution.
> This leads to problems when we need to use newer virtio features (like
> the recent virtio_balloon stat update), which breaks compilation on some
> (older) distros.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/4] update virtio_mmio.h
      https://git.kernel.org/will/kvmtool/c/7e2209945bb5
[2/4] util: include virtio UAPI headers in sync
      https://git.kernel.org/will/kvmtool/c/393e2187cf68
[3/4] include: update virtio UAPI headers
      https://git.kernel.org/will/kvmtool/c/e5390783db61
[4/4] include: add new virtio uapi header files
      https://git.kernel.org/will/kvmtool/c/1a992bbaab08

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
