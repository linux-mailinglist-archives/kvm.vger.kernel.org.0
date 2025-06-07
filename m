Return-Path: <kvm+bounces-48700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6E96AD0FE0
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 23:14:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5AC316C1A7
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 21:14:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 680952135B9;
	Sat,  7 Jun 2025 21:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sHLNfznN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="O8o+Pr7S"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4B41482E8
	for <kvm@vger.kernel.org>; Sat,  7 Jun 2025 21:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749330872; cv=fail; b=BgfVrn/WVhLWczn4jgIk4pL/BsiCChF07UVviTAOMB2fRfmd/ox49lfYSXIqArnQh7JbnC6Gm903To1SpwKhkBAa9pPLfI+a205jtRtWmZ/3C/PetQeuXTgjCtYH1z1zeceMQFaohplUwXimJOyPxB1Cd940wnS4O9D7E+nn2j0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749330872; c=relaxed/simple;
	bh=RbUEvy8pYLTKXXtBYiy4/U8Dsr03iXPfGerc3uNDj+4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p96jQRWt7/8v9ZEleqAiU+bYF7huA7jmp5YpZ303LJvktQXVVJidOjRrx82t/t74ow8v8PM1cYC/Gf3/vQBesGhqdjk2McBnJCMtx64raIxjPi3fCvMdnAAIPvqy4jENSYzr6otrdPOc4Ht1mz+adRNoGZOhy5N3KTDW3GrQCrI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sHLNfznN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=O8o+Pr7S; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 557L8hJF010610;
	Sat, 7 Jun 2025 21:14:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+7wJhL/KawaDGPe2ftuVnHQyPJ1Zr9I6m4QcayRLYUk=; b=
	sHLNfznNtHhYSELIP6VDm85xniBATQFFGFsu4qK3EytQoujDjjKd1MvnnA7qDMa3
	qyfHXS3hoaGAcuZ5wR1yCEtYuwPv8ASfoWC/eYWNRSDSPKWggj+cx4p4jUID71o8
	kfO5TfDT9jPQblrJukA56deZDub69Yl2EqKRJreUvlo1xlLTRYmSa2Vbt6XvEmuN
	YyFbAYktAj5FWvi0yQoVyzQOqiCBMI3TR3CAEQYyc+eDCGzh/3/A0LMgUuGlRGnO
	MY9rB2lDTEoPYh2wYd7So57y9/B5zklss77JeelhcHhCFK/A9YcNRqDTOdwjTtI2
	Wn3EVvF4WPCiVpFdDzyYmw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474buf0gcy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Jun 2025 21:14:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 557HsLg0003964;
	Sat, 7 Jun 2025 21:14:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bv67735-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Jun 2025 21:14:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MnHXppRb3luHjPolpcLC9u+0RMHH598exKpYQBuesEtIK0M5fHKum+bfZItk6/4DzqsQ6XQxqut4V7DFDUcf6mor9qGjuIYP7aPUgNZtTqYpTAkntztDVzQezRI3I5yUMMKQxJlTdI7xE1jafHpZgZVKJCfIstTlZ0HB/7pIZ0kPnLu4i/yuwm/2atBgPSqYmKYI5glIa9u9bZt8oCwJtBa0vdntvtBca7WfJz77rjRHKZQxVlrB39z42+Q8sT9cPZp10Cg3eTDKlyXLw9/ohsC4S8oDuCPCKkzHTfInRlK8iV32OnHlYyxWrOq3nrobjg8CS6A2OXdFgNb5ES1W5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+7wJhL/KawaDGPe2ftuVnHQyPJ1Zr9I6m4QcayRLYUk=;
 b=HGEbeNG6njjgofM6O9BiwP93JUIy8RenD9JrpzbrQr8vnCU3nMv4mW2yGOgDptlLBeHaSZ5Xp3cp1Jq3eQ1NP0wl8HdCcm+HfB3hqulUzyojwad7RggAxy8sVpSHWLYWqb/KiD+k4EnFb0rJwbWDUZLdXElitTZ2x9J4ppc4gdVAqDDwzmHqnmLWneqmni/GlqgBZre3meBnLxtZ0qjFT/uDs0k8XuvuwxEu653PnvwPOOaVKpnf2dFTB4irS1q9u0Zkq167lf1/k0UN1wk1bGpRv9kVuCb16nFRl7zZkEhlP37AJ9laENrKE5ACvHL+YsPe0iQP5v8fya/ejwdLhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+7wJhL/KawaDGPe2ftuVnHQyPJ1Zr9I6m4QcayRLYUk=;
 b=O8o+Pr7S/qfx7jj2JDVLC9tVzi1h831xjFe4stGz6xcvr5Pq4O+Cw+SRa+xmHCxAwcQeN7gZX2ypM6Q1CnMdUBmfTtdMlvhSckKWaR0SWAADuq+zi+0ISSJ/cV49EJZiNn6UzvgyK45y7PCR4ZgiY6If/Suyxl9B7NjiP/Q/YY0=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by MN6PR10MB8045.namprd10.prod.outlook.com (2603:10b6:208:4fb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.22; Sat, 7 Jun
 2025 21:14:17 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%6]) with mapi id 15.20.8792.033; Sat, 7 Jun 2025
 21:14:17 +0000
