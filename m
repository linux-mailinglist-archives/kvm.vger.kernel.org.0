Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0693197799
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 11:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgC3JP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 05:15:59 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:25243 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727925AbgC3JP7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 05:15:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585559757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zemqa+eFWbSRqKFbVoTd6828wtJbQvKtR1Vj/t4nfws=;
        b=ijkjwL5FqXjDfXTK6tSFRz/dMNqOl08HOKnAvrEWech/P8+rbowSpc9X5Y++NKQ24UNB0H
        UHbqdTyh7sFzcQGMXdOP7ltvff1g45ILPVpg/fLNMhAgkeJHpNiur7C5E3GvT2IOIVvu1X
        MOmyTpbgMbB09RzV3mQn4YJT7agPVFk=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-_mA3n72BOgG4XJzCkpkpJw-1; Mon, 30 Mar 2020 05:15:56 -0400
X-MC-Unique: _mA3n72BOgG4XJzCkpkpJw-1
Received: by mail-qk1-f198.google.com with SMTP id r64so13859378qkc.17
        for <kvm@vger.kernel.org>; Mon, 30 Mar 2020 02:15:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zemqa+eFWbSRqKFbVoTd6828wtJbQvKtR1Vj/t4nfws=;
        b=n4US+4qx3uG6Jp5c2y+b85mQX8fWFuUMbfiGurRkuXCyqTngh9fDgh49rFLi/hxKCP
         QbJNpWnkzHWM7FqhgDvEkDmstdKYQuHaFaKHAWz9krRZYe8b6SgG2gC4GiBm94R/HGbj
         L85YZN9nIdylxDhC3DCY8bSRZUpzDcIFLLtwQQZ98gpr5TpVSE2PxBfoOTyPL2Zsb++d
         Hfb1Z5ejOJPtSOuKZoipPMwh1lOV+iH6k1PJd1+yH+DHeviCMpC814m7J613BTYLF2vA
         QWmyFIzlVeDL1QC1KSKe93v4xfRxCbAFdtxjS6MxeeJYS9j+yoyofddD7TvksVdqK0Zf
         FOaQ==
X-Gm-Message-State: ANhLgQ3sVZq7EEeVvodowNmuIPBiSryMsP984YvQF3vaCnue/KTl3b7U
        tqU+T3HLy2ngmLthdglXbpr53jE+nqrY/vgDx/fOtiZZQ3u+qq/6g93nmDqDgKKiwNaktQ68BwB
        ONxZFVvi/sIRt8elbXtz24eudlmgH
X-Received: by 2002:ae9:eb12:: with SMTP id b18mr4617822qkg.168.1585559755410;
        Mon, 30 Mar 2020 02:15:55 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtmZS/6wgLxWT3ZU/CS/qVPDcBOgRfiDiQ203JJ58Kdixi7MMbXpUC+A+8C7IiEGVQnJsaMv5FmAfbHLS/iB3g=
X-Received: by 2002:ae9:eb12:: with SMTP id b18mr4617794qkg.168.1585559754968;
 Mon, 30 Mar 2020 02:15:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200329113359.30960-1-eperezma@redhat.com> <bb95e827-f219-32fd-0046-41046eec058b@de.ibm.com>
 <CAJaqyWePfMcXhYEPxKYV22J3cYtO=DUXCj1Yf=7XH+khXHop9A@mail.gmail.com> <41dfa0e5-8013-db15-cbfe-aa4574cfb9a0@de.ibm.com>
In-Reply-To: <41dfa0e5-8013-db15-cbfe-aa4574cfb9a0@de.ibm.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 30 Mar 2020 11:15:18 +0200
Message-ID: <CAJaqyWfq3TGiQ9GSqdFVAZyydg29BoKiJFGKep+h3BoV5POLHQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] vhost: Reset batched descriptors on SET_VRING_BASE call
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 30, 2020 at 9:34 AM Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
>
>
>
> On 30.03.20 09:18, Eugenio Perez Martin wrote:
> > On Mon, Mar 30, 2020 at 9:14 AM Christian Borntraeger
> > <borntraeger@de.ibm.com> wrote:
> >>
> >>
> >> On 29.03.20 13:33, Eugenio P=C3=A9rez wrote:
> >>> Vhost did not reset properly the batched descriptors on SET_VRING_BAS=
E event. Because of that, is possible to return an invalid descriptor to th=
e guest.
> >>
> >> I guess this could explain my problems that I have seen during reset?
> >>
> >
> > Yes, I think so. The series has a test that should reproduce more or
> > less what you are seeing. However, it would be useful to reproduce on
> > your system and to know what causes qemu to send the reset :).
>
> I do see SET_VRING_BASE in the debug output
> [228101.438630] [2113] vhost:vhost_vring_ioctl:1668: VHOST_GET_VRING_BASE=
 [vq=3D00000000618905fc][s.index=3D1][s.num=3D42424][vq->avail_idx=3D42424]=
