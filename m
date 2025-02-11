Return-Path: <kvm+bounces-37922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D353AA317B3
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 22:28:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C9003A042C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 21:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12BE3266570;
	Tue, 11 Feb 2025 21:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SKET2Dpo";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MK3H0v+z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AED2627ED
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 21:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739309248; cv=fail; b=XsxUSIM0a9F+pfL0VcGcDC9ucBq0gYa3+aGUE5P1hpSm0YdzjJa9DSaYCXvNqinKLDLce9YC7JAX+oqhqJ/G8+N2Sjcwh53+5Uhib+1/HfFzb/ed++V6PjuTrmwW+RZGmF7zNwdmojvSF+uyOJOMr5LfozVXmF81Ssn+L5/m44E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739309248; c=relaxed/simple;
	bh=NfrZ1npIgXj8At2LCjNOncvotM+O5obgW2IXA7s/hHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C+Ilp1gal8MikD9IGc1PXCvTEJc1RhsxLhfWnG9VWbf/jSHYIPcYtALvQjS3AfEIFLOO6hbJuxS5HLTd7JeKenyLM/xu9THzPccRwu0xVaBQAMnRQl5PJ47uHkE0u4x4CMHtpQyWIzBmWQIj3+dGxTxfEfjkzBy2qOs5QpkY1dU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SKET2Dpo; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MK3H0v+z; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51BLMTpS012928;
	Tue, 11 Feb 2025 21:27:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=dOJyRPV8dlR5jnFzjW42MurMFkaJRKQWdQLmnpULjLg=; b=
	SKET2DposKuX8cwyQiZl1A1DTmN6lPdnt/IxjboPKPEmczhz3yIlUMt52stw1bFg
	hXWviinbamZ0KtTqCNNl5qH6mX290jnsF7evmFYG+4e3UW285+c1NrQMSCYJ0Zyt
	A5XCwPR2p45GVFAqlqXvVfuUK04sc2WCso0WIpUnutW8OF5PqwoH7UlAjhxsKwH7
	v+o6IB6gQ0vo3TzBcfZwK+MNK0Gyq078U8HBzDk6znmA+BYoG7LV7z8w3Gmt3tg4
	zeg6yq69GuaeRzsLyQYZoQc2oZJNPPjLDcc10ixEbEFchZa5v3ufJdDoyrrtk/P8
	L+ajzG00W6a5OHEV6BxlAg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0sq68m8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Feb 2025 21:27:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51BKRe59027138;
	Tue, 11 Feb 2025 21:27:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwq9cdqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Feb 2025 21:27:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eNvXr7LnzGo7h2K0LVnrTEmlRUXCgLo0KsGMTI9+rh8KiGosUrZ7JwDAysvMoun/LNlitW0yyjfwnv2uhSl8pQNrxZRRiiURcJgJNH0Z3VTNtJDLZxZ1EGvV9oqE8nNOIsraGePg8fy7OU8qIQsui4lRVFJ0GejJ505gwVuHFz0urIngk++R1dR65x+fQPkFVM9b8sT111rsdledTTVwY98LECARW52nl5TIQebmZuwcmwDhHrO6+jLRObpH8FTALtdxa8EbhzBLvWfYOdHYfw5m7jjvWFcookQJZCoJD2bLNG7fpKYlp6KC17tCICJXe3XViuiyrN1q9IcG0VS86Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dOJyRPV8dlR5jnFzjW42MurMFkaJRKQWdQLmnpULjLg=;
 b=S2vcETr1pyv3uLyizbeDoL+ZZcJhQtBzl75T9i4SkuonPKXFRbFo408gFeuS2sjl+uXD6+mFiBH/dVijbBh2Q8j4wgrK/ALry4QtWbg57WUXVcIcQ1NdpI+uOvQ0TM+ReXa4KFc99X/SFScA0Fn/bCkDG1QXVr3sr6U8V9nbg/H3Xe/DhY4emvHSpCFs0hrKlTdmKOGVvY4v32GW2tih5zoDryHz+Ji8SnGHCR5G6c6fPVjaqEQA9iltzpVN8fgxMQ60HfviH08xXdPBqUSE+c8Yz4TOjRYOwlqBXSjcfJlF5w26Y09kL3ugrN5L8oOM5dpcGKzSmLUyxbPo389XIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOJyRPV8dlR5jnFzjW42MurMFkaJRKQWdQLmnpULjLg=;
 b=MK3H0v+z9FfguyURlmLwyM0CbaQ95mjBWhpI5tTAoDEnww2O3+B3Cykew4xxsV7c7DjZVFF+4O8uH29Df1VO85fI2V4QoLyX8ZaigcT6Urm6bDQheU+UEtfs8DTcsfanw3vEXQQOUeqO80GpBOf6jRjDVVqOSEyP3T99fjhSbV0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB8126.namprd10.prod.outlook.com (2603:10b6:8:1fb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Tue, 11 Feb
 2025 21:27:12 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 21:27:11 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: peterx@redhat.com, david@redhat.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: william.roche@oracle.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, joao.m.martins@oracle.com
Subject: [PATCH v8 1/3] system/physmem: handle hugetlb correctly in qemu_ram_remap()
Date: Tue, 11 Feb 2025 21:27:05 +0000
Message-ID: <20250211212707.302391-2-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250211212707.302391-1-william.roche@oracle.com>
References: <20250211212707.302391-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0047.namprd11.prod.outlook.com
 (2603:10b6:a03:80::24) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB8126:EE_
X-MS-Office365-Filtering-Correlation-Id: c0d4e38d-72fe-4ab4-95a2-08dd4ae2d8b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nk7QLqL2EL/+vrw5PfAVGiQ+MAZjQbOCAubZZS9WgW2CwKf5Lz7nC1y7xfmW?=
 =?us-ascii?Q?POLmp1HQmlNZCUdYuCeJLd+W6eQjQHZMYpSXMxQqGr/45XYD5A/u5hLrzSsl?=
 =?us-ascii?Q?1aGHetkmbrRRM+WW22gFewoWtbx+vAM+cLFdCITLhBApq9NUfrsQ64GG3kUu?=
 =?us-ascii?Q?Kj7HkS0hyFXct+FAmPRki2UFMTg2Ub7J6ibnMjj+4HUn5txwCcvojG+c0Xhp?=
 =?us-ascii?Q?FOiEQEofLSXLqF/6uHW1fIlSiuaffMdzr1XmzNR+ypN9fTw5xRbmarEtivpL?=
 =?us-ascii?Q?W2Py6H1K1GDQ3F6cAA0Zz/DAqcrkxxObqPTuf//hLTXh2eBvJnyCv9BusIk9?=
 =?us-ascii?Q?CZwlZgJo3jpba/M1XtRSTRr5IFHd7SxjmBhWKdAz8r8N3xbevjrSj8K80WSj?=
 =?us-ascii?Q?G5ikAmI9RC/cO4vnIU63zk93SM/PEl5Fl0mxtZnMlIY8JUXWJNXyYdsNLQ4u?=
 =?us-ascii?Q?42AQrqPYixGojnZAlCwOTX8x2OBgP9TUNEAX8uVV5ofJwdNhhRc3i6+6Ryvg?=
 =?us-ascii?Q?rdTCQeteXY8SX4ZZs0ZUh9WX9g+eHe9TVBKFj0QaAKLfJP8xEtWKXZ3IwsLo?=
 =?us-ascii?Q?eamYH6WQ20nOtEWAT/pjTng67ACwP9N37TzmwCb/36SpS+rOv5CZTlN/IKul?=
 =?us-ascii?Q?8lCG3n8mwR8lmZWV89cezJUV7YizAEAlL2+of3pk9LKfFmYQeqcvlUdo3psa?=
 =?us-ascii?Q?6G6crgUenf1FbtN4PA5mJoIoJq4uqdGV1gvxRyhfAzrAMZQjAuVoCb77ehlI?=
 =?us-ascii?Q?60FiulDSjyyflezvQpBkmSXSRntlWqtn4vgKy5Ievla5kd0zOqc/WysdNMwi?=
 =?us-ascii?Q?ngV8EDLwXFF9x1NzqJllDIc0JLbZvYGewV/G6lrVFnaPXpEvOUuNjQq1BjbO?=
 =?us-ascii?Q?7KfWnGhBE6MLDhA+H6GEr/e58EJ3ogqPImH3eLqku+7HrGr9qKGVEjyRG1Xg?=
 =?us-ascii?Q?PvX2Zj5x8V5dorAAINRD8OlDgmQvcbdyn6aonW+zDomQ09OrioIray3HAc1r?=
 =?us-ascii?Q?QuSdvpkErk5Qvwq/wP5E0EWwtEXIc8PmJ7FC5ew+iZ+7iB3mU6KMgFyjMdZb?=
 =?us-ascii?Q?8wCACAESGeUj7RYp9PKVk4XVqOwhsFbyfdULowyJtzck4w41wOJVoY30vPIV?=
 =?us-ascii?Q?pb7kOMEJxRrmWBrkS60w0/8sBuLUji16A7SttUl0ZD5h1K7NkxBkt5GsHRvp?=
 =?us-ascii?Q?mhWXrTBUjTFz6mYI9NgRzabFgJdXccNIBdw5MTXHC2PzALPltloX15oxuiPH?=
 =?us-ascii?Q?QQUn02n+SlY7biEOs/Aqg41uItV8wLbUWCp8QpZ9W1gXZwHZ11vE9Un8sF/n?=
 =?us-ascii?Q?jTptIWUI7rh8cC6a7Af0uh8h5NcI//nc+YKZY96QHR7hOWKJxmGNAnJYTUyc?=
 =?us-ascii?Q?1nptAwNbX8lKzGqr2/i4izGPAJYS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R06QPvl31b/d9CI/oCIG15IlotMJyZ77q3MbuRNSv9sgDI+brQQ8VRLmLQyB?=
 =?us-ascii?Q?3gNYFseiAl2r7BgqV7Ex9YalPGionX+yuH9AP4Xl9UNZeGQMD4lreB1DL7Ot?=
 =?us-ascii?Q?7bD+4YeG5xrHO7cICIwO0P+mDwweDUrZ19GNXhg9Xxy5ehgOz0YoNiCR64Jr?=
 =?us-ascii?Q?LT2k19Ff3rpuQdZaEEnK6LfM3oZVOHTutYKt9Q6Wh0EyoreDkwdR30zvqs2N?=
 =?us-ascii?Q?wKoopkzkhnQujkzqHy48j/meQs/a2mZsDY3V2Q9muOt4IWCxldSDOXoEe4ST?=
 =?us-ascii?Q?oaxU5eAqPbUaDjLWsCVXumosH/geygWWI6Gbi7WcaArVer6u4uZP9pl0Ll9e?=
 =?us-ascii?Q?w0R+OaE92hX8PHGGhgAUeq/VQZDXc+99atBdoZa2pQ0RlbqfbIlzNMT097z4?=
 =?us-ascii?Q?dN/9YSkFrg/x/fkr+7ZiA/1lGMOGio0tX93sKGQhQNJ02b5QbkiUaQZYqY6d?=
 =?us-ascii?Q?2q2Fr+gH/dAxHzEOJyJ9Zf83PHH2ufvVYbccgIzwTaowfW5x3TRgz3UDirDf?=
 =?us-ascii?Q?J/tes253B9/TdYJtWkno14pyA6UCvk/es/9ID2sOYKi1RJdphkRZ8wM8APml?=
 =?us-ascii?Q?TE6aX5jSp/2SmBWbUlzDotGaBi1/oDnTeJLOYjvAmq6JNzTT5Py3DGc/uWzT?=
 =?us-ascii?Q?PnbSfJxXpmvV2VPLr5KL3KxQV0m9ZuecT4q84sh9QdqIfJiB9d9SQjPZJAz1?=
 =?us-ascii?Q?PE18XvgQoeIHvGLbVc1DbUnypUps/jhd35egH0RBVP48w+VFFvh9QIbFRJfM?=
 =?us-ascii?Q?cDT6PZqxWpFWJISuiZaO2GOeNRYEYmhclhRdd7V01cNADuNFbOfztKfTjd91?=
 =?us-ascii?Q?hMKJWSXYy58/JXSC+a0P4PsIhAaxxtZeW8W0fyjnHLEtPYLaQqPhttPjZUWq?=
 =?us-ascii?Q?3VZyC6MtRVhLBYLgJLjNwt1yPulE2Frj0ly8pG3VTHY6yVvqoLimyZ1gc4Sd?=
 =?us-ascii?Q?o+K/lFvZiRYdf9fplpbtT8z40OT95eqkKWQTDNLdoNCyRkK4THgKIaUSa5Am?=
 =?us-ascii?Q?nQI7jPY+jjt26MCU1DEGUFhpDKaJCg0cHyWpf+8bh5zZT3WZIfoIAKpg2517?=
 =?us-ascii?Q?64YVc/Z4CIenJjegCYjcK8h7EMmF3gCOwmxu1dvskMU/hBiXR1BX3QsuoTUg?=
 =?us-ascii?Q?Wrq2Vx0m5Ki0pTZ2cT4Tz/Px+gTwfpsn2Ka4VBhE9j/cA8Lf2AKGt70RLRYl?=
 =?us-ascii?Q?Eso3HsysykIElpm6kpKa0hXxKYEz5c/qOyO+RaiPaMsKLVpZuBFQ+qWg8mBB?=
 =?us-ascii?Q?Rs+i5qQ2DORGg6ZRkr4uobjSAPQuu0BL4w3G8WOcN2yFcn+GWyXyOP4BWT2U?=
 =?us-ascii?Q?K/TeBvbbbTNpby3d+v1UZy6kxIJzZmhkp4KPCo65csDXIWCD1zLMInz8imGI?=
 =?us-ascii?Q?4P5gGAylcxEn9mxTklSotqZUaX/vHGips9e62Fgv6MuypGb5Efx6E1V6iIUm?=
 =?us-ascii?Q?wAdzNN6/gUUJwjE23AjE6/4GkBIP79TW88+27r61Vv31/e0u9bBaFNh2W0lW?=
 =?us-ascii?Q?cK6amMMHFLEomrQoIBFqteuFqw0R5MD20Lgn5QlbynKTeLb1Ofc8iQHmOZWT?=
 =?us-ascii?Q?d2W6qXiko72h5Yk/TtlNGcZrX+qBdzfJG7orsU75txwRimEsPtayOadDas5R?=
 =?us-ascii?Q?ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uMn/A6tedaBxS2ZFfool8z+X6eCV9ZbOn6gbyeAPlj70kcpDHy6UR7ct+88WCkyVnjzZ9e57b2MAlagMd6BIGR7PbAsJ3S22ZJ1LQxy51iTJG/Aw4sacAlzxYfcKiM9CgFGbae77IepQd6dSnete2VjMNLGQjQgARtF9X9QF5bTvbCW71aXxqaKc1iOjH7dG2kL9FBiCs47grZL5Gqfu1HFd44vhhkvNvXnWZpU4UeAOcx/E/jICYbRngzvOeWNClNXEw5eq2m6Hi/t1LGUyOOi/7h9aRq0lJFBVnEspq8w4aIb9oRWY7FZZaA0PkGXXRs1UmK4z5b5ua+k4cGmUj0HoCxTbTRDNM2vH/Re9ZEmYCYmBwdUMSVA2ufIAJAXd8okIFGY9H4OHW87jPSNsnIddO3jZmW+hlROwk+6NRlj5LsbUbcnO3UCsMXNd6uRJ790wclFKXdt7EtRgVlF7v07i6S4cIFHdnjP2+O2UmTcaM7YW0pFpjHxWkyDymGzTglDedtmBRK2CHZ/praA5OkWOcqikYN9A8ad2Qx4fL+sRb/xsH5axO40s6UaCvSMGwfC7Dtm8nCZiZgcX/vpTgyL6nBPqUoqpw36B1Dd0SEY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0d4e38d-72fe-4ab4-95a2-08dd4ae2d8b4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 21:27:11.6917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FxqHSg2Sbuo9oIDggf+AYHN7nw2vBIN7WLT1eQjt5HwRZWjSA75fQD+AEmzEoDEzQDPGAZXwGejvrpR/NfwTv2/F5pWjbvwznTX6Gri0SbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8126
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-11_09,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502110141
X-Proofpoint-ORIG-GUID: cAHKBiKqQ1UCuZZWBQj7oXShtKg3xGsM
X-Proofpoint-GUID: cAHKBiKqQ1UCuZZWBQj7oXShtKg3xGsM

From: William Roche <william.roche@oracle.com>

The list of hwpoison pages used to remap the memory on reset
is based on the backend real page size.
To correctly handle hugetlb, we must mmap(MAP_FIXED) a complete
hugetlb page; hugetlb pages cannot be partially mapped.

Signed-off-by: William Roche <william.roche@oracle.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
---
 accel/kvm/kvm-all.c       |  2 +-
 include/exec/cpu-common.h |  2 +-
 system/physmem.c          | 38 +++++++++++++++++++++++++++++---------
 3 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c65b790433..f89568bfa3 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1288,7 +1288,7 @@ static void kvm_unpoison_all(void *param)
 
     QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
         QLIST_REMOVE(page, list);
-        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
+        qemu_ram_remap(page->ram_addr);
         g_free(page);
     }
 }
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index b1d76d6985..3771b2130c 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -67,7 +67,7 @@ typedef uintptr_t ram_addr_t;
 
 /* memory API */
 
