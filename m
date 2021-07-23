Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7304E3D3B6D
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 15:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbhGWNLz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 09:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233552AbhGWNLy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jul 2021 09:11:54 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4835F60EBD;
        Fri, 23 Jul 2021 13:52:28 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m6vbG-000VBj-B4; Fri, 23 Jul 2021 14:52:26 +0100
MIME-Version: 1.0
Date:   Fri, 23 Jul 2021 14:52:26 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        will@kernel.org
Subject: Re: [PATCH 10/16] KVM: arm64: Add some documentation for the MMIO
 guard feature
In-Reply-To: <20210723133845.jwp3ljkfnupgv36i@gator>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-11-maz@kernel.org>
 <20210721211743.hb2cxghhwl2y22yh@gator>
 <60d8e9e95ee4640cf3b457c53cb4cc7a@kernel.org>
 <20210723133845.jwp3ljkfnupgv36i@gator>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <6768b88a9119ea8b6e80d0d3e1935e42@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com, vatsa@codeaurora.org, sdonthineni@nvidia.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-07-23 14:38, Andrew Jones wrote:
> On Fri, Jul 23, 2021 at 02:30:13PM +0100, Marc Zyngier wrote:
> ...
>> > > +
>> > > +    ==============    ========
>> > > ======================================
>> > > +    Function ID:      (uint32)    0xC6000004
>> > > +    Arguments:        (uint64)    The base of the PG-sized IPA range
>> > > +                                  that is allowed to be accessed as
>> > > +				  MMIO. Must aligned to the PG size (r1)
>> >
>> > align
>> 
>> Hmmm. Ugly mix of tab and spaces. I have no idea what the norm
>> is here, so I'll just put spaces. I'm sure someone will let me
>> know if I'm wrong! ;-)
> 
> Actually, my comment wasn't regarding the alignment of the text. I was
> commenting that we should change 'aligned' to 'align' in the text. 
> (Sorry,
> that was indeed ambiguous.) Hmm, it might be better to just add 'be', 
> i.e.
> 'be aligned'.

*blink*. duh, of course.

> I'm not sure what to do about the tab/space mixing, but keeping it
> consistent is good enough for me.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
