Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6905E2AA47F
	for <lists+kvm@lfdr.de>; Sat,  7 Nov 2020 12:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgKGLBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Nov 2020 06:01:50 -0500
Received: from mail-eopbgr00073.outbound.protection.outlook.com ([40.107.0.73]:26223
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726242AbgKGLBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Nov 2020 06:01:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i98CI5ZVfTkJ2IBmFiPrkgEgzzpKRxAtI3ozXxIQ9oE=;
 b=HC1TDfbLRZ9tf2POkPGLhEG7XEEvqNzNRotFmQgqM7/y9up43YWMkA16pxitg1254SfamcNAW1OqCUXB8RC+LjoefAisakMr+pDLWg7x/jftNqvrCLN/4B1akQIyHsrnpN56klMPan5zFdh2HJVwuWEoPOMTdLaIdKqYwQZE+9s=
Received: from DB6PR07CA0163.eurprd07.prod.outlook.com (2603:10a6:6:43::17) by
 DBBPR08MB4251.eurprd08.prod.outlook.com (2603:10a6:10:d1::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.18; Sat, 7 Nov 2020 11:01:44 +0000
Received: from DB5EUR03FT042.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:43:cafe::db) by DB6PR07CA0163.outlook.office365.com
 (2603:10a6:6:43::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.13 via Frontend
 Transport; Sat, 7 Nov 2020 11:01:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT042.mail.protection.outlook.com (10.152.21.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.17 via Frontend Transport; Sat, 7 Nov 2020 11:01:44 +0000
Received: ("Tessian outbound 39167997cde8:v71"); Sat, 07 Nov 2020 11:01:44 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: bfd0a49e7395d405
X-CR-MTA-TID: 64aa7808
Received: from 01663b9aa28d.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 18A87810-AE2E-4F38-880E-1477A40E2E15.1;
        Sat, 07 Nov 2020 11:01:38 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 01663b9aa28d.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Sat, 07 Nov 2020 11:01:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1vTzp5WQV1oJeyU7tJdyAxGf6d21JcsO0x4AJga0vFaPKQ5ALHRlfKRnyr+yJcfqzX4hCF31ajsiUv0adGkua53UbblVyRmC44DiSAqV3EmJvQtzf/F86rTJyzUVXVV9980M/sV7ziZns6YGmtgkvj2BFcJiWQ33KPs9WHJsKwvYEHItN+FS6KHx6A/spaS3FMDrcObaVROyo9RRji9cG+UQ7mPqEAC1uzGccYcqaBrcVBS4SE0mfHF0G74BO0G87Dzr3pILchvnFPNfSZI06/xGYlhy7E6GtCpZJEPQjEL175hAKpHu8kkFqcdK9ZH3N31YSF/34OkNZh1RCjlvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i98CI5ZVfTkJ2IBmFiPrkgEgzzpKRxAtI3ozXxIQ9oE=;
 b=dxkv50/4oDkl/H84kQClC221MaF+Jo8+5ayIKA1xe86rijUeWHVf29/g9S3CDpm99QREI54iPgN3xWAcGMs2uRh7C9VkKSco9IUYJVOySySEMGlM14gAaDNEcB8vfwAS0aB5vBXTE2tLbySztovmvCOg6+egxdIqpLkWBgN39dvH3QPhjaVCFKWdbgIrTvbhdIhg5fhLAbPXQKlkWvECojc+njKrZuCUFcmpcTFmAKZfyEHhkm8mO6E2VWAa/WQIzXXviay8w4rfU9chlO6UPC+4ItsqJ9TsMGmn2D3D6GPIlc4W+SfSmwkLc95u+9nFG3+0Gev5zTGjQX7rQMlj7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i98CI5ZVfTkJ2IBmFiPrkgEgzzpKRxAtI3ozXxIQ9oE=;
 b=HC1TDfbLRZ9tf2POkPGLhEG7XEEvqNzNRotFmQgqM7/y9up43YWMkA16pxitg1254SfamcNAW1OqCUXB8RC+LjoefAisakMr+pDLWg7x/jftNqvrCLN/4B1akQIyHsrnpN56klMPan5zFdh2HJVwuWEoPOMTdLaIdKqYwQZE+9s=
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
Received: from DB8PR08MB5339.eurprd08.prod.outlook.com (2603:10a6:10:114::19)
 by DB6PR08MB2872.eurprd08.prod.outlook.com (2603:10a6:6:24::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Sat, 7 Nov
 2020 11:01:35 +0000
Received: from DB8PR08MB5339.eurprd08.prod.outlook.com
 ([fe80::2d28:f8e2:5c8a:c377]) by DB8PR08MB5339.eurprd08.prod.outlook.com
 ([fe80::2d28:f8e2:5c8a:c377%5]) with mapi id 15.20.3499.032; Sat, 7 Nov 2020
 11:01:35 +0000
Subject: Re: [kvm-unit-tests PATCH 1/2] arm: Add mmu_get_pte() to the MMU API
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com, Andrew Jones <drjones@redhat.com>
References: <20201102115311.103750-1-nikos.nikoleris@arm.com>
 <20201102115311.103750-2-nikos.nikoleris@arm.com>
 <f347911e-bca6-3124-7f4a-4a61ec0cb7ab@arm.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <4a142934-732d-d5de-dbc0-75728f1484b7@arm.com>
Date:   Sat, 7 Nov 2020 11:01:33 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
In-Reply-To: <f347911e-bca6-3124-7f4a-4a61ec0cb7ab@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [188.214.11.183]
X-ClientProxiedBy: LNXP265CA0056.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::20) To DB8PR08MB5339.eurprd08.prod.outlook.com
 (2603:10a6:10:114::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from C02W217MHV2R.local (188.214.11.183) by LNXP265CA0056.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Sat, 7 Nov 2020 11:01:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8eba7fc8-6fa1-4754-b358-08d8830c83a2
X-MS-TrafficTypeDiagnostic: DB6PR08MB2872:|DBBPR08MB4251:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR08MB4251E4E75AA99B2D7B2BC406F7EC0@DBBPR08MB4251.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: oxdEIBMzXiJZDJZno9eg7xwEbVfAK7Ge19TyhUZWVdwgofVe1bfXa642uGW6QESh1A6P7zPQ4XaN06tc9e522ICjs+6RMO88rMZFvQyMU8B6J5ldypGa3ES7OqSKspnO3nPB81hdqk5ngDwx9tLAFh4uldKKvFGWO7h7mhQQFBWYF6jJcBM6aAJ2zdbQknbrBxICIISziKXlBF2cCqf9i6Szd01L0rYmx6nNEsqTsvv6iumM16OTAMQTcObqudsXvPLpO8mHwd+uIZNZf44vKhoePbTtmwxRhbPp+j/ZbhC2u8TWbz62tOuRArezLfAHpsFfou9RAiiiOL5gUU3X5Q0xcFw65i5Yqd+aACJwOa0Fb5c9gWic/S199YeAGa1Q
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5339.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(66946007)(2616005)(6506007)(8936002)(5660300002)(6486002)(53546011)(83380400001)(26005)(956004)(8676002)(6512007)(66556008)(86362001)(44832011)(66476007)(31686004)(4326008)(31696002)(316002)(36756003)(478600001)(2906002)(16526019)(186003)(52116002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2ngXETpTfuD/pHC7XQwDKxlukJ1xU7EWNq4Xu5Mlx5ExGoi59tJjvU4fW5ydYSg6zr/q0zmCiEX8/vjMhEdpT7qfUW3u/jYgnB+qyS3GdhMgKSFOn7LESmeKhdOA7ojApoxdfuRqjrm5ZIjzziOB3H3lATapjZJa1xVIJWWCrIYxVxdcu9yYbQKr6Khhi+ujdBMR+DiC+e6WFNaQMFn/qxxu4K6PfhHUBeM9kDrC1RtBQfo+W14p0CNcveRCvwcPib5XxVaIEp1thQAASbrcY+Ga219mcoKArfVC+Mhj1Y9hH2rRigAYMQ3SPOgHoNRbZk6n16/y7/ewftKWgYwJ81RLQlZGcyKWL3bnQc/0mJe0Y4fI+9S2itS8U9/QB88JAUmJI3lvgPZroTLkCOk2UAchEckD4W/TKUIXU5QF0OdKKkFKAyeZ94FMo0Pyyr5XCEs1HHvhuNLgLa53lQQgoISUfydx2lUfmMD8qdg+6lIUDmp+yk57b/CPUDvABfKMZUYi6B+VtGt/Wh4yXJViZi3YJoJ9/aObRZOhPHEP1A++t9VEPVx65dvkJPLqOwiqgsjRNPtRd2P+fb+LatmWGPyJVBze2VnMqO3zRdOvEBDfhniUR2HuqVY2Fvu15GX678qxBr9zF3Npxm5vJdycTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR08MB2872
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT042.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: ea5f1238-67fc-42fd-f86c-08d8830c7de6
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N3ZQ98UnMGMo8ACPMxO7vobrJC3xx3hqp5Yy73+EHdUSp75p8Kv3X75uop1cM2C+9fdLjI9O4EqAkg1D+AUaEhV/AzkHZREo51i/jOCbeR6Ybn/PHOhzH0LfqZXEXQk+oYdsv6WsTnP2EAKnpw6ucnZcv/pN3v1mkNilcjWbv9GZ7RNLFLOTlluUIV0UtTJAMuatityMs+Cbh+B/htytak4m69lIBEjpeS0XxclnEcJT1aLwffBQsjw0GgiGB3PuHBb1shQ6+ZFc0b5387vlosheItqqZP1GP5IRN3r7dmHDiGK1iNTt0k7p9kP1wDUzFTkjwCtM24Dhdp85ClDGGSxrWU9SNEJ1QcVkioCwinnK+VFxaf8AJPP6tn+Xsd97OEcnE75IjLxfTQjeedTzgW+TtGVXn+REPCx1mXTXYuU=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(136003)(46966005)(8936002)(82310400003)(478600001)(6512007)(336012)(5660300002)(31696002)(356005)(86362001)(47076004)(6486002)(82740400003)(70206006)(70586007)(81166007)(2616005)(16526019)(26005)(53546011)(186003)(316002)(4326008)(2906002)(6506007)(44832011)(107886003)(83380400001)(31686004)(956004)(36756003)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2020 11:01:44.4179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eba7fc8-6fa1-4754-b358-08d8830c83a2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT042.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4251
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 05/11/2020 14:27, Alexandru Elisei wrote:
> Hi Nikos,
>
> Very good idea! Minor comments below.
>
> On 11/2/20 11:53 AM, Nikos Nikoleris wrote:
>> From: Luc Maranget <Luc.Maranget@inria.fr>
>>
>> Add the mmu_get_pte() function that allows a test to get a pointer to
>> the PTE for a valid virtual address. Return NULL if the MMU is off.
>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>
> Missing Signed-off-by from Luc Maranget.
>
>> ---
>>   lib/arm/asm/mmu-api.h |  1 +
>>   lib/arm/mmu.c         | 23 ++++++++++++++---------
>>   2 files changed, 15 insertions(+), 9 deletions(-)
>>
>> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
>> index 2bbe1fa..3d04d03 100644
>> --- a/lib/arm/asm/mmu-api.h
>> +++ b/lib/arm/asm/mmu-api.h
>> @@ -22,5 +22,6 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr=
_t virt_offset,
>>   extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
>>                             phys_addr_t phys_start, phys_addr_t phys_end=
,
>>                             pgprot_t prot);
>> +extern pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr);
>>   extern void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr);
>>   #endif
>> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
>> index 51fa745..2113604 100644
>> --- a/lib/arm/mmu.c
>> +++ b/lib/arm/mmu.c
>> @@ -210,7 +210,7 @@ unsigned long __phys_to_virt(phys_addr_t addr)
>>      return addr;
>>   }
>>
>> -void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
>> +pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr)
>
> I was thinking it might be nice to have a comment here reminding callers =
to use
> break-before-make when necessary, with a reference to the pages in the Ar=
m ARM
> where the exact conditions can be found (D5-2669 for armv8, B3-1378 for a=
rmv7). It
> might save someone a lot of time debugging a once in 100 runs bug because=
 they
