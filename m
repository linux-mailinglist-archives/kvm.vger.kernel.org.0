Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7A624B03B
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 09:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgHTHh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 03:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbgHTHhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 03:37:25 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 747D5207DE;
        Thu, 20 Aug 2020 07:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597909044;
        bh=argdKbSednZIqUaCnhWJ/yMeBGfc5QoU71Zy2RYOt84=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zOnr852Ik4U8kZ3umPheqaGWulkIu3q6vL7syveggRIxY4TT9MZ7Lj+Uq2uTthkFM
         YvLxUxSaGDXiYXSPdAYZ9DQ3uhl4NFtUDu85czFql1mweGosF3IXY9yDzF6JtB6Hgh
         9UlGIXWwLD/inm2hMviSqGGMxx8syiCadwoo+c4I=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k8f8U-004RjE-Uw; Thu, 20 Aug 2020 08:37:23 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 20 Aug 2020 08:37:22 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Alexander Graf <graf@amazon.com>
Cc:     Auger Eric <eric.auger@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.com>,
        kvmarm@lists.cs.columbia.edu,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: arm64: Add PMU event filtering infrastructure
In-Reply-To: <0647b63c-ac27-8ec9-c9da-9a5e5163cb5d@amazon.com>
References: <20200309124837.19908-1-maz@kernel.org>
 <20200309124837.19908-2-maz@kernel.org>
 <70e712fc-6789-2384-c21c-d932b5e1a32f@redhat.com>
 <0027398587e8746a6a7459682330855f@kernel.org>
 <7c9e2e55-95c8-a212-e566-c48f5d3bc417@redhat.com>
 <470c88271ef8c4f92ecf990b7b86658e@kernel.org>
 <0647b63c-ac27-8ec9-c9da-9a5e5163cb5d@amazon.com>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <18b9ff6f9a65546f55dd2e7019d48986@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: graf@amazon.com, eric.auger@redhat.com, mark.rutland@arm.com, kvm@vger.kernel.org, suzuki.poulose@arm.com, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, robin.murphy@arm.com, kvmarm@lists.cs.columbia.edu, julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-19 00:24, Alexander Graf wrote:
> Hi Marc,

[...]

> I haven't seen a v3 follow-up after this. Do you happen to have that
> somewhere in a local branch and just need to send it out or would you
> prefer if I pick up v2 and address the comments?

I'll look into it.

         M.
-- 
Jazz is not dead. It just smells funny...
