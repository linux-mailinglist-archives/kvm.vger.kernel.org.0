Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9122D2A0579
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 13:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgJ3McK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 08:32:10 -0400
Received: from mail-eopbgr130079.outbound.protection.outlook.com ([40.107.13.79]:57483
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726533AbgJ3McJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 08:32:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zJMNDzAem2bxw/jG+4pAkgb6Qrq4SOEARClATNfEg4=;
 b=es2RbrSU0uxdeSPghXXlKhqOA4SgropTRzWZ/lN7MqQnBQkncz52rFcWXwW2HuSuUGAwQy/0cccuRcMdM0bO/KqLpB0HzOjNotRqzPWSw6HFZJrOTbCjeYIolVcbONjKcB0HHdezYQx1t579fDCwNoAFJzc2yxj9snwBDQ/tROQ=
Received: from AM6P195CA0063.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:87::40)
 by AM0PR08MB3441.eurprd08.prod.outlook.com (2603:10a6:208:de::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Fri, 30 Oct
 2020 12:31:46 +0000
Received: from AM5EUR03FT049.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:87:cafe::8a) by AM6P195CA0063.outlook.office365.com
 (2603:10a6:209:87::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend
 Transport; Fri, 30 Oct 2020 12:31:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT049.mail.protection.outlook.com (10.152.17.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3520.15 via Frontend Transport; Fri, 30 Oct 2020 12:31:46 +0000
Received: ("Tessian outbound e6c55a0b9ba9:v64"); Fri, 30 Oct 2020 12:31:46 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 7f80179c565698a4
X-CR-MTA-TID: 64aa7808
Received: from d16b006954e3.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 13DE18B2-D0C4-4B6D-8D20-D4E0C7C5BBE5.1;
        Fri, 30 Oct 2020 12:31:40 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id d16b006954e3.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 30 Oct 2020 12:31:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zt/gBfLG8TErRaHH8mdlZ3TSJ0hS4T7RYf6no2RV44pkmLHyebLaXUTd6JP1uePKkHPgO8Dn/zsDw60I0hqbNvlMNKBeGT1SVkD1uTVrqx3CDyAeAxGTl90NMFp8Zgpa3osrlJRfE/D7uckXimWTXDw/vrlUlffp+/J0MZSYtlFMUW310K111wmuOn3SjrOz/P9S2EZvHbKIalXRFbwiojf+4CUDBfFYmQgUVYtYtYxkWSuPCBv2ES/ZNUPVFgfox9xFkR5czYgyZUHKwQXZ4zUSV1zEoq9GHFwn+Vk8N+DDM2Yp90pcWSovYXulevRdSZOu4UfYeAT5Dyyusx9hnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zJMNDzAem2bxw/jG+4pAkgb6Qrq4SOEARClATNfEg4=;
 b=KumeEMN8lDLJO11gLGK4s73qP8tAHtgkzp+UpowMfSer6qB/ct1Mrstmua6NLVpy9oualWIq4u4PjzNEH2szAuaVb4q17kcbjk5UJ0C9AXDBqZBNO2xKGwGITn77Dbz5iELJLcUtqgWIsol8rdnBYD03TG2z0osIC8KL42prOUJnf1GalbTvXhWCPwNbX8EiAmOOzZWA+GCUFovGeEW+rPGSfYUEV9/z3RNg1fhxpt56eFgVx4SO1qBAiwkXMemSywMFpiT8RVaga4R8MH2weTeFqplzHaf6H8a/KvNM5kyXIusEvl1pq8Fs92LjY2QFygLwWKv4ZaDQosqbjV7tLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zJMNDzAem2bxw/jG+4pAkgb6Qrq4SOEARClATNfEg4=;
 b=es2RbrSU0uxdeSPghXXlKhqOA4SgropTRzWZ/lN7MqQnBQkncz52rFcWXwW2HuSuUGAwQy/0cccuRcMdM0bO/KqLpB0HzOjNotRqzPWSw6HFZJrOTbCjeYIolVcbONjKcB0HHdezYQx1t579fDCwNoAFJzc2yxj9snwBDQ/tROQ=
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
Received: from DB8PR08MB5339.eurprd08.prod.outlook.com (2603:10a6:10:114::19)
 by DB8PR08MB5146.eurprd08.prod.outlook.com (2603:10a6:10:e7::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 12:31:38 +0000
Received: from DB8PR08MB5339.eurprd08.prod.outlook.com
 ([fe80::f848:3db5:1e63:69a7]) by DB8PR08MB5339.eurprd08.prod.outlook.com
 ([fe80::f848:3db5:1e63:69a7%9]) with mapi id 15.20.3455.040; Fri, 30 Oct 2020
 12:31:38 +0000
Subject: Re: [kvm-unit-tests PATCH] arm64: Add support for configuring the
 translation granule
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com, nd@arm.com, drjones@redhat.com
References: <20201029155229.7518-1-nikos.nikoleris@arm.com>
 <368532ad-b9eb-98f5-ecd6-ac5b8117cf77@arm.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <9e5e5248-208d-cd93-0fb8-39de3fad53fd@arm.com>
Date:   Fri, 30 Oct 2020 12:31:36 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
In-Reply-To: <368532ad-b9eb-98f5-ecd6-ac5b8117cf77@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [188.214.11.183]
X-ClientProxiedBy: LO2P123CA0043.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::31)
 To DB8PR08MB5339.eurprd08.prod.outlook.com (2603:10a6:10:114::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from C02W217MHV2R.local (188.214.11.183) by LO2P123CA0043.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Fri, 30 Oct 2020 12:31:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dca1effa-b2b5-46ee-e175-08d87ccfc437
X-MS-TrafficTypeDiagnostic: DB8PR08MB5146:|AM0PR08MB3441:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB3441296ED3057EA638AAC0F1F7150@AM0PR08MB3441.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 0cPQmPeuT8qndjueJ0nsImfMElwMULpjuVxGdFXXEHipZLokKH7yJiA0QTL801kn4y3IDwls87anW4m6dp1yPb8GDledEws5PxIPAjikuO5Lkn+vU3n6VQu82MKoKK/QgetJ+0VHdMuTrv1tIq+vrm6OC9JZNonvQ54Rt5C/uj8jZGae3M9CERVMEsSgiLd4uDhfVrk5nLTQ4n7xo7mCj3PY7Jf8rC/H6YtYBsCkb//WWNVJTU6N9HO9VHsrIsvP9U7huw+UqO6pY19r4+dh7LULxa6AzDJqVSLCJmVfXAW+/5psZ2QcmTcW1pBbqgZ+9skOsVZiozHOp1Exu+5jyGxKyuQhbdMwqZ2SPq/i6KRGA8rFrwjFIagMG4LBdNmV
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5339.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(396003)(376002)(39850400004)(2616005)(2906002)(6512007)(66946007)(186003)(956004)(66476007)(66556008)(86362001)(16526019)(53546011)(44832011)(26005)(30864003)(6506007)(6486002)(4326008)(31686004)(8936002)(478600001)(316002)(31696002)(83380400001)(5660300002)(8676002)(52116002)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3leZrkH4YUskyqYAg4rtJvCjPYWhx59pMwNhK8y6u82WLxGls+aNQkLVfguWOQlWvVY8lv8AonpAC/MvL+w90fE7y9dsUIEm9S6RgBzFlXvrli8GiHSEDoQq2+bYM68c5CfQZXIkaITGVxkujytmbVnBnM7Yo0ZbPRRn0ZqSoiBffQ6HWBWhJCv/cujgn1hCZmj/GCtBMNMSc/0bjX2EsY6/SHKxYA4xzOUHPqFisfaZd3q+PGw4PuaaC3IDkPj6Ojg5Vp7Eh3MbYkyw4KUoydGXILwNAiBEzpOoYfJED91Cdi3IvNUWkz4/GMsvWwd/B9szkkvyIUWDJNl//GyStSWrLJvCRR+e1syxc8tUb7DlAscKGvNUn8KpbpmDK0YMCoEDg2QlTv2yysUt8KAaBGsVkMWZxeuNcdDZa6fB0W0br7my1Ljqnqhcro1R0w8FJCLdVxO4ZsfuK2/UGYrLLm5qqsgsN/9cSulpmJkY5ia59OjiBc2kq0Caaf/c2YW2+XY7RVb5er2NL7bVmcHrXLxypHnFO7/q82EhheKN7GOM2fEiokBvWSftYmDFlrdBQzQ3QJyf7CSu5hDT1brBLm5vGfx/b8NKpMiIzlbLEZVru0c6D0HdUI118SCOp2nAy2InTlh9HyQKnPCYoKE3Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5146
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT049.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 489f67aa-eab8-4708-b0db-08d87ccfbf35
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OsMMYaLhocvaBfXvspXcSZui/rL5izsakEBsB0o92Of7D7oUYi92hY9Jpra3gKEYk+jqoUeIeGkPPPL0X3pTk2o267a5/RWOpsAqaXh3D2YdgG45J3jkLOlNEIxQThnFfoL7fCDYl6RrPK5BwCYiqATZKPaW7KDH6X6Kn5rrAFTK9JDtSBZKcWyq3HQv7Bdc/ZapvmBWlX/5o4fNgS3/sQcDxcAvoAaoufJKhc5v425asd0rQ6oz8CXd2munXosCoae8OSLB4h0PEXF0mhmlU9acrF762HEhv3qziouBfP0LORaGzF6ZgN8CkGZij43WanPmHTTgfcqh4eEwRjufxGOVpE2M2jp51dGoT5+Nb8tVHkfrdi4ZxR70K2fJ14aRLh5+peVnTU98Jg2LyPbB0efmt5qS9y+TEzKHBC+IN5A=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(39850400004)(136003)(376002)(396003)(346002)(46966005)(8936002)(31686004)(70206006)(2906002)(83380400001)(86362001)(107886003)(478600001)(4326008)(356005)(36756003)(82310400003)(8676002)(30864003)(2616005)(6512007)(81166007)(36906005)(956004)(26005)(70586007)(316002)(6486002)(5660300002)(16526019)(44832011)(53546011)(6506007)(82740400003)(47076004)(336012)(31696002)(186003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2020 12:31:46.4226
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dca1effa-b2b5-46ee-e175-08d87ccfc437
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT049.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3441
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

On 30/10/2020 10:46, Alexandru Elisei wrote:
> Hi Nikos,
> 
> I scanned the patches, will try to do a proper review next week. Some suggestions
> below.
> 

Thanks for the review!

> On 10/29/20 3:52 PM, Nikos Nikoleris wrote:
>> Make the translation granule configurable for arm64. arm64 supports
>> page sizes of 4K, 16K and 64K. By default, arm64 is configured with
>> 64K pages. configure has been extended with a new argument:
>>
>>   --page-shift=(12|14|16)
> 
> How about --page-size=4K/16K/64K, which accepts lower and upper case 'k'?
> > It might be just me, because I'm not familiar with memory management, 
but each
> time I see page-shift I need to do the math in my head to get to the page size. I
> think page-size is more intuitive. It's also somewhat similar to the kernel config
> (CONFIG_ARM64_4K_PAGES, for example, and not CONFIG_ARM64_PAGE_SHIFT_12).
> 

You're right setting the page size is more intiutive. I had started 
implementing it that way but I got worried about the added complexity. I 
tried it again now and it doesn't look that bad. I'll post a v2 that 
allows you to configure the page size instead.

> I might have missed it in the patch, how about printing an error message when the
> configured page size is not supported by the hardware? kvm-unit-tests runs C code
> before creating the page tables, and the UART is available very early, so it
> shouldn't be too hard. We can put the check in setup_mmu().
> 

It's not there and it makes sense to check. Right now if we configure an 
unsupported page size, tests appear to be running just fine - you only 
find out when they time out.

Thanks,

Nikos

> Thanks,
> Alex
>>
>> which allows the user to set the page shift and therefore the page
>> size for arm64. Using the --page-shift for any other architecture
>> results an error message.
>>
>> To allow for smaller page sizes and 42b VA, this change adds support
>> for 4-level and 3-level page tables. At compile time, we determine how
>> many levels in the page tables we needed.
>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   configure                     | 21 +++++++++++
>>   lib/arm/asm/page.h            |  4 ++
>>   lib/arm/asm/pgtable-hwdef.h   |  4 ++
>>   lib/arm/asm/pgtable.h         |  6 +++
>>   lib/arm/asm/thread_info.h     |  4 +-
>>   lib/arm64/asm/page.h          | 17 ++++++---
>>   lib/arm64/asm/pgtable-hwdef.h | 38 +++++++++++++------
>>   lib/arm64/asm/pgtable.h       | 69 +++++++++++++++++++++++++++++++++--
>>   lib/arm/mmu.c                 | 26 ++++++++-----
>>   arm/cstart64.S                | 12 +++++-
>>   10 files changed, 169 insertions(+), 32 deletions(-)
>>
>> diff --git a/configure b/configure
>> index 706aab5..94637ec 100755
>> --- a/configure
>> +++ b/configure
>> @@ -25,6 +25,7 @@ vmm="qemu"
>>   errata_force=0
>>   erratatxt="$srcdir/errata.txt"
>>   host_key_document=
>> +page_shift=
>>   
>>   usage() {
>>       cat <<-EOF
>> @@ -105,6 +106,9 @@ while [[ "$1" = -* ]]; do
>>   	--host-key-document)
>>   	    host_key_document="$arg"
>>   	    ;;
>> +        --page-shift)
>> +            page_shift="$arg"
>> +            ;;
>>   	--help)
>>   	    usage
>>   	    ;;
>> @@ -123,6 +127,22 @@ arch_name=$arch
>>   [ "$arch" = "aarch64" ] && arch="arm64"
>>   [ "$arch_name" = "arm64" ] && arch_name="aarch64"
>>   
>> +if [ -z "$page_shift" ]; then
>> +    [ "$arch" = "arm64" ] && page_shift="16"
>> +    [ "$arch" = "arm" ] && page_shift="12"
>> +else
>> +    if [ "$arch" != "arm64" ]; then
>> +        echo "--page-shift is not supported for $arch"
>> +        usage
>> +    fi
>> +
>> +    if [ "$page_shift" != "12" ] && [ "$page_shift" != "14" ] &&
>> +           [ "$page_shift" != "16" ]; then
>> +        echo "Page shift of $page_shift not supported for arm64"
>> +        usage
>> +    fi
>> +fi
>> +
>>   [ -z "$processor" ] && processor="$arch"
>>   
>>   if [ "$processor" = "arm64" ]; then
>> @@ -254,6 +274,7 @@ cat <<EOF >> lib/config.h
>>   
>>   #define CONFIG_UART_EARLY_BASE ${arm_uart_early_addr}
>>   #define CONFIG_ERRATA_FORCE ${errata_force}
>> +#define CONFIG_PAGE_SHIFT ${page_shift}
>>   
>>   EOF
>>   fi
>> diff --git a/lib/arm/asm/page.h b/lib/arm/asm/page.h
>> index 039c9f7..ae0ac2c 100644
>> --- a/lib/arm/asm/page.h
>> +++ b/lib/arm/asm/page.h
>> @@ -29,6 +29,10 @@ typedef struct { pteval_t pgprot; } pgprot_t;
>>   #define pgd_val(x)		((x).pgd)
>>   #define pgprot_val(x)		((x).pgprot)
>>   
>> +/* For compatibility with arm64 page tables */
>> +#define pud_t pgd_t
>> +#define pud_val(x) pgd_val(x)
>> +
>>   #define __pte(x)		((pte_t) { (x) } )
>>   #define __pmd(x)		((pmd_t) { (x) } )
>>   #define __pgd(x)		((pgd_t) { (x) } )
>> diff --git a/lib/arm/asm/pgtable-hwdef.h b/lib/arm/asm/pgtable-hwdef.h
>> index 4107e18..fe1d854 100644
>> --- a/lib/arm/asm/pgtable-hwdef.h
>> +++ b/lib/arm/asm/pgtable-hwdef.h
>> @@ -19,6 +19,10 @@
>>   #define PTRS_PER_PTE		512
>>   #define PTRS_PER_PMD		512
>>   
>> +/* For compatibility with arm64 page tables */
>> +#define PUD_SIZE		PGDIR_SIZE
>> +#define PUD_MASK		PGDIR_MASK
>> +
>>   #define PMD_SHIFT		21
>>   #define PMD_SIZE		(_AC(1,UL) << PMD_SHIFT)
>>   #define PMD_MASK		(~((1 << PMD_SHIFT) - 1))
>> diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
>> index 078dd16..4759d82 100644
>> --- a/lib/arm/asm/pgtable.h
>> +++ b/lib/arm/asm/pgtable.h
>> @@ -53,6 +53,12 @@ static inline pmd_t *pgd_page_vaddr(pgd_t pgd)
>>   	return pgtable_va(pgd_val(pgd) & PHYS_MASK & (s32)PAGE_MASK);
>>   }
>>   
>> +/* For compatibility with arm64 page tables */
>> +#define pud_valid(pud)		pgd_valid(pud)
>> +#define pud_offset(pgd, addr)  ((pud_t *)pgd)
>> +#define pud_free(pud)
>> +#define pud_alloc(pgd, addr)   pud_offset(pgd, addr)
>> +
>>   #define pmd_index(addr) \
>>   	(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
>>   #define pmd_offset(pgd, addr) \
>> diff --git a/lib/arm/asm/thread_info.h b/lib/arm/asm/thread_info.h
>> index 80ab395..eaa7258 100644
>> --- a/lib/arm/asm/thread_info.h
>> +++ b/lib/arm/asm/thread_info.h
>> @@ -14,10 +14,12 @@
>>   #define THREAD_SHIFT		PAGE_SHIFT
>>   #define THREAD_SIZE		PAGE_SIZE
>>   #define THREAD_MASK		PAGE_MASK
>> +#define THREAD_ALIGNMENT	PAGE_SIZE
>>   #else
>>   #define THREAD_SHIFT		MIN_THREAD_SHIFT
>>   #define THREAD_SIZE		(_AC(1,UL) << THREAD_SHIFT)
>>   #define THREAD_MASK		(~(THREAD_SIZE-1))
>> +#define THREAD_ALIGNMENT	THREAD_SIZE
>>   #endif
>>   
>>   #ifndef __ASSEMBLY__
>> @@ -38,7 +40,7 @@
>>   
>>   static inline void *thread_stack_alloc(void)
>>   {
>> -	void *sp = memalign(PAGE_SIZE, THREAD_SIZE);
>> +	void *sp = memalign(THREAD_ALIGNMENT, THREAD_SIZE);
>>   	return sp + THREAD_START_SP;
>>   }
>>   
>> diff --git a/lib/arm64/asm/page.h b/lib/arm64/asm/page.h
>> index 46af552..726a0c0 100644
>> --- a/lib/arm64/asm/page.h
>> +++ b/lib/arm64/asm/page.h
>> @@ -10,38 +10,43 @@
>>    * This work is licensed under the terms of the GNU GPL, version 2.
>>    */
>>   
>> +#include <config.h>
>>   #include <linux/const.h>
>>   
>> -#define PGTABLE_LEVELS		2
>>   #define VA_BITS			42
>>   
>> -#define PAGE_SHIFT		16
>> +#define PAGE_SHIFT		CONFIG_PAGE_SHIFT
>>   #define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
>>   #define PAGE_MASK		(~(PAGE_SIZE-1))
>>   
>> +#define PGTABLE_LEVELS		(((VA_BITS) - 4) / (PAGE_SHIFT - 3))
>> +
>>   #ifndef __ASSEMBLY__
>>   
>>   #define PAGE_ALIGN(addr)	ALIGN(addr, PAGE_SIZE)
>>   
>>   typedef u64 pteval_t;
>>   typedef u64 pmdval_t;
>> +typedef u64 pudval_t;
>>   typedef u64 pgdval_t;
>>   typedef struct { pteval_t pte; } pte_t;
>> +typedef struct { pmdval_t pmd; } pmd_t;
>> +typedef struct { pudval_t pud; } pud_t;
>>   typedef struct { pgdval_t pgd; } pgd_t;
>>   typedef struct { pteval_t pgprot; } pgprot_t;
>>   
>>   #define pte_val(x)		((x).pte)
>> +#define pmd_val(x)		((x).pmd)
>> +#define pud_val(x)		((x).pud)
>>   #define pgd_val(x)		((x).pgd)
>>   #define pgprot_val(x)		((x).pgprot)
>>   
>>   #define __pte(x)		((pte_t) { (x) } )
>> +#define __pmd(x)		((pmd_t) { (x) } )
>> +#define __pud(x)		((pud_t) { (x) } )
>>   #define __pgd(x)		((pgd_t) { (x) } )
>>   #define __pgprot(x)		((pgprot_t) { (x) } )
>>   
>> -typedef struct { pgd_t pgd; } pmd_t;
>> -#define pmd_val(x)		(pgd_val((x).pgd))
>> -#define __pmd(x)		((pmd_t) { __pgd(x) } )
>> -
>>   #define __va(x)			((void *)__phys_to_virt((phys_addr_t)(x)))
>>   #define __pa(x)			__virt_to_phys((unsigned long)(x))
>>   
>> diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
>> index 3352489..f9110e1 100644
>> --- a/lib/arm64/asm/pgtable-hwdef.h
>> +++ b/lib/arm64/asm/pgtable-hwdef.h
>> @@ -9,38 +9,54 @@
>>    * This work is licensed under the terms of the GNU GPL, version 2.
>>    */
>>   
>> +#include <asm/page.h>
>> +
>>   #define UL(x) _AC(x, UL)
>>   
>> +#define PGTABLE_LEVEL_SHIFT(n)	((PAGE_SHIFT - 3) * (4 - (n)) + 3)
>>   #define PTRS_PER_PTE		(1 << (PAGE_SHIFT - 3))
>>   
>> +#if PGTABLE_LEVELS > 2
>> +#define PMD_SHIFT		PGTABLE_LEVEL_SHIFT(2)
>> +#define PTRS_PER_PMD		PTRS_PER_PTE
>> +#define PMD_SIZE		(UL(1) << PMD_SHIFT)
>> +#define PMD_MASK		(~(PMD_SIZE-1))
>> +#endif
>> +
>> +#if PGTABLE_LEVELS > 3
>> +#define PUD_SHIFT		PGTABLE_LEVEL_SHIFT(1)
>> +#define PTRS_PER_PUD		PTRS_PER_PTE
>> +#define PUD_SIZE		(UL(1) << PUD_SHIFT)
>> +#define PUD_MASK		(~(PUD_SIZE-1))
>> +#else
>> +#define PUD_SIZE                PGDIR_SIZE
>> +#define PUD_MASK                PGDIR_MASK
>> +#endif
>> +
>> +#define PUD_VALID		(_AT(pudval_t, 1) << 0)
>> +
>>   /*
>>    * PGDIR_SHIFT determines the size a top-level page table entry can map
>>    * (depending on the configuration, this level can be 0, 1 or 2).
>>    */
>> -#define PGDIR_SHIFT		((PAGE_SHIFT - 3) * PGTABLE_LEVELS + 3)
>> +#define PGDIR_SHIFT		PGTABLE_LEVEL_SHIFT(4 - PGTABLE_LEVELS)
>>   #define PGDIR_SIZE		(_AC(1, UL) << PGDIR_SHIFT)
>>   #define PGDIR_MASK		(~(PGDIR_SIZE-1))
>>   #define PTRS_PER_PGD		(1 << (VA_BITS - PGDIR_SHIFT))
>>   
>>   #define PGD_VALID		(_AT(pgdval_t, 1) << 0)
>>   
>> -/* From include/asm-generic/pgtable-nopmd.h */
>> -#define PMD_SHIFT		PGDIR_SHIFT
>> -#define PTRS_PER_PMD		1
>> -#define PMD_SIZE		(UL(1) << PMD_SHIFT)
>> -#define PMD_MASK		(~(PMD_SIZE-1))
>> -
>>   /*
>>    * Section address mask and size definitions.
>>    */
>> -#define SECTION_SHIFT		PMD_SHIFT
>> -#define SECTION_SIZE		(_AC(1, UL) << SECTION_SHIFT)
>> -#define SECTION_MASK		(~(SECTION_SIZE-1))
>> +#define SECTION_SHIFT          PMD_SHIFT
>> +#define SECTION_SIZE           (_AC(1, UL) << SECTION_SHIFT)
>> +#define SECTION_MASK           (~(SECTION_SIZE-1))
>>   
>>   /*
>>    * Hardware page table definitions.
>>    *
>> - * Level 1 descriptor (PMD).
>> + * Level 0,1,2 descriptor (PGG, PUD and PMD).
>>    */
>>   #define PMD_TYPE_MASK		(_AT(pmdval_t, 3) << 0)
>>   #define PMD_TYPE_FAULT		(_AT(pmdval_t, 0) << 0)
>> diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
>> index e577d9c..c7632ae 100644
>> --- a/lib/arm64/asm/pgtable.h
>> +++ b/lib/arm64/asm/pgtable.h
>> @@ -30,10 +30,12 @@
>>   #define pgtable_pa(x)		((unsigned long)(x))
>>   
>>   #define pgd_none(pgd)		(!pgd_val(pgd))
>> +#define pud_none(pud)		(!pud_val(pud))
>>   #define pmd_none(pmd)		(!pmd_val(pmd))
>>   #define pte_none(pte)		(!pte_val(pte))
>>   
>>   #define pgd_valid(pgd)		(pgd_val(pgd) & PGD_VALID)
>> +#define pud_valid(pud)		(pud_val(pud) & PUD_VALID)
>>   #define pmd_valid(pmd)		(pmd_val(pmd) & PMD_SECT_VALID)
>>   #define pte_valid(pte)		(pte_val(pte) & PTE_VALID)
>>   
>> @@ -52,15 +54,76 @@ static inline pgd_t *pgd_alloc(void)
>>   	return pgd;
>>   }
>>   
>> -#define pmd_offset(pgd, addr)	((pmd_t *)pgd)
>> -#define pmd_free(pmd)
>> -#define pmd_alloc(pgd, addr)	pmd_offset(pgd, addr)
>> +static inline pud_t *pgd_page_vaddr(pgd_t pgd)
>> +{
>> +	return pgtable_va(pgd_val(pgd) & PHYS_MASK & (s32)PAGE_MASK);
>> +}
>> +
>> +static inline pmd_t *pud_page_vaddr(pud_t pud)
>> +{
>> +	return pgtable_va(pud_val(pud) & PHYS_MASK & (s32)PAGE_MASK);
>> +}
>> +
>>   
>>   static inline pte_t *pmd_page_vaddr(pmd_t pmd)
>>   {
>>   	return pgtable_va(pmd_val(pmd) & PHYS_MASK & (s32)PAGE_MASK);
>>   }
>>   
>> +#if PGTABLE_LEVELS > 2
>> +#define pmd_index(addr)					\
>> +	(((addr) >> PMD_SHIFT) & (PTRS_PER_PMD - 1))
>> +#define pmd_offset(pud, addr)				\
>> +	(pud_page_vaddr(*(pud)) + pmd_index(addr))
>> +#define pmd_free(pmd) free_page(pmd)
>> +static inline pmd_t *pmd_alloc_one(void)
>> +{
>> +	assert(PTRS_PER_PMD * sizeof(pmd_t) == PAGE_SIZE);
>> +	pmd_t *pmd = alloc_page();
>> +	return pmd;
>> +}
>> +static inline pmd_t *pmd_alloc(pud_t *pud, unsigned long addr)
>> +{
>> +        if (pud_none(*pud)) {
>> +		pud_t entry;
>> +		pud_val(entry) = pgtable_pa(pmd_alloc_one()) | PMD_TYPE_TABLE;
>> +		WRITE_ONCE(*pud, entry);
>> +	}
>> +	return pmd_offset(pud, addr);
>> +}
>> +#else
>> +#define pmd_offset(pud, addr)  ((pmd_t *)pud)
>> +#define pmd_free(pmd)
>> +#define pmd_alloc(pud, addr)   pmd_offset(pud, addr)
>> +#endif
>> +
>> +#if PGTABLE_LEVELS > 3
>> +#define pud_index(addr)                                 \
>> +	(((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
>> +#define pud_offset(pgd, addr)                           \
>> +	(pgd_page_vaddr(*(pgd)) + pud_index(addr))
>> +#define pud_free(pud) free_page(pud)
>> +static inline pud_t *pud_alloc_one(void)
>> +{
>> +	assert(PTRS_PER_PMD * sizeof(pud_t) == PAGE_SIZE);
>> +	pud_t *pud = alloc_page();
>> +	return pud;
>> +}
>> +static inline pud_t *pud_alloc(pgd_t *pgd, unsigned long addr)
>> +{
>> +	if (pgd_none(*pgd)) {
>> +		pgd_t entry;
>> +		pgd_val(entry) = pgtable_pa(pud_alloc_one()) | PMD_TYPE_TABLE;
>> +		WRITE_ONCE(*pgd, entry);
>> +	}
>> +	return pud_offset(pgd, addr);
>> +}
>> +#else
>> +#define pud_offset(pgd, addr)  ((pud_t *)pgd)
>> +#define pud_free(pud)
>> +#define pud_alloc(pgd, addr)   pud_offset(pgd, addr)
>> +#endif
>> +
>>   #define pte_index(addr) \
>>   	(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
>>   #define pte_offset(pmd, addr) \
>> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
>> index 540a1e8..6d1c75b 100644
>> --- a/lib/arm/mmu.c
>> +++ b/lib/arm/mmu.c
>> @@ -81,7 +81,8 @@ void mmu_disable(void)
>>   static pteval_t *get_pte(pgd_t *pgtable, uintptr_t vaddr)
>>   {
>>   	pgd_t *pgd = pgd_offset(pgtable, vaddr);
>> -	pmd_t *pmd = pmd_alloc(pgd, vaddr);
>> +	pud_t *pud = pud_alloc(pgd, vaddr);
>> +	pmd_t *pmd = pmd_alloc(pud, vaddr);
>>   	pte_t *pte = pte_alloc(pmd, vaddr);
>>   
>>   	return &pte_val(*pte);
>> @@ -133,18 +134,20 @@ void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>>   			phys_addr_t phys_start, phys_addr_t phys_end,
>>   			pgprot_t prot)
>>   {
>> -	phys_addr_t paddr = phys_start & PGDIR_MASK;
>> -	uintptr_t vaddr = virt_offset & PGDIR_MASK;
>> +	phys_addr_t paddr = phys_start & PUD_MASK;
>> +	uintptr_t vaddr = virt_offset & PUD_MASK;
>>   	uintptr_t virt_end = phys_end - paddr + vaddr;
>>   	pgd_t *pgd;
>> -	pgd_t entry;
>> +	pud_t *pud;
>> +	pud_t entry;
>>   
>> -	for (; vaddr < virt_end; vaddr += PGDIR_SIZE, paddr += PGDIR_SIZE) {
>> -		pgd_val(entry) = paddr;
>> -		pgd_val(entry) |= PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S;
>> -		pgd_val(entry) |= pgprot_val(prot);
>> +	for (; vaddr < virt_end; vaddr += PUD_SIZE, paddr += PUD_SIZE) {
>> +		pud_val(entry) = paddr;
>> +		pud_val(entry) |= PMD_TYPE_SECT | PMD_SECT_AF | PMD_SECT_S;
>> +		pud_val(entry) |= pgprot_val(prot);
>>   		pgd = pgd_offset(pgtable, vaddr);
>> -		WRITE_ONCE(*pgd, entry);
>> +		pud = pud_alloc(pgd, vaddr);
>> +		WRITE_ONCE(*pud, entry);
>>   		flush_tlb_page(vaddr);
>>   	}
>>   }
>> @@ -207,6 +210,7 @@ unsigned long __phys_to_virt(phys_addr_t addr)
>>   void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
>>   {
>>   	pgd_t *pgd;
>> +	pud_t *pud;
>>   	pmd_t *pmd;
>>   	pte_t *pte;
>>   
>> @@ -215,7 +219,9 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
>>   
>>   	pgd = pgd_offset(pgtable, vaddr);
>>   	assert(pgd_valid(*pgd));
>> -	pmd = pmd_offset(pgd, vaddr);
>> +	pud = pud_offset(pgd, vaddr);
>> +	assert(pud_valid(*pud));
>> +	pmd = pmd_offset(pud, vaddr);
>>   	assert(pmd_valid(*pmd));
>>   
>>   	if (pmd_huge(*pmd)) {
>> diff --git a/arm/cstart64.S b/arm/cstart64.S
>> index ffdd49f..530ffb6 100644
>> --- a/arm/cstart64.S
>> +++ b/arm/cstart64.S
>> @@ -157,6 +157,16 @@ halt:
>>    */
>>   #define MAIR(attr, mt) ((attr) << ((mt) * 8))
>>   
>> +#if PAGE_SHIFT == 16
>> +#define TCR_TG_FLAGS	TCR_TG0_64K | TCR_TG1_64K
>> +#elif PAGE_SHIFT == 14
>> +#define TCR_TG_FLAGS	TCR_TG0_16K | TCR_TG1_16K
>> +#elif PAGE_SHIFT == 12
>> +#define TCR_TG_FLAGS	TCR_TG0_4K | TCR_TG1_4K
>> +#else
>> +#error Unsupported PAGE_SHIFT
>> +#endif
>> +
>>   .globl asm_mmu_enable
>>   asm_mmu_enable:
>>   	tlbi	vmalle1			// invalidate I + D TLBs
>> @@ -164,7 +174,7 @@ asm_mmu_enable:
>>   
>>   	/* TCR */
>>   	ldr	x1, =TCR_TxSZ(VA_BITS) |		\
>> -		     TCR_TG0_64K | TCR_TG1_64K |	\
>> +		     TCR_TG_FLAGS  |			\
>>   		     TCR_IRGN_WBWA | TCR_ORGN_WBWA |	\
>>   		     TCR_SHARED
>>   	mrs	x2, id_aa64mmfr0_el1
