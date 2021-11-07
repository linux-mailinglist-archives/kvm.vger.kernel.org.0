Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4AE447280
	for <lists+kvm@lfdr.de>; Sun,  7 Nov 2021 11:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbhKGKYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Nov 2021 05:24:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32939 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229713AbhKGKYi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 7 Nov 2021 05:24:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636280514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=atZ/pePHP/+NA64gKuXMrnkZMDn3k3mW+OH37h9DxL0=;
        b=iH0sBKDZHJkp9qX/qdECjL9uq0OlxN5uU8ESq3ys2Gwgk8LI5jar16n6BGhW0EMrhZNH5A
        XM8A1hUxFj8zH0YcjICzlcIHr+Qtua2tVVCJ6pOABCXUlUTS+5cFhpTfn1RXKqymPhfbSA
        bcM7bq9ilyrUJvLIRDSuC92Ahw1tRpM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-ArKhxayNOj29lI_svx5apA-1; Sun, 07 Nov 2021 05:21:53 -0500
X-MC-Unique: ArKhxayNOj29lI_svx5apA-1
Received: by mail-wr1-f72.google.com with SMTP id h13-20020adfa4cd000000b001883fd029e8so2260901wrb.11
        for <kvm@vger.kernel.org>; Sun, 07 Nov 2021 02:21:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=atZ/pePHP/+NA64gKuXMrnkZMDn3k3mW+OH37h9DxL0=;
        b=ufnnp8NZYYwFkL62uKtVGZV+XO3ux8jjPiEJcfqihbfCqz6nkJO81XWNRS2rqV55G3
         WZArI00XP4/xUfkIoqaGJB6kNjkO2GTwi2voRKRm0Jrz5kpsCJ+GtmGOCoR/jJX3FCxn
         JZoyulbpqz/fYIqG9SVAodAcn4qIUmVEV39huUNeoVZYIcB8L5b7/o/1ipzuk5n9Cjzr
         GapkYgWBUMTXXcF4A2l3mVkVW5ql5NC8l7gMIO7db4T13Y1oGsImKeE2jGvyEg+bV023
         z/QxKXsE8DxNJIl3nLuS1nalq9xM7GDAx2tlJbTlTUd9p61Ll802XQTHHH3uZNTNECJz
         9kFQ==
X-Gm-Message-State: AOAM531VKQDXdh25bAGtMe16T2BzPrTQh8i8cA709NTmX2sFwuvok1z4
        X2j3fY37iSphGPmLAsF32BRnBEWg7yOV04HduUtPOQSnKoCVECGNjWYhGwhzQGYr3zQ4KDEOCzl
        yw91VLkmhyGUT
X-Received: by 2002:a5d:6d09:: with SMTP id e9mr68805528wrq.17.1636280512544;
        Sun, 07 Nov 2021 02:21:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwCEewVH1OASVQ31el9e2Z4O/i0wt4tV7KOU+PlG2161rRgIcKJYPJIr6YcXG1iHgRfkCDAnA==
X-Received: by 2002:a5d:6d09:: with SMTP id e9mr68805499wrq.17.1636280512331;
        Sun, 07 Nov 2021 02:21:52 -0800 (PST)
Received: from redhat.com ([2.55.155.32])
        by smtp.gmail.com with ESMTPSA id f6sm12732558wmj.40.2021.11.07.02.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 02:21:51 -0800 (PST)
Date:   Sun, 7 Nov 2021 05:21:46 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <ani@anisinha.ca>, Peter Xu <peterx@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        Hui Zhu <teawater@gmail.com>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1 00/12] virtio-mem: Expose device memory via multiple
 memslots
Message-ID: <20211107051832-mutt-send-email-mst@kernel.org>
References: <20211027124531.57561-1-david@redhat.com>
 <20211101181352-mutt-send-email-mst@kernel.org>
 <a5c94705-b66d-1b19-1c1f-52e99d9dacce@redhat.com>
 <20211102072843-mutt-send-email-mst@kernel.org>
 <171c8ed0-d55e-77ef-963b-6d836729ef4b@redhat.com>
 <20211102111228-mutt-send-email-mst@kernel.org>
 <e4b63a74-57ad-551c-0046-97a02eb798e5@redhat.com>
 <20211107031316-mutt-send-email-mst@kernel.org>
 <f6071d5f-d100-a128-9f66-a801436aa78a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6071d5f-d100-a128-9f66-a801436aa78a@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 07, 2021 at 10:21:33AM +0100, David Hildenbrand wrote:
> Let's not focus on b), a) is the primary goal of this series:
> 
> "
> a) Reduce the metadata overhead, including bitmap sizes inside KVM but
> also inside QEMU KVM code where possible.
> "
> 
> Because:
> 
> "
> For example, when starting a VM with a 1 TiB virtio-mem device that only
> exposes little device memory (e.g., 1 GiB) towards the VM initialliy,
> in order to hotplug more memory later, we waste a lot of memory on
> metadata for KVM memory slots (> 2 GiB!) and accompanied bitmaps.
> "
> 
> Partially tackling b) is just a nice side effect of this series. In the
> long term, we'll want userfaultfd-based protection, and I'll do a
> performance evaluation then, how userfaultf vs. !userfaultfd compares
> (boot time, run time, THP consumption).
> 
> I'll adjust the cover letter for the next version to make this clearer.

So given this is short-term, and long term we'll use uffd possibly with
some extension (a syscall to populate 1G in one go?) isn't there some
way to hide this from management? It's a one way street: once we get
management involved in playing with memory slots we no longer can go
back and control them ourselves. Not to mention it's a lot of
complexity to push out to management.

-- 
MST

