Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D911D553C
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 17:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgEOPzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 11:55:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23853 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726255AbgEOPzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 11:55:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589558143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mtXWoNOchQkg/jrYnv0O2uMYTDRYqqetz96/9IJRxak=;
        b=Mc25anHrDK3QunuzV0Q6DAyCeA8Psrtyy8EX2bwBQPyn9k3GV+BKOj3fTCg3CIayMnvYwx
        jeaQcSGPGtLCC5H2DEOFKSxyAfYB67eJIbIGbO9+UqVxWGbFVzLPRembZ3YYJGs+p1s+Sj
        Ryolklh8pP/VRpavwhrqq/fww6QX75s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-DJgiDMZDPeGYHt7r-fkmZg-1; Fri, 15 May 2020 11:55:39 -0400
X-MC-Unique: DJgiDMZDPeGYHt7r-fkmZg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3114E107ACF4;
        Fri, 15 May 2020 15:55:38 +0000 (UTC)
Received: from work-vm (ovpn-114-149.ams2.redhat.com [10.36.114.149])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E08A5C5FA;
        Fri, 15 May 2020 15:55:22 +0000 (UTC)
Date:   Fri, 15 May 2020 16:55:20 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH v1 12/17] MAINTAINERS: Add myself as virtio-mem maintainer
Message-ID: <20200515155520.GI2954@work-vm>
References: <20200506094948.76388-1-david@redhat.com>
 <20200506094948.76388-13-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506094948.76388-13-david@redhat.com>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1f84e3ae2c..09fff9e1bd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1734,6 +1734,14 @@ F: hw/virtio/virtio-crypto.c
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
>  nvme
>  M: Keith Busch <kbusch@kernel.org>
>  L: qemu-block@nongnu.org
> -- 
> 2.25.3
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

