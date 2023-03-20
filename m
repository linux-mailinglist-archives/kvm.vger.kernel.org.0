Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544D46C260C
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 00:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjCTXto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 19:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjCTXtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 19:49:42 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF6530E5;
        Mon, 20 Mar 2023 16:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679356139; x=1710892139;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Zk4O7hF9bYpxYM+W34JdePDf+JKxL5hj+UwYmKmEWtg=;
  b=S3c/4btKhCW2gIvIL/GXXqUr5Jh+44dxr4Z0QZa/ldqj0BjpdnzQCh7T
   qHuMZ885FrWO+tVKRA1e7SMQxqH4ie2zLIy0Dnx5gNcn8yM3W4mgJ/Ujh
   YXI4akC9DdgYisB9NuGcXFZnrJmLK1X/Nj5U6ijjMyGr9SVC96OHnbbnk
   MQVl7OaAE9h8YR+EJ+kW1LROnXupwldehzosnqr6qlIypGLf1tE+S7+v+
   4fxw9GCFYHn6uXyaaw9960ClD+atMNlnnpYgBPn4vbH7tZOMaTDvlIi+f
   dCHSQW8vlDSYv5jrkcNA1lCoyNMScNJ7qTl/f5zxBc5BOTV3ksNvGvG+x
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="336310637"
X-IronPort-AV: E=Sophos;i="5.98,277,1673942400"; 
   d="scan'208";a="336310637"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 16:48:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="855458463"
X-IronPort-AV: E=Sophos;i="5.98,277,1673942400"; 
   d="scan'208";a="855458463"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 20 Mar 2023 16:47:59 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 20 Mar 2023 16:47:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 20 Mar 2023 16:47:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 20 Mar 2023 16:47:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UdfCN/VXKITcIt9Vz+T8EitcCVWv6HRIXCZa4vQRdIofcopy1W+YZB8y88HbhFEwB6WkkXgbDMFxJAHdnFU9Cgks9VeFspc2msdXATWzCd594oLWi+c1/Ktux7MN3h3KGrH0kqdMy7ZNpbQRpVjEgfieXlUdqiSotd3nN6BVkuqTGpLyCyjVMbbMi3UFoNDBYYF8URpQaCziKW39aC2Rj3c5qV5HPndT7rKJONIQeeo5+zRl4IJtq7zhz9vnJZ4stKRsLKv+sS8rpXaTutQau0N4+iMRJgLqAUxUYupUsipQXoS5sbfrCIKrYHVS2JLq/CdXBKrdnjXoUP3fbLsVgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85me2D9qsSEiLlGqtoCuGgG9Og5XF+pjeQ8IazlNWJk=;
 b=hSvcbngnp3GrCjFM5G33OGU9zCiEBQfmqqgMZpG3epL5YC+Kb0XNkAgn9RDBx+Jbuia+jQIPPJ/EbtzLvc64on8h0TevokWQGzvIjocVzone0BEcL+GV54UCdo6APUSQUbdctfl1IDyssfgDu9QV71EvyGSdaFg8n5KocP/Cu/HhYVFXjQpZ0n3crlLew2aBgfxAxIy0j8DpyQA4W9cbf79tozn5cVHEFbxW5hGTcWsplH6b9fXc4fmP2knpwMXYLSRd5C2KP5qTpUSTKQT16TYyKzGhRWF4JjHrsrG/HTCXwo2gtUnAkXFT0lahGpJIPTEI8CqDOQ3LaKWf+oC6KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SJ0PR11MB6792.namprd11.prod.outlook.com (2603:10b6:a03:485::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 23:47:23 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::7576:1f4a:2a6c:72f7%2]) with mapi id 15.20.6178.029; Mon, 20 Mar 2023
 23:47:23 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 04/34] x86/traps: add external_interrupt() to dispatch
 external interrupts
Thread-Topic: [PATCH v5 04/34] x86/traps: add external_interrupt() to dispatch
 external interrupts
