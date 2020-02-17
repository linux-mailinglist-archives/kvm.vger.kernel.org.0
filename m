Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B896161947
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2020 19:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbgBQSAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Feb 2020 13:00:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:32936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbgBQSAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Feb 2020 13:00:12 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBAA3207FD;
        Mon, 17 Feb 2020 18:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581962412;
        bh=N4IaW7dJRmwJgdZkZ+ORETnJlyDW9qtyXif08JJnFaE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A9vcyWM1I1hyR8h+F9be43m2NDJdYDzfr3Jk4E16UwflHq2bKAnqUpqKSYDCrKPVt
         ZY3sUGVq+MJmJdKQ00JDoYLChTZjbH2TSbRsZWR7X23+jjZkbtDvkoSl1/pdmgw4Mm
         67Dhpm+aIyl38XH+/zeiiGveb6jsacMbcxINtsCI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j3kgk-005z8z-1d; Mon, 17 Feb 2020 18:00:10 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 17 Feb 2020 18:00:10 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Tomasz Nowicki <tnowicki@marvell.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, christoffer.dall@arm.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, gkulkarni@marvell.com,
        rrichter@marvell.com
Subject: Re: [PATCH 0/2] KVM: arm/arm64: Fixes for scheudling htimer of
 emulated timers
In-Reply-To: <20200217145438.23289-1-tnowicki@marvell.com>
References: <20200217145438.23289-1-tnowicki@marvell.com>
Message-ID: <f70d41fd006319e3d62224c410d62e20@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: tnowicki@marvell.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, christoffer.dall@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, gkulkarni@marvell.com, rrichter@marvell.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-02-17 14:54, Tomasz Nowicki wrote:
> This small series contains two fixes which were found while testing
> Marc's ARM NV patch set, where we are going to have at most 4 timers
> and the two are purely emulated.

What are these patches fixing? the NV series? or mainline?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
