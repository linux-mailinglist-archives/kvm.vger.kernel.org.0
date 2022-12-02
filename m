Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B6F64008C
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 07:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbiLBG0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 01:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiLBG0v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 01:26:51 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF785A457
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 22:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669962410; x=1701498410;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KPi5uGmxcMZIBda2tc0HvZ+abfwPRJ8JRCDPuV0c2Ks=;
  b=gEWvaebteY5l7jr6KqYt1e3BsfGc+T+GQvqPaHmMp1Vv+lQqOTmg18nM
   dvyfH6eniMDb0c0LtEGdp2bHKJl7yN1P00Rz2OMnTIfPFJG+qV4cwCY1C
   yq3K/DbBHvJPVZh6zJbg8XSeBU8xra0iwVzsOF/YipqaQIWuxpnesVam+
   aEq6hX7SKSoVIn/VnaESh/OJbdMxWFkTvd8XDzhdXTDtX2xuJVqkXdJyK
   I19V66qoazAAtLg2oMWmRU9IbYlF228V0y4qX4kBrYBQ/HV5Tj/Tfa1Oa
   pbV/Y4SU/dc5NtdTCAhLoSgBOFJczC7WrhCUSCWNGnNDEjI4CzvTIKSb+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="380171978"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="380171978"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 22:26:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="733700508"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="733700508"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Dec 2022 22:26:49 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 22:26:49 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 1 Dec 2022 22:26:49 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 1 Dec 2022 22:26:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ukat/tMdsk0Ll+2cLQQInf0JFev6tht04P5i9sZJRV7SIsEO1KX3usFCPAAeZBAiBHnjVkE+gXahzqxGo3nRnspQN0Ir1jR9tTsusVioOHrPg4q+6S7njX+Mu+5cB7aZWxSNhsHxX+FVjiUZDIhvH7LCKwxCn+dzzDaJuXQv/pMHVQ8IKIeUW5zNYhyiuXb/PXcRbZLse33Nal6eNWIJV6O42ZuuhqwDEjgXPnKAJyYGH11rD0KZOC+jTgdZVLSAgiw8FwNHzHNZm67h+qSA3xXd4oNXDo2YT99rvvU13do4zJsayPqQVkc9EPLN11IZCRaX0jHObO78LaM9KgC9sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPi5uGmxcMZIBda2tc0HvZ+abfwPRJ8JRCDPuV0c2Ks=;
 b=CGbsXLFg9X3LJsVUY2xM51F9OOkMOiUWuiPg9/T+1Dg91A37MnsTviXB0ZLVPiMFh3sZ3UUXiG+AZFJ37t2He59pRZo/ZBaQDV67+c8wOAhY1Sd+IzQ0gUs5HJUTr9jv4REmXDd41t/OMh3argN5BesU1jikhVmA7HjRf9I9Mni6Na9+TQAvS0r/ugxreeRHAwFHXz4TxJJf6uchrRSDbuWepqUaiMY30bzXnutsGnCw6aWwIocJCB79Nd9Gg2G/rcNs5ScQCsBM2r3xvtCDv+NZJrbJzdBl6UGFDFksnijSvMAD25AEzLxP+MMzG7X3JhiJ56SsslrfBxfah7kIng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB7389.namprd11.prod.outlook.com (2603:10b6:610:14d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 06:26:47 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 06:26:47 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>
Subject: RE: [PATCH 10/10] vfio: Move vfio group specific code into group.c
Thread-Topic: [PATCH 10/10] vfio: Move vfio group specific code into group.c
Thread-Index: AQHZBZUDnOAlNAIaZUWywFLx+AqJaa5aItEQ
Date:   Fri, 2 Dec 2022 06:26:47 +0000
Message-ID: <BN9PR11MB5276ACB482FBFB855BD056B38C179@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
 <20221201145535.589687-11-yi.l.liu@intel.com>
In-Reply-To: <20221201145535.589687-11-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB7389:EE_
x-ms-office365-filtering-correlation-id: 060e339e-4b20-420d-7316-08dad42e3062
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JEiKuMLwzAdNVDAMVyDDs0K59feJzADvv/CPd9z5x3X61Z8OmS3Oo+e43S47Eox84h0viwtcIqKyhJ1zyoeNWxCqq4bA+PudCswNJNkxEXIYfForHPlpRvrlsigRTJIcgj3i3fdxOQ8cQhniN6f7vLbCTWs6tZSPGpeaqQf6XHKlSYCMJXR0BiZHIJghgqheyg94l6R7MqtqQ3HdUOdImyYWFsHaaDRkyvu0HLUqOq1kTK9Iq6AdFOC0SJSZmWckyWRyq3cGKarjokwOHPR8ZRapxc7h6wOnBzSVkLdnKB+XlfOVlTdgITAtinq5DcKamehesGnSKSup6x8R5Vh/ouyz8PsM5hOSk3rV7mncrQD58bSGFpR+6uLdgcf1XDMjbqcY+mXGZpRYCJ3ctuL+t26EjS1+ZGouBAK47qA0ulIKL/tgKabOi/epT9GBB+nux2Sx3C+1XDjVWvx10SSwe+Dx8dt0a5TSGHhNhJ7IvMryeGUGtjdIFmu0IwOmn3vPKGzo0B1hKA2pBKCMNDRN7Mj5JlN8jzamvCi9ZsZED3cP6S07rhqsGGrzEHYJNPZFfJNWUCVPD1u1SqLNsQHXBJ72pUQgW0KlNM9Q9U8hGwsGZywRJ+mg7R3yQsP/USYev22zlGVCiySpP+xc5HkBJI/xX1U86xz8Vvv4F+T1FVCirUKzsAlbpdI2GLOExF7G
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199015)(38100700002)(122000001)(9686003)(71200400001)(6506007)(33656002)(54906003)(7696005)(26005)(86362001)(4744005)(55016003)(38070700005)(82960400001)(186003)(5660300002)(110136005)(66446008)(478600001)(8936002)(52536014)(66556008)(41300700001)(66946007)(8676002)(64756008)(66476007)(316002)(2906002)(76116006)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?87xb0DyGdB26BWDvyTzuUeWhhs5tZhW2s9L4iaRnmiVVTaqhBQjwhXCQTSkC?=
 =?us-ascii?Q?MGtfcMPUUhF+XcV3NmxUtR6kH8JhYBVfHqu/PABT5xqqopttsFjzWSF+3jJb?=
 =?us-ascii?Q?DAIb9DM4XI8k43NboDJciUTi60nXDDdtAZYYGMCb+63yt22eDzF3ETosm55+?=
 =?us-ascii?Q?ZJMJZ+mhv/SA/N4kvF38CqSxfHln67ShZ06/3es4YmV528990Af4wY4E/Ju1?=
 =?us-ascii?Q?fPX3MDc+0GvhzshpRlfMfiKETSoo5O1Ojyy79xtDKvJNOusLZD+JuIfol/B+?=
 =?us-ascii?Q?aiiJRJSU11LZXvEgB3yg9dbZt5y5qPtK7m7JJnlHqL5YDGNZCciYwqu3pLyi?=
 =?us-ascii?Q?w2tN+khylcD5vrWY0NQE7CXWjDn6AvOq7JaSIE1PhyUyRwPY7mysMHtNfu7+?=
 =?us-ascii?Q?TIrsOIRj/H8FcSdZdeyjJnlwmotyfbFWJES253D3+QZ9UOZdS3v3fH/2Oy8f?=
 =?us-ascii?Q?N2tgtMEs1tEa8EtSxO0Uy63dPdsVvX+gVVeiQYjCt0E26+SBkzxrF1SiymWC?=
 =?us-ascii?Q?Bfjy6C9Ssfn8COCNr7a5Q158cToy+V8g2iDpIqbk9OYhr2t/ynOyE5OYvTpD?=
 =?us-ascii?Q?9SKJmczt/ux6CgojMrvzu5V2YVzUzVusEl3e/jTNmc2+ZYiZPIqqFF6cs2og?=
 =?us-ascii?Q?4HvLROzmM+OTQUkmw+e3c7upeDuJeoMe0nHgp7N0wSjxGH+xvbod4bO7Nj+F?=
 =?us-ascii?Q?kpQ8wXY8tK1FdairFTfLTkTWpYolFN36ALoTf2k+LDOjZkxhBvzw2Od62e5q?=
 =?us-ascii?Q?epqqjFWNjA4w3IC/MvfvxuP/I/WRRx+tq02HiWWP523yQC66u9gbYx56GBCT?=
 =?us-ascii?Q?RqBbD0oQ0ILFyZALdH0xdDCyHe9WoFDxFa2e0aM9GmHHg943VTXB4WPdBk3Z?=
 =?us-ascii?Q?8K/9ZHXeKys1YKO3xBVQU3jUPHmaCMG/MCX3GzGxq8vEqfKIpaVpjZsQN2/E?=
 =?us-ascii?Q?wxTqVKRYVpwZBi4rh++d5MTPBmaFLmhR2M7deMRYT490UkS4uqI1XaydNNO8?=
 =?us-ascii?Q?/nid1ABBX/rM8953DyrJMJbnouOOLHh3ob91NCWf8IFLE5D1cN4BdOcTz29W?=
 =?us-ascii?Q?98YhdVsVu+JuZfj4vrtnP8tLNXq5MDZUgH5OP7whVa3NEZ3fV5q1IuJnuK2x?=
 =?us-ascii?Q?2Cw+5ShVcXBw3L3OsKc3fbf6B0A+8vwiYm9AXSOoRfo+UaEGwN84Ca6hzwKo?=
 =?us-ascii?Q?v1wiiCTrS14stgn6a3Jzq6c7tlblq7WCoAQn/xihHl0rTb7Nds03w7HK+lX1?=
 =?us-ascii?Q?AYop/P4RxCy8i7T5dUY1g6X2U10XjWpP/2vnJP1ZoHwZGsRiAFUnmXZmvvBH?=
 =?us-ascii?Q?3xDEgQQwB1EI8mT8qADqxJCgUm0HoMPOIzz2CS/8vR2J7UuxKEt//CgjeHzA?=
 =?us-ascii?Q?dBg8+QW4Z+7g4b1uxwtuTR674ex5PRdxs69v5nW1bXkcvIWQJil6Pr1Iv2Jw?=
 =?us-ascii?Q?J/owC6N61TR6PS3aLSDgZVLFxF4doTC9H9u4W01YhlOrZHlKqCUcb2TsNKnJ?=
 =?us-ascii?Q?jOuhPAxhwJSDqWQnvyO3kh0+vWks9xf3wVtzrew10rIkpRyoofnLv2IaZRoX?=
 =?us-ascii?Q?kmI38O+e/X9u9er8Eym/s30nIrsiRw5sJZJ8iLyc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 060e339e-4b20-420d-7316-08dad42e3062
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 06:26:47.1221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i6us71OQuTH8TQI/ruVuDIQGeBY29C9ekuxj5CLs58uUyncXfYVMtbr9qnlZmHdv9TJr64VPT2lnvN5hH/2TSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7389
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, December 1, 2022 10:56 PM
>=20
> This prepares for compiling out vfio group after vfio device cdev is
> added. No vfio_group decode code should be in vfio_main.c, and neither
> device->group reference should be in vfio_main.c.
>=20
> No functional change is intended.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
