Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F18735DCD
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 21:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbjFSTQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 15:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjFSTQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 15:16:30 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDDD10F;
        Mon, 19 Jun 2023 12:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687202189; x=1718738189;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AsT56bTVJn9Ek+yalR/5f1CXD0PHyC4UqSBFn8sFMO4=;
  b=aWYiRow8bLJ2JJC5Xgg+WmYJTEftO+9S9WfjGnEbwqq4RX0hBMoWER4N
   c+i9ShvhYWhhU6G1yEIyPLGdb4iETza+fgvf1EJZEM45mZ+rMe23zpi5b
   ZsUfSkSShfRwWM7Jwz2UF5auAIgE5mUYzgaNkgDwpTgKy3q7/Lb1yTFXx
   quAs+4Qnw8X7VvpCsFG7yt0Y/2ZzUt+gjfs28JY9Lzhn7DWtNIq/4+PbU
   zEkkqR/313dByoJKUU2UezOL1JSJO4MhyeWJ8SL9r4zBO+IHvbGmPw0Ju
   jlgYqbjN2SnTzd+2OUddOP4Qcbp58eu+xOuEAGi/zvNX5foHYv9Wy10Xk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="339312383"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="339312383"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 12:16:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="716979755"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="716979755"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 19 Jun 2023 12:16:28 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 12:16:28 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 12:16:28 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 12:16:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Icy/Md19fllbvdRLWfVOoGqBo9KN14nwqeejJuFCrDubG/HAlrjlmDTZNIGN2KrGVDifq7fNZH0oy8+sz9bP1fyM4elhn/xHVrNKOquAIhra7+mCCufvdyG6aXjr+P6VV74BkgvUp9y1akGxOEipYbPu3x8E51fIf7McIvR9iYiJAeBfsIoszsI6P9lojIMRkpe8Srl8I0VerzRQ92wLXFT7IqkZof8+l2kAC6PPn6oOsv8cPooxYNzWl9IC1dHlTgNVYbtuRq9tZDmnEewRc0mifoYyawXcnFJD1JCHJtXnrU0TO0ScScWAiRKbk8rBhCs3/HFGj82RXxv07KIzMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Erq3dA9hco8uH8z4CJ8u96rHypJunYFfTOATR9N/Ky8=;
 b=JeTC4ioHEBNNSUvIkQ6tnmJrZq+EM1V/HYOOP5RRGZNZ4p6xR5dSGiy1s1jQafq6NJGRncJ/sBWwIGoRRe1Rzmqvj7sYFv+IuH6t2kYSOU3Ed8LgD0s/oKoO2eW0+nhcVXU7G/Ntfqt8+u4T/+2vfmVdqNXkzHXPiJ5siPhZiWwyskfW7OkQft5XQAWKhwOpXVni13YU9hkSUvdUtMXBw/rsUUjli2JdtmbAy6DL9UUndajVRkQ8WzX+CyWjii7SYgkT3VNVVsRfBJnLY57jes0ihEZntO9aYPA8N5HtdCoP9CfUE2DkioEDsM+jtFEtik1/SV3GFB+Y6vGO6hxbTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by DM4PR11MB6096.namprd11.prod.outlook.com (2603:10b6:8:af::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Mon, 19 Jun
 2023 19:16:25 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::c016:653d:c037:44fc]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::c016:653d:c037:44fc%7]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 19:16:25 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v8 05/33] x86/traps: add external_interrupt() to dispatch
 external interrupts
Thread-Topic: [PATCH v8 05/33] x86/traps: add external_interrupt() to dispatch
 external interrupts
