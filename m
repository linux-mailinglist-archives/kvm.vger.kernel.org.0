Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F7A6809BF
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 10:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbjA3Jj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 04:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236046AbjA3Jjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 04:39:55 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A971B17CC4
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 01:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675071573; x=1706607573;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ixv8E/lLNIxV+EuP4vcNgdiU+GKjlDLhYCsbSszj5dk=;
  b=B7/M5GBFXgVfn629FWB6pn838WGFfCtmS5sSWxHZS6KcU1X+GK1U2m+g
   U5FW0kASvJWfZzeFzQNydp3tbnrJNzaP3NVKw54td98erf8+doG82WZ2g
   F7qF5RFSdhm3DM6BhNTQHNAnnA4gneIi+2HuV8Erj1WAAr7mmcXawMoQc
   qasat4xRSYDXwANr9X6bwJtnDHW1Z4l715vFWVERSgv970tRWjutuI9lQ
   NQryroiT27CgC934WgRMtxR1qOLZF8TP8lxajjZFTF4ORfnIHCCR0lIGc
   929qn1QEie6OgFyrFOdqXmMt5bRPEk4w0Tyh2WQzEsMEoMWnrfOYotnlg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="326183338"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="326183338"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 01:38:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="772430973"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="772430973"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 30 Jan 2023 01:38:47 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 01:38:46 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 01:38:46 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 01:38:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbit78RXHHcieKsGs9sI6Tu9aDVYik5JXBR7PdvlLv1A9plLzlxYg3GK0fdFM7/rLIBHbnhX6uwq6OSORehOJP+usl53+7jLqrE7Qb0au8+Yq60B5XaFv4hniX0VDFwksb/3HeMHbgrfouhfaKL0EbncQMQlQEEyQWd9m70TLBpcDvMXG62XXvIMvim4ROC2LCO3q89yDA/eVIuuJTOWF1nso03MAgy9dpBRwgUdKYqaJQD0qaWagCfOn4Ey9cNFObdbaxK9A3ZmyL5VnA3J7AAQyCARocSq576yHZEXOe8PlHsaJ9Gly0pbZZr8IAkn76FY7uK4GVxJzCHW9higrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixv8E/lLNIxV+EuP4vcNgdiU+GKjlDLhYCsbSszj5dk=;
 b=m2eoLCToWPiXkOWLjxL0l2Mzfgza7rJ+1+liTdujj/vJu+X1UCKOy/v9EbiOVQyUZr5e5HMume/70nG36kdtVfe9J8wyV6FSV9f6iy8awhp5CTmB6W8NdykTlXNxeK3hvO47gu0cinHnffJWVKQOXJGUdNcm4u1nOSMre3cW6+2HfNgxzGo1mq2C9FnKgniRQF7zzr9stGH9WHv9wUxdFWQMsJ+L/z3vB9HTnPO+pEQdw5ZO7VNI0v2YxpKxb+3gF/VGg1B3y2Q6+ebzeJOG78HKt61dn1lwgHyZzKgc+0iwG5DnDoTvioI53uSUTJKEBUJ7axY9mdN4z7meuDC/JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CY8PR11MB7244.namprd11.prod.outlook.com (2603:10b6:930:97::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 09:38:44 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 09:38:44 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 07/13] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Thread-Topic: [PATCH 07/13] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Thread-Index: AQHZKnqZS+8POWOjeU6G9NbMGjMjsK6llfGAgBEqL1A=
Date:   Mon, 30 Jan 2023 09:38:44 +0000
Message-ID: <DS0PR11MB7529C3839F35A49E97F90739C3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-8-yi.l.liu@intel.com>
 <537e68ee-6dab-97e0-4797-1ca5cec4c710@redhat.com>
