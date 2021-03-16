Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 004D833DCF3
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 19:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhCPSy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 14:54:58 -0400
Received: from mail-eopbgr20076.outbound.protection.outlook.com ([40.107.2.76]:59785
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240214AbhCPSyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 14:54:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKJ3VBPp6c8Oyvr9D2tiSnLLN/FsVjsVQGBWr/bVMGs=;
 b=SfNTewU25SKvZxMWYTRikMU0shBPvqQkpHpYczCFJeWmWIlRtVSUDGawkgXl6RmL3ZiScbvDU9a8PZg8Lei5SKeY47E6UrnZeIFptMzWkCWPWEAwL4y8uO0XcxcEMtMCh6vmt0tU2VhZmt5vrrGCOsMUz4h9YEq5ceoIDCismX0=
Received: from DB3PR06CA0026.eurprd06.prod.outlook.com (2603:10a6:8:1::39) by
 AM0PR08MB5315.eurprd08.prod.outlook.com (2603:10a6:208:18e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 18:54:35 +0000
Received: from DB5EUR03FT064.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:8:1:cafe::f2) by DB3PR06CA0026.outlook.office365.com
 (2603:10a6:8:1::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Tue, 16 Mar 2021 18:54:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT064.mail.protection.outlook.com (10.152.21.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.30 via Frontend Transport; Tue, 16 Mar 2021 18:54:35 +0000
Received: ("Tessian outbound 10f3eddefbbf:v87"); Tue, 16 Mar 2021 18:54:35 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: b8ab260058211a1e
X-CR-MTA-TID: 64aa7808
Received: from 94adc8ff4ec1.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 885FFC57-897E-48C9-9147-CA90C1F466EC.1;
        Tue, 16 Mar 2021 18:54:28 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 94adc8ff4ec1.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 16 Mar 2021 18:54:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiCdKy9hSNP3LXseu5a5zr0tD291Bq6rcIZC2g0WB+NE2QdesIR+hkiB+kdPvJdsntxoZIfeLad37ODe3rgngPaRskd1n9nwwNL5HNoWBtNJQTn00Vpq4ds3Kvm1EQSWUeK8qyzfyIlWAlM4kAQ+J08Rmb0mSVWSdnMA1RVLmmJFE0Qb2pa3rqFwNeTYwdNsqjVmmDkaS6oaihSLA5OEj2dQu9uRd6kEfighNfviJiJ2/GeclKcKIowotJkSoAcOkhL99dNAVdQUDdoDOXCJHMwYLjUfY/X0PW59Cg+0dC1jmUa9i3CPDCxfVrO3y9OFgezqIZBYHhCc/ESnjdGxwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKJ3VBPp6c8Oyvr9D2tiSnLLN/FsVjsVQGBWr/bVMGs=;
 b=XgKEiFMwhtk6irN5kSpgJ2NQMCyZw2SXIwpw7IrJaad2+reCuSD4bl+KZtTlBbWiqp+GHQMppJqO401vZ90HozpcpKv5tfNZcviSIMJSXBL6LgC2hwyKpNowky9CIysStPBsoXsyC2tiKGOWticOvOidHtVfk6Lm+YV/MOEgECrJYGZMmv0DnpElbiL1ny+2jp7r1pnqowKCTa4Nf85qm16C35aGQcXxNWdCL/JdBwAPFGuYruDAT5pz1UZYh/ixxQRO6PlL5I18XYWE9o88aZ4WLlpgw/AzHm0XzF0Xn2D0blDSQ20wvvndos9hGY3nj46JMI8Ibz+mOhi/REZ0og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rKJ3VBPp6c8Oyvr9D2tiSnLLN/FsVjsVQGBWr/bVMGs=;
 b=SfNTewU25SKvZxMWYTRikMU0shBPvqQkpHpYczCFJeWmWIlRtVSUDGawkgXl6RmL3ZiScbvDU9a8PZg8Lei5SKeY47E6UrnZeIFptMzWkCWPWEAwL4y8uO0XcxcEMtMCh6vmt0tU2VhZmt5vrrGCOsMUz4h9YEq5ceoIDCismX0=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3550.eurprd08.prod.outlook.com (2603:10a6:803:84::21)
 by VI1PR08MB3343.eurprd08.prod.outlook.com (2603:10a6:803:46::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 18:54:26 +0000
Received: from VI1PR08MB3550.eurprd08.prod.outlook.com
 ([fe80::8834:fa36:9de8:e6e0]) by VI1PR08MB3550.eurprd08.prod.outlook.com
 ([fe80::8834:fa36:9de8:e6e0%7]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 18:54:25 +0000
Subject: Re: [kvm-unit-tests PATCH 0/4] Fix the devicetree parser for
 stdout-path
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com
References: <20210316152405.50363-1-nikos.nikoleris@arm.com>
 <20210316170315.332uljbqwe7t7w4q@kamzik.brq.redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <ab4f63b0-a5f4-4142-f55b-2a8c5240578b@arm.com>
Date:   Tue, 16 Mar 2021 18:54:21 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <20210316170315.332uljbqwe7t7w4q@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2a01:4b00:88be:aa00:398c:314d:51a4:59be]
X-ClientProxiedBy: LO2P265CA0046.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::34) To VI1PR08MB3550.eurprd08.prod.outlook.com
 (2603:10a6:803:84::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from C02W217MHV2R.local (2a01:4b00:88be:aa00:398c:314d:51a4:59be) by LO2P265CA0046.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:61::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 18:54:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7fca448a-aed3-436b-ec0f-08d8e8acf182
X-MS-TrafficTypeDiagnostic: VI1PR08MB3343:|AM0PR08MB5315:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB5315E14D31540EFFD3042E50F76B9@AM0PR08MB5315.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: pRSdwkC/RgxRKD/diZKubepNv+AmZE+xA1rhNb37fKZZRHsC1av9obdMLa150qfGud4JMk7dNpPVwxSOVTMtJ1lC1idXPCzpDgrFaCsnyEn0mNhRWq7YZ5F1r0rsUM928yf3U0+K/oF7x3m0Sv9v3U2Ka2u7fEY+fvMpjeIRkbenCq34nHBAmXEzCuJyXe9Rwfj/N0OwSYvPTFu8yFl0GFtQ+i/MzjTQt65SODnFl+iWIIpeiId2ozSX9VTqbPwUs2a2nPOl+TaBh6fvdoTIErioG1uYz9QFTt7R9Mwe0lFbFNPqxnvSMXiWv3mBZ9AuXllLDqeoD8fQTV03kn6y09CbXkS+WF/VRO+fVt3vqScZxN+6VOSAfl9iAgcIgFzaYCZtZTT34slvBr1E64CW6A0oUf1V2ccMH4/7nd7ngYuncivMe3EqOfN6xeR3NTguzzrQLzyiAvVAe/dAfjHjA2hAhUO7or6uuz/iMibNFiJ7Oo2mt1iC7qLfKv5q+mWYTbhAItvVfmYsiOT/GHL82ko+MV5TIhiWYQpma/d2zmdJl9AEXxRxmSDaIiq47t0lHzXO9LoTj3qn1xuqwEEyFG/487T7UAxNH0cgpnR47Xr3sr75NCTvCbjr77QImzskS1+OdPkmwJzMFWHk95SxNA==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3550.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(66556008)(86362001)(52116002)(66476007)(66946007)(31686004)(478600001)(6506007)(8676002)(186003)(5660300002)(316002)(36756003)(6512007)(4326008)(31696002)(16526019)(83380400001)(2616005)(8936002)(44832011)(53546011)(6486002)(6916009)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?LzBNNzYxMGR3WWFKRnRCQ0haUUdFcng4cEJOQXdsbURNNEhhQ0JrWGt2cVIv?=
 =?utf-8?B?cjVNL2lXL0RneEc3V1VLZUJEcjB6S3hQVDJrRHh1dG5zcmdJQ0xWNVl3M3Vp?=
 =?utf-8?B?b2lJOXhwbXZ1MG51Q2VtWVpZcW56dEFFRFNiL1lWZnhib1ZjbFJzOG9LZ0pV?=
 =?utf-8?B?WUVXNCtBSUtzaGt2dDAvR3BTNCt5VTNoU25na0xuQ25aRlhYWHRiL0hOUi9u?=
 =?utf-8?B?ZGYxRElVb3Vqem9jN05hMkhvTmQ1M005MHkzQmVzaU5qc1p1cmVkK012MGIx?=
 =?utf-8?B?Zi9QYStpdURxNmdQbFZLbUp0QTgzWUxTOHkzUWZQVnhQYnJGNzI5eHBTY2lQ?=
 =?utf-8?B?S3ExUG5WL3RPQktCRkE5VHpja2pMd29CTHFVQytZRnBhZUpwblh2emRmcFdG?=
 =?utf-8?B?NzNPRlcxaCtYQlVVR3Q0THZXOW5jdVpvMWRPTHVDTlk3R1NpS2JzUTA1QWx2?=
 =?utf-8?B?a0krQ3M3WHVPSTFKUzF5NWxQWC9ybVdQUXNoc0hWUlhGNUl0akc4NVlOaXps?=
 =?utf-8?B?QlA5U1A3eHkrbHZUNmdmSTMvTnQ0NzBmOE45bllldXRHSDRyelZaKzlUUFRh?=
 =?utf-8?B?d01pU2JuQVY1VEVOLzdmbERZUkdBcXN4QjVNWkUxRzVGWC9Jc2l3ZENSS1kx?=
 =?utf-8?B?bVdXTy9FY0Z2WFlkemQ2OTlObTV6YXJrU1VtWkJ5MklOSmhpZVBKZGtYOHhI?=
 =?utf-8?B?aFJnQkFrMy8xRlZvOUlOaCtoVmVDbjhyblNUYXFGODdWOEdKRy9Gd0NSOE1N?=
 =?utf-8?B?N0NoSjljUWdRMjRoSElTL1dmQzh6WnpybFZ5czJWR1djU3BRUVRHcHRIVHEw?=
 =?utf-8?B?WGZ4WEQzV0lQSWdjbXR5c2I0anJXcWxrb01JaWRaaWIxY054UmxUNlZSTi92?=
 =?utf-8?B?Q09rSTZNbEtjNmFCeGlzUFNZd2lhWk42cXNWWHZwZ1dSL1ByZ1NrcVZLbit2?=
 =?utf-8?B?aVVWS1ZmMFFUR081Wm93U0NRdWliVklIdmdhdFNXNWV3UTQySVZ0WDN5S0pu?=
 =?utf-8?B?eWRseHd0eFVFeUpaVXVkekJuVFBndWJtaHNCL1FXdlBKeVMvTHN5L0svWGkr?=
 =?utf-8?B?RE5QcFdITk1UZjVGeGhnamZMamJnejUwVDE5d3pyNEthTkVSV0RaV3FZSVhu?=
 =?utf-8?B?WnRNSTBUQ0VSTTdwRnNiZ0I1VU1saHBxYTNzemM2TXRoR2pTc0VYdUc0S3hD?=
 =?utf-8?B?YytwREpHcFhjTlhwYndIbDZXVHJqVUtrZlFaeGJyaEVkbnM4b2pMWDIxNVJO?=
 =?utf-8?B?eVNISXNuQk05cnhtdlVPUkRId0hiNlRUdWsxMnEyNHVFMzVVYWRlai8rNFA4?=
 =?utf-8?B?SlFUc1JHQWVZY3BRbC83ZEt3QVZyRUZNSHFxNWlEZU84WCt1SFZnMHZCN1d5?=
 =?utf-8?B?VWxzdFFvU1doZW1LOVB2ZngxcDM1blZMRHZvbWFZQmlCd1ZZeEUvSGhpNFR6?=
 =?utf-8?B?bkwvZTN5OGM1alBXOTNmSFpOSHZjZit3U1JLRWpuK2NMc3l2aXI3bzd2MTVT?=
 =?utf-8?B?dlV0T2hSK2M1dm5ObjlSSlBRcW5ZeWdHb0VFWEdLRnE4U3FLRGl3ZWlpeUh5?=
 =?utf-8?B?N0UwajNqOHZkVXcwSnAxOUMyTVpmdUZSQnBzY1lXeVowWTczSWorSTVkakQ1?=
 =?utf-8?B?cEQvVHZ5Vm1iVm1kOG1mQjdhbWdURXNteTBLRkQ2K1MwSExvbVJMaUR2UTdG?=
 =?utf-8?B?V2U1cURoNGt4cXVxZEsxRGxoTzRPS2RDVlVxaEFUcGFkQndQY1hUOGlsa2Rt?=
 =?utf-8?B?ZTFtRWFxcVlUeTZtTWJtRlUxTFdkNjNwaWJLYlhjejlpTXpFa2lhTVRWc3Ax?=
 =?utf-8?B?MmtISmpEelhjVUl4ekNzNFpOVjBGVGxKVlFpdm5DOFlvbFMrck03d3p4ZjVs?=
 =?utf-8?Q?1kzomWImLl6L5?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3343
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT064.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 26aaac13-0452-4434-1143-08d8e8acea43
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 83wTq/dnw3b10+gsNsPBa+iYVPyvQuHNFYL10PIzX3EL+yBULp+zxHvraWqD0qlCe6PthXfUaKVlNsqzPwO3clcA0TmDctKqcL56M6FeEgwuriaHkCmbZTbWzSQ//Qw6LeHSZjE7EsRNQ4al6HHFbipkfZ450ZVPPNhy+4XL88f/9hKoTovuM42qYyAyOOJpI/e4GwSFfcKUV9o4UTfNJBOFBd2bbI8THP1ZXojGcavzvHRtvzSN0bX+dtZR9SwTfYycQcCEMhre8P+Byg9NsKWdw0I3URK7t6YzmI5OQEDBUjN55cd8CZc70yJ86Nw6gbqh3dEr/8grLAKQaYXmqiH0EwJ4K5CiJ0v1xzPzKpU3RgRTpTRdSjikm0gYjPBqNnl25JSRTOc131Kquz3xaoEkAGApXjFt73UNE8FOmxrFUXGnqDw+IV/AIIrg7/naR6CJmNo3zbFaoiiEew62sutnBtfKXIKcgPjp67PpvrigFdR8JcIEFBljtOuP7uh7xgiAUbrrVdAkJ2LQ1WgNTbHSosksicyG+dPDi9TnMCugyOwx2DgxlIqGnNbsZ6qcn4kZDb78s36od0GkrmOjnJksUqb1G+Zw0WTpTFNdnuZK30AsURB+3UfMKpfJ4Phuckc0W18IRDHu5yA3AuAl9SuYilUbv6mAvLCmjEq2e4CcM/ijziXWQQKfiD8j6Lvv
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(46966006)(36840700001)(82310400003)(83380400001)(31686004)(70206006)(70586007)(53546011)(16526019)(186003)(8936002)(26005)(356005)(31696002)(6486002)(478600001)(81166007)(6506007)(36756003)(5660300002)(8676002)(44832011)(86362001)(2616005)(316002)(82740400003)(6862004)(336012)(6512007)(47076005)(36860700001)(2906002)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 18:54:35.6763
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fca448a-aed3-436b-ec0f-08d8e8acf182
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT064.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5315
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hey Drew,

On 16/03/2021 17:03, Andrew Jones wrote:
> On Tue, Mar 16, 2021 at 03:24:01PM +0000, Nikos Nikoleris wrote:
>> This set of patches fixes the way we parse the stdout-path which is
>> used to set up the console. Prior to this, the code ignored the fact
>> that stdout-path is made of the path to the uart node as well as
>> parameters and as a result it would fail to find the relevant DT
>> node. In addition to minor fixes in the device tree code, this series
>> pulls a new version of libfdt from upstream.
>>
>> Thanks,
>>
>> Nikos
>>
>> Nikos Nikoleris (4):
>>    lib/string: add strnlen and strrchr
>>    libfdt: Pull v1.6.0
>>    Makefile: Avoid double definition of libfdt_clean
>>    devicetree: Parse correctly the stdout-path
>>
>>   lib/libfdt/README            |   3 +-
>>   Makefile                     |  12 +-
>>   lib/libfdt/Makefile.libfdt   |  10 +-
>>   lib/libfdt/version.lds       |  24 +-
>>   lib/libfdt/fdt.h             |  53 +--
>>   lib/libfdt/libfdt.h          | 766 +++++++++++++++++++++++++-----
>>   lib/libfdt/libfdt_env.h      | 109 ++---
>>   lib/libfdt/libfdt_internal.h | 206 +++++---
>>   lib/string.h                 |   5 +-
>>   lib/devicetree.c             |  15 +-
>>   lib/libfdt/fdt.c             | 200 +++++---
>>   lib/libfdt/fdt_addresses.c   | 101 ++++
>>   lib/libfdt/fdt_check.c       |  74 +++
>>   lib/libfdt/fdt_empty_tree.c  |  48 +-
>>   lib/libfdt/fdt_overlay.c     | 881 +++++++++++++++++++++++++++++++++++
>>   lib/libfdt/fdt_ro.c          | 512 +++++++++++++++-----
>>   lib/libfdt/fdt_rw.c          | 231 +++++----
>>   lib/libfdt/fdt_strerror.c    |  53 +--
>>   lib/libfdt/fdt_sw.c          | 297 ++++++++----
>>   lib/libfdt/fdt_wip.c         |  90 ++--
>>   lib/string.c                 |  30 +-
>>   21 files changed, 2890 insertions(+), 830 deletions(-)
>>   create mode 100644 lib/libfdt/fdt_addresses.c
>>   create mode 100644 lib/libfdt/fdt_check.c
>>   create mode 100644 lib/libfdt/fdt_overlay.c
>>
>> --
>> 2.25.1
>>
>
> Just tried to give this a test run, but I couldn't compile it on my x86
> Fedora machine with my cross compiler:
>
>    gcc-aarch64-linux-gnu-9.2.1-3.fc32.1.x86_64
>
> Every file that includes libfdt_env.h gives me a message like this
>
> In file included from lib/libfdt/fdt_overlay.c:7:
> lib/libfdt/libfdt_env.h:13:10: fatal error: stdlib.h: No such file or dir=
ectory
>     13 | #include <stdlib.h>
>        |          ^~~~~~~~~~
> compilation terminated
>
> So I commented out the #include line to see why it was there. We need
> strtoul(). I quick hacked an incomplete one (below) and was able to
> compile and run tests. However I see that 'make clean' is leaving behind
> several libfdt files
>
Thanks for testing and for the fixes!

For some reason this isn't causing problems in my setup. gcc is
eliminating unused symbols and it doesn't need to link with strtoul(). I
see how this is a problem though and I will include your fix in the next
version.

> $ git clean -ndx
> Would remove lib/libfdt/.fdt.d
> Would remove lib/libfdt/.fdt_addresses.d
> Would remove lib/libfdt/.fdt_check.d
> Would remove lib/libfdt/.fdt_empty_tree.d
> Would remove lib/libfdt/.fdt_overlay.d
> Would remove lib/libfdt/.fdt_ro.d
> Would remove lib/libfdt/.fdt_rw.d
> Would remove lib/libfdt/.fdt_strerror.d
> Would remove lib/libfdt/.fdt_sw.d
> Would remove lib/libfdt/.fdt_wip.d
>

Sorry for that, I will fix in the Makefile.

Thanks,

Nikos

> Thanks,
> drew
>
> diff --git a/lib/stdlib.h b/lib/stdlib.h
> new file mode 100644
> index 000000000000..23a3f318d526
> --- /dev/null
> +++ b/lib/stdlib.h
> @@ -0,0 +1,4 @@
> +#ifndef _STDLIB_H_
> +#define _STDLIB_H_
> +unsigned long int strtoul(const char *nptr, char **endptr, int base);
> +#endif
> diff --git a/lib/string.c b/lib/string.c
> index 9258625c3d15..2336559cd5a1 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -6,6 +6,7 @@
>    */
>
>   #include "libcflat.h"
> +#include "stdlib.h"
>
>   size_t strlen(const char *buf)
>   {
> @@ -161,7 +162,7 @@ void *memchr(const void *s, int c, size_t n)
>       return NULL;
>   }
>
> -long atol(const char *ptr)
> +static long __atol(const char *ptr, char **endptr)
>   {
>       long acc =3D 0;
>       const char *s =3D ptr;
> @@ -189,9 +190,23 @@ long atol(const char *ptr)
>       if (neg)
>           acc =3D -acc;
>
> +    if (endptr)
> +        *endptr =3D (char *)s;
> +
>       return acc;
>   }
>
> +long atol(const char *ptr)
> +{
> +       return __atol(ptr, NULL);
> +}
> +
> +unsigned long int strtoul(const char *nptr, char **endptr, int base)
> +{
> +       assert(base =3D=3D 10);
> +       return __atol(nptr, endptr);
> +}
> +
>   extern char **environ;
>
>   char *getenv(const char *name)
>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
