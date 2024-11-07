Return-Path: <kvm+bounces-31090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 759569C0224
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 11:22:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98CDD1C21EA6
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD031EC015;
	Thu,  7 Nov 2024 10:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oeJVMPah";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L4+D3NIh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6394B1DFE30
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 10:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730974911; cv=fail; b=GlPRf8vmEbjVdjWWAQauhkcby9bWjrhmHG0X4RozlfReYbdSiT+3mdUjrsMcQ+XI5OPMfMjDwdbsmwaqGQLWJb3zTgttWGYI89h7tXUDiF+vlIlmN0W0yp5n3B+WRUbsskLg3tfMMsytsm3GwReBG5jZ6DjU1f7HGGFD5qTnlP8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730974911; c=relaxed/simple;
	bh=S3nzrlgSfcwMO9SkHf3vXi0/tz+lbhd3WrXah5mQEXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JC8Uze9hDU+tHR9PD4pqs8WuUoRgbEE/Kt4M1lXOx21QAApR+QtImHTJEr2ABNKxDpMG9b0IhoHTaEFL5K3mHYBoa7/v+mXYlEmnM39M1halTZhjP+T3gnzBE51ZG6HX8ISGho/Os0MXtHCh58AfF1DaQMFODFLZ0+Q03LfTxIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oeJVMPah; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L4+D3NIh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A71feAB029833;
	Thu, 7 Nov 2024 10:21:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=yctP/0Msvjx7Iz47FfA6haubLmelPA6MXTQieDQt7RY=; b=
	oeJVMPahLZvBVyGdFV11aCgZbFpjOxqgszGxtovb3Z5SD1GVab713zbl5Cm6eLKj
	wdt5JjORVy2ghIUKjZsjd4YRyWivGGFz9+oLBxEMekguGlYzbbtClq5YiZ15MiaS
	hWktBsuFKQiFfq8/+Y94m+OYGeGZyYLGwyRSXemwfuE1KdArVmxXOUO0tuD2r4AH
	KxSDmQSOL4LTxybBvaahkMTXB4tvKpTVoZO/reGYdK9A3+0uCFhowksf7SG6AyIa
	nUmQiqjhNpXZwLNnlXnLsUuuR3aFuGYn1poqhnHEIbRH3buzrnhwZLAhLPGYfG4d
	qMLn9XzSXe0T1jrGGywrKg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42qh03d7c1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 10:21:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A79FBjH031520;
	Thu, 7 Nov 2024 10:21:31 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2041.outbound.protection.outlook.com [104.47.58.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42nah9hq8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 10:21:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OAmyrIkXJU1SvnK3H12UCd4hqsiNif7ZfPKW/Cyjn1WtgIWoxKNmby42zhwpGFpIh1FYTke9o/GvcP6qfEjHG/GqQWHRkh8PQivuG47LkijeYxKiIJhwxEve73XCDTBnY0+PtoSWn3RyAIeihSAujgDu9QtfoQx6vgrIenG3ajCx5wbEHVw2O0RbEGLAYrG3OCT6QEwmAqvBKE65BWyhHtbIFuqJrp1/r0EshpH/DokgNlqTHQDplnVXZQCnswkfGbrO+1uq7/BsKPwFWtIS7pocv5M2d7YaGlkfUM2KuOP7Y4c2DNmIDSvi4T6k1FqhA0u7zArPYWpx0vA7RVBNaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yctP/0Msvjx7Iz47FfA6haubLmelPA6MXTQieDQt7RY=;
 b=XHnK4XgKdM/ZfpL8y8pW0GcuhQatuQuCdyvDBQusWkAidgkrFY/BqbIXxVMbrVC9H/CipsiaQqK2OCh50bssjguIphHdf1NodxOJqGkDVooI9f5JsKAmO4c7zJNETJF61TU0yqmbej4DY8nXC5di/WonZslaIhZuniwc5zhMoHeLH7Ot70TJRNviXZFDDmLoMjnksnS8KKIphcEDakv1uqgX+t/kqbsQONYq7wFEsLzcIaAioFM5waYYE8EkfOtfShaos5txmbhoUMOmQmUTEnNTBOnNkrj98lxz+a8BrDptUsD+OKOn5U5ziH+QDGNmFCalR/IzdAmOwO3bWNX5GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yctP/0Msvjx7Iz47FfA6haubLmelPA6MXTQieDQt7RY=;
 b=L4+D3NIhsufOW0Pf4EwFbYeuw6luUEVucevVZpPfn3JzfWoWjQlDiKx+ErDP9FIU/S3b7QKw8JluIyCckpkP4shPuAx3QGr3r7WMjcN36q/k+h16Cr7oseJp7z3youX1MYsrXsKCpUpCtBoGE/9c4KeBFchAFWwWvA82EPlcNKQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM6PR10MB4187.namprd10.prod.outlook.com (2603:10b6:5:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 10:21:28 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%3]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 10:21:28 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v2 0/7] hugetlbfs memory HW error fixes
