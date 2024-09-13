Return-Path: <kvm+bounces-26830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70A52978532
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:53:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0A681F21EE3
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 15:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2216D1B4;
	Fri, 13 Sep 2024 15:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ErZc50FR";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ix7ohTQb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D09770E1;
	Fri, 13 Sep 2024 15:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726242773; cv=fail; b=f5VKU76iuPpDjTfRTgWg7LiTtnQj/v7liz1hwWoXGGP7gDulGeO5LLvdDcGtf8y46XH570oh9QH9DXZ8Yu7LreBwf6xomNb3ygshb5MGWoVY/bSnWNXFOLec2wnIkvXzaVZmqwrHMzi3nN/1EfS9Vc9tl3HRfTcm6m2pmf8aOL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726242773; c=relaxed/simple;
	bh=C9Bc8+cPR5zzq2EpXSjm4fVoLaTnBHIiYS2pTLTHbAc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K+P8kebwYQh6c6MA3pRfg9Ao7gjb9Mcrh1BNLU6jKUNLQdcywImXYKo06GnfSs3mgyaZfwJ/y1AqVdv4O1yYo2e3xXBtpEi39gUd9dDOJm1dmSWNacFdDX/a/g2w4lPf3YlLPGEQXZjVrbyePy8GAt1vQQXR19O65KkeQRL/9/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ErZc50FR; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ix7ohTQb; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48DEmllN028356;
	Fri, 13 Sep 2024 08:52:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=C9Bc8+cPR5zzq2EpXSjm4fVoLaTnBHIiYS2pTLTHb
	Ac=; b=ErZc50FREu1/LTyL20vznUl3JgYUS20vElDyZRBG3C2Pkiuev1CgsEmov
	91patblLrT4SCJhJLZndeeEl542T6PE+cjWM42VmG+QdF9NXVTzUHcL+RDwDHqTq
	A7u369cpc6ViidxuVUV9dqvyGelejK+08HCgb+ducpDghxY3oo47urRSrC41xy8/
	1OmzCl3kcDtgZjEuay58v3ECmTZiL2bWS5DEcksFdMGX4z9SkkP6Ef7ubuCQEp2B
	cdXlPltOg5rATQqIpXjDTbyASESfdWLX+MXvgWlccuDgU2DeebNGxXvRAYAqGfpq
	nHMPFohSpgIDyeo7ZBBByszs/Vc8A==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazlp17012032.outbound.protection.outlook.com [40.93.1.32])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 41m496jhyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 08:52:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OkAy8mk+P0BipDtE6cyL/D5+XtVOKBJZla5Ad1oXmtgND2WPLHXFRHz8RogIhuoaZNgOmE4CJDuOq/rpQmvYsmGXANORj37G4EeOI69YaBKkGeGv1k+QiAEkI9xY9Mtc3szGqbTmaGZ2Nhaj0BJlf83Qzoi4AYLZ3+nsn6wITE4mMCEVWtjLcwhrcNhPofEuZK0labIRQ5c5tdRJCNpfJL1acaZTZL+YKKm52slIOPHwTtMzxkpYPVEl/QCx+PA1UN/FC7tXIlvjVe3o/uAQINVqqBXnhhXtI5CygL0gIqYuPSsyxgRUfzW/gaU5b1kjPDQVZ5VjDHA9EYG0s8PMVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9Bc8+cPR5zzq2EpXSjm4fVoLaTnBHIiYS2pTLTHbAc=;
 b=G17PiGL5v4VChNG/aM4X9gvtFgyIBnTwKGwUkWRO6TETt2TNFp3aSlBEHY97JTE3Ow2OJKZMtTQbotEQrMAC+ZsKmgRt0Nq13vUaetjhzcNseMr24N+9df7dUlDLQ92NvkARu+14vW1+gjI2Xby4Qt8nNCpzA2QKcwYWfFtv80wxjGmHu/Bp60ouVeqrxeL0kUaLOdlGjnChQAKchlCH31GP3b9ZqZF9+O6sMDCTmTa9u5ktYomoXpu9U7t2bs7ykFilGocS5rapR9h7/l/PKJCEJr5rujS2zcF/Ph7Y5Ig0kR9J/1EeubHYXV3BXMnjPejx+J2VWAkv3pwMCcyAzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C9Bc8+cPR5zzq2EpXSjm4fVoLaTnBHIiYS2pTLTHbAc=;
 b=ix7ohTQb4rIy+VHQ3m1W6gcEvc/m9DB+iGQ9YX2GLn4qyywPP5b/kEzZ2FPS7kl0OrL+Dws8ck0kcgehoUUzSQbDmy4OoyFHtrR2aUgfHzw7VFQ21xcLF1mYfiiz+b2AEr9zpYCVFWiGykWWkb9iZWfgx7SZfZmm/iKRk1uRiZoPvFTNv1ePFU5ZlXvzoT6prpnhTdTyug7z781jO8334vZSizcbQDswm1G3BEiqCTrAv+qtrutKsbtrpsWXwDfNHFCvZJPiRA7uq0nAF7wHZ0o2dLnTIWJdaYxxlhs2nTr7q3O8XYstvHb9gINMdm3ZctIT3mF9nn7JeIGt7rnzfA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by IA3PR02MB10519.namprd02.prod.outlook.com
 (2603:10b6:208:533::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.27; Fri, 13 Sep
 2024 15:52:07 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.7918.020; Fri, 13 Sep 2024
 15:52:07 +0000
From: Jon Kohler <jon@nutanix.com>
To: Chao Gao <chao.gao@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Ingo Molnar
	<mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, X86 ML
	<x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML
	<linux-kernel@vger.kernel.org>,
        "kvm @ vger . kernel . org"
	<kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/bhi: avoid hardware mitigation for
 'spectre_bhi=vmexit'
Thread-Topic: [PATCH] x86/bhi: avoid hardware mitigation for
 'spectre_bhi=vmexit'
Thread-Index: AQHbBRtn4jznGhv7KU+IMqTomlXzNrJVNH4AgACq/4A=
Date: Fri, 13 Sep 2024 15:52:07 +0000
Message-ID: <49173342-7518-4A69-9B45-01DA7FCB6831@nutanix.com>
References: <20240912141156.231429-1-jon@nutanix.com>
 <ZuPQKHrUcC/YejXx@intel.com>
In-Reply-To: <ZuPQKHrUcC/YejXx@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|IA3PR02MB10519:EE_
x-ms-office365-filtering-correlation-id: 64ac1066-78c7-469e-c9c0-08dcd40c0537
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?REZWb0dMZjduby9ueXJkbGVTWngzSFJzVEQzVk50MTRoSTYwYXV3eWg4Rnly?=
 =?utf-8?B?YVMxblJVVEVDYU9FRlZoa0pMVEJ5ckV1YVFHS25QbUFpeXlqeGtJR2svdVVI?=
 =?utf-8?B?bDkyL0hodVRpc3dWdTlYenQzVFFlci9ZYUVER20xNDNwckJML3VTKzdkNTJ5?=
 =?utf-8?B?QWxTY1gvMmNzcnIrV0hCanJ2RmliN1EyVjc1SVgwK24wZ1VOWlhuamNMVDV2?=
 =?utf-8?B?SytCZFdxNWtLaDdIQWRnamQ0Z0ZOSm1wdkxaVGFBQm84blkyTWEzUWROZVE4?=
 =?utf-8?B?bVpQSEsrd0tOZnN1TkUyU3pQUkNpb0FEcGMxU1gvZEN0UEdlN2E5Smc3YlRv?=
 =?utf-8?B?QVJ6OXM5emEyUStKbzhnc3djeEs0bDk4UFpsS1ljR2xrWW4xUEp0MXI2MUxv?=
 =?utf-8?B?Um9TOEdzQndIa3dCL2oyb3FldHBtd29URmpsT1E2WkUwaytkV21FN25SSnpq?=
 =?utf-8?B?cExzUkRTNS9jcDBlNnQyT21xT0pJY3lWS1NCQmNwbk1UaHdCM3FBcFFPbWw5?=
 =?utf-8?B?Wkd5UVlxeTBaNDVid0p1a1NvSjViZWc4Z2tYajU0V2h5bUFDRjNpRzBJcFJ2?=
 =?utf-8?B?ZGRURCt5WnBreldDYjN1alcxWGl5U1dKcG1pa1R5bkRzNEIwTG1wSGlJNDlN?=
 =?utf-8?B?RkNCdW1GOXN1Y0NkMitqNTJCeFBXMm5mM2gvSE5LN3d2MDNSVGdPaXV3bTNT?=
 =?utf-8?B?WlNvYWI1RjNkcVdKMlpIYjNlNWN3WTlqME83akZPMjFoTVovbmdqZnVDZUtX?=
 =?utf-8?B?bEs1ck9jekJ3d3ZIN1B4TGluVXRVL0ljVjlNb3JXQVNFSWl1cVI0NHhuL3Ix?=
 =?utf-8?B?NUNlQitKMDZ1SFdwcXNBWVdsTk9RRXRJVUxpSzM3bERoUnhCN1dqM1hTMUJ6?=
 =?utf-8?B?SzdtQklFZEJoS3llYkQwSWlkNE84YXQybm5WOWFnVVJsZ0VyL0JyUDF4azEy?=
 =?utf-8?B?WDdhWnZFSFFMZ2NlNEs1N2dSOHU0aUZjYWx4SEhYZ1ZJeFZwQkNXNjF1QWFw?=
 =?utf-8?B?YVRBbkRtaHh6T016dFdySy9ncDVKc3NSbEpJclVmZXFGVEVxNWhaNVFtYWxY?=
 =?utf-8?B?R3ZRaDJjUlMrMUdPaHVhdlh6NG4veVMxdnlFK1hxV1p1OTdvdzVHY1FlSExC?=
 =?utf-8?B?VldyYmNLNkd6NXBDbmRDTUFjQUNic1VlT0Q1SzI5em9HNDNGb3NHdFkyQzc2?=
 =?utf-8?B?WUtaVVVmVWIrY1VhWTBjSjd0bGNYeVNxaFRRMGdBbmNOQW93TWRpLys1Vk9w?=
 =?utf-8?B?WkhjU1FLNTR3QzcrVWgzVTlraHNpQ2dSRWNwY3NBT0dON3lISWJSSkhteWpj?=
 =?utf-8?B?cFZ2aTVXclBFd3RSOWV2WXN0SEJray9XYUlaNVdYTVpMTGdIa0E3VWlnQ1d2?=
 =?utf-8?B?RmxmcXVSbUIzNmV4R0JSRW9yS05vZHYwYVZzVlVpZzI4Rkpib21YUktITDc0?=
 =?utf-8?B?QmIzUlRESDRnZlJ5bzE3dVJ6Y0xJVHhxY3V0bDhHdWdDZXIxS2JLeklzSnpQ?=
 =?utf-8?B?YnBNOVJ4QWs3UFVNMEl6T0htT3hsUlVhdEF0cTZoeG1UY2tnc3dWTTErMElh?=
 =?utf-8?B?ZWdYT2gwM1NlNVhkczJjT2hJYlQ3YUl0cm4xc1FIU1VtbGVyOWpCd3Y2WGN2?=
 =?utf-8?B?TThXT2d6M093UFZ2LzhvWHlReTgwSmZNeHFRTUt1OThQS29tL3Q0OFhrd3dT?=
 =?utf-8?B?M0tPRHh0QUV2RWNKdGM1QnhVdm1DL2tFVUl5Q05TU05WS0hJZStFeGdRZjRI?=
 =?utf-8?B?QU4raTRVczhpV3BwVFpGNTZGMXdQQmZ5SVhEK3RDV1hQVm8yR2dDUEFHU1I3?=
 =?utf-8?B?Z1BHUHdKSVBlT2dteVFtanRjQjF3bjNBNHJUclRKanJobVkxcEZUZDZtSGJN?=
 =?utf-8?B?U3c5amV3MHd2NWptSFFpR1RsL0Z5Y2lxc1E1VER4ckh1WXc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SGxOdHFMdGwwcm9GRVhnTXJGSHU1K1BaUExOT0YvRmJaWXZMMHBqWTk3VlUv?=
 =?utf-8?B?RTNxODY0cVJDbHA1VVdWcDUwbEh6SWl0RTNqQ2lrVGk5MTYvSzY2aUtjdnh6?=
 =?utf-8?B?NFR4NnlvOWFPZkdoYWx6NGttU1BoRnRMbFRTRWZ3Z0dPVUlpUFdOWnNXTzB0?=
 =?utf-8?B?YzU1L2E5ZTBhZWZxQ1p4Vncrc244aDB5OVBUdWVjUjlFd1VkQXZIcnIvbGt1?=
 =?utf-8?B?NmNoTkVYaWU5VlRNV3REV1YybjZsRjFBbTNUSVdJUHlLei9Nbll2Yis3aElN?=
 =?utf-8?B?WUMwSWE0M0NWbnVvWG8rbXo5and1a3NXSXhLQzdiWWdHRnJZcEZDTHVTdTZX?=
 =?utf-8?B?UTBmdWJRZ0I0RGltaVhzRGFCOVI3OXNnc042aU52T3cwU3VwRVBqN1ZDMDlL?=
 =?utf-8?B?a1I3N01iOG9pa3ExRW9UWXB3bUNsa0dhTmtNT3dFcDNQSjRkemxsRFA2Wksx?=
 =?utf-8?B?dW1BeTBBbVd1bFk2WFNPRklDY2tVeDBxSk8zamtXTDZ5TTYrL0x6bGZlcU11?=
 =?utf-8?B?KzBvNnpaYlIrOStaUTdXSytZdmE5bGhJM1hGVkc4bzZ3MEpCazNuME1GQkJO?=
 =?utf-8?B?Z284QkowTUhNa2NBdXZHMnVDSjJxNGkrdExDTFJ4eXZxRm1DeUlXZks1QUNF?=
 =?utf-8?B?bmM0Si95d0lmVDFtWmtkVDNsUjJ6Y2NpZWVCZU12VXVhV2dOdk13SXEwUjdv?=
 =?utf-8?B?WVUzeHYwVUdZcWZRbk80WFBUMUV2aUJLQzlVNmthTFpMM2NreXp1WEdzdDQw?=
 =?utf-8?B?ZlV4aGtCTXBDaHBhQUxibHp3STUvK3Blb2NBQUc4Q0VieFRzaTdiQ1FWLzFQ?=
 =?utf-8?B?OUZDaTRCNEFiV1Z1MytLNkphRlRTa2hVYXpnR1VTRTlGYXBZdjJYWEdoSDF0?=
 =?utf-8?B?MFNNV2lKL2V3SksyVVlXQ2NYbkxXdXE1MkpLK3pOZVpjZW5mejRhemt1cDZV?=
 =?utf-8?B?Z0VNcXJGREhGQy9mcW01MjJtZlhJZTlRWGJMNTI2Q2JvSW9qVGoyLzJQRUxy?=
 =?utf-8?B?K0tQWkQ1cmhYZVV2VVZ3b1RjZm9DYmkvWmdQTzQ1Zjl5aW9KRzBhN3Q4c1Q2?=
 =?utf-8?B?amNVK1hUQ1RuTHlLRUZsYlpDYkpMWklaVVhwMnAyNUtqVjJHblMxcGhDeTJH?=
 =?utf-8?B?MittaGswV0N6dUFCNDVUM2UvVkJHVDNRSFYyUHlDUHpKVVozejZqUDZPQmIy?=
 =?utf-8?B?OGM2QWtIY3JJTndZWGtKV1pWSWNIcGl1V3A2c1NSMmUzRHo0ZXE0anB1a2Fz?=
 =?utf-8?B?NjNPSTRJd2F3UWNYVVhoN1poay9GRmgyMkxJS3pIK2RCVndkVGI1Qkg5Vmgv?=
 =?utf-8?B?M0RpNExSaFEwNmNnTjczWTNyNFhPaG9QTXVrRi9KckJaWEg2czJYNThESEFr?=
 =?utf-8?B?bHo4VFV5RzZOTXoxcHZxMVhtRWRUSWxmVlZpSW0rUFVWQ1dsajBPNUU1WXlk?=
 =?utf-8?B?ZVgrTDFybjI4N0NpNG1uek9iMXlLQ0tUYmQ3RXRsaVhIRmkxbFpNSVVNdnkr?=
 =?utf-8?B?SS9iTEQ4aWRMRERVc3FIZUxUZ2dhcW55Q0VPSnJCRHRob2pGSXRDN0JUcUQ5?=
 =?utf-8?B?TzBpOUhIUllhMkI4Wnc0WWJlaGZSTEt2QlpaWnBJU1pxOU9FS0hhaHBQZUp1?=
 =?utf-8?B?SVg5c1UxS2pxM2t0SW9RNmQ4R1V0VGM1eTBHWnY5SUFPVXVuTi9DZ0V2ZVBz?=
 =?utf-8?B?ZnlYVCs1ZjY4c0tEaWUrZ21Fdy9JSmlmekF0bVFtVlZXVEpqSFZwcDZKL1hS?=
 =?utf-8?B?UTB2UC9WRVMvaTd4N2xrdDJEejMzQXpjWkVENEtIV04vWmtacVJXWFRKczV0?=
 =?utf-8?B?MzlYNmNMd0tWZlNCcC9qVjV5L0cycHhWcklocWNuMnVXZlVlOGdOU2Z4QnBW?=
 =?utf-8?B?TDhzRytNY2JJYnl1cE1tUWw0U1ZaY3VvVy8yZEp1STdTbGN6K2xaKzZscFpO?=
 =?utf-8?B?RHpUek1WYkVGQTF4b29MUGVjemdidHVjN0R1L3ZCRUJFL2cyL2VJY1owOTN1?=
 =?utf-8?B?WlA5N3gza2tJaldJa0MwMWJxbFdnb1BSWDBUdDFmZjVJbWFYUGVkazhMdHVM?=
 =?utf-8?B?aS8yOS92N1h5ZG85WTFvRkdwV2NnQ1lIbzdtSWEzVjJjWVVOZ2lhM05FMTkw?=
 =?utf-8?B?dVIvUlhkeVE4K0kvbFVyRWdTZG9UWGYrNm9kbW53MnFtK2g3RTQxMkhEVjZV?=
 =?utf-8?B?WVpSa0JraVA5cXJkVXJGSnFXeFgwNDB4c2JnaExkWFdLY21zcjZraDNEY0x0?=
 =?utf-8?B?SWRmUm9kcXlXNWMwd1RvZGw1S0lnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73C53385791CFF4CB83FA02EC52872AE@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64ac1066-78c7-469e-c9c0-08dcd40c0537
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2024 15:52:07.1771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n8i3BnBWVl24Gp1oRJlF1XIbBUWLWm30MhzTpQHrKCWRRoGVpfQPzon/+4bGxvcEd5E1LoOM54GmySvQVaHhkEnVL+RG5rxLjnmzhhBcaZ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR02MB10519
X-Proofpoint-GUID: RfsDACBULT3yvSTE1LxnF4QDGvvqW6Jt
X-Proofpoint-ORIG-GUID: RfsDACBULT3yvSTE1LxnF4QDGvvqW6Jt
X-Authority-Analysis: v=2.4 cv=CfRa56rl c=1 sm=1 tr=0 ts=66e45fa9 cx=c_pps a=fM4bIjZpJamw6RFag0UgWw==:117 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=EaEq8P2WXUwA:10 a=0034W8JfsZAA:10 a=0kUYKlekyDsA:10 a=QyXUC8HyAAAA:8
 a=64Cc0HZtAAAA:8 a=PVCY_jKM7sJ306oarKUA:9 a=QEXdDO2ut3YA:10 a=14NRyaPF5x3gF6G45PvQ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gU2VwIDEzLCAyMDI0LCBhdCAxOjM54oCvQU0sIENoYW8gR2FvIDxjaGFvLmdhb0Bp
bnRlbC5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9OOiBFeHRlcm5h
bCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiBUaHUsIFNlcCAxMiwgMjAyNCBh
dCAwNzoxMTo1NkFNIC0wNzAwLCBKb24gS29obGVyIHdyb3RlOg0KPj4gT24gaGFyZHdhcmUgdGhh
dCBzdXBwb3J0cyBCSElfRElTX1MvWDg2X0ZFQVRVUkVfQkhJX0NUUkwsIGRvIG5vdCB1c2UNCj4+
IGhhcmR3YXJlIG1pdGlnYXRpb24gd2hlbiB1c2luZyBCSElfTUlUSUdBVElPTl9WTUVYSVRfT05M
WSwgYXMgdGhpcw0KPj4gY2F1c2VzIHRoZSB2YWx1ZSBvZiBNU1JfSUEzMl9TUEVDX0NUUkwgdG8g
Y2hhbmdlLCB3aGljaCBpbmZsaWN0cw0KPj4gYWRkaXRpb25hbCBLVk0gb3ZlcmhlYWQuDQo+PiAN
Cj4+IEV4YW1wbGU6IEluIGEgdHlwaWNhbCBlSUJSUyBlbmFibGVkIHN5c3RlbSwgc3VjaCBhcyBJ
bnRlbCBTUFIsIHRoZQ0KPj4gU1BFQ19DVFJMIG1heSBiZSBjb21tb25seSBzZXQgdG8gdmFsID09
IDEgdG8gcmVmbGVjdCBlSUJSUyBlbmFibGVtZW50Ow0KPj4gaG93ZXZlciwgU1BFQ19DVFJMX0JI
SV9ESVNfUyBjYXVzZXMgdmFsID09IDEwMjUuIElmIHRoZSBndWVzdHMgdGhhdA0KPj4gS1ZNIGlz
IHZpcnR1YWxpemluZyBkbyBub3QgYWxzbyBzZXQgdGhlIGd1ZXN0IHNpZGUgdmFsdWUgPT0gMTAy
NSwNCj4+IEtWTSB3aWxsIGNvbnN0YW50bHkgaGF2ZSB0byB3cm1zciB0b2dnbGUgdGhlIGd1ZXN0
IHZzIGhvc3QgdmFsdWUgb24NCj4+IGJvdGggZW50cnkgYW5kIGV4aXQsIGRlbGF5aW5nIGJvdGgu
DQo+IA0KPiBQdXR0aW5nIGFzaWRlIHRoZSBzZWN1cml0eSBjb25jZXJuLCB0aGlzIHBhdGNoIGlz
bid0IGEgbmV0IHBvc2l0aXZlDQo+IGJlY2F1c2UgaXQgY2F1c2VzIGFkZGl0aW9uYWwgb3Zlcmhl
YWQgdG8gZ3Vlc3RzIHdpdGggc3BlY19jdHJsID0gMTAyNS4NCg0KU2VlIG15IG90aGVyIG5vdGUg
d2l0aCBhIGRpZmZlcmVudCBhcHByb2FjaCBhbmQgdGVzdGluZyB0byBtYXRjaC4NCg0KUmVzcG9u
ZGluZyB0byB0aGlzIHBvaW50IGhlcmUgdGhhdCB0aGlzIHdvdWxkIHJlcXVpcmUgVk1NIHRvIGV4
cG9zZSBCSElfQ1RSTA0Kd2hpY2ggZm9yIGV4YW1wbGUgUUVNVSBkb2VzIG5vdCwgc28gdGhpcyBp
cyBub3QgeWV0IGEgcHJvYmxlbSBhdCBsZWFzdA0KdG9kYXkNCg0KPiANCj4+IA0KPj4gU2lnbmVk
LW9mZi1ieTogSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29tPg0KPj4gLS0tDQo+PiBhcmNoL3g4
Ni9rZXJuZWwvY3B1L2J1Z3MuYyB8IDEyICsrKysrKysrKystLQ0KPj4gMSBmaWxlIGNoYW5nZWQs
IDEwIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9rZXJuZWwvY3B1L2J1Z3MuYyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvYnVncy5jDQo+
PiBpbmRleCA0NTY3NWRhMzU0ZjMuLmRmNzUzNWY1ZTg4MiAxMDA2NDQNCj4+IC0tLSBhL2FyY2gv
eDg2L2tlcm5lbC9jcHUvYnVncy5jDQo+PiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2J1Z3Mu
Yw0KPj4gQEAgLTE2NjIsOCArMTY2MiwxNiBAQCBzdGF0aWMgdm9pZCBfX2luaXQgYmhpX3NlbGVj
dF9taXRpZ2F0aW9uKHZvaWQpDQo+PiByZXR1cm47DQo+PiB9DQo+PiANCj4+IC0gLyogTWl0aWdh
dGUgaW4gaGFyZHdhcmUgaWYgc3VwcG9ydGVkICovDQo+PiAtIGlmIChzcGVjX2N0cmxfYmhpX2Rp
cygpKQ0KPj4gKyAvKg0KPj4gKyAqIE1pdGlnYXRlIGluIGhhcmR3YXJlIGlmIGFwcHJvcHJpYXRl
Lg0KPj4gKyAqIE5vdGU6IGZvciB2bWV4aXQgb25seSwgZG8gbm90IG1pdGlnYXRlIGluIGhhcmR3
YXJlIHRvIGF2b2lkIGNoYW5naW5nDQo+PiArICogdGhlIHZhbHVlIG9mIE1TUl9JQTMyX1NQRUNf
Q1RSTCB0byBpbmNsdWRlIFNQRUNfQ1RSTF9CSElfRElTX1MuIElmIGENCj4+ICsgKiBndWVzdCBk
b2VzIG5vdCBhbHNvIHNldCB0aGVpciBvd24gU1BFQ19DVFJMIHRvIGluY2x1ZGUgdGhpcywgS1ZN
IGhhcw0KPj4gKyAqIHRvIHRvZ2dsZSBvbiBldmVyeSB2bWV4aXQgYW5kIHZtZW50cnkgaWYgdGhl
IGhvc3QgdmFsdWUgZG9lcyBub3QNCj4+ICsgKiBtYXRjaCB0aGUgZ3Vlc3QgdmFsdWUuIEluc3Rl
YWQsIGRlcGVuZCBvbiBzb2Z0d2FyZSBsb29wIG1pdGlnYXRpb24NCj4+ICsgKiBvbmx5Lg0KPj4g
KyAqLw0KPj4gKyBpZiAoYmhpX21pdGlnYXRpb24gIT0gQkhJX01JVElHQVRJT05fVk1FWElUX09O
TFkgJiYgc3BlY19jdHJsX2JoaV9kaXMoKSkNCj4+IHJldHVybjsNCj4+IA0KPj4gaWYgKCFJU19F
TkFCTEVEKENPTkZJR19YODZfNjQpKQ0KPj4gLS0gDQo+PiAyLjQzLjANCj4+IA0KPj4gDQoNCg==

