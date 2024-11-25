Return-Path: <kvm+bounces-32453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 219CA9D87EE
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 15:28:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A92411643A5
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B171B0F2D;
	Mon, 25 Nov 2024 14:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B/KPsn+z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pdU0ExrM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C391AF0C0
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 14:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732544874; cv=fail; b=YMBP9a8lRPUQDsVTxy/iI41D+YQAso8cnDKxduEdyDst2kzP3D/A17a5TGV07TiUARp0avZwDHgQ5ZgTUfiWbX+eavYWyebfs6E8MYDD0ea38d5za/CX9K9WLEHBx3gR7cG3v6h5mX43w+H4PbeBzGk5vwzcxsghIadFb/TeuBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732544874; c=relaxed/simple;
	bh=I0VU1QyW0GQwuI3lsH25K3Cwdp9OTreY8CU5512oBx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YQfCTUawS1aQdrwSwCpAWmix7By74BkMwN4zhjX2QmPpEY8Ei7yoibg86CcA3H4px7AE6Nsth0uv1aGW2QU7PUw9DFgIQEaG3Fc9PGrQm4BrWGt7xWkowkM25falfsMJlKsJJSaYq7kE6pTOGrR5zRFfCRmzlMKPu+c4kVlEmEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B/KPsn+z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pdU0ExrM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP6fdj5013071;
	Mon, 25 Nov 2024 14:27:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=0dYtQssQodKteOemuW+BXocH/li0Yw0mJiC2BY/oj6c=; b=
	B/KPsn+zzLgJ5iNdEPykSXXnq4HEzEQskYe5JzfKycuRutEIDJUW/ZB91L8QyWh5
	9CDIAgRDwjg/+K7S9jhh5wJNsSNC+gpyrz8LJzcHzPmC74clCXucs3QHZ/yeuNOe
	GZNtx3cpO0rVsJxQqbFeu4XPLptUpL0MU1qX+8ltfYdYyj2gaeLjswbiNg/YyLzK
	y8SKsvNcSJpGeNSxjP0kkXBekmLGWS078Y1t0oWx8LVpDlouW6l73vrqiCve2mWl
	mkhg6C7zhUml3pSeHXlugu1dUSmK7+uVb7xHEDybPYifp8vOi9/wnq4ElWFTNuKD
	jrTwvFqIgdyPi6mi7TIxBw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 433874b7eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4APCZj77027232;
	Mon, 25 Nov 2024 14:27:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4335gdy6ak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t13KrUF5FGIdckmUWWWSW48oMC6Ho/ftcSS9MYBp78+HbUwtKafms+gLhsyy0UCfYb6D6SCDgC5sst8wWYcBcj1S/AyZMC+3fNBPpIY9PzM3dg0GuV6qAUBY9aGa8F5lDZ2IAv0qZBcv2WdC56qNissP+fGR/8hJhU8YS9GqndgH7QzbnbY/ML/N5Zj98bxBLlBJM0JBTG6Zm3nzhFWz56Mekp2SjUTVWOwR4N9lLnoEH7xc0xhB2YqJhIzSZMOBGtZuEUUKq7e4FFfnE2q4AoRJhh4rOpU6hdkubM/6J9SUXWrjUcEjbb0hOyO3ZDlffCjdfg6hJs1ZaBSWASf9Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0dYtQssQodKteOemuW+BXocH/li0Yw0mJiC2BY/oj6c=;
 b=paTSnpw47VUeaDmseLoXKinApaF49ipt7CfKZS28wqmNsRKR9dFnQYqgx7sFM38xmQpNjFPCc3HAbFt6Djwt6gO0wNEP2IYc7pkKsk2TWFGLWZPULRaB2a7WQIBwvVMZLoSc12y89wByr+HQEvBTj+xj6dYRumZ4R3OLHhCKu2aLleOskpHwwucSlkEkCoYQyp74JhIpC/pgQS0DajQcjQlfaJrhcIy76lNIFPHq7ZaFXaJRcYbGJVvt/NeGPDTCZo68zCpaei8qK4zWJGurEAjuGrwfxteqNpfwWhIQjxhBoKN7CRD1XcEYqSl6fsTN3EpYXYOmoRXOJR8Z6VdqKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dYtQssQodKteOemuW+BXocH/li0Yw0mJiC2BY/oj6c=;
 b=pdU0ExrMANH3G93xF5lqufnmhDusYw4I42I/Z6gHeYawt+V+kY1Pev8vBvD8JbfQTf4CPbrBml9IzCJuAxF7HpJIVuK5xpcd+hywfDM3zfN4Sxacx2rTPW698FHQG1HdsWc4wmfQ1o7uCVL2nimWQ2UVsb4ViL/xBAoJS9FIDkw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB5995.namprd10.prod.outlook.com (2603:10b6:208:3ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Mon, 25 Nov
 2024 14:27:36 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 14:27:36 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v3 7/7] system/physmem: Memory settings applied on remap notification
