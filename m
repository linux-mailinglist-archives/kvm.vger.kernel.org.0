Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F37398462
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 10:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbhFBIlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 04:41:11 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:60309 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbhFBIlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 04:41:10 -0400
Received: from [192.168.1.155] ([95.114.42.59]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MFsAJ-1lbUtk1PzT-00HQ57; Wed, 02 Jun 2021 10:38:55 +0200
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Parav Pandit <parav@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>,
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
 <PH0PR12MB5481C1B2249615257A461EEDDC3F9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <06892e6a-02c9-6c25-84eb-6a4b2177b48d@metux.net>
Date:   Wed, 2 Jun 2021 10:38:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <PH0PR12MB5481C1B2249615257A461EEDDC3F9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:l+r3sN5SfjQDzPJscBIPShHltDwqwPcayg5WV/CYRoSgPIqQpVf
 nypmndPm+Xcga8629Rm3atqfOUY4jtIpCRBkSvl3tL9FdJLtVCs2fkgZOVCMoIk+e6poH6N
 Lr1tS/QP3jPWg8oSFFvv1qUsaZfJobcxa3TkLpasX1rJQr+iKvnAf+so6R+0G298HvJhAsJ
 ckCAZxKX77S/iFXJir6Vg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:9QK8tjMINWQ=:W2FJjeVB+RAwhnh4xrLNDf
 WvktQrxYIXErcpfmwKotIsgYXO0C22lPSrzEErm6UdeH0xpW1KHDoS9pId8CXpLUdyHpactFE
 E2pP1xG8D9bFDaulLLucajREXeayDRyct24u9v9I03HKY/nKR5lsp/zisZQodIh3F3S65iZBN
 nvjeergISyU9JJi9VQy6wcSzDh/YHWqkAyNtr9Vw/rEEHzWUA+LrJcvpT4YZULTjqvh+VfG5G
 l/5EBuVMUQZls0dtnoypFxp1Bk7Oi/cqwDZUe40JaZL3XOVTzRMX8RJeYgY1Cyhul4/uExXoo
 Gr4YeVY9lleA7Fk9cDrS4wEQkFGL3T0bgjtjKiCqx3nVG9Z7Q1hyhPJ8QKOsSYKaA5QbdAip3
 MIMqNC8bktJHQNNs6aFxc8R+KYKzSUd/3gQtsODbqIxASa9WXxQk4ezurd0pQKiZseaYL1toS
 W+CMqlYweNttLAeS7+q1iuILjK+iKpVcz5Jm/g7J9TG7I8/mDmEt3jMp/4Y4RcJiOfyCvrZN8
 EBOzJFhZ1vkMWMC5LScSrs=
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31.05.21 19:37, Parav Pandit wrote:

> It appears that this is only to make map ioctl faster apart from accounting.
> It doesn't have any ioasid handle input either.
> 
> In that case, can it be a new system call? Why does it have to be under /dev/ioasid?
> For example few years back such system call mpin() thought was proposed in [1].

I'm very reluctant to more syscall inflation. We already have lots of
syscalls that could have been easily done via devices or filesystems
(yes, some of them are just old Unix relics).

Syscalls don't play well w/ modules, containers, distributed systems,
etc, and need extra low-level code for most non-C languages (eg.
scripting languages).


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
