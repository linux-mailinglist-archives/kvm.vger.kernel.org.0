Return-Path: <kvm+bounces-64694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E2DCAC8B0EB
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:50:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EE91D4E792C
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:49:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CDE633EAE7;
	Wed, 26 Nov 2025 16:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="QZiMHvIt";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="McrhnjZ2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7BF33F391;
	Wed, 26 Nov 2025 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764175764; cv=fail; b=IV6GBcn5g56MD0UI6tOxjVEcTRQK1baN2047s/DWjM12VtrG+wFnd0MyeKoe3Dkn3XbpCXvSym2cv6QZC/HBh3oITv0jP5KVBAZtvluooIJkyU1LsRtT29ktQDjrI6frOoc6dvBAvuY3vBRva1td48vswbT0mHzv+VoBLprW9Oc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764175764; c=relaxed/simple;
	bh=QW1Nl2jQL6PPVa1Ak5o/jhieVBsBrie3Jyu+VdCsQBw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JOgCeTlnAy94OBERoq9C5ygbfC+cT916asSO5SEE8GR0rDlHFga1s4SR8KTw5Z0rWR/uQWT1qH/TSaWGR1X2f+MMJ6fDKtNXpB1Pja+YOXODZNF4KsxC02bEJRG7WbWYrntVYLVsOUV0r8xwYWRGkUf0I3CHa6kdkMAt8aQIvVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=QZiMHvIt; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=McrhnjZ2; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQEr9WJ1608995;
	Wed, 26 Nov 2025 08:49:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=QW1Nl2jQL6PPVa1Ak5o/jhieVBsBrie3Jyu+VdCsQ
	Bw=; b=QZiMHvItGfBp/tgsQPg7WzQfzKanEMJVJSpT+5/4be8CiUg7DcDwuidGF
	qNinrNCRixFPDBWZeyGYqM+aawgltAdWGJRP/hr4XudTC3PmpjN3NTpV6AN6kKvW
	2efc8c3YoIjEDIARVftBkNpV2s6DvkA/30EVTPN+FwkwfPYeRCYMTtN0j79MdszM
	BSoAw2aFFqeunE590GOi05BjZ1y45hGFKNIKXmxOCczn+0g60h9zTzj9QbhniNuJ
	JvYrKT3Mc3E6zSLha0mEBSu6UnBec48HFXwGTFlQP+/0cLI/gVq2FhLmPhcxlV+R
	fhrzMureJiw+kGUdQMEv9lbdFla1g==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020108.outbound.protection.outlook.com [52.101.61.108])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4ap3q2g81c-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 08:49:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ikG399HlRNA4ow8sNMn6qxtZFhfMkJAzcCvIoYzntK308yPbpG+8V3Ls4nTRZCyyORLs0ORjREemWS7s/XbO2Ht2w69g/Rb6W74fktLvKQ15Doo+F4D6lSnR6EQXxotPnAPM3vHkxqfw8l7pKldZbT/Xg2v54NWqIFyZLu62VZfnAJXpz6ePgnXpGKJwFP4kZXEPUtgDboKc0oDxlfxrlgunTgXzX8YUUr5SebSM/8yOh/rCalKRES+LLEUul4zR8pWmtcl7iCln+jPzj2C6pF2IFS87apH2HpRLNmm7N0N9gKYHVMN/GZ5Niu4GdKv6tXQycOdoOSl8SxyieZWJDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QW1Nl2jQL6PPVa1Ak5o/jhieVBsBrie3Jyu+VdCsQBw=;
 b=iCMrn0kyE+yOYTN+/iNNhdwWyzgBs0C94ArEsQrbFC/oKlhRBnvYBEnry4YeopBOQQFu6ZCnlNJPkb0IZUhb/3zTJM4eu4M2uWUjdFdGtmPlHQpVVQSrT9oJi9QzthWHiIRT4p2HRiCyF/6/q+A4/AJahrkXDepuwPm0AIV1DXmveHw/HAsH8pZm1liLaZol4K0pWCpZLCKmXj1pvk/jEUq41QATDPn1OTdEr9Y+zDATU1saRHyqmmrZzYUp6mV3TXnTRC6cbH0+fs2Grdp89YQlHlwB36BLaXx3FpkBb8HmVMEchEWr8m40CFHIhyjjxRoxyLmVIT85mSgo2jgdjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QW1Nl2jQL6PPVa1Ak5o/jhieVBsBrie3Jyu+VdCsQBw=;
 b=McrhnjZ2bSIgQ1OD88xX1rfcBZ/eBohBz7kP5T57wHmV+mpUdrG75xVYz5fkp6XNXDVKz9DNEqH5UKVqIOsRLSH92WaZMSKYVe6dj7oEHUt44uqiwFihKI0VF2L7VNN9STmjQ+mOcf1uQZ/9r9A9C/cg2Pc8Yj31vowWBeeozvKco9Z3BIWxUS49H8oXF2MXCczDotHpXE0PdE3RtrTC+50ROG554QkseN9UxEt6oVzIiN85HKzvd9ChCLiUFcyFUo4B9iwkauqIOCSSH0PGl0x1jAGG/i6yyBK1+cBaTpNA42BmAyCYQ9zEHf+19brpvCUxUkn4Arp6WQH640a97A==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by DM3PR02MB10273.namprd02.prod.outlook.com
 (2603:10b6:0:46::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 16:49:11 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9343.016; Wed, 26 Nov 2025
 16:49:11 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?=
	<eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] vhost/net: check peek_head_len after signal to
 guest to avoid delays
