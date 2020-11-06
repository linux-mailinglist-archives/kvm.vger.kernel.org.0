Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05C12A9589
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 12:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgKFLhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 06:37:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726694AbgKFLhF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 06:37:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604662623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZbI9mXtuIvuDTrdiKj8oxalc7jVWcCR4Pepa6yW8fF4=;
        b=ehYW3WLD9fQ7R7RNLpeggQVujP4a+7+RIOPwI1RQHBy6lTpSDT079NSrelIzCJ6UbV8ml6
        zb+LVSdfjowrH7yB6ZqCUIVi+dtg9w0qSPBj5sK7c2t5iGhMFKl6DIyMyyjCPI33M1F22n
        eJEVV3ZNoMK3h5fYF9GbSx7VPqkUPog=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-nPD_yKwpOV2SVW3HCOuF2g-1; Fri, 06 Nov 2020 06:37:01 -0500
X-MC-Unique: nPD_yKwpOV2SVW3HCOuF2g-1
Received: by mail-wm1-f70.google.com with SMTP id s85so326587wme.3
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 03:37:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZbI9mXtuIvuDTrdiKj8oxalc7jVWcCR4Pepa6yW8fF4=;
        b=C2pBfCrVaQ0906A21KzAfkd/UuyTOQH/Cmid6WbYzCzNobO1gYFC7gOspbKTM1gBlX
         BUF5MH/f59AXCfMXQLWsbBysst0FVh//s6bJu65KEiUEBBUK29o70a4e8a9pVF0W+XrA
         oKpd3Od50miOfbvW49NpA4JRUdRnV0YnJafsSsHh3CmU1D3DjGC3IRHBSpaMoB8tc1o9
         3/wmvcCHmTVcS3dlfjOeKGGZzjsnVWTtbyHq4xhw3O7YE5KBPKrJpym6BDe0SWODlYOr
         F4llKz6gIHGplSIEFwhcesNZZDeeY28mf0yWDKZfzcPzyP1MIqMlPkWX+Gl/znMDmH5A
         e1Xg==
X-Gm-Message-State: AOAM532fs8+jPtwnZQfGeqOqX2Up/EyM5jTPWhJl2Uc+wgq5Ym3hgsPV
        xoJit2LSrV4xqn6AMzt0H7MQsXOrjQ8veNFJwXaQFHadJCG03ro6JzhRjPd4LtsbZ2yGSVUXIsx
        D5LpBtbk0kN4k
X-Received: by 2002:a1c:7dd0:: with SMTP id y199mr2062690wmc.95.1604662620700;
        Fri, 06 Nov 2020 03:37:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQWQPRPJBn27M2BnKtV2uKV5WjBwMgsgig7WeNc+iEAi98uXq7WlamnKrvIi9GhGV/LLmvhQ==
X-Received: by 2002:a1c:7dd0:: with SMTP id y199mr2062674wmc.95.1604662620460;
        Fri, 06 Nov 2020 03:37:00 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id i11sm1651635wro.85.2020.11.06.03.36.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Nov 2020 03:36:59 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v2 0/7] Rewrite the allocators
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, lvivier@redhat.com
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a75e5ac1-b456-90af-b584-e3c3b1fee8ef@redhat.com>
Date:   Fri, 6 Nov 2020 12:36:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201002154420.292134-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/20 17:44, Claudio Imbrenda wrote:
> The KVM unit tests are increasingly being used to test more than just
> KVM. They are being used to test TCG, qemu I/O device emulation, other
> hypervisors, and even actual hardware.
> 
> The existing memory allocators are becoming more and more inadequate to
> the needs of the upcoming unit tests (but also some existing ones, see
> below).
> 
> Some important features that are lacking:
> * ability to perform a small physical page allocation with a big
>    alignment withtout wasting huge amounts of memory
> * ability to allocate physical pages from specific pools/areaas (e.g.
>    below 16M, or 4G, etc)
> * ability to reserve arbitrary pages (if free), removing them from the
>    free pool
> 
> Some other features that are nice, but not so fundamental:
> * no need for the generic allocator to keep track of metadata
>    (i.e. allocation size), this is now handled by the lower level
>    allocators
> * coalescing small blocks into bigger ones, to allow contiguous memory
>    freed in small blocks in a random order to be used for large
>    allocations again
> 
> This is achieved in the following ways:
> 
> For the virtual allocator:
> * only the virtul allocator needs one extra page of metadata, but only
>    for allocations that wouldn't fit in one page
> 
> For the page allocator:
> * page allocator has up to 6 memory pools, each pool has a metadata
>    area; the metadata has a byte for each page in the area, describing
>    the order of the block it belongs to, and whether it is free
> * if there are no free blocks of the desired size, a bigger block is
>    split until we reach the required size; the unused parts of the block
>    are put back in the free lists
> * if an allocation needs ablock with a larger alignment than its size, a
>    larger block of (at least) the required order is split; the unused parts
>    put back in the appropriate free lists
> * if the allocation could not be satisfied, the next allowed area is
>    searched; the allocation fails only when all allowed areas have been
>    tried
> * new functions to perform allocations from specific areas; the areas
>    are arch-dependent and should be set up by the arch code
> * for now x86 has a memory area for "lowest" memory under 16MB, one for
>    "low" memory under 4GB and one for the rest, while s390x has one for under
>    2GB and one for the rest; suggestions for more fine grained areas or for
>    the other architectures are welcome
> * upon freeing a block, an attempt is made to coalesce it into the
>    appropriate neighbour (if it is free), and so on for the resulting
>    larger block thus obtained
> 
> For the physical allocator:
> * the minimum alignment is now handled manually, since it has been
>    removed from the common struct
> 
> 
> This patchset addresses some current but otherwise unsolvable issues on
> s390x, such as the need to allocate a block under 2GB for each SMP CPU
> upon CPU activation.
> 
> This patchset has been tested on s390x, amd64 and i386. It has also been
> compiled on aarch64.
> 
> V1->V2:
> * Renamed some functions, as per review comments
> * Improved commit messages
> * Split the list handling functions into an independent header
> * Addded arch-specific headers to define the memory areas
> * Fixed some minor issues
> * The magic value for small allocations in the virtual allocator is now
>    put right before the returned pointer, like for large allocations
> * Added comments to make the code more readable
> * Many minor fixes

Queued with the exception of patch 6 (still waiting for the CI to 
finish, but still).

Paolo

