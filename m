Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66BE33A2196
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 02:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhFJArB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 20:47:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:35572 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhFJArA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 20:47:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A0XuT6190438;
        Thu, 10 Jun 2021 00:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=DqoLS3623Eqx2+2hDJW9GV6Qe4RkyrUhoeDiYvDVGU0=;
 b=tPGRVEBQaouIcLTZxGudAgFxLNuP0Wp6YdVY9RsNejpWQC8OruVzcctptQKtahFgDbXg
 34R+b1lkCxZyacAqqFyYwvyhDqc18pbvhKLZNOQwUe0uhwjGTGK8vNH6F7eUCggNGrkA
 9so8LfxddfYR9x/UxdsnpxZs+IUReciZ2LawtpNrdxYRjlyi6j3S1MHxfvYpSQIr1s2q
 fAsrZ6JW0P283XMCKuz5keJM7UqRPCq9PWCbL7yZon/ppf5c/a9yWbUdrO0UTHcn7bgy
 kV+yrC0Pp8l+G/nr5yK7CNQT9lxDeGGp7C5eacki6WN5z6CnnQEgvDcKGaTuMpMs3Lk3 GQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 39017njjfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 00:45:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A0aQfu195096;
        Thu, 10 Jun 2021 00:45:02 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2177.outbound.protection.outlook.com [104.47.73.177])
        by userp3030.oracle.com with ESMTP id 38yxcw3gvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 00:45:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E79jWitWzuGBLvZHC0KTVKfI3LnVIytMm6PYF8I5lHON5x5zCtJ+Cfk7IMtanqPGxUGCcEELdvrTZtmYMGInCp6Mt9FoRc5E5rBvuFI/XNV2kIWT2TTf/3b1A9OBoFlE9HW61/fsWDAeLV6Cy0o1oyIDmIAnpM40uUUyvQ9PfJlyJcSHLNd/u+T6QwtoO0y5Mom9/OcVca9gDs81gUPN8e0Jm8lksBm1oX0XAyaY6gwYRmvGt53SbI8pFpcpJGE8lCwJ2sq16taPtiYNc0SFad5l7B6yV4tvOD8AkB5wA383lQRTOUtiZ1KaotjdMHQckNwvlFK9szrlPTUV/M3vgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DqoLS3623Eqx2+2hDJW9GV6Qe4RkyrUhoeDiYvDVGU0=;
 b=DOZILTAE3ZOGvjOW1ND1q/Jtntue2BZSk3buYQNwW0rfj3uOvAnzRFC3yXmwxt/gRfQkTG6xYmkOu664oGpsYueThz86nDMnUsNEb2wg03iXsUbX5mFjUsW5pua3D2ph+momQdQ2t2G4wWnpz9FCq0OzPfOPtnWSEBQSSIS53r0Uc0B07ZfGi+pleF25uB2aTBD1Mpdi8Jyn1zGl//iFlqpj2am6tRWyycvj0qduQe/owE80Y8e9wmgKBmWQqOxOxIKwBZyLdBeBJKwCY5NJgkJ6k1hWR5D5v5MrfsUTfyv1jB9JXT2qQzSFzEIzOdcoX96I6Vkwg34OQETPWREB4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DqoLS3623Eqx2+2hDJW9GV6Qe4RkyrUhoeDiYvDVGU0=;
 b=P+inkkopqbLnqetGiiNeRadmpCKvmJWzUdDqTiJoykoAHpg4Hv+OFukd5tTqzOKLNarAltGqCsfGnulyqibIvMv2DgrYX+2ndJ3m3OsbRCT6uGJurMLFtKceP2CXqk95dUCVhMgCh4/E3dtbkNrfSA8KtRd0IHsiOxMfOR1mu9g=
Authentication-Results: googlegroups.com; dkim=none (message not signed)
 header.d=none;googlegroups.com; dmarc=none action=none
 header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2575.namprd10.prod.outlook.com (2603:10b6:805:45::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Thu, 10 Jun
 2021 00:44:58 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::f17c:44eb:d1be:2107%7]) with mapi id 15.20.4195.030; Thu, 10 Jun 2021
 00:44:58 +0000
