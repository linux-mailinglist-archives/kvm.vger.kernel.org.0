Return-Path: <kvm+bounces-10496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C886786CA51
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 14:33:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 23B7AB25A30
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 13:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BDF87F47E;
	Thu, 29 Feb 2024 13:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CGIo5NHk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="a8noKVaa"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EAE64AB0;
	Thu, 29 Feb 2024 13:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709213584; cv=fail; b=g+U3TCmlZkjDxLfrit0Wc0aQPfovRX3cOOrgIA99pvAfJ5sk2q0yow0RHG8Sq0ei9TgbH7gxmzk6uvbegJBXwmwvvvb8g05HPOeanrqUuVxBW5uTijmnsnwRFJ8OVauFh4Ul187ySGtgWcl7zFlmiIpzd28FSrqkGKXGo5oJdm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709213584; c=relaxed/simple;
	bh=dQbr+j8Q2lAUpVXM+0He2v2Os6Mqznl9Dto3AgS6JCc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kvgARiJpuyzCuA98l6OTPOGvwtsX8EVsITkLnKwCoNNq1CX5s26IGdZtWVkW+2TcEFAF7qT/NL7SDMT8BJgYgF/wXq4dwBK7L6r4SrPlSvwEER/WPW29aDQ1V+CDf60hirk5hoTyQYBhDJInVDUf25uuh7ph0JiAtMpuHYzwAJ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CGIo5NHk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=a8noKVaa; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41T9rbXa012454;
	Thu, 29 Feb 2024 13:32:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=ZVIyoOLgin0+RHTkFHeDcorezwDyj94/DlibiP/b8BY=;
 b=CGIo5NHkeCvuwibj9DEi76uAVzHkfrw9wj/N3I3fZdv6f6ohFXLYO4QekgfqY2qnn+sT
 DNQubbk6tVJD9oIAAF2YIQLTWD2+exQnwT18aLC6gndv8zIJn321O2sggg/bCMYmho4/
 n69LY2u+lTLnAcSBnkTgqAG26aZ8xjnFUf9yMvYvLNO9Nyw2b2CoKQe49i0JBePXaqKe
 y6QaA8yU+LcF2wxbnE/XMJ4eq4/OBHNjwwLx2KSpsH2PekoIngHqJ9RKFiGH+SYgix/0
 wRy76kfWk66psXfD/ko/XhFEbfhsLbmmWAOttRpO9ugfu/XPvm+i+g5j0XKMyq97phEs kA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf82ud5y7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Feb 2024 13:32:54 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41TBsgHB015331;
	Thu, 29 Feb 2024 13:32:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6wapnw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Feb 2024 13:32:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V452zpljI9X5YwOLlrPywBMeA8KcVnYTlcfEW2gg55NFinQkQbYZgmSI0FDSogC/N1/zUjmzKPEkXswmB6HHg3R5Bnl7rV0FWNgTlyaylbr5r0uqC7+VkrbRGfWx6R7KF6Ter9PlTQJ1JocUkWAE8/Q4wtnzyjYG0Ee+Z0Nfvx9lTHyFnrndfM50/YgK+xe2Amjf4WQtqVARpZKjX9zZjAeZXKPS4xrMkY/XkJbu2x/7QR7LYouusdFsEteySWCe+FXqpw/OJueUDR57ZC2F8bUIXeitE+68AOZ712pklq4XOGvWzQ7qJEr/PyJaDEtHA1Ifgud71ZE9yG+9/Oj9KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZVIyoOLgin0+RHTkFHeDcorezwDyj94/DlibiP/b8BY=;
 b=oT6rWkdPWZEmSllzmixrirq6aGA3AwaSQMkxHTCyxvDV3EwndHjazFR9Qcuc7iSLQWgkHg/TYBDtGgTlEx4S0w9moQrYQAoOVvOo98Lyt/lf7Q+rvC4rbjScIE+jxYdK67TUbRdkiKJNpezQKyRkZjnyoG7Oyhq/+5C3VdkyxBJtt9TxPIbLJjiu4vP5ofAhFWfAXMiu+Po29AvrD4eQ48oxQjGPzK96bpXkXwboaJ9JFbLsUv2T0cJgeg0DEQIa5HdsuFGfJU6E3AEwj0knpM0iZg1SY0QexZRcNdHYp/7XCSIPLteSZQwwweIwuXHggo2ET6PZQTFEccQeP0zJRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZVIyoOLgin0+RHTkFHeDcorezwDyj94/DlibiP/b8BY=;
 b=a8noKVaa+eK+0UYi1Kyd/d96Pv5WNFhk90vigdcpLfMx7/wHuskh0Sn99VZDEKlE9r71qYjnxKCy2CWS8J8wSYUtcTo26ZzJUbjMdFmdeayAhZjWOooU5+tj7J0aa4FD3JIgOoNneJrAGA0GGiElgz1NTB9aokZDydegYOqRGPM=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by IA0PR10MB7327.namprd10.prod.outlook.com (2603:10b6:208:40e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.39; Thu, 29 Feb
 2024 13:32:50 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f%6]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 13:32:50 +0000
