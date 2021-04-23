Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B78369B29
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 22:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243798AbhDWUPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 16:15:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39148 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229549AbhDWUPR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 16:15:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619208879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kPiSTsL8TiObPGwF4YH7BB+/X0Qk9VUlPRyHxvfkG+U=;
        b=b4iGB4Oi7KbFZ6x/CXxCStBb3dnlkKZtZz3t2RRoRFBvZxP7g0SiTxBZhA3SoZzdDs4lgt
        ue4OpCp/sJwmhZK+X2mS2H5mCL8EhbxCkIPPgemA79O/DmhbSXBJE9LGWp26T6Cf8m8AAT
        VJyUZYzYEZ6FxN907Ax9bPhLQdCGgfI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-EW1W6Bl-Prq_r8uX_y1soQ-1; Fri, 23 Apr 2021 16:14:37 -0400
X-MC-Unique: EW1W6Bl-Prq_r8uX_y1soQ-1
Received: by mail-wr1-f70.google.com with SMTP id 32-20020adf84230000b029010705438fbfso10354947wrf.21
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 13:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kPiSTsL8TiObPGwF4YH7BB+/X0Qk9VUlPRyHxvfkG+U=;
        b=W7MxVs3CRuTQZTZecZEoD2aQu45budYkmod+HcUfBMluC4OmDJVLKBJ/q/bBV93fAm
         +SOI6PIdIWYy+vjcGrOgg+538zLbEb6dbXZUzvtwQMo1E95Ib8DQygZTX1aZB2hnGROO
         ca7sdjl26fqW8jIHEOmUmyNFFp+V8mOS6r+/eSR6vQw/ro01zfoI44sx7L8QCIXLNDfr
         a4p8yUw5naOzwqfyGCLEudEtqLQTop+bEkfgBNSeRhcHrt8oeMl35toRhBdN+dtHGi6E
         YWwn1NCtlIuXCtRhSCLjp7ogjTe3js/G9uaGsuwcAh67akcVojtSk4RfuNwVQfzqiKGr
         Z6wA==
X-Gm-Message-State: AOAM532EC3I511GD/5AgsW231K73igMhptC/VBGbCAhzbtRksMZ0GVFA
        FB3lTc90VfBIFcEaOD5BnhjEYtWBscixydYBluOpHhqT96OGtgNG1c+uA2wWg2MhkamMN/N6RO4
        SMR9Y+UGC/urY
X-Received: by 2002:adf:f0cc:: with SMTP id x12mr6889801wro.16.1619208876781;
        Fri, 23 Apr 2021 13:14:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxS1qAa/j7zcr+DtFN+X2GWOzkZj3CTy5jb00vUo5xDAoIFKiSI5gTfVmMkq6tnjXpLfUWn/g==
X-Received: by 2002:adf:f0cc:: with SMTP id x12mr6889783wro.16.1619208876551;
        Fri, 23 Apr 2021 13:14:36 -0700 (PDT)
Received: from redhat.com (212.116.168.114.static.012.net.il. [212.116.168.114])
        by smtp.gmail.com with ESMTPSA id s14sm9819112wrm.51.2021.04.23.13.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 13:14:35 -0700 (PDT)
Date:   Fri, 23 Apr 2021 16:14:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        martin.radev@aisec.fraunhofer.de, konrad.wilk@oracle.com,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] Untrusted device support for virtio
Message-ID: <20210423161114-mutt-send-email-mst@kernel.org>
References: <20210421032117.5177-1-jasowang@redhat.com>
 <20210422063128.GB4176641@infradead.org>
 <0c61dcbb-ac5b-9815-a4a1-5f93ae640011@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0c61dcbb-ac5b-9815-a4a1-5f93ae640011@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021 at 04:19:16PM +0800, Jason Wang wrote:
> 
> 在 2021/4/22 下午2:31, Christoph Hellwig 写道:
> > On Wed, Apr 21, 2021 at 11:21:10AM +0800, Jason Wang wrote:
> > > The behaivor for non DMA API is kept for minimizing the performance
> > > impact.
> > NAK.  Everyone should be using the DMA API in a modern world.  So
> > treating the DMA API path worse than the broken legacy path does not
> > make any sense whatsoever.
> 
> 
> I think the goal is not treat DMA API path worse than legacy. The issue is
> that the management layer should guarantee that ACCESS_PLATFORM is set so
> DMA API is guaranteed to be used by the driver. So I'm not sure how much
> value we can gain from trying to 'fix' the legacy path. But I can change the
> behavior of legacy path to match DMA API path.
> 
> Thanks

I think before we maintain different paths with/without ACCESS_PLATFORM
it's worth checking whether it's even a net gain. Avoiding sharing
by storing data in private memory can actually turn out to be
a net gain even without DMA API.

It is worth checking what is the performance effect of this patch.


-- 
MST

