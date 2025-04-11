Return-Path: <kvm+bounces-43180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D8CCA867CC
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 23:00:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00A451B83025
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 20:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96E6293B48;
	Fri, 11 Apr 2025 20:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MxruI4yk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M6YH40DX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A5C28F93B;
	Fri, 11 Apr 2025 20:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744405109; cv=fail; b=rqZTWc6Ka0dKfCd6Je/TadokToQA0G1+y0G7elo+JNWM/UqdatlvCqjr6Auc9pazPUIkJf9AXpE/3ZVLH+3uqcIlhR6O78D9mXrBb+BSF6hM1jeCuAUC0mJ7RkPWmveEFGdH8qwlbDe6O9gv6bqhY23+0oeGcELA9QAhgfcY1nA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744405109; c=relaxed/simple;
	bh=ujGW/crkrry9XVGr1Rnpq5/X50/iXwCNgAQ0Z6SMHoo=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=C9StF2YRYBysxtYVTqfEMTli/OJoges7yflNbIhvxwvHXktPBK9zJIoYckVZPI/WVN9MsiSAblSOWJ2H70boTf4DOlXog4N1tTZVdqRgHnSW8JMqE9YsK1c9ERJathmE1QL18Rn894kP7mMw8MyVsaW3cHVZgPNmz6lcpODoSVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MxruI4yk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M6YH40DX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53BKM2A8025973;
	Fri, 11 Apr 2025 20:57:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ue62yBFFTdNDVlIagVcuQdtlhLZeehOpGYPi0+f0Aoc=; b=
	MxruI4ykpUZrODI/ttEeXnhorYTeJjukcrb6pa5CyOsaL98maUhDNVmiuuwYd7iQ
	QeBxzBasUVCnADn8j/kWWIxuOYNTB7wm350YVgEg2n/KxN0YrnH6YZTuUIMTr/UY
	IrApEn9AcZUf8IXnhehhCydvLl0Hq+LxKDei1gw0VENW8zdVeAe3c8gROZwtzDVS
	jB1IVU7PkR8J6DpIfacNgbfCWjtYuXSD0tmgJ5C3iK20++AXNry/BzHK3WGVD+lV
	JeSbGgdZsfhMB9wlTdyAqLKLKafstwnAsbZVQGX1sdSQlKIG3tIFdP+cGwnJgdih
	wPZ3stUTpfjaLtTQYinDRA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45ya25831c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 20:57:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53BJeM1G022176;
	Fri, 11 Apr 2025 20:57:22 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazlp17011024.outbound.protection.outlook.com [40.93.13.24])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyewmy5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 20:57:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B5EZTnzE6OD5xWhzqX/nzEuSRXXbg+Vipt0falnKcDrimymmsDxnsGEFO/F0KlMvvQf65YeBt2T2ndW9CCDEtI2R8MxxO1uxtWNYt4JX5tJHyQtHElWBAo6hDkM9logmbfJAdEaZkIGKyp+GlWpaHQ/yWqmy6voYQoZjxh5+7Q0b/DBPUwDWOIrEHEEF5cJ3LR8LVZNe12pQGa5HyGPDvQf1CQNm/RjsK18U3xl/PHEDJzrc8kmxuIE8E4prgf2nga2CBPOiMJXf1SYVBxVj9UIwxRxqqQlnqYAupk9Un4Q3sYc/CUkpi9IsBz6LP9P4pmqFmPFjhiCcRtsrvqJ1KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ue62yBFFTdNDVlIagVcuQdtlhLZeehOpGYPi0+f0Aoc=;
 b=cdsfcr+4msmY/W7zr1vvoETlQ3+4LFQ161EurRETVVUV9T5VH/QrQbKcpxwA3A1E26k0V3UMygbJda5EuJ1M8NdGxHhz8nkRsbpnGxWGBJxD/CseJ+KqR1WWA7RkHLN+VRF2YpPaUPB3G5B/FoNSEBWQFaIxFPiaMZ1gZKfqxAV0FkQ0F11ImKHG9GfRUhDYBkzO4tkEIQTyN+0DKMkxM4WuWugQy3/uZ5NsfnwXDfDGwCY8jUj7WgCK+NcSOx3x4ZM9LPT8GQtZQkG3jHE8iyOAVqSlz1q2XUXARViZzun8jsQfC1F/JKZR462Xf5nbklF9opdy4l0xKe5hZZYFZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ue62yBFFTdNDVlIagVcuQdtlhLZeehOpGYPi0+f0Aoc=;
 b=M6YH40DXWQbud3R4XBqfR5SHwanXCqm3H/yFcI6n4SGSooL1bPcAYCvg+dULllMsy5S/GNrhIXFPYhySij1l6w9F/0tEuCooh55Sy/lzOwbCdPdNW6yZYpkttdighYw2H8NerOR07hQMu2fFqrbxjN/AW4ovZzAra599vZSjDik=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by MN2PR10MB4368.namprd10.prod.outlook.com (2603:10b6:208:1d6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.38; Fri, 11 Apr
 2025 20:57:18 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%5]) with mapi id 15.20.8632.025; Fri, 11 Apr 2025
 20:57:17 +0000
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
 <20250218213337.377987-11-ankur.a.arora@oracle.com>
 <18875bd7-bf01-4ba8-b38a-4c0767e3130e@linux.alibaba.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        catalin.marinas@arm.com, will@kernel.org, x86@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        maz@kernel.org, misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        zhenglifeng1@huawei.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v10 10/11] arm64: idle: export arch_cpu_idle()
