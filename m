Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC7694F90
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 23:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbfHSVId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 17:08:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbfHSVId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 17:08:33 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C5D6D7BDAC
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:08:32 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id o13so5818825wrx.20
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 14:08:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LPz289eUqMdVK44r3XmdrIn3iZGWOuftMF6bJgSrgXw=;
        b=iczRtKUataFH2/2CT840ZuPSJaWFEE3md4rq1IA6QlMAxpGXVOZaYPlQuYK2mwhSqZ
         f4dLwXNRaQBsGDVRht/wJmcobT8SQWNLZJ9F5y62yAjuGBVcSHOoe/7X8OXy8FglGXha
         yBmxAI+zNSDoumZnLe4oz6KeDUcq+87JtHV9ElBfG0jxOluF6kYSfY6OEAHxv1iHYnCz
         q/LQswFdAZO9q73LH+erRP85S0ruzAWchg/KCQmBIe1jh1UwwDxnnNDkWFh4hpPpuZfl
         E0l7v20SXtH6wDT8hJ8rY0XPTu0jZzOvmKhskz0mfFX2Fivlobf2E5ylMl4MvlO2OLXe
         De2Q==
X-Gm-Message-State: APjAAAUuYf4D5vwLrFWrjJ7UMRniRPACz1U9rEckeoOBLbGIOaunjBAy
        afH8Saqyn2AqNNIH7OZlPmhsqvbEhIRDhbIIGmWiyDMyazHhRMrbaP7Fj76BlWWALjeXxCx/0ak
        Wx+yIvkxhisVB
X-Received: by 2002:a1c:1ac2:: with SMTP id a185mr22464974wma.96.1566248911492;
        Mon, 19 Aug 2019 14:08:31 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzzkGtqGEh4bXvK+QUgFZWjgeN4BxKK01EdaQMhbc46GISjxsEbgjr0J/8MhISgz5u3RfrvFQ==
X-Received: by 2002:a1c:1ac2:: with SMTP id a185mr22464968wma.96.1566248911216;
        Mon, 19 Aug 2019 14:08:31 -0700 (PDT)
Received: from redhat.com (bzq-79-180-62-110.red.bezeqint.net. [79.180.62.110])
        by smtp.gmail.com with ESMTPSA id 74sm28893350wma.15.2019.08.19.14.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 14:08:30 -0700 (PDT)
Date:   Mon, 19 Aug 2019 17:08:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jgg@ziepe.ca
Subject: Re: [PATCH V5 0/9] Fixes for vhost metadata acceleration
Message-ID: <20190819162733-mutt-send-email-mst@kernel.org>
References: <20190809054851.20118-1-jasowang@redhat.com>
 <20190810134948-mutt-send-email-mst@kernel.org>
 <360a3b91-1ac5-84c0-d34b-a4243fa748c4@redhat.com>
 <20190812054429-mutt-send-email-mst@kernel.org>
 <663be71f-f96d-cfbc-95a0-da0ac6b82d9f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <663be71f-f96d-cfbc-95a0-da0ac6b82d9f@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 13, 2019 at 04:12:49PM +0800, Jason Wang wrote:
> 
> On 2019/8/12 下午5:49, Michael S. Tsirkin wrote:
> > On Mon, Aug 12, 2019 at 10:44:51AM +0800, Jason Wang wrote:
> > > On 2019/8/11 上午1:52, Michael S. Tsirkin wrote:
> > > > On Fri, Aug 09, 2019 at 01:48:42AM -0400, Jason Wang wrote:
> > > > > Hi all:
> > > > > 
> > > > > This series try to fix several issues introduced by meta data
> > > > > accelreation series. Please review.
> > > > > 
> > > > > Changes from V4:
> > > > > - switch to use spinlock synchronize MMU notifier with accessors
> > > > > 
> > > > > Changes from V3:
> > > > > - remove the unnecessary patch
> > > > > 
> > > > > Changes from V2:
> > > > > - use seqlck helper to synchronize MMU notifier with vhost worker
> > > > > 
> > > > > Changes from V1:
> > > > > - try not use RCU to syncrhonize MMU notifier with vhost worker
> > > > > - set dirty pages after no readers
> > > > > - return -EAGAIN only when we find the range is overlapped with
> > > > >     metadata
> > > > > 
> > > > > Jason Wang (9):
> > > > >     vhost: don't set uaddr for invalid address
> > > > >     vhost: validate MMU notifier registration
> > > > >     vhost: fix vhost map leak
> > > > >     vhost: reset invalidate_count in vhost_set_vring_num_addr()
> > > > >     vhost: mark dirty pages during map uninit
> > > > >     vhost: don't do synchronize_rcu() in vhost_uninit_vq_maps()
> > > > >     vhost: do not use RCU to synchronize MMU notifier with worker
> > > > >     vhost: correctly set dirty pages in MMU notifiers callback
> > > > >     vhost: do not return -EAGAIN for non blocking invalidation too early
> > > > > 
> > > > >    drivers/vhost/vhost.c | 202 +++++++++++++++++++++++++-----------------
> > > > >    drivers/vhost/vhost.h |   6 +-
> > > > >    2 files changed, 122 insertions(+), 86 deletions(-)
> > > > This generally looks more solid.
> > > > 
> > > > But this amounts to a significant overhaul of the code.
> > > > 
> > > > At this point how about we revert 7f466032dc9e5a61217f22ea34b2df932786bbfc
> > > > for this release, and then re-apply a corrected version
> > > > for the next one?
> > > 
> > > If possible, consider we've actually disabled the feature. How about just
> > > queued those patches for next release?
> > > 
> > > Thanks
> > Sorry if I was unclear. My idea is that
> > 1. I revert the disabled code
> > 2. You send a patch readding it with all the fixes squashed
> > 3. Maybe optimizations on top right away?
> > 4. We queue *that* for next and see what happens.
> > 
> > And the advantage over the patchy approach is that the current patches
> > are hard to review. E.g.  it's not reasonable to ask RCU guys to review
> > the whole of vhost for RCU usage but it's much more reasonable to ask
> > about a specific patch.
> 
> 
> Ok. Then I agree to revert.
> 
> Thanks

Great, so please send the following:
- revert
- squashed and fixed patch

-- 
MST
