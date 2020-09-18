Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5740270434
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 20:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgIRSkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 14:40:13 -0400
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:39924 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726115AbgIRSkM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 14:40:12 -0400
X-Greylist: delayed 4354 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 14:40:10 EDT
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08IH7rcf019910;
        Fri, 18 Sep 2020 19:26:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=gcAh7g4k0iAb/wRiW3bxiJtQ4j3NcCLr4fV0vgDvS1s=;
 b=AVEiiTDWy7LFbL+icTKE/+L5C21gtlSM/TfOPhoIboY2aMw52oCUE2+xqf76daLz9LZU
 wK9xDpk//OiGzXo3ZNHUc3E+e+0blGfPAI05RcNGIIGCL5/skjSXG/JLPuYxCl41lLHW
 zDrCzwUgt5rmhTD/8tq2zp73mn/8BA4+ZXv1+PP3M9jlIbok1jDWV56Asq7sak/0MccR
 AHccq/nfXK6Gbrgo7v+I4i1B5xkKsp/h2C1R4RcWMbPqs1af9nR1XWPXIROh2C0+Fu1Q
 0TtyqvjpwlzXGXwO+K4+54cfIImVxigqDEayuVJvU/FzFCLVikXRI3KxvKpoSUnCTh4f 7A== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 33k691sasf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Sep 2020 19:26:52 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 41F7F100034;
        Fri, 18 Sep 2020 19:26:51 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag3node1.st.com [10.75.127.7])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id E9E6B2A65A1;
        Fri, 18 Sep 2020 19:26:50 +0200 (CEST)
Received: from lmecxl0889.tpe.st.com (10.75.127.51) by SFHDAG3NODE1.st.com
 (10.75.127.7) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 19:26:49 +0200
Subject: Re: [PATCH v6 0/4] Add a vhost RPMsg API
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "sound-open-firmware@alsa-project.org" 
        <sound-open-firmware@alsa-project.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
References: <20200901151153.28111-1-guennadi.liakhovetski@linux.intel.com>
 <9433695b-5757-db73-bd8a-538fd1375e2a@st.com> <20200917054705.GA11491@ubuntu>
 <47a9ad01-c922-3b1c-84de-433f229ffba3@st.com> <20200918054420.GA19246@ubuntu>
 <0b7d9004-d71b-8b9a-eaed-f92833ce113f@st.com> <20200918094719.GD19246@ubuntu>
From:   Arnaud POULIQUEN <arnaud.pouliquen@st.com>
Message-ID: <f1d98e33-a349-678a-4a4c-3598c0371fd4@st.com>
Date:   Fri, 18 Sep 2020 19:26:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200918094719.GD19246@ubuntu>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.51]
X-ClientProxiedBy: SFHDAG6NODE1.st.com (10.75.127.16) To SFHDAG3NODE1.st.com
 (10.75.127.7)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-18_15:2020-09-16,2020-09-18 signatures=0
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Guennadi,


