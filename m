Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585DE504B72
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 05:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236142AbiDRD6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Apr 2022 23:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236137AbiDRD6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Apr 2022 23:58:46 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6AA18B2F
        for <kvm@vger.kernel.org>; Sun, 17 Apr 2022 20:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650254166; x=1681790166;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jagr0mkrj6UaULGiZSd1et/uvWvhzacOiCbTa8rk1+k=;
  b=YdWM/rCn8F8RWcNsHwP4yRnJWGjueM+m5ns/WMqpfxxiMDlgbgvxqFBE
   AvbKQJ/T0CUcGv+x6yY3Y0xFpHNzni8Ve3Sk5IOxbjrFsm4A3C+YSYhn8
   jHJfZgqXNfwDlj1NLC+Eqj7XuzCvYY95Wt9Y0XWddUV4eyfJ28erx8cxB
   pH0rIPEecSZeD1zoLB3Aw2Bvk64fE1OyfAJ2YX+uLsTMeetMNAzR6WZtO
   nvCrWo9YwVxIXGPahE8nD7T/CXIhGk+NpkrSSjfbyCXQkBIYCqJWrMafx
   /T8IqBFiiY0aOUIzEK8XscZxLoUy+Y6UVCl/G0/c0bhQCc03Nj6HpFmPs
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10320"; a="261045873"
X-IronPort-AV: E=Sophos;i="5.90,267,1643702400"; 
   d="scan'208";a="261045873"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2022 20:56:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,267,1643702400"; 
   d="scan'208";a="575400895"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga008.jf.intel.com with ESMTP; 17 Apr 2022 20:56:05 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Sun, 17 Apr 2022 20:56:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Sun, 17 Apr 2022 20:56:04 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Sun, 17 Apr 2022 20:56:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LioVlNescvaO1ml9f2A8EJGBvCjTjS4MBFPaPjkScAnYpSdk+TTqokcHYReaGe1Es20PMNID0yIo+vnv69abaRL1W4l99wEyuWVInIjzQDbXbMEbRvikrmaTZxtv4ogqXOu7iCyzdtk4O4ReJllGUSHtBJt0c8AxuaUdnROqzYMedcHsm1OTgWouB9eipIjpCeUXkZvcXvXu2HD8v6XfsAuoWy1xpZa9UwwhulxvebziHyLcvrkN4Kwool48EleOzoEJgVjeQ/ZMadn60m9eMPd92R1SmEgExB1nCB+laQXrPueUjitrjipL8SGEA1aybKcJSQJVnqE4KZaouurmRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aYQaXamO+CMSapCoy2iYnXqf13JfyX6WnKBiSt0Dq30=;
 b=JrHoYlozcBFk9pPrvYxRicX14smOCvh/Bt12eyT3pr/2g1qdbO135oe108cTcpCT/x42rMWcQ49Rc4nB6HrKZGtu8jvdqpBZah96+Ks9ygDGSe4OM35hfzCPCCpwrwT9IFoCJFOVxVVUOgQ9J/yu/3r6FZmdYNGfn4Vuo28AJRh98O6i5sPM6A/WZUZW2yDiR/AwtUpNZkVye/EoBSudmUg8/N9GksqKh2RpLDgQzfWTqFKpzfO/klETC1AWDBC2y+U5QpxQgy5YO8PgF2mfjeVJgsUlPO+YqGUQ9qRgSuhr3+86n1aB6V84gNGLeXoZlLORyJq8PMY1rrNdlwXDLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MWHPR11MB1536.namprd11.prod.outlook.com (2603:10b6:301:b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 03:56:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 03:56:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH 04/10] vfio: Use a struct of function pointers instead of
 a many symbol_get()'s
Thread-Topic: [PATCH 04/10] vfio: Use a struct of function pointers instead of
 a many symbol_get()'s
