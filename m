Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494E5157FC0
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 17:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgBJQ0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 11:26:45 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35616 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbgBJQ0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 11:26:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=65bdrIaYUEY07Eg6lahVGNf+sXMz7DgHQPG+97GSzoU=; b=O249n01KJyJmh5v7eoKu72Wxm
        aT6PtOrlOoyebt8IeMBdWJ+Mc0G34pwCNSbq0pYUPEVnSHE8dOnkTdb88whOVZjCsaHxz+de39iuw
        yWGdC/Muzm1L1tlo8Yjkn1SETYGGIMiFmXrUylkja4lUEkM0nU9MJ8ufgf5CDc7P0iz1Cwj0bx9rJ
        /sVJEE2hjddOOmp19LpzoXQL2y7uBEKycflnocOXeWpZIs83p15iLxzw6REUj4m/ovum6O/B7IyuY
        8gdPpNCERbJCVPjnCguAIPq7nX4OSUNFDb7Dbgxau52hL0T9rKWjEzNmX5smg1KyJyTM8hvgHvd9N
        t9gGOlcEw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:38534)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j1BtO-0007mo-Kh; Mon, 10 Feb 2020 16:26:38 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j1BtN-00081o-CD; Mon, 10 Feb 2020 16:26:37 +0000
Date:   Mon, 10 Feb 2020 16:26:37 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <Christoffer.Dall@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Anders Berg <anders.berg@lsi.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH 0/5] Removing support for 32bit KVM/arm host
Message-ID: <20200210162637.GG25745@shell.armlinux.org.uk>
References: <20200210141324.21090-1-maz@kernel.org>
 <20200210162523.GF25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210162523.GF25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 10, 2020 at 04:25:23PM +0000, Russell King - ARM Linux admin wrote:
> On Mon, Feb 10, 2020 at 02:13:19PM +0000, Marc Zyngier wrote:
> > KVM/arm was merged just over 7 years ago, and has lived a very quiet
> > life so far. It mostly works if you're prepared to deal with its
> > limitations, it has been a good prototype for the arm64 version,
> > but it suffers a few problems:
> > 
> > - It is incomplete (no debug support, no PMU)
> > - It hasn't followed any of the architectural evolutions
> > - It has zero users (I don't count myself here)
> > - It is more and more getting in the way of new arm64 developments
> > 
> > So here it is: unless someone screams and shows that they rely on
> > KVM/arm to be maintained upsteam, I'll remove 32bit host support
> > form the tree. One of the reasons that makes me confident nobody is
> > using it is that I never receive *any* bug report. Yes, it is perfect.
> > But if you depend on KVM/arm being available in mainline, please shout.
> 
> It is only very recently that 64-bit ARM has really started to filter
> down to people like me, and people like me have setup systems which
> use 32-bit VMs under 64-bit hosts (about a year ago now.)  In fact,
> everything that you presently see for the *.armlinux.org.uk domain now
> runs inside several 32-bit ARM VMs under a 64-bit ARM host.
> 
> It isn't perfect; I've found issues with qemu and libvirt.  One example
> is the rather sub-standard RTC implementation, which means if you
> use libvirt's managesave across a host reboot, the guests idea of
> time-of-day freezes while it's asleep, and resumes when the guest is
> reloaded - resulting in the guests time-of-day being rather wrong,
> sometimes to the point that NTP gives up.  That becomes very painful
> if you use kerberos authentication, where time-of-day is important.
> 
> So, just because you haven't received any bug reports doesn't mean
> there aren't any users; there certainly are, there are problems,
> but the problems are in places other than the kernel.

... argh, I see, you're not removing 32-bit guest on 64-bit.  Ignore
the above then.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
