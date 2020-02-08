Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57AF5156379
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2020 09:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgBHIqz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 8 Feb 2020 03:46:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:53600 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbgBHIqz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Feb 2020 03:46:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Feb 2020 00:46:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,416,1574150400"; 
   d="scan'208";a="250691345"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga002.jf.intel.com with ESMTP; 08 Feb 2020 00:46:53 -0800
Received: from fmsmsx101.amr.corp.intel.com (10.18.124.199) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 8 Feb 2020 00:46:53 -0800
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 fmsmsx101.amr.corp.intel.com (10.18.124.199) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Sat, 8 Feb 2020 00:46:53 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.55]) with mapi id 14.03.0439.000;
 Sat, 8 Feb 2020 16:46:50 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
Thread-Index: AQHV1pyUqT1ciCuF4kOFYogFFmLhrqgPqnuAgAFZAdA=
Date:   Sat, 8 Feb 2020 08:46:50 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1B5847@SHSMSX104.ccr.corp.intel.com>
References: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
        <1580299912-86084-3-git-send-email-yi.l.liu@intel.com>
 <20200207114345.2071a482@jacob-builder>
In-Reply-To: <20200207114345.2071a482@jacob-builder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNmVjYjE1M2EtOTUzOS00MTQyLWI0NjctYjAyMjRhMzE1ZWNlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaDE2amUyT0hFa29kR3JHRXNGTG1peEQrTXdBejQ3dmR6b1NabURjWUIxWEp2Z1VlYWU3QXdsV21Wd2NUT24yVyJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jacob,

> From: Jacob Pan [mailto:jacob.jun.pan@linux.intel.com]
> Sent: Saturday, February 8, 2020 3:44 AM
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
> >
> One issue we need to solve is how to share PASIDs at the system
> level, e.g. Both VMs and baremetal drivers could use PASIDs.
> 
> This patch is granting quota to a guest w/o knowing the remaining
> system capacity. So guest PASID allocation could fail even within its
> quota.

that's true.

> The solution I am thinking is to enforce quota at IOASID common
> code, since IOASID APIs already used to manage system-wide allocation.
> How about the following changes to IOASID?
> 1. introduce quota in ioasid_set (could have a soft limit for better
> sharing)
>
> 2. introduce an API to create a set with quota before allocation, e.g.
> ioasid_set_id = ioasid_alloc_set(size, token)
> set_id will be used for ioasid_alloc() instead of token.

Is the token the mm pointer? I guess you may want to add one more
API like ioasid_get_set_id(token), thus that other ioasid user could get
set_id with their token. If token is the same give them the same set_id.

> 
> 3. introduce API to adjust set quota ioasid_adjust_set_size(set_id,
> size)
> 
> 4. API to check remaining PASIDs ioasid_get_capacity(set_id); //return
> system capacity if set_id == 0;
> 
> 5. API to set system capacity, ioasid_set_capacity(nr_pasids), e.g. if
> system has 20 bit PASIDs, IOMMU driver needs to call
> ioasid_set_capacity(1<<20) during boot.

yes, this is definitely necessary.

> 6. Optional set level APIs. e.g. ioasid_free_set(set_id), frees all
> IOASIDs in the set.

If this is provided. I think VFIO may be not necessary to track allocated
PASIDs. When VM is down or crashed, VFIO just use this API to reclaim
allocated PASIDs.

> With these APIs, this patch could query PASID capacity at both system
> and set level and adjust quota within range. i.e.
> 1. IOMMU vendor driver(or other driver to use PASID w/o IOMMU) sets
> system wide capacity during boot.
> 2. VFIO Call ioasid_alloc_set() when allocating vfio_mm(), set default
> quota
> 3. Adjust quota per set with ioasid_adjust_set_size() as the tunable in
> this patch.

I think this is abstraction of the allocated PASID track logic in a common
layer. It would simplify user logic.

Regards,
Yi Liu
