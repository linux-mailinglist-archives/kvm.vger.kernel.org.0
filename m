Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D10231C3D
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 11:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgG2Jkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 05:40:31 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:44870 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725851AbgG2Jka (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Jul 2020 05:40:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596015628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k7LhEO6XCqGVUuc17BRfAuaIUsyKpv0HJUC9DTzz2Oc=;
        b=aTUGkFDzlfnTAtMIkavF5q0pbjm/tYkMvwS9s4lXusfBW6ISdw0v8oL7whQMdCi9pV0MAC
        ncIZ7tlnNOLhbiYr//e8O3USfI6ewiNxQFZitZJ7FyRJzbcMeegk6iy4/J5iDGnvWYSbGa
        fOC33IX3aq2haD3YX39P8yFzMYofPxg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-7wbtm3iKOkGebWcvJBR60w-1; Wed, 29 Jul 2020 05:40:24 -0400
X-MC-Unique: 7wbtm3iKOkGebWcvJBR60w-1
Received: by mail-wm1-f70.google.com with SMTP id z74so462169wmc.4
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 02:40:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=k7LhEO6XCqGVUuc17BRfAuaIUsyKpv0HJUC9DTzz2Oc=;
        b=SeWfp65slyNedhMZQuUp/CQ9zRMXogV5Ev2rXwPtYJEdAZ+1OmmOBi6Yk7Z5J0jD8I
         Bdu9eC8wYZ5+dKI8mVw6ci0AYijib6S7ff14ygyrJ+XGubsREPq0hUlagCrHl63XLUOJ
         bLdRPb0c4CFfB6XJK7cFg2tethvV2O/htEijosx1S80iZ0yRgcvDFLI64rw7lhMhoqfn
         oeYsH02kURzCOJIm90d4sEXnZ9YpP3c4iA+EZi2CHwFnVuiMlWrIPByRU4HWQVzomDPL
         AKOovfWzOItMrzgDIucwSaBGeZSc6wFgekCmTqrDchjGzjtk2Z299Y3ifXMNcZkuTQj7
         H3eA==
X-Gm-Message-State: AOAM531XTipLUXTUJmvqrTgDQHl77ck8IBCMFiBXOcIpczjxIBCMBcnS
        1SROFHIWErUWi6MqyrZNA2qjCwbssEABYYk7AOsXrRrctlkuDS9XBm7I8eHhheFHc9IZgCVoVJH
        UUzL7/Tu3dKSZ
X-Received: by 2002:adf:9c8c:: with SMTP id d12mr28254559wre.369.1596015622989;
        Wed, 29 Jul 2020 02:40:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSgh6jDxOdFmcD7rlJpBZFVipNvyIVfH2WgoMjLbmLGCkqivl8DMGS+QOpLJ4wheZJRWE1WQ==
X-Received: by 2002:adf:9c8c:: with SMTP id d12mr28254546wre.369.1596015622705;
        Wed, 29 Jul 2020 02:40:22 -0700 (PDT)
Received: from steredhat.lan ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id x2sm534205wrg.73.2020.07.29.02.40.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 02:40:22 -0700 (PDT)
Date:   Wed, 29 Jul 2020 11:40:18 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, decui@microsoft.com, jhansen@vmware.com,
        kuba@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+a61bac2fcc1a7c6623fe@syzkaller.appspotmail.com,
        stefanha@redhat.com, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Subject: Re: general protection fault in vsock_poll
Message-ID: <20200729094018.x6rr2jlzh3ne4pgx@steredhat.lan>
References: <00000000000099052605aafb5923@google.com>
 <00000000000093b5dc05ab90c468@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000093b5dc05ab90c468@google.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 29, 2020 at 01:59:05AM -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 408624af4c89989117bb2c6517bd50b7708a2fcd
> Author: Stefano Garzarella <sgarzare@redhat.com>
> Date:   Tue Dec 10 10:43:06 2019 +0000
> 
>     vsock: use local transport when it is loaded
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17e6489b100000
> start commit:   92ed3019 Linux 5.8-rc7
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1416489b100000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1016489b100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=84f076779e989e69
> dashboard link: https://syzkaller.appspot.com/bug?extid=a61bac2fcc1a7c6623fe
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15930b64900000
> 
> Reported-by: syzbot+a61bac2fcc1a7c6623fe@syzkaller.appspotmail.com
> Fixes: 408624af4c89 ("vsock: use local transport when it is loaded")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 

I'll take a look.

At first glance it seems strange, because if sk_state is TCP_ESTABLISHED,
the transport shouldn't be NULL, that's why we didn't put the check.

Stefano

