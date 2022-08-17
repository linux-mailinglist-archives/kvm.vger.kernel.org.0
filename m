Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03267596C84
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 12:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbiHQKB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 06:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiHQKB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 06:01:26 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFA17B1F6
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 03:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660730485; x=1692266485;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=B4R1DFuiXPF+8vAbVc2Fmk+7hqhIln4JuF4CKHbbVhQ=;
  b=k9G6Bx6JBJQsT7nzXlKOijJ1IV4ohgm/cbVyO7hlvsvatyhIgneKPLC+
   IzGh2fulZbJepOSfHqdyQy9Ay56o6mnJ5GtJugwnGhzwXfzSRXcy7D1pA
   UFrdk8O8Bh3JccctmUgNAizzciKIInlvmnsDxHJ2HS6OztV0KkMnMdlHz
   oCDr7bSv9DLG/Du5k0MpOSP687eLmg9IrPsdIxbm5C5s6CjVIpTd6YctK
   mDp0/pSO/4i8UmqSgcN8Ym3fS9e5SvPiqAnWpp0IL4SMOT8VzwI619uYD
   Y0RUovo5OZZJbMVWApnzoDWmycmUoskLM6TF0QrXpzdEkLeFSE6A5hIwn
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="279418429"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="279418429"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 03:01:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="583707566"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 17 Aug 2022 03:01:24 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 17 Aug 2022 03:01:22 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 17 Aug 2022 03:01:21 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 17 Aug 2022 03:01:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 17 Aug 2022 03:01:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6NUGFj4dHr38lhcPioJg8BH0kGRq68FPN5lv8CYillahj1F6ht1FOn3ldas+1+HnjeBcHLIdo43gWNfbBoJ088d8vAH1i/r7me1zYsa60gWPMnTypREbNqYAblTisb12WWMIVhZi1nZcfLGi0XXus/2DgmtUehobo/GBOXP8ZFdR3WxccBpuWdCde4nCh7AEevsO6eQxFn7bih0+qfoMO9M8xBcLljpyv7iH9RXwHBEjZQ7JD5f/KG22KvmzV6YMmTau6ObmTuGV9Ft/dsFc8J4LdIsgUKzzo++O+KFNL2lmY7+To3AwlRHKp4n/XKbDBYVIfW+5d1Q6uJrVgRwZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4R1DFuiXPF+8vAbVc2Fmk+7hqhIln4JuF4CKHbbVhQ=;
 b=TsZsMu0h61GmebT0Y6YWkpgxEMqHRdONx5qsZrPZywi162eESW2QjTufMT1G1RVHW8+FyxwSW8pjqFGoI/ic3q3OD+Si8CP8zG9b9aeAYAVn5EUzQRgKoV3IJ5+lGte5n+PXAqMDxu2IV9YIZqgoM3wW7GTQr1p81BWdKFzo66Tu9js3qGbGLPY3C3d1QogHmK7CxDAA1w9zZDEjVb2BLvBfPXENGrPDI0vl/s+GydyWxYwdILF6RLAWaA00OUDmHXxvni9V7163PAbuzyNgIKcYYhrGl/deBbyXcudDqtwY6dlRC66WM6mjnZHbIy/WqnoVZRrIvWafkjDsxMN9iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MWHPR11MB0029.namprd11.prod.outlook.com (2603:10b6:301:67::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.23; Wed, 17 Aug
 2022 10:01:18 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::1d3c:4dc0:6155:2aee%4]) with mapi id 15.20.5525.010; Wed, 17 Aug 2022
 10:01:18 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "dmatlack@google.com" <dmatlack@google.com>
CC:     "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bp@suse.de" <bp@suse.de>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH 0/9] KVM: x86/mmu: Always enable the TDP MMU when TDP is
 enabled
Thread-Topic: [PATCH 0/9] KVM: x86/mmu: Always enable the TDP MMU when TDP is
 enabled
