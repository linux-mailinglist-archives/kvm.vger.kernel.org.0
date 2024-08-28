Return-Path: <kvm+bounces-25235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC109962302
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 11:09:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D8F31C21D5D
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 09:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 256DF1607B6;
	Wed, 28 Aug 2024 09:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="CGevrb/M"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2BF158543
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 09:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724836124; cv=fail; b=e4dQc8pMun78V5Tpgb9AG543dgiIT7jjCG1MJ1be8yAoBp7LA+yVcf/IKDq0wN6rtXFKMXsq42560UdS/qn1BVwi4/kyiHOjAgZG2kPWAbbIXYbmc4VFt3n/v4dAd2Qhh9OzVNo1/U0Lz5VaYfbRB2fEhz5tRYfcsZHfR3+Tts0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724836124; c=relaxed/simple;
	bh=Ei4h9BoRkvGS1C59FgDTLdKfYsM6mzj9uPtolSBZG5k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GcVQmnKF/aqOphBVDI2kzYFbAS8VjFS7mSLBuejaen6Q9njuPI33EzhtzMuRwqerHchVw5hu+1ShWc8b1eMc98gjeGfQgqQlOxooG36KiZGU4cRYLrEXt2/l8e7fvjey4AZo7L/hzBCaVpYMq0uxNddZw3vNba3wHAR+mzFgWNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=CGevrb/M; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47S0HUrU029993;
	Wed, 28 Aug 2024 02:08:19 -0700
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 419pvr244u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Aug 2024 02:08:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yfv+0xcCaAVCZBjpBvb3piSvdY442sDVyv+sSjtwTpRod9xNLns7pYmasVKBg+mbNLy4K1G8cq4nSuVcjk0j35iwMDLIGXrCxL9flfASFCXiB2cqwBQzZjI7S09e0tmIgRBX1XPkG2xp4ideBrBu19INqFQB2y2SUk7OPmnDtgi3+doZ34PygQG6yjPPmlqUqAEXbCVexBntPIOfCK3PBpJZsSWgULVXmTvAxWL8SRuSIVdiIigZC1PYPA18eo6UkTPsg2rbojMBV64WW1GzkaEnnfUVMfxN6mF3j0vpe6jicxW+L6/mqlp/IUNhF9iMED4h7aSql8CgEcmQhk0sSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ei4h9BoRkvGS1C59FgDTLdKfYsM6mzj9uPtolSBZG5k=;
 b=SdC+voThV4Ttj1x+g3xYuTPJJddlysGUMv9xuUCQGme8CcLoy3PPd8+XjGx8WkLWY+EKXq+mf8WC/kOX2CIeJfTo59vRetgj+fgC6n9qU36D1lumKhtGmMCmsSACyfIDaWH+OIiVZvjka48Kd6yhmqvzMKi41ozgflj35x31NYxEAjicQk1N/K2TpNnFZIzLeUnv0iMQei6iJUW1eDoyAR3vg3Ad9Nojk3Rjb1GVlzYzG2D5o0ECBemaQIH/knbxfU2kzoIOwEAwnhYiW1TgefopKTI2Fpw47lVoC6auY95i2lAb+gFJ0Q9H18TIylAE/emdXWB+9nZJSl5PNG19yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ei4h9BoRkvGS1C59FgDTLdKfYsM6mzj9uPtolSBZG5k=;
 b=CGevrb/ML50GYm4PXSw75NSGMIe3hnTIhjne7OKaZXw0h+24nTehxVc3Was3A351gLZg+aDgSj753FSsTN6YjjyP/Ynac208dTC+2lxJCVtXGc0vj4C2BB2w/5WtXJgQVm1/Z1ngVLxQ0N00MbRqRovHRnNFaqdiykxP7akFolY=
Received: from DS0PR18MB5368.namprd18.prod.outlook.com (2603:10b6:8:12f::17)
 by SA1PR18MB6020.namprd18.prod.outlook.com (2603:10b6:806:3dd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 28 Aug
 2024 09:08:13 +0000
Received: from DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac]) by DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac%5]) with mapi id 15.20.7897.021; Wed, 28 Aug 2024
 09:08:13 +0000
From: Srujana Challa <schalla@marvell.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        Vamsi Krishna Attunuru <vattunuru@marvell.com>,
        Shijith Thotton <sthotton@marvell.com>,
        Nithin Kumar Dabilpuram
	<ndabilpuram@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>, "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
Thread-Topic: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
Thread-Index:
 AQHasnq4Ve/zJa91a0mQb+nM4LHR9bH6+HqAgANtqRCABESwAIAAB/wAgAGBD8CAAEc/gIAWCbHQgCJn50A=
Date: Wed, 28 Aug 2024 09:08:13 +0000
Message-ID:
 <DS0PR18MB53684A307C08D17276A465EEA0952@DS0PR18MB5368.namprd18.prod.outlook.com>
References: <20240530101823.1210161-1-schalla@marvell.com>
 <20240717054547-mutt-send-email-mst@kernel.org>
 <DS0PR18MB536893E8C3A628A95BF8DDA0A0AD2@DS0PR18MB5368.namprd18.prod.outlook.com>
 <CACGkMEtQ3SWBpS-00BBCJxoUK5AQRB=FhKGEqigh81GTbRf61A@mail.gmail.com>
 <20240722034957-mutt-send-email-mst@kernel.org>
 <DS0PR18MB5368298DAEA53CF7F9710B46A0A92@DS0PR18MB5368.namprd18.prod.outlook.com>
 <20240723070326-mutt-send-email-mst@kernel.org>
 <DS0PR18MB53689BE0C0DFDBD86D396515A0BF2@DS0PR18MB5368.namprd18.prod.outlook.com>
