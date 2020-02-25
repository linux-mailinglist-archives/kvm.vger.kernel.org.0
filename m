Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E295016BBDB
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 09:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbgBYIbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 03:31:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53671 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729130AbgBYIbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 03:31:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582619465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JmkjEEqq8m5BjNADnDl327dChnkc9rLHPLw9n41A+qY=;
        b=J2Ft6uL3qb2pUkrxSzHQSuCdB2OCostH1rV/uFJVI2B/TKrJmxoBV0yberxiiXKVlFyM7u
        JKS/xUMWIFdWvtFbJ2ye3E+rPUp/98hUpbCF0oEdytKtW/QOkTQgoDlQm9w+aPNnVzFO6L
        svGPKk94UfJIxUteZKeKnY/AtS+VR6A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-0MxabjBhMmWDIH8_YovY2A-1; Tue, 25 Feb 2020 03:31:03 -0500
X-MC-Unique: 0MxabjBhMmWDIH8_YovY2A-1
Received: by mail-wm1-f71.google.com with SMTP id m4so552254wmi.5
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 00:31:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JmkjEEqq8m5BjNADnDl327dChnkc9rLHPLw9n41A+qY=;
        b=aiA6nR+Pogr72oRd3Q8q6Qblk/Ki3W9z5KWdNuxR6w337si2qxYywR0UjFYSiICd12
         rc3h7SONfETFjKEWvWxVJG40M+CwzFDN5FKQbAc79sQgx78bmch7DZlff0CZVMRlG5+v
         ZPgbocOAlRxPo2miLKA6UFloBRVU24D7K7Acd1gWIKzroLkSCESfjrWKhQNyKUVNAViI
         fkHSlJbH+duEmLlCrgERayF3D/nh343V3a5t2uR+wpOA+5lZ5504xDZvXrgOvrG1H0F3
         MEVPuJGVzM9hJ9TXDxgByYFSPaiHzboOURJ6CihWrOrqgwZfpeBUr5Y6CoG8v02Un3tn
         hs9g==
X-Gm-Message-State: APjAAAXxQ+iJ/eKgrimJs9I/2vynOnAjIibh6MMX/VmJz9TA1V189m6n
        Q2mxwTYm2ipbR930nPfXt3lS6Jw94hyozXUIJHBPBT8jiFQ3Ldmiqr2OFssKJIXgzBIQjnVLq72
        ilsNIPjAo7bOm
X-Received: by 2002:adf:f586:: with SMTP id f6mr15471133wro.256.1582619462025;
        Tue, 25 Feb 2020 00:31:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqxskh69L3ehEc2A4u9xM0Hn8YDZ+SLMXLTAldmiH302cEMuq/teKvvxsxUwEbCUclTnpJrS4Q==
X-Received: by 2002:adf:f586:: with SMTP id f6mr15471097wro.256.1582619461690;
        Tue, 25 Feb 2020 00:31:01 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id a13sm5456577wrt.55.2020.02.25.00.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 00:31:01 -0800 (PST)
Date:   Tue, 25 Feb 2020 09:30:58 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Hillf Danton <hdanton@sina.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        syzbot <syzbot+731710996d79d0d58fbc@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: INFO: task hung in lock_sock_nested (2)
Message-ID: <20200225083058.nfrrvsdgjxj3zcmw@steredhat>
References: <0000000000004241ff059f2eb8a4@google.com>
 <20200223075025.9068-1-hdanton@sina.com>
 <20200224100853.wd67e7rqmtidfg7y@steredhat>
 <HK0P153MB0148B4C74BA6A60E295A03D8BFED0@HK0P153MB0148.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HK0P153MB0148B4C74BA6A60E295A03D8BFED0@HK0P153MB0148.APCP153.PROD.OUTLOOK.COM>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 25, 2020 at 05:44:03AM +0000, Dexuan Cui wrote:
> > From: Stefano Garzarella <sgarzare@redhat.com>
> > Sent: Monday, February 24, 2020 2:09 AM
> > ...
> > > > syz-executor280 D27912  9768   9766 0x00000000
> > > > Call Trace:
> > > >  context_switch kernel/sched/core.c:3386 [inline]
> > > >  __schedule+0x934/0x1f90 kernel/sched/core.c:4082
> > > >  schedule+0xdc/0x2b0 kernel/sched/core.c:4156
> > > >  __lock_sock+0x165/0x290 net/core/sock.c:2413
> > > >  lock_sock_nested+0xfe/0x120 net/core/sock.c:2938
> > > >  virtio_transport_release+0xc4/0xd60
> > net/vmw_vsock/virtio_transport_common.c:832
> > > >  vsock_assign_transport+0xf3/0x3b0 net/vmw_vsock/af_vsock.c:454
> > > >  vsock_stream_connect+0x2b3/0xc70 net/vmw_vsock/af_vsock.c:1288
> > > >  __sys_connect_file+0x161/0x1c0 net/socket.c:1857
> > > >  __sys_connect+0x174/0x1b0 net/socket.c:1874
> > > >  __do_sys_connect net/socket.c:1885 [inline]
> > > >  __se_sys_connect net/socket.c:1882 [inline]
> > > >  __x64_sys_connect+0x73/0xb0 net/socket.c:1882
> > > >  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> 
> My understanding about the call trace is: in vsock_stream_connect() 
> after we call lock_sock(sk), we call vsock_assign_transport(), which may
> call vsk->transport->release(vsk), i.e. virtio_transport_release(), and in
> virtio_transport_release() we try to get the same lock and hang.

