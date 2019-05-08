Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0094917AC7
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 15:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfEHNgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 09:36:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51368 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfEHNgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 09:36:23 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2474289C3B;
        Wed,  8 May 2019 13:36:23 +0000 (UTC)
Received: from gondolin (ovpn-204-161.brq.redhat.com [10.40.204.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67AAA19729;
        Wed,  8 May 2019 13:36:21 +0000 (UTC)
Date:   Wed, 8 May 2019 15:36:18 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/7] s390/cio: Split pfn_array_alloc_pin into pieces
Message-ID: <20190508153618.3ff9174f.cohuck@redhat.com>
In-Reply-To: <15e733fc-e6eb-176e-e9bd-3f7629d5f935@linux.ibm.com>
References: <20190503134912.39756-1-farman@linux.ibm.com>
        <20190503134912.39756-4-farman@linux.ibm.com>
        <20190508124327.5c496c8a.cohuck@redhat.com>
        <15e733fc-e6eb-176e-e9bd-3f7629d5f935@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 08 May 2019 13:36:23 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 May 2019 09:25:57 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> On 5/8/19 6:43 AM, Cornelia Huck wrote:
> > On Fri,  3 May 2019 15:49:08 +0200
> > Eric Farman <farman@linux.ibm.com> wrote:

> >> +/*
> >> + * pfn_array_pin() - Pin user pages in memory
> >> + * @pa: pfn_array on which to perform the operation
> >> + * @mdev: the mediated device to perform pin operations
> >> + *
> >> + * Returns:
> >> + *   Number of pages pinned on success.
> >> + *   If fewer pages than requested were pinned, returns -EINVAL
> >> + *   If no pages were pinned, returns -errno.  
> > 
> > I don't really like the 'returns -errno' :) It's actually the return
> > code of vfio_pin_pages(), and that might include -EINVAL as well.
> > 
> > So, what about mentioning in the function description that
> > pfn_array_pin() only succeeds if it coult pin all pages, and simply
> > stating that it returns a negative error value on failure?  
> 
> Seems reasonable to me...  Something like:
> 
>   * Returns number of pages pinned upon success.
>   * If the pin request partially succeeds, or fails completely,
>   * all pages are left unpinned and a negative error value is returned.

Sounds good to me!
