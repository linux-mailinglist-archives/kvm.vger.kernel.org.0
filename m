Return-Path: <kvm+bounces-37064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BF36A2480C
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 10:58:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B886161D47
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 09:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C4F4149C54;
	Sat,  1 Feb 2025 09:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N9BfYzcF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zB/MXxpl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48742145B26
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 09:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738403870; cv=fail; b=cEfItMizUcL5omHEIltbyHmN7HZmG9WRueULjUIbxnPRkt+UjpJHh0THpTcfdGeYf6EFY94e/kMqrJ65rTRYiUpXx+JqQycc2OEKYb7Wbhag6w0jNsazTyKXXcNjysMjPl39muCpC4a33z1DCIlEtiI/SyiA516IZVf/TG7/H2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738403870; c=relaxed/simple;
	bh=j5PvR/5fKfYwUgg2gCMynzASGAcdFXri8UcwRQ4E92c=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=FAe1DD33KAadt22axgaW8ZQh88ZHWAktoyIKh2NqodLDA1LbcGxRiXFqEHKf6UcurprWpbY5bUggBhEQtlCznoWeKnkV0IsOdIO7efbiKvk/3HalC4Ke7OLJgY5Ve1qwT4NAsxLMi0T7Bq2+psGnno1KQ+3zG4rmr2xEzPSaShk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N9BfYzcF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zB/MXxpl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5118IfJm001363;
	Sat, 1 Feb 2025 09:57:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=79/ipwvX0MCcgAfo
	YgCmSnpK4r3zKyEe0mPlXooGvxw=; b=N9BfYzcFcgsVYfNJZ9Im56rQaUoYugwn
	Uc4XRBPngQhJWbfVv3/uDkFLuI8KSt4zYdHZzTEC1+uad7rBJ8QHGvVLov0ecFGB
	j24m3nRJ1LJAmY2GM+ZEtrAAnG5WQBreo/+bfaMoAqTmCQwg8bPsjUtjZwyucfIE
	A4OZEwcVlURaUhQCd4npcP7rDiCpOQVflZAlCyYVF2ZMMrKnUMmR6qAOI4QbCP0F
	NwtmZGnYwAHWIAwlNZ07HgGGAXJ4XgNvB/n/1XUkwMd/XDYIciA6rmUwLo/V9wcm
	xkS+wCaGuIjQljsdqf3NBbQUMq8NQumZT8xTdoSoOKjLgF8DjC6aCw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfy802tn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 09:57:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5117XIwt008880;
	Sat, 1 Feb 2025 09:57:30 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44ha25fbmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 09:57:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YwcbFtp+cJOA3KEjCUQv9OiLogcCjrZ0Xo619qooBU7DaPsLy+/BV4d7VTJuga3WYv7kBp+uQ6G2YqolzaiMReP6lOPt7nJMzY/tepl/uW9ttb+QMIBG1crtourBlvuCk1mFRp8BLXMxQggE8qeE8e96jGrJk5I/O0R1YhfhTLz9b6pqvCLRzDeE5ueq9i9zvkmKkg4XJuB8mmeIOlaorLlD/T5OZ6firBicTEuvZcOp30t7pr5+cd0Wk6kNAfJmuHf4xWQFNF/P2K0PAqXkEse5H91tCswDIWOFiDBwJqnxfjGNRWr7ofCXz4t9EVX19/gEFWpeztHPENGdW9RH9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=79/ipwvX0MCcgAfoYgCmSnpK4r3zKyEe0mPlXooGvxw=;
 b=ZwWayCObNKhDa3vakUkHFeupEv22nQkvm6t3dRwu0d48M43WTtLHN/YvQeXVuLV5MQmjCxg21vDBwbEmylQqgJi5Bcklz9+fTlnmR5uyU6uk+/ARgqMZbxJey/YcLxAbiZtkGuks8umLaVxwdQfiDkr+3oK6fhe5PWi7m96HOURaFRgbHbH4Rr64jeBl3WUXGFdR7SOaomFyHwtBSDGcFeiQylKHZLFCJF9iRSJ79rJg8RwcKeDKytpzHDF/64mrDhP40G5bybTY9O5WG2ipk70HRXEWdZ+jYTR63dygsjDyEOEWErWCuXacP3U7qjI+HcQkx98OcMpO4DOGtunB5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79/ipwvX0MCcgAfoYgCmSnpK4r3zKyEe0mPlXooGvxw=;
 b=zB/MXxplaO80Oo3o33CmPVNTmYehCaUeiXoU6iiAzmd9Ibn1x1Gk7o0zSIEXlEmQarRLEDfjj2MBrm9P99PkZNhhlXBuHGIPpCmQJDCM02G6tJf2DpaQXMdi5WN8PzhgPEhyBWd5kSer/OnGPLacbmzv0dxq4NweZZ1BXV9SG8s=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4418.namprd10.prod.outlook.com (2603:10b6:303:94::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.22; Sat, 1 Feb
 2025 09:57:28 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8398.018; Sat, 1 Feb 2025
 09:57:28 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v7 0/6] Poisoned memory recovery on reboot
