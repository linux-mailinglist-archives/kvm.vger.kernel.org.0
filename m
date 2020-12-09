Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28892D4970
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 19:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbgLIStI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 13:49:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37545 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730901AbgLISs4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 13:48:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607539649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yrfjyaqj4L5BFqPSfVQQDLQ7l1oJGf/95/9z1Mukkqs=;
        b=Yhmuv1uU4jQRMTMHcN6mw1bTQKEAgGLKpmIBGWN+FnBGb6EQrqvM4MIjAwje8VRsIH/9Ul
        /MpuYX/KyZWfO20f7dYrv3a02Sk9imsQfYigLhFHg/z82jbLgvv+bbo0XfkCRaWjBHVGPx
        CBxj0YKvtPxWvXpiMyfoSS5PV4jzPe8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416--xJR9HZAOD6t9XNQSqIMjw-1; Wed, 09 Dec 2020 13:47:28 -0500
X-MC-Unique: -xJR9HZAOD6t9XNQSqIMjw-1
Received: by mail-qk1-f197.google.com with SMTP id g28so1782579qka.4
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 10:47:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Yrfjyaqj4L5BFqPSfVQQDLQ7l1oJGf/95/9z1Mukkqs=;
        b=J72Ou4fAg9JGubjTKb9WG7q2q2D/soLJwB8IOb06IpCMik/qNVHvggLMp4IzBeohmt
         Uwy0bQ0N9fVR71QD0fh070EPGrnWcnmi7GeKX2PFJApUNusm7D+L/XxLiIbLJE6+dhCC
         CNTNlAkVH2/8Qd4JQc4pkjP7+W5GHe/1gwjlpawUUUOY27ExG7lLMw/GJUNkPBPEIcFa
         Q9QqooOoF5soiNh1sWpwzIjWLjylbZKrd17DdOsns5Zpnq8TiLU/984vK0Utz0kC8kez
         EPOXDisYy9RoYjF0J0Aimxl5FCTbVQdiXwy3KID8ALRIJQ37vAFBSuNQfAL9Nso69Qzr
         nUew==
X-Gm-Message-State: AOAM531Gb2wfFFLBPECfSiiVkzrb/I7ZnXhCjgiyhzVCwPs2DJMOB8H4
        mICrvnXNkMnv519htEfVPyhkaJNCbjW0d9ZkFck0NHwfqDPqY9CgljeTA4uQFNYuol0vsFI3/3X
        XEQZGh5ldduHULzvGIMaCnhpb5iNI
X-Received: by 2002:aed:2742:: with SMTP id n60mr4678334qtd.221.1607539647089;
        Wed, 09 Dec 2020 10:47:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxGw7c+xnc6N0H9X/g1O8JWP6r/KrIswT9lVGNbdosIwMEkBtS/32ZQWoZKrT4z06MWCEuozyqQRgwYBZN7ig8=
X-Received: by 2002:aed:2742:: with SMTP id n60mr4678306qtd.221.1607539646912;
 Wed, 09 Dec 2020 10:47:26 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <20201120185105.279030-17-eperezma@redhat.com>
 <20201208082552.GT203660@stefanha-x1.localdomain>
In-Reply-To: <20201208082552.GT203660@stefanha-x1.localdomain>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 9 Dec 2020 19:46:49 +0100
Message-ID: <CAJaqyWdN7iudf8mDN4k4Fs9j1x+ztZARuBbinPHD3ZQSMH1pyQ@mail.gmail.com>
Subject: Re: [RFC PATCH 16/27] virtio: Expose virtqueue_alloc_element
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-level <qemu-devel@nongnu.org>,
        Lars Ganrot <lars.ganrot@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Salil Mehta <mehta.salil.lnk@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Liran Alon <liralon@gmail.com>,
        Rob Miller <rob.miller@broadcom.com>,
        Max Gurtovoy <maxgu14@gmail.com>,
        Alex Barba <alex.barba@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jim Harford <jim.harford@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Christophe Fontaine <cfontain@redhat.com>,
        vm <vmireyno@marvell.com>, Daniel Daly <dandaly0@gmail.com>,
        Michael Lilja <ml@napatech.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Nitin Shrivastav <nitin.shrivastav@broadcom.com>,
        Lee Ballard <ballle98@gmail.com>,
        Dmytro Kazantsev <dmytro.kazantsev@gmail.com>,
        Juan Quintela <quintela@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Howard Cai <howard.cai@gmail.com>,
        Xiao W Wang <xiao.w.wang@intel.com>,
        Sean Mooney <smooney@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, Siwei Liu <loseweigh@gmail.com>,
        Stephen Finucane <stephenfin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 8, 2020 at 9:26 AM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Fri, Nov 20, 2020 at 07:50:54PM +0100, Eugenio P=C3=A9rez wrote:
> > Specify VirtQueueElement * as return type makes no harm at this moment.
>
> The reason for the void * return type is that C implicitly converts void
> pointers to pointers of any type. The function takes a size_t sz
> argument so it can allocate a object of user-defined size. The idea is
> that the user's struct embeds a VirtQueueElement field. Changing the
> return type to VirtQueueElement * means that callers may need to
> explicitly cast to the user's struct type.
>
> It's a question of coding style but I think the void * return type
> communicates what is going on better than VirtQueueElement *.

Right, what I meant with that is that nobody uses that feature, but I
just re-check and I saw that contrib/vhost-user-blk actually uses it
(not checked for more uses). I think it is better just to drop this
commit.

Thanks!

