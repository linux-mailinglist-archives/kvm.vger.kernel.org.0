Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33086DAB65
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 12:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbjDGKTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 06:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233289AbjDGKTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 06:19:16 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05212B755;
        Fri,  7 Apr 2023 03:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680862741; x=1712398741;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e+rWqy7swA1ww4gE81d/j+NtUBM1DibIYvBjh1wCozc=;
  b=lCUy6Y+mLtF2dhBa2ppwh/BfIlI4KvQqpCJIQM74Cu81+11POEYAMABq
   V4pGPjZW1g0ryvZuEIE6RLfj+s+I8K2s6vbFgp8LI3ZVjlywP8ynydON8
   XbkHfBoyzk5UQbS6dHX9n1HzG0i3DxjKhVcl72jo5U7sbCX5cJ6npS1NB
   nabwvcG5cdCEjgFdl4i8leIiXbGJIaHtF3yj1m0FsWSSd/RFnj5mM3Y6m
   O1fAOnCSFkF95iCs3xLv4H5SN0wVOVYQaQxwqo7fwdEgqf7cH8R9EG+La
   NR0aiZCGOWZ1xYADmUjswonuLAw1IjqsDbaWTjUax2rQtVn0RgMzMTdMa
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="370798539"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="370798539"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 03:19:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="752001069"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="752001069"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 07 Apr 2023 03:18:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 03:18:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 03:18:59 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 03:18:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdnSU5yI9JjVlwdFbcNESU8+brgCeLS5ZXtD2bXZiM0Cr0XRDkC8mon33ASCxjpMd1qtQ4bpQ6eNT4trg5LyaJDvDrXR7RZCIlJCFjYJ8mUO/dRqWV3p6gQuFFgXwKw2WqoWMaFH5l0WKhWKJeUuNAvCOCUgpr7yW2MRy+Wop9ymyyX0LR3khUIPCncr8VYbdEXEoXxFkEf3JjApbJLrFINGoDFC69YPRVJVNR8e+PM+y8cgWKvVKLWEGIxPy2FhFRl5Mh1FP6n9Cd9WuCNT8tdVSMPA2iVhqN2ovYrO8TANvPUvdPq49vfBAuNx/hfQgQPq/nQo4HwcOfrqv8dE8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+rWqy7swA1ww4gE81d/j+NtUBM1DibIYvBjh1wCozc=;
 b=eZlpXmDqqtwQ4kg0nFbXs7/FPrZqMOpheBcwUHlDEm2z9i2Vf9lJV1pcnr7Qa1SKXyNF5K5T5dQtUQ4bjqMiae3CNwF75Z6DZ1NsFvxpisazBVgOKp87UwXQMYpM7fDX1RIJtoJJimyWPEYELKpO2eDYEn8DYQ597Kezug0qiXByG6oSiifvpH3/f34hT7LWYVo38zth1pBjiR5Os1XWF/Y89pCFXwaUvUlJjEY/fuAsPD81KGkxwFqYtNIvASVExh1CwPX7sDTSevts9C7QDib2LHN/U8Ph+gfjlNKG7BXzkmbcvZNtCAhSZkmDMo0C10dfFmIcYkqa6QeRocQVhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BN9PR11MB5323.namprd11.prod.outlook.com (2603:10b6:408:118::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Fri, 7 Apr
 2023 10:18:57 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ca24:b399:b445:a3de%5]) with mapi id 15.20.6254.035; Fri, 7 Apr 2023
 10:18:57 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: RE: [PATCH v9 10/25] vfio: Make vfio_device_open() single open for
 device cdev path
Thread-Topic: [PATCH v9 10/25] vfio: Make vfio_device_open() single open for
 device cdev path
Thread-Index: AQHZZK1D+eJ9QkqYa02I3/dIBx/pMq8for+AgAAGITA=
Date:   Fri, 7 Apr 2023 10:18:56 +0000
Message-ID: <DS0PR11MB752930F01679A834463038DDC3969@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
 <20230401151833.124749-11-yi.l.liu@intel.com>
 <05d59a7e-fa75-a93e-95a5-a376c00721d5@redhat.com>
