Return-Path: <kvm+bounces-18744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EBB08FAEC4
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 11:29:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11F10283EF3
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 09:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD9D143C61;
	Tue,  4 Jun 2024 09:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="Nt+b8eSr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4057C143C5B
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 09:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717493373; cv=fail; b=EyZ0k5gIcGzdZrOrceR3XH28zPOpwATmdBuKCjwoIm/gaRN/cOXyd8sF9Bqpdk8cxEBGUKLXeZ4MFiOSPqfb3U88QC5HEjcyTKwZ05+fzZ+Wyjhligq2Ny3LMQ1hxvdL1Eh7U8Jk+xd/hseNmRzt0T4cjINWRl2hiPW0icKUp+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717493373; c=relaxed/simple;
	bh=7j8X5c9SQ8Nh1PUVLz9UPLQ0QP7zf3IdetE99mG3rKs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oCUDV6KTPUmhv0nTOC5sfdYHVtBAbMV/DZQXU8zn9T7VBkTF8/Za3xCtcubZ4xy8gKllRKKhGBt1lN0o80FYYBo1B+UBaBBdG/c0MN8wqJ0MARzE2wbPnzInevpjFp8G0UyrV8NRQ//8/L+49uvCGPzipRGYoT1AAOmO5MrHmvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=Nt+b8eSr; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4549ArB6030763;
	Tue, 4 Jun 2024 02:29:27 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3yj02n02bj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Jun 2024 02:29:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7cGXKlk1CPeIEJgWyAVCsQP3hiEzOOjyDBM8htYJDaPFusXbfohsoxjPxLenQKTf2pSmMltEvR2glVYTmTh679JGTeZYnv24Chvu0FT9Fsx642iX5qR3pV0wOglc/jmNQRRYljfGIWzQCRFTPmtLJes/O8qqFz+ddRV/TDhP5K8RrJ3zlDxXQyfvh2CXpO/RML5XPvjHcShWpeNX3dxW2TpfIjDuLbliPmybtWvmM6JG8VCM2UIdmO+CaKXa4Ko7ZjcFt0DwINwkrL83Y0zdb3/hd+K7cG6hq1z+OfbASRaJlluEHrCT5817hkSndHl/tef8HZ3R8jxQ31RooPJwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7j8X5c9SQ8Nh1PUVLz9UPLQ0QP7zf3IdetE99mG3rKs=;
 b=XuRRWl1xoXhNwo5pTDUtVKBniyVb7/IFFu6EF4wXFxUDhUd8y00CuT0AZJb2UL1jtfq3GAg90anmfXnGQZPPTM4xCBzV0SQmE8EaecA1PKqwA3X4NNvrq9s3VbKQ5oY9+G0soqjQKyOcfX3MnI8jNZhnC/pbF4ejFrnGZxkh1st0O/gs6dpjCG7coiaaVG8fJL8iMmbda4YAeSP4ezGxhxfca1XZPzyQ3UI9BSKHUYi4o+wMCVYlf4HcND2Bm2pPG39gOL1+0xhcTD2/tVqFRpOmTErWlPt0y2A4jNuayATBsMTWzQ9/cS0rV0+HDDbIZGuhDh4L9a9J0WveRCgUyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7j8X5c9SQ8Nh1PUVLz9UPLQ0QP7zf3IdetE99mG3rKs=;
 b=Nt+b8eSr7nqLu1gsGBdgYAiJnZjGvC2AOL3RAQ4BQtedzzrMkTROQeiPkg8CAg4bcDXMHdKFVKarX1xCNuReeleFslQbwM3BBmVLkbuJ9zYIic12f6oqBhTfyk80jZsWLF9KWjlZNVLohtA2PDtKjR7N/i7w9pwh9XCfDtpl44w=
Received: from DS0PR18MB5368.namprd18.prod.outlook.com (2603:10b6:8:12f::17)
 by SA3PR18MB5579.namprd18.prod.outlook.com (2603:10b6:806:394::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Tue, 4 Jun
 2024 09:29:24 +0000
Received: from DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac]) by DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac%3]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 09:29:24 +0000
From: Srujana Challa <schalla@marvell.com>
To: Jason Wang <jasowang@redhat.com>
CC: "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com"
	<mst@redhat.com>,
        Vamsi Krishna Attunuru <vattunuru@marvell.com>,
        Shijith
 Thotton <sthotton@marvell.com>,
        Nithin Kumar Dabilpuram
	<ndabilpuram@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>