In-reply-to: <18875bd7-bf01-4ba8-b38a-4c0767e3130e@linux.alibaba.com>
Date: Fri, 11 Apr 2025 13:57:15 -0700
Message-ID: <87h62u76xg.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MW4PR04CA0304.namprd04.prod.outlook.com
 (2603:10b6:303:82::9) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|MN2PR10MB4368:EE_
X-MS-Office365-Filtering-Correlation-Id: 260bc96a-bbab-4703-aefc-08dd793b7189
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dmthcWVEcU5GNVUxdEMyaVdscGtKdjkzanlIUEpweC9MczFrdjBmdzk0Tkt3?=
 =?utf-8?B?TlpnRmpQUjRHcmpTZXFDbTlqa3ZKWERHMFJQdjRGRmVEcTVxNUY4V2Y3NkYr?=
 =?utf-8?B?eUNOVC9uRE5lbjBnaUxFWlEzNWtzbjFTY25KWE1aRzZ0NzdqRFlyaEVKbHFz?=
 =?utf-8?B?cUdpSHFpNjh1Z0NCTHp5dGtzb1NiRFlwOGpKQ1FnWFc0bk9WdlFoaHcwTklr?=
 =?utf-8?B?QzNuWWtheE9zTnpxa0V0QmJheEJjM0FudWk1eWFrTnhremd6Y0VaemFKVXpV?=
 =?utf-8?B?NlFvUERIZS9CR2VyWmhFQkFHSzZ6K3g1MVo2dWRNVHVkb3hUTXVPUDN2Qm9M?=
 =?utf-8?B?SHhHV1VNTENEQ3d2d2Z4Q09qWTJHVlJYUjlXUi83YmdBVlBuSmtRdVpCUWU1?=
 =?utf-8?B?Zmx3WnQ3a0NKcldYaUV6dElBdDJwZ0FWODBnb0lOMnNybHo0MXcvSmYwZzVv?=
 =?utf-8?B?cWhBZ095NE91TTJweGNDRG5NSmxNYlFsRmZ5N0xhWU5lR1BRemNIL0MydStt?=
 =?utf-8?B?dkZtR0xCNkRvQ1h4VUJNa1RFWG9OY0JvdVZmK3JBeDlBaDA4ZXZzOG4xWkR3?=
 =?utf-8?B?ZzBGMTFYQ3g4Nmprc3dBTHd5Y05TK3JST25ZT2d3MUtyQjVIdFVkTmpLRnpl?=
 =?utf-8?B?WDdvcXZlZWc4NDdVVHNkRzhRSUtkTUVFYjN3NmgvcmhtZnFrNDZxbURkbU5h?=
 =?utf-8?B?bmtlVXV1TkdCNGlTbjI4MVhtUFcxam92NklTQisrSE1iU01VSU9jSzI5c1k4?=
 =?utf-8?B?VFV1QVNSQXlnUnpCTUJXck9pczhGWGJrTEw3UWtYci9yOGNxM2svTUJSYUVB?=
 =?utf-8?B?MlhORkdDWlA3dm5xSkxtemtxNFQ0ajdYQ2NUdllyWTFZRTVEbEtSc2wxSGRG?=
 =?utf-8?B?YUpoc0V1SnlUVmJrNFc1bEVsd1RVWCt0VHhTam80UHNoMVZ2UHVPZllCRlNS?=
 =?utf-8?B?aTVpWExvR0FJNm5oYXVKYXhUYUEzZWFGelg2SFpKSkExS2pqaC9jeldhdFZL?=
 =?utf-8?B?QzZvRlB1Z25XRXZseW41V0dIWG51cFRlYzZNbDFlNGpEZjBOaXFyWStWbE9v?=
 =?utf-8?B?YnhBZ3MvTklpSTJxNVBHYWpFQklubFI4T1pPYXlObUtoc1dTcnFqR1RnZHZo?=
 =?utf-8?B?UEN3dHQ5WndvWmZlc0JZLy8vLzNrTEE0YzVZN2FhWWxIRGU3d25qTzR4dWR5?=
 =?utf-8?B?R2RsMmNRL3FEV1phNGRPOVBCekJEcGd0NDlWVEpPaHNJZkFQS2UyaEx1ZGhD?=
 =?utf-8?B?NE5mSjBReEFEbVFFNE1tbnYzanExN2hmWWpvNTNjaTRGTkdwQkhsYkZSUFk4?=
 =?utf-8?B?ZVhpWHRndGhrbW9VRStseGgrOERsbWNGMlRoS3ZNQ044dDl2a3JTb0RTdGtC?=
 =?utf-8?B?bTJyU1g4allEMEk5b2F5eFlwOVVZU1RYRFpiSXA0UUhrVlNnb0JxaG1PYURP?=
 =?utf-8?B?RzBTMXo4Sm9jNG5jcTliS3hHWlJxR2hJcTBxdkJuVTVoTnFxUEc3dlErUGpO?=
 =?utf-8?B?dlRSYUg0L1Rma0gvTzFaSXNJeC9RMWhua0VKVzJVUUgxSUxSU1BoOWZtYU1C?=
 =?utf-8?B?aWd4UWl0cHpidGszaGdxQlVIdHJySklEOFJ0TVQ2U011UGhySW5OWVd1ZkFI?=
 =?utf-8?B?b0h4WXQza3lxcnlXL2xwZ1dsWVN5WkNlK1V5UzdqZTlvU3FnMUVNZGdPaGl3?=
 =?utf-8?B?MSs5UTAyVGNXWnNCeUhMN3NCQ3pwK2VzSHRKQ29WeFI5UU9vMWlTRTk2NTAz?=
 =?utf-8?B?NUl6ZUc1eTJTK2NWcjFKNDV0WDZGaTdlY0g3SzJpUVZnVjlrUmQwU0hTUFVW?=
 =?utf-8?B?Qi9kMlNvZnR3N2ZmZ2lCcy9aOElGbjN5ODhldExkb213ZlRVRXAwaFpsNEgr?=
 =?utf-8?B?Tkc4QW05UEVrdlhZN3NRajhQdTJZMDVxRjcweFVMRmJtUXRYUUlscFNtdkV3?=
 =?utf-8?Q?/JHlD/CLguI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWxJOHdSdTJEa2d6MXN1bmVpaGZRYlE1aVVCRjhXYXcyZFI1bDhqQXk0RSs5?=
 =?utf-8?B?TFMwa3Y3cDFVTlFsWjU4Q0g3TnFHZkU1NklHYzFQL2U3Yktza05wMUJOYmRh?=
 =?utf-8?B?T2M1WWxlWDVpQS9YUXkxS0FVNG5mbjhXdlJvREtCM0oySDUzdExLN1FxeWox?=
 =?utf-8?B?dTVEaUkxZEpZY1VMRE1yZzZFM2UvanIxdTRoeHhjZnQwb2U0TllacmlmSkdT?=
 =?utf-8?B?dEJ0NDNPYzJUTzM1LzM0TG01dzhzbXZNQzNPRmxTcmVyc24rUEN1RER3eWpk?=
 =?utf-8?B?VEROcC9vOEpycXhVakZuMmNrdUQzcjZqb0gvd0ZLTVF2QU9KTDRTWVFvbWNQ?=
 =?utf-8?B?VWIxMUZNZ0VOaDZkazVjaWFzcFhQNEVZS0FwTUx6ZjR4V2F4YlFyVzM4SlFz?=
 =?utf-8?B?V1RsS3I4SVJ2bUx3b3B3ZFdzVWQ1M1VrMDYvdUpJSTkrZjZ5aG5LZ3JFL3ZS?=
 =?utf-8?B?R25YenZsbnlUc3NPZENYOWVUQkFnY241ZGpBWWMzWHZZdjVlaCtuVml6YVJW?=
 =?utf-8?B?bS9Kbjdsays5ZlVaSVdLOTBDcnova3ZmOG9FNWI4TWQzclpJYlZLUnFOY1dn?=
 =?utf-8?B?VUlqaUJpRDlPSkt3cHU4UGRlYWw1TzNpLy9LQ1RwbjRUWGw1NFpOTVg3ckIz?=
 =?utf-8?B?ZHU5SEhzRitUbDEveHhVZEdwYVdjQ1hGV08ycVVWdlFaTXJpVFh1MHUvNXFw?=
 =?utf-8?B?YkxBTDUxam5ZV2dXR2NnaTZqV2NCNTFtbHF3dTZzNHNyYXpuQjVtTTRJdU9H?=
 =?utf-8?B?ckxQQldGSmR1SDdTcmJRY3puVndFNk4wa0RFb2VHeUxsajN4VWJsaUV0ck04?=
 =?utf-8?B?cjY2bXhMcWdpYk1KbmhRSDhVQmxnTFVTajJxakI5NktkQjF1bm9Xbmo0OHQ2?=
 =?utf-8?B?K1MrU2YyMUlRMC9yaDNtV3F0amlQbDVuc0lBV1AwM09pRUJZV0phSS9ibVNF?=
 =?utf-8?B?aVBod0ZiY1c4UlcxSmZkV3d3eUNaaXljd1pMZkZUcTUvTnpobDRnN3hqNEJt?=
 =?utf-8?B?N0MybzRoME9uQWZQemVtcHlwWTBBcjVuZ05QTHNDSnVRQ3c1ajN3NEJrWnhN?=
 =?utf-8?B?SlBPdVFVcE1wS1BrNmZ4dVp2U1lEcWtHRW5zVVJDRzdJVzhtN2ZuMXErWGkw?=
 =?utf-8?B?Q0lrWUxUMWVnWE44VlVIVm4vMTRIaitUVXA3dGUreU9kUW1SbUxBc1ROckhr?=
 =?utf-8?B?OE1jVXVCVWdiNldCZU0vYkwrU2V1dm4xVEhicWFLc252VndXNWhaUFdLdGZH?=
 =?utf-8?B?RndodldCVnltekx5MEttbGdwa25Ub1JnbWdGTG9teXpFWmR0QVovem1KTHBE?=
 =?utf-8?B?TGdyZVQ0OHB5SktPU2VBYWp4V2VZNFJOWnBxdU55RVNrQ0U2ejBpN3ZmSExT?=
 =?utf-8?B?Z3FjT2NmbXdXaE1mYXVGNkpVT01WcDFod1NlRW1DMWRmdUNiSjlPUStuZVhJ?=
 =?utf-8?B?QWZ3ajF6QUxoYzBIdXBQU0ZhNFREKytxcWtVM295ZVdUZkNEVmowQW1OT3hT?=
 =?utf-8?B?MnZOOTg5YUl1cU45eEdDWTRydnh2VnRhR25ZekhKd01OUmhTUEV5bXg5d1dL?=
 =?utf-8?B?dkwwNEY1K2FzZUJudzNTeHJYUERxaUc0M08vMDNmMEh6RE9henhmU3pGNThv?=
 =?utf-8?B?WHNaK2Z6Y3dqOTBTNkxTVUk4QzBJWCtWdlJJMmtoZHlsd0t5WWdLbFByZ1Na?=
 =?utf-8?B?N1FSKzVKUkRnMTBDTXdPT094TThhd20zbldCeFRTTWFmaGJTMnVUTWlwQU5i?=
 =?utf-8?B?VkNNK0lOVURhcmY2aEh4UFNOcXpjcm1LWnpwSTZVTFZVT0lCb0VKdmRUb3dX?=
 =?utf-8?B?TmxGZE1lRTREdEJyMlBaaUVhWExrbVhxaGdtYnBZNzFUZXVySHdDUHVCbGEy?=
 =?utf-8?B?R2l1ZWVwTG5YVUlQRGpUV2pxTVltak1mb2ljbDhXSjB0d2pwSTNrOGEvWHpU?=
 =?utf-8?B?RmtXTGVTdVp3eVh1R3Q4MHFkbjlDV1VOMHB0b2pEMFh2d3AxZFBkL1JJWUMv?=
 =?utf-8?B?QTc5Sm5RdXkvVTEwTkVnK1FFaE04WHNtVi80Yll6dVd5b0czSHZkcERZODll?=
 =?utf-8?B?U1M5NGxESEoxMjRaKzEvdENaUXdtazNvM3hrdmdTZm1HUzhPWWQyS3JSc2VD?=
 =?utf-8?B?Q1dtQkgrYTBHOEE2ZE1YYlZrYS9CbGw3bnUrM2d0M095VkF1U1N4TWhDQThU?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wEqdpJzg50CZPdie+GM2pvXuv7Oa1QhmDv3YAvtTDsXVjHTaRsEognqK05cxvEcpzJPmHksY8jVNMJs4eO8Drsg/dE88rp6SxKiB/ZZpb1HXNtzETE936u/r2/r6s3G6m1NEOjIOFLA6ZkXlZzOBq+2WKa2y7mhvMUe35GWxqAYnsPmWc7b+GcsIk5Om/6nx5+Jvh30l5GS0S2FdkqCAks1lPytVDwufT7t3hr5aNt7thjW17lPXXWDoA4j45ysKLdizqBuKXQrdQYzUgaZNW47f7be4u0ikYDas0kf2+9vvH+n239pUy/S0lPISYlam2jt6O6LM323du+DaDPXBJNf5UI81Q6EWCybZLAU47dGNFZqqwPKJqgAMz4FW5ar/sSw5ES/rNdqSAeI7BjmalsnVbY9zn2a07Ifp+TUuFoQWewUUSS+QzUnlFyYesA8INsqcrThf3OzgMFTEysl/Ju1mhUGwsFaFdsR4AWDlAQUlxej6J5FkqJTeg5oeBrn84Ei9SJJNuZYFcrZowp5PNo5VeC5ax+hQffP4JImDHoJ3/nr/y+xtHdgY+rHI7hcEDNbVd9boyvs4D4yKFNEi8uqlCdj9i0AjYpfEU9MioJs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 260bc96a-bbab-4703-aefc-08dd793b7189
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2025 20:57:17.4107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JQ8TKTbtnAyCBcGOVf9+hI+NARjIegEkgi8ZXC8Rcme/F2iCJeyP/aaIB/UBuwszO7D6kkoZZR/3E9gCVHK7/Jbpmb/KDrn10sBeKNG+E6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-11_08,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504110133
X-Proofpoint-ORIG-GUID: qyEoUnSNb17ebG1zxGiU7BebKeQg9Z54
X-Proofpoint-GUID: qyEoUnSNb17ebG1zxGiU7BebKeQg9Z54


