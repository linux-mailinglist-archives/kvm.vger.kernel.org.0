Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCF836F654
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 09:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhD3HUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 03:20:25 -0400
Received: from mail-eopbgr770045.outbound.protection.outlook.com ([40.107.77.45]:23622
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229590AbhD3HUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 03:20:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=es1Dj/pee8bx1WKqDAwu7g0TA9adhYP5SFBqYFs2NepB4YTrvdOUGyQ9qi4bccomTfh3s96vbVS1sJ1t4p8RDKokGJnm21KDUAWultp68Abekb9q0vFrgVVChE1Yf95oNfXn/pq3k1Cd6+lRIO6yX9oru0/B/APY62avwCNZVprjwnyeWxfbt1AcyVeLj61qWEkIXnvAeL6FI/a+EzOR0R39DskRxIxocMrutNRrTuIzBwr5TCGabRq5eqwiVFAOJKgAN9vZ2q88mO5eXsoy4D3DhLkOJDndnjOHf6s3jTByh4gDzV3UgaAouKdNzcS1kICFRW/7OLPZ07X1baPxnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSYB08/pdXnKkyP3es4gx8XqbBoWmnzulVj5ioalPFc=;
 b=Xx8U0qwTOPjQpbfeLkf1h+YwnTn1SrdnLykgKeUaO3tBGcn8vuPiaCkNWj+egcB8PEmvW9za2qKEeCzEpkEo3nVU4+ZRsTm3geH17wWTvt0e2SQrGeAdcEyfDUaJMUnzdIpISiDIA3bR1Tt+UxI0S5VzY/jDaDp1SXWWnD+hQ2VCZqDUsb4zRcj9IlT9mZcxcbLTbXKfLNygTsSofyI56LLTKcu276ojpOFfRu7UIYa3CxWq9rxKLr5QRsELWhGdO/++T1vL/SWAiWk/3+JyUahYWjoWkvW6oGudpPfQruC7GB7xGW7ACZ+ZIAkByLiaq1O4++P0Q0M6RwDHNDswXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSYB08/pdXnKkyP3es4gx8XqbBoWmnzulVj5ioalPFc=;
 b=nH9GSdjS8OZynj6NeWyilZx8UDQ/ufaKVgBLNdiDG2RHy66Nbs4aSRyRe5/mIOXEndZcKWxtaJBF47hPBTFMy1Y47B7CAycNPyH8MGhPUns0zih2uYEcYyK/Vvyi3AXYCdEx4HZtbjdpB1uZgGiYu+baRhlFJ0knEDm2ZglJqj0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB4750.namprd12.prod.outlook.com (2603:10b6:805:e3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Fri, 30 Apr
 2021 07:19:34 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%7]) with mapi id 15.20.4065.029; Fri, 30 Apr 2021
 07:19:34 +0000
