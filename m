Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8F74D11D1
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 09:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344612AbiCHIMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 03:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344821AbiCHIMM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 03:12:12 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350633EBBA;
        Tue,  8 Mar 2022 00:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646727076; x=1678263076;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OtFUdm3eiaBRByDGFoCdCnEMIy9G14/fNcv+creOSII=;
  b=MnXaEtKGRgFwImyfWUrcb3lcbCqX58u1m35FtfN+EBiIiHLGPDffi4zZ
   d+Dhp4jnjOMvRNC3Re7wB/66P0YBjkCEhFfLJtUom8fO+doAmS5GKtHxa
   pkC1PP2Ec348lVY2vR9q5NSoeG/D5NZxnASu+NaCSTK9qsa/1sf8AfIHe
   7pbvGXq3VbE1EhUXvqsC84BPTV+lighoFWfnESb8yv1kh51ECY5kRWCvV
   +JnBhVmyckCX4V9LiIP8CWRsQ8jCaziJNBzbcRBzX7V8wJ9HdvhwGPd9E
   FHvQsyqo1nLN4MDbdZ3ipsTkwn0vFEV9wbwiAv/WRavkbCREFPTTRmPBh
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="242061131"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="242061131"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 00:11:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="595808861"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga008.fm.intel.com with ESMTP; 08 Mar 2022 00:11:14 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 00:11:13 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Tue, 8 Mar 2022 00:11:13 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 8 Mar 2022 00:11:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LYeemP4D3nyRdkiaMFtUymxG8MJgKtMbz7M/QCUcgKsVPbtZo3up7eov49+EXkdWpdNHbQuRl1JSpsJpf4XSwhlgCFE3Lws/TWvnuMaQ6TLg7Ile0/2BAnaK4WB1V102U/Xj43CCqS7gcyrDWwm9StoEQeuuvwmiMeiP4ouWSiWqnO1NxqvOgUpcYdRxdr7FFCOj6pXYH5YvdDH1YxOlGdrDifwLoAmpuvU48VpfvTq8EYD1t+mEUhuTDumpd0mfJ7v5JGIjSYp50+PP3dhpzqwdfqvqBNgWm0LOyjqUzMaP7p83Ri7b88urKYSzGqgQxFwnoDiy/dJfBl0PAzgPEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OtFUdm3eiaBRByDGFoCdCnEMIy9G14/fNcv+creOSII=;
 b=dZE77broxrGa9VKmgZktGIODP/r8rfZEenSO+eFmNXnKYVnmFpQZCYYObI715NxOR+uRCJ+Iwm1VR29bHLFom+UJpW0ZeuFJgeNirnc2HMmmGZfjKwdoPCwa9dKDVovnycoG2SzkXedKN8gz7BabwxFmhmNIZ1Fp9DEY+3PrRU0TZOLsO2ZaupAk94V+YOGkgPFyZN6BFeU1ZzHgQYSmdY9RPeiHS+OCk6dBSm32OyS2JJQ/uIdd0imxAeXMECySs1kWjHThKPzrRdEVZ41NoTOGGe6uDX51wWnBk+0vmRluoyI5yNPZe+7F63ps7vLOUfpSOXL1xumJ4CRfJyFbCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN0PR11MB5744.namprd11.prod.outlook.com (2603:10b6:408:166::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 08:11:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%6]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 08:11:11 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
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
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>,
        Xu Zaibo <xuzaibo@huawei.com>
Subject: RE: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Topic: [PATCH v8 8/9] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Thread-Index: AQHYL1L4gR02rU84FUWBTBG9yRMgBqyvtjoAgASXrICAAAasAIAABpSAgADGSDA=
Date:   Tue, 8 Mar 2022 08:11:11 +0000
Message-ID: <BN9PR11MB5276EBE887402EBE22630BAB8C099@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
        <20220303230131.2103-9-shameerali.kolothum.thodi@huawei.com>
        <20220304205720.GE219866@nvidia.com>
        <20220307120513.74743f17.alex.williamson@redhat.com>
        <aac9a26dc27140d9a1ce56ebdec393a6@huawei.com>
 <20220307125239.7261c97d.alex.williamson@redhat.com>
