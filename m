Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACDF4E2888
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 14:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348364AbiCUOAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 10:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349049AbiCUN6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 09:58:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1200174BAB
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 06:57:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71100611CF
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 13:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F7DC340F2;
        Mon, 21 Mar 2022 13:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647871029;
        bh=s3RG2lskzYIHCBj0QpKrfumQWmHB+RikR9MMTPHjm84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arZmPv1RKvDBxBtQO6qflcWzhZzHazoWt1I2sDMWzf9nGEgUjXIqXmkKNpDN1C44x
         FTvGihIaTZgquWdz8xHDIDMY/UVtEeNTr3/OhPBYLjq1oC1P4ZbeKqBxbSD/BfKEb3
         EMqa5Z9et4GjNepvi8VgS4hiDlGzFcXt++rOp9K/37qnFxycJwpLJnraNBXCXBvCX8
         StI0Zwfe2mknjdC91BMMiC1HTVPUwx78dThXcfgejQuenTHsFJN2uV0dOoHU55zdxn
         ytQF8v/WfgXCVrKYgsdi1QutqIQD/qRC6zGvpyF6gXVVeHaAJB6CXzaAAlcAERLPZn
         CmRldtuCN95LA==
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org, Sebastian Ene <sebastianene@google.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        qperret@google.com, kvmarm@lists.cs.columbia.edu, maz@kernel.org
Subject: Re: [PATCH kvmtool v11 0/3] aarch64: Add stolen time support
Date:   Mon, 21 Mar 2022 13:57:02 +0000
Message-Id: <164786978933.4050895.3560918928068714544.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220313161949.3565171-1-sebastianene@google.com>
References: <20220313161949.3565171-1-sebastianene@google.com>
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

On Sun, 13 Mar 2022 16:19:47 +0000, Sebastian Ene wrote:
> This series adds support for stolen time functionality.
> 
> Patch #1 moves the vCPU structure initialisation before the target->init()
> call to allow early access to the kvm structure from the vCPU
> during target->init().
> 
> Patch #2 modifies the memory layout in arm-common/kvm-arch.h and adds a
> new MMIO device PVTIME after the RTC region. A new flag is added in
> kvm-config.h that will be used to control [enable/disable] the pvtime
> functionality. Stolen time is enabled by default when the host
> supports KVM_CAP_STEAL_TIME.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/3] aarch64: Populate the vCPU struct before target->init()
      https://git.kernel.org/will/kvmtool/c/ff6958200c4b
[2/3] aarch64: Add stolen time support
      https://git.kernel.org/will/kvmtool/c/7d4671e5d372
[3/3] Add --no-pvtime command line argument
      https://git.kernel.org/will/kvmtool/c/1b76b6e1f84a

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
