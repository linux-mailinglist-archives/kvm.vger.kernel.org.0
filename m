Return-Path: <kvm+bounces-10209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4094886A8F9
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 08:31:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E5B55287111
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 07:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E2D724B41;
	Wed, 28 Feb 2024 07:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Us/BG3oS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nAjkZhbF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193BA24A06;
	Wed, 28 Feb 2024 07:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709105461; cv=fail; b=gvMPTy4JLY5/a3X66F38Lhd4800Tn4uE8qDiGrVzrhsLpolig0/Fszz/ScOfSgCMlMeTsTTAtJsCOVGyLfCxlGZx32ePHq29Pf+ouPjemblEPax44pNEPCGhKbS8X/C664w52bk0rxLOQretKtwJsZL2/GTi/lm9rmch3S5LSCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709105461; c=relaxed/simple;
	bh=CyvkTIgNzyZykfnIz2JRo/pm3kxetbzcJ2/88+adHLo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZzxEj9UgYgU22ljww/74Tvw7zlDpAeUnfIQso06ITDMbkYNfwY4xF6Sjcbp+xBMTGF1XNj//UjZ/4lPoospS5AAPYHBIYytMsmASfx+AeXnTJKgs+XTqk/oGm6+9iOaZj6kGCtZLEnZf/uF68i5p2ndCC7SOZVp3lZbDtjO8hD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Us/BG3oS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nAjkZhbF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41S6iwNO010567;
	Wed, 28 Feb 2024 07:30:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=eDm0dySGDSy5fmrwXQj2LWBX3sy6Dm9wUmp4/hBs1s8=;
 b=Us/BG3oSDN5+823E7sL2nh25sciSPcMikXvRjjVzbitvyDY87r5Sl8vC65/c5D9qzBCM
 XWt6n4yVdnsy2P5TxVDY/nqgGyFRT68JsgTeeus0Zs3VSfBm2wzv5Oa5hNUufYW8aU5V
 EeRBof48crXMqMVG/6+wf+aSymeFYvvF9PqcjH+1qP6mJu2OaEyfjW4Z8nktD3qRNoUd
 rFPpZ03zsoUQtKvw4wSulIg99xqk4kyZLtgoFLK61k2rMqMyImFO3mfnYtPuovOPPhqp
 GrVvJm1LNCE7KG4S5za7viYsLLxSiwQQ/B0ML6PuenjDW39QVgwcvU0tvL5RRpnNCLLo mQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf8bb9dph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Feb 2024 07:30:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41S6NSVP015314;
	Wed, 28 Feb 2024 07:30:46 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w8pqks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Feb 2024 07:30:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPE6+uV8Y0yknoYtu4YiNzxvPbKIwvfQ54Ey+nBNpIZ0BMgMRVUEVNzLSLhAvQ3KIAVU38tVEQ0jTst7QBh+NhAmEu7jut+3RmsFWAL/n2zt+RDM8RfI9TXHKbjXqiKj36u+VF1AlBO1UPpV/GMbuJfVNPPYKunkaLOxDJ8UyVG3PEny6c9JEYfXdbrjuvlpRp4hbfXMFt5pqBTBXMJwA8suKhcormHdy2DzzEQRh+QRgErC67evjK5gawBsMV4xbC26Z/ivPqgOIGIlJShzc6HcDXe2Viqu/yrRfspRgxkYdgrzIbLIcgoEIkODnkQ4ivGvvlbzIhkOnK9j4LbKoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eDm0dySGDSy5fmrwXQj2LWBX3sy6Dm9wUmp4/hBs1s8=;
 b=QEekowC/a8EM/MS+OnbemzMzJH1c/1/Qm3Ij7mBuArg9DRTpK0gpWSF0Qz52TCWU2838pxVz4UyOcqo+jgsaEOAVj0gI2/XBdjcOdLjftjd/TPdxaAWWhfJt9qK5vglHycOoFGWa9/fMiZwLGfTQyX6l7B9EDTxsvlaE/O03vYjffTiwwm74HLiHsdcH1uHUe3lL0t2Z0eBivwnbp9B/s1yihtVTwEu4jcRDRycUahidAQtVd2XULKDHc4NCQs0LC56ZkgSyNQcggDgDByejm2FSaI5tLIYg7QnTwyPpT/b2pHCQ6pURtmvWKKSgbuwPyJe2ajO2KANKZsZ2h8YxpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDm0dySGDSy5fmrwXQj2LWBX3sy6Dm9wUmp4/hBs1s8=;
 b=nAjkZhbF9V4E5cdGjGl1Jv9IG++ueOL/Mgk7RMwSm2yPUe6lmAITmeN6q+CAvJpBKtTn7sqRn8R7exknkJnDy2+Z4nfE3i6/Hw+w4J7iPX5U0hqxweRBlv1dJePlbbdANL9HORCytYX5rzIAhukgSF60ZBqURpPjWmYSGk/hP94=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY8PR10MB6755.namprd10.prod.outlook.com (2603:10b6:930:96::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Wed, 28 Feb
 2024 07:30:44 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f%6]) with mapi id 15.20.7316.037; Wed, 28 Feb 2024
 07:30:43 +0000
