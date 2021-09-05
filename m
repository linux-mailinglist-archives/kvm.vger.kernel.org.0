Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52A7401080
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 17:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235924AbhIEPQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 11:16:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229566AbhIEPQ2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Sep 2021 11:16:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630854924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5ZzmZ3cm/kvau4n2g5RTLrehaLVkdjZ73wl5vRun3Qc=;
        b=jSK9066dndq/16yyZBjVD5G0DhGL841NBQX95/08sI4ETdDbUXTWGI8788lkGLXBurmWa3
        eic/dwJ7/bEGq9U6YkgPzMlp+mwLEhKpXO2rDPnAPevhFIrHvcAbJrIw6SUHOfZDNZw2Hu
        Id2QV8oeQD0UGizoVFqZbUWG6vS3P6Q=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-h8Dv_jffOk-RnHNIB-nekQ-1; Sun, 05 Sep 2021 11:15:23 -0400
X-MC-Unique: h8Dv_jffOk-RnHNIB-nekQ-1
Received: by mail-ed1-f71.google.com with SMTP id h4-20020aa7c604000000b003c423efb7efso2407937edq.12
        for <kvm@vger.kernel.org>; Sun, 05 Sep 2021 08:15:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5ZzmZ3cm/kvau4n2g5RTLrehaLVkdjZ73wl5vRun3Qc=;
        b=OxoHhRU6/Co8kfqnQBHrqgXdjJnL3WjSpOOsiC8gO1GVZOMs3lmz4vyuifBDPFwxl6
         XkXgt26r214Qo4MA4fwPUwtf7pOROEwnvYIV+kpITfY97jMHOHsOIJp84SwL8+Zw8+J6
         kBulvaDx9UkEbKp1JS918txYtUUb4oLifG5MRQYm7AzhOPPIyCJz7yjF/N8Tya/Jikm3
         oOobS/chrSZn+CXX6Ejks76AfZ8ZNRQrNH9+3T8J8HH7Q2zTlXsnKDSUKvslhSMd9phT
         5Ni5TU//W8TzcsGGgMlnKWOF1EYEvaPkaYMyP/GGDniDF+HS+9VENj8EdIKq4eBJceyM
         2qvA==
X-Gm-Message-State: AOAM530t1dGO7vpuMcQhHMpCQUo74A2yJ+YazBUjmuhzBHBdH6CF3Hl3
        pv6QeLFgQ5VTNLOoRar70hqOCKVsv9VED0wrWoLLJDknulMBqapF7XScNfFsaykCxbEwibdlJZU
        vAYUUSQyj8lff
X-Received: by 2002:a17:906:1f54:: with SMTP id d20mr9200341ejk.48.1630854922110;
        Sun, 05 Sep 2021 08:15:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWbCojxNISr+mKnf+beM5xR3SEos+shGuS9gvYwwtR/FWexU0zALsrFPLXDAs6YgRpFnkV0Q==
X-Received: by 2002:a17:906:1f54:: with SMTP id d20mr9200330ejk.48.1630854921973;
        Sun, 05 Sep 2021 08:15:21 -0700 (PDT)
Received: from redhat.com ([2.55.131.183])
        by smtp.gmail.com with ESMTPSA id cf11sm2997982edb.65.2021.09.05.08.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 08:15:20 -0700 (PDT)
Date:   Sun, 5 Sep 2021 11:15:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, hch@infradead.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, israelr@nvidia.com, nitzanc@nvidia.com,
        oren@nvidia.com, linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH v3 1/1] virtio-blk: add num_request_queues module
 parameter
Message-ID: <20210905111415-mutt-send-email-mst@kernel.org>
References: <20210902204622.54354-1-mgurtovoy@nvidia.com>
 <YTR12AHOGs1nhfz1@unreal>
 <b2e60035-2e63-3162-6222-d8c862526a28@gmail.com>
 <YTSZ6CYM6BCsbVmk@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTSZ6CYM6BCsbVmk@unreal>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 05, 2021 at 01:20:24PM +0300, Leon Romanovsky wrote:
> On Sun, Sep 05, 2021 at 01:49:46AM -0700, Chaitanya Kulkarni wrote:
> > 
> > On 9/5/2021 12:46 AM, Leon Romanovsky wrote:
> > > > +static unsigned int num_request_queues;
> > > > +module_param_cb(num_request_queues, &queue_count_ops, &num_request_queues,
> > > > +		0644);
> > > > +MODULE_PARM_DESC(num_request_queues,
> > > > +		 "Number of request queues to use for blk device. Should > 0");
> > > > +
> > > Won't it limit all virtio block devices to the same limit?
> > > 
> > > It is very common to see multiple virtio-blk devices on the same system
> > > and they probably need different limits.
> > > 
> > > Thanks
> > 
> > 
> > Without looking into the code, that can be done adding a configfs
> > 
> > interface and overriding a global value (module param) when it is set from
> > 
> > configfs.
> 
> So why should we do double work instead of providing one working
> interface from the beginning?
> 
> Thanks
> 
> > 
> > 

The main way to do it is really from the hypervisor. This one
is a pretty blunt instrument, Max here says it's useful to reduce
memory usage of the driver. If that's the usecase then a global limit
seems sufficient.

-- 
MST

