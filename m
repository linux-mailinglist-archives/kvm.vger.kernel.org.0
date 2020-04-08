Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B2F1A2709
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 18:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgDHQTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 12:19:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26419 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727486AbgDHQTx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Apr 2020 12:19:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586362791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kCxevzibCCjQEpgBkSWFcYxtyHB47IcQu6B4P94oXGg=;
        b=LPn1gW1HjxRwzG5nPOTpBsY6XXNDPo5wTdUu2NUwbBdpCkp25Vfemxq8X4bDltLXruX6Ls
        To/qY0FzhODC4XM7qNq2xmhErc/AGG8KImzx9re8u24EF4/AYfk7q35IUotaYZG4RqOHhK
        XlyLOhKws6FoeF+wx9YyGTsUeUw0QnM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-Fa7EIChmMjmVgdJqDf3j1A-1; Wed, 08 Apr 2020 12:19:49 -0400
X-MC-Unique: Fa7EIChmMjmVgdJqDf3j1A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1246801E53;
        Wed,  8 Apr 2020 16:19:47 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A90B5C1C6;
        Wed,  8 Apr 2020 16:19:41 +0000 (UTC)
Date:   Wed, 8 Apr 2020 10:19:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH v1 2/2] vfio/pci: Emulate PASID/PRI capability for VFs
Message-ID: <20200408101940.3459943d@w520.home>
In-Reply-To: <20200408040021.GS67127@otc-nc-03>
References: <1584880394-11184-1-git-send-email-yi.l.liu@intel.com>
        <1584880394-11184-3-git-send-email-yi.l.liu@intel.com>
        <20200402165954.48d941ee@w520.home>
        <A2975661238FB949B60364EF0F2C25743A2204FE@SHSMSX104.ccr.corp.intel.com>
        <20200403112545.6c115ba3@w520.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D80E13D@SHSMSX104.ccr.corp.intel.com>
        <20200407095801.648b1371@w520.home>
        <20200408040021.GS67127@otc-nc-03>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 7 Apr 2020 21:00:21 -0700
"Raj, Ashok" <ashok.raj@intel.com> wrote:

> Hi Alex
> 
> + Bjorn

 + Don

> FWIW I can't understand why PCI SIG went different ways with ATS, 
> where its enumerated on PF and VF. But for PASID and PRI its only
> in PF. 
> 
> I'm checking with our internal SIG reps to followup on that.
> 
> On Tue, Apr 07, 2020 at 09:58:01AM -0600, Alex Williamson wrote:
> > > Is there vendor guarantee that hidden registers will locate at the
> > > same offset between PF and VF config space?   
> > 
> > I'm not sure if the spec really precludes hidden registers, but the
> > fact that these registers are explicitly outside of the capability
> > chain implies they're only intended for device specific use, so I'd say
> > there are no guarantees about anything related to these registers.  
> 
> As you had suggested in the other thread, we could consider
> using the same offset as in PF, but even that's a better guess
> still not reliable.
> 
> The other option is to maybe extend driver ops in the PF to expose
> where the offsets should be. Sort of adding the quirk in the 
> implementation. 
> 
> I'm not sure how prevalent are PASID and PRI in VF devices. If SIG is resisting 
> making VF's first class citizen, we might ask them to add some verbiage
> to suggest leave the same offsets as PF open to help emulation software.

Even if we know where to expose these capabilities on the VF, it's not
clear to me how we can actually virtualize the capability itself.  If
the spec defines, for example, an enable bit as r/w then software that
interacts with that register expects the bit is settable.  There's no
protocol for "try to set the bit and re-read it to see if the hardware
accepted it".  Therefore a capability with a fixed enable bit
representing the state of the PF, not settable by the VF, is
disingenuous to the spec.

If what we're trying to do is expose that PASID and PRI are enabled on
the PF to a VF driver, maybe duplicating the PF capabilities on the VF
without the ability to control it is not the right approach.  Maybe we
need new capabilities exposing these as slave features that cannot be
controlled?  We could define our own vendor capability for this, but of
course we have both the where to put it in config space issue, as well
as the issue of trying to push an ad-hoc standard.  vfio could expose
these as device features rather than emulating capabilities, but that
still leaves a big gap between vfio in the hypervisor and the driver in
the guest VM.  That might still help push the responsibility and policy
for how to expose it to the VM as a userspace problem though.

I agree though, I don't know why the SIG would preclude implementing
per VF control of these features.  Thanks,

Alex

> > FWIW, vfio started out being more strict about restricting config space
> > access to defined capabilities, until...
> > 
> > commit a7d1ea1c11b33bda2691f3294b4d735ed635535a
> > Author: Alex Williamson <alex.williamson@redhat.com>
> > Date:   Mon Apr 1 09:04:12 2013 -0600
> >   
> 
> Cheers,
> Ashok
> 

