Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8D91B0DD5
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 16:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgDTOEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 10:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729547AbgDTOET (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Apr 2020 10:04:19 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42B5C061A0C;
        Mon, 20 Apr 2020 07:04:18 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id x26so5085460pgc.10;
        Mon, 20 Apr 2020 07:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=jy4gVgbbUYqO2rt1Le5nr76glIwKILe+Mz5nWHBsqjM=;
        b=uouxbw//nd9aTZSxpidFGATpCYluoYuMgRDfhpraTbSk723O0YRgM5hKBc/s4ewUAY
         iAYXcA2NrJk9THIX4YgB6WvefvXfGvWVbP01C9dJEiiIex2UZlASbW5szaxwLpbA44WQ
         cJDm22jNH6TZknJX6N8dhRvxOQKJLIDl+rMsECPHbd0hUScnG8aNE41RKpTiODpM6mV8
         HFX4gY9fuymHYgEsplWMHOxbCRxDa9AZRbtexJKkOoRB2D1Z7cDt/Q5hl2hYOya0PqJR
         y1COMLbSEzPGDMwiLDNqif/XRRUQaSQ1Wc4t23UTIxWbYplFDpf7eKRDtAQmvlHjnfqk
         CEzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=jy4gVgbbUYqO2rt1Le5nr76glIwKILe+Mz5nWHBsqjM=;
        b=RBg9mTfrjLDJi5fxw9ZfM4AsRvoZZXoHurUGZtMi23CTc0R7sGnrukFtFWb/JHGSUZ
         AtW61c7YBG1nMtTc5ckv62uRhihFBDcZFlIYMoNi4M8asZ1C8c8aNIZLF3Y2V2/BcFvl
         sN8TecvjFsMZpJZc5nRC4Cn6bbsswfD4YNYp02fHRRHwFEImAxpbyS2QJLyMlXarcM/Q
         Zg63FKKnYq0T0f9O/CvRgksh+snjGVjCHYjMIimZOhZVhqP1P7fqC3P7SsXSZG/NF7gi
         8gOod+zI/kkMqPlh909QcwW6iNSAplGMCq0LrZOSBKtP0eQE+UwN1e4jav0Qn8kqvTk1
         AuGg==
X-Gm-Message-State: AGi0PubGpDIlqN5sCNxeDoT6yajAiPCXc0XfyhGd94uh5QqZQ1LSYnjx
        rph3wPsmGlNF/CFwfOUXrqg=
X-Google-Smtp-Source: APiQypK7x2ipAVoVTFsP+Bys7u+FsKgBv39XGJ9ob8gZ6ttd6GdgBR6XVEF/C1J66eoItzGvk1ipjw==
X-Received: by 2002:a62:ed1a:: with SMTP id u26mr17026729pfh.47.1587391458282;
        Mon, 20 Apr 2020 07:04:18 -0700 (PDT)
Received: from localhost.localdomain (203-219-253-91.static.tpgi.com.au. [203.219.253.91])
        by smtp.googlemail.com with ESMTPSA id o12sm1222803pgl.87.2020.04.20.07.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 07:04:17 -0700 (PDT)
Message-ID: <76718d0c46f4638a57fd2deeeed031143599d12d.camel@gmail.com>
Subject: Re: [PATCH kernel v2 0/7] powerpc/powenv/ioda: Allow huge DMA
 window at 4GB
From:   Oliver O'Halloran <oohall@gmail.com>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        Russell Currey <ruscur@russell.cc>
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, KVM list <kvm@vger.kernel.org>,
        Alistair Popple <alistair@popple.id.au>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Date:   Tue, 21 Apr 2020 00:04:11 +1000
In-Reply-To: <9893c4db-057d-8e42-52fe-8241d6d90b5f@ozlabs.ru>
References: <20200323075354.93825-1-aik@ozlabs.ru>
         <b512ac5e-dca5-4c08-8ea1-a636b887c0d0@ozlabs.ru>
         <d5cac37a-8b32-cabf-e247-10e64f0110ab@ozlabs.ru>
         <CAOSf1CGfjX9LGQ1GDSmxrzjnaWOM3mUvBu9_xe-L2umin9n66w@mail.gmail.com>
         <CAOSf1CHgUsJ7jGokg6QD6cEDr4-o5hnyyyjRZ=YijsRY3T1sYA@mail.gmail.com>
         <b0b361092d2d7e38f753edee6dcd9222b4e388ce.camel@russell.cc>
         <9893c4db-057d-8e42-52fe-8241d6d90b5f@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2020-04-17 at 15:47 +1000, Alexey Kardashevskiy wrote:
> 
> On 17/04/2020 11:26, Russell Currey wrote:
> > 
> > For what it's worth this sounds like a good idea to me, it just sounds
> > tricky to implement.  You're adding another layer of complexity on top
> > of EEH (well, making things look simple to the EEH core and doing your
> > own freezing on top of it) in addition to the DMA handling.
> > 
> > If it works then great, just has a high potential to become a new bug
> > haven.
> 
> imho putting every PCI function to a separate PE is the right thing to
> do here but I've been told it is not that simple, and I believe that.
> Reusing slave PEs seems unreliable - the configuration will depend on
> whether a PE occupied enough segments to give an unique PE to a PCI
> function and my little brain explodes.

You're overthinking it.

If a bus has no m64 MMIO space we're free to assign whatever PE number
we want since the PE for the bus isn't fixed by the m64 segment its
BARs were placed in. For those buses we assign a PE number starting
from the max and counting down (0xff, 0xfe, etc). For example, with
this PHB:

# lspci -s 1:: -v | egrep '0001:|Memory at'
0001:00:00.0 PCI bridge: IBM Device 04c1 (prog-if 00 [Normal decode])
0001:01:00.0 PCI bridge: PLX Technology, Inc. Device 8725 (rev ca)
(prog-if 00 [Normal decode])
        Memory at 600c081000000 (32-bit, non-prefetchable) [size=256K]
0001:02:01.0 PCI bridge: PLX Technology, Inc. Device 8725 (rev ca)
(prog-if 00 [Normal decode])
0001:02:08.0 PCI bridge: PLX Technology, Inc. Device 8725 (rev ca)
(prog-if 00 [Normal decode])
0001:02:09.0 PCI bridge: PLX Technology, Inc. Device 8725 (rev ca)
(prog-if 00 [Normal decode])
0001:03:00.0 Non-Volatile memory controller: PMC-Sierra Inc. Device
f117 (rev 06) (prog-if 02 [NVM Express])
        Memory at 600c080000000 (64-bit, non-prefetchable) [size=16K]
        Memory at 6004000000000 (64-bit, prefetchable) [size=1M]
0001:09:00.0 Ethernet controller: Intel Corporation Ethernet Controller
X710/X557-AT 10GBASE-T (rev 02)
        Memory at 6004048000000 (64-bit, prefetchable) [size=8M]
        Memory at 600404a000000 (64-bit, prefetchable) [size=32K]
(redundant functions removed)

We get these PE assignments:

0001:00:00.0 - 0xfe # Root port
0001:01:00.0 - 0xfc # upstream port
0001:02:01.0 - 0xfd # downstream port bus
0001:02:08.0 - 0xfd
0001:02:09.0 - 0xfd
0001:03:00.0 - 0x0  # NVMe
0001:09:00.0 - 0x1  # Ethernet

All the switch ports either have 32bit BARs or no BARs so they get
assigned PEs starting from the top. The Ethernet and the NVMe have some
prefetchable 64bit BARs so they have to be in PE 0x0 and 0x1
respectively since that's where their m64 BARs are located. For our
DMA-only slave PEs any MMIO space would remain in their master PE so we
can allocate a PE number for the DMA-PE (our iommu context).

I think the key thing to realise is that we'd only be using the DMA-PE
when a crippled DMA mask is set by the driver. In all other cases we
can just use the "native PE" and when the driver unbinds we can de-
allocate our DMA-PE and return the device to the PE containing it's
MMIO BARs. I think we can keep things relatively sane that way and the
real issue is detecting EEH events on the DMA-PE.

On P9 we don't have PHB error interrupts enabled in firmware so we're
completely reliant on seeing a 0xFF response to an MMIO and manually
checking the PE status to see if it's due to a PE freeze. For our DMA-
PE it could be frozen (due to a bad DMA) and we'd never notice unless
we explicitly check the status of the DMA-PE since there's no
corresponding MMIO space to freeze.

On P8 we had PHB Error interrupts so you would notice that *something*
happened, then go check for frozen PEs, at which point the master-slave 
grouping logic would see that one PE in the group was frozen and freeze
the rest of them. We can re-use that on that, but we still need
something to actually notice a freeze occured. A background poller
checking for freezes on each PE might do the trick.

> So this is not happening soon.

Oh ye of little faith.

> For the time being, this patchset is good for:
> 1. weird hardware which has limited DMA mask (this is why the patchset
> was written in the first place)
> 2. debug DMA by routing it via IOMMU (even when 4GB hack is not enabled).

Sure, but it's still dependent on having firmware which supports the
4GB hack and I don't think that's in any offical firmware releases yet.

Oliver

