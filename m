Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85161B8D1F
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 09:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgDZHBW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Apr 2020 03:01:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgDZHBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Apr 2020 03:01:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6DBD20700;
        Sun, 26 Apr 2020 07:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587884481;
        bh=gDlxekB/2N2vqpIddLrHidD79tcnpmMBQVDOhy4Z6BU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qXrgwMg0f9dUvourwVLSx7FE5mTQiqT6tSylKLvlVlbe3ywGngs9gaWmn7i+THwzG
         tWgN29BdSYwtnemcyLmKIQcIU7ZQ3xfSYvWe9bUCL2ARAWHtzrlf6y1JVdcTICEmgA
         qfhGACT4iidV7YzOU/OVTh6kMtavESsiZ7k7cinE=
Date:   Sun, 26 Apr 2020 09:01:18 +0200
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
Message-ID: <20200426070118.GA2083720@kroah.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com>
 <158751203294.36773.11436842117908325764.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158751203294.36773.11436842117908325764.stgit@djiang5-desk3.ch.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 21, 2020 at 04:33:53PM -0700, Dave Jiang wrote:
> From: Megha Dey <megha.dey@linux.intel.com>
> 
> This is a preparatory patch to introduce Interrupt Message Store (IMS).
> 
> Until now, platform-msi.c provided a generic way to handle non-PCI MSI
> interrupts. Platform-msi uses its parent chip's mask/unmask routines
> and only provides a way to write the message in the generating device.
> 
> Newly creeping non-PCI complaint MSI-like interrupts (Intel's IMS for
> instance) might need to provide a device specific mask and unmask callback
> as well, apart from the write function.
> 
> Hence, introduce a new structure platform_msi_ops, which would provide
> device specific write function as well as other device specific callbacks
> (mask/unmask).
> 
> Signed-off-by: Megha Dey <megha.dey@linux.intel.com>

As this is not following the Intel-specific rules for sending me new
code, I am just deleting it all from my inbox.

Please follow the rules you all have been given, they are specific and
there for a reason.  And in looking at this code, those rules are not
going away any time soon.

greg k-h
