Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B191E2FC2
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 22:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390811AbgEZUJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 16:09:22 -0400
Received: from mga03.intel.com ([134.134.136.65]:22129 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390075AbgEZUJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 16:09:22 -0400
IronPort-SDR: ixYVrwQz5we5pbKcZzBV9Fo0PvZUcrmHN9CUL4k02a+j47P0vgHYTbYs1nNWg8imK+IYROhY16
 yZRAYvJEfofQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2020 13:09:21 -0700
IronPort-SDR: sgsNAYYFGCR4KGlJv/TA+kTZFRtuojydT7U/eTiZLJz8egiwOJhfloULIDvnCHPFbaNWeVgllc
 q/DbJK7RP6pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,437,1583222400"; 
   d="scan'208";a="468432903"
Received: from aprakasa-mobl.amr.corp.intel.com (HELO [10.254.67.245]) ([10.254.67.245])
  by fmsmga005.fm.intel.com with ESMTP; 26 May 2020 13:09:19 -0700
Subject: Re: [Sound-open-firmware] [PATCH 5/6] vhost: add an rpmsg API
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Cc:     Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        sound-open-firmware@alsa-project.org,
        linux-remoteproc@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20200516101109.2624-1-guennadi.liakhovetski@linux.intel.com>
 <20200516101109.2624-6-guennadi.liakhovetski@linux.intel.com>
 <9737e3f2-e59c-0174-9254-a2d8f29f30b7@linux.intel.com>
 <20200525135336.GB6761@ubuntu>
 <59029e07-f49b-8d1a-4eb4-2f6d5775cf54@linux.intel.com>
 <20200526185522.GA6992@ubuntu>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <f93b01b9-b14c-2433-af97-5bb9ae53f788@linux.intel.com>
Date:   Tue, 26 May 2020 15:09:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200526185522.GA6992@ubuntu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



>>>>> +config VHOST_RPMSG
>>>>> +	tristate
>>>>> +	depends on VHOST
>>>>
>>>> depends on RPMSG_VIRTIO?
>>>
>>> No, RPMSG_VIRTIO is used on the guest side, VHOST_RPMSG (as well as
>>> all other vhost drivers) on the host side.
>>
>> I vaguely recalled something about sockets, and was wondering if there isn't
>> a dependency on this:
>>
>> config VHOST_VSOCK
>> 	tristate "vhost virtio-vsock driver"
>> 	depends on VSOCKETS && EVENTFD && VHOST_DPN
>> 	select VHOST
> 
> You probably are thinking about the first patch in the series "vhost: convert
> VHOST_VSOCK_SET_RUNNING to a generic ioctl." But no, this RPMsg driver
> doesn't depend on vsock, on the contrary, it takes a (albeit tiny) piece of
> functionality from vsock and makes it global.

yes, this is what I was thinking about, thanks for clarifying.