Message-ID: <b0ceacea-e2ba-0a79-fca7-158fa8a1bcb6@oracle.com>
Date: Thu, 29 Feb 2024 05:32:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Pass full 64-bit error code when
 handling page faults
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Michael Roth <michael.roth@amd.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
        David Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-5-seanjc@google.com>
 <6c10e17a-b1f2-c587-fbdd-85d15256b507@oracle.com>
 <Zd9d2n3k8c5pTJto@google.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <Zd9d2n3k8c5pTJto@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::39) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|IA0PR10MB7327:EE_
X-MS-Office365-Filtering-Correlation-Id: 2779b369-6eae-476b-c041-08dc392aecd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	IufjTn1OY+0c/oeA830n2cTmSgSF1d5ahzTHE7U4pT8XbPf2bje7X0nicGh83hJJCuy6KTF/uvadd/lECejIKFufVFXlDHZhsvv65ciQ+CUgM6daCaYeaILUylqMeAEthVno2iqL0pZes6ZEAyYAz8a8pgjT//OskOo8WEHwJoyoB5EnrTQ/wql/UoNP/VY8MODebITEeHokVh3+p8OdFFF6WIcRbQP5oHRNaVG3vW5yj6yDHQ5ACHU0wgg0DkWCcPcFMtdNNjvJZ0lMsmRZI+yLPZuuhNJX9OO0mlkxtALo/SDT8dOcehMBAGuOmZPhD7OEdk4XcKLqLCjeDbj3pnuHK/4OTk6qK5frkNolRcNk7lp49iBxympaUzYAKEjsGZED+cqKZ8WYz23z5oZ61iKZ9TrlA824T2AguidNKJxN3FbG670+JdwN8LNB4YhaTqjkHbNLn4bsxePtp+d3EQcmVlhdiQpFl//r2zCcBSOzA/J6dWvx99C121NqZnWTyQ7Oh9qaeGVgO+DUFcY22yUC68N7DIQDlp3pkwUo4h1EOuC06rBBYIVORDCKHNY7UKS/qP4IkaAbpArtFOc200y3M1BJVfI1b6rc/G1f4ZSOlmK0Xi7cteAIz1FrM2OwW5Oyu0OFl06E7eiIT1ULiw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WFFyenBYdlVYMzRUa2xxQ3VkK05Gcml4eUZsNkNNQ3E1MEJFK2dGeVREN25p?=
 =?utf-8?B?ZzV6dVAzNTJQNHVaWTl2dVFvRU94cjhCa1JuTVV6MWFqdDA3bXJLdCsvR1dM?=
 =?utf-8?B?OERJTkt2SWoxRHd5MUJXVEZLdVZERS9PVlM4akZkdExucXVQN2R1Wkw3a0Zz?=
 =?utf-8?B?eFBrME1sOWYzRjlXMzk0Zi9kanBsM3k2WlZYMVVVYkpnbko4S3VxblNMSmli?=
 =?utf-8?B?RUxMejQvK0FSVzQ3SXZVQnBmWXJ2bHl0dWtRM0h3VEJIS2JZR3QrN1J5U1Zu?=
 =?utf-8?B?dDQzK01lM0FYN2Ntb2RVWjBsQ1l4SXlxZExxR3Bhdk9VZWpwZU1vTDUxZXdD?=
 =?utf-8?B?cHFMU1ZObW9wdCsxNWdUQ2U5RnZFeXVuTmRueHFUM3BkZkFQb25rRGFrRGlJ?=
 =?utf-8?B?a2M0VWNnbVRscnJTaFBzMmVXd21wY3VBRlJveWdVNmpVQ2xKYmtkL1ZQTDF0?=
 =?utf-8?B?cWxBNXpRb3hTeDA0SWhIUE5hOFpEZ2ZwTVNBSE40TWNFbmRJbk5ZTEI3U21Y?=
 =?utf-8?B?R3AyWUhXUFo0ME42c1RUVHI0VGpWVDlNYVV0bDdVZXBjNTNvRFF1ZDduWmZY?=
 =?utf-8?B?ai9IUmpia2ZQQ2dBdVBMZENhWDZYaEtsMW9TZmNXMldPZVp4UVlFeU5wdkdn?=
 =?utf-8?B?TlJaUWFFaWdJSGdBd3ZWSTlpd1pwd1hvUitkUHp6a2lKeDlxN1VmSTVYUVZQ?=
 =?utf-8?B?MTlQNncybFZpTTI3QVhnMWNyZUxVb0lzd253cEtSaThVWlN6MGFuSm1GSmkx?=
 =?utf-8?B?M2xTMGE0N1VCN29Ma3pvbGdHbmh0VnZGWFR5ejd5RFZUamNBb1lWeDVDT1pp?=
 =?utf-8?B?QzhwazUrV1BIRnBXTXNSSC9obXgrbVp6Y2dQclpXZjhGa2R5THdRSDBvMTFn?=
 =?utf-8?B?dlNrV3Erd0cvRnhkOEw1M2pwRDJrRmxkeVZvWkd5MGwvNS9nd0h1QjNsbUtv?=
 =?utf-8?B?Sy9RZkVqU0dIUkVpLzQrdnJQeGxtV3lPSENRQU1EZmM5WkdRVzZWYlBVYXVi?=
 =?utf-8?B?UkNLMnhadG50VGtOVlVSWk5PSkZOeTIySlJzUU4vNlpEQ251UzJ3ZnkwY0N0?=
 =?utf-8?B?bVdYTGRQZWRPUWwrVkQzV1k1VEg1THc4RmxRVk9QOEZMRTRaUmlFVnZhODVv?=
 =?utf-8?B?R25jOWZQUU1Bb0d1MkN2V3pkK3U1QWRTYUtHTURIc0UxcmRyY3pwQXBONGVi?=
 =?utf-8?B?K1hCMCt4NE1FcUJGRWpBeU9ScHJsbDFzSlgvRVFTb2x5YVJSVkJkY2JCdnhw?=
 =?utf-8?B?QitwM2xpU0Z5cHRPdW1CZ3BnbGRacWd3S2svaCtNeHJVM0hOYi8wSndYRUtw?=
 =?utf-8?B?RExjOW9Yb1Nyc0FIOHhIekswYzNzTnkwZ1FwdWJQMFBqY0hWTDBqLzRHMlg0?=
 =?utf-8?B?b2tTNXA1Yy9IbktwcGVqdFA3U1NoOGxVaWxFYTk2TWxvSi9LeDRUaGZsT2Zs?=
 =?utf-8?B?cVIvMHZwbUVLemhkTWRIVmRFaURvai9YZnNDWEhsSUxabXBSdHl1RXNKZUVh?=
 =?utf-8?B?NjFITHhWUGFIS1ljRlpUK3lpR01RYWpYSDcraysrWUl4VXNXcE4zOXcwVkpB?=
 =?utf-8?B?TmVTUDFJc3Z1bUtxQ2JWOG5SeXBZUk5yQlQ2NXo3N3RGL2ZwWGZzQzdxUWVS?=
 =?utf-8?B?ZFpISHcxc05Kc09ub2tFMlE3M3ZDNndnaG4xK3FCUDh2UFY5alRLeld1M21V?=
 =?utf-8?B?SFVFaUVXQ3B5emthRDVSa0VpVVBlSlkxUWRkSnBreGVHb2RIMVhuM09tcHVl?=
 =?utf-8?B?SFI0VjVtSWorWGd0SkhVUjJweHBIaFJ5M2M5dUtzWnRQWWEyVXB2K01zSGhZ?=
 =?utf-8?B?V3oycU15L3RMOGIyWHRBZGhQb2pvRjVFRklWYldxblpGMkN0ZHhGbXJrQTZR?=
 =?utf-8?B?enVPcE9yTWt2OHNMbk03WVR2S1lyL0NRQk1xeWlCdlROS1BzTWdYZnlESkRp?=
 =?utf-8?B?a2cya2pWRm92Q2hBdldibDhBUzc4dytiaXA5dUZ0LzcxWlVPRjRtN0c0TkFi?=
 =?utf-8?B?MkFNdzdhMkVSakhoMmsvVytmN3V1S21rL0VjWEdobldUSkJzUEN3YU1QaCti?=
 =?utf-8?B?KytpeTJHRHB6ZTFwVFJpNHI3Q2IxeUVsamxvR2dabEFDSnFhU2ZmK0xndjVJ?=
 =?utf-8?Q?kHafPMyr+jo5L3rl5K7shJkjn?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	2GetAuks4Yw/kE2pfe4z5Ikz130P9csrpqbD4Y8RB6Ze29MCsByI+QTa+6YoPSvZ0EYe2z/qtZd/Vm/luhdYOvsi/iTvGeFz0/6aVC50uNhGUaq3VcFC0euKB1WlAVhbdejPunNTS0Rh7nY5ycLeRWi6w0VHGWimrp4De2+nhLkqMA8znaXblqsFWD/XMYHSya+XlpKK0Fuehex3yrWKp9HORcAOlrHlhztIF6WXLSGmP7OgDF795ql7PJaSJaMeyhYvan2WT7IHTjn0WcSCmCJb501cFVVc8GZRoATVHiMiLGBIYJWycL+PM8o2H0BJCOb8IW9DjtAWhQ5PzUXupkqPHlFlglrTzidMfSSvBpQn+KBJ3rJGgnn/zVPDmVWNkj0U7tQXe5/xi/OfAQvxDM7cOWMuLRb5Ci7HtWc4Qmrec4HS/gtpVWNQDbGtcrfGlV8Uie1wjuD9aazRoErs4NkIWXDplYMgG7/3QvQcj2xxsjm1G9seVUs7nNJ+eJl+LhL279Xdak/g2Y3l3FRzA9aUMYf24frAz11kZV4glBxu50XFLZeJKzJ/5V8b4WkzF2M+v4rCW9l15ESUNQ4JBe+IjcJEeujCHFCwzhij9Hc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2779b369-6eae-476b-c041-08dc392aecd5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 13:32:50.5682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CemdphvanWpr/cy2uADeh25LID1VjPVUNL2oXOFKwsyVWgVY7VOi1+ETUtRf4Kie5hTQVKuf+HIV8UBtZ+4fuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-29_02,2024-02-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402290104
