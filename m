Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A052C1BA62E
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 16:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgD0OTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 10:19:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33052 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728024AbgD0OTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 10:19:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587997142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=//IIDXbV7XRjpK24m7Wh2m8pTq6hYTKHqfhZLqX4Iik=;
        b=g8Uwg6WfE9yUric8ZwxaMAVJ9ppcQvYRH10QVxKfYtsd7ANsWVByy1hSSVgfCvROO7wUcr
        xoZosvZ0qYcWiiJCog43KMw5vmeewF6baFy6id4UZkqauDKUEQ9oS4GJ9nsTLrwqBozvqr
        AlAXQ4LUdnpJCjc1OZ8WVeczFDH/unU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-Zad7BFGDMceHE1Cw8nJ5Ag-1; Mon, 27 Apr 2020 10:18:58 -0400
X-MC-Unique: Zad7BFGDMceHE1Cw8nJ5Ag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81BE8928E37;
        Mon, 27 Apr 2020 14:18:46 +0000 (UTC)
Received: from x1.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E06E31002388;
        Mon, 27 Apr 2020 14:18:41 +0000 (UTC)
Date:   Mon, 27 Apr 2020 08:18:41 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "megha.dey@linux.intel.com" <megha.dey@linux.intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Lin, Jing" <jing.lin@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH RFC 00/15] Add VFIO mediated device support and IMS
 support for the idxd driver.
Message-ID: <20200427081841.18c4a994@x1.home>
In-Reply-To: <20200427132218.GG13640@mellanox.com>
References: <20200423191217.GD13640@mellanox.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D8960F9@SHSMSX104.ccr.corp.intel.com>
        <20200424124444.GJ13640@mellanox.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D8A808B@SHSMSX104.ccr.corp.intel.com>
        <20200424181203.GU13640@mellanox.com>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D8C5486@SHSMSX104.ccr.corp.intel.com>
        <20200426191357.GB13640@mellanox.com>
        <20200426214355.29e19d33@x1.home>
        <20200427115818.GE13640@mellanox.com>
        <20200427071939.06aa300e@x1.home>
        <20200427132218.GG13640@mellanox.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Apr 2020 10:22:18 -0300
Jason Gunthorpe <jgg@mellanox.com> wrote:

> On Mon, Apr 27, 2020 at 07:19:39AM -0600, Alex Williamson wrote:
> 
> > > It is not trivial masking. It is a 2000 line patch doing comprehensive
> > > emulation.  
> > 
> > Not sure what you're referring to, I see about 30 lines of code in
> > vdcm_vidxd_cfg_write() that specifically handle writes to the 4 BARs in
> > config space and maybe a couple hundred lines of code in total handling
> > config space emulation.  Thanks,  
> 
> Look around vidxd_do_command()
> 
> If I understand this flow properly..

I've only glanced at it, but that's called in response to a write to
MMIO space on the device, so it's implementing a device specific
register.  Are you asking that PCI config space be done in userspace
or any sort of device emulation?  The assumption with mdev is that we
need emulation in the host kernel because we need a trusted entity to
mediate device access and interact with privileged portion of the
device control.  Thanks,

Alex

