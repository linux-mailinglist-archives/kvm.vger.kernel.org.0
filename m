Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC11C26A4CF
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 14:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgIOMOi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 08:14:38 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:45184 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726524AbgIOMOU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 08:14:20 -0400
Received: from pps.filterd (m0046661.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FC2LFb006517;
        Tue, 15 Sep 2020 14:13:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=STMicroelectronics;
 bh=kKdS2tlwzV059/Lhs1Caty/4XEr8KG1zy796n1j1L0M=;
 b=XnqI1FkUTTwhp/zh3usFXCinlAiIWxdSjX9yCybtvtwfqeyyLMVZRPFD8ymhKDUIgjSV
 rD32tvqiHqirqlR7qO41Y0BFcm9soNh6IAPqQSmp9YOrDQ+bHijSenPyqRWmE5TOedyl
 w88sj11s2gU7jV+JIOpNzMcDKtCvsoDtMjsenD5T/JrrooLdcRC+Qibj3WLFd7bf+6eU
 6UOOVoYqMBuvaZaUMTLQojJ1rn7J8Kx+pNckymfekfHu/xW57aWI9zB0VcswhcGzMZwa
 NTp8s2wYW+9fgYJJmLM2bfN0yes3aGkydiZ1gK/LBNH405ibdc4QavstMAdYTUKt+BJK kA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 33gn7gyh1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 14:13:33 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id EFA8C100039;
        Tue, 15 Sep 2020 14:13:26 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag3node1.st.com [10.75.127.7])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id DF8D42B0EA9;
        Tue, 15 Sep 2020 14:13:25 +0200 (CEST)
Received: from lmecxl0889.tpe.st.com (10.75.127.49) by SFHDAG3NODE1.st.com
 (10.75.127.7) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 14:13:24 +0200
Subject: Re: [PATCH v6 0/4] Add a vhost RPMsg API
To:     Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
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
        Vincent Whitchurch <vincent.whitchurch@axis.com>
References: <20200901151153.28111-1-guennadi.liakhovetski@linux.intel.com>
From:   Arnaud POULIQUEN <arnaud.pouliquen@st.com>
Message-ID: <9433695b-5757-db73-bd8a-538fd1375e2a@st.com>
Date:   Tue, 15 Sep 2020 14:13:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200901151153.28111-1-guennadi.liakhovetski@linux.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.75.127.49]
X-ClientProxiedBy: SFHDAG8NODE3.st.com (10.75.127.24) To SFHDAG3NODE1.st.com
 (10.75.127.7)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_08:2020-09-15,2020-09-15 signatures=0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi  Guennadi,

On 9/1/20 5:11 PM, Guennadi Liakhovetski wrote:
> Hi,
> 
> Next update:
> 
> v6:
> - rename include/linux/virtio_rpmsg.h -> include/linux/rpmsg/virtio.h
> 
> v5:
> - don't hard-code message layout
> 
> v4:
> - add endianness conversions to comply with the VirtIO standard
> 
> v3:
> - address several checkpatch warnings
> - address comments from Mathieu Poirier
> 
> v2:
> - update patch #5 with a correct vhost_dev_init() prototype
> - drop patch #6 - it depends on a different patch, that is currently
>   an RFC
> - address comments from Pierre-Louis Bossart:
>   * remove "default n" from Kconfig
> 
> Linux supports RPMsg over VirtIO for "remote processor" / AMP use
> cases. It can however also be used for virtualisation scenarios,
> e.g. when using KVM to run Linux on both the host and the guests.
> This patch set adds a wrapper API to facilitate writing vhost
> drivers for such RPMsg-based solutions. The first use case is an
> audio DSP virtualisation project, currently under development, ready
> for review and submission, available at
> https://github.com/thesofproject/linux/pull/1501/commits

Mathieu pointed me your series. On my side i proposed the rpmsg_ns_msg
service[1] that does not match with your implementation.
As i come late, i hope that i did not miss something in the history...
Don't hesitate to point me the discussions, if it is the case.

Regarding your patchset, it is quite confusing for me. It seems that you
implement your own protocol on top of vhost forked from the RPMsg one.
But look to me that it is not the RPMsg protocol.

So i would be agree with Vincent[2] which proposed to switch on a RPMsg API
and creating a vhost rpmsg device. This is also proposed in the 
"Enhance VHOST to enable SoC-to-SoC communication" RFC[3].
Do you think that this alternative could match with your need?

[1]. https://patchwork.kernel.org/project/linux-remoteproc/list/?series=338335 
[2]. https://www.spinics.net/lists/linux-virtualization/msg44195.html
[3]. https://www.spinics.net/lists/linux-remoteproc/msg06634.html  

Thanks,
Arnaud

> 
> Thanks
> Guennadi
> 
> Guennadi Liakhovetski (4):
>   vhost: convert VHOST_VSOCK_SET_RUNNING to a generic ioctl
>   rpmsg: move common structures and defines to headers
>   rpmsg: update documentation
>   vhost: add an RPMsg API
> 
>  Documentation/rpmsg.txt          |   6 +-
>  drivers/rpmsg/virtio_rpmsg_bus.c |  78 +------
>  drivers/vhost/Kconfig            |   7 +
>  drivers/vhost/Makefile           |   3 +
>  drivers/vhost/rpmsg.c            | 373 +++++++++++++++++++++++++++++++
>  drivers/vhost/vhost_rpmsg.h      |  74 ++++++
>  include/linux/rpmsg/virtio.h     |  83 +++++++
>  include/uapi/linux/rpmsg.h       |   3 +
>  include/uapi/linux/vhost.h       |   4 +-
>  9 files changed, 551 insertions(+), 80 deletions(-)
>  create mode 100644 drivers/vhost/rpmsg.c
>  create mode 100644 drivers/vhost/vhost_rpmsg.h
>  create mode 100644 include/linux/rpmsg/virtio.h
> 
