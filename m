Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADD236B9D0
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 21:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237091AbhDZTM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 15:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234229AbhDZTMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 15:12:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B003C061574;
        Mon, 26 Apr 2021 12:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=pnKzdbOPzZSQYjwLj7WyZcZU9565NzRjpCFzu8GyTfw=; b=efMIkUs4aQeMT6UgS/WiHk1rrm
        +Qum2LujncESNM6fWI0GSAjQEp5UKm6AeQvgUDWTQfUboADhwgeGDfWYXU+ed0VFA0uPPg3mpLBkM
        N+BaPeGVyYvQ96rsY4wsvvR31Fxp+/UxI7HcQAyjODSidR25QGGSBCsTDm5dmge+2kMjeulUAiybm
        aWmi3sTfFHXxXJjwJ103LyXflCYgNZh8aAxmBkKnLFugg+JHQePuprcFp2Dwonv52GhzpdZPbBxRF
        RjOkgC3/5v368BDxCR1UBmkitmRsP3pAjxxLNdWZAppE14a9APyYQz6J7oKc9voE2hBqnJJZ87pkS
        KgX/kwnA==;
Received: from [2601:1c0:6280:3f0::df68]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lb6e7-005zpv-1Y; Mon, 26 Apr 2021 19:11:55 +0000
Subject: Re: [PATCH 01/12] vfio/mdev: Remove CONFIG_VFIO_MDEV_DEVICE
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, linux-s390@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
References: <1-v1-d88406ed308e+418-vfio3_jgg@nvidia.com>
 <d058f9ad-7ce1-c1b3-19cd-5f625ef4c670@infradead.org>
 <20210426182625.GY1370958@nvidia.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <79ee612e-4830-2d04-c7eb-e2a51dd7e8e7@infradead.org>
Date:   Mon, 26 Apr 2021 12:11:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210426182625.GY1370958@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/26/21 11:26 AM, Jason Gunthorpe wrote:
> On Fri, Apr 23, 2021 at 05:08:10PM -0700, Randy Dunlap wrote:
>> On 4/23/21 4:02 PM, Jason Gunthorpe wrote:
>>> @@ -171,7 +171,7 @@ config SAMPLE_VFIO_MDEV_MDPY_FB
>>>  
>>>  config SAMPLE_VFIO_MDEV_MBOCHS
>>>  	tristate "Build VFIO mdpy example mediated device sample code -- loadable modules only"
>>
>> You can drop the ending of the prompt string.
> 
> Hum, I see this whole sample kconfig file is filled with this '&& m'
> pattern, I wonder if there is a reason?
> 
> I think I will put the '&& m' back, I thought it was some kconfig
> misunderstanding as it is very strange to see a naked '&& M'.

It just limits those kconfig items to being =m or not set,
i.e., even though they are tristate, setting to =y is not
allowed.  I guess the thinking is that samples don't need to
reside in system memory for very long. However, if you want
this one to be capable of =y, like your patch, you can still
remove the end of the prompt string.

-- 
~Randy

