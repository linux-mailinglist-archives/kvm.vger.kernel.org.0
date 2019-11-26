Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B31910A649
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 23:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfKZWCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Nov 2019 17:02:13 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34187 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfKZWCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 17:02:13 -0500
Received: by mail-lj1-f195.google.com with SMTP id m6so14663943ljc.1
        for <kvm@vger.kernel.org>; Tue, 26 Nov 2019 14:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jIlvgH7GkjMm5Fm1Bx/lY01P8MyoEe6h4HHhXWC23Qc=;
        b=ndnCBhIj8byM5T63YMQ2tUJlUxUR5uzTBPJPU4VHBzoi4TNywKibjwtBReW8vBjU7l
         co4kHNslBOq35J3qeVobWEQkCBWvS+rpC4zwJfcMEBmzMhe2qcCOU6Kp/G00Zc9mx1yO
         xr/kBdRU1WzNK6cCORkhXGt5/iEWbWLWX6Lwp1lJbuCJowwHtZ9PIOFDfnb+9zKff5Le
         3Ld5pYpGhcUk5B2i16LWyerFILURjeqMTob8HriSixnLPx3VlaRRHyyrlMktILxq/RwU
         plfMlmM/gHbwKxCE2bkFZxYpGd7wvhcQ660rUOl29giYEHidKjPLEVSscItkCb8DFzEF
         uGeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jIlvgH7GkjMm5Fm1Bx/lY01P8MyoEe6h4HHhXWC23Qc=;
        b=rNxi0wGEYNPk3fET6j7BcTYMYV7QonKbgkGr78NRWPy+w4DzbWdvzcecvGN/nqZqpt
         3Y5FTZFn+2DwH48uViuMSr2uc65NX08ZptiOpDyv/IxJbssLFpG7QrrbobaYKASRJ6T5
         ZPx8bnVJgGJGWi3grxbOsSUY3qjm8bl+GLSe019+c4PLcdM9MZRcdGzj6Qml4i8kyQ0v
         5+dpW9ODxcaF6R0cE1V64Em7Q0aDHyhdX71I0eWMAGQhwjLUGdcDh4D31veTLcb6axHS
         01HKFq+l/DjKxqU8F6xsGjUYof9PE+ZsMVFphIe+oLxIMyBp29vsvwqLEpSyDcbCMf+n
         QNLg==
X-Gm-Message-State: APjAAAVQtBKTSiV/Qt36PNzvnGLQ+qFzNRgIs7oZ+8YC7+fYVAGAkkml
        aUjTFEfe0ZCw+IC6Xld47r7VidIfbwAQAL2XD9Yupg==
X-Google-Smtp-Source: APXvYqytbpMqe+yt7kf0QVOv8NSjT14vJa1WAatkadhVMZmBkFT4NJRxnOvYf6+4w54fjqeM/g6b7It26TD8BtxUt4w=
X-Received: by 2002:a05:651c:326:: with SMTP id b6mr28119597ljp.119.1574805730784;
 Tue, 26 Nov 2019 14:02:10 -0800 (PST)
MIME-Version: 1.0
References: <7067e657-5c8e-b724-fa6a-086fece6e6c3@redhat.com>
 <20190904215801.2971-1-haotian.wang@sifive.com> <59982499-0fc1-2e39-9ff9-993fb4dd7dcc@redhat.com>
 <2cf00ec4-1ed6-f66e-6897-006d1a5b6390@ti.com> <d87fbe2f-b3ae-5cb1-448a-41335febc460@redhat.com>
 <9f8e596f-b601-7f97-a98a-111763f966d1@ti.com> <CABEDWGxmTvENvz-3Om0wzPb=wrx4XvPhkNYFTy1O6YAHxm+A-w@mail.gmail.com>
In-Reply-To: <CABEDWGxmTvENvz-3Om0wzPb=wrx4XvPhkNYFTy1O6YAHxm+A-w@mail.gmail.com>
From:   Alan Mikhak <alan.mikhak@sifive.com>
Date:   Tue, 26 Nov 2019 14:01:59 -0800
Message-ID: <CABEDWGzppgrGKwhr4J2RB8nG6B1Nqg9E1NVZEA6GDvzat7DNQQ@mail.gmail.com>
Subject: Re: [PATCH] pci: endpoint: functions: Add a virtnet EP function
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        lorenzo.pieralisi@arm.com, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org,
        "haotian.wang@duke.edu" <haotian.wang@duke.edu>,
        Jon Mason <jdmason@kudzu.us>, KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 26, 2019 at 1:55 PM Alan Mikhak <alan.mikhak@sifive.com> wrote:
