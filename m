Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC88D2DA28D
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 22:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503576AbgLNV1C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 16:27:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2503571AbgLNV1C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 16:27:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607981136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sj44vDZp0yoWNaa+V0L2lJeML/RXpnxN2J+1LkLWlyw=;
        b=SJOtguax8IFl30Ma5b4NC/+ccj9w00yceZI1ooCz57iBIs4j8TEU2i/fLbHumawaNCvLw1
        IPJBK3KFs/i5MwyDX69V977KcahrcLM1VzBZnChSN4wQ36pADWZmJRa99Kaa16LrOCHkwi
        kwspMOFqywnOem9Ur4YqH8iKIvmTmgc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-4SccWWaQPOeOxSEBp6sW3w-1; Mon, 14 Dec 2020 16:25:34 -0500
X-MC-Unique: 4SccWWaQPOeOxSEBp6sW3w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66A341005504;
        Mon, 14 Dec 2020 21:25:31 +0000 (UTC)
Received: from localhost (ovpn-116-160.rdu2.redhat.com [10.10.116.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4EFE60BE2;
        Mon, 14 Dec 2020 21:25:24 +0000 (UTC)
Date:   Mon, 14 Dec 2020 16:25:23 -0500
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org,
        qemu-ppc@nongnu.org, rth@twiddle.net, thuth@redhat.com,
        berrange@redhat.com, mdroth@linux.vnet.ibm.com,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        david@redhat.com, Richard Henderson <richard.henderson@linaro.org>,
        borntraeger@de.ibm.com, cohuck@redhat.com, kvm@vger.kernel.org,
        qemu-s390x@nongnu.org, pasic@linux.ibm.com,
        Greg Kurz <groug@kaod.org>
Subject: Re: [for-6.0 v5 01/13] qom: Allow optional sugar props
Message-ID: <20201214212523.GS1289986@habkost.net>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204054415.579042-2-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201204054415.579042-2-david@gibson.dropbear.id.au>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 04, 2020 at 04:44:03PM +1100, David Gibson wrote:
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

Reviewed-by: Eduardo Habkost <ehabkost@redhat.com>

-- 
Eduardo

