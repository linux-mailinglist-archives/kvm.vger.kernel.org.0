Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10B2343D52
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 10:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhCVJ4m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 05:56:42 -0400
Received: from mail-vi1eur05on2050.outbound.protection.outlook.com ([40.107.21.50]:21057
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230095AbhCVJ4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 05:56:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruugFBGV1TknmESBDQjhn+YIhcKx2gEO/yanLtYegJ0=;
 b=Edtom/kqxgV3oUOwLxjxpvrZQA9G95UDL6I+imhTsMtR4WpWZr0oXwIF0cevOessqiq4AlXJn847WE5msZfQnC+lLFIlhWXrR0owURF4QsLDryEGQ44x42DzZiPqN/p5gG51yVxFlOpFooFTvUiEn1YFPKKicq99DCLcAJLEv2Y=
Received: from MR2P264CA0053.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:31::17)
 by AM0PR08MB4035.eurprd08.prod.outlook.com (2603:10a6:208:134::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 09:56:10 +0000
Received: from VE1EUR03FT050.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:31:cafe::47) by MR2P264CA0053.outlook.office365.com
 (2603:10a6:500:31::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Mon, 22 Mar 2021 09:56:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT050.mail.protection.outlook.com (10.152.19.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 09:56:10 +0000
Received: ("Tessian outbound 26664f7d619a:v87"); Mon, 22 Mar 2021 09:56:09 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 1cfded42ea8ee747
X-CR-MTA-TID: 64aa7808
Received: from cabb5fa20b70.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id E35A74A1-47A3-44D3-BA1C-DD55D802F140.1;
        Mon, 22 Mar 2021 09:56:00 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id cabb5fa20b70.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 22 Mar 2021 09:56:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTHJwm8B9QaT25MSegOH5JoFB8u5xEtEDa52oQmuAWOZ+pNhbin1US2EPj9tYY+VJvDwWPT0VVOFzhiPSLJDMXUu+X4btmbX2q3snSpoIuOEeFFkK8mcLqWn3G1Y5LlJoCwGOSr+fASlv0pqHY0rizZWdkTAkrOg1f/FYqpZLiLUvwkKFa/wA6sdf/6TmNRpYmWZbmAfLyRzg8glad6MQUYcDdjCc3jVFQ9DyBfjAMqqAcQn8l72atGNjNRYE2rWOA3/lkfNhT23MMHH8F4GFtzhDYpmEnHA9PEXRyRVwF1fUqhfclO/WoxqzC2/ZjvJ+fR2zXxhzYMu/O18dWNEvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruugFBGV1TknmESBDQjhn+YIhcKx2gEO/yanLtYegJ0=;
 b=VysfuaOZgb6BvDRQmVP0YEiPmhdWnpN/UikiwJKcYm5btigIciP2tKbDyvg8XxBJ9Xsi9goEcnKbx5rLHy8eeHLp7eegwM+Cp0v8MlG1xzab5EiuCQMkn+DdbqiwbgABNfDOohya/wSOUBByTbuWaCKGMa6ydCw3wZ/9p6mcFRC1qF2ScZt6QhiHvTflyqtA2ko2ugaqCQS8jwT0ZRdJ0CcHfPwm1WdwrIc8T6z9LcVKy/yj1fjVq1wAV53t4YDuzA8Cp+k7DaCdy9HCD/ql0Y92qk1VCCZb+9Z0PBIRmaBICKq1fVYT/iAwid7X/bJqRAbuhFYmOA5x+Y/uKrUydg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruugFBGV1TknmESBDQjhn+YIhcKx2gEO/yanLtYegJ0=;
 b=Edtom/kqxgV3oUOwLxjxpvrZQA9G95UDL6I+imhTsMtR4WpWZr0oXwIF0cevOessqiq4AlXJn847WE5msZfQnC+lLFIlhWXrR0owURF4QsLDryEGQ44x42DzZiPqN/p5gG51yVxFlOpFooFTvUiEn1YFPKKicq99DCLcAJLEv2Y=
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3550.eurprd08.prod.outlook.com (2603:10a6:803:84::21)
 by VI1PR08MB3758.eurprd08.prod.outlook.com (2603:10a6:803:bd::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 09:55:58 +0000
Received: from VI1PR08MB3550.eurprd08.prod.outlook.com
 ([fe80::8834:fa36:9de8:e6e0]) by VI1PR08MB3550.eurprd08.prod.outlook.com
 ([fe80::8834:fa36:9de8:e6e0%7]) with mapi id 15.20.3955.024; Mon, 22 Mar 2021
 09:55:57 +0000
Subject: Re: [kvm-unit-tests PATCH v2 0/4] Fix the devicetree parser for
 stdout-path
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, alexandru.elisei@arm.com,
        andre.przywara@arm.com
References: <20210318180727.116004-1-nikos.nikoleris@arm.com>
 <20210322085336.2lxg457refhvntls@kamzik.brq.redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <6fdd395c-7a3f-763e-9da9-2c9515eae995@arm.com>
Date:   Mon, 22 Mar 2021 09:55:55 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <20210322085336.2lxg457refhvntls@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2a01:4b00:88be:aa00:e1b6:307a:e182:1112]
X-ClientProxiedBy: LO2P265CA0382.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::34) To VI1PR08MB3550.eurprd08.prod.outlook.com
 (2603:10a6:803:84::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from C02W217MHV2R.local (2a01:4b00:88be:aa00:e1b6:307a:e182:1112) by LO2P265CA0382.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a3::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24 via Frontend Transport; Mon, 22 Mar 2021 09:55:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b5a13e30-81c0-439c-b54c-08d8ed18b862
X-MS-TrafficTypeDiagnostic: VI1PR08MB3758:|AM0PR08MB4035:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB4035CB96CB1D22CD250B4DFBF7659@AM0PR08MB4035.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: umHzhuKDPVK7lPaMtq/Mc/rvw7hTFTA3ev2hyG6iGBBqGzCT1RSLqpmaeJpny2jJMkdkR7GyFByvcYSru+7jEx/FvAsiTVwELZ6gTh1JEMNkqiDvzcy0/C3RaBfTAQco97AnIeNYVNJQXKTC5JITdZtjhAFDeifsDG6nHDfkBG6OUwVmtLtFZytSZFlQAW7u8kQpoo7bx9tWxUMA2zNDx7Aqh9eHmhqfcTytYZOY6iUUYJ79vxhWB58PEHzPzf32wrcCzh4Lb9fiz045nUjag2G1Vw4tHhbso8RMqtiPPMm7Vktu/xMXMto6yb9HrRUXzivxZxchAqRJZP2MKsMGDS7fkh9o1IYJxCeuqZY1KjCMOSWurplgttUOcptyhxOitBLc6Ib6K+wGb7cdMKZPAMKzq3o+jEV4QKsJBhq2TSGzUd0XrdBuQ37JIrkL1DMvy+mep2ShM0ReyW7KO8Rtj0iuWIbiv1pB81qCk/oAn4c3LNepM3QycEwNMcIY+21cYjxNGNZKS8PjF0zf6tgLBrcb0s1pceeMtKPtYb98jXNpL5klTxb+zObv9SOtZNYtMqJQSHg3QIA64v6cuvlFCeZ4sHm+qXvAbJjWMr+0+1jOmupaEKcFMLz+hYcwDotutPE23mhXPNIjcC663oZwZrZYkaVyAGWQ3e45miJAvCSW6w3Z6Z8mrQ3DF/AvXI6sTjobxg1srtQ0IdmbBGpJi+0D0iPPXq/ENqI1tdgwK4u7ni1MRX1kJ7/d3XpV4zVa3KtGKNIz0CxZOXly5WPIJW4NBSC4gZohzn8oi9y43P8=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3550.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(38100700001)(966005)(31696002)(316002)(66946007)(86362001)(478600001)(6916009)(5660300002)(6486002)(2906002)(2616005)(4326008)(83380400001)(66556008)(8936002)(6512007)(6506007)(16526019)(186003)(8676002)(53546011)(31686004)(44832011)(66476007)(52116002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RTVBOEpDZEh6UVJSNWZtdG5WNnlSQlk0WTNQQ0hhVlU5LzR1ZWlNMWEwL1RK?=
 =?utf-8?B?YlVzNGlNRC96RVFiUDBiWUw2dkI4UlpNdmVwcmk3Slg0NWRXcWtrYloxeVlv?=
 =?utf-8?B?aWFaOUpvenJiZ2ZsMC9kcitpM3V2eERucGhBSmczWU9Oak1neE01YWI2SDcy?=
 =?utf-8?B?amtoWU5PNFU1NDg5Nk1BK0x3dnUxZHoyQ0phdXVWR0RCcjc1TmtHR3ovbFlj?=
 =?utf-8?B?NlNQbDNIVyt6OWgrN3BxREY1MnEzL0lCejEyOWFRU2t5THVGbGRxVVRQL1Vs?=
 =?utf-8?B?Y1h6dkZidHVyRkxtN2xLZ21ZeU56MTF4eG1wQW5TcU4vQTFxeXk4N1I3dVAr?=
 =?utf-8?B?SnMraXpLSUI0TXZMT2RHRjJrU3ltL0VKaXY3bnY1bnRiYUxmVlpHMlhwbktB?=
 =?utf-8?B?M2N1U2pRTjhWR3Y1NEppb0VldFlSeUQzV09LNVVlZG9qWlJScGRuYllpN21U?=
 =?utf-8?B?NTJHV3E2NFBhRVVrYmtKRnBWOEJyM0VaWmpEMXJvQlJUWGtOa1VKQlV5UC9J?=
 =?utf-8?B?SVYzdUYzNWlrbCt6KzBhbHdGbjFmc20wZFk5ZWl3T1lKN1I2bzV1Wjlwck1O?=
 =?utf-8?B?TTIrZktrRTNOMm00NXFYWG9xaUEya1JBK3MzR3hWOTdHb2ZMeW5RVHE2dGVq?=
 =?utf-8?B?bWF6c3R3WEl4aWRrN2IwaVdsOWx3WFdVRlAweFJ2cFZPQWVvcUliZmI1Sytz?=
 =?utf-8?B?OEIwUnFNRlVSVVNFa2l0d2hLQlc1QnhRWDExdXlqMXNLTVBrWWd0Y2hONy9X?=
 =?utf-8?B?QmVyY0xFeXZRZ3NyaXpSOGl6TSs2U1dKTU1QK25OMG9GMVJHckFMK3NQU3FD?=
 =?utf-8?B?STJuMHpLZ1NHRVhZVUVNVEFmYXd6MWJYUnRqYzBwdGdxRURPOGZRaXEwZmdD?=
 =?utf-8?B?c1h4RlY4SVBHOEIwSFBkMzIyYmx2VTRMMjBZaENIM0FMZStidGs0WG9rcTRO?=
 =?utf-8?B?bEZac2V2WjVJRFlXOHJpdytPcWVyWEJkbGFDSnpzSUR2OE8zR2ZMdG1tbUxE?=
 =?utf-8?B?bW42N21XTk1NMWZZWlI1UGxDM3BwQXBLamdLWTJpV08zL3lNVUNob2doaFJ5?=
 =?utf-8?B?aXVYbzJSc0ZIS0YwV0FLVm1uc0tWc3NSQURycEtrSWRldTh2dU1uV1djWkl6?=
 =?utf-8?B?V1ZxbGtEanNIOURsVEtlOVhvdUN6TUwydGMySnpzVThMZWpLQk84QWNGNHJi?=
 =?utf-8?B?ZnZaNEd0dW5FNmhodkhtZTVwYnJVTEZrRXZHNW1ZNHE3MXc2SC9NQThTb2Uz?=
 =?utf-8?B?d3VjbU45cG5PNXBhYjZWN1YvSVdjMXFaelBjbSttZzY5akZ4L0k4dzhXdFdr?=
 =?utf-8?B?TDhrL2g2VGNweGxaZWRmMllzRnViTU5hTU8zbm9naFVmeVpxU2VHZ1p4d29I?=
 =?utf-8?B?OHhlQTY1eUhjZ0tUWUdRVEkrWGhLeHN1aWFUY3hLbmNXQi85U2tRUTN4bVNQ?=
 =?utf-8?B?TFlSckZtaE5GdHhXN2w5N211djlNYUhQMERyamY5T0U4YThFK2JyZERiSWpS?=
 =?utf-8?B?TjFBSll6RVZZNURvdzcwSVZmTUtCKy9KZnRLMlVPSmVXVHFnd0t3OEVSdy80?=
 =?utf-8?B?Sk42TkUya1FCbDFJUUszdDRJNk9RUktZZUVjbDFzV3RIRUxrZnFDNUJmV3ZN?=
 =?utf-8?B?UlFETzdERnZUazRObXI5aUJmS2ovMFZmcGNCUnZLa3JHSHkzTHFFRzh4T0xs?=
 =?utf-8?B?RS9SL1FtcXkrN1Q1NEJLL0RPUTN4emtPR29VWVQ5Z2NGbEtBVDZlTitOU3hH?=
 =?utf-8?B?UWpQVWNnbVlMajF3NnpzWmJkTm5CVjcwdERCZXIzL0N0Qlczb2FxWi8vbGIy?=
 =?utf-8?B?bHZ5a0xHcHlGTC9tNUNKOE5ZYVVIN09URndyMWJMTVdxcVFUL0RUdHhNSjdP?=
 =?utf-8?Q?gVkIZi2gENItE?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3758
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 86ed800c-b5bb-4412-5152-08d8ed18b0db
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rli8CKNVcMoN0PqdK9z0lMy0bcLc7z/d7x5F32SYbkDArYa5Am7alWi68uq3M6NbEJgBZlLKgk5/IAZWLaVoDAgEtx1zDmAUJfRjllaIbfstsQI8uP/4O1lF18e+7wEgoFtK/mC2CZukvUov3IdYp02iMH7bHfpeJBeE4cfAZ7x0nCNLzVXKFQiKDDI7xS8Ypxp3VI9H1UjT5ZEPLCpsSFhkSe5/mMXlxHTHCTgjYt1sIKanHT2vAWgc/0vMH267pSFGZuM/KeZTM6vkd/EQaKgy/3ak3rEPwEdEh3YC0nxdprmk9SEsEM7Zpc4PYpMcyzrcf6wJj+4tH8/2p0KXGHO0FZ/3EA5yczntBIW3pW4XxNZJmmNDxSxg21ivszfDBQPTl7jpVPOI3EWHF7DyvrcVU/CIf8ywke5jTS1EmauqGnBTMWDUQgCOc6jiTORLQIEIcMq6++6AGj7e9kFuIdegts3NbTEuGDkXJTJj+bIPhQK5szab3Iqm+mMc5rMg92gN+yoLLqhLr/0QlBhZ2I2s9l7INlPm7MDv6KDsW1EVlOho1HWtcMBLp5eAKJnK5W4pfRgEmYgwXdGJlUIy3fjWYNETPSfeYNTEcNbWCeLJEnsE8a/RH49DnXvAwXksjUtCSbtswRqoWUZ1/hYgH61uAZ4aQy2hJQVcMPaTA09HhZql9dCTfCh0VBTYjb8QIySK97x3NhuShJFjlYw/4XQWcsBFJ/qDPXaVQ97w4FbMvnbJEr/zwwzNGGqEz6feSSrmu4Dn2l6+iHZ6QpWN+A==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(136003)(46966006)(36840700001)(6486002)(83380400001)(31696002)(8676002)(36860700001)(8936002)(478600001)(86362001)(966005)(82310400003)(47076005)(2906002)(31686004)(70206006)(70586007)(44832011)(316002)(5660300002)(82740400003)(81166007)(53546011)(6506007)(2616005)(356005)(4326008)(336012)(186003)(26005)(36756003)(6512007)(6862004)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 09:56:10.0100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a13e30-81c0-439c-b54c-08d8ed18b862
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT050.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4035
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/03/2021 08:53, Andrew Jones wrote:
> On Thu, Mar 18, 2021 at 06:07:23PM +0000, Nikos Nikoleris wrote:
>> This set of patches fixes the way we parse the stdout-path
>> property in the DT. The stdout-path property is used to set up
>> the console. Prior to this, the code ignored the fact that
>> stdout-path is made of the path to the uart node as well as
>> parameters. As a result, it would fail to find the relevant DT
>> node. In addition to minor fixes in the device tree code, this
>> series pulls a new version of libfdt from upstream.
>>
>> v1: https://lore.kernel.org/kvm/20210316152405.50363-1-nikos.nikoleris@a=
rm.com/
>>
>> Changes in v2:
>>    - Added strtoul and minor fix in strrchr
>>    - Fixes in libfdt_clean
>>    - Minor fix in lib/libfdt/README
>>
>> Thanks,
>>
>> Nikos
>>
>
> Applied to arm/queue
>
> https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue
>
> Thanks,
> drew
>

Thanks for the reviews!

Nikos
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
