Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6363A39B74E
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 12:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhFDKqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 06:46:48 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:37741 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhFDKqr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 06:46:47 -0400
Received: from [192.168.1.155] ([77.9.34.20]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MXH3e-1lrzgc1R4Y-00YmfZ; Fri, 04 Jun 2021 12:44:32 +0200
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <bb6846bf-bd3c-3802-e0d7-226ec9b33384@metux.net>
 <20210602172424.GD1002214@nvidia.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <bd0f485c-5f70-b087-2a5a-d2fe6e16817d@metux.net>
Date:   Fri, 4 Jun 2021 12:44:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210602172424.GD1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:EoukDPcc2J/QT1D3boJAqDV3J9p3cqCtFNu4BEvhSOo+pu9OZsX
 DwBwLSc9+AiWMjMqEkc8DgpMYjdaXZ3udFjKV/t35j93kOSrcJS2O5rSy8bS4O9YWqrwJah
 eQ3aEeFMxZainqV/DPiuIeWIiAAeeoQNexILCOmEFhLNHZ/NUZBkuwfo46oactlC0K7Fada
 vDtxNQu+o6eAn++Bv+/eQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QKgPDva5+wg=:eeMux13sB16S9C4PhjuoZD
 CtwoD8dWEh81W5fy1QPhYLQUS15Eyu4lv3ZTs3TJ1ftGLpHB2oin7q+5F1zibM1WVSzfdeScd
 uU0679MJoje4xsogtaueiuTQtRcF9QzF0/XvHjQzfWg0g+KGNEw58XxmgZulfIvcirFRfd0JS
 bDRA6Bz3nIU+Vhb20syeejdhTusBXSk3fj0k0p07MLmf3Aw9Su2r8ncxiz9zoFX04+i2yPQ4O
 9xQpYJA09Bamh3J5+sDfaH3BuXCmI5Uj1YN1YFPi1/3l9FGCN95CEX+PvIhQAQ3/MmkdZIvJG
 AGR70wW8AgrmjraQNoKhqd0CX0w1JHDhv1rd0feIIp/1VWd0xxSHnqyle4T2JlOBmNHY5PuWH
 /mT93AOHNqxmXXtc2D3+VCmGUYySMWbv1MyW00of6y0T07yKv3XmCL948iDJae4WYI826EjvO
 sSSSZUyu1ujzfih9pcDYtclYWtmKmNXkn3y9dqmlywTwqoL7hphFkBhxYGsE9vU/fGfUNaH3H
 PElzz4R4ACzW4c8fgPPEko=
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.06.21 19:24, Jason Gunthorpe wrote:

Hi,

 >> If I understand this correctly, /dev/ioasid is a kind of "common 
supplier"
 >> to other APIs / devices. Why can't the fd be acquired by the
 >> consumer APIs (eg. kvm, vfio, etc) ?
 >
 > /dev/ioasid would be similar to /dev/vfio, and everything already
 > deals with exposing /dev/vfio and /dev/vfio/N together
 >
 > I don't see it as a problem, just more work.

One of the problems I'm seeing is in container environments: when
passing in an vfio device, we now also need to pass in /dev/ioasid,
thus increasing the complexity in container setup (or orchestration).

And in such scenarios you usually want to pass in one specific device,
not all of the same class, and usually orchestration shall pick the
next free one.

Can we make sure that a process having full access to /dev/ioasid
while only supposed to have to specific consumer devices, can't do
any harm (eg. influencing other containers that might use a different
consumer device) ?

Note that we don't have device namespaces yet (device isolation still
has to be done w/ complicated bpf magic). I'm already working on that,
but even "simple" things like loopdev allocation turns out to be not
entirely easy.

 > Having FDs spawn other FDs is pretty ugly, it defeats the "everything
 > is a file" model of UNIX.

Unfortunately, this is already defeated in many other places :(
(I'd even claim that ioctls already break it :p)

It seems your approach also breaks this, since we now need to open two
files in order to talk to one device.

By the way: my idea does keep the "everything's a file" concept - we
just have a file that allows opening "sub-files". Well, it would be
better if devices could also have directory semantics.


--mtx

---
Hinweis: unverschlüsselte E-Mails können leicht abgehört und manipuliert
werden ! Für eine vertrauliche Kommunikation senden Sie bitte ihren
GPG/PGP-Schlüssel zu.
---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
