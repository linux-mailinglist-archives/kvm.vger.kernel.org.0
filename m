Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A183EB69B
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 16:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240192AbhHMOPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 10:15:08 -0400
Received: from mail-mw2nam10on2070.outbound.protection.outlook.com ([40.107.94.70]:37020
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236081AbhHMOPH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 10:15:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3Sdi4jH5qhFKph5kM18Dwe6K7aEwNJeQrD/6BVgynncPy9cdUoc5jMskgRf44ajWBOEcAhCyrgglEadKfAXc7f2V2FmZtGtsmzmYJ3pTOjvB2ziS24kPd25ERI5rIURmlTEL7kPfsw47CRaU+LaDjx3ArJk0fb/YtYwb2aXMQfR6Nw/nugIOYhGUBVO0MuENEd24w/gpFrWfzBxiFdNs0qR1VVmoBJdsrdUKBfYJ/Tp9XW3ek2DCUqmcG8dQb+E7wVIVs4kG+ME8dmQn1qLiy8ckaAoI+Wxc0T2k5WqXZCAB3KIKqinQ6qEi6DJX3faNtQtKbMsvonIFyR8uXZaKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghmwH3/nCbVcjWKYe71YwWkwpP0h8+pKVLrUC9gXz7w=;
 b=bAdC+YD51UJIG3WSBZBRlujCSRzxthQLLCYJikRezIp2wS5sfBRVo72cTIiTdMtq/GuMpyZsWYqCA2RrpT6At2YALGDKMFokeEHNUB9ke87PyD/OCLMkSKe9EHaABZUopJHSbWquLIES8IqZ6zAB5fuAEKUx5Av2n2ybf/ZLezENmdGOc9a9/JzgIljpr4TjwPT+9CJ0ISR25fuEgZ6nBvhXpDWjDQspIFr6u80/oD0ONNqCmFfNlIDWcQYzH89iVANBRG1Q+m7gv9hgcv3Q8VH86nVpVU4W79aga73MLTqu/xopnxx3kc2kjxdyq/taP+O0jNJjUn8rCEMjvj+Mfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghmwH3/nCbVcjWKYe71YwWkwpP0h8+pKVLrUC9gXz7w=;
 b=MSsbaB3F5CU4X6MZ5aRg4GM2Jjk2XWK6qsywVTp45YRv8E6WRtWXTPe9WLSJ5G2/MwKUkLLb9Uh4RZlpdJlYqHnMx2pCC4OXFxfXXiNnC7yYfM4JCbb3DfD6KvZYZQedP9dD9jweo9D1SRRAjl1aEwNAtrFkZQv+5+5fjbOkwJE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MWHPR12MB1232.namprd12.prod.outlook.com (2603:10b6:300:10::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Fri, 13 Aug
 2021 14:14:39 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3987:37e5:4db7:944e%7]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 14:14:39 +0000
Subject: Re: [kvm-unit-tests PATCH v2 0/2] Couple of SVM unit test fixes
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     seanjc@google.com, thuth@redhat.com, drjones@redhat.com,
        kvm@vger.kernel.org
References: <162880829114.21995.10386671727462287172.stgit@bmoger-ubuntu>
 <c5d156e5-e23d-4c82-42f2-33566af06ae1@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <91d5533b-d9db-5f61-095e-ad5ac532d032@amd.com>
Date:   Fri, 13 Aug 2021 09:14:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <c5d156e5-e23d-4c82-42f2-33566af06ae1@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0064.namprd12.prod.outlook.com
 (2603:10b6:802:20::35) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.0] (165.204.77.1) by SN1PR12CA0064.namprd12.prod.outlook.com (2603:10b6:802:20::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Fri, 13 Aug 2021 14:14:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5060775-cd4b-4bb6-480f-08d95e64aff0
X-MS-TrafficTypeDiagnostic: MWHPR12MB1232:
X-Microsoft-Antispam-PRVS: <MWHPR12MB12328B8EF58157B3FA03A43095FA9@MWHPR12MB1232.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ntnMcENVEzrxHv7v+1Zi/AVTMaQZaJfmd0xwwmhQ4fb+V92noPOlGy1y6hm/Y83SHh0mEfeq/7cmYIRmSJcwTaId2qu8Cl+5r7tc3PG7fQ3Zehrrwvny6u0o8EsMTyMMB8NVF/n7IpAl43ksYSUEArgUBgLvSkjSFjUPhzgRRfFbnItKNyOlKWyfVJ+YLXWu8toG/XtV5fstAlY8y+idfMNUsEOvUEoV2ZpDCJQCTLA/agbBIyuKJeL253CCTo8K322ol0s7+gfsFZfJEhSbmLYiD48sBIivzq2MhGSzEYrkqbVYpABMllWMNMqdsBxLdtR6zsjIM5/8qNV/F4XPkAaGc2HpuRKlz0uhZ7Bx5/+Ay5YF/SPpQ9FuuCwGTFQ29HEX8XpmUiY6K/mltxWCrWn20AlQ8beMW2kmO4VvZawojRDhSyQSolxfgfPdG6LvgULLzbGdFlt5PMeopHCQJ7TNjdyNZPCCbXC8kRi3Lm5PKp741A6VSXZvBlDGtF7MYPFjldH5eTb+xzVHxfgB1ojoZQXjib12FZmCS6O2B6UDuwmSf+B5iJ99JodTjL9TGUpUTIW2ugEk8xl0KNI6Ex+5I8tsx1B/DfazF+JW13gFQSHKsrtmizpsaQu823N007S+6W1moxJJPZ5Ov4o6fBqrptZKpmy2Mh2xzn2T5mt3P92s/+H6ZZBykfwGo8wLxCLkoqeNHdaSHkeVc1nBTpqj3UYzJkQcQ+lvGx8vDm4opoFzjj+3rrEJKImqJZ6jvhum58N7lvKplM/zpf3CWfJKNF4Opnxsvmb8nv19vZ4mdsGmPBr7UtNklMin51Xu08CNm8SwAux3c5RA+hsYFhAO/sKP74Kq2ffeyLOI2uE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(16576012)(186003)(6916009)(478600001)(45080400002)(316002)(6486002)(966005)(86362001)(8936002)(4326008)(8676002)(956004)(2616005)(44832011)(38100700002)(38350700002)(31696002)(53546011)(52116002)(66946007)(66556008)(66476007)(26005)(83380400001)(36756003)(2906002)(5660300002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0k5MHhHdkJ0OU1qYTEwV2QvY3pBeDBKUEdLZ3hBaG1JbFR5OFZUUUs1Tnhu?=
 =?utf-8?B?RFE4amNtZWRFeTFxNlg2cVErakRScXRrNlBvKzU3UG5sNDBwZ214WjFVcHg4?=
 =?utf-8?B?RTRyQk14UWt5UFhlSGVUZ1lsd1NCdjBlMEh2Y1dyUFlnc05LaGFBR2RLQ2Qx?=
 =?utf-8?B?Y1B3bk5NMFdycXR1a283bEFFMEJoOGtubXBHNWxibllJOFJ4N1NmdzRlZTE0?=
 =?utf-8?B?czNqUzZCdWZVeWcxL3BQN1NVRzAyVHdvWGdnTGd2VEh3N2RIS0hCSVRmWU81?=
 =?utf-8?B?T01oaFNvYUo5L1hBU1NiaFRZQmxtTVd4c2xDc05lWFpQTmJYY3dPRnkvZE9Y?=
 =?utf-8?B?NGhrWUJmVUEzWXZSR3d3SUg1bEZoV3JxRzY1eVNweXFNaE1qSFpBVWZCeEI1?=
 =?utf-8?B?QmZXU2xOWVU1ZUpzSkFtVXJVbGNJVXZ6WElDQnBMUmhNa0dmWnlraGxyWTBo?=
 =?utf-8?B?aEM4WHhqZWFaZ0J6azJBVzM5VEhYUEY3OHhPaXZYUXBGSUtVZlJla1JRRVV5?=
 =?utf-8?B?SmhvRGx0QTQ4dkVMeFdGN3FubXpTS0xFdHZjbUszQXkrUWRrdUFUK24vaEV3?=
 =?utf-8?B?cDZDNHZpTy9jTkpFR0NWSUR5QWRLZ0Y3RkVCdnhZY0tuckVXQlZ5bkxFUnlB?=
 =?utf-8?B?aWYyMVRaSENsZlMxQkd1OHloZmRPekNiNFNvNWs5b080ZmdsUzhqKy9xSUk0?=
 =?utf-8?B?dEc1WGRpWit6YjNFQ0tiamowUzh2a0tkS3dRSjdsaVR3TkM1U3RvTUdHRE92?=
 =?utf-8?B?RUtrVTZXTmxCVUJLZ0Z6M1hEQ1V6Q01UOGVZY25rZ3VKQjFseUpjdHFTaHNU?=
 =?utf-8?B?M2J5NjQ4MWU2bkdERFZJZnZHRHcrY1c3c0dNYVNnWHZ3ZkJyRGNrNjlDUFZO?=
 =?utf-8?B?NWZZYjJHa0dtNHlzRU81Z0pkcC9vZi9qVHVVNmJqLzJnYW04T1Q2Tm5aU3ZS?=
 =?utf-8?B?SEliOVRXY2ZxaGxYTVlyNXNicFc1ZGdUWnI1OHNSdEwxSitBWEV6Vk5WQ0pR?=
 =?utf-8?B?SXY2WUJrRGhXbER0WlJxQzQwdmhHZVhGR2tvcTViMkR6aFVqNTRmZkZxeHZO?=
 =?utf-8?B?M3gzTnFRUnBsaGdLL0xkV09jV0NTMjNPVHlFVms5dmFreVMzcXI2blJpOVZB?=
 =?utf-8?B?QlhkS0tmUVJlQjVTSTFYd3F4MDBYZkNJN0tZcDFBcHVGbmhXY3J0c3Rtb2RH?=
 =?utf-8?B?QTNINzRjeTllTUNrUVFJek1TQndIWXM2OElYQnArSjBqWGI5QmdrQ3pSMW9a?=
 =?utf-8?B?REZpRlg4YlVFWmpIZjkrZGNaZkxlY1FvZnlHVXVSVUJsZlZaUW1qV1drRUdP?=
 =?utf-8?B?UVZXVll5YzV5OS9mblNyYlBSejFVZTkwM2VpM2diT29HRUpKMDJYMXZTZkhJ?=
 =?utf-8?B?RWVmcW85bVhaRXAvRUs4YkRQYVNCYVNrZzZtZUFoeUQzNkhZemJLVEp2UFJJ?=
 =?utf-8?B?aEtLVHlOSmNxdTdWcjRkQ2JqMTlwb2hVY3M0UlhaT2dxa2R2YTFvTk9WRHI3?=
 =?utf-8?B?clEwWFBIYS9tZXZ2blcrYnhvUFVlNTJTSTMxaEVTaWxVTGNaV1UwQmJBZG5J?=
 =?utf-8?B?aGNCT0c1RkJuZ2F1YWNrbldqK0gwUnNUaCsvU3hsNGQxSnBNcGpRbUF3QW9R?=
 =?utf-8?B?RU0xcnJIRllKYXozMWR1QWd0TUZQbHZUR2duR0pROVBRWU12b3FpcUEvZy9H?=
 =?utf-8?B?d2dNUVFxeEF5T0tIY1FacHhVMSsweHc2N1hIMFI3eWJhV21pZ25kdE5zcVVR?=
 =?utf-8?Q?ZqX14Ae8gOAwVNBKn7PMoXfeocGjjWf0dp1Adrk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5060775-cd4b-4bb6-480f-08d95e64aff0
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 14:14:39.3894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3H+Eh1fATgGVhybfHRa8gX5Mr1g1JF+dAdeqSwwlNpxq8keca9EMW5ENf644RrcD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1232
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/13/21 5:38 AM, Paolo Bonzini wrote:
> On 13/08/21 00:46, Babu Moger wrote:
>> This series fixes couple of unittest failures for SVM.
>> 1.The test ./x86/access is failing with timeout.
>> 2.The test ./x86/svm failure with infinite loop.
>> ---
>> v2:
>>   1. Modified the check in ac_test_legal to limit the number of test
>>      combinations based on comments from Paolo Bonzini and Sean
>> Christopherson.
>>   2. Changed the rdrand function's retry method. Kept the retry outside the
>>      function. Tom Lendacky commented that RDRAND instruction can sometimes
>>      loop forever without setting the carry flag.
>>    v1:
>>  
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F162826604263.32391.7580736822527851972.stgit%40bmoger-ubuntu%2F&amp;data=04%7C01%7Cbabu.moger%40amd.com%7C37359356e8fa4a0c33bf08d95e4690ae%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637644479455847518%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=JFA5zk9xqFpdbASQlHyTVtpn7yBhF1mk9NFaKrllYjU%3D&amp;reserved=0
>>
>>
>> Babu Moger (2):
>>        x86: access: Fix timeout failure by limiting number of tests
>>        nSVM: Fix NPT reserved bits test hang
>>
>>
>>   lib/x86/processor.h |   11 +++++++++++
>>   x86/access.c        |   11 +++++++----
>>   x86/svm_tests.c     |   28 ++++++++++++++++++++++++----
>>   3 files changed, 42 insertions(+), 8 deletions(-)
>>
>> -- 
>>
> 
> Applied, thanks.  I'm looking at a few more limits to the number of tests
> as well as optimizations to ac_emulate_access, which should reduce the
> runtime further.

Paolo, Thanks for applying. I will test your patches and let you know.
thanks
Babu
