Return-Path: <kvm+bounces-33817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F52F9F1F1C
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 14:46:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1F561674AF
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 13:46:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42864193094;
	Sat, 14 Dec 2024 13:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YJuv0pyu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VraBMRZP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6692417E015
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 13:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734183986; cv=fail; b=rmQqojcmlWb79P7xvvFB6M1JlnXvG2GM4jYD72PoYlBJFtveqeBJ1tr6wYBcWlHOJVYzYksmcz4P/RnovBf4dLqmt6pN57+TYO2IGbsnpDR7bAFtn5m31bKPDEfnKnai9W6atU3QdG05vyutxEUFp4GqQmjosLzNIsZRcbsTYTo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734183986; c=relaxed/simple;
	bh=mvSsuHiQLGYMvvtlRwlcXkDyoDm93MiYPNhN2Hd8ZdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GLeMWoAMn9s6e5JP2vlr7i5BX+opnU5KSEOgtEB8iAJdn8OEee0yJi+O0aELH4bRh2VKi5mvf6jOd2RsSwr97ar9Sq6E1zg9RlEATU56R3mins74DfiQ2ZhfdAt8eqiqFGPyRXQHP2KJ82wNmOKx5vrmDgnNFEXQo80RwIK+LWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YJuv0pyu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VraBMRZP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BEAN5SF010737;
	Sat, 14 Dec 2024 13:46:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=LItWZ8PhaPmr7Pn+T0bqX9jszbEKabDoOzZo89xEkRs=; b=
	YJuv0pyuAnsD/lH6a1VuC5CG++Je9iC+hfL4ZJMJ7f8rX1dnRTh3vFsxUg8jTJW6
	slIhKiED4RLTpNLdBzRy6g5NQ+ccOxgnMi16iOFjV3CfG4kiHK5gTHolLKMrwE4y
	bACEGF15wv6ktG8qsL9+GSAq4Tm7RWFBIIk1wG9Fyu43UOFf+0S0cZq0FbWGsbIn
	zO28zaR322+ORFB+tMyydTlAcxnASO0kNCtwwfNqF0lOgW+n0HHiudDJbRknRSR4
	5PgYVnbMYduoxqBWDNuloZUPwc6HHNlyftu4Z4rYZXeuUq4OPh9BIu7UGoM2rHVF
	OhfpF6wrxgcW5sPTKHG5sA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0ec0gu4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 13:46:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BE8XbGM032621;
	Sat, 14 Dec 2024 13:45:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fbu0nt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 13:45:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mlf/sMIsnlPKvSWdxSr0Ailbr/s0dpHvuewwFRym9ooHm97r0OlIE2gPINAmogSX4gbuO3DPA5O2JOF9AQ6U+nEhNPh3h/9vvzPBJl/7jX0Uih1h7LoVbRDigaq2+ZzjunaYuO9PqoKr7BEWVxWuO2x61oI2R4TImuZXrijzaHfLlBVRUY2XAj98ian+e3GQp3pb/eXEm7+BcFFpMua1bVc9lSrp/ee1I8+li3r0mxT/TMvg5JLrUa+4BlC0z5ACuGxLhXjIRz5LE2HiVwxW3AzCuNe8Am9bXqL8uf1Gqo/QKxO8OyriGL9jzDKvh99S7I0MvrQyWILoniu2d1FtbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LItWZ8PhaPmr7Pn+T0bqX9jszbEKabDoOzZo89xEkRs=;
 b=VkOPGKfh8HJQGdGFlTcWGRxMQku1AsgjP8RGnXLgZRci9pyqxkSWosYASKfbWU28tU7mcvAxBndU14rFYs4cEzjcMtiADYXh0gh2U/42erQnKzlPDzzVH2Gs3ReHRdjdl3h0EYbrsRP+sj/Us+01YHe2utdt3A3iCHoS6NqYohu1iGfuGWt9ViCfRq5wWAuUlbGxeyWiDxOh8xpoRgHNSZp6Y8ZF3akf7HFCygOy9ugSy1Sb0hTNhGFUzaByi1QlupmYWuKlOtTHRUr5aNGmJH3/UGqwgbJPM8+Of9lklma+U6TkPE+nGx0mfxxdEDqM+hJnocFlCDnBBoX+JXdG6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LItWZ8PhaPmr7Pn+T0bqX9jszbEKabDoOzZo89xEkRs=;
 b=VraBMRZPmGHTtqmsXkicthtEA1mIEzC5xMmfz/VQnFgEtd6T0dX0D1c1/5uKg9UPr+dHX7u4ZgGHLfbXH5Y557NqBCGxQLRqFa9hs9F6fEa6awLDIEa/qtfK8AnccHjdh9MLZ4n+Trr8tg+uGPcqmu8jBx52Hlnpc5FWyA74lS0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SN4PR10MB5624.namprd10.prod.outlook.com (2603:10b6:806:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.19; Sat, 14 Dec
 2024 13:45:57 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8251.015; Sat, 14 Dec 2024
 13:45:57 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v4 0/7] Poisoned memory recovery on reboot
