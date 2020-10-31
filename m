Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8D22A1323
	for <lists+kvm@lfdr.de>; Sat, 31 Oct 2020 03:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbgJaCur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 22:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgJaCuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 22:50:46 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98468C0613D5;
        Fri, 30 Oct 2020 19:50:46 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604112643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uApMClh8LgUA9+nJd9aotz4iVU4rrDChpNyqFIsKvVA=;
        b=BTy3lFhBX7sA4VCntMKiVzzwk15jABSRHtryuyJx0+un+EmAEDlvBnsxWJN/WlLwW0AZtf
        dgIPedgj2GGEjgGyhDuEhVmXnVNwJ6R2nQaqLpM2oQSdZsNeRblLHWV1fRJeXgirvSE5Cz
        M/U9x6HLsQuAd7grINFE+wXsybNOiFGqeZ4aI6wY5qOnfcZanCDX3DbFOa8b/cHiCtwGnJ
        QEbUT+UuCjF76GX1Eku7Ndj/2ocNBLRt5PYkolws6PuXIWsQylQzhlESmrDBr3VijobWxB
        NSMTVPCrpbQzkdGGnAWLN4CHPuD1EQy3J/h0xxtVJ008KaTYvoCn0wcg1FwESA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604112643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uApMClh8LgUA9+nJd9aotz4iVU4rrDChpNyqFIsKvVA=;
        b=A819AejM97rPxCwoMXgGJd+KHw/MTmbonbj8ZqfBkpxDATgoUcgnpq0ENP6nnXI3x/A5+P
        UiUnecA3TerRblAA==
To:     "Raj\, Ashok" <ashok.raj@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        yi.l.liu@intel.com, baolu.lu@intel.com, kevin.tian@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com, jing.lin@intel.com,
        dan.j.williams@intel.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, parav@mellanox.com, rafael@kernel.org,
        netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        Megha Dey <megha.dey@linux.intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v4 00/17] Add VFIO mediated device support and DEV-MSI support for the idxd driver
In-Reply-To: <20201030204307.GA683@otc-nc-03>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com> <20201030185858.GI2620339@nvidia.com> <c9303df4-3e57-6959-a89c-5fc98397ac70@intel.com> <20201030191706.GK2620339@nvidia.com> <20201030192325.GA105832@otc-nc-03> <20201030193045.GM2620339@nvidia.com> <20201030204307.GA683@otc-nc-03>
Date:   Sat, 31 Oct 2020 03:50:43 +0100
Message-ID: <87h7qbkt18.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ashok,

On Fri, Oct 30 2020 at 13:43, Ashok Raj wrote:
> On Fri, Oct 30, 2020 at 04:30:45PM -0300, Jason Gunthorpe wrote:
>> On Fri, Oct 30, 2020 at 12:23:25PM -0700, Raj, Ashok wrote:
>> It is a different subsystem, different maintainer, and different
>> reviewers.
>> 
>> It is a development process problem, it doesn't matter what it is
>> doing.

< skip a lot of non-sensical arguments>

> I know you aren't going to give up, but there is little we can do. I want
> the maintainers to make that call and I'm not add more noise to this.

Jason is absolutely right.

Just because there is historical precendence which does not care about
the differentiation of subsystems is not an argument at all to make the
same mistakes which have been made years ago.

IDXD is just infrastructure which provides the base for a variety of
different functionalities. Very similar to what multi function devices
provide. In fact IDXD is pretty much a MFD facility.

Sticking all of it into dmaengine is sloppy at best. The dma engine
related part of IDXD is only a part of the overall functionality.

I'm well aware that it is conveniant to just throw everything into
drivers/myturf/ but that does neither make it reviewable nor
maintainable.

What's the problem with restructuring your code in a way which makes it
fit into existing subsystems?

The whole thing - as I pointed out to Dave earlier - is based on 'works
for me' wishful thinking with a blissful ignorance of the development
process and the requirement to split a large problem into the proper
bits and pieces aka. engineering 101.

Thanks,

        tglx
