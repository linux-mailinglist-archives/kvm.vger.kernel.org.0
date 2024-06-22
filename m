Return-Path: <kvm+bounces-20318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D948191311B
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 02:13:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52B301F22077
	for <lists+kvm@lfdr.de>; Sat, 22 Jun 2024 00:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE8A7F9;
	Sat, 22 Jun 2024 00:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PCdvfdjH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pmjdgMlX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4F5384;
	Sat, 22 Jun 2024 00:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719015228; cv=fail; b=NAKf6DSzqPN6gbzkJlsaXXRyBimURem4Qzqzbv7QaP+a2JcTB5zTUengYAQgAKCtA4SsJ3KaniePp0TxTxF4q6qonvp7zBbtpsFxbVtPcCZZjxVjLQ0iPXfeBv81G7GkWIRwQnXsnlaSy+8llbrYhWejXlYGLo5h8D35e/QUX48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719015228; c=relaxed/simple;
	bh=2i2ERkUGQRj+tnRhZn0KqIVqZX4WZ/zF9K3gJbcdpGg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KE64pjohcOAzcB5pzKqts/08rwrsY9d9gYEpkMUCY3v3bDRXulzhZ6jxx0UBP4CCb0zamWoJeiPw5UmsL/FxkfFwgwjVwX+xPFLY0c2b3CN6DHgJWpPMT8wKWtmNFqLLtLsyTUAOCB5alPuvx/wrtPxkfZ7yzpAjIjwAK6LjOKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PCdvfdjH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pmjdgMlX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45LNiuSv013301;
	Sat, 22 Jun 2024 00:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=corp-2023-11-20; bh=xMm5ODqRsrPuMl9o8PXRdXYnR1OyUiK/sBIowuTsr
	uI=; b=PCdvfdjH91uTArU2JIwviSaymwHrB1cn/ltl4ei5NGxaEukJtTvjOgBPq
	yO2UYITE0Rh05mBV03qe1KUJUMRc7M2/CyhE0L8JTqlJuzeBqT3fXsYzTyZ7DMsI
	NjgjwBAi4UbAjfrkfK+c2sFEupWkXPjK8hoTGG+JqW3FH0fs0KPdLrvw1Oc1LTa+
	szf94QezIDOYx2NswvAFEmTfD+AN5kcj+58r7JpcgSX2laQLREJGVamiKQMLvdAm
	/YppL3dKe+USxGpmCWBbwf+7LfaF095omTx/mcDrdzVtSnPC5aTqIdawTUwyfxB5
	e+wNYZQQnbNQthWlTsHrZivWQZgLQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yvrkftr47-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 22 Jun 2024 00:13:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45LNR8rS019618;
	Sat, 22 Jun 2024 00:13:24 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yvrnays6e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 22 Jun 2024 00:13:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALMwkaMNQjKBlnKgzeF8ItzVpI00d7eePQGA6KVp7HDgy0vbv8FzHD1lt5fZ+HWv1TVvXL12bS6GudGQNo81m1H7zQ2eT30feDdLZ5//J7APvGBqZAl8318wsrigBGYWMhcYmqJvtoTI2tlbv68zC4HNCZ7vkYkQLf5MLYj2ycv/saqsqcfsmW+0ZWeAPc+FgbZdtfEHzTgAGauf0+kWFwvSx8XeunFyv0LUu6+IpfQH6cnH0KJ/LpDj9RYwZjJw65IsAOgX7HIxDOoavexp6u7Zv7xRY2DjKG45fyl+S5zziQGgWkiPfqpDOZsl/T7WypoFq96tVOI3WJY8Le5TSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xMm5ODqRsrPuMl9o8PXRdXYnR1OyUiK/sBIowuTsruI=;
 b=JXNdm/Jd0hpGBF8SljK68rbrTJqG3gsQWlgJQ9ZPVJWmbioy6BPupqKkbLfdWNdYBVoJEV7QaB2rgjJnrSOKP55Jcb+GEIAb2DiT/cOO9lByfEdzJOmQUxaFxSC/UADoyfwbml8i9ntgxrAG8gR5IRliSP8swUz5by2ATAbf/URnVTlasrhdZrg8BJa3kG/DJJ7xpcN8we8cQDGNvF1lRT4Fb/37+Vg30azDlfy0+s7MRcRSf88BFTECaTmeFRZN1mV5WHS1PZKgMK9UsZXBxLpszmHjjwiqIB4WAheYfZBA3WOG4mmz60Pw49OCxqdyQE4yR+6kiZc16hxBfcHq4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xMm5ODqRsrPuMl9o8PXRdXYnR1OyUiK/sBIowuTsruI=;
 b=pmjdgMlXm1r6OOYsRUHze9YJFlvbQvKXBvCPIwz3wtDwpGVlxGqBMl4ppQuku/YWRdGmeZ/nDPaR6h0HVkzTADmacFugzSVw05vT+Nou48wXbm4BSSfys1QJN4z4ePjIdGMJ+qy7BhhWUOpi24KyMZtovfXL9PGzdg8eYcX4r94=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by DS0PR10MB7362.namprd10.prod.outlook.com (2603:10b6:8:f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Sat, 22 Jun
 2024 00:13:04 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%4]) with mapi id 15.20.7698.020; Sat, 22 Jun 2024
 00:13:04 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: Michael Roth <michael.roth@amd.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
        Brijesh Singh
	<brijesh.singh@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Liam Merwick
	<liam.merwick@oracle.com>
