Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A063749340D
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 05:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351466AbiASEgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 23:36:49 -0500
Received: from mail-bn8nam12on2073.outbound.protection.outlook.com ([40.107.237.73]:13921
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1351481AbiASEgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 23:36:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ao+kjCl9EZhR0Wn4zGOevFU6YFddkBAU7ZXdD2LKTOe/dBqh21Sjef1R1E1J6GPusHfX/O6nAw+Zd2eDpaLoyPIJlX/pRy5YDFdcrpbJmLF77BGN2PhLOYSq0DFbIulsRtCt/SyzEHTO+/ehwrrSX3H1Np+5EpGvnGnfzKXe8ZscCt4JE1NccwDNlffFOaOdertV7Ca/19IP8iuxEXu6focE+o+JMaP+DteuE2MPOKRHwZujRdjfvByPDXHbbHWkY3nqVEJkwgfus8WqqaOUgZddjg59DotdmB+bxHho5TMcA2ACkOFw8MZ5lvgfNDUNvwU/RTIjWILMvNlPE/28Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1GH7n6peZsNYk7J/nlZmOhC5CIvmXDqEAGrb8BaW7E=;
 b=Azs6P7BU9W1WOkF08YuwFp3vEZbZZ8KtPXqHIn0Y7g9LH05t7ERhSVgWuVz8XhigmfQfhwA+xbPBveJBMGXwmW0L4qbOeu5EfblU8NEdodjDTvc4RJMboqgOMQnuiCwMcKDuQ+f3PPl0gGBThkIUv5+cNpkl8OlkFoV9QbzHBZp1PN1jL9lR7tsufHJMxlR0qh8CvrJZr3ZudZOywN1W0vj+PPGhYeYKzG907wU8YbMlhclH0zmv+Xi356nwUifG3WqF9wPnOSRFhycYPKqN05fFiGzzcFw29AcyLMNqZwkMyuZlUZ3T/QYN1bRCgo/mKPYXNpOD0yx4S2LPBNSNYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1GH7n6peZsNYk7J/nlZmOhC5CIvmXDqEAGrb8BaW7E=;
 b=KNjC71gvJ7ux3DS3qPeQCa9G6fI1DDj92V8LViLF0VeS97Xb1cYjCjM13DRX+pGOHY2yOyyNgPuMDMDq1ZCq+E8s3lHvL+I9wQZTDFlqwHL3YWc1U8AVfzPo4iFL/m+qA7mL/VhUxHKUb0du45Zb2zhsrf4mjWuNivBT21ivGs8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB4045.namprd12.prod.outlook.com (2603:10b6:208:1d6::15)
 by CY4PR12MB1509.namprd12.prod.outlook.com (2603:10b6:910:8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.13; Wed, 19 Jan
 2022 04:36:45 +0000
Received: from MN2PR12MB4045.namprd12.prod.outlook.com
 ([fe80::f4d8:4aef:33b1:1480]) by MN2PR12MB4045.namprd12.prod.outlook.com
 ([fe80::f4d8:4aef:33b1:1480%4]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 04:36:45 +0000
Message-ID: <598e5492-e049-823f-c2c8-e3b1d3eb5f27@amd.com>
Date:   Wed, 19 Jan 2022 10:06:33 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: PMU virtualization and AMD erratum 1292
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        kvm list <kvm@vger.kernel.org>,
        "Bangoria, Ravikumar" <ravi.bangoria@amd.com>
References: <CALMp9eQZa_y3ZN0_xHuB6nW0YU8oO6=5zPEov=DUQYPbzLeQVA@mail.gmail.com>
 <453a2a09-5f29-491e-c386-6b23d4244cc2@gmail.com>
 <CALMp9eSkYEXKkqDYLYYWpJ0oX10VWECJTwtk_pBWY5G-vN5H0A@mail.gmail.com>
 <CALMp9eQAMpnJOSk_Rw+pp2amwi8Fk4Np1rviKYxJtoicas=6BQ@mail.gmail.com>
 <b3cffb4b-8425-06bb-d40e-89e7f01d5c05@gmail.com>
 <CALMp9eRhdLKq0Y372e+ZGnUCtDNQYv7pUiYL0bqJsYCDfqTpcQ@mail.gmail.com>
 <4fd35b75-a79d-e6f6-1cca-49abda43206e@gmail.com>
From:   Ananth Narayan <ananth.narayan@amd.com>
In-Reply-To: <4fd35b75-a79d-e6f6-1cca-49abda43206e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0106.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00::22)
 To MN2PR12MB4045.namprd12.prod.outlook.com (2603:10b6:208:1d6::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46888e0d-3a49-44b8-bb48-08d9db054c61
X-MS-TrafficTypeDiagnostic: CY4PR12MB1509:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB150941A7A09EB9E88447354E85599@CY4PR12MB1509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bBJbE/lZxoHo/GV+91t+dbbgqszXNjMgj7b/rbBtgIS0rYTen2u/jV47nTNDA+lfYKvJZG2fjWaKNjwl4h/NwsWPCHVgfeW18JQKu5yje8teuzMzC2cv39ykUdbrYzahFh8Th8DZliHaz+daWrtwSduF9Y6PuWOu7/pHEw89NcZeeipiJk+F+G6jyqnqvoXg9naoPoFpawTsEDl5ZKISVx9hut5/TtzoVkMECCRVUuxsD39NvOXJB75FZiccw2idoip9QBivIP2dXsaL1/YgCloHlNdatV2mL8KbtRfAFdihYJ/Mjgn8Cph0qPw28nv4Vo+iDoDfI2B9Da36Xj4z4fzxssH42krE84y3D3YMh9Q7ID5cwBbw5dR3fxunyGOQ9LsjVl7V2jo7AdsRuCygZyxru4DAOmjNpQ+oW9vRFcHNEqDw6VqZ2eCuKUEocL1vi4ipXsi+vR9rxXYuXiv7Gh2SV+wccAMYvw4FUuvv9E0n4sFbCqWcPDpglq+Gj1MneWUm9SVKmgj24aBLj/C1JPKFKaxeefsh/rnEKO+t5BrTE1uJ+t2ZMMN89pM9r4x87HPxf541aYXmmEF33mFki4ZGoJ++5GrkQfjsmnaUHcy9q7D26plvUCboWa03YUtp/L7aCPjJ6c7zEtntsP0jHmRrkjyvDX5S9Q+pwmrcBfctXG11bqvMkmZEV8VO17KQpA3xqkVVtmrn4KWTuFI/vQ7iWi3vfQgBwP8jKBgh7Mg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4045.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(86362001)(6486002)(2906002)(53546011)(6512007)(31686004)(316002)(36756003)(110136005)(54906003)(186003)(6666004)(6506007)(66556008)(31696002)(8676002)(4744005)(8936002)(38100700002)(66946007)(66476007)(2616005)(44832011)(26005)(5660300002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFJJaW5wYWViSmc4RHZnY0F5dHNiUStBQ053c0hRenlId3lTSzZFa0w1RU14?=
 =?utf-8?B?UEhmbGRyd3YxbnJFSkdLSVo2RlNLUXJZL1NyNVdEcldTVXE2Uis3MVpSRUVh?=
 =?utf-8?B?Q2NPeHFyNjd3QjZVckdpeFJGQWpocHIzU05iNDZvWURncGZKSVRCRjFROVFO?=
 =?utf-8?B?Y3JMSllMYkpLdGlXMWRyTWtiSWE1czNwMWJtV0dGUjJBUWR2dzB5czR3SXY4?=
 =?utf-8?B?MGJiVXZEWG0rbHM3T0x2U3dHNDVpUEZQUFNjTXNTYUF1SHF3Qkk2QkY3ZEda?=
 =?utf-8?B?cDl1NWpxZjdYVkh5U3pkUkxmN1JscWVVN1ljRjlOYi9MWTMwQVFkTGtkTFp3?=
 =?utf-8?B?ZDhHc1ovWUgzNDJscCtsTSt1Tk9ocFB2bW5uR093UngxMnloQnMzeFpiNUNC?=
 =?utf-8?B?MW5BMTl0M1lsTVc3Zm1XUmE1T2IreHZiSXVvNjBwNS9CTUlmeENRbnY2ZFIx?=
 =?utf-8?B?Uk9rTjRuMVU2empWdWRyK2JsRVZPSHdTbm9hK3kwVGNqanp5anBsUzJnaHlD?=
 =?utf-8?B?b1k4bmZiSlc2MTdINllmWXNTSDV3WU1xYzY0bVhqWHF4dFRyKzNIOG1xU0xF?=
 =?utf-8?B?OFNxVjZuVVZONVJkMWpBVzc0cFBVTTZjU2RBL1REbWtMNG41cGd3bzNKSml3?=
 =?utf-8?B?azJUNlRCcnJONzJYNkprU25CUElTV0N4TXdpWWhxYUQyc0d1TDRaZzQxT21y?=
 =?utf-8?B?ZElqc2taYW5najhTb09JTWFNT0hsT3RRSGUvUG5LbkZxRm13ZVlhcm5GTmNq?=
 =?utf-8?B?Vkl0MDZIK3hyZDdZZkthcXl6dXJoUTVYWmFDK2ZneE5FTGh4NUxreWVjQWRv?=
 =?utf-8?B?aGx2VHViZWYzaHh2bVNRWndvaGh2YjhLMVJpQW9lSEE4Zm4xSWgrMzhBNndo?=
 =?utf-8?B?USthZDFvTW9FQlY3MENicXJQUzZDNmp3NXRHQmRwODRTeDBjMC9RdXI1VGFw?=
 =?utf-8?B?VkMxTGFCaFhIbldXUng5amtLN0paaGZVQUlxU0hHLzlXS3Q4YkovWGJxLzVo?=
 =?utf-8?B?Nm9QcWhKcVBYamF1YWE5NTZvd21ZVGFiMzBER0poOWJmUERNZDdJQ1R2NmdV?=
 =?utf-8?B?dXIrVjYySERoK3lZdS9yRXIwd0tUcG9KZ0R3TllNSWowb3FJdnU5c29xVWNY?=
 =?utf-8?B?ZUs2MG9mVWVoOXVqNmZSSmcrU05xMnF4RE5sOXBTK2x3bUxqSWd0dFFJNmZm?=
 =?utf-8?B?cGlmUUkyTUl5OGFaTmhRRkFad0FhTW9meXA3YkJhUndqbzdIdWZpNGpOZ2ZG?=
 =?utf-8?B?Q1hUMVdsM0ovZWl6WXQvbkY5amd2UEVpTTQ2aytWUlpoZGhEdUR1OFh1cHVI?=
 =?utf-8?B?YVo3dFJ4a2Vza0huZ3Z0VlRyNXUrRlJna2dQUFhGY3JFbHB2TXZTR2pYL3BG?=
 =?utf-8?B?QjY4KzhqT3JvbHM3cTAvTDluNjFhVHNqRmFhWnArQWhaYWxIRmR1V3BsWkVK?=
 =?utf-8?B?M0x2cUVHczl4RldHV08vTmQ1dFFUUmJ6M1J2aGttK1dVWjRoVkI1RXNHVEpk?=
 =?utf-8?B?MEIrMncrVGVpcGRFTzJQZzBnSDcvZkJCSlNJWHZzaXltU3htSXhkc2pEYm1L?=
 =?utf-8?B?Y3JYQnZQcXo4VU1GNnJZSjJuSlZlaUJOYnBaMEVXTEQ5T1NpcXM1SDVZZ1hn?=
 =?utf-8?B?VFU0WkZCdUV0aVZhdzlKUU1QeTFKeXIya2VkcE9LeWIxV2JuQzVleUx0ejlq?=
 =?utf-8?B?UnVqaXJFVTR1VklqOWdwWmZtbjFOeXRqdXdFalZmZUtPd082R1ZlUkliNGZ1?=
 =?utf-8?B?RTIyTk5yQlZjb2pNODluSEgvMXZIcnAwMFdkSWtzT0ppZ1N5K2RJYmdFVXpp?=
 =?utf-8?B?Ri85NzNDcXVQdVRocjVjeVRzaG93dmhoMFlicFNzRTdaWkFEOVV5ZjJScHkv?=
 =?utf-8?B?NTUvUkZEZlVtOHVwZ3A2eFZzckJWUmxLN2hFN01PT25hMmxzYzNhWG5aR09U?=
 =?utf-8?B?aXA5d2NINWpSOGYzU3dCMDM0N1FOY0ZJcTdHVkZIU0R0aDRJVHVKdTcvd20w?=
 =?utf-8?B?WHRaMlZkSWRZc3REckhDYjhJZGJ0dGxhV0xzbktBcDA3aWNkelg4TmYyOUVx?=
 =?utf-8?B?Q2ZmZG1neStZTFJWQmkrOVYvVDFBakRVZEdKWlUxR2s5ZEZIdDdUL29OaEc4?=
 =?utf-8?B?VitLYzBIU3hCS0YvQTFDcDdkVG5PSG9kT1lYMFptK0R1OXlQdFVqN0ZITHJm?=
 =?utf-8?Q?AFx3SqBIInZKxnN09sM0h+c=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46888e0d-3a49-44b8-bb48-08d9db054c61
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4045.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 04:36:45.6490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vE6XTILa6D7RUuZIU0cjK6XS7UxenTqwN2PKTHCqJH4jn826qwMWNKWDHfRbwmPkW+9odAbTvaevYw5YwC8fDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19-01-2022 09:24 am, Like Xu wrote:

...

>>> In any diagram, we at least have three types of "reservation":
>>>
>>> - Reserved + grey
>>> - Reserved, MBZ + grey
>>> - Reserved + no grey
>>>
>>> So it is better not to think of "Reserved + grey" as "Reserved, MBZ + grey".
>>
>> Right. None of these bits MBZ. I was observing that the grey fields
>> RAZ. However, that observation was on Zen2. Zen3 is different. Now,
>> it's not clear to me what the grey highlights mean. Perhaps nothing at
>> all.
> 
> Anyway, does this fix [0] help with this issue, assuming AMD guys would come
> up with a workaround for the host perf scheduler as usual ?

Yes, that is WIP. You'll see a patch from Ravi.

Regards,
Ananth
