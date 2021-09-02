Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9023FEC23
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 12:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbhIBKaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 06:30:09 -0400
Received: from mail-eopbgr130048.outbound.protection.outlook.com ([40.107.13.48]:54503
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233716AbhIBKaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 06:30:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPBLBnvQCRfuLHSfFTIenFptxafHmFmUT3Kn0pUI+2U=;
 b=FV8d4C/WTJL/4Sq4UM/1t57ToblXGiGwczIYoqAaL/Y/NmLd/Whtc8eA/RPPvl0xx38oVMhdRwNo+jrSU4EZmOSJkTmzrSysfN82NVZNEECyae4ledrJUdoreZr7v6CtoMW+Rikm4r5ZVkJMVAbWjs0F6ohk61sizbsL4tL15Pk=
Received: from AM6PR10CA0053.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:80::30)
 by VE1PR08MB5630.eurprd08.prod.outlook.com (2603:10a6:800:1ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 2 Sep
 2021 10:29:04 +0000
Received: from AM5EUR03FT048.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:80:cafe::a4) by AM6PR10CA0053.outlook.office365.com
 (2603:10a6:209:80::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend
 Transport; Thu, 2 Sep 2021 10:29:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT048.mail.protection.outlook.com (10.152.17.177) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19 via Frontend Transport; Thu, 2 Sep 2021 10:29:04 +0000
Received: ("Tessian outbound 1a0c40aa17d8:v103"); Thu, 02 Sep 2021 10:29:04 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: ed9177ab0ca57cd6
X-CR-MTA-TID: 64aa7808
Received: from 04e66dde62c2.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id E1A65119-953D-4C3B-BEB3-DC248FF5A515.1;
        Thu, 02 Sep 2021 10:28:56 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 04e66dde62c2.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 02 Sep 2021 10:28:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KyRfcwt0RezgTyyQh0Xw9cmxAVnu9J5lFJtqP3FIqifcpp5OlZPMtNqkdmareiBRM+w97ZbMgdduVH9bHPuUdvH88o9qzdmpDU08kPplH0IHJfVrI53xqdRnPlWQmK6ELInkQ1lZ/uHkBVyURbDr4sII01BWcBRv7rKfeuJZYkoLRBrNOhy5z1QusBriA6z/le0dpmw7u2Dxx64OWUM1dGIsIRf0gjiNyDzjScUcZwdXRElDDlxZ/eCnUfrZRK7f1e7SQbDrbI8UpkKhJPHPqC+YmpIlMtDn/BWOBSyo5rqR3Kmw3DilyZgG/qJCnK3TQkCRKFnfaVhkaL/GWZPbOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pPBLBnvQCRfuLHSfFTIenFptxafHmFmUT3Kn0pUI+2U=;
 b=nDIubUA4zh5g2uuuseSOzDXPo1583dpIW9gAXiaBmRH5vyB6wOop1bndPK14KOB8VPyIpxYxrOeOMu1QjJ89GmsKEZuTa9LuLGUypzG2DRfBJ/r+ssjPcp4WOQ9uYWFcv5YaNmYYqfb0gIsWn/y9FwADFdclz9WCZhCCvdwn5dx2jFDFAIKw7/FOzucAlCzxFJkcXeZxaurfiE+mGQqOXcWGowYU+wnt4F+HPma+w96MdU47mndm3Cqu/j5GF7JLqr0yFTbIpI/OKJECy8x7JuZhuOpf+oEHIz9D10wh6E9H5pojNpRCxSO2i93wjWrg/+Rn9RPSQBkLL1+36Ew4zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPBLBnvQCRfuLHSfFTIenFptxafHmFmUT3Kn0pUI+2U=;
 b=FV8d4C/WTJL/4Sq4UM/1t57ToblXGiGwczIYoqAaL/Y/NmLd/Whtc8eA/RPPvl0xx38oVMhdRwNo+jrSU4EZmOSJkTmzrSysfN82NVZNEECyae4ledrJUdoreZr7v6CtoMW+Rikm4r5ZVkJMVAbWjs0F6ohk61sizbsL4tL15Pk=
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
Received: from DB6PR08MB2645.eurprd08.prod.outlook.com (2603:10a6:6:24::25) by
 DBBPR08MB6235.eurprd08.prod.outlook.com (2603:10a6:10:201::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.20; Thu, 2 Sep 2021 10:28:54 +0000
Received: from DB6PR08MB2645.eurprd08.prod.outlook.com
 ([fe80::5c52:c63f:275d:59b6]) by DB6PR08MB2645.eurprd08.prod.outlook.com
 ([fe80::5c52:c63f:275d:59b6%4]) with mapi id 15.20.4478.019; Thu, 2 Sep 2021
 10:28:54 +0000
Subject: Re: [PATCH] vfio/pci: Add support for PCIe extended capabilities
To:     Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>
Cc:     julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
        alexandru.elisei@arm.com, lorenzo.pieralisi@arm.com,
        jean-philippe@linaro.org, eric.auger@redhat.com
References: <20210810062514.18980-1-vivek.gautam@arm.com>
 <20210831145424.GA32001@willie-the-truck>
 <4f5307cf-0cea-461a-838f-85e82805c499@arm.com>
 <20210901104451.GA1023@willie-the-truck>
From:   Vivek Kumar Gautam <vivek.gautam@arm.com>
Message-ID: <1891648f-cd80-1066-5d4b-9774ca1923bd@arm.com>
Date:   Thu, 2 Sep 2021 15:58:47 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210901104451.GA1023@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: PN0PR01CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4e::12) To DB6PR08MB2645.eurprd08.prod.outlook.com
 (2603:10a6:6:24::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.162.16.71] (217.140.105.56) by PN0PR01CA0030.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:4e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Thu, 2 Sep 2021 10:28:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35e2695d-2dc0-4d1a-c182-08d96dfc7ce7
X-MS-TrafficTypeDiagnostic: DBBPR08MB6235:|VE1PR08MB5630:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR08MB5630E6180B8D3C2980B71DB889CE9@VE1PR08MB5630.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: cajGiRZU36w0PIMacjBHql2uKdI+JBQv+StkHv9pUZtNVOUH6oOk25LiMqDFVRk8Lp2EIiZ0nCdMGO3M5ZsL6eHIEQfuNB0vViX1Pgt3B5stlkWA7gEegOI/31+34jKl5D1gs3li3BPg3+/yX4yNg7hUNFc2xEad4pL6o9e6VcsueqUJDHd3PJbKiZRWukp4g0MILqmvIRBDDgNwU/H+PiMkQ5PpS1uc/raQi+b7B3bxT2BCQYT7wvWmdUbjZ0IAFLsJS2KLGf051asPCFSutBTGHPUuR/kK5f98wSeZgZZ67KEbmYrbLCuYWnFHBbiGpiN/9i9VcPE0xHfuZLRbaG8veeW6xfZ0ZNcqL58zQq/o0EA/k6HI59fS9RkRxZmMfv3hrrH1AqrZrH6QG9lpz2XQP6S6GlTsJrCug95jmcBqO8Om5YTs5eFHA6Em+BB4iIMIMVXpX2mDWj1wYUVtjrOZfXROuAA5HbR7nJ7rWjU+NcmcQJLFqvnxby2EqDXBE0atz1vkovwmpNWdZIIdIGwkwu/DMIdCa/ToASXAL+7x5mB5vBjTcatgGoJnBGUlPdFPTGTSFgJfYQ991+dxVua2A9SGEBMH0IJWKG/biJIfeQOXG+1yaNG0eXtuqeanH7rGwIamjhLzdW0N/n9i0IYLscqpASzQA0VYrqChyCzSk5CRxvWRGs4EiwcVQHi3tqISDLn7jLPRlkptRvuXo9sQvJLu+sckXuM1DL2s2/SOXIANdov3/pIMqzNmmnglct86jki4j71udf27KC7Ouw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR08MB2645.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(136003)(376002)(396003)(478600001)(66556008)(66476007)(66946007)(956004)(38350700002)(5660300002)(31686004)(2616005)(8936002)(8676002)(4326008)(38100700002)(6486002)(6636002)(6666004)(86362001)(31696002)(83380400001)(2906002)(36756003)(26005)(52116002)(110136005)(186003)(53546011)(16576012)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGJ0WENYVjRKOU5TRUdoUXBvdzhGNEd4WDZpdjJGd1VRNlo5cFFvN1Bwem1x?=
 =?utf-8?B?TkJCYWlFR2NhTENFbkRJRGczVUdyUmNRaFVMRkhNd0RKS3dpcTEvMml5TEFk?=
 =?utf-8?B?NmVGZDdHdUN2Q0tSRWQxVlJOUHVTaUo3QzdiVGE4MVhrblVEd0lEakdXVXFu?=
 =?utf-8?B?TzRLUEFRY25CZGg1NXduZ05wQlZwbmlQdVpiZ3RiYXhsQytzTUxyZzVLalBX?=
 =?utf-8?B?Sm5KQ2NTYytXZGx0UE1nNE5rRUNCclpkeUEybE5kZ1B0dk9iR0lrRUdONGxB?=
 =?utf-8?B?RGl2VzA4eEQwSlhHRDZOdW9FVXZOS1h4aGJZOXRTbGVPTFNYT0FuWkp2OGo0?=
 =?utf-8?B?Y2g1ZlRKUENkcFFtNHkyZ0xZNTN1MWJ0c0F2eVZJSU5JZ3oxQ1ZyTFkzZnBL?=
 =?utf-8?B?SzJDM1hvRXJNMU9LTHhqOFRSNjJSSE1HYklpNDRqVjRMdWg5UG0zRkgyWGRl?=
 =?utf-8?B?OHI3SkxuWXZjQWVjbmdFWWFoOWszTSsybXNUWnM0QVFSTHFxcjBxRVpIWUlX?=
 =?utf-8?B?c0JuaFR1YjEwZ0hmRmJKWTFyVFV0Wi85eDd3SWRiUkMrbGo4ckh2V1o2bGRI?=
 =?utf-8?B?bFFiZTBzRjd0NHZyZWZUN01MVisxZFVTY2xrNVRqMzJiTllIWStmcEU1SlhL?=
 =?utf-8?B?L295U3F2dXR6LzBDNU1EVGtkTm5QUy9TVldqRFI2c2ZEVmtJNDRPVzN5UXg0?=
 =?utf-8?B?TkRGYllxdWFjWDJJZngxcmhOME1EdEYvM2RZV1plckRYVzZNdUxxN2FxSkF2?=
 =?utf-8?B?cmErMldJV0hwSlNmYi9GN3g0anJPSWU5RE5lVjFyb2RoeFNseXF0ZVBTcEhh?=
 =?utf-8?B?c2FEdDFhbzU0WmduaEJ6cjczMlhXNkJKT3hObnV4ZmtRd0lUcVBoRWJqemxV?=
 =?utf-8?B?M0xvcGw0WU5aZTcycTRQcFduWFI2NEpmOVZrOGJuRDJCU0JMQ0tOQTF2dFhF?=
 =?utf-8?B?aHdhLzB2ZXJMazA0aDFtNWRTK2hOa2x0Wjc4V0JRTWt2RS8rK0dBTVNiWFRp?=
 =?utf-8?B?OVdwNytsbG1pMWNRVXRvRWZUa25raWFEVVdOY0RyMyswR04wZXdmRDNqazBp?=
 =?utf-8?B?MDMvZ01uQ2d5K1BMS2NEbkJzd0Q5cW4wM09nR2t3RU1kbWUwNUVhWUZRNTgv?=
 =?utf-8?B?aVhVeXRuTWhWT0lVeVpMQk5kemNYQ0ticyt3YXJBdWlKazdBUEZmOS9FaGRF?=
 =?utf-8?B?aGRrMjBDZzRUQUo1ZXk5Q3R3N2VwTnFwbHFZV2V0dkdDUnVibTdLMndtbnFz?=
 =?utf-8?B?QzNrOVpybXJzd2dRWE5mMmcvT01xbGZ2TGs5MjYwdDJLa1kxTzA5TjFCbHIv?=
 =?utf-8?B?aTlCNENuY0U4Ykw0UzFCc3FUeTFId2cyZ20rdks1LzVYcDJVbHM3VmZRdGhI?=
 =?utf-8?B?RWc0MG5WRDhxOVQ4TVVKSmRYQzV3RDU0ejJzejJWeW1MSk1LM3k4U0E3a210?=
 =?utf-8?B?Y3cxeWlScmRGZ1BhQWh0S1FMUG5MTGFNOU0yVEZ4eHE1RFRUK21vRnZoeFhR?=
 =?utf-8?B?d1FIWDJpQThFTjZWdlhaSnZGK25mNG1vazhUSGx2endwWDErWUtZSzdkL2Iy?=
 =?utf-8?B?VmNzY1FXSmV3amlUa2JVVTB2RmhPTExsV3prZ0MvdWthdzhvTFJpUG9XNGFD?=
 =?utf-8?B?bnorRTNpdzkwclhvWDJvKzJGTnNnNlhXWEFFS3d2cXV5M1hxN1dvQU42U05H?=
 =?utf-8?B?OG9hRjdRR0krMnQ0cE9FTElEU01yUTFlUmFqNDJYVXlCbHN2NDljaEprVjBB?=
 =?utf-8?Q?P5Nl1sk/U+Y6HC4q9yX8hPFlmrqW/XQCN+dSUKl?=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6235
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT048.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: a069c334-57a0-40d9-b88d-08d96dfc76c0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y9PJ3b62Hf1Xd+JHkIu/EbnBJdk283X6nAFHDseBEVbGCqQqPkIR0ER1QZrup5mPz87U05FpcDHfX8RWRz659XrlvRo6Tb8YwilUp9uo2MgNYwCJ/wVeC0Nz5LyU/e3+6FqdaTOfwATjnbo3MXgYSbNXrhgf2W/0MLcSBA1Radf36umscaP7nn1DT65E3677bodfm0pFOcXRaPFkQaEn3ALKrU8Cqt2cOjFNCwKtDRkOgSLxWxbF5XQDFk9/pX4wfe2WOFzG9i3r23wT91Kj59JrCp8QQiVP7kOqmf4OaHhLhGgAYONMwJseT/hwCzGzTnH+TR1vxwo1fMqqAVIVMLj57ZUXdAz+Gxc930JXUcvWZwA1u5BM+9QZJEstXJ9G22IU6vn1I0t28SNFZgO1lAp8H9hCfuSuYVArpS6RHgtLM7EnkG5gxdDUIPl3miG+W2f1qa1rByZmQ6TtAWXzI0qQt2OLEKjRQ0SHXt8AXmvXG4IBl1fc5jZ3m+ibB6FzvHLwKwelKWLuZe9AACBJaesL79I8tveGvt8GLmSbSh+yOj+i1y+NTOLYWYD6Ou6O+es85WuI+7oPIG1ofgiAFIi4Yb1BocLskYaH9+ePE+BVLBjoVHa99GVmRfQpixNDSrPK+x7OfHJ9p8+hmTwXDVDjJ5Hn1PiP0bvu3mthgkF1nOBL+LblqHoE2RljpqZ6t6bqgT3PLE1AQ0ATRe6Ss+85Ag3CbIzVQNgwBw8WdC0=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(956004)(6666004)(70586007)(2616005)(8936002)(356005)(186003)(31686004)(31696002)(86362001)(2906002)(336012)(4326008)(6486002)(82310400003)(36860700001)(53546011)(70206006)(6636002)(8676002)(83380400001)(508600001)(110136005)(16576012)(81166007)(316002)(26005)(107886003)(47076005)(36756003)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 10:29:04.3615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35e2695d-2dc0-4d1a-c182-08d96dfc7ce7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT048.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5630
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,


On 9/1/21 4:14 PM, Will Deacon wrote:
> On Wed, Sep 01, 2021 at 11:27:21AM +0100, Andre Przywara wrote:
>> On 8/31/21 3:54 PM, Will Deacon wrote:
>>
>> Hi Will,
>>
>>> On Tue, Aug 10, 2021 at 11:55:14AM +0530, Vivek Gautam wrote:
>>>> Add support to parse extended configuration space for vfio based
>>>> assigned PCIe devices and add extended capabilities for the device
>>>> in the guest. This allows the guest to see and work on extended
>>>> capabilities, for example to toggle PRI extended cap to enable and
>>>> disable Shared virtual addressing (SVA) support.
>>>> PCIe extended capability header that is the first DWORD of all
>>>> extended caps is shown below -
>>>>
>>>>      31               20  19   16  15                 0
>>>>      ____________________|_______|_____________________
>>>>     |    Next cap off    |  1h   |     Cap ID          |
>>>>     |____________________|_______|_____________________|
>>>>
>>>> Out of the two upper bytes of extended cap header, the
>>>> lower nibble is actually cap version - 0x1.
>>>> 'next cap offset' if present at bits [31:20], should be
>>>> right shifted by 4 bits to calculate the position of next
>>>> capability.
>>>> This change supports parsing and adding ATS, PRI and PASID caps.
>>>>
>>>> Signed-off-by: Vivek Gautam <vivek.gautam@arm.com>
>>>> ---
>>>>    include/kvm/pci.h |   6 +++
>>>>    vfio/pci.c        | 104 ++++++++++++++++++++++++++++++++++++++++++-=
---
>>>>    2 files changed, 103 insertions(+), 7 deletions(-)
>>>
>>> Does this work correctly for architectures which don't define ARCH_HAS_=
PCI_EXP?
>>
>> I think it does: the code compiles fine, and the whole functionality is
>> guarded by:
>> +    /* Extended cap only for PCIe devices */
>> +    if (!arch_has_pci_exp())
>> +            return 0;
>>
>> A clever compiler might even decide to not include this code at all.
>>
>> Did you see any particular problem?
>
> The part I was worried about is that PCI_DEV_CFG_MASK (which is used by
> the cfg space dispatch code) is derived from PCI_DEV_CFG_SIZE, but actual=
ly
> I think this patch might _fix_ that problem because it removes the explic=
it
> usage of PCI_DEV_CFG_SIZE_LEGACY!

That's right. On adding change for PCI_DEV_CFG_SIZE the entire
configuration space can now be read. With Alex's change for PCI Express
support PCI_DEV_CFG_SIZE can be either PCI_DEV_CFG_SIZE_EXTENDED or
PCI_DEV_CFG_SIZE_LEGACY depending on arch_has_pci_exp() check.

I booted with enabling and disabling ARCH_HAS_PCI_EXP and was able to
see a passthrough device getting detected fine in the VM. Logs are below.

With ARCH_HAS_PCI_EXP enabled  (master with this patch):
--------------------------------------------------------
# lspci -vv

00:00.0 Unassigned class [ff00]: ARM Device ff80

         Subsystem: ARM Device 0000

         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+

         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-

         Latency: 0

         Region 0: Memory at 50000000 (32-bit, non-prefetchable) [size=3D25=
6K]

         Region 2: Memory at 50040000 (32-bit, non-prefetchable) [size=3D32=
K]

         Region 4: Memory at 50048000 (32-bit, non-prefetchable) [size=3D4K=
]

         Capabilities: [48] MSI-X: Enable+ Count=3D2048 Masked-

                 Vector table: BAR=3D2 offset=3D00000000

                 PBA: BAR=3D4 offset=3D00000000

         Capabilities: [54] Express (v2) Endpoint, MSI 00

                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us

                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
SlotPowerLimit 0.000W

                 DevCtl: CorrErr- NonFatalErr- FatalErr- UnsupReq-

                         RlxdOrd- ExtTag+ PhantFunc- AuxPwr- NoSnoop-
FLReset-

                         MaxPayload 128 bytes, MaxReadReq 128 bytes

                 DevSta: CorrErr- NonFatalErr- FatalErr- UnsupReq-
AuxPwr- TransPend-

                 LnkCap: Port #0, Speed unknown, Width x0, ASPM not
supported

                         ClockPM- Surprise- LLActRep- BwNot- ASPMOptComp-

                 LnkCtl: ASPM Disabled; RCB 64 bytes, Disabled- CommClk-

                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-

                 LnkSta: Speed unknown (ok), Width x0 (ok)

                         TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-

                 DevCap2: Completion Timeout: Not Supported, TimeoutDis-
NROPrPrP- LTR-

                          10BitTagComp- 10BitTagReq- OBFF Not Supported,
ExtFmt- EETLPPrefix-

                          EmergencyPowerReduction Not Supported,
EmergencyPowerReductionInit-

                          FRS- TPHComp- ExtTPHComp-

                          AtomicOpsCap: 32bit- 64bit- 128bitCAS-

                 DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
LTR- OBFF Disabled,

                          AtomicOpsCtl: ReqEn-

                 LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance-
SpeedDis-

                          Transmit Margin: Normal Operating Range,
EnterModifiedCompliance- ComplianceSOS-

                          Compliance De-emphasis: -6dB

                 LnkSta2: Current De-emphasis Level: -6dB,
EqualizationComplete- EqualizationPhase1-

                          EqualizationPhase2- EqualizationPhase3-
LinkEqualizationRequest-

                          Retimer- 2Retimers- CrosslinkRes: unsupported

         Capabilities: [100 v1] Address Translation Service (ATS)

                 ATSCap: Invalidate Queue Depth: 00

                 ATSCtl: Enable+, Smallest Translation Unit: 00

         Capabilities: [108 v0] Page Request Interface (PRI)

                 PRICtl: Enable- Reset-

                 PRISta: RF- UPRGI- Stopped+

                 Page Request Capacity: 000000ff, Page Request
Allocation: 00000000

         Kernel driver in use: smmute-pci





With ARCH_HAS_PCI_EXP disabled (on top of this patch):
--------------------------------------------------------
# lspci -vv
00:00.0 Unassigned class [ff00]: ARM Device ff80
         Subsystem: ARM Device 0000
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0
         Region 0: Memory at 50000000 (32-bit, non-prefetchable) [size=3D25=
6K]
         Region 2: Memory at 50040000 (32-bit, non-prefetchable) [size=3D32=
K]
         Region 4: Memory at 50048000 (32-bit, non-prefetchable) [size=3D4K=
]
         Capabilities: [48] MSI-X: Enable+ Count=3D2048 Masked-
                 Vector table: BAR=3D2 offset=3D00000000
                 PBA: BAR=3D4 offset=3D00000000
         Kernel driver in use: smmute-pci

Let me know if you have concerns.

Best regards
Vivek

>
> Will
>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
