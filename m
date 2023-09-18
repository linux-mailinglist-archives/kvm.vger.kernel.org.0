Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42A57A47D6
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 13:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241193AbjIRLF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 07:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238383AbjIRLFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 07:05:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C548F
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 04:05:44 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88832C433C9;
        Mon, 18 Sep 2023 11:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695035144;
        bh=NWcIkVKXQuz0dy4PV+dpQU+akpyxJPdtdJuXOsRrbOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TsDOlHK3hMkODLICVQuy14QnFtwod4XycabkjydXYNKpVGlk3XzvMTzioi2OnRDq5
         FPt2RRZ91shk5ASJEpAGiUm/AdnLl3sjPXqNxfvU0djum3z6BF77AuKiI1TljT2Da6
         BN3Oy5S16FrUI5dsJ3EGc0T4bLc88wm30h6vo+6gSpUOErFOIjag+5WuBTBgQ29gCS
         AinKClTr0iQMM5Wr2rmskhPaCe8OmpKeduE4tEdN3dRbUUhhEKpL5Fp7GQHFcnnZzV
         BH3eFntpm9n1Z5Mcagn46VeQVQxZNjDUakS62F4I/+94z9JAwHjkdQyIkw5uuVlBoQ
         2aONjgEfWGANg==
From:   Will Deacon <will@kernel.org>
To:     Keir Fraser <keirf@google.com>, kvm@vger.kernel.org
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH 0/3] Fixes for virtio PCI interrupt handling
Date:   Mon, 18 Sep 2023 12:05:18 +0100
Message-Id: <169503422822.3759341.13505105033585274249.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230912151623.2558794-1-keirf@google.com>
References: <20230912151623.2558794-1-keirf@google.com>
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

On Tue, 12 Sep 2023 15:16:20 +0000, Keir Fraser wrote:
> Please consider these simple fixes and cleanups to legacy interrupt
> handling for virtio PCI devices.
> 
> Keir Fraser (3):
>   virtio/pci: Level-trigger the legacy IRQ line in all cases
>   virtio/pci: Treat PCI ISR as a set of bit flags
>   virtio/pci: Use consistent naming for the PCI ISR bit flags
> 
> [...]

Applied to kvmtool (master), thanks!

[1/3] virtio/pci: Level-trigger the legacy IRQ line in all cases
      https://git.kernel.org/will/kvmtool/c/353fa0d89e29
[2/3] virtio/pci: Treat PCI ISR as a set of bit flags
      https://git.kernel.org/will/kvmtool/c/292144845000
[3/3] virtio/pci: Use consistent naming for the PCI ISR bit flags
      https://git.kernel.org/will/kvmtool/c/d560235f4556

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
