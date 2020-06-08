Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872221F1C50
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 17:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbgFHPmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 11:42:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730237AbgFHPmp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 11:42:45 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95938206C3;
        Mon,  8 Jun 2020 15:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591630964;
        bh=CcGUQFrKPbxqqYBdQSn7aunL0vzndo8c/yOQ5BBHLhQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gBsMPDJNjtGVl/jmnBcUHW9bDu1wu5RUrfh/1SfTLUiFY9kxCvC5tQUVcjiqdrRRg
         zGGKnhrKBC457xtfkyzZ/VmOelipN92/chg1ZHo2VW/x7+ZbYKfv8HrPuPDRxrpVi2
         DYRPtJFy+eJEeof/DFhqUmsnS7BqRQ8/XLbheQjI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jiJv9-001A5n-3f; Mon, 08 Jun 2020 16:42:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 08 Jun 2020 16:42:42 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Scull <ascull@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kernel-team@android.com
Subject: Re: [PATCH v2] KVM: arm64: Remove host_cpu_context member from vcpu
 structure
In-Reply-To: <20200608145145.GA96714@google.com>
References: <20200608085657.1405730-1-maz@kernel.org>
 <20200608145145.GA96714@google.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <1a00887a4af019fa83380b68afd43a29@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ascull@google.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, mark.rutland@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

On 2020-06-08 15:51, Andrew Scull wrote:
> On Mon, Jun 08, 2020 at 09:56:57AM +0100, Marc Zyngier wrote:
>> For very long, we have kept this pointer back to the per-cpu
>> host state, despite having working per-cpu accessors at EL2
>> for some time now.
>> 
>> Recent investigations have shown that this pointer is easy
>> to abuse in preemptible context, which is a sure sign that
>> it would better be gone. Not to mention that a per-cpu
>> pointer is faster to access at all times.
> 
> Helps to make the references to `kvm_host_data` clearer with there now
> being just one way to get to it and shows that it is scoped to the
> current CPU. A good change IMO!

Thanks! Can I take this as a Reviewed-by or Acked-by tag? Just let me 
know.

Cheers,

          M.
-- 
Jazz is not dead. It just smells funny...
