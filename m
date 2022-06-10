Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE65545D33
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 09:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346428AbiFJHWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 03:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346718AbiFJHWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 03:22:45 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EADE56B21;
        Fri, 10 Jun 2022 00:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654845763; x=1686381763;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nT+zbJJaO2B5n1hgPiHC4nqFyduAT6VckA+7PzugUG8=;
  b=YkFhMhukc9SVYj7fOvhDAFhbxQ/EFeTcCoZii5WJ+BWCDZL1pT4vwRNN
   6D1oNYB6DrvLjChIo7phZ/opSXsPQInPDHoZXOpOjVO8ethfJJwtw2bV7
   eAEAGtt801t69fUymXY+7+Vl5qD1liFRe8eThSnZNASjL2Q8LFAD4EYBV
   cY49febA1B9hK6scWWvsbleSuXHq1JGOQ+lNrZJuIpfaMslps36rh+ZLU
   hEcBs7iHzBCGwe//+Be0waUH8HsNfcmLyCCOU4pKZH/0JT+xz5kznswy5
   DG5bYn1MpCuSZoFImXGcxPI37ZxxTH+zUMTeW15fY+CTXRfoiEGsD1NE1
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="275072115"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="275072115"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 00:22:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="637993480"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga008.fm.intel.com with ESMTP; 10 Jun 2022 00:22:43 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 10 Jun 2022 00:22:42 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 10 Jun 2022 00:22:42 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 10 Jun 2022 00:22:42 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 10 Jun 2022 00:22:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SuN/+4/XkZAbGOOiLdjFvM4kBh6egcxoNdvSIE3For/x+FztKmUv7XGW0DE/jjrefQjgw7wre3/cflA4UAU3Me7UKDgMe3hnQBtJH9D3c4uETR6EtXqbcDQZT4FdkkYZCw1qIYQiSCJUFfr1PNmqXUCXJ6a31eBQ22assk4Z2g8Okd2xiOtoYPzOf824fCtPs9HBX8AZuHd+rk1gonR4EApVQVatBH5HW87/M++BcYsiPv59rztkCIE1IjHq63qghiLR+xLuLcKqNfLwpGvBxzQVtMC+3ExlmRTbvfuDPDcPOY52b/fEzZ583mv1tRZOGhrx3nczhbeGpRqzKE1fZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PsaWEqPUqp1aopEzCIcfz84mTmseLCTQSS4LCUYF3Pg=;
 b=eAVOau2EWkDfKlIIWKZjkrGbjKcf2wJbJux5O/bFP4N54QUHJx2RJOUgA/AhUC7awGOCKChH1PDbpTfZXC6tPrcJ8qoAKwt5VpVnuFnULGyI9HrzkmkwmL5uyIxuh+SFGWzhZChnDCIPtZBG17qSErETC4gjaazJBFEO6/RFFWH01D7f1e3gzlra85I2XvifyPbBLl/e07Bj/hwfrD+7BwF88csr92pljtM7lC1JnjNdTmwr3ERJdzU/Vh3P1YkRXPo18A2CWViXmjzIIl9OSQpnRrSA8QhmObf6UkP3IWikb0kx/Z0IUzeYUk2iGJ0oRhwO2ARkZpICLP8ui03BKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR1101MB2228.namprd11.prod.outlook.com (2603:10b6:405:52::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 07:22:39 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.013; Fri, 10 Jun 2022
 07:22:39 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
CC:     Tony Krowiak <akrowiak@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
Subject: RE: [PATCH v1 13/18] vfio/mdev: Consolidate all the device_api sysfs
 into the core code
Thread-Topic: [PATCH v1 13/18] vfio/mdev: Consolidate all the device_api sysfs
 into the core code
Thread-Index: AQHYdqUEck/r7iTbF0WopMtoGxuNG61IR/vg
Date:   Fri, 10 Jun 2022 07:22:39 +0000
Message-ID: <BN9PR11MB5276B2F389EE5812182029E08CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-14-farman@linux.ibm.com>
In-Reply-To: <20220602171948.2790690-14-farman@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e6ba6f21-272f-4549-c6db-08da4ab20027
x-ms-traffictypediagnostic: BN6PR1101MB2228:EE_
x-microsoft-antispam-prvs: <BN6PR1101MB2228C29B9DC95F3E2410DDE18CA69@BN6PR1101MB2228.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GNPBVnPzBf6BDE2mH00xTxcBE2UR0gKAQEUTAtWB5BM6+aYAxUHlLbEJB1Sf+LyW/9ypj4U6uviKfL863n8tJ/NlCCFM08emyPIgYoTPLjhJIv5IYBDg4j2mopiMm1sDLA8Aj7JWqXFkUL+7hgBAorkN14kAWGtpOlahTss8UcZ0X/56AE9VW5Ig8zyEbsFhntABqDEt2EC0q72QW7nMTIzT1yQPOk8INKf4z8BWldze9r0sNspuyvG3izS2mlXu4bpe8IkE548byGhcyI2ZOikzZu0OL4IzrYxEkdhGbGHQPIAMVQHrBgTyM+RxDj4X82g6n5sW+9HbnTGCdtjf9QqVV+UYdYoDSPO2afa2+y+BD/EX7K7wchA6FpvL5G1qYbjUE7gzjBlP2JYGqoEH/NA0SN7FTfp/VDx5DSCcV6wlOSakYIMQTvHTogRqYBCun/9VU5wiZF09OEtvbATW6cnLzObOwo2U83B6E4KKna7D0/PxtexH8/l2ux6F7p9NhfSYTbSs84Y5g3WslG1L/Ed4QbZqPdPs/3eXPAZ56Ix6e1VOP1hLdHR+ma1KEihF35/hoyb5STNlcqS46Q0ZJjvVTODa5QPJqVNUjzA7ykx0VV3bGJISNAcXTIp2tCDXcglphmyOOKc1SQrvV2ZJpaw9hivKIv7E5EsUqBbw1Xo8C2TNWFoQ6ZtGCNPxQpVo2nCwJt+gPws1VxvGc1ZovU20fss/mHfoLESEpndaYW3NLb8wq/bSfinPcBHpgWANbWtGEKNa+d3TXb6d2V8IxRWUVTCStJIpufAjOKrRFiY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(66946007)(66556008)(66476007)(6506007)(66446008)(26005)(7696005)(64756008)(71200400001)(316002)(110136005)(54906003)(55016003)(33656002)(9686003)(38100700002)(76116006)(8676002)(82960400001)(122000001)(38070700005)(86362001)(52536014)(966005)(508600001)(4326008)(186003)(5660300002)(2906002)(7416002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?E1Jc6zXHyaNnX9M6E9vs7macBij58z9MFo93HlXZM84wAwEQ2LQwq6/D8Xum?=
 =?us-ascii?Q?kzAXtOuR/CUhRXeL+mgh0DF+ArPbdDn1+abPWI+1HZy0E9xUS1eiyl1Kug6V?=
 =?us-ascii?Q?ewwac1HB3GFr94ruAzgQUavjoFpg8dj8q/TunoKWp8qDnikBmsT9Q5sXP+oT?=
 =?us-ascii?Q?8a6ctetNuDKimADUJyse6/h/8He8B5CyOEugAJ5IGaCZEkyFO1kVyGFatIef?=
 =?us-ascii?Q?icMcFkSGz0w9ZpLHEWm5W3iSgP/oIHyrWOYqCA6e+5gKAPCqaOOuLYkGjBMK?=
 =?us-ascii?Q?ZtCW5ZUEXH2zVxS7RYE5sgumSzSuYenxCBFIGh38L2XPcuc0krD6Z6dnmBh0?=
 =?us-ascii?Q?MyhtkrRSghqw515EHJtcf9hPO5A8iWFiF0qmbIZGbafywlT2HSYnIgvdzCJ7?=
 =?us-ascii?Q?xdqaBZ2Oq900N+f33Ryi5Zx+OFXwVWzhjV7Nx7KGlopEFTKg/UQLs3w+dCoS?=
 =?us-ascii?Q?smaKWAy0LdryxQloNjZRWM0riMLkKp63RG2mh9WYowupkKQ8GD1ELQUn7w5N?=
 =?us-ascii?Q?yp1BrI7OHhSbfRFoA1TZUmKEcr6ntCc0tayXXM7c9B5Fgc5F4CFyBeVugUqa?=
 =?us-ascii?Q?ha7ByAGPfKz/Ph0Vn5mMqyqC+7S2VxlkiaTiYHDxz9kU6DsIQY/F+X7PCakt?=
 =?us-ascii?Q?edvniJhEh+sV+txwgiV7AnfxsFLjlqrV+BWrnk/QLEmtXO9/TNLt+HH9ozw2?=
 =?us-ascii?Q?cHKGDkQUJk6mfWMV15Qk55TUqD0ZT9chLQWGE8vC346KQTRrHb8xV8O9cb5w?=
 =?us-ascii?Q?PupMfp8qTIrFyYHWOjQcOQJbOw8Vzmd0PxX2dau2wNot5HO9M9lb/ND0IKil?=
 =?us-ascii?Q?E717+2hhulpCLxJdVRbm8xIKaSGoK85XtfSg5ndgd1kNFYRFoOSLw6IFdjQz?=
 =?us-ascii?Q?IhI4ZTSGPpXytwgW01WRBuroauodn9S0BqtjbPa/WPIZNkpS5ZipI7E5PVFv?=
 =?us-ascii?Q?X2MYCnRiu6KGKNkHb7pXb2LY3tswueYeR0TcvtU8XcA/iv3xW2RPt21weqf5?=
 =?us-ascii?Q?GpbTFVKOlgYkBYB/iJ4PR1HONwdrqoosBQj+HhYBhGC7HyE8jV1ZdC9TP0bz?=
 =?us-ascii?Q?x0xyRT+cGqy8dYKk5Q+EThpjprO3rLeJ6b3/G+lA0vycOLOjQ0e89XI3o3Wr?=
 =?us-ascii?Q?AUfMC3bD6j+ip3E1XbBcrzmeeC7VAf0Tw6nNkyjV+8oR5QlLs2xnmHrgDuGK?=
 =?us-ascii?Q?By5+wVkDo4/VXbCJFjd3D8XR18QnvFUbO3P1OrqVMRrWEsrz/PFOFIH4tPol?=
 =?us-ascii?Q?zhG9J7dfsKTCNB3kMbJxAZfYaxmYcXdp3jz/fI1vzywpHY8i41EE0BYO2fw9?=
 =?us-ascii?Q?Fc6GXNkDiwz2xeOx7Jic+1KbbeYjACQ6xyZRxINjjvJFo6qF5XZOw70HSsZG?=
 =?us-ascii?Q?O0J1ov2IRd8PtBQeLaouGKoGVy5xYtP0L4/iI5WdlsUBg5ROrff37QNJ8q8s?=
 =?us-ascii?Q?FhHxueWK8xORoMas6qYOsCK0/vXjAFa4/fq7mYubwPCCpqna0LwkHWJIp6jy?=
 =?us-ascii?Q?V3yfMQBwhcj4xIvbcVvJ5ERBULLBrhjw5heTQgSOS90vQx8XN/RxRMpeJj5z?=
 =?us-ascii?Q?k9Edj2gUO17U/nxIVzgGPUCktcrGiZf4R1SPCforApz4NQHKLpplcmu1WVhu?=
 =?us-ascii?Q?FAgckEHAz+2Ij4tnoiLmN1nM6mbnM3arX8OS2SE0HPqoioGsSm3K7AsZaRhj?=
 =?us-ascii?Q?kkE1OEErp+wt1HzA9TVczmUgI6TnqzCImdBIozEMG/U3gLtmMAwmUIxwf2xD?=
 =?us-ascii?Q?ixO8Ehn+wg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ba6f21-272f-4549-c6db-08da4ab20027
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2022 07:22:39.2961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u8B7LmtSEuYjbWU/CR1TIPSn3612urG1wl0/v2W6OQAauDWjSajG4P7pdtgR+M4llk3D0MmqNQXAi2ZI6tzG1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2228
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Eric Farman
> Sent: Friday, June 3, 2022 1:20 AM
>=20
> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Every driver just emits a static string, simply feed it through the ops
> and provide a standard sysfs show function.
>=20
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
> Cc: Zhi Wang <zhi.a.wang@intel.com>
> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> Cc: Jason Herne <jjherne@linux.ibm.com>
> Cc: intel-gvt-dev@lists.freedesktop.org
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Link: https://lore.kernel.org/r/6-v3-57c1502c62fd+2190-
> ccw_mdev_jgg@nvidia.com/
> [farman: added Cc: tags]
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>, with one nit:

> @@ -225,7 +226,8 @@ Directories and files under the sysfs for Each Physic=
al
> Device
>  * device_api
>=20
>    This attribute should show which device API is being created, for exam=
ple,
> -  "vfio-pci" for a PCI device.
> +  "vfio-pci" for a PCI device. The core code maintins this sysfs using t=
he
> +  device_api member of mdev_parent_ops.
>=20

s/maintins/maintains/
