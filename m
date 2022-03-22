Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0F24E36C6
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 03:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235554AbiCVClw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 22:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235538AbiCVClv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 22:41:51 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF09140F4
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 19:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647916825; x=1679452825;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EDV0X0oVmqEFB59yLp0u21fIAnL9fPhPqRAig7Lc8ko=;
  b=B18OnktUOidN7iI1Hzzl6hGFaNZHmM1jOzdU9l/4dRMR7XuF7AKYGdin
   Lcvp90rST9SjczahaI8btnIJyk5er58r3SrkWyf7Dv4Dt047XeF/WqIHc
   NC4mPTHGGP6qhhlOcgyVf9Hiu+3aDAcb0tzWSghtBzoiSbqeAWlCGRWKU
   232A8FsWZP2UXuy8deOdl5TiMLznAvKl2+/NGcAzaLrE6j4uOxrcSsQ+9
   KIMWPqut5Tfw/EqP7CoJYPxYmoO5kWvTKui9z03BNa7cmPqp4uPrprpyZ
   WGEYRh55TDtiZkaBEkOe9P5+Ds3eNuKxTmUttiP8c3CEsH0J/NirBdM7J
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10293"; a="245178420"
X-IronPort-AV: E=Sophos;i="5.90,200,1643702400"; 
   d="scan'208";a="245178420"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 19:40:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,200,1643702400"; 
   d="scan'208";a="785215517"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga006.fm.intel.com with ESMTP; 21 Mar 2022 19:40:24 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Mar 2022 19:40:24 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Mon, 21 Mar 2022 19:40:24 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 21 Mar 2022 19:40:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HoZDFYVVhjLCHkmhp5mGefUuG/cxQ6ShBox0U0UMiUJWDKrJ1/q2EG18boYyjeg5Qvj1HYtAB93iv05M9Ea5q3K+KOVDrMlaTaQH24h1maHtj3CjopAyQwavr2BQDJqWu0pDbvNlEvyN8HtDQiAt/aLckLflQEuwHNeaWMYizKGirElb+OjaAf5/xyCr9uglgRMX7gHKAy7ZZBtPpfww9xCoJrNOp63DwitYs1bTilrGy+eVoJx0D0+DNDB1Ts7AXeW2oafc1FtZ1YGka9hh+ruOelYjAYobP1ZriLQpXK+cRT3PI4LjwmiM77x7k4LN7gcm2bWDEN4apfHUl0SZUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EDV0X0oVmqEFB59yLp0u21fIAnL9fPhPqRAig7Lc8ko=;
 b=VyIIENNSyDIGdD+VA8ZPzMGpbvF6wvGcdkN8BAjR+MjuIrVgcAwLjzJhPndTNVklW8z825VNqIt/7r7I2/DIEArqx0oVQR3IGahiwn480c4E0NhJnqjX1iPBnVdQExzX9VK/+oOyxk5lvMZGEnp1CdYAhhzP5ar1zFh4r0AgyiFNhuM68yRrp73FJwYbQOiYeaaU0R/j2Ek7QQTu6EtgmEeGeTgGSaNagPuYuqt6vCLYBl48c0sGrXH4f24+Bp30EF+HJ0AUD3NuqiN0NsQJdEK3ztblrbj+fXZez5QAEROqAAz6GLDtTJGba6BtXIa10J0y152XEuILBWouzJhd4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN6PR11MB3133.namprd11.prod.outlook.com (2603:10b6:805:d2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Tue, 22 Mar
 2022 02:40:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4df7:2fc6:c7cf:ffa0%4]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 02:40:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Thanos Makatos <thanos.makatos@nutanix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "John Levon" <john.levon@nutanix.com>,
        "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Eric Auger" <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: iommufd dirty page logging overview
Thread-Topic: iommufd dirty page logging overview
Thread-Index: Adg5jKKwvNkxolKnRPWJ5nYfZVngmwABAPgAAEWHdcAAB6sPAAAoLtSwAABPxRAAJv8uwABJHyGAABh+9yA=
Date:   Tue, 22 Mar 2022 02:40:20 +0000
Message-ID: <BN9PR11MB52762EA6B54F35F63A0535458C179@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <DM8PR02MB80050C48AF03C8772EB5988F8B119@DM8PR02MB8005.namprd02.prod.outlook.com>
 <20220316235044.GA388745@nvidia.com>
 <BN9PR11MB52765646E6837CE3BF5979988C139@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220318124108.GF11336@nvidia.com>
 <BN9PR11MB5276CF40E2B50782FC20275F8C159@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220321133055.GT11336@nvidia.com>