Thread-Index: AQHZUKGztfjifB1+wEenbg44nnnakK8D4jgAgAAjLICAAGT1oA==
Date:   Mon, 20 Mar 2023 23:47:23 +0000
Message-ID: <SA1PR11MB673441665AA79735E5EA60C6A8809@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
 <20230307023946.14516-5-xin3.li@intel.com>
 <20230320153630.GO2194297@hirez.programming.kicks-ass.net>
 <20230320174223.GC2196776@hirez.programming.kicks-ass.net>
In-Reply-To: <20230320174223.GC2196776@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SJ0PR11MB6792:EE_
x-ms-office365-filtering-correlation-id: 8e2780b2-82d1-4114-903c-08db299d73e8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mm/Gxk6H9fM3m+O0+ICmmbincncRwEj4uBSEl1ykvsqDWY17tty9vwm2ZyBO3ocYOto72Xrgw/RH485/RbQ+hmt4gkQycC/LSE/VrdcdxEZADyEoMi47+z5d2czSIB6otMEdxa2iR1Gt3dJeznQN9eaxOMLXAcLySiuYOvvWDJs7xrmSqFSe8Nvu5Iei+swN3egOvqQZWFYOOJAwSL+kE+nsGiZivSRT5HkzF4+sjtU8dB6Qq8LTZLKsKFPJCJsoS9pp8PGyrOvHRWR8JTrK7wIQrOsuXbvln9+I32BL+gsgcdw+14HlmPrrTauopoDkyeEGRMz+/S0T1WKLCHWsKJ0V42ZTDgU3HJ+V9InsAOolsqKqEiKeAadu4i1h/u9u8N5FV6AVdkUbJohMkjDkZptjMNnfcJxSuuhz/tewTt4Z+9lxzO0/TpMYvMUZCcvkNOQ8ekpyPEJQRasdAv7VZH2r08oLINdIV0rSRu705m5nNH8kDCrHUqTeJabUoHdXDMokB7Eh68CEY6p/WfvJFbpMdrv9vWhu1WJBlfUiyboLaSXzwMQFcTXVSOaodCQmuDFdlmZ4tHcJSIBGiRp0vamPB5nuvtksvq8Wcv51SZBiC4oTHzn0MN345BonyMU7ue6/z2nbaxB0PlmeaRTGtkCBB69hqfX3IfZWIQSohwUlTPX/b+fDIMjAUh1XgsgmXFGnFe4pSC6mAfd96+u03A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199018)(82960400001)(186003)(9686003)(38100700002)(122000001)(2906002)(26005)(6506007)(38070700005)(5660300002)(7416002)(4744005)(8936002)(66446008)(76116006)(52536014)(55016003)(66946007)(41300700001)(86362001)(7696005)(54906003)(4326008)(66556008)(66476007)(64756008)(8676002)(6916009)(33656002)(478600001)(71200400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1Ey2FioZ3LIbDad0z6WM/bAkr8yUoOtqtryvoZV8eMeyVVOpN5i8PowdRgwK?=
 =?us-ascii?Q?iNrXE6L4AOsOA1hdEaNplULUPUokV+HwdC4O5E6HYvOH06Z6vDWdFNxbIP4O?=
 =?us-ascii?Q?qSOpShul/xU3nr7Q+NpyCW3XkAgjugqAS3JBRm6xJ5z/MHhU+sd/ikppVL3/?=
 =?us-ascii?Q?dIvKBwictE1LUbo6RI33e/nQwLWc6ZmanbAVjBUsLET7CWzB6v8zaZICZSxI?=
 =?us-ascii?Q?aJaT/VniERcaz2Aiggxml9XrXbBTYbz/ccRKk0GflJx/XxD8avzDvNMUaNxF?=
 =?us-ascii?Q?xj1E72gdly39tWXcJGJuaM9jTySeGeQVFofMIWVK/HSXovsbYHRGTpVHGJZ3?=
 =?us-ascii?Q?C/I+h1i2Uzv/ykE/yBvxjZLKaddqNGBKJQj69gSwyrb+2sNalpvVBYDtJcxs?=
 =?us-ascii?Q?nmuya5IKu4ovMlR8tLhA8iaFfQ7Q3k5n1tiAY1giOTNJkbI8h8CE3dM1rD2B?=
 =?us-ascii?Q?4IMKhW7HAHh1ag9esLdWpli3mGsiRBgLSr5jYhmgQekhYV3VmKYFhZkVWxT9?=
 =?us-ascii?Q?FkJQ3+ZOSoGK2+26x5/52wSD2MoTdY1UZcFa4tWJBJeUOnILkDG6r23DcfzI?=
 =?us-ascii?Q?dgT5K7MZDkYw2euIBdzcRg9lNsci+UJadTsPdnH6X92F9fC7aXW8VcTIKToS?=
 =?us-ascii?Q?gOMLNXunnzWbhmG6+lPRfIVf0c5THT4DLoIfvfPU1yU813e1sA/V9eDvAiak?=
 =?us-ascii?Q?s58dpaPEY95+SomQBp02cyWrmndfqS+CCViM//+e326CVj5hwjG3jsb5rXy1?=
 =?us-ascii?Q?WkiR1ExkAGBDbznHyWqMQxViYGBXcBNu9yV3jpKacEXiGYZyMuxEIdQGNZ9z?=
 =?us-ascii?Q?xGDBzEuCeULJVdUjojg/UyWAksFIZiJx7wsa9NY/cFWShTYRNhErEWeu7E9M?=
 =?us-ascii?Q?LSs+TLiaD09R87tqTQ+clCTMEmh0oeIeTrNgwlgNEhTtK+apWcdKxJJahesK?=
 =?us-ascii?Q?W7CuPi3HmkvCF9NmduwBGbVWYkEh0blmuSG5p+20jQr3lJBREr0g05UEF5g0?=
 =?us-ascii?Q?KEX53Lp3mVjjR6Np8ReNDL58Cy/ct5n+V+55YPptqRS09xZ4YABEV94FP++K?=
 =?us-ascii?Q?PBAudBB5UHrG5lGfTEYNW+K+tXwwIo+VsDsqQ/3E97GmMZPa/1ijtFTCRy1I?=
 =?us-ascii?Q?oHS9YzBIaci2RC9hQd+8FA/eb+cuQ3NI8/1meBPbegIMyKIrW2yTyPOBU5yo?=
 =?us-ascii?Q?K+8xvRSZfDbxTVbPstVMI3b1L3Z7oFhH7K+w+bDyk+phdefTkzqb5asHhij4?=
 =?us-ascii?Q?0BEnx/vsOTmyRc3Xxr5ITItDvsbh1aBjN63dulNHXbdREwkgI7ku3aVQlKYL?=
 =?us-ascii?Q?h2rkUfI7dOFydGR2Zg9dYvrSfi5HK3M+wGbmxouhL3nkf3MdZULckm6Hva6c?=
 =?us-ascii?Q?rH1FHhY7wU54GgZs2bX3rm3sTMIb2Jf61EgqOOk14JH0hXZK5CYHYyJjNkWE?=
 =?us-ascii?Q?DrL1OK8wCscMFj7huaefIFXAmpc3Zf6mox1nXaSoc+Jh1yt5frjUvt2WVRHk?=
 =?us-ascii?Q?f7X96LIsMLcSTuIkJ0QxNvTSIrDDNVrpARwROnii9CjhRjirDCwlqSvAoDx/?=
 =?us-ascii?Q?b79xLTje4krh+gf12cM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e2780b2-82d1-4114-903c-08db299d73e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 23:47:23.3970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PT6EN0cdX3R+iMNBYA9kJfZYXW1H8oSOIkxrBQQDacByKYaVVbJ3lPTbCQZ4v1XMWhHKw6sy+3sX7dILoKcsjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6792
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > +	if (sysvec < NR_SYSTEM_VECTORS) {
> > > +		if (system_interrupt_handlers[sysvec])
> > > +			system_interrupt_handlers[sysvec](regs);
> > > +		else
> > > +			dispatch_spurious_interrupt(regs, vector);
> >
> > ISTR suggesting you can get rid of this branch if you stuff
> > system_interrupt_handlers[] with dispatch_spurious_interrupt instead
> > of NULL.
>=20
> Ah, I suggested that for another function vector, but it applies here too=
 I suppose :-)

Of course!

We just need to use a wrapper as dispatch_spurious_interrupt() takes an ext=
ra
parameter "vector".

Thanks!
  Xin