In-Reply-To:
 <DS0PR18MB53689BE0C0DFDBD86D396515A0BF2@DS0PR18MB5368.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR18MB5368:EE_|SA1PR18MB6020:EE_
x-ms-office365-filtering-correlation-id: b85a60ac-bad7-45e3-9df9-08dcc740f20f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VS9XRU1keVJCRUhEL1U2a0cyVm4rMG4weWI4dUE4WHhGajlnYnlKYkZ4Z2I1?=
 =?utf-8?B?ek9sSlBCc1hpSmo1aHRLcWNNeklCaGl0Tk1WemVlUGt5Z013OGxuSDNZMmZa?=
 =?utf-8?B?TE5yOWRFOGhMdU56S3dYUUw5ZDY4VFF3Z1I2OGtjN0NDOUc5aFMxVHpseWFZ?=
 =?utf-8?B?U09DRCtMS2Y4OFQxbzFVb0tOVXRWQzAyZkI2UGMwbDRHTzRMaUZtdUszbEc5?=
 =?utf-8?B?ZjVIYWUwVXlmOGZROFFtdWVTWUhXcG1UWFFGbXA4OHAyRUdSOVR1M2YrU3F2?=
 =?utf-8?B?OGR1K254dEJqRWtUcVlyWXp6QlAzSHUrVEJ4UHUvTExzV2ZFamk1VDhQV3ZM?=
 =?utf-8?B?K01XVmMxS3J6UTVPaHVCeFZzem9OVVdDK3pUZHFCcnorcUYyUU5wcm9rcENI?=
 =?utf-8?B?OVdCV3ZnaDUvaUEyY09JZmlMd1ZGd2h4aFBHMTYzSzRiMmFGTlZJWU1BcnMz?=
 =?utf-8?B?TDRza2RyWFptV29jbFBxZzBrZDVxeE00VThuSzNjRThnZnI3d3E5TUpMeDh1?=
 =?utf-8?B?YVVUQm9CQ21JZWZsRHdWcTErV2kzTjhCTzN1bUFsYlZCaWg3R3dyaytyT01H?=
 =?utf-8?B?OVI1cnFjZVAzbEFMMjhLaEx5Rlg4UWdxWFAxNXpWWlFJdmU3UXBWMzFzZTd6?=
 =?utf-8?B?a2tteDY5VC9NRWFodVhweHk5ZldkMHd3WkJoTUFlc3JSOEg0M21jVE02dGQ3?=
 =?utf-8?B?cU1ORGx2OGRnYng0M1E1OVFPbUVGd1VhZXp1RjJiaEdNTno1WUMwb01nRGdx?=
 =?utf-8?B?R2lYSjkwZzliZHVLcEszQ0tmclZhbExLRW1VWkdrU0hPMTdSUys4SVNWVThC?=
 =?utf-8?B?OTVjaitsRk5ZS09QOW1OV2ZFV2JrRW9EMGs4YXlEbWtxOXpEY0dnSkU5ZzhB?=
 =?utf-8?B?blJJdGIyb29HTm04UjQzZVV5UHZteFJTRXNKaEtXME9LVUpKNjhDQkNMOTF5?=
 =?utf-8?B?ZmJsNnFDOXpwMU5VeXBvb0FBRnZlKzlYbmc3L3B3dmNiZmR2VnhZcUxwT1pm?=
 =?utf-8?B?RFdDa3dRUjdWNGYrWkxEeSszWjI3ODF0aVZHM3FLeTdlTTRRRHlmQitZR1Mw?=
 =?utf-8?B?RkxQWGFYdGxTL0tYR0g0Smc0TFd3Z0hwamdIakVuVjVyMU03em03ckZENDlk?=
 =?utf-8?B?TXV3Q3F3bHVHdTNxY3Zpejg4SzBqZERoUDhISTUxYWpodkNqZzV2eHovb1dN?=
 =?utf-8?B?YllWOHFaQkJiT2YveE1ibHBiZGd6YWw1QitqRTQyVGpLNmlvUjNveXZtWTBC?=
 =?utf-8?B?UUJacGRZNTFKWllMYyt3bDNyeGdWbEIzTXJYUXhOK1VsdGRuUTN3Q1ZpZUk2?=
 =?utf-8?B?Y2wybzVENU1La2tBTEQ3VUZoRzh6OEVKeklQUFp0cFpYMTJDMmZFNVJvWmti?=
 =?utf-8?B?UFcyazhOQUZQTC9LNUwyRzNsNFNEeElqU2ZRcjV0Zjlna3R3akcza3AwY3Y4?=
 =?utf-8?B?YjVlSVBXSUNISUVhTVZyQzBLNjJEaFNSbTd2NGZQeWVrc2NZWEFKNG1FYzFq?=
 =?utf-8?B?ZElCUStrL2t0dWtDdWFzZ1ltZnhMSDhROVVpUDhWdm1FZTF5RHIvRHJmRm1F?=
 =?utf-8?B?RmpwNmxabGd2aTVsWk1Ia3NROHNNWVN4akdrTnpTMlM4VDI4dWdZTzZtRFBo?=
 =?utf-8?B?K1hlR2RjVVdOcVpPSytobFdwdEEzcUE1ODdEdGc0NE9QTDQxMDNTK0lYNkEy?=
 =?utf-8?B?SkZCckx3bDUyYnNjZEV4R3BtVnpBaGlKajNOeHJISE5YUzU4WWNVa2Q5MzQ4?=
 =?utf-8?B?UTBFaTRWUUlzR1JJRHhZWWFCamJKR3VCVmt6NDNLR3JSSjdsTW1CVzRtOENQ?=
 =?utf-8?B?eW1KRC8xc1gvS05CNU1FR3piTmZRakVqeWkxRzlzYUs5MGJsL1Y1OW1ZeU9v?=
 =?utf-8?B?U2w3V2x0V3plVFlPbDFOY29pdklRUHBvd0xpK3NicTBrTnc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR18MB5368.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RTlzdTR5T0VNT3had0ZpK0hFM3VSaTA5TjcxZWZMbjlxWkNDalZnOWNqOG82?=
 =?utf-8?B?dzdWVVJvVCtBNUliYUUvbHRpZDJPWnE2VnVIdWk1R0lpbmNpc2JkRFdOM0hS?=
 =?utf-8?B?dk9EdDRqVS9aOXhVRlhJK0Z2TCsyQW82M1EvR1lCV2U4ZWNQK201MVVaalZl?=
 =?utf-8?B?c0NVZ2xVL0o5cG0wYjQyQWpNQ1V5Q1VPUitoRmtqWTRzSEhnM0lUOGszMkp2?=
 =?utf-8?B?NngxWmZEL2tPYTMrekhld0tXc2xyeGxqNUhHQ1hnYzgzcEpoM0dRODhFUkg4?=
 =?utf-8?B?RHVBRnJpd2NSY2ZKYi9XYWZHUlVSVS9iaFVkUUd4QTRXOXFyU3lrcDU5MjZs?=
 =?utf-8?B?RkRPK2RGam9BOUVpSWF3Mk5OY1lNWlVkRXlPQ21CeXNvTDlyamNCYVZDZDlw?=
 =?utf-8?B?WGZBVjRIenhJSGFHc0tQVEFib0l5ZisvU2RVZHFBYjVkWG9md3ZNN0l3OENV?=
 =?utf-8?B?OTRJMjk5cWthZHJWeTJaSWdsckNLUG5PU1NwODUzTWJWZ25laTFxMlhzN1c4?=
 =?utf-8?B?Y3BYT1lDYm5JNVFYdXpON2FoVTNRek44ZU81KzV5dDFCVzNHTFNWZTdGVS9k?=
 =?utf-8?B?eGJ6ZHNTNnlqbnZHUVpLakliZ21Ld2hPVDkxYzk2ZHNvMnd3MDU1TlE0cmM0?=
 =?utf-8?B?SWhZNXZjQXlCVnVhR2hwaXRSSi9FRWNuZ1hqdzZaNVlhVkZjSUhPb2Vzc3kv?=
 =?utf-8?B?cGlLTE8rS0V6Z3oyV20zaGdwOEoyQXl0bmhydDhROWFsdDAxdGNpZ29BM3RY?=
 =?utf-8?B?OFBiNTJVOVU1UHJxSVZENWdtOENRWitYN2FqSHk5MG5TaVZDcm1vVFBxelFG?=
 =?utf-8?B?ZnNmQ0tWZTdTcDQ1aFBIczdnY2x4TzdUSXVPd0pYOVRabUJhL013b2NGamNN?=
 =?utf-8?B?YmJvV0xmbEdNRkN6TmdjK08wV2xUYlluYmRDaUVtdFYzS2J2cldEK0N3MFU0?=
 =?utf-8?B?aitYcm1nR0U2QkpwU3JOTmgxS1pOcXlacmdNcVdBUHRINlI0Mys1LzMrekgr?=
 =?utf-8?B?c3JpVDlxRlNIdUhUcU1qWDNRWVdZRExCaytrNXFRNk9NQ3c3MjZaK3hUejFE?=
 =?utf-8?B?YnAxUjBmT2FVYkFOTmRUendjRERWc2txNVdrQXdQRE05azZCMUsrSkRNOHlJ?=
 =?utf-8?B?anJldkxPMnNYaDNSQXJ2ZmZXSExoQXN6R0l5dUNaWEM3bE4rcTRlMHFSc3dW?=
 =?utf-8?B?UWtyTXZDZWp4SUZHYVNEMlJIUWlSRWFudFJKV3NnRklrcDQ3ZkdhOHkwakhn?=
 =?utf-8?B?UDZ5NFZaamF6Z2pUNnRteUI4T0lVUmFNS0ZjK2lXdXQ2czZoSjNjeXJjaGFv?=
 =?utf-8?B?TmJoeGdyVUp5dURJMVBGWWVNT0k1ZzNObFFaQ0xlQmF6SC9XdnNXL1lSVTNP?=
 =?utf-8?B?eXNEY3JmRU40bGxqU3VuRjNrWktZZnFzYUdtcVFXUzhGeDVKbkI3bVkzZnJu?=
 =?utf-8?B?U1lyS2RtTHJFSnBwTjVWa1RLYS9kaFhoZXBNa25NSTJBc0pPYmkyRjBtYUZM?=
 =?utf-8?B?cnJvSFg3bklGR3VqTTcyMDBIQ3JodER1WGxGWjlLNW1iMW1zWDB6WTI2aGkw?=
 =?utf-8?B?OXRYVWdRZkFCV2x1d0tOZnh5b3lSQTA0RDkva0lpYXE2ZjArS0hGbzh4WEo1?=
 =?utf-8?B?Y0wrbHZJVFRtMW9rbUI0cndTNGE4VE53YXc4UDR3bEpQempBK1ROcytlbFRS?=
 =?utf-8?B?eUlaSkpCRFRQVThiN09nbXd4dnRvL2JqcDRucFkrMU1tenVRQ0JYTjZwekZ5?=
 =?utf-8?B?aHlyMW1FbzBTSXBNYVZ1N2x1VDJzbkthaGpGZHVXVmFRNFZvZ1RURDZYNkZ6?=
 =?utf-8?B?aUxNR0hpb0Y4cWVKeW1xTDcrVllyMzB4eFUvbUJkVE16aWtybWNtUDFkZFpT?=
 =?utf-8?B?TTdkc1RrNmJ3cGN6WGtaWldCT0VZNnhDRDNPNlh5MWo5M01ZT21yNnhNNGds?=
 =?utf-8?B?MU5IWHY1V1p2Ujl6RVFsWVNYTis4QUtpaUFISnRtdnlCN01ZSzNEWG1iMit4?=
 =?utf-8?B?L1VCWTYxZ0YwclVveWREajYvQTJNc2tWZWxzZks4YTVEU2I5V1VSbW1xdkpE?=
 =?utf-8?B?OVFjTGZaNHoyTXNmeG96bDdTODFtdks4WjkrSHpIcmFUOS90OXZwdE1jNHRE?=
 =?utf-8?B?VWE5T2U2ZWZpUlM5MGxBZkJsYTdnb3ZHUTBpNW1xWVYveDlWbXVQbHRmbjA1?=
 =?utf-8?Q?HoBGRjYTIw16pfTfDjmmhx4/QKTxdX/chIKyTjtKP34u?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR18MB5368.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b85a60ac-bad7-45e3-9df9-08dcc740f20f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2024 09:08:13.2510
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CsMy5Mx9+BqsI48l7FULUbcO8hPqsB2YUrGnUK6umoqnzm8qs784deJILKorH63J50nfslFRf75wDA4Yxp6saw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR18MB6020
X-Proofpoint-ORIG-GUID: 9U8GfQAYNxxhOrhu2PKZ_ZWZ3eu9aN_H
X-Proofpoint-GUID: 9U8GfQAYNxxhOrhu2PKZ_ZWZ3eu9aN_H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-28_03,2024-08-27_01,2024-05-17_01

