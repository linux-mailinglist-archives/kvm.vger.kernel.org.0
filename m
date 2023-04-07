Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB326DA94C
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 09:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjDGHPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 03:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbjDGHP2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 03:15:28 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161277ECB
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 00:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680851725; x=1712387725;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PHfG6XX+eROmboCbGnRwkLg2pMegIOliwEv/pCTaDzI=;
  b=WiWz8o+UlnEU16uCALHaFWplnK/hF/6R0U/DadZmakjhaQ+9hD8V8krW
   t9J62PbqpeDpBLk6GQ1n3N79+FhzvLw8xqMZyXRB4bNz4ecstUQpASv67
   6zAcuEeiKg511v7tmNuMBLEHIY45aUonb8FugCu8objYE1xxvghs6Dt9Y
   fkEC5SBI6lx1TH6onn4c0qwNOpqsZrLTXsp0rpfVWVUJGwMgIIGAlB3+t
   9sQQcXSRqD0pa/g0NVatS9aqVEkWReTkJSntnhwFnQVdEn8QJAm9sPfZR
   L/UT+DD4yvxNQs0kVvBCOW/l/Wt0CfdguG+sAhKp3xecwhhHi1ny6uE2o
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="345588396"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="345588396"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2023 00:15:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10672"; a="687439909"
X-IronPort-AV: E=Sophos;i="5.98,326,1673942400"; 
   d="scan'208";a="687439909"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 07 Apr 2023 00:15:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 7 Apr 2023 00:15:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 7 Apr 2023 00:15:24 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 7 Apr 2023 00:15:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I9NbQSCRWPK0nzBtpAm0Acy0rjX2WbJVJHz+244Vxswqq5WGOybadfVBEaY8HNwWjKFqktFHaQkElCm5yj/75FiO2E88c5upoP5GaZ90iPtUT9dhzxbLTPNH/+W5Aoy/9J4Z8lMjV3FWOfQPqsgtbVzonkdFRg4V0ZHjuUIjvzTiJD8u+FvemYS2IreAedhTrlv9weglGC7iGRPkZ7rDQuCiM/pi1h0k0ipPzXtvZ5S+hZtlwa99+2bSgkm5nufcX9tAdUPhEAJTdLbZmn1aCKDkcq2p9ivXlb7xIawvdgShEFHb4QfOl+/sfEIQZlExAcwOl/Q9Ubux9lVKJVVYxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJhakdGMJApXczPMAXktLwau0ussCiajITl22IS2lBs=;
 b=Cc776CamRt31HXfebp9PF5FhVn9z4zoTkRESJifBe0B66uVTHDL6Pu+1q8r16l09pXm4ggTzSKEyg5BP0y8VNDWRaN/kRp72DJ+diF7ja77kzM8gMoFl0SvOtbGMEaH7WtAy1yXDnYIioxmEjuYN0cb7Fa9tH3st4fdUbjZ0p7CUnfTHGJJ+Z90E4cZ9pTz/rKp0JDRs6XL8+bQ9u4872pcEYEcMkpY46r1wRy7pmZ4TRA7xAE/FXcaSP0PsOHeOE8AqyDs17CWYKWuwf5IpEYxW2mCOyUm0r19UOl7wRImCchi7xIww9MhshvutM9W6M+1Qc+GHbMFV9/QGbYiSww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by DS7PR11MB6037.namprd11.prod.outlook.com (2603:10b6:8:74::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.33; Fri, 7 Apr 2023 07:15:22 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::5dfc:6a16:20d9:6948%6]) with mapi id 15.20.6254.035; Fri, 7 Apr 2023
 07:15:21 +0000
From:   "Li, Xin3" <xin3.li@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "Yao, Yuan" <yuan.yao@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "H.Peter Anvin" <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: RE: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
Thread-Topic: The necessity of injecting a hardware exception reported in VMX
 IDT vectoring information
Thread-Index: AdlnGoO7DMFQx8JhSoqsl2dQLdydDABDU48AAB2Ml1A=
Date:   Fri, 7 Apr 2023 07:15:21 +0000
Message-ID: <SA1PR11MB673433E396709D115897255FA8969@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <SA1PR11MB673463616F7B1318874D11A3A8909@SA1PR11MB6734.namprd11.prod.outlook.com>
 <ZC4hdsFve9hUgWJO@google.com>
