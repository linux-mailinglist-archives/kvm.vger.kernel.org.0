Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B5132EF0A
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 16:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhCEPhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 10:37:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36288 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229446AbhCEPhS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Mar 2021 10:37:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614958638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VM5usnxbwbdMQmAkNqSEXWFDqDsME8ZUFNJtssClblc=;
        b=a6zRAOpRwek2kvaw/RhLdBze0Wgz99WNFvSkKWAh237SPoMWepqrLMFOqho+pe+dtZrIV+
        EzhYCA0xo1h315kT4AOOrhBmof1MSfasBoW1K8LdRgDCEPPng+DWweTqIGz/Mw0mB/CkUY
        zB/b1cdpQ3dIYQ7Sv4UtzIVAKyFdFjc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-k-6sOvr5PXWdXILqxO3e4A-1; Fri, 05 Mar 2021 10:37:16 -0500
X-MC-Unique: k-6sOvr5PXWdXILqxO3e4A-1
Received: by mail-qt1-f199.google.com with SMTP id h13so1872220qti.21
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 07:37:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VM5usnxbwbdMQmAkNqSEXWFDqDsME8ZUFNJtssClblc=;
        b=a+iO80eHKbPQ0RssALbBACxK1ZhBu9fYi00NMzp5SdTpj/0yHwYAWcavZuDADind8E
         gI+w0lr+GgajfhDs2VVkiEHZnt6gcdS1mqWv+QUOb8IsNpFDkw79xeF+8apUzC5KjgBd
         6/BGeWluLCdPN4/f/58luDsu1wuH1kQt2ahlAVtGIkbrczBGfb2bZrMKg8wTMGZjAcQK
         v6QHwX/21sEJpVut9nZ2OJGQrZP+4ZY3hjXx/WEhVUP0sRLQiGOz7XCs7DsDwfIwr2hd
         iTkDCiu1hh8cAgJOPtc7VysksOhhjzJynvoSVydaH2qPsr1kbDzUCVbtn4l0aP6AVMTm
         pz/A==
X-Gm-Message-State: AOAM532esUUJ+l5ecwjRSA7mLqL7mr3Ue/amrJmpLzKb2qcYyGx5VrVu
        LgXHmxmc/jUxZjTPcR1AAneS2fKnSqKi9iXLbgUnYHYdM9wnVuevKf14Z0y3f10nXPG2oe/5CWg
        XXJBiYNHcGO+B
X-Received: by 2002:a05:6214:aae:: with SMTP id ew14mr9540457qvb.24.1614958636122;
        Fri, 05 Mar 2021 07:37:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyB4JZtMASx0k65cuavabY0PrSoysqOM6feB49hI/cytiY6dkQjJwkq5kXlzFeukx6oQdfC4A==
X-Received: by 2002:a05:6214:aae:: with SMTP id ew14mr9540423qvb.24.1614958635882;
        Fri, 05 Mar 2021 07:37:15 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-25-174-95-95-253.dsl.bell.ca. [174.95.95.253])
        by smtp.gmail.com with ESMTPSA id a9sm1995727qtx.96.2021.03.05.07.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 07:37:15 -0800 (PST)
Date:   Fri, 5 Mar 2021 10:37:13 -0500
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Kotrasinski <i.kotrasinsk@partner.samsung.com>,
        Juan Quintela <quintela@redhat.com>,
        Stefan Weil <sw@weilnetz.de>, Thomas Huth <thuth@redhat.com>,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org
Subject: Re: [PATCH v2 7/9] memory: introduce RAM_NORESERVE and wire it up in
 qemu_ram_mmap()
Message-ID: <20210305153713.GG397383@xz-x1>
References: <20210305101634.10745-1-david@redhat.com>
 <20210305101634.10745-8-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210305101634.10745-8-david@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 05, 2021 at 11:16:32AM +0100, David Hildenbrand wrote:
> Let's introduce RAM_NORESERVE, allowing mmap'ing with MAP_NORESERVE. The
> new flag has the following semantics:
> 
>   RAM is mmap-ed with MAP_NORESERVE. When set, reserving swap space (or
>   huge pages on Linux) is skipped: will bail out if not supported. When not
>   set, the OS might reserve swap space (or huge pages on Linux), depending
>   on OS support.
> 
> Allow passing it into:
> - memory_region_init_ram_nomigrate()
> - memory_region_init_resizeable_ram()
> - memory_region_init_ram_from_file()
> 
> ... and teach qemu_ram_mmap() and qemu_anon_ram_alloc() about the flag.
> Bail out if the flag is not supported, which is the case right now for
> both, POSIX and win32. We will add the POSIX mmap implementation next and
> allow specifying RAM_NORESERVE via memory backends.
> 
> The target use case is virtio-mem, which dynamically exposes memory
> inside a large, sparse memory area to the VM.
> 
> Cc: Juan Quintela <quintela@redhat.com>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Thomas Huth <thuth@redhat.com>
> Cc: Stefan Weil <sw@weilnetz.de>
> Cc: kvm@vger.kernel.org
> Cc: qemu-s390x@nongnu.org
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

