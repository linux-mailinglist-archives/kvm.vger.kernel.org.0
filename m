Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7221AB608
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 04:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389107AbgDPCx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 22:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732153AbgDPCxw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 22:53:52 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE670C061A0C;
        Wed, 15 Apr 2020 19:53:52 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id i3so19460477ioo.13;
        Wed, 15 Apr 2020 19:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ngCJzKY2ZnK49mg2jGGljIlU1JbhJIlV2lpEN9jKoEY=;
        b=llwmz87toXGIOJuYxhv2PIFwORKPaThTINL2NoVuCVqGaUmUA7pHFbF1rmjk9A1JXB
         AI0YubGcI81uNFct+Yp0Gb3pda/Bf3jclSTgLX22rnpeFyXAKZCpPLYs0POU986neGo4
         3N6qqN1MfvpfobDHU79UymqFKqj8xgcZMP/KMP36Zf5U/aCYN2bLkVSzIq2dN/1qjmH3
         B0MIbEZE8i/0s239U34M4Dz5ifPdCbbbK635AsDenm+h0D/Or/K2SnCCnwKfCKgWkAmJ
         DwRM+kxpaQTTmkBvlsGhbF0eQvqq16B8bUlHTJFCIO3YuVDQ1X1SJpbF/b+ox/nSnQGg
         RzOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ngCJzKY2ZnK49mg2jGGljIlU1JbhJIlV2lpEN9jKoEY=;
        b=E1OUMgn5X0SIKU5jD0oDX3HAVd4xbw2HxDShfSL4KmzrwboDNiqWhCkq2xd4aVXu+y
         ozXlZu/2Kf1BBfgJluROI1EshsgqIsJ+9+4xoVWIpysvFQG8bDlksH0WR7yZ+CCUPOV2
         bAbpcDQmE5nNYeF0TvBdXXxbs2gIuAMxVkk9TFac9uBopaeseOvNc7aFynyaa2Y4pdrC
         irzDD8xjQKnAjJCBQSx2bmc16lKbiRcqn4zcliGiPtRoy3yIKHViUOCklc+unj9SiKSB
         nIol6Nkjqk4ZEP3nXTQqxLK3xGDOKygkkNmyOgW1JjAI7hCJyuMza8V9CKEFOoRQqY+m
         eF3w==
X-Gm-Message-State: AGi0PuaROSsxvHXUp/ElO3ZGFxkGcNQvW/sx3dWRRZLipNNyBwb5hWD0
        6vTuhb0sUlmN6PN35+TuYcHCp/5qwFQsKbM5fno9HQ==
X-Google-Smtp-Source: APiQypKEW4cirP40WWh9h1+FSf8l8r3Na2muRxXULAy1/Sjlj4eHqzxNeFysW4pqxEPNPnQTWbu3Zrsw8Id3VqS3cjY=
X-Received: by 2002:a6b:7903:: with SMTP id i3mr30104932iop.66.1587005632207;
 Wed, 15 Apr 2020 19:53:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200323075354.93825-1-aik@ozlabs.ru> <b512ac5e-dca5-4c08-8ea1-a636b887c0d0@ozlabs.ru>
 <d5cac37a-8b32-cabf-e247-10e64f0110ab@ozlabs.ru> <CAOSf1CGfjX9LGQ1GDSmxrzjnaWOM3mUvBu9_xe-L2umin9n66w@mail.gmail.com>
In-Reply-To: <CAOSf1CGfjX9LGQ1GDSmxrzjnaWOM3mUvBu9_xe-L2umin9n66w@mail.gmail.com>
From:   "Oliver O'Halloran" <oohall@gmail.com>
Date:   Thu, 16 Apr 2020 12:53:41 +1000
Message-ID: <CAOSf1CHgUsJ7jGokg6QD6cEDr4-o5hnyyyjRZ=YijsRY3T1sYA@mail.gmail.com>
Subject: Re: [PATCH kernel v2 0/7] powerpc/powenv/ioda: Allow huge DMA window
 at 4GB
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, KVM list <kvm@vger.kernel.org>,
        Alistair Popple <alistair@popple.id.au>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Russell Currey <ruscur@russell.cc>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 16, 2020 at 12:34 PM Oliver O'Halloran <oohall@gmail.com> wrote:
>
> On Thu, Apr 16, 2020 at 11:27 AM Alexey Kardashevskiy <aik@ozlabs.ru> wrote:
> >
> > Anyone? Is it totally useless or wrong approach? Thanks,
>
> I wouldn't say it's either, but I still hate it.
>
> The 4GB mode being per-PHB makes it difficult to use unless we force
> that mode on 100% of the time which I'd prefer not to do. Ideally
> devices that actually support 64bit addressing (which is most of them)
> should be able to use no-translate mode when possible since a) It's
> faster, and b) It frees up room in the TCE cache devices that actually
> need them. I know you've done some testing with 100G NICs and found
> the overhead was fine, but IMO that's a bad test since it's pretty
> much the best-case scenario since all the devices on the PHB are in
> the same PE. The PHB's TCE cache only hits when the TCE matches the
> DMA bus address and the PE number for the device so in a multi-PE
> environment there's a lot of potential for TCE cache trashing. If
> there was one or two PEs under that PHB it's probably not going to
> matter, but if you have an NVMe rack with 20 drives it starts to look
> a bit ugly.
>
> That all said, it might be worth doing this anyway since we probably
> want the software infrastructure in place to take advantage of it.
> Maybe expand the command line parameters to allow it to be enabled on
> a per-PHB basis rather than globally.

Since we're on the topic

I've been thinking the real issue we have is that we're trying to pick
an "optimal" IOMMU config at a point where we don't have enough
information to work out what's actually optimal. The IOMMU config is
done on a per-PE basis, but since PEs may contain devices with
different DMA masks (looking at you wierd AMD audio function) we're
always going to have to pick something conservative as the default
config for TVE#0 (64k, no bypass mapping) since the driver will tell
us what the device actually supports long after the IOMMU configuation
is done. What we really want is to be able to have separate IOMMU
contexts for each device, or at the very least a separate context for
the crippled devices.

We could allow a per-device IOMMU context by extending the Master /
Slave PE thing to cover DMA in addition to MMIO. Right now we only use
slave PEs when a device's MMIO BARs extend over multiple m64 segments.
When that happens an MMIO error causes the PHB to freezes the PE
corresponding to one of those segments, but not any of the others. To
present a single "PE" to the EEH core we check the freeze status of
each of the slave PEs when the EEH core does a PE status check and if
any of them are frozen, we freeze the rest of them too. When a driver
sets a limited DMA mask we could move that device to a seperate slave
PE so that it has it's own IOMMU context taylored to its DMA
addressing limits.

Thoughts?

Oliver