>
> On Tue, Nov 26, 2019 at 4:36 AM Kishon Vijay Abraham I <kishon@ti.com> wr=
ote:
> >
> > Hi Jason,
> >
> > On 26/11/19 3:28 PM, Jason Wang wrote:
> > >
> > > On 2019/11/25 =E4=B8=8B=E5=8D=888:49, Kishon Vijay Abraham I wrote:
> > >> +Alan, Jon
> > >>
> > >> Hi Jason, Haotian, Alan,
> > >>
> > >> On 05/09/19 8:26 AM, Jason Wang wrote:
> > >>> On 2019/9/5 =E4=B8=8A=E5=8D=885:58, Haotian Wang wrote:
> > >>>> Hi Jason,
> > >>>>
> > >>>> I have an additional comment regarding using vring.
> > >>>>
> > >>>> On Tue, Sep 3, 2019 at 6:42 AM Jason Wang <jasowang@redhat.com> wr=
ote:
> > >>>>> Kind of, in order to address the above limitation, you probably w=
ant to
> > >>>>> implement a vringh based netdevice and driver. It will work like,
> > >>>>> instead of trying to represent a virtio-net device to endpoint,
> > >>>>> represent a new type of network device, it uses two vringh ring i=
nstead
> > >>>>> virtio ring. The vringh ring is usually used to implement the
> > >>>>> counterpart of virtio driver. The advantages are obvious:
> > >>>>>
> > >>>>> - no need to deal with two sets of features, config space etc.
> > >>>>> - network specific, from the point of endpoint linux, it's not a =
virtio
> > >>>>> device, no need to care about transport stuffs or embedding inter=
nal
> > >>>>> virtio-net specific data structures
> > >>>>> - reuse the exist codes (vringh) to avoid duplicated bugs, implem=
enting
> > >>>>> a virtqueue is kind of challenge
> > >>>> With vringh.c, there is no easy way to interface with virtio_net.c=
.
> > >>>>
> > >>>> vringh.c is linked with vhost/net.c nicely
> > >>>
> > >>> Let me clarify, vhost_net doesn't use vringh at all (though there's=
 a
> > >>> plan to switch to use vringh).
> > >>>
> > >>>
> > >>>> but again it's not easy to
> > >>>> interface vhost/net.c with the network stack of endpoint kernel. T=
he
> > >>>> vhost drivers are not designed with the purpose of creating anothe=
r
> > >>>> suite of virtual devices in the host kernel in the first place. If=
 I try
> > >>>> to manually write code for this interfacing, it seems that I will =
do
> > >>>> duplicate work that virtio_net.c does.
> > >>>
> > >>> Let me explain:
> > >>>
> > >>> - I'm not suggesting to use vhost_net since it can only deal with
> > >>> userspace virtio rings.
> > >>> - I suggest to introduce netdev that has vringh vring assoticated.
> > >>> Vringh was designed to deal with virtio ring located at different t=
ypes
> > >>> of memory. It supports userspace vring and kernel vring currently, =
but
> > >>> it should not be too hard to add support for e.g endpoint device th=
at
> > >>> requires DMA or whatever other method to access the vring. So it wa=
s by
> > >>> design to talk directly with e.g kernel virtio device.
> > >>> - In your case, you can read vring address from virtio config space
> > >>> through endpoint framework and then create vringh. It's as simple a=
s:
> > >>> creating a netdev, read vring address, and initialize vringh. Then =
you
> > >>> can use vringh helper to get iov and build skb etc (similar to caif=
_virtio).
> > >>  From the discussions above and from looking at Jason's mdev patches=
 [1], I've
> > >> created the block diagram below.
> > >>
> > >> While this patch (from Haotian) deals with RC<->EP connection, I'd a=
lso like
> > >> this to be extended for NTB (using multiple EP instances. RC<->EP<->=
EP<->RC)
> > >> [2][3].
> > >>
> > >> +-----------------------------------+   +---------------------------=
----------+
> > >> |                                   |   |                           =
          |
> > >> |  +------------+  +--------------+ |   | +------------+  +---------=
-----+    |
> > >> |  | vringh_net |  | vringh_rpmsg | |   | | virtio_net |  | virtio_r=
pmsg |    |
> > >> |  +------------+  +--------------+ |   | +------------+  +---------=
-----+    |
> > >> |                                   |   |                           =
          |
> > >> |          +---------------+        |   |          +---------------+=
          |
> > >> |          |  vringh_mdev  |        |   |          |  virtio_mdev  |=
          |
> > >> |          +---------------+        |   |          +---------------+=
          |
> > >> |                                   |   |                           =
          |
