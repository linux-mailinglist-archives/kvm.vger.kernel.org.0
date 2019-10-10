Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF061D247F
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 11:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389249AbfJJIqF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 04:46:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45706 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389239AbfJJIqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 04:46:04 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A1D6E8B09
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 08:46:04 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id w2so2412946wrn.4
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 01:46:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tR/b93II6w98Y1JcW5QoZrFBl2Ih7JvmORnV8m5CDsk=;
        b=NNd+Hi7PvOzjppW+p62fy4Vep5MJgjp9LmaNNvzHHuKStg/HaNWU61zC7/beV8jv9V
         B8uFG31uCgz9nBJOAm5Yd2I8NNJ3rR3Q88KWR7gKPFY/cBs2nGEa+8Pcc8sgnCVixNsg
         x50BnzBTE/A8h0S0eP6fbJowx+SvU7Uj8SN2EgsKC3I6yqx4vLv9p/5q0EpVnKwsmPHc
         2YJXcZMBsblEOccQlYKE61F5ZKDA2S8MGUp2YdzkSx8sIoKRDVcnDJALHl1ouibjeiYh
         f7ILNw9a3NdpzlJ401GRqP5nsWIlqL8/YON7JqcBBBVqQejVstmZNDBV8MLVSGGraFcu
         Pp+w==
X-Gm-Message-State: APjAAAW6S0prfHP0jzXhr1yG70yhytcJFmvvb5ruYVbZ0QAyZEpz5yc7
        EScCMTmU0z9MwOljf7ky0mLJ2bC28Mwom0YCM9a6p7Dd1ww0hAj5Ftbh/Pp/2zvoXGNOGMi2JYM
        IbH6Fzr1gLTfS
X-Received: by 2002:adf:e401:: with SMTP id g1mr5700490wrm.211.1570697162834;
        Thu, 10 Oct 2019 01:46:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyrGXBfAqLL3DSANixqvzd6znc5l0D4LZnBiMcWibn1Ag6PBFlGAQzLidI7EwNDBrIbfhWgrA==
X-Received: by 2002:adf:e401:: with SMTP id g1mr5700471wrm.211.1570697162619;
        Thu, 10 Oct 2019 01:46:02 -0700 (PDT)
Received: from steredhat (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id q124sm8324726wma.5.2019.10.10.01.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 01:46:01 -0700 (PDT)
Date:   Thu, 10 Oct 2019 10:45:59 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [RFC PATCH 00/13] vsock: add multi-transports support
Message-ID: <20191010084559.a4t6v7dopeqffn55@steredhat>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20191009132952.GO5747@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009132952.GO5747@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 09, 2019 at 02:29:52PM +0100, Stefan Hajnoczi wrote:
> On Fri, Sep 27, 2019 at 01:26:50PM +0200, Stefano Garzarella wrote:
> > Hi all,
> > this series adds the multi-transports support to vsock, following
> > this proposal:
> > https://www.spinics.net/lists/netdev/msg575792.html
> 
> Nice series!  I have left a few comments but overall it looks promising.

Thank you very much for the comments!

I'll follow them and respin.

Cheers,
Stefano
