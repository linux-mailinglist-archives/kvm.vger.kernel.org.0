Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF883C916
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 12:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfFKKhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 06:37:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46578 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfFKKhu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 06:37:50 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85F543082E70;
        Tue, 11 Jun 2019 10:37:50 +0000 (UTC)
Received: from gondolin (ovpn-204-147.brq.redhat.com [10.40.204.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C29619C70;
        Tue, 11 Jun 2019 10:37:43 +0000 (UTC)
Date:   Tue, 11 Jun 2019 12:37:40 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
Message-ID: <20190611123740.3d46f31b.cohuck@redhat.com>
In-Reply-To: <20190606115127.55519-1-pasic@linux.ibm.com>
References: <20190606115127.55519-1-pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 11 Jun 2019 10:37:50 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Jun 2019 13:51:19 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> * Documentation is still very sketchy. I'm committed to improving this,
>   but I'm currently hampered by some dependencies currently.  

Have the "dependencies" been resolved in the meantime? It probably
would be a good idea to include some documentation for what needs to be
dma and what doesn't somewhere in the kernel documentation (IIRC we
have a s390 drivers 'book' partially generated from kerneldoc; there's
some general document about the cio interfaces as well, but I'm not
sure how up-to-date that is.)

I think the code in here looks sane from my point of view (except for
the one easy-to-fix issue I found); I would be fine with the virtio-ccw
patches making it into the kernel via the s390 tree (and not via the
virtio tree).
