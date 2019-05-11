Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 811CF1A600
	for <lists+kvm@lfdr.de>; Sat, 11 May 2019 02:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbfEKA7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 May 2019 20:59:21 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:34522 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbfEKA7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 May 2019 20:59:21 -0400
Received: by mail-oi1-f195.google.com with SMTP id v10so5811788oib.1
        for <kvm@vger.kernel.org>; Fri, 10 May 2019 17:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cl42dZaKPdWPXIrbH2C5qTFgM5gCSynPhXLIFVqa36M=;
        b=JR3F2drFoXseIQNDe33GWiE73pjKGHV2B+ZvDgnMGVjCLxOFIDvA+J2M/UovbYCnvV
         YcuxiRV4p1HMaTBSOYebaH3fsVxx/ol7Wtq6ZpE6/Gk1IBXROdqbBeu5MDQMRwwVcRah
         m9Qjvj1EU8HgsmsPflXbrp5Vw906510cI+DXtJRIWjFfNagGxWdGiXAeQF1hyIkdtmMT
         32kIvIJCS08/uOxfO80bXjH93DKhiS1SMnc1m4KGF7ma2My4ftVxbek5TCV+Tx8pP9Eg
         MJhTlP53ahTMQYspd6lsWtec5GjwwOjEr4TA+HSjHeNVwNiPPO4FWDnfuEaCMgG0/X9d
         2Zaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cl42dZaKPdWPXIrbH2C5qTFgM5gCSynPhXLIFVqa36M=;
        b=XRYuKXd9rE8I74RyGdYoPAa3P1FzphV5lnkuiGVQf3rrrmALylnjpk3nDzNO0OenKN
         8t911ZPD1C0CauMy1X/Y3bHj/A9+GJh1zGqa1YIDkNPQz+L/2GDN9QlBh18g1PvDq+k0
         SDsL1zjAIhHEEdnKgvNDhU2c0AFdhS6CajaPHOJpwDWrZbTphja5XWgYhR12RgK1wPwP
         7aEkU6WAzSKMkSl7+I6+aF5aXaDXk/gIJzbg3+ThkpwtZPjWaUxMe6MTZ5J3CocFBsBQ
         Z0LJKrOWNc5phkW6A2Gl15ajBNlQvJaXo9UcgFuTytaR92IhEhYqQD3DEbrUBvq8TC6A
         qTvg==
X-Gm-Message-State: APjAAAVL6olKd1gTWS3NTKGaJiq8+5jpu8OATwhhyhAzrdfZJJGB68ot
        Sm+qJqRIFiOUdTHDqRE79FgjLf63l14kVIDnSrmsjQ==
X-Google-Smtp-Source: APXvYqxd5L2Nvbw7B4301QM480ldUecZ6yt4es0ATqbCcPph8SnTzi7vakiTbRG5uoFRT6lPjWaHfX+1q4uJu4AYewU=
X-Received: by 2002:aca:f512:: with SMTP id t18mr3998026oih.0.1557536360283;
 Fri, 10 May 2019 17:59:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190510155202.14737-1-pagupta@redhat.com> <20190510155202.14737-4-pagupta@redhat.com>
 <CAPcyv4hbVNRFSyS2CTbmO88uhnbeH4eiukAng2cxgbDzLfizwg@mail.gmail.com> <864186878.28040999.1557535549792.JavaMail.zimbra@redhat.com>
In-Reply-To: <864186878.28040999.1557535549792.JavaMail.zimbra@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 10 May 2019 17:59:08 -0700
Message-ID: <CAPcyv4gL3ODfOr52Ztgq7BM4gVf1cih6cj0271gcpVvpi9aFSA@mail.gmail.com>
Subject: Re: [PATCH v8 3/6] libnvdimm: add dax_dev sync flag
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        KVM list <kvm@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Qemu Developers <qemu-devel@nongnu.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Ross Zwisler <zwisler@kernel.org>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Christoph Hellwig <hch@infradead.org>,
        Len Brown <lenb@kernel.org>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        lcapitulino@redhat.com, Kevin Wolf <kwolf@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        jmoyer <jmoyer@redhat.com>,
        Nitesh Narayan Lal <nilal@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        david <david@fromorbit.com>, cohuck@redhat.com,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adam Borowski <kilobyte@angband.pl>,
        yuval shaia <yuval.shaia@oracle.com>, jstaron@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 10, 2019 at 5:45 PM Pankaj Gupta <pagupta@redhat.com> wrote:
>
>
>
> > >
> > > This patch adds 'DAXDEV_SYNC' flag which is set
> > > for nd_region doing synchronous flush. This later
> > > is used to disable MAP_SYNC functionality for
> > > ext4 & xfs filesystem for devices don't support
> > > synchronous flush.
> > >
> > > Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
> > > ---
> > >  drivers/dax/bus.c            |  2 +-
> > >  drivers/dax/super.c          | 13 ++++++++++++-
> > >  drivers/md/dm.c              |  3 ++-
> > >  drivers/nvdimm/pmem.c        |  5 ++++-
> > >  drivers/nvdimm/region_devs.c |  7 +++++++
> > >  include/linux/dax.h          |  8 ++++++--
> > >  include/linux/libnvdimm.h    |  1 +
> > >  7 files changed, 33 insertions(+), 6 deletions(-)
> > [..]
> > > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > > index 043f0761e4a0..ee007b75d9fd 100644
> > > --- a/drivers/md/dm.c
> > > +++ b/drivers/md/dm.c
> > > @@ -1969,7 +1969,8 @@ static struct mapped_device *alloc_dev(int minor)
> > >         sprintf(md->disk->disk_name, "dm-%d", minor);
> > >
> > >         if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
> > > -               dax_dev = alloc_dax(md, md->disk->disk_name, &dm_dax_ops);
> > > +               dax_dev = alloc_dax(md, md->disk->disk_name, &dm_dax_ops,
> > > +                                                        DAXDEV_F_SYNC);
> >
> > Apologies for not realizing this until now, but this is broken.
> > Imaging a device-mapper configuration composed of both 'async'
> > virtio-pmem and 'sync' pmem. The 'sync' flag needs to be unified
> > across all members. I would change this argument to '0' and then
> > arrange for it to be set at dm_table_supports_dax() time after
> > validating that all components support synchronous dax.
>
> o.k. Need to set 'DAXDEV_F_SYNC' flag after verifying all the target
> components support synchronous DAX.
>
> Just a question, If device mapper configuration have composed of both
> virtio-pmem or pmem devices, we want to configure device mapper for async flush?

If it's composed of both then, yes, it needs to be async flush at the
device-mapper level. Otherwise MAP_SYNC will succeed and fail to
trigger fsync on the host file when necessary for the virtio-pmem
backed portion of the device-mapper device.
