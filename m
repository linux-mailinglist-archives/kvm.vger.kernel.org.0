Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34DE86BB96
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 13:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbfGQLhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 07:37:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726284AbfGQLhq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 07:37:46 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83C0321743;
        Wed, 17 Jul 2019 11:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563363466;
        bh=tq+6xuI8SQMUzIcpH5lQylstA6fY9G03SjvpF49Mn2E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LyYLGrvDiM18pUehSMqkl7EfV7nTxu+TP8iz9zuDkbtis9IhHbLdioUOrimvCYnj5
         fBlgIMDcyBjdbOcwuu8f3bV3+ZlarDx4fL9xPPmh0krBOFae8O3tRwJKqorg0FEC2r
         gLsjYOdU7afjfIpVmRacn61BGofcHdODOgtn5qGk=
Date:   Wed, 17 Jul 2019 12:37:40 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org
Subject: Re: [PATCH] MAINTAINERS: Update my email address to @kernel.org
Message-ID: <20190717113739.ffw43htk5vtt5bfr@willie-the-truck>
References: <20190716174308.17147-1-marc.zyngier@arm.com>
 <20190717064315.tn26dss343iv33oj@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190717064315.tn26dss343iv33oj@willie-the-truck>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 17, 2019 at 07:43:15AM +0100, Will Deacon wrote:
> On Tue, Jul 16, 2019 at 06:43:08PM +0100, Marc Zyngier wrote:
> > I will soon lose access to my @arm.com email address, so let's
> > update the MAINTAINERS file to point to my @kernel.org address,
> > as well as .mailmap for good measure.
> > 
> > Note that my @arm.com address will still work, but someone else
> > will be reading whatever is sent there. Don't say you didn't know!
> > 
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> > 
> > Notes:
> >     Yes, I'm sending this from my ARM address. That's intentional.
> >     I'll probably send it as part of a pull request later in the
> >     cycle, but that's just so that people know what is coming.
> > 
> >  .mailmap    | 1 +
> >  MAINTAINERS | 8 ++++----
> >  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> Let's see if you manage a better job of getting people to use your new
> address than I have:
> 
> Acked-by: Will Deacon <will@kernel.org>

Actually, since there's another change from Julien, I'll just pick both of
these up via the arm64 tree for -rc2 along with the vdso fixes we've got
kicking around.

Will