[vq->last_avail_idx=3D42424][vq->ndescs=3D0][vq->first_desc=3D0]
> [228101.438631] CPU: 54 PID: 2113 Comm: qemu-system-s39 Not tainted 5.5.0=
+ #344
> [228101.438632] Hardware name: IBM 3906 M04 704 (LPAR)
> [228101.438633] Call Trace:
> [228101.438634]  [<00000004fc71c132>] show_stack+0x8a/0xd0
> [228101.438636]  [<00000004fd10e72a>] dump_stack+0x8a/0xb8
> [228101.438639]  [<000003ff80377600>] vhost_vring_ioctl+0x668/0x848 [vhos=
t]
> [228101.438640]  [<000003ff80395fd4>] vhost_net_ioctl+0x4f4/0x570 [vhost_=
net]
> [228101.438642]  [<00000004fc9ccdd8>] do_vfs_ioctl+0x430/0x6f8
> [228101.438643]  [<00000004fc9cd124>] ksys_ioctl+0x84/0xb0
> [228101.438645]  [<00000004fc9cd1ba>] __s390x_sys_ioctl+0x2a/0x38
> [228101.438646]  [<00000004fd12ff72>] system_call+0x2a6/0x2c8
> [228103.682732] [2122] vhost:vhost_vring_ioctl:1653: VHOST_SET_VRING_BASE=
 [vq=3D000000009e1ac3e7][s.index=3D0][s.num=3D0][vq->avail_idx=3D27875][vq-=
>last_avail_idx=3D27709][vq->ndescs=3D65][vq->first_desc=3D22]
> [228103.682735] CPU: 44 PID: 2122 Comm: CPU 0/KVM Not tainted 5.5.0+ #344
> [228103.682739] Hardware name: IBM 3906 M04 704 (LPAR)
> [228103.682741] Call Trace:
> [228103.682748]  [<00000004fc71c132>] show_stack+0x8a/0xd0
> [228103.682752]  [<00000004fd10e72a>] dump_stack+0x8a/0xb8
> [228103.682761]  [<000003ff80377422>] vhost_vring_ioctl+0x48a/0x848 [vhos=
t]
> [228103.682764]  [<000003ff80395fd4>] vhost_net_ioctl+0x4f4/0x570 [vhost_=
net]
> [228103.682767]  [<00000004fc9ccdd8>] do_vfs_ioctl+0x430/0x6f8
> [228103.682769]  [<00000004fc9cd124>] ksys_ioctl+0x84/0xb0
> [228103.682771]  [<00000004fc9cd1ba>] __s390x_sys_ioctl+0x2a/0x38
> [228103.682773]  [<00000004fd12ff72>] system_call+0x2a6/0x2c8
> [228103.682794] [2122] vhost:vhost_vring_ioctl:1653: VHOST_SET_VRING_BASE=
 [vq=3D00000000618905fc][s.index=3D1][s.num=3D0][vq->avail_idx=3D42424][vq-=
>last_avail_idx=3D42424][vq->ndescs=3D0][vq->first_desc=3D0]
> [228103.682795] CPU: 44 PID: 2122 Comm: CPU 0/KVM Not tainted 5.5.0+ #344
> [228103.682797] Hardware name: IBM 3906 M04 704 (LPAR)
> [228103.682797] Call Trace:
> [228103.682799]  [<00000004fc71c132>] show_stack+0x8a/0xd0
> [228103.682801]  [<00000004fd10e72a>] dump_stack+0x8a/0xb8
> [228103.682804]  [<000003ff80377422>] vhost_vring_ioctl+0x48a/0x848 [vhos=
t]
> [228103.682806]  [<000003ff80395fd4>] vhost_net_ioctl+0x4f4/0x570 [vhost_=
net]
> [228103.682808]  [<00000004fc9ccdd8>] do_vfs_ioctl+0x430/0x6f8
> [228103.682810]  [<00000004fc9cd124>] ksys_ioctl+0x84/0xb0
> [228103.682812]  [<00000004fc9cd1ba>] __s390x_sys_ioctl+0x2a/0x38
> [228103.682813]  [<00000004fd12ff72>] system_call+0x2a6/0x2c8
>
>
> Isnt that triggered by resetting the virtio devices during system reboot?
>

Yes. I don't know exactly why qemu is sending them, but vhost should
be able to "protect/continue" the same way it used to be before
batching patches.

Did you lose connectivity or experienced rebooting with this patches applie=
d?

Thanks!

