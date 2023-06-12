Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E8572C280
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 13:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237975AbjFLLI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 07:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237720AbjFLLIN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 07:08:13 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16725253;
        Mon, 12 Jun 2023 03:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686567386; x=1718103386;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AKlyJBoBrACBgNqR9IQRgqazephZfOWLKmZdjd8IdFY=;
  b=RZnfkcvGowU+bxdxWQr1mAbBan+cpBPeo7qRx4uH0ZIX8GQFLmfmkDTW
   E4BBCU86EJKb4Xq9aqKnuTWmCvnDev41ggptTR2317po9hshRxOCJOuie
   WHXv4iwfh+lcign6EhLO8izSZ0h/JAQtijWFRBx/+mFw+RrFt/y2Ylq1L
   7QNpOeCFxmUUkWz1Vq2FFoUMZDTvztP36WGmtO0VBO251ZIy2WhP3XNSv
   gwYK1XX6CTaetkhb3ruIBv6jroYBQAo4enCA6eppPC2cTCxTGdEsbjj7D
   DZHAowgXwJ59XEzOXGoZcj7gC30qotFDw2Q+drm7ZNEdKlFqk4kT6p6lY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="347655178"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="347655178"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 03:56:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10738"; a="688576265"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="688576265"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 12 Jun 2023 03:56:22 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 03:56:21 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 03:56:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 03:56:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOdKChmDlwS2mXZbffNMUn4XpSPAOwlsVGaOVNXTMjG5vjRricKqmUZKw+ohVMwdd3V+iwBMCU11dCoFHw+GmyFG1jNl4qEcSPQtUXWgd4GfO6CF8dcVMl13V3aHlIeoBV5Gd+B44NZCMKcY6lMOZ3fm4GT4nWj8cAYebZKFl4a7Zq/iH9dKRCvU2wWHcTQj6XRLRN8vw+Roa/wMLVLx75ttzxuJuZkYI+eejQJx+lgMSJdM3SrUbOD7i31OfpkaXLMbvj4faXnVOeNopLK/Xz/zgSWHhWTbPu3nnHuNR/pfMbFETNZKbyaUKtF5piogWOxzUN1t5rNim31xwrPFPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AKlyJBoBrACBgNqR9IQRgqazephZfOWLKmZdjd8IdFY=;
 b=W5Jrp8NzoJpgI7gh9lA7iAeZRioryCiJ4oMeeI34rCztwuTA5in4LxiLskyxPSnnZ1LF9sF7oOsVI+OU54P7UdfMJ2R6os8XSPvqXY9bwF1q9fQjEaCSJ/AojD5EwwvxALiHvZhhuBTGDTm1gyFycC8Fv7mEMHJWKN9PRNBJlbcaUnN5CzDFuDHR4hOVAEPoSynP6kwZckK99DyXIXCsNR2vmfN4d/Scf97HUNJTKj1txEVodDy2IHLasKn0VdTFpx+N+ja0k1LjKL9AnO0mT2FdJvRPliWGKB/RXNnA/IkbB4FWhNkatTd7Az5LuERAOb9klesxnQFbjIFs/6EHYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB8424.namprd11.prod.outlook.com (2603:10b6:a03:53e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 10:56:19 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6455.043; Mon, 12 Jun 2023
 10:56:19 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>
CC:     "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH v11 00/20] TDX host kernel support
Thread-Topic: [PATCH v11 00/20] TDX host kernel support
Thread-Index: AQHZlu+pYtFoPsSOB0KPkoB+E5UoTa+Ba5oAgAWfiQA=
Date:   Mon, 12 Jun 2023 10:56:19 +0000
Message-ID: <ee1949b33915ed8a80aa8318435595feee88a538.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <6482423c7c52a_142af8294a6@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <6482423c7c52a_142af8294a6@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ2PR11MB8424:EE_
x-ms-office365-filtering-correlation-id: 6eb30a60-04a5-43c3-758a-08db6b33a734
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8cRIHxe/DEqnlQCQ7sBNF8nJWe3K/t47uTYJ6fUfjW+4dc28j29I8gwvSBC81Qdwtb7ykPIDc8FM/9EsZJQzw39Euy06AM/WJwcqEKONK04VirZkk7DR0zopy7isHrMfxYwOaNzsGD1MrFcKOf9oj4dUJCPr9EGiBQv10zigO93Z12aVqZn+aiMGiG2efXFEsqA6vH8EctibS7bAtjpk70q7mF/aLdskL0+/ASRnAx+oDtIYJtQXv4thJPOCisNadavST2X2vD94FVVnkp/UeB7NtS/TbS8N9zUxQFraYX/2+jrg+wtUsVBkYyh4k30b0CpmTxKvO4LwQo46IfwQdUCH6jRgp/R8W/ClfJ/iz0eB6aXKORqQgoBQICFH5b71Y/Dj+NawAQZtpSN6WqNTBShwUsEfeyHGTPGwvoZqlqouZFz6ORulYwOMK/iZY7iTx6cWLHtohU/0cBW9qdsCU2ZBNli2qa2eh10QjzlWnYdMttcezBgxA1bP+ryVVKIdP4MlIiHyUutcqej1Nw1kx7u72h847KfYkAnZwrqjWyCWducmqBWv0VSj/FMZhp/c5b0+jdeDKSN0iSnkCgaAQp7rDc9CfkHBARM90m+P77c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199021)(4326008)(91956017)(64756008)(66476007)(66556008)(316002)(7416002)(66446008)(41300700001)(76116006)(186003)(110136005)(2906002)(54906003)(478600001)(66946007)(8676002)(8936002)(5660300002)(71200400001)(966005)(6486002)(6512007)(6506007)(122000001)(26005)(83380400001)(36756003)(38070700005)(86362001)(82960400001)(2616005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nmdxd2xiNTdiVThDTkpQa0hIdVdZQy9ZRTEvV0V4RjBBVGpRZGdwWGhPU1di?=
 =?utf-8?B?OTA5TUlZK05aTmZaalk5V1hHd0lYNUJwMWRzWWQzQzdSVEJLeWVvRzU4RFIr?=
 =?utf-8?B?TGdEQlRjd2RCQnpraDlzMGMrOFhNaUR4L2RDeWxVR293VnhCcnVSSG5YcXBk?=
 =?utf-8?B?eVhkNXdQTXNLNlNkTmhxL3ROSm5HeFhaSEprTFE1UXpYT2VQY2pmZnNBS2hL?=
 =?utf-8?B?OEtuWjdDSERPWnFhQUVPZlZmc2QzM3N4a0pzRWFBVUdralhQTFZEQng2UnRo?=
 =?utf-8?B?L2JiUitpZ2psZXNWci9VYkFtUmRIV1hPcEpHamtjNE9jbjg5Q09OTlZDd0Rs?=
 =?utf-8?B?dENtZU0rNWY5Zi9ydnFzUEZyM25qa0xZWnBhdkNaeHNKc2NaZXZiRFZpU1hH?=
 =?utf-8?B?aEJ5ZHJGT3FmWS9ZR1JYb21NQ0RsZTVyb2FQQWNsZkFVVVdhMThhc2lhRG1L?=
 =?utf-8?B?NEpCbENKWWNpakZnMklDNDBrNGFUdWtZYlhKVVNXeFdvN2U2MU1uZ3BsTGZO?=
 =?utf-8?B?M3lCN2o2Y0ZmdUMzOUhDVUorQ0RmWURtUjhJdzRZUjNxTkg1UTk4K21TNFpr?=
 =?utf-8?B?V1hYMExESENtNlV5NXFrSFNkN1JpQk1CRTgzTEs5MTRGc0dzcGtkL0QySmN1?=
 =?utf-8?B?ZS85K2haKzB0eGptMlhSNC9uSElXMEM2R29RSTc5cFhYN1k3Y2h4KzFXaWNx?=
 =?utf-8?B?dFRsZGFSN0xwaUVtdG9QWDRuZFgwWngreElRcDlYOHNuWW1CRGJJZm92b1Ar?=
 =?utf-8?B?emx1OFA0WjMxbnQ4QnRVSWsvcmF6b2taaTFLYmNvNFZ1NkthVEsrdEtPVmtw?=
 =?utf-8?B?YWp2VjQ2RWE5Wk5xTnFQUVJXZm5iRkFrMVNtTVZZa21RVS85c1o1RlpINHdV?=
 =?utf-8?B?MDdmL3lIL0JuYTBpM2E4SU1saDRXL21PQlh0dDgvMXB3eTJrc1V5V2NuaUhk?=
 =?utf-8?B?Q3RrMjk1S25jRCtMZTFtUG5ZVGVDOWNGMGwzWHc4dGxndmJKaHFPNFZUbVBM?=
 =?utf-8?B?MzBMZllOSEdrUmo1dDE0ZGNBVTRacWZuZ0lFRmJzWmxaaXZjcHZXZGFzQU9j?=
 =?utf-8?B?SkFzWDZVTU4ranhOSXpPQTdsU002cTVQWWZwdE1nTXQwdENVQ1J1alpRWW1q?=
 =?utf-8?B?ZW5KTUtaRjdhczFpRmJUeXBocXo1NG9HaWc4OGo2cFNUSjJQOWVWTUZPUkNi?=
 =?utf-8?B?UXdrTWRzR3lSdTA0VXJYTXlRS3Q1ZEdKWXE2dlBJTytJVkFHeG1taHpPelNv?=
 =?utf-8?B?WG9TNjhheUVxZzVFNUhEcnEvRFNSWmhjOWdwMm1zRVlhWVEzNjU3TTFzZ3Zh?=
 =?utf-8?B?OG5HNnBrOU5tOHFWdEtQV29FdEp1VGhMRU1GOEdPL1lWOHR6WU56NHVPTGE1?=
 =?utf-8?B?azFZVjZYQ0V1aTczb000MncrbjA5M3BZaXBXZkNMN3owMXJqdEpURVFFOXh1?=
 =?utf-8?B?ZzljZjhJTE9palVTc2JxckxmRGJlNzNPUURQV2hsR0hUdlpEM1p3OU1yTzBN?=
 =?utf-8?B?aGFneFNDeE9qbzJNQTcrN0NMOXR6ODlIV1hpUVp6TDBzc2l4c0t3L2hzVWYv?=
 =?utf-8?B?aStkaENwRElnckhzT21FM24rQkpUNll2YkdaWGhjcHdlcXFJbUROb1E0ekhv?=
 =?utf-8?B?YmtURWU0ZVFEZUEvYUp1ODQrWW1pRGpHVEJoZUtQdzlIdXhZNlNyMU9JWDgy?=
 =?utf-8?B?SVp3UVVPQlFJZkhHRGFhdDZnQ0xLZkN5ZzNib0JwM3VBdTZ6bEVPWjNLMkV4?=
 =?utf-8?B?ckVkbTVGUlhyVWVIeXFDT2RGUzBjT2NPenhRdWVoeFpQR1lvcXd5T1RHcGhx?=
 =?utf-8?B?aXA4dnprZS9xK1JzdUQyOWtxUVBIOEZSMUF4OEhKMmRVU25nZ2F5bWZxcWxD?=
 =?utf-8?B?NE05UXNHbjFXYit0allGQlJPV2oyWUZXemkySFZhUDFLMVdKaHpuWVdOZElE?=
 =?utf-8?B?SDdBbmsva2ZlZ09IODIrckVxU1J2NUpYYmNsb1YrY1BDNlc0R3pWTWhnUE9Y?=
 =?utf-8?B?ZGVZUXlCYTBlQ2N0dXFBeVAvU1Q2Vmc1WHdCZ0ZCa2ppT2JxTlQ1QW81UjU3?=
 =?utf-8?B?MEVJT2F5b3QzV2VzdE5KL08zTE9LcnlhT1dEWFYrVEpsTW1mbFFZZEcyYk9t?=
 =?utf-8?B?NzlyQmxXaGN4VE9Jdk5NUzZPSW9TK2FIRm1NcE1HaDhvNTZnUmlPWGFPbWRy?=
 =?utf-8?B?Tnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <492FD8D067B45749AE8C15E8944087B7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eb30a60-04a5-43c3-758a-08db6b33a734
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2023 10:56:19.5339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YddgOwNLgQ+FTAjg7zxi0B4jOO+BrNAOuR1yn7bzqS9iABfodUMQRVl9B1nyhl2q/Pc1+TO77tCblLOx1C0EgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8424
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIzLTA2LTA4IGF0IDE0OjAzIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEthaSBIdWFuZyB3cm90ZToNCj4gPiBJbnRlbCBUcnVzdGVkIERvbWFpbiBFeHRlbnNpb25zIChU
RFgpIHByb3RlY3RzIGd1ZXN0IFZNcyBmcm9tIG1hbGljaW91cw0KPiA+IGhvc3QgYW5kIGNlcnRh
aW4gcGh5c2ljYWwgYXR0YWNrcy4gIFREWCBzcGVjcyBhcmUgYXZhaWxhYmxlIGluIFsxXS4NCj4g
PiANCj4gPiBUaGlzIHNlcmllcyBpcyB0aGUgaW5pdGlhbCBzdXBwb3J0IHRvIGVuYWJsZSBURFgg
d2l0aCBtaW5pbWFsIGNvZGUgdG8NCj4gPiBhbGxvdyBLVk0gdG8gY3JlYXRlIGFuZCBydW4gVERY
IGd1ZXN0cy4gIEtWTSBzdXBwb3J0IGZvciBURFggaXMgYmVpbmcNCj4gPiBkZXZlbG9wZWQgc2Vw
YXJhdGVseVsyXS4gIEEgbmV3ICJ1c2Vyc3BhY2UgaW5hY2Nlc3NpYmxlIG1lbWZkIiBhcHByb2Fj
aA0KPiA+IHRvIHN1cHBvcnQgVERYIHByaXZhdGUgbWVtb3J5IGlzIGFsc28gYmVpbmcgZGV2ZWxv
cGVkWzNdLiAgVGhlIEtWTSB3aWxsDQo+ID4gb25seSBzdXBwb3J0IHRoZSBuZXcgInVzZXJzcGFj
ZSBpbmFjY2Vzc2libGUgbWVtZmQiIGFzIFREWCBndWVzdCBtZW1vcnkuDQo+IA0KPiBUaGlzIG1l
bWZkIGFwcHJvYWNoIGlzIGluY29tcGF0aWJsZSB3aXRoIG9uZSBvZiB0aGUgcHJpbWFyeSB3YXlz
IHRoYXQNCj4gbmV3IG1lbW9yeSB0b3BvbG9naWVzIGxpa2UgaGlnaC1iYW5kd2lkdGgtbWVtb3J5
IGFuZCBDWEwgYXJlIGFjY2Vzc2VkLA0KPiB2aWEgYSBkZXZpY2Utc3BlY2lhbC1maWxlIG1hcHBp
bmcuIFRoZXJlIGlzIGFscmVhZHkgcHJlY2VkZW50IGZvciBtbWFwKCkNCj4gdG8gb25seSBiZSB1
c2VkIGZvciBjb21tdW5pY2F0aW5nIGFkZHJlc3MgdmFsdWUgYW5kIG5vdCBDUFUgYWNjZXNzaWJs
ZQ0KPiBtZW1vcnkuIFNlZSAiVXNlcnNwYWNlIFAyUERNQSB3aXRoIE9fRElSRUNUIE5WTWUgZGV2
aWNlcyIgWzFdLg0KPiANCj4gU28gYmVmb3JlIHRoaXMgbWVtZmQgcmVxdWlyZW1lbnQgYmVjb21l
cyB0b28gYmFrZWQgaW4gdG8gdGhlIGRlc2lnbiBJDQo+IHdhbnQgdG8gdW5kZXJzdGFuZCBpZiAi
dXNlcnNwYWNlIGluYWNjZXNzaWJsZSIgaXMgdGhlIG9ubHkgcmVxdWlyZW1lbnQNCj4gc28gSSBj
YW4gbG9vayB0byBhZGQgdGhhdCB0byB0aGUgZGV2aWNlLXNwZWNpYWwtZmlsZSBpbnRlcmZhY2Ug
Zm9yDQo+ICJkZXZpY2UiIC8gIlNvZnQgUmVzZXJ2ZWQiIG1lbW9yeSBsaWtlIEhCTSBhbmQgQ1hM
Lg0KPiANCj4gWzFdOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMjEwMjExNzQxMTYu
NzIwMC0xLWxvZ2FuZ0BkZWx0YXRlZS5jb20vDQoNCisgUGVuZywgQ2hhbyB3aG8gaXMgd29ya2lu
ZyBvbiB0aGlzIHdpdGggU2Vhbi4NCg0KVGhlcmUgYXJlIHNvbWUgcmVjZW50IGRldmVsb3BtZW50
cyBhcm91bmQgdGhlIGRlc2lnbiBvZiB0aGUgInVzZXJzcGFjZQ0KaW5hY2Nlc3NpYmxlIG1lbWZk
IiwgZS5nLiwgSUlVQyBTZWFuIGlzIHByb3Bvc2luZyB0byByZXBsYWNlIHRoZSBuZXcgc3lzY2Fs
bA0Kd2l0aCBhIG5ldyBLVk0gaW9jdGwoKS4NCg0KSGkgU2VhbiwgQ2hhbywNCg0KQ291bGQgeW91
IGdpdmUgY29tbWVudHMgdG8gRGFuJ3MgY29uY2Vybj8NCg==
