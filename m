Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AABCA8164D
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 12:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfHEKDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 06:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727830AbfHEKDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 06:03:19 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D63212075B;
        Mon,  5 Aug 2019 10:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564999399;
        bh=YOw3eXXTngamY2vUc4t6eNrKhwGf591Fl1XUuUTIR14=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hSLcHvvUheEUjR3iZldH1kFTzjsmKYQEJY3qZfcH2XHVp85wSCD10iY/IOI7hrQ0M
         RXojUUFfKcGjxcUYjZhk++s1wQBVkRKmQhCSJkDbeHWO0jF/4x/0ofAqCZ0MduABXE
         R/xSf8650vmGSiEbz9ThcRl5ywyoTZtrvpD4W18g=
Date:   Mon, 5 Aug 2019 11:03:14 +0100
From:   Will Deacon <will@kernel.org>
To:     Steven Price <steven.price@arm.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] arm/arm64: Provide a wrapper for SMCCC 1.1 calls
Message-ID: <20190805100313.x65743i3n4qx6gyc@willie-the-truck>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-8-steven.price@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802145017.42543-8-steven.price@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 02, 2019 at 03:50:15PM +0100, Steven Price wrote:
> SMCCC 1.1 calls may use either HVC or SMC depending on the PSCI
> conduit. Rather than coding this in every call site provide a macro
> which uses the correct instruction. The macro also handles the case
> where no PSCI conduit is configured returning a not supported error
> in res, along with returning the conduit used for the call.
> 
> This allow us to remove some duplicated code and will be useful later
> when adding paravirtualized time hypervisor calls.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  include/linux/arm-smccc.h | 44 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)

Acked-by: Will Deacon <will@kernel.org>

Will
