Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41CC3A0EFD
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 10:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbhFIIyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 04:54:16 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:44127 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237793AbhFIIyQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 04:54:16 -0400
Received: from [192.168.1.155] ([77.9.120.3]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MaIGB-1lo04d0Q0D-00WDfS; Wed, 09 Jun 2021 10:51:54 +0200
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
        Jason Wang <jasowang@redhat.com>
References: <30e5c597-b31c-56de-c75e-950c91947d8f@redhat.com>
 <20210604160336.GA414156@nvidia.com>
 <2c62b5c7-582a-c710-0436-4ac5e8fd8b39@redhat.com>
 <20210604172207.GT1002214@nvidia.com>
 <2d1ad075-bec6-bfb9-ce71-ed873795e973@redhat.com>
 <20210607175926.GJ1002214@nvidia.com>
 <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
 <20210608131547.GE1002214@nvidia.com>
 <89d30977-119c-49f3-3bf6-d3f7104e07d8@redhat.com>
 <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
 <20210608190022.GM1002214@nvidia.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <ec0b1ef9-ae2f-d6c7-99b7-4699ced146e4@metux.net>
Date:   Wed, 9 Jun 2021 10:51:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210608190022.GM1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:129gpDF0BUiljAKLG/lQM9gOvQsLJNYv6mn4lsTL3Y6scaycnu6
 FPVYBAyrjnF1UY5uwjcf4oFw4beloQnySFsPKYbawZfN6tAapAsVHo2QgL4R4yFkhCoiQly
 iyPTJnWT8Mwi7XapNxHe64Lv15irUjL5dqbROpopaoobxzsl59SG2wsiJeu+82nnrgqc/7a
 JUvZonTmpEByKtCFMeFWw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:POLH6n9P4zc=:r5TZcQVPFRF4PjIFhtEtsc
 dD3FDxLNBDMLgWG/MNRgaoxxjZoeGAnDFNrL5n572RnYavwM9FfniMfqfMegke/Kgg+e/KzJa
 9LT9KniwqqSJEplpR6p60i0ubJxhUj61aitZlsxUKoHu1+cYuoLonSFnlHgOXXC3zFb7sKL/l
 5+N8urVp3aD+42CMom3DQmR/OhngLKKh+hlZaij3jykJCSIz47lO9KJuXFI+YhvVENVR+ioig
 WZT63ZCSIX6xP1GiD1irLtO7PWirac5YLkWT77v6fAqAq7TwBbrQ5aSJndaBXoRp894v5mq+A
 hxHvxDh5Ac4N20dRUBxzHcjupjmrO/qFNOsUIZXrvj6wkMw2LhuGnb9V7NHPk8ut4K8TtSMzz
 NftmcBDo+y4gl+xa7jJC9dAZA2MJKxdMtOURjbYeDGaoHWYoYYUAaW9hKpmQVqPUOVzVXdpKb
 BnL/wbMl256p27IIfNXK9nADHPcn4funqrbusWTku0lTWHysNztTXM0dDN+uqFCyfGjMB/61y
 SDR8IC7P1tGKRZkANhzhfE=
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08.06.21 21:00, Jason Gunthorpe wrote:

> Eg I can do open() on a file and I get to keep that FD. I get to keep
> that FD even if someone later does chmod() on that file so I can't
> open it again.
> 
> There are lots of examples where a one time access control check
> provides continuing access to a resource. I feel the ongoing proof is
> the rarity in Unix.. 'revoke' is an uncommon concept in Unix..

Yes, it's even possible that somebody w/ privileges opens an fd and
hands it over to somebody unprivileged (eg. via unix socket). This is
a very basic unix concept. If some (already opened) fd now suddenly
behaves differently based on the current caller, that would be a break
with traditional unix semantics.


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