Message-ID: <6c10e17a-b1f2-c587-fbdd-85d15256b507@oracle.com>
Date: Tue, 27 Feb 2024 23:30:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Pass full 64-bit error code when
 handling page faults
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Michael Roth <michael.roth@amd.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
        David Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-5-seanjc@google.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240228024147.41573-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL6PEPF0001640D.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:14) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CY8PR10MB6755:EE_
X-MS-Office365-Filtering-Correlation-Id: e83e3152-bc59-42b3-70f0-08dc382f2bde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	+fF7xle5zv9wsXmDXyZxxJbkUGb2dUd7BheYfn4NYjn3LyUjnomwtBVhnZUHu8moYxK46xnjItzCv9Wt6eljb8I8pYCoGo15wlcSg3BVXFTCOa6XOAEEQmTgRg6vJXx61gE+TvmUJKaOcVov8o4c/Mot5nI0vUXwI9peOSVo4DOVn2JjRx1o3T6qcCnNv3a2lYEhOshYf7U3de8GR1Zx5cNHHAHGxDLXyWqg4FYAoWWSBRJsfBCrdxl7OsO6/QJRFXjYCWuyluxPoHrkawgWZeyUK49ffjcP+08fwxhqmkUJaBtHfQh/IDmaFmW6cHrXJeSO18+QiCun+J27v/Y+vJB3yduN8Kv6yrEwLuqwDTGPD6WhzyNiJDbM76QpEH+TQoWzjpUdarO9m6GcHws6d5ueJEC0t9MlumEuh+ifMVnIS/FWozUEXkix5qmtrap/Gg0ilk6EDuHfzjg4A/02rFT+Iwx/v6NfMvfSi88Y7Ogonnm59tHrifChX7AYD0Ac3ggAdhvRIXFD2sTQMga4GzPlUxgvcp710/kUbFljro5tkYsegJ4seoiaU4b4qYNEV+NDhIxpjMVedSerokxSD1a0rCTtlMRZQrKxU3f0Kn30XG9cF30oI1sgpPExE04B
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VTMvNExESTNuaHNQUE1tM0tKV3VyMHB1M3NkcGNSendMMTd6TlYwdTk5ZHg4?=
 =?utf-8?B?VGJMVm16bllBSU1vaW03ZXhGdEE0T3cyakE4UFY4WkxScC93VWZlU3k0eWFw?=
 =?utf-8?B?cEVYQWJHMFQ5bk5sRElkaGpoVStRUzhGcHkwSE9JS3JhSkRmajZEWS83eVJC?=
 =?utf-8?B?Qkt6dVUzOWpCYkc5VElwemhIaVRMdW54ZWtBeWI1VmM1ZTBnNnFhRTRuY2l4?=
 =?utf-8?B?YXhGNE4wdmQ4ZXNhai92c0xZdm1sSjFmSC85L2l0a20xUVJtMHdZc0pmMVNX?=
 =?utf-8?B?aWF4bHd2U3B2aFg3VDRZaXc3RG9LVHBMd2F0Y3p6Sm00MXBkK0dZZnB2WnV4?=
 =?utf-8?B?R0dybzczZk1RYTRzMWNzL3B3WmhqRzdwL2JKY1ZtdUJSUzFCOWt0b1MzR1ky?=
 =?utf-8?B?bHB2ejFHeVg5K2I4d1hYYVpNcXRWUk93bm0zTFBjcGI5UUhrNVVYLzAzNWln?=
 =?utf-8?B?M1EvY2h4NGFhcFovM2JJY0xzYjhaZVA2UFdJcnVjc0lERVREUkRmbGJ4cmpP?=
 =?utf-8?B?NGR4NTczSHlJQVNvZGZCdmRYOHhSdWJHWW54cy84dkdsVGpUT3B3T2xEYjgr?=
 =?utf-8?B?NDN1dElxNzJXWTE1OWd6N0w5R2FyT29IY21ZYmp6ZEZQZmlFUlNjWngxdGhR?=
 =?utf-8?B?Z25CSEQzS1N6akttSzdncEtRRUlyekk3dTJVMXFqTnRYdm1oeCtBZFNvL0pz?=
 =?utf-8?B?dU9UdVFIVEgxZ21FSXU1bnRrQ3ZaWUR0bHdHNFBvU2NWOStmTTRFTzV4Y0I0?=
 =?utf-8?B?UjdYWDlRQ0xNaHRkaEozRHNOS1hKVXlWVkEyYk5yb2VQNE5xeWh6eExlYmNs?=
 =?utf-8?B?bGxLZnA0NE5xYjk3c2I4TTZPbkgwSVZjNFhSUjJnTVl3aEI4ZHJDa01WOUd3?=
 =?utf-8?B?UWU5dGVJRE9IN2tzekxlRFBBeFJHSnJoZDk3bE1ZMk5sSVgvSncwSVkzMWhj?=
 =?utf-8?B?aDI4eU9YeXVwRUQ0MXQxc1RwQkVJVUVYaWxvckpPYlVZTkNRQ0pHTDVVMml5?=
 =?utf-8?B?VnVaSW5TUTJLNzVaVGo3Wk9tRlJFRjI1UEpaOXVsOElpcWtrNDhVVmR4RnUz?=
 =?utf-8?B?MVFCZlZhdEE2RUEvcGo5U2ZBaFAxWjZvN2w5RVdSZWNwY3l3QS9vRlhGMzNr?=
 =?utf-8?B?N3VidkR5Wm10WFNScWlQN2tjNWZzRzNSV2U0d1gzUW9JRDZ5bytTTW11M1hN?=
 =?utf-8?B?VWppS1JvQjRnSGFacnVtZnRITkRTUnFsUlVNdHVWVjZWcjA4QVJtaXJDNEl2?=
 =?utf-8?B?MGdacUgrY2RBTDJxT1lwV3pFaWR6M1JwVHg0QTA5cGx1dnVCRlo1VytIdzgy?=
 =?utf-8?B?V3BnODlRZ3l2dGJaSkMyUVVTenhBYnhnQ3RMRVFzZlIyK0RMalBldDZRYkNn?=
 =?utf-8?B?OVV3UmNrS044YWwrWmRpN3doY0tacVBhMGZlWHhiTTJ5dElaOUhjNHcrWnRO?=
 =?utf-8?B?UWVaTTJEeHlnVHJKUW9nTjFPcHc1d05zNUFMT0MvYVNpMWUybnV4SnIvV3hN?=
 =?utf-8?B?MUd4ZXdLSHpzY0JKMXM1VTV0Wllrb1ZOQ1YxM1E1dWxZKzFpTyt5Rkg2Z3cv?=
 =?utf-8?B?Z0RZRnlNUmNnU25idDI4ZnhxWlBzMWM5ZktHMHFaRkdpR3dJbmdRQ2hRYXFN?=
 =?utf-8?B?SzJwL2tpeDZhbC9KVisyYy9SL243cGMzRFA1QzRmczkyUHhwYXFMa0U0azdR?=
 =?utf-8?B?K1Q5UW5GOUNWcGlrbHRVOFJIMFUxZWtLc1p3dkpYS2xUdXZJd1VibGNicDRx?=
 =?utf-8?B?Ky9jS2F6UGVxQVROeStWdzQzcFdJdjN1bXp5R080NUprZkxFSUNqa3BLMVky?=
 =?utf-8?B?Rm1aV1ExSG4xUlJGTTVXUHJtbGVpazRjdEJuQzEzR0p2OEozbWdWVlhwSmEv?=
 =?utf-8?B?QkVvMmRIeUc3SnkwK01mMitLTUdydzNUd0NtSEhwQW5QQ2FXN2xTdGJvdC9E?=
 =?utf-8?B?RThQNXRLRHZOU3hLTjEranBwZ1FTb0VRQ1d1dEczQ3Vvb0t2c3QwallBVmUx?=
 =?utf-8?B?UUhIYWxHWmN5Z3huRVkzYkpnNDIxczc0UnpOVnFGcDlXY2IvZWV1NVJrV0dU?=
 =?utf-8?B?NjI0ZFBDZnF5QTFaK083WWwyNjRRZW8wZU9iRkVmTHdFL3JLTWh5MmgvVHdq?=
 =?utf-8?Q?iFavyZO/v7ALpx6RpvvCgttff?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	DzvF1/ctutQcOqp2mpLMddFVaWKB02cC1QY9X1Ee7wn+N9e4v/l7wd9bpfJXswGJwEhYdDnFKiYajoO+kIzQ/aHrJV0pLkbULivs263l8R8tkd7iRG7Pvr8p5NhoICEcYxYnX1B7ksnqhm4mverk2qSztTkBaFR7jdEhf9jdTZge1NojUTylFkKyQxJwcAuTv7WnIC0yhVgq6X0qnndx8zRa3s8OA6vJYOZztPAyL3R+BHFbn2PyV/O+M7IKnpTxYgB/fEmK/58ReoMs08CiZiKRWLIXa48ciFitsOI9QuTnoX/zNyGWKE4xj/RbbWjyDr0tKAlZpc2EHVeUlLeXjAJaflOIVMYAD/6eF47LaPg/4Xs8e2TikPRBnqDineHL8niqJbd1llPpzOO1SQmT2l2MctCF+kHr5zjtwLXyLlBTT76IbeXN4mXlkpiGfHpK+ZPJ+lxVA3nqu8k5QTuEgFs/67KTu2PlkA+UT4SlLt7oMRrcL91rhN9qpzdhc1tdRc5omPkZ+qlOPcf3YbSWEup5n4UqMdE3px+j1FgU7XaOc6FbQNRSJxhfbhCe2CKAGI4/ofAMsNzbEUdhDl4n7a+t9rlhjsNdmg1hvRI9Wtc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e83e3152-bc59-42b3-70f0-08dc382f2bde
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2024 07:30:43.2440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: grHgM4QaH9gICXRCaAL1Coj52K+Ta90BZXgr8G8KJlkjlbVGyZAhM2YlQEwN/tiSYRGLcVQEaZ58ma5b9jfazA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6755
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-28_04,2024-02-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402280057
X-Proofpoint-GUID: lMIdfnMGhTitj34wovhOvkZPmyK9WWWu
X-Proofpoint-ORIG-GUID: lMIdfnMGhTitj34wovhOvkZPmyK9WWWu



