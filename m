Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D5A75C20E
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 10:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjGUIxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 04:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjGUIx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 04:53:28 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EEA2D5E;
        Fri, 21 Jul 2023 01:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689929607; x=1721465607;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Cov9DH1r2Pqx9RhokX2QDxEg54TXtccdtFp4VBqunSk=;
  b=NS26BCNvkwuwS4dTzyodCeAMYmuUorHoNTV9uQzs7576bOmc4mPG8WtG
   dsuZkntn6r08jUD0cV60lwcjzDK1wDErkeWUNgR153HsZ3ZmqTg9AXRze
   VZLhbN3cc7Dbk86kiqSzX6EyJD8TbVntd8hmJDmyzv6mLQgN7+DPVLYQX
   kftFYdypBNH8qoYOrIfDjwwatNtS+MFr78OL0MRY5HoqsFMOhmZMYxS9K
   nL6e/RIxaokEIdxmemhN1ij4lXkqFGYtgNN3pDqmrGWm1HVYwbay/0+qp
   fo646vR5T+rLdmjiW93HE4Xql9wPHvpVweGeihwnqphb3YDZfgp31InN/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="370575095"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="370575095"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2023 01:53:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="814872299"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="814872299"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Jul 2023 01:53:26 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 21 Jul 2023 01:53:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 21 Jul 2023 01:53:25 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 21 Jul 2023 01:53:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkuD5Of6pnE6q4GyyU0YcBnz9U+6H0/ibnaFvNo43A9L9MPNAhgc2ZpLWuyNvmU08dRUU+dV4AVlkTIIE40neXjYOSjhv+nuaWgeEOJqBfsMGy1yAGX2HhguY7DVPw/8/ZfS7dSrhaY8DSoiy6Kq+YJZGrglIZS/M6Iw15ONsbb0DM3K6L5v56mW00hou6VIYAC5Rg5dIXJYq1+EDWIF++DRics6mvu+pxKR9B10Rh1jBHFx/yKfBPOYoYzthcCclO/VXunAvEo54yVEwCerXwXwxWnqY5lJLLXJ941RqEp0H37uoj80GdhGyidJwxZbCcmxWbiX9XJDDpp8MBvJCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuFBSmxPd7dqVz+CUt4hA7z1fg59qgPJ5Q3CXdcS5fc=;
 b=k7rJt2GBt4N63H5Q3Z+cKN/C4t+CE6yZ1/Zh3GCAIB3czUvsJJOVi/YeqQQuPih+OnaBwooV1WcOuWs4YR39L66GfnsEqrGg95K+vJ/QsH9k89DCoddvnOcA8ey1A0BYHzTIHrChPQ2j+0J0GaniTyBIdwAHlzYmFEqNAkd9OdwrLw4L4MjD5pUkA7g7fdKluWktIlH/viDNvly8Iy8FD0GWdOSInTx5uqAdKiZ6iqqNYnS1PJu3nhcjddq2AaHP+RCVYzpz3jbkA+xrs44867cylhhT9zpKV6rmM37JiEv552tmKASrqZwHXDS8bPgEpTjEtDtNTWk+Wtl+vVYaTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7706.namprd11.prod.outlook.com (2603:10b6:806:32c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.28; Fri, 21 Jul
 2023 08:53:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159%4]) with mapi id 15.20.6609.026; Fri, 21 Jul 2023
 08:53:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Brett Creeley <brett.creeley@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
CC:     "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v12 vfio 2/7] vfio/pds: Initial support for pds VFIO
 driver
Thread-Topic: [PATCH v12 vfio 2/7] vfio/pds: Initial support for pds VFIO
 driver
Thread-Index: AQHZupF1kNGTWmL8J0KWBhuok+WC9K/D7APg
Date:   Fri, 21 Jul 2023 08:53:23 +0000
Message-ID: <BN9PR11MB52766A79CD8EDC013AE33B5A8C3FA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
 <20230719223527.12795-3-brett.creeley@amd.com>
