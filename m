Return-Path: <kvm+bounces-23347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 224CF948E0E
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 13:47:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCE3C2872AD
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 11:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE1281C37AE;
	Tue,  6 Aug 2024 11:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="JSQ5yaXd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5325D2A1CF
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 11:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.156.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722944846; cv=fail; b=XLRmmuNN3d5pjHcaGov6IU4Q/OwLU9NM06PJ+/oULPRO3U+W7aB3dREF2SKdPkaVHfNTzREG+27uqnO2iA5wQBZZB8Q5XD0Utct5rMNGtzzyiUgQT5ACxpKbIA17UK1IUCAKnXhle3NQJXF4iDEPDr179HwT1ft4EA9YL0uiAY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722944846; c=relaxed/simple;
	bh=aoMEZvbWKHoeHEoPPASxkWS8L8xe03AmIhnJomvxQtw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WMb9jXXhMbwc7dN3Gtx/ZdbhT9YkON2LSmLwWLWD9ImE/seqxGT60k1gRXUdUYtPrc6xoxZs3gWO5aSxPMGAV9+1ucURNXqnZl6507Eyisd2XsfGBdU3SHiOF3aMjF//OQ0v+u5TP6gxvxiDFElTW4t28pWJ/hcs31hW3C0wwpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=JSQ5yaXd; arc=fail smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4763fx2B017010;
	Tue, 6 Aug 2024 04:47:12 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2049.outbound.protection.outlook.com [104.47.55.49])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 40uc5f1h35-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 04:47:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aMQkQB8jKkIrwPIwXN/4IEN/bfUWMrq27qjeuwHiqxGH7aBDDZ4B2pwlF+PDloGNmTBv/wAJk6nHb/eyz1nFjRFG72Yyk8BPYAyjzicVjzREx/LfCLRZJM+ol7VdSe9yUqRKenBb1HoXUAMVUzn09TAW2A3NFN7vONO4TfNTWEFA7l0Q+PR2Z2EsDs9jOJX9NMjMcE4E+QaWgG99Q7xq2pPMfPN/mPbRM0ZNeZJa3kchuOlOqOfqfxjdBtC016hGj+Zlp/Kt+RzvWvWNiRtQ+1KYgfCiuUchyimwIP52KJcVhca+KT96yQZ7xTTGUbWacqatxdKHj567rUQuxgdHLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aoMEZvbWKHoeHEoPPASxkWS8L8xe03AmIhnJomvxQtw=;
 b=fM5Yut8l3IPPL2U/bNDRrADM8M2ZLrI+0el/w5AT2+d+WU7XLy4gErmTLOjRZzFsQIN+WjHPm+kcDqBaTL41Ydkl9KUdUSgkT8CD7dnuyyMY7czEuzy0gl89SDpwb3jyugCgFLpbbFQF2lkMvrtau01uEkkkL7SjkUX1600jw9lylPm6m0bghsPTooMpaaozuwvvop/U+5axcqKEwg8FuSTUxfrkUapYyWRCPPx/IACKbCE1ns5wdeSsUmL7NKkCE38AvurhFypdrxQIv4pM14dDOmFrTYzJKca96nPb7Ei4VVmVL9qWTIklWtRRVQIDPf6zOvaxBzzy0eRDuOgryg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aoMEZvbWKHoeHEoPPASxkWS8L8xe03AmIhnJomvxQtw=;
 b=JSQ5yaXdUNKhjsu7X0+43+YJ/lr/+Rjxp468BqgyK089+XQTFPbT57lwreAajHD5KOIenCXq8+mciUjDjGZuNk18KCKLO8RU41PX+jgGLyXG4avz19ViplDHj0/Zf59jjqxwIEFX3yqwQt404enr22s7+SFJsB/R0aoAVD5I0Q4=
Received: from DS0PR18MB5368.namprd18.prod.outlook.com (2603:10b6:8:12f::17)
 by DS0PR18MB5410.namprd18.prod.outlook.com (2603:10b6:8:15e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Tue, 6 Aug
 2024 11:47:09 +0000
Received: from DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac]) by DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac%5]) with mapi id 15.20.7807.026; Tue, 6 Aug 2024
 11:47:09 +0000
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
 AQHasnq4Ve/zJa91a0mQb+nM4LHR9bH6+HqAgANtqRCABESwAIAAB/wAgAGBD8CAAEc/gIAWCbHQ
Date: Tue, 6 Aug 2024 11:47:08 +0000
Message-ID:
 <DS0PR18MB53689BE0C0DFDBD86D396515A0BF2@DS0PR18MB5368.namprd18.prod.outlook.com>
References: <20240530101823.1210161-1-schalla@marvell.com>
 <20240717054547-mutt-send-email-mst@kernel.org>
 <DS0PR18MB536893E8C3A628A95BF8DDA0A0AD2@DS0PR18MB5368.namprd18.prod.outlook.com>
 <CACGkMEtQ3SWBpS-00BBCJxoUK5AQRB=FhKGEqigh81GTbRf61A@mail.gmail.com>
 <20240722034957-mutt-send-email-mst@kernel.org>
 <DS0PR18MB5368298DAEA53CF7F9710B46A0A92@DS0PR18MB5368.namprd18.prod.outlook.com>
 <20240723070326-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240723070326-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR18MB5368:EE_|DS0PR18MB5410:EE_
