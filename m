Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F5C614602
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 09:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiKAItl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 04:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiKAIti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 04:49:38 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9EC14D10
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 01:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667292577; x=1698828577;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v+3KFEgBtM+e4MZZy7+CsmBx3ZMLWgH7H+64XLJMajQ=;
  b=fX5k9I7aUllHW/meGgri2tv4XO6SNdEE3UsABDJ56xSxMay0GPNIpCvm
   XObT/5XWjVi05TXlXpGBRWxP4zopoS+5nmWl60taoZ16SPCCdYpnZXhDj
   sEx/VGA4oewfuV6kkjZgLZU2GE3yaqHYpqwppxz0kOR3wl3pBH8GFznSX
   HwI//yS/RDdwhDtDzaXLnKuJBIjNqHQF6H1Oxdr89LUfXhoJGsFOzfNbv
   cau251JGnY8j/nY4GI5PyD6yCXVekvO4qgH7KiyzeGDizVEd1XffBBplJ
   6ZnJYLmHiVxORXIXjXxlpL8D6Y3nYkQh6+L6eFNRIYBPxshDXa7/eneXB
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="395408825"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="395408825"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 01:49:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="808841506"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="808841506"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 01 Nov 2022 01:49:31 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 01:49:29 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 01:49:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 1 Nov 2022 01:49:29 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 1 Nov 2022 01:49:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACzpKTN81q6r616EPf2Gh84rmUBr7EIAV3BV2aCJ1FQ3nZ3L34sTJ7gK/e090+mGWZVysDkj7QA6UK9I6ON8mCBgs0TdMh0fvMQy/+ybu7S5eWamCUcs1rT1WmWUQx0YgaeSDDJFL9jDjAr5kfH4B/YbryjmkkKwHuamGWzGYX86kI/CZh85mjBFx8cbG/D8JYTah+FFiL3odZETNT3I/iIAEph0E51o6bdB2A6C0GK6imv4yci9qFPseYTspcS7V6dhVPEZRdu0CcNGd+INmV0brx9bG/3/sybyT1jWOgw2uLAL67XNyYDlBMeAksopUCSYEGUHH6SmXPrxHwIfdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+7qAWA+hL3eAiR98CipUGdapSsilK3aGb2/qdpKbvY=;
 b=g/iknk6TNJuPwxD/sSOwtlCVW1AeyyvIxXf4WBahq1/nwsL/pZMfj3VxKQuSPu1fPDfl0YXN//OVNBY/XstN8bwC94cWlNZYiQe+droknxYMxPQkLCOtMa2NK2tITueYoISQU45GmwPCYKvuH+adP4H8IRkjWjS4CxstxSenl/BtHa7pO95IFqqdazUC5A5NgB6PysK5dv0iBUwpGz+RD8V8wtVPfyX8QrY+FQEy/oxE53wH45org5GliKB0kOggtXxnVNWpgG+YtfoudSCCrQKndhw+SiO9ctv8nYJ1QUZXQDWQSAo07OYANL5a+4aB4jdtr03AtwltIW1Jo9C1PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4576.namprd11.prod.outlook.com (2603:10b6:806:97::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Tue, 1 Nov
 2022 08:49:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::737e:211a:bb53:4cd7%5]) with mapi id 15.20.5769.021; Tue, 1 Nov 2022
 08:49:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Anthony DeRossi <ajderossi@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "abhsahu@nvidia.com" <abhsahu@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>
