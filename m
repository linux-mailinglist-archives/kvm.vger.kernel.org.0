Return-Path: <kvm+bounces-63249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1E1C5F0DF
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 20:35:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BD93B4E70AD
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 19:31:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 819162FD68C;
	Fri, 14 Nov 2025 19:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="typ2I5tK";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="HaBeNg2W"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678812F3638;
	Fri, 14 Nov 2025 19:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763148662; cv=fail; b=ZdEcIq8d6ChaxfOhikwBf1Lz7iiaWwwV2xAr9XxRmHOUn6Ikv/6reSA5i8zvvmJaXuAyWfkXW4JQ4mqdrSvKJkgb5thfEwcgh/3DOQQk0ehvD9cnSMI4Dh6wgrmOEQm7CF4TIlGnYrVDC1K461D56dWAIfnzpGCrzP3viWt5gBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763148662; c=relaxed/simple;
	bh=tnSxftJaibJdnD+awIgiYWDk90TRBKb26GQDkVeeaIA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QkwVJDBJWz0KZWu+cpgGKBRrnqI9EENSa7aQulFngclmUDiwFb3sK89TlXCvqfpZ/cZf5BtsBN/8LHTpT0J81ndggtqdx5e2jJDTh3f5qQfRKb5brGoOmGby5nVzmWeMvUesjs4VByS6+ejhn59oG6WrXN86UXTaIPa5w5ODoZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=typ2I5tK; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=HaBeNg2W; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AEIllP9068145;
	Fri, 14 Nov 2025 11:30:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=tnSxftJaibJdnD+awIgiYWDk90TRBKb26GQDkVeea
	IA=; b=typ2I5tKI6S7BQYcd3s+LMuh7sCAsLPbbNBbY8KGe0QZxtm3Ir6ZzKnZW
	mK3wHDu2QDuEOjeIGv7Jr8SRPamwSfUeCteeRZPxczsRBS/ibd6rZuJscO0bJ04p
	B6a3qrR1O58aGq2PeMHdld09DoPxgl/33ePv07L/Oc84U+AIw2nAJAIIvUOYuTkH
	gW+QzM+640lxg3eyS/xp13CG7tDaQQ4WSnQlVVLSEcNEKvRP42TJNqbARoGS365J
	Kxqlzzk7elVL4O2uCcF8F6WLTxSys/SRmLnWrPl3sNCbTN6fb9gzWL1xKYOMWO1G
	54N0L3LVR9Tb1CfQN4eEhIp4Vp8IQ==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020104.outbound.protection.outlook.com [52.101.61.104])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4adq50tgf8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 14 Nov 2025 11:30:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DwvHgVW71ZJfVzYRe2dLVeKGMDzIu6MHbk81Zhi56qLMgamtx0kO8GOjsAP6W/Eg5pQpjldVYc96cK9XZxSlPepcvSQDbjgqQUDEGRELPpRgG/ZdAMx9C6jK53uJA247pe0tYXeFfRtxn3T07z/m8VIpMHDMideztgC5Bx2CuvnEmh57fFeQQ/lZqaX6kUdXHsr64U22zMFIXwOyyukzyN+HVnD7FxIykCSdhfkufPjwXbV2P8vInL0+kejh67YfuFEEi/kxpnWaS7ZGvu9iIoGOX3xldGlD+ScTzrKj+QVDBf/3wjRd9OTD9eNJekIDncntDbc2QHosAfzNiyukng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tnSxftJaibJdnD+awIgiYWDk90TRBKb26GQDkVeeaIA=;
 b=OnUGmmTvAGLnRzcwfLbrAexLbjmYBEQWD+tuoR2L8nnWdQu49c6h6fM9VbbasfomLNyvEv11TpxpJ8rUUgcPkTGqBOBEJPG1IJlbXPoGTOxf3qflpqxOnYui75bPAcrZE6W182nk4IevsbIOIQa2JVn0APjQvOq7wkh6V32l9UpNFM80yMlWmCdMVWAE+TZgmmJcifDSasKpf0bHNtvH7xF/UpTpazBwYmkvovMoUiuQdiHdBIAFa6mD+vix/9p0C0YqDevSaVoJLITwspgoFSqsBOf6I3kNRU1MKA9vSSAZk68tyMlEF7k36JHm0QIJL4kh4uFgoboSM0oOsm6rHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnSxftJaibJdnD+awIgiYWDk90TRBKb26GQDkVeeaIA=;
 b=HaBeNg2WuXenTuJOeu10e0LRW9WDFFJxJXpoEJY8VdtfCEkHz608waH1l9cWKvzryEwvH4iUP9/JlkawKmOgQgOuVTaqhTMFDVoPk4z7LQkFp4NC/yIpNEarhs3RDTm5UNDhK0sqOwnL9syqJ/IB+BcJMjLeS0Xso4s2lp0VSHPTEUIhh1wgG/E8WXDsStpbmir7KdM1iu6PiaFEeGgVlVx1gd3ANyRCsXs6pK3oOSYmcSdPc427km7WtFZJxFO3PVyYIBy6WANv3DcWzsjqx1YiuL2xRI/iKBDCEAGN1P2/3vEJTq6WcrMZtZNBm0phfTQgJ8drGjnkUIqJdUh9ng==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by CH0PR02MB8168.namprd02.prod.outlook.com
 (2603:10b6:610:10d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 19:30:35 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 19:30:32 +0000
From: Jon Kohler <jon@nutanix.com>
To: David Laight <david.laight.linux@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Linus Torvalds
	<torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Sean
 Christopherson <seanjc@google.com>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user() and
 put_user()
Thread-Topic: [PATCH net-next] vhost: use "checked" versions of get_user() and
 put_user()
Thread-Index: AQHcVDJryQXjlObInEG9J4YkYYZKUbTyh8sAgAAKDAA=
Date: Fri, 14 Nov 2025 19:30:32 +0000
Message-ID: <2CD22CA1-FAFA-493A-8F41-A5798C33D103@nutanix.com>
References: <20251113005529.2494066-1-jon@nutanix.com>
 <20251114185424.354133ae@pumpkin>
In-Reply-To: <20251114185424.354133ae@pumpkin>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|CH0PR02MB8168:EE_
x-ms-office365-filtering-correlation-id: 99b3a57c-5824-457d-1143-08de23b4471e
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?MmdMd25IYnJnWFduRE9OYTVEYU1BTHY4SDh2WlNtbHM0MEdVNWlxL3JKMjlq?=
 =?utf-8?B?TVZZMk9YeHRGOW9STlNmQi9Pak9kOXR1bHBPVUxUbmVXYTYrNHJLZGllcnds?=
 =?utf-8?B?VzhBTGRuWkN0VFNra3BlTzhBQ0tyMUxpNzFoU3U1dWo0RlBITys2OGxRblY1?=
 =?utf-8?B?ejV4WlJQN1VMRnlmM2R5ZkQraGJHci9JRU5mY0RJQUdnWFFmMGtHRjQ0bDBq?=
 =?utf-8?B?QVowK1FYSFZsMHUwTktyYi9DaFhFOTU1UzZ1NDJscW9lTmJqd1BIRjZJSXZH?=
 =?utf-8?B?emJHcWpKTHFWbkpNaG9pNGtERmNzc0piN2thRWxNQWQ2Ry9kS1ZLS0Y0Y0JM?=
 =?utf-8?B?OFU5OUVXMmszdkZQYUg1M25hODZKMWtUVXRZb0VNZ0k4YlVpVDdhYlZhcUFY?=
 =?utf-8?B?eHdmM2x1TExxeUJuVnd5SW5lN1FhNDNCZ3NXRm4xWnl2N0FKejRyYURVNWhR?=
 =?utf-8?B?MXZZblJqTHlQd05POGFuTzd0ck96WFJra0pyeFBjVWZPSWI4cWU2VWV1SXJ1?=
 =?utf-8?B?QjQxOXBlRCt2c3RUQTlwa0VNWndxbEFxazVGRk1pSEQwUjNZT2ZiZWEzMDNm?=
 =?utf-8?B?NCtzbU1hNHZTeldUZmJkd29YQU9nalM3VExVek1xMDBGMEhDSURISmRMV2Ux?=
 =?utf-8?B?aGhqOW9IS2srWDhFem9JeXF3YUU3ZG9PR1dJSVJZZjdXTWVncGNIVFhBWjd2?=
 =?utf-8?B?WEV0VThWNzhyVm1YSEhKTW05N084ZkNGcmFVWjRFNEhkZVZUNEJhQ3dtblNk?=
 =?utf-8?B?eTlLejdQTy9IR1orZE4xSnF3NTQ0clFLRWUrU2w0MmFoanovbkVxMERhU3RW?=
 =?utf-8?B?RGVXSDNtTEZpcndtdjB4bEFlVlVDVUpjRy9kbzVxQUNRUnhxYmxFYkJYR1o0?=
 =?utf-8?B?N0poeXFWZDI4WTl5TGlKL2kzVUlrZHFnYjYyNlVjTEZHMGFqRDMxMGpVbTNL?=
 =?utf-8?B?bGFIaXp0VVBmWml0cEliMVh1dEE2U2FXeGcrZWRMaHE0Mm5YV2JXT25ZUlRY?=
 =?utf-8?B?clFLa0xmN3U5a29ma01VNXg2TW5KSTd2Mk9ieDBHYkVPOWthWjNqdk1BTDM4?=
 =?utf-8?B?eHRYQVZYUy9UT1FmTWlodlNuZXFwOWkwZDBPb3JyNmFGNE9pSHRqMG1UNEd2?=
 =?utf-8?B?Q0IwMjczUlJYS3luaFN3RDhxaVM5eSs3TTNMY2xrbzJDb1dKZlNiNHN0Zmx6?=
 =?utf-8?B?a29tZjZsZjdnWGxNU044Lzg0cEtzVDlpU0pNblFDb3VDcW1kVG5wc21qS0Jo?=
 =?utf-8?B?d0JaWjU2eEh4RWc0UTRTMUNUU28zQnJpR2RxTFFNVm1XUkQxQXZsVzVGdjcy?=
 =?utf-8?B?c2tnVWNOR2ttZTc1VGU1cC9yWDFnQ2hlZDh3VXlaSkc1dTBOZUhmeGMxeTN0?=
 =?utf-8?B?RUY4bVI1UjFtb1U0c2RJbFE4M3dpdElJSENGODZRelMySVhPUHE2aklPd2Y5?=
 =?utf-8?B?V1hYRVVseWhKeE9DN3ZJVSs3QWpkQkN0OVdMMUpsS2xtd0xaYnB0cHVCUVZv?=
 =?utf-8?B?T2ZiZ0tpVGF2R2p4L1VjcWRmZ2JxY3JIazYxdGJqQUVHcjhCdGZGSTg2c3FR?=
 =?utf-8?B?QnpXU0VTeE92RENGNUlQU1QxYzIrcGt2R0NMUFlvUjdjVXlTVk81ODZna2o3?=
 =?utf-8?B?WmdnMWtiSzRjMjZxbHlOZ1ppbUxLUEh1MGkzVjNGd3ZwTENKQmJuYWRCN2Vy?=
 =?utf-8?B?Yk5pQzdlK0x6S2VTVElseWFoVHpVMDRWUEhFWC84Ylk1dXZDdUd0bkhPOExG?=
 =?utf-8?B?V21URVBIOWROYmk0VFZTQWJVeE5vRmZmYTZOT2J0amNHWStTcFRYZElScHdM?=
 =?utf-8?B?b2RKWFJqWFdaQUpNTkxhR2I5M3owUkZ3QnlpM0tnRzlZS3Vya3BaYVhPRkFC?=
 =?utf-8?B?SS9uaHNIMjFMSnVDVjN1WHIwOUJnQ25uT21aWFh2RERIdzJBRHFNTm0vTlRU?=
 =?utf-8?B?dnc3cDhKY2dyb2RnRy9lUGdTU2s3eGVGL28zQ1JKZldmM0NvN2RWQUhBNmcw?=
 =?utf-8?B?Z1NZQXZnVVhmcVZud2MyUEtyWEt2UG1icWFjdjhsaFhhdWg1TDYvQUlsMnhF?=
 =?utf-8?Q?ou9l0B?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q2JnM2lIdlR5Zy9KRE1HNGQvbzdUcGdNQVAvc2pMWExRYTE2cnBLamErSTRE?=
 =?utf-8?B?a1pMYmhLQTZCQU5Tc3B0c2lrOFNEOThjSTYwVnFuWHJsQVBaYjZHZnBBY3pY?=
 =?utf-8?B?VmxzdVB5N3NkeFk3S1J5QmFRMHd0aWJRRTVjcDZ3cE1TYzhPOXh5cUpuL0tT?=
 =?utf-8?B?blVLemZXZUxGK1pJcUNUb2RIRTlDREhWc2dQWTh4WXpUUmZKTW5wVmN2RFhi?=
 =?utf-8?B?b1pjZjRmQkJ6WjgrbkpFcEx2WWhrYlhOd3B5ZjhPNzVjYTFBRTMvL0l5SHI3?=
 =?utf-8?B?Z21naUtkZko0RXRFWHY5SFJRUVc3NFM5VDB2bmJhZjBhd2o5bVg1Tmd0Qk9h?=
 =?utf-8?B?bzBqQ05tNmJMVkRNeDhlcTIyVlFrWDNKY3d5bnJCVHlJYUJDOURxaG1IdzQ4?=
 =?utf-8?B?VTg3emJ0OVB5Rk9aRTdsSzhyYUdabWppOE5lbHd5TzJxbHBSOUdSQkttRUlr?=
 =?utf-8?B?TS9IUCtvOTRTUWl3c05TakVrWkhqbTNrQmJRb3BmK29WY1VBdzYzWXpYWG9N?=
 =?utf-8?B?cXNMbVd5SmRCS0ZKb0QwOWc0T3F2UUttcVVyZjZIVWkwajZnV0ZJUFc0d2VM?=
 =?utf-8?B?UVZFdTdqWXhyV0pFNERIN0k0UGE2aUNUWkdWdnRxU0ZlKzNBcDhCTmF0VXVH?=
 =?utf-8?B?VDhxdUZxTmpIcW5xakM4Sk1YblJJaFlJOFdjUWh1ajZIOVl2QjB1R3JONXA0?=
 =?utf-8?B?MGx0QnFCQmlWbW9zUW1qSU1ENWRqTnJ4eTRVRUIyTU1Ba1JEb2dnTXhJRXYv?=
 =?utf-8?B?U3FiNmRIemxrZENDUlFpNUJlZDR2bHVUVlgzMVBFTVpzKzRidFc3R3VwN01G?=
 =?utf-8?B?bjRMbS9OcFVxWlBWNWU1OWx6ejBrVytDZE5lb2doNkJ4bjYzeno3OGUvamdQ?=
 =?utf-8?B?azdZOHNNTVZyREdySDl4dWJ2ZDZTbmZMeElFVlVJaXE3Yyt1QmhvMHBaUUxm?=
 =?utf-8?B?d2twK3d3aFB0Vi9nY2FGREpvZFlvWCt5UmNrdVZXSUdTQm5MVVkrN3hXWlBL?=
 =?utf-8?B?WTEvSHBTZUdobVlaMm9iMEhJeDFzU1A3ZjNQTzdIUXc4cE1HMDdESHJ1OXdV?=
 =?utf-8?B?VzhTTTMvZk5pREsxMDhacFlFRlpTeEQ1WVhYZzMvcGtKUmg3R2g4Y1BEVk9M?=
 =?utf-8?B?RkRvY3lSTjZBNlJjeEU3eStnTXpnVjgwMitTZGptM1NySU8ydWtVbktOanZ0?=
 =?utf-8?B?STBPdGw1TE5IRTFDYnF5RVlROEMzY0dqVmp6c2U4ODRoc3krRmw1UFU5dmhx?=
 =?utf-8?B?QlYvUzRDbEdCdENzeXU1Q0QrdVc3N01keW0wNVdNcVVKY2ZkTVgyN3pTYXFK?=
 =?utf-8?B?R21URklqM1dydEZxbVpmMkdKR1dMb04rdE5UMnVDZmduc05LYlNBS1ZkSjN6?=
 =?utf-8?B?TFZuUzZjREdWNE9lSDdrcGNnMklCSythZXZNUmZ4RllSK3FhUjhmNStLVlh1?=
 =?utf-8?B?VEhNdjlpaVlxbUVoWWFheUllbUJDNnpYMTVNMmdJMW5MLzl3Y0t6VkQyVTFE?=
 =?utf-8?B?QWh1U1FPcjlHaUtJdXYrd2hiZUhyam1zcndYMWZBOXhacUVxeE5MWTYzVnZG?=
 =?utf-8?B?blRxWUU5aDhJVW5GSUJHbUU0OEtnWmU4V0dpMUY4N1JUZHc3cXM5S0MyZDRx?=
 =?utf-8?B?LzRrRnYzdGZLVEtjdytoU2pNd2lRTnhrMHZXS25rWC9FQ1gvU3FxaysrRjNr?=
 =?utf-8?B?LzVLQzlxWDBaakV1bi85ejZBczBrRU9LcFlNM3l3K3FQWTQrUW4ySEhlTkZh?=
 =?utf-8?B?bFllaVRNUUxPamRaZFBIbUJwak55M25nSEVFcUlFcFI1ZlE5ZGxCejA2TjV2?=
 =?utf-8?B?T1h5a25ZQTdNOG5FSWgyMnBSUlgvTEt3aHdzczMwMHNRL0VkM0g4UEwvSVJ0?=
 =?utf-8?B?WTAzMHFRdGg4MzY5ZnY0dC9kTFBYejZueUQvYU1iaFV0cFFLK09Gblo3NFdZ?=
 =?utf-8?B?bU5iMERwL2xwWnJDVkRIc0F4MjA0b25Hemd2VjlaaUxSeEZZV29FNHZIYktp?=
 =?utf-8?B?KzdCUzRBSnpwK0NMRTNSY1hIMENvRjU2Um5tVkhXUCtJYXJmVEpkMTZnaUUz?=
 =?utf-8?B?emtYeXVhUjI4NnZueXhIT3lGS1YxRDk4dWdpNTV5ZWFzTFVOYjJtMElOYlF4?=
 =?utf-8?B?RTlhbjFrNzV1UTZIemIxaWVET1RzRUp0YkFPdmoxSmcvTkVseTBWSC84N0Ev?=
 =?utf-8?B?U05FdXY4ZDd2aUVFSmx6cE52dUwxVGREV1cyaHhSbUtpNzRoakpDK1NSendW?=
 =?utf-8?B?SHF5VWNkNGxPL0tNdTlmK29iZmFBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C17F9E28839AE940A82534601810900A@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99b3a57c-5824-457d-1143-08de23b4471e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2025 19:30:32.6937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1vrrU9oywvV6tApnAxMPRPV4sH64jVZUbyd+8DC7Z76L654TBAYrXWYLeU2YvKmOsEnRdUMVw9KzpEOjgqJUMLiKCksxEEb0QakT8Phhpmg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8168
X-Proofpoint-GUID: gVff8BX0CVZYEB76hvhIDKJ4CKAcuT01
X-Proofpoint-ORIG-GUID: gVff8BX0CVZYEB76hvhIDKJ4CKAcuT01
X-Authority-Analysis: v=2.4 cv=LLJrgZW9 c=1 sm=1 tr=0 ts=6917835d cx=c_pps
 a=pRYMHFsXyG92p8CuKGQZlQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=64Cc0HZtAAAA:8 a=mj4BoeqodCBr67XLK2YA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE0MDE1OCBTYWx0ZWRfX9izmVQVcHCpD
 QeaWza9VN98artCxOJIHZ061yr4EL3gkwDfVnkkKPLGrHAOa/nY2yVm8GLEvudCVrA457RpmLmd
 /wi1RoHMHvLdP1NZeqnEDJvPmWOjhDoHYwxczO9kHmpQ83OACQsTP4uf+kqjY5qrQr6H0pwe15b
 7De2VskB1QG6zmGwyDdhNkHmhgqqWcO9ILtIZUdVWu5udjV6K4pFmOyk1mZ3FSrshZR6HhattgC
 lAgYIH1u7l6/krVlLh9x1h5AayYC6EFKB/Xee09XKS+U1MJmU3B3vOVuVITE4GBQiHUmzBalmd6
 jzMAr7s3uQFm/iO4EEZ0HTyXPPL8W7VOAkJiwN86MIyyThln0vg+5QHJk/q69suh3rG3KzPjAzy
 39gbBM9EWNikZtE++s0UJgHBMVuFIw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-14_06,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTm92IDE0LCAyMDI1LCBhdCAxOjU04oCvUE0sIERhdmlkIExhaWdodCA8ZGF2aWQu
bGFpZ2h0LmxpbnV4QGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiAhLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4gIENB
VVRJT046IEV4dGVybmFsIEVtYWlsDQo+IA0KPiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4gDQo+IE9uIFdlZCwg
MTIgTm92IDIwMjUgMTc6NTU6MjggLTA3MDANCj4gSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29t
PiB3cm90ZToNCj4gDQo+PiB2aG9zdF9nZXRfdXNlciBhbmQgdmhvc3RfcHV0X3VzZXIgbGV2ZXJh
Z2UgX19nZXRfdXNlciBhbmQgX19wdXRfdXNlciwNCj4+IHJlc3BlY3RpdmVseSwgd2hpY2ggd2Vy
ZSBib3RoIGFkZGVkIGluIDIwMTYgYnkgY29tbWl0IDZiMWU2Y2M3ODU1Yg0KPj4gKCJ2aG9zdDog
bmV3IGRldmljZSBJT1RMQiBBUEkiKS4gSW4gYSBoZWF2eSBVRFAgdHJhbnNtaXQgd29ya2xvYWQg
b24gYQ0KPj4gdmhvc3QtbmV0IGJhY2tlZCB0YXAgZGV2aWNlLCB0aGVzZSBmdW5jdGlvbnMgc2hv
d2VkIHVwIGFzIH4xMS42JSBvZg0KPj4gc2FtcGxlcyBpbiBhIGZsYW1lZ3JhcGggb2YgdGhlIHVu
ZGVybHlpbmcgdmhvc3Qgd29ya2VyIHRocmVhZC4NCj4+IA0KPj4gUXVvdGluZyBMaW51cyBmcm9t
IFsxXToNCj4+ICAgIEFueXdheSwgZXZlcnkgc2luZ2xlIF9fZ2V0X3VzZXIoKSBjYWxsIEkgbG9v
a2VkIGF0IGxvb2tlZCBsaWtlDQo+PiAgICBoaXN0b3JpY2FsIGdhcmJhZ2UuIFsuLi5dIEVuZCBy
ZXN1bHQ6IEkgZ2V0IHRoZSBmZWVsaW5nIHRoYXQgd2UNCj4+ICAgIHNob3VsZCBqdXN0IGRvIGEg
Z2xvYmFsIHNlYXJjaC1hbmQtcmVwbGFjZSBvZiB0aGUgX19nZXRfdXNlci8NCj4+ICAgIF9fcHV0
X3VzZXIgdXNlcnMsIHJlcGxhY2UgdGhlbSB3aXRoIHBsYWluIGdldF91c2VyL3B1dF91c2VyIGlu
c3RlYWQsDQo+PiAgICBhbmQgdGhlbiBmaXggdXAgYW55IGZhbGxvdXQgKGVnIHRoZSBjb2NvIGNv
ZGUpLg0KPj4gDQo+PiBTd2l0Y2ggdG8gcGxhaW4gZ2V0X3VzZXIvcHV0X3VzZXIgaW4gdmhvc3Qs
IHdoaWNoIHJlc3VsdHMgaW4gYSBzbGlnaHQNCj4+IHRocm91Z2hwdXQgc3BlZWR1cC4gZ2V0X3Vz
ZXIgbm93IGFib3V0IH44LjQlIG9mIHNhbXBsZXMgaW4gZmxhbWVncmFwaC4NCj4+IA0KPj4gQmFz
aWMgaXBlcmYzIHRlc3Qgb24gYSBJbnRlbCA1NDE2UyBDUFUgd2l0aCBVYnVudHUgMjUuMTAgZ3Vl
c3Q6DQo+PiBUWDogdGFza3NldCAtYyAyIGlwZXJmMyAtYyA8cnhfaXA+IC10IDYwIC1wIDUyMDAg
LWIgMCAtdSAtaSA1DQo+PiBSWDogdGFza3NldCAtYyAyIGlwZXJmMyAtcyAtcCA1MjAwIC1EDQo+
PiBCZWZvcmU6IDYuMDggR2JpdHMvc2VjDQo+PiBBZnRlcjogIDYuMzIgR2JpdHMvc2VjDQo+PiAN
Cj4+IEFzIHRvIHdoYXQgZHJpdmVzIHRoZSBzcGVlZHVwLCBTZWFuJ3MgcGF0Y2ggWzJdIGV4cGxh
aW5zOg0KPj4gVXNlIHRoZSBub3JtYWwsIGNoZWNrZWQgdmVyc2lvbnMgZm9yIGdldF91c2VyKCkg
YW5kIHB1dF91c2VyKCkgaW5zdGVhZCBvZg0KPj4gdGhlIGRvdWJsZS11bmRlcnNjb3JlIHZlcnNp
b25zIHRoYXQgb21pdCByYW5nZSBjaGVja3MsIGFzIHRoZSBjaGVja2VkDQo+PiB2ZXJzaW9ucyBh
cmUgYWN0dWFsbHkgbWVhc3VyYWJseSBmYXN0ZXIgb24gbW9kZXJuIENQVXMgKDEyJSsgb24gSW50
ZWwsDQo+PiAyNSUrIG9uIEFNRCkuDQo+IA0KPiBJcyB0aGVyZSBhbiBhc3NvY2lhdGVkIGFjY2Vz
c19vaygpIHRoYXQgY2FuIGFsc28gYmUgcmVtb3ZlZD8NCj4gDQo+IERhdmlkDQoNCkhleSBEYXZp
ZCAtIElJVUMsIHRoZSBhY2Nlc3Nfb2soKSBmb3Igbm9uLWlvdGxiIHNldHVwcyBpcyBkb25lIGF0
DQppbml0aWFsIHNldHVwIHRpbWUsIG5vdCBwZXIgZXZlbnQsIHNlZSB2aG9zdF92cmluZ19zZXRf
YWRkciBhbmQNCmZvciB0aGUgdmhvc3QgbmV0IHNpZGUgc2VlIHZob3N0X25ldF9zZXRfYmFja2Vu
ZCAtPiANCnZob3N0X3ZxX2FjY2Vzc19vay4NCg0KV2lsbCBsZWFuIG9uIE1TVC9KYXNvbiB0byBo
ZWxwIHNhbml0eSBjaGVjayBteSB1bmRlcnN0YW5kaW5nLg0KDQpJbiB0aGUgaW90bGIgY2FzZSwg
dGhhdOKAmXMgaGFuZGxlZCBkaWZmZXJlbnRseSAoSmFzb24gY2FuIHNwZWFrIHRvDQp0aGF0IHNp
ZGUpLCBidXQgSSBkb250IHRoaW5rIHRoZXJlIGlzIHNvbWV0aGluZyB3ZeKAmWQgcmVtb3ZlIHRo
ZXJlPw==

