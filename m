Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA9B5E6A2F
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 19:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbiIVR7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 13:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbiIVR7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 13:59:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2962106F51
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663869539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cQKtQ+HLjF1KR9C7lW/Z2uYSrTGWjqEhSeykoOqm/6o=;
        b=ahwcURY/xJnV6/hG2MOwqw9Wltda4JK0LJ9issbtRuLAJEj77yNVGHig+G8vAP6+gxX6Kt
        7cPbzOtUiQOGtrxPT4Is8pDwlnuI2+6BIPr7MYo54b4h2eXtt9jdEkMCZKXA9tjfqBe3bV
        njZ8mwzFjkJpWFEcMUtG8r4kRkZjTFo=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-549-_U1vVXeTP3uk23PLBgpMsg-1; Thu, 22 Sep 2022 13:58:58 -0400
X-MC-Unique: _U1vVXeTP3uk23PLBgpMsg-1
Received: by mail-il1-f197.google.com with SMTP id h10-20020a92c26a000000b002f57c5ac7dbso6121887ild.15
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:58:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=cQKtQ+HLjF1KR9C7lW/Z2uYSrTGWjqEhSeykoOqm/6o=;
        b=LA5uhjx8jBXOUcV5jZmKInu/260OhrL9eEuzYUuP24c4stgqzU/1TOaELAMtm1ytCH
         bGfjDrki9MFyJUCHJPi2RWTWYK/rXMWCK0GAM2s1JXiR+RmTatlwD413vYq+F4JoJ6RO
         bbDGSGRrPIsaCqSDaWTqrIatMeljFTEVScHC82w/4bZV2jf8kwfr1XJNJJfhBFjwrn1X
         5TNGJAiBThKy5wC/QtTe3OpNqLZYdOqprgonjW+Yj/SIDnqlWmaPCxvlGGaTBseB60FP
         FeFrfPyjkWqf7gbTJIHfIlzYFykTk6eeKN5fpLKUujaRqli29YfrjVKjcIPoQm/C+VTp
         UODA==
X-Gm-Message-State: ACrzQf2w0H8m1wHTu6MPnGzIvKdVrfmoyW1bYMIfyy8KcDLMGZD5YQgv
        iwxPqThW2iUXUZEkHCDUqH5FPyyygrTU29c+UXauk1xuRl6yG4nGde2/+4np99gw5k1NeJ/FFOw
        h9dC2AuRNkQHw
X-Received: by 2002:a92:c56c:0:b0:2f5:ab59:55fe with SMTP id b12-20020a92c56c000000b002f5ab5955femr2463332ilj.23.1663869537591;
        Thu, 22 Sep 2022 10:58:57 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5vJfSW6oj1MkF6lJ22r5jWfL0Aw0/dAeBfXfItZsGoo76YrwXUqu4tvsqrX7RM9DJoGcIksw==
X-Received: by 2002:a92:c56c:0:b0:2f5:ab59:55fe with SMTP id b12-20020a92c56c000000b002f5ab5955femr2463329ilj.23.1663869537408;
        Thu, 22 Sep 2022 10:58:57 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a3-20020a021603000000b0034a5993e1b5sm2366997jaa.113.2022.09.22.10.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 10:58:57 -0700 (PDT)
Date:   Thu, 22 Sep 2022 11:58:56 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] vfio: Split the container code into a clean
 layer and dedicated file
Message-ID: <20220922115856.14361e1b.alex.williamson@redhat.com>
In-Reply-To: <YyyZuwjmeOxEjh7e@nvidia.com>
References: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
        <BN9PR11MB527613A28174EBE5450B4A218C4F9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <Yyuzrqe8PocywMld@nvidia.com>
        <20220922110930.0beadbc3.alex.williamson@redhat.com>
        <YyyZuwjmeOxEjh7e@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 22 Sep 2022 14:22:03 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Sep 22, 2022 at 11:09:30AM -0600, Alex Williamson wrote:
> > On Wed, 21 Sep 2022 22:00:30 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Wed, Sep 21, 2022 at 08:07:42AM +0000, Tian, Kevin wrote:  
> > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Sent: Wednesday, September 21, 2022 8:42 AM
> > > > >  drivers/vfio/Makefile    |   1 +
> > > > >  drivers/vfio/container.c | 680 +++++++++++++++++++++++++++++++++++++
> > > > >  drivers/vfio/vfio.h      |  56 ++++
> > > > >  drivers/vfio/vfio_main.c | 708 ++-------------------------------------
> > > > >  4 files changed, 765 insertions(+), 680 deletions(-)
> > > > >  create mode 100644 drivers/vfio/container.c
> > > > > 
> > > > > 
> > > > > base-commit: 245898eb9275ce31942cff95d0bdc7412ad3d589    
> > > > 
> > > > it's not the latest vfio/next:    
> > > 
> > > Ah, I did the rebase before I left for lpc..
> > > 
> > > There is a minor merge conflict with the stuff from the last week:
> > > 
> > > diff --cc drivers/vfio/Makefile
> > > index d67c604d0407ef,d5ae6921eb4ece..00000000000000
> > > --- a/drivers/vfio/Makefile
> > > +++ b/drivers/vfio/Makefile
> > > @@@ -1,11 -1,10 +1,12 @@@
> > >   # SPDX-License-Identifier: GPL-2.0
> > >   vfio_virqfd-y := virqfd.o
> > >   
> > >  -vfio-y += container.o
> > >  -vfio-y += vfio_main.o
> > >  -
> > >   obj-$(CONFIG_VFIO) += vfio.o
> > >  +
> > >  +vfio-y += vfio_main.o \
> > >  +        iova_bitmap.o \
> > > ++        container.o
> > >  +
> > >   obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
> > >   obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
> > >   obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> > > 
> > > Alex, let me know if you want me to respin it  
> > 
> > That's trivial, but you also have conflicts with Kevin's 'Tidy up
> > vfio_device life cycle' series, which gets uglier than I'd like to
> > fixup on commit.  Could one of you volunteer to rebase on the other?  
> 
> Sure, I'll rebase this one, can you pick up Kevin's so I have a stable target?


Yup, you should see it in my next branch now.  Thanks,

Alex

