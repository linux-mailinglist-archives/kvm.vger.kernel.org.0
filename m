Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA8AD26BA
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 11:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388089AbfJJJw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 05:52:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47708 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387497AbfJJJwz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 05:52:55 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 894D63CA16
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 09:52:55 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id k4so2500869wru.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 02:52:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TqIbFc3q/Gn71WMn1cgD1WOyhahKFHqycUgmiD17c60=;
        b=NWOWyW98MByRteE9yIX9EQM3U7Bpy0AP3Ol0MUNJmRTb9SE/9FiL3rsAExzRxth3AY
         thIGn286cSdPkyQcSowYI6dQLfeOAtlmekpVdsPOgXaudhluFFUSAryR+V4OtFlkSWiP
         DS3aXtXnPZ44xbqy/tCwuYerPEO4bmj2JsqpSNhryxV9shgmeD9eZOkbGLhpkJt/SUKj
         3f/ZOwggIZ1K1zqo62Dl8rfx0ipZQAsJT58zevkmXdQ8S+w9fNQ6ZZdmR1r5EopkBjra
         6iuu29LQCgVpDTj7WNhHF2n9FpyCnuWOAgzl1D5lzHeHM1rgIsTA6SjlEqe1W5smLRqD
         8DAg==
X-Gm-Message-State: APjAAAViGlnAGawRTJbXDq8mnqzfWXMA3Tv6Y6I+9tQ0y/4Col674aKe
        BtnxINuIHXSUKQEkLqQgNleWU/TPWA0sRWlH96eGwBGxT1qni0YIQdAdSAxAiiY+CF5DBbGlHod
        eLCkPoJ5vo3rS
X-Received: by 2002:a05:600c:28d:: with SMTP id 13mr198467wmk.100.1570701173968;
        Thu, 10 Oct 2019 02:52:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqypapq2mOJT0UwRrfDwUNCu9powWRCw63cVBYVEzLpMWYF3N5fg0WGtA5sfkqGUCAP/OmrMBQ==
X-Received: by 2002:a05:600c:28d:: with SMTP id 13mr198456wmk.100.1570701173753;
        Thu, 10 Oct 2019 02:52:53 -0700 (PDT)
Received: from steredhat (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id c6sm5901462wrm.71.2019.10.10.02.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 02:52:53 -0700 (PDT)
Date:   Thu, 10 Oct 2019 11:52:50 +0200
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
Subject: Re: [RFC PATCH 08/13] vsock: move vsock_insert_unbound() in the
 vsock_create()
Message-ID: <20191010095250.zmwmce7bgqgf3nv4@steredhat>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <20190927112703.17745-9-sgarzare@redhat.com>
 <20191009123423.GI5747@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009123423.GI5747@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 09, 2019 at 01:34:23PM +0100, Stefan Hajnoczi wrote:
> On Fri, Sep 27, 2019 at 01:26:58PM +0200, Stefano Garzarella wrote:
> > vsock_insert_unbound() was called only when 'sock' parameter of
> > __vsock_create() was not null. This only happened when
> > __vsock_create() was called by vsock_create().
> > 
> > In order to simplify the multi-transports support, this patch
> > moves vsock_insert_unbound() at the end of vsock_create().
> > 
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> >  net/vmw_vsock/af_vsock.c | 13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> Maybe transports shouldn't call __vsock_create() directly.  They always
> pass NULL as the parent socket, so we could have a more specific
> function that transports call without a parent sock argument.  This
> would eliminate any concern over moving vsock_insert_unbound() out of
> this function.  In any case, I've checked the code and this patch is
> correct.

Yes, I agree with you, I can add a new patch to do this cleaning.

> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Thanks,
Stefano
