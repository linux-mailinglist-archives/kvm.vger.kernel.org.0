Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF67304A23
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 21:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbhAZFPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:15:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:41654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727085AbhAYJny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:43:54 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00AC522D03;
        Mon, 25 Jan 2021 08:46:23 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l3xVs-009qJ2-Rx; Mon, 25 Jan 2021 08:46:20 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 25 Jan 2021 08:46:20 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Alex Shi <alex.shi@linux.alibaba.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        yj226063@alibaba-inc.com
Subject: Re: 3 preempted variables in kvm
In-Reply-To: <c14cac63-6a4c-1b5d-6a32-e16117141e94@linux.alibaba.com>
References: <b6398228-31b9-ca84-873b-4febbd37c87d@linux.alibaba.com>
 <YAsnvA1Q5AlXLd1W@google.com>
 <c14cac63-6a4c-1b5d-6a32-e16117141e94@linux.alibaba.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <cb8ee83260dd9cc60acbab5e33c2b6db@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alex.shi@linux.alibaba.com, seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org, yj226063@alibaba-inc.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-01-25 05:49, Alex Shi wrote:
> Hi Sean,
> 
> Thanks a lot for the detailed explanations.
> Yes, they are all meaningful variables on x86. But for more archs,
> guess the lock
> issue on different arch's guest are similar. Maybe a abstraction on
> the point would
> be very helpful. Any comments?

It depends on what you have in mind. The whole "yield to another
vcpu" mechanism is already abstracted behind kvm_vcpu_on_spin(),
which at arm64, s390 and x86 are using. You could investigate
whether this is a valid approach for Power and MIPS.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
