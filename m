Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27A1402D16
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 18:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344982AbhIGQsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 12:48:38 -0400
Received: from mail-bn1nam07on2073.outbound.protection.outlook.com ([40.107.212.73]:6511
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344752AbhIGQsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 12:48:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JjsC/nmRzBLTak2+3ULGrGTwRXxkWiThnYTOyltnReM60uEomrylZ3ZD4Ajxw4Sv4NeD6m28+5LOSpKAlZ8mcWeheaZsNIFdSDekGtwklfbNrp66dgtbtv3KwsqVsWUF7LaQlh12M59xn1QGs/THCa/mwzQsBPTX10L7yuG3i7RD1OmOsGMt86n6xk+JMaJIJaimBlbUh2DaEXf4IQjRnG9RCkh0K7MSN2hcS9ApovwQWk5XkmggNOQrC1aN2/3SR0y+rd3QvYf8iFYX4WvUHhu2MhP8g0+UJIYNv4rpykymfi4PHZaJQ8MTKLGdds3VpVV4GwFYyYhQeNP38oxL4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5X6SPtmbx6JB4E86sX6U6fEhm916EbRgdq9u5gpat8k=;
 b=CXI5Td78MNxjc6Lq2ZVt/E5Qr5/6WtmLrNvPm3H7+ZLazd1/RKoN2Dg6SwWW6JaD627w0G2X8uuwAyXsR7au6qR5+HfdFqw+V9XfZVLsc1hPsYuIwbudPI+zZvsObVt83dxHHNyyMpBtzmwFN6eyiwuaMW1tX69Gw2luzmXowqWgndxSAYPTGjQ1sXJ+CB1LlVhshm2dXhbGRDqYqrokfKzrdoFMNyNBErA99FNF4Y56rya+lDKbsFND8t4p7oFuu3ZJtVlZbDtJT95Ed9akBha1St1iC8J0pnfrVCeIhsbvl3DWE6JxHdAymStycU8k+PP90zKgNhejaVDoMP2hfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5X6SPtmbx6JB4E86sX6U6fEhm916EbRgdq9u5gpat8k=;
 b=t0HnWNGOG28kvZWEn8T15e0dv6zFJjit2cdO/fCzh1vnE3sJ7Ynjzeak/V8qJIy04DsBilHUsfcMXJPASgrGT9nU5W3HljOSh+6SascqSVMw6rbAyAvoRzXsNir7rrVXg8srA86RljkOJ0BJWECwh9C9NYIXv0p3fFPNgImM9SY=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3704.namprd12.prod.outlook.com (2603:10b6:610:21::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Tue, 7 Sep
 2021 16:47:28 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::f5af:373a:5a75:c353%6]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 16:47:27 +0000
Date:   Tue, 7 Sep 2021 11:18:59 -0500
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
Subject: Re: [RFC PATCH v2 07/12] i386/sev: populate secrets and cpuid page
 and finalize the SNP launch
Message-ID: <20210907161859.yszmnymqlwcfprvq@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
 <20210826222627.3556-8-michael.roth@amd.com>
 <815caff2-6cf5-fef9-1493-c626d29d8cd2@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <815caff2-6cf5-fef9-1493-c626d29d8cd2@linux.ibm.com>
X-ClientProxiedBy: SN2PR01CA0065.prod.exchangelabs.com (2603:10b6:800::33) To
 CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
MIME-Version: 1.0
Received: from localhost (76.251.165.188) by SN2PR01CA0065.prod.exchangelabs.com (2603:10b6:800::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 7 Sep 2021 16:47:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6c4da86-9a08-46be-a4da-08d9721f2ce8
X-MS-TrafficTypeDiagnostic: CH2PR12MB3704:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB3704F263A4D45AEFEDE4102595D39@CH2PR12MB3704.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JAkNbt97Arbn16mx+2/OqwKku4o/sfc9loEq8YSobRiftaz7ne7srwPqiM+hN0/Xd+AkmtyNXIe/iXgyG6VeqjnQq19Gvy7H5NkvLqsaUhgai+11MzFTu2W1WUZKrAa+W60xHXKogHan95FKmzPYM6Lge6beqJMpkdUsdI5DNSYqPQH5aWDrzbmQYAG9m7UEP/z2vvbqNVNlVzROvoWDZf/U8w4xcOp0Qg98fysIFvlLg8TkyRHU/J3sE9OLXS/VPEPqPmTepbgu3qCumxbTZtEjXZINhmfB5fzbquMQkaUIZELrefsxJ8ZZJPt3kuXZ1t2efCWrUW0FZ5+8iVCVa+mGJqfcRfAkaXwZYp+8vYUvwPGRcFjYWcBB+Djy5YNilKkdzlb69wSEX6F3ug7b+4+4x0Pa2fzgHw7DgsxNA4sEUg7crID+4j96033BPs+vrtxQNcNuuIwutJgSJJA4tQDQPBRhJRFjBzXdf4uokY6vBJpVzB42R/EAta7r3oNQd1eS61r3F4FHyoTwbMpwFGoMRHddEy5WYjVqPd4H1PaZcx5keO2oWS/wDLguQLCBP2szSE8Bfp7zraIs6lmFS8Deixj/Y0eGfa2oU/CpD7epBWAfsuVumBXauInr8QVhJ/0sm9guPu36lJcIPWJrxfs6qP+AOQ1+0iJ2TZEBTgiUKbgUSVv4qdbbw7FCCeXq+IbOhOqt5G1hgQReH8+ER3fTvEr89cVqkqIUjkdVXQ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(7416002)(508600001)(86362001)(186003)(44832011)(3716004)(6496006)(956004)(26005)(5660300002)(83380400001)(66556008)(36756003)(2616005)(6486002)(53546011)(6916009)(38100700002)(38350700002)(8676002)(66946007)(54906003)(30864003)(66476007)(2906002)(316002)(52116002)(1076003)(4326008)(8936002)(343044003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lIqedjnCd0b8CKZhHaXVqq4Eo5N9U8V3nfl59XNTkQIWFxsz4DUPNdt+1RCG?=
 =?us-ascii?Q?7O41PBsOLCVDSyHOD0KzJVkdjLNcld2cKyFH8f9DSoRTgXUcinf7b+Jva96D?=
 =?us-ascii?Q?EJT8ZqthJ+uzxb3Q+1eReO0IQB5OoqZyF2N9jYgexaHn8fXF8rqTYF1WnfyO?=
 =?us-ascii?Q?f2yQbPCgSfm70QQkdTucrXhT2xf2smxeP6QMo7JexkTidU4beQIEcsjeA+dg?=
 =?us-ascii?Q?YeRaJwq8dMCWY5dfrCi7b2U+7vErbw2rfwUcj69wXnATRVrwR0Osed9FPdKs?=
 =?us-ascii?Q?UZ3apEnF10d+K6vomeg19tdEd4Ata4ai0ggF0MZ7qY0vnH4IEMyOI146a4xc?=
 =?us-ascii?Q?6eVgiP94109HPny9CEalVK6OWRAbgWYqet4bkqFotCInfTe3grMQBG83gkKn?=
 =?us-ascii?Q?U8KW9+PpOiVvgOJFPrd9TD8NgCOjtRUbXlPPRnUIu2fFMTML4aAkYfnT44Wy?=
 =?us-ascii?Q?Yun7N0Am34ZEXhAWKliQilo/ipHxyJ/kycucz9GZ1gOMgRNrivAt/P0SmmhJ?=
 =?us-ascii?Q?J+b9qGaLn7tTTxXn9Z5sfF1BFIlyi0lfccBn7+/92VKVO7F7aPhNjH2a/JYB?=
 =?us-ascii?Q?7MoNyaDLQbKPqvptce7BKryf7fJ3sDbhxvuJhPqhSk9lDl/27u55ME9ShSnN?=
 =?us-ascii?Q?bwshJxEcG4ICIl27ceFt1QmXblyt2M9nGQ7nLUFaiyMOLJcKYiKPTOXJKJDi?=
 =?us-ascii?Q?JcBFLmRuIu8rLmyA5EGMmZgNoOG1+gBZcxGMXxvKsxwvyGeQHtGMGro+At4O?=
 =?us-ascii?Q?3F3I3mrfqWBylenyc4mJ2bJy53rnC+iUuZR4o+UORmfyaG7tAhiAZ7XuZCku?=
 =?us-ascii?Q?qB5BomW9ssNAPs69Q240kcESnVGrjXSoOhZYk75Iq7lybazuTpVJF6VnPPXz?=
 =?us-ascii?Q?Olg6HKtiykBQNf9MYzA1e4AvOW0rcC2YQmfU9VixPJff83GscWIwO/OLtqf1?=
 =?us-ascii?Q?136g/3P22bQido64N+v+xcHNQfL1kW3FOqBzv2RiHYnlpcoNeL37D/clqEFm?=
 =?us-ascii?Q?04KxON4ul5dTDTlcEWJo50r0PPCtzEFNMgAAZQEG+Cb7iRd9SXUkt/k6M/BP?=
 =?us-ascii?Q?Vb8bMPiPiCMQ5+guEzXSSwW0L690Qc44N2XxLZWHARa7D9fkQ5iBwWdTiBGW?=
 =?us-ascii?Q?BW3bVFUaJOKxHFXHcvoGfbvgV+AF6d3pMbBAqHeUftDiEAYxpAmBDUm2hZ2N?=
 =?us-ascii?Q?1WEuue3QCakzZStf7ZIhX070VMSu+kwFy/Rkb2bkSvpjY4ibGOZsk0aqH+Za?=
 =?us-ascii?Q?mn+jN9HD7BaVGO9vbawPhVQBPqIBOb3Gvw5O4bW8T/OSFFo8qmjtXc9oGu4T?=
 =?us-ascii?Q?WNzsII/qNonbRP2p+cMmY8/d?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6c4da86-9a08-46be-a4da-08d9721f2ce8
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 16:47:27.5081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yk9POJnqau6L262+gHTxQeTbP+V00hlaYWGbcK5sFyoWr/AD9Ufj0HXDzaIgUJXU/ja6AeUF17L/47URnHntZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3704
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 11:24:20PM +0300, Dov Murik wrote:
> Hi Michael,

Hi Dov,

Thanks for reviewing!

> 
> On 27/08/2021 1:26, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > During the SNP guest launch sequence, a special secrets and cpuid page
> > needs to be populated by the SEV-SNP firmware. 
> 
> Just to be clear: these are two distinct pages.  I suggest rephrasing to
> "... a special secrets page and a special cpuid page need to be
> populated ..." (or something along these lines).

Will do.

> 
> > The secrets page contains
> > the VM Platform Communication Key (VMPCKs) used by the guest to send and
> > receive secure messages to the PSP. And CPUID page will contain the CPUID
> > value filtered through the PSP.
> > 
> > The guest BIOS (OVMF) reserves these pages in MEMFD and location of it
> > is available through the SNP boot block GUID. While finalizing the guest
> > boot flow, lookup for the boot block and call the SNP_LAUNCH_UPDATE
> > command to populate secrets and cpuid pages.
> > 
> > In order to support early boot code, the OVMF may ask hypervisor to
> > request the pre-validation of certain memory range. If such range is
> > present the call SNP_LAUNCH_UPDATE command to validate those address
> > range without affecting the measurement. See the SEV-SNP specification
> > for further details.
> > 
> > Finally, call the SNP_LAUNCH_FINISH to finalize the guest boot.
> > 
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  target/i386/sev.c        | 189 ++++++++++++++++++++++++++++++++++++++-
> >  target/i386/trace-events |   2 +
> >  2 files changed, 189 insertions(+), 2 deletions(-)
> > 
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index 867c0cb457..0009c93d28 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -33,6 +33,7 @@
> >  #include "monitor/monitor.h"
> >  #include "exec/confidential-guest-support.h"
> >  #include "hw/i386/pc.h"
> > +#include "qemu/range.h"
> >  
> >  #define TYPE_SEV_COMMON "sev-common"
> >  OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
> > @@ -107,6 +108,19 @@ typedef struct __attribute__((__packed__)) SevInfoBlock {
> >      uint32_t reset_addr;
> >  } SevInfoBlock;
> >  
> > +#define SEV_SNP_BOOT_BLOCK_GUID "bd39c0c2-2f8e-4243-83e8-1b74cebcb7d9"
> > +typedef struct __attribute__((__packed__)) SevSnpBootInfoBlock {
> > +    /* Prevalidate range address */
> > +    uint32_t pre_validated_start;
> > +    uint32_t pre_validated_end;
> > +    /* Secrets page address */
> > +    uint32_t secrets_addr;
> > +    uint32_t secrets_len;
> 
> Just curious: isn't secrets_len always 4096? (same for cpuid_len)
> Though it might be a good future proofing to have a length field.

I believe you can specify a contiguous range of pages for cpuid_len (in
which case you'll get multiple self-contained CPUID tables), but I'm not
sure about the secrets page. I've tried to avoid the need for multiple
CPUID tables/pages in the initial implementation by allowing 0 entries
to be left out, like how KVM_SET_CPUID2 does it; guest kernels will then
check the CPUID ranges to determine if a 0 entry is a valid all-0 entry
vs. an invalid one.

> 
> 
> > +    /* CPUID page address */
> > +    uint32_t cpuid_addr;
> > +    uint32_t cpuid_len;
> > +} SevSnpBootInfoBlock;
> > +
> >  static Error *sev_mig_blocker;
> >  
> >  static const char *const sev_fw_errlist[] = {
> > @@ -1086,6 +1100,162 @@ static Notifier sev_machine_done_notify = {
> >      .notify = sev_launch_get_measure,
> >  };
> >  
> > +static int
> > +sev_snp_launch_update_gpa(uint32_t hwaddr, uint32_t size, uint8_t type)
> > +{
> > +    void *hva;
> > +    MemoryRegion *mr = NULL;
> > +    SevSnpGuestState *sev_snp_guest =
> > +        SEV_SNP_GUEST(MACHINE(qdev_get_machine())->cgs);
> > +
> > +    hva = gpa2hva(&mr, hwaddr, size, NULL);
> > +    if (!hva) {
> > +        error_report("SEV-SNP failed to get HVA for GPA 0x%x", hwaddr);
> > +        return 1;
> > +    }
> > +
> > +    return sev_snp_launch_update(sev_snp_guest, hwaddr, hva, size, type);
> > +}
> > +
> > +static bool
> > +detect_first_overlap(uint64_t start, uint64_t end, Range *range_list,
> > +                     size_t range_count, Range *overlap_range)
> > +{
> > +    int i;
> > +    bool overlap = false;
> > +    Range new;
> > +
> > +    assert(overlap_range);
> 
> Also:
> assert(end >= start)
> assert(range_count == 0 || range_list)
> 
> > +    range_make_empty(overlap_range);
> > +    range_init_nofail(&new, start, end - start + 1);
> > +
> > +    for (i = 0; i < range_count; i++) {
> > +        if (range_overlaps_range(&new, &range_list[i]) &&
> > +            (range_is_empty(overlap_range) ||
> > +             range_lob(&range_list[i]) < range_lob(overlap_range))) {
> > +            *overlap_range = range_list[i];
> > +            overlap = true;
> > +        }
> > +    }
> > +
> > +    return overlap;
> > +}
> > +
> > +static void snp_ovmf_boot_block_setup(void)
> > +{
> > +    SevSnpBootInfoBlock *info;
> > +    uint32_t start, end, sz;
> > +    int ret;
> > +    Range validated_ranges[2];
> > +
> > +    /*
> > +     * Extract the SNP boot block for the SEV-SNP guests by locating the
> > +     * SNP_BOOT GUID. The boot block contains the information such as location
> > +     * of secrets and CPUID page, additionaly it may contain the range of
> > +     * memory that need to be pre-validated for the boot.
> > +     */
> > +    if (!pc_system_ovmf_table_find(SEV_SNP_BOOT_BLOCK_GUID,
> > +        (uint8_t **)&info, NULL)) {
> 
> Fix indent of arguments.
> 
> 
> > +        error_report("SEV-SNP: failed to find the SNP boot block");
> > +        exit(1);
> > +    }
> > +
> > +    trace_kvm_sev_snp_ovmf_boot_block_info(info->secrets_addr,
> > +                                           info->secrets_len, info->cpuid_addr,
> > +                                           info->cpuid_len,
> > +                                           info->pre_validated_start,
> > +                                           info->pre_validated_end);
> > +
> > +    /* Populate the secrets page */
> > +    ret = sev_snp_launch_update_gpa(info->secrets_addr, info->secrets_len,
> > +                                    KVM_SEV_SNP_PAGE_TYPE_SECRETS);
> > +    if (ret) {
> > +        error_report("SEV-SNP: failed to insert secret page GPA 0x%x",
> > +                     info->secrets_addr);
> > +        exit(1);
> > +    }
> > +
> > +    /* Populate the cpuid page */
> > +    ret = sev_snp_launch_update_gpa(info->cpuid_addr, info->cpuid_len,
> > +                                    KVM_SEV_SNP_PAGE_TYPE_CPUID);
> > +    if (ret) {
> > +        error_report("SEV-SNP: failed to insert cpuid page GPA 0x%x",
> > +                     info->cpuid_addr);
> > +        exit(1);
> > +    }
> > +
> > +    /*
> > +     * Pre-validate the range using the LAUNCH_UPDATE_DATA, if the
> > +     * pre-validation range contains the CPUID and Secret page GPA then skip
> > +     * it. This is because SEV-SNP firmware pre-validates those pages as part
> > +     * of adding secrets and cpuid LAUNCH_UPDATE type.
> > +     */
> > +    range_init_nofail(&validated_ranges[0], info->secrets_addr, info->secrets_len);
> > +    range_init_nofail(&validated_ranges[1], info->cpuid_addr, info->cpuid_len);
> > +    start = info->pre_validated_start;
> > +    end = info->pre_validated_end;
> > +
> > +    while (start < end) {
> > +        Range overlap_range;
> > +
> > +        /* Check if the requested range overlaps with Secrets and CPUID page */
> > +        if (detect_first_overlap(start, end, validated_ranges, 2,
> 
> Replace the literal 2 with ARRAY_SIZE(validated_ranges).

Will do. I was a little concerned with the case where validated_ranges
might have variable number of entries in future (say a new optional page
was added/scanned for via ovmf so extra space was allocated for it). I
think some comments should be enough to avoid any issues should that
change be made in the future though.

> 
> 
> > +                                 &overlap_range)) {
> > +            if (start < range_lob(&overlap_range)) {
> > +                sz = range_lob(&overlap_range) - start;
> > +                if (sev_snp_launch_update_gpa(start, sz,
> > +                    KVM_SEV_SNP_PAGE_TYPE_UNMEASURED)) {
> 
> Fix indent of arguments (if possible).

Not sure it is :( Not without changing the loop logic anyway, I'll see if
that can be reworked a bit.

> 
> > +                    error_report("SEV-SNP: failed to validate gpa 0x%x sz %d",
> > +                                 start, sz);
> > +                    exit(1);
> > +                }
> > +            }
> > +
> > +            start = range_upb(&overlap_range) + 1;
> > +            continue;
> > +        }
> > +
> > +        /* Validate the remaining range */
> > +        if (sev_snp_launch_update_gpa(start, end - start,
> 
> I think the second argument should be:    end - start + 1 .
> 
> Consider start=0x8000 end=0x8fff (inclusive). In this case you want to
> validate exactly 0x1000 bytes starting at 0x8000.  So the size should be
> 0x8fff - 0x8000 + 1.

Good catch, I'll get this fixed up.

> 
> I assume all this doesn't matter for the underlying calls which operate
> at whole pages anyway (are there proper asserts in sev_snp_launch_update
> (or in KVM) that verify that start and sz are page-size-aligned?)

That's correct, snp_launch_update() mostly operates on the underlying
pages, so the actual size doesn't matter much. I'm not sure if that
granularity is meant to be transparent to userspace or explicitly enforced
though, I'll need to check with Brijesh on that.

> 
> 
> 
> > +            KVM_SEV_SNP_PAGE_TYPE_UNMEASURED)) {
> 
> Fix indent of arguments.
> 
> 
> > +            error_report("SEV-SNP: failed to validate gpa 0x%x sz %d",
> > +                         start, end - start);
> > +            exit(1);
> > +        }
> > +
> > +        start = end;
> > +    }
> > +}
> > +
> > +static void
> > +sev_snp_launch_finish(SevSnpGuestState *sev_snp)
> > +{
> > +    int ret, error;
> > +    Error *local_err = NULL;
> > +    struct kvm_sev_snp_launch_finish *finish = &sev_snp->kvm_finish_conf;
> > +
> > +    trace_kvm_sev_snp_launch_finish();
> > +    ret = sev_ioctl(SEV_COMMON(sev_snp)->sev_fd, KVM_SEV_SNP_LAUNCH_FINISH, finish, &error);
> > +    if (ret) {
> > +        error_report("%s: SNP_LAUNCH_FINISH ret=%d fw_error=%d '%s'",
> > +                     __func__, ret, error, fw_error_to_str(error));
> > +        exit(1);
> > +    }
> > +
> > +    sev_set_guest_state(SEV_COMMON(sev_snp), SEV_STATE_RUNNING);
> > +
> > +    /* add migration blocker */
> > +    error_setg(&sev_mig_blocker,
> > +               "SEV: Migration is not implemented");
> > +    ret = migrate_add_blocker(sev_mig_blocker, &local_err);
> > +    if (local_err) {
> > +        error_report_err(local_err);
> > +        error_free(sev_mig_blocker);
> > +        exit(1);
> > +    }
> > +}
> > +
> > +
> >  static void
> >  sev_launch_finish(SevGuestState *sev_guest)
> >  {
> > @@ -1121,7 +1291,12 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
> >  
> >      if (running) {
> >          if (!sev_check_state(sev_common, SEV_STATE_RUNNING)) {
> > -            sev_launch_finish(SEV_GUEST(sev_common));
> > +            if (sev_snp_enabled()) {
> > +                snp_ovmf_boot_block_setup();
> > +                sev_snp_launch_finish(SEV_SNP_GUEST(sev_common));
> > +            } else {
> > +                sev_launch_finish(SEV_GUEST(sev_common));
> > +            }
> >          }
> >      }
> >  }
> > @@ -1236,7 +1411,17 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
> >      }
> >  
> >      ram_block_notifier_add(&sev_ram_notifier);
> > -    qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
> > +
> > +    /*
> > +     * The machine done notify event is used by the SEV guest to get the
> > +     * measurement of the encrypted images. When SEV-SNP is enabled then
> > +     * measurement is part of the attestation report and the measurement
> > +     * command does not exist. So skip registering the notifier.
> > +     */
> > +    if (!sev_snp_enabled()) {
> > +        qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
> > +    }
> > +
> >      qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
> >  
> >      cgs->ready = true;
> > diff --git a/target/i386/trace-events b/target/i386/trace-events
> > index 0c2d250206..db91287439 100644
> > --- a/target/i386/trace-events
> > +++ b/target/i386/trace-events
> > @@ -13,3 +13,5 @@ kvm_sev_launch_secret(uint64_t hpa, uint64_t hva, uint64_t secret, int len) "hpa
> >  kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data %s"
> >  kvm_sev_snp_launch_start(uint64_t policy) "policy 0x%" PRIx64
> >  kvm_sev_snp_launch_update(void *addr, uint64_t len, int type) "addr %p len 0x%" PRIx64 " type %d"
> > +kvm_sev_snp_launch_finish(void) ""
> > +kvm_sev_snp_ovmf_boot_block_info(uint32_t secrets_gpa, uint32_t slen, uint32_t cpuid_gpa, uint32_t clen, uint32_t s, uint32_t e) "secrets 0x%x+0x%x cpuid 0x%x+0x%x pre-validate 0x%x+0x%x"
> 
> In this trace format string you use the notation A+B to indicate addr=A
>  len=B.  But for the pre-validated range the arguments are 'start' and
> 'end' (and not 'addr' and 'len'), so I suggest choosing a different
> notation to log that range.

Indeed, will get that fixed up.

> 
> -Dov
