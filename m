Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3007280609
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 19:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733004AbgJAR53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 13:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732751AbgJAR52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 13:57:28 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E273C0613D0
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 10:57:28 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id m34so4595442pgl.9
        for <kvm@vger.kernel.org>; Thu, 01 Oct 2020 10:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=epOrrz4kKiqmzu4J7cp47FloQ3io83Jz4uKs6hd3fz0=;
        b=uGNSA88Q/UROgLtV2zok8DH57ntohCYkuXElcPqKMURtdJi2FlAfVCmxsaH07rWfI+
         rMnW9DdZzRksbRjWcumZGf/eLqu5aHtqNoMbVYk/Gi+Cqlu6c3LRsbFfbMXD73DJxULe
         PtkkkeaZdfdJ6OSNOR5GIPbaVXokC0nHdnHJscHNMrcupVQJLFqkCWwGdvoY4YvlSQJi
         YABDLPX3SnLmS5HuJnjSswKVIGQ+IwcTEuPEZw5f0F+18Sf0RMhNuF9Y+rmUCeNtjBql
         cHQBKxLLJm7f/Y+fxsqkKHryAiglhimI/jTS2GHL8qG4uys0yZyfz92o/72scXAnrhgb
         kDeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=epOrrz4kKiqmzu4J7cp47FloQ3io83Jz4uKs6hd3fz0=;
        b=BkywueshbTUPZaU4atobV1Cn4vn/fiYVyKutBFp9PE2XWSPlodWm+rJp2Kf+PoRhw8
         RsnJeXOXtf9GXSic4VYiaBiTC/2Ur3weRQYku7W8yagmRlH01YVCcLHL+F6oa8bWH7z9
         vB3BO6xkFJE6mHge3clSaR4xnXfHgQO0X83NYuG7C574dtDapqY+AKjdo9NLjCOAlfst
         Ncgn9M0jhiiKtEz5dG5zBinkQYrdjBfp0uRKtJAljzJKCM+EE8dLkFG94O2bZK/26Hmo
         sMYhqX+IPbNd+MPLE91+8Ze38/N93zqeir5Gh2sigNceQoAPsuCfpnJLrCEODo4grN0f
         poAA==
X-Gm-Message-State: AOAM530pM92t0NW3J1W/+JkDE7bbHJcVstli9S4jql0USmO12GQQXXyk
        nw+JrypCMwHIzTz4tNmsBh0X7ceIVkx9gg==
X-Google-Smtp-Source: ABdhPJzqAiSfYpf8Hk8KchDt1VsrFJ+6qJZ45BJ+NQuvKJH7ix53aH5X/0Alpm7Fiuw4X4dhQwa3mg==
X-Received: by 2002:a17:902:21:b029:d2:564a:5dc6 with SMTP id 30-20020a1709020021b02900d2564a5dc6mr8610275pla.14.1601575047982;
        Thu, 01 Oct 2020 10:57:27 -0700 (PDT)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id c201sm7317111pfb.216.2020.10.01.10.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 10:57:27 -0700 (PDT)
Date:   Thu, 1 Oct 2020 11:57:25 -0600
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     Arnaud POULIQUEN <arnaud.pouliquen@st.com>
Cc:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v6 0/4] Add a vhost RPMsg API
Message-ID: <20201001175725.GA396662@xps15>
References: <20200901151153.28111-1-guennadi.liakhovetski@linux.intel.com>
 <9433695b-5757-db73-bd8a-538fd1375e2a@st.com>
 <20200917054705.GA11491@ubuntu>
 <47a9ad01-c922-3b1c-84de-433f229ffba3@st.com>
 <20200918054420.GA19246@ubuntu>
 <0b7d9004-d71b-8b9a-eaed-f92833ce113f@st.com>
 <20200918094719.GD19246@ubuntu>
 <f1d98e33-a349-678a-4a4c-3598c0371fd4@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1d98e33-a349-678a-4a4c-3598c0371fd4@st.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

