Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4B472376D
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 08:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbjFFGSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 02:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbjFFGSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 02:18:37 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726E21BD;
        Mon,  5 Jun 2023 23:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686032316; x=1717568316;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fbh9XCahgBFmyVT2gRCZ56ZAYqCHx7X6NVd/cL/MvZM=;
  b=bqlLIqhU9ai01eEerUuuQWPhIsW+/N9xt3U8AnRhWDG34oTYYrvSJy3i
   4GpbsuIdwmHKRfPECDTOYLN4cZ4n5thajTcE1uppjzt/gSos7zIGTmh4u
   tGqNgW4V/tBfeKCn/1hazaVOJks8s+QKOMV0zSTRqEHyBOK8LlFK5zJfp
   JFWMOmS5gfo4E1V0J93IygnpuAclk/jnCb3kIBE9oTPSePbZDk1mScHa8
   FAm/PCY9MioCzrb9XdgJm1w6X7jHsQpK5eJoxfja7YecjJIS3bHMM8F3j
   Ypjf9/1asdYNrAwFzmgC4JEVEqx2bTRTKGKPdtDxz2j1WVhWp4WzeKpgZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="442954764"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="442954764"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 23:18:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="659393600"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="659393600"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 05 Jun 2023 23:18:31 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 23:18:31 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 23:18:31 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 23:18:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kn9jznIgqtScMAoG0JxGHm/q3n7mZBIyEb0V2Zn365Ygy9612OMdhORqtFj0SxBd3BN2szwhrscggAnMllGqr+eS/gz8r+rGlw9NNwbBZ0ugclXYhlbJrfFqC9y4zE8L5oBWGbWcnHbD7pHhJj4uH2/Sp1Twt6/l4FISXxvx9FQm1OwX2Qp23GPGlPVIVuLVtSVS0C3fEd15U52fIc5crIDJLau8DdNgjan1oXsGcSW54BHlAUseJcqBKR9HI5teK4oBimfQqY5tA6Z46aEp0a23q1cX37ErRdrDOsRdce32SMlOiN37QkWzcuuo4GyzzbpQVP+f4h4sKaou84Qfxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MfqsgSxYe3Z8SbtYSJj9j7lI+t5Nw5DSNV0DJeEstJM=;
 b=bz4JTkAXe1OpCDriZhUfE6WjtjQDU1QAOnpCxLlWPQi8Nj/zpx6aIJETh3Jiidh2lJcbEByg5MmSAOmXusp7kRGph6As7/1yilLYnPd+ktWRW7t0UxiEizkx07PgCarc7kcPtGSlRDL/uDU2+S6YFa/Uo+0VBq0vxSemQL/UL+rH10hjNIhYXr/8i6niYYl5jgtUYsCBvKkl8Kq7fH/YUJLONGQ3yjfwvNcFBhwMVIxYePSwbjdA1VVJw8mvLzX/+OIejj925hXbPTN3bZ000n2fZU4+Kjclz1qxHCkuJ/npd4CuFT1D0iiN/QTrw2DQsr/3deJG2eyoWST4vvsQZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by SN7PR11MB7090.namprd11.prod.outlook.com (2603:10b6:806:299::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Tue, 6 Jun
 2023 06:18:22 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d38:3229:72d:88a4]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::3d38:3229:72d:88a4%3]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 06:18:22 +0000
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
Subject: RE: [PATCH v8 30/33] x86/fred: allow dynamic stack frame size
Thread-Topic: [PATCH v8 30/33] x86/fred: allow dynamic stack frame size
Thread-Index: AQHZa4iiz71eBkvk6ESYIcvcz1ZsbK98mC4AgAEFnqA=
Date:   Tue, 6 Jun 2023 06:18:21 +0000
Message-ID: <SA1PR11MB673430AC2D6F20C5F77FC83AA852A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-31-xin3.li@intel.com> <87wn0i578t.ffs@tglx>
In-Reply-To: <87wn0i578t.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|SN7PR11MB7090:EE_
x-ms-office365-filtering-correlation-id: 2918e6fb-734d-4054-a101-08db6655d400
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E3AMz7clYLCJmahI8a0Aq7Id2hDW63AfQAMNUWppaXXOUaixJrVYfuhJMM6spKPgN3q2GV4hNLsGi194kwAbsr9fWQ9oM0CFOuAZu5GPUjbt2QOFSjnhrs5syTBWjS1ZDehIqXnc3XjC0Gl+/Zk67h0xo1dDO6jhQXvYOJobn/9lmRKvzYxk7nEck4+3aJH3cDBsFFxV2mxGFbVAN0gS3nkR/S21HOmeKPGjzM3bPJk5jB1sYMdpcj/V5PIEhdfULFOuLh8BZiBDh7KhiWTVJbbHl3tqHRqKCCHtChOz371YEn0MTsRMjVjV1WU1xWellUlPrnivKNFqv4pG+fwX9bDbitBI1CBFbXODh0UUcqaGCR/vUgZta6x9cXiU0m216uEeDRDMdGD1l6jOqykvcjZ+qXk/4csLX8jfjn6IgrtTbUK7o0vF7odsgNlIglgtgcYE2acrH8y/N8k1ubOmduI+ywOc9phq3PS95+v9LrRCiFZzPnlFn3pIJeAZGCbFR5gyxZFDpTFeIdClPO1iDgFM736KNKWsE4ze0gFLGGNU4K5t46PS69h6IRCXYo3pWndI630oq7edh9kQC/UIL8hDXhWp/3JQAFscbjpdyxtuCB018tVGH1VNSEU0ZYyf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(39860400002)(376002)(366004)(451199021)(71200400001)(478600001)(7696005)(33656002)(26005)(186003)(83380400001)(86362001)(38100700002)(38070700005)(122000001)(9686003)(6506007)(55016003)(82960400001)(41300700001)(66446008)(7416002)(66946007)(76116006)(66556008)(64756008)(66476007)(316002)(4326008)(52536014)(5660300002)(8676002)(8936002)(2906002)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rAwaK0LR3XewxppwZE60wC2YjKq0D9Tke/Qljyg+IheokG8rXlBJAymjdLGD?=
 =?us-ascii?Q?Yb0/yVOut5DwF7FEc7Ip9HI8eMXvEHn+kZ7RyZ9QDuBA8dt7ZjaVTYxm9H12?=
 =?us-ascii?Q?fkChbhGK9X6aSH8i0khvuddooCCDgJSnU9bEIQas0BhkZIKtUCS5QjwJAeL4?=
 =?us-ascii?Q?FdPW7ivHxonFSTbg323mMbaIoHCwFxnyyTHXSsOmjaAZM1HfrYUXWVz9k+P5?=
 =?us-ascii?Q?T0Tp9mPGLR3bVIDVBOpvHiy88CrlXFSyQ8X15xwgPuNsqS2eA9MgKGmcgMZ7?=
 =?us-ascii?Q?fGBnFMXbg1rbtH92g9EK5M2locyTyYh908OK/ztsi6f2eOCps74veNEcFj2j?=
 =?us-ascii?Q?fN/T5c+M8cTIy1nL3GF5YClWy+tsQ8A0996RIZEyeYgK5dS6XxXjFZeZf4AE?=
 =?us-ascii?Q?slQQtIS3datyH+wvKVtTACQwvFGJhE+34FoFsudohcgQ9EMMVtmHnlbTS/EF?=
 =?us-ascii?Q?XGQyaCGeVtxb0/EPpbyEH+r4ir6bC5lud+kWes7S3pQf3rVk/ckKWQ1rim5L?=
 =?us-ascii?Q?j1Y6JE+uboE5HaEUg3X6v88ME7GRO2d9wzGa31gSkcGA1+seX/pIxQt6BMUJ?=
 =?us-ascii?Q?RMyChOw8AHH6j8S5hqn4BYxF2DJeUekktRJRCyk3jfDaqxXknJwdshERUImj?=
 =?us-ascii?Q?B+2NT0TzLbge2DvNHqmLITMCJoOtggZcLw2ggDXPBg2TZLNGwG2w/71PcKDj?=
 =?us-ascii?Q?MtF4Zx6X22aKpDsDrhwPbj+YUDaY88M8N118g7OMwH0xAXp0mYPexd6KBDd+?=
 =?us-ascii?Q?lDufiz+emDseHy5SSMC9nLyhSB7oX7qS/bK/x6QgxlNcqpc9MJ+ZCmE6z5KI?=
 =?us-ascii?Q?3OmJg6jHfQSIWzU27kQBRYvF9TzUEh6FPidQRRFYSLKZ6Wk0i8WCm6gNOeps?=
 =?us-ascii?Q?7SgTGJ/hrXgR41dadUFXsHOypDSv2X/R+y8gKULiRuaDQWMW6JLprX38fBLM?=
 =?us-ascii?Q?FBOT9o2OKj//cTLuuYZ/YGzcB7aTDLpeDf0ZXbnksZgKTlBU97oIPDuHWqUl?=
 =?us-ascii?Q?htCUzieukn0yIY8iiIubTtrZQYgGVGBelgov+4aOk7mXHJir7JGk/XuxgYNT?=
 =?us-ascii?Q?Kb1NMZuqq+VnUufxj/NEboqUTRJt27nEmVdSVjTLdtHlG37G2MHLmLLnVr7t?=
 =?us-ascii?Q?IRWVK2eji1nkRZwIqH2y5i34zs8dNNq1g5uADHGRD6TODq1nm94WYekMx0Cf?=
 =?us-ascii?Q?E5eZdBV+t4oRxsN6mdHNEi6vpORvbwbQ9n4Sj4Y0unYfymmbUEacRSBzpkDN?=
 =?us-ascii?Q?f+oUJI/Sa+J3EFsnbPnTZPVBxoRCa0N9w4SNko1UNdrHTQ5iWGaCmbYwQmjn?=
 =?us-ascii?Q?vkfDeAEYPHIgX4qM45MOybabr4LyBBop1CHSAEVKBmEW4PpP5zFLkesx7ce+?=
 =?us-ascii?Q?hSiNvzgjA7MA1fiz5/zRG/HBAs+Ut6NRMCB8Xr4cZBJM/JYOld4XGupRr3Yn?=
 =?us-ascii?Q?xpW1WAWvzw2ZtpL1YN8br2ARnDTEHilAj94xNFo5nGLS6iI2kLo/eaeWSGDT?=
 =?us-ascii?Q?7POIjJNQp74O+zBOwko/JNrnbT36c2fkLC42zM8uL6U1EwtLrepBUuGijzZI?=
 =?us-ascii?Q?judkYu+JULpM3Eblm9c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2918e6fb-734d-4054-a101-08db6655d400
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 06:18:21.7557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3h9HlHSoufLCc+mSpwUMuugHPcfOPOv9VxnaIA4h2QPwYejxNKC35NlHEfp9ZHdmRjWfJdKyR7l/zcUh7AzFjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7090
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > A FRED stack frame could contain different amount of information for
> > different event types, or perhaps even for different instances of the
> > same event type. Thus we need to eliminate the need of any advance
> > information of the stack frame size to allow dynamic stack frame size.
> >
> > Implement it through:
> >   1) add a new field user_pt_regs to thread_info, and initialize it
> >      with a pointer to a virtual pt_regs structure at the top of a
> >      thread stack.
> >   2) save a pointer to the user-space pt_regs structure created by
> >      fred_entrypoint_user() to user_pt_regs in fred_entry_from_user().
> >   3) initialize the init_thread_info's user_pt_regs with a pointer to
> >      a virtual pt_regs structure at the top of init stack.
> >
> > This approach also works for IDT, thus we unify the code.
>=20
> And thereby remove the useful comment and replace it with an undocumented
> macro mess.
>=20
> I'm simply refusing to review this. It's not my job to understand this
> undocumented hackery.
>=20

I believe it's a nice idea to allow dynamic stack frame size, at least for
FRED. It's totally my bad that I didn't make it meet the minimum standards,
I will rewrite the commit message and add better comments.

After a second thought, I probably should only apply the change to FRED for
2 reasons, the change seems problematic with ESPFIX (which FRED doesn't nee=
d),
and such corner cases are hard to test (self-tests needed?).

Thanks!
Xin

