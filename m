Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B7D1BB7B6
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 09:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgD1HfI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 03:35:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726800AbgD1HfF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 03:35:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C72F0206B9;
        Tue, 28 Apr 2020 07:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588059303;
        bh=IAwY+0Nh3EkxxXHtSahpYzrED4Rl8r+8ekoqfkVKb/0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oZDYROcDt/z2hNKXF24FZRVWFw/iV17GPFpXarq4tvPeCBQyL+ns9y5VzPlfMGqYd
         s2hp8hQIBz9WYApD+atCrE3vYXR1rMcyjn05BNKspBQn72xPop6y115/ZPZkEKMGQn
         50YnTSqionB3NEYZKPwRCPjHicWPXB+inBFdAC+8=
Date:   Tue, 28 Apr 2020 09:34:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     vkoul@kernel.org, megha.dey@linux.intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 01/15] drivers/base: Introduce platform_msi_ops
Message-ID: <20200428073458.GB994208@kroah.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <158751203294.36773.11436842117908325764.stgit@djiang5-desk3.ch.intel.com>
 <20200426070118.GA2083720@kroah.com>
 <4223511b-8dc0-33d1-6af1-831d8bf40b3d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4223511b-8dc0-33d1-6af1-831d8bf40b3d@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 02:38:12PM -0700, Dave Jiang wrote:
> 
> 
> On 4/26/2020 12:01 AM, Greg KH wrote:
> > On Tue, Apr 21, 2020 at 04:33:53PM -0700, Dave Jiang wrote:
> > > From: Megha Dey <megha.dey@linux.intel.com>
> > > 
> > > This is a preparatory patch to introduce Interrupt Message Store (IMS).
> > > 
> > > Until now, platform-msi.c provided a generic way to handle non-PCI MSI
> > > interrupts. Platform-msi uses its parent chip's mask/unmask routines
> > > and only provides a way to write the message in the generating device.
> > > 
> > > Newly creeping non-PCI complaint MSI-like interrupts (Intel's IMS for
> > > instance) might need to provide a device specific mask and unmask callback
> > > as well, apart from the write function.
> > > 
> > > Hence, introduce a new structure platform_msi_ops, which would provide
> > > device specific write function as well as other device specific callbacks
> > > (mask/unmask).
> > > 
> > > Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
> > 
> > As this is not following the Intel-specific rules for sending me new
> > code, I am just deleting it all from my inbox.
> 
> That is my fault. As the aggregator of the patches, I should've signed off
> Megha's patches.

That is NOT the Intel-specific rules I am talking about.  Please go work
with the "Linux group" at Intel to find out what I am referring to, they
know what I mean.

The not-signing-off is just a normal kernel community rule, everyone has
to follow that.

greg k-h
