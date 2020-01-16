Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41FB613DA91
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 13:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgAPMsT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 16 Jan 2020 07:48:19 -0500
Received: from mga18.intel.com ([134.134.136.126]:46442 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgAPMsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 07:48:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jan 2020 04:48:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,326,1574150400"; 
   d="scan'208";a="257343252"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga002.fm.intel.com with ESMTP; 16 Jan 2020 04:48:18 -0800
Received: from fmsmsx154.amr.corp.intel.com (10.18.116.70) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jan 2020 04:48:18 -0800
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX154.amr.corp.intel.com (10.18.116.70) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jan 2020 04:48:18 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.197]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.203]) with mapi id 14.03.0439.000;
 Thu, 16 Jan 2020 20:48:16 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>
Subject: RE: [PATCH v4 04/12] vfio_pci: make common functions be extern
Thread-Topic: [PATCH v4 04/12] vfio_pci: make common functions be extern
Thread-Index: AQHVxVT1ZgpJigc+lU2otv7lw0J4t6frE/6AgAI3QTA=
Date:   Thu, 16 Jan 2020 12:48:16 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A183F99@SHSMSX104.ccr.corp.intel.com>
References: <1578398509-26453-1-git-send-email-yi.l.liu@intel.com>
        <1578398509-26453-5-git-send-email-yi.l.liu@intel.com>
 <20200115115605.2014c01f.cohuck@redhat.com>
In-Reply-To: <20200115115605.2014c01f.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNWNkMjEyMmQtOGE4Ni00ZjdkLWI5NjctODE4OTc3OTBhZTJiIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRElpZ1wvd3NqRnVibzY4NnluZCt3WmgrWm0xbjBBakpsdE9qcEtXdXROVzY5WndjdXdCWHJXSGdcL1JwOVVabjNGIn0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Cornelia Huck [mailto:cohuck@redhat.com]
> Sent: Wednesday, January 15, 2020 6:56 PM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [PATCH v4 04/12] vfio_pci: make common functions be extern
> 
> On Tue,  7 Jan 2020 20:01:41 +0800
> Liu Yi L <yi.l.liu@intel.com> wrote:
> 
> > This patch makes the common functions (module agnostic functions) in
> > vfio_pci.c to be extern. So that such functions could be moved to a
> > common source file.
> >
> > *) vfio_pci_set_vga_decode
> > *) vfio_pci_probe_power_state
> > *) vfio_pci_set_power_state
> > *) vfio_pci_enable
> > *) vfio_pci_disable
> > *) vfio_pci_refresh_config
> > *) vfio_pci_register_dev_region
> > *) vfio_pci_ioctl
> > *) vfio_pci_read
> > *) vfio_pci_write
> > *) vfio_pci_mmap
> > *) vfio_pci_request
> > *) vfio_pci_err_handlers
> > *) vfio_pci_reflck_attach
> > *) vfio_pci_reflck_put
> > *) vfio_pci_fill_ids
> 
> I find it a bit hard to understand what "module agnostic functions" are supposed to
> be. The functions you want to move seem to be some "basic"
> functions that can be shared between normal vfio-pci and vfio-mdev-pci... maybe
> talk about "functions that provide basic vfio functionality for pci devices" and also
> mention the mdev part?
> 
> [My rationale behind complaining about the commit messages is that if I look at this
> change in a year from now, I want to be able to know why and to what end that
> change was made.]

Right, agreed with your comments. I'll change the commit message accordingly
per your suggestion.

Thanks,
Yi Liu

> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c         | 30 +++++++++++++-----------------
> >  drivers/vfio/pci/vfio_pci_private.h | 15 +++++++++++++++
> >  2 files changed, 28 insertions(+), 17 deletions(-)

