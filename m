Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0907AA63E
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 02:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjIVA5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 20:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjIVA5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 20:57:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5F1F5;
        Thu, 21 Sep 2023 17:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695344230; x=1726880230;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mUeAzKPI5Af8FxRm6nmT4jIhjplR+wza6atOcVL3I/c=;
  b=HIDpAjNotBUvUwIuz+hMtMeP0YXN/sCLlN1qPwyQgS1/WAiNgrda0mGq
   Sri18ZEUw17sphXL7J4uGq/SEZCEHjIO/SOaNhlseDXHkqVs1g2tYMSQ+
   LuGNA3LLXr0yqi1LtevT1nI3Ux4/M5W+BSFlWYcKV3Kn4h1k3Hm9Yl/Vx
   ZIndeTrZUOxkMdwZvpcN54SpUbywyxdn2PEn2mGiRjj88TOCWBeBMIf8y
   9QtP8xC887u4oQgqhmnrRKePkKzvTvJb05dTHgGLqCjPP0UZ5PexBluns
   1S/5DGkl9Ouu7nLilS3/MZAx/+vNSLXENJwNnh2L35OXuzukgHk2s0qVm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="467007474"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="467007474"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 17:23:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="750624774"
X-IronPort-AV: E=Sophos;i="6.03,166,1694761200"; 
   d="scan'208";a="750624774"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Sep 2023 17:23:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 21 Sep 2023 17:23:49 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 21 Sep 2023 17:23:49 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 21 Sep 2023 17:23:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ko+gGCSiFHnkYgbuzLeq/0vy85Tlg/LDi3OFR4G+opNk+9UtHPTFgGvMoBMvdkcLRnI9TXWeeQkENzUNVYnAB9Vv7a+ZNp7v8ZEN5wwHDZOJAULvuFR8h+XmSQqb5BOkHtEnot9OdtpvLIyG7lNSznXwN4oa+cu14p58yNzULmQ4VYaUNyGpz+2X49RyM/AeqslhbBzo2SjBREYhYZFGOZGwdvhuctljjRFcr25sHtge8Ohxcrhn+dv1p3KLKySf3bYyFN4HxO9GAMOOBLsw+TxoqPtctN0U5ChtKqFoWh0EJxbDLihqcQqkTN/2SJTLoF5CY3N2NuNX01bOi+xPfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alKKaia/g7BvdDc1kHcS8ZIafl1z4EDrxRZnShUM+OY=;
 b=HbMU2vSrXdppTttYoWPl4xgBJZT3cTq1dvw6MBArIARyGA/71b6vIKmveN2Zbl+8mbU9C0Z+czBK9ORzGjgWp6IIT5oBgDY93v5BTUF4mN597o137M15vHvtJ/gYmnUPBlnNsanOOHF01MqtHH2WMVFmZbOxEe+POI71KcxX4gI6E0f8UNPeaCaCbJyluJQcul03klW8j9g4T1oUrVvsCN2aW1a+Z29sEEalrjJyIzxj5uUUS7LYWs6kr6ta4gdoNSoL5nkgZevJjFfsudhTTn6D48mCCrhu1ti8Pcifqu1jY2R4dCiDgZFb0bZmH/eW/9b4yUTKSg2C6kbMOQKcTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB5923.namprd11.prod.outlook.com (2603:10b6:806:23a::17)
 by SJ0PR11MB6575.namprd11.prod.outlook.com (2603:10b6:a03:477::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.26; Fri, 22 Sep
 2023 00:23:42 +0000
Received: from SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::a9c7:a04e:633d:cfad]) by SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::a9c7:a04e:633d:cfad%2]) with mapi id 15.20.6792.024; Fri, 22 Sep 2023
 00:23:41 +0000
From:   "Chen, Jason CJ" <jason.cj.chen@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [ANNOUNCE] PUCK Agenda - 2023.09.20 - No Topic (Office Hours)
Thread-Topic: [ANNOUNCE] PUCK Agenda - 2023.09.20 - No Topic (Office Hours)
Thread-Index: AQHZ61Q3W8C4TbDbjku4TL8lLfXt9LAjMW6wgAB8aYCAAVPZgIAA7UAAgAAPnQA=
Date:   Fri, 22 Sep 2023 00:23:41 +0000
Message-ID: <SA1PR11MB5923020DA713458F360305DCBFFFA@SA1PR11MB5923.namprd11.prod.outlook.com>
References: <20230919234951.3163581-1-seanjc@google.com>
 <SA1PR11MB5923CE0CA793FF8B63DFDAEBBFF9A@SA1PR11MB5923.namprd11.prod.outlook.com>
 <ZQrsdOTPtSEhXpFT@google.com> <ZQwJtbXrXH/wPxpd@jiechen-ubuntu-dev>
 <ZQzQum0Ulz+b19iu@google.com>
