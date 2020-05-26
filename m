Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED9E1E26F5
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 18:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbgEZQ3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 12:29:13 -0400
Received: from foss.arm.com ([217.140.110.172]:53244 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729597AbgEZQ3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 12:29:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8095B30E;
        Tue, 26 May 2020 09:29:12 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8EFF93F52E;
        Tue, 26 May 2020 09:29:10 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
Subject: Re: [PATCH 11/26] KVM: arm64: Add missing reset handlers for PMU
 emulation
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-12-maz@kernel.org>
Message-ID: <51a1bb5b-fd7f-eb0e-8efe-0b1952a7fffd@arm.com>
Date:   Tue, 26 May 2020 17:29:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200422120050.3693593-12-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 22/04/2020 13:00, Marc Zyngier wrote:
> As we're about to become a bit more harsh when it comes to the lack of
> reset callbacks, let's add the missing PMU reset handlers. Note that
> these only cover *CLR registers that were always covered by their *SET
> counterpart, so there is no semantic change here.

Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
