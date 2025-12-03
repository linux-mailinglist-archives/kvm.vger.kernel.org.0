Return-Path: <kvm+bounces-65192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 39A65C9E144
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 08:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86E053A95A6
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 07:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD1E329D260;
	Wed,  3 Dec 2025 07:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="eZ4idwbj";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="BRdcPnWv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0645221555;
	Wed,  3 Dec 2025 07:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764747986; cv=fail; b=NP8AhHWx6aa3LXbqU6BFfRAz+RJ7xXPLFKqfH5Zgt8z+hK+ZYypNu6VkbHIKmx35wVxrjyJIngRTH8OqyuCY88kI+gnqySwncq3ddD2lPIkaufXqXLFkIpCjn15KzmYdaRsTZN4Tv97YoOK6IvssWeWcFamhutVnTY/W7L7NDiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764747986; c=relaxed/simple;
	bh=co+LpUZab3KOVxeigdFM2GpXeVR2NOaMEpi5QZNeArY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jJlcpiG9/BMr00uwYkKaTSfz0Nz2E6QIhIOyWdjC2ny0Xvi8Dfa9QaSnirPk4cJQUfWgaqNpTLvY8YIC5XF46YBtgGoaTqRoMX90mqff+jkOgRskRIz/RWnjaE03Bv+njkdp9jibyBwGlS9UUgSFh3ERTPSWeOqFY5d/Ww06jkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=eZ4idwbj; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=BRdcPnWv; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B34qvLj2598411;
	Tue, 2 Dec 2025 23:45:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=co+LpUZab3KOVxeigdFM2GpXeVR2NOaMEpi5QZNeA
	rY=; b=eZ4idwbjQFG89yWlBCurlw/1cX+GIBmFdrmC+INMNnFhjo3YgiAwXmklU
	pNuc+PVOz7kWvHyGgHvjrIJ6PybrT76V8Jnvhai/Npr1xFZP8Yyt5yQUdZQxL4HL
	4nUfrCBs/Tt/3GKf7eAXXQ/WkqhIOqlr9SWPAWx084oHihGnyNV/lTwPovuHUuci
	Gk/tQjLK4JPQeI91sB9X6sJbRP+hLmaCLgMxm9ZGAFXIwCzNGaUdGwBa9siNiL8X
	b2q4U0DPwyAb9+EJbN55kKbO9NwF0pcL/Oq56N4Zm7xahPsT60TI/0DRh2KysKJl
	UWXi9CWeJOj5d9xeuipM0IcBj2Brg==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11022083.outbound.protection.outlook.com [40.93.195.83])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4at4909j5b-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 02 Dec 2025 23:45:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=paR53fHC50v2NMfhoMnBxcGzZDDSCcOsZuseAUCO9vDAVOrytUsmKjUAHr+1TV+L/aiD8YxjUdZVLre+prjNXvO2DGyWlQ9rXF3z3xNFWC7oF3FnwO0NQ6wJMjqYbmITB11xMT0buW4Tqwsw5nOl8d/nOqLVp0ErthdyS4m9dD6qW1MW46yfOGZQ6ohEsUvUUUn/VUkmvaf0vHzwz1eOfpDP424H3bwnxRBOKNQ8RABiXSe55e7oRi65r406HvFCjwZQGHO2ugciZwdnPmE5KGAzgWXrNPIUIouuGNJYBuOHHYyjmBMvVGDpGJU1Gyheu0PX5PwOJWAB327WoCKR4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=co+LpUZab3KOVxeigdFM2GpXeVR2NOaMEpi5QZNeArY=;
 b=TkuB4iVaj667XYyZwSOpMh7P8HHW6Qj8cnBi2+aOs2yu8lB4b6qbMOXQ204jGnP3yUGz/cWF4UdP2g2azpE+PxpNX/80N2cs+VGsIz7nn4ucBOfAYnMwlaNMnNxMcqh5oYAQPfJ3WVyo1eKdXw0Vd8d22ADnihctshWbJcHPA18/1yndAqL2WtRKLWyjh9Dh3fVieteOwRikvovP4udqrv5RvC/oPpKsO2RFQwi7Sk3+Chp0Hf3OPqQiAFLepwGPMX/5uB3Hp5nJgb/LiMCCc9ZlahIfSzxLcM71/0L+UPn6pR7xQ8HI0ZjaltW642PdN9iWOcqdrkBOJcALlgz3Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=co+LpUZab3KOVxeigdFM2GpXeVR2NOaMEpi5QZNeArY=;
 b=BRdcPnWvtUBkrKS2SZQ2gxARGGgiob20oBlm2/Z6o6SaMf6oH0k88J4FJ+P/yQH2uyMuVd3u8tu3syEPGwh2Syzi9gJxveawcihUN4CsVkX7+kCLalWeoFG+pvu3hzQuIxTSdUnR8T2G5JABTyx5rRUqLoxqvGiM5lDw2dC2ox1kRYegDCKHaoOcGbThUkEn1LpH3AxlzMmqTqZOW5F2FZRD+ec/XbNc2cxBtdDpmzPNaLVW3Mby2/Kz8lcfkwJXg89l9nj3rMQQ1SeA97ADF4t9wkN99hOY3Dhgnp9FOC/c7L3qMZe01Zu3uZFGxpV/NiFutPdjulxiKj/IBMBdug==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CO6PR02MB8708.namprd02.prod.outlook.com (2603:10b6:303:137::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Wed, 3 Dec
 2025 07:45:34 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b%4]) with mapi id 15.20.9388.003; Wed, 3 Dec 2025
 07:45:34 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jon
 Kohler <jon@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Topic: [PATCH v3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Index:
 AQHcXjYohMZ/JxHmj0OqVx2H9OyjkbUOG28AgAA+6QCAAAkXAIAAJLGAgAACdYCAAAyTgIAA/fuA
Date: Wed, 3 Dec 2025 07:45:34 +0000
Message-ID: <994FA1C8-7AC2-4FD2-958D-373C0AA1553A@nutanix.com>
References: <20251125180557.2022311-1-khushit.shah@nutanix.com>
 <6353f43f3493b436064068e6a7f55543a2cd7ae1.camel@infradead.org>
 <A922DCC2-4CB4-4DE8-82FA-95B502B3FCD4@nutanix.com>
 <118998075677b696104dcbbcda8d51ab7f1ffdfd.camel@infradead.org>
 <aS8I6T3WtM1pvPNl@google.com>
 <68ad817529c6661085ff0524472933ba9f69fd47.camel@infradead.org>
 <aS8Vhb66UViQmY_Q@google.com>
In-Reply-To: <aS8Vhb66UViQmY_Q@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CO6PR02MB8708:EE_
x-ms-office365-filtering-correlation-id: 3c057338-4bb9-4d00-87e4-08de323ff13a
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?bmp4NWsvcmt2dmp5UlFjbWs5Z1hqdHEvaG8rV3ZYc0RJTVQvM01QcnhlQ1JE?=
 =?utf-8?B?TDJFanBuRjBmK29zdy9OcW9DeW9xTVVzT1hnQUl0bEU3STlTajRlaEhoeXk5?=
 =?utf-8?B?R3A3MkhIdnRIN2pJMHhlOGo1aStxMHJpSVBvWk1DeUlvYWZZb2d4Vzk4ZDBU?=
 =?utf-8?B?ME44a0lxaU1PN0JteWdSZ3BqazgyZkZDbG5IRDdwT1lkYW42S0xQTDA5aGFG?=
 =?utf-8?B?WHZIKzdvanRWSHUyUHVhcHFQQWQzUzBxb2JUNEU3WHozU29CdFUzMmF2Wlda?=
 =?utf-8?B?aXdQM0ZqT2svYlI1SHRrc3ROTkpjckxJZmNpTUhEZlFJcC9SYXZWdjJTOUJC?=
 =?utf-8?B?UHpyNjJSdHc0ZVZ1bVdMaU90WDlScGNZa0l0Wk1qd0x2MDZONldJYi9QR0J5?=
 =?utf-8?B?enhONzFUMUloN0VvTXpvVzcrNXo4WTB5TVZoZk5qQWFDRGdFN3QrWlM1Ykdr?=
 =?utf-8?B?S2oyM0tENEtaQ0haSVJ2V1NpbmRGcGtlbmpHL2NkSDBWYnBlQkJSd3owbkZh?=
 =?utf-8?B?UmxCSVg2cVpHSWRlT3crTTc2anhzTDdaREFsY1JQRnJnNTd1eTlsS3JONnZ4?=
 =?utf-8?B?U2I5MTBzak9jY2RkdXA5Q1lad3NvK2Rta296R1k4QlloSkFkSXVIQW0zeHdy?=
 =?utf-8?B?ZU14MlduTzhvVWp4MHRpc3pnSmxJV1BiZGJEM2FIcjhJaHdvLzRzWmR5OWc3?=
 =?utf-8?B?dVRaVnhZMlFDTk5UTEpPdnh3THVjVWZVODZiU0FleEMybkk2UlpoeGlzVzJn?=
 =?utf-8?B?TnltelVmVTdDQUJwSEo4cHBxMkVWcU9JQjVMeitpVFBoOHZCa09TUEloWXlW?=
 =?utf-8?B?VGVYSjBEY1FNa3Rjdm5Jd3dzRndnY0RVOWNUN3NFQU8xUW9VOVJGS2g0cFd1?=
 =?utf-8?B?NVVlNHNhQXNCb3F4Zk92TklGNjNNeFkyVDdhUHpIdSt0WkZZcHNOR05qdnJz?=
 =?utf-8?B?b0RMbFZDeDVoR2ZlakNzOGlpWG9BUEVSTDBIbHdvWTdjYm5pTkZzU0YyTUE0?=
 =?utf-8?B?c3kranBXcEpPUGt6RURjckswQ29XME0rcld3T3FLbmsvdTIrUDN6dEpWWkhL?=
 =?utf-8?B?SmhTTkgzL2tvbUtsRDFKVENZcCsxV0RhSkJyajMyZlBzTkNHaE5MUFpaa0tB?=
 =?utf-8?B?SWxFandxVXF6ZHp2TTd5aWNIdDZvWmM1bWg2aHFMY24rSEFSMUs3anFOcW02?=
 =?utf-8?B?UkczYkJlRkNSL0xPSTlBK0V6eW1QRVhDVjNUVDFjRjl1cmJUcnJYS1VBYnVt?=
 =?utf-8?B?djlXTDk3UHd1TWZTT2M1alJiYTMrbXpWRGgxQzJqcmJHdXp5WFNEYk51Ym5R?=
 =?utf-8?B?NVFLSnRyOUZ5dnVjNFZHeVQvNElNYmptdXVrdTZPVXF6aU5VOTZ2NWdmSEdJ?=
 =?utf-8?B?RTNRYXAwNlljVlZPeEZWcnRkbHNmckcvaG1YRXZsS05hU3lGM0cxU2ltbjNF?=
 =?utf-8?B?UE96NXhMZHhIbEtISnhoYllSTzBncDVTL005Zmd6RnB1bk1MRmkwaWRPWTRS?=
 =?utf-8?B?WFV2bjlOeVI0b0p5WjR1V0dZUGxwUldYRDdhN21SWENtMXFSRFNxbVg1WWhZ?=
 =?utf-8?B?cVhwVUVob0N3cjBCT3lrN0lNekU5NE1RSE44YmlWMjNBcjErQ3dDRlo1Vlk3?=
 =?utf-8?B?UkpSK09zaTcrL1JVenpvZURFT0lEa3Flbi9nak1sZ2w5RG1NNmUzZ3pjbWRk?=
 =?utf-8?B?ZGwxTVVGbWNJeldpUW13L3FUdmlPOG5ZRDlnS0JBY1hwZDVTanZmckJBNGNr?=
 =?utf-8?B?NTJkUXZSZXJpMzZGMFc3RUJGTTdGamxrMVIzUEJ4bDAzNkNmb0E5V0JxelpW?=
 =?utf-8?B?V0lCNzhBTm1LdDk3L1RtSnRuako2eTMvSTJ5UngvOFlEQjJBR1RuL1doUHRR?=
 =?utf-8?B?WDNGSjF4WkhNMDV4NWd5UU15VFJQNWFJbjhqc3FNZ0VqdGs4QnlVOHF0WkdK?=
 =?utf-8?B?aGV3aCtKN0NlcXhzaFRaN2VpaW9YL2IwM3hoOHdraDgyelA1dWNwYkF2Szlv?=
 =?utf-8?B?VW1VcDFTUmlRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RVRxdGtYbkpZU3NQQ2JieHoyNVRSRys0WC9Da1dianFReFBYSjdYMWFqdFB3?=
 =?utf-8?B?Yk9iUVhMRG1qdGRiVjkxNFVQMGhvcTljRm9jaEphbGxVL1pha3JQczFzSy94?=
 =?utf-8?B?OE9kVkhXc2sreGZWa1ZwT1hNM1VmRjlaU3FVTm9MWHo1QWJjUnNRc3M3TTdM?=
 =?utf-8?B?NVJCVWp0ODRTWHM5MTlhVmVPejI1UnpMVVdxbUNEeEpvd09iZENTN3YxTjAx?=
 =?utf-8?B?S2c5UEsrTzFxdGdWanU1M3BWY3VTbEp0WmVBWmhXVmsyVmFSZVNzbGhST0pY?=
 =?utf-8?B?UFdIM1BsM1JnNnlQYm02QXBOcVBuMURnUStXNFljZ2JyN0czQlp3UGs3OUFW?=
 =?utf-8?B?Vlc2NkNpdFN2Umg4S3NRWmJhL1JMSlVKTDlnaG54eFVhUW1LRzRQTy9aaFcy?=
 =?utf-8?B?S3NHL1dRaExqQWhDem5xSmdMT0FNZG45VTV4dTY1QnVSZjZ6ekR2UnJTeVhr?=
 =?utf-8?B?WE5QNVhITEZQN3ZmeTlLVW9vZFE5Tlk5dXZxZnVKYXl0Vmx3d1VHZ0FaVyt2?=
 =?utf-8?B?bVhJbFZWNTFnWlVMMldQL2hXS3dTUkp6WXBsYjhZZFFKUlRUMDMyTVlrMnBP?=
 =?utf-8?B?QjgrUGhZenJ1UGFhZnMzeVF6YkUxdWdFeTNGc0NnRFROVC9JbG5ONjJYMmVN?=
 =?utf-8?B?N1RLVHptQy9qeTR1cFlWekJaY3BTUW51YmE4SVRHSWJLenJhRFR5dGdBdjdI?=
 =?utf-8?B?ZTl3RDEvc0dsWk11L1IxUTJONVlJRy9Wek1BK3RmdE1QM2JXcHdiVmxNbm85?=
 =?utf-8?B?QUxQamlCWSt5K3IxdUhyOTB4MGJjaGViZTl1SzFUdjBBN2VzRElncjFxa0lp?=
 =?utf-8?B?VDdZdlhjMWN0Z0RGNGJhSEtaSGpTVnV5SmhsMENWa2d3M21hMVJTemRNZnZJ?=
 =?utf-8?B?UVBIT296T050NVhoYW1JSHFLdHh4YjJxTnV4Z1JFYnZnZDJVeGJWSWtQSk1H?=
 =?utf-8?B?ais3eEgxekp2WmZ5Z1RTWkpyMFE4bDlyR0tDbUtna29tQ2g1WlZBcGFybU1o?=
 =?utf-8?B?TmFNQXNseVNSMndKK2dGcVNNUGxUeFFXS2lDbStkZXkxZWlFSE12YUZLM2J4?=
 =?utf-8?B?S1AzeVlRREU4TUo1dWdVdklIbTM2RzRpRW1ZUzN0ZzhqUWdCNG5Fc0NKQk5i?=
 =?utf-8?B?aU5jWDB6Z3hOSE54enErb2s0cFc5eUdZV2Q4dDBveVNETzVRb3NnYUVxaHN6?=
 =?utf-8?B?RFBTSlV4MnRsUVlMQ0xBVmlBQmpHL1BwaTQ1OWl3UVpVRUNIVENsWUZSQXlX?=
 =?utf-8?B?ZWtKUEltdWZ2ODlVN2N4aEVyZThSdjJGSEF5Sm9lQ0NOTzQ0ck9ZQjVRSEMr?=
 =?utf-8?B?V29hbjZyZWFZcm1hMXNpTTBYWkg0STUrbitkYnpSaUx0TFArUzBmZFAwQkZ1?=
 =?utf-8?B?ZUlCdmJ4Vi9oWmZtMXU2c2F1WkJmUUdxTTZZekI0UTR0NU5iQlZjQk5CN3Q2?=
 =?utf-8?B?a1Q3Q1JhaFpxTThUUXRjcEp1WXZaV09lbGtBWE44SWFHVXBPK0ZCcTgrUzJN?=
 =?utf-8?B?NU16Y3pwUjFrWE00cU56bDR0K1REZ2k5RjlnUTVCMVhPdGN6RVpLRmYveEVn?=
 =?utf-8?B?Q1NsY3FZZm42NVgxNURRUDd0MjZFNThIVDF6eWZNeWRFWkxpL1NaanRER1pS?=
 =?utf-8?B?VlB0SmNCZnlmR1JpelVkcEF0YkhYMzdMeWw5SEo3Q2JxVGxxSlBLOFFUUXQ1?=
 =?utf-8?B?ejltemJoSklIaFJoUHZhRzdINElBTGlrZ0wwaDU3M2xHRXFWTStPYlk4RkZV?=
 =?utf-8?B?NVVpdnovOFhhcVJUazBTa2VHaHNXTGZnWkpHMVdXYnpPZFVwU3hmODFaUEsz?=
 =?utf-8?B?Rnc2Vmd2TUhCRi9DT2M0ZWYxcm9UMjRvWlFsUGpFNGhPU3I4SGx0Zi9iWXVs?=
 =?utf-8?B?aVJiLzF0QWZMc1p3cDgxUDRZUG9OTml3OUcyZUhjaTVCRDVpWDVvcm1MZFJU?=
 =?utf-8?B?aU4xb1IvK3pKc2VkTzJJMUo0RnNMdzhZR3dpUE13VkMyWGc0L3UyU3Q0VVVI?=
 =?utf-8?B?dm1VbVhlVFpOM2JEbGlndVZlNkNxanc2RDRVcmxYREZuVTNIN3JCREcvcHQw?=
 =?utf-8?B?dFhhVzNaZlFCMjFxRzFlaDJXR0ovZExsL1dYZVZraUxYUGs2MmlLRTJBbGNx?=
 =?utf-8?B?aThrSjdRUzlVK014SUNBak5SVUVpOFFYaG1RbnlVWWNUUXhRS3ZFODcrT045?=
 =?utf-8?B?MVZYL0I2aXUrcnk3OEc2OGNaR1RzZGNmUEpFL2h5T3hQb1IzVnpxV21GRzV6?=
 =?utf-8?B?RWdGU0hPUENNKzYvMGpIbjNlR2ZBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4FFC420F22E4D143959B553FBF9F4F2F@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c057338-4bb9-4d00-87e4-08de323ff13a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2025 07:45:34.4182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZO3ngLEJjxISliN0UJXt0EPEXnlXqYpKtFXwU4XJiIWpQ+h+jGRZ+WRciv1UM2qP3xpC7/jM5VTiceKmOtRBtek4sy5DV9ncPWdKXZv5WQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB8708
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAzMDA1OSBTYWx0ZWRfXyUnQMMKprcFi
 0zESq8GVy3YdRFAq9FIBKbvyYYiSPXp1IQzAq1P7RMzQwttPLhU7+ZgawAFUMNXxKHMan6uAg0t
 0uVFDAogBy7I3NU0JhpwuwP+PQ4cAbTo+F9JI4fDXglHfVUthyaR1wRIF0qNGK9AYtj6Wi09hZw
 nd7IzLFMMOtzxa/Vh6BA3QAz+ZcDl2koc8I59l/UjGegLw+fbG+WEBuzLMzREPVMqMedoFk76CM
 j/GnwqWbAx1acDJvYl79kEMPwrJUk0HHNBDu9GNm50EyHylXv63+6MBwyx/mToTWMzFHYiB77md
 09CLh9COPiBheCt3vWBTGOEN/gUBfwrbvzGLJbwUS41iJWPntRkglBV60fvVl/LQxNpZpjX3HAQ
 yOuNLleUJdPjxad/retb/9kPb4kEVA==
X-Proofpoint-GUID: DaPa9jOvWHEwDhqeMDx-8jQvk5Euh8Gu
X-Authority-Analysis: v=2.4 cv=Gu1PO01C c=1 sm=1 tr=0 ts=692feaa1 cx=c_pps
 a=qXrkyhrtrlo5bn8cMY6OCA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GaQpPoNlAAAA:8 a=64Cc0HZtAAAA:8 a=1XWaLZrsAAAA:8 a=K75ulotX1rxnJcC7HaIA:9
 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10 a=xF5q_uoM5gZT5J3czcBi:22
X-Proofpoint-ORIG-GUID: DaPa9jOvWHEwDhqeMDx-8jQvk5Euh8Gu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-01_01,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMiBEZWMgMjAyNSwgYXQgMTA6MDbigK9QTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gKyBpZiAoY2FwLT5hcmdzWzBdICYgS1ZN
X1gyQVBJQ19FTkFCTEVfU1VQUFJFU1NfRU9JX0JST0FEQ0FTVCkNCj4gKyBrdm0tPmFyY2guc3Vw
cHJlc3NfZW9pX2Jyb2FkY2FzdCA9IEtWTV9TVVBQUkVTU19FT0lfRU5BQkxFRDsNCj4gKyBpZiAo
Y2FwLT5hcmdzWzBdICYgS1ZNX1gyQVBJQ19ESVNBQkxFX1NVUFBSRVNTX0VPSV9CUk9BRENBU1Qp
DQo+ICsga3ZtLT5hcmNoLnN1cHByZXNzX2VvaV9icm9hZGNhc3QgPSBLVk1fU1VQUFJFU1NfRU9J
X0RJU0FCTEVEOw0KDQpTaG91bGQgdGhpcyBhbHNvIHVwZGF0ZSBleGlzdGluZyB2Q1BVcyBieSBj
YWxsaW5nIGt2bV9hcGljX3NldF92ZXJzaW9uKCkgDQpmb3IgYWxsIGFscmVhZHktY3JlYXRlZCB2
Q1BVcz8gb3IgaXMgdGhlIGludGVudCB0aGF0IHVzZXJzcGFjZSBtdXN0IHNldCB0aGVzZSBmbGFn
cw0KYmVmb3JlIGFueSB2Q1BVcyBhcmUgY3JlYXRlZD8gSWYgc28sIHNob3VsZCB0aGlzIHdhcm4g
aWYgY2FsbGVkIGFmdGVyIHZjcHVzIGFyZSANCmNyZWF0ZWQ/DQoNClFFTVUgY3VycmVudGx5IGNy
ZWF0ZXMgdkNQVXMgYmVmb3JlIGluaXRpYWxpemluZyB0aGUgSS9PIEFQSUMsIHNvIGRlY2lkaW5n
IEtWTeKAmXMNClNFT0lCIGJlaGF2aW9yIGF0IHZDUFUgaW5pdGlhbGl6YXRpb24gdGltZSBpcyBq
dXN0IGEgYml0IGF3a3dhcmQuIEl04oCZcyBtYW5hZ2VhYmxlDQplaXRoZXIgd2F5LCBJIGp1c3Qg
d2FudCB0byBjb25maXJtIHRoZSB1QVBJIHNlbWFudGljcy4NCg0KRm9yIHJlZmVyZW5jZSwgdGhl
IGluaXRpYWwgUUVNVSBzaWRlIHBhdGNoOg0KaHR0cHM6Ly9wYXRjaGV3Lm9yZy9RRU1VLzIwMjUx
MTI2MDkzNzQyLjIxMTA0ODMtMS1raHVzaGl0LnNoYWhAbnV0YW5peC5jb20v

