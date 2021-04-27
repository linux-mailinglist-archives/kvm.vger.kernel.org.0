Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A2536C782
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 16:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbhD0OH0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 27 Apr 2021 10:07:26 -0400
Received: from mail.savoirfairelinux.com ([208.88.110.44]:50842 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236074AbhD0OH0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 10:07:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 7D1749C1498;
        Tue, 27 Apr 2021 10:06:41 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 5_2dxyO4_oUn; Tue, 27 Apr 2021 10:06:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id EB6E19C14A7;
        Tue, 27 Apr 2021 10:06:39 -0400 (EDT)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LVTXpMiwd0MI; Tue, 27 Apr 2021 10:06:39 -0400 (EDT)
Received: from barbarian (unknown [192.168.51.254])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id CAF099C1498;
        Tue, 27 Apr 2021 10:06:39 -0400 (EDT)
Message-ID: <878b461c295c084aa7152b56668b3e61aa78f744.camel@savoirfairelinux.com>
Subject: Re: [PATCH] uio: uio_pci_generic: add memory mappings
From:   firas ashkar <firas.ashkar@savoirfairelinux.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 27 Apr 2021 10:06:39 -0400
In-Reply-To: <YIetS88K/xLGHlXB@kroah.com>
References: <20210426190346.173919-1-firas.ashkar@savoirfairelinux.com>
         <YIetS88K/xLGHlXB@kroah.com>
Organization: SavoirFaireLinux
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
The reason for these extra changes is the result of running 
fashkar@barbarian:~/Downloads/linux_mainline$ clang-format -style=file
-i drivers/uio/uio_pci_generic.c

fashkar@barbarian:~/Downloads/linux_mainline$ ./scripts/checkpatch.pl
0001-uio-uio_pci_generic-add-memory-mappings.patch

i shall undo those changes and retry again, ty
-- 
Firas Ashkar
Developpeur Système Embarqué

savoirfairelinux.com  | Montréal, Québec

Tél.: +1 514 276 5468 ext. 118



          

On Tue, 2021-04-27 at 08:20 +0200, Greg KH wrote:
> On Mon, Apr 26, 2021 at 03:03:46PM -0400, Firas Ashkar wrote:
> > import memory resources from underlying pci device, thus allowing
> > userspace applications to memory map those resources.
> 
> You also did other things in this patch that have nothing to do with
> this change, why?
> 
> Always describe what your patch does properly, otherwise we have to
> ignore it.
> 
> > Signed-off-by: Firas Ashkar <firas.ashkar@savoirfairelinux.com>
> > ---
> > :100644 100644 c7d681fef198 809eca95b5bb M	drivers/uio/uio_pci_gen
> > eric.c
> >  drivers/uio/uio_pci_generic.c | 52 +++++++++++++++++++++++++++++
> > ------
> >  1 file changed, 43 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/uio/uio_pci_generic.c
> > b/drivers/uio/uio_pci_generic.c
> > index c7d681fef198..809eca95b5bb 100644
> > --- a/drivers/uio/uio_pci_generic.c
> > +++ b/drivers/uio/uio_pci_generic.c
> > @@ -24,9 +24,9 @@
> >  #include <linux/slab.h>
> >  #include <linux/uio_driver.h>
> >  
> > -#define DRIVER_VERSION	"0.01.0"
> > -#define DRIVER_AUTHOR	"Michael S. Tsirkin <mst@redhat.com>"
> > -#define DRIVER_DESC	"Generic UIO driver for PCI 2.3
> > devices"
> > +#define DRIVER_VERSION "0.01.0"
> > +#define DRIVER_AUTHOR "Michael S. Tsirkin <mst@redhat.com>"
> > +#define DRIVER_DESC "Generic UIO driver for PCI 2.3 devices"
> 
> Like this, why change these lines???
> 
> thanks,
> 
> greg k-h

