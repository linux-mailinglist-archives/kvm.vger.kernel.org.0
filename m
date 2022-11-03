Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0526761833A
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 16:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiKCPr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 11:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiKCPrZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 11:47:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F91E1143;
        Thu,  3 Nov 2022 08:47:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18BA4B8269B;
        Thu,  3 Nov 2022 15:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB34C433C1;
        Thu,  3 Nov 2022 15:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667490441;
        bh=YyjFEMcRcjqRDNSfbQWiVKeLBUUkpDMT5jdKO6cAdqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDr9qyKe/+dTR8gWFGKeBUhaC6zf/8HOy2icfeIp2fkVHh6HFeOyvTa2yirYgH9Uv
         g4p6zC9ZdppboGONR9r7YwziMTpiF2HbXUtg0n8i+Kbk9k6mvoNu4xv3ZaKijU7d6d
         haM3m5tT7hYMlfh7UBfNTT13941UTyCsMsHT3eEQrZuKkF3vhVU7/yKO7UR6K+b6f7
         PgKJmetND26xArGRpkC53q/67oQ63maKXTe7hybvMkyeKQPiqAiOM9KosvFZYi+Lc8
         tWWbtpIOX7OWLWvK1l729EYpyaHJi41yIut+oPFcdNnuQbQk6jHeaLmxoBM4KJY8nk
         wkgc4wFHl4lbA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1oqcR5-003Xxs-PC;
        Thu, 03 Nov 2022 15:47:19 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     yezengruan@huawei.com, steven.price@arm.com,
        catalin.marinas@arm.com, mark.rutland@arm.com,
        linux@armlinux.org.uk, Usama Arif <usama.arif@bytedance.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, will@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, bagasdotme@gmail.com
Cc:     fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com
Subject: Re: [PATCH] kvm/arm: Fix pvtime documentation
Date:   Thu,  3 Nov 2022 15:47:16 +0000
Message-Id: <166749042515.2400683.5463582608696818455.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221103131210.3603385-1-usama.arif@bytedance.com>
References: <20221103131210.3603385-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: yezengruan@huawei.com, steven.price@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, linux@armlinux.org.uk, usama.arif@bytedance.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, will@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, bagasdotme@gmail.com, fam.zheng@bytedance.com, liangma@liangbit.com, punit.agrawal@bytedance.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 3 Nov 2022 13:12:10 +0000, Usama Arif wrote:
> This includes table format and using reST labels for
> cross-referencing to vcpu.rst.

Applied to kvm-arm64/misc-6.2, thanks!

[1/1] kvm/arm: Fix pvtime documentation
      commit: e7442ac1da07910f4731cb812c05484e4be2d4de

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


