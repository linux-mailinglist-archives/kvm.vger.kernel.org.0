Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206501E2702
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 18:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388651AbgEZQaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 12:30:15 -0400
Received: from foss.arm.com ([217.140.110.172]:53364 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388612AbgEZQaO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 12:30:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7189330E;
        Tue, 26 May 2020 09:30:14 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C27C33F52E;
        Tue, 26 May 2020 09:30:11 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
Subject: Re: [PATCH 22/26] KVM: arm64: Disintegrate SPSR array
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
 <20200422120050.3693593-23-maz@kernel.org>
Message-ID: <24debc78-9de6-ac97-afbc-dbe366164e5e@arm.com>
Date:   Tue, 26 May 2020 17:30:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200422120050.3693593-23-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 22/04/2020 13:00, Marc Zyngier wrote:
> As we're about to move SPSR_EL1 into the VNCR page, we need to
> disassociate it from the rest of the 32bit cruft. Let's break
> the array into individual fields.

Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