Message-ID: <e20ec5d2-d54a-4367-a885-578ebd2b6c7d@oracle.com>
Date: Sat, 7 Jun 2025 22:14:08 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] KVM: Batch setting of per-page memory attributes to
 avoid soft lockup
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, tabba@google.com, ackerleytng@google.com
References: <20250605152502.919385-1-liam.merwick@oracle.com>
 <20250605152502.919385-2-liam.merwick@oracle.com>
 <aEG-bmjRgqlxZAIR@google.com>
 <03b2e404-afa7-4b12-bcc8-ffea92fe088b@oracle.com>
 <aEHrQpvN8CtES9je@google.com>
Content-Language: en-GB
From: Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <aEHrQpvN8CtES9je@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0046.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::20) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|MN6PR10MB8045:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b2c64a5-4aac-4388-6bad-08dda60842e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b2pwRFc0ZzZKaGhtZDNnSzk4TlB5MzhXSHpoS0RFZWVqUURjbUU3RFRxM1B4?=
 =?utf-8?B?TmhHN0UxckJOL0c3WFA2RDJQNGFaeDVCc2tSZGRJTEpqemRqdTFsbkIzQjU1?=
 =?utf-8?B?WEErZkpIK3BzNFdJZGdwTWgzK1R6UGw3bllKYjZ6M1FJbmhmVE1kT043YTdN?=
 =?utf-8?B?d2RHQXErb3lEVHBPdG5pVDBRTzRhVUxodm1oL1V2NWxWSmxZMyt4N05LSzZB?=
 =?utf-8?B?ZFVJdnVqSUtPSjFuUFdCT1drZHMvQndiNmx4RENDZENGSkprbzE0bjlwV3g5?=
 =?utf-8?B?djJIOGNac2NjSXFLUFAwdUJmWEtZZHBtdnhoK1Qwd0ZGSHhKQmhmWkFRd3Fk?=
 =?utf-8?B?cUY2MytxM2xBKzUzcjdVLzhOUDdQdDNYZTJtVy9hZXp4b1lDbTRQUlZiZXBV?=
 =?utf-8?B?aC9pZ1ZaSXkrT1g3N0F4T2p2NHBCSnRBd2lCL2lhMk4yOXBtaURCTU9PcjhT?=
 =?utf-8?B?a1VhcUJidDZqZ21keC8zN3M3SGpaNDVDZVFqL0xtRDk1REJsVW1rNjliTjU2?=
 =?utf-8?B?UkttK21SQVJnZGVMWGZnT3ZBVEZWUEF0QS8zaHpSdW9ZeXkvWjhzNTFlRGI0?=
 =?utf-8?B?bjdzaWUyRUxqcVFEQkZvamJTSGlITDJEMlJqMFZkQkRTdloxb1Z6dmd4T0VG?=
 =?utf-8?B?MEZWNzJlRGE0WHlYTVcxNmlNMHB1dlhWZGV5NzlrQWFRZmtOUEFUWkZTRXdE?=
 =?utf-8?B?amdZRXNYWDNkZGY0R0p0Ny9qQUM5WStlamR1NEs4dW9adE9EV3pLRC9QSGlm?=
 =?utf-8?B?MW9GbGFuRFBqWXJWU2Z6SDZrSS81VlBnQk41Y3lMY3prTGl6VkVrSUtPZFRr?=
 =?utf-8?B?NERWVGtSRmpENWlNZmthTFo4NTMzRlpYYjF3SVJnWXgrRlNwRGhtYlROU3c3?=
 =?utf-8?B?MkYrRU4yR3Vpc3ovc1F2bFZ5RHBSWHEzVW03WVE4dG5zenhZN1h6OWFERHBl?=
 =?utf-8?B?UXUvZ0dhR2NVa0FzRTQ2eUMvbmZCdGc0bXRwcXFiYXc5K3pzL0Z2czZrcHRH?=
 =?utf-8?B?TDFJS2JVVTJ4QmZZRktjMktsSmdtdWZpNUprSEhiZHltNzV0ajJHN2Y1ZXlu?=
 =?utf-8?B?TXNUY3c1NFRwWUNuc3lWNWJaL0dCV2tPQUF2Ky9NN0VISStKVExnenRHTmha?=
 =?utf-8?B?VGlDZTF2OW9KUXZ2cnBOSVc5TmhhOG9OSzNsRXB4RzZiNjVXQW1DalNoTlU5?=
 =?utf-8?B?NjYwdERSMDlDcWtWQTVvalhWNy9qcXU5Q2JmWVB4aVJEdG94eDJadXBjVUQx?=
 =?utf-8?B?U0tTRVJORXV1VWdhSEFFd3dZcVpVZFVLRm9RRXBwcHl0bzFBc1pGVnkzbjI4?=
 =?utf-8?B?STIwYXM1ekdnSXhSRG5TSi9Xb3NPT2UzZkRySXBtdDBqcVFmMGFFYmI0eG9K?=
 =?utf-8?B?NUVqVmNyVTdtK09LSlFvT0lPQjJxY04vM1FuYjg3WXJUL2hCT2UyMzN5YU5F?=
 =?utf-8?B?VVlwbUhqQzl3UHpqd0pZcDF6VzBTeEI3dTd3c05RM2lFdnBzVVFNc0g1c3My?=
 =?utf-8?B?MStEUlhYY1hWMUovRVMzZ3pud3lJRk9SOW9ueEpKSFFNWEtYRDZ0YWRUUFJw?=
 =?utf-8?B?L29QQUU1VFZHOHFUblkvblJjVmFGV0cvQ2F2azZUK1daS2I0eVVRWnI5bnNK?=
 =?utf-8?B?T0hvWkNrMnBMaUZGeXVXa1Q3L1FncE4zWlFRZzF5L3Q1MnpnVzZwNFZmOEhh?=
 =?utf-8?B?eUcxd25UU2hmL0sxbnF2QVd0S3krMkwzTnkyYVhyaERJT0JaQzI2bFQxSUdk?=
 =?utf-8?B?MUVFR0FDYXRoeXUyUmszM2VsZjY2dHhhRjFzdGJpYkZZcnptc2t0R3NyNmN5?=
 =?utf-8?B?RTA2TkZ5cS9JaW8wcnM4UmFiYk9qNFJzaDhac3MwTW9ma2RwTHRHMjZQNDI2?=
 =?utf-8?B?Zis2RVJzOEpDTzc0ZkdpOXNiQlEyZTJXTllIRWVhbnBaS3lic1RIS1hObDVh?=
 =?utf-8?Q?14Bu0yiO/jI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ni9va3RaNHZwZWZUMGpTbEJaZERDWXUrVVEvZWI3MUFnM0ZKb2hndmhWYndz?=
 =?utf-8?B?d0ZsbG1EaGRqeGxRcjVlODNVODRmb1EvdFBhUGZpcmF3VGJoZVA0QysxTm9l?=
 =?utf-8?B?b2VLUTB0ZkJTN0NVdnlpR2NtR3QrUmRuNHBGWWdmQ0U3bzhXSGk2WlNReGN5?=
 =?utf-8?B?eUZoMXpPd2xpa0ZUVEgwZWZ5WjFsdXFwaXRCeFEzOXRPVlN0QWp0QXdsMnFM?=
 =?utf-8?B?eWRablJpZ2ZxNlFWUmZBVUQ1WXhEYzR0SGM5RHZzK3hJZ3dYSTd0d25DekVN?=
 =?utf-8?B?VXg1R3RET0E1a2RYZU41NFFnZFAveWZxeDlCVmw2Vm03SnhiZXhjV3VwMXRj?=
 =?utf-8?B?MlA5UnUzNzJUNXFRTURMTkljeFdxTjhXcWRwMGVzYjRvdFB4bkEvZ1VsV09r?=
 =?utf-8?B?ODc1bU9oWUVmdHErZHAvMEhtM1Q3M21tRzc0ZFNGYTNiKzhFcXRQWHZxSUdK?=
 =?utf-8?B?NW1Qa25HTWpnaEJiOS9LTzE5SkJscEpSK2ZMaFJOdEVOMFVWSzF2bi9ha25H?=
 =?utf-8?B?d3VrRmEwSEtYQTM3cmVld2ZyUGp5YXRDT1Q3czQyeDVQb3FKQjByRGh5Y21R?=
 =?utf-8?B?RUN3SytYU3B4YVFZaXc3TWc4d0ZSbWxOVHVsVzJ5UEU4ejQ0SHlyWWRHem9n?=
 =?utf-8?B?Yi9qaUFybTI3N2JZUGpma1dOK1c4anphaHB0eStMYytqUFkyQ3U2N2dPMFpK?=
 =?utf-8?B?Mm82TWFnYnJzUS8zdXV4ZEtNbld6UEdQc1JpdVlQbERVbWVJMDVEaHQ3aEJs?=
 =?utf-8?B?UldKQUFlWGxGanhvNHpIZVJ4MHhHWUE3TlNUUzhvZzlEV0FRMWV6MlBJdFpE?=
 =?utf-8?B?aXYzQ0M0NkhtQTNIWExYVkVoc0RFZ0dTbWF6TjlYQmdtakdCMFNLM1hLWkNQ?=
 =?utf-8?B?RnpRK1RYN2pjdDdwZFZzbzF4VkpvdHRuSUU3OHByaFh6QXFSNWN5YVFEajl6?=
 =?utf-8?B?MUhJNi9TQ25Jc2tHWlN0V01mTWVlSSt3WUsrc1JKd2RKSlpkQ1Zhb290cnRk?=
 =?utf-8?B?NE9VNVhlYkkxekVKNmhTY1psZG5kOTRRVDZ5TGRWRWVmUmMxdUgvQUlXWEZX?=
 =?utf-8?B?OHV2em5LT0hTMWl2cWxiN2RGb0UvWWthbjFCenlYT1hkQll1RXVHOVlKOThG?=
 =?utf-8?B?dkdQRmUzbXpmd3d4azFsTC9VSWtwK2NseU1pMFFtVGQ2Vm5xZlhXSGs2dDdv?=
 =?utf-8?B?blB1cURjRUNVOEtBQk5ZcmxMbmRXV0JHelQ5bTFvTk1XaldTMTIyazUwYVNE?=
 =?utf-8?B?bzJXVk1ycTltM0xLY0xMNmYyZG1tZjNoaEZkYm05QTM0S2VoMmtMRFladTBF?=
 =?utf-8?B?SlZXdHRtblRha25meHVFT3pDL1dLTFBlNTNPZnNCdTJQaEE2ZVhadTNaMzBJ?=
 =?utf-8?B?RFRZT0FpNDBKbCsya0lFTnVpaHR4dXRvaStiYzNsUEtTaTJMMHlyek9oSjVV?=
 =?utf-8?B?MzJRazdJdnAvYWd5Zk04NDM3cVNEM0lhUXRKUmZkRlhuOHBzaFhQRFFsVFlu?=
 =?utf-8?B?aFBOY0x3WVBaZmhaWDRuYU1mMnF4ZUVVUFNJcWhMdW9kcVZDM2ZKK2JPWWNj?=
 =?utf-8?B?SGFqbEhIdnRRMm00eng4aS96cmk5RVI1WUJiS3FqVkNlamlxZ0FNcUdDQ2NQ?=
 =?utf-8?B?REM4MnQvTkgwVHh6Vm5ORVo4VEt1WGREUWpmR2pjOEl4RnFTTkIzeGdZWUw2?=
 =?utf-8?B?eXUxdHlhczFidkFiZTY3cUlGQkpsWC91cS9lQ3lQdFhMUkRyR0tQWEo0RHhp?=
 =?utf-8?B?bzhrNWFXOWFVMFA0OCswRE5wSXhjMU9FSUk0T2kvdzNGQ0E3NGpMOFVoY2ZH?=
 =?utf-8?B?d2xuQ2lqQ2pnVjRPR1o0SkRMaU5uQ3k2OTYzR1pRL3NpbVcxbDQ2QnpDOTJJ?=
 =?utf-8?B?Rk1XR1pJTUdPZzFFN0IrMnRQSXRBbHUxTTFWZVAzYXY4K3B6UGp6ZEdnTG9F?=
 =?utf-8?B?L3FNcEYwYzcvU0ZqZDAvNG5zMFltZ2dDeHAwK1JMNnNvQzdrbXNqRDZ2d0JH?=
 =?utf-8?B?c2JNK0F5R0d4TlYxeFRFdXhTRXRPWVpCOFAvRWVDbVNxbWl1MnY3YXFpL2ln?=
 =?utf-8?B?N280ZzhRS0hiVU4ybDU0R1hPdWRTVG5PQ0ZySGl1VFkyM0pWRU96bDd3b1dp?=
 =?utf-8?Q?7N7AuVMe+4NZK7xZ+zIabXGsb?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BA+T0elm3aCGRWzCcYUinQ6pKncysFUDHjp0K31IDoR5P+fnTQXO/MsIdWv5PWGvfXKXDj/usaB1u79WGmHbBTvqdOgnnUfxHCgzeGSTXVL6uhVGZKCiaSO3zCuLR09UDN79RVsi5h+oajEC1SmVpwW/d9PKOyXCL7tOUCg7TdOTK+dq7sOvfVFOTvLqBQFaR5iDIbsg0A/ma0QM7jjaBvKcORx+FzEdGmGBoADCJbYtzDCTwbt8acINQDF1QvFJd2UTJVY4IDJYt6NJqdXYFC8okr+NPRt5LCRsvVAAPbuV7s/l8e08zUpCbDtslUIPGJH1taXrd5kn/Z14o4EKMJYkgwAnx+qWmqvQ6Sd2HTHqF/VHehtIHto1C6qa8qvZN3fzG/yLJ+SpsHkZ02xxvwDWjSz5AKxCLOVGRZ0KJ5DzpqDkEO1FjMeHcErZqbn9wCpOEKjyndlbIMDUmbPFT/RYmda+2wmtqmvverXAxHttHbEVDcbLqOZObCipjtc3aKaCeu713HJ1sh3TZ6vFv84r/jOdWy45WvbKT9ODUSBhE30b7LOvz0j3Yb2TTLab6NlqdLNBpwbeRHfPBnvWAxg2n+KN4kajZN08RuYEuu4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b2c64a5-4aac-4388-6bad-08dda60842e5
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2025 21:14:17.2215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ofLmsfbq+dgXW2QNbeSbr/dBduELy7TilffMaxBGtD75Yk3eGlGACT22aySsE0IRYdr1Yp/lTwUKv3znZJ/Cwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8045
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-07_09,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506070155
X-Authority-Analysis: v=2.4 cv=RZGQC0tv c=1 sm=1 tr=0 ts=6844abb1 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=3s1eEnmg6PCB4sTly5MA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14714
X-Proofpoint-GUID: gLNOJBCcQQ7DVsvAfykFxDyYoA9_fvto
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA3MDE1NSBTYWx0ZWRfXw7Qp5Z9i8eb0 wfjZYXqUusdaUikdQdqfHSsCE3tpAaZE7zL4BAEPde4maekhdvKzmiFSJWvfD960sZFJxCK1tcv 8eDU2ZZ8qhcvdubPnSIExMd6yEmy1bHGSBYQj84tEriNuqGgPLrHT36XG2mkYpqpeVJFmdD8IQj
 h6G0R2Q6YvPV0ErhrANj4jR4bAZCbnXTw/1snf5Gws0Wz5tPeYNs9vodu5UkmyPv6xJI8B+nuET Gl0h8WG4xtz8B31LoG70q4kwr5YRoF4NJ/EE0ZbqoW/1J9/r9CR/Vl0Ag+XKx7mmRO0/8mfw6na 5636ZiwN7o+8sEXQP7f+LQOfoBzPQ3J1jmDEdBoBhyrD35Ke0FpIg+8desKS1r91aDKL8yyhly7
 YO4f4H7+Ih1aC6COIpPqn/3i/EeoxoBmtzSPCCT3LhL3ZaKihM+o0V8nWMKBZTVwkkN2bkj+
