Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52175A4420
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 09:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiH2Htd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 03:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiH2Htb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 03:49:31 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDE64F64F;
        Mon, 29 Aug 2022 00:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661759370; x=1693295370;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OPaFSyKKrEh5MFAOyjBx0rCTCEFrkxjeeiRiBH7zqYY=;
  b=IpfkKVg2aXp6UAGiTuA0+rrkeVN4eCY8AxEY/UJvHLpfIv7MNYLq153w
   9TOWZQtDcik/cVoAWmXQ7PZvDAmpKXPSTdZQYmlYPqDajFCimcAhnn1i+
   YH7FbBaAcyzzB+2AKncgwrtaAxupR+pUrPoj08c50pAvds8tWCb2ycQXy
   +DdZZRZjhJR4WhbM460mLvVdzGOLkeEE5+B2pkto+uP27V/cZJtFZqkzo
   ClxC4NK+uVIPBQ77Ft8/4E17jkDhNphS907WqTCaTRCKl14QEMoKkssAb
   5fc2Xguf8VyRqeFUALMF2m6Tw1AAU5O4NZvreKCfUqhyVOfQ7kkffrbHq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="295612492"
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="295612492"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 00:49:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,272,1654585200"; 
   d="scan'208";a="672281195"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 29 Aug 2022 00:49:28 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 00:49:28 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 00:49:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 29 Aug 2022 00:49:27 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 29 Aug 2022 00:49:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuIOghl4xnZymRBcQwzaHtmvDze7EEoonEy+iDwHX5a2E/rAK0IwLbrZsA//VttAPZGUc7PuftURP0AJ/ClDlwhoRj3+z9GHUlWHOYRE2sewxvpL2pJDvCvdr3KQ9vWMfrZUNXbmBFWrsznz9qylHNwM11Bo8GT0zCj5TAa+rC7Eh/SEFSHdJDghIEhuBXvljVI97pZCWLoRjUSq9uv2KZScsKV2rO//5ib0VGCahBbjRPKM2Ljw0svMTjhCPgcu1yOxFoRhXR4cbonN6GXYanf0Y2TmjPLkIVMyLmX/LkQPnmzun2P8haRzr8bKJkos2yaDs/p8wWozmBFBpXWkcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ECvVhbwW8T60mYiei5o5JASXMgXqtRSlUa2FQzgT4LM=;
 b=mZMKzN2el74f2XTO8vF2+8Frxw9Xi2xjqWtwMF0/hWmv5FWe+GNHtqwTC5tZ6GNLULgPFhxfc/DmBExcGtDT7u+8f0UbzuypOH5JzDqGsgi5nbczuU6Q0K2TFJ7TiR1zVbfbBnJDEm1IEkZGrPTvOhwy1Se0m2dl+lZZJC05pnFk0WUf4nwKKF03rWc1DTDPbk7zSgjYyT7Hrq1FoD/6Q5NE2pbKoD8hzTkH2N4BmfQoi/q9Nu4r2OrtA6/5lQMo7hiWkyBKV4Lx9XCjmlNs9fXP+8osZTbctdAdOPy89SVOEP4bPuI5zMD2Z9UhFPjwMXAxsaxRYZSLG26jYQ9e1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5PR11MB6365.namprd11.prod.outlook.com (2603:10b6:930:3b::5)
 by DM6PR11MB4057.namprd11.prod.outlook.com (2603:10b6:5:19d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.19; Mon, 29 Aug
 2022 07:49:24 +0000
Received: from CY5PR11MB6365.namprd11.prod.outlook.com
 ([fe80::4016:8552:5fb1:e59]) by CY5PR11MB6365.namprd11.prod.outlook.com
 ([fe80::4016:8552:5fb1:e59%8]) with mapi id 15.20.5566.015; Mon, 29 Aug 2022
 07:49:24 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "Namhyung Kim" <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Topic: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
Thread-Index: AQHYuGCfKwYxaXR4306din/WULaC4K3Fff5w
Date:   Mon, 29 Aug 2022 07:49:24 +0000
Message-ID: <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
In-Reply-To: <20220825085625.867763-1-xiaoyao.li@intel.com>
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
x-ms-office365-filtering-correlation-id: 70188c2f-438a-4905-3afb-08da8992fde2
x-ms-traffictypediagnostic: DM6PR11MB4057:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1M9+tr2lw/FVohpKTK1p8yTK68ID2TqdHecaHHz3es0ELBSw3uVw+ZmCsK+ozZJVw+KGkwNkE/rV/q64FgyY3aCga6neFNBq+2hU+Nu9HZd9NeALmjt/uJmqWevEWun834PmofTFdZeVLUbedtwD1kKfQz+xxwUjUQVmVuFdgEL1MQbSMceN6jpeysOPt0gE+iGWRINxUA75p75dvCXMBLw8PSop+peTidOAkGYEjrrcUDFZywevDUhG2VPXd8Wy+WicWgaBwyASqeK1mLYuRO9Cu0qoi2qKfbehmZkE7PlTHxPIxWsSl2gWNQdVKzNbBiOIDQ3GyU4YiEA0EL+uzbWEKYNZ+KoABJi1odiOaWmL9GjtXHYpyM5N5Li5tFpXYSNWWkq22BRxNuw5l3ze03sh7yVUs3g0nF5X8WpdSv+ceNieGWvWqXG/fMJCPpAPoWmKB5M0rWnNaNrE8871s1ZakMQ9xE403a3jTjXR9yzL5AiTKaP0R/1+YOD9+PKDbPdXz8fj8FPMCkGVhr+Xq86Wj8KB8kRP82dzNM7SqoEe4XLyIZYwBI2w+lfRmfXQLoiKsRSq5X+nuJqyBEQnF8ohG9Vad5KFJLVyrXQFE4oiQ4G/+1jRJUWdyhGqd8SFNMXbSHY5a6V4CcITwPwqzGltAcJXK4w3uNW9EpYN4nmNUjSv5JdZe5CVSYaL7kiotCLW9hLu5Aznm5534eaJKWDVzowSP7LAPuWTHOwNhsFhXM+6c+U1sC4prg8fMc02U7x652mMNEm33UI9I+hZWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6365.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(396003)(376002)(39860400002)(136003)(82960400001)(6506007)(7696005)(86362001)(53546011)(9686003)(26005)(122000001)(33656002)(186003)(478600001)(41300700001)(71200400001)(83380400001)(38070700005)(7416002)(55016003)(66446008)(4326008)(64756008)(316002)(8676002)(54906003)(76116006)(8936002)(110136005)(66946007)(52536014)(66556008)(921005)(5660300002)(66476007)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IUCllLkzy33gMmFITRE4Ecq0hANWpCFFfyS3fdj1QodIWuOgkkt5leWL4tlz?=
 =?us-ascii?Q?CZhP1dm9jOzP6d+BF7GX6BTQEWYFhA3Evf9RxjTA92+VaKUF95He4sYAf6SD?=
 =?us-ascii?Q?CytgECIFYtPyNWnvk98/8uWbsaa4QigwH+P9Ar/wPHaGd7ZpavYTAVeIeILg?=
 =?us-ascii?Q?vBMtbe9sbf+gsFTJA/N937DvcgTHCYUA/F2ic51QhSMWpMDiSvVp8G/gUauB?=
 =?us-ascii?Q?72rBU5HoXkdPm++mI792HA2Ekv+ggLIlqppGcnBYoeBQVTIvh9eTC5katmbU?=
 =?us-ascii?Q?boIUdaDG/lWkRrjF0bxPJH1S/CTQavayW/cxq+4UxJ1erPiRcpRCRtSrqvAf?=
 =?us-ascii?Q?PQ3nm+1JYnwMR385+7M/3/1OEtc1nh+xofq8FneuNo1qnaXuloB/NTt6/RS9?=
 =?us-ascii?Q?Jc4bWNTrb8gEtXBGKV24mmAuf4IMHVJRUibN1Jub2zfVjCZdgF+DaPKdwmby?=
 =?us-ascii?Q?jq2Z+4QL5ismMGue0tzxP9TwxO5TlYXXN0MBtydRnQMva3JWya226zBORfsz?=
 =?us-ascii?Q?bBs/0QhHPQ46/CYbCbfO7iv5O0kNR6GNpLYliDFYG1FEjRjtvbi8R97sxMo0?=
 =?us-ascii?Q?yZ/8rsfT8Ld6VsVaS5PkQXPUQRdKMIWq+FHNuHNoqahDHlTA/Je8bYo4rAE8?=
 =?us-ascii?Q?xAZTN+nHdYAnoqeuGX+vfX71ktl0dyT45zXCJwYGXO0kDbxNKVL6S6ijLbZn?=
 =?us-ascii?Q?YiB3U2IHlbkhqvtjXcptnbhAe1e3xehhmaKj5dLJTvlDeAhlm0zv17SK8l9U?=
 =?us-ascii?Q?7Znd1bGnzvnaIRF9DYTQVXU6MYJ1lFLuEEUWZL2LKH3Zt4t4g13Mc1+7un1U?=
 =?us-ascii?Q?dj7BvTbvoMzvYWbifUYJfOT6FHw+khQUXN7LRilms6dmGKDFoauuVid/PeD8?=
 =?us-ascii?Q?lRNXNHsNRaAJK0fFNKwNv7AAy6WxZwwWS6GV1SbJaX94nTrP3F6l4SXfB4zM?=
 =?us-ascii?Q?3goTrYyp7CK1UdjU/z4yzR0uxi0VhW+UMCSDuY0zlUTjN6UZYMJDHsGChmAM?=
 =?us-ascii?Q?klwctDYC3I2vRSQpB1uk8+Vdqc90kPfg4mKajfkqNvSi7XjuHOUJmjk2Yrz3?=
 =?us-ascii?Q?Jqf9UIUXE5ZnPz3OpGjIeG2eheAkZKtIDFnLF1vKPgzO3LPHZoeBpNW2RSp9?=
 =?us-ascii?Q?blzpH5nCnrCVwGWs0ikQ44kiN2KMMgvE3PIQ5BmkQIipRj81Rfl/kkhWqSUm?=
 =?us-ascii?Q?0Jq/jGvOP7Fku303/YwHrHFDywHRylX9baoWo6qHeiUCvpnTZxVBngpVS2mv?=
 =?us-ascii?Q?NoUX5iTJnrcl6ixP/Ku47JzCt0m9FHz319jqsG7mgptlnX4KQ/aGgDSdrcan?=
 =?us-ascii?Q?IPob9RT2/3zLCC9kMOKnzI92gYWTOwHBJOG0kUOqITVcX7CrNRYcA+LlFDH9?=
 =?us-ascii?Q?G57lbrHr3QM+3+H3ip346aIFIIwkLQnsEC6jM6jkvkTrTBfbDqD9xsRhI57P?=
 =?us-ascii?Q?eiLATuubqK2tpq2m0dsIJpbC26t/Z3N3qsDX+46jyDElneX0gfSQWwzt7qFL?=
 =?us-ascii?Q?gPCbPLv2ilnn/F1yZyC5fsd4keoJY5PDqsj7C1HftP7r+faHNR0wTT5DKEB/?=
 =?us-ascii?Q?9r8rJIojGFbPFcyh3FXyyTpU9x8Cfu2vabkDZ0Mn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6365.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70188c2f-438a-4905-3afb-08da8992fde2
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 07:49:24.3414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mKjk4IdscBGuaX+DcvY9eyi5OSLXLtKyxrDvaUL5w2UqiFiu/jYyNhODxHBodcU9CHfB9sRSZZmr7qA3y/IQ/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4057
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, August 25, 2022 4:56 PM, Xiaoyao Li wrote:
> There is one bug in KVM that can hit vm-entry failure 100% on platform
> supporting PT_MODE_HOST_GUEST mode following below steps:
>=20
>   1. #modprobe -r kvm_intel
>   2. #modprobe kvm_intel pt_mode=3D1
>   3. start a VM with QEMU
>   4. on host: #perf record -e intel_pt//
>=20
> The vm-entry failure happens because it violates the requirement stated i=
n
> Intel SDM 26.2.1.1 VM-Execution Control Fields
>=20
>   If the logical processor is operating with Intel PT enabled (if
>   IA32_RTIT_CTL.TraceEn =3D 1) at the time of VM entry, the "load
>   IA32_RTIT_CTL" VM-entry control must be 0.
>=20
> On PT_MODE_HOST_GUEST node, PT_MODE_HOST_GUEST is always set. Thus
> KVM needs to ensure IA32_RTIT_CTL.TraceEn is 0 before VM-entry. Currently
> KVM manually WRMSR(IA32_RTIT_CTL) to clear TraceEn bit. However, it
> doesn't work everytime since there is a posibility that IA32_RTIT_CTL.Tra=
ceEn
> is re-enabled in PT PMI handler before vm-entry. This series tries to fix=
 the
> issue by exposing two interfaces from Intel PT driver for the purose to s=
top and
> resume Intel PT on host. It prevents PT PMI handler from re-enabling PT. =
By the
> way, it also fixes another issue that PT PMI touches PT MSRs whihc leads =
to
> what KVM stores for host bemomes stale.

I'm thinking about another approach to fixing it. I think we need to have t=
he
running host pt event disabled when we switch to guest and don't expect to
receive the host pt interrupt at this point. Also, the host pt context can =
be
save/restored by host perf core (instead of KVM) when we disable/enable
the event.

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 82ef87e9a897..1d3e03ecaf6a 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1575,6 +1575,7 @@ static void pt_event_start(struct perf_event *event, =
int mode)

        pt_config_buffer(buf);
        pt_config(event);
+       pt->event =3D event;

        return;

@@ -1600,6 +1601,7 @@ static void pt_event_stop(struct perf_event *event, i=
nt mode)
                return;

        event->hw.state =3D PERF_HES_STOPPED;
+       pt->event =3D NULL;

        if (mode & PERF_EF_UPDATE) {
                struct pt_buffer *buf =3D perf_get_aux(&pt->handle);
@@ -1624,6 +1626,15 @@ static void pt_event_stop(struct perf_event *event, =
int mode)
        }
 }

