Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB0F6107B1
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 04:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbiJ1COB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 22:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbiJ1CN5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 22:13:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C247A5986;
        Thu, 27 Oct 2022 19:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666923237; x=1698459237;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W9jBm0sOF76rKxmiUZ6pTXoCFHPn7RrnX+jymGXwkF0=;
  b=aPAmp6VF6ahldJI52ZUAOeP5WT8/J2Xksai4nTff6Dd6aWrr7mD58Rfi
   W6mKBewcg69qPIHFl//JKimEcUCjSIarXlbCWTT0eYAnin6k7i75gBh/b
   JMom0RbKdOKrKdumyFcd/oCmxSBd6l/57/rfdWJ+oixLi5kVcaYSKXVrD
   pfGTPWKtKhPyWsp75rYTi6heYKsQvY6Jtm5g0haKlkL3uAhrZ9PHDDGZf
   LI6KLNG9XT1vrCiAXBEUQfwBMijOCnjAWWw6Yb/Fs/JGXJNf9pvXIjwdz
   eLOFHsyKsDDwidIVDycwSJ9IRUiqkx/7gaIdYet6XQFTgCrRkUu2K+4T3
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="291690923"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="291690923"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 19:13:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="721889460"
X-IronPort-AV: E=Sophos;i="5.95,219,1661842800"; 
   d="scan'208";a="721889460"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Oct 2022 19:13:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 19:13:55 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 19:13:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 19:13:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TmV1Ysqd4QtsW1poY/zn3eXwf+l6BqUdXHepeJxWCZM1FfBcFDLyLxJjhuTj8ur9HKBXTb95Gp1WSkyX4z5/5opIDjImiy5lotXV57iPR3nNGeFPtiGFF1l1EYrbB94KLemd92bBePHzGFP4PEDbVXYa87DVT8Gre3bI0leIWzxo068gsRuKzC+/ZF+I/kOgYQHPbWb5w1b2reKIGXLcdWQQjYDF2Xoqy0RKmi+LNXb2Ia5moWVCBpSPHYa1l0tJPRO98u7LvS7QngwYyGgy1vU1v1u7ZZS495tdBqWsGFygYO7nrvrJk5pUjQE/y02aGuWJSnYHseEt/H92RdeeeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vmkkncZ1XLiBprji9iPQzXlWT/P5aH/UySXa5vTkTok=;
 b=Vy7/S40gIybtRVYRCNdVDRnOBWgeoFUQVa5s0w1peqOF4aYTcR1Cra8V29xfTDZEk19ouQs1DVYkO52IkqQazzQ8n+n1vx+39gS9JSv34ZsxTSd48J3XZuED96kN7DrTulY4bRcUfhE64wUi6X9bmpGjIzdZvnYJrdN96E9Au6EB4kKQrsES4KYW4VK3eMXxj5BIZBunlQNvVnroFd+MSi6sDjewD/wvLl3iml5q1kpVK2KLnyMViLNFkMM/0FEhKhefT+72Gy9livDFOrJTen9bcKgOkaUsT15F+QHyqzmZN467/b9OrWGgZW3L2kJz0krTKAB94qBADATGcs6v2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 IA1PR11MB6241.namprd11.prod.outlook.com (2603:10b6:208:3e9::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Fri, 28 Oct 2022 02:13:47 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246%6]) with mapi id 15.20.5746.021; Fri, 28 Oct 2022
 02:13:47 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 01/18] KVM: selftests/kvm_util: use array of pointers
 to maintain vcpus in kvm_vm
Thread-Topic: [PATCH v1 01/18] KVM: selftests/kvm_util: use array of pointers
 to maintain vcpus in kvm_vm
Thread-Index: AQHY55ylKGIU2b/Czky3MagHOAXjm64hW4iAgAB9rdCAAIjHgIAAqpCA
Date:   Fri, 28 Oct 2022 02:13:47 +0000
Message-ID: <DS0PR11MB63735816188919680E100046DC329@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <20221024113445.1022147-2-wei.w.wang@intel.com> <Y1nHL5BUoWPqUtt9@google.com>
 <DS0PR11MB6373E471C1378CBEEBD40A82DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Y1qjWZ8Lpveyky9m@google.com>
