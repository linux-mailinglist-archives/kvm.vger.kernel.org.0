Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422C5534C68
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 11:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345567AbiEZJRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 05:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiEZJRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 05:17:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EA6C6E50
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 02:17:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC6CE61B9C
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 09:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF46C34116;
        Thu, 26 May 2022 09:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653556666;
        bh=dWD+fwKtrKR5z8CZ2KODKvXcnmCFqzgsu2dUtUZMLv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBjy8V7knc4KUI8ojwX1AQf9eRGdRotaUMsw/SUvO6DChcbxpjKsB3Qw/jsmeHK6m
         XOfE8aRBG/Gqm3Asz8Phfkpw7U/p+NNdUYimaL4Wp1+lGvSmWah4NS/I5XIPAd8k3R
         75gt2RcYOM4TBv5wMNC7qE+ZGR3ZYe0p4/eECV6hu9p2sbsgzM91RFsP4zS0sdav3n
         CBaeTNmAy+W56tJXnoVc0Keq61glemVfTXBEyUkIjF03EmepY6JVSpThbHVVNgUCFX
         csqxvYAuEktWXU2iJfj/nX9Xyr6Ke7Rb2xrpzXYUJvDGSKdXtodMvaRIODpRaM2Ctv
         TX2aFLfgOlmHA==
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org, Dao Lu <daolu@rivosinc.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kvm-riscv@lists.infradead.org, apatel@ventanamicro.com
Subject: Re: [PATCH kvmtool v2] Fixes: 0febaae00bb6 ("Add asm/kernel.h for riscv")
Date:   Thu, 26 May 2022 10:17:35 +0100
Message-Id: <165355598165.3705180.69056897352417098.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220524180030.1848992-1-daolu@rivosinc.com>
References: <20220524180030.1848992-1-daolu@rivosinc.com>
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

On Tue, 24 May 2022 11:00:30 -0700, Dao Lu wrote:
> Fixes the following compilation issue:
> 
> include/linux/kernel.h:5:10: fatal error: asm/kernel.h: No such file
> or directory
>     5 | #include "asm/kernel.h"
> 
> 
> [...]

Applied to kvmtool (master), thanks!

[1/1] Fixes: 0febaae00bb6 ("Add asm/kernel.h for riscv")
      https://git.kernel.org/will/kvmtool/c/b4531b2c4d3f

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