X-Proofpoint-ORIG-GUID: gLNOJBCcQQ7DVsvAfykFxDyYoA9_fvto


On 05/06/2025 20:08, Sean Christopherson wrote:
> On Thu, Jun 05, 2025, Liam Merwick wrote:
>> On 05/06/2025 16:57, Sean Christopherson wrote:
>>> On Thu, Jun 05, 2025, Liam Merwick wrote:
>>>> Limit the range of memory per operation when setting the attributes to
>>>> avoid holding kvm->slots_lock for too long and causing a cpu soft lockup.
>>>
>>> Holding slots_lock is totally fine.  Presumably the issue is that the CPU never
>>> reschedules.
>>>
>>> E.g. I would expect this to make the problem go away, though it's probably not a
>>> complete fix (I'm guessing kvm_range_has_memory_attributes() can be made to yell
>>> too).
>>
>> That indeed works. I couldn't trigger anything in
>> kvm_range_has_memory_attributes() but am limited to about 2TiB.  I'll do some
>> more tracing before I send a v2 to see if there any more places that might be
>> close to hitting the limit.
> 
> To get kvm_range_has_memory_attributes() to fail, I _think_ you would need to do
> a large query when the attributes match a non-zero value, so that it needs to
> perform its slower search.
> 
> Ah, actually, I wouldn't be at all surprised if the issue is limited to insertion,
> or even just to the xa_reserve() path that allocates memory.


