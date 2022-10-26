Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FECC60D914
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 04:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbiJZCKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 22:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJZCKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 22:10:04 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D7C3B996;
        Tue, 25 Oct 2022 19:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666750202; x=1698286202;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wm7+lbEuif54OjWmO4m8Bzr4t3MLCnTzvHrRrScRgfg=;
  b=SarjCvAh9FCtTYLyV55bYdRCYGxQe+k9xcCRvJF0wJRTUoB2ynL67jdD
   9Ol+KeMQ+DzfeybTGOZawTOEOm2dFHT1z78dhZa2qhfj0K4nMZIxl5Nwe
   9R92V+i5iWPuQ8GedSydCrQEU+jMEwL527uIyiKUP0NdW/zY2QcdAhySb
   ZbIF3nUIyHwzotOhcoMhCkzUMKxZ1iJzZOZUlaOXYh8x/Z/H/Lkp/nlDD
   ZK8ajEdPHiHlTX7NFYidmFcn5TyltPKtWtct+oMUIGaRJMF+aD9aLHz7y
   eR0F7RUfZRN8WKbx+Ip7OGHccI1YPN8f2dPgUiFEJcQ3/FWO0wkESJ8wz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="394151019"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="394151019"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 19:10:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="665123539"
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="665123539"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 25 Oct 2022 19:10:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 19:10:01 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 25 Oct 2022 19:10:00 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 25 Oct 2022 19:10:00 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 25 Oct 2022 19:10:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJ50mtVQNHbAuH9uu3zNkuOYjQqWskCBJvH5eGo8tRs5KY5X8NQpqvygeBytusbeixH4AO9FGEn8Iq1RBkbIwufIazPcI3deq3unIgvDa7FCJ/CRi12IETMfirkzbhvbOwsLXr/QWp+DGlGlIca3qhBi9SdJ8bJO992K62sMiBe/XyegkxNPano5ZD4u1Klsi48Df2BT6xK1SdeG2DQ9/pVexTxRB4bky/G40kZA9fbS8QwcKHJY0O+xTQFK6NDLU8Xhro/yYuJXntEIPMO5xg4f40BPMbXRZmPoXVs1w0DP2rEEwsf/ro4Knw1yeeenhNhfDKsRYgHR2+npUYqmbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4XzNpj4w0bLi2v26k5b4pqJipsIZumuzDE1G7xMlLgE=;
 b=DJ2NaPLleZIX/gM6AkIjsP+yjYiq6piNPsEbNFWs9JvH4mJJP3ma5FgfN/gjzjGdrfYfXeKdq/ib23QsSCBakq4nsFNG+/Sua8AlWBZOqin1KgS6bk7wrTp/iWm3pdC386Ol+rhlCZqHmNF8GOV7SJWHOkxHVi0ObxsXvMtcNeLxtuZC/amxQpJkklcQPRQ3zYIX9+UHbWVTrZYz3bSQD2c6LkChQ/R7nruBVlfKJ4rNAf//v2ow2sGuAmoJLp0mbpd9tAdjtxPRxZVcDGP1jswawwIlXJcAqNEKYqYF+3w0VeJk7v/pkL9WX/FF+XjyMvJ+S+QjIQq/33DBT8zXKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 BL1PR11MB6003.namprd11.prod.outlook.com (2603:10b6:208:387::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.26; Wed, 26 Oct 2022 02:09:57 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246%6]) with mapi id 15.20.5746.021; Wed, 26 Oct 2022
 02:09:57 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     Vipin Sharma <vipinsh@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>
CC:     "andrew.jones@linux.dev" <andrew.jones@linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 2/5] KVM: selftests: Put command line options in
 alphabetical order in dirty_log_perf_test
Thread-Topic: [PATCH v6 2/5] KVM: selftests: Put command line options in
 alphabetical order in dirty_log_perf_test
Thread-Index: AQHY5ZK2DtwRH96SdU6gbpj3kZHCAq4f7taA
Date:   Wed, 26 Oct 2022 02:09:57 +0000
Message-ID: <DS0PR11MB63738A6EDEAFA2CC05BBE14CDC309@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221021211816.1525201-1-vipinsh@google.com>
 <20221021211816.1525201-3-vipinsh@google.com>
