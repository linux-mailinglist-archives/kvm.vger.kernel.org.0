Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9EA2466AC
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 14:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgHQMwQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 08:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgHQMwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 08:52:13 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA53020789;
        Mon, 17 Aug 2020 12:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597668732;
        bh=LCkDhp0yrQ1H4GBGLsPDHG1MxDxVdl9KXyWjwLTvWPI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pUHLfV+s8fddXGPPQLHHqlb1z8AbfUZG7NYwsP6qnq5K2IVfcprGJsRrncpdFA9ra
         0yWmrmbHicohobmmQJY+O/OkOVFL+9FwbcCNn8IymvQarItwreniFbq0rqYpjzwCEx
         WpS6O+f+OLhmp7XvP9Rx93u16E0rFw/5ea5eTJsA=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k7ecV-003ZH0-B9; Mon, 17 Aug 2020 13:52:11 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 17 Aug 2020 13:52:11 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        wanghaibin.wang@huawei.com
Subject: Re: [PATCH 1/2] clocksource: arm_arch_timer: Simplify and fix count
 reader code logic
In-Reply-To: <20200817122415.6568-2-zhukeqian1@huawei.com>
References: <20200817122415.6568-1-zhukeqian1@huawei.com>
 <20200817122415.6568-2-zhukeqian1@huawei.com>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <267c5f9151c39fd2dcd0ce0b09d96545@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, steven.price@arm.com, drjones@redhat.com, catalin.marinas@arm.com, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-17 13:24, Keqian Zhu wrote:
> In commit 0ea415390cd3 (clocksource/arm_arch_timer: Use 
> arch_timer_read_counter
> to access stable counters), we separate stable and normal count reader. 
> Actually
> the stable reader can correctly lead us to normal reader if we has no
> workaround.

Resulting in an unnecessary overhead on non-broken systems that can run
without CONFIG_ARM_ARCH_TIMER_OOL_WORKAROUND. Not happening.

> Besides, in erratum_set_next_event_tval_generic(), we use normal 
> reader, it is
> obviously wrong, so just revert this commit to solve this problem by 
> the way.

If you want to fix something, post a patch that does exactly that.

         M.
-- 
Jazz is not dead. It just smells funny...
