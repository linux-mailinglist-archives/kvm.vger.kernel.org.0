Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8487723C373
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 04:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgHEC2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 22:28:01 -0400
Received: from mga12.intel.com ([192.55.52.136]:7821 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgHEC2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 22:28:00 -0400
IronPort-SDR: 87eqX5vs6NlVYDqs1vW0UjNs31Wm3EeepiP988Jo9JLF5Jf940kR+gDoxVws9fUCOO+yyrZTew
 m0t2Zz01bQCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9703"; a="132008707"
X-IronPort-AV: E=Sophos;i="5.75,436,1589266800"; 
   d="scan'208";a="132008707"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2020 19:28:00 -0700
IronPort-SDR: LX4R3k0iffTaiqM5OpI1cWhwKqIC5VWRP8Vx+UJnFeioBfw+oO5qHl5ETPIih7AENO50oqq4AG
 OmEpqTHMj+Hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,436,1589266800"; 
   d="scan'208";a="315578039"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga004.fm.intel.com with ESMTP; 04 Aug 2020 19:27:55 -0700
Date:   Wed, 5 Aug 2020 10:16:54 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com, eskultet@redhat.com,
        jian-feng.ding@intel.com, dgilbert@redhat.com,
        zhenyuw@linux.intel.com, hejie.xu@intel.com, bao.yumeng@zte.com.cn,
        smooney@redhat.com, intel-gvt-dev@lists.freedesktop.org,
        berrange@redhat.com, dinechin@redhat.com, devel@ovirt.org
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200805021654.GB30485@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200713232957.GD5955@joy-OptiPlex-7040>
 <9bfa8700-91f5-ebb4-3977-6321f0487a63@redhat.com>
 <20200716083230.GA25316@joy-OptiPlex-7040>
 <20200717101258.65555978@x1.home>
 <20200721005113.GA10502@joy-OptiPlex-7040>
 <20200727072440.GA28676@joy-OptiPlex-7040>
 <20200727162321.7097070e@x1.home>
 <20200729080503.GB28676@joy-OptiPlex-7040>
 <20200804183503.39f56516.cohuck@redhat.com>
 <c178a0d3-269d-1620-22b1-9010f602d8ff@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c178a0d3-269d-1620-22b1-9010f602d8ff@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 05, 2020 at 10:22:15AM +0800, Jason Wang wrote:
> 
> On 2020/8/5 上午12:35, Cornelia Huck wrote:
> > [sorry about not chiming in earlier]
> > 
> > On Wed, 29 Jul 2020 16:05:03 +0800
> > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > 
> > > On Mon, Jul 27, 2020 at 04:23:21PM -0600, Alex Williamson wrote:
> > (...)
> > 
> > > > Based on the feedback we've received, the previously proposed interface
> > > > is not viable.  I think there's agreement that the user needs to be
> > > > able to parse and interpret the version information.  Using json seems
> > > > viable, but I don't know if it's the best option.  Is there any
> > > > precedent of markup strings returned via sysfs we could follow?
> > I don't think encoding complex information in a sysfs file is a viable
> > approach. Quoting Documentation/filesystems/sysfs.rst:
> > 
> > "Attributes should be ASCII text files, preferably with only one value
> > per file. It is noted that it may not be efficient to contain only one
> > value per file, so it is socially acceptable to express an array of
> > values of the same type.
> > Mixing types, expressing multiple lines of data, and doing fancy
> > formatting of data is heavily frowned upon."
> > 
> > Even though this is an older file, I think these restrictions still
> > apply.
> 
> 
> +1, that's another reason why devlink(netlink) is better.
>
hi Jason,
do you have any materials or sample code about devlink, so we can have a good
study of it?
I found some kernel docs about it but my preliminary study didn't show me the
advantage of devlink.

Thanks
Yan