On 2/27/24 18:41, Sean Christopherson wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Plumb the full 64-bit error code throughout the page fault handling code
> so that KVM can use the upper 32 bits, e.g. SNP's PFERR_GUEST_ENC_MASK
> will be used to determine whether or not a fault is private vs. shared.
> 
> Note, passing the 64-bit error code to FNAME(walk_addr)() does NOT change
> the behavior of permission_fault() when invoked in the page fault path, as
> KVM explicitly clears PFERR_IMPLICIT_ACCESS in kvm_mmu_page_fault().

May this lead to a WARN_ON_ONCE?

5843 int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
u64 error_code,
5844                        void *insn, int insn_len)
5845 {
... ...
5856          */
5857         if (WARN_ON_ONCE(error_code & PFERR_IMPLICIT_ACCESS))
5858                 error_code &= ~PFERR_IMPLICIT_ACCESS;

> 
> Continue passing '0' from the async #PF worker, as guest_memfd() and thus

:s/guest_memfd()/guest_memfd/ ?

Dongli Zhang



> private memory doesn't support async page faults.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> [mdr: drop references/changes on rebase, update commit message]
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> [sean: drop truncation in call to FNAME(walk_addr)(), rewrite changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 3 +--
>  arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
>  arch/x86/kvm/mmu/mmutrace.h     | 2 +-
>  3 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e2fd74e06ff8..408969ac1291 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5860,8 +5860,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>  	}
>  
>  	if (r == RET_PF_INVALID) {
> -		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
> -					  lower_32_bits(error_code), false,
> +		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
>  					  &emulation_type);
>  		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
>  			return -EIO;
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 0eea6c5a824d..1fab1f2359b5 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -190,7 +190,7 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
>  struct kvm_page_fault {
>  	/* arguments to kvm_mmu_do_page_fault.  */
>  	const gpa_t addr;
> -	const u32 error_code;
> +	const u64 error_code;
>  	const bool prefetch;
>  
>  	/* Derived from error_code.  */
> @@ -288,7 +288,7 @@ static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
>  }
>  
>  static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> -					u32 err, bool prefetch, int *emulation_type)
> +					u64 err, bool prefetch, int *emulation_type)
>  {
>  	struct kvm_page_fault fault = {
>  		.addr = cr2_or_gpa,
> diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
> index ae86820cef69..195d98bc8de8 100644
> --- a/arch/x86/kvm/mmu/mmutrace.h
> +++ b/arch/x86/kvm/mmu/mmutrace.h
> @@ -260,7 +260,7 @@ TRACE_EVENT(
>  	TP_STRUCT__entry(
>  		__field(int, vcpu_id)
>  		__field(gpa_t, cr2_or_gpa)
> -		__field(u32, error_code)
> +		__field(u64, error_code)
>  		__field(u64 *, sptep)
>  		__field(u64, old_spte)
>  		__field(u64, new_spte)