Thread-Topic: [PATCH net-next] vhost/net: check peek_head_len after signal to
 guest to avoid delays
Thread-Index: AQHcXi98HPUjRK7uJEmyz5eQdWvl9LUEECQAgAEcnoA=
Date: Wed, 26 Nov 2025 16:49:11 +0000
Message-ID: <4F24DF4D-7F5F-4BFC-B535-57C1AD66762D@nutanix.com>
References: <20251125180034.1167847-1-jon@nutanix.com>
 <20251125184936-mutt-send-email-mst@kernel.org>
In-Reply-To: <20251125184936-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|DM3PR02MB10273:EE_
x-ms-office365-filtering-correlation-id: 9f7caefe-a5ac-4c14-380f-08de2d0bb9a3
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZGp4NjIyejB4THM0KzBFd2xxY21NVm1ud0NGdStTZDFFdmRqUFE3ZXZwbUdl?=
 =?utf-8?B?RkdZS2JWVm1pNTV1eXNteXdwMWFTTkNFbENHekp4YWxDMFc2LzVHeDc2dnkz?=
 =?utf-8?B?VVFkMGovSnVuZjVoUXQ4L092WXlpZCt3V0FGUGE1eC9FRUZQWE9UUmorZnB2?=
 =?utf-8?B?S3p2Qk5TQnFoUTJRd3hSOFhWZ25qVDZRd1NZa3M5T1AzQnJKRnB1QmlkVDdQ?=
 =?utf-8?B?QWZsMlFzb21wUW1KV0Y1TmRISnIvUGM1UC9ySDdESUNhZThRZm1IZlRGTFVw?=
 =?utf-8?B?QnM1SjRvQSttZmVmcEI0TDVWSk9UYy94N001d0RGczNUay9vOWlBWkwvRGJm?=
 =?utf-8?B?YUdQay9mdVYwcFlmZkoybmJEczRlM29OTmFQNjJGT3IyaW4wWVlnSnV4ZUxv?=
 =?utf-8?B?YlhObkdyL3MxdGdtdVF2Q3hONElNU0xvdUxaMFBXSEIxeUJmcGYvZXV1SUpW?=
 =?utf-8?B?OXloVGJ6YjJLQ1M3QWpYL2lvMDkrOXlncUw5UVM5RVNLM2RvV2RsNDlsTnF2?=
 =?utf-8?B?WFVlYXFya2t4VWtId2RieFpwQlFKb2IyUmJ2a2w1V3Y0cndIZTBCZ1JHSEVT?=
 =?utf-8?B?MVRodDJYN2NCYkVoWUwxeWs5bEk3MzhNVWU5aVdYS1haL1lVU0NEWnlhS1k3?=
 =?utf-8?B?djdoTWFhUVN1cmFvamk3RG84dytLNjVJbDZVTzcyZXVWOVB3YU9vWlM4Yjgy?=
 =?utf-8?B?eXo2cVNBSGtJODlSNEJ6eFFXcUlmUnczSDFwSy8yYkllZmhqbDhsYytUZHA1?=
 =?utf-8?B?VHI2eWYxOFE2b3VvZ2dnSWVZUVJGMlV6bkZVQ2tYVFA3NXZsdDl3aGU3UVp6?=
 =?utf-8?B?Rmp2cmY4SzJUOFJPVHhJUStXbjJ1MmZNVVBIeDFxWko2VXdJd1FHZlZWKzJr?=
 =?utf-8?B?ZGNpNWRqM1YydGZpZEo1STRxaFFISUJFY0xCQ3hlWmp4T2FSQXQrQTN5cVFq?=
 =?utf-8?B?NXdHTXNZNTdpOXJoem50NzdFUjhnTGs4NlFPN0lIYzhxUU9NdkxSRjZZeE8z?=
 =?utf-8?B?c0VJQ3UvMnh0WURwazA3SEFxSDJKZklPcnNkRGNBRjNxZjZQR1RST3dESVNG?=
 =?utf-8?B?d1Zsd0tJckpRMDlJTGxRS1Y0NGNwUmViSW9Ga0JhR1NMVkVvK2xKQWNyMFFO?=
 =?utf-8?B?azE3WkVKZkZPeDZjcmFTUWp6V2psSkd6eXh3eVdjTHAvNWxadEs1SWFSU05L?=
 =?utf-8?B?ZCtKSHZxL3Y3OHNNbTIwSnpITUMwY05QSFArY0xaeWZ4QUJhRlZQaktjMnp1?=
 =?utf-8?B?TU13RXF5cHNEY3pJU1ZVaWlSUWMxbUdCZTk4dTdURU90cUpjYitFcWQ3QitM?=
 =?utf-8?B?aVZiSXFySVRVVDNtMDhVb2VBSEdWOVk4VHljKzdpQ2o5N2JmUmc4TTZEOWFq?=
 =?utf-8?B?OGkrYW9pKzZNZVVBS0xFRVNFNEZDYWM5Y1NDZTg5ajlQV2VKRTcvVjlkZWZD?=
 =?utf-8?B?Z1ZYLzgyRE9JOGo5RkRXNForejh6M1owNVEwUTBqSVB5aGZsLzhBejY5bDg2?=
 =?utf-8?B?OEVyRkp4cXF6ZU5aR1hDa0dHOFhQSGswM3JCc3VYWkpXckVFVlExODJaV2tl?=
 =?utf-8?B?dzdGY24xSUl4WXNRSWd3NkovRUJiWFNEMDA1ZDM5R1Y3OXluQWp3VjFOMGFu?=
 =?utf-8?B?ckNaNUFzbmNVZWZxMHJzZnFmTTNNMEEzMzN6UmFBN1JqZVl4SDlzWjgzTDhY?=
 =?utf-8?B?MmtkZEVnVE51Q1RIaDg1cWRxVGh1UVRaZHorRU9GQU1WOStaUGdrZXVvN2kv?=
 =?utf-8?B?UmlDdnFDZkMzdWVYTlM3TWNHbzRFRUlyc25SZ0JZNnRWN3ZOTUMrZm04VEdF?=
 =?utf-8?B?S2l3WDh0L1dFcVMydWxLV3hLcXFoaDdYUWlPU1c5UmxrYSt0bnl0SW03TWUz?=
 =?utf-8?B?aFpQQ2MrdU1YWENSRFpSUWY2V1B3TDIyclFoRlhLVkExSkRhUXlGZjVhcEti?=
 =?utf-8?B?WStVQ2kxQ3piWGpXQzRqcmlBMGRmcENLNC9NWTBEbHcxZHhENnJDeDA2OTBZ?=
 =?utf-8?B?K2s1V1ZMVXdacUFqY1FzVzQyeDJwWEJvbjY0Ymw5cmg2eDJ4dFQ2aFBnaTUz?=
 =?utf-8?Q?/UZf9p?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T1VndkY4VUVuNVp2ajByYUZLcllMckZuUzJLN21tMGs5eWY2bXBrNVQrbVFv?=
 =?utf-8?B?V2VpWUUxeERDdUJ3bHdJZlIxeUlvRC9PUW5EbWthMGx2ZTVUSm9HV2YrMW94?=
 =?utf-8?B?cm9kQURIU0RMeGRMREFYSDlROUVUSmxNUEFoVnQ0aXEzWkpxNnRjekRCTHZG?=
 =?utf-8?B?TTgrNVBKMkNBVmdQUkRSVGpjZlJLRHhEcTRxNUFINFV2c2ZHd1IyVUNtSXpO?=
 =?utf-8?B?dGFBdHRObjhkQTVuZ2ozOG5IY0x4NGRrb2RKMW1YZ0tYZlN4STZCL3BuTEE0?=
 =?utf-8?B?di85aUxKUUkvaDVuY2xwc2pMVlB1RkhTbVVacUI0akpHdUtBNVVUb2JycVJh?=
 =?utf-8?B?RkRNcDdLZzJadTlMRFhDaUphSjVuRCt6eTJia2tBM2s2OW5VVlIzb0VvUXhq?=
 =?utf-8?B?M29sSjhWOFZxQmQ0bWkza2RzdktlQTJ4aWlOd0c1RUs4bVVMY20vOHB6Z2Y4?=
 =?utf-8?B?QjczQmh3aXlHc1p2eDdUL0dJOHZOdzVNSUhuNmtqYXN0N0hQaTl4RmJxWTNK?=
 =?utf-8?B?WlZVUVdJMXAyTHluQXRSeUI5Vk1pV0o1MWlVeVZORmJlcHFuZnR6N3ZDQlZH?=
 =?utf-8?B?dEI5aEF1cTFEbGthNVZObzUrc3ZhTVN4cWtPbEhDN28vQVk2eS9KNGUwWFAx?=
 =?utf-8?B?OW1tL2ExSjNPSThiTWtQbGJNcFNmTnZSaFJjQXVkczFZekNNK1ErNkpkb2NC?=
 =?utf-8?B?bWtoOFVpVDl6bjNsZkVXRUNxUE9iaWI4Q1hlMUF2TkFOWWFMWnBJN3JwbU92?=
 =?utf-8?B?WENWMENJT1BpdEpWQVl3eVNUUTVId1MwKzVmaUtJV2dDTU41ZGRxb0toUXZq?=
 =?utf-8?B?NldQdzVVcjUrcnZiL0tYdkVnZVVXdVhyNUZjbkxpQ1ZjLzc5VlpCSEFFTU5F?=
 =?utf-8?B?ZFh4Z2RVMS91Tk5nNEduTHhEUnJYcW5BamFoNzVJbDhVNWdkK0hmTG1oSENR?=
 =?utf-8?B?K1hKUU12R3VDaFRuY2Y1SGNicHRhZEtUd2tnWVlhSDRxOFh5cmxEQzRWZmsw?=
 =?utf-8?B?WlMvSEYwdjBmUjU0YVltUEtDZTByN0VYME9QZjFnNmtNVlN2bGxFZ2pQRXBs?=
 =?utf-8?B?UWV6SU5YK05KdlBXY0xJbkQ3UUVqek9JL2hYNC9GRlczZm1Ka3FtbmRIYVpF?=
 =?utf-8?B?QmFwSER0TCtrTmNBRVBNd0pLeGpzeXJCVXB4b3czNEVTQSt2dEVkL1Q5VUFx?=
 =?utf-8?B?bnZ5RVl1ZUovVHo5MExsSUpML24wSlo4QUpXNStWMEhZTXh6SUw5Q2k1RWNz?=
 =?utf-8?B?Z3BTOEl6dEhzMkJpWXJNdjlhckthOTExdVhITDJxZC9RYW5tb3hhSGk2emRL?=
 =?utf-8?B?V2JWcHkrVENraEpjU3hhcFJFVXBLV1F3emduUGtWTDArbm9ILzJkZnh0TUMx?=
 =?utf-8?B?eDZDZG9iMFBBS0R2RlY3c0tWMkFPak1NSGdGWGRuaERGb3F6RU92eU82Ri9j?=
 =?utf-8?B?S1YzcHkvMEIxMGU5dmRoc1dMd1ptU1NONFVNeE92QUR2SzFEV2ZXN2d5M0FN?=
 =?utf-8?B?YzdGcFgvSTdCZ1BXMVl1RnFGbHVDd1FNZVNPOVg4SG43WXNHMGQ3eERSV1FZ?=
 =?utf-8?B?VnplaVdUbFlCWlVmbEtlUWtxbnZPNWpnS2IwektLd1VFREhPZXV1bEx3YzBY?=
 =?utf-8?B?TkxVdlpVKzJNdzNKK014NTR5eERSUnZMMzRranZUL0xLTzhPUVdFK0NkNW1s?=
 =?utf-8?B?Q1JEeU5JNmpaNUpxQzFOOHdzQUtDRGZEc2w3aVdCdFltdVA2L0tPYndmV0Fk?=
 =?utf-8?B?ZjRhMHdPaFRQK00vVmI4eGtrK3NZTW9MNTdVUXBBcXZKV0lpQlpuUVJXYUtZ?=
 =?utf-8?B?YVR2aEszWUMybVo4eW90WXkrY1YyZVRIQ0dBRjZZb2t5TitIV0FQckY5bTRv?=
 =?utf-8?B?QTRVam45dCtFaHNSdEdFci9kRGNWMktwZDF4bEYzcXRrTWRONGJrbXJXZXdU?=
 =?utf-8?B?aThXVHdyZGNGcEl4enEwQTlDTnRsZGpiTVpRMll6WEtaWVFqcDNSeWZNTklS?=
 =?utf-8?B?Q0JEM1F4V3JadlludVhrenRiVEIzbWJVdUw4QjdqK2ZxRlBvRkFySW1McnhJ?=
 =?utf-8?B?aitqVzdyN2Q4YlkzYlhGcU5CaEpuT1JjMDIyQ0FTNStjS0F4Qm55bmdwdUsw?=
 =?utf-8?B?QnFvWDNGMy9Tb1pRZVVNOUg5ZTk4WEtPZTMvZWNJUDh5d0hXSUM0OFVVNWl3?=
 =?utf-8?B?Q2ZFd0VPS2V0Y0VnTGdyemo2WXVWcS9CU0x5Q2xmcjJDMFlWTWllRUQyQktt?=
 =?utf-8?B?RnpTaVlObkhOSWhQcGhMdElTZWR3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8DF3F796E661CF4EB516C35A06FF412A@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7caefe-a5ac-4c14-380f-08de2d0bb9a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 16:49:11.5350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rIhp8q9UEAYMfMAFXPMsw+OurJE3WxNr26WZxT9vnD23Z6lFCXz4Apxn63w9ljmnUCEX1TQ6fKoziTO5QC97JLzWkimkHe1tyX5uEKlien0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR02MB10273
