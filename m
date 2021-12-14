Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD860474638
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 16:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbhLNPSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 10:18:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45702 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbhLNPS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 10:18:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 210D26156F
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 15:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23B2C34601;
        Tue, 14 Dec 2021 15:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639495108;
        bh=EheSDqC3FtmG12jUqvkeLKuuf7chv9JbJw5/t8miYYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhOc+qNBB3PcX8Uw6HgFn4cya+Y68hJp3SZtSh7NnxT/AFI/G7dIJCIDNfP/dsVVG
         Fs0iCHINYGPeFsidL/TNsOalKN99bOi+kpE0iWD15qLx2b1hjoMRdG2MWzX7DjRvoy
         zhquxKKEcfGSDp7VLPuB+JnA51O3LbsYmKwsi8AxiS7ZYfoPvDTLcMMBcdsn6Vuqbf
         mLS2sfUWznlF6TxKMMD9u/Y5YlkJRTKedZKSmXn7Gp3h6nQIgv1Nr9LfteUHWEU8QM
         B50ff54l5vfHgR3su5iTBuZCZ7bENlqSWWzVRO9dNiAK7TtQ9RXOfDzPYEWiWkyIxr
         UIRd4Uk1YBEhg==
From:   Will Deacon <will@kernel.org>
To:     "haibiao.xiao" <haibiao.xiao@zstack.io>, kvm@vger.kernel.org
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        "haibiao.xiao" <xiaohaibiao331@outlook.com>,
        alexandru.elisei@arm.com, julien.thierry.kdev@gmail.com
Subject: Re: [PATCH v2 kvmtool] Makefile: Calculate the correct kvmtool version
Date:   Tue, 14 Dec 2021 15:18:12 +0000
Message-Id: <163949408693.4012464.3950088981610014340.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211210030708.288066-1-haibiao.xiao@zstack.io>
References: <20211210030708.288066-1-haibiao.xiao@zstack.io>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Dec 2021 11:07:08 +0800, haibiao.xiao wrote:
> From: "haibiao.xiao" <xiaohaibiao331@outlook.com>
> 
> Command 'lvm version' works incorrect.
> It is expected to print:
> 
>     # ./lvm version
>     # kvm tool [KVMTOOLS_VERSION]
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] Makefile: Calculate the correct kvmtool version
      https://git.kernel.org/will/kvmtool/c/642f35bfe8d9

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