In-Reply-To: <Y1qjWZ8Lpveyky9m@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|IA1PR11MB6241:EE_
x-ms-office365-filtering-correlation-id: 4795439a-873b-4e13-1b44-08dab88a0c37
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CCj/R4+ajGzsbqd2e1bxpej/ge/IyDHFFMunP1sSUnYn2sC2hVoCrJiZJ23+xJYmplXe9LItyFt6TeMn2Z7ZoZZKEnyfskAUztbxk3SlDn0TzfJcRed1RTwWUoxgh81iSyvmIDjPpL337hKjXS00MNfWcBYejz6OtYHA1GcQsE6CubifniJ0Hi2ZAmh9uXlN0ulb33MSwqIDZWTe6H2hFtGDLGTT16UD+m7QEEKqHgYh9DPV7LYu7cMsi/ZHh9fGx11sabHpMqDKgqrC8LA8QBxOLEpy933EIFaAmJX2koOFxyISkrznfTSk5Tx2iIWSwHgz3mp6z9w/fWoah+yc0FEX25VOVbDfTw8x20NOrBrlJTqaa67HSOLsIaPDmOLNsta4uXjgYGoCb8bX8k/vC+W4sHBUjzF7Tn6U32gpnsP9MzxSKQJIxr57Nnu0Xh9LzRasDeTO54Kj9KWnag6KDm5tpz7kPuKOA9B+ki+G37hv3My4qozFRzet7KPPzxS3FvrRhdJWNWW0AToW41HToiFUTBwDuIwFHnoyVJwZ61E+UeAVqyfS6FRqRcOp4h7B3JVTBuxy+x39ZTwk3HpT1E+/WU42HKQqJCnHAGVYhhro2kgL6Cwgpe2eLw6UEzqyNO2IA+nh9u8fOJUVMkB4dgU0+XOOmcu/qPgTiqU/t08j/Zpa0wTFaEXViEIJ0DLpBFKp0v15reg6AljZIgnXy5SA1cHOvZUXZ42Ninv/na7nsrtaBFUrd3k3bmVpnjFJYhg3CAmwqpjDugKnrFZamA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199015)(33656002)(38070700005)(86362001)(122000001)(82960400001)(38100700002)(6506007)(53546011)(7696005)(4744005)(55016003)(2906002)(186003)(9686003)(26005)(54906003)(66556008)(8676002)(71200400001)(316002)(52536014)(478600001)(4326008)(6916009)(66946007)(66476007)(41300700001)(64756008)(66446008)(83380400001)(5660300002)(8936002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BjbzZFQHbHUHXQZl68dIgq8dgxqksSS0MDgKafF+V+GelAwXi3seUJ+mUf9g?=
 =?us-ascii?Q?LLGwk60ROalyRIewK3ROWsPSw1cTEpnSvV9CE1/kYp7MgRX0d//2z4zMDdQW?=
 =?us-ascii?Q?ACKz63njnauqC4LTL7zGHHyPAutfKkIPbpmu2hLA2eNZ2b0fDro24hol7MEg?=
 =?us-ascii?Q?eCi4Syi4WSU8O6m/KS28ds0hRCOuGQTreULH0SwrzcbmIhOhWJtHAi9wSf/x?=
 =?us-ascii?Q?WCdhOw5JOmEXVcpzeap02ZAvB8y/Sv3yLCZnC9UyL2xxisGxt30ZCeJednGV?=
 =?us-ascii?Q?lsz2UMnKbn7l2ySYX4aYkfyiVTwXV5L1yeIzZ9/G5Z85+dpMewJgHuKcYqBy?=
 =?us-ascii?Q?rErx4jAj0RWBycQCrf6ZoLQyhaE4CnuToHdXAQ3a1it/+XcK/VJ8f7ZRYGyq?=
 =?us-ascii?Q?App7iN9UIhMu4OZKMq4kMdw0BiQfEi2W6KmKmp7dURFP2m0sL6vfmk09q77S?=
 =?us-ascii?Q?ytYC0sUd7Ts5BwEhN27z7wzeIsKX0ouRN4MN53UxUuoGanb98+pqLQbzTaTQ?=
 =?us-ascii?Q?hGz8LwHtMihq0ErvcY389LXsV8qQYvb5v/lxkIapCafjx9hDMW+udXDBpI1B?=
 =?us-ascii?Q?1Z1EgVF6hQHB3OlKL/BPdFXzrQhdlJ5gK7h6yC9xKSS0uMpzrpF3h3yGfJ8X?=
 =?us-ascii?Q?PjTuwAl+M79FTW8wqd1MtJ0rc2mEAQvjRwX874v7YRRW5XIzgPKnFAEzDZVu?=
 =?us-ascii?Q?rcFVybRXtZrx3MMY/Y3V5ViuPdO9zsppXioRUZRriqxW6Hg1TqNYWkeKm6gX?=
 =?us-ascii?Q?iKBQ+gArXwBjgFw1fOhpkGztQuG7LO6FPuk4v4Gu4fSVgIesrPmM9StuZl+c?=
 =?us-ascii?Q?VgJdKa1MTJoV4OmpKI4DwBaiqvXgBtBcYdQx7Z2+yG7Y15cpE1g/31jW7MA2?=
 =?us-ascii?Q?qLBc6+CCv5E2E4jS9NgOKAx2D7yqh+nx/GLe85tqJdrQp04MOjAQGW5z3zmR?=
 =?us-ascii?Q?uRVTF57j+ohOjGk/UlbRy4MDte0XQIm9Ebl++U3mgfwdWWOTUdiJE6peTrlv?=
 =?us-ascii?Q?ckyxzRW4kIdHdFUruES01Wk9lM7V4FmR0udmgXPZ12r3pKVs7zFv0uDiWxkP?=
 =?us-ascii?Q?aw7/ST0Bq8bkfzST0JeKhMnk84v3XOKeQQd/aEhG+En1TnzdDIVDDF1/f+O8?=
 =?us-ascii?Q?1I2OtWEMnyNns334yMABUBe/paiWSL7zDH67WLZPKF1tajrc5qV0zBtf1qlL?=
 =?us-ascii?Q?36jmRv6tS8PYLGhdjIF/V8iN59gKcC71hUJTN+SD7n9r8HnDhvNy6i78hnhz?=
 =?us-ascii?Q?IIy62l9sFORa0IbxasQHXq1BmQGJJXuY7lqKOBRVIOCufS3Tkw8VIHvlVXPc?=
 =?us-ascii?Q?FSi2AY0E2V8UikTv6qutySBUASJxxTH7MCb6RrWGTDjwPaH5F/qB/ryvruao?=
 =?us-ascii?Q?CPa5mHNJCvOooU31COtuU0TLnRMccyzBdGLGLkbouEEiXvblUc4kVeJqxm2D?=
 =?us-ascii?Q?urT13P9WcLdfWJ2LdL5oOjV1Nekk/GsnsqsZ+7eop67CnEXs4bKipDs1RUCg?=
 =?us-ascii?Q?kU7YfNZ5j9oqzDo6HXpS4njnpdiaYWEqS1N3LGW5Y8bgt2l/KbV4/ReB7E5K?=
 =?us-ascii?Q?HUzosEzHwOTMRTTvgnh+LHVjP6n7xU/fVAKPxnNQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4795439a-873b-4e13-1b44-08dab88a0c37
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 02:13:47.6125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nRADm+5HycFlc6LxHqMw7QRmTU2JQUlshFVnSFu+2XzDSXvgDRh77XUj1IVZpcr4XOwSrQd5uvoqitBOHWx0Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6241
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, October 27, 2022 11:27 PM, Sean Christopherson wrote:
> Yeah, just allocate the max for now, though the array still needs to be
> dynamically allocated based on the actual maximum number of vCPUs.  Oh, d=
uh,
> we can do the easy thing and just bump KVM_MAX_VCPUS to 1024 to match
> KVM.  And then assert that
> kvm_check_cap(KVM_CAP_MAX_VCPUS) =3D=3D KVM_CAP_MAX_VCPUS in
> kvm_create_max_vcpus.c.

Right. I thought about the same thing, we should update KVM_MAX_VCPUS anywa=
y.

