Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E605133D8D6
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 17:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238499AbhCPQNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 12:13:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31691 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238512AbhCPQNH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 12:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615911187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5nXgBqh8rbvtx+l718KVEXx0Knra8enUurT+91ouh5U=;
        b=b3ymIII53nmRfrQ3ivNf/UBzke0lUemJZWGHEqv0OgRHsCmYEYT4mvx0pjX2WUuZWBK4as
        TJrCnKnfkPL+uvflA8WgKD+OoZyoWM0wLWbt8IWwq8NyN0xuq7K81yvxiN9TlCsmXSIbos
        SlsAwHPNIfFEsbuhAjvHRoiqP2yOX+g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-aVT0u-g0PFWbxzgSD078LA-1; Tue, 16 Mar 2021 12:13:03 -0400
X-MC-Unique: aVT0u-g0PFWbxzgSD078LA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05104104FC11;
        Tue, 16 Mar 2021 16:13:02 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 609ED60C13;
        Tue, 16 Mar 2021 16:13:00 +0000 (UTC)
Date:   Tue, 16 Mar 2021 17:12:57 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH 2/4] libfdt: Pull v1.6.0
Message-ID: <20210316161257.v73vsfaq2jhg4nzj@kamzik.brq.redhat.com>
References: <20210316152405.50363-1-nikos.nikoleris@arm.com>
 <20210316152405.50363-3-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316152405.50363-3-nikos.nikoleris@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 03:24:03PM +0000, Nikos Nikoleris wrote:
> This change updates the libfdt source files to v1.6.0 from
> git://git.kernel.org/pub/scm/utils/dtc/dtc.git
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/libfdt/README            |   3 +-
>  lib/libfdt/Makefile.libfdt   |  10 +-
>  lib/libfdt/version.lds       |  24 +-
>  lib/libfdt/fdt.h             |  53 +--
>  lib/libfdt/libfdt.h          | 766 +++++++++++++++++++++++++-----
>  lib/libfdt/libfdt_env.h      | 109 ++---
>  lib/libfdt/libfdt_internal.h | 206 +++++---
>  lib/libfdt/fdt.c             | 200 +++++---
>  lib/libfdt/fdt_addresses.c   | 101 ++++
>  lib/libfdt/fdt_check.c       |  74 +++
>  lib/libfdt/fdt_empty_tree.c  |  48 +-
>  lib/libfdt/fdt_overlay.c     | 881 +++++++++++++++++++++++++++++++++++
>  lib/libfdt/fdt_ro.c          | 512 +++++++++++++++-----
>  lib/libfdt/fdt_rw.c          | 231 +++++----
>  lib/libfdt/fdt_strerror.c    |  53 +--
>  lib/libfdt/fdt_sw.c          | 297 ++++++++----
>  lib/libfdt/fdt_wip.c         |  90 ++--
>  17 files changed, 2844 insertions(+), 814 deletions(-)
>  create mode 100644 lib/libfdt/fdt_addresses.c
>  create mode 100644 lib/libfdt/fdt_check.c
>  create mode 100644 lib/libfdt/fdt_overlay.c
> 
> diff --git a/lib/libfdt/README b/lib/libfdt/README
> index 24ad4fe..aed3454 100644
> --- a/lib/libfdt/README
> +++ b/lib/libfdt/README
> @@ -1,4 +1,5 @@
>  
>  The code in this directory is originally imported from the libfdt
                                 ^^  says originally, so we should
replace the whole paragraph with something like

The code in this directory has been imported from the libfdt directory
of git://git.kernel.org/pub/scm/utils/dtc/dtc.git - version 1.6.0.

> -directory of git://git.jdl.com/software/dtc.git - version 1.4.0.
> +directory of git://git.kernel.org/pub/scm/utils/dtc/dtc.git -
> +version 1.60
>

Thanks,
drew  