Date: Sat, 14 Dec 2024 13:45:48 +0000
Message-ID: <20241214134555.440097-1-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0049.prod.exchangelabs.com (2603:10b6:a03:94::26)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SN4PR10MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: e1303c40-2f75-4fd4-59ac-08dd1c45a326
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VNs2QA28VGdV4RdEdSZCzeYqI5GErk+63ijMjAfnuQjg45gsZZYxv+mmJiOO?=
 =?us-ascii?Q?Ioj8RF0Enk9TrSH5tbDSgTiEHd+L2Y4+zsE32rtM59/AR12Xivk8cr8NGYGG?=
 =?us-ascii?Q?F/F/u0jHkrSPJWT8Y6P6DQ3GBWM0z1W1DaPhqlnpQ68mw8lUaYdYXEz79ENO?=
 =?us-ascii?Q?rtI+0ZuXQQ3t63wvnVbLJMahSp6cLm06/aF4UtXgiKEc3USBkkfllV35YzFF?=
 =?us-ascii?Q?ru0bZyQs8Ky9C6HnC6qTrL7nnN17pFmoSjJA5JDtVd/L2HwKrpT9iYlT1oh/?=
 =?us-ascii?Q?/qjO0f4bT9prsXGmdU94xNqbuDtUim2NMPiZeojgxk+yzZQb9UL2h6ASeeb2?=
 =?us-ascii?Q?VJ3sNYv9P4tF8XYhdWBePGw4KcWli5wPERk9kyz60ouiI3HAjFVFZLOQZ8gI?=
 =?us-ascii?Q?iXNkPiYoOYF5tyiD94rtbZPH2jJzilV95WkQkbsBp+rUUiMZcbzlxM/rVpzK?=
 =?us-ascii?Q?Y11xAkiPiUwEbyYtQwSrGr1nRzdV1qcMNNf9KusEpbWFdg0SRnAHf1qNDaoe?=
 =?us-ascii?Q?J+ynfIY11krN9urfBzT0+cDY3CM2Vt87lvObX0FQf6pVbB/b1qirKbT71/F1?=
 =?us-ascii?Q?MUz/ouoinuJEYiSy3WGzmcjxLnR0AHY1/DerPTfjkTatrVxrbCwhB+LDmVYR?=
 =?us-ascii?Q?ymdjgLOHVaDWV24xojTijj8vMHkrvMkL8V+850qe8TUe8Ce0HCKaoU+cjpoL?=
 =?us-ascii?Q?5s78ZKB5W8nphw+hyAhBHRg3NcjVeooKpubm1i7Za2fTj7TlAvumP1+JQvB6?=
 =?us-ascii?Q?WmJB1en51R0toQdFqxFkUTxiJbsQAwycfXkcow3wRTk+VRCIDytUO2vSUZqz?=
 =?us-ascii?Q?ZcIr65DaKG2wcwetam5pVh+/65wcWz6nyZZ3nRrmFjiCcVVUB9+pdmMHYlfe?=
 =?us-ascii?Q?T8aLaHKf5gTD6GjIOjtgXQKRVilzchoKO08x8imvxNsHthg55iuPHRrj+yy8?=
 =?us-ascii?Q?LrNcB0zwDpw3ZFKOzo+WXoYN50hJkiuqlzJAAkcwcEdcx5NJUTLKWJQFpqiB?=
 =?us-ascii?Q?pmWaK00g/8oWm7/U6teHX0auSo9xXWa8eo6UjCBS5CaXynyLXWUwQmJVL2XN?=
 =?us-ascii?Q?wba0m9E9Bn1xL1FJ4aaMGfDdv5LLPshjPraAY3BY0Ge6cej7JMScTKOFy6DQ?=
 =?us-ascii?Q?FTFwcMlMWuHUOQiFlIm0IH5+3mzkS9OufE6vcRiVlirJD11/4AGJnEAO1+gT?=
 =?us-ascii?Q?d9yPnUY707BHe1YDRm5LgPCzoiAK394Ej+HZ7MyAzb7bCpeDYvlNkqWDw0Y1?=
 =?us-ascii?Q?pHD108uUeLUBPWvfim3gghKHfxIzSr53VqQDlsQA910c3SmuU0MDG6aZOxm9?=
 =?us-ascii?Q?oPewCT/nwawoNxdbpsgcsyoethOET0YczsRmtZXpK9+SUw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i1yIo3iSX/TXAmhV4jYKswoPxRubZBfNtNw/AbTsCI+WSzgv06ovsCKKd4QJ?=
 =?us-ascii?Q?2nhlWyq83d+THht/qeeNPfxboLJd9Lnd0J7v/51/IUyUL+noXbWHfXnMQW+S?=
 =?us-ascii?Q?RFPn2WYOLGHxScD3BoiU+DpUKi5vvee6SXaXh0P26t29GyDKxP9FnnGcndVp?=
 =?us-ascii?Q?vwkFGDvT+6AwSdjw1kz0KvjI4h+PF+QPLQU1t3sVp2ZCQvPV3xvwo9g1VJSV?=
 =?us-ascii?Q?PyqbIYBlnjoVQK6VH1/kxqv7Bb6iKEtsxGnnXqCX0lrJyIcspJVxE7GY3ZHt?=
 =?us-ascii?Q?3sNqGzwJc2pJ0WfK/knILeM8rVXkPao+fR6PbCvakL2zOw24nFQs+EbZ3Zmc?=
 =?us-ascii?Q?0gonh7d71VLjW4GgVfu6Bje5Mu4ZGPzvZKNoMS5gAYco80Z4TF5YdiSFiotn?=
 =?us-ascii?Q?MvrzhiVkcOUW0j0dZ8pb0i1rLgb3excZw2kGKL+V/z0RTXVsMp0Rumu9gMbX?=
 =?us-ascii?Q?Wa1eWrCbpUkH7mifmqcVknqkE85b40eGFDx60wjZo/MuJBFllEjiLAWSrewQ?=
 =?us-ascii?Q?eb54zkM+d4h3TtVL7XEV8B4gR++jSPbJkT3Iq4XdPTWxvPVKIwdLtI5FoAVL?=
 =?us-ascii?Q?KEN8ngt8BbjKH/QW3S1ts7da1BBF3owk3/Gx11y+Z8cdaV3Usjng1LGhfTbd?=
 =?us-ascii?Q?6J7Dwo2Cq7V40Lizs9hS5sbOyTMXFFzjDbXirQ61Ydu51rmDIdZHhIXl2jKq?=
 =?us-ascii?Q?nurFrWxgtBLRzdodJU2f/EcjxFnK3R/1YtOMSF4b+22xWB/q0YC3XPUpP5sr?=
 =?us-ascii?Q?ORqsnJzviSVr3t0tmb+KrfbzLh2NzfneqxrPyLtD9qOfJW63CHqwtf+yRHQp?=
 =?us-ascii?Q?xBBqFeEFTReN2SOxW6hx1zZcTlNP/c2xj6elGFSZ30cdenU2wUnn8gs5tIWB?=
 =?us-ascii?Q?5w8og0W4mt7TGBK4FFYRv29zSRxIFQQntrYoCc74XjpAUrM1I70VRIvFx3uw?=
 =?us-ascii?Q?u/GtqVDGWh+3oTwUXQ4Kgzoni4b0c4RXGbnFgbhJnK+YpabbujVmPHqgP+rx?=
 =?us-ascii?Q?QfMUcMxYM1yBDIxLHGe1AMyG/mBt6SyEY+HD9yJ+BaxcoTLHwWWStIzZRJCW?=
 =?us-ascii?Q?EDy0R0TuDt2NqHHPDbzRv/ZjyL0cKMA22RmFXonT1pgUUo4MXLlwmkRPsLfF?=
 =?us-ascii?Q?7e+cfszSumuFQWNxH2FsZtp2BQ4TBm780pakgKAZeN5ZftVp/O5FBkbGwWEY?=
 =?us-ascii?Q?tUx0JKzsGrZ2NQk4w7i+npZBm2XNgh/ef28leX+nOi5UKwgm4VKf634ckwsG?=
 =?us-ascii?Q?SWWvl0Jml2kBRiDFQCggBdokQ+e4A7Bow+cVpB2RB0xsVbGWsaKszibAMuSx?=
 =?us-ascii?Q?R1hWHUVzTSHfy2zj8Urv3nmoSu0w+se2RXq6E0R7hvU7zyT0M4oObQx9tfkc?=
 =?us-ascii?Q?q4Bvv1l4OcjtXWxAasFaPqZ+6fyzxSD/DUynNx5XD8we2fO4V3cn2zgS2sne?=
 =?us-ascii?Q?nO+U8psV5EVkqfkjFRuEgVGXvFNeLbomFUKQh5dauVqRPmILFDyReO1VLKmn?=
 =?us-ascii?Q?VFgMqMrTAhi2R1YKyujy9p31869hXbbwVw9jbPdzjIL7Ueh1XcSq7DUOfCJQ?=
 =?us-ascii?Q?ZJ2tT+bjT/NZFo2wI2ewN2vodFNnt2VZToM5NyqhW5CH53nHBZQ+9Fd6NpC8?=
 =?us-ascii?Q?7Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FYv9Gbjs5fOGzC3bWGoCUnYTJq0TXf0cIpbDrLO9iw32nRAsEBsOC4+TZI8O06c87Ns2C0hByhbtwwI+tF0/4Oe3s/RTVWT7H1TzNaZ6ZBHm1APfBGbr7I/nvKhDiLhOiH2PdPGYa0klSao7KdCXVr78wLlN5gdTnj+8zdNWJmL1n9RuJFU7TXjyESPiW9l4mF6OPWPYsVbD6TE6ORDM6yn/O4cObguN04LgBLEk1/QXMTNfuk4X2s6hshFkXWlVniOSiVQFZ4uLkg8hBCbQNTZ8/2/8EiIp+HLEB5TwQn1HRay/X8r4gpupzBpCukx/PQLtrRm/O2o7+xDd8PzvgoIq5uUjnvGdWryeGM7QwvQx0SNX8vZ2340up/YIJz/kUh5CU1qDjVlSGRaiRxCLlTZQh+3J1rLzAZs/YYhIxOYAb/ERPtJ+YZx8lp3Xqtvey29KAh31wTdJDdOvYKoXODvd+owRlSWCAspidcQwK7J7u0ISU1cDnMjONCB91MzgGpTjhbwg6v98ZRdCvQF7oOY5BsCzVO/O/B4Jb5Gl1hasJtRoIAkXIjQbEfYK8hq3ksCagl30uSRlmiwdzX6ke54G25vfLK4v3jKzBfpU8ZY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1303c40-2f75-4fd4-59ac-08dd1c45a326
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2024 13:45:57.3954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V6c2Ef7p/kvp79ux16fs8rrcz5DXIRdd+BBBssvH8MI3VgjJ4oF8Fet7t+5X2pGAxCeGE4SpqERNRdzS85tesjV+UQxSHfsF49G6FZfMPD4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-14_05,2024-12-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412140112
X-Proofpoint-GUID: xZFIhNOhDP9HyK3JinEdLUdYCu9j8L4p
X-Proofpoint-ORIG-GUID: xZFIhNOhDP9HyK3JinEdLUdYCu9j8L4p

