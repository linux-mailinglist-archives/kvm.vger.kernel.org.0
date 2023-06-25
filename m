Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4162A73D1B3
	for <lists+kvm@lfdr.de>; Sun, 25 Jun 2023 17:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjFYPaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Jun 2023 11:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjFYPay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Jun 2023 11:30:54 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617BC1AA;
        Sun, 25 Jun 2023 08:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687707053; x=1719243053;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=N3u6VKRG+d6wYVsEH5cHxmzQEDKAWxT4qIRhAx0YJgk=;
  b=Sqwf2yBY7F/7HgSO0ctfF3x5pf18EEvX8T5y5RczaejlJo2oRlxSDNH8
   4ZRITW9lk4fIMyiF8mJSmh7U+6W07Xi2BTttqlLOKUeaRehtGyUQ1k5+4
   ZiUyNjcnV/MdamvnRUI/Hbg3bEsfPpSDQTBRWyZjU8Z4GUJm5Gtv/RUGK
   na0GDqG2fNr9JEGrceNutiozILX7K2wtpskauzexzcsjYFNPVSkFacHkx
   xsRsTyfOUuGpXabbbv9xyFvVD/wqeJMDKjGT3PCtRjHN38qHGf+Nq4L+7
   85ilR9c3TUeCbmyPi6ZQqpguwkDANGipiIL3q+Vmkr8O3UZkkp/w5vv1B
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="427072551"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="427072551"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2023 08:30:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="781135300"
X-IronPort-AV: E=Sophos;i="6.01,157,1684825200"; 
   d="scan'208";a="781135300"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 25 Jun 2023 08:30:52 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 25 Jun 2023 08:30:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sun, 25 Jun 2023 08:30:51 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sun, 25 Jun 2023 08:30:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4nkwow0Fp3lS+UxWuBt2YYmsN6T0d5b8/OJOvv0tMjVOvOpn8FozZuuTHcyC7D4ZZGBXJ5jYYWzu/1mDA6zVa3wMAFNzCeuJWmQgVMwvuFvQTKpIhKJZg9xYYtaUxe7WuN1CB9AbfOr/Q3Nt7O3+uoXv1RznKn47KoLcc6P5MjJImF67/D9NTYu9y/9m1XJX7vtM2XGLALuP8ADXDScUAz3OIIF2X06LzCpMwaFOTP+FX4jDLuTT2QSyX1tvHIyxR11BQldvHrGhiEtoeimlMqLPWR7SCq3qvlNCTAqqakvsr4Y+pIpWtStwx5q36HUKHqc2VMUpqfWaN0/vh2BGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N3u6VKRG+d6wYVsEH5cHxmzQEDKAWxT4qIRhAx0YJgk=;
 b=Rj4IYeJB2u0OYOPhwPeC6yaRh8QAP3v11YOc2mQs69k9xl/dfheRHKE7v+W8/z4BnTlnam89ARWQyI+k4AEzecQb+xoAUut6JjAhCbmrqLM1OEcjTI9sdT0ynaSivQ5rStG7ykcjbvE/zEvfXrSawauKEfVe1DzyVu/1r+Mmr8xprI2zUuWS3fuebcaN8CfbHA7NkhNSIdvWAt4Fljj8jNUhzwMDlIulq2syTLtQoACRDhF/j/WgJ81Ggv5zTiLCKR5Oo1z412+aeS7LQ5jzWSighLecbR5i0GoHIrUmlIzuRWt18WwHNzpCpBRb+kyJoRV+gw5qcJVPZ0BzxVSztA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7468.namprd11.prod.outlook.com (2603:10b6:806:329::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Sun, 25 Jun
 2023 15:30:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::19b7:466f:32ac:b764%3]) with mapi id 15.20.6521.026; Sun, 25 Jun 2023
 15:30:46 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
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
Thread-Index: AQHZlu+7CCb5RYnzE0SLr6ZWSpg4cK+CfSeAgAQK0ICAAFGDAIAAKbAAgAA3uQCACt3UgIAALtiAgAAEVYCAAJVNgIAAFRQAgAACvwCACM0fAA==
Date:   Sun, 25 Jun 2023 15:30:46 +0000
Message-ID: <d624fc2c3c75e30f8ed8f52dc42826e10b9c9c63.camel@intel.com>
References: <cover.1685887183.git.kai.huang@intel.com>
         <5aa7506d4fedbf625e3fe8ceeb88af3be1ce97ea.1685887183.git.kai.huang@intel.com>
         <20230609132301.uvvp27yr5kpenl6f@box.shutemov.name>
         <58f34b4b81b6d6b37d3386dec0f073e6eb7a97ff.camel@intel.com>
         <20230612075830.jbrdd6ysz4qq7wdf@box.shutemov.name>
         <4c7effc3abe71aa1cbee41f3bd46b97aed40be26.camel@intel.com>
         <48d5a29a-878c-665d-6ac2-6f0563bf6f3c@intel.com>
         <5782c8c2bb3e76a802e4a81c553a21edbaee7c47.camel@intel.com>
         <be258af9-a329-6f03-fcf9-9dafad42c97f@intel.com>
         <20230619144651.kvmscndienyfr3my@box.shutemov.name>
         <63477d22-26ef-dd08-a3b0-93931b7d1d16@intel.com>
         <0be5634f390015ee6badb3f2b2154ad90eb70434.camel@intel.com>
         <4069285d-1653-4cbf-a3b3-24727697754b@intel.com>
