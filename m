Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D7930A882
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 14:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbhBANTK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 08:19:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:42372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231849AbhBANSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 08:18:00 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 346B364E2A;
        Mon,  1 Feb 2021 13:17:20 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l6Z4w-00BH6m-3U; Mon, 01 Feb 2021 13:17:18 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 01 Feb 2021 13:17:18 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        wanghaibin.wang@huawei.com, jiangkunkun@huawei.com,
        xiexiangyou@huawei.com, zhengchuan@huawei.com, yubihong@huawei.com
Subject: Re: [RFC PATCH 0/7] kvm: arm64: Implement SW/HW combined dirty log
In-Reply-To: <f68d12f2-fa98-ebdd-3075-bfdcd690ee51@huawei.com>
References: <20210126124444.27136-1-zhukeqian1@huawei.com>
 <f68d12f2-fa98-ebdd-3075-bfdcd690ee51@huawei.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <9a64d4acd8e8b0b8c86143752b8c856d@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org, catalin.marinas@arm.com, alex.williamson@redhat.com, kwankhede@nvidia.com, cohuck@redhat.com, mark.rutland@arm.com, james.morse@arm.com, robin.murphy@arm.com, suzuki.poulose@arm.com, wanghaibin.wang@huawei.com, jiangkunkun@huawei.com, xiexiangyou@huawei.com, zhengchuan@huawei.com, yubihong@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-02-01 13:12, Keqian Zhu wrote:
> Hi Marc,
> 
> Do you have time to have a look at this? Thanks ;-)

Not immediately. I'm busy with stuff that is planned to go
in 5.12, which isn't the case for this series. I'll get to
it eventually.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
