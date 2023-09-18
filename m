Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F27A7A47CD
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 13:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbjIRLFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 07:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237590AbjIRLFg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 07:05:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7CE8F
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 04:05:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99572C433C7;
        Mon, 18 Sep 2023 11:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695035130;
        bh=wC7QnFLvCqU8DsHm5B4yuOBZaQeAGaIgKbEwgAUZiSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gD2vsMJ1bJvnPFq93NWl5TCMjL+stqIaMJxJtFZNN4AS6DBEQHjIMYLt6yP4dAVWH
         qI5aa+RpaGdN6Ldi2uw8AhafuAFFdl6cm5V4BH4tSQv1bgWVSImWi/NsAvcaBtIX1K
         cVklO6JE9u/xQCu+qRiabtpVH86SEOgXffoOU1/i8zJxPK/rxPSyn754PHtslPMUED
         A5mgLRN7wBAsareOE4lmNaVS+gZWnEqXC/0HhT6wXM/hAqrlCfHUWPaCPzl6EdY4Qb
         7E+PZcKIRxzGE5AEOrrZMT17mwxa/Bcc2METS76+q6ENSXCA6C901QaVyD2ODYC6bn
         g4E4Jm4LpUC+w==
From:   Will Deacon <will@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>, maz@kernel.org,
        andre.przywara@arm.com, jean-philippe.brucker@arm.com,
        suzuki.poulose@arm.com, kvm@vger.kernel.org,
        julien.thierry.kdev@gmail.com, apatel@ventanamicro.com,
        oliver.upton@linux.dev
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH kvmtool 0/3] Change what --nodefaults does and a revert
Date:   Mon, 18 Sep 2023 12:05:14 +0100
Message-Id: <169503375704.3755487.15995711453259792866.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230907171655.6996-1-alexandru.elisei@arm.com>
References: <20230907171655.6996-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 7 Sep 2023 18:16:52 +0100, Alexandru Elisei wrote:
> The first two patches revert "virtio-net: Don't print the compat warning
> for the default device" because using --network mode=none disables the
> device and lets the user know that it can use that to disable the default
> virtio-net device. I don't think the changes are controversial.
> 
> And the last patch is there to get the conversation going about changing
> what --nodefaults does. Details in the patch.
> 
> [...]

Applied first two to kvmtool (master), thanks!

[1/3] Revert "virtio-net: Don't print the compat warning for the default device"
      https://git.kernel.org/will/kvmtool/c/4498eb7400c6
[2/3] builtin-run: Document mode=none for -n/--network
      https://git.kernel.org/will/kvmtool/c/c7b7a542cdcd

I'm also not sure about the final RFC patch:

[3/3] builtin-run: Have --nodefaults disable the default virtio-net device

so it would be great to hear if anybody else has an opinion on that. IIRC,
we introduced this for some EFI work, so perhaps those folks might have
an opinion?

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
