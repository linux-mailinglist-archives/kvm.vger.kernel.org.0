Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8DB807A0
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 20:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbfHCSFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Aug 2019 14:05:33 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:48507 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728366AbfHCSFd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Aug 2019 14:05:33 -0400
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1htyPF-0002A1-0t; Sat, 03 Aug 2019 20:05:25 +0200
Date:   Sat, 3 Aug 2019 19:05:22 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Steven Price <steven.price@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] arm64: Stolen time support
Message-ID: <20190803190522.5fec8f7d@why>
In-Reply-To: <20190802145017.42543-1-steven.price@arm.com>
References: <20190802145017.42543-1-steven.price@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: steven.price@arm.com, catalin.marinas@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Aug 2019 15:50:08 +0100
Steven Price <steven.price@arm.com> wrote:

Hi Steven,

> This series add support for paravirtualized time for arm64 guests and
> KVM hosts following the specification in Arm's document DEN 0057A:
> 
> https://developer.arm.com/docs/den0057/a
> 
> It implements support for stolen time, allowing the guest to
> identify time when it is forcibly not executing.
> 
> It doesn't implement support for Live Physical Time (LPT) as there are
> some concerns about the overheads and approach in the above
> specification, and I expect an updated version of the specification to
> be released soon with just the stolen time parts.

Thanks for posting this.

My current concern with this series is around the fact that we allocate
memory from the kernel on behalf of the guest. It is the first example
of such thing in the ARM port, and I can't really say I'm fond of it.

x86 seems to get away with it by having the memory allocated from
userspace, why I tend to like more. Yes, put_user is more
expensive than a straight store, but this isn't done too often either.

What is the rational for your current approach?

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
