Return-Path: <kvm+bounces-18848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A25218FC316
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 07:48:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 35C7A1F2419C
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 05:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FF8F21C180;
	Wed,  5 Jun 2024 05:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b6rXpaJ/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Gq6P9+EX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8785C946C;
	Wed,  5 Jun 2024 05:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717566495; cv=fail; b=p6hPKKKCYQ80imnOCnyHKfK80DdrBFRN7UUXqtE3ERF0lp9m5BVbvURIHWTjhwV8lkxXSi8lPIoPET4ln66ykE6K3FVJ7RSJwrjk7/SQ4JHAXasPewGn6LWTxfxrJwrE9U8QJ2DHQGQVxwY5jYCqfx7UJC0OwnVnI3MElfUSxQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717566495; c=relaxed/simple;
	bh=tQBXh4pXGE9eUXh8LgMwUPZJVmuHxb0kA3S8BNNl1z8=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=PPwMDuQuEmO0yX52DqfwgcteBdOGNC1avObNCrGe5pej+3BSmaW7jA+byILmK2FtDdypsm+lTPO5DUqwChoAjsk6bVR49xlh5Pfrzcxzemo4APKzm2EHZJTFLTq3ioTY0bHQW9q7PE8MNfrOMOGXqIhX8dRuymAV6C0VAXgJrkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b6rXpaJ/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Gq6P9+EX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4551Dvie002356;
	Wed, 5 Jun 2024 05:47:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc : content-type :
 date : from : in-reply-to : message-id : mime-version : references :
 subject : to; s=corp-2023-11-20;
 bh=uFzNSMp5Qs0jGiPRijyCCPPZM3Cnck4mgPOw/Dqh5tY=;
 b=b6rXpaJ/TTLneRhmXUqf6BnpQrbKxr2/v7OYUfYWJ7DjHHpO9O5vWuomCXvAh4VMkfol
 v1T0UG/Qx9Uge0QD4JhRdL/dmG+GZCG3OZ0SRxhDUuujSlpAjLBKlQ48408qey5mYyGq
 CX7epUz9BwkD1ASI7VmaKM0ZGsqxk8OjJqZ9FZyXFjuimwikQsTDSnBPmIUDZs2vZnux
 25C16uyKRMwSRMnkZ1UYSb4uLmnapgFVgfCSm+BiHWDfX52bznJzyCzu/ZiW0XBSWgdg
 RtcFUgSeLv4H3zW0heVco0Sluz1ITksJhuRDhC6pgNdgpGgHhoORSJitYARBA5Il9DQl vQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yjbsq0cck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 05:47:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4553k2N9023970;
	Wed, 5 Jun 2024 05:47:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrqxspp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Jun 2024 05:47:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N44EWXsYejaYR8GDRi8y9pDhRRUU6kt7Ud+GU9yynNs9A1jMTAtSMOaiUsuEpo66mL0NULMj//HZHzqjZiJsJGlKRLu53wtN3c385VhPUvSmzF0gMgt6ERHlRDJSm45ee11fp2d+WY+RlOskB165PDxosFgMrwlBLnHZSHL2vj/pzl/zDXrbdrWmn6CrH4nYCvsj5FqjkU4QOA2YSIBWU60PZcM40m9bFrXE/PFk/FK4MH7LFya7Vc6pNYmfy6tcm5X2ScvVnceEYLveAWmzzBMncQY+xfFYcorpW8kOxQ9R1TqTLQavIW6eEzrbFeMaQJff8jRI9h3kLneSE6ZFgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFzNSMp5Qs0jGiPRijyCCPPZM3Cnck4mgPOw/Dqh5tY=;
 b=QQBCMLeDGnomrrj2wm75GX8F3fSdqCGVVkf9fGgftvYRyfMTLyyK2oMhWqTVyKDHIw3PQ8ZEbfb6IGwL6XqUw94TywG8Qtu6QMbTrMvto0EPgpQXBukFtOdbnzSmmkGsJPeQQ/ckRFvNvKLGTz5canvMJh2/RzyTbQ8CL3YJnU8l3/id+9qgQ202Q8sUd/EZ9L9fRrmv0OoPU5ogxMM7ycUhKPdE026nwOwlurq5GvRZ5Gujo4LbSGA4AGb5wnaOt1eSTWO+jQakgGk13MTwgzQ2s0O4kKh89MQKGiZqAmlO9bNX0vw0VeEhIM2F5e7saIWLiLD/QLDBFRovIIDKyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFzNSMp5Qs0jGiPRijyCCPPZM3Cnck4mgPOw/Dqh5tY=;
 b=Gq6P9+EXpCJIILaTXVtYOqrB3R0XnEMg4C+Z1BFtPevezwg2ByX2e6zDCFPLm9LyOT8PVcJZfKbquPSrupOQTg0jXMqdyl+gBEonpaMSaz7FBBjZYTf3Cjp3+nmLYZjKZoz7kWWs330q7eAuXSyhVA8vrlkxF/uNl3tTjUQAn3o=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DM6PR10MB4345.namprd10.prod.outlook.com (2603:10b6:5:21a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Wed, 5 Jun
 2024 05:47:22 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7633.021; Wed, 5 Jun 2024
 05:47:22 +0000
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
 <20240430183730.561960-5-ankur.a.arora@oracle.com>
 <3f72519e-bf82-458f-a066-0c296a7d655f@oracle.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, catalin.marinas@arm.com,
        will@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/9] cpuidle-haltpoll: define arch_haltpoll_supported()