Yes, that's what I got.

> 
> > > Seems like vsock needs a word to track lock owner in an attempt to
> > > avoid trying to lock sock while the current is the lock owner.
> 
> I'm unfamilar with the g2h/h2g :-) 
> Here I'm wondering if it's acceptable to add an 'already_locked'
> parameter like this:
>   bool already_locked = true;
>   vsk->transport->release(vsk, already_locked) ?

Could be acceptable, but I prefer to avoid.

>  
> > Thanks for this possible solution.
> > What about using sock_owned_by_user()?
>  
> > We should fix also hyperv_transport, because it could suffer from the same
> > problem.
> 
> IIUC hyperv_transport doesn't supprot the h2g/g2h feature, so it should not
> suffers from the deadlock issue here?

The h2g/g2h is in the vsock core, and the hyperv_transport is one of the g2h
transports available.

If we have a L1 VM with hyperv_transport (G2H) to communicate with L0 and a
nested KVM VM (L2) we need to load also vhost_transport (H2G). If the
user creates a socket and it tries the following:
    connect(fd, <2,1234>) - socket assigned to hyperv_transport (because
                            the user wants to reach the host using CID_HOST)
        fails

    connect(fd, <3,1234>) - socket must be reassigned to vhost_transport
                            (because the user wants to reach a nested guest)

So, I think in this case we can have the deadlock.

> 
> > At this point, it might be better to call vsk->transport->release(vsk)
> > always with the lock taken and remove it in the transports as in the
> > following patch.
> > 
> > What do you think?
> > 
> > 
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index 9c5b2a91baad..a073d8efca33 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -753,20 +753,18 @@ static void __vsock_release(struct sock *sk, int
> > level)
> >  		vsk = vsock_sk(sk);
> >  		pending = NULL;	/* Compiler warning. */
> > 
> > -		/* The release call is supposed to use lock_sock_nested()
> > -		 * rather than lock_sock(), if a sock lock should be acquired.
> > -		 */
> > -		if (vsk->transport)
> > -			vsk->transport->release(vsk);
> > -		else if (sk->sk_type == SOCK_STREAM)
> > -			vsock_remove_sock(vsk);
> > -
> >  		/* When "level" is SINGLE_DEPTH_NESTING, use the nested
> >  		 * version to avoid the warning "possible recursive locking
> >  		 * detected". When "level" is 0, lock_sock_nested(sk, level)
> >  		 * is the same as lock_sock(sk).
> >  		 */
> >  		lock_sock_nested(sk, level);
> > +
> > +		if (vsk->transport)
> > +			vsk->transport->release(vsk);
> > +		else if (sk->sk_type == SOCK_STREAM)
> > +			vsock_remove_sock(vsk);
> > +
> >  		sock_orphan(sk);
> >  		sk->sk_shutdown = SHUTDOWN_MASK;
> > 
> > diff --git a/net/vmw_vsock/hyperv_transport.c
> > b/net/vmw_vsock/hyperv_transport.c
> > index 3492c021925f..510f25f4a856 100644
> > --- a/net/vmw_vsock/hyperv_transport.c
> > +++ b/net/vmw_vsock/hyperv_transport.c
> > @@ -529,9 +529,7 @@ static void hvs_release(struct vsock_sock *vsk)
> >  	struct sock *sk = sk_vsock(vsk);
> >  	bool remove_sock;
> > 
> > -	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
> >  	remove_sock = hvs_close_lock_held(vsk);
> > -	release_sock(sk);
> >  	if (remove_sock)
> >  		vsock_remove_sock(vsk);
> >  }
> 
> This looks good to me, but do we know why vsk->transport->release(vsk)
> is called without holding the lock for 'sk' in the first place?

Maybe because vmci_transport (the first transport implemented) doesn't
require holding lock during the release.

Okay, so I'll test this patch and then I'll send it out for reviews.

Thanks for the feedback,
Stefano

