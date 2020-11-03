Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4DB2A4EDA
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 19:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgKCS32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 13:29:28 -0500
Received: from foss.arm.com ([217.140.110.172]:54020 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728855AbgKCS32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 13:29:28 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1DE91474;
        Tue,  3 Nov 2020 10:29:27 -0800 (PST)
Received: from [172.16.1.113] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DFAFD3F718;
        Tue,  3 Nov 2020 10:29:26 -0800 (PST)
Subject: Re: [PATCH 0/8] KVM: arm64: Kill the copro array
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
References: <20201102191609.265711-1-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <d1d98b83-7d58-1ab4-f429-0f297071c34a@arm.com>
Date:   Tue, 3 Nov 2020 18:29:25 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201102191609.265711-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 02/11/2020 19:16, Marc Zyngier wrote:
> Since the very beginning of KVM/arm64, we represented the system
> register file using a dual view: on one side the AArch64 state, on the

> other a bizarre mapping of the AArch64 state onto the Aarch64
> registers.

Now that would be bizarre!

mapping of the AArch32 state onto the Aarch64 registers?


> It was nice at the time as it allowed us to share some code with the
> 32bit port, and to come up with some creative bugs. But is was always
> a hack, and we are now in a position to simplify the whole thing.
> 
> This series goes through the whole of the AArch32 cp14/15 register
> file, and point each of them directly at their 64bit equivalent. For
> the few cases where two 32bit registers share a 64bit counterpart, we
> define which half of the register they map.


Thanks,

James
