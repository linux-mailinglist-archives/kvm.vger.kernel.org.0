Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23EC2116564
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 04:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfLIDZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Dec 2019 22:25:55 -0500
Received: from mga05.intel.com ([192.55.52.43]:54662 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726748AbfLIDZz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Dec 2019 22:25:55 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Dec 2019 19:25:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,294,1571727600"; 
   d="scan'208";a="244303960"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by fmsmga002.fm.intel.com with ESMTP; 08 Dec 2019 19:25:52 -0800
Date:   Sun, 8 Dec 2019 22:17:42 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Eric Blake <eblake@redhat.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: Re: [RFC PATCH 1/9] vfio/pci: introduce mediate ops to intercept
 vfio-pci ops
Message-ID: <20191209031742.GJ31791@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20191205032419.29606-1-yan.y.zhao@intel.com>
 <20191205032536.29653-1-yan.y.zhao@intel.com>
 <9461f821-73fd-a66f-e142-c1a55e38e7a0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9461f821-73fd-a66f-e142-c1a55e38e7a0@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry about that. I'll pay attention to them next time and thank you for
pointing them out :)

On Sat, Dec 07, 2019 at 07:13:30AM +0800, Eric Blake wrote:
> On 12/4/19 9:25 PM, Yan Zhao wrote:
> > when vfio-pci is bound to a physical device, almost all the hardware
> > resources are passthroughed.
> 
> The intent is obvious, but it sounds awkward to a native speaker.
> s/passthroughed/passed through/
> 
> > Sometimes, vendor driver of this physcial device may want to mediate some
> 
> physical
> 
> > hardware resource access for a short period of time, e.g. dirty page
> > tracking during live migration.
> > 
> > Here we introduce mediate ops in vfio-pci for this purpose.
> > 
> > Vendor driver can register a mediate ops to vfio-pci.
> > But rather than directly bind to the passthroughed device, the
> 
> passed-through
> 
> -- 
> Eric Blake, Principal Software Engineer
> Red Hat, Inc.           +1-919-301-3226
> Virtualization:  qemu.org | libvirt.org
> 
