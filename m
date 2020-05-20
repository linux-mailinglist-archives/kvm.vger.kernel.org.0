Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB2A1DB8EB
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 18:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgETQCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 12:02:50 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43630 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726596AbgETQCu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 12:02:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589990569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xwYbz+wmK7npnV+vVcQzDOpVINUREQVEaIQxYqTLVuo=;
        b=Zqsq9ZMtFxXvrJiunCd8qE84qAcv3bdr0uLvwG6OHkTenVJ/adWAFHMQF0wfZBMyEiJIg9
        UAkJyDmp0kkNfKUtZaePbWPWcR8jdI2t9gFUHUG2vVjdx2SJPuQvVRLdIM5QFQEkxmAR/N
        A/uuea7dMNwRFKA1AcFm19DqpK4AI88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-rkU9kdoyMWyk56uPuaeMbg-1; Wed, 20 May 2020 12:02:36 -0400
X-MC-Unique: rkU9kdoyMWyk56uPuaeMbg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B4201015DB8;
        Wed, 20 May 2020 16:01:58 +0000 (UTC)
Received: from work-vm (ovpn-114-169.ams2.redhat.com [10.36.114.169])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B3F13AC;
        Wed, 20 May 2020 16:01:50 +0000 (UTC)
Date:   Wed, 20 May 2020 17:01:48 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH v2 12/19] MAINTAINERS: Add myself as virtio-mem maintainer
Message-ID: <20200520160148.GF2820@work-vm>
References: <20200520123152.60527-1-david@redhat.com>
 <20200520123152.60527-13-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520123152.60527-13-david@redhat.com>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* David Hildenbrand (david@redhat.com) wrote:
> Let's make sure patches/bug reports find the right person.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Peter Maydell <peter.maydell@linaro.org>
> Cc: Markus Armbruster <armbru@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 47ef3139e6..91c2791679 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1744,6 +1744,14 @@ F: hw/virtio/virtio-crypto.c
>  F: hw/virtio/virtio-crypto-pci.c
>  F: include/hw/virtio/virtio-crypto.h
>  
> +virtio-mem
> +M: David Hildenbrand <david@redhat.com>
> +S: Supported
> +F: hw/virtio/virtio-mem.c
> +F: hw/virtio/virtio-mem-pci.h
> +F: hw/virtio/virtio-mem-pci.c
> +F: include/hw/virtio/virtio-mem.h
> +

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

>  nvme
>  M: Keith Busch <kbusch@kernel.org>
>  L: qemu-block@nongnu.org
> -- 
> 2.25.4
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