Date: Mon, 25 Nov 2024 14:27:18 +0000
Message-ID: <20241125142718.3373203-8-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241125142718.3373203-1-william.roche@oracle.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241125142718.3373203-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0262.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::34) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: f5bb2cfd-446a-4bba-ac6c-08dd0d5d4ec7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eiJ6+xmvzQ0RakZ1FXhdFSQOhlHwNWtJsFlqMBSj/PUYPvl++M2TNvPxEgi4?=
 =?us-ascii?Q?fKwfUQlnRfT6s6KeLRb3jMjjG4fgoDARvezEW07SGPYNwM099kHnzbYXbQ5d?=
 =?us-ascii?Q?u8FbUD/Zb1UPJw4VYRiF3ImjLX9NL6pUhfDb9Yws76Lv/GfptyLZ/y4ucCye?=
 =?us-ascii?Q?MAab5+oS+UWmagQEBFhwHOYYAf7MTqlYN7TcFLqtScmsSTLxniRZkQczWCQ4?=
 =?us-ascii?Q?gUox/5SNwVc/L1Wn8ctV9GcH4d9rOPQJzChshhVl147Y02fAAH9Sz1DkWq0j?=
 =?us-ascii?Q?dmbDdIGzMBn2a0SrGT0Llh+7CPoYw1M6JKWGgvb7R7TXUKCFusbDlfmyK/jg?=
 =?us-ascii?Q?onIXq6qacuUB6nH2/7AVDmW6pa1uW9vf8dfHcW1u/XjsiN7CZVRpntCX+kI7?=
 =?us-ascii?Q?qfJisO7jKLrE3HDPV7QFFKtqFpn8KWr2es7xv41MFiUV60DtQvEBzOkzpqLB?=
 =?us-ascii?Q?UYOqD3xuKtcc3GqsHyboZe8oLJw8v0DrCHoexUTwPI8FWq6b+EatJ1/pBlmt?=
 =?us-ascii?Q?mSc/vwSLdz+Td/ym9Fg2/jFuMrC4XaqtSn9kwbEJ2xtrvq0znIl8MZYlAZtb?=
 =?us-ascii?Q?NcvSIZ3d1hIgWqbnD6ZWugZEPk1qGy2LQKpfTdmEHyvh2D3C9SpEtrH0Lk4J?=
 =?us-ascii?Q?HohERDq9pi3NCUw2RWJHnrMxI93X3FjTFJEmkIFSwXC0zsFn5nQYvn3gDBO3?=
 =?us-ascii?Q?tkF2sjNL7WYV2VepT8Uw9uczaXC1kModHDKJ0B4nDEion2FitjKYixdMSxO0?=
 =?us-ascii?Q?VM1ErtsoWwG8eUrhYLpL+cI6isXszXw8Wrxl3qwHRLf4bCm8gpjyUiAV+9xd?=
 =?us-ascii?Q?g9XLpFwFIXyItTAm1Xtd7dKo79usABJty08//ZfNMTy8tUX//MAAgKnO3V2z?=
 =?us-ascii?Q?RV0bn1dfO1EU52dASe3tvVUk3sbOanyALSJnU5PiczzAkPa5TA5cG+Q2X4xt?=
 =?us-ascii?Q?IbimPirS2Pbev4nJyaxz9g3A7HcId6JRgDeCWUxftCg0T3IGp4jMs+vjUqZX?=
 =?us-ascii?Q?aJ6ro9A6UhZC4+ggpZgv+bcWVT7344V9nBVeDS9Y5q0/Ex66N4KxdN5h8Z/i?=
 =?us-ascii?Q?B1VsQacPqz+0vKJOXBpgNwD2+cuG2EBFu/zW88qTCa687I2U4C4LLUGd9ScN?=
 =?us-ascii?Q?9Vs9bquQ1bsq4sm8/6BQesUon8k3KRn76VVB6ZTBhG3MKG1xeazfhIJuxE5y?=
 =?us-ascii?Q?ClWMzOmKPtOPdLPYXFE8GK0V/TNahmVfzRA2d+r1icc15rCdI5UP+TnEz/Zp?=
 =?us-ascii?Q?WTAd4A40e28hbuq52/oqHiRvwFremouwW2TCcBCXE9aSxym+kQjcLTzVN/6Y?=
 =?us-ascii?Q?w0ietZKxIlaHPGGqxa9dxbbhBnPUIjP2pegwUorPSe3GpA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oEXuv8I386NmFON1xwAJkDH9DhhaODqAjyifnr5cU80wbxVmy4NoHwkkH+9R?=
 =?us-ascii?Q?7mAahNzNiRE8ypi5DnoVz30wJY466BEh6cgYmwebozn5APYL+Qwvfv+g9vs2?=
 =?us-ascii?Q?EBxE7qFGedSIfvtil9MuO9/2yiERdQlt43bwfmyIJfZ+vxnG6q8h9sfObIPw?=
 =?us-ascii?Q?TQbG2Q3z2Z4K5glQ8wpFTaT6Jm+LtIlBVKYDFlPQdCR2yuPTUAInDWIczogV?=
 =?us-ascii?Q?LCNAWzmv5jDpBwtrEdEX4r1RgsNWPMSGHyjDzPDP/FtMaIH/DMb3JAWJQF0w?=
 =?us-ascii?Q?fCXZJYAg6k7EYtHO+fjC6h20NQPKXa7NXoimFQy2F4r1rX9xFfWp6qsL7Vip?=
 =?us-ascii?Q?MwwztR+uPAU+BD3tgQQbIsZn7OFf1e6wBKd4DtK4/a+oNp4FZIFBuuzOwyfc?=
 =?us-ascii?Q?XhC/Byy4MC5buaYvqZdgJTC0Ze41vs23t+YJhV0T8C8f5jp4U2FBnCH5dcsT?=
 =?us-ascii?Q?xWoh+P6W8tFtBAFJV5DZG2YgtVd5pjfemWx0MW1ka7FYw16rh8Dm8LEQ3eYU?=
 =?us-ascii?Q?Uoc+ql1SDlz5ao+Ss3WIg4tIwqnAvOKG6Q09X4HS74xQRCcCOlleFSIKUao1?=
 =?us-ascii?Q?qZY3jE6OnsyQF7BXDWDYFKUpU0Ek4rsfwNVJ8sRb+UBxTTsVPTvLSNACD1yT?=
 =?us-ascii?Q?tM3RzGFRhv23DaskL6BQ6XgbfwKYVjMi0d6d2Dk8cvbkTfSSjrY9mtvJdKYA?=
 =?us-ascii?Q?hDYbsOJ1hDlzw9DOgdvb6jP9qg+xVSlHaYWyE8llNBV/KR9gsURCFs+vMU2i?=
 =?us-ascii?Q?EsKzixBfGMpgzNaoUscSxC33qDPIeQVgUGmi9Y1Edi6pXZxNzPrlwW45djTd?=
 =?us-ascii?Q?fL4fGNzyjSWtXhM5XRMehn56C3eRqvvvSKYNSa9Se59Vlb9B4gK+Y9QK/0LK?=
 =?us-ascii?Q?2Wm/QoBRqoV3cK/Pd2t9W2uC2GtZF8CCzDRUpK2p78XdQoHiZ71Ay8Qok1t9?=
 =?us-ascii?Q?PVnx3/LS2T09iNdda81BDwA+uCYwktmBYqTxTSe5CEGJspWG18/xwiXZ5ufv?=
 =?us-ascii?Q?502Nsaj8eK0gu9/14dNnsyDByrAXUqe3dxxpjbDHEAHN2li8shla/LHLn4Jl?=
 =?us-ascii?Q?IhxfO2ra6n84yqJYJPpmYLIA2gTV3mdlOXlPF2EzUGLw1cPGIwFdH6hjGng4?=
 =?us-ascii?Q?OHeSjdaHN9vxwmBA4tBXRrooy/6RwD9kfuuDsWz4GIjyEhBCF46wbWehS4CR?=
 =?us-ascii?Q?SSPGM4bSKcIxhEwctQRmxyA5C3PQGJkOF0eQC53ljQFp91cE7wnE9ZPJ9Cfy?=
 =?us-ascii?Q?huvI802fLtooJdBHcD/FuKx9xk0EBftiPMXiq6oUitV19vtRMxVpgrBC8rYx?=
 =?us-ascii?Q?Bmsy2DUpCIYE/2mWf4fcXJmWg7x8rIa8IXNdrYuKWK0moAgUaLD0YS7tTMDU?=
 =?us-ascii?Q?bt2ZlUcVpQUpF2KYiq3do8WJ7v7r6uV4PXXmf0oq3poOLGeBGzbPXh6nycVl?=
 =?us-ascii?Q?SNdHSMmnw5fSZVShLWBM2YW6NncDKADZjCVTKoOfx6Q/oCgpgFAYtu8tDXnd?=
 =?us-ascii?Q?inMr/yV+kfH/4JfXmEFoR4VYB+R00IxTf2WZYFUN6sFY8M0CpSD9onQgVKvf?=
 =?us-ascii?Q?UrlnQ57PGQgkZQfSCOVwS3KOCeDmo7q3ZdgaqhkkH0iDjUsjR/S6ZKla2ks7?=
 =?us-ascii?Q?KQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RjuPKWyIkZ4QQE3VYy+Gb7Xfz/13ZvtVU8y7YTJkOH97YzxeHYWBNxAGnblA64RUJOBDxjsUb26yhRFZGLdn0OD0olbXqnaCFcEQkijlaGq/bjZ/lEyjgl3UhLL/rIzlsrPYoJRO6tQ+md5MkOgUEbklBq4Hu0/hhg5VZhqJl+DO/rVIrCqLN/AiQn2FR9o8lEgG+6QH/NgNVApGzHoovyHlN68fjA4DpOFtiUQ3IYJZM3j5/mjci+ULCnu/pGQYAHNv77EpeInr4vaR110cmqKzfYZ83FTgC+mZ5xlBop9rMpkasV+8CUq0B/dv6YEHwAVezvsYKjYHiwRS7tkZ0RqOLgj8VKjjJCBJgadQ3a1DZodfnvpJp0JUDEJW8/+v40IAEcccll4755320WBB1bYISLVC6TiQ4Rq75TdAMJj+IRxmGEvlq1YZdGKdPJPnxTlbFcSIHaj0ox3EfR9VIbabv1iUHZnEU49ct91sJU1bDKYnaBs7qCVp48wZXqG4U0ZT1WIqXtu3JCQNMraZbSRKRGYIERzG9TB/x+bJCTqHk96pSrQAQajnk9fUSgjXX8OyzH/A+MHiyh69PPfYl1tY8KFc91xwEafzCz1ICG8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5bb2cfd-446a-4bba-ac6c-08dd0d5d4ec7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 14:27:36.3800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qa+GV1QzbvFW4Jnf+t/bTDQRHCneEJ9kkb7VotURVeIBEElS/ZbcH3ZoOmVomtBnte/mm7CHcXDm2Z9oAbuEbosgM6TxM4kOuWrVPRJ8oc4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-25_09,2024-11-25_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411250122
X-Proofpoint-GUID: vJgPJ5LSp6LrEIuXe5_aWjpCtwwKb9sL
X-Proofpoint-ORIG-GUID: vJgPJ5LSp6LrEIuXe5_aWjpCtwwKb9sL

From: William Roche <william.roche@oracle.com>

Merging and dump settings are handled by the remap notification
in addition to memory policy and preallocation.
If preallocation is set on a memory block, qemu_prealloc_mem()
call is needed also after a ram_block_discard_range() use for
this block.

Signed-off-by: William Roche <william.roche@oracle.com>
---
 system/physmem.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/system/physmem.c b/system/physmem.c
index 6b948c0a88..f37c280db2 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2243,8 +2243,6 @@ void qemu_ram_remap(ram_addr_t addr)
                         exit(1);
                     }
                     qemu_ram_remap_mmap(block, vaddr, page_size, offset);
-                    memory_try_enable_merging(vaddr, page_size);
-                    qemu_ram_setup_dump(vaddr, page_size);
                 }
                 ram_block_notify_remap(block->host, offset, page_size);
             }
-- 
2.43.5


