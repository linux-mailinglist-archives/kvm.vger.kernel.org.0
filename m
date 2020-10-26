Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D116298F25
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 15:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781305AbgJZOWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 10:22:50 -0400
Received: from foss.arm.com ([217.140.110.172]:40836 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780875AbgJZOWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 10:22:50 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74CB130E;
        Mon, 26 Oct 2020 07:22:49 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.56.187])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2995B3F68F;
        Mon, 26 Oct 2020 07:22:47 -0700 (PDT)
Date:   Mon, 26 Oct 2020 14:22:45 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 01/11] KVM: arm64: Don't adjust PC on SError during SMC
 trap
Message-ID: <20201026142245.GI12454@C02TD0UTHF1T.local>
References: <20201026133450.73304-1-maz@kernel.org>
 <20201026133450.73304-2-maz@kernel.org>
 <20201026135308.GC12454@C02TD0UTHF1T.local>
 <b85f3ed6b97944055eda7f4bfeae8abc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b85f3ed6b97944055eda7f4bfeae8abc@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 26, 2020 at 02:08:35PM +0000, Marc Zyngier wrote:
> On 2020-10-26 13:53, Mark Rutland wrote:
> > Assuming that there is no 16-bit HVC:
> 
> It is actually impossible to have a 16bit encoding for HVC, as
> it always convey a 16bit immediate, and you need some space
> to encode the instruction itself!

Ah, of course!

Mark.