X-Proofpoint-GUID: _OUpMuRvrI_B4H812VveGl6JnsLcM1-L
X-Proofpoint-ORIG-GUID: _OUpMuRvrI_B4H812VveGl6JnsLcM1-L



On 2/28/24 08:22, Sean Christopherson wrote:
> On Tue, Feb 27, 2024, Dongli Zhang wrote:
>>
>>
>> On 2/27/24 18:41, Sean Christopherson wrote:
>>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>>
>>> Plumb the full 64-bit error code throughout the page fault handling code
>>> so that KVM can use the upper 32 bits, e.g. SNP's PFERR_GUEST_ENC_MASK
>>> will be used to determine whether or not a fault is private vs. shared.
>>>
>>> Note, passing the 64-bit error code to FNAME(walk_addr)() does NOT change
>>> the behavior of permission_fault() when invoked in the page fault path, as
>>> KVM explicitly clears PFERR_IMPLICIT_ACCESS in kvm_mmu_page_fault().
>>
>> May this lead to a WARN_ON_ONCE?
>>
>> 5843 int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>> u64 error_code,
>> 5844                        void *insn, int insn_len)
>> 5845 {
>> ... ...
>> 5856          */
>> 5857         if (WARN_ON_ONCE(error_code & PFERR_IMPLICIT_ACCESS))
>> 5858                 error_code &= ~PFERR_IMPLICIT_ACCESS;
> 
> Nope, it shouldn't.  PFERR_IMPLICIT_ACCESS is a synthetic, KVM-defined flag, and
> should never be in the error code passed to kvm_mmu_page_fault().  If the WARN
> fires, it means hardware (specifically, AMD CPUs for #NPF) has started using the
> bit for something, and that we need to update KVM to use a different bit.

Thank you very much for the explanation.

I see it is impossible to have PFERR_IMPLICIT_ACCESS set here, unless there is
AMD hardware issue or Intel page fault handler morphs the error_code erroneously.

I meant the above commit message confused me when I was reading it. E.g., how
about something like:

"Note, passing the 64-bit error code to FNAME(walk_addr)() does NOT change
the behavior of permission_fault() when invoked in the page fault path, as it
should never be in the error code because ...."


Thank you very much!

Dongli Zhang

> 
>>> Continue passing '0' from the async #PF worker, as guest_memfd() and thus
>>
>> :s/guest_memfd()/guest_memfd/ ?
> 
> I've been styling it as guest_memfd() to make it look like a syscall, e.g. like
> memfd_create(), when I'm talking about a file that was created by userspace, as
> opposed to GUEST_MEMFD when I'm talking about the ioctl() itself.

