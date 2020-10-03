Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B330282304
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 11:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgJCJXj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 05:23:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37531 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725730AbgJCJXj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Oct 2020 05:23:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601717017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ltf9E3cxcQ9E3g2EEaIx5vhqzyYEnVj/Ef3P4Leih4o=;
        b=CDAiiwASqpeU9kfJCovT+6n51au5hnURPUYFXlo6fhNa9g3Ng5BjHj4PRVrJZ6XkGzvBbM
        piUiTLKBbrGMXw+tcUXCHOpJ2j/3ROe7ZpZVD+VWugvTmpKZ2p4g8Qv3G70LcwHCN43e76
        JMAV6/gooqXJ+jox4g6OcZtPddFsgA0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-dR6t7TGVPIeN9sEs0ZuGBA-1; Sat, 03 Oct 2020 05:23:35 -0400
X-MC-Unique: dR6t7TGVPIeN9sEs0ZuGBA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85AEC107465E;
        Sat,  3 Oct 2020 09:23:34 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-112-40.ams2.redhat.com [10.36.112.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BED891000232;
        Sat,  3 Oct 2020 09:23:29 +0000 (UTC)
Date:   Sat, 3 Oct 2020 11:23:27 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 3/7] lib/asm: Add definitions of memory
 areas
Message-ID: <20201003092327.5xl7nzx27o35jqwf@kamzik.brq.redhat.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <20201002154420.292134-4-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002154420.292134-4-imbrenda@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 02, 2020 at 05:44:16PM +0200, Claudio Imbrenda wrote:
> Add definitions and boundaries of memory areas for some architectures.
> This is needed by the next patch.
> 
> Most architectures only get one generic memory area, wherease x86 and
> s390x get some more attention:
> 
> x86 gets
> * lowest area (24-bit addresses)
> * low area (32-bit addresses)
> * the rest
> 
> s390x gets
> * low area (31-bit addresses)
> * the rest
> 
> Notice that the number indicates the order in which the areas are
> scanned when more than one area is indicated. The default order tries
> to get allocations from higher address ranges before trying lower ones.
> This tries to keep the precious lower addresses as free as possible.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/asm-generic/memory_areas.h | 11 +++++++++++
>  lib/arm/asm/memory_areas.h     | 11 +++++++++++
>  lib/arm64/asm/memory_areas.h   | 11 +++++++++++
>  lib/powerpc/asm/memory_areas.h | 11 +++++++++++
>  lib/ppc64/asm/memory_areas.h   | 11 +++++++++++
>  lib/s390x/asm/memory_areas.h   | 17 +++++++++++++++++
>  lib/x86/asm/memory_areas.h     | 22 ++++++++++++++++++++++
>  7 files changed, 94 insertions(+)
>  create mode 100644 lib/asm-generic/memory_areas.h
>  create mode 100644 lib/arm/asm/memory_areas.h
>  create mode 100644 lib/arm64/asm/memory_areas.h
>  create mode 100644 lib/powerpc/asm/memory_areas.h
>  create mode 100644 lib/ppc64/asm/memory_areas.h
>  create mode 100644 lib/s390x/asm/memory_areas.h
>  create mode 100644 lib/x86/asm/memory_areas.h
> 
> diff --git a/lib/asm-generic/memory_areas.h b/lib/asm-generic/memory_areas.h
> new file mode 100644
> index 0000000..927baa7
> --- /dev/null
> +++ b/lib/asm-generic/memory_areas.h
> @@ -0,0 +1,11 @@
> +#ifndef MEMORY_AREAS_H

_ASM_GENERIC_MEMORY_AREAS_H_

> +#define MEMORY_AREAS_H
> +
> +#define AREA_NORMAL_PFN 0
> +#define AREA_NORMAL_NUMBER 0
> +#define AREA_NORMAL 1
> +
> +#define AREA_ANY -1
> +#define AREA_ANY_NUMBER 0xff

