Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFA31E7658
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 09:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbgE2HHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 03:07:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24500 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725308AbgE2HHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 03:07:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590736034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pivs+3xvqdIzBjxHwsCy4HZnB3ZGTtO9uNfpkTxvtC8=;
        b=HGAlajvQ1cSdagzxPjaXS7AF9C/5ZCl4z7M8s1Szu866buLh30Dmb8eDUEieL+BTfXoxgA
        frL5zLV+lFd9msLx3xi8gVRXYHlkqEFC8KzJxVl2NWAGfcOqr73vm4UpbYyC0tG8is1Eyp
        15OwcxV5ghzjoHfsUtBVjKthiuygkTA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-TiDOx8SSMxmL--eQ7_cUyA-1; Fri, 29 May 2020 03:07:10 -0400
X-MC-Unique: TiDOx8SSMxmL--eQ7_cUyA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACA768015D1;
        Fri, 29 May 2020 07:07:08 +0000 (UTC)
Received: from [10.72.13.231] (ovpn-13-231.pek2.redhat.com [10.72.13.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98A7A579A5;
        Fri, 29 May 2020 07:07:01 +0000 (UTC)
Subject: Re: [PATCH v3 0/5] Add a vhost RPMsg API
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
 <044a3b81-e0fd-5d96-80ff-b13e587f9d39@redhat.com>
 <20200529065050.GA6002@ubuntu>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <327003ea-2bea-0c13-74cd-fa8bce7386f4@redhat.com>
Date:   Fri, 29 May 2020 15:06:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200529065050.GA6002@ubuntu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/5/29 下午2:50, Guennadi Liakhovetski wrote:
> Hi Jason,
>
> On Fri, May 29, 2020 at 02:01:53PM +0800, Jason Wang wrote:
>> On 2020/5/28 上午2:05, Guennadi Liakhovetski wrote:
>>> v3:
>>> - address several checkpatch warnings
>>> - address comments from Mathieu Poirier
>>>
>>> v2:
>>> - update patch #5 with a correct vhost_dev_init() prototype
>>> - drop patch #6 - it depends on a different patch, that is currently
>>>     an RFC
>>> - address comments from Pierre-Louis Bossart:
>>>     * remove "default n" from Kconfig
>>>
>>> Linux supports RPMsg over VirtIO for "remote processor" /AMP use
>>> cases. It can however also be used for virtualisation scenarios,
>>> e.g. when using KVM to run Linux on both the host and the guests.
>>> This patch set adds a wrapper API to facilitate writing vhost
>>> drivers for such RPMsg-based solutions. The first use case is an
>>> audio DSP virtualisation project, currently under development, ready
>>> for review and submission, available at
>>> https://github.com/thesofproject/linux/pull/1501/commits
>>> A further patch for the ADSP vhost RPMsg driver will be sent
>>> separately for review only since it cannot be merged without audio
>>> patches being upstreamed first.
>>
>> Hi:
>>
>> It would be hard to evaluate this series without a real user. So if
>> possible, I suggest to post the actual user for vhost rpmsg API.
> Sure, the whole series is available at
> https://github.com/thesofproject/linux/pull/1501/commits or would you
> prefer the missing patches posted to the lists too?


Yes, since I see new virtio and vhost drivers there.

Thanks


>
> Thanks
> Guennadi
>