Date: Sat,  1 Feb 2025 09:57:20 +0000
Message-ID: <20250201095726.3768796-1-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::31) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4418:EE_
X-MS-Office365-Filtering-Correlation-Id: b0b60e10-e065-4aa1-3b76-08dd42a6d60f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HEUk5hbU+o2ADQHPziSi53IriUkRKJSJPC2sCqMK23eQFixiBXOwmRMI2n0S?=
 =?us-ascii?Q?jflEa9wVVpeim46ewZhHYG+doIHOx1p20EYbmXRTLx0EEA4VNtALnQmI2oVF?=
 =?us-ascii?Q?ywKVz/SHvBWy5uBoX31tlSK6EJqXm1u4SEtMEpyyy1aj1BS6F/zh48ZZNL2q?=
 =?us-ascii?Q?+8SV0Ik6pFq7L3uFO9t5Hj4ook1X8kZ2AJ7hNP2tzDWqj/eXy2Sx/zrPeGaE?=
 =?us-ascii?Q?zBPOSoOov+NHjXoHV2XfXo9Zf0BAScq1LCnsSIYNJvHIAqtpNwsJhn/EAMoC?=
 =?us-ascii?Q?2Bi5CUXsgaCUKtywjRBZe+QB0Pr0cdOjjw2u0aAOJCYWnDhI/sOfiDFCsgiq?=
 =?us-ascii?Q?1oYeylvxzntDDZfqDfTQY/FuWUVB2/wp2kuHA6HliZXZVENG47AzLjK5rCGJ?=
 =?us-ascii?Q?SEENxLiThhE1Pk2VSFvf1vc96gL7AXxU0MI7WLkJjQQecWUh4XqexAk+0u04?=
 =?us-ascii?Q?JcMkGK8Ftc8wkyt+Jg3pA+RAUQ8TG9F7yWP257u3Uwjsb7hhVakFYfinYdMt?=
 =?us-ascii?Q?35eM6ux0t34QRAIoTdO3e567maa2c60pgxkfTteGkv/bxiX1qs3wMgRjV6YW?=
 =?us-ascii?Q?m1f5+dNdSB3NGBGxmGCRi1OK9IshcGmObmRzFqx2rM14W3abAp7x8GjD0yHu?=
 =?us-ascii?Q?JnB3bNCx3yuD5V1kewAQUVCN+akk/jg5DHe8VMH3btPVnEroYtgr2vtcBgXG?=
 =?us-ascii?Q?pSeFF7mJkf5h5HSr42C2hiHqBFqg+FzFxnrUjLjX72BazhypyKimVXdVnjv6?=
 =?us-ascii?Q?paFlI/VyfTuyJjA2+XQdH0Q7PrkgD5yD+55qmaDsxVTShW8qASRuaatjNd1e?=
 =?us-ascii?Q?Ncj0dkhx67aoPy/96+1rJxAI0yK6CzPh4d6Yx4rkzwse+q0cUBy995AcuZoL?=
 =?us-ascii?Q?ga0AJb6yn4iEcsGKAuVCWakU0RuLhYfV622Jhg4A2QLRPya3Qr+J3uJIMnLk?=
 =?us-ascii?Q?komIMdwFcvLTGKJPgK5Rj+xTJhN2ovadu0wOXnOBHMY/APR/SV5k2caFqQSs?=
 =?us-ascii?Q?T7t+vz+PUeIawGzFNlxcAsdF+0r2TD9dnUGPG3M/v0MHFnNUMlysSXYK+aLt?=
 =?us-ascii?Q?xy+wBNRXC5Ly06ndIE7PGsdU7Fnr8MkZFEWm95T8BaMb8fIcyp5A/gchTOhT?=
 =?us-ascii?Q?nmoOTDqe0P7K2zKgXM4sr27NEbF9Cj4vMDEl6Z7KWBgzFC2YI42u6j2WvPcE?=
 =?us-ascii?Q?z8Bq+Yvlmf+rfRkUb66yjes0OmQpafNr9BwT6vFhMbp3gDHYyb5XfoI5mQxK?=
 =?us-ascii?Q?lPaox/9N5HtRD3ztFljw/0RacbW5y+OfOAPOHAKm3fqnPtAtFnUUtSupaU/3?=
 =?us-ascii?Q?2HpMpyOCRvibSrqIiSvDegNSuXUrQQXYbEo89o0TEcSgYXFoGpsWyNMXXm0B?=
 =?us-ascii?Q?sEWfWWycVPcEzm8zJbpEc9um/e1k?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?p6oS7QP95rL/vTAZ0wRmpGtqmpQl/tiRyE/aJY8PdEE2+HdnXTZv8wd2Q/mj?=
 =?us-ascii?Q?jypi3isTk5mdGHqfk+lGhEwqjOpLIJaPdM5DvYuixKix3PgUu8qrF/6hlA32?=
 =?us-ascii?Q?43fQ3W/qbH6xicMf3BkhRANiyLYJVpyuofMefvurTZCcVcARwuCyq2okpmMc?=
 =?us-ascii?Q?glTUuZieivpMVhjSl9Khx1Mc+yUeZPDrg4RVXamypkV/iOCDljrlHdPhEz7v?=
 =?us-ascii?Q?7OFes1xBvH/oRRA++lEh3g+O0sqUb5FBMGxA5sB2VesRdVzs3LaALeE7t4w0?=
 =?us-ascii?Q?W4i/jLm80DoZCvw64W6C7X43B/Jpqxa3wIzo5D5/6kFA5Kfv1ivUvkHDmt3L?=
 =?us-ascii?Q?bpRyYjXNk9Is9gdgILmMIT2L7ALCiw64PBXIl/TpfHWkVnnVshIs+5X9pvbB?=
 =?us-ascii?Q?uY06KBHAkqNLngPnhEdS2KJAR8sdqa3Ik3NuIpwTL2pq/DJTxYJ2eIUZ28EH?=
 =?us-ascii?Q?8EZk8cEqCFL4jfKICV3i/Qcrvh0Gs1/0tVraItwO324xk+qPr/jBVD3kpDdc?=
 =?us-ascii?Q?FGSkSvNIyOvcfHXC74wgcR+/gXHqa+I5wlh4IMDWmiEloranoVutObvgkiXn?=
 =?us-ascii?Q?YkHosBLHOpaC5snITG8kyKhaw5EcZCt0frBJEYw2x0twCmj5Xdl5eu+wOkkb?=
 =?us-ascii?Q?HSNA1+A08Tfv2oWHmR5LWpCYXxuwiusGXFQ3xeQZp2e74Fudf5tt+oE5TN5X?=
 =?us-ascii?Q?XEVqNDPJr82TT5thwL5vpzbUvYfSnx0Tync7M6XPdaO7qOVZO/C6dTRNHHSn?=
 =?us-ascii?Q?Qh8aigzBWStyTzQH2mnowWfXYFAc6xj4GexXx9wq5PKDq0CbKzzezvX40GZI?=
 =?us-ascii?Q?trZSppmfp234juNDDcZWooifHSUP9nHlod3rZlhE8IMxMjOofQ8X3kuaRy19?=
 =?us-ascii?Q?ouofXZrb+0oHZiqJwJe2SEPnkZgYvo8ICZncnWtmswUetKpuWac2/kqv6zKd?=
 =?us-ascii?Q?kk3ZQKbLyQrzv4NwT4PE5CyVVzZ9nJdV1ovE0E9Bj1moySgE1mnm2tBdLD0z?=
 =?us-ascii?Q?J5/WZnRnjVLDbYw2tF7D09agtpud8rdx708L+U+0R3msvkKCiAEaVU7YKvrp?=
 =?us-ascii?Q?zZeS8egInYGpt4ao5SrDhDbjeUzw69m1cqZfOENfeXmBIi75PQ2/+Asj/KRI?=
 =?us-ascii?Q?fZwK344aVO8XhlOZUusjGqVtlMQSP2Xy3HorEr5dibybYimgml841W0JFnhY?=
 =?us-ascii?Q?23d87IikAgFnbiS0iwNLPI2iGqXD9NkO/c/ZjXaOd48hCl5uP/pQi7LZTqoO?=
 =?us-ascii?Q?fujeswZH2ygG74eHfuJRGD9W6FDkwBtjGDqKTXNFHpUf+77Gw/cJhCmZB4oU?=
 =?us-ascii?Q?r1t6vQjsSpTYU+AkNiBWoBjoYkzDHhYDOxUHF9HuK3rUcwwydo2ve+DCMxPd?=
 =?us-ascii?Q?dgfgaokOIhSAnvBW2AyHpn+oscKcHeTeRKJwdTRGUR3Jx+xn3sj+lCQqG2KZ?=
 =?us-ascii?Q?NSD4/xbmaZwuTeoFMVjSiPR1/cXOZN+iGp0pr2Gn0PL/ex44eWBgTFdS/kUW?=
 =?us-ascii?Q?nRgS6cGyKJyGiBVv/gXMXjKSSEU1zrTC3cJH54yu7LDUbPGghNNeyId5sFpj?=
 =?us-ascii?Q?0ZA+7JDGc+5Qy0fUDedJb89Dq/lpa+PkxpXADlnBILaiGEAuUFE5i1Fn5QL+?=
 =?us-ascii?Q?yQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V2bnJKFuew5n3DNPQVmGJFFjHZmWCCHQ9QMhrLAq/hahhlau8NV47lNa5GVESNmk14CPfCPKhGR6cpyzGFsMOVT7hx7jYFfvkDMn7VnP1GrwIpdcXCKhW3gunhU91SmpyDlrfBaRlbuw/bAtNpEYPGS6A/JP5MvCZk2t5cyFN6uGjLb8oUIe9svFti2q8nFY3sxCFDXsGAYlKn6m7+GnxJKjZQ139P0Dnp9Jcj6Q+KB+MdRdziHAl2gaKUnT/V2ELJHFQRJJUxQ+j2YCI5za+bfeetS4giSr3ym1DIOqGTv998b6wRpygpn6CfNl8r/2wmx6+hO8VtVXfanuY5tWz2NATD4DlBQSkyJQC3Kq5AYiNuFodAqafRvECn40BBf5lpbQjs5tqifTRQNfcbRKH4crfYSvmZEcx+2rhRYuG4bRwTQXl+MlO8P3jl6J/nj9ziQV1TtvI/MxS34tO2YmtkfZ4cT0PEH8bbPe/0tJ3XzQ4MOG7nUwuMwIcwsw28Q3qozGCyK52i2eVzexGK7yRX23G/fkRssOgTm9IfLSw29qqLs6E9KknbnMj8XUeDNqzELXIqo3f0XFw6AyLFW89iLKeI/euvzf4cnF9dxGw9I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0b60e10-e065-4aa1-3b76-08dd42a6d60f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2025 09:57:28.1485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FBuKmLM3BgkeQGZhu/75uYcdpKt1L8sGltYLguu6ukX+pXL8GF6PtIzefeLaFliNvC4TvQJAtJD0VruXbDF43Dxa9MmoNO1RpA7MzMAKRd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4418
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-01_04,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502010085
X-Proofpoint-GUID: JSmL995VT9vTmxH0ccZKhJzpbqBjMlW4
X-Proofpoint-ORIG-GUID: JSmL995VT9vTmxH0ccZKhJzpbqBjMlW4