From: William Roche <willia.roche@oracle.com>

Hello David,

Here is an new version of our code and an updated description of the
patch set:

 ---
This set of patches fixes several problems with hardware memory errors
impacting hugetlbfs memory backed VMs and the generic memory recovery
on VM reset.
When using hugetlbfs large pages, any large page location being impacted
by an HW memory error results in poisoning the entire page, suddenly
making a large chunk of the VM memory unusable.

The main problem that currently exists in Qemu is the lack of backend
file repair before resetting the VM memory, resulting in the impacted
memory to be silently unusable even after a VM reboot.

In order to fix this issue, we take into account the page size of the
impacted memory block when dealing with the associated poisoned page
location.

Using the page size information we also try to regenerate the memory
calling ram_block_discard_range() on VM reset when running
qemu_ram_remap(). So that a poisoned memory backed by a hugetlbfs
file is regenerated with a hole punched in this file. A new page is
loaded when the location is first touched.

In case of a discard failure we fall back to remapping the memory
location. We also have to reset the memory settings and honor the
'prealloc' attribute.

This memory setting is performed by a new remap notification mechanism
calling host_memory_backend_ram_remapped() function when a region of
a memory block is remapped.

We also enrich the messages used to report a memory error relayed to
the VM, providing an identification of memory page and its size in
case of a large page impacted.
 ----
 
 About patch 3/7, I still think that generating an additional message
 in the kvm_hwpoison_page_add() function creates a cleaner code without
 the need to repeat it for x86 and ARM. The message would be displayed
 before all the injection messages issued because of the large page
 failure. But we could go with this version if you prefer the existing
 message to be enriched.
 
 About patch 7/7, I could merge it with your patch 6/7 if you agree.
 
 
