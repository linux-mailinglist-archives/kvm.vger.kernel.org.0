Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797D05E621A
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 14:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiIVMQU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 08:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiIVMQR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 08:16:17 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CAFE512A;
        Thu, 22 Sep 2022 05:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663848975; x=1695384975;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RSIkUqwF1ZnzWy+6H43tRHwMk0WUs/RiAvPGzP9Q7Ss=;
  b=oFocfaMPi9DBt6f/UpFngA8iS3y5z4SBzpQrVCQP1OZbdbYPsqxba2Q8
   wWzuQIXupSLbLdy7yFGmg1f5BFllmY5NRUYmbh8yHxTk+1JEXAeTDJ0Ea
   1L6CSL0G83eBDIgkNU4C+im2kXRRiFTsJSTAKxVBTCEkBHGiHU8S0JsF4
   wJNX9+PsistQqKPvl3l3q/z+PVE0inut6R4no2dR+tOfjjK6ElCxvA3NF
   GquYk44Mp1lTT5jcjOoca/yNEc3D/GU4fK5Q9F6fcbXrdwpli8I/ztra7
   Wz9/TnMIH6IWgKus/0QOkwEgBIkJctEiNTJZVrAQlBIEpbmliQP2GLGCH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="280649017"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="280649017"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 05:16:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="570939552"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 22 Sep 2022 05:16:14 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 05:16:14 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 05:16:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 22 Sep 2022 05:16:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 22 Sep 2022 05:16:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xl/W8fVyZXpjRLVkrQS19qVVEoZqfatXPnubzYfFTZON66cWzGaHIgqKuXoo/JATFVgrR22UJM8hOMUEMa8CAbIznpo7mEdeyZ2OvyZNVAjpl9gbYUvQTt/VAz4kzX0UPsvQMeNipPzgmsW2da6NYMT86KwW+Tzqe3SgaSYAeSMz2v8JSyJ5tuLop7FSsThgmTzsZudG2h0tx1z4XrMDxOPe1VoZ7O7n8Zpn0BP9WOiE9TXBxuSDJ45hPeDLp9YFvdcXCLyJdXlcIJ5s9OINdwEB+XEadXxhI5iPL15zioNztG/aRrytj2f/BilgFNlXZmmbpKC29oXFTeaogJbcpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O1aXRaHb54blRgUlqHqSiuS7FID0RwMTlGweY2tYkQQ=;
 b=Pi/VDYHq/uCCzOBa/6Rkf2gnpqKCRexJDCtX30gHk95ZAoa1/QTZqeMCFqLrbRdqeYrOhvia935NFdvUYdsOEU/KHUqMChqk+44zFA5p5+WpHfFtotektvwiHz9ArSxN3beGnfKXSi1WrdyUB6bFtnst2egSTmmCCd83sQw3DMRnn155rL/Gvo64ytqRDqEtYbYPz7HBIURbv5Zlcf/GVuixVDb0LV1oZzCi2dtBBJgcFA6/VO63wPoOcmZcuB0Kxk3CG+Dr39knMOCcjpBOExuM9CUqVLumL7AxM+02qKp9xu8PZvhqrmqftdH8y5VH3Yot/EQNZmWwN9RWguF05A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 IA0PR11MB7188.namprd11.prod.outlook.com (2603:10b6:208:440::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 12:16:10 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::817a:fd68:f270:1ea0%7]) with mapi id 15.20.5654.016; Thu, 22 Sep 2022
 12:16:10 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Alexander Shishkin" <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>
CC:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH v2 1/3] perf/core: Expose
 perf_event_{en,dis}able_local()
Thread-Topic: [RFC PATCH v2 1/3] perf/core: Expose
 perf_event_{en,dis}able_local()
Thread-Index: AQHYzdmS5cJRyY6p6kagl/IIgs8y763q3Zkw
Date:   Thu, 22 Sep 2022 12:16:10 +0000
Message-ID: <DS0PR11MB6373E03E51A593E1AE74B259DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
 <20220921164521.2858932-2-xiaoyao.li@intel.com>
