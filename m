Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F4339D333
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 04:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhFGDAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Jun 2021 23:00:18 -0400
Received: from mga17.intel.com ([192.55.52.151]:22261 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230147AbhFGDAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Jun 2021 23:00:17 -0400
IronPort-SDR: 3b1QHOvsMmYJn5mOOexMW56PPOOUkPHucWXRYwid7EYdq6eWYa+sQi3Bb2NGNlalAz8lCWPUIw
 rhWGC8tuKaBA==
X-IronPort-AV: E=McAfee;i="6200,9189,10007"; a="184923568"
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="184923568"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 19:58:25 -0700
IronPort-SDR: ZtusT+LbjUh3T7aLJ0BJzDneXMJBVk6Py9g05B8GDXhwqs263nx5UkX9LeBP8T0mqPgWJOW1xI
 qwnmL6hT126Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="481359150"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 06 Jun 2021 19:58:25 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Sun, 6 Jun 2021 19:58:24 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Sun, 6 Jun 2021 19:58:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Sun, 6 Jun 2021 19:58:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Sun, 6 Jun 2021 19:58:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=feUTDzdUTN6zYxLSjo52Lt65JB0gms3IlBL/UkPG5nvEX1CmJtfLt2rudo5woO3uHTkf7sqSCXLAPu1PJJQKgKOkaZP/7VTs1bg0pfISN7nSXf30FqJ5YOJWdyR4JgpHU6AVUgYPGr4ADDFITruuIUOdDyPwfZ0UTPUxc7vgkclFhuPl+K4fzSjy3FWJy3TSJhUKSBt5K0tqxMJ2enHugM7WDuw0mRcfLJQUWGFytEiDUriTk7ZUCfdbjEHHec/2rsrYl4Zc3nV+p+iRAHe8l3QFFW1K7g4AaB4Z2Z06Zzxv0honu1oFQCl5v/KFp/9t5f2uxrCybbt9Fzzc6qKh4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPgwOJR3ggSZ1LaYcT5aVkaSDZp5iD19DSjadb3NqBk=;
 b=BxdCGyAmgG1hqTJvXSDBQNSTIgkM8aMY25/mU3raFKyFCdzCKZQFIYmM80w8stwIRQXwgfTTQb0ADaBREjphJKigM11yKHt7jCgooyL7FoKAEGb3MgNbObwIZsBBDzSDzlgNw4PzbQ35XzQFJYnGA0K6dnFXvMfLUwq4rJdIYrP0iE6tdibo2/kOY9jxSXQvsrTCzbyKTNAXavZn6LicAaU+Potc1KHMj0KQ+Xdm0WOOPfT0Cuhd4/M/LOAt84hqHlASPakTODfYPnussZHZH5OhnWdG82mhT0ADrww1TgQ5ojEwzdJ6nFRhmXADx1vHGhhznogvi7Mogi9wPEPyIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mPgwOJR3ggSZ1LaYcT5aVkaSDZp5iD19DSjadb3NqBk=;
 b=MzPgpyXVb4BUHnavHdqZyhiNf+ADNvj4GbZqB9jyJGliEtHayqEE8JsT7TyS9ZglohLjRFlABBwBd9RcR50ihiAuFLJVsfDeM7OSep7jn//MqD96FzpDTges1w+3w8/yLrqPKvnQf7SLYAcr68meYWj+/NCX6whNTYn7XXhVbPM=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB4882.namprd11.prod.outlook.com (2603:10b6:303:97::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 02:58:19 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 02:58:19 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>
CC:     Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Plan for /dev/ioasid RFC v2
Thread-Topic: Plan for /dev/ioasid RFC v2
Thread-Index: AddbO/WEUAFl3MPnRsG8exiH8bwEag==
Date:   Mon, 7 Jun 2021 02:58:18 +0000
Message-ID: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.65.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b2d35cc-7b9e-4d1a-1c2e-08d929601ae2
x-ms-traffictypediagnostic: CO1PR11MB4882:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB48820CF4879F2B822C5BD1518C389@CO1PR11MB4882.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y+APzMm+XfgCVSc4sqjF9Us/lHNePpak3R0/S3u2PpFmqeW0PIsJkM9Lb+TC/YX1vBguuraGSXQRN992ygPWNUf5sYiforOiyWMjluz7jTyDcm+NhCira4K4qXQdYsrgDlJN8shO/n3I4J2dmJUvrLBPNUyylJzHtyoWpB02rOaIfY8v0M2M7ncRHrS2YHLt/f5o/UtHor2hOPOGw1lmuy63Sh5z+WEucLlcTcpKPUuiCEet8+8qYBRQMQrDJnldzP7CUsAUpFryhPrkvrxCnGwRp3jclZHD/HihQGubsLvmHwBfOKPBZS6+wnquF6lx6EoBcaO+t8Ox//vhm06zmdO/n4ZHOsLo75m4lS3TCq/V0hNns54ikoSR5xigxMq9ERRW5xW0YQDZGRRrH8+FxznVxC5CrJZ8WJ8Jqn/TIdldyAxkr4FTb6+bHeoiCL3bSY/xh/MbQj3SJLr5Za3VZKETofmeJb2NXPtCT0j80gT8A8gYjNII2DlupuJXH99rC5S4LpYtni90xwVBWsIk42dvc2y4ZGmK18rFHXyjw8IAbN97Zs02Mlf7iFr1UUk3/3z+eTTRQ1e+XB1n/HsST47PobyrmbLWqH/fvGCp5OYj8F5IPVXMUE+rhiPFs1QoPn0Tvf9tirwZ4UOCE0iicNES2I5vR5z+NM3+IJo0d0E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(376002)(136003)(396003)(8676002)(8936002)(478600001)(52536014)(83380400001)(55016002)(9686003)(4326008)(71200400001)(5660300002)(921005)(122000001)(186003)(7416002)(26005)(86362001)(66446008)(316002)(64756008)(66476007)(7696005)(33656002)(76116006)(110136005)(6506007)(54906003)(66946007)(66556008)(2906002)(38100700002)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YzLaWbwZmhYm+gKPV9kX8fdXuIkpKZlASoiKSkfGbhpr84PD4R5Dj1Abgp7G?=
 =?us-ascii?Q?SoBpQM7uqp2+EKk2RFQGhaDhwr+TlrlSKx0st1xgg4pCNWYraCHwXo6aJoCp?=
 =?us-ascii?Q?fwmiq/iS2iJ8LTPKslaUp8PgdfVZS+Si8EW6QeiBBvlGmSrOJRuQdbsSWm//?=
 =?us-ascii?Q?u4/tkLP95Vcgiyou27bAxmJ9DP70tsB+AR0v+Y+QnFxJgyVdVechpdqHL+x4?=
 =?us-ascii?Q?huZMxV2/OaPxW3wOdYduRJyNx6WJk1PQOE61VQuldhzEGxH+GOVfRZW0m/T+?=
 =?us-ascii?Q?slXS8la+0u3bVZ/OcI/hlLPIt6F7UkoTHUEp3rBdPSmJuKrckhvJXs6a99W/?=
 =?us-ascii?Q?QCW6KD0L8nFA/74oIRNLZWpCOS6mBs6huGRK0dYY2ElqPLfMtkdE+pf+4cM2?=
 =?us-ascii?Q?qLAI8bOnY9uyLHnywNy9WgN8NzFNkfCWk9P5Huh2LKy41fv8hUfJxHb1hjyO?=
 =?us-ascii?Q?NPDKOlVyFuWWBmRsFP+sR7m1X/7rRaSucKuvtrteG69WzjTjpGVF8Nb3xmXL?=
 =?us-ascii?Q?4DqCqRQKV4E5frZysmq/R+Hjrnse1QMXZvHbtAdS858Dim6I4VvwrETqSuXR?=
 =?us-ascii?Q?LCT0jIkFD58aItR/2iHi8T3FSBzhnNsDNBXABeJ66LVq1sFBnqKpAJyxQPiB?=
 =?us-ascii?Q?7Q5MBxtomADjPCRBAV2bAernJfIjE/WrVaQr4/31fPNqCSxs7xK7YJK6LRWR?=
 =?us-ascii?Q?aazxLJXxbJeEGcyLQOmMI+wYVAWGjSgmCcQrKjavU6UWyhVoBOFU7qleubX7?=
 =?us-ascii?Q?rUO1vt64tYnQLrdA0RK/7NrYRkfahreV3Q/RPPEyLfi/l/ArUlBTGEv+P1Hp?=
 =?us-ascii?Q?J3c+5yyeiQc1FRrycN5bv6XQbIGNLUV3dtVUme6MGvwi4sP5Y43AS+rY+iG5?=
 =?us-ascii?Q?tL/1SBYEfOI0NCHp1zELmAmPV7jvMkKaeHk+CqQX13E/MfGzKc/5+p0NEcB6?=
 =?us-ascii?Q?DH9kmCkqpBjDZLdZViRjksy17Ma4xI32QqmteGN0IiW+RK9XIpYgidHhnfhz?=
 =?us-ascii?Q?5pH0oqCcC/Ny5fdnRF1cBEspJxNb93sOQKxGVkeXF12r1UqgWoL6uWRsNDuB?=
 =?us-ascii?Q?H07hBGb0Q6dq/g7u8IO5y9Uev7eUybjBmIRGdQFtDD+I3ROVSJRXIVgIUPnF?=
 =?us-ascii?Q?KQNZkYd03JjPcDue67WNpmadMWpJq6ksAOO+pHxn260+jd8C6J9SAHx0f8Sf?=
 =?us-ascii?Q?LxiFsV1SMBkhH8umbhY8ixKUTfK2zJ24OkoQCc9I+Fdx91OABSMQoPwAPEXh?=
 =?us-ascii?Q?QAiGg1Nr9+kWMAevEK+pme4ZL+MD6z0U0o3bkgzgF4/DsLr02K2aT/fZU3QC?=
 =?us-ascii?Q?EOk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b2d35cc-7b9e-4d1a-1c2e-08d929601ae2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 02:58:18.6874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f7pNzEYkRZIAON0mIkVjxbiyV7Ye89bTuUw1X8cJfe6vorTukPmzgt2g5CiGSb4Qq3LMvNk+7zplGuF/ygRmDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4882
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, all,

We plan to work on v2 now, given many good comments already received
and substantial changes envisioned. This is a very complex topic with
many sub-threads being discussed. To ensure that I didn't miss valuable=20
suggestions (and also keep everyone on the same page), here I'd like to=20
provide a list of planned changes in my mind. Please let me know if=20
anything important is lost.  :)