In-Reply-To: <ZQzQum0Ulz+b19iu@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB5923:EE_|SJ0PR11MB6575:EE_
x-ms-office365-filtering-correlation-id: 1f7ff7a8-f15a-4bc4-31b2-08dbbb022cb1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GqJeTaKBB64td+4ZwAYenxVMDz1s8CP6JACs/xHq3kqCZ7lGWJMrLasttrlY1IB6frCIvkIS8WxYUiUYKqHRJc81rFkxFUl9hub2EKAWeaGSm64nrgo2BU3YUfIlq7Mcvl83AFs2RqGvSUooQ3GjPREy1QulgQbUcdAPbneS3ZLMPXEjwJDqEhfhmmcEN5sCEtrSYSJD73hop1sFDDiXmNk9vceDYDtH4H9dHuZDewG+uMOPFtZM3zYSHq5cf8shkE3DlGdXvEbD+EXdHwOOAsnDf5JGtanrxBwdu3/GvhX9MDARgEn4JiHA3KDiEVpyMvnbCQ2Oov3MBMnJdV3S8ZFsN27KQcgnj0USI3dtqzrVYdUxbpJn8iZn7pw5UZtHj1lMmjrATxvwLOaDrhE9SG8lNoIy0PUJC0MUXlHJIhecaPr0BkQcO4fMLWKUpFIir5pCW00DNIUuzvvYpPFVTut6BiwqkWeUF+scshWjnr49rGVUaoWqPewicHJnC01C7rcrUetK/DiCaHC/pcN0Tx276Tf+SfTbd1WgesyCBlQgHp/Y/ngnpkJnmG2h/Xne8JCSf5lMTfD0yP6izn6WalTTWyRV3xmn9NFPibzfzwp5lShdY9uicbLfOnGKPcTX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5923.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199024)(186009)(1800799009)(478600001)(83380400001)(6506007)(53546011)(7696005)(64756008)(52536014)(9686003)(2906002)(41300700001)(6916009)(54906003)(76116006)(66476007)(66446008)(66556008)(66946007)(71200400001)(316002)(26005)(55016003)(8936002)(82960400001)(38100700002)(86362001)(38070700005)(122000001)(4326008)(33656002)(8676002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?82OtxitCZr+NrvXOxdgBCttUNGtHm9y0UNxBK4IQuOs3R0vSG56tryI6E+8V?=
 =?us-ascii?Q?lcFyA1/DE5kLC2gNPhgA8/ol700HfXNZ6RgBbyVHFLZA9eY/i+ZWVS6AcXWY?=
 =?us-ascii?Q?fVD6o8B/4YPXnN69jzYdjWa559zYg23A/hKPbVdcv59GpQcGkufPK00xfsaH?=
 =?us-ascii?Q?WEYjVohaqZXWScNuTvHPhrndiQdHb5QFDPY790pH8kKIVeHBw6gCwhyIsCzU?=
 =?us-ascii?Q?FqQfwj1U73Q/HO8yP8FMkxyjZxey8LFNleXykTsWpIhGrz5/vbOg3n/sg5tH?=
 =?us-ascii?Q?lml81BuSR7emFNQHzDyZ2nSXxtBd8Jr/clHkkawXBPHEJ9tgAw52vfBhUF4B?=
 =?us-ascii?Q?uAXrg5UBjO1Q/T4/DL3yXhrDGLY0oY/zgLmGCLww/K/051E7Jpe87kUIlQap?=
 =?us-ascii?Q?WnirWjrXE7s3mgIpxhgq655oZcDN2heTcIYjse7L1nwKkghQMFSZ9WdCUI4n?=
 =?us-ascii?Q?sj+YKBLANw8iIGs83ghaPFOR8B1mZPE/uBCr1LHZZUkg0p3ATkGOqM5diZYM?=
 =?us-ascii?Q?qJ8gB2dU+k4e5u/uqafBNsKw6TnQwplyDn2eeLUn+d+CneQl90ivzEzSMFj5?=
 =?us-ascii?Q?qQhX+zZxCZThbk4vM7G8jzeNKiOH4oJH0anHx8zqhO+PFMEh9hZ6TvZN3Y6d?=
 =?us-ascii?Q?xRHG8qFGPtBcLeNj4CYcaGFPF0qlOvuYf/7047aO+SNWIZX0VnUa6JwxeGQA?=
 =?us-ascii?Q?dvvohnXsao5usCo65ax54h5qx1FnVdw0gwMcCrAMQ/uO+jHN42cwzT9DGl9S?=
 =?us-ascii?Q?farCVTq+cxRLW6wdqkvslbfa0LTtUUNFFkDrDXTl3r/76SNGtDoEO2PSpZNu?=
 =?us-ascii?Q?aCX5P6cV0tKrVYoeI/Vx6quLScakV3Y69H/jOQ3aADTohcHfCrkTpWjV54lS?=
 =?us-ascii?Q?fjVTwtVI/SfgUbbI03WdFEFwmTtD9MTVjW5nww9V1f3pHOmtvug5bv5W3zeA?=
 =?us-ascii?Q?wujS65nOtBPChU6vqsrPsVVNr2/hwrk7bK8q8YVI2P1WSLH77T9mx7xfTgbJ?=
 =?us-ascii?Q?CEeSqErQRYGngEqP2rb3QnbMpDPttjGDQhKfeGw5EdxzZTdxl80pdzVTGifr?=
 =?us-ascii?Q?FhXxjv4Abq/7Gqi5nmKo7I80cC6ydHhVaW2EFfXpz0PJf6cInbmZfXMXQyzd?=
 =?us-ascii?Q?+giSoy/qbJjRg1LpyWENddnk0UoF+4N2wYwr5iKd8FWs/OtYLzSnwrY45JQp?=
 =?us-ascii?Q?yeUUiTzsAus5vUIdiHBmwZCUdm4ctZviiMY9lvli5Mw91HouFIWUmCS/lUJ0?=
 =?us-ascii?Q?Pxc1G9ZLqwhk7QGa/TnSqpSm/o/h7u3vV0QkFovYbb7gzOqa0kOKUmhx6xZ7?=
 =?us-ascii?Q?CnU2D/FXi8WyValCQqjyMXKNHMONaFHsDdL4SHz/BHIyY8ODkCn3DRvPyMXq?=
 =?us-ascii?Q?6Zo6fNyYyr6950szo8mrsmn2lrT0qJpW8ihEqxu4zrcWFFvPlTd3xh5pbxaJ?=
 =?us-ascii?Q?LPb/a6KlAaxNPxcKvNDDhIYtq+wRXg5e+5PZkzMeGHGpU41SHyaEvHzfjWaA?=
 =?us-ascii?Q?Q0mZsh9zNBIR+5LYszOdD2S2EVpxm6QcOHAymIvMM+2nhCrFXke3p+Lglc50?=
 =?us-ascii?Q?Xf45MXZawi32X6JjFw3zoS/Dqs5aODa9+++7pyQl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5923.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f7ff7a8-f15a-4bc4-31b2-08dbbb022cb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2023 00:23:41.6871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YpIEUkAxxbdJm/GaejHUf47vnBwNEy+ZcI20HES+lG3yqgQ3Q++jtOobujCk7yk7kVecXU5RWcE8Ha+xnOf5nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6575
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Friday, September 22, 2023 7:25 AM
> To: Chen, Jason CJ <jason.cj.chen@intel.com>
> Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [ANNOUNCE] PUCK Agenda - 2023.09.20 - No Topic (Office Hours=
)
>=20
> On Thu, Sep 21, 2023, Jason Chen CJ wrote:
> > On Wed, Sep 20, 2023 at 12:59:11PM +0000, Sean Christopherson wrote:
> > > On Wed, Sep 20, 2023, Chen, Jason CJ wrote:
> > > > Hi, Sean,
> > > >
> > > > Do you think we can have a quick sync about the re-assess for pKVM =
on
> x86?
> > >
> > > Yes, any topic is fair game.
> >
> > thanks, Sean! Then if possible, could we do the quick sync next week?
>=20
> No, as called out in the agenda I am unavailable/OOO the next three weeks=
.
>=20
> My apologies for being unresponsive to your pings, I am bogged down with
> non-upstream stuff at the moment.  It will likely be several weeks before=
 I can
> take an in-depth look, as I need to get going on a few things for v6.7 (v=
PMU
> fixes in particular).

Got it, Sean, then let's wait for several weeks to discuss next.

Thanks!
