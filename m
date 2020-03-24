Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C67B190D20
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 13:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgCXMOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 08:14:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgCXMOR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 08:14:17 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A54920658;
        Tue, 24 Mar 2020 12:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585052057;
        bh=dhtvbB+PPXUZoBcoMnaOLzrw631OzqnrbINwvvOINt4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BgAC6V2Az+2jFYEhLlmiHR3DebSQCeuePZdwonD5gjANLrYa9D+arvTk94T7GB+BZ
         +YV6s/yqUjiFPXUurWd/i7Nk6p/54EQx+aFWgjpj7OXiVAZUdZF+ehgehCHIaMuDJL
         IsReRW1A7GPCm69FfQjZKPUGQla2Wxpj9rbdq9Zc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jGiRj-00FFea-4G; Tue, 24 Mar 2020 12:14:15 +0000
Date:   Tue, 24 Mar 2020 12:14:13 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v6 08/23] irqchip/gic-v4.1: Plumb skeletal VSGI irqchip
Message-ID: <20200324121413.12839170@why>
In-Reply-To: <0ac3af1c-5160-a528-f2b4-aac4833ce32c@huawei.com>
References: <20200320182406.23465-1-maz@kernel.org>
        <20200320182406.23465-9-maz@kernel.org>
        <0ac3af1c-5160-a528-f2b4-aac4833ce32c@huawei.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, tglx@linutronix.de, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Mar 2020 10:27:18 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> On 2020/3/21 2:23, Marc Zyngier wrote:
> > +static int its_sgi_set_affinity(struct irq_data *d,
> > +				const struct cpumask *mask_val,
> > +				bool force)
> > +{
> > +	/*
> > +	 * There is no notion of affinity for virtual SGIs, at least
> > +	 * not on the host (since they can only be targetting a vPE).
> > +	 * Tell the kernel we've done whetever it asked for.  
> 
> new typo?
> s/whetever/whatever/

Yeah, I'm that good... :-(.

Fixed now.

	M.
-- 
Jazz is not dead. It just smells funny...
