Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E25888F4AA
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 21:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbfHOTdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 15:33:04 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41498 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732500AbfHOTdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 15:33:04 -0400
Received: by mail-qt1-f195.google.com with SMTP id i4so3533994qtj.8
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2019 12:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=d/Vs2YH0f5xNou4jHOnIZOohEAfDIJUopBMHuRVrEaM=;
        b=DSQnzP2boVVz05frK9Rf9m+2jw7zFPx+9AUXj2jqSyufMDNrAKls4vo+Fb+WrAEgvO
         ktfk/TjL4ijraP2CEooza64EfLjaFdcqjeQ5Vv3suWLQE3AFJsd5YcPid89lanEu0ZoG
         VOQYC/bNeGf1IZi2CVdyacQhQw7JiSZnXckYhCGW/PB/p43g8HasbOXkyAfk/T5vpF3D
         xiyWjGC5nu7KpcLH5DDONB00uambPQIgUVk3jQbczWBzrPFHJZNpEMI+ZlEgjUg+75rH
         LjzpVx3i2jLsC6X0ifOF/LcBrXk/+s6IlAd5gRScNQG9jSmLI4mn6ct4mUNoFB6ybWFo
         /qdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=d/Vs2YH0f5xNou4jHOnIZOohEAfDIJUopBMHuRVrEaM=;
        b=BCnN4VVyPEeja0TsqdO8j/laWIMIUGSGPqZ9K7X0nFOTnQ7UGDH2idVtBrjnvq0HPt
         xsvdwwyq2z/84R+z/fxkGfmOFYUPx/pVn9f8T+iHnF51AeFTGz7x9DatpmJn6xfxFnIE
         2Nw1Q9QSi2f2eU8bQIlbXbG6cCC/HrssUnX5yeF8Dn8hlFEIqkmG9xb+k/4ExDHl41Hh
         VdTYWq3SJMR4CAqokHSQ/zQMIflzfxhSIrLYIU5A0bEvdJEhxhLVQXtv3En+T3ZyLl5i
         166sL2Hp085kMbMIzIYgjL8MRn6vNFkob3PY+qgx0g/ETzy92kpZD/XMHL9ke+Y2FG13
         c2IA==
X-Gm-Message-State: APjAAAUpbji6tCCau+Si0QF8pjUjDlat64ZsEx9QZFF6VqEiEIAbpSOc
        t9Onkqk+gklMRU8Ouk8DT4p66w==
X-Google-Smtp-Source: APXvYqzizPYl2LrtkxXjbmjRPnD30yqIwKDY6KgNsz0NbhIueWjJnIkysTmtYLAdQWA6iei+yUmzJQ==
X-Received: by 2002:ac8:5343:: with SMTP id d3mr5516461qto.50.1565897583402;
        Thu, 15 Aug 2019 12:33:03 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id s4sm1862094qkb.130.2019.08.15.12.33.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Aug 2019 12:33:03 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hyLUc-0008Aa-AF; Thu, 15 Aug 2019 16:33:02 -0300
Date:   Thu, 15 Aug 2019 16:33:02 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V5 0/9] Fixes for vhost metadata acceleration
Message-ID: <20190815193302.GT21596@ziepe.ca>
References: <20190809054851.20118-1-jasowang@redhat.com>
 <20190810134948-mutt-send-email-mst@kernel.org>
 <360a3b91-1ac5-84c0-d34b-a4243fa748c4@redhat.com>
 <20190812054429-mutt-send-email-mst@kernel.org>
 <20190812130252.GE24457@ziepe.ca>
 <9a9641fe-b48f-f32a-eecc-af9c2f4fbe0e@redhat.com>
 <20190813115707.GC29508@ziepe.ca>
 <74838e61-3a5e-0f51-2092-f4a16d144b45@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74838e61-3a5e-0f51-2092-f4a16d144b45@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 15, 2019 at 11:26:46AM +0800, Jason Wang wrote:
> 
> On 2019/8/13 下午7:57, Jason Gunthorpe wrote:
> > On Tue, Aug 13, 2019 at 04:31:07PM +0800, Jason Wang wrote:
> > 
> > > What kind of issues do you see? Spinlock is to synchronize GUP with MMU
> > > notifier in this series.
> > A GUP that can't sleep can't pagefault which makes it a really weird
> > pattern
> 
> 
> My understanding is __get_user_pages_fast() assumes caller can fail or have
> fallback. And we have graceful fallback to copy_{to|from}_user().

My point is that if you can fall back to copy_user then it is weird to
call the special non-sleeping GUP under a spinlock.

AFAIK the only reason this is done is because of the way the notifier
is being locked...

Jason