Shuai Xue <xueshuai@linux.alibaba.com> writes:

> =E5=9C=A8 2025/2/19 05:33, Ankur Arora =E5=86=99=E9=81=93:
>> Needed for cpuidle-haltpoll.
>> Acked-by: Will Deacon <will@kernel.org>
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>>   arch/arm64/kernel/idle.c | 1 +
>>   1 file changed, 1 insertion(+)
>> diff --git a/arch/arm64/kernel/idle.c b/arch/arm64/kernel/idle.c
>> index 05cfb347ec26..b85ba0df9b02 100644
>> --- a/arch/arm64/kernel/idle.c
>> +++ b/arch/arm64/kernel/idle.c
>> @@ -43,3 +43,4 @@ void __cpuidle arch_cpu_idle(void)
>>   	 */
>>   	cpu_do_idle();
>
> Hi, Ankur,
>
> With haltpoll_driver registered, arch_cpu_idle() on x86 can select
> mwait_idle() in idle threads.
>
> It use MONITOR sets up an effective address range that is monitored
> for write-to-memory activities; MWAIT places the processor in
> an optimized state (this may vary between different implementations)
> until a write to the monitored address range occurs.

MWAIT is more capable than WFE -- it allows selection of deeper idle
state. IIRC C2/C3.

> Should arch_cpu_idle() on arm64 also use the LDXR/WFE
> to avoid wakeup IPI like x86 monitor/mwait?

Avoiding the wakeup IPI needs TIF_NR_POLLING and polling in idle support
that this series adds.

As Haris notes, the negative with only using WFE is that it only allows
a single idle state, one that is fairly shallow because the event-stream
causes a wakeup every 100us.

--
ankur

