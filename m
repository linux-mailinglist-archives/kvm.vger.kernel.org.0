Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1AF1FAEFD
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 13:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgFPLRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 07:17:54 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49416 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725768AbgFPLRv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 07:17:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592306269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=da8UnOZcqvP4RkUxtdOC7xKwlzyHgAbrTXZEHOn7keo=;
        b=PFKVwNprn6rYCTwGuRpGSlaU1bnMppJJ9AOoRMchQ3FZXZ8ON4DZkCGr8ZFLa+YgdD//rB
        9oVktuhRA1jHFTemkdXCXWC5mgewPjHBndhYz+IR3FNKwKiUyWAchCU8ppE25+H2hEzoIk
        +C3o1iHL3+06OXC1lFGQ50r01Kw0GoE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-S5uGZ7BrODihBcFKB5hMLQ-1; Tue, 16 Jun 2020 07:17:44 -0400
X-MC-Unique: S5uGZ7BrODihBcFKB5hMLQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10A2F100945A;
        Tue, 16 Jun 2020 11:17:43 +0000 (UTC)
Received: from gondolin (ovpn-112-222.ams2.redhat.com [10.36.112.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAAE46FDD1;
        Tue, 16 Jun 2020 11:17:35 +0000 (UTC)
Date:   Tue, 16 Jun 2020 13:17:32 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v4 04/21] s390x/pv: Convert to
 ram_block_discard_disable()
Message-ID: <20200616131732.52eb76d1.cohuck@redhat.com>
In-Reply-To: <20200610115419.51688-5-david@redhat.com>
References: <20200610115419.51688-1-david@redhat.com>
        <20200610115419.51688-5-david@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Jun 2020 13:54:02 +0200
David Hildenbrand <david@redhat.com> wrote:

> Discarding RAM does not work as expected with protected VMs. Let's
> switch to ram_block_discard_disable() for now, as we want to get rid
> of qemu_balloon_inhibit(). Note that it will currently never fail, but
> might fail in the future with new technologies (e.g., virtio-mem).
> 
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Janosch Frank <frankja@linux.ibm.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  hw/s390x/s390-virtio-ccw.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)

Did not review in detail, but looks sane. Would like to see a sanity
check and ack from folks with access to a PV setup.

Acked-by: Cornelia Huck <cohuck@redhat.com>

