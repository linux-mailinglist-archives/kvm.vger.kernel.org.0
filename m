Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265D8402D32
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 18:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345105AbhIGQvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 12:51:48 -0400
Received: from mail-bn8nam11on2075.outbound.protection.outlook.com ([40.107.236.75]:27918
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344220AbhIGQvr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 12:51:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGHMJx4oLKFb6emJJJhSTArxIesW0i0U03OgNhL3fXXGN8c5ZIijmik6J5SYjXVgYZIVVZvewL89cpaxT9Dx9yssF7jyKl5LJqaqpxJ9Pq7NAdYBzvkOJASre3bQ2HQ/bcbaSxkUXyZKY3hmMD8e+va784j98P319asOlsSSmjNOlZGHaguAB9LW2Qk1186zkHEiiYusAXNc0ST7ZRFFrSULMAgAjvZXpgoy2z+9VQz7RVI6A/RYLxqCai/utvtZFDOBU0PedmBgQe4pYcrc1pYr71QP/e0kQan+9SFns0+RpVDbo09nJwB4W7aB9Os9JoshT0lXgcxOFBY8bTrBGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=FSfpTRwdRG1BCHyz7OmlgyanEj+Po9oHFq/wgwsAGXM=;
 b=dy8EPcEMEUSlefCWxrthqHNN5wSHKaZF+SKrFMNzhKuh//PQwIr/fFsgt9apX9z0WUAyTnmEQ875nMvijCVP2J0p4Yc/0/5UQk1VnKAwVjzWbpYobMmwmxNvi0zK7LyfFT6Tc5dEA/io+tYD8YBcPbM/BPH+n8rk38lg1VBrHdxdH1K3crxuJlaxPoJiLd4QjWNDHwYMlcGW+ah4qE2mbb4YXgJOhlo+vB5K60JuXRhograLE/9HAEl392t9nY/MHscaHZ4+pARTyy5PIk2hUA6AGZxdED74ZmZrol75sIwVf5V79BvgLBBM5b3sMENOM+mBJ/h/TSrSWiJ3A0NYzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FSfpTRwdRG1BCHyz7OmlgyanEj+Po9oHFq/wgwsAGXM=;
 b=mgwxVouUie+P0R1Y8Q6se4ToyZ57Thzvp8/Tqsf6B5Ekllj7IvGFn3C/GVH9AmpFcfRjLx82auH6zF+ZF4vdONnKpXSXIcFopor18KmrzwXnPCKMVvYJaTfO1x3y1wMiFhH6hveYcUoNh/XwSklBWtD5xKUwLxuPYZVjXGPmnO0=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB5019.namprd12.prod.outlook.com (2603:10b6:610:6a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Tue, 7 Sep
 2021 16:50:39 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353%6]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 16:50:39 +0000
Date:   Tue, 7 Sep 2021 11:50:33 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Dov Murik <dovmurik@linux.ibm.com>
Cc:     qemu-devel@nongnu.org, Connor Kuehl <ckuehl@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: Re: [RFC PATCH v2 11/12] i386/sev: sev-snp: add support for CPUID
 validation
Message-ID: <20210907165033.56bkajbopc3zchl4@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-12-michael.roth@amd.com>
 <8c89a4e7-8d3e-645e-c2a8-16f3c146ef32@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c89a4e7-8d3e-645e-c2a8-16f3c146ef32@linux.ibm.com>
X-ClientProxiedBy: SA0PR11CA0194.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::19) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
Received: from localhost (76.251.165.188) by SA0PR11CA0194.namprd11.prod.outlook.com (2603:10b6:806:1bc::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Tue, 7 Sep 2021 16:50:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68080fc7-2af8-4620-ef28-08d9721f9f17
X-MS-TrafficTypeDiagnostic: CH2PR12MB5019:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB501944DDE66765EFE6D27E3395D39@CH2PR12MB5019.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vTZI6O2X6Jw9Y0jAXX6vAJ0qb4OVxtdX98T2r8SKS4BTy/7HBx+F64q5rtaPcejowsP10k47KlHfZiQ0ibXsVJODroE2rbf2XeYFWMGpU1JDpW+4D8wo4B0A3Gqd4XN8T7Ax0/Tklv5zY22SBJsMqTIxLNG/xwgYNLJyAMxXS3DHuZeX9ltFfaHXKGCE3lUKVqpFFi/za6ac4kFhYpZUNJ9NcV3SY99+Orf8Ous/SLwLfCCoUpC63xgWpDmTJWQh/CGkwyaSJndF3cYXSMJyRb0OlJvJ85i47wexH7Yl3bh+n0GZZkZd+a3b69xouu02qQXM4sRcygUBzuQQi6dqlBnYIPmw9MNA+N6dUzNpB3+D6ldIRNQRTS1TJSJ/ytYKzZ6NqalEWOM1sw06gQ31M1yjYhkr/NoT6aszVpdcvh8klBMZYRvUQ6U9Bgfas/3lQV1Z0IZS2vOOWc/pklcDUrJf36VpE55xpQZSbwB1wY8lj9HCKUpmvxpIgcTEQ3Y2du9igyVxfdI+XvDhiBDle0IfnYldmQSGhBiyMc4UHIo1URj8fLznNcjDYqOuqDzEypIbu00u9PhFaoUOTxq0bnAXTOP/1DgmmaNR3u2GgC2A5FuvOLyMpjWW4vQnBe4p6RTpYHkPdwP59hg1hGzpudnrXVrxxQ94LizqpiCaHRKjb9JHs1C8iZU99Bvz50gxicBBIMZ7IV6RdGH7FxytQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(956004)(6486002)(86362001)(38350700002)(38100700002)(4326008)(186003)(52116002)(8676002)(7416002)(2616005)(54906003)(44832011)(6666004)(316002)(83380400001)(8936002)(26005)(66946007)(6916009)(36756003)(66476007)(66556008)(53546011)(508600001)(6496006)(5660300002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9iCj225YlW1k1GPWX0rTVhuIlkZRDVNWVWupC0cNGlyhUiZ/U1PYwu9AWAA/?=
 =?us-ascii?Q?7H9+1bXl80G2qruk/cTNkVNS0qwauM/hm93kc5GOEZ6DpJDlTPwBOCi+vi28?=
 =?us-ascii?Q?Y0rcGOIbFmL9PJMjf5KvKA7Ns89jJLkOo511s1dBmUARC2Fwnq1xDXO8XpQq?=
 =?us-ascii?Q?oN0+Qn4gfEpiuLF4D/bBt1Z4TBOS/SSMhTkvCrLIT4Wir4OYtzl8V1VIRfS7?=
 =?us-ascii?Q?6ugOluCZugYmtpQ1ejDyW3/MogqIFHzJ/hQ7yQp+5/lvwW6dIfQ4Wp4c26lg?=
 =?us-ascii?Q?pyM2gvL9BlOFtsYtwNoDz4jiIDI58Mr6QdRwzyVejh/4Mwyj2Nq5V/6WqR0d?=
 =?us-ascii?Q?b29gcjxUXlF8aIGdPpF/oX/TDc5+GqmzB3p+VGu2hii+saNiXOsMC7Ilkg2R?=
 =?us-ascii?Q?X8kq6WSWRDQDBJZ7QRme1Rc6Lj72O3x9l8ebq70HXSdHgUSTPfEdASDBcqEh?=
 =?us-ascii?Q?n3/2dVYd2GAz6CWGau+dJ0fE12BIh1hefqMYFqWD1+tj+RVjp53/DqeuFtVn?=
 =?us-ascii?Q?XJdZy7DHZft9RFlkZWRHKOb2g5mq1xM06R/XMxsR5kP6ruyIYb7aIs1V9edy?=
 =?us-ascii?Q?rcQL1eFt8iaNenMrHr7jWtbnlYwWx4D4LlUyu7n8yqN3CHmrVGAy2Huxj6Nx?=
 =?us-ascii?Q?JPmhvJqmTCJIv7rtZDfHVpExlaBN1g6pPxokyeu4quLBfJmRfyGF9OhWzjwA?=
 =?us-ascii?Q?P2eGP7pVdQsMOW0iMLErsTkDtox2M4kDGUkeXErDAz1DlEuB4SID+yBrWjvs?=
 =?us-ascii?Q?Z/gMHWIgaOvRw5rSn6J9suel3qQsMiYRx61KcPRfDBEeKC+P1hWEbyGjpa5p?=
 =?us-ascii?Q?pqPXF3kH+MN3hlD/1fsrt+0r2uO8IrhYi6DnXIMHDn5aFRCKfP/Tu8obT3CC?=
 =?us-ascii?Q?Be3pNk6No1RCk1l/G9G1HtL2yGDU+qrCfG8PrQLJ+0mrt0Das8AwE2M8R5Ge?=
 =?us-ascii?Q?F/ptkInqguLbxwJzy3w5diK+q3xLHv6TRXq64hIQBeGDB41L48FrEYKhC+fb?=
 =?us-ascii?Q?zEzX49uLaD117tiHcQX/TL89PPILr97HtUlkR4D74IALzlGfbRouvXtK6v9Q?=
 =?us-ascii?Q?jHokYOtAHdlc+fA0EO3lbaSQ5r4gUjEejruuwD/O0KOE6N7xncdKeqA1KZdJ?=
 =?us-ascii?Q?EirDUoukYUbEeestONUKyUT4C8v4QpXzuGNDqZI/wjCCwe+nL+/ZxrHiczP1?=
 =?us-ascii?Q?saJsD1JbPjwZAxCVGj8qUMlHF2ZWImC5KBhgsARDfFiXQuqbzaqSi0y7mN/P?=
 =?us-ascii?Q?zlEFISdae4hIMvIZY3pOOeLSVXJnKs0WOzQ2Anp7CqA5xaBc7hAqe7crcooz?=
 =?us-ascii?Q?+29T5O4smbA3siC/xO+UkUlB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68080fc7-2af8-4620-ef28-08d9721f9f17
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 16:50:39.0395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ocG65TO5meZpU/LHwbClHtcqbZ5aKbBPl6e1zJFeQm0LVxwArXYDEcF/0a6dxYIRMbJVF30Hv3M1wakvxZI5xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5019
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 05, 2021 at 01:02:12PM +0300, Dov Murik wrote:
> Hi Michael,
> 
> On 27/08/2021 1:26, Michael Roth wrote:
> > SEV-SNP firmware allows a special guest page to be populated with a
> > table of guest CPUID values so that they can be validated through
> > firmware before being loaded into encrypted guest memory where they can
> > be used in place of hypervisor-provided values[1].
> > 
> > As part of SEV-SNP guest initialization, use this process to validate
> > the CPUID entries reported by KVM_GET_CPUID2 prior to initial guest
> > start.
> > 
> > [1]: SEV SNP Firmware ABI Specification, Rev. 0.8, 8.13.2.6
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  target/i386/sev.c | 146 +++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 143 insertions(+), 3 deletions(-)
> > 
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index 0009c93d28..72a6146295 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -153,6 +153,36 @@ static const char *const sev_fw_errlist[] = {
> >  
> >  #define SEV_FW_MAX_ERROR      ARRAY_SIZE(sev_fw_errlist)
> >  
> > +/* <linux/kvm.h> doesn't expose this, so re-use the max from kvm.c */
> > +#define KVM_MAX_CPUID_ENTRIES 100
> > +
> > +typedef struct KvmCpuidInfo {
> > +    struct kvm_cpuid2 cpuid;
> > +    struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
> > +} KvmCpuidInfo;
> > +
> > +#define SNP_CPUID_FUNCTION_MAXCOUNT 64
> > +#define SNP_CPUID_FUNCTION_UNKNOWN 0xFFFFFFFF
> > +
> > +typedef struct {
> > +    uint32_t eax_in;
> > +    uint32_t ecx_in;
> > +    uint64_t xcr0_in;
> > +    uint64_t xss_in;
> > +    uint32_t eax;
> > +    uint32_t ebx;
> > +    uint32_t ecx;
> > +    uint32_t edx;
> > +    uint64_t reserved;
> > +} __attribute__((packed)) SnpCpuidFunc;
> > +
> > +typedef struct {
> > +    uint32_t count;
> > +    uint32_t reserved1;
> > +    uint64_t reserved2;
> > +    SnpCpuidFunc entries[SNP_CPUID_FUNCTION_MAXCOUNT];
> > +} __attribute__((packed)) SnpCpuidInfo;
> > +
> >  static int
> >  sev_ioctl(int fd, int cmd, void *data, int *error)
> >  {
> > @@ -1141,6 +1171,117 @@ detect_first_overlap(uint64_t start, uint64_t end, Range *range_list,
> >      return overlap;
> >  }
> >  
> > +static int
> > +sev_snp_cpuid_info_fill(SnpCpuidInfo *snp_cpuid_info,
> > +                        const KvmCpuidInfo *kvm_cpuid_info)
> > +{
> > +    size_t i;
> > +
> > +    memset(snp_cpuid_info, 0, sizeof(*snp_cpuid_info));
> > +
> > +    for (i = 0; kvm_cpuid_info->entries[i].function != 0xFFFFFFFF; i++) {
> 
> Maybe iterate only while i < kvm_cpuid_info.cpuid.nent ?

Unfortunately kvm_vcpu_ioctl_get_cpuid2() in kernel only checks
kvm_cpuid_info.cpuid.nent as an input to verify there's enough room in
in kvm_cpuid_info.cpuid.entries array to copy the values over. It
doesn't update kvm_cpuid_info.cpuid.nent to indicate how many entries
are actually present, so I've been relying on the 0xFFFFFFFF marker
stuff.

An alternative approach is to keep incrementing cpuid.nent until the KVM
ioctl stops reporting E2BIG, I think the KVM selftests take this
approach as well so that's probably the way to go.

> 
> > +        const struct kvm_cpuid_entry2 *kvm_cpuid_entry;
> > +        SnpCpuidFunc *snp_cpuid_entry;
> > +
> > +        kvm_cpuid_entry = &kvm_cpuid_info->entries[i];
> > +        snp_cpuid_entry = &snp_cpuid_info->entries[i];
> 
> There's no explicit check that i < KVM_MAX_CPUID_ENTRIES and i <
> SNP_CPUID_FUNCTION_MAXCOUNT.  The !=0xFFFFFFFF condition might protect
> against this but this is not really clear (the memset to 0xFF is done in
> another function).
> 
> Since KVM_MAX_CPUID_ENTRIES is 100 and SNP_CPUID_FUNCTION_MAXCOUNT is
> 64, it seems possible that i will be 65 for example and then
> snp_cpuid_info->entries[i] is an out-of-bounds read access.

Indeed, and I don't think this is guarded against currently. I'll make sure
to add a check for this.

> 
> 
> 
> 
> > +
> > +        snp_cpuid_entry->eax_in = kvm_cpuid_entry->function;
> > +        if (kvm_cpuid_entry->flags == KVM_CPUID_FLAG_SIGNIFCANT_INDEX) {
> > +            snp_cpuid_entry->ecx_in = kvm_cpuid_entry->index;
> > +        }
> > +        snp_cpuid_entry->eax = kvm_cpuid_entry->eax;
> > +        snp_cpuid_entry->ebx = kvm_cpuid_entry->ebx;
> > +        snp_cpuid_entry->ecx = kvm_cpuid_entry->ecx;
> > +        snp_cpuid_entry->edx = kvm_cpuid_entry->edx;
> > +
> > +        if (snp_cpuid_entry->eax_in == 0xD &&
> > +            (snp_cpuid_entry->ecx_in == 0x0 || snp_cpuid_entry->ecx_in == 0x1)) {
> > +            snp_cpuid_entry->ebx = 0x240;
> > +        }
> 
> Can you please add a comment explaining this special case?

Will do, meant to add one previously.

> 
> 
> 
> 
> > +    }
> > +
> > +    if (i > SNP_CPUID_FUNCTION_MAXCOUNT) {
> 
> This can be checked at the top (before the for loop): compare
> kvm_cpuid_info.cpuid.nent with SNP_CPUID_FUNCTION_MAXCOUNT.

Was possible previously because cpuid.nent doesn't reflect the actual
entry count, but with the proposed change above I think I should be able
to handle this as suggested.

> 
> > +        error_report("SEV-SNP: CPUID count '%lu' exceeds max '%u'",
> > +                     i, SNP_CPUID_FUNCTION_MAXCOUNT);
> > +        return -1;
> > +    }
> > +
> > +    snp_cpuid_info->count = i;
> > +
> > +    return 0;
> > +}
> > +
> > +static void
> > +sev_snp_cpuid_report_mismatches(SnpCpuidInfo *old,
> > +                                SnpCpuidInfo *new)
> > +{
> > +    size_t i;
> > +
> 
> Add check that new->count == old->count.

Ah, of course.

> 
> 
> > +    for (i = 0; i < old->count; i++) {
> > +        SnpCpuidFunc *old_func, *new_func;
> > +
> > +        old_func = &old->entries[i];
> > +        new_func = &new->entries[i];
> > +
> > +        if (memcmp(old_func, new_func, sizeof(SnpCpuidFunc))) {
> 
> Maybe clearer:
> 
>     if (*old_func != *new_func) ...

Not 2 structs can be compared this way, maybe I'll just compare the
individual members.

> 
> 
> > +            error_report("SEV-SNP: CPUID validation failed for function %x, index: %x.\n"
> 
> Add "0x" prefixes before printing hex values (%x), otherwise we might
> have confusing outputs such as "failed for function 13, index: 25" which
> is unclear whether it's decimal or hex.

Of course, will fix.

> 
> 
> > +                         "provided: eax:0x%08x, ebx: 0x%08x, ecx: 0x%08x, edx: 0x%08x\n"
> > +                         "expected: eax:0x%08x, ebx: 0x%08x, ecx: 0x%08x, edx: 0x%08x",
> > +                         old_func->eax_in, old_func->ecx_in,
> > +                         old_func->eax, old_func->ebx, old_func->ecx, old_func->edx,
> > +                         new_func->eax, new_func->ebx, new_func->ecx, new_func->edx);
> > +        }
> > +    }
> > +}
> > +
> > +static int
> > +sev_snp_launch_update_cpuid(uint32_t cpuid_addr, uint32_t cpuid_len)
> > +{
> > +    KvmCpuidInfo kvm_cpuid_info;
> > +    SnpCpuidInfo snp_cpuid_info;
> > +    CPUState *cs = first_cpu;
> > +    MemoryRegion *mr = NULL;
> > +    void *snp_cpuid_hva;
> > +    int ret;
> > +
> > +    snp_cpuid_hva = gpa2hva(&mr, cpuid_addr, cpuid_len, NULL);
> > +    if (!snp_cpuid_hva) {
> > +        error_report("SEV-SNP: unable to access CPUID memory range at GPA %d",
> > +                     cpuid_addr);
> > +        return 1;
> > +    }
> 
> I think that moving this section just before the memcpy(snp_cpuid_hva,
> ...) below would make the flow of this function clearer to the reader
> (no functional difference, I believe).

I think I put this here to avoid the extra KVM ioctls if this case is
hit, but it shouldn't hurt to move it.

> 
> 
> > +
> > +    /* get the cpuid list from KVM */
> > +    memset(&kvm_cpuid_info.entries, 0xFF,
> > +           KVM_MAX_CPUID_ENTRIES * sizeof(struct kvm_cpuid_entry2));
> 
> The third argument can be:  sizeof(kvm_cpuid_info.entries)

Much nicer.

> 
> 
> > +    kvm_cpuid_info.cpuid.nent = KVM_MAX_CPUID_ENTRIES;
> > +
> > +    ret = kvm_vcpu_ioctl(cs, KVM_GET_CPUID2, &kvm_cpuid_info);
> > +    if (ret) {
> > +        error_report("SEV-SNP: unable to query CPUID values for CPU: '%s'",
> > +                     strerror(-ret));
> 
> Missing return 1 or exit(1) here?

Yes indeed, will get this fixed up.

> 
> 
> -Dov
> 
> > +    }
> > +
> > +    ret = sev_snp_cpuid_info_fill(&snp_cpuid_info, &kvm_cpuid_info);
> > +    if (ret) {
> > +        error_report("SEV-SNP: failed to generate CPUID table information");
> > +        exit(1);
> > +    }
> > +
> > +    memcpy(snp_cpuid_hva, &snp_cpuid_info, sizeof(snp_cpuid_info));
> 
> Before memcpy, maybe add sanity test (assert?) that
> sizeof(snp_cpuid_info) <= cpuid_len .

Makes sense.

Thanks!
