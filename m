Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687546BDE11
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 02:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCQBRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 21:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCQBRq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 21:17:46 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6477D664E5;
        Thu, 16 Mar 2023 18:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679015865; x=1710551865;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IcxYoKsxjCERtr2pNd5xqsT4pnOIicJnSUsKnrcRgYA=;
  b=BzWs7qWwfk0UHnZ6dr3CTv/aHWjA7jMQ2GBrDEPsl6c6M4HnMNSFw+6u
   Kw1wfQKwiJ5hxBBUbTWet6+pAFVYg+cuTXDte6dOuLXoy7a3AaBwpwebO
   OJnrBBrnEa/lbnVoVRzaWh1sETEKyhPF1jf/7dEEwe99L21EoeP61xmpr
   0mlBTTD2E3M+AGeqO+btYTF1cs3uCVVE4vkwB/geWR31dXZXU8Vp1ikie
   ZIjrmPDojOjQ7FLUQTEXYSH8LvbeysucK5lxaWbLlNP4ECaySiXy2LQJ2
   vBMXx2aHbTcS3hDSSYtf34dhCMo/18OQLQUeV7U08kHxlt/qjcTILhhW+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="335642401"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="335642401"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 18:17:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="744375627"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="744375627"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 16 Mar 2023 18:17:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 18:17:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 18:17:42 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 18:17:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1e7Ll+xM4p1/QJ74vdUmVZPFnY/kHeiudkGLm6YOhY5BsLM00b0sCoO9c6felP3iRQFTY9HALT0ug/b6D+Qr34/J0skY03jjfIFzr3AXCXcFAerQWtcGIm7gGPCCLbYhLrx5KqD+e3HRFWjFu22x6BlplBs+1qIkHR5jHgXYMHgP+LMYbNpOTOi7Y6Ke8ZK3DyoX80pkC60glKMTo1FFV4Uncl2YWlR44HIAdXcDpqx3+wQy5elCPD48hcYYgV4OuppVvRGW2/QaPAjSphFzz3BwS6cpku5fZ/p5/mXiaC4CeWGQIVTYeO36sGjzfTHX9IlNtjiDgaqPcXenrwzfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IcxYoKsxjCERtr2pNd5xqsT4pnOIicJnSUsKnrcRgYA=;
 b=cqYk0OMDAPlEtmBiYWL/ueHZPBwob8u1YgaA8ZKO8uwfSBmr2qa/E+TH+z2UF3dw+wp9NNtOxq1ZPNkcBmO6mcaMGl2pCoOdn3cP3tAofeZTwSC/bsUgK2Crc5kPdu5Vc7eC1m9DOPwgsu4k5h7jJzsgFrNbGDIVaiyeTISn6hLL+kr7OSBtbIE5PsOUoFiJrvwJ41jI/we0PA/N+ylS8M/RPx7UaCcXMjTTzg4h9hAN48kWbpHIHXDqr4RnxNuXx6q6ZQPcen3/uTO7LxkoEwLpz3gN34lA76hLqhawMStG0uqVFSsFzlYVDZadMDi5c83qcKl6mNl0bwtPdN3ncg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5372.namprd11.prod.outlook.com (2603:10b6:408:105::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 01:17:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 01:17:41 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
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
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH 6/7] vfio: Accpet device file from vfio PCI hot reset path
Thread-Topic: [PATCH 6/7] vfio: Accpet device file from vfio PCI hot reset
 path
Thread-Index: AQHZWATIRc34FbOx5UqYJG5sVHfgfK7+LGtQ
Date:   Fri, 17 Mar 2023 01:17:40 +0000
Message-ID: <BN9PR11MB5276FFE8774357A05E41C37A8CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
 <20230316124156.12064-7-yi.l.liu@intel.com>