In-Reply-To: <20230719223527.12795-3-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7706:EE_
x-ms-office365-filtering-correlation-id: 77cd3efc-032c-4a11-845f-08db89c7f0d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QWjjSep01QuFkHjAIkRv4GwD9GvooqAaINmvTfFPQ/P6X474PF2bMVXKPGrasQdc7sOpKPLmLTrz3Uw9dmvaqnlZxQaArtu33YcWHRQW4mhkyXGrIjzOzrOf5Dv0sPvEi9bHwRgH7hItIzN36CGrygQScF5xleVsSPgbi57/WO/TcVpQGNl+/K0wm2kav2bEEcsTvX2Q4wb+u347v9KU/LMAKywAeJ/Vdg4mKGedam2um+SmtLBUi7ajF+nztvLswETGUj5MDFkZWafzMSH5oVEJOmhPmgzJCfO0sTN0pGyjqC92vqd2ZmEgp0tIeFcUqj/kTUM86gWiCLnCNtesbmVGssCfXyj1eP0DxN++gxjVyzbapBRNLEA0glfhyl2hAEWV3fEY6Tap81i16vUks6m9RgBamAuidn3ogbzfH9TbeClZqBHEscZuMKnF5nzkHVxdyOZxKmJ7z82xoHJ8XFqUrFRNhuN0jhLjD+/TgPs0ko1qHNMqaOj+Z+lLi0+aZ0C7ER76jFYAB2dZ1BnzsWhqoHvE5lGKSQkTzPFpcVWXKbHpXTLWfA6yFp2oBp01VvPBSmtg6g6ksQUfJAnH3WPMvpl5trC4O25qtWby99xpdiTeesj+EZgvHQYNHzH/KlnoHFrapx+stT8CPBh1EVCdDOvSfapnbtq6V/d5um0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(376002)(39860400002)(136003)(366004)(451199021)(66476007)(2906002)(4744005)(8936002)(8676002)(478600001)(71200400001)(52536014)(66946007)(76116006)(41300700001)(64756008)(66556008)(316002)(4326008)(110136005)(5660300002)(9686003)(55016003)(186003)(26005)(6506007)(7696005)(66446008)(33656002)(38070700005)(86362001)(122000001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s4lbF83ncAgDxb4zZS4PQt3KUCokM/d5xvPhE0kS8xr8krJgmgfvdCbzBg55?=
 =?us-ascii?Q?l4EcHMCS8P6plzgd3DbgPHp2XYIT7dIMKcm63OwnhgnGd0gFs5cs9Fns3yH6?=
 =?us-ascii?Q?7lwxg16BIDcKs8iq/WaLPwtnxCQjN27IwJgy2kVkUrbZqFT6RyXCXkChY25j?=
 =?us-ascii?Q?0o1ITfutKMcO18mx6lJx977fjtZoJ8eQw+9y8YtYgvWES2ODJI0z3odNCKlb?=
 =?us-ascii?Q?ktW06rH54WwjxNEeQ3ZeKo5f7/TtOWfzFNBu5OlsfVt2LwJJK5xFVEW+1xdG?=
 =?us-ascii?Q?JgE1T+IcBg3C9tXxNT8k5Kj2c7281iCaK/+Kzy8sb1+zHmF0m7AD/4h6NRnl?=
 =?us-ascii?Q?V7dnAPTjgw6WipoNAz5rsafJv7O9NmJNKULNnGHhNTs2g0l+zzf/Zzsb+Myy?=
 =?us-ascii?Q?WuJP1c1dx4aiZOn5DFabEmGjUdc0EMqofNMJwVi465BFAcs0T3pP48cIoDe4?=
 =?us-ascii?Q?dV0HkXAMXkLX8wS83YwuL9BXbC+QROlmNwzeFSt0r3P8HpRL1cs3ys+1LUT+?=
 =?us-ascii?Q?i1+BCoPMCJKiWigwFZUYiH+ImFE0cNl8mZC8FolLJLPiSh2mOSBUQn+979B1?=
 =?us-ascii?Q?8hXp7Btk0R7DmsWm1qHOx1ZNtrTcQ4jilh7C+oczuOAxqWyAg6y+hZTLr2He?=
 =?us-ascii?Q?dASch/MvvLY4BeXBhtHIDgIJVOTZ0QzuD68eQ+LC8mLLKyVL/OFwBGXylSWP?=
 =?us-ascii?Q?r2eKoOv4aOVYnHIiC4+n7fcaRnb7i0u6v3cEH6LMucrcLdBhM6CPnK1pqf05?=
 =?us-ascii?Q?wsp9uVXPN4UrdLkw+SZGJXiMHpbJtarj24Hty6olmkGEkyO+0w6VdeQ3KhL5?=
 =?us-ascii?Q?/BWlafbFeZeNhiO5NyebtHxLrCbafPX247KmzNm4XG9gmSEU6xM6P2/YBywA?=
 =?us-ascii?Q?/e0/0vDyprb7WuFXQN0NOXz79bbVN0G+/LQ0xG6jLzK/ia0lCcp3RLwTBaST?=
 =?us-ascii?Q?5JMDmBQ3xbHNgTTZIu/x5Opd8J2YuzmEmPlkKpxDOt4/UuBWcqp+1d9IpgMW?=
 =?us-ascii?Q?NiQGlk0PJ0bkJu/nctKDVMUJ16Vcru6+Zs0WIEGqzQIiruv27g4eooyj87bB?=
 =?us-ascii?Q?YiyeXwwoixrLQ5C9cE82GArVz7qE+aklwN08L3bvnSMr3Pgu4zN8Y9MB8cc3?=
 =?us-ascii?Q?Eb9gpayPHWRbTZMDT+bbbYtr6rigehGryr9JeZvevu0Zr+E+8Vy11RJmORca?=
 =?us-ascii?Q?Xp3kmKH7GQL58s/YtBK40HbL51IozgTQhdEJ2aK5pa9hF6yyCA3iJGbaZXZW?=
 =?us-ascii?Q?0d3CsFIISuCmYLtA5VSvkD/K6hKZk1dLejn+yPhbksTx1jKFcdLOTmH+qys1?=
 =?us-ascii?Q?80NRQXQPjjH/ztTz0UfTe0VpZhvAiSDKBCciTlbZ+uAlCNoDtCb1Qg5e+yDW?=
 =?us-ascii?Q?w6qV3YlJuRTjs6GfjiXoqok1FeVZElHiwJ5bNszS8jy7/xpPQCy19nlA8doY?=
 =?us-ascii?Q?XGK5JAdquva5oMcpx0Q6ijgtKMCKUWc7mWHmiAi8B5x2UModfyrt0pVEbP1z?=
 =?us-ascii?Q?w6YZMWM/FyeXW72+wa62Ia84u1TnlHws/WIbzOsB88XJZWaj0GgfG7vmJnjy?=
 =?us-ascii?Q?b/2eLDtfnrxTMzpZo2erDIhRkKZ8Mc8KGPXhYU2Z?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77cd3efc-032c-4a11-845f-08db89c7f0d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2023 08:53:23.4920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ovQgESb3LRctGoO/TZ69uarWwhYlbdFJkrC/Qwvy02fY14P+vDRRnFBiJbjy9g29ZI4YLGzljmtchOuGtxc96A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7706
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Thursday, July 20, 2023 6:35 AM
>=20
> +
> +static int pds_vfio_init_device(struct vfio_device *vdev)
> +{
> +	struct pds_vfio_pci_device *pds_vfio =3D
> +		container_of(vdev, struct pds_vfio_pci_device,
> +			     vfio_coredev.vdev);
> +	struct pci_dev *pdev =3D to_pci_dev(vdev->dev);
> +	int err, vf_id;
> +
> +	err =3D vfio_pci_core_init_dev(vdev);
> +	if (err)
> +		return err;
> +
> +	vf_id =3D pci_iov_vf_id(pdev);
> +	if (vf_id < 0)
> +		return vf_id;

this returns w/o reverting what vfio_pci_core_init_dev() does.

A simpler way is to move it to the start.