In-Reply-To: <20221021211816.1525201-3-vipinsh@google.com>
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
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|BL1PR11MB6003:EE_
x-ms-office365-filtering-correlation-id: 44cc69da-0f30-4b68-0ede-08dab6f72e68
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +GYxZlrRF7gGQdcz07MQ0XRjSvaLUzmWX14a+uC2lH2t6brNzEb2J7Jk0OwN62OLWXZk5aDNV+XPeeiooz/xcCXQZF94/zXtw/QBnc3UtP8NqPm0IkfDMnKjhWB8xBAtmr/E+L89FEiZe4G3C0BNVDE2ry/cYIhsWCDdVOj6cTCuCU98+AY480d8JDBge6rWruXZV8Sdj7DNAEG75LB4+ftAMbVbVW/rSA6tON1vfDTkv3vWE+ABGfeE391AJYP4kIfZ89RX0p3yvd6OcXPQtaBmQhDVHa1l4jrCfUy+9aD/J50BM0oDc1Wdm4L2ReJbOLYNu9cMWjEhK3o8+RNgQPwKP875+0v5T93dhYkX/vkB8gGxWV/qy8eNRq8+MEFgwdw7Y2dUhz8DhSIDDV9/T2wmYmfc5QlJG9gORALb8zz4MBqk5YAuxUuwfiLoptGq6vNk/yVSvlvuPVOkRxBGCvP9MMxST2Rv+RGiHIwhm2Svs3xX2sQGDE8Fb8Da69AK/L0Ukt/ZgxbtrJQ+vUkZgdTm3OFCV+QyZEuCei5xmhOVeoZZFndXBfJgbqU09PQn5yKz6FvjtMLhyhoF648vdlWNCq6Vu0hyTrG6QXggi2cnG0htVAdje+BucgeZJ8oo+E0SamVYEzJIqchKYZChUqO+XNID++ThfQmAjnTF83h2qXUwjfRZJ8DbG6tqzfPUaGptR2pZY9cbPtoRLGcxnI9HTAVg3j51bpnFv/f6oxPet7S5P1BSOaoRH/px2GPMn69zliYnO2SbuPYeQDU2HxpT2Ela0V/xJRTF8pyF5K4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199015)(4326008)(66556008)(66476007)(64756008)(41300700001)(55016003)(6506007)(53546011)(83380400001)(82960400001)(52536014)(7696005)(8936002)(8676002)(76116006)(38100700002)(316002)(2906002)(122000001)(33656002)(5660300002)(54906003)(110136005)(38070700005)(71200400001)(66446008)(86362001)(66946007)(9686003)(26005)(186003)(478600001)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?U9ZW3zlgBtRJSh7GByMKDQU4yWISU6lPphvhQfP9Jg+70y3DR36GQcx5RHo3?=
 =?us-ascii?Q?81ecLxG7SVdaTV5qVFF3tjHdjvo/gDejK8veWOU5JBzOhP5QBnVLWlmlvuqz?=
 =?us-ascii?Q?ZSY9BYfFIVn3IlVSWE3lKy6rjhCo0COXxCN0UX7WGjCU5d+O84fegHn+YisP?=
 =?us-ascii?Q?O/ngVopQerM/tue6Fi6LY18bVcOaew9RK7q9S8oAdauBQx/Z/v8k21lfBQqb?=
 =?us-ascii?Q?2cJhJhctBC1IO51N97X9L0Jfd7FwYqvv2MvdEkL13gED229tfPuGk1ePxJGh?=
 =?us-ascii?Q?OvCRY2i0QACaKTX3T2lDkPz/gAr1imz7EsAQHL5fBaeApLxyIyngt9Y+yujw?=
 =?us-ascii?Q?t4uLXR2gjuWTr/FbuMsWSLm1qwVhVC6AbRzeBvldVgoi1jbMD3PtEXBPzk2h?=
 =?us-ascii?Q?7FSJSOx0XCYvngssmmKoOe3+Bf2d2oKtuj1nv6M/f+wFLKVu255My3zzj5+2?=
 =?us-ascii?Q?13Zq4TSGbUzp2u+8YQC9QQJRk54L7ZTd9z0sH2qIv55f6d9twpFzGHwBK1kz?=
 =?us-ascii?Q?4Ln8yk/Epihc5EkdacODlZKuIQP6FmmlwcEsYdskmHX3zAEsSNf8lUE6nKe8?=
 =?us-ascii?Q?usW0InEuWpH9HK1j7Zd1Il8Q25vXgWmSMHYNyyXmXj3HUhLeKer+i9fkJkjL?=
 =?us-ascii?Q?M09vKl2cdoutIJZs0CGUg88VZ/uiC8QVHy2Gih8FAmOV8HZHMjCG5Tht6wsP?=
 =?us-ascii?Q?Hbwu6Xen1G2Z7yzxUqffj774RNogr77AicnoY3ignVNti2+mK9omjOWVhJOi?=
 =?us-ascii?Q?Rmf/uLfPuGDQDk6j60QlIcq1/g0DFpUIPIMr+TLcVglea0RDI47lx5VlXCXl?=
 =?us-ascii?Q?IhJw6NlAuatjNkwdbefLMeGvy98FEUzOkQP6Kviv8VygNechcVQLuTa3rvlZ?=
 =?us-ascii?Q?OMlxVbieNIySMluEooPO2cWk/MLC7pkG8zGJVkqOXgz/IPKla4zxKiHDMJpk?=
 =?us-ascii?Q?ShOAVSbzAGVHrWiXD6VVWmrnh33Eiw2k5YqbB8hctOXzrFjFO4642P6bMuBv?=
 =?us-ascii?Q?IFYUMrFL0FfrKbZ9gn+oC/0QsKjX0szvnVxkUSj/VaPYN5/C8El1jI23YzWo?=
 =?us-ascii?Q?Rkh3eYphT/o5lVaj5d2vImlQw6FBMhI2YLSD1e1z7GlSaTPC86FibQ/53GMD?=
 =?us-ascii?Q?xodDYRoSm4en6zkRnLih+QJ7m1ilHzRCAiKwpPjXlbugxAwzv6ynw4871u2+?=
 =?us-ascii?Q?kZaV62UBsOU2CbMXHks2zput6SH20QpL0bCXEpLt6hEeAkB396ts1pWJPGWR?=
 =?us-ascii?Q?2LY1FJmaZpONCYm4aqmT6d0E+026BU96RPh3auMETFfQ7eSvZL1K/HIOi5+4?=
 =?us-ascii?Q?N+ZZley0YK2I5cbZoJxvGJvM8Z4ql1HALY1w3Zd+jicrQmpcOLIDffTNt0ko?=
 =?us-ascii?Q?vJwMWhNmHlMtcbFD00WCeI0ZwP/LBqxJWBw1lSPchGgLSei+wPPmufRpGCvH?=
 =?us-ascii?Q?97Es4ewIfWBtDNHltzMEZVMypX3c080i62vCzw7P1uNKCMxRBGZ2IJ4bbZra?=
 =?us-ascii?Q?FuDlHy3nNZGeLWGOAOShPlsW8pmq3iUfI+SmpuoyMbgom3kcIS87Y3OACMUN?=
 =?us-ascii?Q?W9dq52hYIH+X2ag1jPlqxJQL8hV/Vx8i2H6mLHyt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44cc69da-0f30-4b68-0ede-08dab6f72e68
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 02:09:57.7939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Aq/wklrnNKrpR21v/p8RpqWE/dHCHhHgu+F6IZtuDGt5lbLamMYWR8SyfOPS5DCNqkew1mMlMpWVhm5GhTfQaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6003
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Saturday, October 22, 2022 5:18 AM, Vipin Sharma wrote:
> There are 13 command line options and they are not in any order. Put them=
 in
