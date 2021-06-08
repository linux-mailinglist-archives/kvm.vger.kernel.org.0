Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8BB39F179
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 10:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhFHI5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 04:57:17 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:39141 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhFHI5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 04:57:17 -0400
Received: from [192.168.1.155] ([77.7.0.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MqJZl-1l3PJU3uj5-00nR3j; Tue, 08 Jun 2021 10:55:04 +0200
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Jason Wang <jasowang@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerd Hoffmann <kraxel@redhat.com>
References: <20210602120111.5e5bcf93.alex.williamson@redhat.com>
 <20210602180925.GH1002214@nvidia.com>
 <20210602130053.615db578.alex.williamson@redhat.com>
 <20210602195404.GI1002214@nvidia.com>
 <20210602143734.72fb4fa4.alex.williamson@redhat.com>
 <6a9426d7-ed55-e006-9c4c-6b7c78142e39@redhat.com>
 <20210603130927.GZ1002214@nvidia.com>
 <65614634-1db4-7119-1a90-64ba5c6e9042@redhat.com>
 <20210604115805.GG1002214@nvidia.com>
 <895671cc-5ef8-bc1a-734c-e9e2fdf03652@redhat.com>
 <20210607141424.GF1002214@nvidia.com>
 <1cf9651a-b8ee-11f1-1f70-db3492a76400@redhat.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <9a5b6675-e21a-cf62-6ea1-66c07e73e3ae@metux.net>
Date:   Tue, 8 Jun 2021 10:54:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <1cf9651a-b8ee-11f1-1f70-db3492a76400@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:8kyLIALPf2tB8V1k8OkKPO+t0JzfF1nw6+qQyhnu0hXMra8y0xE
 6jTMAZv9U2q49s04k9XDHsGY7Zz+zj1PbDtCUSaFUayZkcDZhg5noOdzNDTmj9H5JfgBRxU
 tVmITHaGAVxeS/NootJaf9Wo7ND6rbtDzVmKjhhZZB0rh/Od2LmuGKGmpZUJBOU76UkahDH
 qjbSLLC8JG6uwi9xeZH+A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NKHch6yJ0Zc=:rOP7klmWM3f3oIrFW9VpKr
 BBvV9RaWe6aDGtA16XwYrQ1FvLMQJgy+7wg1T/6mpmISE3kI7YbMzFteDBiF6Bh+QSEWYoAg2
 RhexYbCbDtd8B1PG7fUL8pxQhgWJUn3diCm5hVw1lAxrwI3UeyJPiFXCScCM70WacprM/ws+G
 UY35oxJu1qeyt7h5tbpNj6uHw2utJco6lAKKYKK4nMPQcedVrLp73PbZQEKhdQGsMHmWRhpAs
 ZFxgp3QPNWmGqa/0NazChPNcDsWJZ2tUuE4XMjSGHtDJfda8VdD6iQjPxZkZXA+3ouU7vRJhZ
 BM75tNyPemu2xLiD5SKq3Smg4DaLPhQZZgIhbXGld3sHVs5pGtZfXDHPjIyIBsYdK5Q1/4g/j
 szIm6tHXksp4KbolEcOf+SEjJ1dazkoNzXznRvFao7oxpSuwYV8bIJBsuTosFUdTpNck5omTL
 9B1TmZUX8SAc/S3jB4aJSDDHL72Ob833jj/WG8RWmKr2lh8A7eCyv0vwsRnKHelgu92Hu+jzR
 upIGX+uczX+fYEzNP2pysc=
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08.06.21 03:00, Jason Wang wrote:

Hi folks,

> Just to make sure we are in the same page. What I meant is, if the DMA 
> behavior like (no-snoop) is device specific. There's no need to mandate 
> a virtio general attributes. We can describe it per device. The devices 
> implemented in the current spec does not use non-coherent DMA doesn't 
> mean any future devices won't do that. The driver could choose to use 
> transport (e.g PCI), platform (ACPI) or device specific (general virtio 
> command) way to detect and flush cache when necessary.

Maybe I've totally misunderstood the whole issue, but what I've learned
to far:

* it's a performance improvement for certain scenarios
* whether it can be used depends on the devices as well as the
   underlying transport (combination of both)
* whether it should be used (when possible) can only be decided by the
   driver

Correct ?

I tend to believe that's something that virtio infrastructure should
handle in a generic way.

Maybe the device as well as the transport could announce their
capability (which IMHO should go via the virtio protocol), and if both
are capable, the (guest's) virtio subsys tells the driver whether it's
usable for a specific device. Perhaps we should also have a mechanism
to tell the device that it's actually used.


Sorry, if i'm completely on the wrong page and just talking junk here :o


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