Subject: Re: [PATCH v1-revised 1/5] KVM: SEV: Provide support for
 SNP_GUEST_REQUEST NAE event
Thread-Topic: [PATCH v1-revised 1/5] KVM: SEV: Provide support for
 SNP_GUEST_REQUEST NAE event
Thread-Index: AQHaw/7fb1OIi0jFq0ycooaD40OyhLHS+lCA
Date: Sat, 22 Jun 2024 00:13:04 +0000
Message-ID: <d0363471-e175-4d58-a6af-9c38f51d31b4@oracle.com>
References: <20240621134041.3170480-2-michael.roth@amd.com>
 <20240621171519.3180965-1-michael.roth@amd.com>
In-Reply-To: <20240621171519.3180965-1-michael.roth@amd.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-imapappendstamp: BN0PR10MB5030.namprd10.prod.outlook.com
 (15.20.7698.013)
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5030:EE_|DS0PR10MB7362:EE_
x-ms-office365-filtering-correlation-id: 82e705aa-5f6f-456c-a3c2-08dc9250161d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230037|7416011|376011|1800799021|366013|38070700015;
x-microsoft-antispam-message-info: 
 =?iso-8859-1?Q?pDl4ihGEm/bq11p7aSnxJoYe3L/wJbNVJO4bSNscvV+TbViRB9q/1v16zc?=
 =?iso-8859-1?Q?NFemz4j06bMgkrxgqQ83C4UlZmGO702npDyb76YAj20KVwLNNXaV2mV3Zn?=
 =?iso-8859-1?Q?t7jXz2NymXYB0kzjrZe6iHVmk9Y7oTu8uw5x9vFob3XgkQTssSPHGOIdJE?=
 =?iso-8859-1?Q?YoLK2stscI+xABJ/yw1aalqrg6BmBfWEDtCHH8ogfNRqsVeSd+yvOeMGGj?=
 =?iso-8859-1?Q?i/idW76bwW0GZpi4+QB/ejJuAi4UBaai+5oIzkDDtzbPogLXty+mzqPxit?=
 =?iso-8859-1?Q?IXPoAX59gPGCzImpSXtTg0Cx1QQvWX/c2WqvruDqBKisL6eoM34KDIitcI?=
 =?iso-8859-1?Q?0kCbJIVJSW/I/rys71rKfST9VRzGNz6syx1zNhtWkDCF23GxJN1OoD7rUG?=
 =?iso-8859-1?Q?ktIbq+PGlnQFothoZDabYHZuSpANufXXd2GTWN1y6tnJBE5nhCVRRtN+bj?=
 =?iso-8859-1?Q?o7nhCnqXxuGrHMq+gD8gT6FlIv8+K8g77U5IlYhJl50e6gRNHV8KQwYxoQ?=
 =?iso-8859-1?Q?5PRFbqF0vDf6gJt2wRD2F77CzYmzXFpo1mxkO8XRhowaLVEnJKspBTWmpa?=
 =?iso-8859-1?Q?68I/0iImc6iICyNUGdfAsqwywsJwROMnM2GB/5g5TIrnyzktZmQMGDxD/T?=
 =?iso-8859-1?Q?HDS5qBx1fmllEMxlGaNetBEiLsDoR3riB6ZU7k9bcETHZXDY4zQoi2po6M?=
 =?iso-8859-1?Q?lk9QkoU+FRWYsOiSdQKNHeVAIxUk3Ldr38PHkCUnhzrqjFCuxA7UBlBqKz?=
 =?iso-8859-1?Q?TqoZjAB1csq1pkY/MeVnvMIO64JlL0njTSdEV+uAKJMZKYJ/bu2EpSNLdY?=
 =?iso-8859-1?Q?jO9QMk+9a+GsGBdi8NgqmaY5yGcDE6DKSqSRRZEuxJ3En7ZvH+MwiBLR/u?=
 =?iso-8859-1?Q?HFCPAIbiRFkoCBM6wFWPVDMN0u5KV7c0b/lKgqxgp57ILuY1RL+38BecwZ?=
 =?iso-8859-1?Q?oeu5iak/VXqPEUcYYK5BR4xbqThAqAwvbBYBE1U4uH3IduunXQXf9Hhbnr?=
 =?iso-8859-1?Q?IJISjffBgt33mNhWawWyJyxQmny5jxuJ1RAmLUvG23wxPfR5/DDTA0J/m1?=
 =?iso-8859-1?Q?ThxbI+0K8jK+7KnwRYx1gBkZO48JZZnBQr/GoMHkPrRxELs9j0FKmsY9aK?=
 =?iso-8859-1?Q?0zoQGY4BW+/08al63TA4lRofLEmDpVUomQEyRM6/XBgzP9/v6IZn8oCZJ6?=
 =?iso-8859-1?Q?AzPdlanKrDw6BWlJtgKkfaiWpIZOrneROiMCZgfnJTbVr+6D6ZNmue6eEt?=
 =?iso-8859-1?Q?qh/gN5rI9VwvinoTOrXfDCQymoOJrnot/c2CmIKnjZj2ME5wxI6Q/E45ZK?=
 =?iso-8859-1?Q?aviWBjASl/0BDIsWkmiR3WOBxqsWEMK4fs93wzOvUjTuLG7UggnL+tGjGa?=
 =?iso-8859-1?Q?khHmESlYUI1Rk5MnCltDfXmMHio7AKeE89DYfcnKHvyHBxXXz/vL4=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(376011)(1800799021)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?iso-8859-1?Q?qQtDpM90HRxk6344aC0vsU2i/6DNkXNHbcrqvZJKhZa6IEv0rRetezJmvH?=
 =?iso-8859-1?Q?tTDJKSt9FpZ3v5U/iZypAjE2XGJ3d9BZU0Y+NvxIRZISqc1xW114MkF8c2?=
 =?iso-8859-1?Q?ZazP50Cxu9+bGkyAWjB+54IyOf31m5IpImUpy3KFG6m6RqKLb1yMWkAbTp?=
 =?iso-8859-1?Q?4+8U1OgWz1honf10lD5S+keIJcbhKwNOiYnsNz/rEqXcjydtyWHUMCdHAp?=
 =?iso-8859-1?Q?NJT3X+keGRQRpbW6nAlV+rqINhYwAYzl2CNuVDREbj3qxqyYd6GagP7kY9?=
 =?iso-8859-1?Q?jUbdiGDwu3us4dUTQEVBI+dUWC1HBPnJfyqU5TvFfuL/ANkS6KbqCItm2Z?=
 =?iso-8859-1?Q?2rfzBtqrvnxf5MD6nC10aavcMiuVkuWwSRISaxgPdXNH25jqYRKQylb2ZL?=
 =?iso-8859-1?Q?AT8LCkasoiRrTMF+RQuJ1SfIKhn5sf9+uJnH/gbykL9ionvFNdu14ei/QE?=
 =?iso-8859-1?Q?5nieV7Nas0y81MDOxNHyWkFtqfwvzisOUC8zdlpqj8dj86J1XZ41PNXr/w?=
 =?iso-8859-1?Q?yVYQKW3s0/mwM1dA7mZe67GqlWDm9CqhLmu9dJdphAeAdc0rBipkb+9uz0?=
 =?iso-8859-1?Q?jPhFVdLQoXQ30P7/htj0xWIUjlfEtQV/xTYz7KK8WFpdOET2ruxpMfNfZS?=
 =?iso-8859-1?Q?t3UFt+IOtwmtmbHHfUC+SFB1SWVEvM6Bx6ERTWH2KayDGIbMfHxi6r0RnQ?=
 =?iso-8859-1?Q?BC4T0Sn5H48w6HjwMErvU9gZa3ApQCF7lz/DRovjNhEamD17/rccItN2Rm?=
 =?iso-8859-1?Q?y9j0gUUqKf54e/sNnmJuz1dDzzVKXh6vf3/RK4wMp43YVmSY6qWbbpoJJf?=
 =?iso-8859-1?Q?jhBAEXCRE2uvCN9qAoxIG+5/SYkfwIvrzRPs0JaALTH1f0iRrfNi9cdjQu?=
 =?iso-8859-1?Q?1PAtXXZOMPiLTE4ZtydUVgfJE6WQ00qBdGHieXWjJpxYF19HIuLTEstkw7?=
 =?iso-8859-1?Q?+2PPVUElAO2rM75ohTWsoirDz3DQn33/xYX2wxHM166HZwiHggolEucXkn?=
 =?iso-8859-1?Q?qkeQs4C8/h0xJJcsWrVuLwidSwKPLRtWPRJABAhBXLEjceGfAbaLaNGZhv?=
 =?iso-8859-1?Q?HDmRXPhGF1qzKLYshm+/ZENPlgRmmZBvbStWSrRUmxC+uopGxfi7sY1nXt?=
 =?iso-8859-1?Q?zgepzjQwWtwDj7Uco5XE2q6B8bmUgOCg2JGnvCpSJyVFWjZ8rCcTXSzKSM?=
 =?iso-8859-1?Q?AalQYZWcZ9RTHyi03P9YKG3rOZb7LgM1ouFxHdcDhreR8Rt5tJyuzFjHUs?=
 =?iso-8859-1?Q?LEeR5LucZSo6rawrBReSDzEE1BNajW+G280yjfI17tj+z8nHSdihvehuz8?=
 =?iso-8859-1?Q?AJ4vFFenkSNQWjgTtdVTMpaEVzDWkGMZZ9R79cQHMsryZ3866JxsYtQvnv?=
 =?iso-8859-1?Q?3cMb7aImuN5Zpa54WFNHP246wA84VYBvFNi9Ul2z8Xrb9KBliQ1uoLktUj?=
 =?iso-8859-1?Q?APETXnbZXXO9tnXtDHrZdJQYWEr93T/In6I7wOYCaIJpTfjMTQfT7WxQwk?=
 =?iso-8859-1?Q?hEYzJM63OUC06fd7hi5GkSL6cIeQs9zOaFeC7tj2BO2PdVcknBu/XV+wHB?=
 =?iso-8859-1?Q?q+2QjHZqvUWV7h/YZ/RjqW/Lz4/h8hVNCvpN7y7Rjeytx/7BqGgvVS9Y+O?=
 =?iso-8859-1?Q?XJqKUbS9G7Hn8CF58OCXfT1KhPd4Bfk27U?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <24958ED1AA28C84CB1BDAF29590D7E78@oracle.onmicrosoft.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	q9/YWTfv+EI3F0UGDX9gnrHdpISy9dtEzZaMMLblSfPmqXRzqLyICcCWbEAqg19J8GvXut4RgRAqmyN0Jb9h0QwajohLUuoVmEopz6G8OaSMqNdaS+g1588KmVuot8bnlGmu/X1Iy89qSWcGitlRNiwRC34jJXb9x7OmcUGuycUcPBYFJ0V9U6VwWwD7hdJH7vP3Ki3cm/nYu7mLCrF4T3lChj74rwILalHmHCeLySMcGAz9oGK4hZ5PrWnIrEkpfbQeDAoHedB9WSO8AKcVR/OcCvVaMq3kwq8hwURFlw50cadBENw+GNnpPHHSFHT+FO//aRk+1g2wgOAnSUURi1fGvWMFbmEPnmuHx1CReyxY5Elwb36CYgMgKJTkzprOhs0LJvZz8QOmRQEMssHnE4tKEIe+QWFBXTOl54ihRr5bivyYJA9xqtiSiGKUa95fcodMUKbjsU6R6ur/1ORaY11abZfiRnDBLGBsixU7OKIYlUPUMVP2osDlmgJP6DwfB+R/wbm2l80Vi9bOXshiXBsW3U9sDNi3Z4QAlJfuUE3aifLRIT1W//VRsTOcidBBe7x3UejKxKs7lnTxi5Oo6O1VmWHOIf+Sa4TE9mBiMhI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82e705aa-5f6f-456c-a3c2-08dc9250161d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2024 00:13:04.5646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9/IFrtvX1dNZknJ3oLx9wxFO1lqTlY+gZWrIUbL1/7XJXcA1mtbHiDgutDetqoiW3bkLqMNxujUJSRngVOJExA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7362
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-21_12,2024-06-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2406220000
X-Proofpoint-GUID: aQBRVmE7WfBOWwBVgUms0nzBR6sPmGsf
X-Proofpoint-ORIG-GUID: aQBRVmE7WfBOWwBVgUms0nzBR6sPmGsf