> alphabetical order to make it easy to add new options.
>=20
> No functional change intended.
>=20
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>  .../selftests/kvm/dirty_log_perf_test.c       | 36 ++++++++++---------
>  1 file changed, 19 insertions(+), 17 deletions(-)
>=20
> diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> index 56e08da3a87f..5bb6954b2358 100644
> --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> @@ -406,50 +406,52 @@ int main(int argc, char *argv[])
>=20
>  	guest_modes_append_default();
>=20
> -	while ((opt =3D getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) !=3D -1) {
> +	while ((opt =3D getopt(argc, argv, "b:ef:ghi:m:nop:s:v:x:")) !=3D -1) {
>  		switch (opt) {
> +		case 'b':
> +			guest_percpu_mem_size =3D parse_size(optarg);
> +			break;

"break" wasn't there.
This is kind of a functional change (i.e. bug fixing), and would be better =
to be
moved to patch 1.

Other parts look good to me.

Reviewed-by: Wei Wang <wei.w.wang@intel.com>


>  		case 'e':
>  			/* 'e' is for evil. */
>  			run_vcpus_while_disabling_dirty_logging =3D true;
>  			break;
> +		case 'f':
> +			p.wr_fract =3D atoi(optarg);
> +			TEST_ASSERT(p.wr_fract >=3D 1,
> +				    "Write fraction cannot be less than one");
> +			break;
>  		case 'g':
>  			dirty_log_manual_caps =3D 0;
>  			break;
> +		case 'h':
> +			help(argv[0]);
> +			break;
>  		case 'i':
>  			p.iterations =3D atoi(optarg);
>  			break;
> -		case 'p':
> -			p.phys_offset =3D strtoull(optarg, NULL, 0);
> -			break;
>  		case 'm':
>  			guest_modes_cmdline(optarg);
>  			break;
>  		case 'n':
>  			perf_test_args.nested =3D true;
>  			break;
> -		case 'b':
> -			guest_percpu_mem_size =3D parse_size(optarg);
> +		case 'o':
> +			p.partition_vcpu_memory_access =3D false;
>  			break;
> -		case 'f':
> -			p.wr_fract =3D atoi(optarg);
> -			TEST_ASSERT(p.wr_fract >=3D 1,
> -				    "Write fraction cannot be less than one");
> +		case 'p':
> +			p.phys_offset =3D strtoull(optarg, NULL, 0);
> +			break;
> +		case 's':
> +			p.backing_src =3D parse_backing_src_type(optarg);
>  			break;
>  		case 'v':
>  			nr_vcpus =3D atoi(optarg);
>  			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <=3D max_vcpus,
>  				    "Invalid number of vcpus, must be between 1 and %d",
> max_vcpus);
>  			break;
> -		case 'o':
> -			p.partition_vcpu_memory_access =3D false;
> -			break;
> -		case 's':
> -			p.backing_src =3D parse_backing_src_type(optarg);
> -			break;
>  		case 'x':
>  			p.slots =3D atoi(optarg);
>  			break;
> -		case 'h':
>  		default:
>  			help(argv[0]);
>  			break;
> --
> 2.38.0.135.g90850a2211-goog