In-Reply-To: <4069285d-1653-4cbf-a3b3-24727697754b@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.2 (3.48.2-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7468:EE_
x-ms-office365-filtering-correlation-id: 8a0046c7-f6d0-4718-9eaa-08db759125bf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kz4EXXLeXolLs0aqaAWj2ZYeJachs7XGVrNbMHOGPzDSvjAysHtHKpAmr/vMTsBkcWCuvC7DzKCNrCjeTzbQOPzxKCyzMwzcL2FqbugoKvhP/hbRkcAE14rVE+VG7eQN5vSc+VF2fyaLaO8k+pnGGakChs7qvjS/MQv15cGZ4QZqV3Y3zmhF5EF5JH3c/UDjtVhBTPxiZYBpKQEO7jqho2bCWGA1gyByN/t0eWmBmKkjcSeWk3NO7xh6AwwACgC7fvGG2nds6ov03wKry91tVP49RkNPHSXRIV5vjdGe3j0p58cpO9L6Xdh8QbPyzbCjqNWxAtFHMoMFJuPWldN1OlfZSpzj+bmy1H0sJCGoL7xMfQ356kZYaRLXqRb1Kzh3zJuxjr5BjaLN3Ts6fga/V9aJ5Q/YWTT3WKdXmJ/10aU1sKqgbuDe6Hj2XZPD5/rZpyVZGTFHNL0/yW93VReBbq+0soNm8sTnkIUcvizBVu1IcAcRR8EJHHfuW7STA+cI3eRxKuBecu1qooKkdlqacvjG21SN5sK8UO4wAApBro9fV/eR8mO0bPUht1CIju3gXHka1HkckICKeWPVhctfOwMpOLoXBYzr1HILR/SgUgJjPVA8moH8uljBKcZx+lPc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199021)(6512007)(478600001)(6486002)(110136005)(71200400001)(54906003)(2616005)(83380400001)(26005)(53546011)(186003)(6506007)(2906002)(5660300002)(7416002)(36756003)(38100700002)(122000001)(4326008)(6636002)(66946007)(82960400001)(91956017)(316002)(8936002)(8676002)(41300700001)(86362001)(66476007)(66446008)(76116006)(64756008)(38070700005)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aHp6K3AxTjhQdzdla2dXZ3hiVEtNeHdHalUxaFpGOE1SZ1JFakszcmxiOVJ2?=
 =?utf-8?B?cWZOSnRzbHFodWNtRTB0a1Yzd2dWdzU0d1BGUzlpekgxM3NaMkhkMVBIQkJ2?=
 =?utf-8?B?V3ZyRExBbU5qNkRtbnZVbXJpSENjYzgzd200SklXZGhTN1dITW9iR29pSExj?=
 =?utf-8?B?SFk3ZzZjSmpyT3VuSUxGNlBJZlQvQTVWREtRSXloSkh0WWZNeno4c2xzUW5h?=
 =?utf-8?B?K2FGSVdFWmg5bk1MR1R4TStNK0ZNNWdaczhhVHhuRk1VM3dNQTNJdEFiT1N3?=
 =?utf-8?B?Y25YWGZFbGFOTktuK3cxVlYrQi9ibEozRFhHY2M2YjNoNkpFZUVVaGRqZjcw?=
 =?utf-8?B?YngzUjFteTh6Y20yeEc2NXEyNmxKUWhudTdqVVJBWTFqZlJGTm94eCtYY29I?=
 =?utf-8?B?U2ZDOWxRTGZaMzUwTXZuOVdNaHZ5UUF4ZXRlbHoydW4yZkpaM0ZsL3luYVlN?=
 =?utf-8?B?RzV6TWJLQ0lSWURJaVFEYTdwQXNZdm5LNWlwUDlMNTJDOFdmTmQvWGpVYzRj?=
 =?utf-8?B?SmxlZlVkVmt0Tjc2bWQ1a0pvWWJwQVlpV0paOXdhd2lRK3BuZEVtY0czMFNF?=
 =?utf-8?B?WlZJaThUL1ZuQWRmRUMxYllIaGhtZTlBUnJoWG5sQjVXS25jM3hVaXFua0dJ?=
 =?utf-8?B?VU56M01nMzJOVUdoN1JXVmZ5bHdNSlF2OEdOUUljaTJFMlRpODgxRDNqbHpN?=
 =?utf-8?B?TUxDRWlyZ1pTN2VJZDR0ZllZcVMwenVxOGc4aTJOTXlMZVl6OVlkaktDU0Mx?=
 =?utf-8?B?TDlsN3FsK2V0YlV0bFRiZmdac2ZsTEtOTEVmeWcxYTROZkVFeXFaVm9uY3Ns?=
 =?utf-8?B?U0pIWk5EeG1xMFJ0MzhtcUVNdXE0djM3UjZKdGQvQVBNb3hSdU5EMjhPNGFO?=
 =?utf-8?B?ckxwcms0MnNXczhUMnpaTjlteHA0QkFSNWFNMEVTWHVkbGR5ZlVSY2xvTUc1?=
 =?utf-8?B?RnpJNWtnM1ZNejN2ZDM3c2wrLzdUTjZGTTRjSlVYQkpybVh2LzA5VXBFcG1u?=
 =?utf-8?B?cUo1eWMxQ2NPYlIzL1l1SjJxamZtY1BxUUpNeWtuZ3ZtWWowK0lGVWtpRU5F?=
 =?utf-8?B?eVh0RXBiQTZ2ZWprT29abWE5ZTVTRWpCdTV1ZTc1VEJkcjNsMVI5M3dldnQr?=
 =?utf-8?B?aGk0aXJ2M0g4K0lVMlJsTzRGcG03R2RHZHEwMlBTRkhWZVQvZmpCaHorM3hx?=
 =?utf-8?B?VG5Ba3M2TFVCMWRNc1E4SjNhZG5XcWVack5OTHZjQTVLSEQydVZwRE4xZXhP?=
 =?utf-8?B?VVVwc0tBQkJRUkc5S1lPOG5OSWRWWXJUa3ZPTzZrb3NGbFQ5dWFDSlNnT0Fs?=
 =?utf-8?B?eEZiOGFNS0xpOW9YblpUMXZMakxUdFZJenhQcTVLR2xDTUljeks3R2c1Mk9X?=
 =?utf-8?B?ZnRzdkVsL25KQUZIbDVYaWlUZ2tMQ0NWMG5KdVk2SzJaS3RrVm1NejBlU2VP?=
 =?utf-8?B?Q0Fha0RPU3kwNHE0bkRvdUkwMnhWbG9lNlZGQTZNL0tjM3FKVlI5bFloYyti?=
 =?utf-8?B?cUVnS0VtVnhVT24vU0p6c01TZHJPZWJrSmdRcUVXR2JxUDlMc0ptdGVZQW1F?=
 =?utf-8?B?eWFmY2ozTmlvWVA1MCtOZjI4bzEvSVpOODh4VW0wNC9aZCtMakNIQTMzL3NY?=
 =?utf-8?B?TVhvTUlNMDdUK3RxVTB4QWpTdkZDT3lpcVlUZmh6Q1l6dDZmb3FBZnJpcGcx?=
 =?utf-8?B?Qlk1OUhtRDVDZk9vR0V3bXVvTldlaXhPTU4vK1hFWWZ5RXJoSDRoclQ5N01J?=
 =?utf-8?B?Z0JZdi8yaXVLSkN4SXVQWEpDdWxZeUh1eVJGQW9KYjJrOFRhcWJnR2JQV3RM?=
 =?utf-8?B?bXBadGJ0OEFRTTlFckY3VkQvZGpxcHNyQnNGeFZmYUcydFJ5SVM3TWduMUtG?=
 =?utf-8?B?RzdneTVCWEE0WFlrd0lDU05pS1NqUFZNeXl3bS9UVGdGQzVMeFRZZlMreWRF?=
 =?utf-8?B?TTdHVUJiek5KSXBvTVZESkoxSkFvVUoyLzJSQkY0UHR1V0xIVG1meHpmbS8z?=
 =?utf-8?B?Z1BYNWhhTHJKaTFiSVR6c1hIajNzdzJtR21FNGxYVXIvZlpBS21HRWxuTkYv?=
 =?utf-8?B?bmNMRXdoemFsbVF6RGlmYlo1cnNxUHJtUlpHT2xWNktKUkVvYjBJajlaVnVz?=
 =?utf-8?Q?Lrqn8KLZEfwYfVeMHM2KN6cOB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <564DDD6B2EE23440BA21E060375D17C9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a0046c7-f6d0-4718-9eaa-08db759125bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2023 15:30:46.6537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WvqNNRpP9tyUVg7wBEAHnUZULDeMUo0VAVud+/oIJD8ZIsDHUK96e4RA3q2Mk0VKCw8pKYAaMemJWp00lj5XLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7468
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

