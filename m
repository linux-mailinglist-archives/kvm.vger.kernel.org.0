Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994FD6A2F64
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 13:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBZMUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 07:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBZMUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 07:20:50 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7197D12BCB;
        Sun, 26 Feb 2023 04:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677414049; x=1708950049;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DBz7Ir9Z4Fc9WkE5oDt5zOwNaZ2EyqyS3CPl2PSxp9E=;
  b=PA4XVk2pZXvnBiBTGy1dl1XUQFSIZdYrpXsl3VVU/Wtu75IzMNOQ0+9Z
   qrJm8mIBF+HWqE2CIdJZpaydjuhXUsDXevMODSmtNzM2LYq7RvhQkbN5M
   bMYDMcdsxLG/zsavo7G56n7qeMQGGdCQTgehl5S8Yjg/XlxSEMZl54E/z
   N3W8ZQbTOhUi49ovGTdd3U5ReZ0xyGS+dOmOhX6zqw48SENNo7qmlrtpU
   QN5g4Fv0rTOJRNDOB+RCgBGeCdtJFTE+vksmMYkUFHgpgDFAVdpErX48z
   iY9yCq6iakCtUxZ3q3wOvTFo6Ae2iNih8PF2iBFx+BNCiCv5y8zy0m/gz
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10632"; a="317508142"
X-IronPort-AV: E=Sophos;i="5.97,329,1669104000"; 
   d="scan'208";a="317508142"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2023 04:20:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10632"; a="737332298"
X-IronPort-AV: E=Sophos;i="5.97,329,1669104000"; 
   d="scan'208";a="737332298"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 26 Feb 2023 04:20:48 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 26 Feb 2023 04:20:47 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 26 Feb 2023 04:20:47 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 26 Feb 2023 04:20:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TX+mbxMChfgZDunjqBsTa4syLkoCLoMjf1kJy1jOTK9uVzdODN4+fl5fHLs7Wgqt3Eu9QynxrEEX7O3MSsD7XYOfIWYf0mCp6FDldnZlXCWQ7FO2wLEo0Q2q6IeAF7zzdXjxJv5DZKZLBxRc9wh+9Vocd3p6mrDeI2KUUlrCcoXix+3MckUkOWeB+3u5kunZZCNzfZZe0psK0qdr+qAPAe9q0Gwetb3+e5yrrTYjM0ZNSBWpXohLMmakA1zB9m1y7UBXLWr9A3w3v+DW/+/8DV6ORjt49g0z2RA76FzcTgiDRKnTKg+FJ3ttwN1GFppEwLZ7sV/iuVpcr9MXobwSVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tqhxuR0l7IgkTyZyAC4ZsOiaiS/osCr7zV2RZJh3ADs=;
 b=hdE2ec/fuBWcObc7br4O8IaSQt4bvtLhSI46vCy/7+LJY5uzICkC6X5SKedqFqWHxb9ubCY6ChDkmtan/vJMbvDUklXYVsNasQz2wxKasVMMeRsA0nCCXvXeSdf8qvK6a+tJ4DQNucoI0E3lSPMcbSeGRePJiSP/H5hjXqCV4weITcbz6vXCLqbS/WNZL9WJan9eaPw2Id8KAecfK7IcsD6et+JadIFggzjFiOrpCGZfibUe7b82BXnqWp+ixJPf447Ju4X7209yJCQNKc6IS4lDFPtmmzUUksMSlHVEIWHegZN9FWxD7yxpgS5wMEDy4PV8RW1cGzIb2D525g0bJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6217.namprd11.prod.outlook.com (2603:10b6:208:3eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sun, 26 Feb
 2023 12:20:45 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%9]) with mapi id 15.20.6134.025; Sun, 26 Feb 2023
 12:20:45 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v4 03/19] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Topic: [PATCH v4 03/19] vfio: Accept vfio device file in the driver
 facing kAPI
Thread-Index: AQHZRadeKhL9Vt84SE2fPL2W6D6IC67aj6SAgAaed5A=
Date:   Sun, 26 Feb 2023 12:20:44 +0000
Message-ID: <DS0PR11MB75293AD7BFC94181CC9EF2B9C3AE9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-4-yi.l.liu@intel.com>
 <BL1PR11MB52717F02174B24EFE1674B238CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
