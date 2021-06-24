Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5A43B255E
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 05:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhFXDVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 23:21:48 -0400
Received: from mail-co1nam11on2056.outbound.protection.outlook.com ([40.107.220.56]:63936
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229774AbhFXDVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Jun 2021 23:21:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8CJBmNJ+9zabBEWfUK/stLQ+UEDs3LJIDlLERlFftAF/j482UAREtGoNIh2oOZTNobPnkj/VwRC4AyK0e6fW+vWLwiiJUi9HQkCjdr5wO62gBLKrIJ8AWp5O2fUzX3JqWEb3yziQUCuT0Yz2NjYLPIxsSlahiR162EeFR8wOwNQF3FrOFJwy1z2UikwuMmMNkydRtRZA5iiJSalp5PDAqtQXuHMWH1ktwSBjb/yXgUdXffJ0yIWP8ImNdee2vicJa7qO4zbLe07BOWsWD8swJFmAKKFZ0s85eJKDHqgy/v6OCDthY3TASX5sRg7e/WjSW4u0Pd3exnSEObZaUcI/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIl5/pZFU58Lz2g9ooE4GvlHx4JadRnfQtgZo+RAgHo=;
 b=F48kzzZuXofirzBx447FuelGLX+JliwBhLpUzr3ao7dh7MT8+soN9fJLolrMN6gbIdlGL4NYjbYJbpQHd7Uqmp9C9S/MLG+EqkJ52dcVsJ02zrIqzcj1Y1ITar13lx6Rmvnby4aPnbLb7g/eotN8XNmdUQutPUJxq6/yx/rCtT+fkjLpukdKk150+lNfgFxwnkABXdbfj6RbQWz9sgeIwxmhagWn4MmzkknodlXAQ7nHcSEG71dewFH0GUXWkW+a7sLx8QzWTTnLsAizv7/nMk8bK/Tt5SiJetwz3YAWv/YVM16Sv7v3Wb7La9v8BilSdV4eZcHP0SYmNkIs4FuQ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIl5/pZFU58Lz2g9ooE4GvlHx4JadRnfQtgZo+RAgHo=;
 b=O+BV1EbrXwIUq0+MbvPVkErrMrjW2lIGDVA2+3vvJQQF1GUAzkBNkL7Ms3bHluDspD7KvxALp4UlvcyOmykvnPQPzKS4bPPMEdW1Llnk3NDPsBHv44JAJHtNXbkE0NBudpn2NBW/NMif1LJFW7Xxh+69rX+kVxvXcCBK0jMiqGk=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4837.namprd12.prod.outlook.com (2603:10b6:610:f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Thu, 24 Jun
 2021 03:19:22 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::181:e51d:a4f7:af62]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::181:e51d:a4f7:af62%5]) with mapi id 15.20.4264.020; Thu, 24 Jun 2021
 03:19:22 +0000
Date:   Wed, 23 Jun 2021 22:19:11 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     "Kuppuswamy, Sathyanarayanan" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com
Subject: Re: [PATCH Part1 RFC v3 20/22] x86/boot: Add Confidential Computing
 address to setup_header
Message-ID: <20210624031911.eznpkbgjt4e445xj@amd.com>
References: <20210602140416.23573-1-brijesh.singh@amd.com>
 <20210602140416.23573-21-brijesh.singh@amd.com>
 <YMw4UZn6AujpPSZO@zn.tnic>
 <15568c80-c9a9-5602-d940-264af87bed98@amd.com>
 <YMy2OGwsRzrR5bwD@zn.tnic>
 <162442264313.98837.16983159316116149849@amd.com>
 <YNMLX6fbB3PQwSpv@zn.tnic>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNMLX6fbB3PQwSpv@zn.tnic>