Subject: RE: [PATCH v2] vfio-pci: Accept a non-zero open_count on reset
Thread-Topic: [PATCH v2] vfio-pci: Accept a non-zero open_count on reset
Thread-Index: AQHY6XO6kPn9IYiwikCCif+DPaBD8a4pyZYQ
Date:   Tue, 1 Nov 2022 08:49:28 +0000
Message-ID: <BN9PR11MB52763B921748415B14FFB57D8C369@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221026194245.1769-1-ajderossi@gmail.com>
In-Reply-To: <20221026194245.1769-1-ajderossi@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA0PR11MB4576:EE_
x-ms-office365-filtering-correlation-id: 3fa21f5e-3f29-4a45-364f-08dabbe5fc4f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6MFhv8pIHWDMm/r+V93hsuP19pibEjzP/B/jeknz6BG6b2JwWX04fA4a/vu1GP72F/tcRZ4fg/fReEyvYqOm8fVehs+MGpaI1RWj8/wwKqAOtRN7/buNredijCj8RCbbyz0zg0DPk1OvP5vUbPNy8jGCGrJRZOT3DSrFoN63AzxTlqm/R7bwcxjqMiACzxNW00q0xRLC8vJTeB79qlVQByNKrlftzx6Ng0TFkjEu8Pd91fvmkpr1q9qBEgxaSetNgGqqUDz/ML7nhJ5apcCA5/UdL7mi0jhLJLPWkFcS5oT8K/YVaxwLyGFYsSeh7eUPx+8PymTJe1XDvzhq+WjJfCdUPEZ+NHrTpAhDlFGQgeiNZ9GnP2lui8FFDz5VpmHrLEBUG4cdiszrlHh3QowqDyjKhWPkWlGGUu6abR/MHONZABNskoaQDVc2tMmpV8LpeCJl6XfXsH9rYe0+aAFA6Hhg+3kwRua/OIAXpSDGsDYMvA+y4vBRdvEVorC63JBruTGTe97HjxzQs0dHUJDQP87D95AIQjUnjDnd/2Fsdw10UCGJhQQ3lc4ihg+4BVgatKmXdHx9aJCtb6WB7VqYI5R8daBtOoWfNsyqGRtm+pvn/EqCEWtFpEd+cc88xpptdDNHXSPSWTKq7m8bP0guHPZY5i4mVt/vdb4aARllbhrOkgkshzTRT8tLszBuqmqywi38IZd64IcEHWHVfDtMku0yfxy/2o2ipBoSbrzB4eufNoWlA7t941Rqi9fMw94y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199015)(86362001)(33656002)(82960400001)(38070700005)(41300700001)(122000001)(38100700002)(8936002)(52536014)(5660300002)(316002)(66556008)(66446008)(110136005)(64756008)(54906003)(4326008)(66946007)(76116006)(66476007)(2906002)(186003)(55016003)(478600001)(26005)(9686003)(71200400001)(8676002)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?822Db30hi7uQw5onIw895rCL/f5BVOFWUv3vcf2t5ZBSs2M7Ktn6mElpzvNL?=
 =?us-ascii?Q?Kg8JxZBKt3zfn9fiqfgFi4oAW2kLkfEIkb16ya25oWqf/SI/2VsPaB6q/TF2?=
 =?us-ascii?Q?7lhuVmdEAeJPSXi6Boak7SV5ZKs8wqeXFp4EEtLmUD2NNhC/Oa+2lEyDbgVG?=
 =?us-ascii?Q?RuTgZEf4LeTqHbcRuingelrpVQi5aHsAqxn78M/Iwe2HSq+jr8BRJIUckXXs?=
 =?us-ascii?Q?BwHstGuKZ0Aei64c5bPvRoEKDAvNBAc2Dnt5fUSGExS6aPgupahQVZ/I/On9?=
 =?us-ascii?Q?DprsDqP9G453zj5u21zBlOcbt1z9XdC7EdrjmuGcsCbUwvjpyQe/hE4O3pnj?=
 =?us-ascii?Q?iR6kEyNALutIL8G87CZIZ9cKDXF1XNuiDhCEIqfI24h/HEPJWNQNu/lLQXND?=
 =?us-ascii?Q?Bs8HZb0EB+261mdy5GTePz8ZVjAmmkIoby3KpTjZaRz5BBuH08YcFMaSkGW9?=
 =?us-ascii?Q?GAVjC7H1A8wyeSW7RmDDmlXeAz1GOd8Nv8salXsqaJntAXMOuuc3lrHHi6/T?=
 =?us-ascii?Q?7yeEPw1hAeGxyJtggieaqdOn2kt0vIknlKRFyChVM+UNwF8jI8tM8u8YojkV?=
 =?us-ascii?Q?rZIOTcR28WhiSzg6WG0NvUfQYneZH3c30mrN9M44zDxDNC65rxbraYFFOsiS?=
 =?us-ascii?Q?+OM6OALGdvewUjEirTaFcqYZR4F/7D10CgaQyo3UeSU0oEEA3g0Zw3TRSHp5?=
 =?us-ascii?Q?nHBpi0oZr0XAY1p6e3wKTwOwXF3fapJ9gn70ezXmq2tHAY2bShsY862dHBN8?=
 =?us-ascii?Q?T9gDqNLnXwg4zTH+hBU6GweHlZdz+1u412svByH/3BPq4cW6cl7FGpM+p/8/?=
 =?us-ascii?Q?vtay7zGSlkyaWHQ1fuFsQKYBJiI+IQZsl+Q3Jz7yke+pT+uvFC36FVLKbGnF?=
 =?us-ascii?Q?c9rv1bRkFjafsJ9fAr5bBD6Gvi5UjcdHgUileiJ+rwGU6plvqAxqg4ypUEmm?=
 =?us-ascii?Q?NirE1mYtZSS/8nv10EMJU9nc0ejha0/B6yVsdXhkefG4SaKkijaqg0WXVSHm?=
 =?us-ascii?Q?ta9H9+bu2/9wRkPJCBOppogymSl5yJG/LcbJ+07rUH2mY6mF6o+cDGpHt6Bi?=
 =?us-ascii?Q?xRL1K6IGmeJevAbQdUGUObygrt1axXTc/Lh3rM3X0K6bgwobWK6RIfZSSZ47?=
 =?us-ascii?Q?7zJUfA3Ag5N+W33nf+2akUw7OxpBgqxoXqCJvisRI6ONXQkn60AXZblVHLSv?=
 =?us-ascii?Q?Lz+ZfXijkFLngUHYY9P+nyySAXIeSDGy0haQ8nBlSU9zHifCNmtRAf8g4Hh9?=
 =?us-ascii?Q?MIc9zW2hWOBl+oRXo4lYlaBunSpAGffFYa3xJLBySDvtu9zxLHl7s9aLMMxS?=
 =?us-ascii?Q?iYaobjEjL59l7FivntsA+luEP60FSiiMNjJZnWEAB0zi/xXLBCPfRkOcDBh9?=
 =?us-ascii?Q?TuipuVMIL/SiCmh7NNln22Os4U/eetXhNhbtGhKaHJwSgRhXADT6DNOM9qtl?=
 =?us-ascii?Q?fm0IOdf9wEPfb5WK0vOeuU8luFdki2wwQgFem5XmeuiLTpOPbBfhutS1t+eT?=
 =?us-ascii?Q?QtZvUcsnhK4WtZ7m5fnEUKftFi+B/VY3xaX9HCKkFeDB6Au8uUOuO67k9lhx?=
 =?us-ascii?Q?HgmzA9DeBIyfi+QXgir1jcahSBvTs5uwBVAFyU0E?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fa21f5e-3f29-4a45-364f-08dabbe5fc4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2022 08:49:28.0676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4RFpQZ8sU0gnp36SVDvaQa819qiTzetxVsunhoRW/R9y2vtiq5BQqQwgu9fXrcUKV+SJQw3s8/72rHHbT1pduQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4576
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Anthony DeRossi <ajderossi@gmail.com>
> Sent: Thursday, October 27, 2022 3:43 AM
>=20
> -static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set=
)
> +static bool vfio_pci_core_needs_reset(struct vfio_pci_core_device *vdev)
>  {
> +	struct vfio_device_set *dev_set =3D vdev->vdev.dev_set;
>  	struct vfio_pci_core_device *cur;
>  	bool needs_reset =3D false;
>=20
> +	if (vdev->vdev.open_count > 1)
> +		return false;

WARN_ON()

> +
>  	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
> -		/* No VFIO device in the set can have an open device FD */
> -		if (cur->vdev.open_count)
> +		/* Only the VFIO device being reset can have an open FD */
> +		if (cur !=3D vdev && cur->vdev.open_count)
>  			return false;

not caused by this patch but while at it...

open_count is defined not for driver use:

	/* Members below here are private, not for driver use */
	unsigned int index;
	struct device device;   /* device.kref covers object life circle */
	refcount_t refcount;    /* user count on registered device*/
	unsigned int open_count;
	struct completion comp;
	struct list_head group_next;
	struct list_head iommu_entry;

prefer to a wrapper or move it to the public section of vfio_device.