In-Reply-To: <20220921164521.2858932-2-xiaoyao.li@intel.com>
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
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|IA0PR11MB7188:EE_
x-ms-office365-filtering-correlation-id: 712d2630-3c2c-44a0-5eca-08da9c943c3f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: invQlhGskbX6bzHHbFHp4f6pAWu4fHsRHO+1etVaeIbFOEYyXNfuJb5li1UBUPfa+v7G4Lfo7F3sWFYH6485BVXEqK0eHAvWQYCJ99wGFSzMx5VYlvbbV2dNARGCAldfaOcnGPRQz1mxslITaQb4ZTtPjxzAkPeFqHaLwKpgIgQZFGtPMRxEJjTl/R3CEC0J9UR7QfMpi1deamvhePqFIGS6LbkhXMPNXYR84QTHgcx5KrHVmLkMiuQffXVwx2j3Y7+TbYWY5qvpzrkBeaGBbQttTdPniIzaQeS08LdKS7upjsN8c84l5KmjuBN0FSTcbx2AYcuWOCcG4hrOeNs7vX0mgri2onAwyGpugh4uJ1PzzXijD/HpuaoYR+ClZaypfh508I2wPTo6IIgmoNMv02jMeoAeN8LN87W0BypD9A/YR61XJiSaTrjSDNvuM1B5nAfnUqNJXbd/3fb/w1PeEc56JuxoGrxJVfyiRjvLkvKbmhUQh2K9fz+FCLL2OXtjf3GNL9xz8I2cCwuWPx1eA8XNkwSmZHXLCq0Ew6pVVMcPWdmppRJe5wkvCiXcA4eWZ54bJc58ztr4cErHmDstDQCWv/b+7G//DU5RW05ctCmVqp0qg7gjcxzgUPdMFRiesk6KnjlY4d+lZGyHQj+Z8thY9VW11S+rnBRfSDoHjUFPa7vmewc7iT28m1wSgG5DTdYoYY3ql45iEH8JKRM33wGO1VS3jB+4RG1X+WaGYOzprnyqeFWn0r19C7npH+XGHcl5nns3nJlWkx20ii7cGAGus4Oc6gSbAYwbmL1ieIE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199015)(76116006)(64756008)(66946007)(5660300002)(66476007)(8676002)(52536014)(316002)(66556008)(4326008)(478600001)(8936002)(66446008)(9686003)(26005)(53546011)(7696005)(33656002)(7416002)(41300700001)(2906002)(38070700005)(6506007)(921005)(38100700002)(82960400001)(122000001)(55016003)(86362001)(186003)(71200400001)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hGtsllanZxIp7ul3PSuyp2Vxv4VgbuKKqT1A25j/Q6/4h0NZTg71QvQCsJHi?=
 =?us-ascii?Q?YFV+QhAzQUQj+YnImteAMaXK3TRp42eQNQH7VvVnGlt9ijDX3rrb8WPMnRzX?=
 =?us-ascii?Q?FiscjaD9wcTfaEjY10t3g4XrmRu5oE0XHJ98P73hLdpWI3yxwK67lQy+4drF?=
 =?us-ascii?Q?Vm+st9FU2xtbapeonslkLr802aH/H0exTe4R1KjnlMbuJgsEmZGcl0Qet/C7?=
 =?us-ascii?Q?N/q65EgZe6hNjD8ZXyZ1+L9soaoydvTJi9XbBuRYjKZBEvOxKHpZyw/Gq4ck?=
 =?us-ascii?Q?r1WkS1tolKgluhIOXDlSfKQNtagE5SgW+T/D8mmN28SLrVuEJ71Y8lY0IWsa?=
 =?us-ascii?Q?GaotfuKgnM9mcxp13Amu50cw3h1TnvJQnlR+9nLvnrceWZ+YyC2oXFJ9/ixN?=
 =?us-ascii?Q?Z3KQA/E1yl97gtvHTKTIRozM8IN5oF4C28YpZeisi6TLq04uo0cbCLKE3MXl?=
 =?us-ascii?Q?EMCyg+LnbAEVuwfg0zBNPYs0s5vDOrjgDpT8QwSJtMt4GOxNkuw3Rmt3JELO?=
 =?us-ascii?Q?fxV6p3M/tpgdouzSsbVMlBtTmfj11vkRYlkafOBLRurEM25fg9flHn9Dzp/J?=
 =?us-ascii?Q?qeij65/3MzAL94xV6wGbYe/+8lrwv5rdTBHVjlY2qyhKSCYx+Ks1un3umMQm?=
 =?us-ascii?Q?Qb5GEHhXjfT8Jpw64GD5QHatVPGEncK/jO1aflCRo8w6J7saHQl9RvGCJD/c?=
 =?us-ascii?Q?aM0I7IxLXQJ2ADlHYenUC7ikh6VqWxktqnJA//wilul07hUB8GXmwqPDcD+5?=
 =?us-ascii?Q?LZK+UuS8vw5rK2YHTp92qwQRWPlnhOeNMKA+iIutvhsxOOXsNvXgVoT87fts?=
 =?us-ascii?Q?ecw8PAO8LSAZCJ1b4ZVaIrPu4tPcqegoAdEcx9bwTmg595zXfrjRxiXxUmre?=
 =?us-ascii?Q?0RGzo3Tuo0jLyXdnp2e7d2LFX8FDFpD5mVmI0NJXvyhv40pZvhZIp7Nqm3eN?=
 =?us-ascii?Q?Li9WAf/cZCDu/YNs7FUQO4Y7/80a3OdjkBJ9YhKhrDH6crjJKaDrgaM4gAqz?=
 =?us-ascii?Q?+rDlz3x/x6BEoqlRMYou+mG/nTlZUxbEZIXlZnTY682LErnyYphK2aE9Zwgy?=
 =?us-ascii?Q?rTlH9+OAsE0v/f2cLp47/F58qGXQp0PIHdgd6zhftcZ7xfLzIgVqmkznFWhd?=
 =?us-ascii?Q?bKuc1a7wRy76uXIIBsGhYaSpnlEc0ZIDIdVWxI4dE/m/c7JfWKEhx2YU/C9j?=
 =?us-ascii?Q?qXVZGvporGUYJvbPOHuJBmjx95VbMVj1rezfsffpYaNhA/OH+lCIH2rAfIAR?=
 =?us-ascii?Q?waoS/3jIkxjPbz6vXp5MVzBHhdQks5VBpxTRn4sGuzfsDcbqUhVWv1oRHNI6?=
 =?us-ascii?Q?7H9UVVl0zvDV67cTeCOvjEohEgiEh42+jr1xWpfXYJTPBbUeXavyI8kUBkpA?=
 =?us-ascii?Q?fJrBMlwEIL/pGPNZp76vc3fXXMNXRJnha0ui0KZ7H+6+mL/nWFfkX76BKx4V?=
 =?us-ascii?Q?5lxFx3o0LvTbU4RHf9+8tkKouvzPKudM6JEaCiO7osbGiMrRZzRsv0MwU/3U?=
 =?us-ascii?Q?4xCgLuD162+5oZLziVVJemvPiA+uwRn3+ynPEBMXjmfUFymGDgZRpbGaLiHg?=
 =?us-ascii?Q?hKgHgudA80+EmfdCrcZfJEYJv18mrFw9SKEClAc4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 712d2630-3c2c-44a0-5eca-08da9c943c3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 12:16:10.6069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CpsKR3AADwW4LqhHRzW/mC5nu7wOL2T36kdtBrB3hoy4QdrKQVbwGkiPW6D8z20KWij8By5pq0Vpod3Md8IUtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7188
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, September 22, 2022 12:45 AM, Li, Xiaoyao wrote:
> KVM needs them to disable/enable an Intel PT perf event before vm-entry/a=
fter
> vm-exit.