In-Reply-To: <20220307125239.7261c97d.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83e67d72-ed28-4339-32a3-08da00db3545
x-ms-traffictypediagnostic: BN0PR11MB5744:EE_
x-microsoft-antispam-prvs: <BN0PR11MB57445C9D81A23899E0BEBA638C099@BN0PR11MB5744.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t1c5GnyXBzqzrg+sp1ogwM9oTlu0yEPHu45clDU2M/bgQUX7rAfVxa4R819emeeOK/a74+iXDJpIFQ3OyAeSIF2syzsM6LDTrQnNi/Z/wZ4A57QEA6XYjNqA+7tHMzxEvr5nWT0KuOAy0Xl0dKEMBo9jrM7404XLP0t8VqF6e8MG2D0fi3zAbBd165q0Lrr1a5l8nyGLUyluVCKOz79b0yn/s8ykdremF5/oeSRsGXxmlWNmhDWqPkGhVGrmR36ut+PNnCnoR8KLRls1V6sr6/sDaLsP6jcUlBU8EB2FvqOkMmVZrZIDiceViofJqLaXvyVbyqG4+UTqpFUWbziBug9xRQvJbaYLveCXRfuV9DfpUqN8Em7HZfeM2C1iJmXfnsJ3XqD4DQ79BfYWuiZ2qBSKXIUt3muOOQEA+jHCuhYlJMNQUcvbzeBpN/vqVeLIc7dsvWr4Z4UiBqTXkjlz7tiEFk56N172doUDlXYYjUc4J+dNBZ2fe6yYdbS+vuoAoMqOT+b7dA+j0hFk4ivncZKLrORsiOONZglvb0p51OOiqbVa6l0roPA7/Y+3CN9An0O7pRnAI9MfE6HDEmRGbI78KQBmUdo6s0b1xTB7md5lETQFdZmT1WdGu4pcy9JK9WXAPRnKK4KQd6dPtAk/D9OdgwkClVjvqYVqJo6TpcyqnTgxQx3hK41FO8tCBml4712qvZInHkmSEGUQr2xzVKYbP1YwcGaUnlpATHeYa+w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(316002)(52536014)(26005)(186003)(2906002)(83380400001)(5660300002)(7416002)(55016003)(82960400001)(9686003)(71200400001)(6506007)(7696005)(508600001)(38070700005)(8936002)(86362001)(4326008)(8676002)(76116006)(66476007)(66946007)(64756008)(66446008)(66556008)(54906003)(110136005)(122000001)(38100700002)(60764002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VTFhaGdiM2tMYzNzQkJmRWN6VDAxbURwUWhPWFB6NVYzMlNiWUdNak5BOUIx?=
 =?utf-8?B?dlVIVExvayt4NE43bXNueDhDT2cvUkJ1ay92bjdpWjVreHE4VU1YY0hWU2tw?=
 =?utf-8?B?UHVuZ3NmOEdTeFdDd2ltajdtNTRjdy9mS0NxSGxFVVpMc0hwSXBxM3lrYmZa?=
 =?utf-8?B?c2hhTllnS1RKVVZCaFhLL2s3VkY0TnNySnZuKzgzMlNhSUFSVjcwUXNObnZE?=
 =?utf-8?B?UEVhNC9oeGEveEE0eEpJZUZhZFY5Y0ZyclAwOWc5U2JPaDhoWlpwY21zUk9i?=
 =?utf-8?B?eDVOT2VHakdxWFlvejgvdEpHWUhjVDR5TGdFZFpmMXhaVjhLNytsYldRdjRn?=
 =?utf-8?B?WURBbWVBRHkxZVAxVkt6VlNpdDBjcUxCbmRSWkVjYkIzbmVBNGthOStoM096?=
 =?utf-8?B?MVZzbThHYzZJR1FRTkRrSmtFQkZseCtOV09PUVNlaEdlNDFmS1dBVTI3bzBV?=
 =?utf-8?B?VHh2L3kvd2htOG9TSHd5NFk2R0RML1NIai9HWDVFTGY1SDVKWDNzSzNDL1hK?=
 =?utf-8?B?SGo5eHEwZUR1QlpHZy84MFBtaXNNS1Y3MTZOSEFZUEljNHlZblgwalVIWnl4?=
 =?utf-8?B?bzVDbW13RjBVTi9TZzR2Mmc5UVZiL3hCOEJqanc1cDRCZC9vcWRGN0lxRzJx?=
 =?utf-8?B?cVBmQ01QaGlQaEhtZG5mV1hOb1ZnMWNkd0lkYVlGVXNiT2o1MjRONVVwRUxo?=
 =?utf-8?B?RnUweUxONXJBZlZjOVNoa3FVWDZTdk5zWVUyM2pnTmZmQW1HQUZCYkZFb08x?=
 =?utf-8?B?c3BGSEVzVW9sbXBQSVp6OUwyem5rMU9GZGdXc0NRY0RxWGM5OFlxQ2NlUUV3?=
 =?utf-8?B?b3RIamtEem9XczNFK1ViemxEQ3gvbS93cEhOdUtwMnRXNEIyTFd5dlhZRkRZ?=
 =?utf-8?B?M3RvQklic3h4Rk5CMTZDS0t5U3drM0g4RklCUUIrNUVnbWZTUzJCUHZZcjZM?=
 =?utf-8?B?YktOdGtJQ2RxY3lodVZWNmQ5WThXWjdaZ0IzamUwMklFT2ZjVGYwTUgrT1N4?=
 =?utf-8?B?WlVaNitiM2lMTzl6UXZrQmtGbXN6ZVpjZmllZS9TMXFLRCs3UDhNaGJkMGZW?=
 =?utf-8?B?Qk14c004WkdxSWl5bzB1bCtacVE4MDVtdXQ1TEtGazdSNXZnYUJINmU2dWlD?=
 =?utf-8?B?WEpFQVZrU2FJY3poVUhNN3QxUXhKbnlOM3FIb25pT3FJYTNWcEJITUhQWnpk?=
 =?utf-8?B?d0EvZkVBMGo4TnVCTlMrOGFmbG9WRG5TN1lFL0NoM3RYZGJEMFRSY20vTFdn?=
 =?utf-8?B?bGUyZ0pHU2I3YUZObzNlNXBwNmx2cDkwd3ZMc1FpV3NmZk9EZ0ZRSFJEOFRQ?=
 =?utf-8?B?UCt1bzZ1aFl3c3RYU1loVlNUMnBGdjlHN3JPUmpBSnAxNXhxbFM4SHk3cE4r?=
 =?utf-8?B?Uy9GQlZkbmxIcStZOFc2bzNhODNicHREK3I5T0pCbjNGWGRNNlpMRi9HWDB1?=
 =?utf-8?B?aVozdDNZR21aQ3NrTWNQOUJoYmw0Y3pPOWtkVWhmSUpEc0hOc3c1Z3pUZks3?=
 =?utf-8?B?RzkxT2dDVEcyYUw2ZVovVk51d0xnYnJDeThMZG1BSXZmRHRJRk0zZDNQbkxv?=
 =?utf-8?B?U0RiWXFPVXRyTCtGU3Bqc2kxeldySWlTNFpPSEg3SGdHVHlxYlFEQ1Y5aG9C?=
 =?utf-8?B?M2p2WGd1VkpYVTRkOHpoVzVEY1dBdERHK0VEak95RXdnNnBYMGQxeHB0Qksw?=
 =?utf-8?B?bERTWWpMbHNpNXNOL0FXTHdENksrRFA5cUx1cVhPZ0dPTkFENjRON0cwNExj?=
 =?utf-8?B?VzhsakFUVXJmUzZuakFtOG16K21aZWt5VVZjY1prOEZGUUNJSTNWTkRWWWo5?=
 =?utf-8?B?UzMzVGE5cXRrSmYrWlRTbjNPQTVnNjYzMHVRNTBFeWxwbWFiQUtFcDhJdVBZ?=
 =?utf-8?B?WlE0OHFQcDkvaFhQb0dYMVNqSnNtVFVEbEpIYXgyVUpqMUk2Q0FrNWdHaEV5?=
 =?utf-8?B?TnVvdWZtekFZb3ZpMi9leTdpNjR2dUpUckRLU25BeGNVcWwxWVRONlp0SFgx?=
 =?utf-8?B?SmZ3NndTT0RSczE1K3BBT0JEbk1lY2hiLzlWempBR1RUYVdTcjJtTXRETEFY?=
 =?utf-8?B?TGV3bkdwdklzb3RUMjRJbS9tL3JWb1BjV3dqMW5CWElFTnpxQURFUy9CY3V5?=
 =?utf-8?B?Ykc2bHd3S0RVcDMyUXJjemd4QldMU1FvaGRnZkN2NUVnMytiRzdvSGZVMXNH?=
 =?utf-8?Q?2vRwv6H+KIY3IYVzraqE5ms=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83e67d72-ed28-4339-32a3-08da00db3545
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 08:11:11.7130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gv2fwtXUeGmPjT6MusDnNo0qiqORMMC/UnLQRHpkM+tkSF94w4VtgoUm4n82gpSuojj151WAm0oaj8AT0GEAoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5744
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
ZW50OiBUdWVzZGF5LCBNYXJjaCA4LCAyMDIyIDM6NTMgQU0NCj4gPg0KPiA+ID4gSSB0aGluayB3
ZSBzdGlsbCByZXF1aXJlIGFja3MgZnJvbSBCam9ybiBhbmQgWmFpYm8gZm9yIHNlbGVjdCBwYXRj
aGVzDQo+ID4gPiBpbiB0aGlzIHNlcmllcy4NCj4gPg0KPiA+IEkgY2hlY2tlZCB3aXRoIFppYWJv
LiBIZSBtb3ZlZCBwcm9qZWN0cyBhbmQgaXMgbm8gbG9uZ2VyIGxvb2tpbmcgaW50bw0KPiBjcnlw
dG8gc3R1ZmYuDQo+ID4gV2FuZ3pob3UgYW5kIExpdUxvbmdmYW5nIG5vdyB0YWtlIGNhcmUgb2Yg
dGhpcy4gUmVjZWl2ZWQgYWNrcyBmcm9tDQo+IFdhbmd6aG91DQo+ID4gYWxyZWFkeSBhbmQgSSB3
aWxsIHJlcXVlc3QgTG9uZ2ZhbmcgdG8gcHJvdmlkZSBoaXMuIEhvcGUgdGhhdCdzIG9rLg0KPiAN
Cj4gTWF5YmUgYSBnb29kIHRpbWUgdG8gaGF2ZSB0aGVtIHVwZGF0ZSBNQUlOVEFJTkVSUyBhcyB3
ZWxsLiAgVGhhbmtzLA0KPiANCg0KSSBoYXZlIG9uZSBxdWVzdGlvbiBoZXJlIChzaW1pbGFyIHRv
IHdoYXQgd2UgZGlzY3Vzc2VkIGZvciBtZGV2IGJlZm9yZSkuDQoNCk5vdyB3ZSBhcmUgYWRkaW5n
IHZlbmRvciBzcGVjaWZpYyBkcml2ZXJzIHVuZGVyIC9kcml2ZXJzL3ZmaW8uIFR3byBkcml2ZXJz
DQpvbiByYWRhciBhbmQgbW9yZSB3aWxsIGNvbWUuIFRoZW4gd2hhdCB3b3VsZCBiZSB0aGUgY3Jp
dGVyaWEgZm9yIA0KYWNjZXB0aW5nIHN1Y2ggYSBkcml2ZXI/IERvIHdlIHByZWZlciB0byBhIG1v
ZGVsIGluIHdoaWNoIHRoZSBhdXRob3Igc2hvdWxkDQpwcm92aWRlIGVub3VnaCBiYWNrZ3JvdW5k
IGZvciB2ZmlvIGNvbW11bml0eSB0byB1bmRlcnN0YW5kIGhvdyBpdCB3b3JrcyANCm9yIGFzIGRv
bmUgaGVyZSBqdXN0IHJlbHkgb24gdGhlIFBGIGRyaXZlciBvd25lciB0byBjb3ZlciBkZXZpY2Ug
c3BlY2lmaWMNCmNvZGU/DQoNCklmIHRoZSBmb3JtZXIgd2UgbWF5IG5lZWQgZG9jdW1lbnQgc29t
ZSBwcm9jZXNzIGZvciB3aGF0IGluZm9ybWF0aW9uDQppcyBuZWNlc3NhcnkgYW5kIGFsc28gbmVl
ZCBzZWN1cmUgaW5jcmVhc2VkIHJldmlldyBiYW5kd2lkdGggZnJvbSBrZXkNCnJldmlld2VycyBp
biB2ZmlvIGNvbW11bml0eS4NCg0KSWYgdGhlIGxhdHRlciB0aGVuIGhvdyBjYW4gd2UgZ3VhcmFu
dGVlIG5vIGNvcm5lciBjYXNlIG92ZXJsb29rZWQgYnkgYm90aA0Kc2lkZXMgKGkuZS4gaG93IHRv
IGtub3cgdGhlIGNvdmVyYWdlIG9mIHRvdGFsIHJldmlld3MpPyBBbm90aGVyIG9wZW4gaXMgd2hv
DQpmcm9tIHRoZSBQRiBkcml2ZXIgc3ViLXN5c3RlbSBzaG91bGQgYmUgY29uc2lkZXJlZCBhcyB0
aGUgb25lIHRvIGdpdmUgdGhlDQpncmVlbiBzaWduYWwuIElmIHRoZSBzdWItc3lzdGVtIG1haW50
YWluZXIgdHJ1c3RzIHRoZSBQRiBkcml2ZXIgb3duZXIgYW5kDQpqdXN0IHB1bGxzIGNvbW1pdHMg
ZnJvbSBoaW0gdGhlbiBoYXZpbmcgdGhlIHItYiBmcm9tIHRoZSBQRiBkcml2ZXIgb3duZXIgaXMN
CnN1ZmZpY2llbnQuIEJ1dCBpZiB0aGUgc3ViLXN5c3RlbSBtYWludGFpbmVyIHdhbnRzIHRvIHJl
dmlldyBkZXRhaWwgY2hhbmdlDQppbiBldmVyeSB1bmRlcmx5aW5nIGRyaXZlciB0aGVuIHdlIHBy
b2JhYmx5IGFsc28gd2FudCB0byBnZXQgdGhlIGFjayBmcm9tDQp0aGUgbWFpbnRhaW5lci4NCg0K
T3ZlcmFsbCBJIGRpZG4ndCBtZWFuIHRvIHNsb3cgZG93biB0aGUgcHJvZ3Jlc3Mgb2YgdGhpcyBz
ZXJpZXMuIEJ1dCBhYm92ZQ0KZG9lcyBiZSBzb21lIHB1enpsZSBvY2N1cnJlZCBpbiBteSByZXZp
ZXcuIPCfmIoNCg0KVGhhbmtzDQpLZXZpbg0K
