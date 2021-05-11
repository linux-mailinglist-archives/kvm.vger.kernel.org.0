Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C5437A6BB
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 14:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhEKMcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 08:32:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231432AbhEKMcf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 08:32:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620736289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BP9KHD+W1HIDDROuTRJrR9O7xFxTR83BEOhAgDnRXzk=;
        b=hFllDrwvGD0tDGF/VnKVs6tJVzN5xbQS7Bsd8GjInjlOOC4u19/W+FzOcakeKCyr1Uf0QL
        UTpvnFMtI9xOruC2DWxhlGHgWWU/qi50hOGmS/5aWiV/aSbW0+xeWOgz89NBscUWVR47s6
        Ws9I6zexvbh4DbgJUdcA5i9ECfE7eGQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-oA5vYqUdOvmyAakwfRS_lg-1; Tue, 11 May 2021 08:31:25 -0400
X-MC-Unique: oA5vYqUdOvmyAakwfRS_lg-1
Received: by mail-qk1-f197.google.com with SMTP id u126-20020a3792840000b02902e769005fe1so14259413qkd.2
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 05:31:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BP9KHD+W1HIDDROuTRJrR9O7xFxTR83BEOhAgDnRXzk=;
        b=kIdZ95RyQ2PHglvvIrDKqJGdXmbAjvUMVj0gNnAxHCpcvLTUAVPq3zOn3HwuySsWCW
         3Dk4bEli/MTNRSxPEd/GM1Fd1b2ICbI8JH7STBPrILCc22FWER6ry2R0+RkZkNmwwhDU
         pLcmCnBbTNY9oGV1V+rzjAP60K3sCK0M0LJx1llltvROkChhfd9n8xBeJsh1jSjSu2hj
         wNDH/E8xbyg0wA5SOoU/wF9L9Tesgi8FWTcqVZKai7uwn4ovyZcFDof97lPNkT1DLzAo
         Eh8pnHkSbeQYrKoh/dktcBVP6hi19JouXP2BLC0jtwzfcdamkqswFCYtMAx8JiIzDSsr
         2/AA==
X-Gm-Message-State: AOAM530/+lZJ3RnuGECaT8Kp9rO7ow4X3wZbnsr5iKszupNZoi4JW8JT
        BF6BfvOHKUfAgkX1NA1fTkrWPNCvwCikxsdtO1smmfB2a2LQyffimy0trlWyq3HO9nE8+kJ6klr
        EjuK/D2n7fW1/DIw+NfVqFt/bIT9S
X-Received: by 2002:ac8:7f13:: with SMTP id f19mr1961249qtk.237.1620736285208;
        Tue, 11 May 2021 05:31:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSg7riSENq1MAenapEWP79PIP+9MrQL8SnAYKC+cTw4sAkxGqMbcnp6TuzMOo5awgtHC7Y4XKudYMK9nsdgy0=
X-Received: by 2002:ac8:7f13:: with SMTP id f19mr1961226qtk.237.1620736285046;
 Tue, 11 May 2021 05:31:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210510155539.998747-1-groug@kaod.org> <20210510155539.998747-4-groug@kaod.org>
In-Reply-To: <20210510155539.998747-4-groug@kaod.org>
From:   Miklos Szeredi <mszeredi@redhat.com>
Date:   Tue, 11 May 2021 14:31:14 +0200
Message-ID: <CAOssrKfbzCnpHma-=tTRvwUecy_9RtJADzMb_uQ1yzzJStz1PA@mail.gmail.com>
Subject: Re: [Virtio-fs] [for-6.1 v3 3/3] virtiofsd: Add support for
 FUSE_SYNCFS request
To:     Greg Kurz <groug@kaod.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        virtio-fs-list <virtio-fs@redhat.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 5:55 PM Greg Kurz <groug@kaod.org> wrote:
>
> Honor the expected behavior of syncfs() to synchronously flush all data
> and metadata on linux systems. Simply loop on all known submounts and
> call syncfs() on them.

Why not pass the submount's root to the server, so it can do just one
targeted syncfs?

E.g. somehting like this in fuse_sync_fs():

args.nodeid = get_node_id(sb->s_root->d_inode);

Thanks,
Miklos

