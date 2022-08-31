Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4A15A795B
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiHaItD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiHaItA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:49:00 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2352EC7411
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 01:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661935740; x=1693471740;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=KdgN19ZYSUZwXgx3tUtPw/p4Etg4nfpB0jFZAB6inbQ=;
  b=DRTTDLYlMqDN262nUKCoO2NeHWLt+H8Oh9OHMmoReYCWBLl5VOQDoXsB
   aJc9YuENqX7moXeH3rPsk1eU97t+VAgAER9Y+B9BM2Spxi5s/szOnz9dd
   GsBcqKyW3sUDRUipeTlat+8t5voFKhtTW04TCatTkTDZL2MDpncGBZItB
   2R7WoT84Ar37h+zHdN2s6REeZYxICVuEFzz1IqrMk6wcTxl/06PGC7Ne5
   GhRncUrrXqEbMEJK0waNjxAybLUMLmy/DBom0y/R8O+B3tJPoyuZBfPf4
   nnApgv11BAwId4bqrqpBMugP//NJ02ok//9GbjlLbOLMpkrfP8oe7UzKH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="296190213"
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="296190213"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 01:48:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="612027748"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 31 Aug 2022 01:48:59 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 01:48:58 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 01:48:58 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 01:48:58 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 01:48:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ds5irscB8HK2tygCJhNF9/zLJetrEq3c66wYNMFPsDHGGr9swhi5ZXEAKJpEry06eymeF1p4PVWWp03GmxWQuqZQmBTwzQxr0NuWE2EHQpRtL6ZzfXMlNXGHm5QYUJjQqWEMLsEDYuzYkwvV312yGuzpUP7nHumGA7dY19M31YuNUXqZAmlu7sIKFQC5ulJnD9ym/KkuDWbX4PGkDU+Ckb8HRW6n7Ye+uV0GpDmjtW7oV4JFz/susKR8yPKuy6j3cAuFjSZ66n34ew/I1uGxFKr1L54cYKiiDSwLyoiw6e53wx+3t74WEPo/u1aZx5goijKgcUr8j/2tl4raZsKnbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qj/4wDeC070zJ8jJy9fAHUHyZGumnabyzS59oD0oPmI=;
 b=WC6fKq3zad77Ubv8KK5aph+itVfRyq2AJUfSPLQOnTHlbBMy0N3b7qvKCWHiaZnoFwJNqQp3a3M7Go9PrkqYBLEoR2yt9fPNiDgaWOlwxvLBMthUWAMtgjfRXoOyUuwkOHMRdLf4UGhPbx6W96Lhe7y8Tb5cLDkrNk3B+AxE+VNFnRyfknt1uAExS0hLx5PCsIIFZq4S25zVJ5BRNcmI89AkFFACrg/5Fv+1Asxi4HzKOwFf4UIrZ9WKvBvOXaSizLIfxiEFZPj1G3RasViNw8hKZ0/5zac6BdyEs/I6F9N1FZRIWsqVYX0/djhgG7z/GsghwiLtMkxXfXufAnNZtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MWHPR11MB2062.namprd11.prod.outlook.com (2603:10b6:300:2a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Wed, 31 Aug
 2022 08:48:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 08:48:55 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 4/8] vfio: Remove #ifdefs around CONFIG_VFIO_NOIOMMU