Thread-Index: AQHYUDAMID4ey+ocu0eeixgszfXfG6zwV6bggAEuooCAAB86sIAAHfuAgAM2yXA=
Date:   Mon, 18 Apr 2022 03:56:01 +0000
Message-ID: <BN9PR11MB5276A67BA0AB9311C4A551498CF39@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <4-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <BN9PR11MB52764D80F73203162C8E82268CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220415215407.GM2120790@nvidia.com>
 <BN9PR11MB5276D64258C6C41C252C5C4F8CF19@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220416013311.GP2120790@nvidia.com>
In-Reply-To: <20220416013311.GP2120790@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37cc3b99-d01b-4e57-3d09-08da20ef5aaf
x-ms-traffictypediagnostic: MWHPR11MB1536:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR11MB1536BD266D83AFC133004FE58CF39@MWHPR11MB1536.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a31wj/hIafIDzRni7Hb0jphvp6do9p4AmnpB/EfF/b/vmn8s4BQog0w+ceYwN4cTsNg8oxti2DHDwVi0ay/ShHdJnVnMxtrM+7rypXcMbB+uVPeKwNI3ax8h+nH9KHRY7zqaGEM7Kgh1A/YeEl4LToU3nlIgyzVrcuqWjnYg5z72qKqOTaytB86JjzvgNp161y2szQ894V39clluj3QBot1MEkuG5CWao3/jCN/uQLIh1qT0dnvE3Cs/GRyP7DRXBZkVET4vW5CFicGnBp1jqFpMrNOtWXWrNTbQt9M69DbLSxZVu25ptMO/8l9rKalhfzyaTANM3D8GwzPgtr/kBWbAqDwP+Lhc1KpY2MetqRFNTvgMI3hJkXQsLzHaNk9tSaBmusjMx8Fg5rymgFOKEu1DwT5K+MVrtJ9RogHd1Jpkwjmr+E9xbmbyZ83XCnK1Irj2jZK0tGndv+O26SgsqsH69ai1XtyPsgDz+wQzTE8CtYAzGiLJh0jgAb4gyZsbu7Kn5aI4j933RTh5yfMDMqlaelYVw0gMmoX4IlWd2YlE7LQm9dWcToauPpkKKyTxVJ9lPMnK9rNEpLuD3Z3KZbm0108JUZ+EC3meiHGMBudYfsn1ZnWGScehAHYvcA9Gtj56BeGNBG5nfONkDrxMa6PN0dG6wq0+DKcf8hZHAKcxcD+77KRS2to34uf3kU32HLIuuz4VeOIyPw434VAJ25OJH9TYltFmETtgmBJRn9vlCyyWTdhlH3EP4oTtuY3HXhm4anF7VcXc4EGVtqDOPOlBCwBtMIZlh/gmHIR3nVs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(107886003)(5660300002)(8676002)(9686003)(33656002)(6916009)(55016003)(71200400001)(316002)(966005)(508600001)(2906002)(52536014)(38070700005)(186003)(66446008)(26005)(76116006)(66946007)(86362001)(66556008)(66476007)(64756008)(8936002)(4326008)(7696005)(6506007)(83380400001)(82960400001)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Wt+PZHNL+0rOJNnihINEZHAVACrTWeP3f8777qbm7gQ5/9I9B/XbQ5f7L8dK?=
 =?us-ascii?Q?6MxEm2brdeYb9guLcOlFRIHD08A+c8Xhw4y2bbSQDYFASNVMB+RwMaqMSvoF?=
 =?us-ascii?Q?kC6p4S+tD3qBWc3leRM9e3faN2f9vyGOFAQ/CFBkVynizyHBMogJsCu3W7Jz?=
 =?us-ascii?Q?GGtJA3WHMuZEtVdQWVLJsur0xmpeOr4gmZp6ROxD7LXomnM3XRIXwtHyY207?=
 =?us-ascii?Q?ZZPnMn2ptVsfeqinRn7q9OOlYAwxyII2b/xwH8hgZD8xo12Jb8cxjE6Kwq3+?=
 =?us-ascii?Q?vh2zoc9lnDw/C2QuDRAOgrkO7rhUVLsKRqXqX+Qh9eQap3JzOhj8HupNzxTa?=
 =?us-ascii?Q?zC95yofdsmnrEI/7MpW9ASdFLRxvyt75EsiLTvnFJg1iWvHrv2Rqjjur4Q7I?=
 =?us-ascii?Q?dpcwzGqGMyAxnwmWnFprT1KMRixwA9oKelQ7SHt6BoJlNBS8vVV7LD6vZ5Xc?=
 =?us-ascii?Q?hEVaWTgDg0+JAmdsmPxLidBGGQ3vhfqA+SF4cW7eTQwxj1fTDdZZRNyl+HB+?=
 =?us-ascii?Q?Ds63aKFt3MNeTDMlBO4yoSwXNWJdlygwT1D7ff9flClv1lky9DhIiBRdrS1f?=
 =?us-ascii?Q?NzA65tlzhFkzucDKTU1p4rGweq1QhhrhVd/A0u5P+xinLlAo2IzEtw+NFkMk?=
 =?us-ascii?Q?AHdPbYzAhU9+ijl5nowZWJ3hKkJPm1A9xa6W5ZAyKXdw7YEKuI9NeVygJm8t?=
 =?us-ascii?Q?mDicoG3dYgeMHfNqMP8eGsvOH320ka73BA1j4WlbVmsb1HhREx3TL6tbfKjo?=
 =?us-ascii?Q?sJA3UNPXF3SOF/qs02qH2dZ08F58qfJbcIZxUa6Yvpy2nDk78EBFWw77vq4/?=
 =?us-ascii?Q?WPK8Oeu4psUayFscc1M+DuqIoznKYTQnyiLW+3vPk6nBWuONSPmfBCw1yzDH?=
 =?us-ascii?Q?ugnOLRu8XV3Kg99ghnusblnuvZKzHcVxFhVR2a3tpM19Y1NuaLrgU1WpQeac?=
 =?us-ascii?Q?qsPZtV70goXFAGk5Ou3HwrurryQFylScCV/58GrYFhZu1qjh38QYdUhXScNz?=
 =?us-ascii?Q?SN8HSNT8LhLuEOkQ4cSQrLYUYR6ktXCdd84TOhm6lK7kHMGRuFEg9X2N/4bq?=
 =?us-ascii?Q?Utr/Si9/o0WISEDb6wCJVdjOrzmXhcZo+97QCmEfRwND7226qn/Lnd4pKH2e?=
 =?us-ascii?Q?0dL7LKyFJcoX6xS4Xes4psQhwItdpo/F/MsecVvu5k1FfA0haM3QqlK0wVdf?=
 =?us-ascii?Q?Ko7aHjUs7p8RbdJXTFKuuxtxizfKrStNWzVIqPB1WPNkkFMidHsjh0KFLt6x?=
 =?us-ascii?Q?uBzgJpgTzyup4snmKUAnuEfMjXNtl1PZpyejDN9eqvltV/VbOUE3L8cOF1WR?=
 =?us-ascii?Q?FHxVOou3BMkO4j4GuHR0JB3JORPsp4YgS/JR9D6tCWiyL7DWB2irCpzlhHx5?=
 =?us-ascii?Q?rW+dq8sUG1H19ahUYkfIlRU/Pk84W5J82ypgbkslRtoQxhmNaA1WteNHsiF1?=
 =?us-ascii?Q?fslmcuTgRSpHYbcyvnLp5dtmkxe+Yp7EU16/T5/b/98dsq6XGhb5/oaCC05m?=
 =?us-ascii?Q?u27UMWGnppImsNGCJ44jMQyt3gfXtaMYuJXbqdiuyGq/+8ZahNA4SxDA9fsC?=
 =?us-ascii?Q?Bc3v9KEpz1YSNQXSjZQbeWcGi1ZxoeIjNFe3noohmIKUTiE6TdlqdVj0BGhQ?=
 =?us-ascii?Q?C+BdYT2jUBsGb4wY9kjjSivE+nNMW6HSNuetne0k6nCLyrunCNc6+kFrUdIZ?=
 =?us-ascii?Q?hEW/OtvkfdcHBfqIrB72AYzWaYJ/vT1k2KgmJPrDigzTUXuCWd5yWK+kF4w2?=
 =?us-ascii?Q?XN+lUUSJXQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37cc3b99-d01b-4e57-3d09-08da20ef5aaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2022 03:56:01.5803
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5+sunmD7zGJYaos7ltqv8GTvcTU1f8GPgxEmLF9pan6mShJrlsUL0v5xuCyIJTeST5f9RmrMZhRn8K7d1FkzcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1536
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, April 16, 2022 9:33 AM
>=20
> On Sat, Apr 16, 2022 at 12:00:12AM +0000, Tian, Kevin wrote:
> > You probably remember there is one additional requirement when
> > adding ENQCMD virtualization on Intel platform. KVM is required to
> > setup a guest PASID to host PASID translation table in CPU vmcs
> > structure to support ENQCMD in the guest. Following above direction
> > I suppose KVM will provide a new interface to allow user pass in
> >  [devfd, iommufd, guest_pasid] and then call a new vfio ops e.g.
> > vfio_file_translate_guest_pasid(dev_file, iommufd, gpasid) to
> > retrieve the host pasid. This sounds correct in concept as iommufd
> > only knows host pasid and any g->h information is managed by
> > vfio device driver.
>=20
> I think there is no direct linkage of KVM to iommufd or VFIO for
> ENQCMD.
>=20
> The security nature of KVM is that the VM world should never have more
> privilege than the hypervisor process running the KVM.

