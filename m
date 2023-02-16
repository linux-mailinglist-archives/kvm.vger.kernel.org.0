Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F00699126
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 11:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjBPK2l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 05:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjBPK2k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 05:28:40 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BA91C7D0;
        Thu, 16 Feb 2023 02:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676543319; x=1708079319;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q2jxAJUukeMdlH1SR30r4JIX6WSE4yZqCUPQPlvIs4k=;
  b=aS2yY2b35UW8gqa6rktCQjgcGmgpVjJucxY4JzFHy2cjSL5HuligT6B/
   9dlptCCVJTDgDOG8FXdt6xeEBH0ZMi3+dhpV3Qw4wAiN1Vq0PsTzngQMJ
   DYjinJk3z96L8EkpFe397izF74If6VAhIl4Lx9WH2yGRvQa6824EYxv9o
   StLmWedFCgMN5dC3glpn/KqG6pAZpNUKkM5aeGYnAl+hwL0uft+Wc4aC+
   y6TtCatz+d354GFw1y1esA0fN5LtaY/JboytEXuPK8T3q3aT6knuA1f45
   N1dsDMtpoZURS/AoD11KyTmv+CkToTmBxIjNimDNhBTctfzWmBJhJtwaA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="417905784"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="417905784"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 02:28:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="844100949"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="844100949"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 16 Feb 2023 02:28:37 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 02:28:37 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 02:28:37 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 02:28:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exNgmtLw93L0EIiS1t3U0LgBj/3vWIN0OmGwQ9CSuFZb2+zcQsj3ps71sX4psNTkZNhemV1w67GZZ0XKFKGYFcO7zq3dWT3/gjCYYjemlgsGQbBICQ1vKOeD4KscbLY803yCQgKGnw6fpS5t2BNrz1AAWoBPJ0pA4siJ210mYAUWhqsoQ8fZNXop+CuB9DcQasGk91u/k10QCz92S+5gTHLyIdM0WucBgILy9OVzTd69PEb1GUg3DvkjvKgeeBRme13xm0X90R8jyOTleTsi5NGjHI3O8qYgsJ7Wa2052yY1kgLnM7RTaW4cMJx6B7xHrXFU50oWZQI0uwY9FDIcCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2jxAJUukeMdlH1SR30r4JIX6WSE4yZqCUPQPlvIs4k=;
 b=TULeV6SKTacfp97TgP/8udwzpqlkTMFNM4qCXePeBSbmw3IW+tQlwD2X+Rs0HT74+q9wzpx2f3K/cSwarhrrdZg5i6485rdNXHghR5iFSCvTNgBtM5w4QJQDFqrPPkWHzROE7+M7CpDfhppH0QgdvNQGjejFdviXScPGBmm6hH6ta4/IzjYvZHVnO+Il4RQ7T8Ca6D+iNTJlcZMtpJLfgr6nzMCSJlrs6E6QLTTTgaWjwMtSN2ZeFqhcG7SNo21/8TCUNWyMt7tMwcNXI2isx/ybzhYm98cmgTR8v4NYHKwhJzttFXZuMZCAxp1ZrKwPkjEt59Cytw+sD03erh2FwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CO1PR11MB5044.namprd11.prod.outlook.com (2603:10b6:303:92::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 10:28:34 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6111.013; Thu, 16 Feb 2023
 10:28:34 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
Subject: RE: [PATCH v3 14/15] vfio: Add ioctls for device cdev using iommufd
Thread-Topic: [PATCH v3 14/15] vfio: Add ioctls for device cdev using iommufd
Thread-Index: AQHZP73TMP7ZzqInoUK0sXtp8iwKVK7RQKyAgAAL3yCAAASGAIAAEEcQ
Date:   Thu, 16 Feb 2023 10:28:33 +0000
Message-ID: <DS0PR11MB752979FC4A54F6459D7A162AC3A09@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230213151348.56451-1-yi.l.liu@intel.com>
 <20230213151348.56451-15-yi.l.liu@intel.com>
 <Y+3oObuMG/v3+x0N@yzhao56-desk.sh.intel.com>
 <SN7PR11MB754074DEC60C9852D42EA4A6C3A09@SN7PR11MB7540.namprd11.prod.outlook.com>
 <Y+31+puocZcGFnSQ@yzhao56-desk.sh.intel.com>
In-Reply-To: <Y+31+puocZcGFnSQ@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CO1PR11MB5044:EE_
x-ms-office365-filtering-correlation-id: 31e6d371-a94e-40f3-c8b3-08db10088e36
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6sT5GjpktkOlrA7Aj67U4qs6MGZqbzoRnL5CTMnOFXP2nuQktaePX4FmRzQiggqU63AJ04StwP+f62XgfUOIdiljCvP9egxUuYFY4LK9+oJNXihTpW7w34CPXXXoNxhhHl8N2P9z0MH3maDnjyxbEfJ5Voo63HiwJG2rIr1tFtFea2QnaYOw07qlw9vby525PPfM05gbX39LIazYJpm/SJ3J939yRwLC+5+vcdmjNpLD2mBy1g8oMVFdZAOE0/Ja3Xme4ReAkeWSYueMMyzEh7cqBu7aB7ZQS9OJpUts1H9qq33iuVdWgutEW2qCheVUt6mKfDm5ysC0uMMsr3mi3thFyA3QnUO0bAx6xEUkmAbLMRl3Ib5oIotozvyTKO+wZeAvPD8F9DFriFO265qIErDV6LXzl/x0yLTV6dAIxhJwMTC2AVtQqoHc+T50yhvPpJ14Bw10JJFTwDPBSxqgjxXqneU3VOf7j7/tq4Ya0mYPPJ6W9WWLL2fe5ii/pLilaT0drXrnLJq3N3djm/Bz2CWkAU/k/le67vCJDy/lWXwBViizSXHZRQ+9dKJYKhOpU9tGnOuCl0xi0RFFbhA8opm/iPBA6B7+TT4Ang+8M8H1YlovVIA+4bbRAyI0WxY0SQT2Fs9+QCHPJ/HChpGlsuZfugP2ygyNw0JsTxLMaJkCLAKBzrUqvDcFhrwVGbDVoLKkInHhStVbpaEEBJH0rA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199018)(83380400001)(7696005)(82960400001)(54906003)(316002)(52536014)(6636002)(38070700005)(9686003)(38100700002)(478600001)(2906002)(6862004)(66946007)(71200400001)(41300700001)(76116006)(8676002)(6506007)(64756008)(4326008)(66476007)(5660300002)(66446008)(55016003)(66556008)(186003)(26005)(122000001)(86362001)(7416002)(8936002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zlpzd1N5UXl1bEhFcnlUTTdBaVFZbTFCZTllVGxVNWJyQTg3SWZZRElabThK?=
 =?utf-8?B?dU1kTTF0NkhBeVlRV0RkdWQ0R0k3SjBHU0FHYW95OWtrcndFbjdaRVJxdWRW?=
 =?utf-8?B?dDM5bldRbmg5c3dzaFplMkJEZzVYM094S0RkL05EZkovNk1tT1YweWFnWlZB?=
 =?utf-8?B?K2JTajZ3MDhRL0dGNVlFc3JsNWw1NlVTYTR2RlFHK2ZPUXBOWlp1TWpBV3dr?=
 =?utf-8?B?MS8wNUxvaGRyOEFvZ2EvbUZPb3prTVNLK3hhVDhlcHZQQlB5TG9SN00rL1ll?=
 =?utf-8?B?VFB6bUw4UjYwT1BpblpJcmFqN1libWJiNkRvSUlSbUVNcXNnOVFMNHhnem9v?=
 =?utf-8?B?c2RNNnlFMWRjNkt3S2tLN3YydDczdURLbFZpN29US0VoOVpWVHMvVVlBZlMz?=
 =?utf-8?B?UWo3T0dXcVVYdzRScHB4UjJQMDRhL2ZrenFDdWNFVmhVWGJ4WmZqMHZEbzNI?=
 =?utf-8?B?V2JXck0vWWRocHdmdm9DN0VjU3haSUVWQVF3K091RWtONEgzQ2kwWlFvbmhY?=
 =?utf-8?B?RnlUSDFOZytUaVZQcUFUYnJva21HR1E3TzJLdXhabllwdUFGMjJwN1VlWlYv?=
 =?utf-8?B?TmErbFpyMGw1THJGR0lkR0J1N0Y5T01RNkp1NmlZMXhsMzJibk1OYk1IdDZo?=
 =?utf-8?B?M3ZYcjlpNHkwMDhMeW9Ub1ltQm9FczVGdmZ4bmlLVHB3Yy9CZ1ViNUlQQ2xP?=
 =?utf-8?B?UHZVT3g3NFhybFBTdTlnL3JTbFZzL1VVaU5Cb0tjdEVHZGZJRnkrSS95dUVz?=
 =?utf-8?B?WndEamtRbldjQWZiYmJMeW1pK1JjK2tZSjJ6ZFJPSnI2eTg3UzBSZThIRVRG?=
 =?utf-8?B?WnFTOTlFOGd1RWVOTTJ3N1ovNVlTSzhJbW1VYmJnbS9QL3FtYXJ6dTBvazlL?=
 =?utf-8?B?dzlQeWVrMXoxVE5BWnNvMmVaVEhtZGdGV3pORG5RTjhZNWhnT2M4UW4vaVNK?=
 =?utf-8?B?aFdZdkd3aHZvUm90bnlEaHZNa2s4elhYZHRjY2RzbHJ1c0wwS3M1WXV0UmpL?=
 =?utf-8?B?Njk0RVVaNTZ4bGVrZjdkMkRXYThuVGsvL0ZkUUg0NzRyV0M1bXlGbTFYcmpU?=
 =?utf-8?B?MkRJZGVlOE5FUjBtUklTa3NKdmlMLzMwS0xRY3lUVHZFZnNWdEw0ZVdKb3VE?=
 =?utf-8?B?bEJaQ2Zpc2tGU1kxT3htc1hwVVBVQ25Lc043RHlvRGkxTWRCelVreVZGOHY2?=
 =?utf-8?B?eGdXM1dOWXZod3gxSGRtRzlOV3d4YWFsV29tV1Z2anFYOHQ1RkdlbzBGSmZp?=
 =?utf-8?B?UTB5SFNiaUFzQU5CY3lXN05LR0xXS3ozdlZJSnBVZDd2WUZFZGpkQ1hWOWJL?=
 =?utf-8?B?YUpGY2Ezc25EYVFQUUdoK1U3RjdFOTY0dHkzVE5WQVU0bno0QnJ2S3ZVYnZ4?=
 =?utf-8?B?NC9GcXg5ektuMGJ1UjhzMStaYmVlNDVnWFprbzdmb1FzQWk1NlROOFM4WURl?=
 =?utf-8?B?MHBJS2pJRnlQTm13RTlPY1hkajFGMTlIRkJwTXJ5Rk0wbm9sWGF2OHNBTkdS?=
 =?utf-8?B?aFlsOTg0ejdWd094dkp0UGw2UmgrcVlOcDRxZFhmcHE2cXYvRFRDVXFlYkVs?=
 =?utf-8?B?dUlPbkpab0NWcWhEbVM2WGlYbVQ3TVppRlAwREwwQkMwanlnVkQxWjlzcnhE?=
 =?utf-8?B?Q04zR2JsZTZXdjgvN0ZRNkdjZFlmN2kwWWRJRkhKbk9TVmZyREdZZkVjbTNX?=
 =?utf-8?B?RXVoNEJ3VitpUzdtQVN0cXVCYWMrZWl6bUp2cnBNSndDUWNucU13UzRpWlMv?=
 =?utf-8?B?NWhrQWFibU1FczZRNDZkZ2dsSjFSeCtnSWJnM3pob0haTmtkY2xhRC9RcFM4?=
 =?utf-8?B?RElIdVZId0x3bjRlWkRYRHFZdm5lLy9ZNzc3N2JGZnNCU1pURkswRG1XQVMx?=
 =?utf-8?B?NDZxZ1l3Sk9yUktSVCtlOGtrQjJYRDdDWkV4dnUvR0tPcG5RTis1bFJjdzl1?=
 =?utf-8?B?Q2Z1cEZYMTF5ZjN4UWV3YmZSQWlaZVdOZlpTTDQ5dmx0STZFS01YVDRkSnNt?=
 =?utf-8?B?MGlMQ2EvUW5lTEJVZlNVdCs0c004NUtPdWk2dDBTOEJ0TmxodE9IUVNRWU5s?=
 =?utf-8?B?eXRlc2hHNjU1S0sxQnUrZ3JMcyttYlM2R3JTMHNVNTVkaHV1Nmovdk1GUzlq?=
 =?utf-8?Q?d+ztwsL6liP7xHNUGpS4lwDE7?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e6d371-a94e-40f3-c8b3-08db10088e36
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 10:28:33.4169
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eV6FVBbGXXaVSQ2MsG1fAoEy+L5K/cc7FFFjsp5QB/WEqRdeCBcH/iOo+zq3xfd+msVis4CoMicsdOgton4q+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5044
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBaaGFvLCBZYW4gWSA8eWFuLnkuemhhb0BpbnRlbC5jb20+DQo+IFNlbnQ6IFRodXJz
ZGF5LCBGZWJydWFyeSAxNiwgMjAyMyA1OjIzIFBNDQo+IA0KPiBPbiBUaHUsIEZlYiAxNiwgMjAy
MyBhdCAwNToxMDowNlBNICswODAwLCBMaXUsIFlpIEwgd3JvdGU6DQo+ID4gPiBGcm9tOiBaaGFv
LCBZYW4gWSA8eWFuLnkuemhhb0BpbnRlbC5jb20+DQo+ID4gPiBTZW50OiBUaHVyc2RheSwgRmVi
cnVhcnkgMTYsIDIwMjMgNDoyNCBQTQ0KPiA+ID4NCj4gPiA+IE9uIE1vbiwgRmViIDEzLCAyMDIz
IGF0IDA3OjEzOjQ3QU0gLTA4MDAsIFlpIExpdSB3cm90ZToNCj4gPiA+IC4uLg0KPiA+ID4NCj4g
PiA+ID4gK2xvbmcgdmZpb19kZXZpY2VfaW9jdGxfYmluZF9pb21tdWZkKHN0cnVjdCB2ZmlvX2Rl
dmljZV9maWxlICpkZiwNCj4gPiA+ID4gKwkJCQkgICAgdW5zaWduZWQgbG9uZyBhcmcpDQo+ID4g
PiA+ICt7DQo+ID4gPiA+ICsJc3RydWN0IHZmaW9fZGV2aWNlICpkZXZpY2UgPSBkZi0+ZGV2aWNl
Ow0KPiA+ID4gPiArCXN0cnVjdCB2ZmlvX2RldmljZV9iaW5kX2lvbW11ZmQgYmluZDsNCj4gPiA+
ID4gKwlzdHJ1Y3QgaW9tbXVmZF9jdHggKmlvbW11ZmQgPSBOVUxMOw0KPiA+ID4gPiArCXN0cnVj
dCBmZCBmOw0KPiA+ID4gPiArCXVuc2lnbmVkIGxvbmcgbWluc3o7DQo+ID4gPiA+ICsJaW50IHJl
dDsNCj4gPiA+ID4gKw0KPiA+ID4gPiArCW1pbnN6ID0gb2Zmc2V0b2ZlbmQoc3RydWN0IHZmaW9f
ZGV2aWNlX2JpbmRfaW9tbXVmZCwgb3V0X2RldmlkKTsNCj4gPiA+ID4gKw0KPiA+ID4gPiArCWlm
IChjb3B5X2Zyb21fdXNlcigmYmluZCwgKHZvaWQgX191c2VyICopYXJnLCBtaW5zeikpDQo+ID4g
PiA+ICsJCXJldHVybiAtRUZBVUxUOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsJaWYgKGJpbmQuYXJn
c3ogPCBtaW5zeiB8fCBiaW5kLmZsYWdzKQ0KPiA+ID4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4g
PiA+ID4gKw0KPiA+ID4gPiArCWlmICghZGV2aWNlLT5vcHMtPmJpbmRfaW9tbXVmZCkNCj4gPiA+
ID4gKwkJcmV0dXJuIC1FTk9ERVY7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwlyZXQgPSB2ZmlvX2Rl
dmljZV9jbGFpbV9ncm91cChkZXZpY2UpOw0KPiA+ID4gPiArCWlmIChyZXQpDQo+ID4gPiA+ICsJ
CXJldHVybiByZXQ7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwltdXRleF9sb2NrKCZkZXZpY2UtPmRl
dl9zZXQtPmxvY2spOw0KPiA+ID4gPiArCS8qDQo+ID4gPiA+ICsJICogSWYgYWxyZWFkeSBiZWVu
IGJvdW5kIHRvIGFuIGlvbW11ZmQsIG9yIGFscmVhZHkgc2V0IG5vaW9tbXUNCj4gPiA+ID4gKwkg
KiB0aGVuIGZhaWwgaXQuDQo+ID4gPiA+ICsJICovDQo+ID4gPiA+ICsJaWYgKGRmLT5pb21tdWZk
IHx8IGRmLT5ub2lvbW11KSB7DQo+ID4gPiA+ICsJCXJldCA9IC1FSU5WQUw7DQo+ID4gPiA+ICsJ
CWdvdG8gb3V0X3VubG9jazsNCj4gPiA+ID4gKwl9DQo+ID4gPiA+ICsNCj4gPiA+ID4gKwkvKiBp
b21tdWZkIDwgMCBtZWFucyBub2lvbW11IG1vZGUgKi8NCj4gPiA+ID4gKwlpZiAoYmluZC5pb21t
dWZkIDwgMCkgew0KPiA+ID4gPiArCQlpZiAoIWNhcGFibGUoQ0FQX1NZU19SQVdJTykpIHsNCj4g
PiA+ID4gKwkJCXJldCA9IC1FUEVSTTsNCj4gPiA+ID4gKwkJCWdvdG8gb3V0X3VubG9jazsNCj4g
PiA+ID4gKwkJfQ0KPiA+ID4gPiArCQlkZi0+bm9pb21tdSA9IHRydWU7DQo+ID4gPiA+ICsJfSBl
bHNlIHsNCj4gPiA+ID4gKwkJZiA9IGZkZ2V0KGJpbmQuaW9tbXVmZCk7DQo+ID4gPiBIZXJlLCB0
aGUgaW9tbXVmZCBmaWxlIGNvdW50ICsgMSwNCj4gPiA+DQo+ID4gPiA+ICsJCWlmICghZi5maWxl
KSB7DQo+ID4gPiA+ICsJCQlyZXQgPSAtRUJBREY7DQo+ID4gPiA+ICsJCQlnb3RvIG91dF91bmxv
Y2s7DQo+ID4gPiA+ICsJCX0NCj4gPiA+ID4gKwkJaW9tbXVmZCA9IGlvbW11ZmRfY3R4X2Zyb21f
ZmlsZShmLmZpbGUpOw0KPiA+ID4gaW9tbXVmZCBmaWxlIGNvdW50ICsgMSwgYWdhaW4NCj4gPiA+
DQo+ID4gPiA+ICsJCWlmIChJU19FUlIoaW9tbXVmZCkpIHsNCj4gPiA+ID4gKwkJCXJldCA9IFBU
Ul9FUlIoaW9tbXVmZCk7DQo+ID4gPiA+ICsJCQlnb3RvIG91dF9wdXRfZmlsZTsNCj4gPiA+ID4g
KwkJfQ0KPiA+ID4gPiArCX0NCj4gPiA+ID4gKw0KPiA+ID4gPiArCS8qDQo+ID4gPiA+ICsJICog
QmVmb3JlIHRoZSBkZXZpY2Ugb3BlbiwgZ2V0IHRoZSBLVk0gcG9pbnRlciBjdXJyZW50bHkNCj4g
PiA+ID4gKwkgKiBhc3NvY2lhdGVkIHdpdGggdGhlIGRldmljZSBmaWxlIChpZiB0aGVyZSBpcykg
YW5kIG9idGFpbiBhDQo+ID4gPiA+ICsJICogcmVmZXJlbmNlLiBUaGlzIHJlZmVyZW5jZSBpcyBo
ZWxkIHVudGlsIGRldmljZSBjbG9zZWQuIFNhdmUNCj4gPiA+ID4gKwkgKiB0aGUgcG9pbnRlciBp
biB0aGUgZGV2aWNlIGZvciB1c2UgYnkgZHJpdmVycy4NCj4gPiA+ID4gKwkgKi8NCj4gPiA+ID4g
Kwl2ZmlvX2RldmljZV9nZXRfa3ZtX3NhZmUoZGYpOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsJZGYt
PmlvbW11ZmQgPSBpb21tdWZkOw0KPiA+ID4gPiArCXJldCA9IHZmaW9fZGV2aWNlX29wZW4oZGYs
ICZiaW5kLm91dF9kZXZpZCwgTlVMTCk7DQo+ID4gPiBpb21tdWZkIGZpbGUgY291bnQgKyAxIGlu
IGlvbW11ZmRfZGV2aWNlX2JpbmQgZm9yIGZpcnN0IG9wZW4uDQo+ID4gPg0KPiA+ID4gPiArCWlm
IChyZXQpDQo+ID4gPiA+ICsJCWdvdG8gb3V0X3B1dF9rdm07DQo+ID4gPiA+ICsNCj4gPiA+ID4g
KwlyZXQgPSBjb3B5X3RvX3VzZXIoKHZvaWQgX191c2VyICopYXJnICsNCj4gPiA+ID4gKwkJCSAg
IG9mZnNldG9mZW5kKHN0cnVjdCB2ZmlvX2RldmljZV9iaW5kX2lvbW11ZmQsDQo+ID4gPiBpb21t
dWZkKSwNCj4gPiA+ID4gKwkJCSAgICZiaW5kLm91dF9kZXZpZCwNCj4gPiA+ID4gKwkJCSAgIHNp
emVvZihiaW5kLm91dF9kZXZpZCkpID8gLUVGQVVMVCA6IDA7DQo+ID4gPiA+ICsJaWYgKHJldCkN
Cj4gPiA+ID4gKwkJZ290byBvdXRfY2xvc2VfZGV2aWNlOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsJ
aWYgKGlvbW11ZmQpDQo+ID4gPiA+ICsJCWZkcHV0KGYpOw0KPiA+ID4gQnV0LCBvbmx5IG9uZSBm
aWxlIGNvdW50IGlzIHB1dC4NCj4gPg0KPiA+IEdvb2QgY2F0Y2ghIFllcyBpdCBpcyBtaXNzZWQu
IEFuZCBuZWVkcyB0byBjYWxsIGlvbW11ZmRfY3R4X3B1dCgpDQo+ID4gaW4gdmZpb19kZXZpY2Vf
Y2Rldl9jbG9zZSgpIGFzIHdlbGwuDQo+IElmIEkgcmVhZCBjb3JyZWN0bHksIGlvbW11ZmRfZGV2
aWNlX2JpbmQoKSBpbiB0aGUgZmlyc3Qgb3BlbiB3aWxsDQo+IGdldCB0aGUgcmVmZXJlbmNlIHRo
cm91Z2ggaW9tbXVmZF9jdHhfZ2V0KGljdHgpIGFuZA0KPiBpb21tdWZkX2RldmljZV9kZXN0cm95
KCkgaW4gdGhlIGxhc3QgY2xvc2Ugd2lsbCBkbyB0aGUgaW9tbXVmZF9jdHhfcHV0KCkuDQoNCkFo
YSwgZnVuY3Rpb25hbGx5IG5vIHByb2JsZW0uIEV2ZW4gc3RvcmluZyBpb21tdWZkX2N0eCBpbiBk
ZiB3aXRob3V0DQphbiBleHBsaWNpdCBnZXQgZm9yIGlvbW11ZmRfY3R4IGlzIGZpbmUgc2luY2Ug
aW9tbXVmZF9kZXZpY2VfYmluZCgpDQpoYXMgYW4gaW1wbGljaXRseSBnZXQgZm9yIGlvbW11ZmRf
Y3R4LiBCdXQgaXQgYXBwZWFycyB0byBiZSBiZXR0ZXIgdG8NCmhhdmUgYW4gZXhwbGljaXQgZ2V0
Lg0KDQpIb3dldmVyLCBJIG5lZWQgdG8gYWRtaXQsIHlvdXIgZml4IGNhbiByZWR1Y2UgdGhlIHJl
ZmVyZW5jZSBvZiBpb21tdWZkIGZpbGUuDQpUaGlzIG1heSBhdm9pZCBmaWxlIHJlZmVyZW5jZSBj
b3VudGluZyBvdmVyZmxvdyBpZiB0aGVyZSBhcmUgbXVsdGlwbGUgZGV2aWNlcw0KYXNzaWduZWQg
dG8gYW4gYXBwbGljYXRpb24uIEknbSBub3Qgc3VyZSBob3cgcG9zc2libGUgaXQgaXMgdGhvdWdo
LiDwn5iKIEknbGwgc2VlDQppZiBBbGV4IG9yIEphc29uIGhhdmUgYW55IHByZWZlcmVuY2UuDQoN
ClJlZ2FyZHMsDQpZaSBMaXUNCg0KPiBBcyB2ZmlvX2RldmljZV9pb2N0bF9iaW5kX2lvbW11ZmQo
KSBpc24ndCBwYXJpbmcgd2l0aA0KPiB2ZmlvX2RldmljZV9jZGV2X2Nsb3NlKCksIEkgdGhpbmsg
dGhlIGZpeCBiZWxvdyBpcyBzaW1wbGVyIDopDQo+IA0KPiA+ID4gTmVlZCBhIHBhcmluZyBpb21t
dWZkX2N0eF9wdXQoKSBhZnRlciBhIHN1Y2Nlc3NmdWwNCj4gPiA+IGlvbW11ZmRfY3R4X2Zyb21f
ZmlsZSgpDQo+ID4gPiBhYm92ZSB0byBhdm9pZCBpb21tdWZkX2ZvcHNfcmVsZWFzZSgpIG5ldmVy
IGJlaW5nIGNhbGxlZC4NCj4gPiA+DQo+ID4gPiBlLmcuDQo+ID4gPg0KPiA+ID4gQEAgLTEyMjIs
MTEgKzEyMjYsMTMgQEAgc3RhdGljIGxvbmcNCj4gPiA+IHZmaW9fZGV2aWNlX2lvY3RsX2JpbmRf
aW9tbXVmZChzdHJ1Y3QgdmZpb19kZXZpY2VfZmlsZSAqZGYsDQo+ID4gPiAgICAgICAgICAgICAg
ICAgICAgICAgICByZXQgPSAtRUJBREY7DQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICBn
b3RvIG91dF91bmxvY2s7DQo+ID4gPiAgICAgICAgICAgICAgICAgfQ0KPiA+ID4gICAgICAgICAg
ICAgICAgIGlvbW11ZmQgPSBpb21tdWZkX2N0eF9mcm9tX2ZpbGUoZi5maWxlKTsNCj4gPiA+ICAg
ICAgICAgICAgICAgICBpZiAoSVNfRVJSKGlvbW11ZmQpKSB7DQo+ID4gPiAgICAgICAgICAgICAg
ICAgICAgICAgICByZXQgPSBQVFJfRVJSKGlvbW11ZmQpOw0KPiA+ID4gICAgICAgICAgICAgICAg
ICAgICAgICAgZ290byBvdXRfcHV0X2ZpbGU7DQo+ID4gPiAgICAgICAgICAgICAgICAgfQ0KPiA+
ID4gKyAgICAgICAgICAgICAgIGlvbW11ZmRfY3R4X3B1dChpb21tdWZkKTsNCj4gPg0KPiA+IFNp
bmNlIGlvbW11ZmQgaXMgcmVjb3JkZWQgaW4gZGYsIHNvIG5lZWRzIHRvIGhvbGQgcmVmY291bnQg
dGlsbA0KPiA+IGRmLT5pb21tdWZkPU5VTEw7DQo+ID4NCj4gPg0KPiA+ID4gICAgICAgICB9DQo+
ID4gPg0KPiA+ID4gICAgICAgICAvKiBkZi0+a3ZtIGlzIHN1cHBvc2VkIHRvIGJlIHNldCBpbiB2
ZmlvX2RldmljZV9maWxlX3NldF9rdm0oKSAqLw0KPiA+ID4NCj4gPiA+ID4gKwllbHNlIGlmIChk
Zi0+bm9pb21tdSkNCj4gPiA+ID4gKwkJZGV2X3dhcm4oZGV2aWNlLT5kZXYsICJ2ZmlvLW5vaW9t
bXUgZGV2aWNlIHVzZWQgYnkgdXNlcg0KPiA+ID4gIg0KPiA+ID4gPiArCQkJICIoJXM6JWQpXG4i
LCBjdXJyZW50LT5jb21tLA0KPiA+ID4gdGFza19waWRfbnIoY3VycmVudCkpOw0KPiA+ID4gPiAr
CW11dGV4X3VubG9jaygmZGV2aWNlLT5kZXZfc2V0LT5sb2NrKTsNCj4gPiA+ID4gKwlyZXR1cm4g
MDsNCj4gPiA+ID4gKw0KPiA+ID4gPiArb3V0X2Nsb3NlX2RldmljZToNCj4gPiA+ID4gKwl2Zmlv
X2RldmljZV9jbG9zZShkZik7DQo+ID4gPiA+ICtvdXRfcHV0X2t2bToNCj4gPiA+ID4gKwlkZi0+
aW9tbXVmZCA9IE5VTEw7DQo+ID4gPiA+ICsJZGYtPm5vaW9tbXUgPSBmYWxzZTsNCj4gPiA+ID4g
Kwl2ZmlvX2RldmljZV9wdXRfa3ZtKGRldmljZSk7DQo+ID4gPiA+ICtvdXRfcHV0X2ZpbGU6DQo+
ID4gPiA+ICsJaWYgKGlvbW11ZmQpDQo+ID4gPiA+ICsJCWZkcHV0KGYpOw0KPiA+ID4gPiArb3V0
X3VubG9jazoNCj4gPiA+ID4gKwltdXRleF91bmxvY2soJmRldmljZS0+ZGV2X3NldC0+bG9jayk7
DQo+ID4gPiA+ICsJdmZpb19kZXZpY2VfcmVsZWFzZV9ncm91cChkZXZpY2UpOw0KPiA+ID4gPiAr
CXJldHVybiByZXQ7DQo+ID4gPiA+ICt9DQo+ID4gPiA+ICsNCg==
