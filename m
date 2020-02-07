Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF44C15535C
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 08:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgBGH6l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 02:58:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30063 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726935AbgBGH6l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 02:58:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581062320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HenEqyaWD9A3GA5daQn5LKIiUsd/BikWwsStjqnEW1M=;
        b=Z4HSOvs6k7Lqqs3eFoI5RaYZ7lzopGgOsysKNn2w2LPBwCLqtFb3NxaZRIfOdkUKkWIjLd
        DNa7T0PLRKzJwfrxkqphRhLyMeT2afBc/hq0lTJAjeO+SnfueuZkQIpbzUc0udhkq4MsJ3
        12HIoxU710H6zXaB0X9aWuKrvZXEkNI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-2J1K9GR5Pi-w86X9GFjM-A-1; Fri, 07 Feb 2020 02:58:39 -0500
X-MC-Unique: 2J1K9GR5Pi-w86X9GFjM-A-1
Received: by mail-qk1-f198.google.com with SMTP id t195so838144qke.23
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 23:58:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HenEqyaWD9A3GA5daQn5LKIiUsd/BikWwsStjqnEW1M=;
        b=l+5PP31wvTS7ZUgjA9WHAYBQM7d2vfk8bMtqxZ8HsCiVVQ1qVPFUw6Xifua2FWD1mN
         vcOH8SfIgUwUHgyTWEA5b4suX6wyhrCycKUkMSY/1w4vr+CWUV391WqVq4wr4ynDz8/d
         +kj2axijNnSo3h/sYhNs9z13qg3rqcUphjIObF/UZqT37aahFUPXY/kACXqMdTbfzYvC
         qwc1PaM32PjCHzGbh4EmeDuXWk5AKNTkIeF6vGOE+yQs67xmrQ00i0ZNu+2J1YMaTnv7
         6fCH/i2nT5qia42W3FKf8Lg2AhqGRNDlDo4WL6H/BFAPAr1f3KZ+tJfH3joTXzigMYAX
         6AIA==
X-Gm-Message-State: APjAAAWhGJLy79kwl69ev4Gce94/ct1RlGfpS5GUFcue04LlQND4p+kQ
        7ybPtY9I4DWoktIPjdoK6KitX+vGqOPFrdr2nIIAxmj8LNPm/zlau9EqsjzCZbLZ2jjCBPHKNQj
        ExAE+wEu3G/Vh
X-Received: by 2002:aed:34c1:: with SMTP id x59mr6453463qtd.236.1581062318423;
        Thu, 06 Feb 2020 23:58:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqziMqz1E8IKbTESJfX9C1no83ZH/Toj/qyo6qUx6yX4UiOkZkQZ1T+NzcXp4I3jI9TAHXN8Bw==
X-Received: by 2002:aed:34c1:: with SMTP id x59mr6453447qtd.236.1581062318154;
        Thu, 06 Feb 2020 23:58:38 -0800 (PST)
Received: from redhat.com (bzq-79-176-41-183.red.bezeqint.net. [79.176.41.183])
        by smtp.gmail.com with ESMTPSA id g77sm906726qke.129.2020.02.06.23.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 23:58:37 -0800 (PST)
Date:   Fri, 7 Feb 2020 02:58:32 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     eperezma@redhat.com,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: vhost changes (batched) in linux-next after 12/13 trigger random
 crashes in KVM guests after reboot
Message-ID: <20200207025806-mutt-send-email-mst@kernel.org>
References: <20200107042401-mutt-send-email-mst@kernel.org>
 <c6795e53-d12c-0709-c2e9-e35d9af1f693@de.ibm.com>
 <20200107065434-mutt-send-email-mst@kernel.org>
 <fe6e7e90-3004-eb7a-9ed8-b53a7667959f@de.ibm.com>
 <20200120012724-mutt-send-email-mst@kernel.org>
 <2a63b15f-8cf5-5868-550c-42e2cfd92c60@de.ibm.com>
 <b6e32f58e5d85ac5cc3141e9155fb140ae5cd580.camel@redhat.com>
 <1ade56b5-083f-bb6f-d3e0-3ddcf78f4d26@de.ibm.com>
 <20200206171349-mutt-send-email-mst@kernel.org>
 <5c860fa1-cef5-b389-4ebf-99a62afa0fe8@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c860fa1-cef5-b389-4ebf-99a62afa0fe8@de.ibm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 08:47:14AM +0100, Christian Borntraeger wrote:
> Also adding Cornelia.
> 
> 
> On 06.02.20 23:17, Michael S. Tsirkin wrote:
> > On Thu, Feb 06, 2020 at 04:12:21PM +0100, Christian Borntraeger wrote:
> >>
> >>
> >> On 06.02.20 15:22, eperezma@redhat.com wrote:
> >>> Hi Christian.
> >>>
> >>> Could you try this patch on top of ("38ced0208491 vhost: use batched version by default")?
> >>>
> >>> It will not solve your first random crash but it should help with the lost of network connectivity.
> >>>
> >>> Please let me know how does it goes.
> >>
> >>
> >> 38ced0208491 + this seem to be ok.
> >>
> >> Not sure if you can make out anything of this (and the previous git bisect log)
> > 
> > Yes it does - that this is just bad split-up of patches, and there's
> > still a real bug that caused worse crashes :)
> > 
> > So I just pushed batch-v4.
> > I expect that will fail, and bisect to give us
> >     vhost: batching fetches
> > Can you try that please?
> > 
> 
> yes.
> 
> eccb852f1fe6bede630e2e4f1a121a81e34354ab is the first bad commit
> commit eccb852f1fe6bede630e2e4f1a121a81e34354ab
> Author: Michael S. Tsirkin <mst@redhat.com>
> Date:   Mon Oct 7 06:11:18 2019 -0400
> 
>     vhost: batching fetches
>     
>     With this patch applied, new and old code perform identically.
>     
>     Lots of extra optimizations are now possible, e.g.
>     we can fetch multiple heads with copy_from/to_user now.
>     We can get rid of maintaining the log array.  Etc etc.
>     
>     Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
>  drivers/vhost/test.c  |  2 +-
>  drivers/vhost/vhost.c | 39 ++++++++++++++++++++++++++++++++++-----
>  drivers/vhost/vhost.h |  4 +++-
>  3 files changed, 38 insertions(+), 7 deletions(-)
> 


And the symptom is still the same - random crashes
after a bit of traffic, right?

> > 
> 			

