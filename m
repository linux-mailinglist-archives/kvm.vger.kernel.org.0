Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4690E3A769C
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 07:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbhFOFvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 01:51:06 -0400
Received: from verein.lst.de ([213.95.11.211]:47299 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhFOFvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 01:51:04 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2547D67373; Tue, 15 Jun 2021 07:48:57 +0200 (CEST)
Date:   Tue, 15 Jun 2021 07:48:56 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [PATCH 02/10] driver core: Better distinguish probe errors in
 really_probe
Message-ID: <20210615054856.GA21080@lst.de>
References: <20210614150846.4111871-1-hch@lst.de> <20210614150846.4111871-3-hch@lst.de> <YMg39xWiesZzjVUr@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMg39xWiesZzjVUr@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 07:17:43AM +0200, Greg Kroah-Hartman wrote:
> Like Kirti said, 0 needs to be handled here.  Did this not spew a lot of
> warnings in the logs?

Trying again it did.  But I didn't even notice given all the crap
printed during a typical boot these days..