On Fri, Sep 18, 2020 at 07:26:50PM +0200, Arnaud POULIQUEN wrote:
> Hi Guennadi,
> 
> 
> On 9/18/20 11:47 AM, Guennadi Liakhovetski wrote:
> > Hi Arnaud,
> > 
> > On Fri, Sep 18, 2020 at 09:47:45AM +0200, Arnaud POULIQUEN wrote:
> >> Hi Guennadi,
> >>
> >> On 9/18/20 7:44 AM, Guennadi Liakhovetski wrote:
> >>> Hi Arnaud,
> >>>
> >>> On Thu, Sep 17, 2020 at 05:21:02PM +0200, Arnaud POULIQUEN wrote:
> >>>> Hi Guennadi,
> >>>>
> >>>>> -----Original Message-----
> >>>>> From: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
> >>>>> Sent: jeudi 17 septembre 2020 07:47
> >>>>> To: Arnaud POULIQUEN <arnaud.pouliquen@st.com>
> >>>>> Cc: kvm@vger.kernel.org; linux-remoteproc@vger.kernel.org;
> >>>>> virtualization@lists.linux-foundation.org; sound-open-firmware@alsa-
> >>>>> project.org; Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>; Liam
> >>>>> Girdwood <liam.r.girdwood@linux.intel.com>; Michael S. Tsirkin
> >>>>> <mst@redhat.com>; Jason Wang <jasowang@redhat.com>; Ohad Ben-Cohen
> >>>>> <ohad@wizery.com>; Bjorn Andersson <bjorn.andersson@linaro.org>; Mathieu
> >>>>> Poirier <mathieu.poirier@linaro.org>; Vincent Whitchurch
> >>>>> <vincent.whitchurch@axis.com>
> >>>>> Subject: Re: [PATCH v6 0/4] Add a vhost RPMsg API
> >>>>>
> >>>>> Hi Arnaud,
> >>>>>
> >>>>> On Tue, Sep 15, 2020 at 02:13:23PM +0200, Arnaud POULIQUEN wrote:
> >>>>>> Hi  Guennadi,
> >>>>>>
> >>>>>> On 9/1/20 5:11 PM, Guennadi Liakhovetski wrote:
> >>>>>>> Hi,
> >>>>>>>
> >>>>>>> Next update:
> >>>>>>>
> >>>>>>> v6:
> >>>>>>> - rename include/linux/virtio_rpmsg.h ->
> >>>>>>> include/linux/rpmsg/virtio.h
> >>>>>>>
> >>>>>>> v5:
> >>>>>>> - don't hard-code message layout
> >>>>>>>
> >>>>>>> v4:
> >>>>>>> - add endianness conversions to comply with the VirtIO standard
> >>>>>>>
> >>>>>>> v3:
> >>>>>>> - address several checkpatch warnings
> >>>>>>> - address comments from Mathieu Poirier
> >>>>>>>
> >>>>>>> v2:
> >>>>>>> - update patch #5 with a correct vhost_dev_init() prototype
> >>>>>>> - drop patch #6 - it depends on a different patch, that is currently
> >>>>>>>   an RFC
> >>>>>>> - address comments from Pierre-Louis Bossart:
> >>>>>>>   * remove "default n" from Kconfig
> >>>>>>>
> >>>>>>> Linux supports RPMsg over VirtIO for "remote processor" / AMP use
> >>>>>>> cases. It can however also be used for virtualisation scenarios,
> >>>>>>> e.g. when using KVM to run Linux on both the host and the guests.
> >>>>>>> This patch set adds a wrapper API to facilitate writing vhost
> >>>>>>> drivers for such RPMsg-based solutions. The first use case is an
> >>>>>>> audio DSP virtualisation project, currently under development, ready
> >>>>>>> for review and submission, available at
> >>>>>>> https://github.com/thesofproject/linux/pull/1501/commits
> >>>>>>
> >>>>>> Mathieu pointed me your series. On my side i proposed the rpmsg_ns_msg
> >>>>>> service[1] that does not match with your implementation.
> >>>>>> As i come late, i hope that i did not miss something in the history...
> >>>>>> Don't hesitate to point me the discussions, if it is the case.
> >>>>>
> >>>>> Well, as you see, this is a v6 only of this patch set, and apart from it there have
> >>>>> been several side discussions and patch sets.
> >>>>>
> >>>>>> Regarding your patchset, it is quite confusing for me. It seems that
> >>>>>> you implement your own protocol on top of vhost forked from the RPMsg
> >>>>> one.
> >>>>>> But look to me that it is not the RPMsg protocol.
> >>>>>
> >>>>> I'm implementing a counterpart to the rpmsg protocol over VirtIO as initially
> >>>>> implemented by drivers/rpmsg/virtio_rpmsg_bus.c for the "main CPU" (in case
> >>>>> of remoteproc over VirtIO) or the guest side in case of Linux virtualisation.
> >>>>> Since my implementation can talk to that driver, I don't think, that I'm inventing
> >>>>> a new protocol. I'm adding support for the same protocol for the opposite side
> >>>>> of the VirtIO divide.
> >>>>
> >>>> The main point I would like to highlight here is related to the use of the name "RPMsg"
> >>>> more than how you implement your IPC protocol.
> >>>> If It is a counterpart, it probably does not respect interface for RPMsg clients.
> >>>> A good way to answer this, might be to respond to this question:
> >>>> Is the rpmsg sample client[4] can be used on top of your vhost RPMsg implementation?
> >>>> If the response is no, describe it as a RPMsg implementation could lead to confusion...
> >>>
> >>> Sorry, I don't quite understand your logic. RPMsg is a communication protocol, not an 
> >>> API. An RPMsg implementation has to be able to communicate with other compliant RPMsg 
> >>> implementations, it doesn't have to provide any specific API. Am I missing anything?
> >>
> >> You are right nothing is written in stone that compliance with the user RPMsg API defined
> >> in the Linux Documentation [5] is mandatory.
> > 
> > A quote from [5]:
> > 
> > <quote>
> > Rpmsg is a virtio-based messaging bus that allows kernel drivers to communicate
> > with remote processors available on the system.
> > </quote>
> > 
> > So, that document describes the API used by Linux drivers to talk to remote processors. 
> > It says nothing about VMs. What my patches do, they add a capability to the Linux RPMsg 
> > implementation to also be used with VMs. Moreover, this is a particularly good fit, 
> > because both cases can use VirtIO, so, the "VirtIO side" of the communication doesn't 
> > have to change, and indeed it remains unchanged and uses the API in [5]. But what I do, 
> > is I also add RPMsg support to the host side.
> 
> The feature you propose is very interesting and using RPMsg for this is clearly,
> for me, a good approach.
> 
> But I'm not sure that we are speaking about the same things...
>   
> Perhaps, I need to clarify my view with a new approach describing RPMsg layers. 
> 
> in next part I'm focusing only on Linux local side (I'm ignoring the remote side for now).
> We can divide RPMsg implementation in layers.
> 
> 1) Rpmsg service layer:
>   This layer implements a service on top of the RPMsg protocol.
>   It uses the RPMSG user API to:
>     - register/unregister a device
>     - create destroy endpoints
>     - send/receive messages
>   This layer is independent from the ways the message is sent (virtio, vhost,...)	 
>   In Linux kernel as example we can find the RPMsg sample device and rpmsg_char device 
> 
> 2) The RPMsg core layer:
>   This is the transport layer. It implements the RPMsg API
>   It a kind of message mixer/router layer based on local and distant addresses.
>   This layer is independent from the ways the message is sent ( virtio, vhost,...)	 
> 
> 3) The RPMsg bus layer:
>   This backend layer implements the RPMsg protocol over an IPC layer.
>   This layer depends on the platform.
>   Some exemples are :
>     - drivers/rpmsg/mtk_rpmsg.c
>     - drivers/rpmsg/qcom_glink_native.c
>     - drivers/rpmsg/virtio_rpmsg_bus.c
> 
> Regarding your implementation your drivers/vhost/rpmsg.c replaces the layers 2)
> and 3) and define a new "Vhost RPMsg" API, right?
> As consequence the layer 1) has to by modified or duplicated to support the
> "Vhost RPMsg" API.
> 
> What Vincent an I proposed (please tell me Vincent if i'm wrong) is that only the
> layer 3) is implemented for portability on vhost. This as been proposed in the
> "RFC patch 14/22" [6] from Kishon.
> 
> But I'm not a vhost expert, So perhaps it is not adapted...?
> 
> [6] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2219863.html 
> 
> > 
> >> IMO, as this API is defined in the Linux documentation [5] we should respect it, to ensure
> >> one generic implementation. The RPMsg sample client[4] uses this user API, so seems to me
> >> a good candidate to verify this. 
> >>
> >> That's said, shall we multiple the RPMsg implementations in Linux with several APIs,
> >> With the risk to make the RPMsg clients devices dependent on these implementations?
> >> That could lead to complex code or duplications...
> > 
> > So, no, in my understanding there aren't two competing alternative APIs, you'd never have 
> > to choose between them. If you're writing a driver for Linux to communicate with remote 
> > processors or to run on VMs, you use the existing API. If you're writing a driver for 
> > Linux to communicate with those VMs, you use the vhost API and whatever help is available 
> > for RPMsg processing.
> 
> This is what I would have expect here. To have only one driver per service, not
> to instantiate it for each type of type of communication.
> 
> > 
> > However, I can in principle imagine a single driver, written to work on both sides. 
> > Something like the rpmsg_char.c or maybe some networking driver. Is that what you're 
> > referring to? I can see that as a fun exercise, but are there any real uses for that? 
> > You could do the same with VirtIO, however, it has been decided to go with two 
> > distinct APIs: virtio for guests and vhost for the host, noone bothered to create a 
> > single API for both and nobody seems to miss one. Why would we want one with RPMsg?
> 
> Regarding the RFC [3] mentioned in a previous mail, perhaps this requirement
> exists. I added Kishon in copy. 
> 
> In ST, we have such requirement but not concerning vhost.Our need is to
> facilitate the services porting between an internal coprocessor (virtio) and an
> external coprocessor(serial link) using RPMsg.
> 
> The Sound open firmware project could also takes benefit of an uniformization of
> the communication with the audio DSP, using the RPMsg API to address in a same
> way an internal coprocessor, an external coprocessor or a virtual machine for
> the control part...
>    
> And of course to simplify the maintenance and evolution of the RPMsg protocol in
> Linux.
> 
> That's said our approach seems to me also valid as it respects the RPMsg protocol.
> 
> Now there are 2 different patch series with 2 different approaches sent to
> the mailing list. So i guess that maintainers will have to decide whether
> they will get the both or only one.
> 

