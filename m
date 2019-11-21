Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D24104EB8
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 10:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfKUJGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 04:06:20 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:55764 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726880AbfKUJGU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Nov 2019 04:06:20 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iXiPo-0004FK-NV; Thu, 21 Nov 2019 10:06:16 +0100
To:     Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM/arm updates for 5.5
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 21 Nov 2019 09:06:16 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     =?UTF-8?Q?Radim_Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Jones <drjones@redhat.com>, <kvm@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Steven Price <steven.price@arm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Julien Grall <julien.grall@arm.com>,
        Alexander Graf <graf@amazon.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
In-Reply-To: <3cde0da8-62a5-d1a5-b6b9-58baf890707a@redhat.com>
References: <20191120164236.29359-1-maz@kernel.org>
 <3cde0da8-62a5-d1a5-b6b9-58baf890707a@redhat.com>
Message-ID: <3d2382e6ed7ea25cb13303760a79091a@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, mark.rutland@arm.com, drjones@redhat.com, kvm@vger.kernel.org, eric.auger@redhat.com, xypron.glpk@gmx.de, bigeasy@linutronix.de, suzuki.poulose@arm.com, christoffer.dall@arm.com, steven.price@arm.com, borntraeger@de.ibm.com, julien.grall@arm.com, graf@amazon.com, linux-arm-kernel@lists.infradead.org, yuzenghui@huawei.com, james.morse@arm.com, tglx@linutronix.de, will@kernel.org, kvmarm@lists.cs.columbia.edu, julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-11-21 08:58, Paolo Bonzini wrote:
> On 20/11/19 17:42, Marc Zyngier wrote:
>> Paolo, Radim,
>>
>> Here's the bulk of KVM/arm updates for 5.5. On the menu, two new 
>> features:
>> - Stolen time is finally exposed to guests. Yay!
>> - We can report (and potentially emulate) instructions that KVM 
>> cannot
>>   handle in kernel space to userspace. Yay again!
>>
>> Apart from that, a fairly mundane bag of perf optimization, cleanup 
>> and
>> bug fixes.
>>
>> Note that this series is based on a shared branch with the arm64 
>> tree,
>> avoiding a potential delicate merge.
>>
>> Please pull,
>
> Pulled, thanks.  Note that the new capabilities had a conflict and 
> were
> bumped by one.

Not a problem, nothing has been merged into any userspace so far.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