In-Reply-To: <05d59a7e-fa75-a93e-95a5-a376c00721d5@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BN9PR11MB5323:EE_
x-ms-office365-filtering-correlation-id: d296ea27-3a30-4342-e02f-08db37517f49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hzWAxeAzUjJETA3PKapFbYSR95l+dlSuil2s3h3At5ET070nTjpujpQVFs4l8OHvaHwNRtXbyXyBbJIkQHO3FxHEi6v5ytwJjOLYCJf+0eG6riYjVhXF13m3USqhAj8kWjQhvoMG1hwQjLyqkay2M+6fLchtD/IxFOPvizlqH0sd3Hjg4beI0qFotoX6EqdcrGVOuKE0jieNPZ0VFuxnhyU4E07bAN//IlLeN27zjbxcARQuBeZL66hFkgRYm6rGr2aQWL9U29xzAfYvNbwp1m7wrm5+55scIcW0XOuDW0RNNW0Uciz8Pi/RRLovCginKWldssHAInzrD1IRwIz2NavWPLjV76LRn7EsrxDLRbqmyZ00JrcBioTnu1AzgTs/T+Ly7yI9h4aB06uZj87OcvmEqKVP7jV3EAOhxbRwvjdZgncnvByxrItniIMuBZ4XjEk1vZuqpNwD9h0rd/hgv/VeXRmnKCKlUolP1LmqFVopKdHe+gXDQP//+JQMOQZ0utCQ+xHePKXdNt9z2NjVspVB3juoqa2wqDb3wzyZ3FhaGM0lmVpZbidbiyP7O96pC71I5+ldyRGmVVHGQcS5HdTZ+8w15fQkK+NeY0DDtTRmw2tW5zKwf61IETiyZo57
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(136003)(39860400002)(376002)(346002)(451199021)(38100700002)(54906003)(6636002)(110136005)(82960400001)(122000001)(316002)(38070700005)(83380400001)(478600001)(186003)(86362001)(66946007)(66556008)(66476007)(7416002)(33656002)(4326008)(8676002)(26005)(66446008)(53546011)(64756008)(76116006)(9686003)(6506007)(2906002)(5660300002)(8936002)(41300700001)(55016003)(52536014)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NitkMFBqMVVPdEVWMGxUWW9penc4dmRkTlFNNUhkbTBHZm1tS2RmOHZnSzV2?=
 =?utf-8?B?enJFN3BqVGcrQ3MzQW0zbHd0MmFMM2hNclNkc3lYTGgxaG1ueVNlWEwzenBY?=
 =?utf-8?B?L0dSemw4c0ZTOHpMYnpRalVvb0lvSTIrS2RvY2U2Y01nMXhYRFBVVysvMVh4?=
 =?utf-8?B?ZFBDVE9kU0ZEcndVT1FBRk85aENHeW5pWW95N1RvTGRlbUxkdmJXd3kzZ3dI?=
 =?utf-8?B?K2JuZHhjWE9vdkV1dVZjbDllM3RTbzVQNEhINXE1QStLS0RUeEVWVm5wN3Fv?=
 =?utf-8?B?ZnRiY1cvMU9ibFMwN2ZIK2c1SVdBUlFHWk9RYWZYQmZxNDdZU1ZUNjZvNEU4?=
 =?utf-8?B?SjhGa3dRbDh0Q2JBOWhQWjFWNm1LakltNkhJd0NOTElBWlBjK3BINzNvSXFk?=
 =?utf-8?B?U1dWQWplZ2FTTVNYaUFDR2JUeW1ia0NtTWlQdzFveXVmUng5R3h3emMzT1U4?=
 =?utf-8?B?aERwNm92Q283ZjZIdzM0VjBSK2prMm12RDRjdDUzZ3lhdTA4Nzl0MHRhamY1?=
 =?utf-8?B?RXhJTUxERW9xWGdFYnRaZUJrK2NsLzFuZmxGYmVpMndrdERoVnUwdkRJK1hG?=
 =?utf-8?B?Q1F0MWtxcENIeWR6aFlhRmNQUnd5MXlOZzFFSFpBeTF4L3kxVTJURjduM1p0?=
 =?utf-8?B?T0FMUVpRMHlya0kxNGJHODNvTmZJK0wyR3IxZVhHMG9jc1l1MC83SnBpTHBh?=
 =?utf-8?B?ckJvcVY0ZlJQN210TTd4M1NVK2Z1RnpUL1ZtV09xM20zVFFIRzYwYU43bUxj?=
 =?utf-8?B?UFpsTnkwM2ZNeTNTaTdubng4d2xPRURjczdIL2o2eDlmYS85bTZtb0pDNHA5?=
 =?utf-8?B?UGd0cEJ2OVcrSDl2bmFoUG4yaXdaTjF3N3ZiMEdRQ0VCRFM3TnBiUmZhUGdE?=
 =?utf-8?B?dmYwVkFGTVV5Z0tiVWJhQnRzV1ZzMFZIYjBtN2V3b1pOczN2QlpFS1RxU2FM?=
 =?utf-8?B?VHYxMFJaT1NQVXlITklsbzNDRUM5UEJ5RXdIVU83blgrb3I3OUQxWVBPOGYw?=
 =?utf-8?B?OUhleFErMW5tVlNGQXJWMVZnUS83bUhiZ003M2FFT0VlYVBhRDIvRkp5aDZs?=
 =?utf-8?B?M1phL1Juek1LTW5lYjBSd20zd1JQM2ZUbFBxdDlHZmprYXBiRWJCZ0xUKytC?=
 =?utf-8?B?aEF3Z0k0RDVpcEplSGV4TVhOY2xIWjlaWmt2aUdmRTFsNWRuSG16N3Ezd0lP?=
 =?utf-8?B?eWFXK0o5RDYzVVN5R092ekh5MkhJem1xQmY3cFhNeUFtRUtLSDNLcmVyTkx6?=
 =?utf-8?B?cDhkRTlrM0hPZm9lRStTNHZVbWhlZG5OZEdPNFVpcmt1SHJEZmxCWVhsbzNO?=
 =?utf-8?B?SFBSZTZ6RTg1QndtVUdKSlNTQ1h3Z1NEamxLc0ZKbk5Za2o1dWwvVWNmcXBz?=
 =?utf-8?B?ejFRM1ZzcVN6UnFGeEVrUVlUNGl6d0NNWjVoUDhtRHFjcllxMVpWWWlsWEtF?=
 =?utf-8?B?VzBFLzUrT29UVXFMR1NYeDBJSlhNbno5L1dNK3hBTUYxM2dTNlA2Wld0ZElK?=
 =?utf-8?B?ZmdHSGdKcTRZS0JTZ3NhNWdDeFh6REZ1WDZ6dVJOYXlNb1RLOWY3Rm1ad3pm?=
 =?utf-8?B?RVBrVHAvak5XRk5jY042aVhSbFdPVEZzOUtOTVBSbHRUQTlJL2pkbG1zcUFN?=
 =?utf-8?B?Q3hRY1N0dFJqR1ppQ0k3V0RmRmE3aHoyaHJrV0JtdXM2a2F5RFBrOWdMUzJH?=
 =?utf-8?B?V2NOZWNJMGE5OGhqalVyRlVhMnV1NHNmMUVNdzJrZnorRFZQYmZlM1NsOWR5?=
 =?utf-8?B?T0FiVFl0YVlwa2M0K0pHODliYW9IandRelU0SVR2RW40RG5zeUEvTkdxWlVT?=
 =?utf-8?B?RnJXZHlBdWMyTUpkQlN3cFY2ZVJxY0JWSHRaRFNMMVM0T1REdUREZXBxSGhC?=
 =?utf-8?B?OEtvNGh2YVhkNm5pcnVwWnNZZTVxZlFVWkk4L00xeVVzb0lBM1NMK3B3RmNr?=
 =?utf-8?B?Tm0zdmdtNjhEYkw4Q1F3VGlTdlBpMkFBQXBiTElCS3dQM2hzUzQydWd4cHRZ?=
 =?utf-8?B?aHowZ3Yyb09tR1d0dVpMMExUVklNS2VRcDFCZi9LU1dMNUF4clN2d3ZXNUtr?=
 =?utf-8?B?RTVEQnQ0TFIwYkQvaFVabFY5ZjdIZWxjNmNyNHJjUEVYQ0phUnQxeWkwVFVH?=
 =?utf-8?Q?+YlA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d296ea27-3a30-4342-e02f-08db37517f49
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 10:18:56.9896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hx8zW6RcWy2PQvG8L+kyvNSLqFbcuo9qQAUVU+otBImBpatLsV1bn0dk6eX1YcO/3dCBd0p9v+YYKMLDgaEKIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5323
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IEZyaWRheSwgQXByaWwgNywgMjAyMyA1OjQ4IFBNDQo+IA0KPiBIaSBZaSwNCj4gDQo+
IE9uIDQvMS8yMyAxNzoxOCwgWWkgTGl1IHdyb3RlOg0KPiA+IFZGSU8gZ3JvdXAgaGFzIGhpc3Rv
cmljYWxseSBhbGxvd2VkIG11bHRpLW9wZW4gb2YgdGhlIGRldmljZSBGRC4gVGhpcw0KPiA+IHdh
cyBtYWRlIHNlY3VyZSBiZWNhdXNlIHRoZSAib3BlbiIgd2FzIGV4ZWN1dGVkIHZpYSBhbiBpb2N0
bCB0byB0aGUNCj4gPiBncm91cCBGRCB3aGljaCBpcyBpdHNlbGYgb25seSBzaW5nbGUgb3Blbi4N
Cj4gPg0KPiA+IEhvd2V2ZXIsIG5vIGtub3duIHVzZSBvZiBtdWx0aXBsZSBkZXZpY2UgRkRzIHRv
ZGF5LiBJdCBpcyBraW5kIG9mIGENCj4gPiBzdHJhbmdlIHRoaW5nIHRvIGRvIGJlY2F1c2UgbmV3
IGRldmljZSBGRHMgY2FuIG5hdHVyYWxseSBiZSBjcmVhdGVkDQo+ID4gdmlhIGR1cCgpLg0KPiA+
DQo+ID4gV2hlbiB3ZSBpbXBsZW1lbnQgdGhlIG5ldyBkZXZpY2UgdUFQSSAob25seSB1c2VkIGlu
IGNkZXYgcGF0aCkgdGhlcmUgaXMNCj4gPiBubyBuYXR1cmFsIHdheSB0byBhbGxvdyB0aGUgZGV2
aWNlIGl0c2VsZiBmcm9tIGJlaW5nIG11bHRpLW9wZW5lZCBpbiBhDQo+ID4gc2VjdXJlIG1hbm5l
ci4gV2l0aG91dCB0aGUgZ3JvdXAgRkQgd2UgY2Fubm90IHByb3ZlIHRoZSBzZWN1cml0eSBjb250
ZXh0DQo+ID4gb2YgdGhlIG9wZW5lci4NCj4gPg0KPiA+IFRodXMsIHdoZW4gbW92aW5nIHRvIHRo
ZSBuZXcgdUFQSSB3ZSBibG9jayB0aGUgYWJpbGl0eSBvZiBvcGVuaW5nDQo+ID4gYSBkZXZpY2Ug
bXVsdGlwbGUgdGltZXMuIEdpdmVuIG9sZCBncm91cCBwYXRoIHN0aWxsIGFsbG93cyBpdCB3ZSBz
dG9yZQ0KPiA+IGEgdmZpb19ncm91cCBwb2ludGVyIGluIHN0cnVjdCB2ZmlvX2RldmljZV9maWxl
IHRvIGRpZmZlcmVudGlhdGUuDQo+ID4NCj4gPiBSZXZpZXdlZC1ieTogS2V2aW4gVGlhbiA8a2V2
aW4udGlhbkBpbnRlbC5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IEphc29uIEd1bnRob3JwZSA8amdn
QG52aWRpYS5jb20+DQo+ID4gVGVzdGVkLWJ5OiBUZXJyZW5jZSBYdSA8dGVycmVuY2UueHVAaW50
ZWwuY29tPg0KPiA+IFRlc3RlZC1ieTogTmljb2xpbiBDaGVuIDxuaWNvbGluY0BudmlkaWEuY29t
Pg0KPiA+IFRlc3RlZC1ieTogWWFudGluZyBKaWFuZyA8eWFudGluZy5qaWFuZ0BpbnRlbC5jb20+
DQo+ID4gU2lnbmVkLW9mZi1ieTogWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+DQo+ID4gLS0t
DQo+ID4gIGRyaXZlcnMvdmZpby9ncm91cC5jICAgICB8IDIgKysNCj4gPiAgZHJpdmVycy92Zmlv
L3ZmaW8uaCAgICAgIHwgMiArKw0KPiA+ICBkcml2ZXJzL3ZmaW8vdmZpb19tYWluLmMgfCA3ICsr
KysrKysNCj4gPiAgMyBmaWxlcyBjaGFuZ2VkLCAxMSBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy92ZmlvL2dyb3VwLmMgYi9kcml2ZXJzL3ZmaW8vZ3JvdXAuYw0K
PiA+IGluZGV4IGQ1NWNlM2NhNDRiNy4uMWFmNGI5ZTAxMmE3IDEwMDY0NA0KPiA+IC0tLSBhL2Ry
aXZlcnMvdmZpby9ncm91cC5jDQo+ID4gKysrIGIvZHJpdmVycy92ZmlvL2dyb3VwLmMNCj4gPiBA
QCAtMjQ1LDYgKzI0NSw4IEBAIHN0YXRpYyBzdHJ1Y3QgZmlsZSAqdmZpb19kZXZpY2Vfb3Blbl9m
aWxlKHN0cnVjdCB2ZmlvX2RldmljZQ0KPiAqZGV2aWNlKQ0KPiA+ICAJCWdvdG8gZXJyX291dDsN
Cj4gPiAgCX0NCj4gPg0KPiA+ICsJZGYtPmdyb3VwID0gZGV2aWNlLT5ncm91cDsNCj4gPiArDQo+
IGluIHByZXZpb3VzIHBhdGNoZXMgZGYgZmllbGRzIHdlcmUgcHJvdGVjdGVkIHdpdGggdmFyaW91
cyBsb2Nrcy4gSSByZWZlcg0KPiB0byB2ZmlvX2RldmljZV9ncm91cF9vcGVuKCkgaW1wbGVtZW50
YXRpb24uIE5vIG5lZWQgaGVyZT8NCg0KeWVzLCBubyBuZWVkIGZvciBncm91cC4gSXQgc2hvdWxk
IGJlIHN0YXRpYyBpbiB0aGUgbGlmZWNpcmNsZSBvZiBkZi4NCg0KPiANCj4gQnkgdGhlIHdheSBz
aW5jZSB0aGUgZ3JvdXAgaXMgc2V0IGhlcmUsIHdydCBbUEFUQ0ggdjkgMDYvMjVdIGt2bS92Zmlv
Og0KPiBBY2NlcHQgdmZpbyBkZXZpY2UgZmlsZSBmcm9tIHVzZXJzcGFjZSB5b3UgaGF2ZSBhIHdh
eSB0byBkZXRlcm1pbmUgaWYgYQ0KPiBkZXZpY2Ugd2FzIG9wZW5lZCBpbiB0aGUgbGVnYWN5IHdh
eSwgbm8/DQoNCnllcywgYnkgdGhpcyB3ZSBjYW4gdGVsbCBpZiBhIGRldmljZSBmaWxlIGlzIG9w
ZW5lZCBieSBsZWdhY3kgb3IgY2Rldi4NCkJ1dCBJIGd1ZXNzIHRoZSBwcm9ibGVtIGluIHBhdGNo
IDA2LzI1IGlzIHdlIG5lZWQgdG8ga25vdyBpZiB0aGUgb3JkZXINCmJldHdlZW4gc2V0X2t2bSBh
bmQgb3Blbl9kZXZpY2UgaXMgbmVlZGVkLiBpcyBpdD8gdGhhdCBvcmRlciByZXF1aXJlbWVudA0K
aXMgZHVlIHRvIHRoYXQgdGhlIGt2bSBwb2ludGVyIGlzIG5lZWRlZCBieSBvcGVuX2RldmljZSgp
IGNhbGxiYWNrLiBlLmcuDQprdm1ndC4gRm9yIG90aGVyIHZmaW8gdXNlcnMsIHRoaXMgb3JkZXIg
aXMgbm90IG5lZWRlZCBvciBldmVuIHRoZQ0KS1ZNX0RFVl9WRklPX0ZJTEUgaXMgbm90IG5lZWRl
ZCBpZiB2ZmlvIGlzIG5vdCB1c2VkIHRvIGRvIGRldmljZSBwYXNzdGhyb3VnaC4NCg0KPiA+ICAJ
cmV0ID0gdmZpb19kZXZpY2VfZ3JvdXBfb3BlbihkZik7DQo+ID4gIAlpZiAocmV0KQ0KPiA+ICAJ
CWdvdG8gZXJyX2ZyZWU7DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmZpby92ZmlvLmggYi9k
cml2ZXJzL3ZmaW8vdmZpby5oDQo+ID4gaW5kZXggYjJmMjBiNzhhNzA3Li5mMWE0NDhmOWQwNjcg
MTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy92ZmlvL3ZmaW8uaA0KPiA+ICsrKyBiL2RyaXZlcnMv
dmZpby92ZmlvLmgNCj4gPiBAQCAtMTgsNiArMTgsOCBAQCBzdHJ1Y3QgdmZpb19jb250YWluZXI7
DQo+ID4NCj4gPiAgc3RydWN0IHZmaW9fZGV2aWNlX2ZpbGUgew0KPiA+ICAJc3RydWN0IHZmaW9f
ZGV2aWNlICpkZXZpY2U7DQo+ID4gKwlzdHJ1Y3QgdmZpb19ncm91cCAqZ3JvdXA7DQo+ID4gKw0K
PiA+ICAJYm9vbCBhY2Nlc3NfZ3JhbnRlZDsNCj4gPiAgCXNwaW5sb2NrX3Qga3ZtX3JlZl9sb2Nr
OyAvKiBwcm90ZWN0IGt2bSBmaWVsZCAqLw0KPiA+ICAJc3RydWN0IGt2bSAqa3ZtOw0KPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vdmZpb19tYWluLmMgYi9kcml2ZXJzL3ZmaW8vdmZpb19t
YWluLmMNCj4gPiBpbmRleCA2ZDVkM2MyMTgwYzguLmM4NzIxZDVkMDVmYSAxMDA2NDQNCj4gPiAt
LS0gYS9kcml2ZXJzL3ZmaW8vdmZpb19tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL3ZmaW8vdmZp
b19tYWluLmMNCj4gPiBAQCAtNDc3LDYgKzQ3NywxMyBAQCBpbnQgdmZpb19kZXZpY2Vfb3Blbihz
dHJ1Y3QgdmZpb19kZXZpY2VfZmlsZSAqZGYpDQo+ID4NCj4gPiAgCWxvY2tkZXBfYXNzZXJ0X2hl
bGQoJmRldmljZS0+ZGV2X3NldC0+bG9jayk7DQo+ID4NCj4gPiArCS8qDQo+ID4gKwkgKiBPbmx5
IHRoZSBncm91cCBwYXRoIGFsbG93cyB0aGUgZGV2aWNlIG9wZW5lZCBtdWx0aXBsZSB0aW1lcy4N
Cj4gYWxsb3dzIHRoZSBkZXZpY2UgdG8gYmUgb3BlbmVkIG11bHRpcGxlIHRpbWVzDQoNCmdvdCBp
dC4NCg0KVGhhbmtzLA0KWWkgTGl1DQoNCj4gPiArCSAqIFRoZSBkZXZpY2UgY2RldiBwYXRoIGRv
ZXNuJ3QgaGF2ZSBhIHNlY3VyZSB3YXkgZm9yIGl0Lg0KPiA+ICsJICovDQo+ID4gKwlpZiAoZGV2
aWNlLT5vcGVuX2NvdW50ICE9IDAgJiYgIWRmLT5ncm91cCkNCj4gPiArCQlyZXR1cm4gLUVJTlZB
TDsNCj4gPiArDQo+ID4gIAlkZXZpY2UtPm9wZW5fY291bnQrKzsNCj4gPiAgCWlmIChkZXZpY2Ut
Pm9wZW5fY291bnQgPT0gMSkgew0KPiA+ICAJCXJldCA9IHZmaW9fZGV2aWNlX2ZpcnN0X29wZW4o
ZGYpOw0KPiBUaGFua3MNCj4gDQo+IEVyaWMNCg0K
