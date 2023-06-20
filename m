Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD09D73608D
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 02:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjFTAQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 20:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjFTAQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 20:16:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C72AB4;
        Mon, 19 Jun 2023 17:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687220204; x=1718756204;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5Skf4uhghb1DRGH5NzTD0evLHcx7yvnugWy0ENm+2t4=;
  b=KP4mhPuKSqF5iCGlouUF1GWHL11nzHjib1ngZh5VW8Y03/hiyC4HPDFJ
   CjaKhcvpUuYR9WrD5q44fKhjclrnDvgHC/ad9fMXYzDDeammKLOzvMjrx
   2JRXNtUxSl9v9yBKyQwT6w4tmng26pRPljoLrN6Qgd1Ukvs0hn5IOQu5G
   9A1apJKf99gRPO99+nZ8DP/3ZZZQsk1UWs1FvYsVZfkhVyiZbxiZEsX3m
   /vbCNk76xbufCtJrcH9wVXEnCb9kXGQ1/woAtH4pC5C5J28vI5hrd+v0x
   vImWkY74UDRqcCXe6YkKNSZyB9UNskNrap54xuti1AqEwYFk2L/eJSadC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="363159397"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="363159397"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 17:16:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="888070213"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="888070213"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 19 Jun 2023 17:16:43 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 17:16:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 17:16:42 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 17:16:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neOmiI8jWh5Si+z5RVXBMtlXawm1KYR7+QLUSnjBvHB3VO82RSnGw3aHQHWd/LvjagA1NM5QaMxstwvQ0TuAkRCj9uULVTLLFW5WI27gnHRkC1eqvYGG6LlXqto/j+9yUAQA4fVuhPqrVO3W8mYP7kTuuQfHkm6UTNKAxAYI1Tp+VKUZLtWFI7rcIV7ixmgEjRQ+23WgntJ+Z0D2L5dkQQN/sV5SRnHD7nZngWL6gwEMlSHpn/QI9XX6kv9WsMvd23sDzoEJMAVZLH89QHxlkKlA/fNhaHXz/PgunkYTXq7F7S2fmZL9mZQIB1DaoWsRl7P7AtLZ1GBYzIbyJwR/Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C3eOT2YX9DCq5kI9BqTGebr0SXpDew5mwDms7Zmlnq8=;
 b=O8dea2a9xy2inPHNDBJrLTm41mrrEu5fmkFvn1ZEDZSRAqIm9Q2X1TBEJcTGI2YC7IRrRJ1DGhhXGFlRQpeFAARrg5qiSejSFJzN8iSgTnu13yzR0u2TUhX0ObarDw3QFvF0Jinr9Yzdbunhv0DxR1eOSbo1VVYpqUqYNl2O0kT7PuG9bRn+Rp4TnbQt6waNF8EpmWBtWdv/FTGdDhtNhLsLWGj2b8UWBO5rMUZG0lrI9CM4kYBzxWVRakhWZ0rZ3B3vc+fZPb04ubuQOBAoH5SxMUZAmw/uoi6E4C7Sg6laoKJ354K8MSevo2ILEVOWHiKXQ3vFb4ZYowq/CF9HGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by LV3PR11MB8577.namprd11.prod.outlook.com (2603:10b6:408:1b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Tue, 20 Jun
 2023 00:16:38 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::c016:653d:c037:44fc]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::c016:653d:c037:44fc%7]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 00:16:38 +0000
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
Thread-Index: AQHZa4hBNd3d+GJ9EUqzqD+DP4Ohj698clwAgBZ2AGCAACZBAIAALadA
Date:   Tue, 20 Jun 2023 00:16:38 +0000
Message-ID: <SA1PR11MB673422CC60B9A9C4F875AA76A85CA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-6-xin3.li@intel.com> <87ttvm6s2v.ffs@tglx>
 <SA1PR11MB67340ED76E3707707D1D61A3A85FA@SA1PR11MB6734.namprd11.prod.outlook.com>
 <87pm5rp34t.ffs@tglx>
