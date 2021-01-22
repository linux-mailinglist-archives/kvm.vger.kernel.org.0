Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431C3301029
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 23:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbhAVWkS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 17:40:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729801AbhAVTpm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 14:45:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611344654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3uNDwmhw+dypTTbDZcFNMsEkHC7AyteHqMNOLnBYuX8=;
        b=OKX9SCGK/1soTaarb1Dmg2hAGL951g6wn5LhqrBHz06CVScHEbpSoEYpiEKBrNDhYHVmNm
        rcD4PavaO9xeOwcW1ghy4LqWCv9xITs8NYmzuW49oa6FT94V5o+gtNmeDewevsGirVm1Ch
        p/BDcgoNcKcek7Zc20CzC0Z4xxivEBg=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-4vApMaq6MXGsCq7TAZ02ew-1; Fri, 22 Jan 2021 14:44:12 -0500
X-MC-Unique: 4vApMaq6MXGsCq7TAZ02ew-1
Received: by mail-qk1-f200.google.com with SMTP id 205so2734403qkf.4
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 11:44:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3uNDwmhw+dypTTbDZcFNMsEkHC7AyteHqMNOLnBYuX8=;
        b=TlUM+rZwYLOSv6jMIgG4IKlyKf8EUWsb1F8pElyq1vSP/l2/oP2vMQ0vNOHHs72i7J
         6vshJwuz8DmNvfpzS4zuNbJxFvsSaJd7KOvk7NBfP0su6g1Fhh/3wIpdptQaLZW+0OB5
         UOaHhQSniI+MRQdRAZRsda+l+5jKVUalsVDWGe9wrAH7cQ1Y1bUh0KxzYO2/iVdf8Tok
         RyFbcx6rMk9n/RAS8s8+gjUtTCsk+eKaHb21liSzu5N7AMqO9p/IF6PFY/Kvs+vG4/OX
         e0sxuQKSSy4ehxRu1OXRfXDnwBZZi6iKl13fEe4KstVoCrsdvr8gsUbPOw64ToYVqBG9
         YNKQ==
X-Gm-Message-State: AOAM530h+2tBozG61/8PU6PAx26rhZH73llbLsqBCJqT3k3exO+jWvfZ
        aDkNBkEV2cq9kexzJr/W1EiHZZG5oUcLF+7LoH2SqY/l/emnPGpuIaAO1ZbEoe14Oc22wCa/w2V
        PKKIcSoR8drjXPVJ0bjW3JoBPPman
X-Received: by 2002:a05:620a:12d5:: with SMTP id e21mr3438614qkl.131.1611344651589;
        Fri, 22 Jan 2021 11:44:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6cFebtmiIS8knjYgLudy4UeqwjmnsOMneaVMKnv2KT/lJTSR4ttPMGlPsJYpw37S7QqTD713vRrO6GSoAsz8=
X-Received: by 2002:a05:620a:12d5:: with SMTP id e21mr3438585qkl.131.1611344651277;
 Fri, 22 Jan 2021 11:44:11 -0800 (PST)
MIME-Version: 1.0
References: <20201216064818.48239-1-jasowang@redhat.com> <20201216064818.48239-22-jasowang@redhat.com>
 <20210111122601.GA172492@mtl-vdi-166.wap.labs.mlnx> <da50981b-6bbc-ee61-b5b1-a57a09da8e93@redhat.com>
In-Reply-To: <da50981b-6bbc-ee61-b5b1-a57a09da8e93@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 22 Jan 2021 20:43:34 +0100
Message-ID: <CAJaqyWcRirQgz+n63rU2nYVH2RKqjQfwHGFLzOG=H46qRWuTog@mail.gmail.com>
Subject: Re: [PATCH 21/21] vdpasim: control virtqueue support
To:     Jason Wang <jasowang@redhat.com>
Cc:     Eli Cohen <elic@nvidia.com>, Michael Tsirkin <mst@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cindy Lu <lulu@redhat.com>,
        Eli Cohen <eli@mellanox.com>, lingshan.zhu@intel.com,
        Rob Miller <rob.miller@broadcom.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 12, 2021 at 4:12 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/11 =E4=B8=8B=E5=8D=888:26, Eli Cohen wrote:
> > On Wed, Dec 16, 2020 at 02:48:18PM +0800, Jason Wang wrote:
> >> This patch introduces the control virtqueue support for vDPA
> >> simulator. This is a requirement for supporting advanced features like
> >> multiqueue.
> >>
> >> A requirement for control virtqueue is to isolate its memory access
> >> from the rx/tx virtqueues. This is because when using vDPA device
> >> for VM, the control virqueue is not directly assigned to VM. Userspace
> >> (Qemu) will present a shadow control virtqueue to control for
> >> recording the device states.
> >>
> >> The isolation is done via the virtqueue groups and ASID support in
> >> vDPA through vhost-vdpa. The simulator is extended to have:
> >>
> >> 1) three virtqueues: RXVQ, TXVQ and CVQ (control virtqueue)
> >> 2) two virtqueue groups: group 0 contains RXVQ and TXVQ; group 1
> >>     contains CVQ
> >> 3) two address spaces and the simulator simply implements the address
> >>     spaces by mapping it 1:1 to IOTLB.
> >>
> >> For the VM use cases, userspace(Qemu) may set AS 0 to group 0 and AS 1
> >> to group 1. So we have:
> >>
> >> 1) The IOTLB for virtqueue group 0 contains the mappings of guest, so
> >>     RX and TX can be assigned to guest directly.
> >> 2) The IOTLB for virtqueue group 1 contains the mappings of CVQ which
> >>     is the buffers that allocated and managed by VMM only. So CVQ of
> >>     vhost-vdpa is visible to VMM only. And Guest can not access the CV=
Q
> >>     of vhost-vdpa.
> >>
> >> For the other use cases, since AS 0 is associated to all virtqueue
> >> groups by default. All virtqueues share the same mapping by default.
> >>
> >> To demonstrate the function, VIRITO_NET_F_CTRL_MACADDR is
> >> implemented in the simulator for the driver to set mac address.
> >>
> > Hi Jason,
> >
> > is there any version of qemu/libvirt available that I can see the
> > control virtqueue working in action?
>
>
> Not yet, the qemu part depends on the shadow virtqueue work of Eugenio.
> But it will work as:
>
> 1) qemu will use a separated address space for the control virtqueue
> (shadow) exposed through vhost-vDPA
> 2) the commands sent through control virtqueue by guest driver will
> intercept by qemu
> 3) Qemu will send those commands to the shadow control virtqueue
>
> Eugenio, any ETA for the new version of shadow virtqueue support in Qemu?
>

Hi Jason. Sorry for the late response.

For the notification part I have addressed all the issues of the RFC
[1], except the potential race conditions Stefan pointed, and tested
with vdpa devices. You can find at
https://github.com/eugpermar/qemu/tree/vdpa_sw_live_migration.d/notificatio=
ns.rfc
. Since the shadow path is activated only through QMP and does not
interfere with regular operation, I could post to the qemu list if you
prefer. The series will be smaller if merged in steps.

Adding the buffer forwarding on top should not take long.

[1] https://lkml.org/lkml/2020/9/23/1243

Thanks!

