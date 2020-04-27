Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF6D1B966C
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 07:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgD0FM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 01:12:26 -0400
Received: from mail-bn8nam11on2067.outbound.protection.outlook.com ([40.107.236.67]:6127
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726172AbgD0FMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 01:12:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZvueFpOtm+tOeN78IfpRwrhQWGli3lYrc5owi3HqixFdXrLvt318LqaLPRROdDmczdH3PAkwZpP/Sa7aOkfiqGnv6EG2azX/asDDBw+mvEO9ykCYfObrADenfKkxfuZaKz7n1MO8Ughx1BTCqs1U5HJL9266mAJypUYo8zHWKJqkzWXOYYRNy//KeTtTg+3/tJvTLMUK434IgZDzCVPcI7Gfy2Z3IxwXAOpLThW5fmBTwdjXQEmwJyj3C5aJjvckFiJ1Aw+CiqNJhgJhdZhyQpClbTFK0LPeoGwDzdyvHhz5uzAQv1viW8Ima8Tx6vrG13u16xesc8P//hSX7fDN1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3zjWIETJRdNjwitasByJov/Gnh2NmU46wjPxF+/0zo=;
 b=VL6Qa6Km2VYtMqvu3wI2oUBCdUIc//EYp7wN+agQksmCNbVgWAfjxwJOvYgJNH769B9y24IOuPRawgMgM1+aEJklk/tJY3p3cCoUGRmzbcIZ278WDmpqMmSm4jYJ/EFyfMbkSi4IuarQKG4OrAaY/CO+f+FmPpoyR+uwU5fr/bTr6d/wPYzNz2Mmx+F150oEMWVDgwgdq4X+DmDn5w8wUade3MDJCjbjsn55bcegRlFu/Ra4x9B0x1ArvXAx0Q+g2QzcSbN1ouVrrNvRnovZ+VBTQGAY2JzPdWJCBvbS4YqlWsiD1A7bLAOH5hXaEi4ytJvnAGxd74LHoxFxcanjEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y3zjWIETJRdNjwitasByJov/Gnh2NmU46wjPxF+/0zo=;
 b=OHmRklQSb/h2HRjSM8N2j0twCEoQXVY3VGVhQMuH/9JwP0okHd+zcCgifDBTs16/J17Ur0Zv8KFPfuS0Bf/SX+UuzYUSh981cNa4wGl/ZmyZq4UBs4nJ0dLw1m9yafhiz9LEb4V4cKF/8AHFKXbflu+4reYoKLcSzyZdhhW9BHA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1418.namprd12.prod.outlook.com (2603:10b6:3:7a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.22; Mon, 27 Apr 2020 05:12:22 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2937.020; Mon, 27 Apr 2020
 05:12:22 +0000
Subject: Re: KVM Kernel 5.6+, BUG: stack guard page was hit at
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     "Boris V." <borisvk@bstnet.org>, kvm@vger.kernel.org
References: <fd793edf-a40f-100e-d1ba-a1147659cf17@bstnet.org>
 <d9c000ab-3288-ecc3-7a3f-e7bac963a398@amd.com>
 <ebff3407-b049-4bf0-895d-3996866bcb74@bstnet.org>
 <f283181d-b8ff-0020-eddf-7c939809008b@amd.com>
Message-ID: <2cc1df19-e954-7b69-6175-b674bf12b2c0@amd.com>
Date:   Mon, 27 Apr 2020 12:12:12 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <f283181d-b8ff-0020-eddf-7c939809008b@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:820::23) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (2403:6200:8862:1548:7439:a459:2279:9a8d) by KL1PR01CA0011.apcprd01.prod.exchangelabs.com (2603:1096:820::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 05:12:20 +0000
X-Originating-IP: [2403:6200:8862:1548:7439:a459:2279:9a8d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a6c3dc7a-6ce5-4d23-46c0-08d7ea6990d3
X-MS-TrafficTypeDiagnostic: DM5PR12MB1418:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1418BF601F9800E05E07651DF3AF0@DM5PR12MB1418.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(366004)(376002)(346002)(66556008)(66476007)(478600001)(31686004)(558084003)(2906002)(36756003)(316002)(6486002)(81156014)(6666004)(86362001)(8676002)(66946007)(2616005)(8936002)(31696002)(52116002)(6506007)(5660300002)(16526019)(186003)(6512007)(44832011);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0kuWsb3sTOuC79QOKBWSnqg80b8Nwt2oNTBUNnLjtTnPMhuJUGPkfm2Q95JFnOI1PZyXZyRDs77CnuXV3iOiSImBLLtc+GMJy/rLZOBrELgR0tJjjL6tcbtdt0bWgKpTFjn4lJlbTq2KC0VGH5p9RUhQjKcvpcSPhFV2PLVzeawNfKUQxyw2P0yQZA3lOJYXp2oqee5qt+ccv6BWZCtS/dFA5jyiN4uRdIcLEQKksCq+Fzxz6/cpsVVa0uszIQtj227LdK3C7sRVabPU/+q6koTVB9B0Splj155xmaghrbuWvatDAffMBnZWoaYicvGACJYqTxxeIPv2QPedBLnwGtIKAZBezOMTsn6+FJsqOkLx8lvPFtpECs4Hu1DuWwDuXqJdgAHBS0w/8CFTIQc+yg7uc00pLjq4QNOgLm4qdU6iSkTR7ark0YzZ40vaKtnA
X-MS-Exchange-AntiSpam-MessageData: xJLC2jxkR2bTAf4UvjTnjS8tG8vjaWCoccJfMmNjqsbvM0mxSEU1lYl3C3MP1fkBiATXB4TsEDM0Z250pUqU0xl7jGU7eGNxdPnQ16+Gr5CI9MLP46Pce2aFNstKTTpoz6mqvzN6hv8yK1KTIzKbWsyRtf8dacOa5ctJgOE5TBD471x9bvf2AZmDEQblqDOKvAGjRhKS9DBwCaklAFjBA5B/jIMY/DwnK7//hHeoYYrN/ZJNrwSxTbTErya88ladQF7RhjuUwnkqy3FaPfLhHVTbknRSv59iBe0imqfRW1EnL0P67rTzWHi7FrSf8Z9qu9XkLIYJilVRmBQLSgJ/3DMQpKtRMH/tClzbEeHoxUZUr7LwKwoOHBEVAe4In5n/tBorA5xGWOPw52rsT0hV4AP7sjXAS5N9YWvmhFLLLkD19c+qsOd0klxL/LVuNqnN6HH/saHmtN0wL0+q6Iw5QkrPCsfukTvYeAn/vBUpwmLsztLkdZIHP5oSL7UmwYsMZwUmc0LJ5aluHgGv/brUuMN6orCVHR2MNU7DoLsKyDQifOtLXD+QVjPm7dw1fUaB4udKbcbLTCo6ex9GuPzvS5LXo/JwhxjfL2ceWPl4CJLpwiCszdIgvvJya/J44ciueiUKaUonNYMU4xSl1pc9Qa2qKPKcrCxkeDScyTqioxzEwX4AltRpNlVwuWIa5W9x7V7/BAxWSoTwTTfBFnPf++WaKmWAvVJg50IaylsKV7xwNlYcjF6hXR5XofYYh5LbLNq8ljsJC73mTgmxjQIAL/F6n5dn+tfh/A+rsqbTNyTGG0IqWwFeRMN5jcLg6M/BHwYPcIa+zoVLb3q3ztmE5h950xSuX/X61CXjaEcd7jS9FO5vs1nI9aWi0sH8yWB8
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6c3dc7a-6ce5-4d23-46c0-08d7ea6990d3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 05:12:22.1204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EcUTygGhlugR10bpRFSwO/pw0Fw59HprxTHh+6iw8mjMogrw2+PcGJFIbpSY/95V4DcD349towVBtGcwfQoP6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1418
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Boris,

Would you mind sharing your QEMU command line and how to set up the VM?
I would like to double check to confirm that this is not specific to
running on Intel system.

Thanks,
Suravee
