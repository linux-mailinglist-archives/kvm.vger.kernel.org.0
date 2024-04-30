Return-Path: <kvm+bounces-16253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A77948B7FD7
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58DFF281D2E
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2876919DF73;
	Tue, 30 Apr 2024 18:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gzMEjh+E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i8MxIXOX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766531802DA;
	Tue, 30 Apr 2024 18:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714502310; cv=fail; b=CI9lAFRs70KF4jP0pOMmJl2SGiU6Jr0xJsu6vRyz0lMBdaTLV0P+pm4JsffP+9HGDS4n06UUC8+p5CLV1KC6KqhDX+2yZ2KFoVVDOaFR5IXGQXSc9SX0FxTqOVBoM+ldRobc1G4t149/0SsgWKm+heG7B1yoSTWx96bFEZ1wUBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714502310; c=relaxed/simple;
	bh=KFGeP/FpAML4FXKpLFKfHiDpT8NYqERwImO8J/BOynE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fyIVUPdJ7rtmpP+Q/FiBnWBZpXDelvudDVJILU01xwq/nN6sY9wGblaA9lvWkBG+zStL3JKpa2c4QVVHSqsG5hJEfET8ZEeTY486GIys/zyXWz4j1A1bR0COATZ4EiqpwDZYu48JWcaDFkFZfiB+/RjcrdlRIAgZpuNtdgD9qDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gzMEjh+E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i8MxIXOX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UHIkop026936;
	Tue, 30 Apr 2024 18:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=9JPGZCPhmr2BbOmo0OZVXiCt5Je9dfuGj8xVEW23KiM=;
 b=gzMEjh+EfflrEOFQSEKOK4YqOSvqvHrpo4ZGfANgue7sk1Vj95loqQsHGcpNyHnoM3ES
 q49CT2CuplF4a2yp/XeJzjFcxGLgfPnHmh+6+//Y/2dxV0dm6J0S188W1ocG/6xoV3Ek
 bIGu4UPhexMbcDqRXPuyAM0EQNSklFsSP22B73x2SvINBNZ0OhWsxU7fB+VFhftYdIZH
 MuK2IPkbVZ3UTZsqNH4OYB+LV5QXc9Xgyh3QsYo/HIeLHCKn3vDgPLHmfAM0NR23Ddak
 fVP8i9KY/eADaIwwoiBjDD9U2UcUx5maGlfBE7EiT9C0JKupkBsfT77GtPyU40WmRewl Gw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrr54duk0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:48 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43UH3kuF016678;
	Tue, 30 Apr 2024 18:37:48 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqteckhe-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ocmp7aWZmc8fMl+A8S6QSn4lIRSYYqM9r0zUbUs9V+72Lrmn3LPM2F/hL9D5BaSP67V3hX150okPMMAR/dO2Ll+WBuSfMvbVI8EzUnsnr5h+Sv/0kdyqALPzSIdZSO+HxIolylvATjfoYVkVKF+5agWo7s2bJBjaT9HPlDRPk7oK050agKjt7V13Rssumc5Kn26iBifRtwvWfn2a25rH90e9qnN1N68HImT+23Uy5br5d6WpkYj9TKuoKbTP+r5gBbCrzIZbqGMJNKhqTu8em675IctkvxJGekPBqEY6gnBDVM32xvyBlcKX39mzkJFc89gbQT+WBSGylLVOx+h3HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9JPGZCPhmr2BbOmo0OZVXiCt5Je9dfuGj8xVEW23KiM=;
 b=OXBOsLmhpkUcOdEijv3+YkmvByMGRkdXaqy1KpFCb5/TZi/i/q6OzQDwI6DfkGB8Hz7w2GmvCC1u8lXRBA3hSl629VTbTyVgi3RNWvxCeh/JUH8ay+gtsgvTsBzwGSFlAzJrUB6j+61IlchTuBaShYzeFOdXgfVdssgkQnmP+mKGzfbW8a0W0+RvvC0IcSr/g86s8bCiynW33eCxwP4UMu3lalan8AN3am0c2uv8EwMaLToeqz4rJe9tHwRvJsUOvnitFH2S6z/blch5kc42OPIbacoI+ni36LisbWv9Z+JAa1+PWQ3tJ0r4GSXk2+JETHVdlFT1Jr8t7dkugTp6VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9JPGZCPhmr2BbOmo0OZVXiCt5Je9dfuGj8xVEW23KiM=;
 b=i8MxIXOXSWYLZZYla8/yz5sM3ubj0/cvn+QvuXZLvfrOz8V3lmHkprFQvrXTbuKbOym5PzjDnlK2oOOFMKS4LXTTNFkLHb+u4bUk607tXXbyWaf1oyscJPYd5EWW+bQW7+QIns+5KcfuQQc3x3WZbR7uFSrubXrz86VuDnYzBmE=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SN7PR10MB6308.namprd10.prod.outlook.com (2603:10b6:806:270::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Tue, 30 Apr
 2024 18:37:45 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8%7]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 18:37:45 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH 5/9] governors/haltpoll: drop kvm_para_available() check