In-Reply-To: <87pm5rp34t.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|LV3PR11MB8577:EE_
x-ms-office365-filtering-correlation-id: c87aefcc-d90a-4589-3551-08db71239daf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U6ucTJ5da5Xta4WNIV1HVEVqj+CK6EdSTV7mCLm7RW1XbbZF/aHn67Pmco4ABk6E4+P0fZhSMwoS34+OQnbgS+f+DDW5gVXnyKE7MmDo28jwAp+rnplEZSg4aUUmY2D3nx+LrjOscQBB8IA4G7QfSmdsEn5I67Te2lzo/sE+JKtB55BmlGAXvwxUDxUe4AoSZrHMbmaKHMcK/F1WiW1mE3ODf4RDPuOWygevV97Xm87zKOeC512TnduAQoEDnZDBaukidcsdiHIKA6J32J7cZpn2ruJwbOpXcaTYjCC9ybNHGbrlfcHDknTC9KAsaMfzRfFUiSaJ1MNOaMo47GNUaZwSOuDCZdcMm13zA974/Mc6ZX9kPtIgUD/jUPUQL+jxLkwd0s9DOdaoRMIWyF3TTpYQJPmaFKMIJ5Qyinh//E9Vor2jor/uZKxbo+sivjIP2p94fypGsSE0ML/XZvjlhb0Vzb2ilFgwsM7+PaDWTXDW3yqKoQdiJCVe5db2jracRRkq7R2/F0KF8S6P+I7bDP9rF382blpLdydTN2XgyTyZZWTftrN8Bx8ZJnpQkrBTiUDolgStMg8Uv2YDkIoXoYSQ5m5U2JudTxOTk+Rn4OJEm9GhxvLe+ulRK6SNPdst
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199021)(52536014)(5660300002)(7416002)(33656002)(8676002)(8936002)(66446008)(4326008)(64756008)(66556008)(66946007)(66476007)(316002)(38100700002)(76116006)(41300700001)(55016003)(86362001)(38070700005)(4744005)(2906002)(7696005)(71200400001)(186003)(6506007)(9686003)(26005)(82960400001)(122000001)(110136005)(54906003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Mco6zH9BkbKTniRanH3SYrs5UgMbvRxJ2m/3bzGLQh72mQoD9wSHs/9bDIuS?=
 =?us-ascii?Q?DFwEM7yLyieVmhuskMbKDGJV5Vi00ovkdznqcD6u5Pv21Djday++70kBFTJ9?=
 =?us-ascii?Q?ie6l1xd9rXDdAlWXqK1xCdns91iM7xd8pJT62PMCuINS0DOdtmpiYqYZvdsL?=
 =?us-ascii?Q?Th6LBGQxMn4OLW94PmL9uPtxKFb0aRDA9EV6rWVzP48UceyqPCBn/1xk+4wd?=
 =?us-ascii?Q?q81zsLu84KiOCQiKvDrIvtVX6/GcIRQ37iaHBRVE+gbjC4cREbsr1C7Dwiqi?=
 =?us-ascii?Q?wSv4OIwiewSdt36LyrqJm8+Of2TA0qxp/s9Y+BcKeY7sq27w2NvvDtWuRDGf?=
 =?us-ascii?Q?6dHKGJarqbQLB0l62DrAATNr7njIXq0FZ4YnIziAj/FKaQE1cdO0e/KOP3tU?=
 =?us-ascii?Q?C7pv8ypUagUMSVrIZd0IPuz+X8Mw8ZVR96mvbLmIv3Yl0lZZvvDCATUcrctK?=
 =?us-ascii?Q?h0LZ2WwVz+EBXm0t+/J6oFRFwC75z/hFT/lIqbFQ17xgJmO1eFaw8lyLhpD3?=
 =?us-ascii?Q?zGoU7VEbgWEDdNmOjfoAB51t+LeEIDfWe+S6eTZbM3sagaMY2M2oJahlF5Vx?=
 =?us-ascii?Q?QXLmMdpTmoU4a9JZq4mugYv1DstymW4kwmFNrWS9QLMvYsKScXpEcNJ/0+IV?=
 =?us-ascii?Q?TTh703IaiGmbx9Sko/faQfQVhxZINxQrmfMno2l+D7NlJMMhK2gZCGmGM0qC?=
 =?us-ascii?Q?z+ERBKtEmd81RiQAkdm/GatZ+U2m6mMJnW2IDksg7xBX0AwW3JqACOflSPAf?=
 =?us-ascii?Q?NxIZscddeRJts3PQ46qH4Z+1B9/AQhASwiBQVseJvqsYdA1Q/xa0z9ybau7X?=
 =?us-ascii?Q?L4V3RsLAquOsFtxHcneGAB4ewn3KnqLbbSe9+F7mz24njp+/I1WS8Ltt+G5/?=
 =?us-ascii?Q?420su4orz000TZvxFK+UjF4HPFdHQNySECHkdILx3C6wL4VE4QMGjaEaK0Fh?=
 =?us-ascii?Q?iJZlSUhgi66uGaTmjU0OhqSp/h3dEF/PY+KWR1DP/C5ZvpepbmGFRde5P7bg?=
 =?us-ascii?Q?iWqUONOBCXOA277IbZmjIQqiCQftOtstwLkTDupMsKhnyAe09k3KuCOSy4ei?=
 =?us-ascii?Q?tKq5fTVwpkF66EhD6APkUw5JczsPpMSBbA7NpyKF5dMH7ol73XzQ3YztSIZ+?=
 =?us-ascii?Q?dK3O1ObMTP3yu8rIePxqu4/nVxOylBPg2nH28GoEQsojcymh64xIQvHszHGH?=
 =?us-ascii?Q?DThk5ka/4P4L7G6HcTJKG1d5gbbeLgSDALQSmkixZjgHkxD3Rv+Xfjv3RJsp?=
 =?us-ascii?Q?psol9PhUIygJYDvKrP/fKTsutZ2Z0yQ9W1ec0DC4ChAn3C9G4J3inb2Wkge8?=
 =?us-ascii?Q?b4AzBUlJ2g2O+jNXr+VtKZlHgE6+oppXY0D13IOZ79U40MiiQzl/JPp+6ypd?=
 =?us-ascii?Q?yhTv6YAEzN2rPHXEAkOZugn6hcWL7wum4niJozMjetUlnkuewrny/BTGZNpg?=
 =?us-ascii?Q?3y2aEmVebFsyVflg4U/doscaD5p1jt8T6lJivGybvFs3P58Z5lSH+koVmGmz?=
 =?us-ascii?Q?rH1n+HwdIyCYnN5tlyczxpK4KCC3alrjHyqZ4VaQJFnmTaKl48Ar/G+nCcRd?=
 =?us-ascii?Q?aCiT7fFMZqNZ6cqpQm4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c87aefcc-d90a-4589-3551-08db71239daf
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2023 00:16:38.5738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VBf4LKCNBVOXKLNbNnts3nnyAv/sSJkiIAtlDm7rbOtFm4VejzQaGhW1gD7O1ck9KyYnKJmCjhBZ5xlp2O8QQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8577
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

> That's not the point. Your changelog says:
>=20
>   If an external interrupt is a system interrupt...
>=20
> It's either an external interrupt which goes through common_interrupt()
> or it is a system interrupt which goes through it's very own handler,
> no?

Ah, then it looks more of a problem in the way how I described it.

What I wanted to describe is the dispatch logic _inside_ the new function
external_interrupt(), what about:

external_interrupt() dispatches all external interrupts: it checks if an
external interrupt is a system interrupt, if yes it dipatches it through
the system_interrupt_handlers table, otherwise to dispatch_common_interrupt=
().

Thanks!
  Xin
