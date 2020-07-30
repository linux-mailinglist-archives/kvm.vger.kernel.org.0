Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C633F23343B
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 16:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbgG3OWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 10:22:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26287 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728286AbgG3OWe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 10:22:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596118952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1g+nDRNzICULfjPK9VzqRZhJlna7oA9vv99CYPf3EUg=;
        b=UQ3EDNTvurWu2gHKnDDpH5e7UdNX8+PcugOgBC6AX2GK6Y/J3TlCKD17RWgARxegkmNV1d
        h04LtLKgtX25mJrS1SdW2igguPEjhfSWDmWA0hYYtoaohwXylVtFEHakECon7uI6b3sidX
        swS6pQ44P81ZMNaS7v3FCb8TqFbuad8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-2Bh90G5aMwyAAl-9Y6F-XQ-1; Thu, 30 Jul 2020 10:22:29 -0400
X-MC-Unique: 2Bh90G5aMwyAAl-9Y6F-XQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 337B81009440;
        Thu, 30 Jul 2020 14:22:27 +0000 (UTC)
Received: from work-vm (ovpn-114-102.ams2.redhat.com [10.36.114.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0293F7AC94;
        Thu, 30 Jul 2020 14:22:22 +0000 (UTC)
Date:   Thu, 30 Jul 2020 15:22:20 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Stefano Garzarella <sgarzare@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>, qemu-block@nongnu.org,
        qemu-ppc@nongnu.org, Kaige Li <likaige@loongson.cn>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH-for-5.1? v2 0/2] util/pagesize: Make
 qemu_real_host_page_size of type size_t
Message-ID: <20200730142220.GA7120@work-vm>
References: <20200730141245.21739-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200730141245.21739-1-philmd@redhat.com>
User-Agent: Mutt/1.14.5 (2020-06-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Philippe Mathieu-Daudé (philmd@redhat.com) wrote:
> Since v1:
> Make QEMU_VMALLOC_ALIGN unsigned in a previous patch

Nah, not for 5.1 - it feels like the type of thing that might on a
really bad day create a really subtle bug.

Dave

> Philippe Mathieu-Daudé (2):
>   qemu/osdep: Make QEMU_VMALLOC_ALIGN unsigned long
>   util/pagesize: Make qemu_real_host_page_size of type size_t
> 
>  include/exec/ram_addr.h  | 4 ++--
>  include/qemu/osdep.h     | 6 +++---
>  accel/kvm/kvm-all.c      | 3 ++-
>  block/qcow2-cache.c      | 2 +-
>  exec.c                   | 8 ++++----
>  hw/ppc/spapr_pci.c       | 2 +-
>  hw/virtio/virtio-mem.c   | 2 +-
>  migration/migration.c    | 2 +-
>  migration/postcopy-ram.c | 2 +-
>  monitor/misc.c           | 2 +-
>  util/pagesize.c          | 2 +-
>  11 files changed, 18 insertions(+), 17 deletions(-)
> 
> -- 
> 2.21.3
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

