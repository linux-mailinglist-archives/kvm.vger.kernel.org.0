Return-Path: <kvm+bounces-19444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DA75590524B
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 14:21:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6AE921F22076
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 12:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A4ED16F846;
	Wed, 12 Jun 2024 12:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Prlok0PO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KFziH4DU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAA5374D3;
	Wed, 12 Jun 2024 12:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718194896; cv=fail; b=SB0Pqd4BjAOMhQCCJm+qKql+a7cCw48gNGHUEzYP3/Fs7Ea1dkTGynNGBSbyFwbIzyKU8gtxZiU4FX+9oqCW31NKIoIT4m+sbDP3maffzGHLA9ek/5afm2BjD4V5jSy4uH1bkBDvDHjEbIWBKMGkvqH2a/txQEQHhrru9w+Tah4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718194896; c=relaxed/simple;
	bh=JmPfq0Z1dLp5ZpXIUrwDoVpajUMPcOaFDLVI8SBuObo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rmIUu3WbBzzbco1UARtBo/k3C1EFjCEPnSAlggY7W529d5C1/sMAJ7rtsod/f1c5jmWgJSrbqgKe8LKt95GUT0VluUhCH3R44KpuG9ug//DaVf3xACZL8R+WaqKT0FHQq4EWCpKL+WrMDLDaPn70cn0v930Cut210l4ZJsT9IoI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Prlok0PO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KFziH4DU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45C7BNcg019458;
	Wed, 12 Jun 2024 12:21:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=jdwaYHIycws7JJ9LZ0iwg8yCQvei7MRsVwseRBHEX
	cM=; b=Prlok0POtImQ/ehREvFxLZhMv5U8gSh6ZOieJkIidnyM8ekr4la+oeD4P
	nfwsffKhwnvfViKM3NP6ls2C5zT6lA/VEhhuFhwRFXlilJI06E9EreuinxuiN7rY
	pB8mKePZ93KdzvwaNqp6Brln7Mjxg2Q+4wtt+IsKNb0XSl5yYF0CsI6Be4WlXtQC
	aO2PfN2zCweMKoq1e1cz8kdbYwbyD/LW/j4nK219bhhp/UBMAMOgLCfyX6Ut0kPo
	LIFjqbbMtdqlqG48RXjJIip3ogigLHgKWEPzoLI5hVtigvSM0WNNpqzLL0PloL7O
	WCoNJtTPdc1zzwcyGPrnm/fkCRL3Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1mf1xc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 12:21:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45CBeO5x027087;
	Wed, 12 Jun 2024 12:21:31 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncdung0y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 12:21:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1mAd4VR8Ps6Bp82JXDFvEvyJ9/olS07wWZsSPAA9dGi3qtHSVB1aCvgBNbHV7aywmkJ8L5b3ZkZb6iTJB0l1JZ9Gh3l/3fhaNLqCOp8LlQM62ewe2xNeuJdeTc2L3pCf00Ezy3jV1H1lFkwpa2lSdghytyBcBgZn1lh3gyQa/emzgpJFBb46NebrMMMbD069ZNWQMSIMOzn4hkqTlCYzUQ+8TTzGAZzExc6vzOobjZLRdrd5LbBcbjMCIOqYhmmvtbk1QNbqFLe25UFpfwEw1nQ4gbO75vQ5HAosoLaXbEO7OiN9Mtn4YmKxVoY7XFfvfNF+P3y4mjAcMKrBbMcKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jdwaYHIycws7JJ9LZ0iwg8yCQvei7MRsVwseRBHEXcM=;
 b=TP+kbHmawIhfNzGBdfWQQsrSrcp2zyGgQtrMx+kG7v0OArjLOAqqb/hKoV9RiSkbvfqNA4DoQ4lhvZ++B8UX8DWH3yrSaQRkdK9uw20dHZnQChELOvorvy/7X/mr+CCPCJIgJR3nI1ZLnsTwKNcKjQWHzJkgeRyKSWKlav2Rt4oLmqGgbNHAlU4BndM/XNng3+LSMHAsxg4VWthcAfhJRnpuA79N3HaxKLf/hxmaXFOW6TZCpTVrD609zuGXC4Y9GBn++wQW9B33xw++3F9suQVtg+MiGo48GdEH3zwOkySBCCP01+q+wcrTUuE3jVvJ2CWyXRQnzLIsZ521q2AJGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jdwaYHIycws7JJ9LZ0iwg8yCQvei7MRsVwseRBHEXcM=;
 b=KFziH4DUE7yFsTphk+NXyMKQnzMiAd8dAJc9taKdNbcnGXFAZlEUXsWo/1dU5QcyamLISswwP5rlawvassodbB7MxGNw7d9OiP5nm9y1BZ39JN2EoP5ZqbQZvUkk2IL+aeqbC7WnN99NzXf+10XugBSkVMcb7sBiT3e7zQ10b4c=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by PH0PR10MB7062.namprd10.prod.outlook.com (2603:10b6:510:283::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Wed, 12 Jun
 2024 12:21:29 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%4]) with mapi id 15.20.7633.037; Wed, 12 Jun 2024
 12:21:29 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Liam Merwick
	<liam.merwick@oracle.com>
