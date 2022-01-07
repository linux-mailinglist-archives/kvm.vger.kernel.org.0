Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1644871AB
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 05:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbiAGEFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 23:05:36 -0500
Received: from mail-dm6nam10on2060.outbound.protection.outlook.com ([40.107.93.60]:7484
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231232AbiAGEFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 23:05:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBWqoM1QfTemb/IHL1k0zhVdEnWXDpmzF9btqs8X3xE+e9Jw7CKrc68zO8RFX3UrGqm1BDCIm6gU2O/EDf8GFxShY8IBb5/ZYMt0KfeQV5DnibGhABjFWAMXhx2eyBxUVqMzEB81IbkuvLGEO6bE5wBIG3g5pZA3tubpD+c+ZloDMZ3bAXH0hcUNHK7AM1A05YtYAp5LuZvsCEUFYxe3d6wjHW01LsPGyI8XcWcIV591KxXkwwm9hc5Vn4a657XURBnClzdhcebvtZGr2UgrJG4nDSaQahsjCwYurFOstehRZRxcwpPsLv2pN6Sf2u/rODBIDlKAVGuZbPTV1iFzgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4rr7zZsmfDOX5isPbIrnfMY0Z+tg1ABrgk0XauAuyYE=;
 b=OuV6ZlFn6knWT7MrkZFOnWyYv9dbtwBqeVK2pa6gefIR7slXiAYysUwMkjf4yVNVjkwKv1pqdA1gUZrgDJY2HfINsQq2ZuiQrkVZVQioQGFGN505iWojJ4gbI/dqHJhHZJziOivjxQD/VPxAneu+9LjIFUEuyw76gRAGnVJbzyhx9qhYD/02ka6udfr1BtQkjlkssgikm7vypuUo9yzsuK9SDjKOx2h0rLXF8vMmwqd3hCJABNITZRjiAFTd+WtVkqfQsqh0V6dMYRQRJWOBPxXqe4H1RszJGTZWcm7zk6zYdKYu7BgzXRVmwIdn+KjqAlPYPNSrDM/TjM8Xt4zQWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rr7zZsmfDOX5isPbIrnfMY0Z+tg1ABrgk0XauAuyYE=;
 b=4yifdYsNyhglDE8uXf9N+7whhmMgEUhDp6TQdwwcK+nvAJ2491ahzYZp7/1KxOrxIlG9Sy2u1o9G7ZfLUNYOxGPVfI+IUfRkkxw0HvfQFteT567/RWklk6BGDxwf1zgXYoiE82VR2SM6AYzmXnpfKz47OPM1HYpnnYhdSaQMyGk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18)
 by BN9PR12MB5321.namprd12.prod.outlook.com (2603:10b6:408:102::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Fri, 7 Jan
 2022 04:05:33 +0000
Received: from BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::802f:ed0d:da05:5155]) by BN9PR12MB5179.namprd12.prod.outlook.com
 ([fe80::802f:ed0d:da05:5155%5]) with mapi id 15.20.4867.010; Fri, 7 Jan 2022
 04:05:33 +0000
Message-ID: <613f1a7f-fc4b-b5e1-9cad-a2748abe8fb8@amd.com>
Date:   Fri, 7 Jan 2022 09:35:22 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [kvm-unit-tests PATCH 0/3] Add L2 exception handling KVM unit
 tests for nSVM