> > >> |  +------------+   +------------+  |   | +-------------------+ +---=
---------+|
> > >> |  | vringh_epf |   | vringh_ntb |  |   | | virtio_pci_common | | vi=
rtio_ntb ||
> > >> |  +------------+   +------------+  |   | +-------------------+ +---=
---------+|
> > >> | (PCI EP Device)   (NTB Secondary  |   |        (PCI RC)       (NTB=
 Primary  |
> > >> |                       Device)     |   |                          D=
evice)    |
> > >> |                                   |   |                           =
          |
> > >> |                                   |   |                           =
          |
> > >> |             (A)                   |   |              (B)          =
          |
> > >> +-----------------------------------+   +---------------------------=
----------+
> > >>
> > >> GUEST SIDE (B):
> > >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >> In the virtualization terminology, the side labeled (B) will be the =
guest side.
> > >> Here it will be the place where PCIe host (RC) side SW will execute =
(Ignore NTB
> > >> for this discussion since PCIe host side SW will execute on both end=
s of the
> > >> link in the case of NTB. However I've included in the block diagram =
since the
> > >> design we adopt should be able to be extended for NTB as well).
> > >>
> > >> Most of the pieces in (B) already exists.
> > >> 1) virtio_net and virtio_rpmsg: No modifications needed and can be u=
sed as it
> > >>     is.
> > >> 2) virtio_mdev: Jason has sent this [1]. This could be used as it is=
 for EP
> > >>     usecases as well. Jason has created mvnet based on virtio_mdev, =
but for EP
> > >>     usecases virtio_pci_common and virtio_ntb should use it.
> > >
> > >
> > > Can we implement NTB as a transport for virtio, then there's no need =
for
> > > virtio_mdev?
> >
> > Yes, we could have NTB specific virtio_config_ops. Where exactly should
> > virtio_mdev be used?
> > >
> > >
> > >> 3) virtio_pci_common: This should be used when a PCIe EPF is connect=
ed. This
> > >>     should be modified to create virtio_mdev instead of directly cre=
ating virtio
> > >>     device.
> > >> 4) virtio_ntb: This is used for NTB where one end of the link should=
 use
> > >>     virtio_ntb. This should create virtio_mdev.
> > >>
> > >> With this virtio_mdev can abstract virtio_pci_common and virtio_ntb =
and ideally
> > >> any virtio drivers can be used for EP or NTB (In the block diagram a=
bove
> > >> virtio_net and virtio_rpmsg can be used).
> > >>
> > >> HOST SIDE (A):
> > >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >> In the virtualization terminology, the side labeled (A) will be the =
host side.
> > >> Here it will be the place where PCIe device (Endpoint) side SW will =
execute.
> > >>
> > >> Bits and pieces of (A) should exist but there should be considerable=
 work in
> > >> this.
> > >> 1) vringh_net: There should be vringh drivers corresponding to
> > >>     the virtio drivers on the guest side (B). vringh_net should regi=
ster with
> > >>     the net core. The vringh_net device should be created by vringh_=
mdev. This
> > >>     should be new development.
> > >> 2) vringh_rpmsg: vringh_rpmsg should register with the rpmsg core. T=
he
> > >>     vringh_rpmsg device should be created by vringh_mdev.
> > >> 3) vringh_mdev: This layer should define ops specific to vringh (e.g
> > >>     get_desc_addr() should give vring descriptor address and will de=
pend on
> > >>     either EP device or NTB device). I haven't looked further on wha=
t other ops
> > >>     will be needed. IMO this layer should also decide whether _kern(=
) or _user()
> > >>     vringh helpers should be invoked.
> > >
> > >
> > > Right, but probably not necessary called "mdev", it could just some a=
bstraction
> > > as a set of callbacks.
> >
> > Yeah, we could have something like vringh_config_ops. Once we start to
> > implement, this might get more clear.
> > >
> > >
> > >> 4) vringh_epf: This will be used for PCIe endpoint. This will implem=
ent ops to
> > >>     get the vring descriptor address.
> > >> 5) vringh_ntb: Similar to vringh_epf but will interface with NTB dev=
ice instead
> > >>     of EPF device.
> > >>
> > >> Jason,
> > >>
> > >> Can you give your comments on the above design? Do you see any flaws=
/issues
> > >> with the above approach?
> > >
> > >
> > > Looks good overall, see questions above.
> >
> > Thanks for your comments Jason.
> >
> > Haotian, Alan, Me or whoever gets to implement this first, should try t=
o follow
> > the above discussed approach.
>
> Kishon,
>
> Thank you, and Jason Wang, for comments and suggestions re: NTB.
>
> My preference is to see Haotian continue his work on this
> patch, if and when possible. As for expanding the scope to
> support NTB, I personally find it very interesting. I will
> keep an eye open for a suitable hardware platform in house
> before figuring out if and when it would be possible to do such
> work. From your slides, you may get there first since you
> seem to have a suitable hardware platform already.