From: William Roche <william.roche@oracle.com>

Hello David,

Here is the version with the small nits corrected.
And the 'Acked-by' entries you gave me for patch 1 and 2.

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

v2 -> v3:
. dropped the size parameter from qemu_ram_remap() and determine the page
  size when adding it to the poison list, aligning the offset down to the
  pagesize. Multiple sub-pages poisoned on a large page lead to a single
  poison entry.
. introduction of a helper function for the mmap code
. adding "on lost large page <size>@<ram_addr>" to the error injection
  msg (notation used in qemu_ram_remap() too ).
  So only in the case of a large page, it looks like:
Guest MCE Memory Error at QEMU addr 0x7fc1f5dd6000 and GUEST addr 0x19fd6000 on lost large page 200000@19e00000 of type BUS_MCEERR_AR injected
. as we need the page_size value for the above message, I retrieve the
  value in kvm_arch_on_sigbus_vcpu() to pass the appropriate pointer
  to kvm_hwpoison_page_add() that doesn't need to align it anymore.
. added a similar message for the ARM platform (removing the MCE
  keyword)
. I also introduced a "fail hard" in the remap notification:
  host_memory_backend_ram_remapped()

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

v4->v5:
. Updated commit messages (for patches 1, 5 and 6)
. Fixed comment typo of patch 2
. Changed the fall back function parameters to match the
  ram_block_discard_range() function.