x-ms-office365-filtering-correlation-id: cfa52ebb-96de-47ff-4724-08dcb60d80af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?d3R5YlZBQmZ5bFRDUEhSeFJxaUo1U0RLampjUWZCVDBNTVJCSCs4YisveTh6?=
 =?utf-8?B?UDJMc3FkdzNSdFljdDNzV2lRWUhHelJxM3NMUWt5VjVLOXh5KzFiZjlFWnFV?=
 =?utf-8?B?OXhEdnh6Wndjb1JRekFxQW9jQVc4ekhMT3FJN2FlcmVsL0ZqK2c0RXdPdDNu?=
 =?utf-8?B?SjlEYmJNV1dkNUt6SGlja2xhdC8rUkdtQTJyYkN5elZtaXpqUThSUVhBMzVo?=
 =?utf-8?B?dkczblJXUk96VUdFb1ZNS0lrVEY2WWFGTmZZb1ZyR0lHRmlzSWpQQUg3eVF5?=
 =?utf-8?B?dmpJeDBZRlhiYTNLaVlFb25qdEgxbmRGSHJINERvRnBRVkZLMlEzRktxT0tw?=
 =?utf-8?B?OHRHMDNqZjVyb3ZHdHExdm44NU1IZkxmMlNwM2tLUWhMZlAyaGpNWHhvRmdQ?=
 =?utf-8?B?cGZPaHhRTFIvakdmaFcwQTdxKy9xdGZ2M2hxMXpRYWc2VDcyVklnZnNPaXV4?=
 =?utf-8?B?Tml2Zm5VYjlGM1ZCVHFlYWFkMDgrVGZXMjZjYXFwc0w3WlpPblNHRURRT2o5?=
 =?utf-8?B?MzVUeWRqOTZhWnYrSGEvYkxoZFlRR2xibjZaMGEvb0ZtUWVRL1liSVpUQkEr?=
 =?utf-8?B?NS9hd3ExMWdWUFphV0NTbkpvMEV5b3RVQ095TDVmZjVJUUlTRGdnTk13T0Fx?=
 =?utf-8?B?WE9HNFVsZnBDMlN3QzZiSlNvMHJpQ1cwS1lQMktNV1dLOWxBbU52RkdqckM3?=
 =?utf-8?B?b09pdml5dGVGYVRKcW1QWFhqNkR0VVFXb0JZZ3VuYktBOFFpcE5NVkEzMFVv?=
 =?utf-8?B?YlJoTUN0L1REMTF2T0kxR1lGMWRDM2N5MmJEUWNsUE5yeHFQOVVoM3dLaHQx?=
 =?utf-8?B?aFI1elo1Ly9HOXVUM0lZMmpMRkZrMEtSYkoxS3d2elJzR1pDUjNONmduaDMw?=
 =?utf-8?B?SFRBU3RWUjdvZ3F2cURKd2l6R1BDOGpnVUZnUmhkT3lXUytBZFFsM29KbkpI?=
 =?utf-8?B?NzNtR3BCL2RBM3hxNHdIWnk4WkpGQUJHYzdUV2RJVVQzemlaU2dRS0M2R0lo?=
 =?utf-8?B?YkZHTVRhS2dzYTFCMjZoMmhza1BXSkd0blBlVEdISDZKSzFhRFNsM21YdFN2?=
 =?utf-8?B?T0xGaFNKUUNkaDlWQitocXVuMjc5eHVzdzR4aXk2VVBJejhIOEdQekt0M01v?=
 =?utf-8?B?QUtRLzNDZC80ajAxWmtTckx6dUhONmtsQXVaSW9WVEFRdExFYzBoazBBdzA0?=
 =?utf-8?B?WDN4YjQwWmF1aFVzZWZnV3MrWEpiMStNdjZsZ2RjMis2NkZ5MGJFNktQUnlz?=
 =?utf-8?B?RUluaS9WSm9HNGtLSmkxZHhiSWxQTG9YQTQ4Nis3OXlQU1ZYZWJCOHkvYlRB?=
 =?utf-8?B?R3ZSdzdmZ3gxWmpkdWplWWRmOUhSUnZhMk8yOEVLUmg4UWZSM2p1THpYaGxt?=
 =?utf-8?B?Y2dYd1Yycm56L2wwekFJZjJQYkRyQkRYTldYcXVweHZZakxoWnlmbDBYYUlt?=
 =?utf-8?B?eTNTQkl1aTlyWUlWZ2EvVkpEcUZONFliVFBkVTlOSVdnSWMzQWgzQWdJN1RY?=
 =?utf-8?B?VWtVOW9MeGtVRTkya05nb3F0OTJnSkQ1LzIrUzdSOWxLMjVuVXIva2NRdG9p?=
 =?utf-8?B?OFZVemZvWEp3Z1hiT1ViTEk3cUE4SUtNU1ZPMDRnS2FHK05QL3ArMXJKRHNh?=
 =?utf-8?B?TnoyR0NXVVlTRkFIUFlZN29NZzRsTGhwZitGQTJTTlFrdFF5U01vWW9TN0xi?=
 =?utf-8?B?TldCVGY4VWV1bnMwa1AxcUJXQkhWbmk2Yi9EcUVxY1Y0MjhUMTdQLzZFUmNE?=
 =?utf-8?B?Y1kzakVjbkVVQnYrT0prbjBYRDBLV1BkQUJ6c3FnVkdkd1J3bkxlV2I5bUQ1?=
 =?utf-8?B?cUF2TlVIVlBHWmVwbVU3Q3ZJTzI5bG1Cd2N0TXI3ZytXaXc1ekkxWUlYWW5j?=
 =?utf-8?B?bDh0ZVNtUGYvUzZpOS9wQW1vQzNtOFMrR0MxRmVhSlJXMmc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR18MB5368.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VTVURlBpU21Fc1lMQ2RnTHB6Vjgyb1R1NlNYUGR2TXd5LzcySFExYUhPb0pq?=
 =?utf-8?B?WGExN3pDbVJtVDBHWDdHYkRXRGZ6VHZ4bE1NQVhva0o3QS91QmhwMkhVcGNw?=
 =?utf-8?B?bjVGOGt3cTdDekVlM1B4ckFrNzV1UWllRFBtWGFVMlBJSmpnNmtLbVQ5aG53?=
 =?utf-8?B?cTZySCs0VVJaYWRheWFCckVyR0duRUVkRndpQ2JsS1NRbU1XaEhiLzhRL0dB?=
 =?utf-8?B?czByd1prUDJhOUxIZGFuTndjV1dzRVhyamFBYTFlNXd0cklmL0hDUkl4WkJy?=
 =?utf-8?B?ZXVqazczeWV4STNLNUNyM1UyZzJZT05PalZPVHU1bkFvWWZveEJMZTRCK2VS?=
 =?utf-8?B?aU5nVzV4UEg4c1NUeTd1Z1RDVUNTYVI4OUI1elErYVI3bDFJd2RPRUk0RG9U?=
 =?utf-8?B?QUljYU4rSWlTd1IrK3lxQ01Ka3g2OW1VclczQmtZbGpwVzRXSFZuMnFMRnhn?=
 =?utf-8?B?U1dtaUIxTkhxZm5oeGE1STJxUlNEbU1NSnowS0lNalhvN1ZJVkpBR3c1Qm9T?=
 =?utf-8?B?RzRRS3V3ZGxrUzIrUDN5MmhRMmZuUVFEbWJBaDhwaFRLallhWTdXbFhEdGRF?=
 =?utf-8?B?YVUyZUd6cGJmeFhoUTRJK2hsQ0UzbHFDbHBiZWprTE90VUdZWjFiUlZwVGhE?=
 =?utf-8?B?ellLUzAvQit3SFppNW5welF2S3hWdGxEZlB6VzlGbDJVTjRxMjduM0MwOXk0?=
 =?utf-8?B?TTFBbWU5SXVZSzBOY3FXRmV5MXVCM09oMXhqQk1sNXhiNWwvZXB3TkJ2NkVp?=
 =?utf-8?B?dXVmcEROZEZ0R3ZBNFI0bVplN1ZUQWxQUElDR2ZtcUs5aitnOSsyaUJ4M25G?=
 =?utf-8?B?YzFvWEwvWFB2T0ord3ZtaWtWRlcrYm05L3BkNU1rT3lmL2VDUjJNSXpKcmVL?=
 =?utf-8?B?OUFyQWlUUmUrY0E4NDlVTUZ6c0l2OEh0VnNYQ2I0VzN2dEtDSXZDdlFPRTNY?=
 =?utf-8?B?bitQOTNBdGVGTTVuU0RjWE1nSmZWUCtNNFNaNE1Bd05DY3c3SGdSUCtsSkZ6?=
 =?utf-8?B?S0lkdnoybGdpL1BoMWpRQlZHaWllQUpNVm8xcndBMFFIRVQ3dGxyMk5qSHVO?=
 =?utf-8?B?Z0NJOGNDVlgzME85RVUxTmVRVFBheGhTUGcwcUhsQThqMVpadE9FbjhTeStp?=
 =?utf-8?B?b2hCV2VSd1JZQmxpWlhyeXRnRktvK09wLzJDVjhJalJLa3RqMEFLRDMzNHY4?=
 =?utf-8?B?S3VtQjVGUENsL1lpaWd3SWpNUHlRUk5kK1ZaaWFpU3pFa01ZOWY5bjhhM0pr?=
 =?utf-8?B?c1c5MFYyaVJBb2p3dGtDQkpLS2xXeHBHWmxnRVRFWXBOL3hENURLSkR0U2lp?=
 =?utf-8?B?M2ZvaU9lZm5TaVdoTzB2MFF3VXYrY01KK2FCbzcrZnlMbFgwN1RGTGZjWHZQ?=
 =?utf-8?B?NW5tN1lUdzkrM3VpUVVoM1NXRkd6WTF4MFFEWlpZWEt4K25jNjNlZEtNbVBD?=
 =?utf-8?B?bjU4VEJpZ2NmTjhWU2diTnA5MkNWYXlCWHBHajRpWm1VNjNsMDNkVEkwU2Ex?=
 =?utf-8?B?WmdhM3R4NGNnbU03c3VWZWVUZERWcURMdjVVMFErcENTelM2WWFZQURhWEVL?=
 =?utf-8?B?cTVzNFUrVWxYNGZKMWhxM0JQSUFuRHRkYnoxR3Nmc094ZzV5a0JzWm9yR1VP?=
 =?utf-8?B?ZEZ1Y1g0Vy9NeXMyWFN0WEE3U21jYnhKQkR2WmIxTUNlcnNHOTJCSk9wZERO?=
 =?utf-8?B?R3BjV2FqTDlOTmFVY05PTHhrQ3BzZ0QzOXUvSk1YTWllK1RNNFdmOTZOZmVL?=
 =?utf-8?B?VVNSeUxRK1RyNFJyS1NKT2o2SzZ3SjFGZHVCN2ZOY0hEcTZvcDZuZm8yalZK?=
 =?utf-8?B?VW9YWVlhcDh2bmMvc3BKelNSY0M1YnJPK3RxVmVOZU5jaWNkUFlxMmVjeXlP?=
 =?utf-8?B?QnVFUkFkUjE5NmQvbHBOZ1BRaFNTSlNyRDlOSkxKZHEyS21McXN6UW9xRE1Q?=
 =?utf-8?B?cDR2cXhpdGFqK3V2OVBpNkFnbW9HU0ozYSt4dzB1NWhSTnpJZEY2cGJGSkl4?=
 =?utf-8?B?SEZDNlBpb2NXVmd0d1JmcVg5WFFzaE5FbVo4bnUwcm1tYStIdS9OSDJTL3Vq?=
 =?utf-8?B?djR1VUE5dFVHdk5TNlJpYStzYmV0ZUdhT3M0QUFuU0c5Y0swaUJRTmhYdUV4?=
 =?utf-8?B?V2EwSTB0Q0pZTWJTdzR4emNrdEp1Qld3QUhtUXRYWlJha1ZrYTJHTXVoaVlv?=
 =?utf-8?Q?+K5Xjk1GZCczCSWgh6e8kXz581SsiK6I+b/J37PrlJFV?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cfa52ebb-96de-47ff-4724-08dcb60d80af
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2024 11:47:08.9446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tOl9MtJM2MYeLgH0EJjitk0Mq/IogZ9R7ErqXrkf7Le004s9yerUHZp6p3qk6qR6OcqcgBos6avS6sFZmoQxcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR18MB5410
X-Proofpoint-ORIG-GUID: n1v4qhaC_Az-2lB0TY3yepJ33RUoikwy
X-Proofpoint-GUID: n1v4qhaC_Az-2lB0TY3yepJ33RUoikwy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-06_08,2024-08-06_01,2024-05-17_01

