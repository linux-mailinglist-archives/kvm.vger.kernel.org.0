Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34013FFCB0
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 11:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348624AbhICJFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 05:05:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57959 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348581AbhICJFs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 05:05:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630659886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a35OZamz4FhULMDWjA+MIpzd8IbhFlUnBRFIx65TG18=;
        b=Zt4azUur3K5JP76jjkcBUcrgj6sagIWwhRb0BV5U+R5pIrRdRakAjFcJI1tzEXaapHvLrl
        TbnOMZcS6p3bMn2mO24JsecV+eewtVDR/gSXmRtT/smdc3ZMOvZXNuwlfORkVw6ScxSkVI
        UkHHszdLfi+GH1LqODC/M0yQe2JJy7g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-taJ6EHrzP9KP9yy8pjpZQg-1; Fri, 03 Sep 2021 05:04:45 -0400
X-MC-Unique: taJ6EHrzP9KP9yy8pjpZQg-1
Received: by mail-wm1-f71.google.com with SMTP id p29-20020a1c545d000000b002f88d28e1f1so712661wmi.7
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 02:04:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a35OZamz4FhULMDWjA+MIpzd8IbhFlUnBRFIx65TG18=;
        b=ZDu4ZHJ4QzeJ8n3kbE5Vuj+JM7bnmlKfcCn3otXKxcXPNANrrrixE6hIYRiQnO17QK
         Huw9/ujEiWVqkfwrR88cqaeLffLRyPNF8VZMWFrEVWMYzKdMSSDs4rBNowLZt9X/omqc
         XCoX7lCP4zhNbQHjQ8J5xr5Bp6EB33ob2eV01GGl/2lfn7tS4BAAX35ugBPYA0WxIlBA
         pjXBJ8ccr7HQbvPRQdMrmdygPXqJ+4VBSn+khHGnvyReLPGiuyRLhVnGQ1DKk433Ia+C
         msa2LFxpOaeO+d2mSkRkunJswK/SJxOVbdlZlmUFz6Do6iMLJVIQWJNefEjrSv8YwEVM
         D1tA==
X-Gm-Message-State: AOAM530SU0+4FYsSiAo/fRfZtZgtQFLEo7JHcTG8nn6rrl8JMqKzfKwN
        VQKat2KKea3c6uiEVDxoIig/khqJ8FdgptjC6JhyQnDA1kYUUlRTvoKB2eR2vAYV76Vm5lAWzsD
        6pJoDP/WDvcmG
X-Received: by 2002:a7b:cd82:: with SMTP id y2mr7316053wmj.4.1630659883799;
        Fri, 03 Sep 2021 02:04:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxq1o45OPMNe+RtszcnJRaHC5co9mJquGrSZkuN/bgyyco2U6W6QjJBBk7GWQODKEhxLdyBqQ==
X-Received: by 2002:a7b:cd82:: with SMTP id y2mr7316037wmj.4.1630659883591;
        Fri, 03 Sep 2021 02:04:43 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:207f:7f47:ccd3:7600:6a2d:c5a])
        by smtp.gmail.com with ESMTPSA id h8sm3665497wmb.35.2021.09.03.02.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 02:04:42 -0700 (PDT)
Date:   Fri, 3 Sep 2021 05:04:38 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        oren@nvidia.com, linux-block@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 1/1] virtio-blk: remove unneeded "likely" statements
Message-ID: <20210903050418-mutt-send-email-mst@kernel.org>
References: <20210830120111.22661-1-mgurtovoy@nvidia.com>
 <YTDnD1c8rk3SWcx9@stefanha-x1.localdomain>
 <6800aad7-038a-b251-4ad5-3dc005b0a8a1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6800aad7-038a-b251-4ad5-3dc005b0a8a1@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 02, 2021 at 10:13:04PM +0300, Max Gurtovoy wrote:
> 
> On 9/2/2021 6:00 PM, Stefan Hajnoczi wrote:
> > On Mon, Aug 30, 2021 at 03:01:11PM +0300, Max Gurtovoy wrote:
> > > Usually we use "likely/unlikely" to optimize the fast path. Remove
> > > redundant "likely" statements in the control path to ease on the code.
> > > 
> > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > ---
> > >   drivers/block/virtio_blk.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > It would be nice to tweak the commit description before merging this. I
> > had trouble parsing the second sentence. If I understand correctly the
> > purpose of this patch is to make the code simpler and easier to read:
> > 
> >    s/ease on the code/simplify the code and make it easier to read/
> 
> I'm ok with this change in commit message.
> 
> MST,
> 
> can you apply this change if you'll pick this commit ?
> 
> -Max.


Just repost with a fixed commit log pls, easier for me.
Thanks!

> > 
> > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