Thread-Index: AQHZa4hBNd3d+GJ9EUqzqD+DP4Ohj698clwAgBZ2AGA=
Date:   Mon, 19 Jun 2023 19:16:24 +0000
Message-ID: <SA1PR11MB67340ED76E3707707D1D61A3A85FA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-6-xin3.li@intel.com> <87ttvm6s2v.ffs@tglx>
In-Reply-To: <87ttvm6s2v.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|DM4PR11MB6096:EE_
x-ms-office365-filtering-correlation-id: b6b70df0-879e-488a-4051-08db70f9acaf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uHRLGrjMIaQpcPs8t4kzHPGOyKmS1Or8IQU42TxS23H4VRhMvDV6QP9zto+a9S1qCwrjeVZEFAketgZl5mcjL76su0JFjXVAEyFRcyTZdVC1v0dM3LfvdWkiDEKsln2UswozQzCF/p+KHe1h4eBuH/YZmJbQOSSkCO4G2HYveocCssbWH5z8RZixz/lP41Tqo6hgD34piId+9BB9b56717G0dbF8CZYp+yreoi9WKIKsMCh1E2Fy2b+S2ME71918hBGBHsIRgiBFnVQ2lU9KTxbed6kSeSYGl1yd2kMlZihyt8/yzrbOFUgaWVAgqVgLt8kN1+JKo7n+FdtcAsnOvS38MU2XuOQbcyUQPJHOb4r618PemdKSrFw1Y6Tl2VtWsbjug8TVKtIcZtmeEGCZHuiEY6w8+gXL1iD4wFl5ogUwQyvQ5c37LRGTLGdbX17KKoy/QuyjHIPZBhe1J83FZuIIgWp7kfZAILNwyW4I2JrVfC0WAd6IFsvA4awgB7+tx2AnbDuqX35vwwUlrcRNGR+15FAAvaT9wdT1+gRZHsubjjFCw88jebvQrZfQqyL6fU1EwuqOh5b+0WAEVN+ujxvZvkvF5vsZMuW7pw5fMcHTUclJWatybxYqlaXhIHXS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(39860400002)(396003)(136003)(451199021)(186003)(38070700005)(9686003)(26005)(6506007)(82960400001)(55016003)(8676002)(33656002)(122000001)(38100700002)(478600001)(52536014)(4326008)(41300700001)(66446008)(64756008)(66556008)(66476007)(76116006)(66946007)(316002)(110136005)(54906003)(8936002)(4744005)(7416002)(7696005)(86362001)(71200400001)(2906002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QjlLm8+Ghzuiqzquqvi3BlNDz6O+0bl3WcPNOQrRHyPQwf6Ko5pdwuOoEzsE?=
 =?us-ascii?Q?EDEL/zJ7sHxvABuJmwuj/pxdFuDphn/9m0Hg6yXDfk4HHU0ltIQaRMNATFdG?=
 =?us-ascii?Q?zjiKL/3/XMkx6zc+FrTGATMNi3NUusYlD3JPBT/7HXIJMzSecL34298xB2LW?=
 =?us-ascii?Q?kgKPS/ZGM5oSe23FVXf6ivMljXpAQhCid6oYvWmc5QRE42hOIbyJ/BdGNovg?=
 =?us-ascii?Q?K7fSPmbLPoVJFqhOdXkzINFIjBycyqf8SNxtVThL1ZayWrirQDpuh4JuUXVX?=
 =?us-ascii?Q?V1/Pvb7GsJ4F4RwJzrjZ2z0bVRsNzgy/oVa5vKhxSEIJFP579mvybZgfWGCA?=
 =?us-ascii?Q?R/AnNnkk2z/11UrOYgcblDxn3Em+zWeoH6WY9cj469qiou0sq+sSb8euybtQ?=
 =?us-ascii?Q?wdM7maX/+2VOyReOfN4bWfXyZa9JKKnVxzQeJpzlMSMRjv/C0uUVSYfSM1p6?=
 =?us-ascii?Q?V1lBFJrlHpLqAh/RusNIFUfeO3H4Ud5ysV5mAQMFvaE8YpTyyO/QtsURW2p/?=
 =?us-ascii?Q?WgHh06byfe6jdsTAqI9yXv2FWC0CQqFMpoV+9mUDm9jq2Go6hZlmbiIhYkHv?=
 =?us-ascii?Q?g05S/578dY3y8KUTLlWwWy7tj6TM3VCES2WJzjmkjrg5eVhRqMQrGmKypZj0?=
 =?us-ascii?Q?knVbVQTX/jRGKQGhf95Fc0rKQn+5NDwIl80Gx+sPIryWOZZMNY2YM97qYw1O?=
 =?us-ascii?Q?vzRCC7zWNRmoi+Az3350p0jrWcBaabTn97Lp3KU3vUMejteet4viAI5xapbH?=
 =?us-ascii?Q?oPWdcsVVnRWks8iWte1PSg96YUdVO6KUgl8S6M85FR1cFhLUbYSLBu9UNPNR?=
 =?us-ascii?Q?zcL7yzl1j9N+fEmeyyKrEflXTpHn87lMZVfYn9x2nw/uJWjBZ05kMl4eoW8u?=
 =?us-ascii?Q?+wHVPYoEI0/73mCmpERZT1I1HihH13CZ+WE22RMWWfrgwNeTKlkCzolTeOFs?=
 =?us-ascii?Q?FaELfkEJ4yUoejwCa38ZXez/zD+K3hmrnsHYxhaQjS3eR4/LktNTF+iIx7RT?=
 =?us-ascii?Q?Sq4DptQCKtLYKsf5Ebkx/WHxN8o5j77qpfMMHpv9bkp7efyd8ZLIAzDlU1JJ?=
 =?us-ascii?Q?3t1lUzjWu35oy/AMf8F6K6z3/pFWjA4CKPWkh16pF7yQzDsn0rfz0/dA+ksg?=
 =?us-ascii?Q?kGqxqyIYhOjxhZHVUrSWUFI1ds839pE2O/TE4FzE9XK2SGMICFacJggZTk+U?=
 =?us-ascii?Q?ndkRXps68SsPMTTwQ034Dw7rVKWdbpg5tO1PasztRMddmsScSt9Bab7gTg+c?=
 =?us-ascii?Q?+mvnWNE0sErsaMj7s6kThG0W89MOnryFwWjkgsMyKjVEuOyNfIXsQlXr6uIW?=
 =?us-ascii?Q?x+XzVKdzb5tpdHzgWQ7yacOEXRjj/do/VQIoUeTXLEalgVaOdX7Rzb/Fk0eG?=
 =?us-ascii?Q?knbFvxpZOHBjD5Du6lQEScjBkbumIlvcV22bI/RKUPad+Rsza6HCWytrK/Js?=
 =?us-ascii?Q?dRRsQCg6tyZxVH/2k0EsgnjJxZBxoDYVly0e3H0rlnRVqyiPgtvg5ZiFKAtp?=
 =?us-ascii?Q?FR03HTmaZOnm3CuvbmQcRcEtQkv6LIQitlUhSKdxx5Zh3RBQTqi5WwUFImGs?=
 =?us-ascii?Q?nkD/+NPIXDlnEPK+HE0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b70df0-879e-488a-4051-08db70f9acaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 19:16:24.9272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U42sMpq6Hg9U2Os9gO6tfEq6gkBRf0K2Oe07NPZx1czTYfSByxJ4Sj0q3TaggHeBeGJizg0gEvQvmAK6V+KMKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6096
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > Add external_interrupt() to dispatch external interrupts to their handl=
ers.
> >
> > If an external interrupt is a system interrupt, dipatch it through
> > system_interrupt_handlers table, otherwise to
> > dispatch_common_interrupt().
>=20
> This naming convention sucks. external interrupts which can be system
> interrupts. Come on.

This name dispatch_common_interrupt() comes from arch/x86/kernel/irq.c:

/*
 * common_interrupt() handles all normal device IRQ's (the special SMP
 * cross-CPU interrupts have their own entry points).
 */
DEFINE_IDTENTRY_IRQ(common_interrupt)

Should we rename it to device_intertupt()?

Thanks!
  Xin