In-Reply-To: <537e68ee-6dab-97e0-4797-1ca5cec4c710@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CY8PR11MB7244:EE_
x-ms-office365-filtering-correlation-id: 47a83a85-7ea5-4d0b-e6d0-08db02a5c7d4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kvqMSNpIwn24dCZ5qzDfny3THrQvsKR09VUC0snjMURM1NzwfTAt547FTYDWwBpQhNacULJHx5Ibb0aBV/VwzvQd2n9icNo+T/N1/PqpyjxV8fjbmn5E81xzqrldntFfhmOgNF0SA5V0H6Is2RCkswS60EeifoJuXvfK2xMQ9sJXs45NQ+FzdhqbeUI2zuBfwxnuZgUG9rqf6lGs+6NkBdrmrVSwZ0amzmwJTjqF1/HvSWZE2Wg1/isOHb0qitAc5c39Pwc5AFO246hGU7p91TUuue3L0Lz0dM5EyqxI1WFYaMVfjEuHFBhZnPruhLicl5nR8Ka4DAcLjRoxtujBoBc1RQvU0sAcmIG8tW8wvCrHVPFOhoPvRQmI0W9T1FZOnlfWk58syVkAfSjL0ZnPsF+auMKLTDBHvnwI37+HZzcEZjZieUeV5EjbWqz6eehgKRh+UCiTjLsSLnHY3/mpHAZLLSGz639y6aYIL5vtlttyGew+m8fImV7LNnLaU24Bn7dndN1hZx6kaNnLl/uoP8Yl8A2EUINTOUthV309d6v0Ja7Yr7B5KLRqNWTwJo6JAkCO8f1jQ/4pCkYKWK97u5EAuulAw0HSkU4pCQ5a3HTXnhyELNuTyL1G9r+8GQv2Qg01/wmhVi11Sg+EDJs/vJ4Q8/aS5NbKr3OUqjNaLmUhfZvnbvVxbg0Fu1G0g03ava4miyLpxJLJ2PbDNZr0c8hFm/u2YEV4A0exjuZG3i5i74rOFeoCRaTdxXzpbvj1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199018)(2906002)(82960400001)(33656002)(9686003)(26005)(186003)(478600001)(316002)(54906003)(110136005)(38070700005)(55016003)(86362001)(122000001)(38100700002)(41300700001)(8936002)(76116006)(4326008)(66446008)(66556008)(66476007)(64756008)(66946007)(8676002)(7696005)(52536014)(966005)(53546011)(6506007)(71200400001)(5660300002)(7416002)(83380400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2RNTFVtRHlNckljbkVzMU5pbmtNZUJLS0JOWW9od09WRXppcDhjUmhFQVdk?=
 =?utf-8?B?NzdHL0ZxM0NwMzk5eHZFbkV4WmxqcjM4WU4rL1grZHgvR2R3VDNkTFNsN2dJ?=
 =?utf-8?B?cm1aejV5bXpPTlZML2I2SDZHT2JVSW1tdFRlMkFjb1hNZFNaeGQwcEtydDFP?=
 =?utf-8?B?V2dsSnZVeTJGRlVHL0ZvVmc3ZmJuQ2F5a3phMlVoUHZ4eVVZMGg4OVAydXpm?=
 =?utf-8?B?ZythRC9nRUxtNHZsQm9zZUVHcGZIaTEySHFZdnRveC9HbGIyL1RKeHE2YlVQ?=
 =?utf-8?B?MTMyYVdOUDM1R0oxYXZNS2k5MFBwVk9pcDl4cU9jMittNGNhbGVvTWdYTmw3?=
 =?utf-8?B?eUFxMjl6VXRpOFlSWWFaS3FlYmhFWDJVeUt6Vmhjd0VQZ1ozUmZabHp3cFVs?=
 =?utf-8?B?MFBabzU3eUdiL3FwVm5DYytJTVNuOTBsUWlqWVUvclk3RWtxd3dqaGdhdEtn?=
 =?utf-8?B?ckpBcGRtUTc2WUUxNXhOZEJWVEcyakY5WXJCOU5DUGExRVVQc2ZwOWxuRnZa?=
 =?utf-8?B?MGVHNnBncnRoRjh3TUlpUzdQalExRmhnUUNHc2pabkZ6bk9ENW0xRXgzeWZ0?=
 =?utf-8?B?Umd0L0JaMU5wSmczN1ZTdzQwUGk2QlNmNGNLWVZTZndDcXhTMVFTaWJhV1ZZ?=
 =?utf-8?B?VUlCODI0UGtBWmpDblpVR3RyVXkrWjNZSzRGVkJ2c05jRDR3ZE54VmlEcHN3?=
 =?utf-8?B?d0VpeE9zU0RnSnI5RVlGcERkU08rNXRZNFFHMU1jdXB3ZDZ6RmtKYkJnbWdT?=
 =?utf-8?B?U3pGM3YvTkFjMWNrYTIzVkgxWGdvMlgydm8rU2NyQzU3N0FvanZvdjBCekg2?=
 =?utf-8?B?Z2R1a3EvY29TbXFGNnlEMTdMQzFsOVdxODgxZ3VKaHY0TDFqZisvYlFTbXpH?=
 =?utf-8?B?elUyZXZ6L2VxbXEyZTJURXBJcm9MTU1nUVNLYVJ6YkFCODd0TFhjYml6RUlr?=
 =?utf-8?B?TXl5TTlWT0xhaDVDTUZoVXBRQVd2VzBHR0hWTU5YR2Q2bk0vckpuUXdYNUc2?=
 =?utf-8?B?dWExOVRobmVPWVE1QWp1ZFhJMVp4K2kzOHBoakZ3NVhjSHprN0NvUXM3YUtm?=
 =?utf-8?B?YlI2VmVOVkhuRzluWmVBd3JFMGkrb0RjS3JDUEJxZkF0Z2t3NEZNZ2NtMXEx?=
 =?utf-8?B?VVEzcCs3TFJJTVBXYWl4MkRmV2VoQWh4UktpRWFtcmtWSlI2K3c5RStMR2Fi?=
 =?utf-8?B?RVpMeCtYT25hOFNoQnlsbDBtWWpQSG11S1FyamVHU1BtTmw3djhyVUhDUG16?=
 =?utf-8?B?N0MrYitXWVVsc3UrT0NEaEFqSWRWTWkyY1dGYXo4YjBLTmJpT3orZ25wQWJQ?=
 =?utf-8?B?KzBrb3lyQnpzY2liQzAzUlBRNElmb3lLcjdvcmsrYmg5dU9YMUdHNjNCdFZV?=
 =?utf-8?B?aEpMUDNSTU1CWUV1SWkvZnl2dUxodE5ZdlVaMGNuUkVmaXRKb0QvbitKZy9L?=
 =?utf-8?B?ZDIwTTQ3UHNMd3hZQ0cvUUh4WVVLcXhzRlhWdUovT29JY3JPT3o4bExIeDNJ?=
 =?utf-8?B?Rys4VUN6NnRzM3VEd1MyalpZdUpCalBPb0ViNXVuQmhEbjcrTG5TN2VoRDJy?=
 =?utf-8?B?UTNoNnhabWhING9WQnJyL2w5dHlLcUttdVhJcEUzdlRXbklmYVkzalFoSWk1?=
 =?utf-8?B?Vk5FZFY2VHEwT2dUUWVjTmJ0QVUwdit6U2VaMnFPNXIrdFBid0loMTArQnFq?=
 =?utf-8?B?bWNwMDJkTW1HTHZDcGNyY2RtZHFnZkxiY291bG1ZNlRDM2FweEtaaDY4T0ZX?=
 =?utf-8?B?UFFMUjRJL3E4Ulk2bWYxSEFLWFdyVTI1VXA4K0p1NmJGSVVOVGNmS2M4UXdC?=
 =?utf-8?B?dGdzZW5wWXpTQ3Z5KzJXTFBPSy91ZmJrc1NEdlFDa2ZxZlFXUytCdTkzYmpN?=
 =?utf-8?B?Y3dqOWJySyt4R3JadGcyTEt6Zzhvd2JkODlDTS9VUDhiRlhsYWdFeUI5a1Vo?=
 =?utf-8?B?SFAwK0JYd1pBdVZRdTZmOEw2K1NPOXNlMmN2THAvK3B0S0Z4elNBTEw4NThH?=
 =?utf-8?B?NW1GRitqeUcrWDFtZkFlRWQvMFJWeUpnMHh5SC8wTWQzcWNDQUxnTHhNWmkz?=
 =?utf-8?B?K2FqQkZYelVaRWdITis5Q3ozSm9Oa2xLM0JYb1VYeVV4VXhoL2ZEWllIMHJ4?=
 =?utf-8?Q?O9apEnsPZ+l8nqjdSJKxqyhbm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a83a85-7ea5-4d0b-e6d0-08db02a5c7d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 09:38:44.8223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U/7fVH/WOMsHOBdkJVjjpUdi2kcaRvXXwhNPmEzYFJ1hjrKERxqwd8SiY8JUhMYc8ljL8MJ6PPhDMjRf5RZx5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7244
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgRXJpYywNCg0KPiBGcm9tOiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+DQo+
IFNlbnQ6IFRodXJzZGF5LCBKYW51YXJ5IDE5LCAyMDIzIDc6MDIgUE0NCj4gDQo+IEhpIFlpLA0K
PiANCj4gT24gMS8xNy8yMyAxNDo0OSwgWWkgTGl1IHdyb3RlOg0KPiA+IFRoaXMgYXZvaWRzIHBh
c3Npbmcgc3RydWN0IGt2bSAqIGFuZCBzdHJ1Y3QgaW9tbXVmZF9jdHggKiBpbiBtdWx0aXBsZQ0K
PiA+IGZ1bmN0aW9ucy4gdmZpb19kZXZpY2Vfb3BlbigpIGJlY29tZXMgdG8gYmUgYSBsb2NrZWQg
aGVscGVyLg0KPiB3aHk/IGJlY2F1c2UgZGV2X3NldCBsb2NrIG5vdyBwcm90ZWN0cyB2ZmlvX2Rl
dmljZV9maWxlIGZpZWxkcz8gd29ydGggdG8NCj4gZXhwbGFpbi4NCg0KWWVhaCwgdGhpcyBpcyBi
ZWNhdXNlIHRoZSBtYWpvciByZWZlcmVuY2Ugb2YgdGhlIHZmaW9fZGV2aWNlX2ZpbGUgZmllbGRz
DQphcmUgdW5kZXIgZGV2X3NldCBsb2NrLg0KDQo+IGRvIHdlIG5lZWQgdG8gdXBkYXRlIHRoZSBj
b21tZW50IGluIHZmaW8uaCByZWxhdGVkIHRvIHN0cnVjdA0KPiB2ZmlvX2RldmljZV9zZXQ/DQoN
Clllcy4NCg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogWWkgTGl1IDx5aS5sLmxpdUBpbnRlbC5j
b20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvdmZpby9ncm91cC5jICAgICB8IDM0ICsrKysrKysr
KysrKysrKysrKysrKysrKystLS0tLS0tLS0NCj4gPiAgZHJpdmVycy92ZmlvL3ZmaW8uaCAgICAg
IHwgMTAgKysrKystLS0tLQ0KPiA+ICBkcml2ZXJzL3ZmaW8vdmZpb19tYWluLmMgfCA0MCArKysr
KysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tDQo+ID4gIDMgZmlsZXMgY2hhbmdl
ZCwgNTQgaW5zZXJ0aW9ucygrKSwgMzAgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy92ZmlvL2dyb3VwLmMgYi9kcml2ZXJzL3ZmaW8vZ3JvdXAuYw0KPiA+IGluZGV4
IGQ4M2NmMDY5ZDI5MC4uNzIwMDMwNDY2M2U1IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdmZp
by9ncm91cC5jDQo+ID4gKysrIGIvZHJpdmVycy92ZmlvL2dyb3VwLmMNCj4gPiBAQCAtMTU0LDMz
ICsxNTQsNDkgQEAgc3RhdGljIGludCB2ZmlvX2dyb3VwX2lvY3RsX3NldF9jb250YWluZXIoc3Ry
dWN0IHZmaW9fZ3JvdXAgKmdyb3VwLA0KPiA+ICAJcmV0dXJuIHJldDsNCj4gPiAgfQ0KPiA+DQo+
ID4gLXN0YXRpYyBpbnQgdmZpb19kZXZpY2VfZ3JvdXBfb3BlbihzdHJ1Y3QgdmZpb19kZXZpY2Ug
KmRldmljZSkNCj4gPiArc3RhdGljIGludCB2ZmlvX2RldmljZV9ncm91cF9vcGVuKHN0cnVjdCB2
ZmlvX2RldmljZV9maWxlICpkZikNCj4gPiAgew0KPiA+ICsJc3RydWN0IHZmaW9fZGV2aWNlICpk
ZXZpY2UgPSBkZi0+ZGV2aWNlOw0KPiA+ICAJaW50IHJldDsNCj4gPg0KPiA+ICAJbXV0ZXhfbG9j
aygmZGV2aWNlLT5ncm91cC0+Z3JvdXBfbG9jayk7DQo+ID4gIAlpZiAoIXZmaW9fZ3JvdXBfaGFz
X2lvbW11KGRldmljZS0+Z3JvdXApKSB7DQo+ID4gIAkJcmV0ID0gLUVJTlZBTDsNCj4gPiAtCQln
b3RvIG91dF91bmxvY2s7DQo+ID4gKwkJZ290byBlcnJfdW5sb2NrX2dyb3VwOw0KPiA+ICAJfQ0K
PiA+DQo+ID4gKwltdXRleF9sb2NrKCZkZXZpY2UtPmRldl9zZXQtPmxvY2spOw0KPiBpcyB0aGVy
ZSBhbiBleHBsYW5hdGlvbiBzb21ld2hlcmUgYWJvdXQgbG9ja2luZyBvcmRlciBiL3cgZ3JvdXBf
bG9jaywNCj4gZGV2X3NldCBsb2NrPw0KDQpJbiB0aGUgYmVmb3JlLCBkZXZfc2V0IGxvY2sgaXMg
aGVsZCBwcmlvciB0byBncm91cF9sb2NrLiBCdXQgbm93LCBncm91cF9sb2NrDQppcyBoZWxkIGZp
cnN0bHkgYW5kIHRoZW4gZGV2X3NldCBsb2NrIGlmIHRoZSBncm91cF9sb2NrIGlzIGNvbXBpbGVk
LiBFLmcuIHRoZQ0KZ3JvdXAgb3BlbiBwYXRoLg0KDQo+ID4gIAkvKg0KPiA+ICAJICogSGVyZSB3
ZSBwYXNzIHRoZSBLVk0gcG9pbnRlciB3aXRoIHRoZSBncm91cCB1bmRlciB0aGUgbG9jay4gIElm
DQo+IHRoZQ0KPiA+ICAJICogZGV2aWNlIGRyaXZlciB3aWxsIHVzZSBpdCwgaXQgbXVzdCBvYnRh
aW4gYSByZWZlcmVuY2UgYW5kIHJlbGVhc2UgaXQNCj4gPiAgCSAqIGR1cmluZyBjbG9zZV9kZXZp
Y2UuDQo+ID4gIAkgKi8NCj4gTWF5IGJlIHRoZSBvcHBvcnR1bml0eSB0byByZXBocmFzZSB0aGUg
YWJvdmUgY29tbWVudC4gSSBhbSBub3QgYSBuYXRpdmUNCj4gZW5nbGlzaCBzcGVha2VyIGJ1dCB0
aGUgdGltZSBjb25jb3JkYW5jZSBzZWVtcyB3ZWlyZCArIGNsYXJpZnkgYQ0KPiByZWZlcmVuY2Ug
dG8gd2hhdC4NCg0KT2gsIGl0J3MgYSByZWZlcmVuY2UgdG8ga3ZtIHBvaW50ZXIuIA0KDQo+ID4g
LQlyZXQgPSB2ZmlvX2RldmljZV9vcGVuKGRldmljZSwgZGV2aWNlLT5ncm91cC0+aW9tbXVmZCwN
Cj4gPiAtCQkJICAgICAgIGRldmljZS0+Z3JvdXAtPmt2bSk7DQo+ID4gKwlkZi0+a3ZtID0gZGV2
aWNlLT5ncm91cC0+a3ZtOw0KPiA+ICsJZGYtPmlvbW11ZmQgPSBkZXZpY2UtPmdyb3VwLT5pb21t
dWZkOw0KPiA+ICsNCj4gPiArCXJldCA9IHZmaW9fZGV2aWNlX29wZW4oZGYpOw0KPiA+ICsJaWYg
KHJldCkNCj4gPiArCQlnb3RvIGVycl91bmxvY2tfZGV2aWNlOw0KPiA+ICsJbXV0ZXhfdW5sb2Nr
KCZkZXZpY2UtPmRldl9zZXQtPmxvY2spOw0KPiA+DQo+ID4gLW91dF91bmxvY2s6DQo+ID4gKwlt
dXRleF91bmxvY2soJmRldmljZS0+Z3JvdXAtPmdyb3VwX2xvY2spOw0KPiA+ICsJcmV0dXJuIDA7
DQo+ID4gKw0KPiA+ICtlcnJfdW5sb2NrX2RldmljZToNCj4gPiArCWRmLT5rdm0gPSBOVUxMOw0K
PiA+ICsJZGYtPmlvbW11ZmQgPSBOVUxMOw0KPiA+ICsJbXV0ZXhfdW5sb2NrKCZkZXZpY2UtPmRl
dl9zZXQtPmxvY2spOw0KPiA+ICtlcnJfdW5sb2NrX2dyb3VwOg0KPiA+ICAJbXV0ZXhfdW5sb2Nr
KCZkZXZpY2UtPmdyb3VwLT5ncm91cF9sb2NrKTsNCj4gPiAgCXJldHVybiByZXQ7DQo+ID4gIH0N
Cj4gPg0KPiA+IC12b2lkIHZmaW9fZGV2aWNlX2dyb3VwX2Nsb3NlKHN0cnVjdCB2ZmlvX2Rldmlj
ZSAqZGV2aWNlKQ0KPiA+ICt2b2lkIHZmaW9fZGV2aWNlX2dyb3VwX2Nsb3NlKHN0cnVjdCB2Zmlv
X2RldmljZV9maWxlICpkZikNCj4gPiAgew0KPiA+ICsJc3RydWN0IHZmaW9fZGV2aWNlICpkZXZp
Y2UgPSBkZi0+ZGV2aWNlOw0KPiA+ICsNCj4gPiAgCW11dGV4X2xvY2soJmRldmljZS0+Z3JvdXAt
Pmdyb3VwX2xvY2spOw0KPiA+IC0JdmZpb19kZXZpY2VfY2xvc2UoZGV2aWNlLCBkZXZpY2UtPmdy
b3VwLT5pb21tdWZkKTsNCj4gPiArCXZmaW9fZGV2aWNlX2Nsb3NlKGRmKTsNCj4gPiAgCW11dGV4
X3VubG9jaygmZGV2aWNlLT5ncm91cC0+Z3JvdXBfbG9jayk7DQo+ID4gIH0NCj4gPg0KPiA+IEBA
IC0xOTYsNyArMjEyLDcgQEAgc3RhdGljIHN0cnVjdCBmaWxlICp2ZmlvX2RldmljZV9vcGVuX2Zp
bGUoc3RydWN0DQo+IHZmaW9fZGV2aWNlICpkZXZpY2UpDQo+ID4gIAkJZ290byBlcnJfb3V0Ow0K
PiA+ICAJfQ0KPiA+DQo+ID4gLQlyZXQgPSB2ZmlvX2RldmljZV9ncm91cF9vcGVuKGRldmljZSk7
DQo+ID4gKwlyZXQgPSB2ZmlvX2RldmljZV9ncm91cF9vcGVuKGRmKTsNCj4gPiAgCWlmIChyZXQp
DQo+ID4gIAkJZ290byBlcnJfZnJlZTsNCj4gPg0KPiA+IEBAIC0yMjgsNyArMjQ0LDcgQEAgc3Rh
dGljIHN0cnVjdCBmaWxlICp2ZmlvX2RldmljZV9vcGVuX2ZpbGUoc3RydWN0DQo+IHZmaW9fZGV2
aWNlICpkZXZpY2UpDQo+ID4gIAlyZXR1cm4gZmlsZXA7DQo+ID4NCj4gPiAgZXJyX2Nsb3NlX2Rl
dmljZToNCj4gPiAtCXZmaW9fZGV2aWNlX2dyb3VwX2Nsb3NlKGRldmljZSk7DQo+ID4gKwl2Zmlv
X2RldmljZV9ncm91cF9jbG9zZShkZik7DQo+ID4gIGVycl9mcmVlOg0KPiA+ICAJa2ZyZWUoZGYp
Ow0KPiA+ICBlcnJfb3V0Og0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZmaW8vdmZpby5oIGIv
ZHJpdmVycy92ZmlvL3ZmaW8uaA0KPiA+IGluZGV4IDUzYWY2ZTNlYTIxNC4uM2Q4YmExNjUxNDZj
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdmZpby92ZmlvLmgNCj4gPiArKysgYi9kcml2ZXJz
L3ZmaW8vdmZpby5oDQo+ID4gQEAgLTE5LDE0ICsxOSwxNCBAQCBzdHJ1Y3QgdmZpb19jb250YWlu
ZXI7DQo+ID4gIHN0cnVjdCB2ZmlvX2RldmljZV9maWxlIHsNCj4gPiAgCXN0cnVjdCB2ZmlvX2Rl
dmljZSAqZGV2aWNlOw0KPiA+ICAJc3RydWN0IGt2bSAqa3ZtOw0KPiA+ICsJc3RydWN0IGlvbW11
ZmRfY3R4ICppb21tdWZkOw0KPiA+ICB9Ow0KPiA+DQo+ID4gIHZvaWQgdmZpb19kZXZpY2VfcHV0
X3JlZ2lzdHJhdGlvbihzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSk7DQo+ID4gIGJvb2wgdmZp
b19kZXZpY2VfdHJ5X2dldF9yZWdpc3RyYXRpb24oc3RydWN0IHZmaW9fZGV2aWNlICpkZXZpY2Up
Ow0KPiA+IC1pbnQgdmZpb19kZXZpY2Vfb3BlbihzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSwN
Cj4gPiAtCQkgICAgIHN0cnVjdCBpb21tdWZkX2N0eCAqaW9tbXVmZCwgc3RydWN0IGt2bSAqa3Zt
KTsNCj4gPiAtdm9pZCB2ZmlvX2RldmljZV9jbG9zZShzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmlj
ZSwNCj4gPiAtCQkgICAgICAgc3RydWN0IGlvbW11ZmRfY3R4ICppb21tdWZkKTsNCj4gPiAraW50
IHZmaW9fZGV2aWNlX29wZW4oc3RydWN0IHZmaW9fZGV2aWNlX2ZpbGUgKmRmKTsNCj4gPiArdm9p
ZCB2ZmlvX2RldmljZV9jbG9zZShzdHJ1Y3QgdmZpb19kZXZpY2VfZmlsZSAqZGV2aWNlKTsNCj4g
PiArDQo+ID4gIHN0cnVjdCB2ZmlvX2RldmljZV9maWxlICoNCj4gPiAgdmZpb19hbGxvY2F0ZV9k
ZXZpY2VfZmlsZShzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSk7DQo+ID4NCj4gPiBAQCAtOTAs
NyArOTAsNyBAQCB2b2lkIHZmaW9fZGV2aWNlX2dyb3VwX3JlZ2lzdGVyKHN0cnVjdCB2ZmlvX2Rl
dmljZQ0KPiAqZGV2aWNlKTsNCj4gPiAgdm9pZCB2ZmlvX2RldmljZV9ncm91cF91bnJlZ2lzdGVy
KHN0cnVjdCB2ZmlvX2RldmljZSAqZGV2aWNlKTsNCj4gPiAgaW50IHZmaW9fZGV2aWNlX2dyb3Vw
X3VzZV9pb21tdShzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSk7DQo+ID4gIHZvaWQgdmZpb19k
ZXZpY2VfZ3JvdXBfdW51c2VfaW9tbXUoc3RydWN0IHZmaW9fZGV2aWNlICpkZXZpY2UpOw0KPiA+
IC12b2lkIHZmaW9fZGV2aWNlX2dyb3VwX2Nsb3NlKHN0cnVjdCB2ZmlvX2RldmljZSAqZGV2aWNl
KTsNCj4gPiArdm9pZCB2ZmlvX2RldmljZV9ncm91cF9jbG9zZShzdHJ1Y3QgdmZpb19kZXZpY2Vf
ZmlsZSAqZGYpOw0KPiA+ICBzdHJ1Y3QgdmZpb19ncm91cCAqdmZpb19ncm91cF9mcm9tX2ZpbGUo
c3RydWN0IGZpbGUgKmZpbGUpOw0KPiA+ICBib29sIHZmaW9fZ3JvdXBfZW5mb3JjZWRfY29oZXJl
bnQoc3RydWN0IHZmaW9fZ3JvdXAgKmdyb3VwKTsNCj4gPiAgdm9pZCB2ZmlvX2dyb3VwX3NldF9r
dm0oc3RydWN0IHZmaW9fZ3JvdXAgKmdyb3VwLCBzdHJ1Y3Qga3ZtICprdm0pOw0KPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL3ZmaW8vdmZpb19tYWluLmMgYi9kcml2ZXJzL3ZmaW8vdmZpb19tYWlu
LmMNCj4gPiBpbmRleCBkYzA4ZDVkZDYyY2MuLjNkZjcxYmQ5Y2QxZSAxMDA2NDQNCj4gPiAtLS0g
YS9kcml2ZXJzL3ZmaW8vdmZpb19tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL3ZmaW8vdmZpb19t
YWluLmMNCj4gPiBAQCAtMzU4LDkgKzM1OCwxMSBAQCB2ZmlvX2FsbG9jYXRlX2RldmljZV9maWxl
KHN0cnVjdCB2ZmlvX2RldmljZQ0KPiAqZGV2aWNlKQ0KPiA+ICAJcmV0dXJuIGRmOw0KPiA+ICB9
DQo+ID4NCj4gPiAtc3RhdGljIGludCB2ZmlvX2RldmljZV9maXJzdF9vcGVuKHN0cnVjdCB2Zmlv
X2RldmljZSAqZGV2aWNlLA0KPiA+IC0JCQkJICBzdHJ1Y3QgaW9tbXVmZF9jdHggKmlvbW11ZmQs
IHN0cnVjdCBrdm0NCj4gKmt2bSkNCj4gPiArc3RhdGljIGludCB2ZmlvX2RldmljZV9maXJzdF9v
cGVuKHN0cnVjdCB2ZmlvX2RldmljZV9maWxlICpkZikNCj4gPiAgew0KPiA+ICsJc3RydWN0IHZm
aW9fZGV2aWNlICpkZXZpY2UgPSBkZi0+ZGV2aWNlOw0KPiA+ICsJc3RydWN0IGlvbW11ZmRfY3R4
ICppb21tdWZkID0gZGYtPmlvbW11ZmQ7DQo+ID4gKwlzdHJ1Y3Qga3ZtICprdm0gPSBkZi0+a3Zt
Ow0KPiA+ICAJaW50IHJldDsNCj4gPg0KPiA+ICAJbG9ja2RlcF9hc3NlcnRfaGVsZCgmZGV2aWNl
LT5kZXZfc2V0LT5sb2NrKTsNCj4gPiBAQCAtMzk0LDkgKzM5NiwxMSBAQCBzdGF0aWMgaW50IHZm
aW9fZGV2aWNlX2ZpcnN0X29wZW4oc3RydWN0DQo+IHZmaW9fZGV2aWNlICpkZXZpY2UsDQo+ID4g
IAlyZXR1cm4gcmV0Ow0KPiA+ICB9DQo+ID4NCj4gPiAtc3RhdGljIHZvaWQgdmZpb19kZXZpY2Vf
bGFzdF9jbG9zZShzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSwNCj4gPiAtCQkJCSAgIHN0cnVj
dCBpb21tdWZkX2N0eCAqaW9tbXVmZCkNCj4gPiArc3RhdGljIHZvaWQgdmZpb19kZXZpY2VfbGFz
dF9jbG9zZShzdHJ1Y3QgdmZpb19kZXZpY2VfZmlsZSAqZGYpDQo+ID4gIHsNCj4gPiArCXN0cnVj
dCB2ZmlvX2RldmljZSAqZGV2aWNlID0gZGYtPmRldmljZTsNCj4gPiArCXN0cnVjdCBpb21tdWZk
X2N0eCAqaW9tbXVmZCA9IGRmLT5pb21tdWZkOw0KPiA+ICsNCj4gPiAgCWxvY2tkZXBfYXNzZXJ0
X2hlbGQoJmRldmljZS0+ZGV2X3NldC0+bG9jayk7DQo+ID4NCj4gPiAgCWlmIChkZXZpY2UtPm9w
cy0+Y2xvc2VfZGV2aWNlKQ0KPiA+IEBAIC00MDksMzAgKzQxMywzNCBAQCBzdGF0aWMgdm9pZCB2
ZmlvX2RldmljZV9sYXN0X2Nsb3NlKHN0cnVjdA0KPiB2ZmlvX2RldmljZSAqZGV2aWNlLA0KPiA+
ICAJbW9kdWxlX3B1dChkZXZpY2UtPmRldi0+ZHJpdmVyLT5vd25lcik7DQo+ID4gIH0NCj4gPg0K
PiA+IC1pbnQgdmZpb19kZXZpY2Vfb3BlbihzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSwNCj4g
PiAtCQkgICAgIHN0cnVjdCBpb21tdWZkX2N0eCAqaW9tbXVmZCwgc3RydWN0IGt2bSAqa3ZtKQ0K
PiA+ICtpbnQgdmZpb19kZXZpY2Vfb3BlbihzdHJ1Y3QgdmZpb19kZXZpY2VfZmlsZSAqZGYpDQo+
ID4gIHsNCj4gPiAtCWludCByZXQgPSAwOw0KPiA+ICsJc3RydWN0IHZmaW9fZGV2aWNlICpkZXZp
Y2UgPSBkZi0+ZGV2aWNlOw0KPiA+ICsNCj4gPiArCWxvY2tkZXBfYXNzZXJ0X2hlbGQoJmRldmlj
ZS0+ZGV2X3NldC0+bG9jayk7DQo+ID4NCj4gPiAtCW11dGV4X2xvY2soJmRldmljZS0+ZGV2X3Nl
dC0+bG9jayk7DQo+ID4gIAlkZXZpY2UtPm9wZW5fY291bnQrKzsNCj4gPiAgCWlmIChkZXZpY2Ut
Pm9wZW5fY291bnQgPT0gMSkgew0KPiA+IC0JCXJldCA9IHZmaW9fZGV2aWNlX2ZpcnN0X29wZW4o
ZGV2aWNlLCBpb21tdWZkLCBrdm0pOw0KPiA+IC0JCWlmIChyZXQpDQo+ID4gKwkJaW50IHJldDsN
Cj4gPiArDQo+ID4gKwkJcmV0ID0gdmZpb19kZXZpY2VfZmlyc3Rfb3BlbihkZik7DQo+ID4gKwkJ
aWYgKHJldCkgew0KPiA+ICAJCQlkZXZpY2UtPm9wZW5fY291bnQtLTsNCj4gPiArCQkJcmV0dXJu
IHJldDsNCj4gbml0OiB0aGUgb3JpZ2luYWwgcmV0IGluaXQgYW5kIHJldHVybiB3YXMgZ29vZCBl
bm91Z2gsIG5vIG5lZWQgdG8gY2hhbmdlIGl0Pw0KDQpUaGlzIGlzIGEgY2hhbmdlIG5lZWRlZCBp
biBhIGxhdGVyIGNvbW1pdCB0byBiZSBzdWNjZXNzLW9yaWVudGVkLg0KDQpodHRwczovL2xvcmUu
a2VybmVsLm9yZy9rdm0vMjAyMzAxMTcxMzQ5NDIuMTAxMTEyLTExLXlpLmwubGl1QGludGVsLmNv
bS8NCg0KYnV0IEkgZ3Vlc3MgaXQgaXMgbm90IG5lZWRlZCBoZXJlLiBTbyB5b3UgYXJlIHJpZ2h0
LiBNYXkganVzdCBrZWVwIHRoZQ0KZXhpc3RpbmcgcmV0IGluaXQgYW5kIHJldHVybi4NCg0KPiA+
ICsJCX0NCj4gPiAgCX0NCj4gPiAtCW11dGV4X3VubG9jaygmZGV2aWNlLT5kZXZfc2V0LT5sb2Nr
KTsNCj4gPg0KPiA+IC0JcmV0dXJuIHJldDsNCj4gPiArCXJldHVybiAwOw0KPiA+ICB9DQo+ID4N
Cj4gPiAtdm9pZCB2ZmlvX2RldmljZV9jbG9zZShzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSwN
Cj4gPiAtCQkgICAgICAgc3RydWN0IGlvbW11ZmRfY3R4ICppb21tdWZkKQ0KPiA+ICt2b2lkIHZm
aW9fZGV2aWNlX2Nsb3NlKHN0cnVjdCB2ZmlvX2RldmljZV9maWxlICpkZikNCj4gPiAgew0KPiA+
ICsJc3RydWN0IHZmaW9fZGV2aWNlICpkZXZpY2UgPSBkZi0+ZGV2aWNlOw0KPiA+ICsNCj4gPiAg
CW11dGV4X2xvY2soJmRldmljZS0+ZGV2X3NldC0+bG9jayk7DQo+ID4gIAl2ZmlvX2Fzc2VydF9k
ZXZpY2Vfb3BlbihkZXZpY2UpOw0KPiA+ICAJaWYgKGRldmljZS0+b3Blbl9jb3VudCA9PSAxKQ0K
PiA+IC0JCXZmaW9fZGV2aWNlX2xhc3RfY2xvc2UoZGV2aWNlLCBpb21tdWZkKTsNCj4gPiArCQl2
ZmlvX2RldmljZV9sYXN0X2Nsb3NlKGRmKTsNCj4gPiAgCWRldmljZS0+b3Blbl9jb3VudC0tOw0K
PiA+ICAJbXV0ZXhfdW5sb2NrKCZkZXZpY2UtPmRldl9zZXQtPmxvY2spOw0KPiA+ICB9DQo+ID4g
QEAgLTQ3OCw3ICs0ODYsNyBAQCBzdGF0aWMgaW50IHZmaW9fZGV2aWNlX2ZvcHNfcmVsZWFzZShz
dHJ1Y3QgaW5vZGUNCj4gKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZXApDQo+ID4gIAlzdHJ1Y3Qg
dmZpb19kZXZpY2VfZmlsZSAqZGYgPSBmaWxlcC0+cHJpdmF0ZV9kYXRhOw0KPiA+ICAJc3RydWN0
IHZmaW9fZGV2aWNlICpkZXZpY2UgPSBkZi0+ZGV2aWNlOw0KPiA+DQo+ID4gLQl2ZmlvX2Rldmlj
ZV9ncm91cF9jbG9zZShkZXZpY2UpOw0KPiA+ICsJdmZpb19kZXZpY2VfZ3JvdXBfY2xvc2UoZGYp
Ow0KPiA+DQo+ID4gIAl2ZmlvX2RldmljZV9wdXRfcmVnaXN0cmF0aW9uKGRldmljZSk7DQo+ID4N
Cg0KUmVnYXJkcywNCllpIExpdQ0K