- haotian.wang@sifive.com

other: haotian.wang@duke.edu

>
> Regards,
> Alan
>
> >
> > Thanks
> > Kishon
> >
> > >
> > > Thanks
> > >
> > >
> > >>
> > >> Thanks
> > >> Kishon
> > >>
> > >> [1] -> https://lkml.org/lkml/2019/11/18/261
> > >> [2] -> https://lkml.org/lkml/2019/9/26/291
> > >> [3] ->
> > >> https://www.linuxplumbersconf.org/event/4/contributions/395/attachme=
nts/284/481/Implementing_NTB_Controller_Using_PCIe_Endpoint_-_final.pdf
> > >>
> > >>>
> > >>>> There will be two more main disadvantages probably.
> > >>>>
> > >>>> Firstly, there will be two layers of overheads. vhost/net.c uses
> > >>>> vringh.c to channel data buffers into some struct sockets. This is=
 the
> > >>>> first layer of overhead. That the virtual network device will have=
 to
> > >>>> use these sockets somehow adds another layer of overhead.
> > >>>
> > >>> As I said, it doesn't work like vhost and no socket is needed at al=
l.
> > >>>
> > >>>
> > >>>> Secondly, probing, intialization and de-initialization of the virt=
ual
> > >>>> network_device are already non-trivial. I'll likely copy this part
> > >>>> almost verbatim from virtio_net.c in the end. So in the end, there=
 will
> > >>>> be more duplicate code.
> > >>>
> > >>> It will be a new type of network device instead of virtio, you don'=
t
> > >>> need to care any virtio stuffs but vringh in your codes. So it look=
s to
> > >>> me it would be much simpler and compact.
> > >>>
> > >>> But I'm not saying your method is no way to go, but you should deal=
 with
> > >>> lots of other issues like I've replied in the previous mail. What y=
ou
> > >>> want to achieve is
> > >>>
> > >>> 1) Host (virtio-pci) <-> virtio ring <-> virtual eth device <-> vir=
tio
> > >>> ring <-> Endpoint (virtio with customized config_ops).
> > >>>
> > >>> But I suggest is
> > >>>
> > >>> 2) Host (virtio-pci) <-> virtio ring <-> virtual eth device <-> vri=
ngh
> > >>> vring (virtio ring in the Host) <-> network device
> > >>>
> > >>> The differences is.
> > >>> - Complexity: In your proposal, there will be two virtio devices an=
d 4
> > >>> virtqueues. It means you need to prepare two sets of features, conf=
ig
> > >>> ops etc. And dealing with inconsistent feature will be a pain. It m=
ay
> > >>> work for simple case like a virtio-net device with only _F_MAC, but=
 it
> > >>> would be hard to be expanded. If we decide to go for vringh, there =
will
> > >>> be a single virtio device and 2 virtqueues. In the endpoint part, i=
t
> > >>> will be 2 vringh vring (which is actually point the same virtqueue =
from
> > >>> Host side) and a normal network device. There's no need for dealing=
 with
> > >>> inconsistency, since vringh basically sever as a a device
> > >>> implementation, the feature negotiation is just between device (net=
work
> > >>> device with vringh) and driver (virtito-pci) from the view of Linux
> > >>> running on the PCI Host.
> > >>> - Maintainability: A third path for dealing virtio ring. We've alre=
ady
> > >>> had vhost and vringh, a third path will add a lot of overhead when
> > >>> trying to maintaining them. My proposal will try to reuse vringh,
> > >>> there's no need a new path.
> > >>> - Layer violation: We want to hide the transport details from the d=
evice
> > >>> and make virito-net device can be used without modification. But yo=
ur
> > >>> codes try to poke information like virtnet_info. My proposal is to =
just
> > >>> have a new networking device that won't need to care virtio at all.=
 It's
> > >>> not that hard as you imagine to have a new type of netdev, I sugges=
t to
> > >>> take a look at how caif_virtio is done, it would be helpful.
> > >>>
> > >>> If you still decide to go with two two virtio device model, you nee=
d
> > >>> probably:
> > >>> - Proving two sets of config and features, and deal with inconsiste=
ncy
> > >>> - Try to reuse the vringh codes
> > >>> - Do not refer internal structures from virtio-net.c
> > >>>
> > >>> But I recommend to take a step of trying vringh method which should=
 be
> > >>> much simpler.
> > >>>
> > >>> Thanks
> > >>>
> > >>>
> > >>>> Thank you for your patience!
> > >>>>
> > >>>> Best,
> > >>>> Haotian
> > >
