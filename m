Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065EA6381FE
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 02:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiKYBH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 20:07:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiKYBHZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 20:07:25 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B927718E1D;
        Thu, 24 Nov 2022 17:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669338445; x=1700874445;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6okoeM1kQTU78CMA0xUjdORfpQusaYgjdSwFAeuGOus=;
  b=enzGwCjJyHSlmyZt10fNY8RUduEXYFdZbv2s3QBBB/qkwuP3Rqbf3nui
   RcX30YvQhz46MQeygKDefuhFn5GIHmW8hCVG/m+iBl9yoqSRmp1Oc4n8t
   WJaGO1ILee46dMkjsMcg9Hdx3z55Mn2C5vyPDXcCeM33TKnw84dThqVMN
   RmZ8Jy8LhqtAQgfhx0pxkBeeGzPyPcg+Rc83/ki9sRfigvhkZycPeLlvA
   2ci/nxT1lv/GHwvqrXM5076SyFXNUwMHDYbwwNe5BsOnzQtg0O20S+bho
   Twh7gE6r47Wg/szNUJDh8YeTJmYmXTeqUFKyFoeU/c/JzMmNiPWCWLhi5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="316208605"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="316208605"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 17:07:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="784782549"
X-IronPort-AV: E=Sophos;i="5.96,191,1665471600"; 
   d="scan'208";a="784782549"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 24 Nov 2022 17:07:12 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 17:07:12 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 24 Nov 2022 17:07:12 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 24 Nov 2022 17:07:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mw8jDO4re/a6oP7URzyz5eUpweFg+fopfqJ7lmSHnROLytG75FCD2HzWARHMJQRJ5ujV2IvH8BphuUEGRdVq7Nx8YOOY7wHf+QxjTXAtTdns9dULPjhF/9FRYZcveLJlrpK45ChAIFvkJkcIPrJccWZ6dP8/Q4TkPuhDQZtCgl4KxdwkxwWQmAGGDj+m4Qc/hT8orM9FOYwoEH8NrsB67yt9Zig0x+6YQnsakTj9xM7LSbK6h+4WcaL/NHPxQiOJ3wMgbWxY9OBb+9GiWZoFp8KFGqp6ekEcjGZpeT+EvpVoUPQOLoGjYw7DctEB9ZYbTTU960aHV1Uq8RGcHGxG3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6okoeM1kQTU78CMA0xUjdORfpQusaYgjdSwFAeuGOus=;
 b=UfLUFJoZpRYHqyOSe+jDPPObFnmIN6Z8OEWJuoqZfycsqmm5xFPUmFniDUKrHMRWTfG0wiObsfGACNwvynYYTUscG958rFltn8ioX3WjqTQwM9ng7W+TK+LsdoHeWk18DhHiWltneyd99S5P8nrGE7ujT3Bb23+BPqWZg5EtCsR99ZpEz8887Cwjuc74Bkd8rKLfDcORa6quGccUZ3END+ZFDU/7KeJzjnXd+p1nkzdWCG9i4LGddxz7OydlNszyZ80Uo6FPCXAZ+AacM2CckFmjJu4SdCEQurBJckTht8U0pUJK2gKLF2crcQUuHjubFjZIVLuQinQGwxjhTIihrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5415.namprd11.prod.outlook.com (2603:10b6:208:315::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 01:07:09 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::2fb7:be18:a20d:9b6e%8]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 01:07:09 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v10 035/108] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Thread-Topic: [PATCH v10 035/108] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Thread-Index: AQHY7ChybP3VDS//1EK2niE1cyNWwq5KVsuAgASWdoD///+UAIAACSUA///9ywCAAAhjgA==
Date:   Fri, 25 Nov 2022 01:07:09 +0000
Message-ID: <1ad20facd81dd346e00ff686ae4a0550123de851.camel@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
         <f1c9996fa4f4bc71b3feee8407d247aeabb8968e.1667110240.git.isaku.yamahata@intel.com>
         <Y3wvhWyIKNzczFov@yzhao56-desk.sh.intel.com>
         <887a77acc9bf96f7c7bea519ab7ebdd27fb67985.camel@intel.com>
         <Y4AIYGGEU3BdrQgV@yzhao56-desk.sh.intel.com>
         <8e14a7732a2d873846d07c4ec467fb7c48b2307f.camel@intel.com>
         <Y4AOMo00B0vlQfIU@yzhao56-desk.sh.intel.com>