In-Reply-To: <ZC4hdsFve9hUgWJO@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|DS7PR11MB6037:EE_
x-ms-office365-filtering-correlation-id: 63941719-a9d1-4e8a-98f5-08db3737d988
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J9mS67Z7vhCn3HZ28r0/1zyYl6ybZXkaZOoRn9HKArNBQzS3Mi/UaKacgH28uGJF4E3FDAounN08C28mZXNkO+PENKtgWoIJoJ1f55tnQ9Fzx1NVOHVXbi6rXdbW+p2B2SmWZhUBG3dko/wRJHrTsib+v5Y7GSypK/m9CIb3bD7suwt5cBXJzc0+dopM1oq9iZQf1e0RDBXbq8ttcRXQ7PQDcEnKaf7Kwhw2SBEViNbpGdlLrjtlFLb32JMXPvhLMRA3GTrpJblur9F1/5PZsXITo2KRJA6mf4ylM7HspLqPd/HsqPSKwTDRvOonlhOzq065f70OjQHQKZC59UmOmFj4rJAvQgB0MUp5jJbNyuGKJLDNSuH57nGEoxvTjktYozyRyzFawd1hRXZ+o+8cok6yt050ZfhFW/6YjiGBEOnbyHh2FJjXtGjS/Th6SqwzDwXKVDS0mxLT4XmSxqKXarKcglOU4wVcqmeK18pErA204F00x1o5lLL2Ff3gYQ5es8BckngCGgrbk+iudQ/yKOBH/qqY17s5eu5DshkA297UczJyANwMPoCxqHWyZVUAKNvTAsQYaNX75IUy/Bd8CuDGasqYNfW5aLjbwtZBjbk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199021)(52536014)(55016003)(122000001)(66946007)(66446008)(316002)(66556008)(64756008)(8676002)(66476007)(4326008)(6916009)(54906003)(8936002)(5660300002)(41300700001)(82960400001)(478600001)(76116006)(38100700002)(186003)(7696005)(83380400001)(966005)(71200400001)(6506007)(26005)(107886003)(9686003)(2906002)(33656002)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yl28o3ZPTzgQFDEPLm0N3+cpvUUcpSgGnQeS3PWJ8nWBXSsUi9LF+9x700aN?=
 =?us-ascii?Q?X8S6BP2NAiqNJM/RSmmpGQXDN7UW3DtzidpAdfq+np7/ma5amGY/YF7lRyvG?=
 =?us-ascii?Q?s2qk7sP677CRBHYxw+JywBwukWumhGZ1k4H96gZ+C6NvP56xY2RcCSWezzsq?=
 =?us-ascii?Q?Z3DKutTt6HPGJ6yM8RsHa2YjGM7oE6gYw2i0eWlZzSdnwG42+WP19OsQUkVl?=
 =?us-ascii?Q?kQOrGoXSudV3/RrAtBYKftAiZlOTGPqlpESH15UxcXm4mGNNurVt4HA6tBLv?=
 =?us-ascii?Q?fncqnNTnrecurDB0GQIoXzy8xJz5sDjxO8BGDgqsswHbeulBnSoAztEWMeLw?=
 =?us-ascii?Q?oW2hD91wEgWT4uJnfFp+fdGXgPgrJ5KN/fRP1hJ3qkilu0Rm4jo1m3mTO7ri?=
 =?us-ascii?Q?zqkvNpvDermFshOrs3k3euDuRnw3EJcAJlpb7lOc6kLAV2rvB4GahFh4Nr8B?=
 =?us-ascii?Q?Pb8CrJFN3T7o57ezZGU0+x+qRmPJu5dUpT0VuQ0kh/uW87tNkn7ta8eorQN0?=
 =?us-ascii?Q?vDNe4LOeZZ5SZECndSXTIEqJJhUOtKzcmjvosozIo4tleaqvtpGPn8mP2W3i?=
 =?us-ascii?Q?Glil4or49PU086I52jons4cT9ko5EtfZHCPdlW29/xhEjjK3/UkTvxJc53pE?=
 =?us-ascii?Q?XR61EPMju0lBus/Te0hvIStqsXMSc/404HncJE/MgLE1o7UdOsYIsBB9cdC/?=
 =?us-ascii?Q?qwCjsTl6vSJlRWPOkspDCjmrsRY8inUKOX2KDU1ZWwpyZcbrWnDOaHmX9Uei?=
 =?us-ascii?Q?A6RlZhR9pNTD5OOU8pBZMDU53NjVhtGuecM21Tj1oFAfdJyvOAC/BPhAtpkV?=
 =?us-ascii?Q?ONO7f1bxSxmgKsOBij1dofw2xLyPOs2fS5gPERjLuOFoypYgWTmr7gWYq8oy?=
 =?us-ascii?Q?BZ0Eu7rB3pZ2SET2JPjnkYQtOC68pYqGWud2rC+I/SjA3G2Fh/EajI/VYALT?=
 =?us-ascii?Q?N9zIwBKU+cubLr6TsLPTavfEPyfQtkTXvnHfqmJBVEGWlW8y9xcLdalazWld?=
 =?us-ascii?Q?ld8Cg6KQVJBMMZpP/K0w0T1Bd8JXGewutH3xU4BSGrIQrSUp1HTMORLPnXC+?=
 =?us-ascii?Q?xYSjRaYa9Nwx2uExomMotI6EjkrAtaxq22/leoMoeQhHP6fVUrSwOR6LnP1T?=
 =?us-ascii?Q?3QB2g2s5dMviT7tV8DW3nnd9UkL4zRmQGPRoFk4pKrFJSiFU5pZld57VjZd+?=
 =?us-ascii?Q?HC6XSIZwKIhofFc98+g6cd89hLJ2HPUnzSXUfqe/keXqnfzzx3FdOE31fxb9?=
 =?us-ascii?Q?RzMDnEUTnTaGSHwnnt0jAUBIqt1YSVEEqBO1km7VuV0VDDcSK0Dph0we8Nav?=
 =?us-ascii?Q?dfinOM9N8mjk5bU6QvKYHP6qNoHe1mybV5hFq/sZ8Gyj1G33ur3fAIopZ99P?=
 =?us-ascii?Q?0RXxjQn5xnylFiQV7h9MXIU1n5yxQO/ok9QAiiLk51iowf28CrbtBpSLOrwT?=
 =?us-ascii?Q?rLkhtoNKQG7I9BLIlj3h1D9itXxdHV0IZlC/EZAmaWYP/LAahkFR4YHAZ6AD?=
 =?us-ascii?Q?IoeT+Gz8ujiXzjC/IBrLboNXA6nojTKiB/kLVP/EcjwG1HmpNjCctl1eLxcA?=
 =?us-ascii?Q?2zc/7bSLYOwAvI8Ajp0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63941719-a9d1-4e8a-98f5-08db3737d988
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2023 07:15:21.4817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eOrOhXSFHAWU7vWtkodsWUXsdcVrlc8yTBFRWLr/wvflEo8D9ui3cifZXVEBScIVeloLorOXQADljrC8deNZdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6037
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > But if KVM just ignores any hardware exception in such a case, the CPU =
will
> > re-generate it once it resumes guest execution, which looks cleaner.
>=20
> That's not strictly guaranteed, especially if KVM injected the exception =
in the
> first place.  It's definitely broken if KVM is running L2 and L1 injected=
 an