Date:   Fri, 30 Apr 2021 07:19:28 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v2 0/4] Add guest support for SEV live migration.
Message-ID: <20210430071927.GA8033@ashkalra_ubuntu_server>
References: <cover.1619193043.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1619193043.git.ashish.kalra@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0001.namprd05.prod.outlook.com
 (2603:10b6:803:40::14) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN4PR0501CA0001.namprd05.prod.outlook.com (2603:10b6:803:40::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 07:19:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a790cc68-164a-4bda-4d21-08d90ba84dde
X-MS-TrafficTypeDiagnostic: SN6PR12MB4750:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4750762A2DF7E88234A655848E5E9@SN6PR12MB4750.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CaemU0XvChl9eaZ3aTL9NoTsSIcMQ0l/lqM1qZG/l3mMxwcKnJbaKwNK+CefePL5Gbd0ciLKTSzEB4dqxoKDfXsMLkwN15GEpDAASkibRXs+otNqY+ADZsl2J4L3Ok0DaVUqHY47OKtAR17NY+Kd+gMds6WHTjnbZplYGdDDZ7Yp4ze3MnrkEa8yS0x9cK9+pxbh/XTcn02UX2zSTYblJ1PS2xUeBh5OIOx+UCXzXBu8DTPY2N4z0wTEkdyovhUTeApCWCQYxtM4clCJBKTnWOjJ7lTU4TAxBpatWFEIzIkKsZnIfbLYDK/KvoF3+vwnRmVpD6Uy3Jim5tY7YHPvvd/oNuG+g3C0niFX4fnuMbJiO7k7Wy/b02bXz1rtlMKPjwQCFwaZsy/LQgz3txC0wRlk8FjR1OdXEfJyg2gfgnIaeys9B59+zTEnZrnPkyh6JFpIiIPNryaq4ACokKUGGW38lIDSN68r0L55MyXMtwR4+RpeqdT+m0dSstlRKKQ6yl/HIzQTCqxaZnfxi/mz0+qoNWB1kN1+47iNtIujfglrO7JdOCl21XjJjU2Duc3lXIUs9tBcWRgI3wultL5zDTFPK3NVHSyPSWegr+3rLaWOsF/VYnKwV2al7jkLSr9RxbOqyXC+yNO2TsDCs7uKu9alwi2VPdIacdB17ifMupk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(39850400004)(136003)(346002)(33656002)(83380400001)(6666004)(33716001)(478600001)(6496006)(316002)(86362001)(52116002)(7416002)(55016002)(9686003)(8676002)(66946007)(66556008)(66476007)(6916009)(38350700002)(956004)(5660300002)(4326008)(186003)(1076003)(16526019)(38100700002)(8936002)(26005)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RJ/1+8zGRLEHYr2KbFxoBzRY28UbjDlW37GUj2J1pKEn/8b5iuVmwnFacbBr?=
 =?us-ascii?Q?913zymISCihi7frLRX2ZIdt7NnDwfxPqUUDV96qzT53GPTUSKwRMA6yEBrQ9?=
 =?us-ascii?Q?a2qH9nDKu5+98K3YTLEbFNi5Njd+kqkVAASAzKFqKG7CmkdhElkWr9Nd6SCk?=
 =?us-ascii?Q?XYXnTAOIpqsW3yHvgUL1A7K8GwTLprnUTHzbyr8Rp3icfifGEcpLXVmtyylV?=
 =?us-ascii?Q?d54jv0S2jdlnJ9sFPwrrDcEgsTCuwZsN6JKDmuryRtMIHw/X/SN0QGmgtug0?=
 =?us-ascii?Q?oy2quYW+aq4FPX0pxuLOZFCExn+KfWrLarKoDBVX4oa/Sd4LpLMqe30yOjPU?=
 =?us-ascii?Q?pVWn0lSQxaJFZdPTXGI9v0t1V+SYs6K35oM6T9lBMcBXSdAFnBH90dnWhnTe?=
 =?us-ascii?Q?DheYomcj+EBSSOFvp8Ei3NGTx50B7bUhgnV02BrUAOF62YvzAyzWUq7/2zzz?=
 =?us-ascii?Q?CTQQ/Zv++wLDmKnPAir3he9O5j6Xyl6MWRCUtFN95NrJViSPAi5QPTfQ6ui0?=
 =?us-ascii?Q?Xuqc0br0wVExGG4Smu+pvw4xi2OC79i9MI+6dT1qdMNCicrak7FarMv30/5Q?=
 =?us-ascii?Q?b8Q2om82NWycT2KfSpLA4k11H9XRljE/tdO/2K8NoGMOm9IT7iw7JoyhTSLt?=
 =?us-ascii?Q?tDSEIG9gViC6DpCiU5QV5K29wvgL1PX8mt6tNvqyJVIcvEw5VVGUJPF12m72?=
 =?us-ascii?Q?anV577SJmIrTKD7CUL7Qmli65SiiW9sa3IcEGc92qjFmDqUv0su9gQZYxEaV?=
 =?us-ascii?Q?lKJjtyJo4xLq258qzRkRGCoN9zqQmaeuZxbCMOHZLkS2I105JhsSPA89vW7B?=
 =?us-ascii?Q?KAGIUJEQKZ1sCNywv/6coLGgH2Bq/+0b8vWOMxYkuQe3OcgZqsd15IR00Xso?=
 =?us-ascii?Q?IL788qqS3CaTKeNUBcE8gPxlvSCN23yvAVC0YelRyJDH9AdEno3E8BFM/CcH?=
 =?us-ascii?Q?1kTElm5StpRNi8oxVgCLGjoqh23JRJkgWMoUvBVY9adLjgAV4K/Zd+nBfcQ1?=
 =?us-ascii?Q?n9rQ9O09qyomejetye6zZCiOx7XsycqzPZZhWgtbJJBKgr42a1bXy9Q6q3Bh?=
 =?us-ascii?Q?hUHYKTvwZh9Lb47zs/zXyd5PcMYZsx0SmHseU74PSIXMqJ2HClqg3QRRmZhC?=
 =?us-ascii?Q?qalbf70zLqs0UHOETFYbjpf7+AANtntebXQuecXZS8nWlsHgl8tgEJHmr0yv?=
 =?us-ascii?Q?H0ZhSXvjs/LE0k/jKcoydDVOqYT1Os+05FzwSZZD0GSjHhm5AMQJguItIRyY?=
 =?us-ascii?Q?g/uQAaZ9Oq3pLK+EkWlVXNbIAjFPq1yWY/uB1NzWrsRCUm5XX3rAeqF/zLuc?=
 =?us-ascii?Q?vwBXOBETTqgtBY9kfrI28/CU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a790cc68-164a-4bda-4d21-08d90ba84dde
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 07:19:34.0320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yFnIrvpCHxiPs9eepyR4kLvqgmAv95IdNy3sD1/OBNFAedULfk5Uh9jVAS3iVOW5cG2mvJu8X9riDbkcekuCZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4750
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Boris, Paolo,

Do you have additional comments, feedback on this updated patchset ?

Thanks,
Ashish

On Fri, Apr 23, 2021 at 03:57:37PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> The series adds guest support for SEV live migration.
> 
> The patch series introduces a new hypercall. The guest OS can use this
> hypercall to notify the page encryption status. If the page is encrypted
> with guest specific-key then we use SEV command during the migration.
> If page is not encrypted then fallback to default.
> 
> This section descibes how the SEV live migration feature is negotiated
> between the host and guest, the host indicates this feature support via 
> KVM_FEATURE_CPUID. The guest firmware (OVMF) detects this feature and
> sets a UEFI enviroment variable indicating OVMF support for live
> migration, the guest kernel also detects the host support for this
> feature via cpuid and in case of an EFI boot verifies if OVMF also
> supports this feature by getting the UEFI enviroment variable and if it
> set then enables live migration feature on host by writing to a custom
> MSR, if not booted under EFI, then it simply enables the feature by
> again writing to the custom MSR.
> 
> Changes since v1:
>  - Avoid having an SEV specific variant of kvm_hypercall3() and instead
>    invert the default to VMMCALL.
> 
> Ashish Kalra (3):
>   KVM: x86: invert KVM_HYPERCALL to default to VMMCALL
>   EFI: Introduce the new AMD Memory Encryption GUID.
>   x86/kvm: Add guest support for detecting and enabling SEV Live
>     Migration feature.
> 
> Brijesh Singh (1):
>   mm: x86: Invoke hypercall when page encryption status is changed
> 
>  arch/x86/include/asm/kvm_para.h       |   2 +-
>  arch/x86/include/asm/mem_encrypt.h    |   4 +
>  arch/x86/include/asm/paravirt.h       |   6 ++
>  arch/x86/include/asm/paravirt_types.h |   2 +
>  arch/x86/include/asm/set_memory.h     |   2 +
>  arch/x86/kernel/kvm.c                 | 106 ++++++++++++++++++++++++++
>  arch/x86/kernel/paravirt.c            |   1 +
>  arch/x86/mm/mem_encrypt.c             |  72 ++++++++++++++---
>  arch/x86/mm/pat/set_memory.c          |   7 ++
>  include/linux/efi.h                   |   1 +
>  10 files changed, 193 insertions(+), 10 deletions(-)
> 
> -- 
> 2.17.1
> 