Indeed.

>=20
> Therefore, when VM does a vENQCMD it must be equviliant to a physical
> ENQCMD that the KVM process could already execute anyhow. Yes, Intel
> wired ENQCMD to a single PASID, but we could imagine a system call
> that allowed the process to change the PASID that ENQCMD uses from an
> authorized list of PASIDs that the process has access to.

Yes, this makes more sense in concept. Just one note that for vENQCMD
guest changes PASID via xsave/xrstor which is not trapped thus we don't
need such change-PASID syscall in practice. The kernel just need maintain
a list of authorized PASIDs and setup the PASID translation structure=20
properly in CPU. Then the guest is allowed to access any PASID authorized
and translated by the CPU.=20

>=20
> So, the linkage from iommufd is indirect. When iommufd does whatever
> to install a PASID in the process's ENQCMD authorization table KVM can
> be instructed to link that PASID inside the ENQCMD to a vPASID in the
> VM.
>=20
> As long as the PASID is in the process table KVM can allow the VM to
> use it.
>=20
> And it explains how userspace can actually use ENQCMD in a VFIO
> scenario with iommufd, where obviously it needs to be in direct
> control of what PASID ENQCMD generates and not be tied only to the
> PASID associated with the mm_struct.
>=20

This reminds me back to the previous ioasid_set concept introduced
by Jacob [1]. Let's ignore the implementation detail for a while as lots
of logic there don't hold now given the progress of iommufd. But just
very high level concept-wise:

- Each mm is associated with a set of authorized PASIDs (ioasid_set);
- VFIO driver provides a uAPI for userspace to attach a guest virtual
  PASID (vPASID) to a hw page table in iommufd. In the uAPI:
    - a physical PASID (pPASID) is allocated and added to mm's ioasid_set;
    - the pPASID is used to actually attach to the hw page table;
    - the pPASID is returned to userspace upon successful attach;
- KVM provides a uAPI for userspace to map/unmap vPASID to pPASID
  in CPU PASID translation structure. User-provided pPASID must be
  found in mm->ioasid_set;

In this case the linkage from vfio/iommufd does be indirect.

My earlier reply was probably based on a wrong memory that the
entire ioasid_set concept was killed when the lengthy discussion
in [1] led to the debut of iommufd.

Thanks
Kevin

[1] https://lore.kernel.org/all/1614463286-97618-1-git-send-email-jacob.jun=
.pan@linux.intel.com/
