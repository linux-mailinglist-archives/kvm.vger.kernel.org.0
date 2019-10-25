Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAF5E48FD
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 12:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502780AbfJYKyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 06:54:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:42762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502766AbfJYKyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 06:54:21 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E045621929;
        Fri, 25 Oct 2019 10:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572000860;
        bh=jjn8O1fddhIJx8i6+ifmbnuM77N9ePQrNyFvwOWY57U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EcAY83h2xusU+VLo9oXK6DO+Rf44eghHHOnM02fWS+QXE2uN3R/oA1PBVVi/2D/mf
         3lixdn9607C+Aj3dLMOmrpAmgEekZC2HZtEG8lnVu+xSqFQ8lYh3z5nbl0Z1IMHgel
         uzw+ACkaDfTcwUUhdkBd+s2+JEKE9LDR6X6aBfPI=
Date:   Fri, 25 Oct 2019 11:54:16 +0100
From:   Will Deacon <will@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool] virtio: Ensure virt_queue is always initialised
Message-ID: <20191025105415.GB9746@willie-the-truck>
References: <20191010142852.15437-1-will@kernel.org>
 <20191025114100.70238d61@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025114100.70238d61@donnerap.cambridge.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 25, 2019 at 11:41:00AM +0100, Andre Przywara wrote:
> On Thu, 10 Oct 2019 15:28:52 +0100
> Will Deacon <will@kernel.org> wrote:
> > Failing to initialise the virt_queue via virtio_init_device_vq() leaves,
> > amongst other things, the endianness unspecified. On arm/arm64 this
> > results in virtio_guest_to_host_uxx() treating the queue as big-endian
> > and trying to translate bogus addresses:
> > 
> >   Warning: unable to translate guest address 0x80b8249800000000 to host
> 
> Ouch, a user! ;-)
> 
> > Ensure the virt_queue is always initialised by the virtio device during
> > setup.
> 
> Indeed, this is also what the other virtio devices do.
> Confirmed to fix rng and balloon.
> 
> Thanks for spotting this!
> 
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Tested-by: Andre Przywara <andre.przywara@arm.com>

Cheers, Andre. Now pushed with your tags.

Will
