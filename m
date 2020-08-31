Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EBE2571DB
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 04:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgHaC3J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Aug 2020 22:29:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:10698 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbgHaC3I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Aug 2020 22:29:08 -0400
IronPort-SDR: Dbx3VU381Xa/aXxoVCgl88rZ6e72FhZPLkGEztSfNJfTc347QDwan0j5RtQoS8OoQLFgXk1dpK
 yk1vPSt+7S6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9729"; a="174949925"
X-IronPort-AV: E=Sophos;i="5.76,374,1592895600"; 
   d="scan'208";a="174949925"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2020 19:29:08 -0700
IronPort-SDR: ig9Ov0e8B3bxE6l4ZMN9kDsqPqnIUQfDWZOo78hcn2EvtXM78vLfiJCEIXeA19KEqWefq21b3T
 Af+2Zw1v2Nog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,374,1592895600"; 
   d="scan'208";a="330557019"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga008.jf.intel.com with ESMTP; 30 Aug 2020 19:29:02 -0700
Date:   Mon, 31 Aug 2020 10:23:38 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, libvir-list@redhat.com,
        Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com,
        Parav Pandit <parav@mellanox.com>, jian-feng.ding@intel.com,
        dgilbert@redhat.com, zhenyuw@linux.intel.com, hejie.xu@intel.com,
        bao.yumeng@zte.com.cn,
        Alex Williamson <alex.williamson@redhat.com>,
        smooney@redhat.com, intel-gvt-dev@lists.freedesktop.org,
        Daniel =?iso-8859-1?Q?P=2EBerrang=E9?= <berrange@redhat.com>,
        eskultet@redhat.com, Jiri Pirko <jiri@mellanox.com>,
        dinechin@redhat.com, devel@ovirt.org
Subject: Re: device compatibility interface for live migration with assigned
 devices
Message-ID: <20200831022338.GA13784@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200818085527.GB20215@redhat.com>
 <3a073222-dcfe-c02d-198b-29f6a507b2e1@redhat.com>
 <20200818091628.GC20215@redhat.com>
 <20200818113652.5d81a392.cohuck@redhat.com>
 <20200820003922.GE21172@joy-OptiPlex-7040>
 <20200819212234.223667b3@x1.home>
 <20200820031621.GA24997@joy-OptiPlex-7040>
 <20200825163925.1c19b0f0.cohuck@redhat.com>
 <20200826064117.GA22243@joy-OptiPlex-7040>
 <20200828154741.30cfc1a3.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200828154741.30cfc1a3.cohuck@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 28, 2020 at 03:47:41PM +0200, Cornelia Huck wrote:
> On Wed, 26 Aug 2020 14:41:17 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > previously, we want to regard the two mdevs created with dsa-1dwq x 30 and
> > dsa-2dwq x 15 as compatible, because the two mdevs consist equal resources.
> > 
> > But, as it's a burden to upper layer, we agree that if this condition
> > happens, we still treat the two as incompatible.
> > 
> > To fix it, either the driver should expose dsa-1dwq only, or the target
> > dsa-2dwq needs to be destroyed and reallocated via dsa-1dwq x 30.
> 
> AFAIU, these are mdev types, aren't they? So, basically, any management
> software needs to take care to use the matching mdev type on the target
> system for device creation?
dsa-1dwq is the mdev type.
there's no dsa-2dwq yet. and I think no dsa-2dwq should be provided in
future according to our discussion.

GVT currently does not support aggregator also.
how to add the the aggregator attribute is currently uder discussion,
and up to now it is recommended to be a vendor specific attributes.

https://lists.freedesktop.org/archives/intel-gvt-dev/2020-July/006854.html.

Thanks
Yan
