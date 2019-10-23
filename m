Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 012AEE1AE2
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 14:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390515AbfJWMjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 08:39:37 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:60501 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732680AbfJWMjh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Oct 2019 08:39:37 -0400
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iNFv9-0001yJ-KM; Wed, 23 Oct 2019 14:39:23 +0200
To:     Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v7 00/10] arm64: Stolen time support
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 23 Oct 2019 13:39:23 +0100
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
In-Reply-To: <20191021152823.14882-1-steven.price@arm.com>
References: <20191021152823.14882-1-steven.price@arm.com>
Message-ID: <f0d79362ab994e269680fba75f913044@www.loen.fr>
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

Hi Steven,

On 2019-10-21 16:28, Steven Price wrote:
> This series add support for paravirtualized time for arm64 guests and
> KVM hosts following the specification in Arm's document DEN 0057A:
>
> https://developer.arm.com/docs/den0057/a
>
> It implements support for stolen time, allowing the guest to
> identify time when it is forcibly not executing.
>
> Note that Live Physical Time (LPT) which was previously part of the
> above specification has now been removed.
>
> Also available as a git tree:
> git://linux-arm.org/linux-sp.git stolen_time/v7

Can you please point me to userspace patches that I could apply to
kvmtool? I'd like to give this series a go as part of my normal 
testing.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
