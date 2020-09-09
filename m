Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9775826342B
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 19:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgIIRPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 13:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730189AbgIIRPI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 13:15:08 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D32E206E6;
        Wed,  9 Sep 2020 17:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599671708;
        bh=yb6nfxanj9Tiy386s0uxnCmabtNDbe5a6Bii3jABOyk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n/hkFtawTWuMM9SNDrnaacRfjoFyyzdh5VJskOv8GjzM/5dDE3F6aLCwqaItQYUpg
         l29nqfWFOjEruGBP8EBMHXqVcWA+wcx/3y/0puprz0aKDcN0b2Q+kFHl0a2+vJ/0JR
         n7AN9/hoad/gNsC2RrX1E28h/ePtSeWrwcWK7XXI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kG3gY-00AQbP-D9; Wed, 09 Sep 2020 18:15:06 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 09 Sep 2020 18:15:06 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.9
In-Reply-To: <f7afbf0f-2e14-2720-5d23-2cd01982e4d1@redhat.com>
References: <20200904104530.1082676-1-maz@kernel.org>
 <f7afbf0f-2e14-2720-5d23-2cd01982e4d1@redhat.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <fea2e35a29967075e46d25220044c109@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, eric.auger@redhat.com, gshan@redhat.com, steven.price@arm.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-09-09 16:20, Paolo Bonzini wrote:
> On 04/09/20 12:45, Marc Zyngier wrote:
>> Hi Paolo,
>> 
>> Here's a bunch of fixes for 5.9. The gist of it is the stolen time
>> rework from Andrew, but we also have a couple of MM fixes that have
>> surfaced as people have started to use hugetlbfs in anger.
> 
> Hi Marc,
> 
> I'll get to this next Friday.

Thanks. I may have another one for you by then though...

         M.
-- 
Jazz is not dead. It just smells funny...