Subject: RE: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
Thread-Topic: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
Thread-Index: AQHasnq4Ve/zJa91a0mQb+nM4LHR9bGwnvCAgAa0y7A=
Date: Tue, 4 Jun 2024 09:29:24 +0000
Message-ID: 
 <DS0PR18MB5368E02C4DE7AA96CCD299E0A0F82@DS0PR18MB5368.namprd18.prod.outlook.com>
References: <20240530101823.1210161-1-schalla@marvell.com>
 <CACGkMEsxPfck-Ww6CHSod5wP5xLOpS3t2B8qhTL0=PoE3koCGQ@mail.gmail.com>
In-Reply-To: 
 <CACGkMEsxPfck-Ww6CHSod5wP5xLOpS3t2B8qhTL0=PoE3koCGQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR18MB5368:EE_|SA3PR18MB5579:EE_
x-ms-office365-filtering-correlation-id: 5a697734-6555-44e3-8f9b-08dc8478d29d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?aDBkNDcwT1pQcGl0SkFEb2l3OThHZkxuNitjNkhWeFlBUjZtYkl0SG9HTFJj?=
 =?utf-8?B?cUQzVWlHZ1BUeXpYTDloU3Y0S1V6WnlPTXR2OVQ2bUxoSjl1dWxzZ04wLytk?=
 =?utf-8?B?c21qTWM1WUVGTlpYL3hENThtQk1LQnZqV3pCTDdMYm1vMGowUk5zL3NsYmNs?=
 =?utf-8?B?R1hiWG5XZFFkUXMzMm5sTDMyVTZCSDQ4VCtaV2ZaU1ZVL2hqWjMrc3FidHJJ?=
 =?utf-8?B?SUx3dDVjK0hFUjBTYTB3bEkvbmVxNks3NlM0Y0Z3MmFQdlIvOVk5eXM0a1Va?=
 =?utf-8?B?WHZKeFNtclp3WTZuaFFWYW1pQUgwdUNOUFhuZmFJdytwdm11bmF1MC9JSEV5?=
 =?utf-8?B?YkxBR2dNQzdQT3hyemRVQndTaUE3WGV3bzJ3TTBRWFI0ajQ4bDgxd0FEZGNP?=
 =?utf-8?B?MDhiaUIxMDN6OTdrRUVMd05JaU1hdkpOWVBmM1NuQzVvS3M4WFNEZW9yQzVF?=
 =?utf-8?B?NlhHSG4zRkdNNGc1VU5ab1hoWTBvQVhBRE80Z0JBSDBGSWRON3NWc3BReUVk?=
 =?utf-8?B?QlltRWtMZkkzSmhSSlVQcFdWYklZLzlDMWE2ck9LdHkyZm9YeW8yWmpuMFJy?=
 =?utf-8?B?Y3Q3Rkk4KytNVWwxSG5idWtuMXlzZGxOeUdVSGEyMWdWejM4K1FEbUQzZDZF?=
 =?utf-8?B?Um5JemZOVGVja1duMFB4Z2hNWW9VcUNsL1BzSlJHSnFXbC9wdmk5UlVOQ3RQ?=
 =?utf-8?B?akl3b1g3UUttZW1TYkZpMWJWbG05OEJ2eXpZc2Z0cWhPbjA4a2tFMDZrMlQ0?=
 =?utf-8?B?ajVncitONDNiWWNydWZxdENOdGI2QTk5NSszTzlSMm9OZVR3Um4rRjI2anZK?=
 =?utf-8?B?WCtYTlNnUnJpc1RYbkFUZ0R0YzN0VkRlUHcyZFBlUFhvTXZ4RUdLRVZwdWZE?=
 =?utf-8?B?cnd0dlBEbWxub3VzRFN0NkVUOVh3b20xemtRRTYxOXJFS3V3b0szeTIvKzQ4?=
 =?utf-8?B?QkxJaWlpdDJSY0s4ZjNiYmtrQlV0cyt0MHBpMjdRMitSemlhMUpZaHR4QW1i?=
 =?utf-8?B?K1hYK3UwMVV1QzN1aUNqOVFheVZVd2lBS3hEcXpQU3c0ZldpdklZby93cERl?=
 =?utf-8?B?R3dpRjcwNHN5U1NhTkNsckNyNlY2VkhUTXJyZ2JvOE5RRjFJUVJWeXZHdEow?=
 =?utf-8?B?WFpIWkdleVdCdFhtVU5lcTVyM1JFOGFBRWNrTXBkcU5TS3dRcldBbDU5WHBW?=
 =?utf-8?B?VW1GdHJqT1d5T1VsZXJuSjFzZDdmL1VXRjJqQlprc1p5TDQwY2NxbXR4U0lD?=
 =?utf-8?B?dVVYckYwNjlCSmdlMkU3UlE1Vk1VN3JSMjQ4MDNiNXViVStCcG84dDBOaVBv?=
 =?utf-8?B?YkNveDlORnlhWTlUSEkvM05ORFF5aUV6Q1ovL1E5N2tZU0ljbFgwMXdnUmtN?=
 =?utf-8?B?c2ZFbFVHdVZqYk9UNDFhOGE5Z2FMeXc2UEVOWFFiVkdoMEtCTUpCak1zYlN6?=
 =?utf-8?B?cUF0NlcxV2xBdEl2NDA2UEFOQklUZzRpb1Azc0NpSVZCak94ZUgvK05hT3di?=
 =?utf-8?B?RDRCMVlLKzBSZEo4d0pkVEtpQVRaazkxbzhDWjJOVFRRaFB0MmlIZXRXc0JK?=
 =?utf-8?B?eU5WWFYvTmQ3ZjRldUlJY3VCM3RUUWxDczFvb2h1clgwamUrRlRRQUpIOW1C?=
 =?utf-8?B?TVl0RGhCQnFGbFJZTmx4d2t2bGNHRTJyYWFOTFRWdlhVQ2s3ZGVkUlYvSTc1?=
 =?utf-8?B?V096OUhwenA1SXZoc3lyYzR5eTFnWXdLTHFXNW9ZeTVNelg5bDNqa3phSW1K?=
 =?utf-8?B?QjlNdExrQStHYXVCb1F0YmY3K3F6ZldTWHJ3cDZ5ckZaYjdHUVRIcVM3eDZJ?=
 =?utf-8?B?VHNSamJLMXI4Z2NjVWxuQT09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR18MB5368.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?OXRjWTRLTVYwcnNPME4yQmt0ZkpKK29jQklXZXpuQ3BpaWJqc1JvRnY2a2Qr?=
 =?utf-8?B?VUhvMXV1aE9OR2JSQmZrRnNtbFRibTNtb2FFOHBacmRlMHk0WkNGcit3WTlk?=
 =?utf-8?B?cWxBS2ptRnhIbFo1bSthUE9tejIxbXZlZTZqaTlXYWZibFptbFk4Z1R3TEk2?=
 =?utf-8?B?dFBreTJjMHFZLzlPZ2d6NzZSc2l2YndaN2htNDNnYzluY093R3BtOFNIMTk0?=
 =?utf-8?B?V3ZHRnlYOWJwWkNvTTZXYzl6TXV4UkVmQ0szWmJRMVBPNWZ4Ri92ajM3d2NH?=
 =?utf-8?B?eWE2cmt3RmRhV1RpU2FFWTJVTFlPNXA1UVpGckJFbUl4dXZmM3dJVUZvMlVa?=
 =?utf-8?B?ZkZCSlZxdkowM21ZTkw5ZTBoc2k1eW9QRDdkUDRvRDhXQXdXTGwwQnhteVVS?=
 =?utf-8?B?eUNVT0JkWTluajh3aUI3bkVQTmtxYlVoQ1RlN3lRVGJDa29DMWVDejlnKzJn?=
 =?utf-8?B?KzRpVFkyTkJNdUEyVmxzdHByR2pmc3ZaNlR4Y2pHK20wek1ZWTRtYmtDai9J?=
 =?utf-8?B?T1BNWW5leXR6Qmw2SFFGMEk4QWFYWm5wdUhUenlubVpwblNjNDFHKzBueXNE?=
 =?utf-8?B?d3hRZHhPUGJxdTVZL0xoMytYWEg5OGFtRjFlQTNvS3YwSzFZR1FacisvbWZG?=
 =?utf-8?B?dUQ2czR5NnRYdDVuWTlCUmE2c3J1ZmJvTEZlN0tPc1RlOGhwMzZHNStsdjV4?=
 =?utf-8?B?allkdkJ3M1RjRjRsSzM2RyttemIxbVFNb1JaUDJFUUppc2Z5TFFZNzBudXFk?=
 =?utf-8?B?b01uL2dVdDhSUXNRNmhDZk9JNnUrUDlLRW1wcDlKdHJwSmFOc1dlNVJyRU5P?=
 =?utf-8?B?YTAwZFUzNkRNL2tlNVJ5dUFGeGlQdW5MQkljSnJ4Vnl5MnVMRGFUK3RUYmRJ?=
 =?utf-8?B?NEtDTW1SUGVnNStJbmk4dldxZGR4VmVEaGE0MjEzdVF1bk1zaStIeS9yeEJJ?=
 =?utf-8?B?U0ZOVWNGckphUHBJN3FKYmN2OUtrelM1K1ZIUjJSMmwxTjZRa2tGSmlZTlNh?=
 =?utf-8?B?UEV6Q0YycnBpT1RHd29KN0dIb3VoTjBkb3VjMzJnVG04bDkya0pzbFJ4SlVR?=
 =?utf-8?B?Q2pycU1sNFFlRHh2bS9PZXlkTDgvZ2pnTWNrRXlsOGhhTFJTeExIemVSUmc3?=
 =?utf-8?B?NDA2a25DbmxUOEEyQWpNMXpNdXcvMEVMaXM3VzRnY1J6U3dhRWxGR2pCdEZw?=
 =?utf-8?B?elVJQk93dDh0L2pRaWI1dW1nMVpGZ0Q5S0xVbnpOd3hnakhVQTZPYUNDaTVX?=
 =?utf-8?B?NTdISk5NbEFndGdQMU9IWG1tdXk4NHdCTFB3d054Z3NabEFKR1pQbjYxcElP?=
 =?utf-8?B?bjRlRlBxRi9lRklDY3ZjdzJiU0FYQU52TWVuTU0rRlVXTEM4b3BKRVN3ZW53?=
 =?utf-8?B?OFlwVWwyZ2VMN01XQ1ByMGlvWEpGVVp4bHFBUjY0VGtoSUJ5MDl0b0tjTmZD?=
 =?utf-8?B?dHRkcCt2azlxODdVcGdQNWNiSGk1MmFCaVBWd1hjdkd4M2E2T2tVYVdrMi9L?=
 =?utf-8?B?cVhQRTBMSjE2MFFwaUZOQlI0TW92L2NaYXovdEdxN2t1UnNMVGw1Q3VZbUN5?=
 =?utf-8?B?OW10czE5Y0Nkd1h3d1ZpYXFCcGxtclUxVXM4bjY2bGhNTkUxL2RjUm1MNmhL?=
 =?utf-8?B?TXZBVW93bU80dzVDOGI5clZhQzYwUVg3WjlQNnNoTUJkUysyNk11WDZzMzZt?=
 =?utf-8?B?dU9TTkllWngzQk8vRUdRZ213MkhkVlVZWDlpbU51YmRrRHRwcU1CN25OV2FN?=
 =?utf-8?B?c1hibE81d05mN0FPSnZQRW85ejJtZUllRjNxSVQzVXhrNGRjdTR4MFE4d0d6?=
 =?utf-8?B?cFFmb2R1WkgwdENLSHkvZWg1VlhacGRVZGllL1JNa21KZ01ZZ2hzRm5RWUdW?=
 =?utf-8?B?YTY1WFZrbi9yVzY4VGZVTUV0aFFJQVNJUk1sVVRmZVpOVSt5bmFQdkgxWFky?=
 =?utf-8?B?NWlJQWdFdGFzbW5KVEVoWCsyZVVUeFJDeU4yYWsydm5yVDNRcUdxQW1rcktC?=
 =?utf-8?B?U2wxTnZBSXFrU0kwclFESzJpVXhIRkpJYjU1ZWVoVUQ2YUxNc1ZxTmZHUXZN?=
 =?utf-8?B?K1dhTVhDU3RxazkrOWp5ZHpsLzZqRUNkeDZqcFUvRjlhUHdVcGRDZUNicnFF?=
 =?utf-8?B?VDZCQ3ZCaGtNZHhnTldhbFMrT0NzL1VjZWFPZ0orcHV3d0I2bVNmSTlITUpG?=
 =?utf-8?Q?hYzoo+u60tav30heW7cr8h4=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a697734-6555-44e3-8f9b-08dc8478d29d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2024 09:29:24.4074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y3/sNieqWPKhvNaWcQnf9k4Ej3/sTCmH8Hf6tDqmeKDdf1U1kXTxSYw4cWd/kki7y8TFxiCnsTOexVUpUgWZ9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR18MB5579
