Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E575E6301
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 14:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbiIVM7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 08:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbiIVM7C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 08:59:02 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19A9E3EEA;
        Thu, 22 Sep 2022 05:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663851541; x=1695387541;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=T3a24w4C5uk0cjQbUzRymKe/+Fbe+c04blAnKTBq8So=;
  b=jF+ROalA+zG7Z9P0im4VCeqGXmimefVVTXZyYMMYyj3g82fHgYmEbgOl
   kPiLIryMAqFEUt454sPm+KXM3SXSZ3FBjqvwCZG5pjIhgFpHa4PB6tiZj
   1rb9RpzB0dp/AGL4O6Pod2+ZUY0pkCgZ5hcLs0xOuny5lgmqnmyaydYOh
   UmF0vsmI7P2frWD89Cy1PPraitpAS0gScTjRq6N1XEMWZ6VoO2Y94BKyV
   mfUnQecoIG2DrBqidkkpfEChx1zV/s8uJDm9kk+ZeokF01Zb31qUh/q2u
   qy70WDUJZu8lpAiutEQo7ESBaEbAvindeCD5yGfBSfFRo4qjHjI/9gIyV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="299003798"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="299003798"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 05:59:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="597421348"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 22 Sep 2022 05:59:00 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 05:58:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 22 Sep 2022 05:58:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 22 Sep 2022 05:58:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUoHfAbec34U8gd7zIsQwqIN595+UWpyOA8GV1nfh9ynIB0u0XTD1jROlc4FegzPQtFkpjWtqyN91jpXxieAupkKxMGorRM+jbHTwSCy+SIIRPRiWpSloCgHnolaQxaIGSNrq8yxEL5o9tLh2WlDfAMkeh+S7FZO5N8h3cVHqzv3+Qaz/7IQxNlnCaV/fZwex8oI4dSuoDMXKbUjxqXPJvlIYEPzFYGIur8mujD3WdtjYVsrokGL07YG13rtgoSmbfo1C4gMeVc6+SJBkMzHLHuHRsX5L6vvFC0WVA9gvqJb9eqD6cPcO5qYQaZjoOAjFRVtuIwLqWLOv6tllhwFfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T3a24w4C5uk0cjQbUzRymKe/+Fbe+c04blAnKTBq8So=;
 b=V0YvsXtOohYwz29TWsHKBZ+je2h/oPCSFf0JHNgRVZ2/YDCgkE15R7g9/U1qRXq/cfTEKuHhAjlqnOHhWyA+7zPMxSAhOV4nwvKk2DZ8NRmYNsc/YP9cW/6ja6OzkTsTk/5RBELQ7TVxqqX0Ss2Ut4Xutd7kYqvyykl87Udxwrivk9kpCURjuF1qpi0wU/lxCGhiyjpXbdN4uP/Uj8mSL2aYQ1c7JdqBIRjfEOy/19I19NM4goSZIEam0we82B+jeQqu788X5AR5OAo/20OYx99MMKWc12sgxQuYfLahDOJ5wpHPeZ7G308txiL1h0vCwDCFjnWX2yVrtGu5JQT+Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 BN9PR11MB5257.namprd11.prod.outlook.com (2603:10b6:408:132::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 12:58:50 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0%7]) with mapi id 15.20.5654.016; Thu, 22 Sep 2022
 12:58:49 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Liang, Kan" <kan.liang@linux.intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
Thread-Topic: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
Thread-Index: AQHYzdmZiDfxfKVenUORyjhoUz2tZ63rY3WAgAAA7VA=
Date:   Thu, 22 Sep 2022 12:58:49 +0000
Message-ID: <DS0PR11MB6373C84139621DC447D3F466DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
 <20220921164521.2858932-3-xiaoyao.li@intel.com>
 <175b518c-d202-644e-a3a7-67e877852548@linux.intel.com>
