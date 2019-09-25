Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9939EBDAAD
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 11:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388567AbfIYJMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 05:12:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36256 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388537AbfIYJMf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 05:12:35 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 784043B77;
        Wed, 25 Sep 2019 09:12:35 +0000 (UTC)
Received: from sirius.home.kraxel.org (ovpn-116-47.ams2.redhat.com [10.36.116.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C55D261559;
        Wed, 25 Sep 2019 09:12:26 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id CABB99D69; Wed, 25 Sep 2019 11:12:25 +0200 (CEST)
Date:   Wed, 25 Sep 2019 11:12:25 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sergio Lopez <slp@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org,
        mst@redhat.com, imammedo@redhat.com, marcel.apfelbaum@gmail.com,
        rth@twiddle.net, ehabkost@redhat.com, philmd@redhat.com,
        lersek@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        Pankaj Gupta <pagupta@redhat.com>
Subject: Re: [PATCH v4 0/8] Introduce the microvm machine type
Message-ID: <20190925091225.bx4c4x2o6qgydidj@sirius.home.kraxel.org>
References: <20190924124433.96810-1-slp@redhat.com>
 <c689e275-1a05-7d08-756b-0be914ed24ca@redhat.com>
 <87h850ssnb.fsf@redhat.com>
 <b361be48-d490-ac6a-4b54-d977c20539c0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b361be48-d490-ac6a-4b54-d977c20539c0@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 25 Sep 2019 09:12:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> If you want to add hotplug to microvm, you can reuse the existing code
> for CPU and memory hotplug controllers, and write drivers for them in
> Linux's drivers/platform.  The drivers would basically do what the ACPI
> AML tells the interpreter to do.

How would the linux kernel detect those devices?

I guess that wouldn't be ACPI, seems everyone wants avoid it[1].

So device tree on x86?  Something else?

cheers,
  Gerd

[1] Not clear to me why, some minimal ACPI tables listing our
    devices (isa-serial, fw_cfg, ...) doesn't look unreasonable
    to me.  We could also make virtio-mmio discoverable that way.
    Also we could do acpi cpu hotplug without having to write those
    linux platform drivers.  We would need a sysbus-acpi device though,
    but given that most acpi code is already separated out so piix and
    q35 can share it it should not be that hard to wire up.
