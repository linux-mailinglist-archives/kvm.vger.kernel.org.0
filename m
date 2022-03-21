Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F444E28A1
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 14:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348438AbiCUOAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 10:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349036AbiCUN6t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 09:58:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99D51777D9
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 06:57:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 430756125C
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 13:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3704C340ED;
        Mon, 21 Mar 2022 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647871027;
        bh=Y2NY1ZQCvMnl231B6PhrCLqSL6sBW0gAFyq6Xmbpnj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MeWasCHe2KUsKQKB2UUQ2x3q4YpR89JUP3967ZVV6JieOTfAmsx9yYP4EmfQGwyoP
         FT5SeNZK9JcHATKDn/SbrN7byT5Rk5quPAiX/YitqP4LlQjS+jBjDnFtznWhOSweWn
         9VWkOv3axYWY0Wq8Aslf0hV7z9Oiah8fzT9+sYg+05yNRtpzNDXQBB15NH3b+AYTrt
         sQcRUISUtGJOMniENgweHeZT6m31ksz4GrRHpvdFtu1OrAmszDfcB1P37Q2L0mhqp9
         Ji+3N00qjgE78gLz9oT4I3CUtk+IsicQjr6Ep1m175Bfq1d3r4caRzwiyPhmzqnTXr
         uXfsgwK1ucFUw==
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org, Oliver Upton <oupton@google.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        Dongli Si <sidongli1997@gmail.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kvmtool v2] Revert "kvm tools: Filter out CPU vendor string"
Date:   Mon, 21 Mar 2022 13:57:01 +0000
Message-Id: <164786994544.4051735.2440121532592863874.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220318204938.496840-1-oupton@google.com>
References: <20220318204938.496840-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 18 Mar 2022 20:49:38 +0000, Oliver Upton wrote:
> This reverts commit bc0b99a2a74047707db73ba057743febf458fd90.
> 
> Thanks to some digging from Andre [1], we know that kvmtool commit
> bc0b99a2a740 ("kvm tools: Filter out CPU vendor string") was intended
> to work around a guest kernel bug resulting from kernel commit
> 5bbc097d8904 ("x86, amd: Disable GartTlbWlkErr when BIOS forgets it").
> Critically, KVM does not implement the MC4 mask MSR and instead injects
> a #GP into the guest. On guest kernels without commit d47cc0db8fd6
> ("x86, amd: Use _safe() msr access for GartTlbWlk disable code") this is
> unexpected and causes a kernel oops.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] Revert "kvm tools: Filter out CPU vendor string"
      https://git.kernel.org/will/kvmtool/c/faae833a746f

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
