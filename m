Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9931A4D2CD7
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 11:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiCIKML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 05:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiCIKMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 05:12:09 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C345716A585;
        Wed,  9 Mar 2022 02:11:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646820670; x=1678356670;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xz5acrPhe8FMklpbWxdmRHR+ZudQ7QjLZeK88QMzv9o=;
  b=geshrB0z1aP9Ad3rBj3RfZFbwXslFq/VhnI/ykmKW+W0BiWSYbIICR2U
   anD8BncmJQy9YWla8t/hbGvtdOb8n2Eth3/Zkk2+oCkHjkSSuiRBbT52j
   WEGAmNbe9969gK4v2AY+MQ9cLSKoOAaif33oZkLHqu8GUI3wFCsAeOdVL
   YFbT0rDw4RiR9ylh0kUFWvS2WLt+in2y1zYd9aFb27VCpueUVXMe4P+ED
   dMvyJqwrMePMtHoLeI7UL5NdN/nj/tfviHtr05B2k3irkRIHqKFsANP1f
   UqKxJ1L8/fj/g+JUrr/MJbw9On9vYgk5aSqwfVqwdxEskZUcNAGN1i65K
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="254669551"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="254669551"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 02:11:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="537951977"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga007.jf.intel.com with ESMTP; 09 Mar 2022 02:11:09 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 02:11:09 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Mar 2022 02:11:08 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 9 Mar 2022 02:11:08 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 9 Mar 2022 02:11:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RvloLLyj4teHH+a8SG6isJVZA2nhyU8M/+GGo4zdr9ERgJfTXiR6OVJMu+YBWIWtW/W9ea3hPmIQp1PZFZHeBp896ZQL4WmTgjVrVQeeoVK1xiw/PKjjPtomF6ElLoSWe5JCB4j1NhT51nAnbmFMa/RKw/xfNmAk+9UEkfuvMo+SRbQf/USnXvJdnyMG+z/No6GIMLYCFvL3oI6lCNhE07U18Tk/hv0k+65Rtlfj07GgNPVHf2YE7mUglopQ3mSBz622EUheBWASOOvaPbwANM/FghKaHxmIc8brFJOxf4RtR6oiHmGRImkN8urmC+tLFXJpAAxr7rL1Sg9sFF+i2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xz5acrPhe8FMklpbWxdmRHR+ZudQ7QjLZeK88QMzv9o=;
 b=MMK5eM3FcldE9LWrC5iSWKOmzgBz50+XcFPvK1dd3XYtCtM+mwW1t4FxEaboVcb8G5HQKpeNDaY41dt+H6M2Qy8Efhf4R6Ve2P8DZH6X1BgrAsz7+l2U1eTsuVIxFOkncwauAooFIrLjUnNjLza4h8IG4Ot+oRmaPn1qBlyw+T3xc4fEqDCNKGqE7gVw5i0NOlGqUz+DaaRAFO9iGTR5kneckTP5SIiKsYuaM/s0X/B0Pwc6R22yR2KQjSPUN0oItU1giCJoUKeMkgwEXTTi3MG7vP0o7MaMgbQ/+E5URbRKUUafO2kXe/7+PvLKv980BNQWbkKeOSWzA3ISETqb6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BYAPR11MB2616.namprd11.prod.outlook.com (2603:10b6:a02:c6::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Wed, 9 Mar
 2022 10:11:06 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 10:11:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "Jason Gunthorpe" <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Xu Zaibo <xuzaibo@huawei.com>
Subject: RE: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYL1L4gR02rU84FUWBTBG9yRMgBqyvtjoAgASXrICAAAasAIAABpSAgADGSDCAAMaeAIAA1MMg
Date:   Wed, 9 Mar 2022 10:11:06 +0000
Message-ID: <BN9PR11MB527634CCF86829E0680E5E678C0A9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
 <20220304205720.GE219866@nvidia.com>
 <20220307120513.74743f17.alex.williamson@redhat.com>
 <aac9a26dc27140d9a1ce56ebdec393a6@huawei.com>
 <20220307125239.7261c97d.alex.williamson@redhat.com>
 <BN9PR11MB5276EBE887402EBE22630BAB8C099@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220308123312.1f4ba768.alex.williamson@redhat.com>
In-Reply-To: <20220308123312.1f4ba768.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5db7826-70cb-43dc-e47f-08da01b51ff5
x-ms-traffictypediagnostic: BYAPR11MB2616:EE_
x-microsoft-antispam-prvs: <BYAPR11MB2616BB17F843292E98AE232E8C0A9@BYAPR11MB2616.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nfoCoR09DibuXOuOq3qBFvfAuI1crDus75IEoqd77kiTDmtN+8sLzYHObt4sYajhi+VqtrRNggrIAeO1tH8YK92WiPjtWxW8eOCx3LXzgDxYpDszfJhrqaw/pWTJBsIsCwxhSmCtBmL8Dni629gHkyvOuj964teMhqOChTDjm4L+isEFCu0Nt7lzzZFQj91mtN5aLa2EI+5OmK5zlRY6Sbf2Jn4kzzaerYHtWMOke/vZvfonR4xLU9BO/m5CyQeAPzzt0oMNTF6PqRKSkcm4DA7y7lq1TTCOpqP7AHGaglTCZGYhrpRtqcX/LxG1ayVI5lO3e1HerLsxm5mv0B0YDGr9tPJX8dBcni79xpEJxpKLFS5hFO/9yEnYMZzfFem0jnQVgDgtvcSaZnLKiCsdquaWJsWffVWIOli9IFhqKV5Bis7sg0Y8m8ctiPQSXFkp2C+r7IiAOzLsoV1lW7sZ9QeWiv4A1ZpSpPNyT80hVQS7TVzVR4neoe3bnn7NZNbeNbkZrv09YyLFdLgrVzx9HiAFLk7gShK0vMKk6BJBzjvxPr98YiNEF0nnpQCZEShj/jasIYXhL1LjR+01yMRG1JEqxtdqacyEVwAm+tYOj1zQrFTklu1jR1kRHjEMIu4beg8jzH50L+VaBjn+jtPi3tQOm+TOELgcyFO2xoDNSg4QHaPze/brayiss+PoN3U+Kt5J5vyi5saTPw9yiRrGuH4kd0v/t3u+iyhVIi8uBiY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(6506007)(7696005)(508600001)(55016003)(54906003)(38070700005)(71200400001)(33656002)(6916009)(38100700002)(316002)(86362001)(7416002)(2906002)(5660300002)(82960400001)(9686003)(64756008)(66556008)(66446008)(66946007)(52536014)(122000001)(66476007)(4326008)(8676002)(186003)(8936002)(76116006)(26005)(60764002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlZJdnVKSGNYSlVtREhhcWFVV3ZoTWxTaWEza0ZtRzhjME10S2tHM0o1S0JW?=
 =?utf-8?B?Ky92dElhdnVheDJ0Wk16ZFczYzZwS2VId3BQN3R0bktpTXhVMThvc3BLMXhl?=
 =?utf-8?B?NG42cUkzQVVEVm5Sa2Q5MURFODlTMGlocUtKMHp1L3I1eVEzS3VKZkVNSDlL?=
 =?utf-8?B?YXNhT2FlTzQ2SWdZSEsyYTFxaUF6QlJNclU5Z3pwamZoV1Y2RG4zZlBCMWRP?=
 =?utf-8?B?d0hvSkora2pRMENIZ0xRNm1MVUNsMnZiMEtSdGJtZHZFSitIRDBraWk1bTV1?=
 =?utf-8?B?V29rWExIYm40d0xVcWxEbXc5NmVSSnJPL2cyV3llTUo5ekZqeUJXNm92ZkJX?=
 =?utf-8?B?MzNEdW5xWG5YSFhZZ2wzRnI3cGtZV2ovZHBISHFNV3pEZm1wQ3FHeTRiYThm?=
 =?utf-8?B?cnhweGF3SVlwL2FKd2tZalhFbERCeXpjK05EVlpkNlNzWTV0dTNBMDNFYWVn?=
 =?utf-8?B?dTBtUU1SNUFaczcyQ096VEhwUkx5R2RKdUJVenNkZ2s2OUxBZktiZVgvalNw?=
 =?utf-8?B?Vkh2QVNwUWNhbXA2RGJyWno5Y2gvZndZdGVqN2czWDROV2N2THZEanFROUhj?=
 =?utf-8?B?aGx3UDhOalVTOS8rZGFBWDZwRStvVTVIWU0yMHVIL2FwVlQreVNtZ24xV3Vi?=
 =?utf-8?B?RytRc0M3SW8weituUHVLU3cxTmk3eHZqYUZ0R3czL1diOFBvQ2l5S0FYaWtz?=
 =?utf-8?B?TSt4QkNJRFhXemNITlF4K0ZDOG52MTFZMkZlaWk4SU5XK0tNWkdUOHcvdEVt?=
 =?utf-8?B?SE9UNzdMeHo5OGkyOTc1NDI0LzFIQTYwOENlK1NLQU1IcGdrT1hXMjlYVnEw?=
 =?utf-8?B?U2xWVzZ3TzhKN1lRQkx0blZmRldoR0NjMm1GRlIvUjQ3WUZNNEFzdUVtV0Vm?=
 =?utf-8?B?aU0rRi9qV1VkR3c0Yk9EQUlhWXNmTVdRZkhKdUVSZUVLNmlIUXQxODVmb3A0?=
 =?utf-8?B?d3FCU2dhMXNJNXdKa3U0YlU5NkhMZzFTcDNOSFlKdlk4M211V1lxekRibm9Z?=
 =?utf-8?B?SExDQy82WDFTaEZJRUY0NlR2YmZFK3NxOEx3VzdUQmEwWXNGc1BOc0l0UVVq?=
 =?utf-8?B?a2VxNjNucW1RTnl3MVBLQmtJZlJpNnVxKzE1VVdadTZRR1FSeU9zbG11M01z?=
 =?utf-8?B?dnloRE1NVk5oRVM5Y2ZneEljU0FwWGlBLzhURnMxOWtWUkZYeGlrNFBjQ2l3?=
 =?utf-8?B?c0VqNFFuenJGSWVkQm9DMzdGZXhidzZzOUVIeDgzNk9hR2dReXJiRDVxYWhq?=
 =?utf-8?B?ZXRYZUN0R09uL2F3cGc2UDBTK202RDgrVkQyOThoNmZ3bldFc2JBbS9RQ2dW?=
 =?utf-8?B?aXVUSEhUWTJpdUxIWUlRT2VGc2x5K1dnOW11czM0RUNNQUd1SGpDMHBIZmlu?=
 =?utf-8?B?dnVmdk9GZlJuSGZWcXZQRlJYckRSVElBWkJnMXRjWlZSS0Fwek9qWFFCbWpq?=
 =?utf-8?B?c1ZDWnp2blE1NFZycVlhdlVKNHpFbUJTa05IVU9yZ1pzT242ZkRhb3VGOXMy?=
 =?utf-8?B?ZklsMElwZjZReXJ4RFdnb1dEOEhXM2tVdHVwNm02LzNYK3dGcWkyZWZUbm0r?=
 =?utf-8?B?UUpWVlVxc2dqNGNNMTFSRHBnamRkelNlYVpQc0UzdnBwUFlFVHNIa3pDRXdh?=
 =?utf-8?B?encxNWJkTnE2OGtkWTBVSERNR1BqcGJXaklocXBPbGJxN1pCRjZlc1B2aktU?=
 =?utf-8?B?WW0vVW1aZTlaenVrSmgzUjJzRlBacjNqYmlLdUVpRHM0WnJPajAzV3ROMUFy?=
 =?utf-8?B?ZmRzaW4vR090aTFZVjZ1YTNNdDR4WmUySGlwR0ZENXhqQnlCSXhQbkZMQ2ZU?=
 =?utf-8?B?bkNRTHZBVXVnSFd1R3BoRThTTnU4Rm5TMHl1U2ZOWUVsZldtODF0TDFKRFg0?=
 =?utf-8?B?RFpWbldsN2daMDQ5ODV3d1hoVVlmNHFoZlVKL0EzZFpNSlp6dWRiTFNsejlD?=
 =?utf-8?B?NmdKbnVodHpHcGRhM2tQdzZveWJHK1VKcnA4bUJlMTlpOTlPQXRPcDNZbjJJ?=
 =?utf-8?B?Z2tPYU5LeVlabmFvcXNjeVFINGt5VkNYaVRjL1lDMGVaeGtKclZoNE5ZaGtH?=
 =?utf-8?B?djkrK1Jwc1VmS04rcFNFOEltUjdiZnA4eHhtcG4zeU1LT3NYdjcxR1VvaEwv?=
 =?utf-8?B?cy9BN2VGQXNlREhrblpyZXBDcktEbVRobWdVRHRTV242VkNxMjBoUWhlMFNS?=
 =?utf-8?Q?Gd/kaDEUAhorZvn1nVlxISo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5db7826-70cb-43dc-e47f-08da01b51ff5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 10:11:06.2325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SyXqtH8H1ddNl31FfCW/+vZ0A7QGbrV9yUI25Zs0Ab/OWzplk1xOWwwCUJP50O29Gt5yLYSyskKvf7sXFbGy0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2616
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBXZWRuZXNkYXksIE1hcmNoIDksIDIwMjIgMzozMyBBTQ0KPiANCj4gT24gVHVlLCA4IE1h
ciAyMDIyIDA4OjExOjExICswMDAwDQo+ICJUaWFuLCBLZXZpbiIgPGtldmluLnRpYW5AaW50ZWwu
Y29tPiB3cm90ZToNCj4gDQo+ID4gPiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlh
bXNvbkByZWRoYXQuY29tPg0KPiA+ID4gU2VudDogVHVlc2RheSwgTWFyY2ggOCwgMjAyMiAzOjUz
IEFNDQo+ID4gPiA+DQo+ID4gPiA+ID4gSSB0aGluayB3ZSBzdGlsbCByZXF1aXJlIGFja3MgZnJv
bSBCam9ybiBhbmQgWmFpYm8gZm9yIHNlbGVjdCBwYXRjaGVzDQo+ID4gPiA+ID4gaW4gdGhpcyBz
ZXJpZXMuDQo+ID4gPiA+DQo+ID4gPiA+IEkgY2hlY2tlZCB3aXRoIFppYWJvLiBIZSBtb3ZlZCBw
cm9qZWN0cyBhbmQgaXMgbm8gbG9uZ2VyIGxvb2tpbmcgaW50bw0KPiA+ID4gY3J5cHRvIHN0dWZm
Lg0KPiA+ID4gPiBXYW5nemhvdSBhbmQgTGl1TG9uZ2Zhbmcgbm93IHRha2UgY2FyZSBvZiB0aGlz
LiBSZWNlaXZlZCBhY2tzIGZyb20NCj4gPiA+IFdhbmd6aG91DQo+ID4gPiA+IGFscmVhZHkgYW5k
IEkgd2lsbCByZXF1ZXN0IExvbmdmYW5nIHRvIHByb3ZpZGUgaGlzLiBIb3BlIHRoYXQncyBvay4N
Cj4gPiA+DQo+ID4gPiBNYXliZSBhIGdvb2QgdGltZSB0byBoYXZlIHRoZW0gdXBkYXRlIE1BSU5U
QUlORVJTIGFzIHdlbGwuICBUaGFua3MsDQo+ID4gPg0KPiA+DQo+ID4gSSBoYXZlIG9uZSBxdWVz
dGlvbiBoZXJlIChzaW1pbGFyIHRvIHdoYXQgd2UgZGlzY3Vzc2VkIGZvciBtZGV2IGJlZm9yZSku
DQo+ID4NCj4gPiBOb3cgd2UgYXJlIGFkZGluZyB2ZW5kb3Igc3BlY2lmaWMgZHJpdmVycyB1bmRl
ciAvZHJpdmVycy92ZmlvLiBUd28gZHJpdmVycw0KPiA+IG9uIHJhZGFyIGFuZCBtb3JlIHdpbGwg
Y29tZS4gVGhlbiB3aGF0IHdvdWxkIGJlIHRoZSBjcml0ZXJpYSBmb3INCj4gPiBhY2NlcHRpbmcg
c3VjaCBhIGRyaXZlcj8gRG8gd2UgcHJlZmVyIHRvIGEgbW9kZWwgaW4gd2hpY2ggdGhlIGF1dGhv
cg0KPiBzaG91bGQNCj4gPiBwcm92aWRlIGVub3VnaCBiYWNrZ3JvdW5kIGZvciB2ZmlvIGNvbW11
bml0eSB0byB1bmRlcnN0YW5kIGhvdyBpdA0KPiB3b3Jrcw0KPiA+IG9yIGFzIGRvbmUgaGVyZSBq
dXN0IHJlbHkgb24gdGhlIFBGIGRyaXZlciBvd25lciB0byBjb3ZlciBkZXZpY2Ugc3BlY2lmaWMN
Cj4gPiBjb2RlPw0KPiA+DQo+ID4gSWYgdGhlIGZvcm1lciB3ZSBtYXkgbmVlZCBkb2N1bWVudCBz
b21lIHByb2Nlc3MgZm9yIHdoYXQgaW5mb3JtYXRpb24NCj4gPiBpcyBuZWNlc3NhcnkgYW5kIGFs
c28gbmVlZCBzZWN1cmUgaW5jcmVhc2VkIHJldmlldyBiYW5kd2lkdGggZnJvbSBrZXkNCj4gPiBy
ZXZpZXdlcnMgaW4gdmZpbyBjb21tdW5pdHkuDQo+ID4NCj4gPiBJZiB0aGUgbGF0dGVyIHRoZW4g
aG93IGNhbiB3ZSBndWFyYW50ZWUgbm8gY29ybmVyIGNhc2Ugb3Zlcmxvb2tlZCBieSBib3RoDQo+
ID4gc2lkZXMgKGkuZS4gaG93IHRvIGtub3cgdGhlIGNvdmVyYWdlIG9mIHRvdGFsIHJldmlld3Mp
PyBBbm90aGVyIG9wZW4gaXMNCj4gd2hvDQo+ID4gZnJvbSB0aGUgUEYgZHJpdmVyIHN1Yi1zeXN0
ZW0gc2hvdWxkIGJlIGNvbnNpZGVyZWQgYXMgdGhlIG9uZSB0byBnaXZlIHRoZQ0KPiA+IGdyZWVu
IHNpZ25hbC4gSWYgdGhlIHN1Yi1zeXN0ZW0gbWFpbnRhaW5lciB0cnVzdHMgdGhlIFBGIGRyaXZl
ciBvd25lciBhbmQNCj4gPiBqdXN0IHB1bGxzIGNvbW1pdHMgZnJvbSBoaW0gdGhlbiBoYXZpbmcg
dGhlIHItYiBmcm9tIHRoZSBQRiBkcml2ZXIgb3duZXIgaXMNCj4gPiBzdWZmaWNpZW50LiBCdXQg
aWYgdGhlIHN1Yi1zeXN0ZW0gbWFpbnRhaW5lciB3YW50cyB0byByZXZpZXcgZGV0YWlsIGNoYW5n
ZQ0KPiA+IGluIGV2ZXJ5IHVuZGVybHlpbmcgZHJpdmVyIHRoZW4gd2UgcHJvYmFibHkgYWxzbyB3
YW50IHRvIGdldCB0aGUgYWNrIGZyb20NCj4gPiB0aGUgbWFpbnRhaW5lci4NCj4gPg0KPiA+IE92
ZXJhbGwgSSBkaWRuJ3QgbWVhbiB0byBzbG93IGRvd24gdGhlIHByb2dyZXNzIG9mIHRoaXMgc2Vy
aWVzLiBCdXQgYWJvdmUNCj4gPiBkb2VzIGJlIHNvbWUgcHV6emxlIG9jY3VycmVkIGluIG15IHJl
dmlldy4g8J+Yig0KPiANCj4gSGkgS2V2aW4sDQo+IA0KPiBHb29kIHF1ZXN0aW9ucywgSSdkIGxp
a2UgYSBiZXR0ZXIgdW5kZXJzdGFuZGluZyBvZiBleHBlY3RhdGlvbnMgYXMNCj4gd2VsbC4gIEkg
dGhpbmsgdGhlIGludGVudGlvbnMgYXJlIHRoZSBzYW1lIGFzIGFueSBvdGhlciBzdWItc3lzdGVt
LCB0aGUNCj4gZHJpdmVycyBtYWtlIHVzZSBvZiBzaGFyZWQgaW50ZXJmYWNlcyBhbmQgZXh0ZW5z
aW9ucyBhbmQgdGhlIHJvbGUgb2YNCj4gdGhlIHN1Yi1zeXN0ZW0gc2hvdWxkIGJlIHRvIG1ha2Ug
c3VyZSB0aG9zZSBpbnRlcmZhY2VzIGFyZSB1c2VkDQo+IGNvcnJlY3RseSBhbmQgZXh0ZW5zaW9u
cyBmaXQgd2VsbCB3aXRoaW4gdGhlIG92ZXJhbGwgZGVzaWduLiAgSG93ZXZlciwNCj4ganVzdCBh
cyB0aGUgbmV0d29yayBtYWludGFpbmVyIGlzbid0IGV4cGVjdGVkIHRvIGZ1bGx5IHVuZGVyc3Rh
bmQgZXZlcnkNCj4gTklDIGRyaXZlciwgSSB0aGluay9ob3BlIHdlIGhhdmUgdGhlIHNhbWUgZXhw
ZWN0YXRpb25zIGhlcmUuICBJdCdzDQo+IGNlcnRhaW5seSBhIGJlbmVmaXQgdG8gdGhlIGNvbW11
bml0eSBhbmQgcGVyY2VpdmVkIHRydXN0d29ydGhpbmVzcyBpZg0KPiBlYWNoIGRyaXZlciBvdXRs
aW5lcyBpdHMgb3BlcmF0aW5nIG1vZGVsIGFuZCBzZWN1cml0eSBudWFuY2VzLCBidXQNCj4gdGhv
c2UgYXJlIG9ubHkgZXZlciBnb2luZyB0byBiZSB0aGUgbnVhbmNlcyBpZGVudGlmaWVkIGJ5IHRo
ZSBwZW9wbGUNCj4gd2hvIGhhdmUgdGhlIGFjY2VzcyBhbmQgZW5lcmd5IHRvIGV2YWx1YXRlIHRo
ZSBkZXZpY2UuDQo+IA0KPiBJdCdzIGdvaW5nIHRvIGJlIHVwIHRvIHRoZSBjb21tdW5pdHkgdG8g
dHJ5IHRvIGRldGVybWluZSB0aGF0IGFueSBuZXcNCj4gZHJpdmVycyBhcmUgc2VyaW91c2x5IGNv
bnNpZGVyaW5nIHNlY3VyaXR5IGFuZCBub3Qgb3BlbmluZyBhbnkgbmV3IGdhcHMNCj4gcmVsYXRp
dmUgdG8gYmVoYXZpb3IgdXNpbmcgdGhlIGJhc2UgdmZpby1wY2kgZHJpdmVyLiAgRm9yIHRoZSBk
cml2ZXINCj4gZXhhbXBsZXMgd2UgaGF2ZSwgdGhpcyBzZWVtcyBhIGJpdCBlYXNpZXIgdGhhbiBl
dmFsdWF0aW5nIGFuIGVudGlyZQ0KPiBtZGV2IGRldmljZSBiZWNhdXNlIHRoZXkncmUgbGFyZ2Vs
eSBwcm92aWRpbmcgZGlyZWN0IGFjY2VzcyB0byB0aGUNCj4gZGV2aWNlIHJhdGhlciB0aGFuIHRy
eWluZyB0byBtdWx0aXBsZXggYSBzaGFyZWQgcGh5c2ljYWwgZGV2aWNlLiAgV2UNCj4gY2FuIHRo
ZXJlZm9yZSBmb2N1cyBvbiBpbmNyZW1lbnRhbCBmdW5jdGlvbmFsaXR5LCBhcyBib3RoIGRyaXZl
cnMgaGF2ZQ0KPiBkb25lLCBpbXBsZW1lbnRpbmcgYSBib2lsZXJwbGF0ZSB2ZW5kb3IgZHJpdmVy
LCB0aGVuIGFkZGluZyBtaWdyYXRpb24NCj4gc3VwcG9ydC4gIEkgaW1hZ2luZSB0aGlzIHdvbid0
IGFsd2F5cyBiZSB0aGUgY2FzZSB0aG91Z2ggYW5kIHNvbWUNCj4gZHJpdmVycyB3aWxsIHJlLWlt
cGxlbWVudCBtdWNoIG9mIHRoZSBjb3JlIHRvIHN1cHBvcnQgZnVydGhlciBlbXVsYXRpb24NCj4g
YW5kIHNoYXJlZCByZXNvdXJjZXMuDQo+IA0KPiBTbyBob3cgZG8gd2UgYXMgYSBjb21tdW5pdHkg
d2FudCB0byBoYW5kbGUgdGhpcz8gIEkgd291bGRuJ3QgbWluZCwgSSdkDQo+IGFjdHVhbGx5IHdl
bGNvbWUsIHNvbWUgc29ydCBvZiByZXZpZXcgcmVxdWlyZW1lbnQgZm9yIG5ldyB2ZmlvIHZlbmRv
cg0KPiBkcml2ZXIgdmFyaWFudHMuICBJcyB0aGF0IHJlYXNvbmFibGU/ICBXaGF0IHdvdWxkIGJl
IHRoZSBjcml0ZXJpYT8NCj4gQXBwcm92YWwgZnJvbSB0aGUgUEYgZHJpdmVyIG93bmVyLCBpZiBk
aWZmZXJlbnQvbmVjZXNzYXJ5LCBhbmQgYXQgbGVhc3QNCj4gb25lIHVuYWZmaWxpYXRlZCByZXZp
ZXdlciAocHJlZmVyYWJseSBhbiBhY3RpdmUgdmZpbyByZXZpZXdlciBvcg0KPiBleGlzdGluZyB2
ZmlvIHZhcmlhbnQgZHJpdmVyIG93bmVyL2NvbnRyaWJ1dG9yKT8gIElkZWFzIHdlbGNvbWUuDQo+
IFRoYW5rcywNCj4gDQoNClllcywgYW5kIHRoZSBjcml0ZXJpYSBpcyB0aGUgaGFyZCBwYXJ0LiBJ
biB0aGUgZW5kIGl0IGxhcmdlbHkgZGVwZW5kIG9uIA0KdGhlIGV4cGVjdGF0aW9ucyBvZiB0aGUg
cmV2aWV3ZXJzLiAgDQoNCklmIHRoZSB1bmFmZmlsaWF0ZWQgcmV2aWV3ZXIgb25seSBjYXJlcyBh
Ym91dCB0aGUgdXNhZ2Ugb2Ygc2hhcmVkIA0KaW50ZXJmYWNlcyBvciBleHRlbnNpb25zIGFzIHlv
dSBzYWlkIHRoZW4gd2hhdCB0aGlzIHNlcmllcyBkb2VzIGlzDQpqdXN0IGZpbmUuIFN1Y2ggdHlw
ZSBvZiByZXZpZXcgY2FuIGJlIGVhc2lseSBkb25lIHZpYSByZWFkaW5nIGNvZGUgDQphbmQgZG9l
c24ndCByZXF1aXJlIGRldGFpbCBkZXZpY2Uga25vd2xlZGdlLg0KDQpPbiB0aGUgb3RoZXIgaGFu
ZCBpZiB0aGUgcmV2aWV3ZXIgd2FudHMgdG8gZG8gYSBmdWxsIGZ1bmN0aW9uYWwNCnJldmlldyBv
ZiBob3cgbWlncmF0aW9uIGlzIGFjdHVhbGx5IHN1cHBvcnRlZCBmb3Igc3VjaCBkZXZpY2UsIA0K
d2hhdGV2ZXIgaW5mb3JtYXRpb24gKHBhdGNoIGRlc2NyaXB0aW9uLCBjb2RlIGNvbW1lbnQsIGtk
b2MsDQpldGMuKSBuZWNlc3NhcnkgdG8gYnVpbGQgYSBzdGFuZGFsb25lIG1pZ3JhdGlvbiBzdG9y
eSB3b3VsZCBiZQ0KYXBwcmVjaWF0ZWQsIGUuZy46DQoNCiAgLSBXaGF0IGNvbXBvc2VzIHRoZSBk
ZXZpY2Ugc3RhdGU/DQogIC0gV2hpY2ggcG9ydGlvbiBvZiB0aGUgZGV2aWNlIHN0YXRlIGlzIGV4
cG9zZWQgdG8gYW5kIG1hbmFnZWQNCiAgICBieSB0aGUgdXNlciBhbmQgd2hpY2ggaXMgaGlkZGVu
IGZyb20gdGhlIHVzZXIgKGkuZS4gY29udHJvbGxlZA0KICAgIGJ5IHRoZSBQRiBkcml2ZXIpPw0K
ICAtIEludGVyZmFjZSBiZXR3ZWVuIHRoZSB2ZmlvIGRyaXZlciBhbmQgdGhlIGRldmljZSAoYW5k
L29yIFBGDQogICAgZHJpdmVyKSB0byBtYW5hZ2UgdGhlIGRldmljZSBzdGF0ZTsNCiAgLSBSaWNo
IGZ1bmN0aW9uYWwtbGV2ZWwgY29tbWVudHMgZm9yIHRoZSByZXZpZXdlciB0byBkaXZlIGludG8N
CiAgICB0aGUgbWlncmF0aW9uIGZsb3c7DQogIC0gLi4uDQoNCkkgZ3Vlc3Mgd2UgZG9uJ3Qgd2Fu
dCB0byBmb3JjZSBvbmUgbW9kZWwgb3ZlciB0aGUgb3RoZXIuIEp1c3QNCmZyb20gbXkgaW1wcmVz
c2lvbiB0aGUgbW9yZSBpbmZvcm1hdGlvbiB0aGUgZHJpdmVyIGNhbiANCnByb3ZpZGUgdGhlIG1v
cmUgdGltZSBJJ2QgbGlrZSB0byBzcGVuZCBvbiB0aGUgcmV2aWV3LiBPdGhlcndpc2UNCml0IGhh
cyB0byB0cmVuZCB0byB0aGUgbWluaW1hbCBmb3JtIGkuZS4gdGhlIGZpcnN0IG1vZGVsLg0KDQph
bmQgY3VycmVudGx5IEkgZG9uJ3QgaGF2ZSBhIGNvbmNyZXRlIGlkZWEgaG93IHRoZSAybmQgbW9k
ZWwgd2lsbA0Kd29yay4gbWF5YmUgaXQgd2lsbCBnZXQgY2xlYXIgb25seSB3aGVuIGEgZnV0dXJl
IGRyaXZlciBhdHRyYWN0cyANCnBlb3BsZSB0byBkbyB0aG9yb3VnaCByZXZpZXcuLi4NCg0KVGhh
bmtzDQpLZXZpbg0K