X-Proofpoint-GUID: mHXjGgOww-9aNMxVwFEV7Ag0efEhOc1W
X-Proofpoint-ORIG-GUID: mHXjGgOww-9aNMxVwFEV7Ag0efEhOc1W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-04_03,2024-05-30_01,2024-05-17_01

PiBTdWJqZWN0OiBbRVhURVJOQUxdIFJlOiBbUEFUQ0hdIHZkcGE6IEFkZCBzdXBwb3J0IGZvciBu
by1JT01NVSBtb2RlDQo+IA0KPiBQcmlvcml0aXplIHNlY3VyaXR5IGZvciBleHRlcm5hbCBlbWFp
bHM6IENvbmZpcm0gc2VuZGVyIGFuZCBjb250ZW50IHNhZmV0eQ0KPiBiZWZvcmUgY2xpY2tpbmcg
bGlua3Mgb3Igb3BlbmluZyBhdHRhY2htZW50cw0KPiANCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBPbiBU
aHUsIE1heSAzMCwgMjAyNCBhdCA2OjE44oCvUE0gU3J1amFuYSBDaGFsbGEgPHNjaGFsbGFAbWFy
dmVsbC5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gVGhpcyBjb21taXQgaW50cm9kdWNlcyBzdXBw
b3J0IGZvciBhbiBVTlNBRkUsIG5vLUlPTU1VIG1vZGUgaW4gdGhlDQo+ID4gdmhvc3QtdmRwYSBk
cml2ZXIuIFdoZW4gZW5hYmxlZCwgdGhpcyBtb2RlIHByb3ZpZGVzIG5vIGRldmljZQ0KPiA+IGlz
b2xhdGlvbiwgbm8gRE1BIHRyYW5zbGF0aW9uLCBubyBob3N0IGtlcm5lbCBwcm90ZWN0aW9uLCBh
bmQgY2Fubm90DQo+ID4gYmUgdXNlZCBmb3IgZGV2aWNlIGFzc2lnbm1lbnQgdG8gdmlydHVhbCBt
YWNoaW5lcy4gSXQgcmVxdWlyZXMgUkFXSU8NCj4gPiBwZXJtaXNzaW9ucyBhbmQgd2lsbCB0YWlu
dCB0aGUga2VybmVsLg0KPiA+IFRoaXMgbW9kZSByZXF1aXJlcyBlbmFibGluZyB0aGUNCj4gImVu
YWJsZV92aG9zdF92ZHBhX3Vuc2FmZV9ub2lvbW11X21vZGUiDQo+ID4gb3B0aW9uIG9uIHRoZSB2
aG9zdC12ZHBhIGRyaXZlci4gVGhpcyBtb2RlIHdvdWxkIGJlIHVzZWZ1bCB0byBnZXQNCj4gPiBi
ZXR0ZXIgcGVyZm9ybWFuY2Ugb24gc3BlY2lmaWNlIGxvdyBlbmQgbWFjaGluZXMgYW5kIGNhbiBi
ZSBsZXZlcmFnZWQNCj4gPiBieSBlbWJlZGRlZCBwbGF0Zm9ybXMgd2hlcmUgYXBwbGljYXRpb25z
IHJ1biBpbiBjb250cm9sbGVkIGVudmlyb25tZW50Lg0KPiANCj4gSSB3b25kZXIgaWYgaXQncyBi
ZXR0ZXIgdG8gZG8gaXQgcGVyIGRyaXZlcjoNCj4gDQo+IDEpIHdlIGhhdmUgZGV2aWNlIHRoYXQg
dXNlIGl0cyBvd24gSU9NTVUsIG9uZSBleGFtcGxlIGlzIHRoZSBtbHg1IHZEUEENCj4gZGV2aWNl
DQo+IDIpIHdlIGhhdmUgc29mdHdhcmUgZGV2aWNlcyB3aGljaCBkb2Vzbid0IHJlcXVpcmUgSU9N
TVUgYXQgYWxsIChidXQgc3RpbGwgd2l0aA0KPiBwcm90ZWN0aW9uKQ0KDQpJZiBJIHVuZGVyc3Rh
bmQgY29ycmVjdGx5LCB5b3XigJlyZSBzdWdnZXN0aW5nIHRoYXQgd2UgY3JlYXRlIGEgbW9kdWxl
IHBhcmFtZXRlcg0Kc3BlY2lmaWMgdG8gdGhlIHZkcGEgZHJpdmVyLiBUaGVuLCB3ZSBjYW4gYWRk
IGEgZmxhZyB0byB0aGUg4oCYc3RydWN0IHZkcGFfZGV2aWNl4oCZDQphbmQgc2V0IHRoYXQgZmxh
ZyB3aXRoaW4gdGhlIHZkcGEgZHJpdmVyIGJhc2VkIG9uIHRoZSBtb2R1bGUgcGFyYW1ldGVyLg0K
RmluYWxseSwgd2Ugd291bGQgdXNlIHRoaXMgZmxhZyB0byB0YWludCB0aGUga2VybmVsIGFuZCBn
byBpbiBuby1pb21tdSBwYXRoDQppbiB0aGUgdmhvc3QtdmRwYSBkcml2ZXI/DQo+IA0KPiBUaGFu
a3MNCj4gDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTcnVqYW5hIENoYWxsYSA8c2NoYWxsYUBt
YXJ2ZWxsLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy92aG9zdC92ZHBhLmMgfCAyMyArKysr
KysrKysrKysrKysrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMjMgaW5zZXJ0aW9ucygr
KQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmhvc3QvdmRwYS5jIGIvZHJpdmVycy92
aG9zdC92ZHBhLmMgaW5kZXgNCj4gPiBiYzRhNTFlNDYzOGIuLmQwNzFjMzAxMjVhYSAxMDA2NDQN
Cj4gPiAtLS0gYS9kcml2ZXJzL3Zob3N0L3ZkcGEuYw0KPiA+ICsrKyBiL2RyaXZlcnMvdmhvc3Qv
dmRwYS5jDQo+ID4gQEAgLTM2LDYgKzM2LDExIEBAIGVudW0gew0KPiA+DQo+ID4gICNkZWZpbmUg
VkhPU1RfVkRQQV9JT1RMQl9CVUNLRVRTIDE2DQo+ID4NCj4gPiArYm9vbCB2aG9zdF92ZHBhX25v
aW9tbXU7DQo+ID4gK21vZHVsZV9wYXJhbV9uYW1lZChlbmFibGVfdmhvc3RfdmRwYV91bnNhZmVf
bm9pb21tdV9tb2RlLA0KPiA+ICsgICAgICAgICAgICAgICAgICB2aG9zdF92ZHBhX25vaW9tbXUs
IGJvb2wsIDA2NDQpOw0KPiA+ICtNT0RVTEVfUEFSTV9ERVNDKGVuYWJsZV92aG9zdF92ZHBhX3Vu
c2FmZV9ub2lvbW11X21vZGUsDQo+ICJFbmFibGUNCj4gPiArVU5TQUZFLCBuby1JT01NVSBtb2Rl
LiAgVGhpcyBtb2RlIHByb3ZpZGVzIG5vIGRldmljZSBpc29sYXRpb24sIG5vDQo+ID4gK0RNQSB0
cmFuc2xhdGlvbiwgbm8gaG9zdCBrZXJuZWwgcHJvdGVjdGlvbiwgY2Fubm90IGJlIHVzZWQgZm9y
IGRldmljZQ0KPiA+ICthc3NpZ25tZW50IHRvIHZpcnR1YWwgbWFjaGluZXMsIHJlcXVpcmVzIFJB
V0lPIHBlcm1pc3Npb25zLCBhbmQgd2lsbA0KPiA+ICt0YWludCB0aGUga2VybmVsLiAgSWYgeW91
IGRvIG5vdCBrbm93IHdoYXQgdGhpcyBpcyBmb3IsIHN0ZXAgYXdheS4NCj4gPiArKGRlZmF1bHQ6
IGZhbHNlKSIpOw0KPiA+ICsNCj4gPiAgc3RydWN0IHZob3N0X3ZkcGFfYXMgew0KPiA+ICAgICAg
ICAgc3RydWN0IGhsaXN0X25vZGUgaGFzaF9saW5rOw0KPiA+ICAgICAgICAgc3RydWN0IHZob3N0
X2lvdGxiIGlvdGxiOw0KPiA+IEBAIC02MCw2ICs2NSw3IEBAIHN0cnVjdCB2aG9zdF92ZHBhIHsN
Cj4gPiAgICAgICAgIHN0cnVjdCB2ZHBhX2lvdmFfcmFuZ2UgcmFuZ2U7DQo+ID4gICAgICAgICB1
MzIgYmF0Y2hfYXNpZDsNCj4gPiAgICAgICAgIGJvb2wgc3VzcGVuZGVkOw0KPiA+ICsgICAgICAg
Ym9vbCBub2lvbW11X2VuOw0KPiA+ICB9Ow0KPiA+DQo+ID4gIHN0YXRpYyBERUZJTkVfSURBKHZo
b3N0X3ZkcGFfaWRhKTsNCj4gPiBAQCAtODg3LDYgKzg5MywxMCBAQCBzdGF0aWMgdm9pZCB2aG9z
dF92ZHBhX2dlbmVyYWxfdW5tYXAoc3RydWN0DQo+ID4gdmhvc3RfdmRwYSAqdiwgIHsNCj4gPiAg
ICAgICAgIHN0cnVjdCB2ZHBhX2RldmljZSAqdmRwYSA9IHYtPnZkcGE7DQo+ID4gICAgICAgICBj
b25zdCBzdHJ1Y3QgdmRwYV9jb25maWdfb3BzICpvcHMgPSB2ZHBhLT5jb25maWc7DQo+ID4gKw0K
PiA+ICsgICAgICAgaWYgKHYtPm5vaW9tbXVfZW4pDQo+ID4gKyAgICAgICAgICAgICAgIHJldHVy
bjsNCj4gPiArDQo+ID4gICAgICAgICBpZiAob3BzLT5kbWFfbWFwKSB7DQo+ID4gICAgICAgICAg
ICAgICAgIG9wcy0+ZG1hX3VubWFwKHZkcGEsIGFzaWQsIG1hcC0+c3RhcnQsIG1hcC0+c2l6ZSk7
DQo+ID4gICAgICAgICB9IGVsc2UgaWYgKG9wcy0+c2V0X21hcCA9PSBOVUxMKSB7IEBAIC05ODAs
NiArOTkwLDkgQEAgc3RhdGljDQo+ID4gaW50IHZob3N0X3ZkcGFfbWFwKHN0cnVjdCB2aG9zdF92
ZHBhICp2LCBzdHJ1Y3Qgdmhvc3RfaW90bGIgKmlvdGxiLA0KPiA+ICAgICAgICAgaWYgKHIpDQo+
ID4gICAgICAgICAgICAgICAgIHJldHVybiByOw0KPiA+DQo+ID4gKyAgICAgICBpZiAodi0+bm9p
b21tdV9lbikNCj4gPiArICAgICAgICAgICAgICAgZ290byBza2lwX21hcDsNCj4gPiArDQo+ID4g
ICAgICAgICBpZiAob3BzLT5kbWFfbWFwKSB7DQo+ID4gICAgICAgICAgICAgICAgIHIgPSBvcHMt
PmRtYV9tYXAodmRwYSwgYXNpZCwgaW92YSwgc2l6ZSwgcGEsIHBlcm0sIG9wYXF1ZSk7DQo+ID4g
ICAgICAgICB9IGVsc2UgaWYgKG9wcy0+c2V0X21hcCkgew0KPiA+IEBAIC05OTUsNiArMTAwOCw3
IEBAIHN0YXRpYyBpbnQgdmhvc3RfdmRwYV9tYXAoc3RydWN0IHZob3N0X3ZkcGEgKnYsDQo+IHN0
cnVjdCB2aG9zdF9pb3RsYiAqaW90bGIsDQo+ID4gICAgICAgICAgICAgICAgIHJldHVybiByOw0K
PiA+ICAgICAgICAgfQ0KPiA+DQo+ID4gK3NraXBfbWFwOg0KPiA+ICAgICAgICAgaWYgKCF2ZHBh
LT51c2VfdmEpDQo+ID4gICAgICAgICAgICAgICAgIGF0b21pYzY0X2FkZChQRk5fRE9XTihzaXpl
KSwgJmRldi0+bW0tPnBpbm5lZF92bSk7DQo+ID4NCj4gPiBAQCAtMTI5OCw2ICsxMzEyLDcgQEAg
c3RhdGljIGludCB2aG9zdF92ZHBhX2FsbG9jX2RvbWFpbihzdHJ1Y3QNCj4gdmhvc3RfdmRwYSAq
dikNCj4gPiAgICAgICAgIHN0cnVjdCB2ZHBhX2RldmljZSAqdmRwYSA9IHYtPnZkcGE7DQo+ID4g
ICAgICAgICBjb25zdCBzdHJ1Y3QgdmRwYV9jb25maWdfb3BzICpvcHMgPSB2ZHBhLT5jb25maWc7
DQo+ID4gICAgICAgICBzdHJ1Y3QgZGV2aWNlICpkbWFfZGV2ID0gdmRwYV9nZXRfZG1hX2Rldih2
ZHBhKTsNCj4gPiArICAgICAgIHN0cnVjdCBpb21tdV9kb21haW4gKmRvbWFpbjsNCj4gPiAgICAg
ICAgIGNvbnN0IHN0cnVjdCBidXNfdHlwZSAqYnVzOw0KPiA+ICAgICAgICAgaW50IHJldDsNCj4g
Pg0KPiA+IEBAIC0xMzA1LDYgKzEzMjAsMTQgQEAgc3RhdGljIGludCB2aG9zdF92ZHBhX2FsbG9j
X2RvbWFpbihzdHJ1Y3QNCj4gdmhvc3RfdmRwYSAqdikNCj4gPiAgICAgICAgIGlmIChvcHMtPnNl
dF9tYXAgfHwgb3BzLT5kbWFfbWFwKQ0KPiA+ICAgICAgICAgICAgICAgICByZXR1cm4gMDsNCj4g
Pg0KPiA+ICsgICAgICAgZG9tYWluID0gaW9tbXVfZ2V0X2RvbWFpbl9mb3JfZGV2KGRtYV9kZXYp
Ow0KPiA+ICsgICAgICAgaWYgKCghZG9tYWluIHx8IGRvbWFpbi0+dHlwZSA9PSBJT01NVV9ET01B
SU5fSURFTlRJVFkpICYmDQo+ID4gKyAgICAgICAgICAgdmhvc3RfdmRwYV9ub2lvbW11ICYmIGNh
cGFibGUoQ0FQX1NZU19SQVdJTykpIHsNCj4gPiArICAgICAgICAgICAgICAgYWRkX3RhaW50KFRB
SU5UX1VTRVIsIExPQ0tERVBfU1RJTExfT0spOw0KPiA+ICsgICAgICAgICAgICAgICBkZXZfd2Fy
bigmdi0+ZGV2LCAiQWRkaW5nIGtlcm5lbCB0YWludCBmb3Igbm9pb21tdSBvbg0KPiBkZXZpY2Vc
biIpOw0KPiA+ICsgICAgICAgICAgICAgICB2LT5ub2lvbW11X2VuID0gdHJ1ZTsNCj4gPiArICAg
ICAgICAgICAgICAgcmV0dXJuIDA7DQo+ID4gKyAgICAgICB9DQo+ID4gICAgICAgICBidXMgPSBk
bWFfZGV2LT5idXM7DQo+ID4gICAgICAgICBpZiAoIWJ1cykNCj4gPiAgICAgICAgICAgICAgICAg
cmV0dXJuIC1FRkFVTFQ7DQo+ID4gLS0NCj4gPiAyLjI1LjENCj4gPg0KDQo=

