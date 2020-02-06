Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 548B4154ED0
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 23:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgBFWR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 17:17:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57101 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727441AbgBFWR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 17:17:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581027447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dliw2RAM/nP3vDLbquqsu5FLbVnJwrHBsnpHt8MF4Y8=;
        b=Bs9Lz2p+ZXJ0cJFtnPu/BAAhMbvh+j1yvWg144fj50x5xlkBdyoBEr2x8q1HVxOJK2QHhl
        29l4blarwSvcj4vjMulxcihFrrX0oAMlPtF40SASaP5nrL9Ejfry5jZl0q0rQqEJfXqhla
        jc8TW2xr73wHMEjOjScOc/uan276LJQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-mySpXerBPLWtT1FNInas6A-1; Thu, 06 Feb 2020 17:17:25 -0500
X-MC-Unique: mySpXerBPLWtT1FNInas6A-1
Received: by mail-qt1-f198.google.com with SMTP id p12so254964qtu.6
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 14:17:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dliw2RAM/nP3vDLbquqsu5FLbVnJwrHBsnpHt8MF4Y8=;
        b=nwvDsejZ2IIjYBeIxPawcIdF8WMyq/yzo9IQZpyXc9A9HX7VVz0k1KsVoeZhQOhGnD
         zvlrU+tFjrSE6jEUfkrw3DraRwHVfdxjc8Rzu4oJkfZAiYkdFjvIaXzxgEtB4wtBtFac
         /Q4dF6jLKwsnCJM25CnV7urq1Bsqtcdtb7fQCrDoiwPrJp/8t2BUn5y+TkLjYf0JieKq
         rvaYhzkmGxl5PLuXBEAkooaUWt/mN59nT1p/tb8VG12eL9WO3fHLCFqEBHk/2Gy6xq7V
         KdwxAADtdIfhGfbB1XUwNE38ZXgPrV0c9AYNZ17bQE82DznxOCal9eB5LSO9BGvxzgkL
         zmZA==
X-Gm-Message-State: APjAAAW2d1jZp8k7z/JNq2yFcK1YrEAJoi+Z6pGKjt5eNzhufmUv6IjK
        qtzmcm/yS8gECTmCsdF6R/YSemcYZ6ZZvp9hqZxb8e5pT6SnVV8XvD+UfntCMUxvdYIUDjsVCxA
        oJUPwYVLB+8yr
X-Received: by 2002:ad4:4c42:: with SMTP id cs2mr4304142qvb.198.1581027445012;
        Thu, 06 Feb 2020 14:17:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqx4aT6nHPT/UCOxB/dIpvh77YFb+ccbCujxO7QlHqlvH0kWVJQHP+Kls/zNpxqC5KRYicsxvQ==
X-Received: by 2002:ad4:4c42:: with SMTP id cs2mr4304120qvb.198.1581027444763;
        Thu, 06 Feb 2020 14:17:24 -0800 (PST)
Received: from redhat.com (bzq-79-176-41-183.red.bezeqint.net. [79.176.41.183])
        by smtp.gmail.com with ESMTPSA id s22sm362089qke.19.2020.02.06.14.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 14:17:23 -0800 (PST)
Date:   Thu, 6 Feb 2020 17:17:19 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     eperezma@redhat.com,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: vhost changes (batched) in linux-next after 12/13 trigger random
 crashes in KVM guests after reboot
Message-ID: <20200206171349-mutt-send-email-mst@kernel.org>
References: <20200106054041-mutt-send-email-mst@kernel.org>
 <08ae8d28-3d8c-04e8-bdeb-0117d06c6dc7@de.ibm.com>
 <20200107042401-mutt-send-email-mst@kernel.org>
 <c6795e53-d12c-0709-c2e9-e35d9af1f693@de.ibm.com>
 <20200107065434-mutt-send-email-mst@kernel.org>
 <fe6e7e90-3004-eb7a-9ed8-b53a7667959f@de.ibm.com>
 <20200120012724-mutt-send-email-mst@kernel.org>
 <2a63b15f-8cf5-5868-550c-42e2cfd92c60@de.ibm.com>
 <b6e32f58e5d85ac5cc3141e9155fb140ae5cd580.camel@redhat.com>
 <1ade56b5-083f-bb6f-d3e0-3ddcf78f4d26@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ade56b5-083f-bb6f-d3e0-3ddcf78f4d26@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 06, 2020 at 04:12:21PM +0100, Christian Borntraeger wrote:
> 
> 
> On 06.02.20 15:22, eperezma@redhat.com wrote:
> > Hi Christian.
> > 
> > Could you try this patch on top of ("38ced0208491 vhost: use batched version by default")?
> > 
> > It will not solve your first random crash but it should help with the lost of network connectivity.
> > 
> > Please let me know how does it goes.
> 
> 
> 38ced0208491 + this seem to be ok.
> 
> Not sure if you can make out anything of this (and the previous git bisect log)

Yes it does - that this is just bad split-up of patches, and there's
still a real bug that caused worse crashes :)

So I just pushed batch-v4.
I expect that will fail, and bisect to give us
    vhost: batching fetches
Can you try that please?


