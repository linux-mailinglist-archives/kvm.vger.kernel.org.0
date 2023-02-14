Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951B6695631
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 02:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjBNBzX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 20:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBNBzV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 20:55:21 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BFD1A96F;
        Mon, 13 Feb 2023 17:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676339720; x=1707875720;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LTvY/NMhaDUpjE32CnhKjRNuELaKx8zFCc4JBzb7Otw=;
  b=F17DpOLOhzc9ifTCvytc9Av1hYRpGKd4oLWBwzYgfPXa5dAUJAy2yDFF
   lZL4lu8fD2ZHP6nLXtqik5eyAMh3cILj6/Q7QUifvy2Q/Xr7UBKkhGMTF
   7+2mk2xnenKAmhTH/U8BVMVCPPwecrgQa7M1V6R0gzDmjQ8/DIXfOc2iY
   9SfU0uzZ4bbQnveQpXS/eRlO6quYcMMMkDWZQn516SjeHyAnekhNdHq9n
   HUqh7V/6BYTXBFhBQ1PsMVMcZ+4gBUhVqbiQN10BJTJallFXSxrUP5jmB
   YByvMzX5QPkuoYEgAUnTZp/EU4wuQPRWL7pKhlO7apIJTdcexudWVgBYf
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="311412830"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="311412830"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 17:55:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="811824559"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="811824559"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 13 Feb 2023 17:55:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 17:55:19 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 17:55:19 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 13 Feb 2023 17:55:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S++WeNYgrrsDxd/JdJBjnu7ECCINdYqbuxUgw+7hiPhYZfdswUUwBHDvYWVVGhOSZRigP0mnUedIYRTidH+7oBDY7cMtzHsbSMtd19lGSoVK0UXrUlOiaYB63d7mVQ2mCb6GMbWerDZWZXyIlnfGOEoeqzi8e/pbUCgb/i9hrlvcIOBH0Z7Z+ilNZlCxxP51e5XGGfO/bEPGPzaHQRmUQUMpVFpgOMZM8aP1VVEmua2UooX16kTbp+11FvUTxCPj2XoXWXgOGrla6Xv1n1pkYkqVDRmuyXKs5oW4WEt6vmRAf1sNpshIV97x3a6LWZW5116suLxshF/UcSw72BK7+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LTvY/NMhaDUpjE32CnhKjRNuELaKx8zFCc4JBzb7Otw=;
 b=RSRB/T3DQ4ne1mJ4wHtSQ//0IP1la0vNjWOjtyDAHGZRDoPi2smrDW2+GoHDayFAlI1wiCXe3cEQWEWumCoanBjA14Q+oiDeYwaWMU4VmY4u4T9wQLn2H0guAQ3bxppzO1Ghzh/9A/K8oNl27nEHWtkGYWNDyOwXhyFAGh53L3QX6c64lkl/UJyL6Chh42wj273r8qDFybR1G0ZUSphCNROGaoppJKDlQd0UMQnZ5dsQhLnJXAoe9VQjniSTjp89qzXPguRYjChZn7+qXVd19ItRvd3b7bHlalDhWVohZqONiXyVbNsNvH2N34vIVNXvEIG2UpaSfuZ7UXWpO9LrhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SN7PR11MB7065.namprd11.prod.outlook.com (2603:10b6:806:298::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Tue, 14 Feb
 2023 01:55:17 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 01:55:17 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH v3 00/15] Add vfio_device cdev for iommufd support