X-Proofpoint-ORIG-GUID: h8BKU7YKTMZ0EnnyDtSStE3ddJSt9WcH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDEzNyBTYWx0ZWRfX//EmNQSh61hN
 4yoE2fG8NrkxLXNQGnim+9cvVm+6Ygixmkz+tNt2zUa8I6B7lZUY4gw9OAd/sBYZ3MF0QMUNI0y
 26EIIMB6EBSqVlL5/R6yPpr7u+Ig3lSJ9QSNLB8qFThNgbvCR0AQQBc3z08ChnEbltDNblszp/T
 1nlI3xNauYBKxmo5QcT61r4YCPXEsnVkhYZc1VfZyH1bMxo2E1ccrznMJ2Z8pjxgOP8TjbxCkdh
 3z9Rcqsfi0SwxDV5DfjOEFpxPdmkUJnIP32FMJy+9ll1+3W5rdCSGo6IdPvYnGgmzcHp4yqQ0T2
 D1XYDjrBVczx6z9+yywlmafxQuSJxQ5BbCobUZPOOQkYtvcQs+MpV6h4Zv7pogMALuRjhnK3A/V
 OMwzfRANcZf+U0tpRwiknYuGdyjSyw==
X-Proofpoint-GUID: h8BKU7YKTMZ0EnnyDtSStE3ddJSt9WcH
X-Authority-Analysis: v=2.4 cv=aoW/yCZV c=1 sm=1 tr=0 ts=69272f8c cx=c_pps
 a=W/yVf4yN/6DpLKuKUOvioQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=-VqCQdr6Eiy9pGN_JrQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTm92IDI1LCAyMDI1LCBhdCA2OjUw4oCvUE0sIE1pY2hhZWwgUy4gVHNpcmtpbiA8