Subject: Re: [PATCH] kvm: LAPIC: Restore guard to prevent illegal APIC
 register access
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     syzbot <syzkaller@googlegroups.com>
References: <20210609215111.4142972-1-jmattson@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <8b4bbc8e-ee42-4577-39b1-44fb615c080a@oracle.com>
Date:   Wed, 9 Jun 2021 17:44:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210609215111.4142972-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: SA9PR11CA0004.namprd11.prod.outlook.com
 (2603:10b6:806:6e::9) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SA9PR11CA0004.namprd11.prod.outlook.com (2603:10b6:806:6e::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 00:44:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c43c7c7-5821-4292-2b69-08d92ba8f929
X-MS-TrafficTypeDiagnostic: SN6PR10MB2575:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2575EEC58EFFAF4C624D1FD481359@SN6PR10MB2575.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jj6qAj3g3mJTEOTRNy2uBK//2I6zWdgGrq2qexF2wOOfq6Xf+gVJs52bksGGS+rkhxG2HoO3OGkSTFdhzg9QnEir71FrZ3+/dExeX8S8G4Qld/+reYb2h5ELhrUy2boMUC56pqUXcCavxuOCad1SjtD85E/gDRBQUNUw/fXnN+hf7eAmjDcx9tyeq6q3O0P50LltNBLE6l9H9Z3RKzwI0vsAY8u8xN7noeOxqHHaOLYB5t2FUcP9DWZSQ5d1eassQlZ4l74vIE6RnBmF7FZN9u9QomUavqxWkPbh/FLdnqi94Ek6FMGx7xRRiu3v3/7Q394MFqDhFjpvLx/fsQCbik6X6zcYIB/zQW8aLFGKJXQ+95UxJXn5BXWe+oP2jivPGnDS9aVBmwCSe2BqcDgv8z6bcfDoreIOW/dN2RlDLdJ8Wu1GUDCbLSDj2UgCMuKEFTLW3PER0T+/5G+zu61vr+wxV7ZInOHUxg+YasrqaoKJ4Qmp8rGdsH9B7DhdQoGDQbLPnFz9C+r1ey1ObUbjr3wAhYZiKGvYTGJdtylsvjp7q5vcNeUHlAT6rByWKpGctp9KCLvJxx0nVmN2Ck6pV76vQbnMyhym5jVyuvEq8a1XB+1eUtyBf870Jw/4qOv12U6PIAzY3QYctJHjOq/6gWcbf8Oncv4Ogx2+k1qoSyDQKtboIWHUqiR/qcDMBrzF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(39860400002)(366004)(396003)(478600001)(2616005)(36756003)(44832011)(31696002)(38100700002)(2906002)(66556008)(4326008)(186003)(6486002)(53546011)(6506007)(316002)(86362001)(8936002)(66946007)(66476007)(6512007)(83380400001)(16526019)(31686004)(8676002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1Q5MHZjczdkQTJnWVZmQkJza1AxdWVWUlB4UENqVUdYUmk2cVRUd2tBZCt2?=
 =?utf-8?B?NktFK3Zabk1WckVobjlQNHp0TWdpeFBvajB6cXZPaXFJZXFLbDRLUW9DNkdL?=
 =?utf-8?B?a1JKZ2NrajJYQldKN0lpZWluOVdkL09SY0ZaZDhweURVQkRlL211M21nOGJk?=
 =?utf-8?B?c01pb1VTRS94WHl2OUdOQ2Q5b0J4RVg0VisrNnpycE91WkN1MnkzZ2ZtMkVU?=
 =?utf-8?B?VUR1R2cxQytoMS9xTk1LL1VRRXpObDJPMVYwbmVZKzhpc2M2NVZCcVB0djQz?=
 =?utf-8?B?MTNOOWFMN09aVnU3QWVhVVFYK1Nodk1uRm9NcGorOVovc3ppSit4VEw4SmNH?=
 =?utf-8?B?OTJ6TlJPMVZWOENJZlVFTXQ2cmxaMEMxRURNcDlnRGMrZUhIRUpjbzU4Uyt1?=
 =?utf-8?B?cXFnaHhqNU9KWGlSNUNyd1dWQTlEVGloWnFnZzZmYUdmRSs1VGdtalZVTm1U?=
 =?utf-8?B?VEFjcGhuMm55K0FURkhkdlBqVzMxY1F5Y1d3Qys1SjBYNTZWUm1CSjV0RTA1?=
 =?utf-8?B?Y3FVTzdjWjJjYW9Pb1huZ1JPR3NiUzAwR2pmdDhKTFFyRHA1cnBPVk9nNEoy?=
 =?utf-8?B?ZkZHeHE0OGMxSnJQTk1QcjVPTDdrcVZib3dSL1IxL0d0dDJzdVB5TnlSdFhJ?=
 =?utf-8?B?clR3aUhPRHpJQjlTdEo1MHJIK0Z4RUc0VGNNMEFGLzNrZUlkVTc2YzhQNmpz?=
 =?utf-8?B?aXEwK2I1YVdBYTk4Y1ZFQVJDTTUvMWVldmZWYjRPcFhieVJyLzVzd3F4a1Vs?=
 =?utf-8?B?OERyQjljMnVuR05MaTVqQ2VOVitaeFJCQUdHZFBTczVHSGx4QXlWMmhNRXg5?=
 =?utf-8?B?M0hzREhoTUo5TWkyZkhFNFAvSXMrNk51SkdlVUU2cUE1d3lEeW5lZW1ac2Mw?=
 =?utf-8?B?azdkU291bWRjQjB4Qjl2ZUNWZTd5Z3VzWHlTT0E3cjU1RWpGYmR3N21lS2FQ?=
 =?utf-8?B?QXpDNGxvbDFEOHhzU3BNRVZWSWYxcExHdmNSTUNOZWdIam4wc0M0MXJvdGwy?=
 =?utf-8?B?aTRTZkM3enBnekFFSlZ3MDRiUUIrSm42bTZsdVRyQnVLVmtkMFBKRlVvcFBv?=
 =?utf-8?B?WFlmQUZCenI4UFNRVEkwd25XV3U2UHVYQzZwUWRqaFZ2M2dYQWRiRjNINnVY?=
 =?utf-8?B?ek5XNm16ZVo2aE05VjdteERQeDQxbE1yVjUzNUMrU3Vqd29XY2FoUCtOVmRQ?=
 =?utf-8?B?eGtIZnNUV25QUWdWMHYyUTg5VXZxNzJUcEx4c0dFdUJGRU91OGFPdlVzRUpJ?=
 =?utf-8?B?R2VPYnhBcmFVUEczQW00c0tTYmR2VklySGRDaXU0S0JqblhIUmk2ejBTazRr?=
 =?utf-8?B?eWNkQlBCS1hZMFpjV1hPbm1iTktMMVhqUHVQOXdxRmw4Qkx2MFlwVGhrK3Np?=
 =?utf-8?B?VngzZG5CeVRmUzJ3bVBLNmQzbW5Wd04ydzYrckJkTWZHamFkajhjM2FTWGtU?=
 =?utf-8?B?Z3pvS2xGNjVZMlF6a1UyRG1YZjBkUmd4R0ZILzZ4MUREbXNaNmVOOFdycWFt?=
 =?utf-8?B?UTB0N2s0UU1ONUF4M3UzNnhBaFd1UWZudi9HWW5LbDBpaTZJTFhwVXgxMnRw?=
 =?utf-8?B?ZVN4ZW04bDExU2duUzhjVmRsRlRZWTA3Z1JjUmxIam9rNXFFeTducGFod0RB?=
 =?utf-8?B?RW5vZ2RaaDFPdmdsTEttdnRQNWkrbU9jaVZyTS81eU91c2M2WnYzMGNOUUpv?=
 =?utf-8?B?TVJZbnpWN1RuaUtQQ1dFOVlIamMvcjRQaHFlRjlyRDNMSUtTT0tyTXJXc0lI?=
 =?utf-8?B?RUozNDcxcHVJWnhsZkc4Y3dVb2o1b0JDZzQwTlBkanFSK0xyVlVPM0R1RzVj?=
 =?utf-8?B?Q2RUdlJUTUxEUC9nMjIxZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c43c7c7-5821-4292-2b69-08d92ba8f929
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 00:44:58.6539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xE5cx1hWCoVlxwnRSwxzS4gaaAjcXOkOUxYT0BAOcB2qTLpzrVhjEzsX/bn92WLfWwEGfigZVABpbL7KJWhHuTGRVmS6xt2X7WLzVNdGl7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2575
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100001
X-Proofpoint-GUID: KdqQAdHzN-baQ5N1zwlujui4V-tDs0xW
X-Proofpoint-ORIG-GUID: KdqQAdHzN-baQ5N1zwlujui4V-tDs0xW
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 clxscore=1011
 mlxscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100001
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/9/21 2:51 PM, Jim Mattson wrote:
> Per the SDM, "any access that touches bytes 4 through 15 of an APIC
> register may cause undefined behavior and must not be executed."
> Worse, such an access in kvm_lapic_reg_read can result in a leak of
> kernel stack contents. Prior to commit 01402cf81051 ("kvm: LAPIC:
> write down valid APIC registers"), such an access was explicitly
> disallowed. Restore the guard that was removed in that commit.
>
> Fixes: 01402cf81051 ("kvm: LAPIC: write down valid APIC registers")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---
>   arch/x86/kvm/lapic.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index c0ebef560bd1..32fb82bbd63f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1410,6 +1410,9 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
>   	if (!apic_x2apic_mode(apic))
>   		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI);
>   
> +	if (alignment + len > 4)

It will be useful for debugging if the apic_debug() call is added back in.
> +		return 1;
> +
>   	if (offset > 0x3f0 || !(valid_reg_mask & APIC_REG_MASK(offset)))
>   		return 1;
>   

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
