Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AC52D4975
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 19:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730901AbgLISu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 13:50:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731168AbgLISu2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 13:50:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607539742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ZdtDVnVSLorYMf0VwrM99dH6Rak2Bc4C+97zOEHdxY=;
        b=OnNniVY8/pADg5bhmkfgdzo8Xlg04yazL6ma77dje9HHqASpIpN6eYPK9x8quFaH/XJjtF
        4BNHKdUZ73ChYmE8XJ4c3nG90Q+/SdaV7g8Vcczm/WlC1tVDDGK8eKVWWov5s4MtoGLtZa
        x7RhJ+tfXIv4Fz+LRXVoCHav0zI1Ikg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-7iwc_1LkMFqJ4UTQYb4hww-1; Wed, 09 Dec 2020 13:49:00 -0500
X-MC-Unique: 7iwc_1LkMFqJ4UTQYb4hww-1
Received: by mail-qk1-f199.google.com with SMTP id z129so1782174qkb.13
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 10:49:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2ZdtDVnVSLorYMf0VwrM99dH6Rak2Bc4C+97zOEHdxY=;
        b=TbFTpx2eEZ9zixsxXihOOQ37fc/OAWiXJWVVRnnVyVNuJS10HjV2uKElTeC2xkArHj
         3lgdy22zlHka8INV0IT3aWCTSG8vfEtIH8IOlk68Szyo8yZs3xLANYl6EZB9qAJFKmaA
         lf7ENg8xGiL5spf90RtZOq4zGk185Qr4xITyEA6qm7EOb0i1nPY74fzyJ6gB2Ain+hPx
         t6V8cPbzuWthvFhmUp0Y6/7RSB3QqCNDDDUPxmG2Xr6xY7Qv8n2EZlhznb7XCn4jSlxY
         VLbz5c2eoF84ds6lxJ6HIVZHK3rTY3wY1YkuEXU+EuvnWbSoKi47ucJT2IHe8e22HVhQ
         VYxQ==
X-Gm-Message-State: AOAM531Ke6wNXZ1ndbhRFMgT9lYNcrqtwIJxRGS2JyS8QLG+bSSMZxeZ
        Cv2NyIvvJljulAciX8QUlbqI/atvPbEDN8GFzz/E5F0s9olaAta5ozN4URzgZ8EkGRuUfRVOCSb
        GS9+CtfgU9WAT+HbwuuIE0jBFkroP
X-Received: by 2002:ac8:e06:: with SMTP id a6mr4783865qti.384.1607539740287;
        Wed, 09 Dec 2020 10:49:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzUDRcl0vkOdfin0XBAKi1xojbc8ggj/scgMp3QAm6uN/Gb1T8m4oXNBcerz4NAW0ctj6nhIRule5lH9IWXXNI=
X-Received: by 2002:ac8:e06:: with SMTP id a6mr4783839qti.384.1607539740115;
 Wed, 09 Dec 2020 10:49:00 -0800 (PST)
MIME-Version: 1.0
References: <20201120185105.279030-1-eperezma@redhat.com> <20201120185105.279030-19-eperezma@redhat.com>
 <20201208084158.GU203660@stefanha-x1.localdomain>
In-Reply-To: <20201208084158.GU203660@stefanha-x1.localdomain>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 9 Dec 2020 19:48:24 +0100
Message-ID: <CAJaqyWeMp=k_1CmWoywE+EiAC5ZYZyX=ieYZgqxFui-Z1Q-+Nw@mail.gmail.com>
Subject: Re: [RFC PATCH 18/27] vhost: add vhost_vring_poll_rcu
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

On Tue, Dec 8, 2020 at 9:42 AM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> On Fri, Nov 20, 2020 at 07:50:56PM +0100, Eugenio P=C3=A9rez wrote:
> > @@ -83,6 +89,18 @@ void vhost_vring_set_notification_rcu(VhostShadowVir=
tqueue *vq, bool enable)
> >      smp_mb();
> >  }
> >
> > +bool vhost_vring_poll_rcu(VhostShadowVirtqueue *vq)
>
> A name like "more_used" is clearer than "poll".

I agree, I will rename.

Thanks!

