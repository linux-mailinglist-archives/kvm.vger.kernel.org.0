Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D013F6295
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 18:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbhHXQS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 12:18:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231437AbhHXQS4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 12:18:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629821891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bJabbqkNupKTThGjFKf2rBjQIQEbUXnIAkBWwJDSMks=;
        b=ZITjXU5JvM3m8fG8Bq4bT85M1Sq2gn1I8zcGpczztwdPozroha/5W+xh8+3YDh0gk76FIQ
        xgnysbOiT6WNQCG2qllSaUNpAsXy0XxK/cqZiO/9hIezSgfc9IKzXT4lVeLqyKMk4Ln5Df
        uNolXyoBOPuF1lRZ9CB20mqOXkK6G80=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-k92hKIaAOg6yo6hUenEl6w-1; Tue, 24 Aug 2021 12:18:09 -0400
X-MC-Unique: k92hKIaAOg6yo6hUenEl6w-1
Received: by mail-io1-f69.google.com with SMTP id n189-20020a6b8bc6000000b005b92c64b625so11074804iod.20
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 09:18:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bJabbqkNupKTThGjFKf2rBjQIQEbUXnIAkBWwJDSMks=;
        b=JQfu/Z5+GvCzv45RejaRANxSmiBHdb2raZtV8wKrfDmSRZ2biHwQjJCzbLZi21FtwO
         MrJQlFNK5JWs70NI+aq1HbbB7CQGpGHb/REzfa3a9Lu48kUHIgCD7Af+KUSGZGUxBuvi
         qp5EiVxLMPW1rRYU6x2XvXVbE1U4P6dZUra6nOtHUUvQMHeEKRqcGoe3zSoilTgjJ002
         1pMC4tF9qLgneO4/Q/waeGCneyQTDvoFYCrCdc8MShtyhdK+91WRN28a72+OsSrB5RY3
         0XqJlrWmCntwDM4vS16KXnUQ06Cy+a6Q4dZCmdthGc3m821vD+pGvKj0TQqlw3mHvaI2
         eAYw==
X-Gm-Message-State: AOAM531clS1udBJbbEo8/Dfbk3ZRYlXLirVYnsZDjhgm796FFSerxqRH
        dsokX1uV3EOceTdLO/1JdcsNaE646+sLty3cLHxOh2irXOSUFg7rnV9G/waiXit2QZXSAUgOPJU
        hTQXbfLZMI8W6
X-Received: by 2002:a5d:8710:: with SMTP id u16mr13582506iom.62.1629821889010;
        Tue, 24 Aug 2021 09:18:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwice9wMKOTJEhk94fUGvO1ox0iAV2gbWgv+fyeX4ypPIlF3s4RP/BFcStnTfghdPYRVxKqrg==
X-Received: by 2002:a5d:8710:: with SMTP id u16mr13582489iom.62.1629821888821;
        Tue, 24 Aug 2021 09:18:08 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id s16sm10156290iln.5.2021.08.24.09.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 09:18:08 -0700 (PDT)
Date:   Tue, 24 Aug 2021 10:18:05 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Cai Huoqing <caihuoqing@baidu.com>, farman@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2] vfio-pci/zdev: Remove repeated verbose license text
Message-ID: <20210824101805.028a0011.alex.williamson@redhat.com>
In-Reply-To: <d2e299fb-c636-ea1d-a523-c0e842e0d9e6@linux.ibm.com>
References: <20210824003749.1039-1-caihuoqing@baidu.com>
        <d2e299fb-c636-ea1d-a523-c0e842e0d9e6@linux.ibm.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Aug 2021 11:52:11 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 8/23/21 8:37 PM, Cai Huoqing wrote:
> > remove it because SPDX-License-Identifier is already used
> > and change "GPL-2.0+" to "GPL-2.0-only"  
> 
> Could maybe extend the commit message a little to add something along 
> the lines of ' to match the more restrictive license that was specified 
> by the verbose text being removed.', so as to explain why the identifier 
> is being changed here.
> 
> With that,
> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>

Agreed, I'd propose changing it to:

  The SPDX and verbose license text are redundant, however in this case
  the verbose license indicates a GPL v2 only while SPDX specifies v2+.
  Remove the verbose license and correct SPDX to the more restricted
  version.

I can update on commit unless Cai wishes to respin with different
wording.  Thanks,

Alex

> > Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> > ---
> > v1->v2: change "GPL-2.0+" to "GPL-2.0-only"
> > 
> >   drivers/vfio/pci/vfio_pci_zdev.c | 7 +------
> >   1 file changed, 1 insertion(+), 6 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
> > index 7b011b62c766..104fcf6658db 100644
> > --- a/drivers/vfio/pci/vfio_pci_zdev.c
> > +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> > @@ -1,15 +1,10 @@
> > -// SPDX-License-Identifier: GPL-2.0+
> > +// SPDX-License-Identifier: GPL-2.0-only
> >   /*
> >    * VFIO ZPCI devices support
> >    *
> >    * Copyright (C) IBM Corp. 2020.  All rights reserved.
> >    *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
> >    *                 Matthew Rosato <mjrosato@linux.ibm.com>
> > - *
> > - * This program is free software; you can redistribute it and/or modify
> > - * it under the terms of the GNU General Public License version 2 as
> > - * published by the Free Software Foundation.
> > - *
> >    */
> >   #include <linux/io.h>
> >   #include <linux/pci.h>
> >   
> 