On 9/18/20 11:47 AM, Guennadi Liakhovetski wrote:
> Hi Arnaud,
> 
> On Fri, Sep 18, 2020 at 09:47:45AM +0200, Arnaud POULIQUEN wrote:
>> Hi Guennadi,
>>
>> On 9/18/20 7:44 AM, Guennadi Liakhovetski wrote:
>>> Hi Arnaud,
>>>
>>> On Thu, Sep 17, 2020 at 05:21:02PM +0200, Arnaud POULIQUEN wrote:
>>>> Hi Guennadi,
>>>>
>>>>> -----Original Message-----
>>>>> From: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
>>>>> Sent: jeudi 17 septembre 2020 07:47
>>>>> To: Arnaud POULIQUEN <arnaud.pouliquen@st.com>
>>>>> Cc: kvm@vger.kernel.org; linux-remoteproc@vger.kernel.org;
>>>>> virtualization@lists.linux-foundation.org; sound-open-firmware@alsa-
>>>>> project.org; Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>; Liam
>>>>> Girdwood <liam.r.girdwood@linux.intel.com>; Michael S. Tsirkin
>>>>> <mst@redhat.com>; Jason Wang <jasowang@redhat.com>; Ohad Ben-Cohen
>>>>> <ohad@wizery.com>; Bjorn Andersson <bjorn.andersson@linaro.org>; Mathieu
>>>>> Poirier <mathieu.poirier@linaro.org>; Vincent Whitchurch
>>>>> <vincent.whitchurch@axis.com>
>>>>> Subject: Re: [PATCH v6 0/4] Add a vhost RPMsg API
>>>>>
>>>>> Hi Arnaud,
>>>>>
>>>>> On Tue, Sep 15, 2020 at 02:13:23PM +0200, Arnaud POULIQUEN wrote:
>>>>>> Hi  Guennadi,
>>>>>>
>>>>>> On 9/1/20 5:11 PM, Guennadi Liakhovetski wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> Next update:
>>>>>>>
>>>>>>> v6:
>>>>>>> - rename include/linux/virtio_rpmsg.h ->
>>>>>>> include/linux/rpmsg/virtio.h
>>>>>>>
>>>>>>> v5:
>>>>>>> - don't hard-code message layout
>>>>>>>
>>>>>>> v4:
>>>>>>> - add endianness conversions to comply with the VirtIO standard
>>>>>>>
>>>>>>> v3:
>>>>>>> - address several checkpatch warnings
>>>>>>> - address comments from Mathieu Poirier
>>>>>>>
>>>>>>> v2:
>>>>>>> - update patch #5 with a correct vhost_dev_init() prototype
>>>>>>> - drop patch #6 - it depends on a different patch, that is currently
>>>>>>>   an RFC
>>>>>>> - address comments from Pierre-Louis Bossart:
>>>>>>>   * remove "default n" from Kconfig
>>>>>>>
>>>>>>> Linux supports RPMsg over VirtIO for "remote processor" / AMP use
>>>>>>> cases. It can however also be used for virtualisation scenarios,
>>>>>>> e.g. when using KVM to run Linux on both the host and the guests.
>>>>>>> This patch set adds a wrapper API to facilitate writing vhost
>>>>>>> drivers for such RPMsg-based solutions. The first use case is an
>>>>>>> audio DSP virtualisation project, currently under development, ready
>>>>>>> for review and submission, available at
>>>>>>> https://github.com/thesofproject/linux/pull/1501/commits
>>>>>>
>>>>>> Mathieu pointed me your series. On my side i proposed the rpmsg_ns_msg
>>>>>> service[1] that does not match with your implementation.
>>>>>> As i come late, i hope that i did not miss something in the history...
>>>>>> Don't hesitate to point me the discussions, if it is the case.
>>>>>
>>>>> Well, as you see, this is a v6 only of this patch set, and apart from it there have
>>>>> been several side discussions and patch sets.
>>>>>
>>>>>> Regarding your patchset, it is quite confusing for me. It seems that
>>>>>> you implement your own protocol on top of vhost forked from the RPMsg
>>>>> one.
>>>>>> But look to me that it is not the RPMsg protocol.
>>>>>
>>>>> I'm implementing a counterpart to the rpmsg protocol over VirtIO as initially
>>>>> implemented by drivers/rpmsg/virtio_rpmsg_bus.c for the "main CPU" (in case
>>>>> of remoteproc over VirtIO) or the guest side in case of Linux virtualisation.
>>>>> Since my implementation can talk to that driver, I don't think, that I'm inventing
>>>>> a new protocol. I'm adding support for the same protocol for the opposite side
>>>>> of the VirtIO divide.
>>>>
>>>> The main point I would like to highlight here is related to the use of the name "RPMsg"
>>>> more than how you implement your IPC protocol.
>>>> If It is a counterpart, it probably does not respect interface for RPMsg clients.
>>>> A good way to answer this, might be to respond to this question:
>>>> Is the rpmsg sample client[4] can be used on top of your vhost RPMsg implementation?
>>>> If the response is no, describe it as a RPMsg implementation could lead to confusion...
>>>
>>> Sorry, I don't quite understand your logic. RPMsg is a communication protocol, not an 
>>> API. An RPMsg implementation has to be able to communicate with other compliant RPMsg 
>>> implementations, it doesn't have to provide any specific API. Am I missing anything?
>>
>> You are right nothing is written in stone that compliance with the user RPMsg API defined
>> in the Linux Documentation [5] is mandatory.
> 
> A quote from [5]:
> 
> <quote>
> Rpmsg is a virtio-based messaging bus that allows kernel drivers to communicate
> with remote processors available on the system.
> </quote>
> 
> So, that document describes the API used by Linux drivers to talk to remote processors. 
> It says nothing about VMs. What my patches do, they add a capability to the Linux RPMsg 
> implementation to also be used with VMs. Moreover, this is a particularly good fit, 
> because both cases can use VirtIO, so, the "VirtIO side" of the communication doesn't 
> have to change, and indeed it remains unchanged and uses the API in [5]. But what I do, 
> is I also add RPMsg support to the host side.

The feature you propose is very interesting and using RPMsg for this is clearly,
for me, a good approach.

But I'm not sure that we are speaking about the same things...
  
Perhaps, I need to clarify my view with a new approach describing RPMsg layers. 

in next part I'm focusing only on Linux local side (I'm ignoring the remote side for now).
We can divide RPMsg implementation in layers.

1) Rpmsg service layer:
  This layer implements a service on top of the RPMsg protocol.
  It uses the RPMSG user API to:
    - register/unregister a device
    - create destroy endpoints
    - send/receive messages
  This layer is independent from the ways the message is sent (virtio, vhost,...)	 
  In Linux kernel as example we can find the RPMsg sample device and rpmsg_char device 

2) The RPMsg core layer:
  This is the transport layer. It implements the RPMsg API
  It a kind of message mixer/router layer based on local and distant addresses.
  This layer is independent from the ways the message is sent ( virtio, vhost,...)	 