Thread-Topic: [PATCH v3 00/15] Add vfio_device cdev for iommufd support
Thread-Index: AQHZP73MTR3br74MlEe91B7qYhP/Qq7NSHqAgABiBDA=
Date:   Tue, 14 Feb 2023 01:55:17 +0000
Message-ID: <DS0PR11MB75298788BCA03FD9513F991AC3A29@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213124719.126eb828.alex.williamson@redhat.com>
In-Reply-To: <20230213124719.126eb828.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SN7PR11MB7065:EE_
x-ms-office365-filtering-correlation-id: 2a6af0eb-a200-4edb-776b-08db0e2e8569
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K9NC/scfNZ56qavUMZCwz2kofZah7AP24QDwcImVzpHZIWnLBUmS7Ip4srKjTQLWb9lWZKtZwsRjLJrZjbjsDkdI+hbloP0q+ElAW7Bj6ybtde2U2vPeByBfLxrfkDn7zxbA79rpYMy78j8aeP/pbxgWhQCxzLRxVtvTNzVb37+fV5+Y/VFpiTPM4Jqt8aqeQRpJq0UWLqOOgqcAJHdKxaDeCXxfOOUzupGldRehoYJG7JowHSERzgstj21UdtctRqusbWasaPXL9aL5zQ7hiOzQuTo09ijKPY91NzQAHyH2+rnUyH+MTfFJBmCxrI9NSEap2SqhDsk4i6szRJURhLmO/9fOxzR1i+9TOQ7iX6z4T5No1mg7TCmz3PXQ6vnQv/eZBV6YuXyw/Te1WuJRnIWg6bQi6tGY9j4QLywE9/ij1/JKazTVscudSHkWx+T9LYrbWwOXllq6NPuKgxSU0u/16FQIZaMrmkFqM0o72oPHzlUguLkR6IG/2is8Tyj7LHnykQWVXQEA4wTe/1Uhyhvfv4Ixf2THBshHEX7HGTwxwCgmcvXksVaMoDazOLbDkQZVHVP81tEVssxqnEQrtCCq3AmKU8PBNjChF+1syJwmwaLF2D/gQh1GoLW3Z6FmNMefGtQVyEFDWopGrFyYT27BIYEWwHZzsiDKVVDse6gVXDcils7TTQguHG7RE5XE+fQ/M9LcK/kAipt6elKtXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199018)(82960400001)(38100700002)(5660300002)(71200400001)(41300700001)(55016003)(38070700005)(122000001)(86362001)(33656002)(83380400001)(2906002)(186003)(7416002)(8936002)(9686003)(52536014)(26005)(6506007)(54906003)(316002)(66446008)(478600001)(66476007)(66556008)(8676002)(966005)(4326008)(7696005)(76116006)(64756008)(6916009)(66946007)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXdxUUtRdFRZWDdTd2hTb1dvcDVLenMrWXJhMW1hSWk3aytDb0VTTUl2OW40?=
 =?utf-8?B?cUZYOTVsL3dNRi9tSmlNZVl3bnY1SCt5eWR5ekZIUWNGY0F0SmVZSGVPQkk1?=
 =?utf-8?B?NW90S0pEQW5WS0pYYzNhOWpSb3liQW10NzFiM09YcG1GWVZOSTFFUUNacmpU?=
 =?utf-8?B?emZXN3hKU2VSSWFiYUVmb0lVK005L3JSTk0zV0pmRVBJYnAzdHZsQ3Z3UWJ5?=
 =?utf-8?B?cnlqbGNqWDRIU0ZLaFdJdU5Ib2lLZjBsVEU5QlVEajNVcWtteXZsTmNHajJK?=
 =?utf-8?B?TTBNTXVZa29FVndmeUxUcDhvQitVbGxZY3YrR0VYVnB2NFVidnhqSmppUGZq?=
 =?utf-8?B?dWc4ZDdlaEVSYmZQQkxsTzBmcXR6UzhEeEYvN01CZnhHNm1wL3BLM1BFejZO?=
 =?utf-8?B?Vld5YnpTMEVWUVVDbG8vbFQ0R1o3dE9ydFJYYkVJRWNCeXVsMVJneEM2RGE1?=
 =?utf-8?B?TWJqVy9MdE9HS1dBZkNxc0Z1dUQxWkRYT21XSTFWZHM1RVE1dHFaeWhDM2NC?=
 =?utf-8?B?ZmFtWnJaYjFVQUFXbmFVMkJkeWR1RS96RzBnb3RzcFN4OW1DSng2aUw5T0VJ?=
 =?utf-8?B?VzNSOS92WXJ4aWlwNUxVWThacWZjZ2lDeGxMaTlLVXhUZjRDdHpPTUZiREt3?=
 =?utf-8?B?cHgxS1VBYnFxdGhwSG9QbXU0SDNOZHM4VjN3eDkrbXZrRnRBSnh0WnVrNHZo?=
 =?utf-8?B?SlBNUk5kK2lReTc0a214cHI1WXBiamtudE8zdmJPQTQ2Q3R2N2V3M25hbGFC?=
 =?utf-8?B?aHh2ZFIvczhBWFFlblNYcUdzZ3hXeXF2WVNWMWFCdWVrNE1lTVU3YzlxVWFB?=
 =?utf-8?B?Ny9sdXFweVhYMjdGM3RrNk0vc2h4MXVaU3FYTDQwbnlFK0ZZaVd3NWVTNzJl?=
 =?utf-8?B?UytFUytORkpNb1ZZNjd6QmlnM1RUbnl4VzlNOXFCdWxUNzcxak9UWDV3cDR2?=
 =?utf-8?B?eVBiWTkvR2lhQ3RvbWJtRlM5dHd1aVE3NllnSVAxL1RYNEduTVVUWngvdWdL?=
 =?utf-8?B?VVI5S2hxUlkrc3I0bXcrL1Y5REpTWmMzSm5Pd2ZFNWpNTXFKOVZnUE9xbnNl?=
 =?utf-8?B?ZmJha3lYdk1LZk1OK2VacHF0V1RJcExjcmR5ZGVpcVB5d3BVVk1tdWNXVGVT?=
 =?utf-8?B?dGg1bVRsZmU5YURWdWZpc0xteklRc21MUzJaMElvUDFFcWJMVW1hSXM0R1FS?=
 =?utf-8?B?b0ROTjJGdmJCSHBsbXRaKzlhaVhrWEZ5dlFBQjA4WnhGV1FxUllocmlWU2Fz?=
 =?utf-8?B?MDZEMTlmdmZ5bzhoS0R0MDF0cUJmK1NWSmtVa05xajk4akEyWHVuWjNITlM3?=
 =?utf-8?B?SUQ0OGhvRjQzeFpjUzMwWmdWdTM3MGowSFQwRmJlM1AzY1RaUC9qdjBMMVln?=
 =?utf-8?B?b2V0NUhWT1FZODFGUndLeHkzeHFQcjBSdnNLZko3eUtXMGpMeWtrT0YzK0NC?=
 =?utf-8?B?Ymd2RFQ4dHorNlFFblpKK01WZld6VnRWWkQ1WnErdEFHb0ZUbXRnVTVnVUJw?=
 =?utf-8?B?N2p4dmJTV0NSM05KZS9OejJHVlFLMEd5TlV5b3ozaGw0R2o2MVF2WFJjbVda?=
 =?utf-8?B?eWJxSTF4Z2xXNGlweDc0eWs3bXFIS1JxNEJhck95OEFsQlFYR1FaZ2NhZFdr?=
 =?utf-8?B?d0h0NVhhSm9neFNBQjhicUhuNFBOZThDSTFqcVEzdURJQ2FzWnlJM0xFcmxk?=
 =?utf-8?B?YXZxc0JOSjFGVmdERUZRU28rMGJwK0JqSjhCK0grMFlqN3gxem54RG9yL1Y5?=
 =?utf-8?B?ZHBKUzQxV0RrZVNhNS9weDhnMGVta3Q4QzNjVXd2dEZVUWh6K1NOYTZCZVUw?=
 =?utf-8?B?R2orN1FKclNBLzJ5V2JLYjQ4Q3EzY3VaVUVkZ2V3OVpKeU56bkJGSTZ6WXUz?=
 =?utf-8?B?MFRKZDlGL2xNci9HM0dVbkRtR1d1bjcvR0dVQVFTS0VGSHE1TklMdU4zWTVs?=
 =?utf-8?B?V25ENlVOcXJ4djN5SEd1dlpLcFlSbGxDU2paVGFreVEzZ3ZZaGNrbmZPano4?=
 =?utf-8?B?UnhBVGJqV3Nlby8xNXlDaUx4RlBuanUveUo5OG1DbllPZUpXVTFCOGFnR0py?=
 =?utf-8?B?b016SkNCc1JzOUl1RlZSQkcrRU85ek4wYXZkZndCcGF4ZXdRUmJ0RDVGby9s?=
 =?utf-8?Q?ozUp5/bLT4bRqaCPqoASZjQYf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a6af0eb-a200-4edb-776b-08db0e2e8569
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 01:55:17.2154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j9s8gjinbEL0H6X3CD3ijg84vDd11H5oihMOeGDoiETFHwCCTIExGpCcn0w8s4J7xEj6qkG7pvck8+ar2epOtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7065
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBUdWVzZGF5LCBGZWJydWFyeSAxNCwgMjAyMyAzOjQ3IEFNDQo+IA0KPiBPbiBNb24sIDEz
IEZlYiAyMDIzIDA3OjEzOjMzIC0wODAwDQo+IFlpIExpdSA8eWkubC5saXVAaW50ZWwuY29tPiB3
cm90ZToNCj4gDQo+ID4gRXhpc3RpbmcgVkZJTyBwcm92aWRlcyBncm91cC1jZW50cmljIHVzZXIg
QVBJcyBmb3IgdXNlcnNwYWNlLiBVc2Vyc3BhY2UNCj4gPiBvcGVucyB0aGUgL2Rldi92ZmlvLyRn
cm91cF9pZCBmaXJzdCBiZWZvcmUgZ2V0dGluZyBkZXZpY2UgZmQgYW5kIGhlbmNlDQo+ID4gZ2V0
dGluZyBhY2Nlc3MgdG8gZGV2aWNlLiBUaGlzIGlzIG5vdCB0aGUgZGVzaXJlZCBtb2RlbCBmb3Ig
aW9tbXVmZC4gUGVyDQo+ID4gdGhlIGNvbmNsdXNpb24gb2YgY29tbXVuaXR5IGRpc2N1c3Npb25b
MV0sIGlvbW11ZmQgcHJvdmlkZXMgZGV2aWNlLQ0KPiBjZW50cmljDQo+ID4ga0FQSXMgYW5kIHJl
cXVpcmVzIGl0cyBjb25zdW1lciAobGlrZSBWRklPKSB0byBiZSBkZXZpY2UtY2VudHJpYyB1c2Vy
DQo+ID4gQVBJcy4gU3VjaCB1c2VyIEFQSXMgYXJlIHVzZWQgdG8gYXNzb2NpYXRlIGRldmljZSB3
aXRoIGlvbW11ZmQgYW5kIGFsc28NCj4gPiB0aGUgSS9PIGFkZHJlc3Mgc3BhY2VzIG1hbmFnZWQg
YnkgdGhlIGlvbW11ZmQuDQo+ID4NCj4gPiBUaGlzIHNlcmllcyBmaXJzdCBpbnRyb2R1Y2VzIGEg
cGVyIGRldmljZSBmaWxlIHN0cnVjdHVyZSB0byBiZSBwcmVwYXJlZA0KPiA+IGZvciBmdXJ0aGVy
IGVuaGFuY2VtZW50IGFuZCByZWZhY3RvcnMgdGhlIGt2bS12ZmlvIGNvZGUgdG8gYmUgcHJlcGFy
ZWQNCj4gPiBmb3IgYWNjZXB0aW5nIGRldmljZSBmaWxlIGZyb20gdXNlcnNwYWNlLiBUaGVuIHJl
ZmFjdG9ycyB0aGUgdmZpbyB0byBiZQ0KPiA+IGFibGUgdG8gaGFuZGxlIGlvbW11ZmQgYmluZGlu
Zy4gVGhpcyByZWZhY3RvciBpbmNsdWRlcyB0aGUgbWVjaGFuaXNtIG9mDQo+ID4gYmxvY2tpbmcg
ZGV2aWNlIGFjY2VzcyBiZWZvcmUgaW9tbXVmZCBiaW5kLCBtYWtpbmcgdmZpb19kZXZpY2Vfb3Bl
bigpDQo+IGJlDQo+ID4gZXhjbHVzaXZlIGJldHdlZW4gdGhlIGdyb3VwIHBhdGggYW5kIHRoZSBj
ZGV2IHBhdGguIEV2ZW50dWFsbHksIGFkZHMgdGhlDQo+ID4gY2RldiBzdXBwb3J0IGZvciB2Zmlv
IGRldmljZSwgYW5kIG1ha2VzIGdyb3VwIGluZnJhc3RydWN0dXJlIG9wdGlvbmFsIGFzDQo+ID4g
aXQgaXMgbm90IG5lZWRlZCB3aGVuIHZmaW8gZGV2aWNlIGNkZXYgaXMgY29tcGlsZWQuDQo+ID4N
Cj4gPiBUaGlzIGlzIGFsc28gYSBwcmVyZXF1aXNpdGUgZm9yIGlvbW11IG5lc3RpbmcgZm9yIHZm
aW8gZGV2aWNlWzJdLg0KPiA+DQo+ID4gVGhlIGNvbXBsZXRlIGNvZGUgY2FuIGJlIGZvdW5kIGlu
IGJlbG93IGJyYW5jaCwgc2ltcGxlIHRlc3QgZG9uZSB3aXRoDQo+IHRoZQ0KPiA+IGxlZ2FjeSBn
cm91cCBwYXRoIGFuZCB0aGUgY2RldiBwYXRoLiBEcmFmdCBRRU1VIGJyYW5jaCBjYW4gYmUgZm91
bmQNCj4gYXRbM10NCj4gPg0KPiA+IGh0dHBzOi8vZ2l0aHViLmNvbS95aWxpdTE3NjUvaW9tbXVm
ZC90cmVlL3ZmaW9fZGV2aWNlX2NkZXZfdjMNCj4gPiAoY29uZmlnIENPTkZJR19JT01NVUZEPXkg
Q09ORklHX1ZGSU9fREVWSUNFX0NERVY9eSkNCj4gDQo+IEV2ZW4gdXNpbmcgeW91ciBicmFuY2hb
MV0sIGl0IHNlZW1zIGxpa2UgdGhpcyBoYXMgbm90IGJlZW4gdGVzdGVkDQo+IGV4Y2VwdCB3aXRo
IGNkZXYgc3VwcG9ydCBlbmFibGVkOg0KPiANCj4gL2hvbWUvYWx3aWxsaWEvV29yay9saW51eC5n
aXQvZHJpdmVycy92ZmlvL3ZmaW9fbWFpbi5jOiBJbiBmdW5jdGlvbg0KPiDigJh2ZmlvX2Rldmlj
ZV9hZGTigJk6DQo+IC9ob21lL2Fsd2lsbGlhL1dvcmsvbGludXguZ2l0L2RyaXZlcnMvdmZpby92
ZmlvX21haW4uYzoyNTM6NDg6IGVycm9yOiDigJhzdHJ1Y3QNCj4gdmZpb19kZXZpY2XigJkgaGFz
IG5vIG1lbWJlciBuYW1lZCDigJhjZGV24oCZOyBkaWQgeW91IG1lYW4g4oCYZGV24oCZPw0KPiAg
IDI1MyB8ICAgICAgICAgICAgICAgICByZXQgPSBjZGV2X2RldmljZV9hZGQoJmRldmljZS0+Y2Rl
diwgJmRldmljZS0+ZGV2aWNlKTsNCj4gICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIF5+fn4NCj4gICAgICAgfCAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRldg0KPiAvaG9tZS9hbHdpbGxpYS9Xb3JrL2xp
bnV4LmdpdC9kcml2ZXJzL3ZmaW8vdmZpb19tYWluLmM6IEluIGZ1bmN0aW9uDQo+IOKAmHZmaW9f
ZGV2aWNlX2RlbOKAmToNCj4gL2hvbWUvYWx3aWxsaWEvV29yay9saW51eC5naXQvZHJpdmVycy92
ZmlvL3ZmaW9fbWFpbi5jOjI2Mjo0MjogZXJyb3I6IOKAmHN0cnVjdA0KPiB2ZmlvX2RldmljZeKA
mSBoYXMgbm8gbWVtYmVyIG5hbWVkIOKAmGNkZXbigJk7IGRpZCB5b3UgbWVhbiDigJhkZXbigJk/
DQo+ICAgMjYyIHwgICAgICAgICAgICAgICAgIGNkZXZfZGV2aWNlX2RlbCgmZGV2aWNlLT5jZGV2
LCAmZGV2aWNlLT5kZXZpY2UpOw0KPiAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgXn5+fg0KPiAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgZGV2DQoNClNvcnJ5IGZvciBpdC4gSXQgaXMgZHVlIHRvIHRoZSBjZGV2
IGRlZmluaXRpb24gaXMgdW5kZXINCiIjaWYgSVNfRU5BQkxFRChDT05GSUdfVkZJT19ERVZJQ0Vf
Q0RFVikiLiBXaGlsZSwgaW4gdGhlIGNvZGUgaXQNCnVzZXMgImlmIChJU19FTkFCTEVEKENPTkZJ
R19WRklPX0RFVklDRV9DREVWKSkiLiAgSSB0aGluayBmb3INCnJlYWRhYmlsaXR5LCBpdCB3b3Vs
ZCBiZSBiZXR0ZXIgdG8gYWx3YXlzIGRlZmluZSBjZGV2IGluIHZmaW9fZGV2aWNlLA0KYW5kIGtl
ZXAgdGhlIHVzaW5nIG9mIGNkZXYgaW4gY29kZS4gSG93IGFib3V0IHlvdXIgdGFzdGU/DQoNCj4g
QWRkaXRpb25hbGx5IHRoZSBWRklPX0VOQUJMRV9HUk9VUCBLY29uZmlnIG9wdGlvbiBkb2Vzbid0
IG1ha2UgbXVjaA0KPiBzZW5zZSB0byBtZSwgaXQgc2VlbXMgZW50aXJlbHkgcmVkdW5kYW50IHRv
IFZGSU9fR1JPVVAuDQoNClRoZSBpbnRlbnRpb24gaXMgdG8gbWFrZSB0aGUgZ3JvdXAgY29kZSBj
b21waWxpbmcgbWF0Y2ggZXhpc3RpbmcgY2FzZS4NCkN1cnJlbnRseSwgaWYgVkZJTyBpcyBjb25m
aWd1cmVkLCBncm91cCBjb2RlIGlzIGJ5IGRlZmF1bHQgY29tcGlsZWQuDQpTbyBWRklPX0VOQUJM
RV9HUk9VUCBhIGhpZGRlbiBvcHRpb24sIGFuZCBWRklPX0dST1VQIGFuIG9wdGlvbg0KZm9yIHVz
ZXIuICBVc2VyIG5lZWRzIHRvIGV4cGxpY2l0bHkgY29uZmlnIFZGSU9fR1JPVVAgaWYgVkZJT19E
RVZJQ0VfQ0RFVj09eS4NCklmIFZGSU9fREVWSUNFX0NERVY9PW4sIHRoZW4gbm8gbWF0dGVyIHVz
ZXIgY29uZmlnZWQgVkZJT19HUk9VUCBvciBub3QsDQp0aGUgZ3JvdXAgY29kZSBzaGFsbCBiZSBj
b21waWxlZC4NCg0KUmVnYXJkcywNCllpIExpdQ0KDQo=
