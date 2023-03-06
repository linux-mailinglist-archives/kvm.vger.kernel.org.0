Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1806AB818
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 09:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjCFIQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 03:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCFIQw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 03:16:52 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CDD12591;
        Mon,  6 Mar 2023 00:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678090611; x=1709626611;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AX3Uu0nMW1+PvrUAIIl3WRfElpOz1m92Rj3fUYlDfww=;
  b=JahpuGL2IlB8+JkEpoy3MQmjQiFARUrlc8JU+EB8AUZommzcIjoM6VLC
   CYR89tK0AqYvBWNmuWiAj80whW0+hMljYRNesdMoUdgp6Ostutn+jVtcC
   xcLZMnASkaUfKKQ95vObrCihmib0Xzi14kLEgMaaki2CMgSE9XFwML/YF
   7tuXqy+YgJ2Vu68QoYJBFataL+sZPmmQ2uMTPTthCZIu6ITgqkkBjB9ZM
   RwuC8RofKyUj7BFls29/HSGCHsSWrKB2HsWaQjye4bON4cBAlEHXqxho/
   +1Yat1cUum47G3ZqjPDtO/LBDJQ8XHh4ruEi9H7TlF+B4Dj09qEyB4B7h
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="319323514"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="319323514"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 00:16:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="786118429"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="786118429"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 06 Mar 2023 00:16:50 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 00:16:50 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 00:16:50 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 00:16:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b1UmXKO1ivcN+U6r/RSZFBka5DtUBzAxHT3uRL1VZ998Zy9bpedTSYjXkZri/1YPuzADcA56VO56TbIGA2/cDUiMMylX/Urn/EQHm2t3efjRclzhqxq1T0xMMzrvBLgcTNujNdF6iggVhtblknT+DMbeglnyDs9lp7HaveGOLOdfXKYIrUEZEejQ5v+XemQPJNxnonpWQmc5SP0p2xHeoSwGsFN5GUL+o9sgzqpyJ27eZm7WRA2cb4dP4oKMt2aCIQ3E+b/sv2whxcfq33iGuoMlyH6E5d1wYEPiXNrS2BagKpYQuHFTY/i4lAo3oE6HGp0G/CPYrEB/tncDPDXmfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AX3Uu0nMW1+PvrUAIIl3WRfElpOz1m92Rj3fUYlDfww=;
 b=hpkTYWPYC5XBUjeN6dguRJG6+nxjmYP7Sak55gpK5JfL2bpTR1B5kJL9dhNaV0NUQUO8quMa3bK82k9eXVs6Unt/HRKuz9rz/2Aj198NKQudblc4bPTTPR6HGodXjfD3SuKJQpUySPi81Pjs6chAWrjeQ7T7swM3MUHb/oqX13oqKPW8Unfk5WW7282eqr8QU1MtAPmSVwalDJk3Kx4WMsT8WlLXH5J5Z515u2DPi8mM+E5B6NBgdqJjCbbPtPFbAafR1DszODYzKQZTjB8bRs4jdoa5R5YkoNkte+Jer4yyfGAQQETZK6WeN+Rk0V8O1TyK8LbxNestEeavXB2/Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7872.namprd11.prod.outlook.com (2603:10b6:208:3fe::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 08:16:48 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 08:16:48 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: RE: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZSpxNc+z5kvMhjUKJQeU3VasOx67nBTMAgAA+rbCAAC27AIAAHWOAgAECO4CAALuIAIADATSAgAEjvQA=
Date:   Mon, 6 Mar 2023 08:16:48 +0000
Message-ID: <BN9PR11MB52768A29E00D8FDCB9E6B4EB8CB69@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
        <20230227111135.61728-10-yi.l.liu@intel.com>
        <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZACX+Np/IY7ygqL5@nvidia.com>
        <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
 <DS0PR11MB7529BE88460582BD599DC1F7C3B19@DS0PR11MB7529.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB7529BE88460582BD599DC1F7C3B19@DS0PR11MB7529.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7872:EE_
x-ms-office365-filtering-correlation-id: adbf613a-1d4e-45da-cf89-08db1e1b21ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VGW1sN6LQ1DZoqBacNkCBxoaKlMOk3kkxpcAGrG6n+fmU4yfnEGUA0o6IxsGhFQ123DvBR8sNLSxGK7uuzj7qTfKGBZBLCZ9h8UlZMTKg6YNDj1mNODjR4/eaNmpPlmFfHfx3TFS/se/OvG1zZGXiuA7C3WGZqQ7ad20UFFtd6K291iaRdUiBW74FVcuUHpJBA9D0WeitkCFX6LC202WK9KLAdDnCu8hBbDs/ZjO83gznLQBKiBYvlFHcfdSZDY8n0Ww3ufr7zOnNtd5flg3eZyZzBGDmX4T26W3ieXKp5sQ5r7uMNP6+i+oJMO5hxsFqATefE4fOoUftVt4tqidQfg4JyrNwusQ8Zq8hirzaGysfcZl5na18AotHBUP0XHVayuuBBqzqRN8y/ux+fbAoelSRruqO3orL672cv4Y0IPzPaTZyKkwdOmkyRq5/0QoH/acvwjTAzwFAs6MK7RJlfgPx6kvUEqowo5tQtw7GhDiYCjg0/jylbf7XBRLTyzsr39HwxD1DUwmRNfRL5XNpE5zeeUms6RbZAoTc4E7Bc5cbkWqJtk6UvOyOSoSnTxxYfmFeb4E5aKCYFE4CxaTYJf6bMeCxzeEuS6Y0131wGnqCw/D4qy94E8WHssP1xbijhANsGalBTNTDvIq93C+5NwiGBpHI2WRiI/lCGGyqOaXsIm/NxgC+SJiSRlWxYIUyxf1eupn8zqWx/Dj3nv3Pg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(396003)(39860400002)(366004)(136003)(451199018)(110136005)(54906003)(316002)(55016003)(33656002)(86362001)(64756008)(9686003)(186003)(82960400001)(2906002)(76116006)(5660300002)(8936002)(66556008)(66476007)(66946007)(4326008)(8676002)(41300700001)(478600001)(6506007)(26005)(66446008)(7416002)(71200400001)(7696005)(122000001)(52536014)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVlKcVlYUm5jS2g0MHJKY0pqeldxdEFlZVNsbncvSy9BdUFRNFpxYlgwdVN4?=
 =?utf-8?B?WU9zcm9vMkpRbWx1SVdTNDdOZU02b0M2R3QyTDBQZ0pycVNwa2NRYW5uYTRR?=
 =?utf-8?B?RVlFOEhoR2VPclJOakpQSWJ3Vm9DK1hzTURvNU9PS3pNeW5YY243ajkrRU0r?=
 =?utf-8?B?ajRsNm42MHE4Vzc1c1VHVlFzN1htWDFFSDBxV2g0SXN0aXptVWRlVGI5Zjlj?=
 =?utf-8?B?c0czaC9JYWJJUFlwbXg5QmdtaGdBZ0lBRFNFZkE1OWR4SHVXTWFsOTB2LzBh?=
 =?utf-8?B?elQ4MHRQeDVQU2l0eXJ4U2drVjhOVTJBa3lEcWhab2RKekZ6S0Y5RU56RFVo?=
 =?utf-8?B?SHVWNjQ5WitJZkVHSnJ5THBCK0ZPNzArVFZhK2VRMytnNEk0eVZNRkh2T2NU?=
 =?utf-8?B?bGp3UHJVSDZTY1krcHVyVXFuOVpkaEpPOE1EVFRJc3BUS1pwZVpmaG1NTzlp?=
 =?utf-8?B?dm15Z3RySmsySXJjSnFTNmxjamZ4NnlBVEtvcUxscGRxWVNoWGd1NWc0cXow?=
 =?utf-8?B?MFUwRkZSZ1hHSGVHYWcweWd4UmtHM0tKQ1VyZitGanpRMEpwb3ZNNjJjdDN3?=
 =?utf-8?B?NGFLYnEwV29BM25aaVNrZ0Z6T3JkYjNHbnZ3ME96cFBETC9RSDlhWVZFMGlK?=
 =?utf-8?B?V2RPbjcrWTNoeXVmVE9nOGRMRFVOeUVtSHdCWU1Gcml0TUhZUkY1K1BsbTYz?=
 =?utf-8?B?MDZ6WnVYOTR2UnlYSnhtbmVKT1pWanpldlVCVmp4QnprZEFtSHVRNmJGL2dD?=
 =?utf-8?B?Lyt6dTZTcFZLN0NnWVBnVUU2Tm5MaU9FcW9uMUw4TndJbmEwNTdZWlZ2cjJl?=
 =?utf-8?B?cEk4UmZON20zb0ZsaFVKZThqVmZOK05CSWZFbmJwY1FoYkJDa0Y3ZitTL3Rx?=
 =?utf-8?B?VmRxdVN1YUwwRWFXdU5hY0Q1SGhnUW1yeXVIU0l6SU56WEZLRUJVREVrSUY1?=
 =?utf-8?B?SUxUY0ppYlEvYjVha0tjOTR6Um02UXY1b3B6cFZ5eWRBVHFRck4wZDdzNm5S?=
 =?utf-8?B?dVluWmVtMzd4SG90aHFLdkliNEFXb25qYVJDZUpBRUZGcDFoQzdZRFU5ZG9m?=
 =?utf-8?B?Ykx1V0lkK3lvUDZDd2RQSlpDR3RsZXFObzNTTVRDOWc0ZC9zaHBjQmF4SzJV?=
 =?utf-8?B?bW9RY00yb0RVUzJDaWp5Qzg5dkJjVmZMUEZ5R25Cd1JRR0VFTE1TVXJuQ0Jm?=
 =?utf-8?B?TUpQb1hMNXBnUVZybkVMTDR4SlhrdEQvdmRHS1E2REZ0UkpzN0lIamFPM3Nm?=
 =?utf-8?B?SElTQ0NoWkV6M0J1U01vYkl1WTQ1dFIvcXc2dlFsOTZTcVUzMDAzZ1lCaXNT?=
 =?utf-8?B?c3lVUElsNElqdFNHTWdhSW9CUm9yR3k2dFlCV2xTc3RoZE84bEIrbHZOUm9O?=
 =?utf-8?B?VS9EZ1h3cG5rdFI1SGJQKy9FVzZpQ0FYNyt4bGhpcFBhZVBNeFlKNVZkK2VW?=
 =?utf-8?B?WEhPNEpUc0w4cmwxd1JiTTUzKys3dFM1c2tEQ0hyVzBldW41c1p2R1RQVlVj?=
 =?utf-8?B?cm40dzlBZThicWhDQjBZMWlnZVYzYkNRc2JUSTREcFQ3UFFybmFMUWxxRzg5?=
 =?utf-8?B?bzN5aUErcDJGTjl4SWJjUFFaZ1oxQXM0cFNyd0FwOHJjYWF1YkhxUG53TFVo?=
 =?utf-8?B?V1lVRnlrbFNFUHdYd2pRSnNyRm9mZ3BzdHpyaXFIbzBxTlZZTzZOdDZsakpQ?=
 =?utf-8?B?VHNqM1ovNjBoZkoxYjBMNGZrVTg3ZXI4dmJ4VGt1Z1IwVndFWHdUeGJvNWxL?=
 =?utf-8?B?cWJvNHU0bE1NeTAxS1B6QXNNRFIwbWJUcTBpWVV6ZzNYdnl1ZjB5SURNZ0hr?=
 =?utf-8?B?RjJnaEIyNVQvbXZyZGh1a3RLSm1JUWl1MG4wN1FiYXdjeVgvYnBJbmF1OVE3?=
 =?utf-8?B?QkZ6eEVCMG1hMEZ0Y0RKUVh2czEvcEZ1Z3RNMldaYkZvVmRHWG1GS3l5WlBP?=
 =?utf-8?B?RE9zRzU5c05OVHdZZkVDVWZwdkZ6Qk5mVmdTek5pbEpLNHh5am5OMVN6VEYx?=
 =?utf-8?B?d3NuR0Q0RkIzaFhEeGpDY05iOE9OaDVLSlA4ay9EWkhzaTg1QWNycHdMYVp5?=
 =?utf-8?B?dXZHbTZ4L1AxazNURVFYTkwxSUQzait1cXJHVUxYa3hxTit1NHRvcC9jZ09w?=
 =?utf-8?Q?BSMTa/yQ1CIZLmTGgE7oAV7Df?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adbf613a-1d4e-45da-cf89-08db1e1b21ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2023 08:16:48.0355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xyxt+hbxcWUlWJm9h6UBs9FNbX4NAetVgH4Q7Ec2+H1sDf3hI8+x+AMvCfx1Z140LaPW3X3LXJRtNP6TMf02Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7872
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBMaXUsIFlpIEwgPHlpLmwubGl1QGludGVsLmNvbT4NCj4gU2VudDogU3VuZGF5LCBN
YXJjaCA1LCAyMDIzIDEwOjQ5IFBNDQo+IA0KPiA+IEZyb206IEFsZXggV2lsbGlhbXNvbiA8YWxl
eC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+ID4gU2VudDogU2F0dXJkYXksIE1hcmNoIDQsIDIw
MjMgMTI6NTYgQU0NCj4gPg0KPiA+IE9uIEZyaSwgMyBNYXIgMjAyMyAwNjozNjozNSArMDAwMA0K
PiA+ICJUaWFuLCBLZXZpbiIgPGtldmluLnRpYW5AaW50ZWwuY29tPiB3cm90ZToNCj4gPg0KPiA+
ID4gdXNlIG9mIG5vaW9tbXUgc2hvdWxkIGJlIGRpc2NvdXJhZ2VkLg0KPiA+ID4NCj4gPiA+IGlm
IG9ubHkga25vd24gbm9pb21tdSB1c2VyIGRvZXNuJ3QgdXNlIGl0IHRoZW4gaGF2aW5nIGNlcnRh
aW4NCj4gPiA+IG5ldyByZXN0cmljdGlvbiBmb3Igbm9pb21tdSBpbiB0aGUgaG90IHJlc2V0IHBh
dGggbWlnaHQgYmUgYW4NCj4gPiA+IGFjY2VwdGFibGUgdHJhZGVvZmYuDQo+ID4gPg0KPiA+ID4g
YnV0IGFnYWluIG5lZWRzIEFsZXgncyBpbnB1dCBhcyBoZSBrbm93cyBhbGwgdGhlIGhpc3Rvcnkg
YWJvdXQNCj4gPiA+IG5vaW9tbXUuIPCfmIoNCj4gPg0KPiA+IE5vLUlPTU1VIG1vZGUgd2FzIG1l
YW50IHRvIGJlIGEgbWluaW1hbGx5IGludmFzaXZlIGNvZGUgY2hhbmdlIHRvDQo+ID4gcmUtdXNl
IHRoZSB2ZmlvIGRldmljZSBpbnRlcmZhY2UsIG9yIGFsdGVybmF0aXZlbHkgYXZvaWQgZXh0ZW5k
aW5nDQo+ID4gdWlvLXBjaS1nZW5lcmljIHRvIHN1cHBvcnQgTVNJL1gsIHdpdGggYmV0dGVyIGxv
Z2dpbmcvdGFpbnRpbmcgdG8ga25vdw0KPiA+IHdoZW4gdXNlcnNwYWNlIGlzIGRyaXZpbmcgZGV2
aWNlcyB3aXRob3V0IElPTU1VIHByb3RlY3Rpb24sIGFuZCBhcyBhDQo+ID4gbWVhbnMgdG8gcHJv
bW90ZSBhIHRyYW5zaXRpb24gdG8gc3RhbmRhcmQgc3VwcG9ydCBvZiB2ZmlvLiAgQUZBSUssDQo+
ID4gdGhlcmUgYXJlIHN0aWxsIGVudmlyb25tZW50cyB3aXRob3V0IHYvSU9NTVUgdGhhdCBtYWtl
IHVzZSBvZiBuby1pb21tdQ0KPiA+IG1vZGUuICBUaGFua3MsDQo+IA0KPiBUaGlzIG1ha2VzIEph
c29uJ3MgcmVtYXJrIChub2lvbW11IHNob3VsZCBub3QgdXNlIGlvbW11ZmQgYXQgYWxsKSBtdWNo
DQo+IG1vcmUgcmVhc29uYWJsZS4gSWYgdGhlcmUgaXMgbm8gdi9JT01NVSwgdGhlbiBubyBpb21t
dWZkIGF0IGFsbC4NCg0KeWVhaCwgdmlvbW11IGlzIGEgZ29vZCBwb2ludC4NCg0KPiANCj4gSWYg
bm8gaW9tbXVmZCBpcyB1c2VkIGluIHRoZSBuby1pb21tdSBtb2RlLCB0aGlzIGFwcHJvYWNoIGNh
bm5vdA0KPiB0ZWxsIHR3byBhcHBsaWNhdGlvbnMgdGhhdCBhcmUgb3BlcmF0aW5nIGluIG5vLWlv
bW11IG1vZGUuIElmIHdlIGFsbG93DQo+IHJlc2V0LCBpdCBtYXkgbWFrZSBuby1pb21tdSBtb2Rl
IG1vcmUgd2Vhay4gU28gcGVyaGFwcyB3ZSBuZWVkDQo+IHRvIGhhdmUgYW5vdGhlciBhcHByb2Fj
aCBmb3IgdGhpcyBvd25lcnNoaXAgY2hlY2suDQo+IA0KPiBIb3cgYWJvdXQgZmFsbGluZyBiYWNr
IHRvIHByaW9yIHNvbHV0aW9uLiBBbGxvdyB1c2Vyc3BhY2UgdG8gcGFzcyBhIHNldA0KPiBvZiBk
ZXZpY2UgZmQsIGFuZCB0aGUga2VybmVsIGp1c3QgY2hlY2tzIHRoZSBvcGVuZWQgZGV2aWNlcyBp
biB0aGUgZGV2X3NldCwNCj4gYWxsIHRoZSBvcGVuZWQgZGV2aWNlcyBzaG91bGQgYmUgaW5jbHVk
ZWQgaW4gdGhlIGRldmljZSBmZCBzZXQuIElmIG5vdCBhbGwNCj4gb2YgdGhlbSBhcmUgaW5jbHVk
ZWQsIGZhaWwgaXQuDQo+IA0KDQpsb29rcyB0aGlzIGlzIGEgY2xlYW5lciBhcHByb2FjaC4NCg0K
aWYgYSBkZXZpY2UgaXMgbm90IG9wZW5lZCB3ZSBrbm93IGl0J3Mgc2FmZSB0byByZXNldC4NCg0K
SWYgYSBkZXZpY2UgaXMgb3BlbmVkIHRoZW4gaXQgbXVzdCBiZSBvcGVuZWQgYnkgdGhlIGNhbGxp
bmcgcHJvY2VzcyB0byBiZQ0KcmVzZXQuDQoNCmZyb20gdGhpcyBhbmdsZSB3ZSBkb24ndCBuZWVk
IHRvIGJvdGhlciB3aXRoIG5vaW9tbXUgdnMuIGlvbW11ZmQNCndoZW4gaW9tbXVmZCBpcyBub3Qg
YWx3YXlzIGF2YWlsYWJsZS4NCg==