Thread-Index: AQHYsRl143Sp+fyEHkmbsD65QcPNj62xLuCAgACKCQCAASV5gA==
Date:   Wed, 17 Aug 2022 10:01:18 +0000
Message-ID: <97103b92b9dc1723b1cbfe67ce529a0f065a76ed.camel@intel.com>
References: <20220815230110.2266741-1-dmatlack@google.com>
         <YvtSc9ofTg1z8tt7@worktop.programming.kicks-ass.net>
         <CALzav=eWhg=ZMxVcGf9w_svn1XaTZABN5VoFP3fgxPiHohaMFQ@mail.gmail.com>
In-Reply-To: <CALzav=eWhg=ZMxVcGf9w_svn1XaTZABN5VoFP3fgxPiHohaMFQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6bdd0c27-b49f-41a6-00d8-08da80376df1
x-ms-traffictypediagnostic: MWHPR11MB0029:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qwco/40E8PdRsybYahfocY7KQD/ar3fGH9hMgs+tawVfN7JWI3ks/3SPoy/FCQYNU52sbWdsVHctE+DwzUqPoDdEC1HmXXNIwLJ/+DTT5eB09WBqDg6uzEx72RsFeySRvIiasf+eYLH1EFdICKweJcHzErg6LpBc+PYr4hooBVqdv8zmTEn87CYA6EEzUtEP1F3mpJj5SebX4/J16KiIzo4WSwoce7NbMdhhC1/v8LsmrlMw0AthXRyCM01te2LesOoEj8aDpSyxrEkYAgrfljbzyMV0pvbwpuBtZtgwyJzUUTToJdhtQNzKX6kzrnYqLot/eWJ/diGjGOpuuGonPkWP4FTVYWAiGmH6zxHVhmQz3jYaVcbwzdfNxIf0gRhhDrmMF1fE4mtu0Vi/pr8yII7l3lZDdbJqVNDk4Slsj7QS2ztVXq1Hu3/MT4iS8qPijbe6ovSoetRRib0DWPGfyt8szUV1vTf3ZiSFNX4wNw6W+gJGzuUisK7FdfQqEZ3o6N67FzXyrCWyFXHWuvvtJneueHGG0n5EXhPDBS1IN5mc66WCeA9+SEV1+dkQbkLyk2qomaXEfkjuLnTeGBT0vjPke33AJCjsRTVU0fHt22XsnCDuvkGATZBGL95zFjDh4xCiWjbjQBBt47+CiiaRewpg91cu4jIZojJxN+GZ/W8vqbS0H6LVvaCrkm4SX2CNKq/RPTvCMRYbZXouIZNWrM0NOJ9ZkOJeqzTGysS+4blf2UaC1SJAoViA9Ekf0BfkV6komhnVuTAOoYnWFJzhlc+rwOLB+ICKa8JSAfS4BXhsTolpRPaawPUETfqtcixE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(396003)(136003)(366004)(122000001)(82960400001)(36756003)(38100700002)(86362001)(26005)(6506007)(6512007)(53546011)(83380400001)(38070700005)(186003)(2616005)(316002)(478600001)(54906003)(41300700001)(6486002)(110136005)(64756008)(66476007)(8676002)(7416002)(66446008)(4326008)(66946007)(76116006)(66556008)(91956017)(71200400001)(8936002)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T256Y1JBV3lBRU5lTWcyakhlMVZKS1VJQVhrS3h5UTlRS2sxU1NLL0JTZDZm?=
 =?utf-8?B?eXRnZ3BLZmhTVmJtNUtSaWRuQVVhU1h2UURWVzhlVkY5V1hyb1dFbDIzamlo?=
 =?utf-8?B?WHRMVDU1ZU1QOUZueDBscm1Id2JnQ3pYbENtMURNNUVOaklFQmpFNXRlOGJY?=
 =?utf-8?B?OHRZL2tiRjZ0MnlTTVNqZmVuTWEyR3hpU0ZIK1NKSGtWbXhNT2ZHOVF2U0Nr?=
 =?utf-8?B?VDBFbDNacmF1MjhURFR5dmVYbU93T3BMNHFweVZCZ3phaHVqMEpLNk5JcEFh?=
 =?utf-8?B?TVJZV0oyRERMYXVicjVlYVB6Z2RpT2JkOUdQWEZHWGpTTHkzQWtpSUpSRC9D?=
 =?utf-8?B?WUVtVmllcVEwRDlDdDBHUm1IVjVQdUF5N0tsbzYxaEVVdzJjdDh5c3dXT0VP?=
 =?utf-8?B?UVd6K0NDL1owT3VpMXRNTTBYdm4zS0ZRRElvMm1TbmJYQTR4SkhpNHhMaGhR?=
 =?utf-8?B?b0h6ODdGYlpvQmdXSGl1WHBxNzBEQ0hhemdZUUthYlRmWjZZSVhDc0ZYNFdW?=
 =?utf-8?B?L2U1NElrTWNpTVdzM09iZU1wOGlxU1hER3RCTnk2N0EzL0QzUFRhaENYbGFi?=
 =?utf-8?B?Zyt6L1pYMi92bkxQVHFFZW0yU3ZNQlM0bjhleGltcTd4N2pkeXdLTVA2cC9u?=
 =?utf-8?B?ZUd3NlFRTGRyQnBOTko0cllLcXR4eDNlVFJLb1gzUm56OEYxRDFEcjhDY2lM?=
 =?utf-8?B?aFdnY0UwN3pHRm16akFGN29pQ1o3VWFEVjV0QlZHbmFoRnA5dlpwbjRTNC9J?=
 =?utf-8?B?UWN3bGkxRDNQQjEwKzM3eDJUV0JpZGdZUTVpWG1vd0tlaGRnWmRKVm5CcUZI?=
 =?utf-8?B?cGk4dmcxRllycEJ2MjEzZ3RGaDJNVlBGUWw5bU5FNHQ2T21jT2wrMUsveXRm?=
 =?utf-8?B?elZTR0p4dTRNNkkrM290Ukd1SHVjM0ZUWFo4MC92TzRTUVY4RHVNWDVPWE9y?=
 =?utf-8?B?VXBJeCtRR3o1VHl2a3dTelFhWUF5R0V5QWF0WVdoK1hDdGZlVVBkVm95RjJa?=
 =?utf-8?B?Ry9Dc0NuYTN6MElkK2IrOCs2R2tLL1NXVjVBaWJSK1pHbFFnOE05eXM3VURM?=
 =?utf-8?B?czNyMG1hOE5NcUlFZEVMUWhUcnZoRzFGbUJUWUJ1T3JWWFhaeEhrS3I0MGt0?=
 =?utf-8?B?bFpCZXA1djBORDVqM3o3SnNHVUVzeVRqYVVvUi9hOXJvUVNYcjAreE5KVHVK?=
 =?utf-8?B?dGhlc2ZmYWkvWE5wMkZSa2lvVVZGdFNZRU05aHQvdjRDd3N5a2daWEJUd0sw?=
 =?utf-8?B?R0ZMejZ3U3V2Y1hTWWpwbnYxMDNkdTlGUUt6VmFKQjREYUZKY0pwaUlXMExi?=
 =?utf-8?B?b2YxN29tL21tY0NDenpXNWlmM2oycWNvQW5ZaWQ4WlF6b3R2Ym9wSGdBeWdp?=
 =?utf-8?B?eHRIMGlCNzdXU3lLUUh5TW9UUFdZS3hKUmJaYnJ1MVpYZE1sbnVLOXFzNGFz?=
 =?utf-8?B?NkY3M0hRalBDcXAwUWtlY2FaSVJTZEx6S29qeWNqcnpEenlDR24rK2F6MXhm?=
 =?utf-8?B?WS9Ld3ZDVGV6bVVqN3I3aUxtYTJBQzZtWlBqS1d6T0JDQ1MwY0JYRXdNakha?=
 =?utf-8?B?TGI4TDlLWnRZVWNmekF0N3M2TTJBMS81d2ZVSktHZ3gvMXc5RXBKNWZ1V2Vr?=
 =?utf-8?B?aUx3VkVWK0s2U2VvMUVhYmVIOFdSOEVVajFBRlY0MkhxWHZndExXeGp0Tjh2?=
 =?utf-8?B?VWlLa2tVbXVPSThPVGpSSG85SGhTVUNTekF4cUIyRWd5R0VGS1NkUzJTVkZy?=
 =?utf-8?B?UXZjMGI1dHhTdE8zak5scFQwMFpxbzlkMllXUWZ2d0NCQ0c3SFlZdnBtYzVF?=
 =?utf-8?B?TFlCUFVIY3pJalRMc1Avbjh1ZDZBZnE0aElCSDFaanc3Mlpib2JOMVAxZElL?=
 =?utf-8?B?MjQxK1JPVU5rZFFtUVVaRFpyT3dXWW0rQzBlRXArWWtUcDhyWURub1pNWW1H?=
 =?utf-8?B?aVlDK3FRd0JNbU1vdnRKSXV6MTJxK3lPcUhDR0lUY1pLZ0hZTzV4UkkrSXFa?=
 =?utf-8?B?VFFETmd0Tmw4d1R6aWlkZFM1cnBDUFFLNDlTMThxY0taVlZ1V0ZxM1UrZzRQ?=
 =?utf-8?B?YVVTYmxIeU9CMkN6RjJGYytuTUtNOGlnNHJOTnN6NXZkZFI0Uk5KMCtMRHFn?=
 =?utf-8?B?VjQ1cGFEdUhxRlVYTVNYbXlVREN0RVAzZHN3TkZlNjN1Q2NjUjMxYk5RUU5V?=
 =?utf-8?B?MlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C68B2A74C80C2C4BB6EC101B31002DEA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bdd0c27-b49f-41a6-00d8-08da80376df1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2022 10:01:18.1789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SYa0B9MdHCXfOY1EsEtlZvkPWcvhCDo+9/RSpBjS5pzTBdzBD87/Boj5LRTzZSmgly9crmUqmo9M9AIdCwHtCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0029
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTA4LTE2IGF0IDA5OjMwIC0wNzAwLCBEYXZpZCBNYXRsYWNrIHdyb3RlOg0K
PiBPbiBUdWUsIEF1ZyAxNiwgMjAyMiBhdCAxOjE3IEFNIFBldGVyIFppamxzdHJhIDxwZXRlcnpA
aW5mcmFkZWFkLm9yZz4gd3JvdGU6DQo+ID4gDQo+ID4gT24gTW9uLCBBdWcgMTUsIDIwMjIgYXQg
MDQ6MDE6MDFQTSAtMDcwMCwgRGF2aWQgTWF0bGFjayB3cm90ZToNCj4gPiA+IFBhdGNoIDEgZGVs
ZXRlcyB0aGUgbW9kdWxlIHBhcmFtZXRlciB0ZHBfbW11IGFuZCBmb3JjZXMgS1ZNIHRvIGFsd2F5
cw0KPiA+ID4gdXNlIHRoZSBURFAgTU1VIHdoZW4gVERQIGhhcmR3YXJlIHN1cHBvcnQgaXMgZW5h
YmxlZC4gIFRoZSByZXN0IG9mIHRoZQ0KPiA+ID4gcGF0Y2hlcyBhcmUgcmVsYXRlZCBjbGVhbnVw
cyB0aGF0IGZvbGxvdyAoYWx0aG91Z2ggdGhlIGt2bV9mYXVsdGluX3BmbigpDQo+ID4gPiBjbGVh
bnVwcyBhdCB0aGUgZW5kIGFyZSBvbmx5IHRhbmdlbnRpYWxseSByZWxhdGVkIGF0IGJlc3QpLg0K
PiA+ID4gDQo+ID4gPiBUaGUgVERQIE1NVSB3YXMgaW50cm9kdWNlZCBpbiA1LjEwIGFuZCBoYXMg
YmVlbiBlbmFibGVkIGJ5IGRlZmF1bHQgc2luY2UNCj4gPiA+IDUuMTUuIEF0IHRoaXMgcG9pbnQg
dGhlcmUgYXJlIG5vIGtub3duIGZ1bmN0aW9uYWxpdHkgZ2FwcyBiZXR3ZWVuIHRoZQ0KPiA+ID4g
VERQIE1NVSBhbmQgdGhlIHNoYWRvdyBNTVUsIGFuZCB0aGUgVERQIE1NVSB1c2VzIGxlc3MgbWVt
b3J5IGFuZCBzY2FsZXMNCj4gPiA+IGJldHRlciB3aXRoIHRoZSBudW1iZXIgb2YgdkNQVXMuIElu
IG90aGVyIHdvcmRzLCB0aGVyZSBpcyBubyBnb29kIHJlYXNvbg0KPiA+ID4gdG8gZGlzYWJsZSB0
aGUgVERQIE1NVS4NCj4gPiANCj4gPiBUaGVuIGhvdyBhcmUgeW91IGdvaW5nIHRvIHRlc3QgdGhl
IHNoYWRvdyBtbXUgY29kZSAtLSB3aGljaCBJIGFzc3VtZSBpcw0KPiA+IHN0aWxsIHJlbGV2YW50
IGZvciB0aGUgcGxhdGZvcm1zIHRoYXQgZG9uJ3QgaGF2ZSB0aGlzIGhhcmR3YXJlIHN1cHBvcnQN
Cj4gPiB5b3Ugc3BlYWsgb2Y/DQo+IA0KPiBURFAgaGFyZHdhcmUgc3VwcG9ydCBjYW4gc3RpbGwg
YmUgZGlzYWJsZWQgd2l0aCBtb2R1bGUgcGFyYW1ldGVycw0KPiAoa3ZtX2ludGVsLmVwdD1OIGFu
ZCBrdm1fYW1kLm5wdD1OKS4NCj4gDQo+IFRoZSB0ZHBfbW11IG1vZHVsZSBwYXJhbWV0ZXIgb25s
eSBjb250cm9scyB3aGV0aGVyIEtWTSB1c2VzIHRoZSBURFANCj4gTU1VIG9yIHNoYWRvdyBNTVUg
KndoZW4gVERQIGhhcmR3YXJlIGlzIGVuYWJsZWQqLg0KDQpXaXRoIHRoZSB0ZHBfbW11IG1vZHVs
ZSBwYXJhbWV0ZXIsIHdoZW4gd2UgZGV2ZWxvcCBzb21lIGNvZGUsIHdlIGNhbiBhdCBsZWFzdA0K
ZWFzaWx5IHRlc3QgbGVnYWN5IE1NVSBjb2RlICh0aGF0IGl0IGlzIHN0aWxsIHdvcmtpbmcpIHdo
ZW4gKlREUCBoYXJkd2FyZSBpcw0KZW5hYmxlZCogYnkgdHVybmluZyB0aGUgcGFyYW1ldGVyIG9m
Zi4gIE9yIHdoZW4gdGhlcmUncyBzb21lIHByb2JsZW0gd2l0aCBURFANCk1NVSBjb2RlLCB3ZSBj
YW4gZWFzaWx5IHN3aXRjaCB0byB1c2UgbGVnYWN5IE1NVS4NCg0KRG8gd2Ugd2FudCB0byBsb3Nl
IHRob3NlIGZsZXhpYmlsaXRpZXM/DQoNCi0tIA0KVGhhbmtzLA0KLUthaQ0KDQoNCg==