+
+struct perf_event *pt_get_curr_event(void)
+{
+       struct pt *pt =3D this_cpu_ptr(&pt_ctx);
+
+       return pt->event;
+}
+EXPORT_SYMBOL_GPL(pt_get_curr_event);
+
 static long pt_event_snapshot_aux(struct perf_event *event,
                                  struct perf_output_handle *handle,
                                  unsigned long size)
diff --git a/arch/x86/events/intel/pt.h b/arch/x86/events/intel/pt.h
index 96906a62aacd..d46a85bb06bb 100644
--- a/arch/x86/events/intel/pt.h
+++ b/arch/x86/events/intel/pt.h
@@ -121,6 +121,7 @@ struct pt_filters {
  * @output_mask:       cached RTIT_OUTPUT_MASK MSR value
  */
 struct pt {
+       struct perf_event       *event;
        struct perf_output_handle handle;
        struct pt_filters       filters;
        int                     handle_nmi;
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_=
event.h
index f6fc8dd51ef4..be8dd24922a7 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -553,11 +553,14 @@ static inline int x86_perf_get_lbr(struct x86_pmu_lbr=
 *lbr)

 #ifdef CONFIG_CPU_SUP_INTEL
  extern void intel_pt_handle_vmx(int on);
+ extern struct perf_event *pt_get_curr_event(void);
 #else
 static inline void intel_pt_handle_vmx(int on)
 {

+
 }
+struct perf_event *pt_get_curr_event(void) { }
 #endif

 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7f8331d6f7e..195debc1bff1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1125,37 +1125,29 @@ static inline void pt_save_msr(struct pt_ctx *ctx, =
u32 addr_range)

 static void pt_guest_enter(struct vcpu_vmx *vmx)
 {
-       if (vmx_pt_mode_is_system())
+       struct perf_event *event;
+
+       if (vmx_pt_mode_is_system() ||
+           !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN))
                return;

-       /*
-        * GUEST_IA32_RTIT_CTL is already set in the VMCS.
-        * Save host state before VM entry.
-        */
-       rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
-       if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
-               wrmsrl(MSR_IA32_RTIT_CTL, 0);
-               pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.num_address_ra=
nges);
-               pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.num_address_r=
anges);
-       }
+       event =3D pt_get_curr_event();
+       perf_event_disable(event);
+       vmx->pt_desc.host_event =3D event;
+       pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.num_address_ranges);
}

 static void pt_guest_exit(struct vcpu_vmx *vmx)
 {
-       if (vmx_pt_mode_is_system())
-               return;
+       struct perf_event *event =3D vmx->pt_desc.host_event;

-       if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
-               pt_save_msr(&vmx->pt_desc.guest, vmx->pt_desc.num_address_r=
anges);
-               pt_load_msr(&vmx->pt_desc.host, vmx->pt_desc.num_address_ra=
nges);
-       }
+       if (vmx_pt_mode_is_system() ||
+           !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN))
+               return;

-       /*
-        * KVM requires VM_EXIT_CLEAR_IA32_RTIT_CTL to expose PT to the gue=
st,
-        * i.e. RTIT_CTL is always cleared on VM-Exit.  Restore it if neces=
sary.
-        */
-       if (vmx->pt_desc.host.ctl)
-               wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
+       pt_save_msr(&vmx->pt_desc.guest, vmx->pt_desc.num_address_ranges);
+       if (event)
+               perf_event_enable(event);
 }

 void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_s=
el,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 24d58c2ffaa3..4c20bdabc85b 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -66,7 +66,7 @@ struct pt_desc {
        u64 ctl_bitmask;
        u32 num_address_ranges;
        u32 caps[PT_CPUID_REGS_NUM * PT_CPUID_LEAVES];
-       struct pt_ctx host;
+       struct perf_event *host_event;
        struct pt_ctx guest;
 };


