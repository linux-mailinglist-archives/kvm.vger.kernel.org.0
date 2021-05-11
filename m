Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AB337A728
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 14:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhEKMz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 08:55:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33815 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231455AbhEKMz2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 08:55:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620737656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xGTthDek+mgAIu+TrlsM9VBHH27BgvbYkw1Rgv4OG9k=;
        b=SrT/Hze/sRCfqceh2NbBkW6vNGS1SxQIaD68ejzTbQSXJ3fDrDhY8NDGBUPc91LjagqwPx
        Fyot3y4S6fhdirwHwqnq91rgX2D9wIb0OO7y9XV2ngB+9jRDq2b62JwGmGrzTXwe4HnN5Q
        +sQiLqC6kWL8UG2VevGrlu/G9BZz+fo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-k9A5cUiFP1WE_AqfKFoVng-1; Tue, 11 May 2021 08:54:12 -0400
X-MC-Unique: k9A5cUiFP1WE_AqfKFoVng-1
Received: by mail-qk1-f197.google.com with SMTP id 4-20020a370d040000b02902fa09aa4ad4so5804792qkn.11
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 05:54:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xGTthDek+mgAIu+TrlsM9VBHH27BgvbYkw1Rgv4OG9k=;
        b=f3g37DNekuUCa656n2FeGK5HYIkDGTrcw01GsiF7jPJ9J1iZG9uO0u5I7pgmf7d+UQ
         RNmGJv93W6xRklKFK1VHdUwWpN8IkyAUnP6uTYY0jX5qwcYN2QnAezaLufGPiFF/e9CT
         tggemgNjV2tVPFYBzOo/aLtGmqnssCrXh6Q6CBteB1L5f19fWvCiA5PYgvqtpfNftsi1
         o3iQbS6qzA74CPnMVVC/ahsaOz5ZBDE7ubQU/3NbjaLfpcBVy4kWi+PkqnJuo9sRfJxN
         mrcEbWgthUvdwG5LikDjSFo4Ph9XxzE0sijp9dUg4Qhz9AfJvnRraxzp+SpiBevJgC4t
         8Upw==
X-Gm-Message-State: AOAM530dEzfF+jA54GpWro2jNtmsVriHz8/TddggB/A+4oKIiWx1Tz7p
        z05apn1tp19mBUaI2d0NraeR4Ha2sLKpsoEp105vQ1sIih0QKHcjDhger0bLxjHP4l1f21Z1RmC
        BVh45vvK1HAxE
X-Received: by 2002:a37:30c:: with SMTP id 12mr27885249qkd.355.1620737651771;
        Tue, 11 May 2021 05:54:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzX36zytDMmof9gcYi2iwZA9ESzFYj/iyjY2FDVlY2VOPgCImoEWzpYb+2ZnCVJY8xiSf2PtA==
X-Received: by 2002:a37:30c:: with SMTP id 12mr27885231qkd.355.1620737651581;
        Tue, 11 May 2021 05:54:11 -0700 (PDT)
Received: from horse (pool-173-76-174-238.bstnma.fios.verizon.net. [173.76.174.238])
        by smtp.gmail.com with ESMTPSA id 25sm2827573qky.16.2021.05.11.05.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 05:54:11 -0700 (PDT)
Date:   Tue, 11 May 2021 08:54:09 -0400
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
Message-ID: <20210511125409.GA234533@horse>
References: <20210510155539.998747-1-groug@kaod.org>
 <20210510155539.998747-4-groug@kaod.org>
 <CAOssrKfbzCnpHma-=tTRvwUecy_9RtJADzMb_uQ1yzzJStz1PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKfbzCnpHma-=tTRvwUecy_9RtJADzMb_uQ1yzzJStz1PA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 02:31:14PM +0200, Miklos Szeredi wrote:
> On Mon, May 10, 2021 at 5:55 PM Greg Kurz <groug@kaod.org> wrote:
> >
> > Honor the expected behavior of syncfs() to synchronously flush all data
> > and metadata on linux systems. Simply loop on all known submounts and
> > call syncfs() on them.
> 
> Why not pass the submount's root to the server, so it can do just one
> targeted syncfs?
> 
> E.g. somehting like this in fuse_sync_fs():
> 
> args.nodeid = get_node_id(sb->s_root->d_inode);

Hi Miklos,

I think current proposal was due to lack of full understanding on my part.
I was assuming we have one super block in client and that's not the case
looks like. For every submount, we will have another superblock known
to vfs, IIUC. That means when sync() happens, we will receive ->syncfs()
for each of those super blocks. And that means file server does not
have to keep track of submounts explicitly and it will either receive
a single targeted SYNCFS (for the case of syncfs(fd)) or receive
multile SYNCFS calls (one for each submount when sync() is called).

If that's the case, it makes sense to send nodeid of the root dentry
of superblock and file server can just call syncfs(inode->fd).

Thanks
Vivek