I would explain more in the commit here:

Export perf_event_disable_local and perf_event_enable_local for perf users =
to disable
and enable perf events on the current local CPU. One usage is in PT virtual=
ization
by KVM:
- before VMEnter to guest, KVM calls perf_event_disable_local to disable th=
e host PT event
running on the current CPU, and this reuses the PT driver to save the relat=
ed h/w states.=20
- after VMExit to host, KVM calls perf_event_enable_local to resume the hos=
t PT event on
the current CPU by having the PT driver load the previously saved states in=
to h/w.

>=20
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  include/linux/perf_event.h | 1 +
>  kernel/events/core.c       | 7 +++++++
>  2 files changed, 8 insertions(+)
>=20
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h inde=
x
> ee8b9ecdc03b..fc5f3952d6a2 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1472,6 +1472,7 @@ extern int
> perf_swevent_get_recursion_context(void);
>  extern void perf_swevent_put_recursion_context(int rctx);  extern u64
> perf_swevent_set_period(struct perf_event *event);  extern void
> perf_event_enable(struct perf_event *event);
> +extern void perf_event_enable_local(struct perf_event *event);
>  extern void perf_event_disable(struct perf_event *event);  extern void
> perf_event_disable_local(struct perf_event *event);  extern void
> perf_event_disable_inatomic(struct perf_event *event); diff --git
> a/kernel/events/core.c b/kernel/events/core.c index
> 2621fd24ad26..8324bb99c6bf 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -2446,6 +2446,7 @@ void perf_event_disable_local(struct perf_event
> *event)  {
>  	event_function_local(event, __perf_event_disable, NULL);  }
> +EXPORT_SYMBOL_GPL(perf_event_disable_local);
>=20
>  /*
>   * Strictly speaking kernel users cannot create groups and therefore thi=
s @@
> -2984,6 +2985,12 @@ static void _perf_event_enable(struct perf_event *eve=
nt)
>  	event_function_call(event, __perf_event_enable, NULL);  }
>=20
> +void perf_event_enable_local(struct perf_event *event) {
> +	event_function_local(event, __perf_event_enable, NULL); }
> +EXPORT_SYMBOL_GPL(perf_event_enable_local);
> +
>  /*
>   * See perf_event_disable();
>   */
> --
> 2.27.0

