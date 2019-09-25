Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFC1BD78D
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 07:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411714AbfIYFGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 01:06:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56378 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411711AbfIYFGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 01:06:39 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F842307D844;
        Wed, 25 Sep 2019 05:06:39 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-47.ams2.redhat.com [10.36.116.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56A8160872;
        Wed, 25 Sep 2019 05:06:31 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 535C617535; Wed, 25 Sep 2019 07:06:29 +0200 (CEST)
Date:   Wed, 25 Sep 2019 07:06:29 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, pbonzini@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, philmd@redhat.com, lersek@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm
 machine type
Message-ID: <20190925050629.lg5w6vvikxtgddy6@sirius.home.kraxel.org>
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-8-slp@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924124433.96810-8-slp@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 25 Sep 2019 05:06:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> +microvm.kernel-cmdline=bool (Set off to disable adding virtio-mmio devices to the kernel cmdline)

Hmm, is that the long-term plan?  IMO the virtio-mmio devices should be
discoverable somehow.  ACPI, or device-tree, or fw_cfg, or ...

> +As no current FW is able to boot from a block device using virtio-mmio
> +as its transport,

To fix that the firmware must be able to find the virtio-mmio devices.

cheers,
  Gerd

