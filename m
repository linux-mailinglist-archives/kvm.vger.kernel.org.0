Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0161DC01B3
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 11:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfI0JDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 05:03:53 -0400
Received: from foss.arm.com ([217.140.110.172]:46236 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725882AbfI0JDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 05:03:52 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54277337;
        Fri, 27 Sep 2019 02:03:52 -0700 (PDT)
Received: from arrakis.emea.arm.com (arrakis.cambridge.arm.com [10.1.196.78])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1C26F3F739;
        Fri, 27 Sep 2019 02:03:51 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:03:49 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH 5/5] arm64: Enable and document ARM errata 1319367 and
 1319537
Message-ID: <20190927090348.GC15760@arrakis.emea.arm.com>
References: <20190925111941.88103-1-maz@kernel.org>
 <20190925111941.88103-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925111941.88103-6-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 25, 2019 at 12:19:41PM +0100, Marc Zyngier wrote:
> Now that everything is in place, let's get the ball rolling
> by allowing the corresponding config option to be selected.
> Also add the required information to silicon_arrata.rst.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
