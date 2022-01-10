Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C39488FB9
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 06:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238689AbiAJFZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 00:25:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:63271 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230407AbiAJFZS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 00:25:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641792318; x=1673328318;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Dg52vI7Zzph7SANnogz1zjWx6H95Svdva7PP5uUm/3I=;
  b=m+hk50sb8GxeJ44J1iEkrK3aQt1voF+ZMQ6R+qEtnXZ7xpc3Wj5eM2Bg
   9jrq21X6RQQewuDonCo+PAfc6V7ZpG64xNC8zmvvl6K9FqlNboE5EcqGN
   cX8UTQvORWkdc0PSsEkBcW6N3ItLPL5F6WqvyoYAYnyvrwV47GpRX1Ei6
   wLGncEAbxmvA0DqjEi8Nrp54URAcMWjk8RnxRiPYrQd2KeMY4EV+ob+cA
   nXY2p85AaIge0RATQ9VyBVdPRs415mWDe6v4kcI2YjqbYJJqFJn/oaGkG
   /6InMQhkbqPjBpMuedFvphGttOPthEqTFxejXAC2nCW8UERsgRSQBXCRL
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10222"; a="240705645"
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="240705645"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2022 21:25:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,276,1635231600"; 
   d="scan'208";a="557874842"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga001.jf.intel.com with ESMTP; 09 Jan 2022 21:25:17 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 9 Jan 2022 21:25:17 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 9 Jan 2022 21:25:17 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 9 Jan 2022 21:25:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6zv3rsRDmlRLho7TN4UvxHXU8SrZ/khQi9taDQiOd/fL5WE6tAUJRvOnoAGShR6Of3Q1Dp2bi9WtmB+gr3zcuYpkgQfdvYyVogEwFAHN0kOJ50YnHhfBfFLl42r7oityj4bYh1jFbTk+ZhlFUmswfTA4hH6AsE07hINscZ6iN5izp/dT7Ot3PtjHwKCbIiKFI/iH3HcK1/PA4HCh/kmagdUC8FXf7JX6AhSiUvTZTMLLOPi58GqSZRFNlL/0fib0M6Uc3T9NwnJlZ8f+Ci6FjS/xyQdtgjjFrFiUq3NEB02wNnvlj6DOQfp7lhF6vgYqUc/E06B1FNpONGLd5pslg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XHgmG7vf6e8yT2idli02GCnA5fjtGU4DpbYXHk8Sllo=;
 b=g0s0/mRYliEvLfUOfD7KuH0KIsVCcHcyRrgYcSdiLr+SGwGMgriEO2Ihlbu4l3QZtkDE+uCK1b2w5REWq7PFljhQhlP/L5Lbym3PhlDc6GYShBdDkKMfUluTFmP7AwVia3hfs5RkFjuHbgj4KJAiUJTBV0slD8gCCnLkjGM56G9nOv5BUex5MzYEJMiDySyoBBCsZuv6+ra1kZSRfCetqT4cUFxPJol287p0yzkf/1B2M0B2lxzBAM/sB6cSLBrbLvf8YQ81bV/SoilXCKEzrEMuz6Zoh54pnt9bWIrkm5YL2+Mu4Rrmt5IFQztbDyUYE18vTMd3VzxDnJvPgM8EaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5451.namprd11.prod.outlook.com (2603:10b6:408:100::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Mon, 10 Jan
 2022 05:25:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 05:25:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Zeng, Guang" <guang.zeng@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: RE: [PATCH v6 07/21] x86/fpu: Provide fpu_enable_guest_xfd_features()
 for KVM
Thread-Topic: [PATCH v6 07/21] x86/fpu: Provide
 fpu_enable_guest_xfd_features() for KVM
Thread-Index: AQHYA/gqbksPM+WOB0GCv7Jt5r6c6Kxbu3ZA
Date:   Mon, 10 Jan 2022 05:25:14 +0000
Message-ID: <BN9PR11MB527688C6B00A14C61B97ABE08C509@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
 <20220107185512.25321-8-pbonzini@redhat.com>
In-Reply-To: <20220107185512.25321-8-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbf94ab1-bc82-41aa-6d13-08d9d3f994ab
x-ms-traffictypediagnostic: BN9PR11MB5451:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN9PR11MB5451757B74FCF13AB89B089D8C509@BN9PR11MB5451.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +VZi5OxPIVGA4FkmlublYI55cZX9NCA/gLRUKopMo536Wl1UOvF3/SksuFHv/jPQhLToQp1Dj17JEdzdTQSHZGVoTaWExnZMtWajB21TIkKDwPRzys66WK+LStJ2MnpDQOgZB5ELyJuoZVK5w2XdCFdnx7ScmHOkbBYvd1bPtdC6cO6buYYv6/DX3qJTuUbnPpVJbTuB+Nx+StgJveQWO44p/qs8T4iTcwjBChzJoYqHUkoVxOq5IHQ1Pvb+/+RAqhbV3ya7M78bcRGzW/wdE9q2W2A69HPjAi4ZRBhJ1c2HTsq00N9LDpLEgaO+Ss9EwvJbcsClAdcilWzcY1+EBg+Fb2zI0zA5YgzDOc3wnmXjbvV2xtNjX92/5K8x9ezBJa2UzJDTq71kqRikVLyRAOewGDh6ojzHep4wgiR3BQij6ZG6DNLTSQIK8BTl/bbTnYsywqe/Qrhri4KAKamrwj4xXyaYeiY2zpNJODKcv4eBDwjMqqekqnJCNNzfUrweHKEPK7YpKHRtDeGf3VvpZ5HNCVWs9PESRgSaycEL0nahvF8M/IKHHhSUNQwfB9QMc/6jASgq9a3OHYnGx2EQsRsOhoPY50HOsHVGiF3TDnSzsWbc5ug/V+9+Wnq5IXph6oFo4fnstDUu/u7lho/CN70v/zpaJLb7kN+WEgILTUKcjzd/HXj6Zn2aaDpeV48TlE259cL9p2/U8Kayx9Cdew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(38100700002)(38070700005)(33656002)(4326008)(7696005)(83380400001)(71200400001)(6506007)(316002)(110136005)(107886003)(82960400001)(54906003)(4744005)(2906002)(508600001)(76116006)(52536014)(26005)(9686003)(64756008)(66556008)(55016003)(66446008)(8676002)(86362001)(8936002)(66476007)(186003)(66946007)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6kR6dFaonRvktbueKxZ5JdXyvhY1IJmZmna38Qb+jskb5dQ0mwyLTlH/zpuU?=
 =?us-ascii?Q?8jMqvoLFkEL7uD2hRY5M703U5/ofWod9Jy/tGrX+otpUadQWUi+xMImHo6lb?=
 =?us-ascii?Q?b5yDPXUx+A4pFu687TnOvOXVAzo2xSXD1P3oYFzKzqC9D1hOV14D9PuyMIPB?=
 =?us-ascii?Q?4AeSUhsWHvydFLGARrzopxs1E6oqCpeNzx1u4pe1GPeTIQCP1nU8RcV6qRXe?=
 =?us-ascii?Q?dl3jltpk/eoCYK6QrBJt5keAX/WsoCl19OqHRmg014+bPBDP8QB0ESidhdX6?=
 =?us-ascii?Q?sFN+HCjhv9DflwHXCwDqCMLvpBwN4BfgEstrWk17cKLBnimLSe0ITk6geSEJ?=
 =?us-ascii?Q?yZodGnyXvyjV7DRTm2NBHbyOzJAhKPDRwbhbyJ8/N7ATYkoT/5K75Had3V91?=
 =?us-ascii?Q?6o6eDqABYniChrL/EWGR8/XYszTEwDp/Uhdst7hngzsC2kBkw1M25IIfHQY/?=
 =?us-ascii?Q?oGScTLT5CK9YeMY7bYRJ6qNoO1f1jw7f5SkANrfAsO7O5Pz4FBZPtEoQzjx7?=
 =?us-ascii?Q?b9gu3B9afzQTdUMfLWAi6ls/cbhKCeUmqir7Br6lf0xarLh5zjIS2Z4G8jWo?=
 =?us-ascii?Q?qeO2gBVd+F+Un0a7w7fgSTG6aZaDaglYx1gcdTr8h/cOBeGncm2+czkg/nJo?=
 =?us-ascii?Q?1dWr1qvR6HjTMODTY3KBQPHeF2VXwn0or86Ax2P5ivACDmXMI+mIlk0HCE70?=
 =?us-ascii?Q?BxqJbfH5QEAX5KAyf9KbOBD24R1BSP449o9SZtjkSu0VxGvedldvVrat3CxJ?=
 =?us-ascii?Q?1ozDQf1h0fkOFtfPHL+Gm0CIKV3aZ01kT0Fm9OkbJX2HX1hKEhehQ3k7pnvx?=
 =?us-ascii?Q?GlMB7kehkBpQlh3NmDoOOYTNj/vGxotHRt65d6/BVpoL6cnJeyY8EYLdZhXj?=
 =?us-ascii?Q?QzKdk2q5ZxhItVRLLSn/Aq3c1Z26LkTV9Qf9EnEIPpzwX/Es0LPBnKsmMTpd?=
 =?us-ascii?Q?DV+cE5Wlty8GM/d3ZziBZhd76ZlcfbLnVTG7rBXhiBvLTuyaVwDpS4omqSI5?=
 =?us-ascii?Q?nYnm9oEkTmeZBewvR5fEyi2egxRX6i6LHU8gUszwd0up39KJC3ta5ENLg1b7?=
 =?us-ascii?Q?T7E2ZDiSSEaZ98kUwKym1doBC56UMI42zuaHNb2dJqJLXlrrYbJS3XaCTwQR?=
 =?us-ascii?Q?Zpr2BuM/ihYxm5JcPtyrL8Ypk5aUwuajgyrAcNTbCUWaBIiMmLaYAlGP4sa2?=
 =?us-ascii?Q?cSc/wjW/tsrlhk5GvSBpup3jploIMuexAFxuOtdJ26FKNLUPtBfrcT51JVt/?=
 =?us-ascii?Q?73V93yjlyMFtVebtEYXtKcWnrCv91b+LnCa97/ZRtvB+06/nDaYr9q5xMmQ7?=
 =?us-ascii?Q?HiaQNaoYiP+0fHJGywdKEYMW7yh7Q+x/GOXZEwz+aWD88g0eWj+IhSxVxtVI?=
 =?us-ascii?Q?rTCnaC1yVB1mYWtmyNwqEJS/15r6xGBPeVOxmUUw9HDs8MTuli/mB1XOVURD?=
 =?us-ascii?Q?CWMicwl24YBCjyZHKiEso46UB9ZGvELMMPrTzNUtBZlLPkUHSWZiCgsM59w9?=
 =?us-ascii?Q?7IMmcz5c9vF9HBxQZpgv4ZzYGP7ttgihnSIx+tz76E3vYd9WqHUMb6OFA84F?=
 =?us-ascii?Q?6zC/7oWoA2tyi3rlAziMdevavVX0V8BVhvpenw5bMx/3q84uy0mpzaTstOyx?=
 =?us-ascii?Q?N4QTrLnJt369ckmgJ6AwFgk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbf94ab1-bc82-41aa-6d13-08d9d3f994ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 05:25:14.2184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p1Qwdf2wfimDwZlJ9L1Mi4qxqmoUUdn0w5waCbhfpx4ITBEgDywnKhPWNPpPfWk/dTYey/r9NS7i24GVuvRESg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5451
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo,

> From: Paolo Bonzini <pbonzini@redhat.com>
> Sent: Saturday, January 8, 2022 2:55 AM
>=20
> +/*
> +  * fpu_enable_guest_xfd_features - Check xfeatures against guest perm
> and enable
> +  * @guest_fpu:         Pointer to the guest FPU container
> +  * @xfeatures:         Features requested by guest CPUID
> +  *
> +  * Enable all dynamic xfeatures according to guest perm and requested
> CPUID.
> +  *
> +  * Return: 0 on success, error code otherwise
> +  */

Just a NIT. This function itself has nothing to do with guest CPUID
which is a caller-side policy. It simply enable xfeatures per request.

Thanks
Kevin