Thread-Topic: [PATCH 4/8] vfio: Remove #ifdefs around CONFIG_VFIO_NOIOMMU
Thread-Index: AQHYvNVUPq69b/lv8EmXj62LjeXVRq3IsxKA
Date:   Wed, 31 Aug 2022 08:48:55 +0000
Message-ID: <BN9PR11MB5276255A50937E1D2C3590B88C789@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <4-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <4-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 296ddaf3-0402-4c34-e51f-08da8b2da37e
x-ms-traffictypediagnostic: MWHPR11MB2062:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MY9B4aO/jqDtNB2/psl4Y/EvF492Bd75mngYCo2q++GZhR66BiBCX2SzboLvIzAXjiyWGLbf2KwP66BjD1iDzL5Cs8iEsVfTP4aXYJ4V2lim7djL5Z6HbsoJBXf9DR+MIoiJGjvTGpAyLGejThdqsRntPKPoOSRj3rOn2MTF7lgm7fodRzHI4vNQm7BMyXwSauzTliHDV9GBXjRAjw9cmk81nY9Y11M77svuk6Wkat36GcexjHf4D6mz8PkPExy1EEzFkDAcjuI55sED1pigjlcKbDSFSGB7FerKzY/Zn/PHVSVrwJnlNZU0F9CpVdpOEaZWIsgDZwzPTV9pW7WgK5bsSc89xStwljD0LjbqhFm33sJA/BQw4/SRj09QbNXLTMyeUmaGTHKqFZnw6Zi9CD8Z119+mtqSMF0NhTlcPWiYvcbuYZJPU6RskyGrwZSwB9BLOFp49Kpcs03lE6MF2LMo39ixeKCtV8OUULVJ386/GQE8Mb5h1jdjXRn653344L3euN5Db8coe8Rs71IttcmN2flF+PGDcMQkD1F9OZjVNY7JV/RJRn9oLAsQY97Janib+j4uN1Kp8YLsX0hSsbTLK1JSE0YFxm9i+tkKsYc4GoqzqE/X1/d2An5Xs6YlSgeN/NBqXbQVOLLLt+ntP6+ZJqGYKXUTU/o7cYbKkbdkTEka+i1Ww+WBMusU+wi9DqC4Z3oI0SkZXWQbo1s0l2ub8wfIvq6j03mYzAISSyq2MFRix+eeMt9V/VA1LGpgnx71WWNASSZVvT1ZWezaZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(366004)(376002)(396003)(136003)(122000001)(8676002)(5660300002)(66476007)(76116006)(66946007)(64756008)(66556008)(66446008)(26005)(9686003)(478600001)(6506007)(7696005)(71200400001)(41300700001)(82960400001)(86362001)(316002)(110136005)(186003)(2906002)(38070700005)(8936002)(52536014)(55016003)(33656002)(4744005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BgCo+P5mLvXyoqSDA+gbCaXsUR/hecUANW6C9CRsDp1WKB/oWeXNbIYDET08?=
 =?us-ascii?Q?I9D2hg84CHtNL53HajTM2ODSX953yLDkKED24xDGHPQwhrSOzP9dTd5iptH2?=
 =?us-ascii?Q?L8nOFVZS3n4Fw3I0IMMxANPDuiEqjcMgn1eQulhQPzA0j4AT+KCYVN+xKxSm?=
 =?us-ascii?Q?VphR8/Twui6YgIUzUzszkVFA6/ConjNJFCprcdWaGMVnMS9ePhar20PAFpsO?=
 =?us-ascii?Q?f34UJOTyvHdqoo57ICPtMbcz/Zwu0XtPJp19WOdiJe5fjYun7q1U9k12ekeu?=
 =?us-ascii?Q?t1ObWpZQJAsUSxMUp/J+7t5huRY4ZVhqUzyVQjJFTVfx4Hz4PrdCyhS0At71?=
 =?us-ascii?Q?luOxLFdlHJA17Jq8OPjq+99CkZQq1zqwXNSr6BGt8ObixmZM1/Akw5gTjJGV?=
 =?us-ascii?Q?StQ/Fl3r3fExmCvddGojghTOj9yuNXJQ4/xwnpowLBOmKaGB7YyyokwGSI+A?=
 =?us-ascii?Q?54f42wYtKSHWPDpbtLkbQcKhYhHDdU7qvilHNWYLeB29AMiFKUlUzoJKY6/r?=
 =?us-ascii?Q?hT2MAxGMXk4SONaL69BwHIjrech1iLO1cnbcjaLmHU37kxkILpZal4fUKCfJ?=
 =?us-ascii?Q?JHQuAFnsXG1KTMHHYgPjy27z4HHF4ezOy8S3d80GNCZUqMz+hiPtKvXUpYXr?=
 =?us-ascii?Q?JjylmbGkGsyrQjVJMF54lNUIlGeycanFgdwE+qC3z7Gm7uVqRgppJX3iSLYd?=
 =?us-ascii?Q?w7ByXJmqKoUl28ewFxvrmdOt64KQtLoPUC0i1OSi+jwa8hoeD5hJ4R+1ECmr?=
 =?us-ascii?Q?Bj1kayyPoqbpNLJ7rdRXyGsmiLkcBGRpYwOSCIQS6u3ZY1fRtXfrxqcI1Etm?=
 =?us-ascii?Q?BIKLpxsg7XrUcagVoEQormOcpLGh/qVtMI0GtZ7q8MEWBlYCZMlDWSC77EcN?=
 =?us-ascii?Q?juNQi8BmbPS2hllUOaSnt8l7wWbVU3hdd/AGvwgJovxENMzhmRJL0yaDRa6G?=
 =?us-ascii?Q?XsJipKDmxXR67PCGlokkf60wFAyR1scx56kluv623553O5V/QJyYs+xOE9aS?=
 =?us-ascii?Q?j2L8dYNkKgMsdE31FEaJYUSPu8ZjzXa6YKIVBC4eRrTbWlNmoc9abWqVk4cE?=
 =?us-ascii?Q?BDLaGst+R4Yp0Yf/mpBS176qmYjar/8iraLJpwGPJNoPq4upJ5j86r4FeZoM?=
 =?us-ascii?Q?5r1x7sIDoEjSszOp1QA0mjjUcEAhEbjy7WvLNOAf2dQqhg30eLmUiYjLgNAR?=
 =?us-ascii?Q?RLwNlbu7XwlAbJo0G5vv8if10sjzHBCKKB/0Tj7uvXwjSzjqvXpyHnq9GhBa?=
 =?us-ascii?Q?hP/YSeEDQ7VZ2//Y4OctPky0OtjT6Sv4rZmhVtu77DO4r05YmE0WUgRWiaWV?=
 =?us-ascii?Q?iLEmblyEa8S/EEID2Bc0QTb9Z4ZtwyF7hWaXjVq0vzkQa3y948ZqqXndzyZ3?=
 =?us-ascii?Q?K922V6M28wb++MNt6Kzj2y+bbEHs1k049d4YgGc5Puwy+0S36vuA4fHCUuk1?=
 =?us-ascii?Q?4C7w3dXR36R9btUv9HM5ivJgrDy+kf5urqP/zyBzZ3b3B0XwFM5Bf4++POiU?=
 =?us-ascii?Q?YX6UsPDX/jTDU6hLevtYbUIapP3Km18inIg3JDRhBUQjgQ79ms+1lZyhuPc5?=
 =?us-ascii?Q?RjVIchqROnmXAzw92fh67hp86cQ95VnzXrgH0psy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 296ddaf3-0402-4c34-e51f-08da8b2da37e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2022 08:48:55.8982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yiSIWjvyrmB96jv01kVm7ZMgnqH9dP1UJ3KHA5APtSY0BH4Lh8gGgYjszC/qOxx9oXVrLcMOIaBGbXepod3QHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2062
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 31, 2022 9:02 AM
>  #ifdef CONFIG_VFIO_NOIOMMU
> -static bool noiommu __read_mostly;
> +static bool vfio_noiommu __read_mostly;
>  module_param_named(enable_unsafe_noiommu_mode,
> -		   noiommu, bool, S_IRUGO | S_IWUSR);
> +		   vfio_noiommu, bool, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE,
> no-IOMMU mode.  This mode provides no device isolation, no DMA
> translation, no host kernel protection, cannot be used for device assignm=
ent
> to virtual machines, requires RAWIO permissions, and will taint the kerne=
l.  If
> you do not know what this is for, step away. (default: false)");
> +#else
> +enum { vfio_noiommu =3D false };
>  #endif

what is the benefit of enum here?
