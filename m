Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7635A0EB3
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 13:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239563AbiHYLIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 07:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiHYLIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 07:08:18 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15F6AE84C;
        Thu, 25 Aug 2022 04:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661425697; x=1692961697;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=765f1Y0gC7zPP4fZqG+Ba70pNtRH7gN/Hb1LIpRZM+8=;
  b=aHbMelbmAfAdVri4/yjkVFot2BGBCa8L21mFMIxSflSfuddifwnGTO0q
   tYm6HVgMLAXBI1ZPGRndIiak9TEba0H2gpyd50NnbFivm+XAYdiS14EHR
   kVLQn1TzOHPHWkYP4VUYoJBQKcQbXz3pQ+gPjwezr7z0taJJ5purdrbrh
   EjtVNmywRiKffySk7n9Q3Bk8TcV4X52tttlMmQOcQzVJJuJK2jVdqcie5
   g5IoK0ME+F7btNhJybBOVpxzm1CwLwCBKWYm+Tq/qzxLVXxPzOrIgRI09
   JSH5I+l66ZA+QRFrxYhX773qAYaxQ3tKDS8DKRBkirxGuhJYfvYr0n9OS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="380503719"
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="380503719"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 04:08:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="785969944"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 25 Aug 2022 04:08:17 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 04:08:16 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 04:08:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 25 Aug 2022 04:08:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 25 Aug 2022 04:08:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rn+o9iF3neQdhGIYD1vONqAaUKdrsMba6sLkaj3nkhlJV9CbeBYUL5accjdijWBSm+n6IKk3ESZ1o8lZrDwBx6xAWOL+QSB/Cj/pqa62ZjlQhhyA0qOdFb1kmDLYgkZzLs0NiTptUNTihBikvZv10UzzssUwC04c8dNNAkOTTN0Z2yaOy7sZ2O2vhNfOQuGGP6oKD2ahZQ0yJ2x0ICI4V0fmTYx5lxpya+kBro8lSUbKHRZM6Sif7M6j/MrtL/FKdeTwP8L1Htrd861Gzq9JW4I9xGNp3Y/4HqXfVEpqkxH/cg8Nsl8l60FfV6x+WNSKwzBFwz8BIQ5MDEQe0E4hlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=765f1Y0gC7zPP4fZqG+Ba70pNtRH7gN/Hb1LIpRZM+8=;
 b=WpGATlm9X/wYRmxBALHv1pVKbpwhZI/tREPCQlSH2dL4l1BI2WeyY5IRU+7Tjb/Q5ns8iV4qnXzQ/7IBnlFbJzK+5lXwvmHadpVDfMNXMgutxtXxukTDDGLFsgiBMGuhk7eDDvXirC/lpQsYeebpt/JpkHjsRZvVHXRmu3ni0pcZnMrKvcBOd4Ox2a5gUB5eKIW51Yi9MPHgQqE3Rc1AV4OmfB8f2AzM0ccorCMyrUi7osOnJe4nA4W7CJG6+qoS5SyVmg7XRORzoTJL9V5n7RB1ny+HQMY2/wlF9jxvbihmCq0/eN2K3qjUJJXZfEOWgEoR/KysQVLhBC97xwCoxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB4824.namprd11.prod.outlook.com (2603:10b6:510:38::13)
 by MN2PR11MB3840.namprd11.prod.outlook.com (2603:10b6:208:ea::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 11:08:14 +0000
Received: from PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::adb4:9c0e:5140:9596]) by PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::adb4:9c0e:5140:9596%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 11:08:14 +0000
From:   "Mi, Dapeng1" <dapeng1.mi@intel.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>
Subject: RE: [PATCH] KVM: x86: use TPAUSE to replace PAUSE in halt polling
Thread-Topic: [PATCH] KVM: x86: use TPAUSE to replace PAUSE in halt polling
Thread-Index: AQHYt5jfiwON7Q5LUE+jIx7HUxEKwK2+FrcAgADk8MA=
Date:   Thu, 25 Aug 2022 11:08:14 +0000
Message-ID: <PH0PR11MB48244A3109FA7A060AB5280ACD729@PH0PR11MB4824.namprd11.prod.outlook.com>
References: <20220824091117.767363-1-dapeng1.mi@intel.com>
 <66ba8291b33e440280ead8418b8b21ee@AcuMS.aculab.com>
