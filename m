Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851DF675451
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 13:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjATMWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 07:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjATMWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 07:22:51 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AFB5AA63
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 04:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674217370; x=1705753370;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6xQKgjosfFB1UuaJAgjRvNj7Ta+wQiy0dDTmeO5MPTE=;
  b=C62O9BagFDpHu9u2ZFBpAsEVtYI47z1RtJyKQ80AE4yNYXpmwWuru4oQ
   wRYJeHAziz28UP8oepU74/WK2SizVzdY7lK3HL7mGi3zBuQnAHE/mnbL4
   d55KLzmQkqmTGvndRsF8vOBJNsycvmS+ayyTgdgDA8CzVKxRnJddPzd1E
   2puG4YuT220tjAH0mvbxR36bZKC+Dngybe6JicR0hizt3E4G/8cqbU5I1
   +B5CicIy1l4mc/HLq48KpO08QZK/h0roCHAJTkDpTQkI06I93brjmKpDj
   9oRHDj/9iyj+K6rM7RHvBjbVHXYVh/Mg2EkQl7SwuOvCfRUs+L/H38Ira
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="309141383"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="309141383"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 04:22:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="691039078"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="691039078"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 20 Jan 2023 04:22:45 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 04:22:45 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 04:22:44 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 04:22:44 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 20 Jan 2023 04:22:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Olh4kqct1jwp6Ip7n98coXFa4APmXba9awNgX1If7ZWU2ECg2r/hpEtTFIX+FTPdFzMsAN+cTnIkjtto0dY4YpURKnrNBeSgm3f2OwAF/HYAxg46va5vNwlBTVlT9Nt+rlZXjP+vcR+R5DpXNDu+Qbjs7fvAmzkuOF3GlyA1EC/bT+47PY3z1q6r6JNySvKhqd5H4NC10nJwWpvjegHTGz4Ezt0T9mvWpAdy9ykP8y1zp+ZvapQXw76Jy/z2A03r50mYaLg1JAmHZGLYMY+KIpFCp1R3iuKzaj+0fXVUXARHu49j9hNMn0iXvoph3kio+SdLcEJ69dTn9ma7waH9Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bfVK+GkJOveUNnosjx2nbkrOhX5xKWyzBBYT12/8nS0=;
 b=nM3vrzARBFgBWlepVdx3n2JkpBLNHWkgyHhj5N/s7CbvlT5HQemjNIwBO0nZ2MGidukuTrgg0EfqLatjJX1dS+x+mRF9IPQsv/UZGyPf5B1n+j359r3qeX1l/4sD8K8Uwx3qxRfUHiHY+lfUhYERGvYWs86OhgHKz0KJp99HnRa8arP70FSnymGt/AwvC77XGk12gN0T287P3sowIbBhQ2D2xFYTSwAs2x1yF45x+BrPyPewjzE+o+gF86nAtoUlAkmSS4BlsQ0MtPqcE5dr5la1vC2zy2FRC9tFVcFxXqp9yaFbutQu+gyXX0aMjQeWiTEDTd0XAGNesQOdg0mUHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM8PR11MB5623.namprd11.prod.outlook.com (2603:10b6:8:25::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 12:22:41 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6002.027; Fri, 20 Jan 2023
 12:22:41 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: RE: [PATCH] iommufd: Add two missing structures in ucmd_buffer
Thread-Topic: [PATCH] iommufd: Add two missing structures in ucmd_buffer
Thread-Index: AQHZLJQp4fqaZY34bUe2mikDb21Oya6m4RQAgABZcbA=
Date:   Fri, 20 Jan 2023 12:22:40 +0000
Message-ID: <DS0PR11MB7529262BCD9344D934D055AFC3C59@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230120055757.67879-1-yi.l.liu@intel.com>
 <BN9PR11MB52764C457BF19D3184A406F78CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52764C457BF19D3184A406F78CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM8PR11MB5623:EE_
x-ms-office365-filtering-correlation-id: a96cb0e4-4279-41a8-eff8-08dafae1067e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PElbRzdC045A4eQ5AJM2duCcKSa0QCcZIydapOWejR8poDhTE6eJzl+P9Pn6CCLIIZS78AOCOWKFDwep3tSXW9hv1DDRHAxWne/BLaMl3qx+OyBMX7p4B3/kfQ1tS+SRa9MSh7+oMQUFZnUeibk+MfFzdDnJ18DzCqxft9jv1nwYLNGUFC49R6FlErWwhrDOXGR2EVWUs3cWR+Pv/SUgA05ZiKBCSxvMqRn3qiaiL150weccqzexrv7gBYgsTqICtQz1rkeAMvhFlUIasIGlH6EvPMfRpS20il3uV/e9Uqc1bV/leoOP11Fku34zhmcYMRis+pWsLHvDrvTgJVGNoXUY5URMF6KQZgxFI+zrcg3sBVlDBrLbZVtTd7qG1pHUT3gQwHjGuc/P1dmB49oVTO7lTHASaRxlunS3i7U2gihr+633B0J4yipz8cHKT0R77e7n++Q1r1d1UoVaCy4seIhs7CPIPoqUkUMRPnjt0Vn1gQr/DujZFXHAAeQdpv2AxMIpIxPuM5heCVPq46Wzcs/Juc20yIKdExSGr+KpBCHRvJ6HRuMjNywX1/AOraw4WugaOlD1bFStCexvjjCKWltZS01g4ECdWNuHZOz2UbY5+0a0dCq4AlWL9fuOs+gkVNnTVqTeeo4xkSg/zeUlu5YjSzrD2t/BDna4/IhCPMdZRdx59QP6/p7QmgbR6LOfaBScMTmbXc+wYYggvYypZGv0TnrtG8B5d8cN5axIBjI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199015)(52536014)(33656002)(122000001)(5660300002)(316002)(8936002)(86362001)(7696005)(478600001)(6506007)(966005)(2906002)(38070700005)(26005)(9686003)(110136005)(54906003)(55016003)(66476007)(66556008)(66446008)(4326008)(8676002)(76116006)(71200400001)(82960400001)(64756008)(38100700002)(186003)(41300700001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1bHi04cn+ZgehwP+w1d/Mxx4pSURR67y7K+rRV/ufRJYiwe/WEnhwy0Iq5FW?=
 =?us-ascii?Q?sllDX58IQP0JYwcwDSy2QPl2Nt+hLLSBEZGq1uW7Edzjt63osOE3zbcIphkr?=
 =?us-ascii?Q?9mt5PvhK5HB6dBgijNaJ+SkU73B74XAaQ58QAtVIsSkjDl8s3pInq/irjv/x?=
 =?us-ascii?Q?iI61vjYQbq1d8lz/2lhj59gOvs0vRHELKCylKU1XiXCQ7V3+FybuVShEk0a3?=
 =?us-ascii?Q?Ggz2+LS0DoE88NHQ159LwJsf1wAVQYDd7yc3VmXzV2O2L/DaDyI/XLCf/Go7?=
 =?us-ascii?Q?4Mx+R4UqVowvv2b/McUOe7innafQ9+QINux2WbZD/s4owm6fLo36Wh+TEUEl?=
 =?us-ascii?Q?fS+wNKtLxbdM+5hWyS/4JSIBTrOAxVVEkCAUCszatjjzIiNfLtgdsEWMvJ2N?=
 =?us-ascii?Q?9T02L9PRvuTLGKmoDVf1n+llkgxbK+Qwe2CWS2JKASPx8wv8XKl9ljfc9bR+?=
 =?us-ascii?Q?Lx4RArt8ZFT8803RRxr0rxBTRXTPOgnmQOh6RE13lIOfEvTmfCFluMGfDIZl?=
 =?us-ascii?Q?MTby/bPciM4wT36lSmINCEetQBPP/DXI5r0a5lkf4n7+ObVdj0a6RvssCxl6?=
 =?us-ascii?Q?dlD+xQL1HLtXSZr6T6cf+yyYlsWJYTwzAwI8Nqih7NyHODpxotu7EGAMZKVk?=
 =?us-ascii?Q?I7kYgvago8yDx5c3qxAErlx+oitrDvbcu0PwpP1Ytv1jUFlj8YejbEUg3Zb4?=
 =?us-ascii?Q?HLKc/X/xhn4CSHLbNbSkd5LyIbfgjObUnm3ZKm20sui0uGfvWouBhVNrSeUI?=
 =?us-ascii?Q?sLPuEsuwIKdUdXO1q+v2WeW+Gika4l033h/PA1ikHFf6SiM70MxcuyJ66KKo?=
 =?us-ascii?Q?4OfjMeoRtIo3M6yIJN88j/BacCNZG84qes3I2PObTIZzNiv3uYCeFonzOcdd?=
 =?us-ascii?Q?MZq59FHyw/ASnDzV8lduIw2jQxpKAqC15I3S1++V5xGx+ZSjnyMaAoBiz66S?=
 =?us-ascii?Q?G2ODlaf9IKy/uSfIIN4ABgd0KKKs+iogeq0cxdt444gEtzFU3eF0LeqLDwNY?=
 =?us-ascii?Q?Ie/Lu25tuIQFgdwbfugN3xktbIgV3lv5nroqF0/tviN2HQTLD6W9sjUhcfJG?=
 =?us-ascii?Q?Qxlp5Rnn1d3VEVPEKPG7XGg0wXdjiYKy8RvAX/W1vP4GSICCyfXFs2LRS8bn?=
 =?us-ascii?Q?r12tFMMhbW7EhfGDuaftR4szQQ0n/eS12g6sIgD4tTIwSYxQbjbyYLSyEy5R?=
 =?us-ascii?Q?p3us4VW6LBnVirioL7uSTlGUK0Fvftr/i3vuBnE/LjKzv6+GnrV+/76ykAFD?=
 =?us-ascii?Q?N+J+GebNgLvFWztmaww51kEPawFWtVZXr6Z6UCEAxQ7cjniYaDRYlmGeyYX+?=
 =?us-ascii?Q?QEoVFD8NJuUtNqxGJerP5mqSO07FyVmpg7iWvK52sj+ESPen/PwjtfykOVg/?=
 =?us-ascii?Q?sXMG9YFnTUs+4xEhwnyAkS9Jn/eFxxgq2U6lbL/PpGUL9qhKWEwQqipQ8OnT?=
 =?us-ascii?Q?cmQMx2ooleBuPjfBlzJJSNuuQ+BFKdc7+TKiN+S/ezx4hHMTW/Elns67SAMq?=
 =?us-ascii?Q?tkf+zo1U+mUtPljsx6I5dTzDbWqF0eOmMMhSQp04M4OnP8g/xT7NwoklRxdE?=
 =?us-ascii?Q?0OTADteqrcJVnCct4Fwq9l1vXoynDn2EVs7mTJTq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a96cb0e4-4279-41a8-eff8-08dafae1067e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 12:22:40.9445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mrzEEHn3YAatrS5xxlzxHufSJwQ0TkdO3+tV1SOBxtt409U0/XcLY0UOen2w+ASV+p7NGz+7Q7M65c9a1fPwJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5623
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
> Sent: Friday, January 20, 2023 3:02 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Friday, January 20, 2023 1:58 PM
> >
> > struct iommu_option and struct iommu_vfio_ioas are missed in
> ucmd_buffer.
> > Although they are smaller than the size of ucmd_buffer, it is safer to
> > list them in ucmd_buffer explicitly.
> >
> > Fixes: aad37e71d5c4 ("iommufd: IOCTLs for the io_pagetable")
> > Fixes: d624d6652a65 ("iommufd: vfio container FD ioctl compatibility")
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> >  drivers/iommu/iommufd/main.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/iommu/iommufd/main.c
> > b/drivers/iommu/iommufd/main.c
> > index 083e6fcbe10a..1fbfda4b53bf 100644
> > --- a/drivers/iommu/iommufd/main.c
> > +++ b/drivers/iommu/iommufd/main.c
> > @@ -255,6 +255,8 @@ union ucmd_buffer {
> >  	struct iommu_ioas_iova_ranges iova_ranges;
> >  	struct iommu_ioas_map map;
> >  	struct iommu_ioas_unmap unmap;
> > +	struct iommu_option option;
> > +	struct iommu_vfio_ioas vfio_ioas;
> >  #ifdef CONFIG_IOMMUFD_TEST
> >  	struct iommu_test_cmd test;
> >  #endif
>=20
> while at it can you also add iommu_ioas_copy?

Done in v2.

https://lore.kernel.org/kvm/20230120122040.280219-1-yi.l.liu@intel.com/T/#u

Regards,
Yi Liu
