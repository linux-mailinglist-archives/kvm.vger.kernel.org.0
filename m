Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E94A39F3DF
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 12:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhFHKqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 06:46:03 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:34329 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbhFHKqC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 06:46:02 -0400
Received: from [192.168.1.155] ([77.7.0.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MnJdC-1l7e5D1hvo-00jJJM; Tue, 08 Jun 2021 12:43:43 +0200
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
 <bd0f485c-5f70-b087-2a5a-d2fe6e16817d@metux.net>
 <20210604123054.GL1002214@nvidia.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <329fcd72-605a-fc10-1a8d-c3f2ac3be9a1@metux.net>
Date:   Tue, 8 Jun 2021 12:43:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210604123054.GL1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:kQlbcYVyqh7Kv3mxj3JGjk3dxcaEReaRMO1wJlQyxPkwqc3rlNB
 ty1P4s3Q1U8YMBl+PAGTd/B9xN3luktYAJUvcIm8MxNrn5Ufw3QW/pOSLFBXCidANQm2vOL
 Kf0ipNSyGmyjvOYlXaOs+iavgR+8to7ozNqxLBThWjyjeMPtyrDyKl4eF6lXS34Ejofrm6p
 wfyAMKuEHX4+5ky7Fwr4A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nhyYPjt/oTs=:181063X6GaNOTval4U+P8Y
 cwsH0SmjAvrMHg8eLaYi+NgNCkjBaK49pcjziRRbc2+BTBWboMP1G/J6UGA1JZO4o0rkgiJRu
 js1Wg22BcB3fVTdJ8XE8KwKizdDPS/mUiTNloNqCDjgMVH0vBodTGeko3MzQ+1K2pbo4PxVqY
 pacCRkNxVyN4T88mjozcEpKiSYPcf4I29DPsjgKlvb+2dX1w01/bpnmZYZoApd7H9elPk1jYf
 FA/7iRSaojlhbDSqWViQX0cY6iufNvofS2ydC4paMpcH7mUXEPmNaKzxdw+io8RzhbL8pO+3K
 4TRWLInFEwbidBxYATrioZTqZ0N4hpCp/SvYDIfcNHiZjug8V0s7MpVr/6AdAPnHjSUXxAwHU
 f3BBAibd9lz3HbL12eZR4kIAFZDAYovq6GU08s1DtCbTzhUJirHdNHyixNjMC0yr7JmjWVv4k
 EkfU+sMCbj+4vxIa7lW+wuha41v3jnKCkDRiUIah6CNkFHkFkHddfO1LO8xkBbrN0KGw7hQZb
 pc4pd+imbUHacOaBdIOXCQ=
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.06.21 14:30, Jason Gunthorpe wrote:

Hi,

> Containers already needed to do this today. Container orchestration is
> hard.

Yes, but I hate to see even more work upcoming here.

> Yes, /dev/ioasid shouldn't do anything unless you have a device to
> connect it with. In this way it is probably safe to stuff it into
> every container.

Okay, if we can guarantee that, I'm completely fine.

>>> Having FDs spawn other FDs is pretty ugly, it defeats the "everything
>>> is a file" model of UNIX.
>>
>> Unfortunately, this is already defeated in many other places :(
>> (I'd even claim that ioctls already break it :p)
> 
> I think you are reaching a bit :)
> 
>> It seems your approach also breaks this, since we now need to open two
>> files in order to talk to one device.
> 
> It is two devices, thus two files.

Two separate real (hardware) devices or just two logical device nodes ?


--mtx

-- 
---
Hinweis: unverschlüsselte E-Mails können leicht abgehört und manipuliert
werden ! Für eine vertrauliche Kommunikation senden Sie bitte ihren
GPG/PGP-Schlüssel zu.
---
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