Do we really need both a "type number", like AREA_NORMAL, and a
"number number" (AREA_NORMAL_NUMBER)? Why not just search in the order
of the type numbers? Or in the reverse order, if that's better? Also,
would an enum be more appropriate for the type numbers?

> +
> +#endif
> diff --git a/lib/arm/asm/memory_areas.h b/lib/arm/asm/memory_areas.h
> new file mode 100644
> index 0000000..927baa7
> --- /dev/null
> +++ b/lib/arm/asm/memory_areas.h
> @@ -0,0 +1,11 @@
> +#ifndef MEMORY_AREAS_H

_ASMARM_MEMORY_AREAS_H_

We certainly don't want the same define as the generic file, as it's
possible an arch will want to simply extend the generic code, e.g.

 #ifndef _ASMARM_MEMORY_AREAS_H_
 #define _ASMARM_MEMORY_AREAS_H_
 #include #include <asm-generic/memory_areas.h>

 /* ARM memory area stuff here */

 #endif

This comment applies to the rest of memory_areas.h files. Look at
other lib/$ARCH/asm/*.h files to get the define prefix.

> +#define MEMORY_AREAS_H
> +
> +#define AREA_NORMAL_PFN 0
> +#define AREA_NORMAL_NUMBER 0
> +#define AREA_NORMAL 1
> +
> +#define AREA_ANY -1
> +#define AREA_ANY_NUMBER 0xff
> +
> +#endif
[...]
> diff --git a/lib/s390x/asm/memory_areas.h b/lib/s390x/asm/memory_areas.h
> new file mode 100644
> index 0000000..4856a27
> --- /dev/null
> +++ b/lib/s390x/asm/memory_areas.h
> @@ -0,0 +1,17 @@
> +#ifndef MEMORY_AREAS_H
> +#define MEMORY_AREAS_H
> +
> +#define AREA_NORMAL_PFN BIT(31-12)

BIT(31 - PAGE_SHIFT)

> +#define AREA_NORMAL_NUMBER 0
> +#define AREA_NORMAL 1
> +
> +#define AREA_LOW_PFN 0
> +#define AREA_LOW_NUMBER 1
> +#define AREA_LOW 2
> +
> +#define AREA_ANY -1
> +#define AREA_ANY_NUMBER 0xff
> +
> +#define AREA_DMA31 AREA_LOW

I don't work on s390x, but I'd rather not add too many aliases. I think
a single name with the min and max address bits embedded in it is
probably best. Maybe something like AREA_0_31 and AREA_31_52, or
whatever.

> +
> +#endif
> diff --git a/lib/x86/asm/memory_areas.h b/lib/x86/asm/memory_areas.h
> new file mode 100644
> index 0000000..d704df3
> --- /dev/null
> +++ b/lib/x86/asm/memory_areas.h
> @@ -0,0 +1,22 @@
> +#ifndef MEMORY_AREAS_H
> +#define MEMORY_AREAS_H
> +
> +#define AREA_NORMAL_PFN BIT(32-12)
> +#define AREA_NORMAL_NUMBER 0
> +#define AREA_NORMAL 1
> +
> +#define AREA_LOW_PFN BIT(24-12)
> +#define AREA_LOW_NUMBER 1
> +#define AREA_LOW 2
> +
> +#define AREA_LOWEST_PFN 0
> +#define AREA_LOWEST_NUMBER 2
> +#define AREA_LOWEST 4
> +
> +#define AREA_DMA24 AREA_LOWEST
> +#define AREA_DMA32 (AREA_LOWEST | AREA_LOW)

Aha, now I finally see that there's a type number and a number number
because the type number is a bit, presumably for some flag field that's
coming in a later patch. I'll have to look at the other patches to see
how that's used, but at the moment I feel like there should be another
way to represent memory areas without requiring a handful of defines
and aliases for each one.

Thanks,
drew

> +
> +#define AREA_ANY -1
> +#define AREA_ANY_NUMBER 0xff
> +
> +#endif
> -- 
> 2.26.2
> 

