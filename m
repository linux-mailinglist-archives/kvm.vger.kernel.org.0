Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0508A2CEE85
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 14:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgLDM6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 07:58:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729128AbgLDM6q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 07:58:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607086640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e2n1oh4DvD0ZoyVsf8H0hUYTOFg8vSGC6lf8R25dVKo=;
        b=PFg5itv84ZrBmO1apzLdcQpdELMqbd699BPc1MPeOMNMLqmdrLP4q7s7yuAf5AGvQpNA0v
        mfZEX4MCE+Bm6gz/vkERRbsWbsKizPUEKYHlBZJxOk9xhCQGnwpwvpJcp6jC1/lelFu/nX
        Ax8UT1douh06USa7uJsKDjjY5yhCvwU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-HW980yUnOJG3P3Gk44aoFw-1; Fri, 04 Dec 2020 07:57:18 -0500
X-MC-Unique: HW980yUnOJG3P3Gk44aoFw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 262D1107ACE4;
        Fri,  4 Dec 2020 12:57:15 +0000 (UTC)
Received: from gondolin (ovpn-113-97.ams2.redhat.com [10.36.113.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F38F60C17;
        Fri,  4 Dec 2020 12:57:04 +0000 (UTC)
Date:   Fri, 4 Dec 2020 13:57:02 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-ppc@nongnu.org,
        rth@twiddle.net, thuth@redhat.com, berrange@redhat.com,
        mdroth@linux.vnet.ibm.com, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        pasic@linux.ibm.com, Greg Kurz <groug@kaod.org>
Subject: Re: [for-6.0 v5 01/13] qom: Allow optional sugar props
Message-ID: <20201204135702.3b4a0b5f.cohuck@redhat.com>
In-Reply-To: <20201204054415.579042-2-david@gibson.dropbear.id.au>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <20201204054415.579042-2-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  4 Dec 2020 16:44:03 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> From: Greg Kurz <groug@kaod.org>
> 
> Global properties have an @optional field, which allows to apply a given
> property to a given type even if one of its subclasses doesn't support
> it. This is especially used in the compat code when dealing with the
> "disable-modern" and "disable-legacy" properties and the "virtio-pci"
> type.
> 
> Allow object_register_sugar_prop() to set this field as well.
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>
> Message-Id: <159738953558.377274.16617742952571083440.stgit@bahia.lan>
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  include/qom/object.h |  3 ++-
>  qom/object.c         |  4 +++-
>  softmmu/vl.c         | 16 ++++++++++------
>  3 files changed, 15 insertions(+), 8 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