X-Originating-IP: [165.204.77.11]
X-ClientProxiedBy: SN4PR0701CA0014.namprd07.prod.outlook.com
 (2603:10b6:803:28::24) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.11) by SN4PR0701CA0014.namprd07.prod.outlook.com (2603:10b6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Thu, 24 Jun 2021 03:19:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e9c59f5-183b-4332-cfb6-08d936bedc6c
X-MS-TrafficTypeDiagnostic: CH2PR12MB4837:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB4837BF4E11CEC772676F36EC95079@CH2PR12MB4837.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BD99qnTEYhXBAAoJ1GoIaaeE0wn7FmRh6n+EXQ3KHC/apem5EE+NSHZ4c4SV5P2OdqRUvqXJA/b9PON0KOEOoJdadabgOKai0h2qQju/NyvzCDwFYZKHtiNl6scEFCc0QBXKfaGr3Ersx4dKBQ8od6vvEK1o/0/X7CimTK5G5Uc1lhb/JzyR6thadonr5b9BM+IRivFzCg+1ievbIHFpMwSa9rSbKVh9P1tF3Rrukv3J5VQgIW1uMM6g2gZde87lTtcm/wGeJuocxto+mr3geTjhI4Z8ruEO7TnNUNeCYkbrcy+c+R/XlVFqKIS0NOf7Kzj1vJmMlzOHlm/iP8SwvgCw99hG4cSUIQj1kB+oBODdFYzZqLcoTI9WemTGKGUHTvXegUnf/SvhUWtXHOgP5krLCXGyI/E/Vv7tiKHjIAmALYwOwzLDeO/WKgrdoC3BhkXBA9WRsQ7/1JtgkUdl96A/BN0ojEsJyoMcBtMJClxB/X57YnCXc0y3+0TJu3UvfS/ZAPDWlxcn0gjYkQ5S5RWRMAG7AeqDgmtL+7wG2wJ69Z10QGDaVy6lXelubNMy7zhTb2d/iMz7P5HWR47ZMLiU/YeGU785bHEc0QEnpCsdHQ6QqD35zvPJhDLLX7wiliqk1EbBaY/czUgSpuuC3N3Y3o9Rk4shDxGCMLgCU9bGKhrpLgRiXdK65ZLe61ij9zwewGWRZnrlVyuRzzU1EP+2SL+bWrPrt06tHBWonAZwI1NfS+6PU9ogqvYKNI1YaV9FLmsjjEU795F9hxDjcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(8676002)(1076003)(52116002)(7416002)(6916009)(16526019)(186003)(966005)(26005)(45080400002)(6666004)(5660300002)(66476007)(66556008)(478600001)(66946007)(6486002)(6496006)(316002)(54906003)(83380400001)(38100700002)(38350700002)(2906002)(36756003)(2616005)(956004)(8936002)(4326008)(86362001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Y9SU1teWqTS5TfL1BpyVwZQBgwU9j4B1KDVoDGpQ1aSg6D9ZDGRYRkgGVhx1?=
 =?us-ascii?Q?JI+mqh48R15ZNkvsIEQ1n4x5jEnRGIMdWO10MFSjUdRKPpShXVE3An/MHZIM?=
 =?us-ascii?Q?HsVl5Dn9qPvnIwAch0wsGdYiYSYAIxTGrnHZ6W9QDxHbSDG3c2pKYSxEnpTS?=
 =?us-ascii?Q?UP1idgH0+eEhvBv710syTYEKW6hTJDAPL5kk8w1PdJMVzOx6hh5GPAVpRJrg?=
 =?us-ascii?Q?+n+29zZFX1WzJR2GsPPzH2rOD8saORgkVPmyLKeeLuz9NKd2ZaySVYVkY7CV?=
 =?us-ascii?Q?4jCV8IKIOFhD1mWo4spSl7WfYTtrzugdoU+Ups7KMdfOYZdIpKcbZ4oud/ue?=
 =?us-ascii?Q?cGTOt2CMzWOyZVBmVL9bESiN92knF4E4wEt6tSTdd1Q5J8y0LgETLK8yXW6M?=
 =?us-ascii?Q?nXpYqB9rsXgYcldzb5lDrJhNKKdtOoW5qaEvQT7tycgATFi5kuY23t1xFlCx?=
 =?us-ascii?Q?pXmx7HO6FsESXGSLoZS6dyvHtarzcdck1OTzh/thMhJO8Q0vq5QG7ukJE4XE?=
 =?us-ascii?Q?VgHUqWj7dMGmt05qQmqB4lzJwDbcGl/pirhEa2L9hYb8vs7WDuhsTm7YMMoV?=
 =?us-ascii?Q?Dfg+t4+hOwi8QbDDm7bAzMSUQRyr6OS7QqlS+qdrncweb8lJzSqyh7aD9CrY?=
 =?us-ascii?Q?O/sp29HtFux6J9xpPL9zY/UArtFbs7kOGdgJlSgnXc3ITvZhYSkVsdLiFKSr?=
 =?us-ascii?Q?1aLHmPR0/640uS6SvyAJBZr2TuU/ED828ZMm5KIkLtQxa9QPOZTVY4t1512q?=
 =?us-ascii?Q?OQSZIJ0h1IAiAl/8wOUzr46oJiujrn6ZaSdPIcnsAqT5FOTB27rJmFYyq4EO?=
 =?us-ascii?Q?0SLtFXHGJH5H+L6xfZKIVJx/uR0bjeutstafOArxtqgAuSBY5XD6ZoSfR1r5?=
 =?us-ascii?Q?srleTTWQjUpvvRlPb4y3G1NSl93fJEXidzAcnKORplZuaQIPvBmWU3O25/Gv?=
 =?us-ascii?Q?houJZlwJqZAEnA3EQOm5W26OVBeL+XHr61B8dfezUnFhi/9KZh5lFuHn6H2I?=
 =?us-ascii?Q?WDG1EGKGmBoqNzU/E8sOZo4YgoxRpIDvJU27nVpXqCFvNiTMAuIBTPkpokWh?=
 =?us-ascii?Q?Z2QyIgHzTvybAJtbr0L5TAVRI0Vz6CPVh8Ez17SO07xEbpcO8FF7nKuXUIP7?=
 =?us-ascii?Q?bFSNHg21MDC87oQii/0XT2n/XkGptjAgmODu8cFRD1uHvjdDYlSPlNC/zZEr?=
 =?us-ascii?Q?JiHK2++QUyZ9uEvLlcLfYMXKC0bWCEjbS/tfQq1h8sVZn4mP/5Cpu7uLjiT6?=
 =?us-ascii?Q?UiaUWhOYJbn7yI+NsVc7TD/yLDvrkBH3n3mVRLK05xWP4IQ4EoXNb1iltcE3?=
 =?us-ascii?Q?wGeto/f6ynIY1hmpXQcTkxA8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e9c59f5-183b-4332-cfb6-08d936bedc6c
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2021 03:19:22.2795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yshIZRuN9Epsj66Jbvu1Am0+z+f8u1QUn+KSCKFyvy60ELW6QjKxytyHauRGGhA8UN6pkJEjqHsUhqb8oDtZWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4837
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 23, 2021 at 12:22:23PM +0200, Borislav Petkov wrote:
> On Tue, Jun 22, 2021 at 11:30:43PM -0500, Michael Roth wrote:
> > Quoting Borislav Petkov (2021-06-18 10:05:28)
> > > On Fri, Jun 18, 2021 at 08:57:12AM -0500, Brijesh Singh wrote:
> > > > Don't have any strong reason to keep it separate, I can define a new
> > > > type and use the setup_data to pass this information.
> > > 
> > > setup_data is exactly for use cases like that - pass a bunch of data
> > > to the kernel. So there's no need for a separate thing. Also see that
> > > kernel_info thing which got added recently for read_only data.
> > 
> > Hi Boris,
> > 
> > There's one side-effect to this change WRT the CPUID page (which I think
> > we're hoping to include in RFC v4).
> > 
> > With CPUID page we need to access it very early in boot, for both
> > boot/compressed kernel, and the uncompressed kernel. At first this was
> > implemented by moving the early EFI table parsing code from
> > arch/x86/kernel/boot/compressed/acpi.c into a little library to handle early
> > EFI table parsing to fetch the Confidential Computing blob to get the CPUID
> > page address.
> > 
> > This was a bit messy since we needed to share that library between
> > boot/compressed and uncompressed, and at that early stage things like
> > fixup_pointer() are needed in some places, else even basic things like
> > accessing EFI64_LOADER_SIGNATURE and various EFI helper functions could crash
> > in uncompressed otherwise, so the library code needed to be fixed up
> > accordingly.
> > 
> > To simplify things we ended up simply keeping the early EFI table parsing in
> > boot/compressed, and then having boot/compressed initialize
> > setup_data.cc_blob_address so that the uncompressed kernel could access it
> > from there (acpi does something similar with rdsp address).
> 
> Yes, except the rsdp address is not vendor-specific but an x86 ACPI
> thing, so pretty much omnipresent.
> 
> Also, acpi_rsdp_addr is part of boot_params and that struct is full
> of padding holes and obsolete members so reusing a u32 there is a lot
> "easier" than changing the setup_header. So can you put that address in
> boot_params instead?

Thanks for the suggestion! I tried something like the below and that seems to
work pretty well. I'm not sure if that's the best spot or not though, it
seems like it might be a good idea to leave some padding after eddbuf in
case it needs to grow in the future. I'll look into that a bit more.

One downside to this is we still need something in the boot protocol,
either via setup_data, or setup_header directly. Having it in
setup_header avoids the need to also have to add a field to boot_params
for the boot/compressed->uncompressed passing, but maybe that's not a good
enough justification. Perhaps if the TDX folks have similar needs though.

diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index 1ac5acca72ce..0824c8646861 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -218,7 +218,8 @@ struct boot_params {
        struct boot_e820_entry e820_table[E820_MAX_ENTRIES_ZEROPAGE]; /* 0x2d0 */
        __u8  _pad8[48];                                /* 0xcd0 */
        struct edd_info eddbuf[EDDMAXNR];               /* 0xd00 */
-       __u8  _pad9[276];                               /* 0xeec */
+       __u32 cc_blob_address;							/* 0xeec */
+       __u8  _pad9[272];                               /* 0xef0 */
 } __attribute__((packed));

diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 981fe923a59f..53e9b0620d96 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -74,6 +74,7 @@ static void sanitize_boot_params(struct boot_params *boot_params)
                        BOOT_PARAM_PRESERVE(hdr),
                        BOOT_PARAM_PRESERVE(e820_table),
                        BOOT_PARAM_PRESERVE(eddbuf),
+                       BOOT_PARAM_PRESERVE(cc_blob_address),
                };

                memset(&scratch, 0, sizeof(scratch));

> 
> > Now that we're moving it to setup_data, this becomes a bit more awkward,
> > since we need to reserve memory in boot/compressed to store the setup_data
> > entry, then add it to the linked list to pass along to uncompressed kernel.
> > In turn that also means we need to add an identity mapping for this in
> > ident_map_64.c, so I'm not sure that's the best approach.
> > 
> > So just trying to pin what the best approach is:
> > 
> > a) move cc_blob to setup_data, and do the above-described to pass
> >    cc_blob_address from boot/compressed to uncompressed to avoid early
> >    EFI parsing in uncompressed
> > b) move cc_blob to setup_data, and do the EFI table parsing in both
> >    boot/compressed. leave setup_data allocation/init for BIOS/bootloader
> > c) keep storing cc_blob_address in setup_header.cc_blob_address
> > d) something else?
> 
> Leaving in the whole text for newly CCed TDX folks in case they're going
> to need something like that.
> 
> And if so, then both vendors should even share the field definition.
> 
> Dave, Sathya, you can find the whole subthread here:
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F20210602140416.23573-21-brijesh.singh%40amd.com&amp;data=04%7C01%7Cmichael.roth%40amd.com%7C3b352c4b944c4d95bbdb08d93630d0eb%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637600405622460196%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=464O7JxibsbjC3bc0LkGcztdb4kCYH7kcQAcqohJhug%3D&amp;reserved=0
> 
> in case you need background info on the topic at hand.
> 
> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpeople.kernel.org%2Ftglx%2Fnotes-about-netiquette&amp;data=04%7C01%7Cmichael.roth%40amd.com%7C3b352c4b944c4d95bbdb08d93630d0eb%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637600405622460196%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=ruCM7CNgPCNPkrOoiNts1ZKi5k7JSUumln7qQMP%2BMi0%3D&amp;reserved=0
