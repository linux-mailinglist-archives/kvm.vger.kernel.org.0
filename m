Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA227C20B5
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 14:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbfI3MjI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 30 Sep 2019 08:39:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:63828 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729603AbfI3MjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 08:39:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 05:39:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,567,1559545200"; 
   d="scan'208";a="220637658"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga002.fm.intel.com with ESMTP; 30 Sep 2019 05:39:08 -0700
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Sep 2019 05:39:07 -0700
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 FMSMSX102.amr.corp.intel.com (10.18.124.200) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 30 Sep 2019 05:39:07 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.166]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.225]) with mapi id 14.03.0439.000;
 Mon, 30 Sep 2019 20:39:05 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Xia, Chenbo" <chenbo.xia@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>
Subject: RE: [PATCH v2 02/13] vfio_pci: refine user config reference in
 vfio-pci module
Thread-Topic: [PATCH v2 02/13] vfio_pci: refine user config reference in
 vfio-pci module
Thread-Index: AQHVZIuMbancBa08SUGlmoYzX8egtKc81xuAgAcGrFA=
Date:   Mon, 30 Sep 2019 12:38:23 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0B55B2@SHSMSX104.ccr.corp.intel.com>
References: <1567670370-4484-1-git-send-email-yi.l.liu@intel.com>
        <1567670370-4484-3-git-send-email-yi.l.liu@intel.com>
 <20190925203609.770a706c@x1.home>
In-Reply-To: <20190925203609.770a706c@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNmJhNmU5ZjQtMmQzZi00ZjBhLThlZGYtMmM2MTZkOGQ2OWM0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiSlBSY2NkVGJTaU1NclN3YlwvSXBDUmk5RGg5MW5GYitoWDIxZTN2Y05rWmkyTTErKzFWbzBqM1lBQ2ZrOVozUWMifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Thursday, September 26, 2019 10:36 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v2 02/13] vfio_pci: refine user config reference in vfio-pci
> module
> 
> On Thu,  5 Sep 2019 15:59:19 +0800
> Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > This patch adds three fields in struct vfio_pci_device to pass the user
> > configs of vfio-pci module to some functions which could be common in
> > future usage.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c         | 24 +++++++++++++++---------
> >  drivers/vfio/pci/vfio_pci_private.h |  9 +++++++--
> >  2 files changed, 22 insertions(+), 11 deletions(-)
> 
> A subtle behavioral difference here is that disable_idle_d3 and
> nointxmask are runtime modifiable parameters, if the value is changed
> in sysfs the device will adopt the new behavior on its next
> transition.  After this patch, each device operates in the mode defined
> at the time it was probed.  Should we maybe refresh the value at key
> points, like the user opening or releasing the device so that it tracks
> the module parameter?  I think we could defend not changing the
> behavior of a device while it's in use by a user.  Otherwise we might
> want to make the module parameter read-only to avoid the
> inconsistency.

Agreed. I think we can take such assumption that the changing is not
allowed during an open/release cycle. Let me add the updates in the
next version.

> 
> >
[...]
> > +	vfio_pci_fill_ids(&ids[0]);
> 
> Or just 'ids'.  Thanks,

yes, let me fix it.

> Alex
> 

Regards,
Yi Liu

