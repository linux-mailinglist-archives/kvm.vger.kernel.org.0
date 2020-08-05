Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE3723C75D
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 10:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgHEIFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 04:05:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33522 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728064AbgHEID0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 04:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596614601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5CCEkWMFbF7tYjFwcBIEHhXPvQ+zBKlX6/BkIraOSPo=;
        b=X3rCQSVJbdXmZIs7AH0E4s+AQiAwNI+lSGQ8SXmV7e94TDxRNNdD3D7BmJF6tpXtjzHKQP
        2TnijfMShRfWSmA6MKtPT3XRdxwS32KXa/+VRrhZTWGMr3Z0MCqGUN4PYV+GCtdj0bojqZ
        uLWEW7IAki2YBmpT5oEa4Hs2RPglJqc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-KK6wDpefN0ixs5uGatIvSg-1; Wed, 05 Aug 2020 04:03:17 -0400
X-MC-Unique: KK6wDpefN0ixs5uGatIvSg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D30B79EC6;
        Wed,  5 Aug 2020 08:03:15 +0000 (UTC)
Received: from [10.72.12.225] (ovpn-12-225.pek2.redhat.com [10.72.12.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D519760C47;
        Wed,  5 Aug 2020 08:02:50 +0000 (UTC)
Subject: Re: device compatibility interface for live migration with assigned
 devices
To:     Jiri Pirko <jiri@mellanox.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com, eskultet@redhat.com,
        jian-feng.ding@intel.com, dgilbert@redhat.com,
        zhenyuw@linux.intel.com, hejie.xu@intel.com, bao.yumeng@zte.com.cn,
        smooney@redhat.com, intel-gvt-dev@lists.freedesktop.org,
        berrange@redhat.com, dinechin@redhat.com, devel@ovirt.org,
        Parav Pandit <parav@mellanox.com>
References: <20200716083230.GA25316@joy-OptiPlex-7040>
 <20200717101258.65555978@x1.home> <20200721005113.GA10502@joy-OptiPlex-7040>
 <20200727072440.GA28676@joy-OptiPlex-7040> <20200727162321.7097070e@x1.home>
 <20200729080503.GB28676@joy-OptiPlex-7040>
 <20200804183503.39f56516.cohuck@redhat.com>
 <c178a0d3-269d-1620-22b1-9010f602d8ff@redhat.com>
 <20200805021654.GB30485@joy-OptiPlex-7040>
 <2624b12f-3788-7e2b-2cb7-93534960bcb7@redhat.com>
 <20200805075647.GB2177@nanopsycho>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
Date:   Wed, 5 Aug 2020 16:02:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200805075647.GB2177@nanopsycho>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/8/5 下午3:56, Jiri Pirko wrote:
> Wed, Aug 05, 2020 at 04:41:54AM CEST, jasowang@redhat.com wrote:
>> On 2020/8/5 上午10:16, Yan Zhao wrote:
>>> On Wed, Aug 05, 2020 at 10:22:15AM +0800, Jason Wang wrote:
>>>> On 2020/8/5 上午12:35, Cornelia Huck wrote:
>>>>> [sorry about not chiming in earlier]
>>>>>
>>>>> On Wed, 29 Jul 2020 16:05:03 +0800
>>>>> Yan Zhao <yan.y.zhao@intel.com> wrote:
>>>>>
>>>>>> On Mon, Jul 27, 2020 at 04:23:21PM -0600, Alex Williamson wrote:
>>>>> (...)
>>>>>
>>>>>>> Based on the feedback we've received, the previously proposed interface
>>>>>>> is not viable.  I think there's agreement that the user needs to be
>>>>>>> able to parse and interpret the version information.  Using json seems
>>>>>>> viable, but I don't know if it's the best option.  Is there any
>>>>>>> precedent of markup strings returned via sysfs we could follow?
>>>>> I don't think encoding complex information in a sysfs file is a viable
>>>>> approach. Quoting Documentation/filesystems/sysfs.rst:
>>>>>
>>>>> "Attributes should be ASCII text files, preferably with only one value
>>>>> per file. It is noted that it may not be efficient to contain only one
>>>>> value per file, so it is socially acceptable to express an array of
>>>>> values of the same type.
>>>>> Mixing types, expressing multiple lines of data, and doing fancy
>>>>> formatting of data is heavily frowned upon."
>>>>>
>>>>> Even though this is an older file, I think these restrictions still
>>>>> apply.
>>>> +1, that's another reason why devlink(netlink) is better.
>>>>
>>> hi Jason,
>>> do you have any materials or sample code about devlink, so we can have a good
>>> study of it?
>>> I found some kernel docs about it but my preliminary study didn't show me the
>>> advantage of devlink.
>>
>> CC Jiri and Parav for a better answer for this.
>>
>> My understanding is that the following advantages are obvious (as I replied
>> in another thread):
>>
>> - existing users (NIC, crypto, SCSI, ib), mature and stable
>> - much better error reporting (ext_ack other than string or errno)
>> - namespace aware
>> - do not couple with kobject
> Jason, what is your use case?


I think the use case is to report device compatibility for live 
migration. Yan proposed a simple sysfs based migration version first, 
but it looks not sufficient and something based on JSON is discussed.

Yan, can you help to summarize the discussion so far for Jiri as a 
reference?

Thanks


>
>
>
>> Thanks
>>
>>
>>> Thanks
>>> Yan
>>>

