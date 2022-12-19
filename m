Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7946B65083B
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 08:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbiLSHzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 02:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiLSHzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 02:55:42 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D567E00
        for <kvm@vger.kernel.org>; Sun, 18 Dec 2022 23:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671436541; x=1702972541;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o2tGfaJAI4O/WLEUJC4bPxqASsr6qbhK7JORX3kEuc0=;
  b=JVGcDBeKZchnGTg7ZpHWNwkGGVmFmaU1NuXrbKpBmkF0pSAoMMoBumK1
   S7QGx2WwgkPZwSDBMSJ0pnmEe48+kLJ5L5TOxd8C92v3B11iLxOU/6QYS
   xiJQt545+FDMKNVIqhPcg3cA92VZ7lTnpeihozbbWl4nTDlAgnWuSQILI
   UPYDv9TqyBhgJDQI7y9fOFMUFzZbAmcJzZkrREmg0iKksiSUstJl8NFT+
   720wirQSq4tDsDe9+dk6ROfGdSmU0UyduZcTugAMNxLYK94LKS+DrD3Cg
   4IGsAhxYOIMoeP2K1PMD8ADZ5f1MHw2CAjc6B/wTZTjEKA4x+niiGFl2M
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="321182433"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="321182433"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2022 23:55:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="628219305"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="628219305"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 18 Dec 2022 23:55:40 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 18 Dec 2022 23:55:39 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 18 Dec 2022 23:55:39 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 18 Dec 2022 23:55:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZumJYgixRdmlmiW3E7h7OkDKlbk7pV+EIaKZSSTIXLH15l4nnpOIK4uvKzH6B5js6nL6EA49cczQ/Y1qrwuT2a+trFuYpD7WJSSFnz/iiGCHgzO2baCr8NxFFSxt7O8ZOh8I4dsua+7uWdErULNXANXObeDjaD4V1zL4LJ3l4gL2w5JnxQ9VZmSH55tJQGdBGneZpdlxo0BGhW8T4usO4RIjDTEdYOYvKh6p8CvfMq+jRuCMJ51B2jFa84412azU2v3J1hlMfZVhhUMNUcvnbMRKmImylofLbdjGLxdSdD7epvjfL9vloTPgtwfeCUMn1cD5vCzm6yXTnccYGhjZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzLkCxnFt+h2Ur5hdmjP3Zb5iMUIWFm/Tx+oCp1rwJo=;
 b=nv0LwmVdtAaiB9dzvvVxHcqyFxNP7WFdhctmaismXVbwJR8zJ4j8tgtY9w51AoTTkWvdq9cjAfvHS59E98J3QirvKTAs1/kFjkJ5Hwirs03VEx7xc11xy2fxHvDrUNiv4Owv2YDBPbuNgG3an4ogifxA5LxFd66/FE4KChDVzDklMFpXRbxmlm0ZT/Pg+Ukj+2IqwZgyDVzIJiHJCGb4zZTItrfeAKwPhkk0HOYAOBlW4cKli/pR34rFhpOPynyV3+Ilvxf3sK4+XnZhA6xHiqDaK3Aw4daNYfT9IMQ5djk1CIEgZPl7SdCCFPNY/CN8ryUGn40+WWZLKSC8swUMEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7641.namprd11.prod.outlook.com (2603:10b6:510:27b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 07:55:32 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809%4]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 07:55:32 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Steve Sistare <steven.sistare@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH V6 7/7] vfio: revert "iommu driver notify callback"
Thread-Topic: [PATCH V6 7/7] vfio: revert "iommu driver notify callback"
Thread-Index: AQHZEX9Y0K2ub2R+gEq2rGjMK34wPK5023TQ
Date:   Mon, 19 Dec 2022 07:55:32 +0000
Message-ID: <BN9PR11MB5276A626B572F5B4B77BA2318CE59@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
 <1671216640-157935-8-git-send-email-steven.sistare@oracle.com>
