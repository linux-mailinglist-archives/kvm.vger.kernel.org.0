Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0768772BF6A
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 12:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbjFLKoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 06:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbjFLKnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 06:43:47 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF7CDC15;
        Mon, 12 Jun 2023 03:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686565709; x=1718101709;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=n3Gmiv1fz9SExVhK4MLnXVIWy6P4W3UdRYpnDn5yZzM=;
  b=Yo0iw5O4CTpXldaSHFpKhDVSsbWII+H4xz782troG7xf6Kulu+HbDYRG
   n5YQ5b/hm6fA9Todb5hhsYKiOaXJuC4rE3mf8lXRxGScCHSFXthsdAGJc
   uRU4J6Gqv1MT2uz6uAI89ELSWsE4HSyOidkOHZSXm6M96nbaNsmfeduJz
   GiZYAoqHCpLUBRI1RbgGvK2litHuSHEoEgGkMZ8g95BcL2aJ5vXHAI/Ju
   Wn4Txc8eWfVy0Xmoh37u0MZWluHb8xmIW4AGEMSvpt2le6Z10yWU9ScgQ
   SgwoK/TIWbBlKh1TUFX2i5ivN0QTua4rzjAbPKUMAV7S00OQA0PrQ09CY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="356886523"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="356886523"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 03:28:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="1041274241"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="1041274241"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 12 Jun 2023 03:27:54 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 03:27:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 03:27:53 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 03:27:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYXO25llhLqeuL144/9JwCippjxL4da57WRLlfe/NMlebwdL8IpKo8t1OthOnxp2aERpztSKB69BsFFmguOiJCVcQLlw9wX8bT91PsW39F9W6tl8tb1rlmLU1WvACE6X2hnhJMBReWgXLh8xbRblfh2+M0ukMx03OMvxUIMNhUq+9xtHNmCtBARTey/u0VsQi9fpdvithqQkUbDet2Pbyw+2CY0pNlvAkLF+ATWwgtm9wxsxE9oskHaVA1LYqMvE1ke2l4Mz+E7GUtaHlznJCf1UUmeif9ltQ1iUBLc9jH0Kydrib5PmoCrQgwF+FE2yrXxuELemQSF2W3N6NBAonQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n3Gmiv1fz9SExVhK4MLnXVIWy6P4W3UdRYpnDn5yZzM=;
 b=XY7Si/G5+ae1zTPdFMHbjigVprOeZq0TEXbh6s1pM+WjxipAccQ/Oz3t/ojhetpeMCDPrpDjIj0TT5sFQVm9WSRUqsyrAGs+jmtx408HtzhuTXu//iQh5Kg3e97433K03qIbb/8ColPwOtafmF7bCylIo0e8jrgnQu1a+dus8moGSgFFtYiYQMwflqXEPBp0hqBqcmAbWGWQFnFda4EFFnCaf+cYObj/PyN8p32YFUzSixd6R36nKjo1ptuPawRXz64Gyw/h9LVQI5uE7mvkab+xwAlzj0wnkKWrqlhY30O2a4PtXsD85s8KipfM82ddL+yh++Md0RtBjwfVT8YWSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6257.namprd11.prod.outlook.com (2603:10b6:930:26::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.36; Mon, 12 Jun
 2023 10:27:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 10:27:45 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Topic: [PATCH v11 18/20] x86: Handle TDX erratum to reset TDX private
 memory during kexec() and reboot
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+CfSeAgAQK0ICAAFGDAIAAKbAA
Date:   Mon, 12 Jun 2023 10:27:44 +0000
Message-ID: <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
         <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
         <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
         <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