In-reply-to: <3f72519e-bf82-458f-a066-0c296a7d655f@oracle.com>
Date: Tue, 04 Jun 2024 22:47:17 -0700
Message-ID: <87mso0ym8q.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0328.namprd04.prod.outlook.com
 (2603:10b6:303:82::33) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DM6PR10MB4345:EE_
X-MS-Office365-Filtering-Correlation-Id: d20ef472-7c34-4927-2f80-08dc8522f831
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?Uf7yKpAghimgxGsfHK1TtMbypXv8svMEE9s3L1rmvwlvcWvvKnfxzycsAZ0O?=
 =?us-ascii?Q?QvuG1o6R6cpXZ8ylGd6yDofLi4YehT7HEQ/GPJBnxX857CJUVacedzCMcVEM?=
 =?us-ascii?Q?1ZJAkLCZo+zANq9QsIM4MaI4aTfc0mI4cXckWKv0YL++I5Z0WuTIXKITbiR6?=
 =?us-ascii?Q?W24+g5XVGehnRrRNW5Hn35aCK5cRMiUy1c50W8csWLq8TvarYDRoO1zi8gJH?=
 =?us-ascii?Q?l089/NiNtlUIVSv2lQhltPhYViTNKXxcdUgICiQqXSkUb4EwZjkO+ukSdu3S?=
 =?us-ascii?Q?uMgZgB1AhltwKp5k1Vss45rQsxjviZwbQMr8tv/CWAkLAdetdlFPk1Dm0N7x?=
 =?us-ascii?Q?Z76kCr8GMAcNSYeKzrfd855ClWsbvGH24XfOSU6QssY3OMjDqW5Ts7jA8rXO?=
 =?us-ascii?Q?4iw/fUHPhHBbUSqwI5PAy3Al02ulK5cKZMbJrIue3ybVc2K474oyzovwFEBQ?=
 =?us-ascii?Q?tBiHWCI2K8/oRW3xJj2rqmA8FN2F3Op9ggQvcqXOarWs/Ja+SKkDcmK1BzcM?=
 =?us-ascii?Q?xVBi1limjVrviQn/rN8un0lJaLfmcoFtoZTHE8mHQb63he34zEU2lF5rB69Z?=
 =?us-ascii?Q?1MCFxyCl3N6iG2tg0iq342PZTPbvM0DPKn1QgvaqlUJ7MKTEfG222xryvrDn?=
 =?us-ascii?Q?jYSETOSesy2eExfS4nbTM3Qk6yYt/soBIx9FvSiQlpntURkA75N3SQSkNqCY?=
 =?us-ascii?Q?4081WgwUau259o7joszvgaBHT7OToU+RsGBLNRmAqYbRjtgc5VYRpgRLN07q?=
 =?us-ascii?Q?tilYwpqgAaJILmjnnBz7y1eRbuUmUx0lxNCjiHeCVgNpeVoT/sJf7oLj9AmA?=
 =?us-ascii?Q?fDNSGzAfKXoq/YhsOMV5MN//Q23ERgVO5k2TWyg88xPL0Q45WB0dmZuqxnzk?=
 =?us-ascii?Q?nGjsmlKrUyWXmowAQQif31ArInW1pYz2d1LYGEJPNcVRoWUFl1l8BIVG4r66?=
 =?us-ascii?Q?Axed9hTSgojO0HXzE6vFPyv8vkXuoQkvaZvy8B5scCPl7vAfFIE6NQVV0x9V?=
 =?us-ascii?Q?2liMEsxttVYBnB8su7Uh74ityqShlWw/RBbrERw7iA4UF63gwwOnJjGUc7Au?=
 =?us-ascii?Q?N2yP1SWroRj/Qak81Cgv/voPXfgCj+LplK4PgHNE5K0vlFsvanlkiAOWEd1Z?=
 =?us-ascii?Q?7oyB/rZ8+bV3tMHQ4/ytM1SCbWXVRJyu94eGa+oT2FWPpeWVnDbv0vSGFLFY?=
 =?us-ascii?Q?U9+k4aVK5JgJswA6gpNz9oekCMkTO4B6CurHt2x5RHqcIASpC3jGdVLgb/yq?=
 =?us-ascii?Q?aKqSmmC0tvlFaLr0a9c2tBK9Xu2Wa7aSY4V/FMCgxw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Jv+buNIuokNT44aEKp26TsUT642uCK2GELzwSjX3LbXwChMdFSLMlx1HibiT?=
 =?us-ascii?Q?0S+4xYX3kc70fPbk4AR9IPuI3a1cWWAtj+iy1hYVTutEL2QCUh7MZTDvef0z?=
 =?us-ascii?Q?52DUJgmf5fRDGifORa+CrPaceRILhw4Ze7Z0j4MFn1VSX0ST6EJw7yVol5eO?=
 =?us-ascii?Q?47I8UYmG8uVTHqUnUJtGioj+QNxF77w4DWbi1nBcqBSr9k9gaMWGL2Ndq4Pn?=
 =?us-ascii?Q?Xvbt6eoiPBwTCu3kQKDH8q/Jaele4axSRYMQHCzG355dE2en21ETjdOTu3p2?=
 =?us-ascii?Q?NvVFVdFkVK4JCIB5WGrpnlgQASWPcYkI1NzBIHS3pyf8kpZlcrhjDKQCQLXO?=
 =?us-ascii?Q?0hfhfTxQdoQ/XqG1GhkXDYcRSlNUrs+l2fVTm3m6+d2VKK5WH3k/CbSy+D96?=
 =?us-ascii?Q?qfOXGm43MYDpVgptY2DJ0eZU6MwzkaDNq05iKhAD7Eqw6CGgYkrnwYr1ez44?=
 =?us-ascii?Q?H7Iy9jntZsA08RpFOKjnnz6HePiT8yApwodgJNflSjJxQX4/t/H17CTK3HUz?=
 =?us-ascii?Q?ZiB0CkYpDOCRO9fv20SrpwVK/5uBOPZ7r1zP9ap4SueRk0wrTux308a52y7c?=
 =?us-ascii?Q?R2JsVUNTzrAAEnCO+aWN3nbxHR/KSmxK/wg7uarGKJEPYwxLBI54sSi4YU/V?=
 =?us-ascii?Q?c45MzCszdbE0ubNB+SRWU3Ir5REDMusNLccxYO9z3v+LGOaTvbJGitakQtj3?=
 =?us-ascii?Q?2KYyF8hvWzvVH/prZ5A4oMNIrEpXh/oQoSnKW6UbvTHwLw5lIbEBCYtUg053?=
 =?us-ascii?Q?Oc7TkIN5pPX5b0FgPABMXWNWfTjg4/SVnblHnbFpH5Zfp1XJDb+2kgtuYhw+?=
 =?us-ascii?Q?xvdy218CcEV2v+9BLdUMAmU8odQ4FJ5nAyRrukUc2+om2s7XeDWA5mUnbUgG?=
 =?us-ascii?Q?ExAfmwhDc8Mmy8Z34K2P1Mvmj/+8Mm+8zQwFKycN0tdlwDxIh+WtjHvVt/XH?=
 =?us-ascii?Q?dx+GJQonRwCATA7xTKJhkPsAz9DsHmNs8A1iLWa+gEeWZfYwhrMFIQITX+Re?=
 =?us-ascii?Q?GMir5OGeEACUJg5zvmCsxi7INgJF1U/TVaaJU+whDr2O0OKUvbp2HfZ1OMi2?=
 =?us-ascii?Q?rIi/46fmXQRcOYsJEJcpCDpb/peVDXptKmLdNlfH597LMCKHdiBuzAg7hDFt?=
 =?us-ascii?Q?/jZqcTbcmNW3OLsb7GCBe66jev/MYurWOFZflGf8ltNagn8WFocr9uMA3joF?=
 =?us-ascii?Q?aojJ8Fq5V/6go6hSZK+0m6wFk52NRPxBhDq/S0xzW7jrmEUKJU+GjwKbk9/J?=
 =?us-ascii?Q?TlzY/RuMbKelWmxmxKgzX0Gdn1cqPyanFfaztobdW5GZhLnElWqHpTaOvHvt?=
 =?us-ascii?Q?ipEJeGwnFS6ucnFUERL10QCRoF02k6KLY7dzPrVeLZ9FTI546pQx4XhhqJ3x?=
 =?us-ascii?Q?UsLoixKGv8bUCwJzNyb2DjMc4fBKbVtk/btnrkK71AGI0d+g2tRuM9ENUc0U?=
 =?us-ascii?Q?pUO+iQctB+Ibtr9o3RvVy4vUJZMYBRjZE85LO99fpbxXzW7ck8x0ir5qkt0r?=
 =?us-ascii?Q?Ed/ZFUu2xStt6EUCPzhzWXqNDnvZcYb6W/1U7QxFwUauoZg+wrHqcBsL5aVe?=
 =?us-ascii?Q?BM7mlH6Kmb3hoszWqUzTwI6ORNQnP1L6ObRDkLqEGzT0KowA2mI9HWPCCBMN?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	KQTzzMr3HCHmyhiZ3mdAYnKOFrvkYJ2krCVpheNN97LYAQdM+t5PGKhwLvKwFitpvLzPY1OiXJ2X9Ca9gbuhd89aRc8KCUtDVH4hdPpN2MoILaCRfcsHM9cUSesPmxuLQmi5B63Q933HnH1wgB6fPA/glOoVSioIdByusg+J2gKzz1W2PY647za+BTmS+JASYaIw59tvLl+XxGqrWC+aLTGg4HBsEj3O0LOLQViK7LkdfJ5mVL3Y4QRKT9ymkHkgpA5WauHF3LLPZCOKfzhiginmamWnFIjyA7BKP2VE5LH1cIN/t5dGGGAcenZHbwNoQGUYCtNtImaV1sgRMoXjS8ullb5yQ0qWsYIJGGrrUW5Xy/YySYEh6Zh1TE12dvFdSI/p7X+9hm1666pCRnhVmna6PZ+DzCN1qQ/0yhTGh9WPYW8/QZYNCcDKekEiLPIk7x2DSRsu6+uMVt1vzqVZDiIL2sFRKrgMQcn86b+Ixe9zzkwhTOo/Ybbv2LxXGb7SThjRW6XM3ytu44z1QHn1jMm2BPETAYA32NpR7XgvY2Xo2WTUFWpQw081PJVrH5uoE5jmX14xDcjzhSZ+88E3vblvheQ9gaEMBXfYDpuV9BE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d20ef472-7c34-4927-2f80-08dc8522f831
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2024 05:47:22.1883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bd6L31MdF1YoGl44ODtL9++f0AUuDc4dtapJIme9zX+RfhtL1PEzHcn9BVhb7W+67jed5ezHRug5hIwsLXPCY23JLSwQYG6PQHrKXo8T0o4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4345
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-04_11,2024-06-05_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406050042
X-Proofpoint-GUID: QeYDQyVsnHR272sEtG40Re-flUm7GPyj
X-Proofpoint-ORIG-GUID: QeYDQyVsnHR272sEtG40Re-flUm7GPyj


