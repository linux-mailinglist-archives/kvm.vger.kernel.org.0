Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B01CB17D851
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 04:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCIDhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Mar 2020 23:37:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22460 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726781AbgCIDhE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Mar 2020 23:37:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583725022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S0qLVKfYZK8pYenESepAxVRIXfABKBnhJdpq7W8RSUA=;
        b=fCsYG5F2c/j7p+LxsK7SJu3WHPEpdfleoVZ0Ttuk23Jkx1bpNEI/w/d01Js2QSlVwDYgbS
        DfbAGbbvEfZ+OoQoHQGKI/JR5Xp0Gw0Zczc6ysuklktadqltg26n5U/eZJ6DsXADkymgEF
        Is7CG+RJWN8J0jr7mGTVEfh99AMYM4U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-VoLRSUGNOjaqQVz4KT5Ihg-1; Sun, 08 Mar 2020 23:36:59 -0400
X-MC-Unique: VoLRSUGNOjaqQVz4KT5Ihg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65DFC477;
        Mon,  9 Mar 2020 03:36:57 +0000 (UTC)
Received: from [10.72.13.185] (ovpn-13-185.pek2.redhat.com [10.72.13.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2A06D9008F;
        Mon,  9 Mar 2020 03:36:47 +0000 (UTC)
Subject: Re: [PATCH v2 0/7] vfio/pci: SR-IOV support
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dev@dpdk.org" <dev@dpdk.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "thomas@monjalon.net" <thomas@monjalon.net>,
        "bluca@debian.org" <bluca@debian.org>,
        "jerinjacobk@gmail.com" <jerinjacobk@gmail.com>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
References: <158213716959.17090.8399427017403507114.stgit@gimli.home>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D79A8A7@SHSMSX104.ccr.corp.intel.com>
 <a6c04bac-0a37-f4c0-876e-e5cf2a8a6c3f@redhat.com>
 <20200305101406.02703e2a@w520.home>
 <3e8db1d0-8afc-f1e9-e857-aead4717fa11@redhat.com>
 <20200306092445.1bd4611c@x1.home>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d9ac428f-c764-014c-db5b-3f94d8f3e626@redhat.com>
Date:   Mon, 9 Mar 2020 11:36:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200306092445.1bd4611c@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/3/7 =E4=B8=8A=E5=8D=8812:24, Alex Williamson wrote:
> On Fri, 6 Mar 2020 11:35:21 +0800
> Jason Wang <jasowang@redhat.com> wrote:
>
>> On 2020/3/6 =E4=B8=8A=E5=8D=881:14, Alex Williamson wrote:
>>> On Tue, 25 Feb 2020 14:09:07 +0800
>>> Jason Wang <jasowang@redhat.com> wrote:
>>>  =20
>>>> On 2020/2/25 =E4=B8=8A=E5=8D=8810:33, Tian, Kevin wrote:
>>>>>> From: Alex Williamson
>>>>>> Sent: Thursday, February 20, 2020 2:54 AM
>>>>>>
>>>>>> Changes since v1 are primarily to patch 3/7 where the commit log i=
s
>>>>>> rewritten, along with option parsing and failure logging based on
>>>>>> upstream discussions.  The primary user visible difference is that
>>>>>> option parsing is now much more strict.  If a vf_token option is
>>>>>> provided that cannot be used, we generate an error.  As a result o=
f
>>>>>> this, opening a PF with a vf_token option will serve as a mechanis=
m of
>>>>>> setting the vf_token.  This seems like a more user friendly API th=
an
>>>>>> the alternative of sometimes requiring the option (VFs in use) and
>>>>>> sometimes rejecting it, and upholds our desire that the option is
>>>>>> always either used or rejected.
>>>>>>
>>>>>> This also means that the VFIO_DEVICE_FEATURE ioctl is not the only
>>>>>> means of setting the VF token, which might call into question whet=
her
>>>>>> we absolutely need this new ioctl.  Currently I'm keeping it becau=
se I
>>>>>> can imagine use cases, for example if a hypervisor were to support
>>>>>> SR-IOV, the PF device might be opened without consideration for a =
VF
>>>>>> token and we'd require the hypservisor to close and re-open the PF=
 in
>>>>>> order to set a known VF token, which is impractical.
>>>>>>
>>>>>> Series overview (same as provided with v1):
>>>>> Thanks for doing this!
>>>>>     =20
>>>>>> The synopsis of this series is that we have an ongoing desire to d=
rive
>>>>>> PCIe SR-IOV PFs from userspace with VFIO.  There's an immediate ne=
ed
>>>>>> for this with DPDK drivers and potentially interesting future use
>>>>> Can you provide a link to the DPDK discussion?
>>>>>     =20
>>>>>> cases in virtualization.  We've been reluctant to add this support
>>>>>> previously due to the dependency and trust relationship between th=
e
>>>>>> VF device and PF driver.  Minimally the PF driver can induce a den=
ial
>>>>>> of service to the VF, but depending on the specific implementation=
,
>>>>>> the PF driver might also be responsible for moving data between VF=
s
>>>>>> or have direct access to the state of the VF, including data or st=
ate
>>>>>> otherwise private to the VF or VF driver.
>>>>> Just a loud thinking. While the motivation of VF token sounds reaso=
nable
>>>>> to me, I'm curious why the same concern is not raised in other usag=
es.
>>>>> For example, there is no such design in virtio framework, where the
>>>>> virtio device could also be restarted, putting in separate process =
(vhost-user),
>>>>> and even in separate VM (virtio-vhost-user), etc.
>>>> AFAIK, the restart could only be triggered by either VM or qemu. But
>>>> yes, the datapath could be offloaded.
>>>>
>>>> But I'm not sure introducing another dedicated mechanism is better t=
han
>>>> using the exist generic POSIX mechanism to make sure the connection
>>>> (AF_UINX) is secure.
>>>>
>>>>  =20
>>>>>     Of course the para-
>>>>> virtualized attribute of virtio implies some degree of trust, but a=
s you
>>>>> mentioned many SR-IOV implementations support VF->PF communication
>>>>> which also implies some level of trust. It's perfectly fine if VFIO=
 just tries
>>>>> to do better than other sub-systems, but knowing how other people
>>>>> tackle the similar problem may make the whole picture clearer. =F0=9F=
=98=8A
>>>>>
>>>>> +Jason.
>>>> I'm not quite sure e.g allowing userspace PF driver with kernel VF
>>>> driver would not break the assumption of kernel security model. At l=
east
>>>> we should forbid a unprivileged PF driver running in userspace.
>>> It might be useful to have your opinion on this series, because that'=
s
>>> exactly what we're trying to do here.  Various environments, DPDK
>>> specifically, want a userspace PF driver.  This series takes steps to
>>> mitigate the risk of having such a driver, such as requiring this VF
>>> token interface to extend the VFIO interface and validate participati=
on
>>> around a PF that is not considered trusted by the kernel.
>>
>> I may miss something. But what happens if:
>>
>> - PF driver is running by unprivileged user
>> - PF is programmed to send translated DMA request
>> - Then unprivileged user can mangle the kernel data
> ATS is a security risk regardless of SR-IOV, how does this change it?
> Thanks,


My understanding is the ATS only happen for some bugous devices. Some=20
hardware has on-chip IOMMU, this probably means unprivileged userspace=20
PF driver can control the on-chip IOMMU in this case.

Thanks


>
> Alex
>
>>> We also set
>>> a driver_override to try to make sure no host kernel driver can
>>> automatically bind to a VF of a user owned PF, only vfio-pci, but we
>>> don't prevent the admin from creating configurations where the VFs ar=
e
>>> used by other host kernel drivers.
>>>
>>> I think the question Kevin is inquiring about is whether virtio devic=
es
>>> are susceptible to the type of collaborative, shared key environment
>>> we're creating here.  For example, can a VM or qemu have access to
>>> reset a virtio device in a way that could affect other devices, ex. F=
LR
>>> on a PF that could interfere with VF operation.  Thanks,
>>
>> Right, but I'm not sure it can be done only via virtio or need support
>> from transport (e.g PCI).
>>
>> Thanks
>>
>>
>>> Alex
>>>  =20

