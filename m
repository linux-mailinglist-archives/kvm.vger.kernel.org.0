Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BF41C4074
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 18:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbgEDQvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 12:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729553AbgEDQvj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 12:51:39 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CA80206D9;
        Mon,  4 May 2020 16:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588611098;
        bh=vNjcj7BiW7fsrp1PHDFOxUtfyekks+fuqVJ5fa+MBVU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F+xJ6rUn2jyOJhjTTP4RDpIU9PMA0E4wiN0tBoAsaa01z99VfvRWlchg0ha7hBAtZ
         D4LGUXdjQ2cM6CbLAuhdcWlaT6Waym4whpQThp95vDGN1kAIoigsCu7mQ9r9jikuGr
         RstFdo9WOMEId9nXKZkHbsRmA3PK4kDvnNFbz9Sk=
Date:   Mon, 4 May 2020 17:51:33 +0100
From:   Will Deacon <will@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        Fangrui Song <maskray@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] KVM/arm fixes for 5.7, take #2
Message-ID: <20200504165132.GA1833@willie-the-truck>
References: <20200501101204.364798-1-maz@kernel.org>
 <20200504113051.GB1326@willie-the-truck>
 <df78d984-6ce3-f887-52a9-a3e9164a6dee@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df78d984-6ce3-f887-52a9-a3e9164a6dee@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 06:05:51PM +0200, Paolo Bonzini wrote:
> On 04/05/20 13:30, Will Deacon wrote:
> > I don't see this queued up in the kvm tree, which appears to have been
> > sitting dormant for 10 days. Consequently, there are fixes sitting in
> > limbo and we /still/ don't have a sensible base for arm64/kvm patches
> > targetting 5.8.
> > 
> > Paolo -- how can I help get this stuff moving again? I'm more than happy
> > to send this lot up to Linus via arm64 if you're busy atm. Please just
> > let me know.
> 
> 10 days is one week during which I could hardly work and the two
> adjacent weekends.  So this is basically really bad timing in Marc's
> first pull request, that he couldn't have anticipated.

Understood, and thanks for the quick reply. If possible, please just let us
know in future as we can probably figure something out rather than having
things sit in limbo.

> I have pulled both trees now, so you can base 5.8 development on
> kvm/master.  It will get to Linus in a couple days.

Thanks, Paolo!

Will