Joao Martins <joao.m.martins@oracle.com> writes:

> On 30/04/2024 19:37, Ankur Arora wrote:
>> From: Joao Martins <joao.m.martins@oracle.com>
>>
>> Right now kvm_para_has_hint(KVM_HINTS_REALTIME) is x86 only. In
>> pursuit of making cpuidle-haltpoll architecture independent, define
>> arch_haltpoll_supported() which handles the architectural check for
>> enabling haltpoll.
>>
>> Move the (kvm_para_available() && kvm_para_has_hint(KVM_HINTS_REALTIME))
>> check to the x86 specific arch_haltpoll_supported().
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>
>> ---
>> Changelog:
>>
>>   - s/arch_haltpoll_want/arch_haltpoll_supported/
>
>
> I am not sure it's correct to call supported() considering that it's supposed to
> always supported (via WFE or cpu_relax()) and it's not exactly what it is doing.
> The function you were changing is more about whether it's default enabled or
> not. So I think the old name in v4 is more appropriate i.e. arch_haltpoll_want()
>
> Alternatively you could have it called arch_haltpoll_default_enabled() though
> it's longer/verbose.

So, I thought about it some and the driver loading decision tree
should be:

1. bail out based on the value of boot_option_idle_override.
2. if arch_haltpoll_supported(), enable haltpoll
3. if cpuidle-haltpoll.force=1, enable haltpoll,

