Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13410152643
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 07:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgBEGXY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 5 Feb 2020 01:23:24 -0500
Received: from mga06.intel.com ([134.134.136.31]:2626 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgBEGXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 01:23:23 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 22:23:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,404,1574150400"; 
   d="scan'208";a="254660466"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by fmsmga004.fm.intel.com with ESMTP; 04 Feb 2020 22:23:22 -0800
Received: from fmsmsx122.amr.corp.intel.com (10.18.125.37) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 4 Feb 2020 22:23:22 -0800
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 fmsmsx122.amr.corp.intel.com (10.18.125.37) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 4 Feb 2020 22:23:22 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.141]) with mapi id 14.03.0439.000;
 Wed, 5 Feb 2020 14:23:20 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC v3 2/8] vfio/type1: Make per-application (VM) PASID quota
 tunable
Thread-Topic: [RFC v3 2/8] vfio/type1: Make per-application (VM) PASID quota
 tunable
Thread-Index: AQHV1pyUqT1ciCuF4kOFYogFFmLhrqgBzCAAgApfJeA=
Date:   Wed, 5 Feb 2020 06:23:20 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1ABE70@SHSMSX104.ccr.corp.intel.com>
References: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
        <1580299912-86084-3-git-send-email-yi.l.liu@intel.com>
 <20200129165632.5f69b949@w520.home>
In-Reply-To: <20200129165632.5f69b949@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZjQ1OWJhMjUtZWU3Zi00ZTViLWE2Y2ItNGNkMDc4ZGM0YzQ4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiOWtrMCtcLzZmWEZjNVZVaWV2MzFrWXJueXZlakg3bWRTVkRMakpUaW85V0dkTXJUNktPWG5STjc2NExtNFp2MUQifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Thursday, January 30, 2020 7:57 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v3 2/8] vfio/type1: Make per-application (VM) PASID quota tunable
> 
> On Wed, 29 Jan 2020 04:11:46 -0800
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > From: Liu Yi L <yi.l.liu@intel.com>
> >
> > The PASID quota is per-application (VM) according to vfio's PASID
> > management rule. For better flexibility, quota shall be user tunable
> > . This patch provides a VFIO based user interface for which quota can
> > be adjusted. However, quota cannot be adjusted downward below the
> > number of outstanding PASIDs.
> >
> > This patch only makes the per-VM PASID quota tunable. While for the
> > way to tune the default PASID quota, it may require a new vfio module
> > option or other way. This may be another patchset in future.
> 
> If we give an unprivileged user the ability to increase their quota,
> why do we even have a quota at all?  I figured we were going to have a
> module option tunable so its under the control of the system admin.
> Thanks,

Right. I'll need to add an option. Will add it in next version. :-)

Regards,
Yi Liu
