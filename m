Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1383A142811
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 11:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgATKRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 05:17:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43682 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726621AbgATKRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jan 2020 05:17:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579515462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3Kn3eF1bDp58ABo+Z+VK7m/se8AJ6JmDqRXHpdzmrrQ=;
        b=N4kAnv8FyaeBpT/U+DneiQLEAqOjHWzqFxCI1hBnEn6ZN7kWZESpfXFUZDmakgzk9C8HC/
        wndmQmZdzAFlXKv4ognXfZHTpM1SeXatCu5LuedbbS37oiwhsZPdJbk9iYyB06yZyj7oue
        dS2VJHPJ5VlHaSrtWZyrMP6xK0CUEic=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-t3Iv4gPeMxGMFdLJu4s4Eg-1; Mon, 20 Jan 2020 05:17:40 -0500
X-MC-Unique: t3Iv4gPeMxGMFdLJu4s4Eg-1
Received: by mail-wm1-f71.google.com with SMTP id 18so3553333wmp.0
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 02:17:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3Kn3eF1bDp58ABo+Z+VK7m/se8AJ6JmDqRXHpdzmrrQ=;
        b=a9xksnCnplIZ58y79B0y83u5eyAuyfAJuaDL1oFAXJz8mwgEfQfWR701NH+cwOH95N
         eg/ZfvZwKT3ZdfhZ7hOVSynP6Bvh4ho+2dH624oMG+4ggI0B2Jf/jMKllDAdEvjfBDu9
         VSv+pZjrNlsehWkaAyZqSrq9SDnLK3HSehzQxH03Xv79QxDfw91Iioab+kJsxWT8uVgV
         Oa9Uw1p6xpWItPKzkveZpvbV9MVkZPUCJGaQbR575mj8xcXSY4ynsdekh2Kx+2i4U0IO
         9mGIdR+RWtS2HvOZIK006JC12h0aCpaeZ611e7JJKjpIZOjf3LqqyZVWkXjKFnTUTnjT
         lBzg==
X-Gm-Message-State: APjAAAUCz4s8/Tf6XsI489pIzHX0lELa8Ig9GqEfQMvhD/uugyaqMWFH
        BSmvehB7B+m0oe7mviGwh6Mt2KfYiWFaCJKOsxl3tvQEPoxpQjkaVWBjbq9C4s/O5XURnOL1RmC
        UGfbgtERW58mz
X-Received: by 2002:a5d:4c8c:: with SMTP id z12mr17204955wrs.222.1579515459301;
        Mon, 20 Jan 2020 02:17:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqx8nPgpJZeiHtCAtqFdRM5avjMVn14ZlpARF6xuxaOm5EpPLbYY6JuPnFuxmQoQgypkH/rg3g==
X-Received: by 2002:a5d:4c8c:: with SMTP id z12mr17204936wrs.222.1579515459017;
        Mon, 20 Jan 2020 02:17:39 -0800 (PST)
Received: from steredhat (host84-49-dynamic.31-79-r.retail.telecomitalia.it. [79.31.49.84])
        by smtp.gmail.com with ESMTPSA id p18sm22504644wmb.8.2020.01.20.02.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 02:17:38 -0800 (PST)
Date:   Mon, 20 Jan 2020 11:17:35 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jhansen@vmware.com, jasowang@redhat.com, kvm@vger.kernel.org,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, mst@redhat.com, decui@microsoft.com
Subject: Re: [PATCH net-next 1/3] vsock: add network namespace support
Message-ID: <20200120101735.uyh4o64gb4njakw5@steredhat>
References: <20200116172428.311437-1-sgarzare@redhat.com>
 <20200116172428.311437-2-sgarzare@redhat.com>
 <20200120.100610.546818167633238909.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120.100610.546818167633238909.davem@davemloft.net>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 20, 2020 at 10:06:10AM +0100, David Miller wrote:
> From: Stefano Garzarella <sgarzare@redhat.com>
> Date: Thu, 16 Jan 2020 18:24:26 +0100
> 
> > This patch adds 'netns' module param to enable this new feature
> > (disabled by default), because it changes vsock's behavior with
> > network namespaces and could break existing applications.
> 
> Sorry, no.
> 
> I wonder if you can even design a legitimate, reasonable, use case
> where these netns changes could break things.

I forgot to mention the use case.
I tried the RFC with Kata containers and we found that Kata shim-v1
doesn't work (Kata shim-v2 works as is) because there are the following
processes involved:
- kata-runtime (runs in the init_netns) opens /dev/vhost-vsock and
  passes it to qemu
- kata-shim (runs in a container) wants to talk with the guest but the
  vsock device is assigned to the init_netns and kata-shim runs in a
  different netns, so the communication is not allowed

But, as you said, this could be a wrong design, indeed they already
found a fix, but I was not sure if others could have the same issue.

In this case, do you think it is acceptable to make this change in
the vsock's behavior with netns and ask the user to change the design?

> 
> I am totally against adding a module parameter for this, it's
> incredibly confusing for users and will create a test scenerio
> that is strongly less likely to be covered.
> 

Got it, I'll remove the module parameter!

Thanks,
Stefano

