Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3973B634CE0
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 02:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbiKWBVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 20:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbiKWBVg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 20:21:36 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41E623B
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 17:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669166495; x=1700702495;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bC4Qb/i/C8qQCNCl60Mr3W1fibRkjLztIO3EvlJ4S6M=;
  b=HGjKVxRxnxzswDy0Kb94L+T0vr0RaSoLLR6+RU4qpXNWukTrxXrNMKpU
   Tb+VN4KlBWLHoDdV4LBDj2nuJ+pphaaGuIctTzMJ0asv1XQk3WE4xEoC6
   MemhlVLUi3gHz2jGMX8uwhEuLE7fczWgxlTjetBZUNQJiuXI/SYqlBp+s
   Fro4FtLYeSrFX6KZqJwhcp8ZgAFc1DLUHNPNtW/0b9J0PV5PNF3/zbo+u
   MjtUMlDj/yRxOZ+aG9Do3f1PL0bXSKPM/tsOiqxwRYlNTBIGoZzeTQUuR
   GAXyJsxuzIIzyEOVmxf3y7avXDFAPa4TLe8cs+hEeLcgr2pKTSVy33nHw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="315776077"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="315776077"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 17:21:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="730607514"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="730607514"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Nov 2022 17:21:34 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 17:21:34 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 17:21:34 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 17:21:34 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 17:21:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l9uS48c06wkVo7MM7Y+LycQ0zzxKBxqR4pqkY6CoznOR0mXYX2Yq2v8jahrYEGiWzmOH8Ij3KzwoRDX+Mm4RYasTmkFdQBCwlfhPYwQcmfiGejURe8v2IxH2zks3nXobY+4t8Cq0Gz3zns3opg2qH+bJVDgGc+SrTRtb/M5k0CYNVvtDo+fYXQyC34YNoO1Y+nNP7LYtvtbAMCW0y2EYMuv4ENPE3FqblGbVPHfezxaj+uVJLCiRwjhIeX761JM1OKtfs1tnMQtUdwMSl34O8lp3bj/BEOUIwmiaT/RfZGJ/6EKAcOetPaDIsVaC40e4h2l0soqTfcoLB00rC9miig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ao+x6Ig5yAykSu/r4f8OFOqufeS2CE58rOZc9Nl6+A=;
 b=X5uO+9Vto7KUFnvOI0wFAcukF4y53iMoIp8a1868bF11nu1Vm4C7HkUuq+bkSa4aS7lTbJtiES4uburPJ40gpsp4zm35M/KETeOK/HOjjxqzOXvN79jTPXRqZX6R9auuwX8TzMUOrVBTgKknF8GAusKCdcWIbuPgdLd5pKYY9xYqFDC0SbkLSFUPySMnxR73OvYNgxrGliNk3Nou2o/CUXZE/eYNKa3m63TgwNeOMssX7KlQUMp31W8WaPY4eXhJXNiLSTulo09viVqIQmc+JuisfSx7BZ+n0DYq8uNMtoLxzb3wkqvXxqps2U7YSXo90fMC9nEhxno9EZlFFEj0fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7688.namprd11.prod.outlook.com (2603:10b6:930:75::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 01:21:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%9]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 01:21:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yang, Lixiao" <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "He, Yu" <yu.he@intel.com>
Subject: RE: [PATCH v3 04/11] vfio: Move storage of allow_unsafe_interrupts to
 vfio_main.c
Thread-Topic: [PATCH v3 04/11] vfio: Move storage of allow_unsafe_interrupts
 to vfio_main.c
Thread-Index: AQHY+gA1L/qNziGKzEi+LQz2iXoY7a5Djn6AgAFEfQCAAFP4AIAFEScAgAEFXgCAAAHQgIAAfwfg
Date:   Wed, 23 Nov 2022 01:21:30 +0000
Message-ID: <BN9PR11MB5276B441E6C1412CFE5BBA978C0C9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <4-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <20221117131451.7d884cdc.alex.williamson@redhat.com>
 <Y3embh+09Fqu26wJ@nvidia.com>
 <20221118133646.7c6421e7.alex.williamson@redhat.com>
 <Y3wtAPTqKJLxBRBg@nvidia.com>
 <20221122103456.7a97ac9b.alex.williamson@redhat.com>
 <Y30JxWOvo1oa2Y3y@nvidia.com>