Date: Tue, 30 Apr 2024 11:37:26 -0700
Message-Id: <20240430183730.561960-6-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240430183730.561960-1-ankur.a.arora@oracle.com>
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0068.namprd04.prod.outlook.com
 (2603:10b6:303:6b::13) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SN7PR10MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: ac21ae12-2b91-40df-b073-08dc6944a084
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?TOdv0xjMDIvCIEsQNOhSV0RmMWfcggzRainQMT+M2yOXs+Dzhb1AzU+IAiCR?=
 =?us-ascii?Q?Ofde2W8PU6SmWmfw19UUZ5RHJsVWpChfwqJEgmoOhJcfKIwsv6uYVf9D14JM?=
 =?us-ascii?Q?2pUEaobV9JMQdZdbXriTqwiPk3ISbhDWyR/BYXlKUTMGsiZJCxVlQxDF2ddF?=
 =?us-ascii?Q?ZGcZiD1T6YDh1YKvV1pQRkLqOXBlKRnLwb0dV72cvHiardLx5bu1HnFWnhhp?=
 =?us-ascii?Q?9/wT11y1t6a8bKmCtnQI+JIrOOY6Lhr1dapwfQuWDUrovMXz8p53MSC/a7nG?=
 =?us-ascii?Q?vyuuBmq5iwKELgV7xUg82BTtbUzYXBZDeJn0/l+lzhL/y63s4ZSxqfQrvWDp?=
 =?us-ascii?Q?jWoAsNVNhKN3sLDRH5DOBCv2aMB+ivN+dFxzjVw1Q8bibaA904tleIApGXJO?=
 =?us-ascii?Q?B1dk9AXfmdiw8iZpmmQsRt7fuHd2fkOpGavJjnJfdf4mQz5PjKwM6GOvRlCO?=
 =?us-ascii?Q?xsGWM6IMFtd0nfZ3jA/SgC+cbyfA6LrPYEezAC64zpOAKBCPffGv/nNCzwcf?=
 =?us-ascii?Q?luX48v+EvRp2msqH3E9T9HGmp7ULqZ+MO49i0p2dLDNYVBfxGITw+u6cirXR?=
 =?us-ascii?Q?i2zazx68K2gzUCejCdUaVVnLZeVUqTblGBm5YHhWZk1PWw3fjlXKZhhTXdlg?=
 =?us-ascii?Q?5JF/JW5x+Z3Hd6JqugzgR+sWA30ssUUm+EyyCjf1vavJpU+mhx4nUcUYtpuW?=
 =?us-ascii?Q?2uq4Rd5i3a3bufxCmhvQDdtk6h2KJqWusQEWvwMxCydjsYdYOrh67HMYXTQB?=
 =?us-ascii?Q?Pv3OAYpe7GewdURV4U9893Qce3O2btkscca/6xlnkUmYsvGq4yy0Nk9pwHi3?=
 =?us-ascii?Q?2mNCH1w3g4ml+OpQ7hY5gJM8osMuskB2JHd4+9qMT3lwcaxKjgxwfQVQRMoA?=
 =?us-ascii?Q?38wYp/LvJsrzhd7Zzf4YINYpiiegb5kjqlrQwZNIwWFK/H5MTb3gpvdqcXLy?=
 =?us-ascii?Q?n1NWAvlKwHcJICtBcZtmvknNs+4q91aY8f3OY6+S8qus4/70wuDnD6CWFF2e?=
 =?us-ascii?Q?+b8/jD/7YT8LT6ErGSqDy+IBz6Rrdwu70tePz4QFaz5D2cJmLiGn5vDl0xEE?=
 =?us-ascii?Q?Kr/K8fiQHBij9E9s+lO1cWd/XiYe9pBJR47NMy2jfYljDb052ycQZDUpmOxM?=
 =?us-ascii?Q?ITcGoikAmH5MXve3WFIg5ej+4rikKoE0fi5U4q/3cqOULS3FNufCe2kQtNGH?=
 =?us-ascii?Q?TURe/HLbMYPB0ZoNkgHZ6rg2z2iO7INW6C006haZZ7bQx9NQD8MhFbkahwDv?=
 =?us-ascii?Q?mWdGCWTi2W00vHDFQIpok35wxTYs1z2Lz5rWwvYHGQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?851//vKLF4gWzMGPCShaLtbnQ1/sFgvxPf2vIiwTdrbGgkd5mEjaDfhN7HkI?=
 =?us-ascii?Q?+Y2uFw21XPPR8wK1d6lQoQvI1Yd3nQg9/lCAdJN1piRbN8o6whcug6kxTAGd?=
 =?us-ascii?Q?JwOQwmLoWHdHwNOJW3QKC6UrRFNYgl99x64hyIOkTNoBuh1P0KsU4A7usR5o?=
 =?us-ascii?Q?r1tFcP/svwKHxt5Rb3DhziEOxFXPnjJc2YioLsPyiT9Rxl6uNyB0DrAdIMp8?=
 =?us-ascii?Q?7pH6e5o8XH+ixxpVLMrxrbbs62Mjs5ahWtYLpV5VcczsRTopv8ShYQPSAmQU?=
 =?us-ascii?Q?x2rFdRpz5InzrXcNPNvSUS28+0sv5AFvWtkmhfcw3MgOkNVSQf943HQQdgXp?=
 =?us-ascii?Q?N2Azgc8xc6tFarxWLKI8S+hInonmM4taQxmVd05gziMopa4Eg8fp+PFPMyQ/?=
 =?us-ascii?Q?2rsci+kFjUIVkMn8/sWwCzTrMDhuM9yMj2+hl5drs1RbgaXN/zpb1AfWBy/m?=
 =?us-ascii?Q?huBJVmTMkkzjyB3AKYu3aiV746X3br8PaGM2HKbWx7XftszotHpWyfnVtfaS?=
 =?us-ascii?Q?goH/6LJJHYR1fsXRo87UYjt9eXx+vDDLFHF2LHZa3vs6RhKj6tmrtVUYf3SC?=
 =?us-ascii?Q?kVYvoG1u1/Fxb3DR96C0oXf4leLbZg4dBgAHHtaOlkmi0YZXxByazFxxiGV+?=
 =?us-ascii?Q?tXP3grFskOneP44Qmipr0dmUOs9liySYngcO7NFsSMzoxyXgdv9ffKKoOLIk?=
 =?us-ascii?Q?6F724WKAUbPbjcAx3KJlWyuITy1X657qewBM3Eps2LtuZekbVeMEgoMY9GDc?=
 =?us-ascii?Q?Bi+vgRk2B87/0CRtF255nVHu6tJWA5YoaTY1n9X4luTuDRpbsyY5hTqWeTwt?=
 =?us-ascii?Q?ezTrw5pZ6xcFEDZEUETxToAypi9SuN6cczerp554t8ZOMyf8V/MP/iAlzlKA?=
 =?us-ascii?Q?I28wntgpK73o6dAEIipN0dE3EI/UH7tFrAlv8ShoGSblCI8w8asuDDddTBfQ?=
 =?us-ascii?Q?jWWE/Fd+T2OQswooj97Q1bT1gA5bS+7S8kUgw7u0+XcjusLjN8jZz5zBQ6+4?=
 =?us-ascii?Q?65eZ9g3JhVggRZbUKNHzhhxpe5uu6xrJOhf5h2Sw4I1+GQ7omAcv44Z2Mnep?=
 =?us-ascii?Q?fGNOqemYTDjcaE3JSifhaUVKDfdCY5qK891b8+YgvydwnJhp+QobAcn3PhbC?=
 =?us-ascii?Q?QoTMmiXoyRd3b1492gWmULGkZUqKWir7FuAMQAx/LG0mPpIE5/V5fzXG1uIM?=
 =?us-ascii?Q?j79cwd//GMV+MeEl3KGvHG9KkCMshnJOZZKB6314lgK81u9az42iSI/jN/zd?=
 =?us-ascii?Q?Fa6qwK1mEcvRmwFQLPM+HTH5YywE/jogfwjMoKRhgr8KAnD5E2GXyvY9Q/9V?=
 =?us-ascii?Q?9ZRZ+toB6QPu2yfg9FYP42KhgVosloM3QI1UEmQVawgWmA4XvpJTc3l7X1Fm?=
 =?us-ascii?Q?/CdJZlKxj0YBs+qzD7UWDdGif7m6cOY7zrzhscqAeYVM+FaV/V+kGyDhZGKl?=
 =?us-ascii?Q?iZTNhAPLxwmarRhyjOKer+WiCdWX4PEOEGPF2nmy2GhGxJBL2R0Aa6nYU30k?=
 =?us-ascii?Q?iOMFPHEJFoBDizh8ta7yi2rM3ozzu9WxVg269oOqOyyBQ8TcWhaCue92WOkn?=
 =?us-ascii?Q?MrwaAr/+FNzWtuc5pdUKhkEVNBKqzL2VxgEbq4B+duY0Ch7LKe7+K120oMfT?=
 =?us-ascii?Q?pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7vNe+m5zxuJ/SCcoGoGRzp+3SK4tdD/VRCyJIiehMZQH1xPvSAqWGxze5qhNofTjJ59SoLTjDaeLAZjjnqgZ7llLRK/jqWvRG7fPBe6wBb7754UsSCTnQAIZJKXkXo/keuPwYjjWTu2p2XABTKLfK1pOUGzUKH7wkSttjaKh6F/WJthJObis1xYjoBWajTYo5cZzFe2xEDaaMtkutafdSMIn2WVVXar0lcmCkzywfrjDPj1kcw5jat9hYHebjEuPLPmh4mMxkRoKO6nxdNPBDOoxiTl83HamVpaHSadZeGcqWOVAdKply4Upn/lh5z31uLz1F51gLOGbKABu4i81OX5LyLDs6AMuvcF6X5C403JqIG0YU1knHPorU2d7thHRL4UPfcFIT5bgU5jd9ioO0Zn6UOaBp2umay0BDLPfGcSt1qub+zJ+wSLdFKyXaZ8htdRxPn2czrViKBsWouBq2Ji5W8CDCTq6SnF7qWBJaxjAUmeGxcYudRxjAI6pGjoP+BaHxrvDyU7pKrvzPycETNtYj8NOhudyb7OacSfXBAUQaPkZSNjtlEA6ptSSl3W24p7/qBu3IpueAea1Emb/r2Iez4/ued46IW+3pekafQU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac21ae12-2b91-40df-b073-08dc6944a084
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 18:37:45.2553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4HWGiMHREaVYUuqKkw9B7p2dEKR9xh7VM4zY6mjH6abdjLhgQ1JqnBMdFwUSvWrPY1XMfMA50jx3LFnJDK7OV37ggI6h+6qTnB/roTK8Rfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6308
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_11,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404300134
X-Proofpoint-ORIG-GUID: Hw59kAtNW6V46ZzTe_vDITnKR1P0Sm_K
X-Proofpoint-GUID: Hw59kAtNW6V46ZzTe_vDITnKR1P0Sm_K

