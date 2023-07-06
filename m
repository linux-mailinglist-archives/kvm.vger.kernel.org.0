Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4176E749F21
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 16:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbjGFOg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 10:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjGFOg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 10:36:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6431FED
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 07:36:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF7B061701
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 14:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F48C433C8;
        Thu,  6 Jul 2023 14:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688654215;
        bh=3RKDpBASOqh+x41gCv91KrT3cdn9wKgFxlufLqzEHOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOU/s1kPpSlu60WSRtFYQYByhYR0N1kh1rcrkNrK0qQ706RJpM88EOboegpME1yiw
         88FfCM6it/iRlA3aRs+YeH7ifVTD3CuxbHqLeKtOQf/40Pa5D5dpS20kSruhf4p3oh
         RKh9l8L9AdQPuxmolXknqA+u+CF/OnIKoKHhQzdfR0aSDK/zMv4N8zoaWxSqlzQ6H1
         UFzhCrw1yZdX8SqYPb1ypjxAfRHIhFoC9kN7nDQWFm6uGUDuODCC5vX0RbzEGU1R8U
         +Yjst3o7ci9rCILRHMzgNUdmJvXoJP6zW6P/lK7CVg0re1m/kuyLKBgvAEFyu2kOhV
         QFRUwYUBD+F8Q==
From:   Will Deacon <will@kernel.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        kvm@vger.kernel.org
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, vivek.gautam@arm.com
Subject: Re: [PATCH kvmtool 0/2] vfio/pci: Fix unmaskable MSI
Date:   Thu,  6 Jul 2023 15:36:50 +0100
Message-Id: <168865388296.2038598.666448286855748813.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230628112331.453904-2-jean-philippe@linaro.org>
References: <20230628112331.453904-2-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Jun 2023 12:23:30 +0100, Jean-Philippe Brucker wrote:
> Patch 1 fixes an issue reported by Vivek, when assigning a device that
> supports classic MSI without maskable vectors.
> 
> Patch 2 adds some comments and renames the states, because the MSI code
> is difficult to understand. I haven't found a way to simplify it but
> this should at least help people debug it.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/2] vfio/pci: Initialize MSI vectors unmasked
      https://git.kernel.org/will/kvmtool/c/3a36d3410e99
[2/2] vfio/pci: Clarify the MSI states
      https://git.kernel.org/will/kvmtool/c/0b5e55fc032d

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