Yes indeed, the kvm_range_has_memory_attributes() operation has a much 
lower overhead. kvm_vm_set_mem_attributes() has that outlier of 99 sec 
for 1.9 TiB

   kvm_range_has_memory_attributes
            value  ------------- Distribution ------------- count
              256 |                                         0
              512 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  966532
             1024 |                                         9781
             2048 |                                         1355
             4096 |                                         2449
             8192 |                                         843
            16384 |                                         240
            32768 |                                         3
            65536 |                                         239
           131072 |                                         2
           262144 |                                         1
           524288 |                                         3
          1048576 |                                         1
          2097152 |                                         0

   kvm_vm_set_mem_attributes
            value  ------------- Distribution ------------- count
              512 |                                         0
             1024 |                                         2
             2048 |@@@@@@@@@@@@@                            1496
             4096 |@@@@@@@                                  813
             8192 |@@@@@@@@@@@@@@                           1621
            16384 |@@@@                                     432
            32768 |                                         12
            65536 |@@                                       239
           131072 |                                         6
           262144 |                                         4
           524288 |                                         3
          1048576 |                                         1
          2097152 |                                         0
          4194304 |                                         0
          8388608 |                                         8
         16777216 |                                         0
         33554432 |                                         0
         67108864 |                                         1
        134217728 |                                         0
        268435456 |                                         0
        536870912 |                                         0
       1073741824 |                                         0
       2147483648 |                                         0
       4294967296 |                                         0
       8589934592 |                                         0
      17179869184 |                                         0
      34359738368 |                                         0
      68719476736 |                                         1
     137438953472 |                                         0

(As a test, I also inserted an additional call to 
kvm_range_has_memory_attributes()
over the whole range of memory with a different attribute value
and didn't hit any pathological behaviour).

I'll send a v2 with the suggested fix.

Regards,
Liam

