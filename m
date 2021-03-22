Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3D5344317
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 13:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhCVMsf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 08:48:35 -0400
Received: from mail-vi1eur05on2043.outbound.protection.outlook.com ([40.107.21.43]:30144
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231617AbhCVMq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 08:46:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wh+YCoA1nqHbz0lLilJ1vcS31vA4jr5+fX+MIVuSoB0=;
 b=zTGAVUOUSzRUCndNRp18ozfsDSxIVR2pHIIP5+s6uvrce7Mc9hbnTDmUh6PS3uuzkMY53Fa79IO698pt+IwddkjR4TTpgWdWFnfLQbqRND+v6W+zjJYBxN7LCF/qETUuz/SjyJXd3B+cJtITqekTafZnTI19PJX5+ZZKKRXtW8M=
Received: from AM5P194CA0003.EURP194.PROD.OUTLOOK.COM (2603:10a6:203:8f::13)
 by VE1PR08MB5246.eurprd08.prod.outlook.com (2603:10a6:803:111::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 12:46:25 +0000
Received: from AM5EUR03FT050.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:8f:cafe::dd) by AM5P194CA0003.outlook.office365.com
 (2603:10a6:203:8f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 12:46:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT050.mail.protection.outlook.com (10.152.17.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 12:46:25 +0000
Received: ("Tessian outbound 04b74cf98e3c:v87"); Mon, 22 Mar 2021 12:46:25 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: cd6ee26ab33c4353
X-CR-MTA-TID: 64aa7808
Received: from ab3abfca9eed.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 5EDC6A08-DA3B-4F32-AD14-0DFD015C637D.1;
        Mon, 22 Mar 2021 12:46:19 +0000
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ab3abfca9eed.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 22 Mar 2021 12:46:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMvJNNiXoS8WSGk8+/lsfytPQS/PvRhJbn2Xx0KrxZkQ2kLPcrQwhPdGYC/vSNogCxvYujmDiAYr9i9M8cqngSfIzeGqGHcAMcmRrDZkdfgiVpqZSzuer2azS1VsLbQCwRcEd5TAHoMVW9Ghm4DpuyFMDRM05F85hv7G5koagnp2/JN2pJRSl9V5QU4+Gb4gLTbKS8OLYrlPP9mHbr8SawipZNVW+SDo6qjCu5s7s3U4/kINpJGJljvCL0MfNFaHoTZjjyIIEwG4ljG21+jprSpaPUziAz5/+dAz8jquISPeiLgPvlYLkDsa+5r1kIsSxLkuIaP8XuKq9wD0MUdZ7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wh+YCoA1nqHbz0lLilJ1vcS31vA4jr5+fX+MIVuSoB0=;
 b=bk2ggMMUbj0SA5227/BpHH+zoq5dAvvpP5xxee4p01Q6508TSJG401gEqmm2eeaPbWl5RlMjVaQ/gaMw+KBfopBdW3FRJAmb4G/jJ2qjrNBOieSYMS7UwsMiHqb9jV6HlAL6A9DBlHuX6b8C7Q2iqY4wu7+46DfLIDix5MUWCFTaP7SceV1U+ChvakT7AGGqtDMWT/ZnBlUUSst57I5p+9cfN2KqWlCCsA0BPWE+qppARNecfYCffBwy9I/4TxK6cgXjtffH/oJlyxEWkVXgMShvcYsc5DPZWiWQjROdGkXu7r2nvt19qoI8NsSd6lT5Se1FYVk1FIf/6kaKBsfreQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wh+YCoA1nqHbz0lLilJ1vcS31vA4jr5+fX+MIVuSoB0=;
 b=zTGAVUOUSzRUCndNRp18ozfsDSxIVR2pHIIP5+s6uvrce7Mc9hbnTDmUh6PS3uuzkMY53Fa79IO698pt+IwddkjR4TTpgWdWFnfLQbqRND+v6W+zjJYBxN7LCF/qETUuz/SjyJXd3B+cJtITqekTafZnTI19PJX5+ZZKKRXtW8M=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3550.eurprd08.prod.outlook.com (2603:10a6:803:84::21)
 by VE1PR08MB5629.eurprd08.prod.outlook.com (2603:10a6:800:1a6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 12:46:10 +0000
Received: from VI1PR08MB3550.eurprd08.prod.outlook.com
 ([fe80::8834:fa36:9de8:e6e0]) by VI1PR08MB3550.eurprd08.prod.outlook.com
 ([fe80::8834:fa36:9de8:e6e0%7]) with mapi id 15.20.3955.024; Mon, 22 Mar 2021
 12:46:10 +0000
Subject: Re: [PATCH kvm-unit-tests] arm/arm64: Zero BSS and stack at startup
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>
References: <20210322121058.62072-1-drjones@redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <fe2ddcd5-1b1d-7e42-87cc-1a9d2a0e81dc@arm.com>
Date:   Mon, 22 Mar 2021 12:46:08 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <20210322121058.62072-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2a01:4b00:88be:aa00:e1b6:307a:e182:1112]
X-ClientProxiedBy: LO2P265CA0394.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::22) To VI1PR08MB3550.eurprd08.prod.outlook.com
 (2603:10a6:803:84::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from C02W217MHV2R.local (2a01:4b00:88be:aa00:e1b6:307a:e182:1112) by LO2P265CA0394.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24 via Frontend Transport; Mon, 22 Mar 2021 12:46:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 19e1ef2b-ec7e-4d63-22ee-08d8ed308134
X-MS-TrafficTypeDiagnostic: VE1PR08MB5629:|VE1PR08MB5246:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR08MB524697BE7E169D10D95E78D5F7659@VE1PR08MB5246.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: epMES0ym81qMZUlQO/l8BScbDFO5DKNni8p7aelHHRlYu36JBtu7pPhl6E6Wr5QfbAR/SmellzMAS+/xtljFNIkQss4gEZ0xkuES3AvxNZ46v0eS34K6hhtw61ahNGfPnpS5EHCAx6arjNWF+frWtKZv+8YorCw5w2jQR0mGIEz5sVPV00lzFF+IUwX73uWi1Ks66GqpNNACTRD+or2aV29CI+/4ThTeiDJz626XmcQdMfVLLDjVLRBHMLvw6kW7C6UnJKjBa7bRKLviTRhBLOZfoCQDd08VC/0jWfgz78ql7kyxgpr00+/U+68Xir90QH/lK0bax5/jGA5Ue3DawocxGu0xonyjnJOU/jnTnoF+EWUiY805p14WIEw2wlc2U86DslGmcNkN31P9uE1UMusgEmGpkyzEenAoL+yf3LbHQRlEGIXcbSr+IxtWzbhtXO35jeTWynv1ZL/6ce6Dq1/YGPpAqjUERA3bfdVjYBjCUdYkkJXDlNrJ0UzMMjjmEKn8vBlOhuct/ZI3oJQeExtlLb3q8VhvdarumqaL1YTsvlNCVfqc4Yu+ckuTCjhOPWH1tz0D8Vh9LVzvjaIMZzw9zN5uUJLEOeFqyXP9c4GjaFv37U6BofGvMo3KF3voHKcuAGMKnc8W3JKtfGn0htvLkHSkIz9GnzWKHG2GDGfr6bnsOE/kv1ulACNWm0S//Vi4u8ZcObVJwJnGbQijcw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3550.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(396003)(39860400002)(478600001)(31686004)(36756003)(6512007)(5660300002)(6506007)(16526019)(8676002)(186003)(53546011)(316002)(4326008)(83380400001)(86362001)(2906002)(66946007)(44832011)(52116002)(2616005)(8936002)(66556008)(66476007)(6486002)(31696002)(38100700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d3FRRFlTRDF1UVRIZ0hhV0xsbHNFVE1YQkZsOFZIdVpibFArSW16eE5DcDUx?=
 =?utf-8?B?Y1dHT05GYXlRM3lOTWRtdXNZTkJFdlB0b2N5K2FxVUZYMUlYZzc2cmFJalBV?=
 =?utf-8?B?aTZMYy9DOFY0KzdLTmJyTUZWRDBKS2JMOXZpTkdSTU1ueVdYUkpXKzB4bnRp?=
 =?utf-8?B?WGZwMnRYbm81TzNla2phUldPU21XU2tldGlJemxTa2hwbG5Nd0c2c2l1djdW?=
 =?utf-8?B?S1lPZE9wQzdCd0JBMmhNM1Q4dDZ6TFYrZ2JxSTVOVE5RVUhZYXF3Q0hEbWR5?=
 =?utf-8?B?Zjc4VVFTU1lwRkpuVThIMHI1cmhqVzIzUGhUb1cydTF4ZFEraEVhVGNOWXQ1?=
 =?utf-8?B?UmZMUXRqSThyaVByRE9xVDFDU3FpRGR0bHROY0V5a3MwUC9ubDkrR3hZdUJY?=
 =?utf-8?B?OWlvWGI0bEVMcGxrQmExVmxud2FzRmNlM1oyNlowQ3FIYVVjWG5Lb2I5N1ps?=
 =?utf-8?B?Y2owS3ZsQTB1Q0pTQ09VdzY3S28rdEVDUldidlI4WEl2d0ZKVDQyYzhyQVZO?=
 =?utf-8?B?OGREU3Z6Y3p2VHB2SEluRXJQZWlzOUcxdHRWVWE5YURUYmYwcDJmODZQOGN2?=
 =?utf-8?B?MEluejc5Z0JKN3hydjhvOVZscFpxdS9tSDNKRlljSkVVM0pBc0N1SGZ2a3E3?=
 =?utf-8?B?K1RkM0VpRVBuUUJBNHFja0E5Z3R5aHQxRzJoOFkyWTFnK1VjaUNEeXN5L1Ey?=
 =?utf-8?B?OXpOSjFPSWk2Rk9mbkZmMWZhSUljVzVYTGlsczFlZmhKY0JxQ1JzZnpWWjJY?=
 =?utf-8?B?dUFRbSs3VmpYK1dFeFdNeDQ3OFYzNU1ZeFg0c2U2eS9pZ0cwT0lJeVR4a0R1?=
 =?utf-8?B?dWNjWlBRdGIxT1ZyT0tWblFKZWhaSUsxLzdpOVZxMDhVVDhNRzJqNjVIZDIy?=
 =?utf-8?B?NWoyVFhMOUJEOVA2UCtodjcvTmE4NXlzdFJObFpIV3Z4VE9QczdIU0JoWlpv?=
 =?utf-8?B?N1E3dTNyRURpQ0J0NzJLUm5qUzFCMnFlZnM2UXVCVUpxcWRLUXpSWHUzMHgr?=
 =?utf-8?B?aHQ4WjZKMTByZTAxS1FhUFE5WHZKdkkyNFhqWjR6NDhQZHFXTWY1ZGFQQ0Iz?=
 =?utf-8?B?NXJlMTFCSGFscjliVmpsemFtTkZRN0RCcU1LN0RYUTBrSXNpYldsQ2pBKytw?=
 =?utf-8?B?QzNzOU1wUjJkTDRMMFJRaE5oclcybm9DaHZHOUVmTjBLUVJ4eTFUYnFGZFE4?=
 =?utf-8?B?NTBMSkQxVFNzaDBST3ZKS0JXWHVCYytQSTQ4cWtvU3ZpMHR5UlVsR0NKbmF2?=
 =?utf-8?B?RHJLWlp2UW1WaGdqL1RmOUtERGFwcnkreTFkczliZHdUN2dhYlNiWGpTaHVY?=
 =?utf-8?B?ZEV4czIrWHh1L3NrWDJZZEpyMW1DeUZDL2lQN2VWVU4rUU9VYmxBWE8zWUtJ?=
 =?utf-8?B?S2JwTjh4QVZuUGxSUFZ6aTNMSXhwOWVoT05nUkI0dS9YcFBEcUx6NTBEVjc1?=
 =?utf-8?B?Ujc3bG11c0hnYzNKUml4Tk9xWXR1ODJoa2xCMnZyTy9VZ0xRd2ZuZDNvRzJG?=
 =?utf-8?B?WmNQVGhJbit5K2RCc0FXOVFpS2p2bkZYc3RNemFML2dobHdCb3djTlB3NGhC?=
 =?utf-8?B?a1NmeWF1TVduWEZtaEhVNHBiTityZWNQTEFaa2JFVkFaTVFTdDdja1VreGJM?=
 =?utf-8?B?akZrUU1aOE1jajdnakxRc3lrQ3doclhXeVFCWDRvL1BEUFluU2xubFYzV1p6?=
 =?utf-8?B?S0VRTGpuckJ4WTFTODg3NDhwa1JLVUc5MWdkeWV4ci9KU3poM1VBTmVESE55?=
 =?utf-8?B?dHhQSWU5NG05bUFmZHBwZnpWaEUvMzZaTmNXZkx3M21rTTVBU1RwY0tuUGN5?=
 =?utf-8?B?c001T1J0eEtlQzlvbDBXWEV0enNweWloNnd3czVDTklFb2RUVFFvdjFSVEx2?=
 =?utf-8?Q?Z+CDASN0sY4J4?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5629
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: b700b485-307a-4c3e-d2a8-08d8ed3077df
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JgUdfzmbI4tReR/PoK+vo81Rx06yEnpS2MzXS6VktrXKp1LB0RLVQANMFWuSCH3wHafLyq/6l5PpJ1TEXfOvGwGZrFuwMueOiTCexLAYz1gtq1QaFMToM+zIdEUk6DYh2Ebx9jCJJ9YseSEmt/sP9Q71DqOXrvnPSgfDnKhaPwJUJ77jhNoy6JnzNFYoNsfB6lU3CJt8wIRm86uklI2tGJ3FQMxRs0FTcnBZ5tnzLAWMKvU80GDQYUA/9LOf6JjM2rfTcDZktv0O06Ju5KRmOowL+2YmwyOA4t3BYZhcww1g4mq2JD5Z1ZNkiKhzc8Hugdzd/1xawBuEQhbdsk94cA47XHT49hx11VBVWkq0ymHBFN1yxFUsRbsp/y8N8lQjwMlXNdGYfcv9UZS/DnLwNjOSfyHJQmzTx+uIR+tUeQtKrVJkERADtc0VSTF1armwzIkpncQCWoZ+YVHErXsBDJK/ZP3gTQIl1WJuELaz1nizX3NjNaj6NeJ27kgoV1+AnYZ5zHpiFjSGrhTyBjfcl+4JTJWX6ZuH75OjzWECwnh9BTFysHILSYjFL/9JT9dviE8jTAHblZFucAImI2OQ8dC/1n8wzHfFSPoGH8MCO6HAbjkCXsDdGXjaQNIeGn/jM2jDCMmrFih2gfSDDHpr6LSBQD3CYE72mwd/pEoRQkIb5fM+dlBF/nrKG8UwGnT+
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(36840700001)(46966006)(36860700001)(16526019)(82310400003)(356005)(186003)(36756003)(31696002)(478600001)(2906002)(70206006)(53546011)(81166007)(70586007)(26005)(5660300002)(6506007)(83380400001)(44832011)(6486002)(8936002)(336012)(4326008)(86362001)(6512007)(31686004)(47076005)(8676002)(82740400003)(316002)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 12:46:25.4266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19e1ef2b-ec7e-4d63-22ee-08d8ed308134
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5246
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/2021 12:10, Andrew Jones wrote:
> So far we've counted on QEMU or kvmtool implicitly zeroing all memory.
> With our goal of eventually supporting bare-metal targets with
> target-efi we should explicitly zero any memory we expect to be zeroed
> ourselves. This obviously includes the BSS, but also the bootcpu's
> stack, as the bootcpu's thread-info lives in the stack and may get
> used in early setup to get the cpu index. Note, this means we still
> assume the bootcpu's cpu index to be zero. That assumption can be
> removed later.
>
> Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>

Thanks for this Drew!

Good point about BSS too, I was worried about thread_info but in
target-efi BSS will be a problem too.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

> ---
>   arm/cstart.S   | 22 ++++++++++++++++++++++
>   arm/cstart64.S | 23 ++++++++++++++++++++++-
>   arm/flat.lds   |  6 ++++++
>   3 files changed, 50 insertions(+), 1 deletion(-)
>
> diff --git a/arm/cstart.S b/arm/cstart.S
> index ef936ae2f874..6de461ef94bf 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -15,12 +15,34 @@
>
>   #define THREAD_START_SP ((THREAD_SIZE - S_FRAME_SIZE * 8) & ~7)
>
> +.macro zero_range, tmp1, tmp2, tmp3, tmp4
> +     mov     \tmp3, #0
> +     mov     \tmp4, #0
> +9998:        cmp     \tmp1, \tmp2
> +     beq     9997f
> +     strd    \tmp3, \tmp4, [\tmp1]
> +     add     \tmp1, \tmp1, #8
> +     b       9998b
> +9997:
> +.endm
> +
> +
>   .arm
>
>   .section .init
>
>   .globl start
>   start:
> +     /* zero BSS */
> +     ldr     r4, =3Dbss
> +     ldr     r5, =3Debss
> +     zero_range r4, r5, r6, r7
> +
> +     /* zero stack */
> +     ldr     r4, =3Dstackbase
> +     ldr     r5, =3Dstacktop
> +     zero_range r4, r5, r6, r7
> +
>       /*
>        * set stack, making room at top of stack for cpu0's
>        * exception stacks. Must start wtih stackptr, not
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 0428014aa58a..4dc5989ef50c 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -13,6 +13,15 @@
>   #include <asm/page.h>
>   #include <asm/pgtable-hwdef.h>
>
> +.macro zero_range, tmp1, tmp2
> +9998:        cmp     \tmp1, \tmp2
> +     b.eq    9997f
> +     stp     xzr, xzr, [\tmp1]
> +     add     \tmp1, \tmp1, #16
> +     b       9998b
> +9997:
> +.endm
> +
>   .section .init
>
>   /*
> @@ -51,7 +60,19 @@ start:
>       b       1b
>
>   1:
> -     /* set up stack */
> +     /* zero BSS */
> +     adrp    x4, bss
> +     add     x4, x4, :lo12:bss
> +     adrp    x5, ebss
> +     add     x5, x5, :lo12:ebss
> +     zero_range x4, x5
> +
> +     /* zero and set up stack */
> +     adrp    x4, stackbase
> +     add     x4, x4, :lo12:stackbase
> +     adrp    x5, stacktop
> +     add     x5, x5, :lo12:stacktop
> +     zero_range x4, x5
>       mov     x4, #1
>       msr     spsel, x4
>       isb
> diff --git a/arm/flat.lds b/arm/flat.lds
> index 25f8d03cba87..8eab3472e2f2 100644
> --- a/arm/flat.lds
> +++ b/arm/flat.lds
> @@ -17,7 +17,11 @@ SECTIONS
>
>       .rodata   : { *(.rodata*) }
>       .data     : { *(.data) }
> +    . =3D ALIGN(16);
> +    PROVIDE(bss =3D .);
>       .bss      : { *(.bss) }
> +    . =3D ALIGN(16);
> +    PROVIDE(ebss =3D .);
>       . =3D ALIGN(64K);
>       PROVIDE(edata =3D .);
>
> @@ -26,6 +30,8 @@ SECTIONS
>        * sp must be 16 byte aligned for arm64, and 8 byte aligned for arm
>        * sp must always be strictly less than the true stacktop
>        */
> +    . =3D ALIGN(16);
> +    PROVIDE(stackbase =3D .);
>       . +=3D 64K;
>       . =3D ALIGN(64K);
>       PROVIDE(stackptr =3D . - 16);
>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