Date: Thu,  7 Nov 2024 10:21:19 +0000
Message-ID: <20241107102126.2183152-1-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
References: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0035.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::48) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM6PR10MB4187:EE_
X-MS-Office365-Filtering-Correlation-Id: 36c89716-7800-4216-5827-08dcff15f12a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yKYsVNwkDCYNT5zc91UdZG27BEndbtesHta8FyEbWttyKxQycssYXnLbQffp?=
 =?us-ascii?Q?SZMa43b3Eb4D1xl0YrlTpIpkJ6JOeKRtNQwairdld3DbOZzOrYtQUtw3hJkY?=
 =?us-ascii?Q?Tpjzug7swnBBJMwfK4WU8/iZ81j2YDlrp3OqSl+6czEM+9V/FiFwlRZUVRJP?=
 =?us-ascii?Q?BLRWClXGS6fqkeHaOdAb6lCtuFbQRLvp8bfPJq+S48KW/+7WGb+VJbKfPyLg?=
 =?us-ascii?Q?Q9K/6TDQa/z5rxGqpa33A+US1yCKsdOo6UFZWWM1GiMtPVD50jdgnS1O96Tb?=
 =?us-ascii?Q?uppa4dJDJHQ16fHz2oFXFT1ZBAzf4rg8t5vrqPnnT4ZH9SpWiQtRuE2doEkH?=
 =?us-ascii?Q?4fo6qRpfPJMsEpqDAWCor2G6aLBOxteNhGh5GWwa6q/hgodX7+M2SZe1X3jT?=
 =?us-ascii?Q?PrktIya8hx27isAYfEjz3Qh1t5sJjGUEwLQIIREMVNiZY/GiTrExTsXrOR9d?=
 =?us-ascii?Q?TS3NOXyfuvxR6nPcWL4FJhJedQSizrbIhQFCilXoyoa2xB4RSDzIou5IHoEG?=
 =?us-ascii?Q?HXOqEC+QwNMTY79ecO4Dm4wciLohxJyndgxwjzF7Zx7cWsE9jpXZT4wti6ot?=
 =?us-ascii?Q?kR8ZadZad7CWPsGoBH6Hekm+wK+XciCmtu2eZpLT+ELjvxQZcG6Pc7gDgybS?=
 =?us-ascii?Q?p7lvyCuB+CvV4HW5PySGycJtM3ay4PsA8+cQZ5XQSxBr1iYZ9ihlildhC7sd?=
 =?us-ascii?Q?I2o5EQh21VVwWE0/X4RAK7sABNT+OTN+IJjCpp7PWGcS4BpEFYirmlwUh/zB?=
 =?us-ascii?Q?OnVPqjc7dkMzahxRbzk6t117jVJLjYjaNEZVDLNmzeDMplMKLd5WsOkhxQ6T?=
 =?us-ascii?Q?gas3x+DV1OtOkgK20KjXAkM8JyvYDCmGtdvC0QmdvRFTENZamscve9IBhMb3?=
 =?us-ascii?Q?zUcAyTPHL3Ea+KK5gad2WcC368Ki9cwdUOqm5luZeri8OoYqLtzRcNeYX+gl?=
 =?us-ascii?Q?s/JeDUD3Spi/Oks8qcQR69SYumHJTjD7R9mOSeFAWY1U+VKPsxh+pLwdBoAB?=
 =?us-ascii?Q?8cWkNcq/eTfW+kKh59mopzTMRVQ8ZkaEZAn7kQwVJiDynd0W6fMdxwe1+Ge9?=
 =?us-ascii?Q?NvB3rXHV9hu7cPa1sTD5o3zV8BYlBapi3VN5SjyF3RN8626ARBk6+LUNrcsb?=
 =?us-ascii?Q?T4o/vvy3mVfBQxWArEeyHIQjfvSXaJM/GZCEceg0U3TmQKGhMx0vIH5PF+C/?=
 =?us-ascii?Q?FVmAKUMJ3V5omEyAEsGpccWnuDQReuGjowIG8O76ouAEEDiV6xO329Nl3wOA?=
 =?us-ascii?Q?j0JFQCGKDd4Xf1wcqYYPG0RGL4XGDfFNNnmT5xRttCT8qjBb5JruDZcJ0rUL?=
 =?us-ascii?Q?ZYz89m+FLDtL3IgwK1OArkFk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xbHPfJBEB7QCeU0GmzRRcR99GF8SLxcy8GbFIpc/PvD3XM9uCHUvRQUZyeJD?=
 =?us-ascii?Q?5n6/VZPypNfssoev+mQRDGcq43bazABFlaXVjWR0L4vGlm+wOo7p4TdO8Dv9?=
 =?us-ascii?Q?PVozhwtdGBXdUapJtEYU9OCfGX1OFlKw8I57JHwNAcgjFK8mNngurvFgxusC?=
 =?us-ascii?Q?Yux5MX4ldObdBPzzT6VOzg/tIuNXPdlZuEd+v+NphNrTsqA/hkgxjAWi3oDF?=
 =?us-ascii?Q?ZiFXE/lB6rRMiGAqjz1NITRR+EjP8nlEU/jAsS68IrV7Msl/dmelXstZFER9?=
 =?us-ascii?Q?LcXjcyJxTbzXmPtA/apQ3ZY9cpymP3etI+y2H01Y9QrQBR8wUVHHLRTQMjRf?=
 =?us-ascii?Q?I3j4gH5khJNCnvAokdgaS/+be0QS9gVEsDyFw5oycMdTCuAYrU0K1ngZBv1F?=
 =?us-ascii?Q?/X5f0pu71I4vfPf+GsRG/f8/bcNcfoT5nXT++40bh/Rxp7nbYsWnu/zqLYEu?=
 =?us-ascii?Q?uhy1moc3GpjvOhppEv9BKZ56Kg2gMO/hh5K4DIErKHhcvs+zsmOYFnrSRh/J?=
 =?us-ascii?Q?ruyYO2QKYDK/VEihThYj4f7K3zok7NEBVn25iiJTIQysrsMXJ4NrDmua7N/q?=
 =?us-ascii?Q?gAV3M2h6Eo872Efs7FWn52D1g9A/OKNPQK1YbJrkQe0bzxCRNLccOXZCTGeD?=
 =?us-ascii?Q?qR6RBRetzch2I/js2/I/c+VNuBEJulKluVD/VA5xDVJwnXYSGchoTNib6dQ5?=
 =?us-ascii?Q?jkd01ht1F2WXHwsW0lMAfWfTdaUUbYLdhoO/h7HarELpYffJb7Lpk7wyw3zQ?=
 =?us-ascii?Q?AoQy/V4r+LqkcvomvPFUmXwX5GcSkQV0jHUM5J7ReccVAPFoxswp7ZQSp88c?=
 =?us-ascii?Q?xUd/vB1BbhoHsf1KdjCwd//vm0YU3UeuDyvMZxCS1qc9nIv/b0ehoykFRO1c?=
 =?us-ascii?Q?PeRz31yxY7KwrnaJKalHftQdR6znV1EpudSHNuyuznnNoOqkbFCa5WU1YC4u?=
 =?us-ascii?Q?LPdMUFKOZofQwZFviwDCdxV1PNaaWrlvoLpBTuxIhLjfjxY8Rc2ovar9hd6I?=
 =?us-ascii?Q?RauuAhogOYZwP+jquYXImSJr+96nEDKRk74lX5h4gfPzu3sFfYc6kQZir/Pf?=
 =?us-ascii?Q?aDP1OyVVYsYOE+4b3hJCXnGC1vdbMSH8bQKt9m9B3STYFRW6jcVyI+CQ0Urq?=
 =?us-ascii?Q?jsEgeTxZACLIHNOzjXP7J0149fvGbCHB7wjg6OUn2LGrzq9r5XaObqKLk1JY?=
 =?us-ascii?Q?Fid0PZ/6jwEeCMvLAzJdctnBw3Dp0vqBorHTufMyK211ltVXTLaNtlzy8o8f?=
 =?us-ascii?Q?0Il584EmsDSZF4SlPkvRNPXnIcRrinDOFhV3RsCpNRASoa3Nt5ydY5u6C4By?=
 =?us-ascii?Q?4sHhusVW6K08Z7DJO/Wmq3Ns/i807AKKp3hVRQCAxMZZDpxrxTHg1MsiFEXa?=
 =?us-ascii?Q?X8XwNqIRtFmXkBI6SdBb3p6ekampLuhjjrMXwIQvvsONENWqfs9WSpK41EGS?=
 =?us-ascii?Q?W/iZ+QvFselnAtGJsrbEA3ucsIUqOV61RX6a4wNI7XJQzBnxRQuH+OdFZuG3?=
 =?us-ascii?Q?o0Wbl/0WFPm0sLa3zSnrwAo/EdcaKu4xqokpgwYSVU0tP7MdOdLP3K8I6awc?=
 =?us-ascii?Q?RR3aCHzcAEqvASfAI5IKPPWTbmG85xVB4OoR2SaBhT6rSiZZa6c0MZ/kvitf?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UKJhgQtDgVpyLbwQmSleFiK0wXkZH3xkj8YoKSyO+DpCsDwDjEN3Au3+pPrl8V6y63rEgOqyuVn30z/WDFIZJFBE2A4+diR3G4Tpl4QvuPjlWqnM33sF7t0n2ca1IJ+nSS7vm2T21JPshWExXLT5XrAQo6Nj1CAswhkQcB7kJqeWzao7U/wyic8V4wbOnNnpAIMH/ft1fLgZXJa8B7LdPuTfSXhBaygP6A/d1TtRW0OC6T35hMDHG8mDrz4vlEn58vfFvrtGIX08LZSIe28DkLcAkf2BkUY0iH8sAe3qIuYQcOcV5q7bmORGqOJneVH186EVXxuxoH7zib3wG19R4CFftPnpppXkWNawAeb7goeoP0/F5C8W1KT91jff+xhsoyjLJdp7DmgJtINXzoaPoahj9qfpWHGAfCUXf2QL4fjQJVxs7m7OfnC/2iErTQxfKRAgWLqIFti1Jg0/phSiYrvsR0l2AYfpRCRgNdK9ogPNp7mRb2jf/GLORVi1/kzX3kqkiVTaoEdauA60+Qc9VYZ/yS1ObaVm/SvEn016Cj1is3afkaKXpot0iMykv0ZvWJrCQNVzyy96XLlb2+kCoPNvdxWV8BaMMvX0q2rRyR8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36c89716-7800-4216-5827-08dcff15f12a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 10:21:28.7325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XiyMbTUqi1jnNySEcU+P36RWSoAF6OVSSHJ6MuaDw/VuUbCRc4/XmtocHZ4wkEs89zxuv/bnsTUByGdjkHVcc1qnLwkraKzLnH4A0iIjlLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-07_01,2024-11-06_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411070079