> forgot to do break-before-make. And having the exact page number will mak=
e it much
> easier to find the relevant section.

Good idea if this is part of the API, it would be good to have a
reference to break-before-make. I am thinking of adding it in
lib/arm/asm/mmu-api.h where the MMU API is, just before the declaration:

extern pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr)

or would you rather have it in lib/arm/mmu.c with the code?

Thanks,

Nikos

>
>>   {
>>      pgd_t *pgd;
>>      pud_t *pud;
>> @@ -218,7 +218,7 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long va=
ddr)
>>      pte_t *pte;
>>
>>      if (!mmu_enabled())
>> -            return;
>> +            return NULL;
>>
>>      pgd =3D pgd_offset(pgtable, vaddr);
>>      assert(pgd_valid(*pgd));
>> @@ -228,16 +228,21 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long =
vaddr)
>>      assert(pmd_valid(*pmd));
>>
>>      if (pmd_huge(*pmd)) {
>> -            pmd_t entry =3D __pmd(pmd_val(*pmd) & ~PMD_SECT_USER);
>> -            WRITE_ONCE(*pmd, entry);
>> -            goto out_flush_tlb;
>> +            return &pmd_val(*pmd);
>>      }
>
> The braces are unnecessary now.
>
> With the comments above fixed:
>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
>
> Thanks,
> Alex
>>
>>      pte =3D pte_offset(pmd, vaddr);
>>      assert(pte_valid(*pte));
>> -    pte_t entry =3D __pte(pte_val(*pte) & ~PTE_USER);
>> -    WRITE_ONCE(*pte, entry);
>>
>> -out_flush_tlb:
>> -    flush_tlb_page(vaddr);
>> +        return &pte_val(*pte);
>> +}
>> +
>> +void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
>> +{
>> +    pteval_t *p_pte =3D mmu_get_pte(pgtable, vaddr);
>> +    if (p_pte) {
>> +            pteval_t entry =3D *p_pte & ~PTE_USER;
>> +            WRITE_ONCE(*p_pte, entry);
>> +            flush_tlb_page(vaddr);
>> +    }
>>   }
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
