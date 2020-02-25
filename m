Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81F0F16BD04
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 10:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgBYJHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 04:07:40 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27511 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729979AbgBYJHj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 04:07:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582621658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J9KNb3WVdOxwxKr6MYNPKvXY1jE7XXYkemzIOMy9lrE=;
        b=i2N+4Su/asOd1EGLWDVkJZvykjCeF7n5a3eSO4MEYuiB5k7M13QU9IVM0YtyYW+pjC7BzW
        AwPnrYNj3YLy49aSxPMqEvFzh6Y/o+CZltJPbDvOQvPbp/wTLZuBQ/PUjqh/s7hSARq0S/
        HuhcpotQJQh4sMHbZ2eQtWMZDNPOaoU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-143KE_6XPxqx8cTxFbBYyg-1; Tue, 25 Feb 2020 04:07:37 -0500
X-MC-Unique: 143KE_6XPxqx8cTxFbBYyg-1
Received: by mail-wr1-f69.google.com with SMTP id m15so6942872wrs.22
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 01:07:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J9KNb3WVdOxwxKr6MYNPKvXY1jE7XXYkemzIOMy9lrE=;
        b=X9jF+yZS1cowlRcXDw9LVt28/9n9iAhnA3MEwsfDQlQfNBQIJdW+lQJ06iUNUMDVUV
         FeuRoVsMVg6c3LVlAwpvgfSXFLqSilmztRmmOeTKate9NA1Czj00eTn7cYitQfxcsobm
         8AtMlmSsP+379j2LTAXKU8CykVIk4h/rKQn6KYF1Noiq/kW56TduRhYLPAgVYnVqlqs8
         oAegi2dEWu5elFQuoBQN6rhtALPbrtiouU3f5EF0KKwY1dOhRKMVCnggmt3O23TMpt4m
         5O55igZEztJFz9Crs4w6oNZZNTEHepUM3TeeRo23QR3oZV9koMGm+Ptl00bPi48YC7qz
         1/Zw==
X-Gm-Message-State: APjAAAUPAZI9nrqU38HUV9Ora6M8Ig4cIQ4cJyFdzGM+wnhf7U1I3tGe
        SDPpidnMkq7ji2ctVhSbzRF9XNa8KWt4BGZOsdviYeOy60ImSeGqcLE2hMpGpuVCUVILgxduv1J
        tCm/XwGIq0WV3
X-Received: by 2002:a5d:504e:: with SMTP id h14mr13354442wrt.82.1582621655917;
        Tue, 25 Feb 2020 01:07:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqyvXTw1dY0/iQ7fl5rVkhMh/4ortONYEYN8tZpl8lKh5OB5cJe57Upw2uu6Y8P8dd7G6t5LXg==
X-Received: by 2002:a5d:504e:: with SMTP id h14mr13354415wrt.82.1582621655699;
        Tue, 25 Feb 2020 01:07:35 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id s1sm22666564wro.66.2020.02.25.01.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 01:07:35 -0800 (PST)
Date:   Tue, 25 Feb 2020 10:07:32 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        syzbot <syzbot+731710996d79d0d58fbc@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Subject: Re: INFO: task hung in lock_sock_nested (2)
Message-ID: <20200225090732.kge6bdf46ji6mbb5@steredhat>
References: <0000000000004241ff059f2eb8a4@google.com>
 <20200223075025.9068-1-hdanton@sina.com>
 <20200224134428.12256-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224134428.12256-1-hdanton@sina.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 24, 2020 at 09:44:28PM +0800, Hillf Danton wrote:
> 
> On Mon, 24 Feb 2020 11:08:53 +0100 Stefano Garzarella wrote:
> > On Sun, Feb 23, 2020 at 03:50:25PM +0800, Hillf Danton wrote:
> > > 
> > > Seems like vsock needs a word to track lock owner in an attempt to
> > > avoid trying to lock sock while the current is the lock owner.
> > 
> > Thanks for this possible solution.
> > What about using sock_owned_by_user()?
> > 
> No chance for vsock_locked() if it works.
> 
> > We should fix also hyperv_transport, because it could suffer from the same
> > problem.
> > 
> You're right. My diff is at most for introducing vsk's lock owner.

Sure, thanks for this!

> 
> > At this point, it might be better to call vsk->transport->release(vsk)
> > always with the lock taken and remove it in the transports as in the
> > following patch.
> > 
> > What do you think?
> > 
> Yes and ... please take a look at the output of grep
> 
> 	grep -n lock_sock linux/net/vmw_vsock/af_vsock.c
> 
> as it drove me mad.

:-) I'll go in this direction and I'll check all the cases.

We should avoid to take lock_sock in the transports when it is possible.

Thanks for the help,
Stefano