T24gTW9uLCAyMDIzLTA2LTE5IGF0IDE4OjA2IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gNi8xOS8yMyAxNzo1NiwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBBbnkgY29tbWVudHMgdG8g
YmVsb3c/DQo+IA0KPiBOb3RoaW5nIHRoYXQgSSBoYXZlbid0IGFscmVhZHkgc2FpZCBpbiB0aGlz
IHRocmVhZDoNCj4gDQo+ID4gSnVzdCB1c2UgYSBub3JtYWwgb2xkIGF0b21pY190IG9yIHNldF9i
aXQoKS90ZXN0X2JpdCgpLiAgVGhleSBoYXZlDQo+ID4gYnVpbHQtaW4gbWVtb3J5IGJhcnJpZXJz
IGFyZSBhcmUgbGVzcyBsaWtlbHkgdG8gZ2V0IGJvdGNoZWQuDQo+IA0KPiBJIGtpbmRhIG1hZGUg
YSBwb2ludCBvZiBsaXRlcmFsbHkgc3VnZ2VzdGluZyAiYXRvbWljX3Qgb3INCj4gc2V0X2JpdCgp
L3Rlc3RfYml0KCkiLiAgSSBldmVuIHRvbGQgeW91IHdoeTogImJ1aWx0LWluIG1lbW9yeSBiYXJy
aWVycyIuDQo+IA0KPiBHdWVzcyB3aGF0IFJFQUQvV1JJVEVfT05DRSgpICpkb24ndCogaGF2ZS4g
IE1lbW9yeSBiYXJyaWVycy4NCj4gDQoNCkhpIERhdmUsDQoNClNvcnJ5IHRvIGJyaW5nIHRoaXMg
dXAgYWdhaW4uICBJIHRob3VnaHQgbW9yZSBvbiB0aGlzIHRvcGljLCBhbmQgSSB0aGluayB1c2lu
Zw0KYXRvdG1pY190IGlzIG9ubHkgbmVjZXNzYXJ5IGlmIHdlIGFkZCBpdCByaWdodCBhZnRlciBz
ZXR0aW5nIHVwIHRkbXItPnBhbXRfKiBpbg0KdGRtcl9zZXRfdXBfcGFtdCgpLCBiZWNhdXNlIHRo
ZXJlIHdlIG5lZWQgYm90aCBjb21waWxlciBiYXJyaWVyIGFuZCBDUFUgbWVtb3J5DQpiYXJyaWVy
IHRvIG1ha2Ugc3VyZSBtZW1vcnkgb3JkZXIgKGFzIEtpcmlsbCBjb21tZW50ZWQgaW4gdGhlIGZp
cnN0IHJlcGx5KS4NCg0KSG93ZXZlciwgaWYgd2UgYWRkIGEgbmV3IHZhcmlhYmxlIGxpa2UgYmVs
b3cgLi4uDQoNCitzdGF0aWMgYm9vbCB0ZHhfcHJpdmF0ZV9tZW1fYmVnaW47DQorDQogLyoNCiAg
KiBXcmFwcGVyIG9mIF9fc2VhbWNhbGwoKSB0byBjb252ZXJ0IFNFQU1DQUxMIGxlYWYgZnVuY3Rp
b24gZXJyb3IgY29kZQ0KICAqIHRvIGtlcm5lbCBlcnJvciBjb2RlLiAgQHNlYW1jYWxsX3JldCBh
bmQgQG91dCBjb250YWluIHRoZSBTRUFNQ0FMTA0KQEAgLTExMjMsNiArMTEyNSw4IEBAIHN0YXRp
YyBpbnQgaW5pdF90ZHhfbW9kdWxlKHZvaWQpDQogICAgICAgICAqLw0KICAgICAgICB3YmludmRf
b25fYWxsX2NwdXMoKTsNCiANCisgICAgICAgdGR4X3ByaXZhdGVfbWVtX2JlZ2luID0gdHJ1ZTsN
Cg0KDQouLi4gdGhlbiB3ZSBkb24ndCBuZWVkIGFueSBtb3JlIGV4cGxpY2l0IGJhcnJpZXIsIGJl
Y2F1c2U6IDEpIGl0J3Mgbm90IHBvc3NpYmxlDQpmb3IgY29tcGlsZXIgdG8gb3B0aW1pemUgdGhl
IG9yZGVyIGJldHdlZW4gc2V0dGluZyB0ZG1yLT5wYW10XyogYW5kDQp0ZHhfcHJpdmF0ZV9tZW1f
YmVnaW47IDIpIG5vIENQVSBtZW1vcnkgYmFycmllciBpcyBuZWVkZWQgYXMgV0JJTlZEIGlzIGEN
CnNlcmlhbGl6aW5nIGluc3RydWN0aW9uIHNvIHRoZSB3YmludmRfb25fYWxsX2NwdXMoKSBhYm92
ZSBoYXMgYWxyZWFkeSBpbXBsaWVkDQptZW1vcnkgYmFycmllci4NCg0KRG9lcyB0aGlzIG1ha2Ug
c2Vuc2U/DQo=