In-Reply-To: <20220321133055.GT11336@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd3f3fb1-9116-4c03-e526-08da0bad4f1a
x-ms-traffictypediagnostic: SN6PR11MB3133:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SN6PR11MB3133282D7B3FF2D01F9E57668C179@SN6PR11MB3133.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /OXOuhQ5EyFHKngVNbNMBpzthAG8njOLVrmO3FpO7vvPrRVWAJS2H62LHxsv2w9/si+VqJFhsv+WWmRkQi4aVX1LUznPb2k4rLkftQmNsGRseL/ktniqKJzQOkGNuOg2wXTls4rSwZVpO7szS0f+JyrUdfMnZ+1ZTeiiZwn/f7yC7qzUn+6DTqvds+zFbELmwSmoO93i8rSxfLoMCalFUx20PKplNS0KFTZ1K7z26RiLL8xpkty5Bs7cj+jVoG3gtvShEQqMABIR8dnw0G0mwk4Sn3SZrTG8Lpic5pF5jLwPIGQnVW+tChqDkErFNEdqL6SEdah8s6YfYRzjgCoXNxLcCoKh1hm7K91xvXJrn58G6hUKP3g7fXwT77ya0w49jMePvYWPJEJi+b14k/TVnGBgxjHYu70h0KVGtBjPnP5lyLDFT7cNA3QXVCnyR8Ip3Wygp2JP/hcbb9iq6qHudbVVdaMs7UqFEepbWtf331KtLuOdC1ioMMcsDa2hCdF97ma7Wza7djO++SO3Yrj8Kwc2K6vTkqsz8DcDClMUMxy5uh9VniYDIlwHInSVmlx8ECGi0i3lnU0ECYwK9kWlkIZdYDgQvonoaGo/XQYOeEDawUUizyqOJl0iaa1QZS6V8UqVPnOv8xrxoTqR+XVqzjqycP7PKVQTDZ2CerNuRPNcN3dVBBzYPeUW8ID60Wo3uUL9hRbEBMzH9K7VZteJFs6z9gPtVBgOZ99wtFVXOE0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(55016003)(186003)(26005)(33656002)(107886003)(2906002)(66446008)(6506007)(6916009)(38070700005)(7696005)(122000001)(7416002)(52536014)(8936002)(4326008)(76116006)(82960400001)(9686003)(316002)(508600001)(71200400001)(66946007)(66476007)(66556008)(54906003)(8676002)(64756008)(86362001)(5660300002)(38100700002)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4MedO71raBwonDEIze+n+m7OPVnfiscPFHtdOV4qR+WAQMu+VDKvXG+TvxkJ?=
 =?us-ascii?Q?GXDUlxJn5ALu73tdK/1eLtX+syN+YDQEa5T2IhFF78/oK18a1UDM2HBQMgv8?=
 =?us-ascii?Q?Z0fTkZ+nlwLjzwoz8DSeDdRbrDVMLYd0mvYh2ZQvbHcgGe697dFrl8d8flrm?=
 =?us-ascii?Q?opy3iJW9CPU097WF+8F/LcNr3S89VycCZYP9loatoIVlHaXIfAJNrFDgOZ3D?=
 =?us-ascii?Q?5XfgRoVdM/LX1kARFJLxZ5u1TbQ0Wga0u0WOy6zmZlWMmiGxVBSpHBfmhHGp?=
 =?us-ascii?Q?nN0Ei7uiwt8pCPwMl+V4Fdph0i+Csrzu+jbFB2Kn0oeQ0zIGEobmdI2CWmv7?=
 =?us-ascii?Q?lEUR8I4r7hbjTYjTiJLr0HuDnWePFZ0JE9IgrX9juSAlLIuVmsydCx/KzgRI?=
 =?us-ascii?Q?CbaW8DW7/zL/4xEcH51tUZmlodHAwNV35yI9MTTj+HDKj2hLWS6fBv2olPzI?=
 =?us-ascii?Q?Aqr/avHz0tTN36wrXm+2P+kS2mtZq4ANmtKWR3GL5j7dX+r1ZDvs/1nfL26L?=
 =?us-ascii?Q?GpdwPx8UPoJ1efFHeXKz3UJ3PSTcrg7a+4QL5mJhs0MMtCSWqeOonF+EItbL?=
 =?us-ascii?Q?D+PphWHMk3jaH3yq5YEpo2GUqf594vgpiirMJolmjN5UuqK77ux5lxPcGWa3?=
 =?us-ascii?Q?KzErBbIy9zAeLtFGT72zIGokbbRkTtLgNiXvS+BR9kDz0hCfYyFP2X+7m6Iw?=
 =?us-ascii?Q?AL+qfG4Y/md/bfAkzUCKc3nqakLSq6qzvk3UEOD2XOYdCaSQuykinSPdpOF+?=
 =?us-ascii?Q?sk/LjTvX5au6BsMZGqqEKd/BLo6V0Pd/MG1ompgmCPCzEtAL3GrBCu9wutor?=
 =?us-ascii?Q?FQRpFUN6WOxgvS8fC8S7+EPMbLJqKZxCVEauXh/iYTB4/UeOhZhRFIWNPbIu?=
 =?us-ascii?Q?aAB4luoBMU0zcltjhmX3/WXge74/l/N7n59XGMAyHTwwJHgAMBV7gDiPa3PU?=
 =?us-ascii?Q?pXUsxo9Nm1QeIsOBY3AW6OXOfIJO+bnCqTINtTziy8Jm087kIViVGqYUt6la?=
 =?us-ascii?Q?p96JexdUsF29/mueEJkafViaFi1c/IEWMPNkmgtlq8HE7N7SVlq1DzjxSk4g?=
 =?us-ascii?Q?xAv89WIRIQtajKaNCxq8hLY7sbmg+xEeIk0c0ql+4PLWwnx7DEcXMoEMRJCm?=
 =?us-ascii?Q?CFHcOhUiTUVpOfvNOq1AXFQKQ+2MgSLuWygyzggdWA/p8z5gVUuzQvTqKYSQ?=
 =?us-ascii?Q?1ZUq0KMW06/0GxjMO7tFJXADhcOtNpMdOgdmSaBwrhDoOZ7+ATVYWxljU3wE?=
 =?us-ascii?Q?jvoNIHtU7Dd9ZUwgJ8uiBhrus86p5iVAA80vsd8Vl2s7B7VgZVYtK7DqcmWI?=
 =?us-ascii?Q?vv89Li6VGSHM7afV/ZYUAdxT3NY8act0ivwGFo9O9Ecj7ZeTdZuF+BGoHrfY?=
 =?us-ascii?Q?J/j4San/FUJBj++QLfM7TOa55yQkFLM6Oq8uEX/t898iKRAuB3HpgEhMd52Y?=
 =?us-ascii?Q?Tb7FFoQncqNuhOW5fTbsQKkTdX6SK793?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd3f3fb1-9116-4c03-e526-08da0bad4f1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 02:40:20.9673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ism1RfGmtWaYaPKrGMC6a4rYANJmsIaua9aOH42Z7cgn3iCYAqOS1lYj5ZvhN5C/MVVEd/IzPe+Kk+VkuMyIcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3133
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, March 21, 2022 9:31 PM
>=20
> On Sun, Mar 20, 2022 at 03:34:30AM +0000, Tian, Kevin wrote:
>=20
> > Thinking more the real problem is not related to *before* vs. *after*
> > thing. :/ If Qemu itself doesn't maintain a virtual iotlb
>=20
> It has to be after because only unmap guarentees that DMA is
> completely stopped.