In-Reply-To: <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6257:EE_
x-ms-office365-filtering-correlation-id: c04e16cb-df43-4933-e143-08db6b2fa93f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rlyr9VWWLV0Qpvjbru6x3c8GxwXh9beXs+PN7SgUFsbmxRkpcCGdBNOM01b7ooVeP6G4dLmdlw8comL+1GLakc7EckcQTYTGk9P+sFaVjxaBHA/XibuAxTXTFGdkyrEcz9ob+SHrJOKbOyj1IQl9Z+2/qBknBs14GUXZJ6pxyP1iDn6l04PaVmVF7i4/G5y5MWGypBIgG7kvhuEcJzl5cJlyc8YhHioay/HMwX4BCv80faz+j8XIDSXihY0ortLbGAGfHVNtgN1E7r/ny1WzKp3ThTXp/lzl85+HHy8BNRx7MJ3Gi4VpyKX8+Qixxr0uTFNbzSviYdyxA1xQywU116jQUgvcK691CpGYYJrKX/Rp5EsYUJs+Sy+WeW+RXM2ujkAqXgGZzlyzJZVUaDaEMN024erCuiKnvuC9b025m6FBgrogPtlYiA+dWxomvVlkFJ//l28TDKOEUrqbWD43BIHUn4VQhgcJRRv29Iy31pTRKMHp9mb+kGfHlnWY1ztx7Cbb4oeZmUUjvHELtpr2CG01UQe3qBRf956s+X2LZD83OjkMm7IjgA7gDo5eHk7a+wUMwb3eOjBBa2hUhaPHriFW80AXK4hPdBsT9b4oYlncu05haGIeA92fkTAvIg44
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(376002)(366004)(39860400002)(451199021)(41300700001)(71200400001)(6486002)(66476007)(76116006)(64756008)(122000001)(82960400001)(66946007)(66446008)(66556008)(2906002)(91956017)(5660300002)(36756003)(38070700005)(8936002)(8676002)(38100700002)(86362001)(6916009)(316002)(4326008)(478600001)(7416002)(54906003)(186003)(26005)(6506007)(6512007)(2616005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmovNnRRQTR6dlNKanJkME5oYWpGS3YrSkh5QUFWVU5VZzV1VFVxOFN3NTZP?=
 =?utf-8?B?ZUU0Z2JGVkNMOWx2ZTNYaTMrMWF0RXBvT1k2aWpwR1ZJekVzM0w0VTBiK1VE?=
 =?utf-8?B?MEdXdEFSK3EvQ2VqbmtyWmc2RlM4S2FOQ1hub1ZYSFR1KzgvUDd3Zm1lMHIw?=
 =?utf-8?B?OFQrSDdvNUhCdUZMek8zVVR3UXFXY1NSVWhDa3FtVU9leFZwOTdYZFA4RWR6?=
 =?utf-8?B?eTEzY2JkV1JYMzJ0NHYrcEtPR2tMSURuMGR2eHR5aFJTeXFicENVaXdzOVEx?=
 =?utf-8?B?ZG5WOXp5b2ovV1pTaUNpOXVXS2hiMjI1dUJyaHA1djZjQ2JKR0thYTdjQkt5?=
 =?utf-8?B?SER5OTc1K3ZSUmpSd2RUNithaytyTisyQjROQUF2QjY5VkROdWhYdUl5RUU2?=
 =?utf-8?B?Vm9YbkV6NThmUlZ6eXhrSkVvVk1tVFVOVjM5d1dOMEtnUGlLTlRDWmNTa2ho?=
 =?utf-8?B?c1JoTFpwbGIvbWxmRmZNRXpWVFFZMG91QmxMTVFKU0Z6V2R1TnRqbDk4ZVJk?=
 =?utf-8?B?Q0JOUlBzeXlpVzJOeEg1RmVacitia3I1VlhkV2xJQld0WmlseEZYVzJsd2Rn?=
 =?utf-8?B?aFNidUdCUlI1RW5mQjA0U3JldW5xNk82QXg0c2ozMmxLR0cvR0JISXRZeWZM?=
 =?utf-8?B?d3VndkxOVk1kNEZzWWV3Zk9wRTVUY3hESVBVeGFJSHkrUFVPVjRhV3Rtc2V0?=
 =?utf-8?B?TUlEZjNXZEQzM1J0MmVtTS9DNUdYN3lBenNDdEJvU1FxbkdZcjNIOFQwOVA0?=
 =?utf-8?B?RmY2SDY4QU9KVTgzQUJkMmNIbUM0eUE3eXBGWGZFWWdKWWVoakJNZHFVSzk3?=
 =?utf-8?B?UHk5ZFcrU25Mc21HNklFejdqc3dCU2RhcUFDbk5MblA5ZWVJbFlxMHlsU0V6?=
 =?utf-8?B?UzQ3U1hETWRWcFhNOUNjWXVpUGJNRERLa2ROTTV5U09jQ0Y5aVV3cSsyV1NB?=
 =?utf-8?B?a1FXR2o0VHk2WkxGc3d2dHJLNVgyc2ZCVWcrNWEvcE93d0RCZHNkME5LTUJp?=
 =?utf-8?B?Nm5zVHhSTnQ5UVI4OHBEZTI2WEp4MG1xQzBYeWxzYTAvZm5KYmZMRXEwTU5R?=
 =?utf-8?B?MVpkVjVNK1N0K29uMmJYaVZJQlRncWtHejBVWkNuZ3crcmhzZkVoWTBMNnRE?=
 =?utf-8?B?ZHFOT1MzdzJjNnV3MzZNWStCSGpycDNSSEhzMGxUTXQyVjRTZU0vZUhzVHEz?=
 =?utf-8?B?SXRMMnlLKzhRT29QaWlnejByN2NwcVp6OEQ3cG0wak15bjNxOUZjRzkzc3hy?=
 =?utf-8?B?Y295K2Q5REJGR1B1WmhhL252R0phZmxvdTVJRUFNalEwKzBUNVl6bDlpM0ZK?=
 =?utf-8?B?OHBYaktvNWdVSUllQ1QzUXhVbTNGM2RNditwTm16RndpdW1vZ3NNUVoxRkw3?=
 =?utf-8?B?ZVVxZWdJaFloc0dZOW5PL0Q0bE9saURGYmwyNDlSWG9UdlR1WE10MC9LNXh6?=
 =?utf-8?B?aVBDTENkOWpaVHI0UW5JK0tnSzJiN002aEFVdTVTZUYzYytxeDMwOE1neEpp?=
 =?utf-8?B?aVBjaHkzSjRjb01QN2ZNQXdMZ0lLQ0RuOVNrb3J0WDg1eU9FbzVvbWRWZ2Jt?=
 =?utf-8?B?VWs4ZjAzSlBIV1Fsdm5zZ3BTVm1wNGlBZ1dtdnptV3gwY1lXYkZqektjOHFs?=
 =?utf-8?B?YTh3ekZCcjFvS2t6T1N6RWRYMmhkSG5kOUNzM0tkWDIvK2NIQzUzUFhqY1NV?=
 =?utf-8?B?bXdSU2RwY2x4SXpoQ0VWeS9RUjE5SFdNZFgwb2NNNkxCRW11bkwxblpVVnNu?=
 =?utf-8?B?MUlNR29Kdm1VdldXSmZvTkNIMmJ2VnAwaW1qVFk0cEgxNWlJcnZGdkpRZnk4?=
 =?utf-8?B?Yit6WGhFZWNhNFM2anBTUk4zY0c4NEZTSlhiM0VvWGU5WlFJTVFueC94SkJR?=
 =?utf-8?B?Uk55RU5sUHhlYUhFNE8xSUJzd1RXYzJtaUd2RjM2TnlSMlJTOUdWd2xpZVhP?=
 =?utf-8?B?T2krSTE5aGJkVVVnMGFKbEE1RStEb3ErZkpvbDU0SS80bnlraVFRM0lsZnVH?=
 =?utf-8?B?ektURjU4Ry83MHI0RVhBYlRrUlhqK0pWdHJlRDdvbnJrekNSQ2I4T0QydE5J?=
 =?utf-8?B?U1krcVNLMXEwci9SYUgvanB0QUcvLy8xY1Jkb2NoeHhneHVOS0ZTdU5UVnN5?=
 =?utf-8?B?VWpZTlJNaEpSS3pBc0Q2OElsWDhNTXoyNXFtR3dVb2hnMmhPRk96empJQ0VT?=
 =?utf-8?B?WUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67C1C4AC4FE4AD49A57FC4E016C44F59@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c04e16cb-df43-4933-e143-08db6b2fa93f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 10:27:44.9812
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 65MYnMqOJeqfajVR915p1GPYKecwA28F1liHjEgnbOoI4RZSUT6k5H7I+ii25jQnXwRUb/pOKlJrrJBK6d4QyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6257
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

T24gTW9uLCAyMDIzLTA2LTEyIGF0IDEwOjU4ICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBNb24sIEp1biAxMiwgMjAyMyBhdCAwMzowNjo0OEFNICsw
MDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIEZyaSwgMjAyMy0wNi0wOSBhdCAxNjoyMyAr
MDMwMCwga2lyaWxsLnNodXRlbW92QGxpbnV4LmludGVsLmNvbSB3cm90ZToNCj4gPiA+IE9uIE1v
biwgSnVuIDA1LCAyMDIzIGF0IDAyOjI3OjMxQU0gKzEyMDAsIEthaSBIdWFuZyB3cm90ZToNCj4g
PiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyBiL2FyY2gveDg2
L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+ID4gPiBpbmRleCA4ZmYwNzI1NmE1MTUuLjBhYTQxM2I3
MTJlOCAxMDA2NDQNCj4gPiA+ID4gLS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+
ID4gPiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+ID4gPiBAQCAtNTg3
LDYgKzU4NywxNCBAQCBzdGF0aWMgaW50IHRkbXJfc2V0X3VwX3BhbXQoc3RydWN0IHRkbXJfaW5m
byAqdGRtciwNCj4gPiA+ID4gIAkJdGRtcl9wYW10X2Jhc2UgKz0gcGFtdF9zaXplW3Bnc3pdOw0K
PiA+ID4gPiAgCX0NCj4gPiA+ID4gIA0KPiA+ID4gPiArCS8qDQo+ID4gPiA+ICsJICogdGR4X21l
bW9yeV9zaHV0ZG93bigpIGFsc28gcmVhZHMgVERNUidzIFBBTVQgZHVyaW5nDQo+ID4gPiA+ICsJ
ICoga2V4ZWMoKSBvciByZWJvb3QsIHdoaWNoIGNvdWxkIGhhcHBlbiBhdCBhbnl0aW1lLCBldmVu
DQo+ID4gPiA+ICsJICogZHVyaW5nIHRoaXMgcGFydGljdWxhciBjb2RlLiAgTWFrZSBzdXJlIHBh
bXRfNGtfYmFzZQ0KPiA+ID4gPiArCSAqIGlzIGZpcnN0bHkgc2V0IG90aGVyd2lzZSB0ZHhfbWVt
b3J5X3NodXRkb3duKCkgbWF5DQo+ID4gPiA+ICsJICogZ2V0IGFuIGludmFsaWQgUEFNVCBiYXNl
IHdoZW4gaXQgc2VlcyBhIHZhbGlkIG51bWJlcg0KPiA+ID4gPiArCSAqIG9mIFBBTVQgcGFnZXMu
DQo+ID4gPiA+ICsJICovDQo+ID4gPiANCj4gPiA+IEhtbT8gV2hhdCBwcmV2ZW50cyBjb21waWxl
ciBmcm9tIG1lc3NpbmcgdGhpcyB1cC4gSXQgY2FuIHJlb3JkZXIgYXMgaXQNCj4gPiA+IHdpc2hl
cywgbm8/DQo+ID4gDQo+ID4gSG1tLi4gUmlnaHQuIFNvcnJ5IEkgbWlzc2VkLg0KPiA+IA0KPiA+
ID4gDQo+ID4gPiBNYXliZSBhZGQgYSBwcm9wZXIgbG9ja2luZz8gQW55dGhpbmcgdGhhdCBwcmV2
ZW50IHByZWVtcHRpb24gd291bGQgZG8sDQo+ID4gPiByaWdodD8NCj4gPiA+IA0KPiA+ID4gPiAg
CXRkbXItPnBhbXRfNGtfYmFzZSA9IHBhbXRfYmFzZVtURFhfUFNfNEtdOw0KPiA+ID4gPiAgCXRk
bXItPnBhbXRfNGtfc2l6ZSA9IHBhbXRfc2l6ZVtURFhfUFNfNEtdOw0KPiA+ID4gPiAgCXRkbXIt
PnBhbXRfMm1fYmFzZSA9IHBhbXRfYmFzZVtURFhfUFNfMk1dOw0KPiA+ID4gDQo+ID4gDQo+ID4g
SSB0aGluayBhIHNpbXBsZSBtZW1vcnkgYmFycmllciB3aWxsIGRvLiAgSG93IGRvZXMgYmVsb3cg
bG9vaz8NCj4gPiANCj4gPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiAr
KysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gPiBAQCAtNTkxLDExICs1OTEsMTIg
QEAgc3RhdGljIGludCB0ZG1yX3NldF91cF9wYW10KHN0cnVjdCB0ZG1yX2luZm8gKnRkbXIsDQo+
ID4gICAgICAgICAgKiB0ZHhfbWVtb3J5X3NodXRkb3duKCkgYWxzbyByZWFkcyBURE1SJ3MgUEFN
VCBkdXJpbmcNCj4gPiAgICAgICAgICAqIGtleGVjKCkgb3IgcmVib290LCB3aGljaCBjb3VsZCBo
YXBwZW4gYXQgYW55dGltZSwgZXZlbg0KPiA+ICAgICAgICAgICogZHVyaW5nIHRoaXMgcGFydGlj
dWxhciBjb2RlLiAgTWFrZSBzdXJlIHBhbXRfNGtfYmFzZQ0KPiA+IC0gICAgICAgICogaXMgZmly
c3RseSBzZXQgb3RoZXJ3aXNlIHRkeF9tZW1vcnlfc2h1dGRvd24oKSBtYXkNCj4gPiAtICAgICAg
ICAqIGdldCBhbiBpbnZhbGlkIFBBTVQgYmFzZSB3aGVuIGl0IHNlZXMgYSB2YWxpZCBudW1iZXIN
Cj4gPiAtICAgICAgICAqIG9mIFBBTVQgcGFnZXMuDQo+ID4gKyAgICAgICAgKiBpcyBmaXJzdGx5
IHNldCBhbmQgcGxhY2UgYSBfX21iKCkgYWZ0ZXIgaXQgb3RoZXJ3aXNlDQo+ID4gKyAgICAgICAg
KiB0ZHhfbWVtb3J5X3NodXRkb3duKCkgbWF5IGdldCBhbiBpbnZhbGlkIFBBTVQgYmFzZQ0KPiA+
ICsgICAgICAgICogd2hlbiBpdCBzZWVzIGEgdmFsaWQgbnVtYmVyIG9mIFBBTVQgcGFnZXMuDQo+
ID4gICAgICAgICAgKi8NCj4gPiAgICAgICAgIHRkbXItPnBhbXRfNGtfYmFzZSA9IHBhbXRfYmFz
ZVtURFhfUFNfNEtdOw0KPiA+ICsgICAgICAgX19tYigpOw0KPiANCj4gSWYgeW91IHdhbnQgdG8g
cGxheSB3aXRoIGJhcnJpZXJzLCBhc3NpZ24gcGFtdF80a19iYXNlIHRoZSBsYXN0IHdpdGgNCj4g
c21wX3N0b3JlX3JlbGVhc2UoKSBhbmQgcmVhZCBpdCBmaXJzdCBpbiB0ZG1yX2dldF9wYW10KCkg
d2l0aA0KPiBzbXBfbG9hZF9hY3F1aXJlKCkuIElmIGl0IGlzIG5vbi16ZXJvLCBhbGwgcGFtdF8q
IGZpZWxkcyBhcmUgdmFsaWQuDQo+IA0KPiBPciBqdXN0IGRyb3AgdGhpcyBub24tc2Vuc2UgYW5k
IHVzZSBhIHNwaW4gbG9jayBmb3Igc2VyaWFsaXphdGlvbi4NCj4gDQoNCldlIGRvbid0IG5lZWQg
dG8gZ3VhcmFudGVlIHdoZW4gcGFtdF80a19iYXNlIGlzIHZhbGlkLCBhbGwgb3RoZXIgcGFtdF8q
IGFyZQ0KdmFsaWQuICBJbnN0ZWFkLCB3ZSBuZWVkIHRvIGd1YXJhbnRlZSB3aGVuIChhdCBsZWFz
dCkgX29uZV8gb2YgcGFtdF8qX3NpemUgaXMNCnZhbGlkLCB0aGUgcGFtdF80a19iYXNlIGlzIHZh
bGlkLg0KDQpGb3IgZXhhbXBsZSwNCg0KCXBhbXRfNGtfYmFzZSAgCS0+IHZhbGlkDQoJcGFtdF80
a19zaXplCS0+IGludmFsaWQgKDApDQoJcGFtdF8ybV9zaXplCS0+IGludmFsaWQNCglwYW10XzFn
X3NpemUJLT4gaW52YWxpZA0KDQphbmQNCglwYW10XzRrX2Jhc2UJLT4gdmFsaWQNCglwYW10XzRr
X3NpemUJLT4gdmFsaWQNCglwYW10XzJtX3NpemUJLT4gaW52YWxpZA0KCXBhbXRfMWdfc2l6ZQkt
PiBpbnZhbGlkDQoNCmFyZSBib3RoIE9LLg0KDQpUaGUgcmVhc29uIGlzIHRoZSBQQU1UcyBhcmUg
b25seSB3cml0dGVuIGJ5IHRoZSBURFggbW9kdWxlIGluIGluaXRfdGRtcnMoKS4gIFNvDQppZiB0
ZHhfbWVtb3J5X3NodXRkb3duKCkgc2VlcyBhIHBhcnQgb2YgUEFNVCAodGhlIHNlY29uZCBjYXNl
IGFib3ZlKSwgdGhvc2UgUEFNVA0KcGFnZXMgYXJlIG5vdCB5ZXQgVERYIHByaXZhdGUgcGFnZXMs
IHRodXMgY29udmVydGluZyBwYXJ0IG9mIFBBTVQgaXMgZmluZS4NCg0KVGhlIGludmFsaWQgY2Fz
ZSBpcyB3aGVuIGFueSBwYW10Xypfc2l6ZSBpcyB2YWxpZCwgcGFtdF80a19iYXNlIGlzIGludmFs
aWQsDQplLmcuOg0KDQoJcGFtdF80a19iYXNlCS0+IGludmFsaWQNCglwYW10XzRrX3NpemUJLT4g
dmFsaWQNCglwYW10XzJtX3NpemUJLT4gaW52YWxpZA0KCXBhbXRfMWdfc2l6ZQktPiBpbnZhbGlk
DQoNCmFzIHRoaXMgY2FzZSB0ZHhfbWVtb3J5X3NodXRkb3duKCkgd2lsbCBjb252ZXJ0IGEgaW5j
b3JyZWN0IChub3QgcGFydGlhbCkgUEFNVA0KYXJlYS4NCg0KU28gSSB0aGluayBhIF9fbWIoKSBh
ZnRlciBzZXR0aW5nIHRkbXItPnBhbXRfNGtfYmFzZSBzaG91bGQgYmUgZ29vZCBlbm91Z2gsIGFz
DQppdCBndWFyYW50ZWVzIHdoZW4gc2V0dGluZyB0byBhbnkgcGFtdF8qX3NpemUgaGFwcGVucywg
dGhlIHZhbGlkIHBhbXRfNGtfYmFzZQ0Kd2lsbCBiZSBzZWVuIGJ5IG90aGVyIGNwdXMuDQoNCkRv
ZXMgaXQgbWFrZSBzZW5zZT8NCg==