In-Reply-To: <175b518c-d202-644e-a3a7-67e877852548@linux.intel.com>
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
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|BN9PR11MB5257:EE_
x-ms-office365-filtering-correlation-id: 6fac4f57-a3a6-4ea3-23cd-08da9c9a31b7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cv084SgqQvw8JhtKAxURsPs6tCNAYUNDi0Ko3m1nPTOmQs4Czcb2E8u2QwtsFB9KVanN1prm+Tld9KlCiI9xFefjBgni+LIsydDWd/IJ8eZIKyjQbzfbrPggh9tbRgBWyA5sxK1GNX0Evv+qzUeAWbfWTDe97ovKdHwb4TX3heQKos8qFwW2ZRYtY8Qx2Im33ZpcxBh4Z047DJ5gOrQ17+qfAH9+MRRgHi3896iPf5lTscwGelO9SBxcMwNcV3h7ojgNZWjcU0uM0DiIJpnQt9LCJSpu1YbTOm054941gOn/SawGR34cbVOH0FIAS63U2DdyCl1sliBcOPzaWPwTTF9gxD47ALa5Nj2d02SjpqA6QvyfOBS/p81LY4ZV0nVrwOyx/IVOhDn2rCP8GRKAIyruiMMl4JolC+XC2SCxGd/j62anmdQJrSsNqwB0BibGV/HXOiV/DLm9bAFGVnWLI9YdFjOXEw29fmaQEuGhgg+pyMMmdXmzrtDBSq3ZA2XOa+guaSDewovbcDHcaqxzYsA0k6VkdURUDozMXHHli/t+Tntvhob4KopNgF7hrdyIWt53lalgUQGUjxzs+fgPQk4tA9Agw3MU7ge2xhmEzHIy+v74ua4fXL9OOhT03F3EAx9jat9pKJJltHKtqhCwaNLiCNzhOL01lOZDHR/g1B9r/438bBswMzG/8ueO9R++64Wsw2K+YabtLVAmWlvhW5PwOCbYeR22U8onT/atOHhqSWEonZ63ssBZgAp8l/TNXEO4sQO1utvL6Oypr6/qqamldXagBnJYXbb7uAwklUY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199015)(921005)(38070700005)(86362001)(55016003)(76116006)(83380400001)(4326008)(64756008)(2906002)(66556008)(66476007)(66946007)(5660300002)(38100700002)(122000001)(7416002)(66446008)(33656002)(82960400001)(52536014)(8936002)(478600001)(71200400001)(186003)(54906003)(7696005)(110136005)(8676002)(41300700001)(9686003)(26005)(6506007)(316002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7SggBQoI5ZauCZbQ75aWFa/j8zcSJAxi0EvMsJkruhZDoMZwG0GALtkR0G0g?=
 =?us-ascii?Q?qxYjV+UzCgJM3+aN0on7p6fwOgF9bbtdO+YpT5uRHwcQZ7pzStHVZg/xJI+l?=
 =?us-ascii?Q?0FnOHLCdyjkTWSIr6vXWNRvuZacAWFcPFq90dFn71Tk9f7VvWG+o4t6hc9pp?=
 =?us-ascii?Q?ZP0o7RhxMNf77vtDVA1PcVMVHOK3/OakakZO6Zrz3X7I5NQ9rNtLRKmKYlDW?=
 =?us-ascii?Q?oD9hD7uCrb2cHZVhbBzR0eE85TPa3zcsQkxYKK1ljd1sOjgG8S9ViAvJm843?=
 =?us-ascii?Q?Hfeg2pAElI/5Gya2y5dtfQy0aE938y6OrzEl3qKq8MJh59hwsn1di7P7DerL?=
 =?us-ascii?Q?ZYv8rZTO6Hb8zno9ixQT3zNfDJwa2+cc/aHd14TrW2W3OlZ/curjhXDrDZfy?=
 =?us-ascii?Q?nSgqrsh99r+Bl1L+C+uRmbcBIo+qPL5ARPKENshXQkf2TyHjAIRwW/kObLcG?=
 =?us-ascii?Q?kWXqv9oEkn1JhYrgiDJQqbZ1E/FmBqvdmGwuYZaFkwgaoeFkuaaTy3yScNgl?=
 =?us-ascii?Q?rQSEIJxc5gjCWsoG4mtsFgRj5UieYFzdNC1QK6nwBLDuoKlQe97IpvIeI3lA?=
 =?us-ascii?Q?L4EzHuN5XafCIrsZBB3lDs+laFQPmjHE3hjkkw3vu4cDGgk0rGvaeLgVbvjK?=
 =?us-ascii?Q?VeaIHyh7IKn7jCSi4vXrqVg3jmYTC04LipTodBhLwqA7FdlQ9RiZAaPlX258?=
 =?us-ascii?Q?0mX3y+AHnpfnIQIQf2ciVInjxcAWdvNMaDDfPaHwpnqgoIOGrv6/tIz/Wbrx?=
 =?us-ascii?Q?QEJjg4+54iSzeozzipPyTFq27+pf0MlL0Fvx2kR/EHRGiFkgmAvOTdwuV8Bv?=
 =?us-ascii?Q?k1nuhFxg3ftC1NLMHVFYPln2Mkv05tmjRcHBL1CEI83RWZNLTCCilQQhT6FB?=
 =?us-ascii?Q?hmx0NauYHoHsIbJgcpmyMwQi3wM7/c3IY51Sltb0ua4420LO1tFqbk5EZET/?=
 =?us-ascii?Q?Afgmxi1KQStzPO/RDv0DT43O+CRNOx/yhiApYw3UUBZ4fQJEKKt2Sm4VjCHH?=
 =?us-ascii?Q?CoYI10AAbqTpClRkt/mLccCb7OHrKtVPUBz0UnSQrXwfYUlZ0ShQPhsruw3b?=
 =?us-ascii?Q?dc2xQxmuayjxvYpsfUaM0twBPksOoHU9TTyx1DXKKNXcQDGUhq5O4Lf7pFVz?=
 =?us-ascii?Q?1aAkCBZSCJQ6Sv8Jw3Ci788oE2/0SLC9buh+VDkIrCEhU0H/Sv5D+nFM+q/Z?=
 =?us-ascii?Q?kRdq/lT1TUtZSR8qzIgdAI8m7Cox3+drNx7NkmpJl6teJi+lPw8YFUdp3MqQ?=
 =?us-ascii?Q?KkAY5gikdWQSYXJJWzUpNdqrQ+avEe84sxCtrgwP1tSzfcJDiwaVfIgBa89t?=
 =?us-ascii?Q?zay2V/x3bmRqeA2r5vTiHvYY/hUw16XaRZ9kCoKE6WB8owBqVbrFaplBcnOd?=
 =?us-ascii?Q?dagO7IleLReYLUDiAAPwgePDBcRzXUqWA4ti6Bg7COV3vxSZ6iX6pGOYR+L/?=
 =?us-ascii?Q?DIqkOs5fd/D9ltn/omVTssHesgk1lvkqy4sZzXOpAh6xSPUum/72uRxXZJmd?=
 =?us-ascii?Q?oWiRCy2dnxfM9+6MDK341ena23C75Yn6ARTZjo6i9pUMtjrVg/oSPf8MHy4t?=
 =?us-ascii?Q?minLxeR+pkcGdoc9z/FNf1cylG1JEuimiE0YE0Dt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fac4f57-a3a6-4ea3-23cd-08da9c9a31b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 12:58:49.8860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xO1ajdMERHTNc4P1p/eymVY4PiD30RUlzXCsy0NURpWe+2JKbG60A9fjn/hOzW1zFYmBwhqCDVGhJ00rjiydTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5257
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, September 22, 2022 8:34 PM, Liang, Kan wrote:
> > To solve the problem, introduce and export pt_get_curr_event() for KVM
> > to get current pt event.
>=20
> I don't think the current pt event is created by KVM. IIUC, the patch bas=
ically
> expose the event created by the other user to KVM. That doesn't sounds
> correct.

Yes, that's the host PT event running on the current CPU. Not created by KV=
M.

>=20
> I think it should be perf's responsibility to decide which events should =
be
> disabled, and which MSRs should be switched. Because only perf can see al=
l the
> events. The users should only see the events they created.

For other pmu cases, yes. For PT, its management is simpler than other pmu
resources and PT PMU is much simpler. It doesn't have a scheduler to manage
events.

I think the usage here is similar to the CPU thread scheduling case. When w=
e have
CPUs isolated from the CPU scheduler, i.e. no scheduler for those CPUs, bas=
ically
we rely on users to ping tasks to those CPUs (e.g. taskset).

For the commit log, probably we don't need those KVM details here. Simplify=
 a bit:

Add a function to expose the current running PT event to users. One usage i=
s in KVM,
it needs to get and disable the running host PT event before VMEnter to the=
 guest and
resumes the event after VMexit to host.
