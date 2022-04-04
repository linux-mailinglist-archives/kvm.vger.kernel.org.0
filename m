Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36EF4F1332
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 12:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357842AbiDDKhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 06:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352770AbiDDKhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 06:37:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0840329A8
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 03:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47AC56151A
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 10:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7EBC34110;
        Mon,  4 Apr 2022 10:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649068504;
        bh=LqfHmuaBRCiwD5kyMx395K7k1ZL3Fca+ZQHr5nGT0es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pviiuiH8etrE5llkIOGeA9Ea5VM1xQArmGE4Hh0ni9iQScMPmOLbn9UDi4W84bIKh
         8ahi8BgnLd/gNj37O8VU69EYW4n38fSMzDbHFm9MGrCliEU0FKSwz68AyNqcDzRtIV
         mbAQ4DOU5dkWkUH7yazGnxfzYkYp4p04YtgGYqyKIUQlllUIEX7fn6hIxZtGzDSUTd
         RBDkL/CeQy7FBEYnfWV0DcXkoXvyiF3Xq+QAgl0ZQ6gN0yx44MmhCEWBpM4I57LtB7
         7MvCMv8Hycx2Y7aGb5dULMOBUCf/uu56fDJ4tgNQ/h1Pa3iSXcWbjUsUyUBs93vbaH
         I6tXC8kWBFxsQ==
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org, Sebastian Ene <sebastianene@google.com>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, julien.thierry.kdev@gmail.com,
        qperret@google.com
Subject: Re: [PATCH kvmtool v1] Make --no-pvtime command argument arm specific
Date:   Mon,  4 Apr 2022 11:34:56 +0100
Message-Id: <164906748276.1613477.6448075447690492653.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220324154304.2572891-1-sebastianene@google.com>
References: <20220324154304.2572891-1-sebastianene@google.com>
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

On Thu, 24 Mar 2022 15:43:05 +0000, Sebastian Ene wrote:
> The stolen time option is available only for aarch64 and is enabled by
> default. Move the option that disables stolen time functionality in the
> arch specific path.
> 
> 

Applied to kvmtool (master), thanks!

[1/1] Make --no-pvtime command argument arm specific
      https://git.kernel.org/will/kvmtool/c/ffa8654620b7

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
