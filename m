Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD64C3F9505
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 09:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244382AbhH0HWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 03:22:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231592AbhH0HWi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 03:22:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630048909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P7AbRF8g9kF3iNkqSowKy6V7iUBVivXq+0DaEzOiKbQ=;
        b=ApkQJ8LCgXiISL9YJXpqGd5l/EZ2QIWNLlzqarCTlCYNLl/tp8FZ3HbUfT+yIWsqEyGxFi
        /R4FPrqj3KV01s5q3gy7DIZgAskmAvElw9bF5WgHXQw2MYg6NL4zQ2scK+bvsM2X06Q5gx
        3NcKv2S/NiOvY7NRB78rDutwzX+s0nQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-VJs92tnTPSaN-pklgz7dXA-1; Fri, 27 Aug 2021 03:21:48 -0400
X-MC-Unique: VJs92tnTPSaN-pklgz7dXA-1
Received: by mail-ej1-f71.google.com with SMTP id yz13-20020a170906dc4d00b005c61ad936f0so2269889ejb.12
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 00:21:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P7AbRF8g9kF3iNkqSowKy6V7iUBVivXq+0DaEzOiKbQ=;
        b=hYfDgUezOTQc+VgMkpe4AVMKH9naJUaP922n9mE9xYc4LB4YeZfAwQBIkBQ8zyk4ss
         3ut7wPlzfeRJD6RxBfKjj1yfynRVJ7kY0kYEV7L6e5lsX5mnWlN1GywNnfs05ScuFwjW
         IDfmPgMzMuksq6OwL5L0lg7siUVrwspn9VPEzVu0FHStZ/fPjrBlZuWXfRcXUjXnel0z
         gOhyHkBqinozWjtOjn7HHxqN+2TPriDMeNmQA2dYbHZJ6yvdZH5H6WFhJIHGOHKseoxr
         Eb/OqbCNIimqbpN+2uY1X1wtMuEN809xzHYWP+EvBR0xFyHOoNTFzCvBRFLbgAQMVsVa
         8i0g==
X-Gm-Message-State: AOAM530iBZ5wbChosrzVKceDMAnpKXOL5sdlSrsK0M4EgsKz1vLtW8nQ
        5gSwMn377RHttqy5b03erLAI8YRiJlpDgYBZxdDwTiIeE48W8R+tSAytZAWatrXHVD+4hbbcNIx
        RiROjOPGW4GDP
X-Received: by 2002:a17:906:1fd4:: with SMTP id e20mr8626095ejt.421.1630048907007;
        Fri, 27 Aug 2021 00:21:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWg1xXqNiorZgR8T58rEsVQDwfH5wUl/c8mZleWZuPOQ+ZXA/1mYSSRDNOCZCEBjdvKW8w2g==
X-Received: by 2002:a17:906:1fd4:: with SMTP id e20mr8626079ejt.421.1630048906799;
        Fri, 27 Aug 2021 00:21:46 -0700 (PDT)
Received: from steredhat (host-79-36-51-142.retail.telecomitalia.it. [79.36.51.142])
        by smtp.gmail.com with ESMTPSA id n15sm2916196edw.70.2021.08.27.00.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 00:21:46 -0700 (PDT)
Date:   Fri, 27 Aug 2021 09:21:44 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Andra Paraschiv <andraprs@amazon.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>
Subject: Re: [PATCH v1 2/3] nitro_enclaves: Update documentation for Arm
 support
Message-ID: <20210827072144.gqncsq42vfpzmoxl@steredhat>
References: <20210826173451.93165-1-andraprs@amazon.com>
 <20210826173451.93165-3-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210826173451.93165-3-andraprs@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 08:34:50PM +0300, Andra Paraschiv wrote:
>Add references for hugepages and booting steps for Arm.
>
>Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>---
> Documentation/virt/ne_overview.rst | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)

If you need to respin, maybe we can add a little section with supported 
architectures (x86, ARM64).

Stefano

>
>diff --git a/Documentation/virt/ne_overview.rst b/Documentation/virt/ne_overview.rst
>index 39b0c8fe2654a..2777da1fb0ad1 100644
>--- a/Documentation/virt/ne_overview.rst
>+++ b/Documentation/virt/ne_overview.rst
>@@ -43,8 +43,8 @@ for the enclave VM. An enclave does not have persistent storage attached.
> The memory regions carved out of the primary VM and given to an enclave need to
> be aligned 2 MiB / 1 GiB physically contiguous memory regions (or multiple of
> this size e.g. 8 MiB). The memory can be allocated e.g. by using hugetlbfs from
>-user space [2][3]. The memory size for an enclave needs to be at least 64 MiB.
>-The enclave memory and CPUs need to be from the same NUMA node.
>+user space [2][3][7]. The memory size for an enclave needs to be at least
>+64 MiB. The enclave memory and CPUs need to be from the same NUMA node.
>
> An enclave runs on dedicated cores. CPU 0 and its CPU siblings need to remain
> available for the primary VM. A CPU pool has to be set for NE purposes by an
>@@ -61,7 +61,7 @@ device is placed in memory below the typical 4 GiB.
> The application that runs in the enclave needs to be packaged in an enclave
> image together with the OS ( e.g. kernel, ramdisk, init ) that will run in the
> enclave VM. The enclave VM has its own kernel and follows the standard Linux
>-boot protocol [6].
>+boot protocol [6][8].
>
> The kernel bzImage, the kernel command line, the ramdisk(s) are part of the
> Enclave Image Format (EIF); plus an EIF header including metadata such as magic
>@@ -93,3 +93,5 @@ enclave process can exit.
> [4] https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
> [5] https://man7.org/linux/man-pages/man7/vsock.7.html
> [6] https://www.kernel.org/doc/html/latest/x86/boot.html
>+[7] https://www.kernel.org/doc/html/latest/arm64/hugetlbpage.html
>+[8] https://www.kernel.org/doc/html/latest/arm64/booting.html
>-- 
>2.20.1 (Apple Git-117)
>
>
>
>
>Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in Romania. Registration number J22/2621/2005.
>

