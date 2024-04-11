Return-Path: <kvm+bounces-14331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A888A206D
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 22:51:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAAE81F2580D
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA68229417;
	Thu, 11 Apr 2024 20:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WXBc+SgS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZHgM5pA8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC3F1CFB6;
	Thu, 11 Apr 2024 20:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712868667; cv=fail; b=UtwLtOGMif3vLAd8jh/JWfpTFdaEyC6GUeo8rdG4Dq1wnVWZJDFn3/fEqJOHUVYrE5Yus81DR3vzvfbp0VIOkY4W5f2Dn7cLUsjl8HWhuyTuSlhkZStAn+6CxwonaHkRaELQ5NUwl40TJXIeA2skVNck9abt6aBqrD37wmVNDUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712868667; c=relaxed/simple;
	bh=tjbSS7cdxOHSpT0RNjxvXTXwzZH8nY3sIeD93wmw9VQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=axUMq6B29WK5VaoPghS92NLrSRUJWdVZuRCuC3DBhFvTL0nEqhm0hspK+fbzEwAp47U08lZHRSHurk/yWdqQXbq62imrE/761fPWBvdm4JskL1xJ45DqmHhe/D4Qtd4rGjmKXqteW/bxFsc8jJPCZW2kMNJx34p+c3zyojA1wzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WXBc+SgS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZHgM5pA8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43BGtLGS009390;
	Thu, 11 Apr 2024 20:50:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2023-11-20;
 bh=EFiWjcposViGS3NtHgp+QVpzUaYRpEooTtYZkbEdzew=;
 b=WXBc+SgSopzA9WqgLfD87tzfE8RmI4vWGUgbIRJ9YZUxBXq5Qe2ggQ7QvdpRe7mcbD2f
 BF3t7z/PwtQQb4DAAgCjHud370icG+Naz/PHWTOvigS4t0IW3tMGh9L0f6ypaND+Oz38
 DXvzgxQLsiRoVT+MAgkkIVtDwmzwF4JLnBohGUaatHVwUnelbUyByXgL0IxBVW1mSp+Q
 e6YhChXuzM6PG4oNvjJA8xaanLeLyWo4YwxbRIyTrTYIhD93UZf4atW0XbxupTx0yA2x
 MBXKBUty5cuMAFhkE09zHL/W3g6nW/AeShpaLYk2FpVrpBNfK4+VL8qQ8hCIS/rxb9+z bA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xed4jsbf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 20:50:37 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43BIqI8W026515;
	Thu, 11 Apr 2024 20:50:36 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xdrst61dn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Apr 2024 20:50:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3D6IhnPbFU/y5Uyc0KaqM+6BIE2dwV7MPzWYxSSmSmqrLcKmKj5eyOxQqcluEZLOHhw+eNd2uOKB1XB6Zpm+mpMGDuX3DW9jPGIIMr5+Uv1Yp80zeynNafreBsnChUahHiShiZks4rZciGWs9FxeNjUCBXXbV7BT/O5wHRrOjHqqdQ/YPkisnu0RZ73dzH/ZEXhf+vjbIzcMvjr0hu9Vgf8vM/9o2iL5YlM+mQUXVSQ/8Ke3vTvijmKUsoiFx20A+Wt+taD7CD4R7W07zlTyVA4hUwiFnlE6eHkExkc9tFXjsRCLEpW1Wq5uiXJ0AdlUQ0zj+8YVLho99VDKVqdwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EFiWjcposViGS3NtHgp+QVpzUaYRpEooTtYZkbEdzew=;
 b=mtcffGzGDHQkeX9n6WnApX1xEK7lNs0lEqONhDYIdU+O4eUK/9JjovTwbT6vfpcvCQ7M2W4xEgGsIAYpMES+CCrMfppogAgw2rceioShHzi9pVKbXV7PTHkqZ0lLYQxqtmQXgAzkfG5hzzDt8qDn7Hqzw7x9DOUet0f8mlgLsSWhQhUCV79hbIiEH8Roq5WTCHyXsetM5jmLqt+eTDco4QBVwMasGLfSXce6NN2B0s4S+ciOtLGqoez+meanyGWM0QrpZWnREmodIUd1Hj2bui3GES7dF/6rR24NHadLvG2dwYejtyj2s0/7tvHnQz1L6lEZP3SIJnMD7M0a0Oos0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFiWjcposViGS3NtHgp+QVpzUaYRpEooTtYZkbEdzew=;
 b=ZHgM5pA8VGIgjgZ1VDRGT03ogDIFaAdwXZWcGLOApW1LEFe8y1C5PFjVNsVimH2umkgo7aJWoNH/Y3Mevxz2j1rXIRJf6DPE1fOzypDMU1oWS5HsazrlbBRXY/6YOpMf0h5hZVxgT2+hEhxxi+34+VD8N6H9+t/WV2AorFda4GU=