PiBPbiBUdWUsIEp1bCAyMywgMjAyNCBhdCAwNzoxMDo1MkFNICswMDAwLCBTcnVqYW5hIENoYWxs
YSB3cm90ZToNCj4gPiA+IE9uIE1vbiwgSnVsIDIyLCAyMDI0IGF0IDAzOjIyOjIyUE0gKzA4MDAs
IEphc29uIFdhbmcgd3JvdGU6DQo+ID4gPiA+IE9uIEZyaSwgSnVsIDE5LCAyMDI0IGF0IDExOjQw
4oCvUE0gU3J1amFuYSBDaGFsbGENCj4gPiA+ID4gPHNjaGFsbGFAbWFydmVsbC5jb20+DQo+ID4g
PiB3cm90ZToNCj4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gT24gVGh1LCBNYXkgMzAsIDIwMjQgYXQg
MDM6NDg6MjNQTSArMDUzMCwgU3J1amFuYSBDaGFsbGEgd3JvdGU6DQo+ID4gPiA+ID4gPiA+IFRo
aXMgY29tbWl0IGludHJvZHVjZXMgc3VwcG9ydCBmb3IgYW4gVU5TQUZFLCBuby1JT01NVSBtb2Rl
DQo+ID4gPiA+ID4gPiA+IGluIHRoZSB2aG9zdC12ZHBhIGRyaXZlci4gV2hlbiBlbmFibGVkLCB0
aGlzIG1vZGUgcHJvdmlkZXMNCj4gPiA+ID4gPiA+ID4gbm8gZGV2aWNlIGlzb2xhdGlvbiwgbm8g
RE1BIHRyYW5zbGF0aW9uLCBubyBob3N0IGtlcm5lbA0KPiA+ID4gPiA+ID4gPiBwcm90ZWN0aW9u
LCBhbmQgY2Fubm90IGJlIHVzZWQgZm9yIGRldmljZSBhc3NpZ25tZW50IHRvDQo+ID4gPiA+ID4g
PiA+IHZpcnR1YWwgbWFjaGluZXMuIEl0IHJlcXVpcmVzIFJBV0lPIHBlcm1pc3Npb25zIGFuZCB3
aWxsIHRhaW50IHRoZQ0KPiBrZXJuZWwuDQo+ID4gPiA+ID4gPiA+IFRoaXMgbW9kZSByZXF1aXJl
cyBlbmFibGluZyB0aGUNCj4gPiA+ID4gPiA+ICJlbmFibGVfdmhvc3RfdmRwYV91bnNhZmVfbm9p
b21tdV9tb2RlIg0KPiA+ID4gPiA+ID4gPiBvcHRpb24gb24gdGhlIHZob3N0LXZkcGEgZHJpdmVy
LiBUaGlzIG1vZGUgd291bGQgYmUgdXNlZnVsDQo+ID4gPiA+ID4gPiA+IHRvIGdldCBiZXR0ZXIg
cGVyZm9ybWFuY2Ugb24gc3BlY2lmaWNlIGxvdyBlbmQgbWFjaGluZXMgYW5kDQo+ID4gPiA+ID4g
PiA+IGNhbiBiZSBsZXZlcmFnZWQgYnkgZW1iZWRkZWQgcGxhdGZvcm1zIHdoZXJlIGFwcGxpY2F0
aW9ucw0KPiA+ID4gPiA+ID4gPiBydW4gaW4gY29udHJvbGxlZA0KPiA+ID4gZW52aXJvbm1lbnQu
DQo+ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IFNydWphbmEgQ2hh
bGxhIDxzY2hhbGxhQG1hcnZlbGwuY29tPg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFRob3Vn
aHQgaGFyZCBhYm91dCB0aGF0Lg0KPiA+ID4gPiA+ID4gSSB0aGluayBnaXZlbiB2ZmlvIHN1cHBv
cnRzIHRoaXMsIHdlIGNhbiBkbyB0aGF0IHRvbywgYW5kIHRoZQ0KPiA+ID4gPiA+ID4gZXh0ZW5z
aW9uIGlzDQo+ID4gPiBzbWFsbC4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBIb3dldmVyLCBp
dCBsb29rcyBsaWtlIHNldHRpbmcgdGhpcyBwYXJhbWV0ZXIgd2lsbA0KPiA+ID4gPiA+ID4gYXV0
b21hdGljYWxseSBjaGFuZ2UgdGhlIGJlaGF2aW91ciBmb3IgZXhpc3RpbmcgdXNlcnNwYWNlIHdo
ZW4NCj4gPiA+IElPTU1VX0RPTUFJTl9JREVOVElUWSBpcyBzZXQuDQo+ID4gT3VyIGluaXRpYWwg
dGhvdWdodCB3YXMgdG8gc3VwcG9ydCBvbmx5IGZvciBuby1pb21tdSBjYXNlLCBpbiB3aGljaCBk
b21haW4NCj4gaXRzZWxmDQo+ID4gd29uJ3QgYmUgZXhpc3QuICAgU28sIHdlIGNhbiBtb2RpZnkg
dGhlIGNvZGUgYXMgYmVsb3cgdG8gY2hlY2sgZm9yIG9ubHkNCj4gcHJlc2VuY2Ugb2YgZG9tYWlu
Lg0KPiA+IEkgdGhpbmssICBvbmx5IGhhbmRsaW5nIG9mIG5vLWlvbW11IGNhc2Ugd291bGRuJ3Qg
ZWZmZWN0IHRoZSBleGlzdGluZw0KPiB1c2Vyc3BhY2UuDQo+ID4gKyAgIGlmICgoIWRvbWFpbikg
JiYgdmhvc3RfdmRwYV9ub2lvbW11ICYmIGNhcGFibGUoQ0FQX1NZU19SQVdJTykpIHsNCj4gDQo+
IEkgd291bGQgcHJlZmVyIHNvbWUgZXhwbGljaXQgYWN0aW9uLg0KPiBKdXN0IG5vdCBzcGVjaWZ5
aW5nIGEgZG9tYWluIGlzIHNvbWV0aGluZyBJJ2QgbGlrZSB0byBrZWVwIHJlc2VydmVkIGZvcg0K
PiBzb21ldGhpbmcgb2YgbW9yZSB3aWRlIHVzZWZ1bG5lc3MuDQpDYW4gd2UgaW50cm9kdWNlIGEg
bmV3IGZlYXR1cmUgbGlrZSBWSE9TVF9CQUNLRU5EX0ZfTk9JT01NVSBpbiANClZIT1NUX1ZEUEFf
QkFDS0VORF9GRUFUVVJFUz8gIFdlIGNhbiBoYXZlIGJlbG93IGxvZ2ljIGJhc2VkIG9uDQp0aGlz
IGZlYXR1cmUgYml0IG5lZ290aWF0aW9uLg0KVGhhbmtzLg0KPiANCj4gDQo+ID4gPiA+ID4gPg0K
PiA+ID4gPiA+ID4gSSBzdWdnZXN0IGEgbmV3IGRvbWFpbiB0eXBlIGZvciB1c2UganVzdCBmb3Ig
dGhpcyBwdXJwb3NlLg0KPiA+ID4gPg0KPiA+ID4gPiBJJ20gbm90IHN1cmUgSSBnZXQgdGhpcywg
d2Ugd2FudCB0byBieXBhc3MgSU9NTVUsIHNvIGl0IGRvZXNuJ3QNCj4gPiA+ID4gZXZlbiBoYXZl
IGEgZG9tYW4uDQo+ID4gPg0KPiA+ID4geWVzLCBhIGZha2Ugb25lLiBvciBjb21lIHVwIHdpdGgg
c29tZSBvdGhlciBmbGFnIHRoYXQgdXNlcnNwYWNlIHdpbGwgc2V0Lg0KPiA+ID4NCj4gPiA+ID4g
PiBUaGlzIHdheSBpZiBob3N0IGhhcw0KPiA+ID4gPiA+ID4gYW4gaW9tbXUsIHRoZW4gdGhlIHNh
bWUga2VybmVsIGNhbiBydW4gYm90aCBWTXMgd2l0aCBpc29sYXRpb24NCj4gPiA+ID4gPiA+IGFu
ZCB1bnNhZmUgZW1iZWRkZWQgYXBwcyB3aXRob3V0Lg0KPiA+ID4gPiA+IENvdWxkIHlvdSBwcm92
aWRlIGZ1cnRoZXIgZGV0YWlscyBvbiB0aGlzIGNvbmNlcHQ/IFdoYXQgY3JpdGVyaWENCj4gPiA+
ID4gPiB3b3VsZCBkZXRlcm1pbmUgdGhlIGNvbmZpZ3VyYXRpb24gb2YgdGhlIG5ldyBkb21haW4g
dHlwZT8gV291bGQNCj4gPiA+ID4gPiB0aGlzIHJlcXVpcmUgYSBib290IHBhcmFtZXRlciBzaW1p
bGFyIHRvIElPTU1VX0RPTUFJTl9JREVOVElUWSwNCj4gPiA+ID4gPiBzdWNoIGFzDQo+ID4gPiBp
b21tdS5wYXNzdGhyb3VnaD0xIG9yIGlvbW11LnB0Pw0KPiA+ID4gPg0KPiA+ID4gPiBUaGFua3MN
Cj4gPiA+ID4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+IC0tLQ0KPiA+ID4gPiA+ID4gPiAg
ZHJpdmVycy92aG9zdC92ZHBhLmMgfCAyMyArKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ID4g
PiA+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKykNCj4gPiA+ID4gPiA+ID4N
Cj4gPiA+ID4gPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmhvc3QvdmRwYS5jIGIvZHJpdmVy
cy92aG9zdC92ZHBhLmMNCj4gPiA+ID4gPiA+ID4gaW5kZXggYmM0YTUxZTQ2MzhiLi5kMDcxYzMw
MTI1YWEgMTAwNjQ0DQo+ID4gPiA+ID4gPiA+IC0tLSBhL2RyaXZlcnMvdmhvc3QvdmRwYS5jDQo+
ID4gPiA+ID4gPiA+ICsrKyBiL2RyaXZlcnMvdmhvc3QvdmRwYS5jDQo+ID4gPiA+ID4gPiA+IEBA
IC0zNiw2ICszNiwxMSBAQCBlbnVtIHsNCj4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gICNk
ZWZpbmUgVkhPU1RfVkRQQV9JT1RMQl9CVUNLRVRTIDE2DQo+ID4gPiA+ID4gPiA+DQo+ID4gPiA+
ID4gPiA+ICtib29sIHZob3N0X3ZkcGFfbm9pb21tdTsNCj4gPiA+ID4gPiA+ID4NCj4gK21vZHVs
ZV9wYXJhbV9uYW1lZChlbmFibGVfdmhvc3RfdmRwYV91bnNhZmVfbm9pb21tdV9tb2RlLA0KPiA+
ID4gPiA+ID4gPiArICAgICAgICAgICAgICB2aG9zdF92ZHBhX25vaW9tbXUsIGJvb2wsIDA2NDQp
Ow0KPiA+ID4gPiA+ID4gPg0KPiArTU9EVUxFX1BBUk1fREVTQyhlbmFibGVfdmhvc3RfdmRwYV91
bnNhZmVfbm9pb21tdV9tb2RlLA0KPiA+ID4gPiA+ID4gIkVuYWJsZQ0KPiA+ID4gPiA+ID4gPiAr
VU5TQUZFLCBuby1JT01NVSBtb2RlLiAgVGhpcyBtb2RlIHByb3ZpZGVzIG5vIGRldmljZQ0KPiA+
ID4gPiA+ID4gPiAraXNvbGF0aW9uLCBubyBETUEgdHJhbnNsYXRpb24sIG5vIGhvc3Qga2VybmVs
IHByb3RlY3Rpb24sDQo+ID4gPiA+ID4gPiA+ICtjYW5ub3QgYmUgdXNlZCBmb3IgZGV2aWNlIGFz
c2lnbm1lbnQgdG8gdmlydHVhbCBtYWNoaW5lcywNCj4gPiA+ID4gPiA+ID4gK3JlcXVpcmVzIFJB
V0lPIHBlcm1pc3Npb25zLCBhbmQgd2lsbCB0YWludCB0aGUga2VybmVsLiAgSWYNCj4gPiA+ID4g
PiA+ID4gK3lvdSBkbyBub3Qga25vdyB3aGF0IHRoaXMgaXMNCj4gPiA+IGZvciwgc3RlcCBhd2F5
Lg0KPiA+ID4gPiA+ID4gPiArKGRlZmF1bHQ6IGZhbHNlKSIpOw0KPiA+ID4gPiA+ID4gPiArDQo+
ID4gPiA+ID4gPiA+ICBzdHJ1Y3Qgdmhvc3RfdmRwYV9hcyB7DQo+ID4gPiA+ID4gPiA+ICAgICBz
dHJ1Y3QgaGxpc3Rfbm9kZSBoYXNoX2xpbms7DQo+ID4gPiA+ID4gPiA+ICAgICBzdHJ1Y3Qgdmhv
c3RfaW90bGIgaW90bGI7IEBAIC02MCw2ICs2NSw3IEBAIHN0cnVjdA0KPiA+ID4gPiA+ID4gPiB2
aG9zdF92ZHBhIHsNCj4gPiA+ID4gPiA+ID4gICAgIHN0cnVjdCB2ZHBhX2lvdmFfcmFuZ2UgcmFu
Z2U7DQo+ID4gPiA+ID4gPiA+ICAgICB1MzIgYmF0Y2hfYXNpZDsNCj4gPiA+ID4gPiA+ID4gICAg
IGJvb2wgc3VzcGVuZGVkOw0KPiA+ID4gPiA+ID4gPiArICAgYm9vbCBub2lvbW11X2VuOw0KPiA+
ID4gPiA+ID4gPiAgfTsNCj4gPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+ID4gIHN0YXRpYyBERUZJ
TkVfSURBKHZob3N0X3ZkcGFfaWRhKTsgQEAgLTg4Nyw2ICs4OTMsMTAgQEANCj4gPiA+ID4gPiA+
ID4gc3RhdGljIHZvaWQgdmhvc3RfdmRwYV9nZW5lcmFsX3VubWFwKHN0cnVjdCB2aG9zdF92ZHBh
ICp2LCAgew0KPiA+ID4gPiA+ID4gPiAgICAgc3RydWN0IHZkcGFfZGV2aWNlICp2ZHBhID0gdi0+
dmRwYTsNCj4gPiA+ID4gPiA+ID4gICAgIGNvbnN0IHN0cnVjdCB2ZHBhX2NvbmZpZ19vcHMgKm9w
cyA9IHZkcGEtPmNvbmZpZzsNCj4gPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gPiArICAgaWYg
KHYtPm5vaW9tbXVfZW4pDQo+ID4gPiA+ID4gPiA+ICsgICAgICAgICAgIHJldHVybjsNCj4gPiA+
ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gPiAgICAgaWYgKG9wcy0+ZG1hX21hcCkgew0KPiA+ID4g
PiA+ID4gPiAgICAgICAgICAgICBvcHMtPmRtYV91bm1hcCh2ZHBhLCBhc2lkLCBtYXAtPnN0YXJ0
LCBtYXAtPnNpemUpOw0KPiA+ID4gPiA+ID4gPiAgICAgfSBlbHNlIGlmIChvcHMtPnNldF9tYXAg
PT0gTlVMTCkgeyBAQCAtOTgwLDYgKzk5MCw5IEBADQo+ID4gPiA+ID4gPiA+IHN0YXRpYyBpbnQg
dmhvc3RfdmRwYV9tYXAoc3RydWN0IHZob3N0X3ZkcGEgKnYsDQo+ID4gPiA+ID4gPiBzdHJ1Y3Qg
dmhvc3RfaW90bGIgKmlvdGxiLA0KPiA+ID4gPiA+ID4gPiAgICAgaWYgKHIpDQo+ID4gPiA+ID4g
PiA+ICAgICAgICAgICAgIHJldHVybiByOw0KPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiAr
ICAgaWYgKHYtPm5vaW9tbXVfZW4pDQo+ID4gPiA+ID4gPiA+ICsgICAgICAgICAgIGdvdG8gc2tp
cF9tYXA7DQo+ID4gPiA+ID4gPiA+ICsNCj4gPiA+ID4gPiA+ID4gICAgIGlmIChvcHMtPmRtYV9t
YXApIHsNCj4gPiA+ID4gPiA+ID4gICAgICAgICAgICAgciA9IG9wcy0+ZG1hX21hcCh2ZHBhLCBh
c2lkLCBpb3ZhLCBzaXplLCBwYSwgcGVybSwgb3BhcXVlKTsNCj4gPiA+ID4gPiA+ID4gICAgIH0g
ZWxzZSBpZiAob3BzLT5zZXRfbWFwKSB7IEBAIC05OTUsNiArMTAwOCw3IEBAIHN0YXRpYw0KPiA+
ID4gPiA+ID4gPiBpbnQgdmhvc3RfdmRwYV9tYXAoc3RydWN0IHZob3N0X3ZkcGEgKnYsDQo+ID4g
PiA+ID4gPiBzdHJ1Y3Qgdmhvc3RfaW90bGIgKmlvdGxiLA0KPiA+ID4gPiA+ID4gPiAgICAgICAg
ICAgICByZXR1cm4gcjsNCj4gPiA+ID4gPiA+ID4gICAgIH0NCj4gPiA+ID4gPiA+ID4NCj4gPiA+
ID4gPiA+ID4gK3NraXBfbWFwOg0KPiA+ID4gPiA+ID4gPiAgICAgaWYgKCF2ZHBhLT51c2VfdmEp
DQo+ID4gPiA+ID4gPiA+ICAgICAgICAgICAgIGF0b21pYzY0X2FkZChQRk5fRE9XTihzaXplKSwN
Cj4gPiA+ID4gPiA+ID4gJmRldi0+bW0tPnBpbm5lZF92bSk7DQo+ID4gPiA+ID4gPiA+DQo+ID4g
PiA+ID4gPiA+IEBAIC0xMjk4LDYgKzEzMTIsNyBAQCBzdGF0aWMgaW50DQo+ID4gPiA+ID4gPiA+
IHZob3N0X3ZkcGFfYWxsb2NfZG9tYWluKHN0cnVjdA0KPiA+ID4gPiA+ID4gdmhvc3RfdmRwYSAq
dikNCj4gPiA+ID4gPiA+ID4gICAgIHN0cnVjdCB2ZHBhX2RldmljZSAqdmRwYSA9IHYtPnZkcGE7
DQo+ID4gPiA+ID4gPiA+ICAgICBjb25zdCBzdHJ1Y3QgdmRwYV9jb25maWdfb3BzICpvcHMgPSB2
ZHBhLT5jb25maWc7DQo+ID4gPiA+ID4gPiA+ICAgICBzdHJ1Y3QgZGV2aWNlICpkbWFfZGV2ID0g
dmRwYV9nZXRfZG1hX2Rldih2ZHBhKTsNCj4gPiA+ID4gPiA+ID4gKyAgIHN0cnVjdCBpb21tdV9k
b21haW4gKmRvbWFpbjsNCj4gPiA+ID4gPiA+ID4gICAgIGNvbnN0IHN0cnVjdCBidXNfdHlwZSAq
YnVzOw0KPiA+ID4gPiA+ID4gPiAgICAgaW50IHJldDsNCj4gPiA+ID4gPiA+ID4NCj4gPiA+ID4g
PiA+ID4gQEAgLTEzMDUsNiArMTMyMCwxNCBAQCBzdGF0aWMgaW50DQo+ID4gPiA+ID4gPiA+IHZo
b3N0X3ZkcGFfYWxsb2NfZG9tYWluKHN0cnVjdA0KPiA+ID4gPiA+ID4gdmhvc3RfdmRwYSAqdikN
Cj4gPiA+ID4gPiA+ID4gICAgIGlmIChvcHMtPnNldF9tYXAgfHwgb3BzLT5kbWFfbWFwKQ0KPiA+
ID4gPiA+ID4gPiAgICAgICAgICAgICByZXR1cm4gMDsNCj4gPiA+ID4gPiA+ID4NCj4gPiA+ID4g
PiA+ID4gKyAgIGRvbWFpbiA9IGlvbW11X2dldF9kb21haW5fZm9yX2RldihkbWFfZGV2KTsNCj4g
PiA+ID4gPiA+ID4gKyAgIGlmICgoIWRvbWFpbiB8fCBkb21haW4tPnR5cGUgPT0gSU9NTVVfRE9N
QUlOX0lERU5USVRZKQ0KPiAmJg0KPiA+ID4gPiA+ID4gPiArICAgICAgIHZob3N0X3ZkcGFfbm9p
b21tdSAmJiBjYXBhYmxlKENBUF9TWVNfUkFXSU8pKSB7DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+
ID4gU28gaWYgdXNlcnNwYWNlIGRvZXMgbm90IGhhdmUgQ0FQX1NZU19SQVdJTyBpbnN0ZWFkIG9m
IGZhaWxpbmcNCj4gPiA+ID4gPiA+IHdpdGggYSBwZXJtaXNzaW9uIGVycm9yIHRoZSBmdW5jdGlv
bmFsaXR5IGNoYW5nZXMgc2lsZW50bHk/DQo+ID4gPiA+ID4gPiBUaGF0J3MgY29uZnVzaW5nLCBJ
IHRoaW5rLg0KPiA+ID4gPiA+IFllcywgeW91IGFyZSBjb3JyZWN0LiBJIHdpbGwgbW9kaWZ5IHRo
ZSBjb2RlIHRvIHJldHVybiBlcnJvcg0KPiA+ID4gPiA+IHdoZW4gdmhvc3RfdmRwYV9ub2lvbW11
IGlzIHNldCBhbmQgQ0FQX1NZU19SQVdJTyBpcyBub3Qgc2V0Lg0KPiA+ID4gPiA+DQo+ID4gPiA+
ID4gVGhhbmtzLg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+ICsgICAg
ICAgICAgIGFkZF90YWludChUQUlOVF9VU0VSLCBMT0NLREVQX1NUSUxMX09LKTsNCj4gPiA+ID4g
PiA+ID4gKyAgICAgICAgICAgZGV2X3dhcm4oJnYtPmRldiwgIkFkZGluZyBrZXJuZWwgdGFpbnQg
Zm9yDQo+ID4gPiA+ID4gPiA+ICsgbm9pb21tdSBvbg0KPiA+ID4gPiA+ID4gZGV2aWNlXG4iKTsN
Cj4gPiA+ID4gPiA+ID4gKyAgICAgICAgICAgdi0+bm9pb21tdV9lbiA9IHRydWU7DQo+ID4gPiA+
ID4gPiA+ICsgICAgICAgICAgIHJldHVybiAwOw0KPiA+ID4gPiA+ID4gPiArICAgfQ0KPiA+ID4g
PiA+ID4gPiAgICAgYnVzID0gZG1hX2Rldi0+YnVzOw0KPiA+ID4gPiA+ID4gPiAgICAgaWYgKCFi
dXMpDQo+ID4gPiA+ID4gPiA+ICAgICAgICAgICAgIHJldHVybiAtRUZBVUxUOw0KPiA+ID4gPiA+
ID4gPiAtLQ0KPiA+ID4gPiA+ID4gPiAyLjI1LjENCj4gPiA+ID4gPg0KPiA+DQoNCg==