. Removed the unused case of remapping a file in this function
. add the assert(block->fd < 0) in this function too
. I merged my patch 7 with your patch 6 (we only have 6 patches now)

v5->v6:
. don't align down ram_addr on kvm_hwpoison_page_add() but create
  a new entry for each subpage reported as poisoned
. introduce similar messages about memory error as discard_range()
. introduce a function to retrieve more information about a RAMBlock
  experiencing an error than just its associated page size
. file offset as an uint64_t instead of a ram_addr_t
. changed ownership of patch 6/6

v6->v7:
. change the block location information collection function name to
  qemu_ram_block_info_from_addr()
. display the fd_offset value only when dealing with a file backend
  in kvm_hwpoison_page_add() and qemu_ram_remap()
. better placed offset alignment computation
. two empty separation lines missing

This code is scripts/checkpatch.pl clean
'make check' runs clean on both x86 and ARM.


David Hildenbrand (2):
  numa: Introduce and use ram_block_notify_remap()
  hostmem: Factor out applying settings

William Roche (4):
  system/physmem: handle hugetlb correctly in qemu_ram_remap()
  system/physmem: poisoned memory discard on reboot
  accel/kvm: Report the loss of a large memory page
  hostmem: Handle remapping of RAM

 accel/kvm/kvm-all.c       |  20 +++-
 backends/hostmem.c        | 189 +++++++++++++++++++++++---------------
 hw/core/numa.c            |  11 +++
 include/exec/cpu-common.h |  12 ++-
 include/exec/ramlist.h    |   3 +
 include/system/hostmem.h  |   1 +
 system/physmem.c          | 107 +++++++++++++++------
 target/arm/kvm.c          |   3 +
 8 files changed, 244 insertions(+), 102 deletions(-)

-- 
2.43.5


