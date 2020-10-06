Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2922284F18
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 17:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgJFPgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 11:36:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57659 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbgJFPgW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 11:36:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601998581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RCh4ickvhv/fi0cK0c0ZcprG+robtaW1/Re2f+LYxuU=;
        b=M6XQjlZwoux7B5hPUBCAyfcy6zPFlWESf5sFZXof2gyoSTgWeJLN7KCxKOg+Ei6fQvVzox
        m/xSi8dYjpPe9LLpzocxnGUzQFaOBUt+G6YWYq6V6ta077N4bZx58ueLa7FvSR8zz62F4t
        7EvYyivulRGaGj3aXmRmOB1mKb/5vDY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-lHlTVva4PbG0RCoS7It46w-1; Tue, 06 Oct 2020 11:36:18 -0400
X-MC-Unique: lHlTVva4PbG0RCoS7It46w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52FB9801F99;
        Tue,  6 Oct 2020 15:36:16 +0000 (UTC)
Received: from gondolin (ovpn-112-156.ams2.redhat.com [10.36.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A0B855782;
        Tue,  6 Oct 2020 15:36:04 +0000 (UTC)
Date:   Tue, 6 Oct 2020 17:36:01 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/9] update-linux-headers: Add vfio_zdev.h
Message-ID: <20201006173601.745ab841.cohuck@redhat.com>
In-Reply-To: <1601669191-6731-4-git-send-email-mjrosato@linux.ibm.com>
References: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
        <1601669191-6731-4-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Oct 2020 16:06:25 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> vfio_zdev.h is used by s390x zPCI support to pass device-specific
> CLP information between host and userspace.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  scripts/update-linux-headers.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
> index 29c27f4..9efbaf2 100755
> --- a/scripts/update-linux-headers.sh
> +++ b/scripts/update-linux-headers.sh
> @@ -141,7 +141,7 @@ done
>  
>  rm -rf "$output/linux-headers/linux"
>  mkdir -p "$output/linux-headers/linux"
> -for header in kvm.h vfio.h vfio_ccw.h vhost.h \
> +for header in kvm.h vfio.h vfio_ccw.h vfio_zdev.h vhost.h \
>                psci.h psp-sev.h userfaultfd.h mman.h; do
>      cp "$tmpdir/include/linux/$header" "$output/linux-headers/linux"
>  done

Obviously requires the kernel part to be merged first, but

Acked-by: Cornelia Huck <cohuck@redhat.com>

