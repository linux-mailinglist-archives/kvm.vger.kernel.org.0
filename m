Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CD37277F8
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 09:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbjFHHAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 03:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbjFHHAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 03:00:03 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA62271F;
        Wed,  7 Jun 2023 23:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686207588; x=1717743588;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=umh8zIHxjigwzZRqCHiV0xvyeVCKF6kSBNY8wfZu+c8=;
  b=YF1h6sLJGyJu+NUUdF4oEMffOq93mkCimnRCqw/gSsFWRdoUlOefsRCV
   6T71caFd8M72q5N9vSxr3+MeDeqZMYGcGtbqhJ5lq+H3SFHIUdWj72OYG
   MNDNlhbAeirAyVnIOS/SVeB2W3eAbCysx8beWKAhQZvXk8XM9GtbVEZDU
   lhTZvq96kMe+bu+vri7chK+yK6/PIaHT6pLZxrts3xPMvP/jRrO+F5Rqt
   DHKCfeKzRB8HsDt9gkV0i4l34t4hAL21lJJonBW8tlrVLGQ0A8e8hZhx8
   G0DusiXgVV2I3TN2v/etSOLyh7gKwmDpHlZoFMknoBMBaCjaXwdQ43psk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="360562959"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="360562959"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 23:59:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="799707880"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="799707880"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Jun 2023 23:59:47 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 23:59:47 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 23:59:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 23:59:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtaosn82k2ppdWfs7LW5+CdZEn1PuI0FCDwgKvZKx7y6BIYwKGgFp340GDeGfVMWUC0LQVJPkXyQnfZ4BbQjvVAn76JpWN4O6Ia/IYzz8D8h6dzI3mrblHABjvpbDC/hQBnsz31Vvvfuf+qPbxBk6Tbo7YffMBWTicAbnCcZL0w7w+3y85anVGxgyQOAKShlmCtuuvMLOm67PwJ+7atcNvdfwVrQq0pANlIG70I3y/SiMEdA6Ge+bDV+4bxF0JMQYkCROqCoOXqkwQ7LKJg9kZGVwF7yvSI+MwaOqPazQFV8WZMLIL4KIdaoA00hmYr98xK4tOceFu5bkQTTjObp1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=umh8zIHxjigwzZRqCHiV0xvyeVCKF6kSBNY8wfZu+c8=;
 b=gin7Scs9cqP68DL1H1egy6J2vQmAleTRBlH3MTfNYwbSE37NXR8qI+jWorJ0ckWGbqRDI86fEbOKCzOsobQnqfZ6c9yTbZy/K6lchtSZU/EYAEmYSW8qn50YxQcth4UMw5aB8bc1i4MxRrs9w2+/enYaAAVv4anV4IOBjRs8HndCUYB0/sk5FMvkXpG1jjNXiVkeiTnnVbfkco2WWCBIb26ShE1JgPCJwgHsQUXv4w+CMrzoPo0zU53m3Vr1xdPTEnKtRaQWj4/crp1nMDWvWjbOU9DzuHXgd67T4spe/DSV+8vvZmLJ2pZs5vXcw5QLzqmajNKtLXfEMP+w22ywzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7)
 by DS0PR11MB7410.namprd11.prod.outlook.com (2603:10b6:8:151::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 06:59:45 +0000
Received: from MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::ea27:a8a0:3e6:db89]) by MW4PR11MB6763.namprd11.prod.outlook.com
 ([fe80::ea27:a8a0:3e6:db89%7]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 06:59:45 +0000
From:   "Jiang, Yanting" <yanting.jiang@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v7 0/9] Enhance vfio PCI hot reset for vfio cdev device
Thread-Topic: [PATCH v7 0/9] Enhance vfio PCI hot reset for vfio cdev device
Thread-Index: AQHZlUvvgnOP/4gAtUGo9Vf7DIoaiK+AgtYg
Date:   Thu, 8 Jun 2023 06:59:45 +0000
Message-ID: <MW4PR11MB67631CC560F073B10C2C8EDCE850A@MW4PR11MB6763.namprd11.prod.outlook.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
In-Reply-To: <20230602121515.79374-1-yi.l.liu@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6763:EE_|DS0PR11MB7410:EE_
x-ms-office365-filtering-correlation-id: e1990b91-dea9-4326-5150-08db67edf10f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vGvk8swf2ektv12fdimIggqWp65KiMn/o1WDd7FugnKccXwLNjDluWOJCPGN24b2mSMoWk7VNKq41z+LsOlyod2bgI89uJJeyr8gNYI9i8pozWsUcM/O4eiHMkkYIYE42qdw1HruC2yIzg10i8ko9t2mlRyZQ1HbiuIRZLnpmje2w4T36zNx0LYtah8lTOISwjT7DOuI42ASFF+qrg8wk5IC1YX/VztzJ6d2DanF4ty8CU4m576vz8oJvlEIdfN/9UcoRaW0ewvzV2YKO8ij60wPJW8Kc8FkW/hMvBbBcHtn/LmDP+m6mclrKegiJkwBTCk5yLY9FwVtsDVXeoccunzHkLlhGVM3EY7jcJils/UZg7NeEsznxqOHnY5wSmfDNDRRcYiHJcFNSsNJn7dopwvkvbHNzWlcul57GUl9SQeV+r2Re/rsJMaTK5xlLyw19BytNRYGt7/RrBWq79qQgzUsYtEiKLRlK7t00we1io+BM9vAnnKzVEgM3OUrKefiw+s9kLgeo15/H2gJkaNz1L4dzzPBVof4yv7SlsXvmI2D9g+MMEG4BFuFE7ZX4w8xy5qbgELL7tgpWryKE8SgsHn3sFNczAX5NrytzUy9m5Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6763.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(136003)(376002)(346002)(451199021)(76116006)(26005)(9686003)(66446008)(6506007)(316002)(83380400001)(6636002)(64756008)(66556008)(4326008)(122000001)(66476007)(66946007)(966005)(7696005)(186003)(478600001)(33656002)(71200400001)(110136005)(54906003)(38070700005)(4744005)(2906002)(5660300002)(8676002)(8936002)(82960400001)(55016003)(52536014)(86362001)(7416002)(41300700001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3VaSE5keERDYVlVNnZxWEdHaFdZcml5aDBWViszeVdZV1pCMWZVY2dicENE?=
 =?utf-8?B?YjFCWlVpUE02aldzSGZaM08xTjJCVXNhRnFLcFRrL2wvN2RtVVAwNWVoSDFM?=
 =?utf-8?B?RDRNekkzV1VsQndpUmVieWdIczdzVXFnTktJc08vZ1lvQ2ZPTzdaKzNvWTds?=
 =?utf-8?B?Yjh6aW1lS2RKZFF6bXVIclM4VmtmM2U4cldvWUVQRnllY2M3UG81ZEUyRkFa?=
 =?utf-8?B?WWJpb2NWZnY1RVJNRlJZNTBEWUk3Z3ZKR3Y4ZCtkNjFmNVdwenZIT2cySXBK?=
 =?utf-8?B?dENKNis2MkpGb3hLd0FPRmtmMVg0MlRYa3dWV2F5R2t2NjhQWW9mbUxNWVlU?=
 =?utf-8?B?c0FDOFNkaURnbHl5ckR6aTUvNDVoWXRhZzVmbmErcmtuUFFIVm5zTE1lQzJM?=
 =?utf-8?B?QUFVUnc0YzlZVk1SdnNTSTlaSjBMNmovUUpqeE0xWWxrc3ZqV1RDRHc5cUhQ?=
 =?utf-8?B?MVZrK0hpbFJRQVVXUFdjQjNXbjBFdFBtSGJBKzZFSWJsdW9rMzQ4bnhLai91?=
 =?utf-8?B?ck9GNWFGalZBRS8reVVHR0M5RTMrMHFyN2pmMFd1SWV1R1pJS1QweFFnWlFO?=
 =?utf-8?B?Nnl0cmVmOXNKbHRGQjRoTUEyTnBGWmxrRVFBN0hpT3dRcmtsbzk5b2MycHpt?=
 =?utf-8?B?ODJPbzc1VXpWQ256Tjk5SUJlb3dpZFl3Z09rRjJmdy9mZW9tZjhvMHNjZHJ3?=
 =?utf-8?B?NmVLNUdTeG1lTllEcWM1ZkVyRU1LR1FsaE9OMG1kOFdxUGRMaENvbG8yeTQy?=
 =?utf-8?B?MlhvckppTzBQQThUZWk2YkNoZFR3elVIQnVoZk5QT0t5cWo0alRqcDMvVWZz?=
 =?utf-8?B?djZRdzBUS0Vxa04zeXFBMktLZVlDZTJBSHdyNUsxanVWdTV1L1lZeDFaNkQ2?=
 =?utf-8?B?N0dnaWdBbkpMUDFNWGhGMUZLU3lmR1Q2SUZpVm5RUE1FOC9GZEwvVWNZeHJV?=
 =?utf-8?B?aWQ1UGVlRFBUb0hScGlxRFZPdEZuWkxOcFlnSW91Sk9iNlZWTm5WbDA4ZTJ5?=
 =?utf-8?B?eW5hVU1ORTg4YmlqdXRvQU41b1phbEZzcTFaRnNNTVVhZDRFdWpQN0prQTFy?=
 =?utf-8?B?WGZ5OTllRXZOemdwUVZLdGFwTEpLUVl6a3RwZXlCNkFDMlM1Z0NGS0V0dWtP?=
 =?utf-8?B?a2MrSDlxQ2MzSG9yblc0NE1hbncvWjBVbGlaQm5sNHlIb08xbGI1cHdlOEJa?=
 =?utf-8?B?VUJnMjh3MGVlVEQ5cEs3dEl1YzJUWG02ZEtvTzhnck55ZGdxVSt6dVBFem5n?=
 =?utf-8?B?REw0QWpkNU1adG50eDBXdmcxV0s1cXNxMWtCYVFQejAyZFBPYVRXWFNVaHFz?=
 =?utf-8?B?N0JHNEhsWFloUEluYnNYV0FReFRvVW45R0dvUmliYnFnRVRVcHhHR3Y3MTl6?=
 =?utf-8?B?RVduM0ZFd29ZeWhqUHVSejdNYkhTQTRiaUtuNlJVM1FMN0JIQVlVekNUQWNy?=
 =?utf-8?B?S0JmV3dVa2w0SVRkQkR3OHF0UWk0WmhBOVFnd2JxN1lOS2h1RGg3MjRtL241?=
 =?utf-8?B?ZzFNams5N29CUEtpcTZ4ZW05bXhvSlczZ3A3SjNiTklkcGNFUzVyTWVoc09W?=
 =?utf-8?B?MXJNQ3lNVXhhSDIzYXdOdkpoaE11b3N5T0U1aDd6TmtoUFovT2g2LzFUTnht?=
 =?utf-8?B?Zk9pYnlwS3h0ZTZGUmxGbm1Dd003R0pSR0o1cjRTSmpXeFA0aXFuZzdVRk5q?=
 =?utf-8?B?V05PZkhPOS91Y2tXMENBNmpLeXY2U0c3blROSlNzdUtoaXJNRVlFMHluNVJs?=
 =?utf-8?B?bVh4ZjRTMGp5WTcrd3hPT0VzanAzZmlIc3Z0SUhuS1FWQWZyanNvTUh1a2Q3?=
 =?utf-8?B?L1ZNRDBDUDQzTERFM2xwU0hYQWhRRWVsdzhqRjRBT3E4Z0w1SENuSE9UT1ND?=
 =?utf-8?B?ZjZBa0hNODkyeG5KOFZDY0p6S1UwaUJoNCtGd2dmanVXejAyMjg1U1pDeVhN?=
 =?utf-8?B?bXZ5ZlJKVmk5UlU1UktsM1BXU3JJVEVwWktSMGNUYlg1UnRKd2VtZFBwa2cw?=
 =?utf-8?B?UWpEZ0xNRzhYUlRiald4aTVtdXhXcFhvd2VHTjN1NWJpUVJka1ZlcWpSZmNw?=
 =?utf-8?B?UTYva21DRjVIUkpodzU5ejUvWWt6L2daWEJDUUNkNDFlSG9GaUNlOGFmTEta?=
 =?utf-8?Q?S9GSRcBSKkp+l7PkB/U4Gv9Uo?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6763.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1990b91-dea9-4326-5150-08db67edf10f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 06:59:45.2115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Lc5VHuH+8nuKVOpkNugEVEX4wgAYS2aParoxGdsZfcc8x+d0ljw1VdQP9lLruJ1uG2It1ODfKdKKpahY1xIEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7410
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBTdWJqZWN0OiBbUEFUQ0ggdjcgMC85XSBFbmhhbmNlIHZmaW8gUENJIGhvdCByZXNldCBmb3Ig
dmZpbyBjZGV2IGRldmljZQ0KPiANCj4gVkZJT19ERVZJQ0VfUENJX0hPVF9SRVNFVCByZXF1aXJl
cyB1c2VyIHRvIHBhc3MgYW4gYXJyYXkgb2YgZ3JvdXAgZmRzIHRvDQo+IHByb3ZlIHRoYXQgaXQg
b3ducyBhbGwgZGV2aWNlcyBhZmZlY3RlZCBieSByZXNldHRpbmcgdGhlIGNhbGxpbmcgZGV2aWNl
LiBXaGlsZSBmb3INCj4gY2RldiBkZXZpY2VzLCB1c2VyIGNhbiB1c2UgYW4gaW9tbXVmZC1iYXNl
ZCBvd25lcnNoaXAgY2hlY2tpbmcgbW9kZWwgYW5kDQo+IGludm9rZSBWRklPX0RFVklDRV9QQ0lf
SE9UX1JFU0VUIHdpdGggYSB6ZXJvLWxlbmd0aCBmZCBhcnJheS4NCj4gDQo+IFRoaXMgc2VyaWVz
IGV4dGVuZHMgVkZJT19ERVZJQ0VfR0VUX1BDSV9IT1RfUkVTRVRfSU5GTyB0byBjaGVjaw0KPiBv
d25lcnNoaXAgYW5kIHJldHVybiB0aGUgY2hlY2sgcmVzdWx0IGFuZCB0aGUgZGV2aWQgb2YgYWZm
ZWN0ZWQgZGV2aWNlcyB0byB1c2VyLg0KPiBJbiB0aGUgZW5kLCBleHRlbmRzIHRoZSBWRklPX0RF
VklDRV9QQ0lfSE9UX1JFU0VUIHRvIGFjY2VwdCB6ZXJvLWxlbmd0aCBmZA0KPiBhcnJheSBmb3Ig
aG90LXJlc2V0IHdpdGggY2RldiBkZXZpY2VzLg0KPiANCj4gVGhlIG5ldyBob3QgcmVzZXQgbWV0
aG9kIGFuZCB1cGRhdGVkIF9JTkZPIGlvY3RsIGFyZSB0ZXN0ZWQgd2l0aCB0aGUgYmVsb3cNCj4g
cWVtdToNCj4gDQo+IGh0dHBzOi8vZ2l0aHViLmNvbS95aWxpdTE3NjUvcWVtdS90cmVlL2lvbW11
ZmRfcmZjdjQubWlnLnJlc2V0LnY0X3ZhcjMNCj4gKHJlcXVpcmVzIHRvIHRlc3Qgd2l0aCB0aGUg
Y2RldiBrZXJuZWwpDQo+IA0KDQpUZXN0ZWQgTklDIHBhc3N0aHJvdWdoIG9uIEludGVsIHBsYXRm
b3JtLg0KUmVzdWx0IGxvb2tzIGdvb2QgaGVuY2UsDQpUZXN0ZWQtYnk6IFlhbnRpbmcgSmlhbmcg
PHlhbnRpbmcuamlhbmdAaW50ZWwuY29tPg0KDQpUaGFua3MsDQpZYW50aW5nDQoNCg==
