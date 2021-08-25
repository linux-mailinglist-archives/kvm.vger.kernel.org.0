Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E3D3F6CEF
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 03:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhHYBLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 21:11:40 -0400
Received: from mx20.baidu.com ([111.202.115.85]:47732 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229539AbhHYBLj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 21:11:39 -0400
Received: from BC-Mail-Ex12.internal.baidu.com (unknown [172.31.51.52])
        by Forcepoint Email with ESMTPS id F4223A21B6EAF994E779;
        Wed, 25 Aug 2021 09:10:51 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex12.internal.baidu.com (172.31.51.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Wed, 25 Aug 2021 09:10:51 +0800
Received: from localhost (172.31.63.8) by BJHW-MAIL-EX27.internal.baidu.com
 (10.127.64.42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 25
 Aug 2021 09:10:51 +0800
Date:   Wed, 25 Aug 2021 09:10:50 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        <farman@linux.ibm.com>, <cohuck@redhat.com>
CC:     <linux-s390@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] vfio-pci/zdev: Remove repeated verbose license text
Message-ID: <20210825011050.GA2079@LAPTOP-UKSR4ENP.internal.baidu.com>
References: <20210824003749.1039-1-caihuoqing@baidu.com>
 <d2e299fb-c636-ea1d-a523-c0e842e0d9e6@linux.ibm.com>
 <20210824101805.028a0011.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210824101805.028a0011.alex.williamson@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex08.internal.baidu.com (10.127.64.18) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24 Aug 21 10:18:05, Alex Williamson wrote:
> On Tue, 24 Aug 2021 11:52:11 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
> > On 8/23/21 8:37 PM, Cai Huoqing wrote:
> > > remove it because SPDX-License-Identifier is already used
> > > and change "GPL-2.0+" to "GPL-2.0-only"  
> > 
> > Could maybe extend the commit message a little to add something along 
> > the lines of ' to match the more restrictive license that was specified 
> > by the verbose text being removed.', so as to explain why the identifier 
> > is being changed here.
> > 
> > With that,
> > 
> > Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 
> Agreed, I'd propose changing it to:
> 
>   The SPDX and verbose license text are redundant, however in this case
>   the verbose license indicates a GPL v2 only while SPDX specifies v2+.
>   Remove the verbose license and correct SPDX to the more restricted
>   version.
> 
> I can update on commit unless Cai wishes to respin with different
> wording.  Thanks,
> 
> Alex
Thanks, feel free to do it, you're awesome.

Cai
> 
> > > Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> > > ---
> > > v1->v2: change "GPL-2.0+" to "GPL-2.0-only"
> > > 
> > >   drivers/vfio/pci/vfio_pci_zdev.c | 7 +------
> > >   1 file changed, 1 insertion(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> > > index 7b011b62c766..104fcf6658db 100644
> > > --- a/drivers/vfio/pci/vfio_pci_zdev.c
> > > +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> > > @@ -1,15 +1,10 @@
> > > -// SPDX-License-Identifier: GPL-2.0+
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > >   /*
> > >    * VFIO ZPCI devices support
> > >    *
> > >    * Copyright (C) IBM Corp. 2020.  All rights reserved.
> > >    *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
> > >    *                 Matthew Rosato <mjrosato@linux.ibm.com>
> > > - *
> > > - * This program is free software; you can redistribute it and/or modify
> > > - * it under the terms of the GNU General Public License version 2 as
> > > - * published by the Free Software Foundation.
> > > - *
> > >    */
> > >   #include <linux/io.h>
> > >   #include <linux/pci.h>
> > >   
> > 
> 
