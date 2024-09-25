Return-Path: <kvm+bounces-27502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BE53986982
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:26:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AC391C21EE6
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 23:26:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA5751A42B7;
	Wed, 25 Sep 2024 23:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KXlrsJJe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="V5Osz7bo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF0614A0BC;
	Wed, 25 Sep 2024 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727306733; cv=fail; b=T2IbkjVzNP9lAtJ4d1K7QxeaD61agiRp5cSCcTu4lph/KwzD2y3mMFZ5ciO0M+VG7n0OSosIg7rNeOTmQwBSpXiOSnA4wOpYVh02fyFEUlCUEinmXea7xUEaHxHkqIon2LH4ILYlvGgVdsRACGgJhEnqwcfiUIfKUbbtpKvHWUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727306733; c=relaxed/simple;
	bh=h+s0zPrbvlVnDP7LgdMF6n/gdbD2X+UkkYRVL3akutM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Y0IruD2VnxyyKoW7hQc52SO6sxtIHkMmrnmA3XxWuxiLpJ5z0etQQf+1HS1w8LD64uLO6GbcupnmXZIWYBTv6SUM3Z6V3i7166PRiVVbmFbpCN9Vaxmx13BdlV9RMtsfydwRLdU93YdRooZ6AmgndNoxaiwFfSIiK4hUve6McmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KXlrsJJe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=V5Osz7bo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48PLnMhq028909;
	Wed, 25 Sep 2024 23:24:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=tuXMmugSwWVSw8iGwCPMmmKPajF8YRsj8SWgseskxsA=; b=
	KXlrsJJebwveCk6kUbzG+jHTxwE4mv3gOTRxmyjO1atgTlxcMx9UCNo8fLKNYikh
	X11svJehqan/q7xiuVBxKX1kpImDTEhjX4+tvewP0ydOB3x0SnPfV+JiUh/TJ+rA
	qGPsp7pCnQ5drSnR1mReIRi0P4BEIjPaWRGtrziSmUbWAnNRniWVDPSJYHg++KfY
	TozT5R6MTkMNeAlYBaokJealL5dmbT+qdJSiXF01Uj1ayV2eD+BL9kdo6XUWVq6w
	v4FXFQUcq1Z6AplzmpyTH1B9uQBzVI/Uc9SjQWo97A+4qeEWKUPNWimLigEP2W9r
	B6cCrQcBXBAjfx2oQ+GcBA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41sp1akkv0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48PM8diW009724;
	Wed, 25 Sep 2024 23:24:51 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41smkb2kjq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jEh9GBpY8pADs+lylcXxvuDaSuVdCWWG8ihgR0ajGSBi1gfhEH44MZPUBsQMeR/ZEFCVRiIEdRe+gxyBCTdBizcNgeq2v4rcypxDb8ftz68x8BPG3+zZHCjQTknrHwXbDBqoNEjoy6EE4si922fVAb+FaOtgCJrWRTREBzCNNEf6crNEjSzLgYOm8yw7ecr1R7jXp8yF9PmA0m7vD0k5vYAq1XWLAg/mX2dwMRl0WQ9Y3z+pYl9SJgpVXmhIXMkNpAZB0Y5nRmTXx/Z23JBU+8uc5b7188y+5GUgg0iJoAlJ355aF5cXUp/7jAeW6JVYRAY+MwliW7rvw0u3Yj5r9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tuXMmugSwWVSw8iGwCPMmmKPajF8YRsj8SWgseskxsA=;
 b=EBdpDE9c4bejQbnpWJggRYpj45btZ6TYbutRHL+UMwdEYd3FedbXb6TuW+o9bQaPIZ0Wo9v9et4tYp+WW4ZAY2O7mrUDLWifSSxmtmQgEQrMpCyilKpnYCUo/eGaOA2egX7f/dEz2w+6HlvISfZTUUGcWqdfJeWAxILn5CyXKh2nYV1LyG8NZh/joYCMUx1mTLz9T6wbfuJ8xoUq/wtqQiY/015iKItuzlWW0Llxei8krJjgwXLKr+7eWFwjSjOG954ExTZbcCBqsCZ5Qkz/vJ8b5oodI5C/frVPBS3/vkCPD7uQOi1WqnKPJH1ruGLmC4/Vt0FLDBYY+B73Ai1xqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tuXMmugSwWVSw8iGwCPMmmKPajF8YRsj8SWgseskxsA=;
 b=V5Osz7boCQ3lEymbJcPkwbqHxeZy4i2cnjmyVyf/jHngrDIHzk4MBTyEtH1AB31Zp01QCNx+yBD/74DeMLzzEC3mSZ81VE6n94vSDLeKe5tFtjIznzY6AuD3Gi6OMTHdQWie75hZfIvf9jy/ZrL6DfBT191/sK+Eep8lXCb3Yto=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 SJ0PR10MB4509.namprd10.prod.outlook.com (2603:10b6:a03:2d9::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8005.12; Wed, 25 Sep 2024 23:24:48 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%5]) with mapi id 15.20.8005.010; Wed, 25 Sep 2024
 23:24:47 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: [PATCH v8 08/11] arm64: idle: export arch_cpu_idle