Subject: Re: [PATCH v2] virt: guest_memfd: fix reference leak on hwpoisoned
 page
Thread-Topic: [PATCH v2] virt: guest_memfd: fix reference leak on hwpoisoned
 page
Thread-Index: AQHau+mxihI7n/iY+EeIbA2JtpN3sbHEHMeA
Date: Wed, 12 Jun 2024 12:21:29 +0000
Message-ID: <033dc666-2158-473d-8ce0-a1f172a77a0c@oracle.com>
References: <20240611102515.48048-1-pbonzini@redhat.com>
In-Reply-To: <20240611102515.48048-1-pbonzini@redhat.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-imapappendstamp: BN0PR10MB5030.namprd10.prod.outlook.com
 (15.20.7633.034)
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5030:EE_|PH0PR10MB7062:EE_
x-ms-office365-filtering-correlation-id: 229123b1-58d7-4485-cc9f-08dc8ada3039
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230032|1800799016|366008|376006|38070700010;
x-microsoft-antispam-message-info: 
 =?iso-8859-1?Q?spkYNTMvtjIQbCw9/XeDkBSc+ma2TAOfaC30tKAHPws3aewA8wb65713sf?=
 =?iso-8859-1?Q?yyagO5LUdF4N7HbTnth6gb01Wl0LOMs8LsC9ncQQAsJiAMvwUhp4eumoV7?=
 =?iso-8859-1?Q?Ozl8vok0MFJnrVvn3x1NuqKEXFBauQMuE8bJiHQFgZmHFY+7hCrhLzgeJL?=
 =?iso-8859-1?Q?fCfdOBb3wY7XOX+WznX4bFJffcfNvHGLgoutJVZFhEh8U3C2egUDNWguSf?=
 =?iso-8859-1?Q?OeIwkOQswniHpNhZWR1Nu14ADlTBt4blEAcuLUvI+uRziitaZzHOsuPPlv?=
 =?iso-8859-1?Q?wLAloUvXKIxUUiV9ppxus8jTMmZAW6rIhjBNQ0QusFjglKXzizlUGHxwRF?=
 =?iso-8859-1?Q?eSRJSDNgFTVv4+wza1rBMJXRNrP9/X1KM+vLZ5DQjM/+OQHyalCqAVgyqJ?=
 =?iso-8859-1?Q?hIkMseNJk0hFeh1XrQVT/C22yKLVDSHp9gS3tYjW2ZQaNXpfpOkm0t5WGt?=
 =?iso-8859-1?Q?P1vLr97xKNhQqqqLjW29wkSv6Ruo6UEn+F/qDShMtYidvHoi3oyZBh6e37?=
 =?iso-8859-1?Q?c47wcfPPdm8lpRCImNVnGeqYAdch8uhGT936IfO+CS2xd2yjbM5Uvx2kdQ?=
 =?iso-8859-1?Q?ELonObeT7A0uV/NDJ+hd/Ij/JMZrID49oIkqsa/CrRc/VkZDpRwUpDqmmS?=
 =?iso-8859-1?Q?EbFx/XCJggpXqQS+mg7OadUuIuXihmo9v1r3ZNTSmWMfPny+Lk+CZYyQxa?=
 =?iso-8859-1?Q?ezx0FKR1G2LPtRX3pV5xkiuPzECwQy0bdsK10gEdo5jlO9LqXIR1VhBcsm?=
 =?iso-8859-1?Q?hnwBp+iwrgqHuHZgCWt5l7QXzXrIzbTPvwooA9iGrpbU9Vh/J4b/bJHNmk?=
 =?iso-8859-1?Q?70SUFZu/knMgNBucwaexnoQBNAmejkzpcI68vV2fTp7bfltmXup2By5aQB?=
 =?iso-8859-1?Q?Vv+teLjbEa+2FACb8V0fBvHEqu5AncMD9bT3vUxOu+MVp8ExqRMyDm6w2Z?=
 =?iso-8859-1?Q?mr0jiyyYGeVQvG7z2S1zcqvbKZKOrGvJFhDqtjvru9e2u7FfDRAy3GCtNV?=
 =?iso-8859-1?Q?7+sCV2d+2YGPTb8SrJqw58nQZciJNyU9Lz414W8Vn5RfeLft0WnOLEt3ly?=
 =?iso-8859-1?Q?s62N5IlFPPMDoE0UX984Uk5mIFZZBpxpRPiCs2pvNv1cHofUqoOKlZyTLx?=
 =?iso-8859-1?Q?UOhlokze97KlIXwXoSn4YyjhU5F+rOnTuf9euEo5AtXpAVGCd0grlnA64F?=
 =?iso-8859-1?Q?nXyBdQbzhtG8VGEcvX2WXBnloYkM4TUZAXPkTEEvR127bWQGNRzOjvHB4a?=
 =?iso-8859-1?Q?l7UpSGg9qiXfQ2uiYQtw76QrQPczlMCmS6LhpzBeyFJa4OHO9ROYIdQovH?=
 =?iso-8859-1?Q?mQ3cbwSm2K1/1JqciTqGFBMECQpf2gFZARbypMntZIRYddCtmVNHdtpst9?=
 =?iso-8859-1?Q?lOgdN0vBAEEZuc7nxBhLWTmC5Po18DRwJrxqUBthNKR+czPNMRnDw=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(1800799016)(366008)(376006)(38070700010);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?iso-8859-1?Q?ibXFGjOpEp5Vq7bnnxe1Iu5KLpB0LcyXQYV6VTDIzCroDRG6OXtSPy2c6h?=
 =?iso-8859-1?Q?CRk91hU9zbc4rf/ON9dV485/FbnFnAoJMkviTW6JKbffjznCWh4v8/orKu?=
 =?iso-8859-1?Q?p1zcZnao5zmQt+cnMavMmbN5byhB3RfYNN1dKImH1zo/epzCQNVghAlnOv?=
 =?iso-8859-1?Q?2Xp9iH37t2A+gGOTXKklFsUkoRZDa0aRdFHNqtkndamEc0J84Mxu0Ste9h?=
 =?iso-8859-1?Q?T6kzjEnw573wUG4ELQS1f23PzCP+SAIhe4kyUWLtprWyVosU9DaG1TqKIf?=
 =?iso-8859-1?Q?qsdeaTyE4dasJNYsCijKuGbvv5Xw0/xXxAVDKNm5slffBVxw8gP/eAkejq?=
 =?iso-8859-1?Q?6UjxkPAPnnZ4ksqpLC6sWGZiUIwqin3M7awZTMs3t+WEvPTufD9whDWJ0T?=
 =?iso-8859-1?Q?M1GIntADMX4EADxiAhCdVOwFqoDHujH0BjGxofendNqc0kyA2LaPl5+osw?=
 =?iso-8859-1?Q?ZCp5n67cACI6UV8aN86md9zsBhXi3MMTs0ijXYoHbKQF/PT7wlDfxgt55+?=
 =?iso-8859-1?Q?fdp2oGrZTYFnCQ+Beiu6tcoCC9qrzeOisfokUIPvGUNfw7P8aC/wHgE3B6?=
 =?iso-8859-1?Q?rPkZaxAPXNF/nnFmFHJuaXk79qmLGusuQbWLlMQXog3lFqmmdhIXnh9z55?=
 =?iso-8859-1?Q?cQdwDNrzJGCvrpljB/1qAM+URzmoU5fq4RjVtTRoj1U2y1Y4ggZf25Ex1a?=
 =?iso-8859-1?Q?0925XG6YuGlVJY9SyYOgfkfHYv8jdRtN4hNhgQMIvVeD2YvB29aLB/OyqT?=
 =?iso-8859-1?Q?U/+WNQF/UUtoSlGn5+ktwoVPHExJdv13fAU3XGcQjGcwyflUrFau6jyV4F?=
 =?iso-8859-1?Q?aIoUzfkDJ0HMD/BsMAYwOn1FTR+UHVSiHc3g5lCVQskKEjWIbvv+9v17FK?=
 =?iso-8859-1?Q?vMT3abMmYRRmwRfNYwHcv8iFHxaudIEAqSU5mnZg3ob4Qt81o4eLQGgu7b?=
 =?iso-8859-1?Q?kel7/Sm39clyWGTC1fWnBz5gcJfxo453/BoZvfE9Vq3os6quftdA9cKomv?=
 =?iso-8859-1?Q?FngoArLpIazuetcyMlP5sqCLlh8gajEmFfFmdovj/rk5Es07wloV7/OOhv?=
 =?iso-8859-1?Q?tBXB6Bqh8T4PltmM/0Tm/5SqTwFBhyqDihzXakPVzNS8EVwktnbmiaDSH6?=
 =?iso-8859-1?Q?0oSeM3/dLTUNPXi60gzKCuB7YVp8ACRAW0NUO6y9OfPKenT939dkZX9Okw?=
 =?iso-8859-1?Q?yR1Ztix8eGscoUju20BIDOvZEMuhpiXeX3YPVfuUxqKgBhF9VTl9zrqctI?=
 =?iso-8859-1?Q?2bV0dfAXK64s/UeEch05J6oKPnR1gqb+QQEyGH65Ca0yRMdk4vwMzfH6TK?=
 =?iso-8859-1?Q?3xEU9173ozzdk1Hird627xDT26kvdeGXy/R/rf5iu7a8biCjJj/+cU+3Lx?=
 =?iso-8859-1?Q?ey6UTMJVKZa2ZDVT8mhEIGgIThTUQuHzDgjvGVXSVv9TmXCbdEhxfc4dpA?=
 =?iso-8859-1?Q?0R+IPGSpbOsUNr6bRZOvWM+pwE6fD855w//xmaxhhiJSSPM4CTeshePmr7?=
 =?iso-8859-1?Q?96fsurbQRzLNKT4aAhUAux5ovE17Kogj4coDi9WHgPJJceHDr2gWWEj+4N?=
 =?iso-8859-1?Q?vc/qwG0C/QZUQ209nJsfeagpOGmQj2QZLG6gngReutL5l6KOf3JL+49dpA?=
 =?iso-8859-1?Q?h1KPmUYE4H+ldOmE0Eya7XEqlPRfLymtgV?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <CFB03160B1718C43A8F80FABD5FB27A6@oracle.onmicrosoft.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	9w45TtbQLuezsBspmTgq+5XCjSmZ71AZ7q7cCTulKQgB8V4MeLAO7cf0zB7Sq0yJ1uHfB/SpsDWCeJhpZGvtOcGIgZcsOIwXugDrnlOKxoLKXDBoea/ReJZcBvPP7r5rXQq3D+BLhlAo7ITbVoLsieO6IF2DGvXGI1yqhmisX6wP/R5l1Inco52PSUxxakdC2VKMjx8908M8WE1oEp9IJLQkJSb1ZTNEQ6nuC5RTyxjkxm6tPvrHHUVQveO+NbE72Js/1eXSwKg/2JDuQ+8Ih9IvISo2mQTPRW+CGeoslj44lG/guzBViGECkqiY+mEDy/Mit+1h3rP83/Z21Wc8wL7n2/5PDmJcuDYZSFgPwNyxWgJhyDxofxOnUiMrrqjrk+2m3CbZGGuvGyHjEtpy8nj7XXQSZu2k0bM4mZkn6beaJDxzvbfUrz88a9UwaELAH4dDATiFJ35X60U3SW8LZCJa9c/Plp4gwRvTnK008NamwB4qV3gKgqXBxWA0/fSzQsTVLwyNlPXT00RNpL1mUR8as2r1LB7LX2xxydZEz0Gv/lvVOU+qqQdyKNy9Oc5hHdELRJ1w7GaYPrMvZ1FC5gCLfN2Jhf9wk+HesdXBJBM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 229123b1-58d7-4485-cc9f-08dc8ada3039
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2024 12:21:29.6242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dmA8DBy9twL1lXV3RSskO2XQIURHd9NBSMFIUB2w+QSi5a5R0j+dIKH6PhSJHpszDs2ELb1T6N0lexlVSIFpNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7062
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-12_06,2024-06-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406120090
X-Proofpoint-ORIG-GUID: fvrBzYq-dCEFJPGCdX0HRynRi6-ZVuNf
X-Proofpoint-GUID: fvrBzYq-dCEFJPGCdX0HRynRi6-ZVuNf

On 11/06/2024 11:25, Paolo Bonzini wrote:=0A=
> If __kvm_gmem_get_pfn() detects an hwpoisoned page, it returns -EHWPOISON=
=0A=
> but it does not put back the reference that kvm_gmem_get_folio() had=0A=
> grabbed.  Add the forgotten folio_put().=0A=
> =0A=
> Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-s=
pecific backing memory")=0A=
> Cc: stable@vger.kernel.org=0A=
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>=0A=
=0A=
=0A=
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>=0A=
=0A=
=0A=