In-Reply-To: <66ba8291b33e440280ead8418b8b21ee@AcuMS.aculab.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca7f1a57-467a-4a4d-ed14-08da868a1aec
x-ms-traffictypediagnostic: MN2PR11MB3840:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zqPb1VQcYICvs2wtFNa0h9/0H7zFsGJFMAv0dCV4gEMudzMpvTGmiL+EBLG9Y5v5544NA5L7m+G+gOKpKLQGG1biKNzvgu3ZuyoLEWoZN1heyPXuPNUdIYrqcrZymKkYKWwNgiPvF4tIJKZetwN3kGw7AxGEe6ME3qFTIxwYAosJSREFizfblG9WpIFByCsZdYkzluusBZEE+brV8cx/2tnPDrELitUxwFc/4EMFku1PTXKR5STz1SU5tJW+xZwnZE69IpVflFuc6Ej+mMvX65AIRYZTki5vTCvJip8k2ECbPFI69jV+hTIRz5FfUKa8/RKRI1O5njTQjnxTJnKm9O6Xtx3OqmhHDv7V7qUUwDLNB5ZCehskZICMrFrc2sDgJLq56xT8451Gmca1cR9sVWQKaZ6xewx9cBOnpK+OM/kOanJWIn2ml0ys5MgmW18ragGVprt8zTeFjuePZe5oFHkov/4jW/geFDZYpjBpWi8IseCKjAJl7wpNUQE39IxHxSYuru5raRQWnJ8g5yOwl8bB/69korFQagKd5TW2DipF23DVqXQxUjdm78bvHMi7ZPJAV+mI3YuYW0OH8PRPC9detAoRlv70E7QUYE3gRcozCN/oBHBTzJ9aIULdpXhtT96saSaVuwmWR3fXyERdGJbN/Re5lgeH5kRjpRE1/89Vfv9CHKF2ZdHtZlBtNSFitwm5bbYeBHEoqIiQiXlh2IVrU3Xs56P4vmhrvn8RleIihG7II0S2of62LwLpNNSNbiXRLe3T6qQ2mz9AFFtzkA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(39860400002)(346002)(366004)(136003)(66446008)(4326008)(8676002)(2906002)(66476007)(54906003)(64756008)(76116006)(66946007)(66556008)(55016003)(110136005)(5660300002)(8936002)(38100700002)(122000001)(316002)(86362001)(38070700005)(41300700001)(52536014)(6506007)(82960400001)(53546011)(26005)(478600001)(71200400001)(9686003)(7696005)(83380400001)(33656002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YnFkWlBMYVJ6T24wNHJCa09VdjFDWkthbGRhVUEybWdsRVZzMllzK2ZTazBJ?=
 =?utf-8?B?bXQ3TWw0YTZkTDhGcWZtWWY4bU9hV1pZSkJPOHk2WldTemxyQjBRTlB3SFVU?=
 =?utf-8?B?RzJVajZGMmlSWTl0eFVDU2FVWDlQK1ZnTFlJaVQ0VkxybEhkV1kvNXIzOG1n?=
 =?utf-8?B?cDZyRWZ2WjN1dXpVQ0NJVmpvVnFSTXkyVVRxRFYrS1hNTTkrRFdLQmUxWkw3?=
 =?utf-8?B?TE9EK1hoT3NOZnZMY0FqK3pYLzJMNVdWSzh6MHh5NytmdnkvZFROVFhzQVhT?=
 =?utf-8?B?QzBsSUhvZ0kzcWFsS2dFbnRaeHNqK2g2NnVBcGd5aVptdVY1Tlh0V0ltd3RM?=
 =?utf-8?B?cEhVYTB4ZWJUcjdjWFlvbnkwd3pDSHFrKzlsK0syVWxNZWd2aklBYVBpNnZN?=
 =?utf-8?B?d0dTcDNYSFJRb3J6TzRFYTRnZ2J0SXArM2dqN3BhNERrNXpoMHlhVnZFUmdv?=
 =?utf-8?B?SFl2aUtWaE5aY3ZQSzZUcEkzdFQ1TDBpVHVlTXhUYWRIUzBDNjdxd0FnYThY?=
 =?utf-8?B?OXFIQ0J0RjZkWGpGMkVEM2tmb0lQWGJsdnZmOVlHQ3NTamcwZEtWVmh1VEFt?=
 =?utf-8?B?aUJSTDV3dTl2Uis5Q1VIb1duZFRjZEFEODg3NjcrWXdvR0NpMnNiUENmMVFK?=
 =?utf-8?B?dVpPa09KTllMWG5tTHpDbjMwa0hXTUJmNWxxQXBpcGxBa3Q0WXl2QTNtL0Rz?=
 =?utf-8?B?WUJnYTYvU3BIZmVIOE1hSFdidnRqQzJiMWxTemZCQkhFTGtsamR6cWpzakRm?=
 =?utf-8?B?cjN4aEhjcE85a3FoY295T3lLQ1BDMWNjTlE5b3lETnNGbkJSQ1hKbGFkL3BJ?=
 =?utf-8?B?ZWYwWjUxaTlLbXpnckpCdmREL1NHQXdzcjdDQnE0ajBzL2djRlVUblpwMDhY?=
 =?utf-8?B?NXRxTUtJV2IwaFFTdDhmK0hBdFQxSzdsVGNyNnNjWDZWT0gveDh6N3lTa2s1?=
 =?utf-8?B?Q2ZyQis0cWhaYmFzeEVkKy9GNG5OZ002U1V4NmpwM3BYNERIUzBMRkhhMGNK?=
 =?utf-8?B?Y3FiS2dFbkJJOXZ2OE41Tno0TCtZSWtUTXg4b3ZNTjFOZVNtN25IMWkxaDA0?=
 =?utf-8?B?dmZVMGU0QkFZK0FTRVRocytQem5QOUpuSnRuV015SzIvUVlDZ3RYSHpXME9M?=
 =?utf-8?B?SG9PbEgydTdyc3dlYUlleko5ZHZiN3FBWEJRS2N0ZjlmdS9oaE5TcVM0MWZM?=
 =?utf-8?B?MXJTaVRwdWlqN1NVaGpLTDhJcDRkdTJSS21DcGhKRS8vKzVTdnlwTmVXS2lu?=
 =?utf-8?B?OUtTZ2NVZXczd0tUcmE2YVJSd2pkRU9xN2xyanBLTmx5ZzVZSWZPQTh0YUFH?=
 =?utf-8?B?ZGxnZFN5OEFSYzc4RWMzZk5ZMlhmUVlZbThUVk1GaVVXRlM5NXlkY2l1SXk4?=
 =?utf-8?B?NXNHNUFxMkpmeDZsaWNmZnQxWVlUV0xaVDh5NUsvMVlmTE9SNU9PVzFETlJ0?=
 =?utf-8?B?c3I2Z1Y1NEVOQlhaYlBTQmdFdXgyVk55RjI0a0xzb1lyN3d6MHI1YW84M2R5?=
 =?utf-8?B?MnBkdmVLVzVwWXJjZGZWb1RvYkRZbVVnM01EQVl1Q3YxS3JBWlN4ZGRaOU00?=
 =?utf-8?B?clVCazlvcFVUZmRDczJwbG91cU5VUmkrNWd4UG4yNzJTS1VaNFVidTlvMmFu?=
 =?utf-8?B?elB6MWZTWEYxTFhaMm9sNE1jK29ieUlGdTYvbkJTbmFCOENESFZjcXE3ZC92?=
 =?utf-8?B?UTIwUkJFUDFMOGNpSGtkeTJad2N3a0tpOXdYTHhzb3hmeTZ6SEhGOXpvVmRj?=
 =?utf-8?B?cmozYWt0a0UwOW9hTFpsbnNXNld5QmpIWlY0NCtYcmxMYjJqakdkdm5sV2JU?=
 =?utf-8?B?eUExUVhDYm5nWHRmSUxLeU1Gd3N5ZEx1cjNDRHMvNlI0eWdHR1JEZ2JhOFoz?=
 =?utf-8?B?V29zUVlYNW91alV0MktveTVmNFU0MVU2QkdyUnY1c01RMlp1amlwaGdCaERB?=
 =?utf-8?B?aTFWdGpoRHYzVjY5bHN2MThoQXVQS0RlUzRhWURROVJKMnp0MzBJVEVOWE9V?=
 =?utf-8?B?cFVZT0s2K1didWlWNDNmcWJHWWo4ajVTY2JhWVAwODE3UDNEbXBSUHdhc3FJ?=
 =?utf-8?B?ckcxeTBaR01XdDlheE03YzhpM0lFU2tPK3NKNDdNWGt1OWg0YlJzc1JyQ3BF?=
 =?utf-8?Q?ZNnuryNyw6v70vKNAjbn0M36Q?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca7f1a57-467a-4a4d-ed14-08da868a1aec
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2022 11:08:14.1066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skmQmVBB0djxxVBZQEvjJWkgXPAlyM2GqNEnL4VpFw2JtA3mY5uhQL0XOsKGjGRTNQuga9E/ac0yg9J90ddQgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3840
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBEYXZpZCBMYWlnaHQgPERhdmlkLkxhaWdodEBBQ1VMQUIuQ09NPg0KPiBTZW50OiBX
ZWRuZXNkYXksIEF1Z3VzdCAyNCwgMjAyMiAxMDowOCBQTQ0KPiBUbzogTWksIERhcGVuZzEgPGRh
cGVuZzEubWlAaW50ZWwuY29tPjsgcmFmYWVsQGtlcm5lbC5vcmc7DQo+IGRhbmllbC5sZXpjYW5v
QGxpbmFyby5vcmc7IHBib256aW5pQHJlZGhhdC5jb20NCj4gQ2M6IGxpbnV4LXBtQHZnZXIua2Vy
bmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4ga3ZtQHZnZXIua2VybmVs
Lm9yZzsgemhlbnl1d0BsaW51eC5pbnRlbC5jb20NCj4gU3ViamVjdDogUkU6IFtQQVRDSF0gS1ZN
OiB4ODY6IHVzZSBUUEFVU0UgdG8gcmVwbGFjZSBQQVVTRSBpbiBoYWx0IHBvbGxpbmcNCj4gDQo+
IEZyb206IERhcGVuZyBNaQ0KPiA+IFNlbnQ6IDI0IEF1Z3VzdCAyMDIyIDEwOjExDQo+ID4NCj4g
PiBUUEFVU0UgaXMgYSBuZXcgaW5zdHJ1Y3Rpb24gb24gSW50ZWwgcHJvY2Vzc29ycyB3aGljaCBj
YW4gaW5zdHJ1Y3QNCj4gPiBwcm9jZXNzb3IgZW50ZXJzIGEgcG93ZXIvcGVyZm9ybWFuY2Ugb3B0
aW1pemVkIHN0YXRlLiBIYWx0IHBvbGxpbmcNCj4gPiB1c2VzIFBBVVNFIGluc3RydWN0aW9uIHRv
IHdhaXQgdkNQVSBpcyB3YWtlZCB1cC4gVGhlIHBvbGxpbmcgdGltZQ0KPiA+IGNvdWxkIGJlIGxv
bmcgYW5kIGNhdXNlIGV4dHJhIHBvd2VyIGNvbnN1bXB0aW9uIGluIHNvbWUgY2FzZXMuDQo+ID4N
Cj4gPiBVc2UgVFBBVVNFIHRvIHJlcGxhY2UgdGhlIFBBVVNFIGluc3RydWN0aW9uIGluIGhhbHQg
cG9sbGluZyB0byBnZXQgYQ0KPiA+IGJldHRlciBwb3dlciBzYXZpbmcgYW5kIHBlcmZvcm1hbmNl
Lg0KPiANCj4gV2hhdCBpcyB0aGUgZWZmZWN0IG9uIHdha2V1cCBsYXRlbmN5Pw0KPiBRdWl0ZSBv
ZnRlbiB0aGF0IGlzIGZhciBtb3JlIGltcG9ydGFudCB0aGFuIGEgYml0IG9mIHBvd2VyIHNhdmlu
Zy4NCg0KSW4gdGhlb3J5LCB0aGUgaW5jcmVhc2VkIHdha2V1cCBsYXRlbmN5IHNob3VsZCBiZSBs
ZXNzIHRoYW4gMXVzLiBJIHRob3VnaHQgdGhpcyBsYXRlbmN5IGltcGFjdGlvbiBzaG91bGQgYmUg
bWluaW1hbC4gSSBldmVyIHJ1biB0d28gc2NoZWR1bGluZyByZWxhdGVkIGJlbmNobWFya3MsIGhh
Y2tiZW5jaCBhbmQgc2NoYmVuY2guICBJIGRpZG4ndCBzZWUgdGhpcyBjaGFuZ2Ugd291bGQgb2J2
aW91c2x5IGltcGFjdCB0aGUgcGVyZm9ybWFuY2UuDQoNCldoZW4gcnVubmluZyB0aGVzZSB0d28g
c2NoZWR1bGluZyBiZW5jaG1hcmtzIG9uIGhvc3QsIGEgRklPIHdvcmtsb2FkIGlzIHJ1bm5pbmcg
aW4gYSBMaW51eCBWTSBzaW11bHRhbmVvdXNseSwgRklPIHdvdWxkIHRyaWdnZXIgYSBsYXJnZSBu
dW1iZXIgb2YgSExUIFZNLWV4aXQgYW5kIHRoZW4gdHJpZ2dlciBoYWx0cG9sbGluZywgdGhlbiB3
ZSBjYW4gc2VlIGhvdyBUUEFVU0UgY2FuIGltcGFjdCB0aGUgcGVyZm9ybWFuY2UuDQoNCkhlcmUg
YXJlIHRoZSBoYWNrYmVuY2ggYW5kIHNjaGJlbmNoIGRhdGEgb24gSW50ZWwgQURMIHBsYXRmb3Jt
Lg0KDQpIYWNrYmVuY2ggCQliYXNlCQlUUEFVU0UJCSVkZWx0YQ0KR3JvdXAtMQkJMC4wNTYJCTAu
MDUyCQk3LjE0JQ0KR3JvdXAtNAkJMC4xNjUJCTAuMTY0CQkwLjYxJQ0KR3JvdXAtOAkJMC4zMTMJ
CTAuMzA5CQkxLjI4JQ0KR3JvdXAtMTYJCTAuODM0CQkwLjg0MgkJLTAuOTYlDQoNClNjaGJlbmNo
IC0gTGF0ZW5jeSBwZXJjZW50aWxlcyAodXNlYykJCWJhc2UgCQlUUEFVU0UJDQouL3NjaGJlbmNo
IC1tIDENCgk1MC4wdGgJCQkJCTE1CQkxMwkJDQoJOTkuMHRoCQkJCQkyMjEJCTIwMw0KLi9zY2hi
ZW5jaCAtbSAyDQoJNTAuMHRoCQkJCQkyNgkJMjMNCgk5OS4wdGgJCQkJCTE2MzY4CQkxNjU0NA0K
Li9zY2hiZW5jaCAtbSA0DQoJNTAuMHRoCQkJCQk1NgkJNjANCgk5OS4wdGgJCQkJCTMzOTg0CQkz
NDExMg0KIA0KU2luY2UgdGhlIHNjaGJlbmNoIGJlbmNobWFyayBpcyBub3Qgc28gc3RhYmxlLCBi
dXQgSSBjYW4gc2VlIHRoZSBkYXRhIGlzIG9uIGEgc2FtZSBsZXZlbC4NCg0KPiBUaGUgYXV0b21h
dGljIGVudHJ5IG9mIHNsZWVwIHN0YXRlcyBpcyBhIFBJVEEgYWxyZWFkeS4NCj4gQmxvY2sgMzAg
UlQgdGhyZWFkcyBpbiBjdl93YWl0KCkgYW5kIHRoZW4gZG8gY3ZfYnJvYWRjYXN0KCkuDQo+IFVz
ZSBmdHJhY2UgdG8gc2VlIGp1c3QgaG93IGxvbmcgaXQgdGFrZXMgdGhlIGxhc3QgdGhyZWFkIHRv
IHdha2UgdXAuDQoNCkkgdGhpbmsgdGhpcyB0ZXN0IGlzIGZhbWlsaWFyIHdpdGggdGhlIGhhY2ti
ZW5jaCBhbmQgc2NoYmVuY2gsIGl0IHNob3VsZCBoYXZlIHNpbWlsYXIgcmVzdWx0Lg0KDQpBbnl3
YXksIHBlcmZvcm1hbmNlIGFuZCBwb3dlciBpcyBhIHRyYWRlb2ZmLCBpdCBkZXBlbmRzIG9uIHdo
aWNoIHNpZGUgd2UgdGhpbmsgaXMgbW9yZSBpbXBvcnRhbnQuDQoNCj4gDQo+IAlEYXZpZA0KPiAN
Cj4gLQ0KPiBSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQg
RmFybSwgTWlsdG9uIEtleW5lcywgTUsxDQo+IDFQVCwgVUsgUmVnaXN0cmF0aW9uIE5vOiAxMzk3
Mzg2IChXYWxlcykNCg0K
