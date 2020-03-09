Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F0317DB75
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgCIIqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbgCIIqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 04:46:37 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F24720637;
        Mon,  9 Mar 2020 08:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583743596;
        bh=tqjXhKqIJkxhukVg4AqM7KFlpr9nxVyUtnEc7Mr1b+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hbcjoUdh6xO89RMRAna09S1atnaN7J9iYMCdr7XSJTrwl7hZn7nUcKHI+jmuRqzm0
         X6G66Kc9wHozfS5RSp+UQz9RcsZxWGh6pHoutT9+AyXQJY9RGCLHRI/CtDjQXKLHOC
         DDrxCLZhzbWy8T9q8rbf1lWYzqIHE+L4pofonJYU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jBE3W-00BCC4-U3; Mon, 09 Mar 2020 08:46:35 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 09 Mar 2020 08:46:34 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 00/23] irqchip/gic-v4: GICv4.1 architecture support
In-Reply-To: <a2994971-0997-f723-4745-c6404a68e65a@huawei.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <a2994971-0997-f723-4745-c6404a68e65a@huawei.com>
Message-ID: <f4b97d8c301bef8778a3a12cf180292b@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-09 08:17, Zenghui Yu wrote:
> On 2020/3/5 4:33, Marc Zyngier wrote:
>> On the other hand, public documentation is not available yet, so 
>> that's a
>> bit annoying...
> 
> The IHI0069F is now available. People can have a look at:
> 
> https://developer.arm.com/docs/ihi0069/latest

Party! ;-)

         M.
-- 
Jazz is not dead. It just smells funny...
