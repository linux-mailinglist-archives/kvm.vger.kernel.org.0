Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73551FB04A
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 14:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbgFPMV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 08:21:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33890 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728694AbgFPMV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 08:21:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592310085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h2SlXHGpqwt43th89psSAGozPMwGRRAsdb7ODXzU9w0=;
        b=gyr9sNwbPl+nXW49OIQ9ZaYti1hISkEEpiGS35C3Kd03CU/GVu2vS3sMzjXl2290fBfWAO
        i27GlZTqnVOzc5TCjmnaASC0Z8fvrBu1hM8mY9qVHhARjyCUMgIvEDlb+TD52Xu1EfuBwa
        PH3tBonHXZG0vg2jcRyXopyBpuF+rGU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-FYI6Xt7gPKyDGTLzv_M7uQ-1; Tue, 16 Jun 2020 08:21:21 -0400
X-MC-Unique: FYI6Xt7gPKyDGTLzv_M7uQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBB4B8005AD;
        Tue, 16 Jun 2020 12:21:19 +0000 (UTC)
Received: from gondolin (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D5AE31001B2B;
        Tue, 16 Jun 2020 12:21:14 +0000 (UTC)
Date:   Tue, 16 Jun 2020 14:21:12 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        frankja@linux.ibm.com, mst@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 1/1] s390: virtio: let arch accept devices without
 IOMMU feature
Message-ID: <20200616142112.2d08ff7d.cohuck@redhat.com>
In-Reply-To: <a93bf169-55ca-2a77-f9a5-b27bf18176e2@linux.ibm.com>
References: <1592224764-1258-1-git-send-email-pmorel@linux.ibm.com>
        <1592224764-1258-2-git-send-email-pmorel@linux.ibm.com>
        <74b6cf8a-d5a6-e0bf-f1c1-e453af133614@de.ibm.com>
        <a93bf169-55ca-2a77-f9a5-b27bf18176e2@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Jun 2020 09:35:19 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2020-06-16 08:55, Christian Borntraeger wrote:
> > 
> > 
> > On 15.06.20 14:39, Pierre Morel wrote:  
> >> An architecture protecting the guest memory against unauthorized host
> >> access may want to enforce VIRTIO I/O device protection through the
> >> use of VIRTIO_F_IOMMU_PLATFORM.
> >>
> >> Let's give a chance to the architecture to accept or not devices
> >> without VIRTIO_F_IOMMU_PLATFORM.
> >>
> >> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>  
> > 
> > 
> > Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>  
> 
> Thanks,
> 
> > 
> > Shouldnt we maybe add a pr_warn if that happens to help the admins to understand what is going on?
> > 
> >   
> 
> Yes, Connie asked for it too, good that you remind it to me, I add it.

Yes, please :)

