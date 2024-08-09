Return-Path: <kvm+bounces-23674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EEAC194CA09
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 08:03:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 763351F22517
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 06:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E29716C873;
	Fri,  9 Aug 2024 06:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="qQHoVzYR"
X-Original-To: kvm@vger.kernel.org
Received: from esa14.fujitsucc.c3s2.iphmx.com (esa14.fujitsucc.c3s2.iphmx.com [68.232.156.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2A6184;
	Fri,  9 Aug 2024 06:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.156.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723183389; cv=fail; b=t2ed+u1/U3TnVS3bONkIytv9nqK6EVbykdwOIwS8OCUB1FttlpNK5mtM6JrneMXq8wS7Qx1nPO1h7WYGJq9tGTv4DMo4U0L/4WesX+OJAxyZKPneB4ewgj2H2WMvWQwFUJ8T1Y34RCIyrvJSi+u0kdPOWWwZztAm74Ch9NfNWDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723183389; c=relaxed/simple;
	bh=mohZU1iYsNmGlnVKH1/vkXevI0cAg1Rh4ja50+BIbJU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t3EqBNM+BkvWqZHSzmo1pS3bqh/MRl7tOAoSxKlIY4CstmwXyK1C8i4hG2Ba/qKglBoSx09zPbOOmiK2fOye1rp2DDSQqWWYzR8GV+RrIpAthCa7kIe05Zw0Rz6nBqNLrc1liKpau6GcB2PcQyIwnWUodQLs0H9RqvHAYHRjuVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=qQHoVzYR; arc=fail smtp.client-ip=68.232.156.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1723183387; x=1754719387;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mohZU1iYsNmGlnVKH1/vkXevI0cAg1Rh4ja50+BIbJU=;
  b=qQHoVzYR+sL6UcXjl0ISLeghMTSSXX1bkYLaCEYMcJbJyaAvvzwsY04+
   F5wtfRqhxnJ6HIm5PKqArZdG/HUNMqXAMPA5eJSGyNg+haYvoCNl0rlhd
   L91f1O4/7XPImgp6FcyEW1+Yh3uA1Lbx6U4HEJ5HoK8m2y35sxciHdkKf
   2ngote3CO/uLws3C1i1dsuNKKLgQrXMDz2fkOxIAk+7YeW7Fw/s4g3kvY
   XEgu4bpUnDa8BUwLvjOLJL2yMIQhDlCV+CSI47AA0FZHgZDO1fQqt/7s/
   umrCKcOyDPjF7gDRD+c69vrrWf5HXNqHcyaMpclIn+VlqBijYOfdqcaN7
   g==;
X-CSE-ConnectionGUID: WrkQ10cQRl2RhXcbGqIt8w==
X-CSE-MsgGUID: ktJhuQ5TSX2WvflOMJeJug==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="127260604"
X-IronPort-AV: E=Sophos;i="6.09,275,1716217200"; 
   d="scan'208";a="127260604"
Received: from mail-japaneastazlp17010007.outbound.protection.outlook.com (HELO TY3P286CU002.outbound.protection.outlook.com) ([40.93.73.7])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 15:02:57 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wj29HXMGBAJIOzw1cAak3i9jYM3agwAFbBLJjjaaqIyFZgalMnRSBJl6hgRHVJi+OhIKNoYUTvR9fKfFa5oJmcKPUT4/1XamUMd4wk1nvHV1F14gndNyPbdbwMHA/OYd/K6j/mUq0Pbn3jkH9hoZuUG1PXkmXYsKQhS1p8wQz+Fnzl6SfNvytwhoCAhBkuj0p8bzSO3XwACF6aN3vXfBVMohwA6WVGZod0ZEA4CWco35fFlwJC5ExXNoNOuHD3imn8HaTKA+tGOLwV9i/lrmeviF46AVTHVzAgyVb/HYRiWbmu6A8aob/ylqMBO6Yi5GLgTehKCjLkL9N1utjdqO/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BLctyC4SoRFs8XX4bWEH87DP1FBGtMBjWcU4FxR5+5w=;
 b=amPmwD1eAk8KP4Vrvyn00yXLG/WS+FSNxOAoggcKT7DG6AOPl/Jl2GFOi49hwEaBNwbHFCro2ORYWVvVk9a7QPrV99QLxI/axdSaPgZMmYJj2xwNz2MF9uoyF45EplRag8xanUrgK7ZKnaezsUUXUXDBeI705a6kIZB+sd+gRlpUeFxkMgM+JckZ0neGb87s+aq0gCeerKl/rrmvDFXRWiT5gJTtenp/22WKQEnS2ZxIECriQSvmUz/ULXDLhwcz/pwC7AMQgqmTMFyc2vA+Mp/B5vqvvwyX853R4hq9nv+NG5VbRIq3371Jl9yWqLuBsor0wCkp5w6wXAcg7//2rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY3PR01MB11148.jpnprd01.prod.outlook.com
 (2603:1096:400:3d4::10) by OSZPR01MB7913.jpnprd01.prod.outlook.com
 (2603:1096:604:1b6::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.14; Fri, 9 Aug
 2024 06:02:53 +0000
Received: from TY3PR01MB11148.jpnprd01.prod.outlook.com
 ([fe80::1c1d:87e4:ae79:4947]) by TY3PR01MB11148.jpnprd01.prod.outlook.com
 ([fe80::1c1d:87e4:ae79:4947%6]) with mapi id 15.20.7849.014; Fri, 9 Aug 2024
 06:02:53 +0000
From: "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
To: 'Ankur Arora' <ankur.a.arora@oracle.com>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "wanpengli@tencent.com" <wanpengli@tencent.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "rafael@kernel.org"
	<rafael@kernel.org>, "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "arnd@arndb.de"
	<arnd@arndb.de>, "lenb@kernel.org" <lenb@kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "harisokn@amazon.com" <harisokn@amazon.com>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>, "sudeep.holla@arm.com"
	<sudeep.holla@arm.com>, "cl@gentwo.org" <cl@gentwo.org>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: RE: [PATCH v6 00/10] Enable haltpoll on arm64
Thread-Topic: [PATCH v6 00/10] Enable haltpoll on arm64
Thread-Index: AQHa35hwUs4dbjmKiUW5dt3OvsFHwrIegdtw
Date: Fri, 9 Aug 2024 06:02:50 +0000
Deferred-Delivery: Fri, 9 Aug 2024 06:02:50 +0000
Message-ID:
 <TY3PR01MB111481E9B0AF263ACC8EA5D4AE5BA2@TY3PR01MB11148.jpnprd01.prod.outlook.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
In-Reply-To: <20240726201332.626395-1-ankur.a.arora@oracle.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=dc7f891e-7698-43c1-9a1a-bfb00a0fcb3f;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2024-08-09T05:55:36Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY3PR01MB11148:EE_|OSZPR01MB7913:EE_
x-ms-office365-filtering-correlation-id: 255f6d7f-0391-4031-6217-08dcb838e81a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018|1580799027;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?UnlLczV1TzJjV3BqQUVuVmQ4OVpqc1FWTGwwdWhGVE81LzlkMlI0aHJF?=
 =?iso-2022-jp?B?WmhrRjljTVRFVlMyREtnekxsZ0RFeDB6dHJyOXptd3FKSlJzelM2NnFk?=
 =?iso-2022-jp?B?dnFQaHR6bDNJbmk4TURZMlZJbWVsamRhYURXbFpmVGFyTStMVDA0VEhK?=
 =?iso-2022-jp?B?QUFqemc3UER1TGVEdmxNNUVJN3ZqQWJKQy8xbTJQRVh6LzFvbFlzeHAz?=
 =?iso-2022-jp?B?M0lmMHhsNjJhbk1OZlYxeU14RGpQUHZvVEpYeDRxazc1b290NHczYk5C?=
 =?iso-2022-jp?B?ZCtTbmJCMlNxa2RXWDQ3ME8zbDUybXhpZ1FlWklrYmd2K3dqWkNtL0Zi?=
 =?iso-2022-jp?B?VE0rWlljdmRpY2xLc2I0TnU4ZEJvdDFlYmlIWWpZMFN2aE10QXExazBp?=
 =?iso-2022-jp?B?SS90SmxTOUtwTzU3cXgrTVFxL1NralRSZSs4WmRaVWRkcHNrNWlWcjJJ?=
 =?iso-2022-jp?B?b0dJb3FpZHo5dk9IYy9ablFVd2RQZyttcDE4SXhNcTVSdmpDVjZRU2tI?=
 =?iso-2022-jp?B?TUNFQVRXaitMTGpkU3FNWkJvNEhVZGc1TTB4bFA2Mk5jMTNzZWdpRzNG?=
 =?iso-2022-jp?B?bHF1OXQybjNQdHBXSWdWcXgveVJHdm4wOGRqZTlrL0ZzeW9WUjhBZ2Yw?=
 =?iso-2022-jp?B?SEVvaE16Ym4vdFZkKzJ0NWluR3g5NFd4dnZmazA3OEtaam5BemlOUUdo?=
 =?iso-2022-jp?B?VzNVbm5qU1BWbzBaYUJJc2tscERLSU9jcnNVTThBV0dLellDMzl4VmZQ?=
 =?iso-2022-jp?B?eGsyaXJEeDNBVFRKcHZYbTQ3TUlnQkVQWS9LUmlPS045YjVNOUhWTE5Y?=
 =?iso-2022-jp?B?cnpMZjMyaDhEZkpuWWVYTU5MUTJEUCt1U1lWOGV2N3YxVVNzS0JHKzJB?=
 =?iso-2022-jp?B?Q2NjUThXbmg4cEhveDZvd2hjek0yMTExaHY2WUFkLzVpQk5hakNzWUJH?=
 =?iso-2022-jp?B?VTBlbUl5TjFveURRZllMR1M0dHVGT01iejhDeGROOFR3Y2QzUW9QdXdw?=
 =?iso-2022-jp?B?VjBMWDdFblhNNjNtLzlYQ2RGcExkbVpDS1NrOHB1azlsT3RnanY1dVlp?=
 =?iso-2022-jp?B?ekxqK2ZYRFUvOWcvNFFPQmk5VWZjdzc3YVZ6N3VKekkrd05YN2pPOTI5?=
 =?iso-2022-jp?B?bWJnVWxjaHkzdm10RS9SeFdlaVBSZTFhSmhScDhDTlJGZmNocTA1Y2FJ?=
 =?iso-2022-jp?B?SGtnaEEzQ29CUkRSN2JJVFVCK3R4VUNtNDRnVCtTcEFpekNwT0tLQ2RE?=
 =?iso-2022-jp?B?UTA5ZEJsRjVZRWdoVHVvd2RqNzQ2aExGWTFESEhNM3VFcDRPS1VIQW5o?=
 =?iso-2022-jp?B?R0VjRTZlaEZBL0d0a3ZoYVZsaTZHUUdCaG1UaGZRMDNNRlBRMVdOR010?=
 =?iso-2022-jp?B?QmIxQmhBdGozMXhKV1czTXNlRVhPaEs0NitDVVlsSlA0eEZiaHBxU0Er?=
 =?iso-2022-jp?B?NHorUDFybE05SnBxZGF1Ryt1UlpEWktSZ0wzRlJyUEVzSUJMYW5MemlH?=
 =?iso-2022-jp?B?K0IvbTRUcG56V2g0UHNxMUh2alNTYk80ZGFTalZvRjFQR2pnNzdLamVR?=
 =?iso-2022-jp?B?eklxUkdlSkI0ZkZIOUptNDlVM2x4aytqUGpHUWVoeUdzbm1HMzlaUS8y?=
 =?iso-2022-jp?B?Y0pvUGhwd3ZnZy85NUhpcDhzMmdCdXBxc2RMYU16NFdZYmpjOXpTYytS?=
 =?iso-2022-jp?B?T3RXcjZ4OTNxL2NrWVlQOUhtS1RYNXNPOGVJaTdJODJlQlQ1Zmo3WXlJ?=
 =?iso-2022-jp?B?YUJIeWR0bExsN0dwYXFidzBka3Q3WkV1Tnl6ZWpyY1FBSjIzR2tqRlpl?=
 =?iso-2022-jp?B?MUl6VUtySnJOM1pmQXJ3Y3pWTTZpd2dQM2FlMnZob3grbnhGcHViU1Zt?=
 =?iso-2022-jp?B?MTRmREFzbDlUZ2xoTGN3SFluWGZZOCtpdTgrcmV5QmV5VkM5RnRMQXFC?=
 =?iso-2022-jp?B?ekhhM2cycXhsb2o2QnR5TmJnWTN6U00vY29SZXZGcjVuODBjUU1KWExF?=
 =?iso-2022-jp?B?TlNDeEQ4MHJRbWQwMHhVdWI5SmRZcHdLUkp0QjYzcW1oTlBMaXRabS9R?=
 =?iso-2022-jp?B?YmRBb0paSU44YkpJcnJJZmxBQnRyelE9?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY3PR01MB11148.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?RVB0Q0Y3Y1hYRDFXMFA2V0ZPenRZQXVVTFRIRmVKZitxSlhUZktuUHBl?=
 =?iso-2022-jp?B?U3FBRkNPR2J4Y3Z5ek9lcUhaRWsxYmNEZ3BKMUFaNGltcE9ZQmIwV0E0?=
 =?iso-2022-jp?B?Y1JVZzJxaHZobVE0ZnpaWFErdFhhR2ltOExDajhmN091NmR3K3RhVHoy?=
 =?iso-2022-jp?B?WWdYekNNeDRNK3AvQmxpcURhRDBRL1l5MTVRdUNZbW9qWVR6VUptYnNl?=
 =?iso-2022-jp?B?VmdRRnJMM2RrNFZRL0E0Um9RNHdWZXBXeUY1THFPd1VsSmFGbDRZM0lw?=
 =?iso-2022-jp?B?MHM2QU45Z2ZsSGF3Ly9janphQXRRaHpCMFFxdEFhdDJHZmI4QjNwa2Q0?=
 =?iso-2022-jp?B?RThKMURSUEhaZHU1NGk1NUJyY3l4bkdNT2gvK3Zxek55NFBNU0ZJM0Vr?=
 =?iso-2022-jp?B?V245YTJVajhKRUpacWZKVllMb0RhRnhiMFRMUHZFV0pqZUc0M3poME1o?=
 =?iso-2022-jp?B?VjJia0Njb1dmWStsL3ltL0p1RGxjbkV1MTdCeFlIdFdkMkM2aDZNMWF4?=
 =?iso-2022-jp?B?YVBOMG4xSG9WdE5OUHNKTnFPS3ZCcW9hQVZSdVlUTWFiWVc5eUtTR000?=
 =?iso-2022-jp?B?UEhJM3lCLy8yTFh0Q1ArY0dHYnk1bXk5bHQzRmxLZG5hYkdnL3oxb0lm?=
 =?iso-2022-jp?B?MkJ5ckxvRUhDZTlVL1haTUJyTjc5bHJpYkdqQkdkbkRQaGpLOE5MeVZR?=
 =?iso-2022-jp?B?a0duTUxVT0lrUCtmamphVkNBN0hlcHlCakNiQVU0c1hQbHdnS3JiNDR5?=
 =?iso-2022-jp?B?MHpHdHN2SEJqL0tXNUgrcGszNS8yYXFjL0hXZUZSVXVNdkZHTXFrbzNq?=
 =?iso-2022-jp?B?aW55WFBEcHQ2N2k0dHozZ29WNkVvVHZzWEErRnpZTThwYUNIT1hrYTZv?=
 =?iso-2022-jp?B?LzdSREZxYlRHc0pPeXRINEZhRnhRdm5VbGU2ZCtxOGtFM3lITFJOS1kr?=
 =?iso-2022-jp?B?Z1NQK0JveHU3U3ozNFdobEJwV1BkcmRWZEY2L2RrNktGM2JNaGdsU1Ja?=
 =?iso-2022-jp?B?YmxVaGxwS3JqcjdMVHl5em5ySmFjTlQ5NHFvWWRVQVlSN21KUmw3SEhP?=
 =?iso-2022-jp?B?dHlUSmVvbkNKOXZnVEtqc0lUOGRWV080Vm9rbGF0K25mdHZhV3E4ZkZr?=
 =?iso-2022-jp?B?bFIxN256UHhEbC92bTFkTUpoa1Q1Tkh4UEt2M1NNUW5lME5QbFRTdG1S?=
 =?iso-2022-jp?B?MVVkSHVFNzFnYnM4MEQ4aklOditSM3FBYWNOdFRaMDN5bzAxdUExa2Rx?=
 =?iso-2022-jp?B?U1FVVVNoZTI5YW5valJCTnArbWFiSk1WaC85ckJHWkNVT3I0VmY5aUJW?=
 =?iso-2022-jp?B?S2ZzdFhWTVV0dXZlbnNxM1ZpMUFKUkZGYzArTUZ1MlJsTTBoazVEaVRS?=
 =?iso-2022-jp?B?TjFjVVhOZGJHWG5FMHF2TU4zcG1oZSs0WkpNdWE5SFE3RytISExiYVB1?=
 =?iso-2022-jp?B?czF1K2RwUUlQbFZvRmIzZWdValYwRXczQlZEUCtOL3VjTG9tdGFGQzRq?=
 =?iso-2022-jp?B?OHJleUpybHAzc1lvY1ljcWQzcncrNC9CKzRrUlFiQzA2SXd6ZlNDSXZ4?=
 =?iso-2022-jp?B?bElsY2lGZ2Foc2dJVm1wRHQ0YjhraEZtVUZRL2pqSHY3RFRUc00vSFhY?=
 =?iso-2022-jp?B?ZWNQWmRjSk1DU0VuZUhGUjh6dzdFRnd2U0VyaVlKeVJaN2lNeVpKdEpa?=
 =?iso-2022-jp?B?MXFaeWM0dWtpbU9oUzF1SlQvSTFsMjZoQ2FnRkJoWmlpU0RaYnZUay9x?=
 =?iso-2022-jp?B?aVZ3amJkMlhMMEZWSUhPTEk2L0ppSnJlUFdDOXRVU0p1MDJ1RFhMTjRu?=
 =?iso-2022-jp?B?a1k2a3JRdkFQeFZ6UlhrSDNNcE1WRm1HVURJYTBQOVExNFUrcUt1LzY4?=
 =?iso-2022-jp?B?dGU1cXR2ZFp4U3E1MmNiS2dsalhFd2hyWjdvZnJZMEt5U1lWOHRYSEVi?=
 =?iso-2022-jp?B?NjB2VjJUeHFibWpXZnF5MEFDSkNJRHh4eExrbEY0Y3F4Ukl3L3pMWGNh?=
 =?iso-2022-jp?B?aHdKKzAvdnBSZmpaLzBVM0FsbkZzOU1UVTk3a3R0TUF0QWlla1BYd1RS?=
 =?iso-2022-jp?B?SWVhSXdUdHV3MStzSmFBRmpabktVSkRRZ0Y1RXljdEFTTTV0djh2TW1j?=
 =?iso-2022-jp?B?a2lOSjJWeVN2TnAzY0FNaGltaHplaG5zb2R1bDRzUVV0QjlLMFRDNStH?=
 =?iso-2022-jp?B?TW8wZkNVR0YvR0FHZ1ZOU3g2MmtpVGFlUDJzZGVmTnk5U2pNTHpjaWp3?=
 =?iso-2022-jp?B?N0JwR0VybUsxVm9oRTk0VTNDekkwMmtJWCtHUUpheGFUVnJRUWlsZmRV?=
 =?iso-2022-jp?B?SjdHWGQrNzQyM0I2clhjYWduMmFleXVtK1E9PQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jc4DjJHbfVB3wU8jiMIdPD5FLO/W9uvAJ6f/HhBj27LEnKnRnR1LqQzpiQGxsvKt4/hzlW/ITEvYqyNDZfsgdi11dT8VCiJM51MgZjoIxJMO9jaSWTvbeCYL7e+RWVJaaeaQGlW5p+fGkwDNUWO3sDakH2B5SM4gdjPAbGu0Uw9Pu2upjS0usXTblv9xh3ALl3cA5dyRE8DqrYJZoiuSKorcOFTe4usE9YtAymmWF8UKRDYMjIRqx1Ap3u75j3llmXC5EE3O2ZPhGaFSo0dzaRIWtvRlFXMpre/7cCqIqgJjOy/OtARC8MpBR6s+GGc0dBK630efVu6Pn2tGKR1LDOfvv5OGM11ycdaYDiVSUwH6pHj33aucPZRKArhzx3lhbOyqiKtoL64mBSMo3YpicRTxrugLNzXsO7u6MHCMqDgMsqFEYL+mq/fGAyMBgWyQVzValu7NrTExJP8jRrfcn487Jc6b6JvTyMYIZJtCcK0wueqkvlgxio0N0K5SXRE3L0MTNcom17JbH6okG6PEmCWSeuAVrDx0zCm+ernQQcJyo63Dzohsxi0ZrbKTN4J3MmlBGzUsbWLCAw0Ez3QYhY0P55iWLBZ0mK1kt6r0AWpsFyxKHw5q7QUrqvWTHy7l
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY3PR01MB11148.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 255f6d7f-0391-4031-6217-08dcb838e81a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2024 06:02:52.9161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yU5irMOOaEGgC0IERtaaMq3gG0MgrXpLRfJQ0hQhBY2rpNIPNkP4CvR2ODoyFoQry6zGONEQwq9f29K+G+FrNThMYV2WUJU3pgNIybk397w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSZPR01MB7913

> Subject: [PATCH v6 00/10] Enable haltpoll on arm64
>=20
> This patchset enables the cpuidle-haltpoll driver and its namesake
> governor on arm64. This is specifically interesting for KVM guests by
> reducing IPC latencies.
>=20
> Comparing idle switching latencies on an arm64 KVM guest with
> perf bench sched pipe:
>=20
>                                      usecs/op       %stdev
>=20
>   no haltpoll (baseline)               13.48       +-  5.19%
>   with haltpoll                         6.84       +- 22.07%

I got similar results with VM on Grace machine (applied to 6.10).

[default]
# cat /sys/devices/system/cpu/cpuidle/current_driver
none
# perf bench sched pipe
# Running 'sched/pipe' benchmark:
# Executed 1000000 pipe operations between two processes

     Total time: 23.832 [sec]

      23.832644 usecs/op
          41959 ops/sec

[With "cpuidle-haltpoll.force=3D1" commandline]
# cat /sys/devices/system/cpu/cpuidle/current_driver
haltpoll
# perf bench sched pipe
# Running 'sched/pipe' benchmark:
# Executed 1000000 pipe operations between two processes

     Total time: 6.340 [sec]

       6.340116 usecs/op
         157725 ops/sec

Tested-by: Misono Tomohiro <misono.tomohiro@fujitsu.com>
Regards,
Tomohiro


>=20
>=20
> No change in performance for a similar test on x86:
>=20
>                                      usecs/op        %stdev
>=20
>   haltpoll w/ cpu_relax() (baseline)     4.75      +-  1.76%
>   haltpoll w/ smp_cond_load_relaxed()    4.78      +-  2.31%
>=20
> Both sets of tests were on otherwise idle systems with guest VCPUs
> pinned to specific PCPUs. One reason for the higher stdev on arm64
> is that trapping of the WFE instruction by the host KVM is contingent
> on the number of tasks on the runqueue.
>=20
>=20
> The patch series is organized in three parts:
>=20
>  - patch 1, reorganizes the poll_idle() loop, switching to
>    smp_cond_load_relaxed() in the polling loop.
>    Relatedly patches 2, 3 mangle the config option ARCH_HAS_CPU_RELAX,
>    renaming it to ARCH_HAS_OPTIMIZED_POLL.
>=20
>  - patches 4-6 reorganize the haltpoll selection and init logic
>    to allow architecture code to select it.
>=20
>  - and finally, patches 7-10 add the bits for arm64 support.
>=20
>=20
> What is still missing: this series largely completes the haltpoll side
> of functionality for arm64. There are, however, a few related areas
> that still need to be threshed out:
>=20
>  - WFET support: WFE on arm64 does not guarantee that poll_idle()
>    would terminate in halt_poll_ns. Using WFET would address this.
>  - KVM_NO_POLL support on arm64
>  - KVM TWED support on arm64: allow the host to limit time spent in
>    WFE.
>=20
>=20
> Changelog:
>=20
> v6:
>=20
>  - reordered the patches to keep poll_idle() and ARCH_HAS_OPTIMIZED_POLL
>    changes together (comment from Christoph Lameter)
>  - threshes out the commit messages a bit more (comments from Christoph
>    Lameter, Sudeep Holla)
>  - also rework selection of cpuidle-haltpoll. Now selected based
>    on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
>  - moved back to arch_haltpoll_want() (comment from Joao Martins)
>    Also, arch_haltpoll_want() now takes the force parameter and is
>    now responsible for the complete selection (or not) of haltpoll.
>  - fixes the build breakage on i386
>  - fixes the cpuidle-haltpoll module breakage on arm64 (comment from
>    Tomohiro Misono, Haris Okanovic)
>=20
>=20
> v5:
>  - rework the poll_idle() loop around smp_cond_load_relaxed() (review
>    comment from Tomohiro Misono.)
>  - also rework selection of cpuidle-haltpoll. Now selected based
>    on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
>  - arch_haltpoll_supported() (renamed from arch_haltpoll_want()) on
>    arm64 now depends on the event-stream being enabled.
>  - limit POLL_IDLE_RELAX_COUNT on arm64 (review comment from Haris Okanov=
ic)
>  - ARCH_HAS_CPU_RELAX is now renamed to ARCH_HAS_OPTIMIZED_POLL.
>=20
> v4 changes from v3:
>  - change 7/8 per Rafael input: drop the parens and use ret for the final=
 check
>  - add 8/8 which renames the guard for building poll_state
>=20
> v3 changes from v2:
>  - fix 1/7 per Petr Mladek - remove ARCH_HAS_CPU_RELAX from arch/x86/Kcon=
fig
>  - add Ack-by from Rafael Wysocki on 2/7
>=20
> v2 changes from v1:
>  - added patch 7 where we change cpu_relax with smp_cond_load_relaxed per=
 PeterZ
>    (this improves by 50% at least the CPU cycles consumed in the tests ab=
ove:
>    10,716,881,137 now vs 14,503,014,257 before)
>  - removed the ifdef from patch 1 per RafaelW
>=20
> Please review.
>=20
> Ankur Arora (5):
>   cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL
>   cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
>   arm64: idle: export arch_cpu_idle
>   arm64: support cpuidle-haltpoll
>   cpuidle/poll_state: limit POLL_IDLE_RELAX_COUNT on arm64
>=20
> Joao Martins (4):
>   Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig
>   cpuidle-haltpoll: define arch_haltpoll_want()
>   governors/haltpoll: drop kvm_para_available() check
>   arm64: define TIF_POLLING_NRFLAG
>=20
> Mihai Carabas (1):
>   cpuidle/poll_state: poll via smp_cond_load_relaxed()
>=20
>  arch/Kconfig                              |  3 +++
>  arch/arm64/Kconfig                        | 10 ++++++++++
>  arch/arm64/include/asm/cpuidle_haltpoll.h |  9 +++++++++
>  arch/arm64/include/asm/thread_info.h      |  2 ++
>  arch/arm64/kernel/cpuidle.c               | 23 +++++++++++++++++++++++
>  arch/arm64/kernel/idle.c                  |  1 +
>  arch/x86/Kconfig                          |  5 ++---
>  arch/x86/include/asm/cpuidle_haltpoll.h   |  1 +
>  arch/x86/kernel/kvm.c                     | 13 +++++++++++++
>  drivers/acpi/processor_idle.c             |  4 ++--
>  drivers/cpuidle/Kconfig                   |  5 ++---
>  drivers/cpuidle/Makefile                  |  2 +-
>  drivers/cpuidle/cpuidle-haltpoll.c        | 12 +-----------
>  drivers/cpuidle/governors/haltpoll.c      |  6 +-----
>  drivers/cpuidle/poll_state.c              | 21 ++++++++++++++++-----
>  drivers/idle/Kconfig                      |  1 +
>  include/linux/cpuidle.h                   |  2 +-
>  include/linux/cpuidle_haltpoll.h          |  5 +++++
>  18 files changed, 94 insertions(+), 31 deletions(-)
>  create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h
>=20
> --
> 2.43.5