From: Joao Martins <joao.m.martins@oracle.com>

The haltpoll governor is selected either by the cpuidle-haltpoll
driver, or explicitly by the user.
In particular, it is never selected by default since it has the lowest
rating of all governors (menu=20, teo=19, ladder=10/25, haltpoll=9).

So, we can safely forgo the kvm_para_available() check. This also
allows cpuidle-haltpoll to be tested on baremetal.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Acked-by: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 drivers/cpuidle/governors/haltpoll.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
index 663b7f164d20..c8752f793e61 100644
--- a/drivers/cpuidle/governors/haltpoll.c
+++ b/drivers/cpuidle/governors/haltpoll.c
@@ -18,7 +18,6 @@
 #include <linux/tick.h>
 #include <linux/sched.h>
 #include <linux/module.h>
-#include <linux/kvm_para.h>
 #include <trace/events/power.h>
 
 static unsigned int guest_halt_poll_ns __read_mostly = 200000;
@@ -148,10 +147,7 @@ static struct cpuidle_governor haltpoll_governor = {
 
 static int __init init_haltpoll(void)
 {
-	if (kvm_para_available())
-		return cpuidle_register_governor(&haltpoll_governor);
-
-	return 0;
+	return cpuidle_register_governor(&haltpoll_governor);
 }
 
 postcore_initcall(init_haltpoll);
-- 
2.39.3