Received: from DM4PR10MB6719.namprd10.prod.outlook.com (2603:10b6:8:111::19)
 by CH2PR10MB4309.namprd10.prod.outlook.com (2603:10b6:610:ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 11 Apr
 2024 20:50:34 +0000
Received: from DM4PR10MB6719.namprd10.prod.outlook.com
 ([fe80::4581:e656:3f19:5977]) by DM4PR10MB6719.namprd10.prod.outlook.com
 ([fe80::4581:e656:3f19:5977%7]) with mapi id 15.20.7409.042; Thu, 11 Apr 2024
 20:50:34 +0000
Date: Thu, 11 Apr 2024 16:50:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
        tglx@linutronix.de, peterz@infradead.org, gregkh@linuxfoundation.org,
        seanjc@google.com, dave.hansen@linux.intel.com, nik.borisov@suse.com,
        kpsingh@kernel.org, longman@redhat.com, bp@alien8.de
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Message-ID: <ZhhNBCtY0rgfJdRK@char.us.oracle.com>
References: <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
 <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
 <CABgObfai1TCs6pNAP4i0x99qAjXTczJ4uLHiivNV7QGoah1pVg@mail.gmail.com>
 <abbaeb7c-a0d3-4b2d-8632-d32025b165d7@oracle.com>
 <2afb20af-d42e-4535-a660-0194de1d0099@citrix.com>
 <ff3cf105-ef2a-426c-ba9b-00fb5c2559c7@oracle.com>
 <CABgObfZU_uLAPzDV--n67H3Hq6OKxUO=FQa2MH3CjdgTQR8pJg@mail.gmail.com>
 <99ad2011-58b7-42c8-9ee5-af598c76a732@oracle.com>
 <CABgObfa_mkk-c3NZ623WzYDxw59NcYB_tEQ8tFX4CECHW3JxQQ@mail.gmail.com>
 <ZhgIN4LIu2K5vf5y@chao-email>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZhgIN4LIu2K5vf5y@chao-email>
X-ClientProxiedBy: BYAPR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::42) To DM4PR10MB6719.namprd10.prod.outlook.com
 (2603:10b6:8:111::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6719:EE_|CH2PR10MB4309:EE_
X-MS-Office365-Filtering-Correlation-Id: f9c6ee25-2bcf-4428-2966-08dc5a690870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	iqqTz5d9lUGz+r8z8imepM7h9Sd2vCqnUKsn1t92N8pBCvlPEtsNeuflRZ4VyMPjmOw8pH9uS5k+TEH/pVOz95oR+8AwqcA3NlaTrdFq1jeU6RIKM4xx8x2N1nbrA1efc93t92UnCVCO32sclrnR7gqDv+ByTr+UPLseP6c1VBaVT3sIPRlMLKmAtKx4pnFZJ5FCnzEOWp5E1lvI3Px9uN0BFRkDBgX2uoiOx1zR0+eX4/hScLzAW/5relWPcQT+EiDVX7Mr/v4CzXxCils7lnsaujtcgYhch1pwDgcKpbBqVOt+djRFk+grjJi0T6jh6GnNRO40jQO8f8pXS6Nx4BU6XGksaUepjp1O3QgBy7nXvlE3JnB3gHxh1qFonSH2xyfaqNrEhuQ8oXLvonQPKXd4xF/EWMa76ziaxhCIae8s+Ail1ME1jx0XkqaSuPONe52SBdmsvZ0jmbq8RkB7SvPuY2MTGCWNgj3tHpHr6GQHtv9+8f6MC1mlzxN4Xacz3qb89nOEj+LTL1VG78GbdLPPbVAhldKR3eJuDuW4lN2QUeaq48Bo6wFmANTDtyAYzQik6N/quQlqci9SRmW8nHrRgWgkTleiELAXcO/clCr2m1LZ0Ka025z5HX471fJ5xU7LzRPEfJolH4wKZ2mQ28MspLV7urVv92m/9uJ0Vic=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6719.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?d3VJU0xrOVlPWGlaRVo4K1BpZlBSOUIrdm1yL2diZnoxd3BTY1Qzd1IwV21i?=
 =?utf-8?B?NWtNMmxmckR1TEVqaG9sS2RiQjN3czBZUnV5ZFozd1lYdGtoNER1Rk1CS2w1?=
 =?utf-8?B?RkVjR3lmZUFqdVJBb3N1V1FHOG5YYlBqRkEwaElOVThmVU5BcU45d2VlYUFW?=
 =?utf-8?B?VnJwZmM4M1hzWGtHeFk0b1VQdHFQMFh3SHVBR2NqN3dYSzJGTFZhMitNd1hK?=
 =?utf-8?B?TTZNRlhNSFZpeWJlTTJUWFpvbUdvdENMQklhWUFkM01lVVlMbU1TbG82dEFI?=
 =?utf-8?B?VXl4NjM3b2FMcjF3anZ6NXhsM2NNcWx4SXVhL0VJZ1p5czZEalZOL2JTcC9W?=
 =?utf-8?B?ODM1YVJvRlNHV3dkanZpa0p2eis4YzR5UWtzRXJEZlo3YjRQbElSNkNhRkM4?=
 =?utf-8?B?V2s0RklPTkQwaVlRUXl2NEJRb3VEZnFvbWYwejQ5anczallTSjJzMG1BM2NS?=
 =?utf-8?B?c1RuNms3a3hROGcxVGhnbVNJcmFOcGRZdHBLN2xwcGpIeVBXQ3ZqQkFPQTdw?=
 =?utf-8?B?a2VCWnc2aWZMVm1udG9GSzhUbzh1M2RKdmRlNXB5V1ZLMWZmNWpOa1dFYzBP?=
 =?utf-8?B?dWFEa0xNZDhJUlRSV1hBZ3lmd1kxbGV5bjhoWkFzWk4zaXYxbytRTno3b2oz?=
 =?utf-8?B?RU5LQTEwR1crVnBJak5TVU9KbytrT0VpaVEwY0M1YXdVNVF6K3pRdGJmSEtw?=
 =?utf-8?B?OTE4QkhueWJhMUh0WEpvVFQxbUNTOXZFZi9BbEZVNENMN2xsNXhDMFMxbUVV?=
 =?utf-8?B?dHFQTkN4S0diWlphY05sM1dtbnVjR1V6ZGpLWjR2d3VIaEw1Z1YxYUpoRjgz?=
 =?utf-8?B?VkVTRVFVM2xXWkpVZzVkbU5PZ3lueTAvKzN4V3Jwb2ZYMUp5amFzTWNCTUZr?=
 =?utf-8?B?MXRxd1dYcUF1aEU0NTZicnZETWtmQ2tsTk1hM2FxOUU5UE9xNGVLWWZPSk4z?=
 =?utf-8?B?SFdVRnRyandIaVdtV2RlRGZ1cU5xS2ZZaHpNVTlWelJ0cXIwUFhRTW40YlBJ?=
 =?utf-8?B?OGFSK251Ty8yRTJUVVp2VWNMSG5EenVEcEw5OWdja2JnOEJ1NlJmckpjZ0I2?=
 =?utf-8?B?TEZXcGtibFd5cUJVT2hZUCthczh4dUVNSnVNWHRrSTlGR1RJOHkrRVR4ckkx?=
 =?utf-8?B?VlNXS2pYalNvaVhyZDJaOFdMY1NiUFhlWndjVHRMdDUxSE9oNk5MczJXY201?=
 =?utf-8?B?YmFTdkZ6d3BvdUt6bTMzdG5BMFIwTTZ1Vyt1ajNtZlpKaDZnTGQvK3RDSEFH?=
 =?utf-8?B?eEVWREhOMzNoMkVDMU1xWVkwczdqdEJCWkhUelJLRVlJSEZTR3htcDZBdmFp?=
 =?utf-8?B?MjF2dHhoOEs0TzEydnovQjBTRW9jU3k4eVVtSEo2eStacjFqbG9XWmlGdG9u?=
 =?utf-8?B?dU5SemxmV1p0SHUzcjFISGFpMXduNTdFY3U3K3d6YXhZaTgzRTYzaGpRLzF5?=
 =?utf-8?B?WUM3UmZDNHB2WkloUEhpQjY0QTlKUTkzVDlMYTNxNGN4VFEvOGJNMGFxcE9X?=
 =?utf-8?B?b0xoQ2VGSWNXRDkxZXIzMVAvL1NCeU1PRW42aENjZ1JoRmFnbklQTDJzb0xl?=
 =?utf-8?B?RjBRWWMrM2Iyb2Z4M0FEcktxdCthbE0wVFdtL0pJLzh4QU0yUEJSdlJPOVlX?=
 =?utf-8?B?eWwvc1ZEYWlSYW5vVDgyZDJPZDNQR2dSa2tqaWpFZlo1b3RseFBuRUE4VExF?=
 =?utf-8?B?YXpXemtEMHF3dWxrNTdrVE5sNmNkS1dvMTAxM1ZWd2dHQmV5M2dIZEVWbU1y?=
 =?utf-8?B?YWdUb2Q2Z0I0WlUxVUhQcklDN3d2M1hqQW1GcTk0UXhzb0pkbFhoMFFrT2l4?=
 =?utf-8?B?OWl4R3BUbnFhVGNJSXV1WFNONzhUdEFKRlFQdUFZS3ppamZUTWdUdFU1dUhF?=
 =?utf-8?B?M3JyNjZnRS9IMnR2QUJpOHphR0xGSFkxTGMvWmRyWVUrNGpJZzMzS3NQYzRm?=
 =?utf-8?B?T0twNlozSGpTYUFZSVFTVEZUWmc3aHJOU1Z6dDhnbVdlZ0F2V3J2WkVJRStI?=
 =?utf-8?B?Z21UNDg4em5tTDdGYkpJRW1CbFBKTlNPR1ZRak9EMVRBWjVpY1MvR3VuL0I3?=
 =?utf-8?B?MG82NHR6dnBmcGM0Q0c3U1VsL09GdGhjYU9idkEwd1RRUTNhVGhuUGJpbE9O?=
 =?utf-8?B?MkFHN05pNWU4bEZzb3lzdWNOMzF5aFE4ai9Cd2x1dVhKY3dDNGRXbXduK0lF?=
 =?utf-8?B?OUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	6HSCKXT6FKbkYVgEFSY9rXoTjDi2hpJH3LTlTtVBkGkbRd7evAFJZ84t2sYb6DQRTXonOqNkRSBDIOn1jIaOgqAS70w0VkoOeRnu6O1JNxb73T8IBXXsJa57Ltmez47ZThX3xHGLQh3cHI/p1+XKVlyVW/QwDdaIwCTEI8TQXA3/TzNax6JkxogZTL1AlotPjctj/EVF+wkUEXFXiwiAYtDu/8/K1VdkJn6gXUi/8dW2wJPfLWU3W7cxcANEFzOYFuQG9LionJhNxdiup7Qvo7ntPcU1dQ7u2NUu899/R1IdEnoWL9Eqp/wGvSdt37duOIZ04IVsFUfkqZ0Hq3u9RkbM29DhEulbi4n2HxFa2BKnsBStmrByYOXp7EjOtZw8HNcgzeiJcQN1czT51JG1EabFOWOMxYs6c8mMQCrlPKpPI0DC14omCMBHshd7B7BTXIqpnNi44jQyen8SEpNgbHZWJZLpYa8QYCqgNI2PErpYGE1g0XxrYP3fRvbl+VfHsRF+e/3IdZme0gUEHOWZGhWvCr4FaLp0gtKzPujXrEzHE8wztpPwNDEYD8CvGUmFvbmzmSQeacufdQ8o+lAEssBPEK7lcQvaViZBVl5URW0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c6ee25-2bcf-4428-2966-08dc5a690870
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6719.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2024 20:50:34.2092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iAfQeqrBv39xLTNsi0oPEjA6K8f7BNoE17GrtJ6zGGwSmMMX/5/SAXrhxTlEo5GgwDgm1dsZRIcKh/a8txjcXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4309
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-11_10,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404110151
X-Proofpoint-GUID: 3-vwZCg6qROAdffXpKNNadaAQR7K_YLG
X-Proofpoint-ORIG-GUID: 3-vwZCg6qROAdffXpKNNadaAQR7K_YLG

On Thu, Apr 11, 2024 at 11:56:39PM +0800, Chao Gao wrote:
> On Thu, Apr 11, 2024 at 05:20:30PM +0200, Paolo Bonzini wrote:
> >On Thu, Apr 11, 2024 at 5:13 PM Alexandre Chartre
> ><alexandre.chartre@oracle.com> wrote:
> >> I think that Andrew's concern is that if there is no eIBRS on the host then
> >> we do not set X86_BUG_BHI on the host because we know the kernel which is
> >> running and this kernel has some mitigations (other than the explicit BHI
> >> mitigations) and these mitigations are enough to prevent BHI. But still
> >> the cpu is affected by BHI.
> >
> >Hmm, then I'm confused. It's what I wrote before: "The (Linux or
> >otherwise) guest will make its own determinations as to whether BHI
> >mitigations are necessary. If the guest uses eIBRS, it will run with
> >mitigations" but you said machines without eIBRS are fine.
> >
> >If instead they are only fine _with Linux_, then yeah we cannot set
> >BHI_NO in general. What we can do is define a new bit that is in the
> >KVM leaves. The new bit is effectively !eIBRS, except that it is
> >defined in such a way that, in a mixed migration pool, both eIBRS and
> >the new bit will be 0.
> 
> This looks a good solution.
> 
> We can also introduce a new bit indicating the effectiveness of the short
> BHB-clearing sequence. KVM advertises this bit for all pre-SPR/ADL parts.
> Only if the bit is 1, guests will use the short BHB-clearing sequence.
> Otherwise guests should use the long sequence. In a mixed migration pool,
> the VMM shouldn't expose the bit to guests.

Is there a link to this 'short BHB-clearing sequence'?

But on your email, should a Skylake guests enable IBRS (or retpoline)
and have the short BHB clearing sequence?

And IceLake/Cascade lake should use eIBRS (or retpoline) and short BHB
clearing sequence?

If we already know all of this why does the hypervisor need to advertise
this to the guest? They can lookup the CPU data to make this determination, no?

I don't actually understand how one could do a mixed migration pool with
the various mitigations one has to engage (or not) based on the host one
is running under.
> 
> >
> >Paolo
> >
> >

