Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B123346580
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbhCWQkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:40:51 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:61166
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233238AbhCWQke (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:40:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bt+eBX3w2Hfkel6mNvbpOCUGmy1gFbxbhcQbFu+2/5g=;
 b=aIrTtSaFhRNZ3Dt0Rr4TD0ywyxMyQ5NVq7CL64Tps41G24Y0uCUA87p4bQOvm063lhZo5a0a6jnimS7TzfML2iwcLbWge5sLaq/AQdjhS/r+J4GIuD1rVa64wBiCqkm9a3dgr49JenSq+y+Icsp5HYu0n/LJFnLt/HQtfKrjFhw=
Received: from AM5PR0602CA0022.eurprd06.prod.outlook.com
 (2603:10a6:203:a3::32) by AM5PR0801MB1907.eurprd08.prod.outlook.com
 (2603:10a6:203:4a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 16:40:32 +0000
Received: from VE1EUR03FT055.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:a3:cafe::b0) by AM5PR0602CA0022.outlook.office365.com
 (2603:10a6:203:a3::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Tue, 23 Mar 2021 16:40:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT055.mail.protection.outlook.com (10.152.19.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 16:40:31 +0000
Received: ("Tessian outbound 2220e7a8bae2:v89"); Tue, 23 Mar 2021 16:40:30 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 80678308ed50d504
X-CR-MTA-TID: 64aa7808
Received: from 658f13620079.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id E6A6AF5A-9FDA-4B77-96E4-06AF4E466E04.1;
        Tue, 23 Mar 2021 16:40:20 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 658f13620079.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 23 Mar 2021 16:40:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZXmoaFS206WuhPcrw7RGBoKUiMkLpWnH4b4J0KWsY+GBbq1hKcA8/LK9q5Vwel43iBTVGKpAdmSPPzVLJgp4QN7FRUz8anJlH5xtjIxzVySpEw/zlFIhPe3QTEBWXMMszD6L5oBa1Y11TlU5XvkZFfmwKKCqELv+RWvTEugdHOQADQtBGznRIE0NRu2qO4PAVISZpPKn+gYdeGWHc01HW2TeoXRwkGU6IYOMYU29IuC6I3rauiDYaOp5W1hK/H9hJHkXuBfsil9rI6+9R9xEZKfR8pJdqjLu6oZNIfMC4ZD6o7p7dCaKUgEz1oYcTawTXSONW7j85mjGJcxlRCx1oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bt+eBX3w2Hfkel6mNvbpOCUGmy1gFbxbhcQbFu+2/5g=;
 b=eoajuujLWyxc4MJrKQTPzgdcc0ugfS5LoW2ImHTsp3AsmDkZnZhvUyouGKDKx7+mgvl1DZkxgaiutWnbYPh6yUsjO/tZwYKr10/39XGK0DU9R9GUSH13OS7gqCVHJs3kCnmsQfeR8Oh3NJcmwwWRf//9iFZKzHCG0j/5hv4qxiKndpM81tDmHRshwI3uFOKR5SVFxvBslQfVP+L0Dt0rrl6KNg+bYsXJos4LRLrBz8Kamoafrx1z96WYbJB8X5tPdJnkiwiCEBHZ1lwgfZYFSqCDh5Z7AR9XQRj6JerEYGtgtBaw35Y7YZgUvZsR/ot0VFjVh/yEBRACTHodeImx5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bt+eBX3w2Hfkel6mNvbpOCUGmy1gFbxbhcQbFu+2/5g=;
 b=aIrTtSaFhRNZ3Dt0Rr4TD0ywyxMyQ5NVq7CL64Tps41G24Y0uCUA87p4bQOvm063lhZo5a0a6jnimS7TzfML2iwcLbWge5sLaq/AQdjhS/r+J4GIuD1rVa64wBiCqkm9a3dgr49JenSq+y+Icsp5HYu0n/LJFnLt/HQtfKrjFhw=
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3550.eurprd08.prod.outlook.com (2603:10a6:803:84::21)
 by VI1PR0801MB1629.eurprd08.prod.outlook.com (2603:10a6:800:4f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 16:40:18 +0000
Received: from VI1PR08MB3550.eurprd08.prod.outlook.com
 ([fe80::8834:fa36:9de8:e6e0]) by VI1PR08MB3550.eurprd08.prod.outlook.com
 ([fe80::8834:fa36:9de8:e6e0%7]) with mapi id 15.20.3955.024; Tue, 23 Mar 2021
 16:40:18 +0000
Subject: Re: [PATCH kvm-unit-tests] compiler: Add builtin overflow flag
To:     Andrew Jones <drjones@redhat.com>, Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
References: <20210323135801.295407-1-drjones@redhat.com>
 <9f0b7493-bc1d-6fb7-9fd9-30fd4c294c7f@redhat.com>
 <20210323162334.pylagyghpkginrzq@kamzik.brq.redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <58560400-fcd8-922d-dfe7-e5501143442c@arm.com>
Date:   Tue, 23 Mar 2021 16:40:14 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <20210323162334.pylagyghpkginrzq@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [188.214.11.183]
X-ClientProxiedBy: LO4P123CA0493.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::12) To VI1PR08MB3550.eurprd08.prod.outlook.com
 (2603:10a6:803:84::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from C02W217MHV2R.local (188.214.11.183) by LO4P123CA0493.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1ab::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24 via Frontend Transport; Tue, 23 Mar 2021 16:40:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 60c2c8e8-a31b-45c4-4a31-08d8ee1a5ff0
X-MS-TrafficTypeDiagnostic: VI1PR0801MB1629:|AM5PR0801MB1907:
X-Microsoft-Antispam-PRVS: <AM5PR0801MB190715D2BB6B92EF62642E45F7649@AM5PR0801MB1907.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: QF1INrJh2pgGCtJZMWoB0YMh2BQTFHMQ0qbTPwD2BcOPf8R9QPDdx2NQM4ITT/lX0f8eKNJGljGunPbori98Mt3dtySjqJLa9V2Ty9/gFOHdyOUyude3o6v8MHE5zSEjto5IxmeFxZSWWRfbyOqGvCOQeWxvsL3vy/F/Frz4lnTsJcFpflxnKuW0B1med07n0Y97ezUvphFYOn7luOvLENdPwN/U7NTrKch5yEI8rtDwjfqlB5cYo4VLlwiU2sew5mqjkM8XwXl3UFzMWHC8sthQQBRiwzglb9m0rVrbHcShkESb+n2k8lSlGG4gFj8yJNHVQJQWFgfQGQErtRGFmPi0y1ERJ0iSeECJqJVuyCKn8J8d3xg6IkC3oClXYIfnhSBVJB7PeRdXi7wTx/4iCYhNoASQED/4x9zOX3XUQYR6NZI80psam//v+DZXEadOMXPPomvgm4V1zXruWeZRsmgNBf9ri6NqMle6ndoqXSWsgayHULB+SoXmr+MI8ngp1gl3VqFMtYqC1h799Et9gfNKGBtyLQWVoVIDCcuYsO0f1qhGfWzgZA6LqXu13V1v1bO0G9SpiqvwzwBBtwv0pLsvtNnR2FBpBs0WDH3+9uRZYROGxuF7qIpk78NPuOn11Azsi96Z3UWhUXpImYNYIl4ZUjTaGlBjsJrgua0nfzdr5o/DcfrSqshNnW0Ox0hDheM3LZY5Ofoj/7BOQPeOsQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3550.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(396003)(346002)(39860400002)(36756003)(110136005)(956004)(2616005)(6486002)(26005)(16526019)(186003)(316002)(2906002)(66556008)(66476007)(8676002)(52116002)(4326008)(53546011)(5660300002)(44832011)(6666004)(8936002)(66946007)(31686004)(38100700001)(86362001)(83380400001)(31696002)(6506007)(478600001)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QU9SZ2l6UXJxcWllUk4yMHEycUN5U1NGYWtLUlRKbTBuMi9zaG5QaU5oV2p5?=
 =?utf-8?B?RVRUTkxLUjgvUkFqVHZtQ2RLWVR0aERBUmZVcU5FeTZWS2lpdHd1QXd1R1lv?=
 =?utf-8?B?alAyV2pZTWxPSzRNWUpybVE3RUF2N041SW83UDhndmxOcmZDZ1MrYmx1eFl5?=
 =?utf-8?B?eUxEc3U1Ymt2WVl1WUdkdGo1VnAybGM3NGZzaXpueWxNMjlCYkk5Z1NlOXRx?=
 =?utf-8?B?am5vQnNnSlIzZjMvaVEvVkhRMDNockp3VFNKSnRTQmhIVDl5Y0FSaXdXQUU0?=
 =?utf-8?B?endRQUxWVkU4THR3U2dtY1NkcDhjcTBEODVESEkwMUxtbEd4bG04bU82eEZR?=
 =?utf-8?B?ZEpyN2FJeHJCM3IvbzdQS3lJN1FuUnJZRCswaSt5eHVicFRVKzkwYXhRTnlL?=
 =?utf-8?B?UGZ0WElXZnc1TGVzWTd0Vm5ZZ1RpMFR5YStvUkROTlNOYVZ1Zlo3THUrN3JG?=
 =?utf-8?B?R2pLQTlDTUNiU3FkMTQxeEl5bmhIeDlCSkZpQXJFV2Q2ZlVHTHB3Qmk1VmtM?=
 =?utf-8?B?ZG5VRzNiei82Y1NlUFpVOXY3Kzl6ZUFOSVEwcjM4bHV1azYvSHZocjJCZ2hz?=
 =?utf-8?B?QS9udXhkYWxVcFhNQytrSXhRZDQzTTg0RFBIUnBLSkFyVG5icGhKejFEUmFy?=
 =?utf-8?B?U1NtM0FkQ243c2tUKzBXY2p1M0ZMY1lOWDl3TXZnOGE4SGJYZG9meDZGcWox?=
 =?utf-8?B?T3crV0R3aEorYXdTMmlWeFJuNkdVbjVhVW00MHA0SWdtTXpSaE5SSGNycWdE?=
 =?utf-8?B?bmtja2VjSEtvNmw5SThLT2xRWUVaclREZDVIWkFMMWRtS1hTMG5SUmFiZE1G?=
 =?utf-8?B?QkhVTGpKUW5Jdks4TFZJaTZqeTd6UGhlRzg5UW9oRHc4Qk9VNmFPSkVmdzg1?=
 =?utf-8?B?Z0s3aTF0ZU9lRzlPTHlrZkRBTlMyUXQxZDVkb2VscHJQYXNtRkdGTGZaL243?=
 =?utf-8?B?ZDJxREhITXhaSzczT0pDZDJTUVFJaDg4WGJkN25GbTBQanpaTmliZ0MzdzZq?=
 =?utf-8?B?TC9MUDBQVjNFeGRNN0VDWm9SWEdzUlArVVZIcnVSbXcray95NFNtVkV6Zjh6?=
 =?utf-8?B?OFJjaE9RY2U1R1dXZGJDMndXeWg2WXJOb2RLWlFreDJkL2gwR0lCNVVva3BR?=
 =?utf-8?B?UUVLZFl3b3NiSmlxRmc5WUNGKzFPZDV5T3hyZ2FyT1BBLzdlUlYyNUtaQVBX?=
 =?utf-8?B?TEg3Y1poSVVBbWR5OHFsdXF2VFVRQUZIb2lrOHhYT3FYbWRleFRaNzU3VnJL?=
 =?utf-8?B?dUF0emJGZ0UzZUhVLzlHSmpST01GOFBIOE9HWkhjeU13MGs5TlJsajVoK1Iv?=
 =?utf-8?B?ZkxwNTNHWE5sOHY1clNOeHliZEg0WjZ4MzNtM3JueWNsZVdZSldlOXFFaXhT?=
 =?utf-8?B?aU9tSVpGTWpmUC9hWTE2bXVtWEVIY0xNbHl4N3BNR2N2b2drcnFqYkxuYVYy?=
 =?utf-8?B?RXMrZzFYOWRxd09sM1owZ3Z0ZzdtY3NiRTZDS1Vxd3c2cmlwQkpzdC9XZU55?=
 =?utf-8?B?cGk3OHZjbnlNNTRSaFV2ekhBRHl2d0Z3VFRtajlNSldtS1lmMHduQlY2YXI2?=
 =?utf-8?B?cHpqVFhVUU1PSDBhT2FiUzY4WXB5OVluSUJVVTR6ZXNQOXdnek0xYndUWWI5?=
 =?utf-8?B?QWVxVkJ4QTJuaUhkRFAyN3ZYU1N0ancwSk8vMHZlT1BYNFVwS3B3UVh6bDJm?=
 =?utf-8?B?eGkvbTZYaU1EU1hkZHNxemVlMWgyWS9aMUNhT2VSSDNseldrQ3d5eWlGTDE0?=
 =?utf-8?Q?ArETiTaoePF4BOWImdQDAi+ISaEdCGWImqLMR3t?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1629
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT055.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 20077983-309e-495a-9d0c-08d8ee1a573b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zFanNulO9cPIYCj5QwJALxWAnz+f+9+GvFZdu6AX/ySg2wYczL3BimrueM+zr+Vu13uGBZT08U044BbiY4OMw4oLtZXfrZhCUF5PJ3OOZQ8KdPR+DBs/fI1zdFA1M2kCvMMZ9G2W9quWjF8RqdiC0IVy8wEMXjI7IXQob6cdpvaI3LcIDnuOut1aCiPcs+Z8n1e/tzEWY7Nuyq2cqG2msRzTBUu6/53YYkJZUL/JT43IEH05i6Nx98awwZNsX6aSYRzsaD/OLqVNeAFxCMY7clD2Ur31zw+Ns2oahBofefNSqNDeKoTpl81p/peMW+1WMsNtg9jOgIUC8cGdc+/AZ1AMPy+3ijjRatalbme3XFJW7PV2oaqyD4jApZDtwQwWsq0KBG4gb2qbNjpXPg4fYOubKXykTHi9QgJL8HLhNoZ1MgRyWmMZ5NV43umEE9R9d/2J86vNTaNcgfM/TMj3zZM6HpEmQROR430393kfhvWBbx0llv16IWaKPVUKiWc3wbeahlE2jdBFuJzN7IQ8q0U+xM4ZeG+ysQc/F6MneDClq0H0P+LzOWeZz409SplnKG6VSCo/j0NHEQ6g+QSAbPRya+O7Tns8SWQUjrVu7aKvqN/5h+91SQ2saxHwpyUzgnVkWnEyxF6LKPwsa3kudjwzdpim2Yw0iDcMdmQ5aZVZ/yYjWtUYJr3d+sATDzw8
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(36840700001)(46966006)(81166007)(16526019)(2616005)(110136005)(336012)(47076005)(36756003)(6506007)(82740400003)(956004)(6486002)(316002)(2906002)(26005)(186003)(8676002)(8936002)(31686004)(6512007)(107886003)(44832011)(5660300002)(6666004)(356005)(53546011)(82310400003)(83380400001)(31696002)(36860700001)(4326008)(70586007)(478600001)(70206006)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:40:31.7799
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60c2c8e8-a31b-45c4-4a31-08d8ee1a5ff0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT055.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0801MB1907
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/03/2021 16:23, Andrew Jones wrote:
> On Tue, Mar 23, 2021 at 04:22:58PM +0100, Thomas Huth wrote:
>> On 23/03/2021 14.58, Andrew Jones wrote:
>>> Checking for overflow can difficult, but doing so may be a good
>>> idea to avoid difficult to debug problems. Compilers that provide
>>> builtins for overflow checking allow the checks to be simple
>>> enough that we can use them more liberally. The idea for this
>>> flag is to wrap a calculation that should have overflow checking,
>>> allowing compilers that support it to give us some extra robustness.
>>> For example,
>>>
>>>     #ifdef COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW
>>>         bool overflow =3D __builtin_mul_overflow(x, y, &z);
>>>         assert(!overflow);
>>>     #else
>>>         /* Older compiler, hopefully we don't overflow... */
>>>         z =3D x * y;
>>>     #endif
>>>
>>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>>> ---
>>>    lib/linux/compiler.h | 14 ++++++++++++++
>>>    1 file changed, 14 insertions(+)
>>>
>>> diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
>>> index 2d72f18c36e5..311da9807932 100644
>>> --- a/lib/linux/compiler.h
>>> +++ b/lib/linux/compiler.h
>>> @@ -8,6 +8,20 @@
>>>    #ifndef __ASSEMBLY__
>>> +#define GCC_VERSION (__GNUC__ * 10000           \
>>> +                + __GNUC_MINOR__ * 100     \
>>> +                + __GNUC_PATCHLEVEL__)
>>> +
>>> +#ifdef __clang__
>>> +#if __has_builtin(__builtin_mul_overflow) && \
>>> +    __has_builtin(__builtin_add_overflow) && \
>>> +    __has_builtin(__builtin_sub_overflow)
>>> +#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
>>> +#endif
>>> +#elif GCC_VERSION >=3D 50100
>>> +#define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
>>> +#endif
>>> +
>>>    #include <stdint.h>
>>>    #define barrier()        asm volatile("" : : : "memory")
>>>
>>
>> Acked-by: Thomas Huth <thuth@redhat.com>
>>
>> ... but I wonder:
>>
>> 1) Whether we still want to support those old compilers that do not have
>> this built-in functions yet ... maybe it's time to declare the older sys=
tems
>> as unsupported now?
>
> I think the CentOS7 test is a good one to have. If for nobody else, then
> the people maintaining and testing RHEL7. So, I'd rather we keep a simple
> fallback in place, but hope that its use is limited.
>
>>
>> 2) Whether it would make more sense to provide static-inline functions f=
or
>> these arithmetic operations that take care of the overflow handling, so =
that
>> we do not have #ifdefs in the .c code later all over the place?
>
> We could add macro wrappers for the arbitrary integral type builtin forms
> and/or the predicates forms.
>
> I can take a stab at that and send a v2.

I was about to suggest trivial implementations in compiler.h without
support for overflows (always return false), it will made the code on
the caller side a lot cleaner and it's not overly complicated; the
downside is that the caller will be completely unaware that overflow
detection may or may not be supported, adding a #warn would be an option
but with -Werror, it's not an option.

Thanks,

Nikos

>
> Thanks,
> drew
>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
