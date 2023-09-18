Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A25C7A47D4
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 13:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239849AbjIRLFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 07:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238345AbjIRLFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 07:05:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8F88F
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 04:05:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15A4C433C7;
        Mon, 18 Sep 2023 11:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695035142;
        bh=nW0F/jeLDs+j1BbOOAMNwLCvRYGq+1XknmLHE2Oerg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bb6QuCt9Yx6m9963C4h4SVwf+Ur+mBHhPMLSWTGG9YHTNfmkteo9rL0xVyBMbREyn
         VuhRGCQsKEHXp1ARnkaPeGjs/jDjAnWgpztpxvXbetKT+xwAuZbxow/TeRd7Iw6Vpb
         3JHU2sIv8fC/YsuDwpdQs8amCrb+M37yl49O9hdcLWDZx4Xtvo9rbfgyC6ayfm779t
         5jBJE1t0FqpGiF9GzivOzQ4klZ7DUSNYJMi+IwEyyHXGeS1ELxaVwXGY7iGLbmhvke
         4YVw4Ue+X/jgS7jW8r6Dv664Hg29LCyw8NlaUfn2bJfVi3XuAjcmdmwsWbEURtHaSq
         TdY2ROaHhN0hg==
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org, Tan En De <ende.tan@starfivetech.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com
Subject: Re: [kvmtool] pci: Deregister KVM_PCI_CFG_AREA on pci__exit
Date:   Mon, 18 Sep 2023 12:05:17 +0100
Message-Id: <169503433987.3759479.15076349640789065997.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230916052303.1003-1-ende.tan@starfivetech.com>
References: <20230916052303.1003-1-ende.tan@starfivetech.com>
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

On Sat, 16 Sep 2023 13:23:03 +0800, Tan En De wrote:
> KVM_PCI_CFG_AREA is registered with kvm__register_mmio during pci__init,
> but it isn't deregistered during pci__exit.
> 
> So, this commit is to kvm__deregister_mmio the KVM_PCI_CFG_AREA on pci__exit.
> 
> 

Applied to kvmtool (master), thanks!

[1/1] pci: Deregister KVM_PCI_CFG_AREA on pci__exit
      https://git.kernel.org/will/kvmtool/c/9cb1b46cb765

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