v3 -> v4:
. Fixed some commit messages typos
. Enhanced some code comments
. Changed the discard fall back conditions to consider only anonymous
  memory
. Fixed missing some variable name changes in intermediary patches.
. Modify the error message given when an error is injected to report
  the case of a large page
. use snprintf() to generate this message
. Adding this same type of message in the ARM case too


This code is scripts/checkpatch.pl clean
'make check' runs fine on both x86 and Arm.


David Hildenbrand (3):
  numa: Introduce and use ram_block_notify_remap()
  hostmem: Factor out applying settings
  hostmem: Handle remapping of RAM

William Roche (4):
  hwpoison_page_list and qemu_ram_remap are based on pages
  system/physmem: poisoned memory discard on reboot
  accel/kvm: Report the loss of a large memory page
  system/physmem: Memory settings applied on remap notification

 accel/kvm/kvm-all.c       |   2 +-
 backends/hostmem.c        | 189 +++++++++++++++++++++++---------------
 hw/core/numa.c            |  11 +++
 include/exec/cpu-common.h |   3 +-
 include/exec/ramlist.h    |   3 +
 include/sysemu/hostmem.h  |   1 +
 system/physmem.c          |  88 +++++++++++++-----
 target/arm/kvm.c          |  13 +++
 target/i386/kvm/kvm.c     |  18 +++-
 9 files changed, 225 insertions(+), 103 deletions(-)

-- 
2.43.5


