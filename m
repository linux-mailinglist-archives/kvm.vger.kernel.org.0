Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111C03B9820
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 23:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbhGAV11 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 17:27:27 -0400
Received: from mail-dm3nam07on2084.outbound.protection.outlook.com ([40.107.95.84]:28897
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233902AbhGAV10 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 17:27:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HbnDEFVGeL2eLtlSU/4EDEE1WhxssHmni/WpLvu+IZCzWE/UEORTrzeCXy8nFZu9kLAe2AL+9fk58lFTZD0jq7ube8q0mBwUG7eVfXef2z1IOsWVKQOCAiHt8+ACciH1NEIz5g0bF70iBgoem26UmUbxKk0hchADeyhNgYhvjvAUiuwyeQB80YmPjIFjnwIUDYJHT72nAs1DsaAnklv1hVjXM6jc1b4qa2LkyCrsujvhnrlIjkwkRjscclzSXlkrajCTZID7axiwkrF59djyL0p+BgRCVkBQdY6nG5qDjpipahoXxsVFLo9kapggHgDsQpf02Woha20FLHhMZMLsiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lY9XVsA7RwNZHJPeOGBolhBN2Kw57bZeyGT0DlVxDI=;
 b=EWKAs8cwv9Ueo4zn0P+4j5n/K3/8pSzr2CI3h+adHTwAH0El1UpNgYsMZfLZb2gYqSXIRR7DpDb0x188hl9UmRWvJS6+SRX4upjdS54N+7qb9RlAEwp+4OIP608xhuMrq4DPMssQ3pSbotnqU9uuL+idb+g4qV5mrr5Z4pxwEf7eVzKuzqqRYq6GbnYSTVIm+IkJ+As7FRETJF2fkfM8+ANFdWWK41Jmm8jXkFaB1GeNQhSUqmnSbNav+FQWh/ekWJxnODLRB2GnMiwd9CSKjRRBPfRGawoLR7ZYjrZjoPpYzIyNIOki4ZGNwhXy3x8uKywRFEMTAZ+jjuLSdLHMvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lY9XVsA7RwNZHJPeOGBolhBN2Kw57bZeyGT0DlVxDI=;
 b=DV1HbfXx+TszndgvJXJC6wY6o7zUsx5qqxQ3LM1JTR+60yNcghLm9KkWmXUsdrIAI/RB5OZGkUqMLyTRs3WaY2KTYvlS4uv2/elWOApJibkuY0SHtyhpcr08CPQ8EVzD/GIjyzenF29N16hUEL+s7A8vYVkxHVCsgnD/U09nu8w=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10)
 by SN1PR12MB2511.namprd12.prod.outlook.com (2603:10b6:802:23::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23; Thu, 1 Jul
 2021 21:24:52 +0000
Received: from SA0PR12MB4557.namprd12.prod.outlook.com
 ([fe80::44db:37d7:2a00:aa7f]) by SA0PR12MB4557.namprd12.prod.outlook.com
 ([fe80::44db:37d7:2a00:aa7f%7]) with mapi id 15.20.4287.022; Thu, 1 Jul 2021
 21:24:52 +0000
Subject: Re: [RFC PATCH 0/7] Support protection keys in an AMD EPYC-Milan VM
To:     David Edmondson <dme@dme.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
References: <20210520145647.3483809-1-david.edmondson@oracle.com>
 <cunpmww227f.fsf@dme.org>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <31dce00c-71bf-6d30-a1d2-f0b6ce743db2@amd.com>
Date:   Thu, 1 Jul 2021 16:24:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <cunpmww227f.fsf@dme.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR16CA0055.namprd16.prod.outlook.com
 (2603:10b6:805:ca::32) To SA0PR12MB4557.namprd12.prod.outlook.com
 (2603:10b6:806:9d::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.0] (165.204.77.1) by SN6PR16CA0055.namprd16.prod.outlook.com (2603:10b6:805:ca::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Thu, 1 Jul 2021 21:24:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b28252a4-7ca6-4b51-6523-08d93cd6a9e3
X-MS-TrafficTypeDiagnostic: SN1PR12MB2511:
X-Microsoft-Antispam-PRVS: <SN1PR12MB251115A76B304D2D021B03FD95009@SN1PR12MB2511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mr/dLQTW8ob5GJljuW8JQmfjON7Usc+bBG81M3iTaNwhu07wwqDRFeRwziLb5XEorIOy618LflKmdvjwskJLfeAT9FOmTe7Eh9WP9dnu+VrgOUdfXXjGBiDW+RqVu8ghpqLuH/ZGTP4NVxmrtNRMGWnG7bVUym/992nnz4bxEjJHdeKSnywkxBKHYV/NEQQrW2oD5Kudq6SkZT+SdmpoXhILe84hGmlwFHmWlUeQXiP1SUfb3yxE/9tGDsWBoAmcRnRe9xkNE7Qd4zDyYKTxy6vzN6QMhHbKryvOceZyZ7XTW2Y5Y918XTsDZ0dlnjEEiCBNnIwwA+ChOpd89mew9XOTql2kH56mzIAkqh3wiV96gx/ftPYICNHPsZ+5TGXQsRoRNAww+zpl+UXTgQ4NjJZ75TYceGo3wMNWreLHRP82Ihylzbty8JP8yI+GjzlM1jdXENUQs4msXEgSs10Tw+rWZi1DeXo/hcOCuWq4DrU2XgifmDabm3jaUSPSyw3RkJ4QyEx2p74h156lr3afvAfyp0sJI0ICtCLuHOsc3ZvrpxVGKfmqLEuxZQ7joF2jvldwAoIEvjkNgsvECT5CeOaJPrylmzxebkcGus5GoOhl4mlKGD7gf6Zht7QB8Aq0jCqQd/lcAoYCn8ITf1PLyXNg4ytc/p/M65qszqEB++7etBtNNRAlqgioKewzHP5sPL4uFOhzRBp0vlMnIYhgwsWyqKXU33hyhksA6dgIMhgO52aV2e911PVG2QXDDC0o+BoQWsvggPDUXibPMgf8hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4557.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(83380400001)(36756003)(31686004)(478600001)(6486002)(26005)(956004)(44832011)(8936002)(2616005)(186003)(53546011)(16526019)(110136005)(66946007)(4326008)(31696002)(86362001)(316002)(2906002)(16576012)(38100700002)(5660300002)(8676002)(66476007)(66556008)(54906003)(38350700002)(52116002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?Windows-1252?Q?MCKx7C27sR4GmMKJPA9ecvfKHODAkPduBCM9s89KML9jANLu/xA4syWw?=
 =?Windows-1252?Q?WIK0qCYbOPo+44fiM3glTh4lr1+Okq2dQiw6mRFhmUidlDoLL2GBlToo?=
 =?Windows-1252?Q?WtkGnoExrdaR2+4Xh07vYSjacenyc6JLEtetgP7s3cTM8d+iaorR0dkb?=
 =?Windows-1252?Q?IYI07tc+6WWTdxrZG4N3VdLEQfXOGKBUC2fmGcLWyEGqnSvvbcgAjFOg?=
 =?Windows-1252?Q?6QxxZka3xvzgMGl9Ure1TtunGV7cdpppPNREtUczK8h1YZu8p9f8TzhG?=
 =?Windows-1252?Q?JWcdwTGGtz+MOb3UyFoE1L2g/ujUY65lQC75y6ue0sBW0n/hcGEEJKtT?=
 =?Windows-1252?Q?2P5Eysaib3R0Oh84Nw4Md/4hwnngY1RNkoYbuGLtOb0JaATrDcM822cD?=
 =?Windows-1252?Q?fyISKpOxPmygN6X8vRcqHi9cFO24vdlVsHsMlu2TEhnxvUYTkbD0uRRS?=
 =?Windows-1252?Q?edk843EXvXcd034f6xdsL4bMkrKa5z8bBNoqsYcolS8XWqfPUZpL19Lg?=
 =?Windows-1252?Q?V88YcotnbclQ6Cyrmdlbf5SGPqNsb+XTX69FfMwH+/hmmSShMfy/qH64?=
 =?Windows-1252?Q?1bt/IkL+WrYKi8vxSwpWh789nPI4n/SVGGQZzUhGAXEysO0XZ1nxA4xE?=
 =?Windows-1252?Q?JLxqdNfzkLX9C0UtgvgC3P1hcfErpQwrLeKkM41sldoSITYN0DOsrWig?=
 =?Windows-1252?Q?4WVSfZ9o9mdzuy1A7vPvqdkuGjM6MV6YyxQdSFK4hjlgiLYEYk0lcU+2?=
 =?Windows-1252?Q?ejlYmfeF6IPGBUYzTLUULEDwEr9dPWcPdhEYX+NEQZQzTnYO3j8POm6t?=
 =?Windows-1252?Q?prX3g5JZGS2U0OiJntRuh94uYg9bSaWjVADwwtGkPsCZWgMBFDqU1qAI?=
 =?Windows-1252?Q?Ydj0cWyI5i+5wJnB/DYJf+lLXRNqIjRT2lXVK1H6t5v6YZlwQRu3laGN?=
 =?Windows-1252?Q?pNDlmdADwvEPSq1XAFECPibgcEhZufdTxi8DpRGcZvFstSpUQbIt30pw?=
 =?Windows-1252?Q?2i9EATACit1VnHpTG6rUeegS/es0sQBJk/Bx2YhC3qETbA1u7pTlHjLy?=
 =?Windows-1252?Q?d1ulIg5whZ35LdpSUS3aP4rr/fhUI6lnbe4BoC4FoV7ca+SNELdmgL4d?=
 =?Windows-1252?Q?Z7ldoKSzT5uy4haI3CTbQ9BUbANfqVDdA86zylCCTyZbqtjjgyZKaJre?=
 =?Windows-1252?Q?DyRWmpSRflBGL4vma16it1FuWCwosgsMpCwwYtURn7zPTrCWIte9kZov?=
 =?Windows-1252?Q?BCiFSYaIK5RrqMvKPHxy9D4R1xxAij8IUlKDeEzUDggRrlyrXfHUQj5n?=
 =?Windows-1252?Q?e0Vx6gaFE8qBeNhkSg7VUJk5BWjjy99tZGdiS6QGHqZEXkPNQdrO5fLa?=
 =?Windows-1252?Q?79hBF5GfRVVL9F4ljykyRpmldbnf3/UIso2qjBxBJY4RJhskOR4hwkz9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b28252a4-7ca6-4b51-6523-08d93cd6a9e3
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4557.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2021 21:24:52.2766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q3xC3zmC9loWBcIePAzbhgTDJuFIZi351UX0mgCDmLBtEfSVHxcvn9TcsGLgAIdj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David, Are you still working on v2 of these series? I was going to test
and review. Thanks

> -----Original Message-----
> From: David Edmondson <dme@dme.org>
> Sent: Tuesday, June 8, 2021 3:25 AM
> To: qemu-devel@nongnu.org
> Cc: kvm@vger.kernel.org; Eduardo Habkost <ehabkost@redhat.com>; Paolo
> Bonzini <pbonzini@redhat.com>; Marcelo Tosatti <mtosatti@redhat.com>;
> Richard Henderson <richard.henderson@linaro.org>; Moger, Babu
> <Babu.Moger@amd.com>
> Subject: Re: [RFC PATCH 0/7] Support protection keys in an AMD EPYC-Milan
> VM
> 
> On Thursday, 2021-05-20 at 15:56:40 +01, David Edmondson wrote:
> 
> > AMD EPYC-Milan CPUs introduced support for protection keys, previously
> > available only with Intel CPUs.
> >
> > AMD chose to place the XSAVE state component for the protection keys
> > at a different offset in the XSAVE state area than that chosen by
> > Intel.
> >
> > To accommodate this, modify QEMU to behave appropriately on AMD
> > systems, allowing a VM to properly take advantage of the new feature.
> >
> > Further, avoid manipulating XSAVE state components that are not
> > present on AMD systems.
> >
> > The code in patch 6 that changes the CPUID 0x0d leaf is mostly dumped
> > somewhere that seemed to work - I'm not sure where it really belongs.
> 
> Ping - any thoughts about this approach?
> 
> > David Edmondson (7):
> >   target/i386: Declare constants for XSAVE offsets
> >   target/i386: Use constants for XSAVE offsets
> >   target/i386: Clarify the padding requirements of X86XSaveArea
> >   target/i386: Prepare for per-vendor X86XSaveArea layout
> >   target/i386: Introduce AMD X86XSaveArea sub-union
> >   target/i386: Adjust AMD XSAVE PKRU area offset in CPUID leaf 0xd
> >   target/i386: Manipulate only AMD XSAVE state on AMD
> >
> >  target/i386/cpu.c            | 19 +++++----
> >  target/i386/cpu.h            | 80 ++++++++++++++++++++++++++++--------
> >  target/i386/kvm/kvm.c        | 57 +++++++++----------------
> >  target/i386/tcg/fpu_helper.c | 20 ++++++---
> >  target/i386/xsave_helper.c   | 70 +++++++++++++++++++------------
> >  5 files changed, 152 insertions(+), 94 deletions(-)
> >
> > --
> > 2.30.2
> 
> dme.
> --
> You know your green from your red.
