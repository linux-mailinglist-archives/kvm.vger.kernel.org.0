Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64492DD19
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 14:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfE2Ma4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 08:30:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46390 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbfE2Ma4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 08:30:56 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C8A0D30C318A;
        Wed, 29 May 2019 12:30:55 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73D921972C;
        Wed, 29 May 2019 12:30:49 +0000 (UTC)
Date:   Wed, 29 May 2019 14:30:47 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Michael Mueller <mimu@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: Re: [PATCH v2 3/8] s390/cio: add basic protected virtualization
 support
Message-ID: <20190529143047.35b5c7d3.cohuck@redhat.com>
In-Reply-To: <e794bad2-5fc2-b30c-972e-b586770a0065@linux.ibm.com>
References: <20190523162209.9543-1-mimu@linux.ibm.com>
        <20190523162209.9543-4-mimu@linux.ibm.com>
        <20190527123802.54cd3589.cohuck@redhat.com>
        <20190527143014.3b48a0d2.pasic@linux.ibm.com>
        <20190527153130.0f473ffd.cohuck@redhat.com>
        <e794bad2-5fc2-b30c-972e-b586770a0065@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 29 May 2019 12:30:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 May 2019 14:24:39 +0200
Michael Mueller <mimu@linux.ibm.com> wrote:

> On 27.05.19 15:31, Cornelia Huck wrote:

> > To actually make the guest use the 3270 as its console, I guess you
> > need to explicitly force it (see
> > https://wiki.qemu.org/Features/3270#Using_3270_as_the_console)...
> > actually starting the console will almost certainly fail; but you can
> > at least check whether device recognition in the console path works.
> >   
> >>
> >> Mimu, do we have something more elaborate with regards to this?  
> 
> I ran that with success
> 
> [root@ap01 ~]# lscss | grep 3270
> 0.0.002a 0.0.0008  0000/00 3270/00 yes  80  80  ff   01000000 00000000
> 
> and was able to connect and login.

Oh, cool. I'm actually a bit surprised this works without additional
changes to the 3270 code :)