X-Proofpoint-GUID: gan0oNlY9i0F7mh2rvNSWN2XwSCEpGwp
X-Proofpoint-ORIG-GUID: gan0oNlY9i0F7mh2rvNSWN2XwSCEpGwp

From: William Roche <william.roche@oracle.com>

Hi David,

Here is an updated description of the patch set:
 ---
This set of patches fixes several problems with hardware memory errors
impacting hugetlbfs memory backed VMs. When using hugetlbfs large
pages, any large page location being impacted by an HW memory error
results in poisoning the entire page, suddenly making a large chunk of
the VM memory unusable.

The main problem that currently exists in Qemu is the lack of backend
file repair before resetting the VM memory, resulting in the impacted
memory to be silently unusable even after a VM reboot.

In order to fix this issue, we track the page size of the impacted
memory block with the associated poisoned page location.

Using the size information we also call ram_block_discard_range() to
regenerate the memory on VM reset when running qemu_ram_remap(). So
that a poisoned memory backed by a hugetlbfs file is regenerated with
a hole punched in this file. A new page is loaded when the location
is first touched.

In case of a discard failure we fall back to unmap/remap the memory
location and reset the memory settings.

We also have to honor the 'prealloc' attribute even after a successful
discard, so we reapply the memory settings in this case too.