--

(Remaining opens in v1)

-   Protocol between kvm/vfio/ioasid for wbinvd/no-snoop. I'll see how
    much can be refined based on discussion progress when v2 is out;

-   Device-centric (Jason) vs. group-centric (David) uAPI. David is not ful=
ly
    convinced yet. Based on discussion v2 will continue to have ioasid uAPI
    being device-centric (but it's fine for vfio to be group-centric). A ne=
w
    section will be added to elaborate this part;

-   PASID virtualization (section 4) has not been thoroughly discussed yet.=
=20
    Jason gave some suggestion on how to categorize intended usages.=20
    I will rephrase this section and hope more discussions can be held for=
=20
    it in v2;

(Adopted suggestions)

-   (Jason) Rename /dev/ioasid to /dev/iommu (so does uAPI e.g. IOASID
    _XXX to IOMMU_XXX). One suggestion (Jason) was to also rename=20
    RID+PASID to SID+SSID. But given the familiarity of the former, I will=
=20
    still use RID+PASID in v2 to ease the discussoin;

-   (Jason) v1 prevents one device from binding to multiple ioasid_fd's. Th=
is=20
    will be fixed in v2;

-   (Jean/Jason) No need to track guest I/O page tables on ARM/AMD. When=20
    a pasid table is bound, it becomes a container for all guest I/O page t=
ables;

-   (Jean/Jason) Accordingly a device label is required so iotlb invalidati=
on=20
    and fault handling can both support per-device operation. Per Jean's=20
    suggestion, this label will come from userspace (when VFIO_BIND_
    IOASID_FD);

-   (Jason) Addition of device label allows per-device capability/format=20
    check before IOASIDs are created. This leads to another major uAPI=20
    change in v2 - specify format info when creating an IOASID (mapping=20
    protocol, nesting, coherent, etc.). User is expected to check per-devic=
e=20
    format and then set proper format for IOASID upon to-be-attached=20
    device;

-   (Jason/David) No restriction on map/unmap vs. bind/invalidate. They
    can be used in either parent or child;

-   (David) Change IOASID_GET_INFO to report permitted range instead of
    reserved IOVA ranges. This works better for PPC;

-   (Jason) For helper functions, expect to have explicit bus-type wrappers
    e.g. ioasid_pci_device_attach;

(Not adopted)

-   (Parav) Make page pinning a syscall;
-   (Jason. W/Enrico) one I/O page table per fd;
-   (David) Replace IOASID_REGISTER_MEMORY through another ioasid
    nesting (sort of passthrough mode). Need more thinking. v2 will not=20
    change this part;

Thanks
Kevin