On 21/06/2024 18:15, Michael Roth wrote:=0A=
> From: Brijesh Singh <brijesh.singh@amd.com>=0A=
> =0A=
> Version 2 of GHCB specification added support for the SNP Guest Request=
=0A=
> Message NAE event. The event allows for an SEV-SNP guest to make=0A=
> requests to the SEV-SNP firmware through hypervisor using the=0A=
> SNP_GUEST_REQUEST API defined in the SEV-SNP firmware specification.=0A=
> =0A=
> This is used by guests primarily to request attestation reports from=0A=
> firmware. There are other request types are available as well, but the=0A=
> specifics of what guest requests are being made are opaque to the=0A=
> hypervisor, which only serves as a proxy for the guest requests and=0A=
> firmware responses.=0A=
> =0A=
> Implement handling for these events.=0A=
> =0A=
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>=0A=
> Co-developed-by: Alexey Kardashevskiy <aik@amd.com>=0A=
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>=0A=
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>=0A=
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>=0A=
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>=0A=
> [mdr: ensure FW command failures are indicated to guest, drop extended=0A=
>   request handling to be re-written as separate patch, massage commit]=0A=
> Signed-off-by: Michael Roth <michael.roth@amd.com>=0A=
> Message-ID: <20240501085210.2213060-19-michael.roth@amd.com>=0A=
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>=0A=
=0A=
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>=0A=
=0A=
> ---=0A=
>   arch/x86/kvm/svm/sev.c         | 73 ++++++++++++++++++++++++++++++++++=
=0A=
>   include/uapi/linux/sev-guest.h |  9 +++++=0A=
>   2 files changed, 82 insertions(+)=0A=
> =0A=
=0A=