This memory setting is performed by a new remap notification mechanism
calling host_memory_backend_ram_remapped() function when a region of
a memory block is remapped.

Issue also a message providing the impact information of a large page
memory loss. Only reported once when the page is poisoned.
 ---


v1 -> v2:
. I removed the kernel SIGBUS siginfo provided lsb size information
  tracking. Only relying on the RAMBlock page_size instead.

. I adapted the 3 patches you indicated me to implement the
  notification mechanism on remap.  Thank you for this code!
  I left them as Authored by you.
  But I haven't tested if the policy setting works as expected on VM
  reset, only that the replacement of physical memory works.

. I also removed the old memory setting that was kept in qemu_ram_remap()
  but this small last fix could probably be merged with your last commit.


I also got yesterday the recording of the mm-linux session about the
kernel modification on largepage poisoning, and discussed this topic
with a colleague of mine who attended the meeting.

About the use of -mem-path question you asked me, we communicated the
information about the deprecated aspect of this option and advise all
users to use the following options instead.
-object memory-backend-file,id=pc.ram,mem-path=/dev/hugepages,prealloc,size=XXX -machine memory-backend=pc.ram 

We could now add the request to use a share=on attribute too, to avoid
the additional message about dangerous discard situations.


This code is scripts/checkpatch.pl clean
'make check' runs fine on both x86 and Arm.


David Hildenbrand (3):
  numa: Introduce and use ram_block_notify_remap()
  hostmem: Factor out applying settings
  hostmem: Handle remapping of RAM

William Roche (4):
  accel/kvm: Keep track of the HWPoisonPage page_size
  system/physmem: poisoned memory discard on reboot
  accel/kvm: Report the loss of a large memory page
  system/physmem: Memory settings applied on remap notification

 accel/kvm/kvm-all.c       |  17 +++-
 backends/hostmem.c        | 184 +++++++++++++++++++++++---------------
 hw/core/numa.c            |  11 +++
 include/exec/cpu-common.h |   1 +
 include/exec/ramlist.h    |   3 +
 include/sysemu/hostmem.h  |   1 +
 include/sysemu/kvm_int.h  |   4 +-
 system/physmem.c          |  62 ++++++++-----
 target/arm/kvm.c          |   2 +-
 target/i386/kvm/kvm.c     |   2 +-
 10 files changed, 189 insertions(+), 98 deletions(-)

-- 
2.43.5


