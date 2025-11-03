Return-Path: <kvm+bounces-61844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 82AE8C2CD50
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 16:43:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AD3844F872A
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 15:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67B333176EF;
	Mon,  3 Nov 2025 15:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="kTKAJOyE";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="vInwLLqA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE505265630;
	Mon,  3 Nov 2025 15:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762183953; cv=fail; b=K7P+takRCBZK6TO4c+avgWfx8Zb2MsoKVAOS3+xu0Gkn8EZrZFtq/nLy2fr2ya8q6qLBcxmSK5omv//o/hOPZmK06pVcgKPpmwX4VuDTdbA1/niQT+RNtIpv8DNlfNVMT56OOIC3NSaFl7VbSRv9J1ium3CLc/V+h2gWKYb3eh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762183953; c=relaxed/simple;
	bh=LatV26bsSxpArn2AGGL3R3spbefG6rJj2MBtxiFj4OA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JV79quNpvXFfPGYczRk/S3O0vMa0EYVU+lAd5ZUbhyIJ8AkdMiHsu16xVmIpkvuoIW6HZ4yulzWJDj7DOTkHNb8uam8VH6aU0NeEOA7lNVlGuUdy6gS98CDNbZpcx6xwPeu8yCg5MzyQ0OWlfRxrhlx7MAjAPxof6CbA6/vk5H4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=kTKAJOyE; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=vInwLLqA; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5A39e9Dt424050;
	Mon, 3 Nov 2025 07:32:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=LatV26bsSxpArn2AGGL3R3spbefG6rJj2MBtxiFj4
	OA=; b=kTKAJOyEppacmMHs0NZJJHbwf2u7e8u2cKE9Yt1kFNrwOiPumZjNuR64J
	9WrPSwkFwtWNC3aPCFXJjV9FQU5RmSJIwOejo6pgrZmnap5GpGXePFaDUkSHhiSu
	dXTy6JijkONEzj8fWGvWvzMulu29vqK8TNRtSTWXyFS401CwwF3Cv48uRG8hds1G
	KTDEFZ11UBWV3eT2IqzAsAN0GwOGuFHAGnEUU2yWVaeIYqgao9CO0tHeFeVYenkW
	5rPzHvctyqBKC1kuZqfjiX/Z4JfsJTje9f1+k5n6ntSMzeSgpmSgR7wXmh/Rjwhp
	CcQQOHbjMkRBeezNWp598MuqTVZog==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022119.outbound.protection.outlook.com [52.101.48.119])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4a6sybrsaa-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 07:32:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XdAIyzQ5WzYVF4kZqjxRCZP714SCSxwYM1ldqxQ/hg6h8ML7Bm7SbEN2TKNDZMjej5tdkv6zY4Jn8PPveNtIU3SgS/RFyqVZxTCFVQ7/MUB+gNdKd0rMTDUKNOS7oGlp2uGRxnCVrvDNIyX+/73SAHGSNi17EkN+RRmoss9KxCg/uTyAoUxV77TE4ZQogRzlmVrx0QBpVpuWOgQnwG1By3+dD+01C6gpmKvTpw8Q02AmeDcF9x+fDvUSxXqSTFPwLGkoCznoNXX45kyk3xprimhBPDfK+CUlsevLVTfGDe2Tv0RhxzIE0qBiuEpfi3jqC3Swk7/7oFbgkc6w4Jretg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LatV26bsSxpArn2AGGL3R3spbefG6rJj2MBtxiFj4OA=;
 b=rb9jhfFyO1P/QHrSxJui4jgdLix3zAL/L0sUBL5Un0jSgVUPPUP8ut249w0uuHxzhBwZo9vI1x+kcbb+V5QWU1SfU938rWVbcpRT1fwAVTY3Eds95HGvtiKKFUF7DpyaFrEAvKfvAuAXG8OufANPlINIZy9d+kWyrrRgcI8PMAhACwSQWc4hWpXq9B2mnWRn5RmbRlYcez5GqiZi2B7g0RhdT60M+ATaX4RPSFbMw4x81pCutSwlbVkQW3pY997teW0ZrbxSobf0xYKb78mPjDZ/HnfBX/91mftmDCQUJmxTdAR2dMkaRghcCKShpCEzbUbbpO7rQcMPd+jDNQk5vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LatV26bsSxpArn2AGGL3R3spbefG6rJj2MBtxiFj4OA=;
 b=vInwLLqAbgAPMbIaYPKFERgcbpO0uxLT08R9zbNdh5mBTqWv4OO1JYnqe3Yaj9GZC7JxqHAWURSggZjuYWLsM4WiJ01569rXbObaI3/CyP9iOqJy8/a/7egQubvhgLxRPzO9uvrsdMFpU73no2Gv6LBW1zEVtOLbjZCK0czoalaw3SGhsjG1hFNefKpcI3JY1rNb9rLinfZVL/Z9POMKC7ncgXX+LXsQP8E653lvYZETf6GmhgJDHA8dV6BC32u8E3bBDdGruVlX/xq7MTkDjFvy4ekngyyGaDf+ydFhpoW4jMQXPbdKUPkQIzqXKNmwx2Lqy4kmVhF0xJA4EhK94w==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by CH2PR02MB6553.namprd02.prod.outlook.com
 (2603:10b6:610:34::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 15:32:24 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 15:32:24 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM: x86: Load guest/host PKRU outside of the
 fastpath run loop
Thread-Topic: [PATCH 4/4] KVM: x86: Load guest/host PKRU outside of the
 fastpath run loop
Thread-Index: AQHcSe6Mk5n8WDTvbk+yt3fEzmuvoLTcitMAgAAx3QCABF2AgA==
Date: Mon, 3 Nov 2025 15:32:24 +0000
Message-ID: <436FCED7-9413-44AB-B78E-AB96D1F5C480@nutanix.com>
References: <20251030224246.3456492-1-seanjc@google.com>
 <20251030224246.3456492-5-seanjc@google.com>
 <0AA5A319-C4FC-4EEB-9317-BDC9E2E2E703@nutanix.com>
 <aQUhkDOkQJJceH4N@google.com>
In-Reply-To: <aQUhkDOkQJJceH4N@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|CH2PR02MB6553:EE_
x-ms-office365-filtering-correlation-id: ee8619b3-d1d9-49a3-d29b-08de1aee2ffd
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZmQxWnBhOE93TVdJeGd0cjAxQm1lZXZRd3JCOWE5cmtmeEtLR0tzVm5nT2hp?=
 =?utf-8?B?em5LT2plQTFMdzBhQnFTREx6NHF2Wm8raDZXUE51NmtUUkZmNmVTcUpXWGt6?=
 =?utf-8?B?cWxnaGlObHl4Ym1oUHlNZ3dvNHc2d2xLeVpEYVJ0WWZNeEJUSU5ieitTTkJB?=
 =?utf-8?B?MXdwbHoxck1reldPWkZPVlZhcFlBcmNoQ1JBSWdNazJoeXpFWldzSXViRmNz?=
 =?utf-8?B?Z2JOdkxHUlEyZUpoRm1rL0FISnpKOEpMRHZvMUtFYUI2UUNMWllQQWxHY2pT?=
 =?utf-8?B?UjA2WlYwL3lxK2orQlJzaXc4MSt0eXlWeWFyZWsvZythZmxQYWZGU3NvV0tZ?=
 =?utf-8?B?YTdqTzdLY1hwY1kvQUE0US9NMzlMLzFXQmZwWVZoWEUyNjhYb2RFSGM0dU5P?=
 =?utf-8?B?cWY5Y2ZlcjJ3a1Q4R2V3QTh3dlF1M09pME9IdXdzNHVJRjVCTlRLRW84Ymkw?=
 =?utf-8?B?TUozV0J1MFlUVldJN0xSYi92TlhTY3NwTzhQenBHTHFxTko4THN2eHI4MkY3?=
 =?utf-8?B?WkNOeVZSRHJuWld2b09XUUduVFpPUmdBN3crcS9kUkRlS0JMSWNQeXdIQ1pO?=
 =?utf-8?B?b2RuMkJLbGFpSG1WMDRYNmpTYkF1bVlRTVEyVk1VUXJSVVFwc1lkUXJEMlhB?=
 =?utf-8?B?RWZUeWdHbDlKT3BWcnhmYnVjNmgwclJuSFhtS1RCMVB5cmRlb2RPcXZYRG9t?=
 =?utf-8?B?ZFh2UmIrMU4rYW1DT0NJVi91K09NUWJQTGFYY0JJcWZTMWdWalpndnJDTFls?=
 =?utf-8?B?Z3VnclZwdWZuUENhTy84OHRISkJ4d3BPTDlQNVRQTEJYb1hZS1R3MUs1bmtD?=
 =?utf-8?B?bHBCckoxZWw0VDZqR0tZcHUvM1p1ZzlleEhQNWg0QzRoMVc5bTVUTENLY0lk?=
 =?utf-8?B?V09VS0dhSVNTTkJaMlI1TTNLeWFycEhjNk1NWGtwRS9HNm1nbnYwRVhmUk9y?=
 =?utf-8?B?UjdKdWFIMG9QSGxpYzhVVnI2M08rSXhJUVpLUGxjN2QxN3FpZG5VVElGTUpn?=
 =?utf-8?B?cTFXcHY3NHdidzA0T012MkZkZURZVUozQVhpUm80MVJSWGNYbDkxdkNpcTk5?=
 =?utf-8?B?ZkVyYUUvSXNLWkxUbXlkZUZxcnBIRVpHVXNWdHVWNCs5M2ZqS2dsdFZreWgx?=
 =?utf-8?B?ZnhUL2prazVnSDRaZDZuL0tVaVNaYjd1ditmdUhCWThHakdsMnU0VFp6QjFs?=
 =?utf-8?B?UytVSjlvWDk2aE1YRXNKVFVtcFZvLzVud3JKVGZDdUUxTWxuRXcwdXR2Q21i?=
 =?utf-8?B?eHlTc0hublJaYUpUUm81Y3laVWYwODZkVmxmM3RvcVBoQVB2RU1TMEF0Sm8y?=
 =?utf-8?B?bmNlYzZjcHBhZXNzdzJjWUpzSXVWWmpkZnQrUll1R1gzY0hxcEtMeER2d1da?=
 =?utf-8?B?cGRjQ2gyd0VmNVdSbG1XdEQraVNkNzV1dHZCTDlkVmNyYitlYjJISHNGM2t4?=
 =?utf-8?B?NEVGTXVQRUlxUG0ydUhMZ3R6RXNxcFB6ZkY3TWxqd3BVdXNFVG54Q1J1eU1H?=
 =?utf-8?B?eC9ZR24yQVZlZFhpSlVoc2c4N1RUQXQweVpDUHYxWHJuazhLYXE2RHlwcTZj?=
 =?utf-8?B?YXhraWFvd2x4SkZFT1hHTkVKU0FZOEx4cmVNTXhrMjNZTnlRSStNNHFMQjdT?=
 =?utf-8?B?OHVnTjBLTFZJK2krUE1lR2htdWZ3cS83NVRvbHlGUjU2VCtvTkdKQ1N4djY4?=
 =?utf-8?B?blMzYURGbUFwYnozSmpsc2hIY25BTzdKUWdYeFVBaGs2Z2h0NWJMRXJTc29z?=
 =?utf-8?B?V0k1ekgwa0lIN0tlYUttTmZJOGtyQ3hxdUpmdHplNnVmeGdVUy9GcVRVbms4?=
 =?utf-8?B?ek1LeTVKVnhQR2JxYkdWZm96eDdGWkVLdHk0dSt5NnRud0c0NlJ4R0x4R1JC?=
 =?utf-8?B?RldPRHpZUUlKMEMrazBWRGEyTjNsL0toWjlweTdHUUpoNDMxQzlKeXhhNjNj?=
 =?utf-8?B?bituWktIb3EyK3Z0Y0RqMDJBV2hhVnN0aHUwZURkS3dXY05yTHlGeGtPeTl2?=
 =?utf-8?B?UnhzSC96SThxMHg0WWhTcjlFb01yeFJzNmM5YmpuaERTYVoxK2JFckk3dnFG?=
 =?utf-8?Q?tc/A5p?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UVI1V29DT1Z3MDlDVmtSMzRVNzJGODUzbi9SRnRnMG1aMWU0eVFzSllraFFF?=
 =?utf-8?B?amw2T2tQYUhUMUg4WmxGQlQzUktzWFNSdUtoNW1sZVE4MmI1czk5UWN5SnZx?=
 =?utf-8?B?RVBNaFAwamxrc1ZRWkJNUmhVSFZqcUExcG1maVdaTlhiaDRIM0xSTGlVeG9F?=
 =?utf-8?B?SVAzQkpIOTNXMEJERENSKy84VHFmcHc5OUxOMXdnWm1tQytyNndOdks2bElM?=
 =?utf-8?B?TjQwNjhscmdGT1hoN0NsQVlpenJVR0VlWHBzamdEQy9HNGZubTNlNnp4eHYx?=
 =?utf-8?B?WWdxbGVmUkR2ZGRjRkhGaUxQQUhCNUpMelZ3UkZKWmRRRU0rT2dmamh3cENs?=
 =?utf-8?B?Q2JDcHBZc3A3eDJpWnA2Lzl0ZXVpSWJjZ1BMdEtjMXhuVzVUVTBFS2ZNVG9N?=
 =?utf-8?B?bStVZ3ZESzNIMXYyYUk0MWxsTDYrTHRNbW5ndUViNmtOQllkQkp2S0hjRnBt?=
 =?utf-8?B?MjNUMnBRckI5N21ZZzN0UUNCQ0thbFdRWFNDK1M3bVpHa1QrYUxJK1ByaDFW?=
 =?utf-8?B?QkMvM0Q0MVlyNG0wT3MrNldwd2xHcEorMDRONElQNGplbzkwN3dPQjZ0emdj?=
 =?utf-8?B?TWFESlNEOVo4c3d2YnpTNjh6cXJpYlpJNUx5L01hbU9uc09OQ0ZBYlVpSis5?=
 =?utf-8?B?Z3Q4Sjl4TmJXNVFSWGgvWnNEK0tBamlnOWxnc3plTjFBVXVvalpDbytRKzhw?=
 =?utf-8?B?dkxPMXV4Z1dNMnQ0STBLN2VKQ2VBNlhSbWZCL0Zsa2twenVSb0pka0JQTm9x?=
 =?utf-8?B?b1FZUnB1M0FDSitDRHRvb2JQK2E0RTcwMjc2VFkyUFZrNUdSUXo2SEZEWlVE?=
 =?utf-8?B?RHdZRnJRRTZjTmJzbHlmODJITmVHZHJTRjhHSStIQTBDK2hhRDJtRENmUUcy?=
 =?utf-8?B?RUZxNzE5WjJ3RmpXMmNIcEZmeTBrUENUUXMrQ0dTZTR1WjVKWU5OUTR4TytD?=
 =?utf-8?B?d05hc083VTZrd2E2Z25qYzAxMTJzVWdkcUs2cCtVY2RuN2FwVDA2aDJ4UG4r?=
 =?utf-8?B?eVl2OW1LWU5TY0lyYzBxSlY1b3djNWFzd2VHTnZseGFHeWpJaVlLUHRMWEJS?=
 =?utf-8?B?UnIwK2h2Y2kwMitBeTdkQVl2U3dnYnI0bjVkWmJ4M3ZmVWx4aERDTnVlT1Nl?=
 =?utf-8?B?VlJXS1BiMjBEVnRtTUh6ZU9zOGFWMUF4VmtTNjlNdjZmQjhBOWJPb0s3T2dZ?=
 =?utf-8?B?TlBrVWNIaFU4Ylk5RUVvclY1b1l5L2xCUVlHNWMwZnBKS1FmQzYwWU01K0Fv?=
 =?utf-8?B?RDZlbXIrcHRxVzNtYXZ3VGF3M3hJeitzOGRlODhRY3JNaDZiV0hEUmQwVmFX?=
 =?utf-8?B?L2xUWmJ3YzRXUU8rSGFLYmc3bXcwY21HUkRrdlVpcEp2ZnMvQjhDeWRsOUZL?=
 =?utf-8?B?TFhTZW15aVlwYzJtRXlHQVUydTErOVRQNFZHc2g3K2F4U2ZtWm53M3N0TGcr?=
 =?utf-8?B?SmdPL01DOSt5MkUxL2N2bDU3a3J6ZXBQVVBibVlOeGtDVlZNVVdxd0J2SThU?=
 =?utf-8?B?MXZraTY4RUZKeHp2RTdVZVlLa3BMeWRtVi9pNXErOTBsVjJRSlpPNy8vK2Rj?=
 =?utf-8?B?dkhWSDFPSWdscUt3R1RPbjAzSXc5bWpLOWI3eEE4L0s0c1l5KzF3d3N0TklZ?=
 =?utf-8?B?ZTNiSFVmb3Y0N0ZkbDF1dzQ5VmZQVDRsRHloS1ZLanlHdENjaGp0TEdicmFo?=
 =?utf-8?B?Mi8wL3RzUEhxaURQVXc1U2liV1YzQ0ltdUJpM3AwUFhuRDErWTNIbjE2dDE1?=
 =?utf-8?B?eGRoSVNCTitQZVJMOXpxWTZxakZZUmIvazI3M2J5OTYreWN5elhkaFRxS0FR?=
 =?utf-8?B?SnRjeWZqTGR4SUtTZ1gzdTZOZlRoU3ZqaFY5SjdGRTkrSGt4blozakN6M2VC?=
 =?utf-8?B?RGpldi8wYjg0QmZaY3QvNnhqTjdOalNDVG4yZXF6WlRHRWI2cTdNdTRUdnht?=
 =?utf-8?B?UFVldDlvM0d4UXU4akF0a3RsYktzTm9HR3J2N01WeGQ1NEhPSzF6Qm9mWWJw?=
 =?utf-8?B?aXYxZmhQa1RTZUlrTk1PUEl0QXNNdVhzRnFxRzRxSkNHTmppR29mNGdxNnBM?=
 =?utf-8?B?R1FVQ3JkN2YwMkNCak9lVldaazlPZWlOMERpK1QzQ2F2d2k1TlFZbDhxeVlQ?=
 =?utf-8?B?SVNjeEU4eXlCcXdyZmxHM1RieDZuZHJEdXBCMmVocnk5alFzYUNuNU5pYjd5?=
 =?utf-8?B?TWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F7D4871579F5124E91EE752ADC3FD6E7@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ee8619b3-d1d9-49a3-d29b-08de1aee2ffd
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2025 15:32:24.2656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OXuwW6L9thBJoez7VfQRefHUqCTxpXUTgO5OeEbrzsJNDtDZq0Nwsu4HuwvmCOOMfokFuiPbROf8ACWhxuWWeoyD15gc1t9Eac0axE+g4V8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6553
X-Authority-Analysis: v=2.4 cv=MslfKmae c=1 sm=1 tr=0 ts=6908cb0b cx=c_pps
 a=xSzMZOIKDOBgwsc4tMfFrQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=qs0yIW7vINAO60LhjlkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDE0MCBTYWx0ZWRfX/zax7eq5AiVn
 YW8vvVEUbkrdSqU5DH4jp7fEk75d0cZPyXWvoQNcpYZfOW6UFq8xkRCJXOievS41h8P41KTi/cp
 1fPW1VIabfDakGg03dGfqLP/dNVAm4KGCpTczDsciRhzfZ6mXjbXTHtB1QkP9vpLPpsNH+7qbKA
 dIWeHK1apolyHNfBzV5UhB080Xmfi6ZypsdeFFd8pMrj8IFDju5KCL7/tsrzLSycX4BcSLkGy8u
 CLrnInTzWgxOhKFt0Jmntb6mGnTe1kFrMe3VogeUnvfJhM8DtXwFaNLFWqVqWWGA+ZZMBUL8HhO
 5UT69IeD8L23TzRLS8BtPDHAC2MtWtuYbwZzLR1XDcf4dWXc5xA6b8MJmTMeQXIvQoMQxs9DxiB
 6ZF6xyRYEpB8qavYKdkXuOvrh+k0Pg==
X-Proofpoint-GUID: qUzoIP-pot9AvaMUik3fynt-sYyCC3B4
X-Proofpoint-ORIG-GUID: qUzoIP-pot9AvaMUik3fynt-sYyCC3B4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_02,2025-11-03_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gT2N0IDMxLCAyMDI1LCBhdCA0OjUy4oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+IEhtbSwgSSB3b3VsZCBzYXkgSSdtIGZs
YXQgb3V0IG9wcG9zZWQgdG8gZ2VuZXJpYyBob29rcyBvZiB0aGF0IG5hdHVyZS4gIEZvcg0KPiBh
bnl0aGluZyB0aGF0IF9uZWVkc18gdG8gYmUgbW9kaWZpZWQgd2l0aCBJUlFzIGRpc2FibGVkLCB0
aGUgb3JkZXJpbmcgd2lsbCBtYXR0ZXINCj4gZ3JlYXRseS4gIEUuZy4gd2UgYWxyZWFkeSBoYXZl
IGt2bV94ODZfb3BzLnN5bmNfcGlyX3RvX2lycigpLCBhbmQgdGhhdCBfbXVzdF8gcnVuDQo+IGJl
Zm9yZSBrdm1fdmNwdV9leGl0X3JlcXVlc3QoKSBpZiBpdCB0cmlnZ2VycyBhIGxhdGUgcmVxdWVz
dC4NCj4gDQo+IEFuZCBJIGFsc28gd2FudCB0byBwdXNoIGZvciBhcyBtdWNoIHN0dWZmIGFzIHBv
c3NpYmxlIHRvIGJlIGhhbmRsZWQgaW4gY29tbW9uIHg4NiwNCj4gaS5lLiBJIHdhbnQgdG8gYWN0
aXZlbHkgZW5jb3VyYWdlIGxhbmRpbmcgdGhpbmdzIGxpa2UgUEtVIGFuZCBDRVQgc3VwcG9ydCBp
bg0KPiBjb21tb24geDg2IGluc3RlYWQgb2YgaW1wbGVtZW50aW5nIHN1cHBvcnQgaW4gb25lIHZl
bmRvciBhbmQgdGhlbiBoYXZpbmcgdG8gY2h1cm4NCj4gYSBwaWxlIG9mIGNvZGUgdG8gbGF0ZXIg
bW92ZSBpdCB0bw0KDQpGYWlyLCBhZ3JlZWQgaGF2aW5nIHRoaW5ncyBjb21tb24taXplZCBoZWxw
cyBldmVyeW9uZQ0KDQo+IEFsbCB0aGF0IHNhaWQsIEknbSBub3QgdG90YWxseSBvcHBvc2VkIHRv
IHNoYXZpbmcgY3ljbGVzLiAgTm93IHRoYXQgQHJ1bl9mbGFncw0KPiBpcyBhIHRoaW5nLCBpdCdz
IGFjdHVhbGx5IHRyaXZpYWxseSBlYXN5IHRvIG9wdGltaXplIHRoZSBDUjMvQ1I0IGNoZWNrcyAo
ZmFtb3VzDQo+IGxhc3Qgd29yZHMpOg0KDQpBIGN5Y2xlIHNhdmVkIGlzIGEgY3ljbGUgZWFybmVk
LCBwZXJoYXBzPyA6KQ0KDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1f
aG9zdC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPiBpbmRleCA0ODU5OGQw
MTdkNmYuLjVjYzFmMDE2OGI4YSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20v
a3ZtX2hvc3QuaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+IEBA
IC0xNzA5LDYgKzE3MDksNyBAQCBlbnVtIGt2bV94ODZfcnVuX2ZsYWdzIHsNCj4gICAgICAgIEtW
TV9SVU5fRk9SQ0VfSU1NRURJQVRFX0VYSVQgICAgPSBCSVQoMCksDQo+ICAgICAgICBLVk1fUlVO
X0xPQURfR1VFU1RfRFI2ICAgICAgICAgID0gQklUKDEpLA0KPiAgICAgICAgS1ZNX1JVTl9MT0FE
X0RFQlVHQ1RMICAgICAgICAgICA9IEJJVCgyKSwNCj4gKyAgICAgICBLVk1fUlVOX0lTX0ZJUlNU
X0lURVJBVElPTiAgICAgID0gQklUKDMpLA0KPiB9Ow0KDQpJIGxpa2UgdGhpcyBhcHByb2FjaCwg
YXMgaXQgbWFrZXMgdGhlIGNvZGUgZWFzaWVyIHRvIGdyb2sgd2hhdCB3ZSB3YW50IGFuZCB3aGVu
DQo+IA0KPiBzdHJ1Y3Qga3ZtX3g4Nl9vcHMgew0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3Zt
L3ZteC92bXguYyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gaW5kZXggNTVkNjM3Y2VhODRh
Li4zZGViMjBiOGQwYzUgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4g
KysrIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiBAQCAtNzQzOSwyMiArNzQzOSwyOCBAQCBm
YXN0cGF0aF90IHZteF92Y3B1X3J1bihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHU2NCBydW5fZmxh
Z3MpDQo+ICAgICAgICAgICAgICAgIHZteF9yZWxvYWRfZ3Vlc3RfZGVidWdjdGwodmNwdSk7DQo+
IA0KPiAgICAgICAgLyoNCj4gLSAgICAgICAgKiBSZWZyZXNoIHZtY3MuSE9TVF9DUjMgaWYgbmVj
ZXNzYXJ5LiAgVGhpcyBtdXN0IGJlIGRvbmUgaW1tZWRpYXRlbHkNCj4gLSAgICAgICAgKiBwcmlv
ciB0byBWTS1FbnRlciwgYXMgdGhlIGtlcm5lbCBtYXkgbG9hZCBhIG5ldyBBU0lEIChQQ0lEKSBh
bnkgdGltZQ0KPiAtICAgICAgICAqIGl0IHN3aXRjaGVzIGJhY2sgdG8gdGhlIGN1cnJlbnQtPm1t
LCB3aGljaCBjYW4gb2NjdXIgaW4gS1ZNIGNvbnRleHQNCj4gLSAgICAgICAgKiB3aGVuIHN3aXRj
aGluZyB0byBhIHRlbXBvcmFyeSBtbSB0byBwYXRjaCBrZXJuZWwgY29kZSwgZS5nLiBpZiBLVk0N
Cj4gLSAgICAgICAgKiB0b2dnbGVzIGEgc3RhdGljIGtleSB3aGlsZSBoYW5kbGluZyBhIFZNLUV4
aXQuDQo+ICsgICAgICAgICogUmVmcmVzaCB2bWNzLkhPU1RfQ1IzIGlmIG5lY2Vzc2FyeS4gIFRo
aXMgbXVzdCBiZSBkb25lIGFmdGVyIElSUXMNCj4gKyAgICAgICAgKiBhcmUgZGlzYWJsZWQsIGku
ZS4gbm90IHdoZW4gcHJlcGFyaW5nIHRvIHN3aXRjaCB0byB0aGUgZ3Vlc3QsIGFzIHRoZQ0KPiAr
ICAgICAgICAqIHRoZSBrZXJuZWwgbWF5IGxvYWQgYSBuZXcgQVNJRCAoUENJRCkgYW55IHRpbWUg
aXQgc3dpdGNoZXMgYmFjayB0bw0KPiArICAgICAgICAqIHRoZSBjdXJyZW50LT5tbSwgd2hpY2gg
Y2FuIG9jY3VyIGluIEtWTSBjb250ZXh0IHdoZW4gc3dpdGNoaW5nIHRvIGENCj4gKyAgICAgICAg
KiB0ZW1wb3JhcnkgbW0gdG8gcGF0Y2gga2VybmVsIGNvZGUsIGUuZy4gaWYgS1ZNIHRvZ2dsZXMg
YSBzdGF0aWMga2V5DQo+ICsgICAgICAgICogd2hpbGUgaGFuZGxpbmcgYSBWTS1FeGl0Lg0KPiAr
ICAgICAgICAqDQo+ICsgICAgICAgICogUmVmcmVzaCBob3N0IENSMyBhbmQgQ1I0IG9ubHkgb24g
dGhlIGZpcnN0IGl0ZXJhdGlvbiBvZiB0aGUgaW5uZXINCj4gKyAgICAgICAgKiBsb29wLCBhcyBt
b2RpZnlpbmcgQ1IzIG9yIENSNCBmcm9tIE5NSSBjb250ZXh0IGlzIG5vdCBhbGxvd2VkLg0KPiAg
ICAgICAgICovDQo+IC0gICAgICAgY3IzID0gX19nZXRfY3VycmVudF9jcjNfZmFzdCgpOw0KPiAt
ICAgICAgIGlmICh1bmxpa2VseShjcjMgIT0gdm14LT5sb2FkZWRfdm1jcy0+aG9zdF9zdGF0ZS5j
cjMpKSB7DQo+IC0gICAgICAgICAgICAgICB2bWNzX3dyaXRlbChIT1NUX0NSMywgY3IzKTsNCj4g
LSAgICAgICAgICAgICAgIHZteC0+bG9hZGVkX3ZtY3MtPmhvc3Rfc3RhdGUuY3IzID0gY3IzOw0K
PiAtICAgICAgIH0NCj4gKyAgICAgICBpZiAocnVuX2ZsYWdzICYgS1ZNX1JVTl9JU19GSVJTVF9J
VEVSQVRJT04pIHsNCj4gKyAgICAgICAgICAgICAgIGNyMyA9IF9fZ2V0X2N1cnJlbnRfY3IzX2Zh
c3QoKTsNCj4gKyAgICAgICAgICAgICAgIGlmICh1bmxpa2VseShjcjMgIT0gdm14LT5sb2FkZWRf
dm1jcy0+aG9zdF9zdGF0ZS5jcjMpKSB7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIHZtY3Nf
d3JpdGVsKEhPU1RfQ1IzLCBjcjMpOw0KPiArICAgICAgICAgICAgICAgICAgICAgICB2bXgtPmxv
YWRlZF92bWNzLT5ob3N0X3N0YXRlLmNyMyA9IGNyMzsNCj4gKyAgICAgICAgICAgICAgIH0NCj4g
DQo+IC0gICAgICAgY3I0ID0gY3I0X3JlYWRfc2hhZG93KCk7DQo+IC0gICAgICAgaWYgKHVubGlr
ZWx5KGNyNCAhPSB2bXgtPmxvYWRlZF92bWNzLT5ob3N0X3N0YXRlLmNyNCkpIHsNCj4gLSAgICAg
ICAgICAgICAgIHZtY3Nfd3JpdGVsKEhPU1RfQ1I0LCBjcjQpOw0KPiAtICAgICAgICAgICAgICAg
dm14LT5sb2FkZWRfdm1jcy0+aG9zdF9zdGF0ZS5jcjQgPSBjcjQ7DQo+ICsgICAgICAgICAgICAg
ICBjcjQgPSBjcjRfcmVhZF9zaGFkb3coKTsNCj4gKyAgICAgICAgICAgICAgIGlmICh1bmxpa2Vs
eShjcjQgIT0gdm14LT5sb2FkZWRfdm1jcy0+aG9zdF9zdGF0ZS5jcjQpKSB7DQo+ICsgICAgICAg
ICAgICAgICAgICAgICAgIHZtY3Nfd3JpdGVsKEhPU1RfQ1I0LCBjcjQpOw0KPiArICAgICAgICAg
ICAgICAgICAgICAgICB2bXgtPmxvYWRlZF92bWNzLT5ob3N0X3N0YXRlLmNyNCA9IGNyNDsNCj4g
KyAgICAgICAgICAgICAgIH0NCj4gICAgICAgIH0NCj4gDQo+ICAgICAgICAvKiBXaGVuIHNpbmds
ZS1zdGVwcGluZyBvdmVyIFNUSSBhbmQgTU9WIFNTLCB3ZSBtdXN0IGNsZWFyIHRoZQ0KPiBkaWZm
IC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQo+IGluZGV4
IDY5MjQwMDZmMDc5Ni4uYmZmMDhmNThjMjlhIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0v
eDg2LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQo+IEBAIC0xMTI4Niw3ICsxMTI4Niw3
IEBAIHN0YXRpYyBpbnQgdmNwdV9lbnRlcl9ndWVzdChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+
ICAgICAgICAgICAgICAgIGdvdG8gY2FuY2VsX2luamVjdGlvbjsNCj4gICAgICAgIH0NCj4gDQo+
IC0gICAgICAgcnVuX2ZsYWdzID0gMDsNCj4gKyAgICAgICBydW5fZmxhZ3MgPSBLVk1fUlVOX0lT
X0ZJUlNUX0lURVJBVElPTjsNCj4gICAgICAgIGlmIChyZXFfaW1tZWRpYXRlX2V4aXQpIHsNCj4g
ICAgICAgICAgICAgICAgcnVuX2ZsYWdzIHw9IEtWTV9SVU5fRk9SQ0VfSU1NRURJQVRFX0VYSVQ7
DQo+ICAgICAgICAgICAgICAgIGt2bV9tYWtlX3JlcXVlc3QoS1ZNX1JFUV9FVkVOVCwgdmNwdSk7
DQo+IA0KDQo=

