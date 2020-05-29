Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33D41E7631
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 08:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgE2Guz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 02:50:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:33424 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgE2Guz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 02:50:55 -0400
IronPort-SDR: pstLqwauhCETH+nbJgkKoGEXKQbeHVb/HXRYnOP+VWCHPq/G3SeJBQnsspvamkvcO6cIVO6mpE
 renkntgHuzSA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 23:50:54 -0700
IronPort-SDR: yua8XKtu+s8uTXp6lxQszfsrwln7XYIAU7mnjksTlB7iQQz8bVoYTbAJP7sqGlvdvjYac1kehL
 8t7+7He4uWGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="285434838"
Received: from gliakhov-mobl2.ger.corp.intel.com (HELO ubuntu) ([10.252.45.157])
  by orsmga002.jf.intel.com with ESMTP; 28 May 2020 23:50:51 -0700
Date:   Fri, 29 May 2020 08:50:51 +0200
From:   Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        sound-open-firmware@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: Re: [PATCH v3 0/5] Add a vhost RPMsg API
Message-ID: <20200529065050.GA6002@ubuntu>
References: <20200527180541.5570-1-guennadi.liakhovetski@linux.intel.com>
 <044a3b81-e0fd-5d96-80ff-b13e587f9d39@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <044a3b81-e0fd-5d96-80ff-b13e587f9d39@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On Fri, May 29, 2020 at 02:01:53PM +0800, Jason Wang wrote:
> 
> On 2020/5/28 上午2:05, Guennadi Liakhovetski wrote:
> > v3:
> > - address several checkpatch warnings
> > - address comments from Mathieu Poirier
> > 
> > v2:
> > - update patch #5 with a correct vhost_dev_init() prototype
> > - drop patch #6 - it depends on a different patch, that is currently
> >    an RFC
> > - address comments from Pierre-Louis Bossart:
> >    * remove "default n" from Kconfig
> > 
> > Linux supports RPMsg over VirtIO for "remote processor" /AMP use
> > cases. It can however also be used for virtualisation scenarios,
> > e.g. when using KVM to run Linux on both the host and the guests.
> > This patch set adds a wrapper API to facilitate writing vhost
> > drivers for such RPMsg-based solutions. The first use case is an
> > audio DSP virtualisation project, currently under development, ready
> > for review and submission, available at
> > https://github.com/thesofproject/linux/pull/1501/commits
> > A further patch for the ADSP vhost RPMsg driver will be sent
> > separately for review only since it cannot be merged without audio
> > patches being upstreamed first.
> 
> 
> Hi:
> 
> It would be hard to evaluate this series without a real user. So if
> possible, I suggest to post the actual user for vhost rpmsg API.

Sure, the whole series is available at 
https://github.com/thesofproject/linux/pull/1501/commits or would you 
prefer the missing patches posted to the lists too?

Thanks
Guennadi
