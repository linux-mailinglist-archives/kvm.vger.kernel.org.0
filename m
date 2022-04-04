Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDA04F1334
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 12:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357953AbiDDKhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 06:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348590AbiDDKhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 06:37:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178A332981
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 03:35:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E948D61519
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 10:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DE5C2BBE4;
        Mon,  4 Apr 2022 10:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649068502;
        bh=IYfJVOFc6UnmRHtdEA/ESevgVleFKYZsstulALh3II0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NB35NYkrbZtRQ1jwqkwo2zZpXR8UzlclafdMxEy833MnnG2Ae9+Bc9rcJYTgpzRGP
         1E4Tcb4l9n0pQJCtj0UkyHTow9jOkiceQnV8neKLpeabTXpxint29gDKzAmiGmdM6h
         6geetnboA52AJ93QWK/4NpiJWh65N7C/+EGaFA4nOF9OdpLt+5CQZaLqE060mq8jJH
         VPVnnG3i3JHfP+M16ckZpP7M1cB5JmL8JfniQyzEuOWqQ0fKhpY5xKTz3o4L3rL+o7
         AjmhczYOKmBFG7bh9hYu2v3YpkKoOTDLZxONvAojHMT1GDKvklS0EqQUG3VGTz8VQF
         xtuP1xkO+eB7g==
From:   Will Deacon <will@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        catalin.marinas@arm.com, kvm@vger.kernel.org,
        vladimir.murzin@arm.com, linux-arm-kernel@lists.infradead.org,
        julien.thierry.kdev@gmail.com, steven.price@arm.com
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>
Subject: Re: [kvmtool PATCH v3 0/2] arm64: Add MTE support
Date:   Mon,  4 Apr 2022 11:34:55 +0100
Message-Id: <164906755176.1613722.14442142721730095672.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220328103328.18768-1-alexandru.elisei@arm.com>
References: <20220328103328.18768-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Mar 2022 11:33:26 +0100, Alexandru Elisei wrote:
> Add Memory Tagging Extension (MTE) support in kvmtool.
> 
> Changes since v2:
> 
> * Gathered Reviewed-by and Tested-by tags from Vladimir, thank you!
> * Slight tweaks to the kvmtool debug and user messages.
> * Do not set kvm->arch.cfg.mte_disabled is the MTE capability is not
>   available. It is not used anywhere outside of the MTE setup function and
>   kvm->arch.cfg is for user config options.
> 
> [...]

Applied to arm64 (master), thanks!

[1/2] update_headers.sh: Sync ABI headers with Linux v5.17
      https://git.kernel.org/arm64/c/af1b793cb616
[2/2] aarch64: Add support for MTE
      https://git.kernel.org/arm64/c/5657dd3e48b4

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