I finally had the time to look at Kishon's pathset yesterday.  If we skim out
the parts that deal with the realities of the NTB his solution is quite
simple.  It also provides an implementation for both side of the channel, that
is host and guest.  Lastly current implementation such as rpmsg-char and
rpmsg-sample-client.c can run on it seamlessly.  

Based on the above and the use case described by Vincent I think following
Kishon's approach is the best way to move forward. 

> Thanks,
> Arnaud
> 
> > 
> > Thanks
> > Guennadi
> >> [5] https://elixir.bootlin.com/linux/v5.8.10/source/Documentation/rpmsg.txt#L66
> >>
> >> Thanks,
> >> Arnaud
> >>
> >>   
> >>>
> >>> Thanks
> >>> Guennadi
> >>>
> >>>> [4] https://elixir.bootlin.com/linux/v5.9-rc5/source/samples/rpmsg/rpmsg_client_sample.c
> >>>>
> >>>> Regards,
> >>>> Arnaud
> >>>>
> >>>>>
> >>>>>> So i would be agree with Vincent[2] which proposed to switch on a
> >>>>>> RPMsg API and creating a vhost rpmsg device. This is also proposed in
> >>>>>> the "Enhance VHOST to enable SoC-to-SoC communication" RFC[3].
> >>>>>> Do you think that this alternative could match with your need?
> >>>>>
> >>>>> As I replied to Vincent, I understand his proposal and the approach taken in the
> >>>>> series [3], but I'm not sure I agree, that adding yet another virtual device /
> >>>>> driver layer on the vhost side is a good idea. As far as I understand adding new
> >>>>> completely virtual devices isn't considered to be a good practice in the kernel.
> >>>>> Currently vhost is just a passive "library"
> >>>>> and my vhost-rpmsg support keeps it that way. Not sure I'm in favour of
> >>>>> converting vhost to a virtual device infrastructure.
> >>>>>
> >>>>> Thanks for pointing me out at [3], I should have a better look at it.
> >>>>>
> >>>>> Thanks
> >>>>> Guennadi
> >>>>>
> >>>>>> [1].
> >>>>>> https://patchwork.kernel.org/project/linux-remoteproc/list/?series=338
> >>>>>> 335 [2].
> >>>>>> https://www.spinics.net/lists/linux-virtualization/msg44195.html
> >>>>>> [3]. https://www.spinics.net/lists/linux-remoteproc/msg06634.html
> >>>>>>
> >>>>>> Thanks,
> >>>>>> Arnaud
> >>>>>>
> >>>>>>>
> >>>>>>> Thanks
> >>>>>>> Guennadi