3) The RPMsg bus layer:
  This backend layer implements the RPMsg protocol over an IPC layer.
  This layer depends on the platform.
  Some exemples are :
    - drivers/rpmsg/mtk_rpmsg.c
    - drivers/rpmsg/qcom_glink_native.c
    - drivers/rpmsg/virtio_rpmsg_bus.c

Regarding your implementation your drivers/vhost/rpmsg.c replaces the layers 2)
and 3) and define a new "Vhost RPMsg" API, right?
As consequence the layer 1) has to by modified or duplicated to support the
"Vhost RPMsg" API.

What Vincent an I proposed (please tell me Vincent if i'm wrong) is that only the
layer 3) is implemented for portability on vhost. This as been proposed in the
"RFC patch 14/22" [6] from Kishon.

But I'm not a vhost expert, So perhaps it is not adapted...?

[6] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2219863.html 

> 
>> IMO, as this API is defined in the Linux documentation [5] we should respect it, to ensure
>> one generic implementation. The RPMsg sample client[4] uses this user API, so seems to me
>> a good candidate to verify this. 
>>
>> That's said, shall we multiple the RPMsg implementations in Linux with several APIs,
>> With the risk to make the RPMsg clients devices dependent on these implementations?
>> That could lead to complex code or duplications...
> 
> So, no, in my understanding there aren't two competing alternative APIs, you'd never have 
> to choose between them. If you're writing a driver for Linux to communicate with remote 
> processors or to run on VMs, you use the existing API. If you're writing a driver for 
> Linux to communicate with those VMs, you use the vhost API and whatever help is available 
> for RPMsg processing.

This is what I would have expect here. To have only one driver per service, not
to instantiate it for each type of type of communication.

> 
> However, I can in principle imagine a single driver, written to work on both sides. 
> Something like the rpmsg_char.c or maybe some networking driver. Is that what you're 
> referring to? I can see that as a fun exercise, but are there any real uses for that? 
> You could do the same with VirtIO, however, it has been decided to go with two 
> distinct APIs: virtio for guests and vhost for the host, noone bothered to create a 
> single API for both and nobody seems to miss one. Why would we want one with RPMsg?

Regarding the RFC [3] mentioned in a previous mail, perhaps this requirement
exists. I added Kishon in copy. 

In ST, we have such requirement but not concerning vhost.Our need is to
facilitate the services porting between an internal coprocessor (virtio) and an
external coprocessor(serial link) using RPMsg.

The Sound open firmware project could also takes benefit of an uniformization of
the communication with the audio DSP, using the RPMsg API to address in a same
way an internal coprocessor, an external coprocessor or a virtual machine for
the control part...
   
And of course to simplify the maintenance and evolution of the RPMsg protocol in
Linux.

That's said our approach seems to me also valid as it respects the RPMsg protocol.

Now there are 2 different patch series with 2 different approaches sent to
the mailing list. So i guess that maintainers will have to decide whether
they will get the both or only one.

Thanks,
Arnaud

> 
> Thanks
> Guennadi
>> [5] https://elixir.bootlin.com/linux/v5.8.10/source/Documentation/rpmsg.txt#L66
>>
>> Thanks,
>> Arnaud
>>
>>   
>>>
>>> Thanks
>>> Guennadi
>>>
>>>> [4] https://elixir.bootlin.com/linux/v5.9-rc5/source/samples/rpmsg/rpmsg_client_sample.c
>>>>
>>>> Regards,
>>>> Arnaud
>>>>
>>>>>
>>>>>> So i would be agree with Vincent[2] which proposed to switch on a
>>>>>> RPMsg API and creating a vhost rpmsg device. This is also proposed in
>>>>>> the "Enhance VHOST to enable SoC-to-SoC communication" RFC[3].
>>>>>> Do you think that this alternative could match with your need?
>>>>>
>>>>> As I replied to Vincent, I understand his proposal and the approach taken in the
>>>>> series [3], but I'm not sure I agree, that adding yet another virtual device /
>>>>> driver layer on the vhost side is a good idea. As far as I understand adding new
>>>>> completely virtual devices isn't considered to be a good practice in the kernel.
>>>>> Currently vhost is just a passive "library"
>>>>> and my vhost-rpmsg support keeps it that way. Not sure I'm in favour of
>>>>> converting vhost to a virtual device infrastructure.
>>>>>
>>>>> Thanks for pointing me out at [3], I should have a better look at it.
>>>>>
>>>>> Thanks
>>>>> Guennadi
>>>>>
>>>>>> [1].
>>>>>> https://patchwork.kernel.org/project/linux-remoteproc/list/?series=338
>>>>>> 335 [2].
>>>>>> https://www.spinics.net/lists/linux-virtualization/msg44195.html
>>>>>> [3]. https://www.spinics.net/lists/linux-remoteproc/msg06634.html
>>>>>>
>>>>>> Thanks,
>>>>>> Arnaud
>>>>>>
>>>>>>>
>>>>>>> Thanks
>>>>>>> Guennadi