In concept, yes.

In reality probably no sw-visible difference. A sane driver doing unmap is
expected to stop the source (i.e. the device) use of the unmapped buffer
first and then clear the iommu mapping. Once the former is completed=20
the dirty bitmap of a given range won't change before and after the unmap.

In case of a driver bug which fails to stop the device use in the first pla=
ce,
losing the dirty bits across the unmap doesn't sound a problem as the user
cannot expect a deterministic behavior in such scenario anyway.

But I didn't intend to advocate 'before' as there is no value of doing so
and 'after' is conceptually correct per your explanation.

>=20
> qemu must ensure it doesn't change the user VA to GPA mapping between
> unmap and device fetch dirty, or install something else into that
> IOVA.
>=20
> Yes the physical PFNs can be shuffled around by the kernel due to the
> lost page pin, but the logical dirty is really attached to qemu's
> process VA (HVA), not the physical PFN.
>=20
> It has to do this in all cases regardless of device or not - when it
> unmaps the IOVA it must know what HVA it put there and translate the
> dirties to that bitmap.
>=20
> > given guest mappings for dirtied GIOVAs in the unmapped range
> > already disappear at that point thus the path to find GIOVA->GPA->HVA
> > is just broken.
>=20
> qemu has to keep track of how IOVAs translate to HVAs - maybe we could
> have the kernel return the HVA during unmap as well, it already stores
> it, but this has some complications..

Qemu has such information. The key, as you said, is that Qemu shouldn't
destroy that information before dirty bitmap is translated.

>=20
> Fundamentally from a qemu perspective it is translating everything to
> UVA because UVA is what the live migration machinery uses.
>=20
> But this is all qemu problems and doesn't really help inform the
> kernel API..
>=20

Yes, and this is the merit of hw nesting and IOMMU dirty bits. Otherwise
Qemu has to pay the burden of maintaining a copy of guest page table
besides the shadow one maintained in the kernel.

Thanks
Kevin
