Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA4169EF56
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 08:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjBVHbW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 02:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBVHbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 02:31:20 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CDB311E3;
        Tue, 21 Feb 2023 23:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677051080; x=1708587080;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bImcU1Rs1IbBOuTSlhg+yfAe/HmWSfpu4qlUUKv57GI=;
  b=Dnf5VKNyz8sHZvuxBJ01bckEHuDtk6Ol0bcPJYzkBRSmeC2ed4keY/Bk
   m39LD+NXHsrR4VbuKhA2ZSU3VJb7dTpP7f+fxRls1s8YSx+83zGYm/lOv
   qxPHWB62OR7UwohZ2p8FAbULAnL7V+koCG/TLajVbxAhn896Yaxl4fkXM
   H51Hbzsj9pOrJt5NJCF/gpML5UGGvyaKOpMC13g8KHeCbAWPUI/CRGLAl
   GeZJ95F/ZK3c+1/7YkdYSW9syFqsuoO7MxSGmsdF1KWcJBWVjY0iteyJi
   wvMwVwdea0PrF9Qg0PYnLPz0Q45JDxQRsOIHkTqapmThbW+mvvgqnyxwO
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="335054003"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="335054003"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 23:31:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="760852725"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="760852725"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Feb 2023 23:31:19 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 23:31:18 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 23:31:18 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 23:31:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eavLJzc/oxeOpj8zLm2weglF2wnsaBqGLL8Pa7MkWU5uENxp6UCyA8rWmuv3XaheDjKZeKm898W4OZSfXOQfry/xWc5FWttC3mgSWNLiEvTcc2ZOMdl7NlnXMFGdm8XRXn7GSQPO07Dhm+lHSMHTt1c1MgcCKjgjpH94i0QrvFWjtK61MCkIQVOEP01NBF35EI+SuQrF0/p44cqtiJxi56p7LpAKUhYtPqjsxGHehY1BJJRpHHs8NRp5nkOOTcVX4LbgzQFyuJpATpistY6FEI4al/yVHD26MNjYXNneRUL96CLCseFip0GzFJi+/MCvbnNLLSsEFhet0DTGrwbiyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iO38hj6YIg7iWbFrJIMsmk7HC/jhNhW7QLYkL6gke9w=;
 b=SNCyxXpcsfZPrk/WOfqEiZ50XtcwTchqvjm5D5ct7aeiqMYFo1y75/QfcxYcXMdcB2nTRev2Xdc5KubpwmwFzQy4BwdaMf0et9CvOjiD51muf0NL6kY6eJUEOYIpMq2rWLSFhAl75TzMOeBVS0kSV71DA7buN8TVP8ZyTwZK3fdv7sYOeZ5F20jsWAew1l7B/hJ/WQ/sALQ4WUBCBL7YQha98Ejo2JOTJXseqaUzY9F7RekNGwvL/Sh229iThzLbvoP4s+An9DuPjnOxGNxph1F9AT8ndgcZQFiSH5wTvFV+GZ6lvJes+4HMVAOKJp3vZAyZCT+tqi6p8jLGt1j7ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CY8PR11MB6818.namprd11.prod.outlook.com (2603:10b6:930:62::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 07:31:17 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f%8]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 07:31:17 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
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
Subject: RE: [PATCH v4 13/19] vfio: Add cdev_device_open_cnt to vfio_group
Thread-Topic: [PATCH v4 13/19] vfio: Add cdev_device_open_cnt to vfio_group
Thread-Index: AQHZRadjJyQ7ueBEDEy9FED4ogg07q7ak6LQ
Date:   Wed, 22 Feb 2023 07:31:17 +0000
Message-ID: <BL1PR11MB52711A9ACC345FF2FF386EBA8CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-14-yi.l.liu@intel.com>
In-Reply-To: <20230221034812.138051-14-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|CY8PR11MB6818:EE_
x-ms-office365-filtering-correlation-id: b394bf6b-393e-4c26-33b5-08db14a6c8e4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8DBv9ILz98R05U6nRzkPyi7fwC9eKWyCQ2lVGI0VospxQ2OSX4kmH3Ljruvy2aQwvEv4PR9PWN8t4xf91ldkQKdVcfmYhk60tBk3HX3pDRkF93Ekp/ShvgaUWtMwCE1WjOlnKRhOP0WJugjWF/8GQADUhlEfCBMUolNoQkgvfHFrqovvfV6GADhHzoKH+jHdKrK0rnpk1esaqkKKsZ8k161lyAncaaU/HaDjW426Hv+wnydDrgL2q1fQvJRZFSRJqnC0Hd7Ap1coMRE1ULvaDFTVyZO6J3ENZTwMEF/ns5qzi+Nh4SOXY2r4igIKZZc+FEFNPOww9v/xSFkRDJ6KEcR8oEL2QhbDHndBa05qRrRrPuLIfG1Y//6DKGU5JhpAEAzaF5kfOYdvPprM7T4ni2JJctBGpNaw3DVvI0RYlJf3hyh57Q+bdjKjZV6PtDZ46Yl3si0OVodSnZTVmMH+DV9FdRQ2GUxobg8cLbODhGXzQLD0Q0szIU9yLHYzbNXCHdZX7Zrv/A9NZtO9s62ATtRoxk5ZsbcNG6b27b4z2SqMMaZWtVdB5nkdw6UWOuVwGsa41beKNJe5Lq0074jz/VvYG6vjtX58CV8dL5GaSPFAwO5XoF58j5qj4jFyZdetq3oBRQOQ3bTotazXmR2OGwBmFB2dqX9vuXnDxmEzsdhiYvEYX8tgX4TVkC/wjihFLbas89SiQTUpJpTUT2bnlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(39860400002)(346002)(396003)(376002)(451199018)(83380400001)(76116006)(66946007)(66476007)(66556008)(66446008)(2906002)(71200400001)(33656002)(54906003)(110136005)(316002)(86362001)(38070700005)(55016003)(478600001)(8676002)(82960400001)(41300700001)(7696005)(122000001)(64756008)(38100700002)(8936002)(52536014)(4744005)(26005)(186003)(9686003)(5660300002)(7416002)(4326008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s0EzBjg4VL5ExynJ/78mJDzYkbNIGQi5oCNCsWnRZLh5JrvMgKtRbRM46dNk?=
 =?us-ascii?Q?OmBl4yfGH2EK3V/gIb2c+rhwJ2Ch3d3hpfHJJU/k4jFuWFKer7lbMJmYdG8m?=
 =?us-ascii?Q?mnirkkQ7IDK/FggIXqdIFmNiyvEvj4Ld3rnQ9kRSTLRKd9cxe2RN71B3EYbl?=
 =?us-ascii?Q?BtHaP/Y+aP7YqKQ8+nGB5YRGysyDs18iOSu1ChFEX7OuitsD+5hGIB3v7K5L?=
 =?us-ascii?Q?lAsBrIgAGcl81OPbVOR2UdVRXn8Fbr7BxFiUhkfe9jxaH+ab9L+/mgykHXJl?=
 =?us-ascii?Q?qRRZglVMecLn8a78OMfeODWoiwzf5z5ss+KMae8xUAy2ma/0Sm/djRHiGSL5?=
 =?us-ascii?Q?PN76JqXVOMWuwj0FD2C1N1HDu99Gd++v/i7f883hDDTwEuTwJcWcw9oGrXoN?=
 =?us-ascii?Q?RZklAOqXfj9AIIIPMM9aKRxtDfs3ijg7zI+77QLRpYxKNqOWnwCM6laNhavl?=
 =?us-ascii?Q?cCnYfOMdiCEnXl0uw0vzJEcWaxVc2CTfhEp6TS5syE2B8QvIME49gwT+n7P4?=
 =?us-ascii?Q?DQ74WRLR9rrkxVGO426uV9+MTOhJjXCpq1Sgqlp2+3xCLhCXuy9prk2K5cB7?=
 =?us-ascii?Q?1Ic8WUQN7ag18A+dW/NIXsgyfvPK9sm36OipVrveZoCpt2eakj8204EfTph5?=
 =?us-ascii?Q?zDNQ2wZImWk4QqOqWt/CQfL5zi/Zk5gi3uvwdrrqXUenT1yHEItQEJaugBU0?=
 =?us-ascii?Q?eTIJKHTvZ9VCTpRBnJgBADeiFNSiOSmSIUmpOM7saCZH1A/yQn+q2TpCo4Zh?=
 =?us-ascii?Q?BF2seWVdXMI3GxUD4WwD6tB0jwPn0JGWjbIMtnUeD6v3LwA05MgDbo+Dhcne?=
 =?us-ascii?Q?yf5WzQeZ9krd9fWAcA57TpdtDHUXn0LXSIAxgKXOu61nlUNtoc8N8SDecKnW?=
 =?us-ascii?Q?R354nZtQL4KCeY/kCgpiSdpYJ1PIr7+azI117uoLPqsTCrwmFbfhCnADlAxw?=
 =?us-ascii?Q?1xkHH+yeBmMCyejDNq8J8ksC3fXjEB8tuY55MteEUCDspYFNAE7apgtIZkGS?=
 =?us-ascii?Q?asmhXbhaIMqT0YtUljpB4r3pX/7SGDJTggGw9qJe58PNuOGHDTHYaoVIZIJq?=
 =?us-ascii?Q?IPVItOs5NAcgzSdyYRfu9nW5DKzoq02r97Bc7Pacv61+FJfecgLKy2HblKOI?=
 =?us-ascii?Q?1x7CZQ/RI1Y5uDCHWxll+gPBR0Vfs3WCy5b50snaFNM1RFGm3X6xnjIMltS7?=
 =?us-ascii?Q?ROuF+ccCCPmgUSoyGBWY5FxqSESpH1hbe3EFaZrHVup1dbeF5A+qOfhKt4ea?=
 =?us-ascii?Q?HdNcEUUguzA4B0jQu4GbgRkP7+63COGCEQ7xw56okAzGf6isUFx/Orfuaj0E?=
 =?us-ascii?Q?hx+esf1UUKQql68S384rNYNDgFCFSuJm0wSKTocszli1Fc/m4NeNZ1SCP1dK?=
 =?us-ascii?Q?dlrKhBqmu1PRY3CMVT5/VScC5AL9XO5HZj7UUYXqbSYVmQ0LBgNo97pdsU5d?=
 =?us-ascii?Q?Uv0H6pfCDnWSLHm3iXDBcy/lRkdRzs9IdvOrmVPA1G+2j7fakGno8uKANTFk?=
 =?us-ascii?Q?eE4Zyuin0PHkKDfSWobEB/Jub7W/R1d/E0D+L2oIdMixNP0koaXtHJYflUQl?=
 =?us-ascii?Q?qcKFKKTwHFFn5rsTOdqD+gZ2bsNasdeTVyy7nukd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b394bf6b-393e-4c26-33b5-08db14a6c8e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 07:31:17.0426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jy3wd2H4F6LGF/jONDXlpjP0YyoxmHwR+OpgUVKQHb/Xokdcy36Q5Gf59fqru9cNZQg9rCa9CF4Fj/BKLlnVMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6818
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
> Sent: Tuesday, February 21, 2023 11:48 AM
>=20
> +
> +void vfio_device_unblock_group(struct vfio_device *device)
> +{
> +	struct vfio_group *group =3D device->group;
> +
> +	mutex_lock(&group->group_lock);
> +	group->cdev_device_open_cnt--;
> +	mutex_unlock(&group->group_lock);
> +}
> +

Add a WARN_ON(group->cdev_device_open_cnt) in vfio_group_release().

with that:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
