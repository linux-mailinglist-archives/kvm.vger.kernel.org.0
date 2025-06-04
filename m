Return-Path: <kvm+bounces-48423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 72F21ACE203
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:14:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E147D189B4CF
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 16:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 706261DE3DC;
	Wed,  4 Jun 2025 16:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="y5c61R8n";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="NOeMsgvD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C20E1DD9AD;
	Wed,  4 Jun 2025 16:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749053649; cv=fail; b=uKF/sncp2mi+5EqtK8FwrS8mjGY5U4lQLqC8qbpG+l54pYqFMMVJ9lOoziy0Bqd3cbRs0vQqn5qm0SuepHEJKJXj27ViWleEHZTViE3g8Me6wa1BarQsy7t+CNwTCj5sbs6MSKlou3bQBnzVll4WuAl2Z8F14P5X0YEnvRySDJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749053649; c=relaxed/simple;
	bh=UP6tlCvpTy5sEFqAOyJSqFwxhT7c/bLmUNmVVsNCMlo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ucbof6+0xfQ6hezrubwgB+aTfkiBPau/b9dGze2OawKl2THhZCzESvxd6IYgp9QXUYDG4hF2b5ZvKXm/bzpj0qQxR/1JSz60FEA/vHrSczKVT38FmALc+0qgeTOdvIpwQuWKtXIZMmI9WwsEhs1rTgzGCwIH8H9wqYNWgZa/UTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=y5c61R8n; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=NOeMsgvD; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 554C1UHp024982;
	Wed, 4 Jun 2025 08:57:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=1xV75CvoLZTM3uQRrHrxZP7xw5k7EoMnnodfjlQAi
	Ug=; b=y5c61R8nSQe7RzB2uMoU8MUB98c/5ql3BI3tDh258E/eY3NX5CsjudJuQ
	wbfNJNM3AsycnCVCcQJ3ipVTpjJ3vGLDQFXoTXzYynyBP8VqjSuW0fJybhcuwzze
	kuAHwgZ2weHOrq3YAWjbMP6K1ZEeZIBm54WSBMIVhJhTW3fGY71tt89DfY4FK3ov
	P4rBNZu5iPOHlr7n/L099lzMJRDPJ47O3D1fdu3eFymmRGjvzeZaPri/Wa7mNV5z
	24UM+Px6VDT+uqdAsliJD1MHkOV0eTJKw1OnENVY2zEHWBkMJ322uHxXNrDdaMLE
	Y3cDairaWW3FB3Fpxc4A7KcRFFL2w==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023085.outbound.protection.outlook.com [40.107.201.85])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 471g88nmqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Jun 2025 08:57:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vUCJatttTBljeRLw7KSslxtvM/E1Py7YuKKAPHkfIr98005I/mFUZ0TLQdIZx0MibA5BpbDVD47XsBq3QYMBYtw9PpKLKvO59d2kkU7A0li3MLHMXlCBpfP8i9+MpsDfbSObR//rw+JCMue1alJ2zLpVfi0LWTEKxvgKz+8fLEM1lDTOz51nLcLPjTcTms9ndzhTuprWzihGPoRAOxiVHbmwQDskr4WCZhByu4MZrRn+RLhdmHH8zFaT5Uyi/F4rklhoQJISuXczkeZR3S+ZS5qsOu9aSqPMlcHNZA1IaxidMw7XYkj3f7ti9ohRvrqy2M5cW0665tuy8HZr+iCPMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1xV75CvoLZTM3uQRrHrxZP7xw5k7EoMnnodfjlQAiUg=;
 b=H+3sHWWoq6LKnoC9Ywo40B4Uz78eLnJ0b96WtJa2FU7o5O8btSpN5VUqOKQ2AW3JYiMIrgzSaYiNLH4S6xGZUk0UQ8JRyCUCD77qs6xdGSaL5tARcdWIc/LPth8Lhm3tFa/bLuFViNnHnmVUvadoTPFH8uc0pkPen+nbRGdOeZLqUueQj2wbJ42a9BcT83zd2J5BUiU9b2PDGO5UlA63ZrVtLpof5HGjip72InUdWIpb4DD+ZGBh3hwrMSyX67PP8cLKdx2fbedZHvkLklo3dojye4pmzrq9zhkgy3PCcen6pgabayiTX8qxU/Jqzitd7pZmNx0ElrmtxKOJ0mE7Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xV75CvoLZTM3uQRrHrxZP7xw5k7EoMnnodfjlQAiUg=;
 b=NOeMsgvDXb3yNtmy4lqnXDELybodaTMv0TP+YBPQ8B4MnExP7gsNNMTFP8CfLsoM9br1IQwrP/ktfLUUUS90R4225qr+FvZ6FjwB53EAMNYN6SCqxmPEm3nLKn0tT2zuKAVkzdSphkOhLw3OgDy+6vyFpVY4GviojWBmY77ookuGsOSNJSyHlKRkRo7JDP0JwNZBzeKBr2/EjH6eWXzGF0uADLIHrFrHa/h5N0rn0alRtqCuy/xJNV02qAyhUM692Q1164TFqD6xIDGjp3BJcan6ItwQIuaecQsA/5HX+JQPt/zDBm2Lg/er2gFfUJxYYbfsyrIweLDamcxeC0c60A==
