Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DD814CACC
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2020 13:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgA2MZ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 07:25:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20502 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726142AbgA2MZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 07:25:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580300725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eD0787NDohNjvxappA/qu+C3lhvoXKd+Eyz4of1nOSo=;
        b=EHtNf7XcBa8XRiZre60N8oEuHL+ePRhJ1+CNeu06aWTIjfJF4oOLv0pusl+iTNYRtggJ4m
        dKKFMh8hVZWyRKcz9vnfeonIFC/sABYdhN40HDSxIVy7mV/twUqPw4YCIlFero/hJ8D6Kf
        ER5gCXlWE8qgCIf7p/rwRkku8TLz12c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-vwla4zUSPA-eS1tmUB1m8A-1; Wed, 29 Jan 2020 07:25:23 -0500
X-MC-Unique: vwla4zUSPA-eS1tmUB1m8A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EF66107ACC5;
        Wed, 29 Jan 2020 12:25:21 +0000 (UTC)
Received: from gondolin (ovpn-116-225.ams2.redhat.com [10.36.116.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0F985C219;
        Wed, 29 Jan 2020 12:25:08 +0000 (UTC)
Date:   Wed, 29 Jan 2020 13:25:05 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        pbonzini@redhat.com, alex.williamson@redhat.com, peterx@redhat.com,
        mst@redhat.com, eric.auger@redhat.com, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        hao.wu@intel.com, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v3 06/25] scripts/update-linux-headers: Import iommu.h
Message-ID: <20200129132505.52501bda.cohuck@redhat.com>
In-Reply-To: <1580300216-86172-7-git-send-email-yi.l.liu@intel.com>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
        <1580300216-86172-7-git-send-email-yi.l.liu@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Jan 2020 04:16:37 -0800
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> From: Eric Auger <eric.auger@redhat.com>
> 
> Update the script to import the new iommu.h uapi header.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  scripts/update-linux-headers.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
> index f76d773..dfdfdfd 100755
> --- a/scripts/update-linux-headers.sh
> +++ b/scripts/update-linux-headers.sh
> @@ -141,7 +141,7 @@ done
>  
>  rm -rf "$output/linux-headers/linux"
>  mkdir -p "$output/linux-headers/linux"
> -for header in kvm.h vfio.h vfio_ccw.h vhost.h \
> +for header in kvm.h vfio.h vfio_ccw.h vhost.h iommu.h \
>                psci.h psp-sev.h userfaultfd.h mman.h; do
>      cp "$tmpdir/include/linux/$header" "$output/linux-headers/linux"
>  done

Acked-by: Cornelia Huck <cohuck@redhat.com>