In-Reply-To: <Y30JxWOvo1oa2Y3y@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7688:EE_
x-ms-office365-filtering-correlation-id: bae39873-3e7d-49bf-36bc-08daccf10d1f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v3FE+ZZFfMU/KIAuAG7u/cAIo5XNjJ7ex8w8Xctbgj/abBc6rxq1h2wl51ojDhxhhA6MZJBkYD7M0YAmaioN5qqPHZNM2KN7DKALagFsHnH1OnU6Q+pF+J+Wvn4X1Ho1RQARl/aJ9p2kJ1Cot8kJ4do84sSxciidDs1U8uXzcsQuTM9YW72xITciywuD9ZSDQ5KN4joyeL+qc7PYEOQIcsggsnwJ9yhs8q020Mhk9c1lBKkgU9xLQE43NRifQvOm2oVzZROp2gkrFWUvo4hNsFdpABSeZCzAHvmbpcS2Z7iZLe43TRcLiLuBa+tNf8nsfPVJYJLg68t0KgW1GZ/CuzfkMmpK6toQoFR25v8vQ8OsVkb3xZZGd1tXszLmSAZiUWBOekVZuB9XIsuU8FdNGh+VOKLnOzN8IY4UwjYtt6PZDHejl8rBHfWX4Whf8WB56F1PmuN2RWVhF5mcQ8ophxh+cwjbjVSlXkOlx7IaxaFJ6UgflxP+HNXue2/bt9tNjsStuvN7uSxCvDXdBZd9CPBxK3tn+CjcBN2UPfRWl1/qDMh0BTtpAyxRrpoGWd7yxwjVOJbCm6UnnBvkgNLvCclJw/DN7WlMAtlSb2VsIN93I2mcRmso4FrZFO5zrPQiuJ6KebBYl9tX/ryidGizNdQNzfdQyhBSZPfF2+56uuT8Q7RZx+xnw+rJtMZJ+dSel5QJ+OIgB1U5DWmjd2TN2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199015)(83380400001)(2906002)(38100700002)(122000001)(478600001)(26005)(41300700001)(82960400001)(7696005)(9686003)(71200400001)(6506007)(52536014)(38070700005)(33656002)(316002)(55016003)(5660300002)(186003)(4326008)(66446008)(66946007)(64756008)(66556008)(8676002)(86362001)(76116006)(66476007)(8936002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oB8bGwIBxWyZP8Pa4seqpFnZ8Em0CS2WOKAeoVq4D9r9ukNHEpDuJ5Xx66AH?=
 =?us-ascii?Q?sxYR50oQhgTt9d6916aEbLoX/li/cZTTMcLCyvrCImJSad6h2IqsCxDy9OoL?=
 =?us-ascii?Q?4SjqPX/jnVRF6DER/HQlBAtBHqpJio+R74K9SZiueQXxIqA6BxvGUZD0YA9o?=
 =?us-ascii?Q?1Bqcf/WZHUfRhtTeGwSsPqgFNZtGu41gO23/WgnW5Pcl9Kl9G4m7eknNRZn/?=
 =?us-ascii?Q?7xFc/y88EG3ry6a7GEifcH0yr8yU9mnRTTWteXxrXQk4rIachUpzhKiK1fMz?=
 =?us-ascii?Q?DWaYVUgfzbJCR54VZ26d3tY+ZWMM8Jf/QnMgbhetVSIgDvjD6ZGWi8WeGWa+?=
 =?us-ascii?Q?dEL6Y1vPqF4FY+gseCSpHcAvcJyxM3ThrkvmsxgGJMoWyja0p11qgquUStnw?=
 =?us-ascii?Q?kxLLlEGxtkBMHDj0fIhou6juKA4It4pAVwhIHMw5nqzekKARO8jbK37OSFvc?=
 =?us-ascii?Q?hyquYUCfXhbn15sjTRUaM+lCHOUR5TP0zQnGge9hopBYqXvkE6G8yGbg79H7?=
 =?us-ascii?Q?lA+bp4tOobSCKFWZk/4GI0qb/2IvHyTMMCN8Bw0fmabmpiK5kgqU09pEIHrT?=
 =?us-ascii?Q?mKRNsJhhPaECGXfV/fMfxWlCQ46BT6msU0Wh3zgggRs9ZB8TYYMpurQnE7yH?=
 =?us-ascii?Q?LBS2X8DDk0o61404qpgtuh90WtlHWKDnp7MA2XcV8oto/WS4+O6+EIlY+uDv?=
 =?us-ascii?Q?TroT4/HjH7gG0XsFMYwXrN0AdiBLHV3ATSvDNXNUP9qt9HY8NfeMasdEPF7F?=
 =?us-ascii?Q?4csU3GxFsdgf4uVhanQb2ec65ZdLVFpF1uWgDU8PI2xEkOsRk+0bCUqgc5fN?=
 =?us-ascii?Q?P47JFWCK+qGh4mBBVEXH8gWuX7oISinHBvi5aEybEXGKmIhgqnv1ppkz5XrV?=
 =?us-ascii?Q?dcjCUfUSSNyc285vNFGjdkviXsBPOsmuSVNDPapMSEpTOiTMouhD8oFaezSf?=
 =?us-ascii?Q?LiemWl55w8upX4qQ5HAIt2JGsk8Vjh3gJHo9UhitXIuKll7C/5GCzdrahKmR?=
 =?us-ascii?Q?Z+E5Bif/W1PnluqH+N2+xbagOKIcINaPbCV+oBMq8KKS/B470pLB9QwMq7z8?=
 =?us-ascii?Q?Xy2oJcoWUAInBp3h/7CRK6bXF7N5p41QtKjReHtHU+bPODXz71k5IrDb2Fz7?=
 =?us-ascii?Q?fFjfiZNW2bXc71pMLw0dZrFtVSLkIYx2hfT6i9hP/vk/uG41oOC4gMTQjIWR?=
 =?us-ascii?Q?iFoEg7UO41Xjep4D3qo/nR9JyLC4ZijDJFvDHczX0SGGNvfBm9VRXHosmz4b?=
 =?us-ascii?Q?oZE3HjyshCpxjD9nx9HicNA4f9QBIsB3euipeHYNHVuWd1u/Kae9DYBQ/1Ar?=
 =?us-ascii?Q?elQcA0bYsSK6/M8yiLxxrCyQc1p90fJXtSkq/uHThxIjTdLWqetPA9Aoaqj8?=
 =?us-ascii?Q?0zyCxBvqQYS7OAvEktKqKmSYPimulz5C4hSkrGYfE3EQzt/lMokJ1clDmLaL?=
 =?us-ascii?Q?u8zG7WLezK0eHz4BiOGjReQEP315eEbIxQAqyTGwbj4k/8Nd6l385RuybK2R?=
 =?us-ascii?Q?Q7ehYMs5A9HnFj6JNmObKT5fvhNVGB0EdQOjLxr/sOHXaxk4fO6LLs/e65gF?=
 =?us-ascii?Q?ohXtnSuRxjRd4YQXa03k+vQGvqokMgGK8+KgTkL8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bae39873-3e7d-49bf-36bc-08daccf10d1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 01:21:30.5368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pWhHNkn/CWSio9/FFu0tN7lDwpL85390QZIpfFM6+ZHNTMY+foX4DAagertX9yWrtQLJGqrZonHjHxWiGG7eLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7688
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, November 23, 2022 1:41 AM
>=20
> > BTW, what is the actual expected use case of passing an iommufd as a
> > vfio container?  I have doubts that it'd make sense to have QEMU look
> > for an iommufd in place of a vfio container for anything beyond yet
> > another means for early testing of iommufd.  Thanks,

One case is that the admin links /dev/vfio/vfio to /dev/iommu then all
legacy vfio applications are implicitly converted to use iommufd as vfio
container.

>=20
> I don't think there is one in production for qemu.
>=20
> For something like DPDK I can imagine replacing the open logic to use
> vfio device cdevs and iommufd, but keeping the rest of the logic the
> same so the FD looks and feels like a VFIO container. There is little
> value in replacing the VFIO map/unmap/etc ioctls with the IOMMUFD
> equivalents.
>=20

I'm not sure the value of entering this mixed world. I could envision
dpdk starting to add cdev/iommufd support when it wants to use
new features (pasid, iopf, etc.) which are available only via iommufd
native api. Before that point it just stays with full vfio legacy.