Date: Wed, 25 Sep 2024 16:24:22 -0700
Message-Id: <20240925232425.2763385-9-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0005.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::10) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|SJ0PR10MB4509:EE_
X-MS-Office365-Filtering-Correlation-Id: 372da725-2624-4691-ab9b-08dcddb93f10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tNf9+mA3jokdSPt015uacIy+nsojNOMpdxlwQFQulvvMrJIQpxScFFpWlFnD?=
 =?us-ascii?Q?xDSOrbKRpR76qjTsZ884YmVL0BVDQGPDUQGGMYC4Z9K6JFxdTjeyJBexxbGh?=
 =?us-ascii?Q?wSZFoG8lIKb4845WCQXT/wkI+JBBZf4OYifOKgj1Kv6SuM4BeSKX3hIfLRPL?=
 =?us-ascii?Q?8AMmXYmPgNVoilaq2tu/UBtydWOIhHM2rZgbQlvc0vp4HAzzfzga3g9fBrEp?=
 =?us-ascii?Q?cKnMNGh19i+VeWc7t1PHnz7hz0w89MHyFmWOh49KWDUf4Dbo6VQqBpjqhfdT?=
 =?us-ascii?Q?J765QEHelhzcwVTQNnyt6aSeFYO2UjblCLR0OTysOcAYlLjJ3UoCsbDMSi9J?=
 =?us-ascii?Q?TEEJRlAhMJiOWoMnkOfFfUQ0m7jwK53izcFXYAs1Uem7LT+6iERxHF5Svf1U?=
 =?us-ascii?Q?sKi4T9NkRETm9ShPRIeTbxpY2SaKXb281hotx5LdAVgsrEyP6nDQovg+D6cM?=
 =?us-ascii?Q?MkTAQtZY6+0SxYLExIU3KaJEJrScpAFGpYcXGXErzXsIY+p8MkuuXCLssQv3?=
 =?us-ascii?Q?RTLpUZhHKe1f6bxALN8poKXpfI9raGPpLgeUWqUwLCoteiFbH0zAPvqObOqV?=
 =?us-ascii?Q?n7xgzqQkgn8rvqXtHhNMpUtk9V+OzVLIz4kYk0Ipg3npYWP3NPsF2lvFVEQi?=
 =?us-ascii?Q?8iCLKn8di2n0iRsDh1Uu6zO+C06fdmuVN0DkNDR08ZBR+aVj51/bUGDTpw2D?=
 =?us-ascii?Q?ez/KU8VjUM4KZRFppahfzHG+sFUfsEiBa/mKx8ijt6N3aw6pZlu1m7YlBRna?=
 =?us-ascii?Q?lQL7zPqeTMir2k5Px1gaxxXDYLAjmLgw0Ojr+CnI/1JEXrZO+NczRgCh5jE5?=
 =?us-ascii?Q?zJqOHRbuXj+TnovhFICH8SR33gt9BGOhfSsQBANwKyffc3KbjH6Z8Izt1UMW?=
 =?us-ascii?Q?8tBNtNepq+WR6cik6T9xNl3ptNA6qz1Xb1b9/txzUBjPSvAjcuQxZZMfRXi2?=
 =?us-ascii?Q?R0nQ+e5qmklVbfLf6uvLjtDR8RNWYAAS3Nb/tY1gFrTT8sWY7lICDA8Rxb15?=
 =?us-ascii?Q?JnQzjAGPgp0B+9olAXcd35RSFgiqUZFp62Ml9hHxufg+N08SL2scy4PTUjZz?=
 =?us-ascii?Q?pGjYxn3KsSMTaxAKfOxV/Y63RtFHBDFQsMZfYOoQCws/tUdOgVCJ7kQIwQWs?=
 =?us-ascii?Q?Mw0ahSFE0UVpxpkh7es+XmTuGlzSMDJBOCkmuQhw/0eyrBwert++tQl3mR5B?=
 =?us-ascii?Q?pzI77ShK6Q+DG00aqcWgju+p4vjFcjlUO4gMcaNgXsBqm7rfE8WnxpIdVLCu?=
 =?us-ascii?Q?oOSDuoHr937dHxSQiAmd6T+zUbCWOowXGZxU0Q30OrJgvYP1GKgduV5fg4lU?=
 =?us-ascii?Q?F96ZCBSXVytrXT0OptnarvM4JhGiLl17gimdoYzfWC6uTQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sFiS05VbNa7G59AG80lISzkZK90WaEy0iDkYwOuMDY8PfVRF8yU/CmxVR9Zr?=
 =?us-ascii?Q?2Py7d821WQrRUKOkdST7KyArwDdGWbp5BavAyIvrdvZdrbd5L/p3FVxzdLDP?=
 =?us-ascii?Q?pPSHp86DIg5hm7qrNMuuXKyXKbE0kFFI3TLfBIPe71Mk9GO8S3IpTHR01zYu?=
 =?us-ascii?Q?VT+EyE1r9em2pTLS48jkqZpZWiaS1mkIUo7I6vRYsSLjfUQ7ietl1kKg/glW?=
 =?us-ascii?Q?xbSp9/Ul7O3Z7fd0VKNc8FSbsi4DqmrEW+ItSQlOXEKD+OiBBaJMX5/cRjjU?=
 =?us-ascii?Q?n3q4A9wbKfKkhF6zSFEch9nj5GC36seICuqTkvh5hsYXUoY6bPU10puWT9VI?=
 =?us-ascii?Q?9uwYDNxgoKD0Eee5fW0YA4tPKyOYj2SKLqNVcTy5/IZCrSvnGOVWRPA1Xi7G?=
 =?us-ascii?Q?A3g4rMiT5vh/2Ia7nxdDxkr5gGfbJHLZ7li1E4K1xnq4CRQXBACKlU0uIGQX?=
 =?us-ascii?Q?tP2IU8Q9HphARdKEqEavG2rZ8L+Yg2VBizlMR4uDf7X/lJpaBX1hxVQ1Glg6?=
 =?us-ascii?Q?bEK/2ljNUHLz9OmkWil3oE76T4yYaqnkrbzsjpW645d2uLxW0uXXiHC8W/y7?=
 =?us-ascii?Q?K3rKnAxnWexphT0UWY6ojnnwzhxWWZrNFwebQd4YDv0aTVQf0Gvyl5qVTkIz?=
 =?us-ascii?Q?LrCUh2TIx9D4CbOoqTf5dj/UrIIWO5sRwGV68RVGiBPiMf1+8C5/58lr2aYU?=
 =?us-ascii?Q?NH1S0cHUxQR3PJ8+mXD+77rA2qt5Qi5Z4ugHrbzNo81Gsnb60SxBEToh2Eds?=
 =?us-ascii?Q?vOAmR+ZGM4Ly/CTK5m9g+v4p4rnfakEVIGlsAN4ECkfKGqhbWRsAEYhZSLDT?=
 =?us-ascii?Q?es3T26xiQbLnfHhlnbLp6DjUlB11w4vl4oRkqUxkhnskToIWZWDILRD302ts?=
 =?us-ascii?Q?ZAG1owYM9WkGV4GMouF1fIYHlxvBYQWru7o6zuqZ0iyjYje8SSzxFclzQdCt?=
 =?us-ascii?Q?Go9s1htvw0/ZqbtgitQU6uw1/welpIZKH5QYvcFaannazv7Ztr0ZQTQl/EuX?=
 =?us-ascii?Q?oGLCISe2XGwhMk7cUEumd1pT2kQZhy3tp8EIa31NgjOmMA4tqVNlep7eH5Gk?=
 =?us-ascii?Q?Iz2KDYgagUQcbvW0AMK/SVUNp5rCdRCXZzivsjDPsXfKxEN24q/Pnx6KqRL5?=
 =?us-ascii?Q?Saz/m17n058BMuxIUrCJ1pM2yUgWN5JR/iu+Kh9dMkgp/MW1+LmngUxaiQpH?=
 =?us-ascii?Q?bpvt2hbv6a3b4h1AcSXy9M0vwNhftU+xWAY0wmYsZ4WfazwTv4tC2CH3gEEx?=
 =?us-ascii?Q?qTkv1r7KR3ivhB3faTLQoFjq/XlIscqy2+RSD7b8R/X1KYg+d2+U7ts8h09q?=
 =?us-ascii?Q?EFyhmBpw8ZLZmDcQE8aDVRi3NQHurFRCIjyO7reM0FMbusg07lOiBjsXOHbn?=
 =?us-ascii?Q?L5bZ9fot/WqIZXdfhztetkMw85zLKteFv6FOoHkLf+HzPV9wbogG1NHArKkc?=
 =?us-ascii?Q?8X3HDDk6CJ8m/xM0m3b/IDTnNeIjfWHNNz02N022YuVhuTrKJl3hyCIlda1J?=
 =?us-ascii?Q?ahVbxJEgMAPmiIBJBWnd/4ceduWMvwOorwc2GcQYbh6NRG1cd3vAOPR5qybd?=
 =?us-ascii?Q?2yBEfz9TZ3bwuNO9fPGei8ZggvIzOGbcBW803ErDzpGiDSdzPtopNuO/RuA7?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RsCJROgn47m/yPNuVWEhzoyVsApJXpOehdbNeLmZv2/bY/0pUVn9+6TvzFsU9dsfpUfDgfFmj1MdPU5Wdq/gw0Qw3YngQ3Lh7uQpxsHiKW9cdNoc43VD/jG41G8fRrm4kuzeAKkFtxDl+sWK0fl1ZAOKdSDYpXgpTVcFcE5UhRR0Gxi4vDVIdxQRrZ4bJnJBCYMwdpMmERu7z9JzyPZqAdevTGK/NLy7kYWwFCxOEevM8Sxk9OYmI4QP+Ey5GQ63konRZQJjIqux79ZlLG1jMngKjRvjX+4ZU7m+Xp0d3n22qWJM6ZtXhe9KWbwfIdSKJAGOmJQj07PM95ZSQ22dHTfuiDBelvEmsQFn4wfACGKFxAd7Tl2UMKAyaXnxMQQcd6cf1XC0yxjBOYRqCt7I681sunfOrQO22341m/BktWnPfTUW5qOlKc4LYqnqghsw4bld0JtgmmJz+D5RE0s4XEgSTfhKVVzg12/QgoliH+2dIBOKbyHyAOK157Nq6stTtYvoQUc/GEWkVVoMQucFy6Unp5zdgHaAMtHB5KaFpt80aW2e7goakpYqexqkbAFOeQ8YRna7xzUWM5xIAmMazcQ4jOfbZHS0CahpT2zVlW8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 372da725-2624-4691-ab9b-08dcddb93f10
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 23:24:47.7626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xRN8YABe0og16tJdynWSvraOK6fIBr1fls8hZbu8E4FZm9xcBLGKf1bB785e7sTQKtnZJJTBfup9quDW0L+tbaMPxU1eDsvcLIBWH2LmHQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4509
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-25_14,2024-09-25_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409250164
X-Proofpoint-ORIG-GUID: 17dCEj0FU7L9JPhqvlbhPomThs5cYmL0
X-Proofpoint-GUID: 17dCEj0FU7L9JPhqvlbhPomThs5cYmL0

Needed for cpuidle-haltpoll.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/arm64/kernel/idle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/idle.c b/arch/arm64/kernel/idle.c
index 05cfb347ec26..b85ba0df9b02 100644
--- a/arch/arm64/kernel/idle.c
+++ b/arch/arm64/kernel/idle.c
@@ -43,3 +43,4 @@ void __cpuidle arch_cpu_idle(void)
 	 */
 	cpu_do_idle();
 }
+EXPORT_SYMBOL_GPL(arch_cpu_idle);
-- 
2.43.5