Note: in the posted versions, cpuidle-haltpoll.force is allowed to
override boot_option_idle_override, which is wrong. With that fixed
the x86 check should be:

bool arch_haltpoll_supported(void)
{
       return kvm_para_available() && kvm_para_has_hint(KVM_HINTS_REALTIME);
}

and arm64:

static inline bool arch_haltpoll_supported(void)
{
       /*
        * Ensure the event stream is available to provide a terminating
        * condition to the WFE in the poll loop.
        */
       return arch_timer_evtstrm_available();
}

Now, both of these fit reasonably well with arch_haltpoll_supported().
My personal preference for that is because it seems to me that the
architecture code should just deal with mechanism and not policy.
However, as you imply arch_haltpoll_supported() is a more loaded name
and given that the KVM side of arm64 haltpoll is not done yet, it's
best to have a more neutral label like arch_haltpoll_want() or
arch_haltpoll_do_enable().

> Though if you want a true supported() arch helper *I think* you need to make a
> bigger change into introducing arch_haltpoll_supported() separate from
> arch_haltpoll_want() where the former would ignore the .force=y modparam and
> never be able to load if a given feature wasn't present e.g. prevent arm64
> haltpoll loading be conditioned to arch_timer_evtstrm_available() being present.
>
> Though I don't think that you want this AIUI

Yeah I don't. I think the cpuidle-haltpoll.force=1, should be allowed to
override arch_haltpoll_supported(), so long as smp_cond_load_relaxed()
is well defined (as it is here).

It shouldn't, however, override the user's choice of boot_option_idle_override.

--
ankur

