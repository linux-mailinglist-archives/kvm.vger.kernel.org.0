Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F19FE12F45
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 15:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfECNdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 09:33:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfECNdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 09:33:18 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 488633086222;
        Fri,  3 May 2019 13:33:18 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42DD6600C7;
        Fri,  3 May 2019 13:33:13 +0000 (UTC)
Date:   Fri, 3 May 2019 15:33:10 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: Re: [PATCH 00/10] s390: virtio: support protected virtualization
Message-ID: <20190503153310.04d4b85c.cohuck@redhat.com>
In-Reply-To: <20190503115511.17a1f6d1.cohuck@redhat.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190503115511.17a1f6d1.cohuck@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 03 May 2019 13:33:18 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 3 May 2019 11:55:11 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> On Fri, 26 Apr 2019 20:32:35 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 

> > What needs to be done
> > =====================
> > 
> > Thus what needs to be done to bring virtio-ccw up to speed with respect
> > to protected virtualization is:
> > * use some 'new' common virtio stuff
> 
> Doing this makes sense regardless of the protected virtualization use
> case, and I think we should go ahead and merge those patches for 5.2.
> 
> > * make sure that virtio-ccw specific stuff uses shared memory when
> >   talking to the hypervisor (except control/communication blocks like ORB,
> >   these are handled by the ultravisor)
> 
> TBH, I'm still a bit hazy on what needs to use shared memory and what
> doesn't.
> 
> > * make sure the DMA API does what is necessary to talk through shared
> >   memory if we are a protected virtualization guest.
> > * make sure the common IO layer plays along as well (airqs, sense).

I've skimmed some more over the rest of the patches; but I think this
needs review by someone else.

For example, I'm not sure what the semantics of using the main css
device as the dma device are, as I'm not sufficiently familiar with the
intricacies of the dma infrastructure. Combine this with a lack of
documentation of the hardware architecture, and I think that others can
provide much better feedback on this than I am able to.
