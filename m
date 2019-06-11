Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3763C931
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 12:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfFKKoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 06:44:07 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40393 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfFKKoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 06:44:07 -0400
Received: by mail-qt1-f193.google.com with SMTP id a15so13863922qtn.7
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2019 03:44:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+Pnqdbl0zwY2ePurYnw0Hwq65Ie2NI3IHAjinIWbf4k=;
        b=bO50Jf5wQ3w5ZS5XsbVAyTd8HnvmePYQq+L5YjH92sChulbMnDmOqfGnKyVNd5ZQMI
         4/+FBoe8bckoMwFyRPUkTc2la0SmfnTcqAA1e5e0inW/6pvbPgBh8An1HXoPUW4fFFWO
         VxExjbd7oGd8jKse/4/wgHjcJ1lAtnFIUtoswFLSi+CkvZqNDqDRWUKKvFNDLSAdoQOO
         5vB20hVE0msEh1VDSJ/HTOVKX4wKK3tZD30xPPEcit7FtI3WOHoRcYwh2xpG4hgvxt9n
         tOpybcmJq1u5Fav/RgZnKsTDnYSAFEhN+95H15stP5qXkbGVm1diJGSB3ZTIQYAynb92
         e04Q==
X-Gm-Message-State: APjAAAW3Amujg1nZzkceFS8RKkbA6fypbQXPdxF1SFURASihMvjPcgAc
        1U0yWvap5bkS7AyXHLy/aEQvh+CQbVc=
X-Google-Smtp-Source: APXvYqwEjJLHFIDj3ElSvfJnv/+Qf+1oLIRfn+OC5xB0E+z5wCQ/9XPGNXVGVO9OcT8FHNYKICjUMQ==
X-Received: by 2002:ac8:4442:: with SMTP id m2mr41565944qtn.107.1560249846338;
        Tue, 11 Jun 2019 03:44:06 -0700 (PDT)
Received: from redhat.com (pool-100-0-197-103.bstnma.fios.verizon.net. [100.0.197.103])
        by smtp.gmail.com with ESMTPSA id s23sm9036235qtj.56.2019.06.11.03.44.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 03:44:05 -0700 (PDT)
Date:   Tue, 11 Jun 2019 06:44:02 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        "Jason J. Herne" <jjherne@linux.ibm.com>
Subject: Re: [PATCH v4 0/8] s390: virtio: support protected virtualization
Message-ID: <20190611064354-mutt-send-email-mst@kernel.org>
References: <20190606115127.55519-1-pasic@linux.ibm.com>
 <20190611123740.3d46f31b.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611123740.3d46f31b.cohuck@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 11, 2019 at 12:37:40PM +0200, Cornelia Huck wrote:
> On Thu,  6 Jun 2019 13:51:19 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > * Documentation is still very sketchy. I'm committed to improving this,
> >   but I'm currently hampered by some dependencies currently.  
> 
> Have the "dependencies" been resolved in the meantime? It probably
> would be a good idea to include some documentation for what needs to be
> dma and what doesn't somewhere in the kernel documentation (IIRC we
> have a s390 drivers 'book' partially generated from kerneldoc; there's
> some general document about the cio interfaces as well, but I'm not
> sure how up-to-date that is.)
> 
> I think the code in here looks sane from my point of view (except for
> the one easy-to-fix issue I found); I would be fine with the virtio-ccw
> patches making it into the kernel via the s390 tree (and not via the
> virtio tree).

Yes, me too.

