Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42EFC728A60
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 23:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbjFHVqJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 17:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjFHVqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 17:46:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBD72D6A
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 14:46:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 395B7611DF
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 21:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E148C433EF;
        Thu,  8 Jun 2023 21:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686260765;
        bh=Hi9ZvnoJXiqKsnwCeV6pxi3rwNjbtka3iW+r3tfA1/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9iqPcgPRHDSoBs+e4HbGKHUKMOUk1RIOXPe/ZkDGV5IkoduuFIcRRUpLuUgRJlDW
         sIocwZiHwKjro04Dx6V6qqctyN9YwUS83itpW4SaN72b63i1BTusrELYGtwGZOtjnh
         TJcpLPsv+r0emaaEZM4K+qmiIT82fzcxR8sRvDZO/aKCUE8RgqGnZRm4jMbnXzzOL8
         aA41SHpQ/p/OK4BWRAgXW0+vdhztfkcy7BGnrmDh1w0uMmrWRbNlvNmHShVQHiEbuf
         pQ9RjD2Z0mIEev91AVefK5FTQU3ThDxAHx2i756oCmzvC4Q1gLNLxBqgXtg/QVT1UU
         WiX9m3qcqI7WA==
From:   Will Deacon <will@kernel.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        kvm@vger.kernel.org
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH kvmtool 0/3] Build fixes
Date:   Thu,  8 Jun 2023 22:45:55 +0100
Message-Id: <168626031848.2990090.2068931143244870829.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230606143733.994679-1-jean-philippe@linaro.org>
References: <20230606143733.994679-1-jean-philippe@linaro.org>
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

On Tue, 6 Jun 2023 15:37:33 +0100, Jean-Philippe Brucker wrote:
> A few build fixes for kvmtool. They apply independently from the vhost
> fixes series I sent today.
> 
> Jean-Philippe Brucker (3):
>   Makefile: Refine -s handling in the make parameters
>   arm/kvm-cpu: Fix new build warning
>   virtio/rng: Fix build warning from min()
> 
> [...]

Applied to kvmtool (master), thanks!

[1/3] Makefile: Refine -s handling in the make parameters
      https://git.kernel.org/will/kvmtool/c/8f6cabb25d79
[2/3] arm/kvm-cpu: Fix new build warning
      https://git.kernel.org/will/kvmtool/c/426e875213d3
[3/3] virtio/rng: Fix build warning from min()
      https://git.kernel.org/will/kvmtool/c/53114134ce5a

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
