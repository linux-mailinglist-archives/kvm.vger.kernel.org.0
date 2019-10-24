Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66990E3776
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 18:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436634AbfJXQKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 12:10:05 -0400
Received: from foss.arm.com ([217.140.110.172]:55416 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436631AbfJXQKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 12:10:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3E8E28;
        Thu, 24 Oct 2019 09:09:49 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 81AF33F71F;
        Thu, 24 Oct 2019 09:09:48 -0700 (PDT)
Subject: Re: [PATCH v2 2/5] arm64: KVM: Reorder system register restoration
 and stage-2 activation
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20191019095521.31722-1-maz@kernel.org>
 <20191019095521.31722-3-maz@kernel.org>
From:   James Morse <james.morse@arm.com>
Message-ID: <e835b1bf-b2b2-c0e7-f34c-e0a68f921ffd@arm.com>
Date:   Thu, 24 Oct 2019 17:09:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191019095521.31722-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 19/10/2019 10:55, Marc Zyngier wrote:
> In order to prepare for handling erratum 1319367, we need to make
> sure that all system registers (and most importantly the registers
> configuring the virtual memory) are set before we enable stage-2
> translation.
> 
> This results in a minor reorganisation of the load sequence, without
> any functional change.

Reviewed-by: James Morse <james.morse@arm.com>


Thanks,

James