Received: from DS0PR02MB9101.namprd02.prod.outlook.com (2603:10b6:8:137::22)
 by MN2PR02MB7008.namprd02.prod.outlook.com (2603:10b6:208:201::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.19; Wed, 4 Jun
 2025 15:57:35 +0000
Received: from DS0PR02MB9101.namprd02.prod.outlook.com
 ([fe80::ca92:757d:a9c6:6ca3]) by DS0PR02MB9101.namprd02.prod.outlook.com
 ([fe80::ca92:757d:a9c6:6ca3%6]) with mapi id 15.20.8813.018; Wed, 4 Jun 2025
 15:57:35 +0000
Message-ID: <0ed1eec4-512a-4831-a9be-8ad8bd00fcf1@nutanix.com>
Date: Wed, 4 Jun 2025 16:57:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/mmu: Exempt nested EPT page tables from !USER,
 CR0.WP=0 logic
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Kohler <jon@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250602234851.54573-1-seanjc@google.com>
Content-Language: en-US
From: Sergey Dyasli <sergey.dyasli@nutanix.com>
In-Reply-To: <20250602234851.54573-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8P221CA0062.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:349::14) To DS0PR02MB9101.namprd02.prod.outlook.com
 (2603:10b6:8:137::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR02MB9101:EE_|MN2PR02MB7008:EE_
X-MS-Office365-Filtering-Correlation-Id: 494be67a-ac22-42ed-8517-08dda38085a1
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YlpIc2VpVmpKNXk3bHVJN3hjY1pUdVpIZDRWQVZaQlpobU1ONkhheVJVUCtB?=
 =?utf-8?B?Tk8zZXRKakZIbTJ4ZDNvMjlLcXROQ0F3M3E5Mm90Y2I3WW9pcGlPbVZkU3Vz?=
 =?utf-8?B?ejJhd3ZCaktveXFMMWloSG1RT1BxNUliVXk4eFlCZ2NaaWJlMjRvb1lrbnk4?=
 =?utf-8?B?L2hFcWNJVG9ERk0rdTdYcEtVZWJieVZsMGNxb0xqN05WaFFLZnE2RlVIcEJE?=
 =?utf-8?B?ZHk2eFdKSE1rVnN0b2lDZE1tR2tuTWZYQ081ZnB2ODRlQkFUcW1ZaHBjYmRZ?=
 =?utf-8?B?Y1FTQ0NmNGVtMEN0dEpLeVlrUXNtOW43WU51T2JoWTdCcGU1WEFyRHNRODRV?=
 =?utf-8?B?N2F5Uk0xTVhKc3ZCcEZyUHZlQ204Ykcyb2FnTUdUUEVZUFAySXVXM2JMUmZV?=
 =?utf-8?B?dHhlRHR3d05IZkh2MGt2SURaVTFkeFM2L3BCS2RwYkRLWVQxa3VweDBjWUhZ?=
 =?utf-8?B?RzlkRTBrMlNrYlhZbHlFaFJQU3gxZ096cDZTNm1lcStGcHFMRCtOcnhNLytE?=
 =?utf-8?B?eVU1cGNIMmlGNjRjaVpmdDBSYXJtdnlGWjVUMWR3c0o2OVl6dTZ4Tzc2QUNm?=
 =?utf-8?B?cUVaSFJXRzI3NDhsUVZQWU4wcHFjaUkrUmMrSUZ2SHBFekhzYk03V2pVUzFZ?=
 =?utf-8?B?SVNkSkU4Q29qd1Z5aG02c0tZbkxZR2ZhdUh5NmxBd0hiU2IyWTJ6bVBGMGFo?=
 =?utf-8?B?a3JDRkk4SkxRUUowSHVqMjJrQ3NVdzFDQXQ5b2lJOE1LUnY4Wk1VWVBEcGhx?=
 =?utf-8?B?bTF1NnB6M052WDlXNSs5TGx5MTg1Qzk4dGttVmcyREd6S0tjTHVuTUhYWXM0?=
 =?utf-8?B?QlFHcDZ0UDJaMnROZWFPVWdxaXRDNjlieXNXcTBrbzFNNWNLckxLQVpvcVho?=
 =?utf-8?B?V21mNzBDOUVRNFBYZWt0VmpwNHZuRUY4Ym9Gb01Xa2VaQkVBTXVxZkFxYUY3?=
 =?utf-8?B?MkpydnN6QkQ4cnpwUmNlSnJnY0d2dUcyNHUwN09EYVJ1VEVSR2d6a0xQM0ZF?=
 =?utf-8?B?dEVGdVh1NFl4WmphNEx2R3Y4OUFPL3NsRnVVdG1vQk5pdzNFcUxuSWVPRDRL?=
 =?utf-8?B?eU0rTFgxN1lxSmc1bTVmMHdVeGkzQ0xrVHlYZ1RlS291VXZyTXVkNXQ0OWdr?=
 =?utf-8?B?MzZNM09ueWFpNDU3dzJDbkIvbVdHZFNIYlFUY3l5Ukt6NmIvdHJVcXRQR0wz?=
 =?utf-8?B?cXVTR3EyOVZvQ2VwMmNUaXFFSFpIcTZVV050R2ovZ0NRekJINGVDbkpaYXBK?=
 =?utf-8?B?TThjMnE1bnlqa2h3czY2NzlyK1d0WlhuUWY2UFVwZkhuRllkOXJmUU83UkFN?=
 =?utf-8?B?VUFlaVhqYkJKRXJQUzRhM3dnRE94M1RuL2ZnVzE5VEtFQTJ3dElzMEpudHhx?=
 =?utf-8?B?bkZkY1ljRkdESjNjdHR4REQxQk1HQ3FuaVlRREo0STlhajZTZUtSOGo2MXVR?=
 =?utf-8?B?ckRKM01STWgzSCtFUTNpekMvRDRiQjd3UzJoYWVnaHVyZUdSK3paQ1pnc0NI?=
 =?utf-8?B?M0NGalFBM1ZISkY1Zjl1K3FzWFh1dVpCSWZRRnhhbWJNenFDMkg0K0pIeGRI?=
 =?utf-8?B?WFZCTHdGWHJRSjJkRmx0RmQweklXcis2RlRxczVIV1M0dTBhOUtEZGs2UEJa?=
 =?utf-8?B?dGxkcjA1VVB1b2FwV0M1emdST1BFdTMrMEltcVAvK0lwNE9sK21QNzdieVBq?=
 =?utf-8?B?NGVLb28veUloQUhMN1M3WVd1R1FCd0N6M1pDWE1QcGV4a3Y1YkdxSTdydVps?=
 =?utf-8?B?VERqYm1DRmVPL1kxSzFlVWx4OHBMQlpUcXVDcXZMSmVDVUFRUVpyOEhMM1I1?=
 =?utf-8?B?b25KU3d5bjhSODNpYVE5Tit0WDlPbHNlTEFWTytGOUtCUUd6RGh6ZU8wNTJS?=
 =?utf-8?B?OGVhTzNReTdOaTMwMTlDTDVxREx3L0J4blVlMWRpNUE4Um5Kd2xMWlpIbFY5?=
 =?utf-8?Q?+UIiuomxgAY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR02MB9101.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1ZjSW9EMldJMXJCYnBiaFBGQ1ZuVllkUzdtOHZxZTV3ZW1pb0w2MFNpTWF5?=
 =?utf-8?B?VUZvakFSZjVyOUlqbzNGMTNRSlljMStpcG9NdHRYWjJYK1JCVTdUMjZ0cDQ4?=
 =?utf-8?B?SDdweHcwRVh1eFdRVEpTUHBCS2dEcytUUk9SWDB4NGlBZ0R0azlHc3AxUFdQ?=
 =?utf-8?B?SVdIeTBOUUFndlljVzBwTVliakJDVkdabmhVUDlCRDgzZ0h5RWpqdEt5bWJj?=
 =?utf-8?B?WW51U3BvbEFTZFduaVdWT0JUUkJ6RnI5UEEveVVwTkl3aXMvN2VZbGczUzBs?=
 =?utf-8?B?ZGk3bERMeHZGelFtMW0zM0s5MWxKVjlWY1Uxb1VtV0dsMFBUOU9MVWhTcm1S?=
 =?utf-8?B?aGZKbjN1b2haeTdRWVYwdjBObmw0VnZsYWtRby9oVE40M0xRMG9PY0dnUTlZ?=
 =?utf-8?B?ZFRoVXowQ1JMYWVQRlM2SWlOV3BjOHBhVzNieHFXZHoyeEpDZGtoS0lia241?=
 =?utf-8?B?OTdrWTNPa0QrNjMxTTE4UHlPV1Vqdm9Pb09QVWYzVythd043VTcwd2NVT3pF?=
 =?utf-8?B?VnFLTWNadm1qVis3dDRJM0dnTlZXamVzdms1OU5GWDQ5N1dCalRMN25zd29H?=
 =?utf-8?B?UXZKUnV0RU9SOTYwdVJuOE9YZXJheFhhTDRKa3EzZjNvUm1ETXhweG1lOGlj?=
 =?utf-8?B?YXVYRjBDc2tVV2JXSTZyV2FMY2ltc1VqZEZqUlpuM0tla1JZck40bEp0eXM3?=
 =?utf-8?B?UVBHZ2JrZjBNRC91czhlN3VhSEwvajlLcklpNW1Edk51eFJ6U1c4WHdjamJL?=
 =?utf-8?B?TjNDM0h0aVJUOVhTOUlIeDZoZ1hJYUZYN2xTMVVUOC9KckNwTDJuOGlNcWZJ?=
 =?utf-8?B?Ulp0VTlJaDdScFNSaFZodmQ1Wmx6TkZKdVAxK1d0TUFJYWRrYVY4TFVoYlNr?=
 =?utf-8?B?UnE1N0NlMHJRNE9qaExKbUZ5VE50NWFJTHArQTFTZ3luNTJRYjI0Zno4Vm8y?=
 =?utf-8?B?L0h4S0FFZXkvYk9lT0RoMHBDdXFyS0hiWTRBTVdKZjNjTXU2KzhudGYrNUFL?=
 =?utf-8?B?RmJTOGJnbTJETVlsYm9vSnpzeW5EYmh4QTBZa09qT01RRWd6Uy8xdTJ6eGp4?=
 =?utf-8?B?REVRQVRkUVZBb3hmclUzNko5L3pPWGtHbTQ1VkVreStsTmJKcnJSalRMNjBN?=
 =?utf-8?B?bEZwUXAyWHRDdEJOTjE4QnMrOGZwNTJlQXcxTHg2UWVNbk83K1JtdEdZSFVC?=
 =?utf-8?B?NjF2WDBLZUprcDh2V1VvS0tpcUxla0RjMUpQNU1CZEExcE80QWhjNFFXUzJW?=
 =?utf-8?B?cDRZTWlVNjM5eC9pVkliNHBYdTZsN2FsKzRjYml3djd5eXI2V1NlWkxKN1lt?=
 =?utf-8?B?SGNaZll0Tm9kdnoyR040dFFBckpqdGNWWFJVczlTVHFqbzBrNWN0ODBwUGNi?=
 =?utf-8?B?RE82QS9CNnBOc2Jkb240cFM2dUloRGYxTkFPOUVqWUJJS3R4UWFZN2N0aHZZ?=
 =?utf-8?B?MGg1aDRBSWZzN3Era3NjaFpWTnprc2V3K0lNYVBvOTk0ZUJIcW1PZ2xWUHlZ?=
 =?utf-8?B?V3g1eXVLNUlEbUozSTFrdmVRMGtYUW1aSDU3RkJDa1RnaWhWRkorR2ZIbWg2?=
 =?utf-8?B?cG5yWCt2TVVVQUhvVm1XakRIVmgyb0M4WTFiRkF4UzRPWVhER3V3aEZqSlB5?=
 =?utf-8?B?OU5zRUZlWlVrTWpnS21EejYrU0hZdnEwN0dCQmxZOHVWaWtGTW5pMEFpaGFQ?=
 =?utf-8?B?TGF6ZVUrejNsWGVnWHpaZU5TajhBa3lteHl2ZzIrQTZWV1pYRExGV3FlTDdL?=
 =?utf-8?B?czY0amlhWklUbHpscEQxVzFXWmg4MnBVOUZ3Q2w2SEtDOHVGN05vS0dHTDVU?=
 =?utf-8?B?N2ZBQjVqazhIZnlXdGRHZ1gvdjZPZEFXd0F6cEJ3YzlNeUlIdmtwZjU2ZkZz?=
 =?utf-8?B?UXNnU011MTl0THJTUUM4TElnVE42cGlNT2tsclJtUkxMZ0ZOdUE0MjBMY0to?=
 =?utf-8?B?UllRK2wzbEFSMU5CK2hoUUloeUEzQ0VydWdQeC91dE05M0VTSlc5MVU0cHRF?=
 =?utf-8?B?cXJObElnNDJrL0IvazhJVVlhcEZKODZYNzNocThOM21XaUMwWjhOa3kxL2Jy?=
 =?utf-8?B?elF1OUR3d254NkVhV0tvU3JRZ1pMSmZoVml0K2lLYi9lYXF4djIxemFDdzNw?=
 =?utf-8?B?eE0xRHMwU3hpRFNiVVlyN1p0NlFGMk5PTk5vSDg5eVE1MEJrbGtzalNQYmpy?=
 =?utf-8?B?N0E9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 494be67a-ac22-42ed-8517-08dda38085a1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR02MB9101.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 15:57:35.2466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vEfrOAQOYoRUHOwh1JEMWufzqbb+hREaT7ba2MM3v0GwgCQ3yJElDylQve2qHD2oJcV9CKGYn16A0OG6GNzWBnvxkvtd/SMpGZ3FTQMUsFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB7008
X-Authority-Analysis: v=2.4 cv=K5kiHzWI c=1 sm=1 tr=0 ts=68406cf2 cx=c_pps a=hLZKniPSsdZe/G0VmHakBw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=1XWaLZrsAAAA:8 a=I1SYLbdxCI6kIEYJAuMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: EROlx7gofjMnoU7lwvZZAJBnZ6zg6EXD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDEyMSBTYWx0ZWRfX5ooS4clchWYw XACjyQxzLTWER4fsrYGmd8QYZdzZjfvdjD3OxOXCmZmrPBrNhIj4Siq5VD2YycWRK7k+Vu7jd8V a3ZOOvtxbTGEKbIbWY6QsaeBdhnGAxy/sYFm2wKF8aBXJsZizKYQupPzqjcLKfCCxqDZ7iO1nIk
 iO2+d2W1OBqUrrQnn80rOuZ7YDFss4OxZCLw8ldCU5HnoC9zhJCFYAJXMDxf+tlo51EzzH4seME 6BsAsaDjn1iNZME1PWs2Ea+QGHVncAdtmVAvDHYxR/AvYybfv6nsjbj1vpvrPk05SSyfqusUy9i QLQE8fNyFk6JtnBIKibxXb4GsE5p13xmQaADGtr3l4mEsvobGMXSBIUVCtm1X236q50YOEQEzmF
 9XpTQFnjG/TeUyjT2JvxsXPvgl3oFFgW1wVRBLJ6ZxNvmNVhWcxVd0Z9ftu7o5R5OJaDwNDO
X-Proofpoint-GUID: EROlx7gofjMnoU7lwvZZAJBnZ6zg6EXD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_03,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

On 03/06/2025 00:48, Sean Christopherson wrote:
> Exempt nested EPT shadow pages tables from the CR0.WP=0 handling of
> supervisor writes, as EPT doesn't have a U/S bit and isn't affected by
> CR0.WP (or CR4.SMEP in the exception to the exception).
> 
> Opportunistically refresh the comment to explain what KVM is doing, as
> the only record of why KVM shoves in WRITE and drops USER is buried in
> years-old changelogs.
> 
> Cc: Jon Kohler <jon@nutanix.com>
> Cc: Sergey Dyasli <sergey.dyasli@nutanix.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Thank you for the patch, LGTM.

Reviewed-by: Sergey Dyasli <sergey.dyasli@nutanix.com>

Sergey