In-Reply-To: <Y4AOMo00B0vlQfIU@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5415:EE_
x-ms-office365-filtering-correlation-id: 63557199-4b3d-4145-590a-08dace8160c7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y7oEQQYzgjtxCeP1yxVe6YTO+tzfz3YmLHCzG4QXm6iCYFd/OI9fOn4sdYgYVvJKZvwaUrHbcc2a32gCbaYBwekcRw22eKDteUqYeKMMZndeZXxNcTrkdleiphPJ8mLBOiJd09SKJXqF1Ai5oCASr0ze0zwyTqD0kdgSMFffv+B/ZxRYxonf7FrfXmyr9adHulsdWhJ92iUIO5s9ous1PMu4FzCvywFrZbAm9wtCNKZvI5rnyZd8bo31UOv3fsOpRjo5EgFO4cvTMzn+Ms2ywiESlfFlrOha7MJ8QcayHUwwFmWL2eepkQnWoV1s9TqJcrq4ygnDLsOa04gltkiDo14TJMhpEjZ1JdChBEmRP+TMHhVrdMc4ymuqSVxz8ygAIreXMEDrHMe4jfcEgE4bNUp8LcpY+Sx22ZzjCY+U+ydQbezs8Q+1D//2sKFgP67Y59snuRBvkE4ykY2V2/3GRzOab4K08RU9UR5IKF0OivzioVxsvsr/X9aaQozbGo5kzchPcuDsk7hHWztZHr1aFCh0Ss+DKBDxkZMSCHxIQIe5BpLXG+vL1K3hSyaM78mG1fa3JxGqkWbwgLAtc467mwqYiNgkjxcKycNX+dlUJjp8OWpACnbF5kz9k1EY7rQKpCd80P+Co21fb1tGGh0ufi3lx8yHt4d/YEkwWJPjmF32ysib5DfhJ3UH0MSyR14VUysLkS7t0Sv4z7idX/YC5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(136003)(376002)(346002)(451199015)(4001150100001)(2906002)(6862004)(5660300002)(8936002)(316002)(37006003)(6636002)(54906003)(91956017)(36756003)(66556008)(4326008)(66946007)(66476007)(478600001)(41300700001)(76116006)(71200400001)(66446008)(64756008)(8676002)(6486002)(186003)(6506007)(86362001)(2616005)(6512007)(82960400001)(83380400001)(38070700005)(26005)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2JPWWFvbEpUWU5XbnZVbWdxdWZwd0c3WmkxQkp0QUJKSXJpS2lqTEljbWo3?=
 =?utf-8?B?M1M0cjF5OGRaUzBKeXM4UFhDWFV3dkxjU0JIM2tWMzBJc2JSVDQvZFJuS0pU?=
 =?utf-8?B?N1dQNWdJL3kremtENlNSaGdGT2RGUDl4VWZrNklVa1cvUG56Z2k1RWxtMi9Y?=
 =?utf-8?B?RXRpZDhmT0VHSDJYcnFRUWM3Y1U3UVczOTRVa1FrNjlPVjJMdEJraTJzb3Y0?=
 =?utf-8?B?a01MRHR5YWtRMmQreEFqRTJTcS9BNFI2TG9jcFlBeVlWd2F5VkZibmdicG1n?=
 =?utf-8?B?VjNRaXRGL2N0TmdiZGVZM0FGbWlWM2daU2hIaEpsbmFTMFRUSWdyWEF4cExZ?=
 =?utf-8?B?NTBzYWo1Z1Ywa0VHT1d6VFRkeWVJcHNxTDRraHJYejRPM0p2QjhlWDZkR0JB?=
 =?utf-8?B?ams2SVlGMDFwb2k5RWFwVi9QbmlLZEZCZWIyUS9aVzU1T1YyQ0t2eFVkRjNZ?=
 =?utf-8?B?Q3dHQlBIVXlFZktDWTBjVHE1YzdhR2ZCUjkyZkQ4eHJ6cm9nMkhxbkJPd1po?=
 =?utf-8?B?R2plNmJxV3A1R1dRb3I0VFZ0dVA3NTR6NDdoMStUQ1ZVN05KZDhhWUJGT3FG?=
 =?utf-8?B?cjhPcHFDeTg5Q2dNejFTK1BnY0V2Ynl3M1VxYWVIZlVOVUZiTXhLelZIbjJ0?=
 =?utf-8?B?TjBvVUZRTGlJY1ZjK1BqMGYwNVg0UG9sWjJhZ1ExbnBYbmlFZGh2TWh0K2wv?=
 =?utf-8?B?bVB2Qm9ERlBKakVJcFY0VkU0TEdCelFJbFliZXNKcjZ4WGlqeFI3cnBMTWdS?=
 =?utf-8?B?cWJaZEhXQXg2d0M1RXg4ZU5hblBOR0tLU2NnM2xwSFV6MEk2cVJLUTFOZ2kw?=
 =?utf-8?B?T0t1MnNlRGFjNEhNUFNBV1lYUnBWSEFrUE5sRWpJd2tRQWdrdVJ3NStodXFY?=
 =?utf-8?B?cUlhNnkwWmgxNU1LYlFVWncxUW5pdVRCTU5BQ0o5L2I2K3crRHBiZXFXWG96?=
 =?utf-8?B?aGxtdXFMcktka1Z1aW1sdTJSMFp5aE01anZoOGNxSTdDWnRIK0RDVGErdm45?=
 =?utf-8?B?ZUwwaHMrbmVud3ozL1MrWG8rYWVWdnFOblJBdGhrOTNBd1pYWG9aeUV5OXFa?=
 =?utf-8?B?RDBOeEVLYVdMdDJ0ZkZXNXRUSStDc1dtWkZuREp4cHpTdVZyajVNaW84Z25Y?=
 =?utf-8?B?RmpqWG9obHByUzVSaE9taC9teUJCU0trZGwrU2VYUFFsM1N5WFZjcEZvSWdt?=
 =?utf-8?B?NmM4Yzl2UHdpb2ZYaVRORjR5Z0tBbWRYTnp4eThoWmdmeG1KZzg1VjB3UkNx?=
 =?utf-8?B?cU5oMVpnMW9wdUhVZzlIVkhpN1g0TS9vdS9KR2VmNy9SejY5eERYV2c5b1lz?=
 =?utf-8?B?NlRhZzFEblFSVzZRUTR2NVp5MjZGT256SjVQTVBCekFkcCtzcnBsRmY2VnpP?=
 =?utf-8?B?bGhSNVJZaVdHejJFeWRhc28zSmgrS055dFlCU1JUQlJFZlJDRXF6b1VveGFT?=
 =?utf-8?B?SzJITjNSNHZWeUJnN3g1WXRWcTNNTW12S2t3QTU0YW9MQTJvcXRVWVlhR2g4?=
 =?utf-8?B?NXpCOG4yV3krSVVNeVpidHJXRDVGNERVY04wQmV3cmE4RTgwbXR2ZkFsZis3?=
 =?utf-8?B?OXc2TTFzNVBwU2trZ2dPS2lpeXU4Mzh2YWZ0cmVjaWlzcUxnaG5ncVRoUUNE?=
 =?utf-8?B?ZjRtNUdtc0RBTGZRY005RHcvclh5NCtsZXh3dzNSUVdVVzRjRndydkk3c0hW?=
 =?utf-8?B?VVoxcGtNc3ZpUFBBSCtBb2VnZG1Uc0t2Lzh1VFVOS1Z5ZlVvR0hSQzRDby83?=
 =?utf-8?B?eGVTaUFZdUw1d29Hc1NDZXlQditUWXhaZ0ViMHEwRDN4SFk5cjBtdXlBbmtP?=
 =?utf-8?B?QklERGFZZGFIMWRuWUtNU2hocHUwY21ESjVYbnR6UDlPbDhGT0QzcCtlS0Vl?=
 =?utf-8?B?dVFGbkdDNVVvSGZmVjQrRUUvU2JHRkxnd2VtVGJKTmcrM1VPbTBmamh0RUpG?=
 =?utf-8?B?RlZtblZXb0ttWHlnQVlNc2g2SGtSMGluUmN5cGxBU3ZJcENFbGt1VmxKc2NJ?=
 =?utf-8?B?VitPbG8ybnBnTEZka24xTE5LbWFnK3NDY2ZicGJMNDFadTcxQnM3KzZqekEy?=
 =?utf-8?B?azU4TkFGdGduVWxDLytxSWw3T1FiQ1pXa1Q1dm5XVDIvbnlzSzFBQ2J4eEJ4?=
 =?utf-8?B?OHNVWDh1enJxMGRuZGxJZmpNYUM4OUY5ZmxQVjJSMHMyTkhIRHlmUWdLbnVy?=
 =?utf-8?B?d1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <398F48077AC1D9459E090BC8A165F535@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63557199-4b3d-4145-590a-08dace8160c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 01:07:09.5658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8nOZC9Ea6zANc1b9OzDWG4QHolQLzA87iVaaiCGjmhwkRz5EndyUfgKwf8p1S6EdI81cHekSwsYG/99018QEzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5415
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gRnJpLCAyMDIyLTExLTI1IGF0IDA4OjM3ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
RnJpLCBOb3YgMjUsIDIwMjIgYXQgMDg6NDU6MDFBTSArMDgwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiBPbiBGcmksIDIwMjItMTEtMjUgYXQgMDg6MTIgKzA4MDAsIFlhbiBaaGFvIHdyb3RlOg0K
PiA+ID4gT24gRnJpLCBOb3YgMjUsIDIwMjIgYXQgMDg6MTM6NDhBTSArMDgwMCwgSHVhbmcsIEth
aSB3cm90ZToNCj4gPiA+ID4gT24gVHVlLCAyMDIyLTExLTIyIGF0IDEwOjEwICswODAwLCBZYW4g
WmhhbyB3cm90ZToNCj4gPiA+ID4gPiBBbHNvIG1ha2UgZW5hYmxlX21taW9fY2FjaGluZyB0byBi
ZSBhIHBlci1WTSB2YWx1ZT8NCj4gPiA+ID4gPiBBcyBpZiB0aGUgc2hhZG93X21taW9fdmFsdWUg
aXMgMCwgbW1pb19jYWNoaW5nIG5lZWRzIHRvIGJlIGRpc2FibGVkLg0KPiA+ID4gPiANCj4gPiA+
ID4gSWYgSSByZWNhbGwgY29ycmVjdGx5LCBTZWFuIHNhaWQgd2UgY2FuIGRpc2FibGUgVERYIGd1
ZXN0cyBpZiBtbWlvX2NhY2hpbmcgaXMNCj4gPiA+ID4gZGlzYWJsZWQgKHdlIGFsc28gd2lsbCBu
ZWVkIHRvIGNoYW5nZSB0byBhbGxvdyBlbmFibGVfbW1pb19jYWNoaW5nIHRvIHN0aWxsIGJlDQo+
ID4gPiA+IHRydWUgd2hlbiBtbWlvX3ZhbHVlIGlzIDApLg0KPiA+ID4gPiANCj4gPiA+ID4gU0VW
X0VTIGhhcyBzaW1pbGFyIGxvZ2ljOg0KPiA+ID4gPiANCj4gPiA+ID4gdm9pZCBfX2luaXQgc2V2
X2hhcmR3YXJlX3NldHVwKHZvaWQpDQo+ID4gPiA+IHsNCj4gPiA+ID4gDQo+ID4gPiA+IAkuLi4N
Cj4gPiA+ID4gDQo+ID4gPiA+ICAgICAgICAgLyoNCj4gPiA+ID4gICAgICAgICAgKiBTRVYtRVMg
cmVxdWlyZXMgTU1JTyBjYWNoaW5nIGFzIEtWTSBkb2Vzbid0IGhhdmUgYWNjZXNzIHRvIHRoZSBn
dWVzdA0KPiA+ID4gPiAgICAgICAgICAqIGluc3RydWN0aW9uIHN0cmVhbSwgaS5lLiBjYW4ndCBl
bXVsYXRlIGluIHJlc3BvbnNlIHRvIGEgI05QRiBhbmQNCj4gPiA+ID4gICAgICAgICAgKiBpbnN0
ZWFkIHJlbGllcyBvbiAjTlBGKFJTVkQpIGJlaW5nIHJlZmxlY3RlZCBpbnRvIHRoZSBndWVzdCBh
cyAjVkMNCj4gPiA+ID4gICAgICAgICAgKiAodGhlIGd1ZXN0IGNhbiB0aGVuIGRvIGEgI1ZNR0VY
SVQgdG8gcmVxdWVzdCBNTUlPIGVtdWxhdGlvbikuDQo+ID4gPiA+ICAgICAgICAgICovDQo+ID4g
PiA+ICAgICAgICAgaWYgKCFlbmFibGVfbW1pb19jYWNoaW5nKQ0KPiA+ID4gPiAgICAgICAgICAg
ICAgICAgZ290byBvdXQ7DQo+ID4gPiA+IA0KPiA+ID4gDQo+ID4gPiBXb3VsZCBlbmFibGluZyBt
bWlvIGNhY2hpbmcgaW4gcGVyLVZNIGJhc2lzIGJlIGJldHRlcj8NCj4gPiA+IA0KPiA+IA0KPiA+
IFdlIG5lZWQgUGFvbG8vU2VhbiB0byBkZWNpZGUuDQo+ID4gDQo+ID4gVGhlIHRoaW5nIGlzIFRE
WCBndWVzdHMgYWx3YXlzIHJlcXVpcmUgbW1pb19jYWNoaW5nIGJlaW5nIGVuYWJsZWQuICBGb3Ig
Vk1YDQo+ID4gZ3Vlc3RzLCBub3JtYWxseSB3ZSB3aWxsIGFsd2F5cyBlbmFibGUgbW1pb19jYWNo
aW5nIHRvby4gIFNvIEkgdGhpbmsgcGVyLVZNDQo+ID4gYmFzaXMgbW1pb19jYWNoaW5nIGlzIG5v
dCB0aGF0IHVzZWZ1bC4NCj4gV2l0aCBwZXItVk0gYmFzaXMgZW5hYmxpbmcsIEkgdGhpbmsgd2Ug
Y2FuIGdldCByaWQgb2YgdGhlIGt2bV9nZm5fc2hhcmVkX21hc2soa3ZtKQ0KPiBpbiBiZWxvdyBj
b2RlIGFuZCBhbHNvIGluIGhhbmRsZV9hYm5vcm1hbF9wZm4oKQ0KPiANCj4gc3RhdGljIGlubGlu
ZSBib29sIGlzX21taW9fc3B0ZShzdHJ1Y3Qga3ZtICprdm0sIHU2NCBzcHRlKQ0KPiB7DQo+ICAg
ICAgICAgcmV0dXJuIChzcHRlICYgc2hhZG93X21taW9fbWFzaykgPT0ga3ZtLT5hcmNoLnNoYWRv
d19tbWlvX3ZhbHVlICYmDQo+ICAgICAgICAgICAgICAgIGxpa2VseShlbmFibGVfbW1pb19jYWNo
aW5nIHx8IGt2bV9nZm5fc2hhcmVkX21hc2soa3ZtKSk7DQo+IH0NCj4gDQoNCkl0IG5lZWRzIHRv
IGdvIGFueXdheSByZWdhcmRsZXNzIHBlci1WTSBtbWlvX2NhY2hpbmcgb3Igbm90LCBhcyBleHBs
YWluZWQgd2UNCm5lZWQgdG8gY2hhbmdlIHRvIGFsbG93IGVuYWJsZV9tbWlvX2NhY2hpbmcgdG8g
YmUgdHJ1ZSBldmVuIG1taW9fdmFsdWUgaXMgMC4NCg==
