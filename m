Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD572EEE83
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 09:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbhAHIXI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 03:23:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:58854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727300AbhAHIXI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 03:23:08 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50DBA2343B;
        Fri,  8 Jan 2021 08:22:27 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kxn2P-00624N-7B; Fri, 08 Jan 2021 08:22:25 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 08 Jan 2021 08:22:24 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Qian Cai <qcai@redhat.com>,
        Shannon Zhao <shannon.zhao@linux.alibaba.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.11, take #1
In-Reply-To: <35b38baf-bd75-9054-76f8-15e642e05f55@redhat.com>
References: <20210107112101.2297944-1-maz@kernel.org>
 <35b38baf-bd75-9054-76f8-15e642e05f55@redhat.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <47864d22df766d6028f437a20aa4668a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, dbrazdil@google.com, eric.auger@redhat.com, mark.rutland@arm.com, natechancellor@gmail.com, qcai@redhat.com, shannon.zhao@linux.alibaba.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 2021-01-07 23:09, Paolo Bonzini wrote:
> On 07/01/21 12:20, Marc Zyngier wrote:
>>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git 
>> tags/kvmarm-fixes-5.11-1
> 
> Looks like there are issues with the upstream changes brought in by
> this pull request.  Unless my bisection is quick tomorrow it may not
> make it into 5.11-rc3.  In any case, it's in my hands.

I'm not sure what you mean by "upstream changes", as there is no
additional changes on top of what is describe in this pull request,
which is directly based on the tag  you pulled for the merge window.

If there is an issue with any of these 18 patches themselves, please
shout as soon as you can.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