PiBTdWJqZWN0OiBSRTogW0VYVEVSTkFMXSBSZTogW1BBVENIXSB2ZHBhOiBBZGQgc3VwcG9ydCBm
b3Igbm8tSU9NTVUgbW9kZQ0KPiANCj4gPiBPbiBUdWUsIEp1bCAyMywgMjAyNCBhdCAwNzoxMDo1
MkFNICswMDAwLCBTcnVqYW5hIENoYWxsYSB3cm90ZToNCj4gPiA+ID4gT24gTW9uLCBKdWwgMjIs
IDIwMjQgYXQgMDM6MjI6MjJQTSArMDgwMCwgSmFzb24gV2FuZyB3cm90ZToNCj4gPiA+ID4gPiBP
biBGcmksIEp1bCAxOSwgMjAyNCBhdCAxMTo0MOKAr1BNIFNydWphbmEgQ2hhbGxhDQo+ID4gPiA+
ID4gPHNjaGFsbGFAbWFydmVsbC5jb20+DQo+ID4gPiA+IHdyb3RlOg0KPiA+ID4gPiA+ID4NCj4g
PiA+ID4gPiA+ID4gT24gVGh1LCBNYXkgMzAsIDIwMjQgYXQgMDM6NDg6MjNQTSArMDUzMCwgU3J1
amFuYSBDaGFsbGEgd3JvdGU6DQo+ID4gPiA+ID4gPiA+ID4gVGhpcyBjb21taXQgaW50cm9kdWNl
cyBzdXBwb3J0IGZvciBhbiBVTlNBRkUsIG5vLUlPTU1VDQo+ID4gPiA+ID4gPiA+ID4gbW9kZSBp
biB0aGUgdmhvc3QtdmRwYSBkcml2ZXIuIFdoZW4gZW5hYmxlZCwgdGhpcyBtb2RlDQo+ID4gPiA+
ID4gPiA+ID4gcHJvdmlkZXMgbm8gZGV2aWNlIGlzb2xhdGlvbiwgbm8gRE1BIHRyYW5zbGF0aW9u
LCBubyBob3N0DQo+ID4gPiA+ID4gPiA+ID4ga2VybmVsIHByb3RlY3Rpb24sIGFuZCBjYW5ub3Qg
YmUgdXNlZCBmb3IgZGV2aWNlDQo+ID4gPiA+ID4gPiA+ID4gYXNzaWdubWVudCB0byB2aXJ0dWFs
IG1hY2hpbmVzLiBJdCByZXF1aXJlcyBSQVdJTw0KPiA+ID4gPiA+ID4gPiA+IHBlcm1pc3Npb25z
IGFuZCB3aWxsIHRhaW50IHRoZQ0KPiA+IGtlcm5lbC4NCj4gPiA+ID4gPiA+ID4gPiBUaGlzIG1v
ZGUgcmVxdWlyZXMgZW5hYmxpbmcgdGhlDQo+ID4gPiA+ID4gPiA+ICJlbmFibGVfdmhvc3RfdmRw
YV91bnNhZmVfbm9pb21tdV9tb2RlIg0KPiA+ID4gPiA+ID4gPiA+IG9wdGlvbiBvbiB0aGUgdmhv
c3QtdmRwYSBkcml2ZXIuIFRoaXMgbW9kZSB3b3VsZCBiZSB1c2VmdWwNCj4gPiA+ID4gPiA+ID4g
PiB0byBnZXQgYmV0dGVyIHBlcmZvcm1hbmNlIG9uIHNwZWNpZmljZSBsb3cgZW5kIG1hY2hpbmVz
DQo+ID4gPiA+ID4gPiA+ID4gYW5kIGNhbiBiZSBsZXZlcmFnZWQgYnkgZW1iZWRkZWQgcGxhdGZv
cm1zIHdoZXJlDQo+ID4gPiA+ID4gPiA+ID4gYXBwbGljYXRpb25zIHJ1biBpbiBjb250cm9sbGVk
DQo+ID4gPiA+IGVudmlyb25tZW50Lg0KPiA+ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+ID4g
U2lnbmVkLW9mZi1ieTogU3J1amFuYSBDaGFsbGEgPHNjaGFsbGFAbWFydmVsbC5jb20+DQo+ID4g
PiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+IFRob3VnaHQgaGFyZCBhYm91dCB0aGF0Lg0KPiA+ID4g
PiA+ID4gPiBJIHRoaW5rIGdpdmVuIHZmaW8gc3VwcG9ydHMgdGhpcywgd2UgY2FuIGRvIHRoYXQg
dG9vLCBhbmQNCj4gPiA+ID4gPiA+ID4gdGhlIGV4dGVuc2lvbiBpcw0KPiA+ID4gPiBzbWFsbC4N
Cj4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gSG93ZXZlciwgaXQgbG9va3MgbGlrZSBzZXR0
aW5nIHRoaXMgcGFyYW1ldGVyIHdpbGwNCj4gPiA+ID4gPiA+ID4gYXV0b21hdGljYWxseSBjaGFu
Z2UgdGhlIGJlaGF2aW91ciBmb3IgZXhpc3RpbmcgdXNlcnNwYWNlDQo+ID4gPiA+ID4gPiA+IHdo
ZW4NCj4gPiA+ID4gSU9NTVVfRE9NQUlOX0lERU5USVRZIGlzIHNldC4NCj4gPiA+IE91ciBpbml0
aWFsIHRob3VnaHQgd2FzIHRvIHN1cHBvcnQgb25seSBmb3Igbm8taW9tbXUgY2FzZSwgaW4gd2hp
Y2gNCj4gPiA+IGRvbWFpbg0KPiA+IGl0c2VsZg0KPiA+ID4gd29uJ3QgYmUgZXhpc3QuICAgU28s
IHdlIGNhbiBtb2RpZnkgdGhlIGNvZGUgYXMgYmVsb3cgdG8gY2hlY2sgZm9yIG9ubHkNCj4gPiBw
cmVzZW5jZSBvZiBkb21haW4uDQo+ID4gPiBJIHRoaW5rLCAgb25seSBoYW5kbGluZyBvZiBuby1p
b21tdSBjYXNlIHdvdWxkbid0IGVmZmVjdCB0aGUNCj4gPiA+IGV4aXN0aW5nDQo+ID4gdXNlcnNw
YWNlLg0KPiA+ID4gKyAgIGlmICgoIWRvbWFpbikgJiYgdmhvc3RfdmRwYV9ub2lvbW11ICYmIGNh
cGFibGUoQ0FQX1NZU19SQVdJTykpDQo+IHsNCj4gPg0KPiA+IEkgd291bGQgcHJlZmVyIHNvbWUg
ZXhwbGljaXQgYWN0aW9uLg0KPiA+IEp1c3Qgbm90IHNwZWNpZnlpbmcgYSBkb21haW4gaXMgc29t
ZXRoaW5nIEknZCBsaWtlIHRvIGtlZXAgcmVzZXJ2ZWQNCj4gPiBmb3Igc29tZXRoaW5nIG9mIG1v
cmUgd2lkZSB1c2VmdWxuZXNzLg0KPiBDYW4gd2UgaW50cm9kdWNlIGEgbmV3IGZlYXR1cmUgbGlr
ZSBWSE9TVF9CQUNLRU5EX0ZfTk9JT01NVSBpbg0KPiBWSE9TVF9WRFBBX0JBQ0tFTkRfRkVBVFVS
RVM/ICBXZSBjYW4gaGF2ZSBiZWxvdyBsb2dpYyBiYXNlZCBvbiB0aGlzDQo+IGZlYXR1cmUgYml0
IG5lZ290aWF0aW9uLg0KPiBUaGFua3MuDQpNaWNoYWVsLCBjb3VsZCB5b3UgcGxlYXNlIGNvbmZp
cm0gaWYgYWRkaW5nIGEgbmV3IGZlYXR1cmUgdG8gVkhPU1RfVkRQQV9CQUNLRU5EX0ZFQVRVUkVT
DQppcyBhbiBhcHByb3ByaWF0ZSBzb2x1dGlvbiB0byBzdXBwb3J0IG5vLUlPTU1VIGZvciB0aGUg
dmhvc3QtdmRwYSBiYWNrZW5kPw0KDQo+ID4NCj4gPg0KPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+
ID4gPiBJIHN1Z2dlc3QgYSBuZXcgZG9tYWluIHR5cGUgZm9yIHVzZSBqdXN0IGZvciB0aGlzIHB1
cnBvc2UuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBJJ20gbm90IHN1cmUgSSBnZXQgdGhpcywgd2Ug
d2FudCB0byBieXBhc3MgSU9NTVUsIHNvIGl0IGRvZXNuJ3QNCj4gPiA+ID4gPiBldmVuIGhhdmUg
YSBkb21hbi4NCj4gPiA+ID4NCj4gPiA+ID4geWVzLCBhIGZha2Ugb25lLiBvciBjb21lIHVwIHdp
dGggc29tZSBvdGhlciBmbGFnIHRoYXQgdXNlcnNwYWNlIHdpbGwgc2V0Lg0KPiA+ID4gPg0KPiA+
ID4gPiA+ID4gVGhpcyB3YXkgaWYgaG9zdCBoYXMNCj4gPiA+ID4gPiA+ID4gYW4gaW9tbXUsIHRo
ZW4gdGhlIHNhbWUga2VybmVsIGNhbiBydW4gYm90aCBWTXMgd2l0aA0KPiA+ID4gPiA+ID4gPiBp
c29sYXRpb24gYW5kIHVuc2FmZSBlbWJlZGRlZCBhcHBzIHdpdGhvdXQuDQo+ID4gPiA+ID4gPiBD
b3VsZCB5b3UgcHJvdmlkZSBmdXJ0aGVyIGRldGFpbHMgb24gdGhpcyBjb25jZXB0PyBXaGF0DQo+
ID4gPiA+ID4gPiBjcml0ZXJpYSB3b3VsZCBkZXRlcm1pbmUgdGhlIGNvbmZpZ3VyYXRpb24gb2Yg
dGhlIG5ldyBkb21haW4NCj4gPiA+ID4gPiA+IHR5cGU/IFdvdWxkIHRoaXMgcmVxdWlyZSBhIGJv
b3QgcGFyYW1ldGVyIHNpbWlsYXIgdG8NCj4gPiA+ID4gPiA+IElPTU1VX0RPTUFJTl9JREVOVElU
WSwgc3VjaCBhcw0KPiA+ID4gPiBpb21tdS5wYXNzdGhyb3VnaD0xIG9yIGlvbW11LnB0Pw0KPiA+
ID4gPiA+DQo+ID4gPiA+ID4gVGhhbmtzDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4NCj4gPiA+
ID4gPiA+ID4gPiAtLS0NCj4gPiA+ID4gPiA+ID4gPiAgZHJpdmVycy92aG9zdC92ZHBhLmMgfCAy
MyArKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ID4gPiA+ID4gPiA+ICAxIGZpbGUgY2hhbmdl
ZCwgMjMgaW5zZXJ0aW9ucygrKQ0KPiA+ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+ID4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvdmhvc3QvdmRwYS5jIGIvZHJpdmVycy92aG9zdC92ZHBhLmMNCj4g
PiA+ID4gPiA+ID4gPiBpbmRleCBiYzRhNTFlNDYzOGIuLmQwNzFjMzAxMjVhYSAxMDA2NDQNCj4g
PiA+ID4gPiA+ID4gPiAtLS0gYS9kcml2ZXJzL3Zob3N0L3ZkcGEuYw0KPiA+ID4gPiA+ID4gPiA+
ICsrKyBiL2RyaXZlcnMvdmhvc3QvdmRwYS5jDQo+ID4gPiA+ID4gPiA+ID4gQEAgLTM2LDYgKzM2
LDExIEBAIGVudW0gew0KPiA+ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+ID4gICNkZWZpbmUg
VkhPU1RfVkRQQV9JT1RMQl9CVUNLRVRTIDE2DQo+ID4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+
ID4gPiArYm9vbCB2aG9zdF92ZHBhX25vaW9tbXU7DQo+ID4gPiA+ID4gPiA+ID4NCj4gPiArbW9k
dWxlX3BhcmFtX25hbWVkKGVuYWJsZV92aG9zdF92ZHBhX3Vuc2FmZV9ub2lvbW11X21vZGUsDQo+
ID4gPiA+ID4gPiA+ID4gKyAgICAgICAgICAgICAgdmhvc3RfdmRwYV9ub2lvbW11LCBib29sLCAw
NjQ0KTsNCj4gPiA+ID4gPiA+ID4gPg0KPiA+ICtNT0RVTEVfUEFSTV9ERVNDKGVuYWJsZV92aG9z
dF92ZHBhX3Vuc2FmZV9ub2lvbW11X21vZGUsDQo+ID4gPiA+ID4gPiA+ICJFbmFibGUNCj4gPiA+
ID4gPiA+ID4gPiArVU5TQUZFLCBuby1JT01NVSBtb2RlLiAgVGhpcyBtb2RlIHByb3ZpZGVzIG5v
IGRldmljZQ0KPiA+ID4gPiA+ID4gPiA+ICtpc29sYXRpb24sIG5vIERNQSB0cmFuc2xhdGlvbiwg
bm8gaG9zdCBrZXJuZWwgcHJvdGVjdGlvbiwNCj4gPiA+ID4gPiA+ID4gPiArY2Fubm90IGJlIHVz
ZWQgZm9yIGRldmljZSBhc3NpZ25tZW50IHRvIHZpcnR1YWwgbWFjaGluZXMsDQo+ID4gPiA+ID4g
PiA+ID4gK3JlcXVpcmVzIFJBV0lPIHBlcm1pc3Npb25zLCBhbmQgd2lsbCB0YWludCB0aGUga2Vy
bmVsLg0KPiA+ID4gPiA+ID4gPiA+ICtJZiB5b3UgZG8gbm90IGtub3cgd2hhdCB0aGlzIGlzDQo+
ID4gPiA+IGZvciwgc3RlcCBhd2F5Lg0KPiA+ID4gPiA+ID4gPiA+ICsoZGVmYXVsdDogZmFsc2Up
Iik7DQo+ID4gPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gPiA+ICBzdHJ1Y3Qgdmhvc3RfdmRw
YV9hcyB7DQo+ID4gPiA+ID4gPiA+ID4gICAgIHN0cnVjdCBobGlzdF9ub2RlIGhhc2hfbGluazsN
Cj4gPiA+ID4gPiA+ID4gPiAgICAgc3RydWN0IHZob3N0X2lvdGxiIGlvdGxiOyBAQCAtNjAsNiAr
NjUsNyBAQCBzdHJ1Y3QNCj4gPiA+ID4gPiA+ID4gPiB2aG9zdF92ZHBhIHsNCj4gPiA+ID4gPiA+
ID4gPiAgICAgc3RydWN0IHZkcGFfaW92YV9yYW5nZSByYW5nZTsNCj4gPiA+ID4gPiA+ID4gPiAg
ICAgdTMyIGJhdGNoX2FzaWQ7DQo+ID4gPiA+ID4gPiA+ID4gICAgIGJvb2wgc3VzcGVuZGVkOw0K
PiA+ID4gPiA+ID4gPiA+ICsgICBib29sIG5vaW9tbXVfZW47DQo+ID4gPiA+ID4gPiA+ID4gIH07
DQo+ID4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gPiAgc3RhdGljIERFRklORV9JREEodmhv
c3RfdmRwYV9pZGEpOyBAQCAtODg3LDYgKzg5MywxMCBAQA0KPiA+ID4gPiA+ID4gPiA+IHN0YXRp
YyB2b2lkIHZob3N0X3ZkcGFfZ2VuZXJhbF91bm1hcChzdHJ1Y3Qgdmhvc3RfdmRwYSAqdiwgIHsN
Cj4gPiA+ID4gPiA+ID4gPiAgICAgc3RydWN0IHZkcGFfZGV2aWNlICp2ZHBhID0gdi0+dmRwYTsN
Cj4gPiA+ID4gPiA+ID4gPiAgICAgY29uc3Qgc3RydWN0IHZkcGFfY29uZmlnX29wcyAqb3BzID0g
dmRwYS0+Y29uZmlnOw0KPiA+ID4gPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiA+ID4gPiArICAgaWYg
KHYtPm5vaW9tbXVfZW4pDQo+ID4gPiA+ID4gPiA+ID4gKyAgICAgICAgICAgcmV0dXJuOw0KPiA+
ID4gPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiA+ID4gPiAgICAgaWYgKG9wcy0+ZG1hX21hcCkgew0K
PiA+ID4gPiA+ID4gPiA+ICAgICAgICAgICAgIG9wcy0+ZG1hX3VubWFwKHZkcGEsIGFzaWQsIG1h
cC0+c3RhcnQsIG1hcC0+c2l6ZSk7DQo+ID4gPiA+ID4gPiA+ID4gICAgIH0gZWxzZSBpZiAob3Bz
LT5zZXRfbWFwID09IE5VTEwpIHsgQEAgLTk4MCw2ICs5OTAsOSBAQA0KPiA+ID4gPiA+ID4gPiA+
IHN0YXRpYyBpbnQgdmhvc3RfdmRwYV9tYXAoc3RydWN0IHZob3N0X3ZkcGEgKnYsDQo+ID4gPiA+
ID4gPiA+IHN0cnVjdCB2aG9zdF9pb3RsYiAqaW90bGIsDQo+ID4gPiA+ID4gPiA+ID4gICAgIGlm
IChyKQ0KPiA+ID4gPiA+ID4gPiA+ICAgICAgICAgICAgIHJldHVybiByOw0KPiA+ID4gPiA+ID4g
PiA+DQo+ID4gPiA+ID4gPiA+ID4gKyAgIGlmICh2LT5ub2lvbW11X2VuKQ0KPiA+ID4gPiA+ID4g
PiA+ICsgICAgICAgICAgIGdvdG8gc2tpcF9tYXA7DQo+ID4gPiA+ID4gPiA+ID4gKw0KPiA+ID4g
PiA+ID4gPiA+ICAgICBpZiAob3BzLT5kbWFfbWFwKSB7DQo+ID4gPiA+ID4gPiA+ID4gICAgICAg
ICAgICAgciA9IG9wcy0+ZG1hX21hcCh2ZHBhLCBhc2lkLCBpb3ZhLCBzaXplLCBwYSwgcGVybSwg
b3BhcXVlKTsNCj4gPiA+ID4gPiA+ID4gPiAgICAgfSBlbHNlIGlmIChvcHMtPnNldF9tYXApIHsg
QEAgLTk5NSw2ICsxMDA4LDcgQEAgc3RhdGljDQo+ID4gPiA+ID4gPiA+ID4gaW50IHZob3N0X3Zk
cGFfbWFwKHN0cnVjdCB2aG9zdF92ZHBhICp2LA0KPiA+ID4gPiA+ID4gPiBzdHJ1Y3Qgdmhvc3Rf
aW90bGIgKmlvdGxiLA0KPiA+ID4gPiA+ID4gPiA+ICAgICAgICAgICAgIHJldHVybiByOw0KPiA+
ID4gPiA+ID4gPiA+ICAgICB9DQo+ID4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gPiArc2tp
cF9tYXA6DQo+ID4gPiA+ID4gPiA+ID4gICAgIGlmICghdmRwYS0+dXNlX3ZhKQ0KPiA+ID4gPiA+
ID4gPiA+ICAgICAgICAgICAgIGF0b21pYzY0X2FkZChQRk5fRE9XTihzaXplKSwNCj4gPiA+ID4g
PiA+ID4gPiAmZGV2LT5tbS0+cGlubmVkX3ZtKTsNCj4gPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+
ID4gPiA+IEBAIC0xMjk4LDYgKzEzMTIsNyBAQCBzdGF0aWMgaW50DQo+ID4gPiA+ID4gPiA+ID4g
dmhvc3RfdmRwYV9hbGxvY19kb21haW4oc3RydWN0DQo+ID4gPiA+ID4gPiA+IHZob3N0X3ZkcGEg
KnYpDQo+ID4gPiA+ID4gPiA+ID4gICAgIHN0cnVjdCB2ZHBhX2RldmljZSAqdmRwYSA9IHYtPnZk
cGE7DQo+ID4gPiA+ID4gPiA+ID4gICAgIGNvbnN0IHN0cnVjdCB2ZHBhX2NvbmZpZ19vcHMgKm9w
cyA9IHZkcGEtPmNvbmZpZzsNCj4gPiA+ID4gPiA+ID4gPiAgICAgc3RydWN0IGRldmljZSAqZG1h
X2RldiA9IHZkcGFfZ2V0X2RtYV9kZXYodmRwYSk7DQo+ID4gPiA+ID4gPiA+ID4gKyAgIHN0cnVj
dCBpb21tdV9kb21haW4gKmRvbWFpbjsNCj4gPiA+ID4gPiA+ID4gPiAgICAgY29uc3Qgc3RydWN0
IGJ1c190eXBlICpidXM7DQo+ID4gPiA+ID4gPiA+ID4gICAgIGludCByZXQ7DQo+ID4gPiA+ID4g
PiA+ID4NCj4gPiA+ID4gPiA+ID4gPiBAQCAtMTMwNSw2ICsxMzIwLDE0IEBAIHN0YXRpYyBpbnQN
Cj4gPiA+ID4gPiA+ID4gPiB2aG9zdF92ZHBhX2FsbG9jX2RvbWFpbihzdHJ1Y3QNCj4gPiA+ID4g
PiA+ID4gdmhvc3RfdmRwYSAqdikNCj4gPiA+ID4gPiA+ID4gPiAgICAgaWYgKG9wcy0+c2V0X21h
cCB8fCBvcHMtPmRtYV9tYXApDQo+ID4gPiA+ID4gPiA+ID4gICAgICAgICAgICAgcmV0dXJuIDA7
DQo+ID4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gPiArICAgZG9tYWluID0gaW9tbXVfZ2V0
X2RvbWFpbl9mb3JfZGV2KGRtYV9kZXYpOw0KPiA+ID4gPiA+ID4gPiA+ICsgICBpZiAoKCFkb21h
aW4gfHwgZG9tYWluLT50eXBlID09IElPTU1VX0RPTUFJTl9JREVOVElUWSkNCj4gPiAmJg0KPiA+
ID4gPiA+ID4gPiA+ICsgICAgICAgdmhvc3RfdmRwYV9ub2lvbW11ICYmIGNhcGFibGUoQ0FQX1NZ
U19SQVdJTykpIHsNCj4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gU28gaWYgdXNlcnNwYWNl
IGRvZXMgbm90IGhhdmUgQ0FQX1NZU19SQVdJTyBpbnN0ZWFkIG9mDQo+ID4gPiA+ID4gPiA+IGZh
aWxpbmcgd2l0aCBhIHBlcm1pc3Npb24gZXJyb3IgdGhlIGZ1bmN0aW9uYWxpdHkgY2hhbmdlcyBz
aWxlbnRseT8NCj4gPiA+ID4gPiA+ID4gVGhhdCdzIGNvbmZ1c2luZywgSSB0aGluay4NCj4gPiA+
ID4gPiA+IFllcywgeW91IGFyZSBjb3JyZWN0LiBJIHdpbGwgbW9kaWZ5IHRoZSBjb2RlIHRvIHJl
dHVybiBlcnJvcg0KPiA+ID4gPiA+ID4gd2hlbiB2aG9zdF92ZHBhX25vaW9tbXUgaXMgc2V0IGFu
ZCBDQVBfU1lTX1JBV0lPIGlzIG5vdCBzZXQuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gVGhh
bmtzLg0KPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiA+ICsgICAg
ICAgICAgIGFkZF90YWludChUQUlOVF9VU0VSLCBMT0NLREVQX1NUSUxMX09LKTsNCj4gPiA+ID4g
PiA+ID4gPiArICAgICAgICAgICBkZXZfd2Fybigmdi0+ZGV2LCAiQWRkaW5nIGtlcm5lbCB0YWlu
dCBmb3INCj4gPiA+ID4gPiA+ID4gPiArIG5vaW9tbXUgb24NCj4gPiA+ID4gPiA+ID4gZGV2aWNl
XG4iKTsNCj4gPiA+ID4gPiA+ID4gPiArICAgICAgICAgICB2LT5ub2lvbW11X2VuID0gdHJ1ZTsN
Cj4gPiA+ID4gPiA+ID4gPiArICAgICAgICAgICByZXR1cm4gMDsNCj4gPiA+ID4gPiA+ID4gPiAr
ICAgfQ0KPiA+ID4gPiA+ID4gPiA+ICAgICBidXMgPSBkbWFfZGV2LT5idXM7DQo+ID4gPiA+ID4g
PiA+ID4gICAgIGlmICghYnVzKQ0KPiA+ID4gPiA+ID4gPiA+ICAgICAgICAgICAgIHJldHVybiAt
RUZBVUxUOw0KPiA+ID4gPiA+ID4gPiA+IC0tDQo+ID4gPiA+ID4gPiA+ID4gMi4yNS4xDQo+ID4g
PiA+ID4gPg0KPiA+ID4NCg0K

