Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75A2C2543CA
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 12:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgH0KdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 06:33:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47750 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727793AbgH0KdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 06:33:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598524384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xVl6R1XwWuiNXr6HJxlhlEi6Bd9mQNsLml7GXEW9cbY=;
        b=WlTMP+L/3Vp6xUDqo/yjQGTsu8ar4gsVsU3KZfHO+/rAheXFotGTks4kiYw02Z37MTzBWC
        D1yUS/6XimJu/YQX5w+NgPttKDNkdVMY76qmdFVUBMicMrru6i6I7sJ/Go6Uath0ghmxTB
        2oIQTUTdrtUpIzGAhk2lWV2BUhODz4k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-bdNbO0IPPrq-tf0swTDF9Q-1; Thu, 27 Aug 2020 06:33:00 -0400
X-MC-Unique: bdNbO0IPPrq-tf0swTDF9Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84F94803F58;
        Thu, 27 Aug 2020 10:32:46 +0000 (UTC)
Received: from gondolin (ovpn-113-237.ams2.redhat.com [10.36.113.237])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5D97196F3;
        Thu, 27 Aug 2020 10:32:42 +0000 (UTC)
Date:   Thu, 27 Aug 2020 12:32:40 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v10 01/16] s390/vfio-ap: add version vfio_ap module
Message-ID: <20200827123240.42e0c787.cohuck@redhat.com>
In-Reply-To: <ca016eca-1ee7-2d0f-c2ec-3ef147b6216a@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-2-akrowiak@linux.ibm.com>
        <20200825120432.13a1b444.cohuck@redhat.com>
        <ca016eca-1ee7-2d0f-c2ec-3ef147b6216a@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 26 Aug 2020 10:49:47 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 8/25/20 6:04 AM, Cornelia Huck wrote:
> > On Fri, 21 Aug 2020 15:56:01 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> Let's set a version for the vfio_ap module so that automated regression
> >> tests can determine whether dynamic configuration tests can be run or
> >> not.
> >>
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >> ---
> >>   drivers/s390/crypto/vfio_ap_drv.c | 2 ++
> >>   1 file changed, 2 insertions(+)
> >>
> >> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> >> index be2520cc010b..f4ceb380dd61 100644
> >> --- a/drivers/s390/crypto/vfio_ap_drv.c
> >> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> >> @@ -17,10 +17,12 @@
> >>   
> >>   #define VFIO_AP_ROOT_NAME "vfio_ap"
> >>   #define VFIO_AP_DEV_NAME "matrix"
> >> +#define VFIO_AP_MODULE_VERSION "1.2.0"
> >>   
> >>   MODULE_AUTHOR("IBM Corporation");
> >>   MODULE_DESCRIPTION("VFIO AP device driver, Copyright IBM Corp. 2018");
> >>   MODULE_LICENSE("GPL v2");
> >> +MODULE_VERSION(VFIO_AP_MODULE_VERSION);
> >>   
> >>   static struct ap_driver vfio_ap_drv;
> >>     
> > Setting a version manually has some drawbacks:
> > - tools wanting to check for capabilities need to keep track which
> >    versions support which features
> > - you need to remember to actually bump the version when adding a new,
> >    visible feature
> > (- selective downstream backports may get into a pickle, but that's
> > arguably not your problem)
> >
> > Is there no way for a tool to figure out whether this is supported?
> > E.g., via existence of a sysfs file, or via a known error that will
> > occur. If not, it's maybe better to expose known capabilities via a
> > generic interface.  
> 
> This patch series introduces a new mediated device sysfs attribute,
> guest_matrix, so the automated tests could check for the existence
> of that interface. The problem I have with that is it will work for
> this version of the vfio_ap device driver - which may be all that is
> ever needed - but does not account for future enhancements
> which may need to be detected by tooling or automated tests.
> It seems to me that regardless of how a tool detects whether
> a feature is supported or not, it will have to keep track of that
> somehow.

Which enhancements? If you change the interface in an incompatible way,
you have a different problem anyway. If someone trying to use the
enhanced version of the interface gets an error on a kernel providing
an older version of the interface, that's a reasonable way to discover
support.

I think "discover device driver capabilities by probing" is less
burdensome and error prone than trying to match up capabilities with a
version number. If you expose a version number, a tool would still have
to probe that version number, and then consult with a list of features
per version, which can easily go out of sync.

> Can you provide more details about this generic interface of
> which you speak?

If that is really needed, I'd probably do a driver sysfs attribute that
exposes a list of documented capabilities (as integer values, or as a
bit.) But since tools can simply check for guest_matrix to find out
about support for this feature here, it seems like overkill to me --
unless you have a multitude of features waiting in queue that need to
be made discoverable.