In-Reply-To: <20230316124156.12064-7-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5372:EE_
x-ms-office365-filtering-correlation-id: 166fd949-897c-4342-fc55-08db26856763
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U9SeXu/Xva+ARNeTb6aFmhj2uUTjRshgj/76dnmMLqxpeqWE64DwSjVyyKL0KlGGi3FL5+KwbHZxcRDZY+yzwOXBIpWegJFNt8hW1DUwg4KmuzHa2gcHorZdsgOkSNmAlOGhoCzNJA/54TIoC5+pQFBHLq3L499ZOx2gFeUsFQXgw75Q/iba+Jpbfq/f2/l4PJJkxXC3XKI1iSGTybk+/SIHZtOF7FVCx4t7bNcjcRRRq5nwSNV8+ybIDp1XM4pk1aQgexTOhbaoSf5WvXv0nl4CZASmAVu+hdMAbbX5vlL3vA0JbzhM97DvByuSV+0xAIAOPi+f959KoSePjNESstfCQ/WdR/CW+FUkjJNL0704SXTrgXqVtFQbvfin6wJYd8Zu2wreT9NztpfNqlGryjh9jhAkZ2+NQRdsHdQgHdTTB+4768pvuFyXG/42yTZcwq6fRnOwJjPlQdB3GGYNj+PuGatt6km0J3szougzRsAdC3GaU3MS2kfMS85Im7P+cZENTecUeAFeNzayJP/gUh/FB6NgqJAgJsY0JbhB6syUntCQOnE08wVbijoDbcLV1yAl4X0rLSErzDCOYCTVEozU5BPYMzs4JF7Mbjvq1pqQlQA1FTifdnHTikxQ5dB/AG+C1/dbtViPgYKaLzHtrCgPlhd8+0QQeNBIzgjCvCHDaNsLIqNdu2f3bvRr+y6KWEzBcHhiwwyUb0Ob9O4uNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199018)(8936002)(5660300002)(7416002)(41300700001)(4326008)(52536014)(55016003)(558084003)(33656002)(86362001)(38070700005)(38100700002)(122000001)(2906002)(82960400001)(478600001)(71200400001)(7696005)(186003)(26005)(6506007)(9686003)(66556008)(64756008)(66476007)(66446008)(110136005)(66946007)(76116006)(54906003)(8676002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3XvXCbUe1dh0Ik08aiNQQL+Wv52tuPg0nmBr2Bb6WLEApkM0yG8p8TInRUUB?=
 =?us-ascii?Q?lV5Guzm+aiHsVWI+kC2OQIMAiEn6QnvngKsRLuDnlg0xinEpst1i8ufyHVJ6?=
 =?us-ascii?Q?6Df8TzSYm8zUXoKzrcTwySyaQv3OYLexoLSAwOGuYgz6XY/NFh7xjgBGXNSY?=
 =?us-ascii?Q?iw63iZiipunFun/kHytM87pp7LcVeAP0Xc11m+qXIERrk6r5hTFm75CiSsXl?=
 =?us-ascii?Q?SMs9zakWu+9U6k84zA06UTWFcONpFHWrbJ3OgnAjY/+du1oaUAm9tNyycMNu?=
 =?us-ascii?Q?6Pkyn8UhKKRGZHgdeYwdIleOSpdp9pvbrCTSc2zm1X3ySq1GiysYbNNTq6yw?=
 =?us-ascii?Q?xtZM4KO4yEXts25aYyHuvkjUlIWjF8WRKDTLvS3GXcdX8J1nnPDmp/FfleA6?=
 =?us-ascii?Q?DXjXZEXJwHK1AnesWRHgizZAhpLBT7yCYW/MORhwpNWrnp6ywMNLkANEzHNx?=
 =?us-ascii?Q?0D5W3/83TPlBEDxZp280ljxqc0IPUQDbhi+DLe2KezTjnmoHVR+730vTdLTq?=
 =?us-ascii?Q?1ssByvPl5RdBgaKwQMIr1PaQ5izaelSVMwdccHrlH7SQF64jfxZaB16q/Ldo?=
 =?us-ascii?Q?PqackJt+ItQDQo1NFvat2KLf2rpfVpMST+tfJ9QtubihNIhnQNIpVB2KwBij?=
 =?us-ascii?Q?O1xvlRVQ/ydqxyFX4sezm2ma+uLaHf/CZgSGtbiyb5O041k1a1hsIu4S7bZK?=
 =?us-ascii?Q?b2WISTtUjIhtf/EcJY/svix6izmjCW65Aa4KPfSPnwjN7hTVIGxClLzilRVb?=
 =?us-ascii?Q?+F2zFFzA1pafKajxkoaBJ3recPxjncMo10slLhi/mpba/eGyKCilTSEFM7jg?=
 =?us-ascii?Q?mjJD16pQOCv83t1S+22aPwftbqfp0MYM40d+zymrhpZtpwSmXx4NY8o9Drmr?=
 =?us-ascii?Q?jmsgebmi05/OULaos3WMFBBWVAeAduaNZ2uaIJ1F+zX9PhPYSG1YK5goeHTB?=
 =?us-ascii?Q?OEQdjIKlSRtH4b2Phrpjdw0dRw726WJVr5cArCHpnNYisaZ+6pBP/NkJlhCX?=
 =?us-ascii?Q?APyXqRKtyvuBetSflUZlC1ih4zsUmm55ucHMnk4JxTUICqhtU1+Tb8Ko7QMP?=
 =?us-ascii?Q?4ubFiUqSQWS4LDzc2N0FlxuxNiuUb0IcNjUmlo2VJ515zfYXIXyLoTXDFJnH?=
 =?us-ascii?Q?W8jU3LieNyG+ng1laGAo3Hj9GSfG0e0VG90QtUf/UR76zgWiBDWAf0SPhsqT?=
 =?us-ascii?Q?gKOa0AJBuHu4c4nV/f8JoNpiYKHsZx83FjXSO3GjQ1JODeaesQwHGpcTGQ3C?=
 =?us-ascii?Q?YbyP2HOqCEWqoEBh+6wNTmlmRFRGK9yIHaIsyVRj1v95TCV4oYjQIppBK3v5?=
 =?us-ascii?Q?5wZ7p/5rcLhruipkzrlnpp5Sfr3HIrCx9V7azsWIYPwvS2EtKiYlaWjypQGQ?=
 =?us-ascii?Q?xnHzXIeW+hr8GXOnpAJBRCwBOKwgHjSHZ0gldip/IFKr3C8i5wVzUyVGYO5Z?=
 =?us-ascii?Q?+Wobz2exbDkrXSnxav3BbxQI2fF9BMvVIsE057Ta4xFI5hUxm2FpoDKFNey2?=
 =?us-ascii?Q?SniI2kOPsPSB4MeEr1c2It7MtwmYME6mFlfWKNAC3jKTneGUytanZO9w9Bbv?=
 =?us-ascii?Q?r4i3NMwVHOTVNpVs3smkTbcn4VnlyV+0S6D2I+iv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 166fd949-897c-4342-fc55-08db26856763
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 01:17:40.9544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KHmpHU+pYxWE5uQhSqHLwt1YfHlHIxU2zEupxqxYY8AdYT7mJxwTh6yz1xdOyCmMXOOnsKJ4zqOcZfJ6co0UXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5372
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, March 16, 2023 8:42 PM
>=20
> This extends both vfio_file_is_valid() and vfio_file_has_dev() to accept
> device file from the vfio PCI hot reset.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