In-Reply-To: <BL1PR11MB52717F02174B24EFE1674B238CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6217:EE_
x-ms-office365-filtering-correlation-id: 8737d54a-9639-4e50-7a1e-08db17f3e294
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GfOpJvSaWadZ0ijYyYzAv91HV3tK3MnsvWqrhFo3b6cxixTWpKaPjv4yP2n7+OZqntl8b/putHz2OvcoaHaPtdR8h0f+YaU48KVntwT2/x5A6FzzO8YNVGb9JKfYRgFc4zUuRw+n2D0OzbS2GbwkbCeNGPZR9ranmP8TRtaZD1GlIaaez2oPEUVU7kYbyxkrkkCldGhyZ61zVmRAhMpS1eW5pYg/a26J207Q+NZoY3RpLctOBmGn48f+Vxl2xdEs4Pvf3NogLd6GCsqgMz+Ws1n4M12UKVc+KJgcjQzQXyl6xXsy6Jxu8ZE1sM74TnX2JTe18neFiAXx4FGYiGwQ6rSxWks2yTDDbRzotnabaPDjVGDTZHP5rtgK0Wn5e7SKeCYXssLoHlEYHKxR/EDKrKet5gcjO5LFKXSP+kv94JytVb9rGIPSn+AKzqSfJV59a/IEttfSlkVsHQPkbeJKXK5XYN2DJZmig5uK834ci1S0FlsdrBEt5EZUDerg+8T5IV4bR+bkoK7piZ/jdBnI92T6uNjyVi3BJDrC9k6ZVHChDEnnnkgevPEDZRuD1oefCaTTmHsECZIA+M3On0ACWJfdCqfoh4dYkr6YxR3s2pDGRZCo8BsPSXexThN3v/lHcAsVVpov0lV2ICYoQXzQdeHEuty2EZGQLAjBb2V4R+XV4KDrHuR5irqhiQqsbzxwv5Zhu2RcGj88i84mU8isU11Dn6I0cUI8MvPOmgk4mMY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199018)(9686003)(38100700002)(82960400001)(38070700005)(122000001)(52536014)(66946007)(41300700001)(76116006)(66446008)(66556008)(8936002)(8676002)(7416002)(6506007)(66476007)(4326008)(2906002)(5660300002)(4744005)(71200400001)(7696005)(55016003)(478600001)(64756008)(186003)(26005)(316002)(33656002)(86362001)(54906003)(110136005)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SV/N7PZ6A9NrvZgBiLfVxKS9jLiluo4GuwMGgrTsi7fKyFcFSDr23SmacPTV?=
 =?us-ascii?Q?w5rCSzU799wccMymPqyqHWDG3PznOEFcqKvrN1SA72zpbixXh99osCoNKzVW?=
 =?us-ascii?Q?GfrlY1OhlKkrXopE1nek9Z9n36LyaiQ+hDEVdMwWDqTNrkjh+j/ulZz0lHaD?=
 =?us-ascii?Q?/zBz63SnNYNzf79fMVsjo/7LKxrrkqpKkGM+/GW9dC7hRO4GUzk8SWJyG7jZ?=
 =?us-ascii?Q?uA1tERBVyy/F31jMDe6eP0xBi8GgXYZ5tSOZdxoS3PJuj45RNRJAd1aNkv7j?=
 =?us-ascii?Q?0gnkwqi/uf99AWvSSQo9b3liEDkJXjYATeFrm7BG4wVil0qBmSDos3GMXOtN?=
 =?us-ascii?Q?Eg5vtQez7uMULU+6R1Gn/g9yOd/ugLKyVKyqR8CFUw6YaCc/bNfGVAPWVuG6?=
 =?us-ascii?Q?ANdbu6njB/Hh7mdhbDnp6Muf02EGf4EVThsGjgMwQpHndoJnC7yZkC54bT24?=
 =?us-ascii?Q?l3A3/2mWt/FeIDFozuK6x4SAIFjImEnTcNFNnwFN72gmyHR6+OdsCVQNvmNc?=
 =?us-ascii?Q?m1VaP99LByJEyWetDBNSSERrxbeoIDj6duxWVmncZSIVkK7c+1tTq6x0BNcO?=
 =?us-ascii?Q?cRs+ykjdKdreW/rnwGkcp5Vr2qo9E1ok4XhLLmQZDREEeNFu0exy3QCCUk6W?=
 =?us-ascii?Q?dTcZqgOk+hv4lj0OeS/+8MNs686Y6a999eDGr+Ct1uP4uFrGaExI/6XJnRmE?=
 =?us-ascii?Q?c4+YZs1gJblMw0wxPVPbVB1CpPOJsNoHNm5ATdbf3z75nzGD5pmlyVgzYP91?=
 =?us-ascii?Q?JUcVeO5Fl3HkCAhy2qMxfjKuAMMF3NhT3oU2J9q30mk5r0Q96xoKyXcxncxs?=
 =?us-ascii?Q?ezViXvWp0H07w9f4vNiaGQw/3oWMLOaZPsZ/LbfCfjt/8V2S5CGbp1D5ZPgu?=
 =?us-ascii?Q?qfAvMbJZd3Lxx7SWOAl4UYm0pidt6GGdAHUX56gkY7GibC659jZrYYsp/qep?=
 =?us-ascii?Q?GogY8i/LE652c+V0NDBe5WzsHtlHHatEmZlCKRSea1Cb2rMwdVaCyHw4f2eQ?=
 =?us-ascii?Q?s6kzjtuTogdeVhDW1oVftr1GTWzbDYcMkt3s2FkrjeH+nDErycj4DFexZlaJ?=
 =?us-ascii?Q?/scN3Dzccs2FgI75WZskWMaYZHAzx7JHm1QT6rwINfg2qZD9CyXxdz7d4PFG?=
 =?us-ascii?Q?r70Sjs0vFVllrHxDI7u/hIQb+H1L9lC8lT0/kl3+uUhEuIksmTVcDQAoIFzm?=
 =?us-ascii?Q?Yed/zcNUT6ECmwZfdJxlHi/v0oe3bBAv1NYHXClF86SBucx+PXQIycWkaeF/?=
 =?us-ascii?Q?zRR7P8vRVEHCQDsRKifu9oWUnbQ44pLc3BZu65RheDtRfKe8e0/TbzGBLCiz?=
 =?us-ascii?Q?ub8eNibavdnRSh7jCoW3jEckryuRb/3YsS9uo7UvEjW/NDsImDVK01MR5xnd?=
 =?us-ascii?Q?UVGmG07xZ9b9PM4F+DYP7DHLNkiOeupYWZzM80lYgdeF+R3YrEhyGzUITGMi?=
 =?us-ascii?Q?YwhNwkg8GaD82P7GeonTSiW5GTLBd5hKB0jR9ea7XFavGsLtRpECgbogMiy5?=
 =?us-ascii?Q?zKirQVy+7y9/PWdZJ1pj52eWuIX2IEaQVeogluvAnVTDLUkLWQSskEkMPx85?=
 =?us-ascii?Q?RPJtURyU9dsw+7M+Rhqnsh9kFUzd0Dz9UGAwJ1h0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8737d54a-9639-4e50-7a1e-08db17f3e294
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2023 12:20:44.8461
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /qp6fA/8McExyoSH7DNSXLlkTWAcOonb0hLG+nDc8WGnnrNhMAy/KUhbU13E8q4/fDu6DOOGR3PX0oNjuUxdIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6217
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Wednesday, February 22, 2023 3:16 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Tuesday, February 21, 2023 11:48 AM
> >
> >  /**
> >   * vfio_file_is_valid - True if the file is valid vfio file
> >   * @file: VFIO group file or VFIO device file
> >   */
> >  bool vfio_file_is_valid(struct file *file)
> >  {
> > -	return vfio_group_from_file(file);
> > +	return vfio_group_from_file(file) ||
> > +	       vfio_device_from_file(file);
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_file_is_valid);
>=20
> Following previous Alex's comment I'd leave pci hot reset path
> to continue calling vfio_file_is_group() at this point so the uAPI
> semantics is not changed here before patch 9 comes to properly
> handle device fd in that path.

Done.
