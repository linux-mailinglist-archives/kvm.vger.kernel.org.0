Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13639375019
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 09:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbhEFHZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 03:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbhEFHZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 03:25:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BABC061574;
        Thu,  6 May 2021 00:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mmRnwL0+7c5+Z5SO1e0LYjJ5FVGGCBEN51tuNvrP2X0=; b=dpl4IyQPo0BlhWM2jTUcSNiOM5
        /T1JxZKErUyUJ9ETGjthgTvZ6+0OE2eNrB29F18aCLTSE3AY/xVRTw0W6UErf9xzj/pLYAIKskR24
        9gkXrFzSnnoR6b0tbjou7qUCFLHVaZaFpamiS+LSYEmXJ79F/OeUbkj/AyGD+HpBOz7desj14+edY
        lUSejZFA7BuloJKBWWjRevjeIajZvfhMZGc2TxvSzC/4NWlQelWzgRFJ0GQWskjKdESm2Q71fXyDM
        MKGsLUXv63Uiz1DdJstZdNuaRRiLTFtehgz1ms52fqVkX+gi+cE6P/G5IoCOYg3wFwXgGl1M0HtoM
        TzrY8boA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1leYKz-001QP0-T6; Thu, 06 May 2021 07:22:27 +0000
Date:   Thu, 6 May 2021 08:22:21 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     Will Deacon <will@kernel.org>, Vikram Sethi <vsethi@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Mark Kettenis <mark.kettenis@xs4all.nl>,
        Marc Zyngier <maz@kernel.org>,
        Shanker Donthineni <sdonthineni@nvidia.com>,
        "christoffer.dall@arm.com" <christoffer.dall@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Sequeira <jsequeira@nvidia.com>
Subject: Re: [RFC 1/2] vfio/pci: keep the prefetchable attribute of a BAR
 region in VMA
Message-ID: <20210506072221.GA338890@infradead.org>
References: <BL0PR12MB2532CC436EBF626966B15994BD5E9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87eeeqvm1d.wl-maz@kernel.org>
 <BL0PR12MB25329EF5DFA7BBAA732064A7BD5C9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <87bl9sunnw.wl-maz@kernel.org>
 <c1bd514a531988c9@bloch.sibelius.xs4all.nl>
 <BL0PR12MB253296086906C4A850EC68E6BD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <20210503084432.75e0126d@x1.home.shazbot.org>
 <BL0PR12MB2532BEAE226E7D68A8A2F97EBD5B9@BL0PR12MB2532.namprd12.prod.outlook.com>
 <20210504083005.GA12290@willie-the-truck>
 <20210505180228.GA3874@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210505180228.GA3874@arm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021 at 07:02:31PM +0100, Catalin Marinas wrote:
> > Furthermore, ioremap() already gives you a Device memory type, and we're
> > tight on MAIR space.
> 
> We have MT_DEVICE_GRE currently reserved though no in-kernel user, we
> might as well remove it.

Please do.  The more we can cut down on different memory types, the
better.
