Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7450B6469FC
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 08:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLHH4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 02:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiLHH4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 02:56:39 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754A04E402
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 23:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670486194; x=1702022194;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YspUErQpsQAG2SEhS0DID7kUVnsKR2BLZPAgD0jfN0Y=;
  b=Kryqb7aRm4uAkw3CaYxWuPeEYD6W9zhTOhtWSvkOnE9BgH9IF1ZCzFgT
   Daz9acDm1WdK0TSSDvPaDrXnacIMbNZSgdzrl25UDCJsp8m4/+Ux84P0b
   dRND/aJmbQM67Tx1owncVIrZ78c2Mt7jMhNhRvDOCpIwIrYJHMXae/gMl
   emJAcKk6/qaQbYZ/9Zg/gWXrYgVn+9Ae+ZnkSJJUaxhPPrztIiRQBbRUo
   25Ejxe65LDFWazgw+1FeWwy6GXS3ekZ5NBgqbfxF7JdsjJFO2f44r44YH
   dL0ZhtdORQKaj/sSMkt9j8LtAqGB6vtyEcL2BsQyu90d2qGy2qSvh/U0Q
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="297461698"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="297461698"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 23:56:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="646912078"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="646912078"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 07 Dec 2022 23:56:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 23:56:33 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 7 Dec 2022 23:56:33 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 7 Dec 2022 23:56:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFWIUFtGmorx/MVRp3BAGSUhI5FtZlmJpDI6d1/+TR7lT9XCPFqifFwj4X+Ppa1pTnlnaB4pJv0O14i7yvBWN4PFlPwjKuKgoOHihIsmZSc5ScK5rloOnbf8K5CGWmgvOp61Qjlz5kaiB40j9TrYrZeOOhhwB4CvXyszw4t6r9okWBXzqg6H1eKdvDFBGVOpqBX8W7J+fZTfSjgKcqQmTVVAIugE1RVV7LGas8fpQhrT+pm6xT7FLsJXszaWgAruRTURFTK66vYwH1+ik0m8MrdTrq4C/dhEWwD1PlFmEtcCyzi1PcjEBLeXywqD1JTDkFPpNJ5+R2MuDq08vW51TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YspUErQpsQAG2SEhS0DID7kUVnsKR2BLZPAgD0jfN0Y=;
 b=eQTVZkZHmQbpdW07rgnM1cQQYSZHvuhfm4iF8IVGe5KffGhdXuaeU6qlulsRKT8gMT0nB6wKoV2s3SCpbSfZJnjy0JoxYowO+E2nISHwO4tpviSaydp4V1nzvdiAlog95wjBXQ6AkdR/UOkwBl1HjIY/py/tIkUSycXx59oa1Od/ntIm0s6QB2nFavPUHiuPhXkD2Gn6H888ClYLRIw/8z/fefYtivvEaJZAKcZ5FujTkRunD59UgNCeFK7shbxovcOw0Lr/KONh7gjcWehHlJ7Rch2wNPWfGrNN3Dy88oCZNNhHjH7BvV2sc3aGXENZMqJDDYX2AocfB30Cw3rRrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB7426.namprd11.prod.outlook.com (2603:10b6:a03:4c2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 07:56:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5880.016; Thu, 8 Dec 2022
 07:56:31 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "steven.sistare@oracle.com" <steven.sistare@oracle.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>
Subject: RE: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Thread-Topic: [PATCH] vfio/type1: Cleanup remaining vaddr removal/update
 fragments
Thread-Index: AQHZCoVjeULY8YaRoECbnHOCrzytX65jn7UQ
Date:   Thu, 8 Dec 2022 07:56:30 +0000
Message-ID: <BN9PR11MB5276222DAE8343BBEC9A79E98C1D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <167044909523.3885870.619291306425395938.stgit@omen>
In-Reply-To: <167044909523.3885870.619291306425395938.stgit@omen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB7426:EE_
x-ms-office365-filtering-correlation-id: ddaea76e-6fa3-4d6c-bcaa-08dad8f1b7db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2AHGPzlatmu2vMeMoE+2E/ajXhCqLomY3jqVxIto0T4oWuE9IqVUkN6rTOVFwE5h8+GQlDAoTVrciBfybsuXELjZiMZu7qOMxIdfucvNQ5mCsjtCfBU+7dzcMBbVJNzB2fhhtm1ExFJWXC+SziR3s8CrXSKKdyIFHqLLrb7YBtNbjj3GkKnWmdqaVqMBg5tMy2aT/07T3jhdfYjzftU8ULZEmjeKF/dbaMxT3Qxel0HwkrydYbFP0pCSaSF9iHprnGg6+ODAaQyzPt0CeDIJDp//t6riTTKtjZblaQ5j2kf7zmgRfq90+K/I3rGXOfCNRcIdVzplegpzj3P7q8eDE95jL1FDKSbv/+1MTJaml6Wyhv/EyhW9F9Q9mF5+TtoR5JItVnq94sII4wakqv5JXu+TaEw9i+tyVE9hIkI8Q5FYA0Kd0+J7o3wCGPnJ9LCuSwUNmGwFbAkifiay2e5A/Ww5ENaCtZ/yr8pSdKgMnDMS0uesueAURAqpzkzRoAFE2TGX+UU/kGRQ7SKFjx7yw9QFuZ3RztZqDfi6BIT7XdUvH6fBPKS6d0OFuu3lVCs/Fu0FXFOZvkljIJNGY+Ax3Wt8pasf49bJ5I9O9SzT/+uo5kdvl+Lt7a22u8Xxs44tehMRP6Js9XBsr7EPaazdYFg5Vu1dtpBzYLTBPkYzueGDPCUbhYkt9IQa7kaX1jGREK9vIwyDv29NhxuVQXhhvVQTs+PituytuMcP6WbAdMA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199015)(4744005)(2906002)(15650500001)(82960400001)(478600001)(66476007)(38070700005)(64756008)(33656002)(54906003)(4326008)(41300700001)(8676002)(66556008)(55016003)(66446008)(86362001)(71200400001)(5660300002)(52536014)(8936002)(76116006)(66946007)(9686003)(186003)(26005)(110136005)(83380400001)(122000001)(38100700002)(316002)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1VIUTU2ZnFqVmRrUHZlKzNsYmlIeFhDMTlkVGYxK09wRzRST1I0cUhzN29R?=
 =?utf-8?B?TWpDaXAzMlpOK1hGZ284RXBoRFlUa3JPNmRsVldadng3Z29Ea1FSbE84SFZa?=
 =?utf-8?B?STM0MjVnYnMzVDVtUEJwRkVDV0FhRklpeEZyc0UyZmVncGcrbURiOVpkbmdW?=
 =?utf-8?B?VDVrNFo4ajlUNUx4NXBPMUtOSW0rV3NTU2M2N0F0M1RkYXpHUWw4Z293WHJB?=
 =?utf-8?B?ci9HclBRT2xJWmhnbzZVRjh0NjZyV0pPRHZ0SWRSUEtDdVdKVVp5NlV0WnM1?=
 =?utf-8?B?a2xtUGZ6Mlg3M3hCRW9PNnlCQTZDMmZINXhFNjFBZlVDalZHYWFOUmQzMHNi?=
 =?utf-8?B?cUdNMmRWSHgwc1o0L0F5cHNubFd1emJ5aDJ1TCs4TXAzVnhrUXlnTDJZd1Vn?=
 =?utf-8?B?R2VQd0NKR3Zwek5VempjS3N5dDdZdFgyS0JDc3NXaVNRSkRLSk9YZE9wZDRw?=
 =?utf-8?B?K1IyK1RMQjdiMzgzbzhpMDBIZXVJaFd5K25OZWNHeHlmcUJFcXQ2RkN6WGV0?=
 =?utf-8?B?OW9BdFJlVThoVW13SHFRTmRXV0VFNlZwU1dyOE8yVTJTTmFXSjJlVjM0cE1Z?=
 =?utf-8?B?bDV6WGRyVzN5bFRZc2FRR0NkVVZrUlk5NHhGc0F3dlQ4bmxMNHV0d1RjL3hR?=
 =?utf-8?B?eVBIaTIxOHB5bWRhSnlrWVBNRWlIejgxQlpRb2hjQ0RaTEtQTTE5NE5tTWdL?=
 =?utf-8?B?Vlo3Q1pkNXNTVHh5V2czWUZrVHQ1ZjRVcmlMMFd3bFhybldTMWVKbEt2cXNw?=
 =?utf-8?B?YmxFSTQ3RUt0QytUZE5MTlQ4MTllUkMvUHFaeXJtY08yYy9oVnowbDZ4UDdB?=
 =?utf-8?B?REYxME1MUlJWNTNVMWxRaTBUbEVpTjZZaFBZWkhLaWovdVRXZmVZQzcyTmhj?=
 =?utf-8?B?SndQSGRZWklDc2kzWjhpWCsvSjBmSUpWaVVJZktWRHU1YkpuaEZwYjRCM2dw?=
 =?utf-8?B?TWRqQmh0c2F5bmxEQ3lVd2pzSGlBMnRpREVPNTRTRzVTclJxTHp3QURFdERG?=
 =?utf-8?B?ZVRHQmY4bFRZL0Z2RUg3aUpuVTQyUTFyRE1MNDRTei9XSEZURmsrZVdTUG9H?=
 =?utf-8?B?bHg1c2NwbElDWUNNSTQ2WlNNV1JoQmRXeW1KL0NDVlVmVnZiNUI5ZmlkWWZ2?=
 =?utf-8?B?MmNCZWhGYVNCZUpsTzlKQi9UK1B6T1pOb1dUUVFkNU4vYSs1UTJsTzNWWW1D?=
 =?utf-8?B?V294ZmpXYjhmeG5IOVMweVh6RmRPY1RVQlVyTXJLWnVRSmp1TGtpbDhHMDMv?=
 =?utf-8?B?ZVRXcGdHVDU1TFVtSVcwNDhqYzdyNVFEUFN3VGJuU3dTNDJMZWVwRUVLOWg5?=
 =?utf-8?B?V1ZvbUc2TFlyZHN3WHprTHFnaTI5WkJSbFRkR0doa2dEdlgzVzBqL2s4L2hO?=
 =?utf-8?B?N255YnVXTFFqajZteWRUZEVWR3QzcGdNYStpQ3VYZ3pHRExxTEQxeHpOL20z?=
 =?utf-8?B?UmcwZ1Btc21temFkc2FETGxyWkI5eXRxUDlFbDNDejFmRHhRellSRXUwRWlj?=
 =?utf-8?B?aXlET096eDlnam54MGtRWEhyU0xlL29TYjRCM2xTcWd2RlQ1bk01c0JvVGdE?=
 =?utf-8?B?dmF5MlNDNWRiajBoQjN5YlhvQ1dicndjYU5zdDM5WHA5eXhIaDZKbjJac1gw?=
 =?utf-8?B?dGd3eHByeXNCWFNueVZzakJiVVQzVlJic002MThna1NiTEJkZVROVUdmZ2RK?=
 =?utf-8?B?Qllia3pKTTBycjRoT29rYW0xY0dUeGRXL2RmTnVHRHJxUkZPazl3YVNlaEoz?=
 =?utf-8?B?eHEzRHd4T05HVFlPcmR3bGNoQlpMNU9RVEI3RXJaSlc3SjVqa1NnUCtwMytU?=
 =?utf-8?B?YjZHcmlQZjdFS3c5MWVhVkNGdHdabnAxejY0c0xFcmgvUWxXVGtrM2U0S3Fa?=
 =?utf-8?B?VVFQeTd2bjJSM0VZVVArcFhnRXpOWVNVKzMrOVExZUdVUHpmb1ArdEUrSVQw?=
 =?utf-8?B?dWg3ZEdDcjlQQ3N5TW42NzZpVWVnNzAxSnZxdXVia05hendnVUMyNnF5TWJM?=
 =?utf-8?B?ZFNhMVNOVXFRcEhncmwvRlJTbStnR08wWHI0VUJ2WCtMQXp4bkZ6aStNb2gx?=
 =?utf-8?B?a1pLY3NXQjcrbWNCWGZFUHlBeERSQk9BVjZCUVVKWndIWkdFYUUwUHZNRVFn?=
 =?utf-8?Q?k2zfGv1+27DclvtGH+C4E8m+S?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddaea76e-6fa3-4d6c-bcaa-08dad8f1b7db
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2022 07:56:30.9386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gbl78Qv19JpMbDHiyci/+evUHlP/wN0NHHWGJU4qInWzVFyluxmfTw6LukNmYRamUPvsjCISGeCv5asezy4giw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7426
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
ZW50OiBUaHVyc2RheSwgRGVjZW1iZXIgOCwgMjAyMiA1OjQ1IEFNDQo+IA0KPiBGaXggc2V2ZXJh
bCBsb29zZSBlbmRzIHJlbGF0aXZlIHRvIHJldmVydGluZyBzdXBwb3J0IGZvciB2YWRkciByZW1v
dmFsDQo+IGFuZCB1cGRhdGUuICBNYXJrIGZlYXR1cmUgYW5kIGlvY3RsIGZsYWdzIGFzIGRlcHJl
Y2F0ZWQsIHJlc3RvcmUgbG9jYWwNCj4gdmFyaWFibGUgc2NvcGUgaW4gcGluIHBhZ2VzLCByZW1v
dmUgcmVtYWluaW5nIHN1cHBvcnQgaW4gdGhlIG1hcHBpbmcNCj4gY29kZS4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+DQo+
IC0tLQ0KPiANCj4gVGhpcyBhcHBsaWVzIG9uIHRvcCBvZiBTdGV2ZSdzIHBhdGNoWzFdIHRvIGZ1
bGx5IHJlbW92ZSBhbmQgZGVwcmVjYXRlDQo+IHRoaXMgZmVhdHVyZSBpbiB0aGUgc2hvcnQgdGVy
bSwgZm9sbG93aW5nIHRoZSBzYW1lIG1ldGhvZG9sb2d5IHdlIHVzZWQNCj4gZm9yIHRoZSB2MSBt
aWdyYXRpb24gaW50ZXJmYWNlIHJlbW92YWwuICBUaGUgaW50ZW50aW9uIHdvdWxkIGJlIHRvIHBp
Y2sNCj4gU3RldmUncyBwYXRjaCBhbmQgdGhpcyBmb2xsb3ctb24gZm9yIHY2LjIgZ2l2ZW4gdGhh
dCBleGlzdGluZyBzdXBwb3J0DQo+IGV4cG9zZXMgdnVsbmVyYWJpbGl0aWVzIGFuZCBubyBrbm93
biB1cHN0cmVhbSB1c2Vyc3BhY2VzIG1ha2UgdXNlIG9mDQo+IHRoaXMgZmVhdHVyZS4NCj4gDQo+
IFsxXWh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8xNjcwMzYzNzUzLTI0OTczOC0yLWdpdC1z
ZW5kLWVtYWlsLQ0KPiBzdGV2ZW4uc2lzdGFyZUBvcmFjbGUuY29tLw0KPiANCg0KUmV2aWV3ZWQt
Ynk6IEtldmluIFRpYW4gPGtldmluLnRpYW5AaW50ZWwuY29tPg0KDQpidHcgZ2l2ZW4gdGhlIGV4
cG9zdXJlIGFuZCBubyBrbm93biB1cHN0cmVhbSB1c2FnZSBzaG91bGQgdGhpcyBiZQ0KYWxzbyBw
dXNoZWQgdG8gc3RhYmxlIGtlcm5lbHM/DQo=