In-Reply-To: <1671216640-157935-8-git-send-email-steven.sistare@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7641:EE_
x-ms-office365-filtering-correlation-id: 3fa3fddc-7015-4724-c8b8-08dae1966752
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WqjjKy3dhbkSdIgU7lozC3rX77lp5XiZjuIkuQ8WtLoGWzBmAUvQypHt7RsNDDtme+J7xrCWnaYuI65cpwUwuBHjx9DNJNIyBR4qnHipD4IS3wJ9yYrDOew+bnzBtUX0OVcrGoPEDASoou1YcxWffCzM8xfVH+QMP9aJnky9Zx3SUSwhptsI6oz2RFKVUEh8cFY3FcnQgeQ2+EypsvB961SD4W36+vUo/SaQ+HHIhLEsX66WY3yFmN8FJhW8HFgCmJVsuya4VzwBMTGiI+Z7DPmyf+fnnTpG6Ic5dHVYQYlUIAXbD3ZUkgudGzi1TnI6v7OQ6X73V6Nv9SMFFua1btAbiBJx0JUJa6YOEzc/zhMTRvXOZaihEGKgxWnVmXvUFawIEqG94XC8X86sibc2IVF55C+7T9x5B8XjReDGLGTidF6D6OCATzXYQOUziG6Ax/J/DTe649lTomLNXr7EMOAIU7oMhcexklTCsta8IG+rpQ+iVEU/bnC7u8hdAlfNrRzQV9KVwqLooT8+I2/y20+mSuAPqflXSrI78/JAMJxa/ObEKJlP2Jy+5HrmWBxu8BmAk5JgepUNxxylqc2Yzg0PrvfYub/Edb2IOcI2nQFsCDGZuIBhQyToqTPmHY2ZpFmGetw/LIJyJyvZ3bzJHgKM+w6pfLgO5lFNlsieVpcHCmtVNaYL81Qjb49KEV8HNIofZlHtOIP7HV6D8tufvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199015)(9686003)(186003)(26005)(478600001)(7696005)(6506007)(66476007)(66556008)(8676002)(64756008)(66446008)(66946007)(4326008)(52536014)(41300700001)(8936002)(5660300002)(2906002)(76116006)(55016003)(33656002)(558084003)(110136005)(38100700002)(122000001)(86362001)(71200400001)(316002)(54906003)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sHmyF/O6YRQ2peX9PMubG/cBLwd4IzyopycJ4ZbMSpPWjrcrXgE8KkSFVFkA?=
 =?us-ascii?Q?k1Gl9NqIU9PogEhHB8W+OZFQa2Vo206ZtolaQjwcJcXUJo8vBqDKsNofUwOg?=
 =?us-ascii?Q?3T1mS8r7wdkZumn8jhr1osFLXVlSLGMXCQ0p6nqhQ1hkoZ3jFlIb/HUQnLuj?=
 =?us-ascii?Q?eOva+RT6Tv+/i/vnnnsMQg2EBnNdXBP/OpGj4kkOmpmXbmN5sdNA7OicueNL?=
 =?us-ascii?Q?71iPeeu5vFsVZub8i8bUxPlseZ0zMJi+XE9YerNK3whHjkarb7hDJ1CnS+6c?=
 =?us-ascii?Q?q6C9tvZ16QvBim6BAWKt8GNMYIrV6qcmeSauKD2LcO8v9lFLFsOnob9MX0zW?=
 =?us-ascii?Q?uRLU0mZ3dAA+SI3213aviNvnX6fPZPn4dQC5XMj1CGsI5X36AUHtkXaBeeh6?=
 =?us-ascii?Q?gPxbZgZ+8l/YrjCVvTnx/1vfzW1KFp8F4t13B7ELPkuL58JLv0rcYd0M1TSd?=
 =?us-ascii?Q?MXZAex7FfNnRE0e38a499kDxGLZo1x+q+zzNLhjbfR8UGrFns8fgVWWk/hVT?=
 =?us-ascii?Q?i2XjbVo+N5Q9rRPbVHyNKHeHJi5f7bbqOXoiaJmDt0LSVJ1bux7wxRUrxNiT?=
 =?us-ascii?Q?Pp4pxnFxSZcaFfkwm/7vMLQv/DX8ux41OnWtX/lpn0rBXoeQVkjjJw/mDCwf?=
 =?us-ascii?Q?90OpH/GPh5WBTEXYp9jGLAFigPnKqVcuwYZUkGjfAED7mf973FWdYmHZH1Zk?=
 =?us-ascii?Q?6HbOIQlNAIel0vCTGtsZ540l5AC6vB3zg5aNVUgHOjb8e4qNxywgiBdXJ918?=
 =?us-ascii?Q?by6Jyvqf4ehYdMy/zCBDO/RlWsNWEjmDEM3IomDfeD034Vj/JchZBLI847fz?=
 =?us-ascii?Q?ycQ1tWWzC8WGstIIpEdmmNtpZ5ZiXl4EW7kzFI7XNhZGy6RdLP+dY+TJbM3V?=
 =?us-ascii?Q?gmDfSmFiUooMajFDhnKXAKj2bljklrN3U2qr+WZW5L+0teVQFwuDucZo/zLH?=
 =?us-ascii?Q?e6u6XLsx6J5AV2cIkF3BYzbbhXjz6njZVvXw56jE6Stkt8QbIUFpK6XiBxzz?=
 =?us-ascii?Q?WOTc/c+cfPF/Ik+XoNEm1do6UeDuFm1MT5G/LqnGDTK3X4U3qvuXZy0w0Wy+?=
 =?us-ascii?Q?8mmrNTj+iLMtcL6nz2MhRKIGXIa7QFtaoF3THFk0ysxXxiIyy7ivG7r/Amtr?=
 =?us-ascii?Q?PdouoKVTLynx2oRI0czA8283N3x4/tFCmP0Jt987jkOx0MLi7G58iK9Zkj37?=
 =?us-ascii?Q?fvOwvWZGIoCuMuoVZkXjcCdRskmcMTXIdaxYZi6gzdZYMVc28IGMSJEPm00U?=
 =?us-ascii?Q?3g2faFeCIRmkIsKbN/4kWuMfzzaZrqZu5YTU7MzudcRN9zAYzeve+p1yGDRx?=
 =?us-ascii?Q?yJ1A01D5DmcIQyMPSZcyuMJAcJIhx/Uhj+/AyINvOneKobbs9NOYfZa+FQZT?=
 =?us-ascii?Q?yC30v+HtGqQZiYsRey1oozc8rDYjuMnjOvuNIdT1gw27PoyN6KCi7EjQdjfb?=
 =?us-ascii?Q?2ZxonlBSTu5XzHcFoT6SPyXoFQpeLWxNPZ467DVsraVny+Et1PJah0XtdVwP?=
 =?us-ascii?Q?+woOWRhBONcc8fCzA5YWjlvcygxkJ9GGQkWTSMnsXMR9RQ7hjCLgbAQYRRCo?=
 =?us-ascii?Q?/XipGFVJhu/F19TgBjSRqF/bZP851q2vNKun5faj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fa3fddc-7015-4724-c8b8-08dae1966752
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2022 07:55:32.0700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U2dW9EG16SktP5004wYaSA52xjlO3ve1jVla9unkPGCASGjhHexLOanpQpGdFwwYAfVGL5Fv2IesS5CAuldGPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7641
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Steve Sistare <steven.sistare@oracle.com>
> Sent: Saturday, December 17, 2022 2:51 AM
>=20
> Revert this dead code:
>   commit ec5e32940cc9 ("vfio: iommu driver notify callback")
>=20
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
