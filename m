Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9F23984B9
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 10:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbhFBI7I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 04:59:08 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:45869 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbhFBI7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 04:59:08 -0400
Received: from [192.168.1.155] ([95.114.42.59]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MGi6k-1lafIq3Oew-00DpdX; Wed, 02 Jun 2021 10:56:54 +0200
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     "Tian, Kevin" <kevin.tian@intel.com>,
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
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <bb6846bf-bd3c-3802-e0d7-226ec9b33384@metux.net>
Date:   Wed, 2 Jun 2021 10:56:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:3Mcq2cb/Ii9ywxMSUXsDQ9pb2+iZexTll119bJZkqKn6n/uAzeX
 vlBuy8gzAJoHwUTbHF/NioLbLGK4SyvZhqUm5yg9cGiQY7V3evXE44KhVXzMiMGt4/Cf+0t
 hvumRBsesWj4xZHsQkSA4vYDmw15qUKwS9PxlgOBBhlXZjg4HB0b/+dgqTxrCfE6CEVuKRJ
 5GqKWS9lwAjodld6KcrWg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:3T0vIilwMWM=:yox9K5pXkfYHqVr3zyrSGk
 pGHofGYSVKITUO56tzDTQQeMUlqiezJiY1iU1N2g8mBSjXRkRt+qit8y3/H+qDaEx6FWUD+T8
 2zxEo4s6fiqhOyQpOf/+BHispEZ03VAeISfUlEJKfkbx0+WjuNHEgeVRxX87ighdQNSgPyiqe
 PILXaXDH1s/q3xSA1qZxtRc+TXuVzZSyj1Ao92QnuDLbX4EbtQ319zNW1yhF4uuC7l+1bSrac
 IWdfwXu73ZKzhJCNW4czH/r58AyDTa/vELP2yx2cqMoHiRyhuxLlQtM+EBL3qmroRYzGoYeC9
 oemgnJQKz8baqNs8M8Co5+2EPoSuDqCqpyEAwBU8g1itzuGflXO0f+KsrSjHAnUqF5/0/x3vI
 cqqFbSmyhFiO5UfQcV1zRJpzELKcdxjFCEZYPk9TPz09cIbdBOVqURnwMRB0ODmBHJanmCKKH
 XHmd3gq/QOWATPJVNXYOtnsgmxwIYMdMShNnrfKWSNKuj4YMT0R7JH2ZVa1B/zNfJrgZqwnUo
 GLmx9XbSg7JKS6nsTmdDqY=
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.05.21 09:58, Tian, Kevin wrote:

Hi,

> /dev/ioasid provides an unified interface for managing I/O page tables for
> devices assigned to userspace. Device passthrough frameworks (VFIO, vDPA,
> etc.) are expected to use this interface instead of creating their own logic to
> isolate untrusted device DMAs initiated by userspace.

While I'm in favour of having generic APIs for generic tasks, as well as
using FDs, I wonder whether it has to be a new and separate device.

Now applications have to use multiple APIs in lockstep. One consequence
of that is operators, as well as provisioning systems, container
infrastructures, etc, always have to consider multiple devices together.

You can't just say "give workload XY access to device /dev/foo" anymore.
Now you have to take care about scenarios like "if someone wants
/dev/foo, he also needs /dev/bar"). And if that happens multiple times
together ("/dev/foo and /dev/wurst, both require /dev/bar), leading to
scenarios like the dev nodes are bind-mounted somewhere, you need to
take care that additional devices aren't bind-mounted twice, etc ...

If I understand this correctly, /dev/ioasid is a kind of "common 
supplier" to other APIs / devices. Why can't the fd be acquired by the
consumer APIs (eg. kvm, vfio, etc) ?


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
