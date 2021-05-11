Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD15537A9D8
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 16:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhEKOui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 10:50:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32786 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231643AbhEKOuf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 10:50:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620744568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sK89xM0IJpifEl5nJO0LrHw28zaa90RKXG5Ozyo+9NA=;
        b=Q9c4DNePuj6Q2YNW4j17cISONwgHz9MBmgRZsYv4Vb5CxHMwE1la2FPWn2Yr4EP39HOJMb
        jVHMXQvaZeuDyV6SOVdwmj5Y0ng57I6jt4c9pQKYfIKJ4Tc9jWnEN958Y/yTWf8XP1D3sI
        P9dSSjv7JMuOvlw0ipZ81CaeLpaeGn4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-q-wb78aZOmSvG2zZGduTOg-1; Tue, 11 May 2021 10:49:27 -0400
X-MC-Unique: q-wb78aZOmSvG2zZGduTOg-1
Received: by mail-qv1-f71.google.com with SMTP id r11-20020a0cb28b0000b02901c87a178503so15624043qve.22
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 07:49:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sK89xM0IJpifEl5nJO0LrHw28zaa90RKXG5Ozyo+9NA=;
        b=uRrbgxXcxUrMN6kXyV4eGS0zgQXx0OOivULtE8Ha8L+JMpwi4du0n9MZL38TNkGV8g
         cXR4uXJv0Tyo96Q0qy5FdDpMFfXZfj0C7RpaXkgwPKuJO0x4UF2J9tPL4z7HKrMBFW7/
         CdJyK+Pcr+OIKG3Y2dSEMOekD1d7oMMcFMuuGTjm4EhW/z9++nWujvDAfAnkj0+Qjk5v
         f1J1dufvXaHDLfbxekJZX8GixEFyxg6HiZna0Gp7nr8SDSReX8QSYEU3+2I7M+Tr2Hd2
         aukCVeJlSWoACn296iCj3b1yPLQqE9zy7ZMfYiiu39ElBLh3pQnepNW3e5wYV3Mzp8ci
         qn1A==
X-Gm-Message-State: AOAM532IvBOFkCq5r6FnfThCU6oZn2+gWrnklQ2Jg+f/9rfIkiNw6wLp
        ettK0ufa4IDDt070Eu9P/+zOYA+vdCphA8aqaYvrPtK/88LgTOpMr+mLjxlANjf/QVrqjDuC9Na
        lClB2kuwwANfp
X-Received: by 2002:a05:620a:2a0f:: with SMTP id o15mr7237408qkp.295.1620744566682;
        Tue, 11 May 2021 07:49:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4kb0sbCk8RoX36mgYeXs6qO+ZFWTiKfRQIfvbaE3YAJhFIYVluBL/QqwriBOoPmGZyMrLbQ==
X-Received: by 2002:a05:620a:2a0f:: with SMTP id o15mr7237375qkp.295.1620744566335;
        Tue, 11 May 2021 07:49:26 -0700 (PDT)
Received: from horse (pool-173-76-174-238.bstnma.fios.verizon.net. [173.76.174.238])
        by smtp.gmail.com with ESMTPSA id v65sm14768708qkc.125.2021.05.11.07.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 07:49:25 -0700 (PDT)
Date:   Tue, 11 May 2021 10:49:23 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Miklos Szeredi <mszeredi@redhat.com>
Cc:     Greg Kurz <groug@kaod.org>,
        QEMU Developers <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        virtio-fs-list <virtio-fs@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [Virtio-fs] [for-6.1 v3 3/3] virtiofsd: Add support for
 FUSE_SYNCFS request
Message-ID: <20210511144923.GA238488@horse>
References: <20210510155539.998747-1-groug@kaod.org>
 <20210510155539.998747-4-groug@kaod.org>
 <CAOssrKfbzCnpHma-=tTRvwUecy_9RtJADzMb_uQ1yzzJStz1PA@mail.gmail.com>
 <20210511125409.GA234533@horse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511125409.GA234533@horse>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 08:54:09AM -0400, Vivek Goyal wrote:
> On Tue, May 11, 2021 at 02:31:14PM +0200, Miklos Szeredi wrote:
> > On Mon, May 10, 2021 at 5:55 PM Greg Kurz <groug@kaod.org> wrote:
> > >
> > > Honor the expected behavior of syncfs() to synchronously flush all data
> > > and metadata on linux systems. Simply loop on all known submounts and
> > > call syncfs() on them.
> > 
> > Why not pass the submount's root to the server, so it can do just one
> > targeted syncfs?
> > 
> > E.g. somehting like this in fuse_sync_fs():
> > 
> > args.nodeid = get_node_id(sb->s_root->d_inode);
> 
> Hi Miklos,
> 
> I think current proposal was due to lack of full understanding on my part.
> I was assuming we have one super block in client and that's not the case
> looks like. For every submount, we will have another superblock known
> to vfs, IIUC. That means when sync() happens, we will receive ->syncfs()
> for each of those super blocks. And that means file server does not
> have to keep track of submounts explicitly and it will either receive
> a single targeted SYNCFS (for the case of syncfs(fd)) or receive
> multile SYNCFS calls (one for each submount when sync() is called).

Tried sync() with submounts enabled and we are seeing a SYNCFS call
only for top level super block and not for submounts.

Greg noticed that it probably is due to the fact that iterate_super()
skips super blocks which don't have SB_BORN flag set. 

Only vfs_get_tree() seems to set SB_BORN and for our submounts we
are not calling vfs_get_tree(), hence SB_BORN is not set. NFS seems
to call vfs_get_tree() and hence SB_BORN must be set for submounts.

Maybe we need to modify virtio_fs_get_tree() so that it can deal with
mount as well as submounts and then fuse_dentry_automount() should
probably call vfs_get_tree() and that should set SB_BORN and hopefully
sync() will work with it. Greg is planning to give it a try.

Does it sound reasonable.

Thanks
Vivek

