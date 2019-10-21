Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE2C2DEEC2
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 16:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfJUOGH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 10:06:07 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:33835 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728098AbfJUOGH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Oct 2019 10:06:07 -0400
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iMYJp-0005GP-K0; Mon, 21 Oct 2019 16:05:57 +0200
To:     Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v6 08/10] arm/arm64: Provide a wrapper for SMCCC 1.1 calls
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 21 Oct 2019 15:05:57 +0100
From:   Marc Zyngier <maz@kernel.org>
Cc:     Will Deacon <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Radim_Kr=C4=8Dm=C3=A1?= =?UTF-8?Q?=C5=99?= 
        <rkrcmar@redhat.com>, Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <890a7909-1083-2e6d-368a-f1d03788f5a1@arm.com>
References: <20191011125930.40834-1-steven.price@arm.com>
 <20191011125930.40834-9-steven.price@arm.com>
 <099040bb979b7cb878a7f489033aacc7@www.loen.fr>
 <890a7909-1083-2e6d-368a-f1d03788f5a1@arm.com>
Message-ID: <760679a0a6fef6041b0e7bec8d04d81f@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: steven.price@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, mark.rutland@arm.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-10-21 14:43, Steven Price wrote:
> On 21/10/2019 12:42, Marc Zyngier wrote:
>> On 2019-10-11 13:59, Steven Price wrote:
> [...]
>> All this should most probably go on top of the SMCCC conduit cleanup 
>> that
>> has already been already queued in the arm64 tree (see
>> arm64/for-next/smccc-conduit-cleanup).
>
> Good point, I'll rebase. Are you happy for the entire series to be 
> based
> on top of that? i.e. based on commit e6ea46511b1a ("firmware: 
> arm_sdei:
> use common SMCCC_CONDUIT_*")

Absolutely. I'll sync with Will and Catalin to get a stable branch that
includes these commits.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
