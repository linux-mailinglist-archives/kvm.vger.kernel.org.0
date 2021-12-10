Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F8046FD1B
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 09:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238821AbhLJJAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 04:00:37 -0500
Received: from mga06.intel.com ([134.134.136.31]:51853 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238778AbhLJJAg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 04:00:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639126622; x=1670662622;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j3xryo8ffPsbr17Qjp7uQ+qanAoDQlwh/kU+v36J8jQ=;
  b=BLIeRJ66PWckCCXfW39jZiXNFgkJVttXoBB5HC5C32A93mttie6Q661Q
   ZyyfZb1bkhkZwPgtjGEiqlUIKC+mV9WX+zhUgg4+8WIHjpskq80CrMK3X
   ybd787UTLiS++WfwHFS/MMW7/i7g0oKlh6lPnFr7tRqbFYpW+Cxd4WtDm
   +ojuBE9oc3Kcrtojk3hq6jg/x3Y222bWj2xQI36xa9x69zOzWHhtN8CY5
   DcMi1Y+zJUbCTQICL2w5XFZJf4+DLM2/cSb01PcoeKU4owrjHfTqLF9Aw
   RY+B1PIxfbEOBraI3TPWygZY1XFxhIS4df2HI6DXs/5Pcuo83iYmiKYpB
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10193"; a="299097811"
X-IronPort-AV: E=Sophos;i="5.88,194,1635231600"; 
   d="scan'208";a="299097811"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 00:56:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="607304827"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga002.fm.intel.com with ESMTP; 10 Dec 2021 00:56:59 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 00:56:59 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 00:56:58 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 10 Dec 2021 00:56:58 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 10 Dec 2021 00:56:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qol5DZybsj9xXi2+yckwNMherWBG8HTDxKLaSEjCAsC/HoilR79s5MXDcKXAsowRVvHiaZ41HPXxtJ1++A/Abv5kTjO9Jhk29iQIx0c1mPDgvhE+Jzc0CVLCFIzvmIJGUAHrDy39/vg5kjtezFzOLHLqfwvhdADgqBGjVXgtQ8xBA1fuJ6sKIrGGEr7dyEOFILrnUKENJFQa3wtyobl2HovWKJN4gFxq0ENyxllSXklrJQztFYpLAkfhznA5jbVT8vmjazFLfa5+EsPn0WPOy4W7JR3RhaQ7aPRjqxvw92pKXz/M1TFicCOuvyTl/OMKBnx7WQum6P+LUIUUzwiwtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ndRaidgbhJ17rilQw40w+rLhSBLDmFF81c07dfEyW8A=;
 b=AAibNF5vCbtxJpvjx8wKfZMGfxEWE0J9M+O4q2MxcK6g3x/19XwRjwDS1UDfYdFBM6l0GTM61Z5jkyHxT0/UXGhsrM2SiKt4RU1OSXTSIwZ47qRctvu2p/KbqvaP72urf3iyiwAuAA44Jna7QdWLLmDyGIyflcwibpdqy5w+5UTZkQEnogUDbIE0nyS9lxMHsbbj2cmiueTJHRAqJZftqQ+1SQhdAnWbETw8z6AQ23o8eXemqpKhsPxVnKnkE2X0iGznmkO7pELVjUlXx9lBV8rv0dVEl1xW2zWiPb+hN2K75nZIQZP6kL8PIY9oeqU+TR7cwXJ9iFMn/heM4O2e/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndRaidgbhJ17rilQw40w+rLhSBLDmFF81c07dfEyW8A=;
 b=PYZLi5jDL/K8vsr9C/OnZJGHWdsYDTFbL7JYSsMX3pPlK/DjmhlaYORmfTjeeKQcqi5W0QINH4yp5s0kcuI7+v3FzNsnyDJI3VSZ4TiDR65JUSQu2rvlL+7H7RzwJXW5lUoCd6FvEsnHrpSm8fbT6AAv4npeQQFU2vNddGseQgA=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1652.namprd11.prod.outlook.com (2603:10b6:405:10::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Fri, 10 Dec
 2021 08:56:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4755.016; Fri, 10 Dec 2021
 08:56:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "wangxingang5@huawei.com" <wangxingang5@huawei.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Subject: RE: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Thread-Topic: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Thread-Index: AQHXyx+9zoVf6ec36EaoAw6mFm2RjKwlh1WAgAGLFwCAARJNAIAAUNaAgABaKgCAAEnegIAAE6oAgACHsjCAABVZoIAAzVeAgAED4rA=
Date:   Fri, 10 Dec 2021 08:56:56 +0000
Message-ID: <BN9PR11MB527612D1B4E0DC85A442D87D8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com> <YbDpZ0pf7XeZcc7z@myrica>
 <20211208183102.GD6385@nvidia.com>
 <BN9PR11MB527624080CB9302481B74C7A8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
 <BN9PR11MB5276D3B4B181F73A1D62361C8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20211209160803.GR6385@nvidia.com>
In-Reply-To: <20211209160803.GR6385@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44878884-d19a-4ceb-ccab-08d9bbbb0500
x-ms-traffictypediagnostic: BN6PR11MB1652:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB1652036C26FD085486BC47768C719@BN6PR11MB1652.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QmERhxq7AJI4BTpGjhwyIOZ1VyiLzXHLFIUiYiAIyajvFR2iKQHIEq7AJ8COw6EIh58lZTGX4lODO2QKFV/Y9ku35IM0sm2PR3I20MI4BiUae6NofFglSa6sPrqG+k21QbTZJmoz6ERmUunjFkLuFKMO9VoBWGhQKQKsgQd0rGB5MOW1cX+Lv291OtIOGN9L16JpRBtnNXz4Z6V8GqFVAl9va6xidxERLOwfwqqHx0OAzL7WfqLoy7XiqgOHdJKK+xMLQb5+mIyqGQrSDNnfR1q5cBk189qoC+D0sKaKESfkP/4sF8ZczDKY+/mbIk0ZXmwGz8IiiuUoHOBec2qS8xxemUdnRFLatbMsaQuD/NNmTabbMasehbLEAtkYW7+fYlXKumgiycdivtPeSlxWZLM/fcMHDWdHTLy8p18iV6J8w3vzUghpgdwZSpVUr3RQQxM35JmQtLbZmK4Qvx/DK3uBCDx5miIuQu1JEqP+iGY9gzaz/2rVAzzmVp2pIuvHm5aigrgBqsK2unLf7sfupdMA5YbW8cKrQoaq6lQG+zSJpig/qPJn/GiloWOdzBPVSrrNQDUyENXpGV5Ol9pmSnSIUQ7r33SJcvSe/K0AA7RRityI9g3H/MrniRXFB7i0NLZBuJ+qWcPt6DnNly1ZxiCvZoj0I4DFWD4gHyx7gTrVPiHj26oOVB7dHnRngLUqPxexEzxD7G9qwQe+qTrEooC9PmdAuO94ukgD1YAaRWQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(66446008)(26005)(83380400001)(4326008)(2906002)(6916009)(33656002)(82960400001)(71200400001)(316002)(7416002)(66476007)(8676002)(38100700002)(64756008)(66556008)(186003)(122000001)(8936002)(6506007)(9686003)(86362001)(54906003)(508600001)(55016003)(66946007)(76116006)(5660300002)(7696005)(38070700005)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LvGEBvzqIpYDFaO7vy0ogmz4glXqWIqyNXp9h+LAZCNOKQeVVAPy6Zc8xW+f?=
 =?us-ascii?Q?nfOrEB4oMq5pRNoSG1Y6+9GsXHIenYwmeRp2xNM2OvEacvGP0Zjz7yNuODvp?=
 =?us-ascii?Q?R9+XK0qHNA86/fX8KmK2qsqAbwfRNC1ABHnSEq3ktFXqpnl0ScRlJtrTj6kx?=
 =?us-ascii?Q?6spvaRdfniS3MyeN6DrTUQZSoLmUQlwrVp/oFhHRV94SqUTblSHCeOcBJ9L6?=
 =?us-ascii?Q?+XFhwzMD3wOdTYNgTAe86gudmjXUdDqyZDQ4ZeZhQZ3SliADxx6HW1Luzx4n?=
 =?us-ascii?Q?WuFrsW2PbBlbEuFyc83RU6RLezW2Oom2GD52oBsK6ND4KxBaODLTL357DvMX?=
 =?us-ascii?Q?UQSs0Gep4I85SYPJ/v2/x/74O6JrQhIdinql1ra1/n5Jw4TUm6TOQfbVTb1f?=
 =?us-ascii?Q?oVa434RDBfUMeEeQBAhxBGGqErGHyqwuN+VeDpWdUqznpn2l2K9WWS+eAkbi?=
 =?us-ascii?Q?tBPGynFFRdR4QoR9ttaA+IS5HNhr4n8lAZIaHMBavRoU0y6R9byjmkhkCMZm?=
 =?us-ascii?Q?hRjxAq7YIJIxqeWVkmfh29aW1fU/g4vrmw7AvAOngBwH1+g66eNuEuM7Z71C?=
 =?us-ascii?Q?3AIQC6eCWFImGiJ57WOOS05W8LWE+5Ib6liap1sq5vuiK/GlRciA+MY/iCiG?=
 =?us-ascii?Q?FvCjIpLifCUQafD/V/peNedEQIrxSeFia2Driftn3A9voroo03TnPg8p8KPz?=
 =?us-ascii?Q?xwBDXO+pufwhK03hw65zgrM/TEoADoVsUQSQLP6cOs19rEvOA/Q8hSQKQ+Ks?=
 =?us-ascii?Q?KJAOnRwsBf1k89AI9tdHM/tqY9VRkxCaubcoHHpQ90UKoh/N0bIy6NqD65ZJ?=
 =?us-ascii?Q?9reNZ2Cyo+bHxJgkmavXxqrHMXKJXf9M31ZAIw99XkCUTIBYQE7E50XzJhVM?=
 =?us-ascii?Q?grinXXD2ZM3KWsXUqmpN74nR0/tqThxoV9W4rQUJ63X9CcMT14k2Ue/SLRU8?=
 =?us-ascii?Q?QF3qhnuc06iGULZay2fRCpLWZt1NCR3E/9ALctNz/h8NU2yJdrzNUxWtPXcw?=
 =?us-ascii?Q?b3mvjCgOReun2xQePVPfdBaqiyk9QuaP9mh6ZHDDYIj2pGxUcTXXGOz96CyW?=
 =?us-ascii?Q?Zk250lGsJBNggTQp53vEz/63LJIvCUQMp3XQrXXhfzN5aCFndhE2vdC/lXYQ?=
 =?us-ascii?Q?NntybhDHI1TbOJi/WBxDD5+e0tkvcf14NNwv7hwBnvvK6TVaVxgDrPOzQIdf?=
 =?us-ascii?Q?dt+7ezTGvI4Tr5iuTGQHSU6sTJON4RX8AWRT+ipaYQQkPFya1detZjUejFN1?=
 =?us-ascii?Q?t77i/E0W2OCxXvJ4C2rsxg29Ul14Tj7zXGITAVuatWy8ApAHgn01yXHglqaa?=
 =?us-ascii?Q?zfLD92k5iQmk8El4Uvf0XDoki6jaUk3bxVS0stZLZXiXOhVmJ7Gaa8kx88ly?=
 =?us-ascii?Q?/dai/i1nj0bu72VxQZ32SK1nOBdhnDH8Y9n4RvIz0gMY7Z6kyszMkRO1djX+?=
 =?us-ascii?Q?otXt2POoRFLeFTqE0DnMwe4tJ6mdwWqjBN5RBQ15YNPE2hzKlNZvazU5099E?=
 =?us-ascii?Q?wlyUxDkET3zbZmTEysKygSisC7KjjWMgB6BMaqT2MOloo+qnKy3MuytD+yTC?=
 =?us-ascii?Q?bEJXZXqOFdXWrfL9pikGMLm8r9z0aIXqXqi/M45d2I9w0jDsG2bah61eGPoG?=
 =?us-ascii?Q?20HHR02GTQDm1Ms5//JBu6M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44878884-d19a-4ceb-ccab-08d9bbbb0500
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 08:56:56.5020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9WZ1e5RIZQ7tbXVb+t7hFGHhsgbOx1eDNK0CmOuv3K9TRu8fWT5CtKXrqG7Sbu/YILChYekrHKMzQ6cvASLYbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1652
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe via iommu
> Sent: Friday, December 10, 2021 12:08 AM
>=20
> On Thu, Dec 09, 2021 at 03:59:57AM +0000, Tian, Kevin wrote:
> > > From: Tian, Kevin
> > > Sent: Thursday, December 9, 2021 10:58 AM
> > >
> > > For ARM it's SMMU's PASID table format. There is no step-2 since PASI=
D
> > > is already within the address space covered by the user PASID table.
> > >
> >
> > One correction here. 'no step-2' is definitely wrong here as it means
> > more than user page table in your plan (e.g. dpdk).
> >
> > To simplify it what I meant is:
> >
> > iommufd reports how many 'user page tables' are supported given a devic=
e.
> >
> > ARM always reports only one can be supported, and it must be created in
> > PASID table format. tagged by RID.
> >
> > Intel reports one in step1 (tagged by RID), and N in step2 (tagged by
> > RID+PASID). A special flag in attach call allows the user to specify th=
e
> > additional PASID routing info for a 'user page table'.
>=20
> I don't think 'number of user page tables' makes sense
>=20
> It really is 'attach to the whole device' vs 'attach to the RID' as a
> semantic that should exist
>=20
> If we imagine a userspace using kernel page tables it certainly makes
> sense to assign page table A to the RID and page table B to a PASID
> even in simple cases like vfio-pci.
>=20
> The only case where userspace would want to capture the entire RID and
> all PASIDs is something like this ARM situation - but userspace just
> created a device specific object and already knows exactly what kind
> of behavior it has.
>=20
> So, something like vfio pci would implement three uAPI operations:
>  - Attach page table to RID
>  - Attach page table to PASID
>  - Attach page table to RID and all PASIDs
>    And here 'page table' is everything below the STE in SMMUv3
>=20
> While mdev can only support:
>  - Access emulated page table
>  - Attach page table to PASID

mdev is a pci device from user p.o.v, having its vRID and vPASID. From
this angle the uAPI is no different from vfio-pci (except the ARM one):

  - (sw mdev) Attach emulated page table to vRID (no iommu domain)
  - (hw mdev) Attach page table to vRID (mapped to mdev PASID)
  - (hw mdev) Attach page table to vPASID (mapped to a fungible PASID)

>=20
> It is what I've said a couple of times, the API the driver calls
> toward iommufd to attach a page table must be unambiguous as to the
> intention, which also means userspace must be unambiguous too.
>=20

No question on the unambiguous part. But we also need to consider
the common semantics that can be abstracted.

From user p.o.v a vRID can be attached to at most two page tables (if
nesting is enabled). This just requires the basic attaching form for=20
either one page table or two page tables:

	at_data =3D {
		.iommufd	=3D xxx;
		.pgtable_id	=3D yyy;
	};
	ioctl(device_fd, VFIO_DEVICE_ATTACH_PGTABLE, &at_data);

This can already cover ARM's requirement. The user page table
attached to vRID is in vendor specific format, e.g. either ARM pasid=20
table format or Intel stage-1 format. For ARM pasid_table + underlying=20
stage-1 page tables can be considered as a single big paging structure.

From this angle I'm not sure the benefit of making a separate uAPI=20
just because it's a pasid table for ARM.

Then when PASID needs to be explicitly specified (e.g. in Intel case):

	at_data =3D {
		.iommufd	=3D xxx;
		.pgtable_id	=3D yyy;
		.flags 		=3D VFIO_ATTACH_FLAGS_PASID;
		.pasid		=3D zzz;
	};
	ioctl(device_fd, VFIO_DEVICE_ATTACH_PGTABLE, &at_data);

Again, I don't think what a simple flag can solve needs to be made
into a separate uAPI.

Is modeling like above considered ambiguous?

Thanks
Kevin