-void qemu_ram_remap(ram_addr_t addr, ram_addr_t length);
+void qemu_ram_remap(ram_addr_t addr);
 /* This should not be used by devices.  */
 ram_addr_t qemu_ram_addr_from_host(void *ptr);
 ram_addr_t qemu_ram_addr_from_host_nofail(void *ptr);
diff --git a/system/physmem.c b/system/physmem.c
index 67c9db9daa..a5d848b350 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2275,17 +2275,35 @@ void qemu_ram_free(RAMBlock *block)
 }
 
 #ifndef _WIN32
-void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
+/*
+ * qemu_ram_remap - remap a single RAM page
+ *
+ * @addr: address in ram_addr_t address space.
+ *
+ * This function will try remapping a single page of guest RAM identified by
+ * @addr, essentially discarding memory to recover from previously poisoned
+ * memory (MCE). The page size depends on the RAMBlock (i.e., hugetlb). @addr
+ * does not have to point at the start of the page.
+ *
+ * This function is only to be used during system resets; it will kill the
+ * VM if remapping failed.
+ */
+void qemu_ram_remap(ram_addr_t addr)
 {
     RAMBlock *block;
-    ram_addr_t offset;
+    uint64_t offset;
     int flags;
     void *area, *vaddr;
     int prot;
+    size_t page_size;
 
     RAMBLOCK_FOREACH(block) {
         offset = addr - block->offset;
         if (offset < block->max_length) {
+            /* Respect the pagesize of our RAMBlock */
+            page_size = qemu_ram_pagesize(block);
+            offset = QEMU_ALIGN_DOWN(offset, page_size);
+
             vaddr = ramblock_ptr(block, offset);
             if (block->flags & RAM_PREALLOC) {
                 ;
@@ -2299,21 +2317,23 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
                 prot = PROT_READ;
                 prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
                 if (block->fd >= 0) {
-                    area = mmap(vaddr, length, prot, flags, block->fd,
+                    area = mmap(vaddr, page_size, prot, flags, block->fd,
                                 offset + block->fd_offset);
                 } else {
                     flags |= MAP_ANONYMOUS;
-                    area = mmap(vaddr, length, prot, flags, -1, 0);
+                    area = mmap(vaddr, page_size, prot, flags, -1, 0);
                 }
                 if (area != vaddr) {
-                    error_report("Could not remap addr: "
-                                 RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
-                                 length, addr);
+                    error_report("Could not remap RAM %s:%" PRIx64 "+%" PRIx64
+                                 " +%zx", block->idstr, offset,
+                                 block->fd_offset, page_size);
                     exit(1);
                 }
-                memory_try_enable_merging(vaddr, length);
-                qemu_ram_setup_dump(vaddr, length);
+                memory_try_enable_merging(vaddr, page_size);
+                qemu_ram_setup_dump(vaddr, page_size);
             }
+
+            break;
         }
     }
 }
-- 
2.43.5