bXN0QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9OOiBF
eHRlcm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiBUdWUsIE5vdiAyNSwg
MjAyNSBhdCAxMTowMDozM0FNIC0wNzAwLCBKb24gS29obGVyIHdyb3RlOg0KPj4gSW4gbm9uLWJ1
c3lwb2xsIGhhbmRsZV9yeCBwYXRocywgaWYgcGVla19oZWFkX2xlbiByZXR1cm5zIDAsIHRoZSBS
WA0KPj4gbG9vcCBicmVha3MsIHRoZSBSWCB3YWl0IHF1ZXVlIGlzIHJlLWVuYWJsZWQsIGFuZCB2
aG9zdF9uZXRfc2lnbmFsX3VzZWQNCj4+IGlzIGNhbGxlZCB0byBmbHVzaCBkb25lX2lkeCBhbmQg
bm90aWZ5IHRoZSBndWVzdCBpZiBuZWVkZWQuDQo+PiANCj4+IEhvd2V2ZXIsIHNpZ25hbGluZyB0
aGUgZ3Vlc3QgY2FuIHRha2Ugbm9uLXRyaXZpYWwgdGltZS4gRHVyaW5nIHRoaXMNCj4+IHdpbmRv
dywgYWRkaXRpb25hbCBSWCBwYXlsb2FkcyBtYXkgYXJyaXZlIG9uIHJ4X3Jpbmcgd2l0aG91dCBm
dXJ0aGVyDQo+PiBraWNrcy4gVGhlc2UgbmV3IHBheWxvYWRzIHdpbGwgc2l0IHVucHJvY2Vzc2Vk
IHVudGlsIGFub3RoZXIga2ljaw0KPj4gYXJyaXZlcywgaW5jcmVhc2luZyBsYXRlbmN5LiBJbiBo
aWdoLXJhdGUgVURQIFJYIHdvcmtsb2FkcywgdGhpcyB3YXMNCj4+IG9ic2VydmVkIHRvIG9jY3Vy
IG92ZXIgMjBrIHRpbWVzIHBlciBzZWNvbmQuDQo+PiANCj4+IFRvIG1pbmltaXplIHRoaXMgd2lu
ZG93IGFuZCBpbXByb3ZlIG9wcG9ydHVuaXRpZXMgdG8gcHJvY2VzcyBwYWNrZXRzDQo+PiBwcm9t
cHRseSwgaW1tZWRpYXRlbHkgY2FsbCBwZWVrX2hlYWRfbGVuIGFmdGVyIHNpZ25hbGluZy4gSWYg
bmV3IHBhY2tldHMNCj4+IGFyZSBmb3VuZCwgdHJlYXQgaXQgYXMgYSBidXN5IHBvbGwgaW50ZXJy
dXB0IGFuZCByZXF1ZXVlIGhhbmRsZV9yeCwNCj4+IGltcHJvdmluZyBmYWlybmVzcyB0byBUWCBo
YW5kbGVycyBhbmQgb3RoZXIgcGVuZGluZyBDUFUgd29yay4gVGhpcyBhbHNvDQo+PiBoZWxwcyBz
dXBwcmVzcyB1bm5lY2Vzc2FyeSB0aHJlYWQgd2FrZXVwcywgcmVkdWNpbmcgd2FrZXIgQ1BVIGRl
bWFuZC4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29t
Pg0KPiANCj4gR2l2ZW4gdGhpcyBpcyBzdXBwb3NlZCB0byBiZSBhIHBlcmZvcm1hbmNlIGltcHJv
dmVtZW50LA0KPiBwbHMgaW5jbHVkZSBpbmZvIG9uIHRoZSBlZmZlY3QgdGhpcyBoYXMgb24gcGVy
Zm9ybWFuY2UuIFRoYW5rcyENCg0KSSBoYWQgYWxyZWFkeSBtZW50aW9uZWQgd2XigJlyZSBhdm9p
ZGluZyB+MjBrIHNjaGVkdWxlcnMvSVBJcyBpbiB0aGF0DQpleGFtcGxlLCBidXQgSSBjYW4gYWRk
IG1vcmUgZGV0YWlsLiBMZXTigJlzIHJlc29sdmUgdGhlIG90aGVyIHBhcnRzIG9mDQp0aGUgdGhy
ZWFkIGZpcnN0IGFuZCBnbyBmcm9tIHRoZXJlPw0KDQo+IA0KPj4gLS0tDQo+PiBkcml2ZXJzL3Zo
b3N0L25ldC5jIHwgMjEgKysrKysrKysrKysrKysrKysrKysrDQo+PiAxIGZpbGUgY2hhbmdlZCwg
MjEgaW5zZXJ0aW9ucygrKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aG9zdC9uZXQu
YyBiL2RyaXZlcnMvdmhvc3QvbmV0LmMNCj4+IGluZGV4IDM1ZGVkNDMzMDQzMS4uMDRjYjVmMWRj
NmU0IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy92aG9zdC9uZXQuYw0KPj4gKysrIGIvZHJpdmVy
cy92aG9zdC9uZXQuYw0KPj4gQEAgLTEwMTUsNiArMTAxNSwyNyBAQCBzdGF0aWMgaW50IHZob3N0
X25ldF9yeF9wZWVrX2hlYWRfbGVuKHN0cnVjdCB2aG9zdF9uZXQgKm5ldCwgc3RydWN0IHNvY2sg
KnNrLA0KPj4gc3RydWN0IHZob3N0X3ZpcnRxdWV1ZSAqdHZxID0gJnRudnEtPnZxOw0KPj4gaW50
IGxlbiA9IHBlZWtfaGVhZF9sZW4ocm52cSwgc2spOw0KPj4gDQo+PiArIGlmICghbGVuICYmIHJu
dnEtPmRvbmVfaWR4KSB7DQo+PiArIC8qIFdoZW4gaWRsZSwgZmx1c2ggc2lnbmFsIGZpcnN0LCB3
aGljaCBjYW4gdGFrZSBzb21lDQo+PiArICogdGltZSBmb3IgcmluZyBtYW5hZ2VtZW50IGFuZCBn
dWVzdCBub3RpZmljYXRpb24uDQo+PiArICogQWZ0ZXJ3YXJkcywgY2hlY2sgb25lIGxhc3QgdGlt
ZSBmb3Igd29yaywgYXMgdGhlIHJpbmcNCj4+ICsgKiBtYXkgaGF2ZSByZWNlaXZlZCBuZXcgd29y
ayBkdXJpbmcgdGhlIG5vdGlmaWNhdGlvbg0KPj4gKyAqIHdpbmRvdy4NCj4+ICsgKi8NCj4+ICsg
dmhvc3RfbmV0X3NpZ25hbF91c2VkKHJudnEsICpjb3VudCk7DQo+PiArICpjb3VudCA9IDA7DQo+
PiArIGlmIChwZWVrX2hlYWRfbGVuKHJudnEsIHNrKSkgew0KPj4gKyAvKiBNb3JlIHdvcmsgY2Ft
ZSBpbiBkdXJpbmcgdGhlIG5vdGlmaWNhdGlvbg0KPj4gKyAqIHdpbmRvdy4gVG8gYmUgZmFpciB0
byB0aGUgVFggaGFuZGxlciBhbmQgb3RoZXINCj4+ICsgKiBwb3RlbnRpYWxseSBwZW5kaW5nIHdv
cmsgaXRlbXMsIHByZXRlbmQgbGlrZQ0KPj4gKyAqIHRoaXMgd2FzIGEgYnVzeSBwb2xsIGludGVy
cnVwdGlvbiBzbyB0aGF0DQo+PiArICogdGhlIFJYIGhhbmRsZXIgd2lsbCBiZSByZXNjaGVkdWxl
ZCBhbmQgdHJ5DQo+PiArICogYWdhaW4uDQo+PiArICovDQo+PiArICpidXN5bG9vcF9pbnRyID0g
dHJ1ZTsNCj4+ICsgfQ0KPj4gKyB9DQo+PiArDQo+PiBpZiAoIWxlbiAmJiBydnEtPmJ1c3lsb29w
X3RpbWVvdXQpIHsNCj4+IC8qIEZsdXNoIGJhdGNoZWQgaGVhZHMgZmlyc3QgKi8NCj4+IHZob3N0
X25ldF9zaWduYWxfdXNlZChybnZxLCAqY291bnQpOw0KPj4gLS0gDQo+PiAyLjQzLjANCj4gDQoN
Cg==