Content-Language: en-US
To:     kvm@vger.kernel.org
References: <20211229062201.26269-1-manali.shukla@amd.com>
From:   "Shukla, Manali" <mashukla@amd.com>
In-Reply-To: <20211229062201.26269-1-manali.shukla@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0041.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:c::27) To BN9PR12MB5179.namprd12.prod.outlook.com
 (2603:10b6:408:11c::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5df3e659-461c-4aae-a5dd-08d9d192f386
X-MS-TrafficTypeDiagnostic: BN9PR12MB5321:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB532156E7735F556195AC8A6EFD4D9@BN9PR12MB5321.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iklb0zaiN7eUDsmBsJu7xaq/cvmjc90qzWxA7UTF+GuCRuqbLKIn4ySqkX5qln3XVF6+8wxJWT0Y3H35SFbP+HNqWY4Z3UAH7EUPrkEJZ1Qwbf+L63WVqL6Vd0gzRmtYgaCRiiQfcz0SSc0B36lKcmxJy6ocWKNanUG6SxnrUEX1WMxORrhVOMKk+g4EqR+X4l31zA8ZcifC9xAxAs4mBThoivhFA6RQbpyxv85o+jiRWTuMwSr7xBPahbhL+VaoJnbHPNEWht7cNsTBSuzt9+g0l4zR7L1RIeIXZj0s5Ds6s1Rf17g6yxWZG3nEB+TYv+1Khq6TdnHZ2pEMslj3ujS06bmQoeeIFOw/1wgxjjL0zY8iAGDMIc2VQyBqn9rUodzyCfkKAdDbawAVlb1UWrvMGWkvMg/U3/0T7fKT7tw1cO8LSzKpNeVuH2t+J1iHgDsKugIjdxbmaP93WdO0ZWEsKNnvtosJg+0QPmebRtiAkT1KpHWhWwFMfK2hb/o1EYgnJN5PMOGb8+KCwQ3RTdzrrjd1mVQSLwQKebrQz3hqwvEwzMoIbWTsvPI/Nl0zU25WDUVfTS2ZfuQVgd8/vCWUIdfuWwQ8Gn1LJCZxz7IWuh6mZKK1ChAj6FtqxwkX3A9LWYrPrmzHo+PDhrnMal/4veI6FTQ/4uELAvHYEBqiPihZhdxYIKlRp4lhOE2L6T8enXZjh16hbbB9nN3Oe8m1OvLOVH3uqHVzimaHROuTyxYnAE690BmQ2GZNk/iY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(66556008)(5660300002)(66476007)(6506007)(26005)(8936002)(53546011)(31696002)(6512007)(8676002)(508600001)(36756003)(6666004)(6486002)(4744005)(38100700002)(66946007)(2906002)(6916009)(2616005)(186003)(316002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGJkRUxtS3JFWDF4RUFUZ2JweVI0MVFPN0FMQ2lrT1dJUTh0b1BGakV1K2VH?=
 =?utf-8?B?QUx1dlYxVmtWWnJiZW13T21vS0VDZTVnd2huSThBU2YwanJvV0JKYU5zNmxj?=
 =?utf-8?B?aU5YRDJhYk1CNHBjd3V3OEZEV1ZiTWhEWG80L1Z4MFU4QmhhZ2VQOFhnb1gz?=
 =?utf-8?B?blBVNkU5a1ltUDJGTEVtVW9BZy9yaTczb0hTV0hrYlg1RUY3bzgzRUViSXNo?=
 =?utf-8?B?N2haM1BjcDBPSkFEeTRSWFhxb080cTRFTWhlZGVhd1E2NVk5N2hucUN6WFV2?=
 =?utf-8?B?cTRON3RtY2xqeDh0RjJlR3JndzVaaVpsdHk0S1lBZHRzVWM3MXFJL2JUS1hr?=
 =?utf-8?B?bTFPblR6WUU2cjdhMVVxTWIydC9FN2pIZzdKayt0QkJrY0toQTFwREMvL2ha?=
 =?utf-8?B?a3NEaXZWRXg4c2xwR0t4RGNtMGI1SnREREtucUlOL1l5aHNJOFZwRkQvem4r?=
 =?utf-8?B?NmFIQ3lZTWdWY3BRNDRjclh3K2MwUmpMZmJhZmY5eXdxNm55Tk1QYVA2U2wz?=
 =?utf-8?B?RFpISUtEa2dBV3V3TTNISDkyVFZLNkN2MFpkK0drd1g3cFl6RitrKzBzdVBB?=
 =?utf-8?B?THNCU1NzdGNOOTBEaFYwVWhGb3o1WFVhV1JoSjRkYTlNOXprYUlta0NnVHBJ?=
 =?utf-8?B?L0ZtU2lIbFU3Z014dmxINncwRklZdHRFR2RtTElPZHE2YTVMb2JXc0VNL1hn?=
 =?utf-8?B?VGY0UUZ6RzNmTXBudjZmTU5EbDNVNE80MGJTZHc2TndwNVBXMHNHLzgwdlBJ?=
 =?utf-8?B?Wi91MCtiRUlMSURSbzNsKzAzWUpFVFQvZ1pveDdQbWF5bkN0dDZnaXBFcXQ1?=
 =?utf-8?B?WmJ5aGM5bHdnTXB3SDJFelpVdXk4RndjRXZ3bTdxdWFPOFFCVzJWN3ltdStx?=
 =?utf-8?B?TC9LTjFvR2tpN3NSeU81UGtCSUdZSnV6OUpxMTA4MWtzWHJNZzRkTk4wRUd1?=
 =?utf-8?B?YmoxS09VdUlBTHVvN3BRTGRHL2t2NGdoT2ZTYnZMU1E2dEZ3TFpWcnJuM0Jo?=
 =?utf-8?B?VmkrUDBqVy9RUExSTmxVTmw1OTdacUFMYzZzWUVmMGxsWjB4ZkNnekZPZlo4?=
 =?utf-8?B?ZUVBYVRsVnBkTnBTMk5NRGx5RkdFQXlza0RHajRUZ2xDY1BHbU5LT29CR2xX?=
 =?utf-8?B?NzlBOUljcEtvQnBUYzc4NERhTHlxT0hnUzZFR1dDZ0o1MmZTNUh2dDRDVUk0?=
 =?utf-8?B?dnR1d2dGSzUvNmlJMjJZM0xBaVlwc3FqbTlYOTRRNTRVWkFEWXpVS2g1cDBE?=
 =?utf-8?B?d0NJdUlXYUdzV2lKbm8vamZCdWJzU0VZSkVJcnY1L3BLNFBjVkpZUkgwcEtC?=
 =?utf-8?B?WUcyMTJFSDJJd2poa3d0Qi85U1RFeGw3cStXVklqck5FRDVDMk5KVm9PNDEr?=
 =?utf-8?B?ZWU2RjBKcHdaRTlhTjJFZ2xwVnNnbkJmclhKOWF0MTN0eWRCWFl0T216TnZq?=
 =?utf-8?B?WVZacnl6OVZDaGZ3dW43N0NRRWF5SGFyeGhLcC9pZWJNV213UloyM1Z5amJY?=
 =?utf-8?B?dFBSbkpGblo4NWN3Y3kwN1VsamJ5WmNFUHFwWVBqRVp4dDFqTmxZWis2Q1hC?=
 =?utf-8?B?c3ZSQzV0V2ZESWU3MjJvOU1uT3pEdzJZT3pXMTYyOEV6RTdhbWRuc2VlNUxi?=
 =?utf-8?B?UVJhVGwrWmVGSnVyUEdVVy9KYk4xcE9sZGdEbmd4YTEvQ0pYaFBFSGt3M3Bm?=
 =?utf-8?B?TDMxc3g5WVVmNUxNRktOZlZBMXJwa29mdDFlSzNEZGkrMThQam9HM3RPWGls?=
 =?utf-8?B?ZWpoMUNOQmlWSFZLVHkyRWpQRGFYZ0ZXVjQzUERPRmhGK2pxZmI5dkxBenNT?=
 =?utf-8?B?V1I2ZmZsTmE3ZTRRbWdWc1ZodGxWb3RXWFVabUhOT1M0bk1ISmZMaUprL09T?=
 =?utf-8?B?MWhNMlJjYWpGTGZjUjRkR0ZLbjBmMEp0QjViV21MNnRPTkV5aytkb0pzT09K?=
 =?utf-8?B?Uko5Zi9MdlYyWWxxYXdaNjVkbzBXYlVoNmhEY3VFZk12bVBGNk9RbHNxSUhh?=
 =?utf-8?B?Q3lnTlpWMDEyMEY2bDdNWUJ2VFdyTzl2T0ZXbm55b0QvNE5sanFqY2RrdXdx?=
 =?utf-8?B?NFhPYWNiclNVM0lyY0l6RFg5aXZvQVJqQmlvUXVFeStEUzV0YUFYQ01TVCtH?=
 =?utf-8?B?dlRXWFYvTU1nVmVrekFJU1RtM1d2aFJDMUNkTG5kbG5TOTQrWTVyaGpvK3Ru?=
 =?utf-8?Q?CcHOmFKhv/i0WrEPfBNngSA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df3e659-461c-4aae-a5dd-08d9d192f386
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 04:05:33.3253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OXVopV6MTQ7ERW/IAmqupIBWPejfhY8sX46/34OfvU2DxZErSqTpOy5GUMFjLmKDLmAv1G3WQVXq3CbtSr8PjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5321
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/29/2021 11:51 AM, Manali Shukla wrote:
> This series adds 3 KVM Unit tests for nested SVM
> 1) Check #NM is handled in L2 when L2 #NM handler is registered
>    "fnop" instruction is called in L2 to generate the exception
> 
> 2) Check #BP is handled in L2 when L2 #BP handler is registered
>    "int3" instruction is called in L2 to generate the exception
> 
> 3) Check #OF is handled in L2 when L2 #OF handler is registered
>    "into" instruction with instrumented code is used in L2 to
>    generate the exception
> 
> Manali Shukla (3):
>   x86: nSVM: Check #NM exception handling in L2
>   x86: nSVM: Check #BP exception handling in L2
>   x86: nSVM: Check #OF exception handling in L2
> 
>  x86/svm_tests.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 114 insertions(+)
> 

A gentle reminder for review

Thank you,
Manali
