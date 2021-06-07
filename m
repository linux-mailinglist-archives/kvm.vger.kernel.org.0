Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018E139DDA9
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 15:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFGNcu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 09:32:50 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:42137 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbhFGNcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 09:32:45 -0400
Received: from [192.168.1.155] ([77.9.164.246]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MDhth-1lg6BL1jZ1-00AmyS; Mon, 07 Jun 2021 15:30:24 +0200
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Jason Gunthorpe <jgg@nvidia.com>, Jason Wang <jasowang@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)\"\"" 
        <alex.williamson@redhat.com>, David Woodhouse <dwmw2@infradead.org>
References: <20210601113152.6d09e47b@yiliu-dev>
 <164ee532-17b0-e180-81d3-12d49b82ac9f@redhat.com>
 <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
 <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
 <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
 <MWHPR11MB1886269E2B3DE471F1A9A7618C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <42a71462-1abc-0404-156c-60a7ee1ad333@redhat.com>
 <20210601173138.GM1002214@nvidia.com>
 <f69137e3-0f60-4f73-a0ff-8e57c79675d5@redhat.com>
 <20210602172154.GC1002214@nvidia.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Message-ID: <51e060a3-fc59-0a13-5955-71692b14eed8@metux.net>
Date:   Mon, 7 Jun 2021 15:30:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210602172154.GC1002214@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: tl
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:0cHgvfvkcENeZcwWOdSnMY5OBsLQc+AHnAcYsiTQDwQzV8yGses
 BzhxD4cYyw748yK6N/P0nmJV8sW+l4B3uSreGFp/ZH44u5wZ7MaIBt0puYo9H6CTlkkSCpD
 r4aJTDd5BK/w2FdPrZ18SR5dS3R3LHVHU6xk7rIJbyOMOb5GKVOegP5pyC9SfzDF6IHFOit
 UCQz3Yv97nhVDnbAb1IQA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0b78p2Fmx6c=:HhyzpkVQ7uJoDa9fEVb7F6
 xFsLe61+6cSl2oyH7zj5A4CrjvXvb7KOqKLmktH3ZbUW1fICP/UosO75+xU7E8hc5+pzc92VW
 LR/LjD80hvYUrCXbe017LZX/bfUnX4iZh/cSkhdx9zvaD9B4wT5uCKFiRN+/Wav2yCLrJvjsL
 cjOZ2hVolWapI/aaKjqSAv9n/VM644SA5c1DfW4pfDVDo9++KvqChAyaSubd+mkw1E7zGgk40
 bfww55mSUZo3QJLPzISQt8UMxjUVnI0+ag/zrptFmAUE1VzXaU21p2vQ1INWR7/mBGuTCmXRI
 zqtvzllXx6M57EsJbqrHzgQywOI2yoFgXEr8y7NLkFdoqVl3Hfq2u0DP3nzTLoHMufwoCj4jc
 vOzRhqKSiix+6zsxGDwISIp38M8erlQsz4YzoFJcWSS2FBSTbyJGUSU1C0Xi0yjMjCV2aBQH4
 e9JA8vdQoGpUfNiaEYe89HFY9isMuEvE4jzZzwHxxJcM8TOdD6nJ4VTt11FTqxA6vE11NAxW+
 FyX744HLunXQ18m0eR0ZMw=
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.06.21 19:21, Jason Gunthorpe wrote:

Hi,

> Not really, once one thing in an applicate uses a large number FDs the
> entire application is effected. If any open() can return 'very big
> number' then nothing in the process is allowed to ever use select.

isn't that a bug in select() ?

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
