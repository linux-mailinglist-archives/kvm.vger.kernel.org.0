Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B050E42DEDB
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 18:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhJNQIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 12:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230384AbhJNQIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 12:08:17 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63A3F61056;
        Thu, 14 Oct 2021 16:06:12 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mb3FC-00GmGg-5G; Thu, 14 Oct 2021 17:06:10 +0100
MIME-Version: 1.0
Date:   Thu, 14 Oct 2021 17:06:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        oupton@google.com, qperret@google.com, kernel-team@android.com,
        tabba@google.com
Subject: Re: [PATCH v9 17/22] KVM: arm64: pkvm: Handle GICv3 traps as required
In-Reply-To: <20211014094613.tnx4xwyqrxj4jmnq@gator.home>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
 <20211013120346.2926621-7-maz@kernel.org>
 <20211014094613.tnx4xwyqrxj4jmnq@gator.home>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <cba80f95c5df69d9bcea8c6dc30cfbf7@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com, oupton@google.com, qperret@google.com, kernel-team@android.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-10-14 10:46, Andrew Jones wrote:
> On Wed, Oct 13, 2021 at 01:03:41PM +0100, Marc Zyngier wrote:
>> Forward accesses to the ICV_*SGI*_EL1 registers to EL1, and
>> emulate ICV_SRE_EL1 by returning a fixed value.
>> 
>> This should be enough to support GICv3 in a protected guest.
> 
> Out of curiosity, has the RVIC work / plans been dropped?

ARM has dropped the architecture, and it makes no sense
to move KVM to support non-architectural stuff.

Which means we will eventually have to harden the guest itself
to cope with the fact that it cannot trust the interrupt controller.

Yes, this is crap.

         M.
-- 
Jazz is not dead. It just smells funny...
