Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4BF1F4797
	for <lists+kvm@lfdr.de>; Tue,  9 Jun 2020 21:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732230AbgFITyN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jun 2020 15:54:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45294 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731214AbgFITyL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jun 2020 15:54:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591732450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+BJRkonEJx+ZVdwFs6Fv9GhnTl9qmo3SNY2XjYXe1xc=;
        b=Vkk8zq0V/UdVbsheAbAZ70kRsOWwWnIsDdcn3+FxW8Rl06gaKIX+/R+Ji/fppsmARdl+Jy
        PwZk5pcc64QpdpPRI8h3KeKs+Lbtc+atMuQwNwXcLxDUaLCAQMWsybMePELLALFpp9Kema
        rQ+KJACWB+rVFl2L6y31ggu2UhfDs9w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-AuUam_f3NACnOtpgizSuEA-1; Tue, 09 Jun 2020 15:54:06 -0400
X-MC-Unique: AuUam_f3NACnOtpgizSuEA-1
Received: by mail-wm1-f71.google.com with SMTP id h25so1228200wmb.0
        for <kvm@vger.kernel.org>; Tue, 09 Jun 2020 12:54:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=+BJRkonEJx+ZVdwFs6Fv9GhnTl9qmo3SNY2XjYXe1xc=;
        b=Vj2qAoRWzQ/Lb9O6mFMCF2pgSeEqWoYCtudKGgU8fO0GF1M4Xi096V5vFIsf/SMu3H
         mENWc0PXUjJ4IxqGxTNsoQ/a2VHzI1C8sA509QHuiCld6BdAP2WHwlyV4Z5cl9qIA6jD
         jsxV4DQ5k/hlkGjCeQlWtCz1GRs+OtyUUUxJF96zaxWvvTO9Q4kH+P8AtL8VYthgfABl
         wUKYePVwd4CHizaJyC0C3upA0dUmXwqyjwo6F3EYE/1w3WCduqqyjr1uqBTsYLmX3VCf
         umKWWFuON3aNl0RmEhNxPwstV9yDQZlSxRtq/3LqhHIsqSC7m74vJMb7FsEnCOaJm937
         R8Rg==
X-Gm-Message-State: AOAM530AFYxOF0emvmFrZM3XoWD/dHQmOVTwnkWN/ibJ9UvLgHa+aYhf
        od0UxTozRog14Qslk/gk5aXfzL9BdGmS3H0zvx/Syvn/cXZdJDWnUUFdN7VSfznbpqxgUhld0U8
        PIPKUDwX8RzHW
X-Received: by 2002:adf:f446:: with SMTP id f6mr6240911wrp.59.1591732445435;
        Tue, 09 Jun 2020 12:54:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVSAhS9By6hEKC4dTsLyv6qAh0Rl9AA+1K1hr9Ygb1hRBqUIEmv23+WTfqP/I3WqlpyXB04g==
X-Received: by 2002:adf:f446:: with SMTP id f6mr6240888wrp.59.1591732445210;
        Tue, 09 Jun 2020 12:54:05 -0700 (PDT)
Received: from [192.168.3.122] (p5b0c6339.dip0.t-ipconnect.de. [91.12.99.57])
        by smtp.gmail.com with ESMTPSA id a1sm4147281wmd.28.2020.06.09.12.54.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 12:54:04 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   David Hildenbrand <david@redhat.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v3 00/20] virtio-mem: Paravirtualized memory hot(un)plug
Date:   Tue, 9 Jun 2020 21:54:02 +0200
Message-Id: <9083E2B4-88E4-4E0E-9270-225F1B2DF046@redhat.com>
References: <20200609194114.GA15818@linux.intel.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        teawater <teawaterz@linux.alibaba.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hailiang Zhang <zhang.zhanghailiang@huawei.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Juan Quintela <quintela@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Markus Armbruster <armbru@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20200609194114.GA15818@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: iPhone Mail (17E262)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> Am 09.06.2020 um 21:42 schrieb Sean Christopherson <sean.j.christopherson@=
intel.com>:
>=20
> =EF=BB=BFOn Tue, Jun 09, 2020 at 02:42:59PM -0400, Michael S. Tsirkin wrot=
e:
>>> On Tue, Jun 09, 2020 at 08:38:15PM +0200, David Hildenbrand wrote:
>>> On 09.06.20 18:18, Eduardo Habkost wrote:
>>>> On Tue, Jun 09, 2020 at 11:59:04AM -0400, Michael S. Tsirkin wrote:
>>>>> On Tue, Jun 09, 2020 at 03:26:08PM +0200, David Hildenbrand wrote:
>>>>>> On 09.06.20 15:11, Michael S. Tsirkin wrote:
>>>>>>> On Wed, Jun 03, 2020 at 04:48:54PM +0200, David Hildenbrand wrote:
>>>>>>>> This is the very basic, initial version of virtio-mem. More info on=

>>>>>>>> virtio-mem in general can be found in the Linux kernel driver v2 po=
sting
>>>>>>>> [1] and in patch #10. The latest Linux driver v4 can be found at [2=
].
>>>>>>>>=20
>>>>>>>> This series is based on [3]:
>>>>>>>>    "[PATCH v1] pc: Support coldplugging of virtio-pmem-pci devices o=
n all
>>>>>>>>     buses"
>>>>>>>>=20
>>>>>>>> The patches can be found at:
>>>>>>>>    https://github.com/davidhildenbrand/qemu.git virtio-mem-v3
>>>>>>>=20
>>>>>>> So given we tweaked the config space a bit, this needs a respin.
>>>>>>=20
>>>>>> Yeah, the virtio-mem-v4 branch already contains a fixed-up version. W=
ill
>>>>>> send during the next days.
>>>>>=20
>>>>> BTW. People don't normally capitalize the letter after ":".
>>>>> So a better subject is
>>>>>  virtio-mem: paravirtualized memory hot(un)plug
>>>>=20
>>>> I'm not sure that's still the rule:
>>>>=20
>>>> [qemu/(49ee115552...)]$ git log --oneline v4.0.0.. | egrep ': [A-Z]' | w=
c -l
>>>> 5261
>>>> [qemu/(49ee115552...)]$ git log --oneline v4.0.0.. | egrep ': [a-z]' | w=
c -l
>>>> 2921
>>>>=20
>>>=20
>>> Yeah, I switched to this scheme some years ago (I even remember that
>>> some QEMU maintainer recommended it). I decided to just always
>>> capitalize. Not that it should really matter ... :)
>>=20
>> Don't mind about qemu but you don't want to do that for Linux.
>=20
> Heh, depends on who you ask.  The tip tree maintainers (strongly) prefer
> capitalizing the first word after the colon[*], and that naturally
> percolates into a lot of other subsystems, e.g. I follow that pattern for
> KVM so that I don't have to remember to switch when submitting patches
> against a tip branch.
>=20

Dito, most developers have other things to worry about. E.g., Andrew (-mm tr=
ee) automatically converts everything to lower-case when applying patches.=

