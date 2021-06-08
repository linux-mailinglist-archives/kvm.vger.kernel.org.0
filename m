Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C48D39F3F5
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 12:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbhFHKrf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 06:47:35 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:49953 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhFHKre (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 06:47:34 -0400
Received: from [192.168.1.155] ([77.7.0.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MLA6m-1m7Xt120cU-00IBqQ; Tue, 08 Jun 2021 12:45:17 +0200
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)\"\"" 
        <alex.williamson@redhat.com>, David Woodhouse <dwmw2@infradead.org>
References: <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
 <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
 <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
 <MWHPR11MB1886269E2B3DE471F1A9A7618C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <42a71462-1abc-0404-156c-60a7ee1ad333@redhat.com>
 <20210601173138.GM1002214@nvidia.com>
 <f69137e3-0f60-4f73-a0ff-8e57c79675d5@redhat.com>
 <20210602172154.GC1002214@nvidia.com>
 <51e060a3-fc59-0a13-5955-71692b14eed8@metux.net>
 <20210607180144.GL1002214@nvidia.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <633b00c1-b388-856a-db71-8d74e52c2702@metux.net>
Date:   Tue, 8 Jun 2021 12:45:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210607180144.GL1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:rKi//4YjvppFqCI3qhiJgU+YGO1eL25Ke0yqyFYXtckbUqQ7e6S
 kKA+xhIO32fHiJKkew3aWBnuNdpx3nAxl3dHU6jeEPDxDNyp5z4ltzkpYR3Bn4LfD8iPBcv
 AO4CpuQLNBTnWt6wcmFrDC06a/FL8VrvsN2vRd+z7sEJJDE8nOOfUW2DkOkUSWZQNvR0gis
 h/Z0w+/XmgIVqxtNGERpQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kCNTYpwYx3k=:ENX9awRdoPAHTHmdvxP6P+
 Oh87cb2CvqF4uZDTt3bVd0BmB3TFHrWDIy9n1yRJqAyXK2+DqPDUdyVvIqVtChm12LQmy8fGq
 LTLm1GEr04ow3kFK51D0laatAd8Mm072ox0KP3s5fFXu3YtX47dlLytTowDQzC84SKQ1R579G
 0vAnVJ+gika9WbUw5sLYcoogN5ElVj2omYck776rzHY3ukplxOS0lGsJcjV/zZnXkQuGbSnJD
 D5cNTGM3NHnQfdVmJ6L3Envzaj0B2IClCrsjYK8LBFm0Dq3DkGdaheb2s7hBLd792Y8VTrs8G
 imkh8fp3ktHtWDTzwFmZ8YUl0tLV4J1Ws+N3ZArU8UgStAiI+XVj+tbc1jqqL30o1Xs8j2HS3
 9JYi7jMypIaj2LQB6I7eCEfDXykmklUVhm2ag7rGDIDrBdhsSP3jxSxc9JbRaxfBJZjeg0lDN
 gqV+jAA0cSbdUK92o0JCymu94oh1or1dDo9X6pvZwxIFeJ4rOCVczv7AEndWBMxIcwUrA/mbt
 UtnNjulrQlLmda/M7OxnzA=
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07.06.21 20:01, Jason Gunthorpe wrote:
> <shrug> it is what it is, select has a fixed size bitmap of FD #s and
> a hard upper bound on that size as part of the glibc ABI - can't be
> fixed.

in glibc ABI ? Uuuuh!


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
