Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36EA352F4A8
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 22:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353586AbiETUvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 16:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353579AbiETUvQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 16:51:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41DA1573E
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 13:51:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5030361C4A
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 20:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED8EC385A9;
        Fri, 20 May 2022 20:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653079873;
        bh=vzfP5yKHAKGGO4SQbbDw042GF3D19OfncNeFMhfZNX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sGGM8ddQW4MqkKILojs72iUFeHZk/gOX7GrE0U7oq6r00Nm5fmn8cnsJZmCho2eLX
         KAbZ45x5Hftok7v5EGJBpiv2mIAdCuhQnu9mCAPMZTGjnQAPa69d+846UOtAK8uE+5
         9lx8gOwafJikkOieyHVFc/YEWA+uOk32FmGJxbB5Empg4IBPJ917OZYpCIwVmCbqS7
         ED9DG9FHFZNl1qoCDRJWnObLt3+6k+jFgcx3+Ojmk3amOyq/NLzSr3Dw3JoMkKF51h
         xa8NcAfQ73193BhJoxZiNN59wcyrcqqMnw6bp1S4oSD8wPU6w7LZ3WGPWDlsq9FKsx
         /sSkVAInO/ovw==
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org, Keir Fraser <keirf@google.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH kvmtool 0/2] Fixes for virtio_balloon stats printing
Date:   Fri, 20 May 2022 21:51:07 +0100
Message-Id: <165307799681.1660071.7738890533857118660.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220520143706.550169-1-keirf@google.com>
References: <20220520143706.550169-1-keirf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 May 2022 14:37:04 +0000, Keir Fraser wrote:
> While playing with kvmtool's virtio_balloon device I found a couple of
> niggling issues with the printing of memory stats. Please consider
> these fairly trivial fixes.
> 
> Keir Fraser (2):
>   virtio/balloon: Fix a crash when collecting stats
>   stat: Add descriptions for new virtio_balloon stat types
> 
> [...]

Applied to kvmtool (master), thanks!

[1/2] virtio/balloon: Fix a crash when collecting stats
      https://git.kernel.org/will/kvmtool/c/3a13530ae99a
[2/2] stat: Add descriptions for new virtio_balloon stat types
      https://git.kernel.org/will/kvmtool/c/bc77bf49df6e

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
