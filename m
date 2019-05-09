Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6369E18830
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 12:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfEIKLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 06:11:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49516 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfEIKLO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 06:11:14 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0F1E77DCC1;
        Thu,  9 May 2019 10:11:14 +0000 (UTC)
Received: from gondolin (dhcp-192-213.str.redhat.com [10.33.192.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1B6B1001E64;
        Thu,  9 May 2019 10:11:08 +0000 (UTC)
Date:   Thu, 9 May 2019 12:11:06 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Sebastian Ott <sebott@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
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
        Eric Farman <farman@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>
Subject: Re: [PATCH 05/10] s390/cio: introduce DMA pools to cio
Message-ID: <20190509121106.48aa04db.cohuck@redhat.com>
In-Reply-To: <20190508232210.5a555caa.pasic@linux.ibm.com>
References: <20190426183245.37939-1-pasic@linux.ibm.com>
        <20190426183245.37939-6-pasic@linux.ibm.com>
        <alpine.LFD.2.21.1905081447280.1773@schleppi>
        <20190508232210.5a555caa.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 09 May 2019 10:11:14 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 May 2019 23:22:10 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Wed, 8 May 2019 15:18:10 +0200 (CEST)
> Sebastian Ott <sebott@linux.ibm.com> wrote:

> > > @@ -1063,6 +1163,7 @@ static int __init css_bus_init(void)
> > >  		unregister_reboot_notifier(&css_reboot_notifier);
> > >  		goto out_unregister;
> > >  	}
> > > +	cio_dma_pool_init();    
> > 
> > This is too late for early devices (ccw console!).  
> 
> You have already raised concern about this last time (thanks). I think,
> I've addressed this issue: tje cio_dma_pool is only used by the airq
> stuff. I don't think the ccw console needs it. Please have an other look
> at patch #6, and explain your concern in more detail if it persists.

What about changing the naming/adding comments here, so that (1) folks
aren't confused by the same thing in the future and (2) folks don't try
to use that pool for something needed for the early ccw consoles?