> exception, in which case the exception (from L1) doesn't necessarily have
> anything at all to do with the code being executed by L2.=20

Didn't think about this case, but it's real. And KVM must inject it.

> Ditto for exceptions synthesized and/or migrated from userspace.
>=20
> And as Paolo called out, it doesn't work for traps.

Yes, to be a bit clearer, AFAIK, the only case is a #DB trap, whose event t=
ype is
3, i.e., hardware exception.


>=20
> There are also likely edge cases around Accessed bits and whatnot.

Do you think, for a hardware *fault* caused by the current instruction, KVM
doesn't need to inject it?

I'm thinking to add comments about what is crystal clear, what are still va=
gue,
helping whoever is interested to understand the scary details.


> > The question is, must KVM inject a hardware exception from the IDT vect=
oring
> > information field? Is there any correctness issue if KVM does not?
>=20
> Yes.  I'm guessing if we start walking through the myriad flows and edge =
cases,
> we'll find more.

I do want to see such cases listed in the comments whenever we notice one.


> > If no correctness issue, it's better to not do it,
>=20
> In a vacuum, if we were developing a hypervisor from scratch, maybe.  It'=
s most
> definitely not better when we're talking about undoing ~15 years of behav=
ior

I also noticed the original code was from 2008, early days of KVM.

It's definitely safer to do so.


> (and bugs and fixes) in one of the most gnarly areas in x86 virtualizatio=
n.  E.g. see
>=20
>   https://lore.kernel.org/all/20220830231614.3580124-1-seanjc@google.com
>=20
> for all the work it took to get KVM to correctly handle L1 exception inte=
rcept,
> and the messy history of the many hacks that came before.

It's a fundamental job to inject events from IDT vectoring, a lot of proven
reliably working code are based on it, I think this is your point.


> In short, I am not willing to even consider such a change without an abso=
lutely
> insane amount of tests and documentation proving correctness, _and_ very
> strong  evidence that such a change would actually benefit anyone.

This is more of a direction check, based on the case you mentioned, I think
I have the answer already.

Thanks!
  Xin
