Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB05A740A20
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 09:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbjF1H62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 03:58:28 -0400
Received: from mail-co1nam11on2125.outbound.protection.outlook.com ([40.107.220.125]:49612
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231593AbjF1H4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 03:56:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIHh0fmnkD/kTTs4gFl8CITc7ubsSsJDRbWf39KyAFQgU8wpMrKlTiPruGI2k8J4sv6ble//hhOsZLYKbzhLP1eiqome64LVf3VtCE/gkW7xvRZc+s6yKvOJaT4kZ7wl94qO7xQxQdcUNazvcLa+Uqn1ohDxRjkOmnoR19VWgS/ZbzgQREEXWGYHBrDC/lLUm7egholm2DNuWnLGFL5DrrUW3V1XDuM+OdysmEwDrTCDavUpkO/UVVWV/3sX/BECXyQHcQpQewQZFIerQZi4jW9ESQ+VxqE0iKnuLrZubUAWK+ChP2a9DmNgwPA6fA/u0PbygRu8GOl7HjBaPLe6lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xWORmrHUDzGBSJeACCmrj+uLoiYqlpO7QwVKdhVOV5E=;
 b=SFCFlbIdwPSn6u/1IxVjO3s2ZipUhvcXsSfCWGo6VPVr1AU7K8spFaGrXOOzowpWYLMbT+ZjvGlgJgZeHmH3qD2MigaLrxTS7/Y2Rdsk2MghmzghPkQUrIH0hQuzCheQdmn6Kx82h28YtTUUH05VljKn3w2V9IvmOzkwS6GrxTODCUzyngAr3Jqjk18IcIpVQZ+i55MlnO3MDwJ4VXAVQN0A4PFRl8cHGYuUnqyPwXooa1/0Z+iuD176ROWQmM01N6wfHC32z+iA2MBVDBGhiEKRx3bRYfa3xeYz8NwjgDSMJQ70PkEkHIHZpL3BuSocEYUHN9AoixTPwimBE2wYBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xWORmrHUDzGBSJeACCmrj+uLoiYqlpO7QwVKdhVOV5E=;
 b=vop5gv2qCCP6yyUAfWNoxx9IcdigzWvc0srnFOZHOJj1u1kkTdafBPXLYd6JnI4NWaJDb+XozpVVe1BBYYE+N9dQH1t7xZwFEk7tHtfdmhqkoE+WMir2Wdtw01BR4gIIUvHT+/ychsk9hF1L/CurbdZBn2xZpNJn+49rwu/xgq8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 BY3PR01MB6708.prod.exchangelabs.com (2603:10b6:a03:363::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.26; Wed, 28 Jun 2023 06:46:06 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::88ed:9a2b:46b7:1eb0]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::88ed:9a2b:46b7:1eb0%6]) with mapi id 15.20.6521.023; Wed, 28 Jun 2023
 06:46:06 +0000
Message-ID: <f19bb506-3e21-2bd6-7463-9aea8ab912f5@os.amperecomputing.com>
Date:   Wed, 28 Jun 2023 12:15:55 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eauger@redhat.com>
References: <20230515173103.1017669-1-maz@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0072.namprd05.prod.outlook.com
 (2603:10b6:610:38::49) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|BY3PR01MB6708:EE_
X-MS-Office365-Filtering-Correlation-Id: c0b4b847-83a2-4e0e-6af0-08db77a35841
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EmBUl+1jD8X/31gXYCzjnPGzAepZOmqffouXVSW0NF/mZFskiEDTk27vZwLu/yFR+CP5aBtXdJwsDM76sre0czu/RYhVNZksKCfcOeiJ5eMUeRHjPyh3rfg+vBdxXSxbFPIUfz5gsZefZMpY4fBUnrzmF8Tugvve//AzVZ8VnAm22fghP98ZaQZXhZ+pj2StzmHD/0JTAywY4aPpD7BW2iiv4OptnYpfNljhj1SGcsRiuY5Oxk730P85+QSUDvS3UeIlpJp6jr3pmjm42CZULytRWTFmRpHB0YphAIppCnOCstxJzsCXU6gaVMlRHCTzq+GwPYUja1jfhmMhmfY/1GM1VTPdCBrdq7AV77AU7ou0z3F1LeL2fKrBhVs8+cjROimiGoyVM9CilQ1T5LH/GEbARKSZqoFPGt/blczNsNcQHArV+pODq7Up91vrDSVL8Vyo3YswNA230f3PQ19qFhdUv4CnvR2ggwnOJecxta6dIcvMfb37tTOykTPjGH5vzg5AZLdCMxEmhCg7XqIaYZRVdmgZecz3NaomSD9pGwwX6sqaXPlQVAewzNrQwoNvT6flQmGKucqpFwBKk5QzY6EkfsLKCRXqYqBaobYAhoAI8oMp4omejRYPIfnZy9L9gW35Eu4h6DEpGresXN0H4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(39850400004)(396003)(346002)(136003)(451199021)(31686004)(66899021)(53546011)(7416002)(5660300002)(86362001)(8936002)(8676002)(66556008)(41300700001)(66476007)(38100700002)(316002)(4326008)(31696002)(66946007)(966005)(2906002)(26005)(186003)(478600001)(6506007)(2616005)(6512007)(6486002)(83380400001)(54906003)(6666004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajNJRWVQeWllVFpDM2IxTkUyNWZXTGxFTjNreHNVSkZXdTBCb1d5VkVud2Ja?=
 =?utf-8?B?eXNNaEZJWVFLK3ozSjVUdW5OMmlvTUgzbVlxWjd0Y3lyTnd0bmNyN3hmQlhH?=
 =?utf-8?B?TGRlekM0a20yZDJaYnZSZEZUTThBSjdrbWFHd3hwdVAyK2xnS1lrNGRGVXgy?=
 =?utf-8?B?cWNuZEJZN0luS2Fhb1pmNkVZSG9CYUFCSTd4cVN6TEgwaG9zYzFaWFV3TnQ0?=
 =?utf-8?B?NXNWTGRQY1QvMExvYm9MYld6VFFReW5Ga3RpbUFoVURrMXhJNWZlTmZFUTls?=
 =?utf-8?B?ZVk3b3RwMis2U1VNaHRmSFF1aVprcGNvN2p0M2xYUDdMSFpJemptU3p3MTNp?=
 =?utf-8?B?TUZCNmZFWldzVjB1YUZNY05DdDZLN05JUWs4OFNYV1lvOGwzVnZsQzdEaEIx?=
 =?utf-8?B?ei95Y2phZFRuQkREdWs0NlVpQVg5NG9tMmdpOXNKeW1yYTJtQ1JxSVRCcmJY?=
 =?utf-8?B?R2IxL09sSnhtaXlRVVB5cndwVkhXOTVEK3NWMFl6a3NtZXA3bWdjTHdrTzdF?=
 =?utf-8?B?VWpBSDVPN2MzRUVzN0tLTWNRMXN2dDRwWExaRXhTQTZ4WXZ0OGR5aU53MzdK?=
 =?utf-8?B?cFFoYlp3WFYraEZMSStnYzlyQ0tvdFNWaFVwbVpjMFM3emVGc0cxNS9wZHRJ?=
 =?utf-8?B?MUtBM3pXeDFFQUIxMjhuWm1iTDFOaUVxNVUyUll0dmc0c3RHdTFoUEZKMFdP?=
 =?utf-8?B?TExVMklRdmlYK3QraEVrVllNN0FnOW5TdVdrWjNRMXhYcGhJMGMrUGRHU2ly?=
 =?utf-8?B?SnZrb2FoUmFCQzY5RDNpYVlMWE01aFBoTUVlOHpJUHpIMEdLMjBNSWVvYUM3?=
 =?utf-8?B?Qk8vaEpiUFp6eTVvRHFyM2VaT01TcDV5WkFOU3ErSzE3Mm9ZZndRcHZCLzcy?=
 =?utf-8?B?OUxnU2Y5dDRxcm9XdXdybk1rYytkdmV1V3cwWnA3WE93ZzQ2dXFMRS9NNEpt?=
 =?utf-8?B?RHlsTkIzMWRWWmhlb3lVL1MwdGRNRkx1ZWJkNG0xSlNCelVMbzRjNlRwK21y?=
 =?utf-8?B?ci9FSmZtYjVRWXVabzR0bzljaW5WTE1hZzUzQjhRZEtRNWdDTHdmNnBybit4?=
 =?utf-8?B?U1BFT3ZNZThQRzkzYzY3Z2QyWnZlNGQzYytYWVpoWEtqREV5L0lGM2JKRlhC?=
 =?utf-8?B?a0hSY0ZrT3BVditMZStMcFQwcUZNQjRhbmtUUUhDRENsRXlGUitZT0plYTlL?=
 =?utf-8?B?bDJKSC9oQXZJVlFvSHY2elFCd2RjOXJYRjFreTJLd3JpSGpjcDZZK0p2MEM4?=
 =?utf-8?B?ekQ3NXlQWm1nZ1hXaEpjRFBWK3I2MXp5dXRhQ1VtbnR2NmFZSFZYRkt3VzVT?=
 =?utf-8?B?TWoxdWE2VENjMy9qeVkxc2xFL2d1N0hGVG9RalNhanE0NnVVK0dNR0c0RUlh?=
 =?utf-8?B?Vk4zZ09EYUUxQTNybUtuZUFhZHRHdHZZU0VaRGZyKzUycFBtN3d3c3VlcHd3?=
 =?utf-8?B?bDU1MVhsZThkU1IyZUx4ZjJtNzFBL2JUSXFKbjRvTkU3RlFBQUN6cklOZWo1?=
 =?utf-8?B?ZlNJeThFZ2VQL2RXUFNrZFNaTW9ERytxZEtXT0R2N2FrTncrdlkvTzd1Y1ov?=
 =?utf-8?B?Njc1eXN0RzBuMlNYVENnRi9qK2NvZWNzUnZtanloNERoc1ZmaXhSUWc2N3F4?=
 =?utf-8?B?eHVLcDlKdzlUdmFFQ0g2OXBuZW9hNCtvQXJYVUovUWs0eUdoeUxHRTRFZTB1?=
 =?utf-8?B?UkJZMFdEc1FsVW9LNUxUajJKS1FKQlhsUHBBZzNLeUVrdi9QbWdIelZxVWhZ?=
 =?utf-8?B?dzByL1pHcW03UnNnNHZVaXFYM2FuVys1aCtBSkxBRjU0TEE4cWxWTWpFVlB5?=
 =?utf-8?B?TDRybDJvOTlicENWd2tFL05DcHJmREljRmFwaC9KaHFMbEVwSUI3bzE2Q3Ir?=
 =?utf-8?B?Um9Nc2thTGI3R3h5QzJWai82Q3JPRU5aaHRaZngxOCtNSUJHT1gvdE5BRmlW?=
 =?utf-8?B?bksrUzZTeTBVN3dML2g1UnN0anFpSjFnRzBOcStPditJaDRWK0ZGd2xZZ3Vr?=
 =?utf-8?B?cWl3Tk9ob0RMK1BDbHp6eUp4aW4zbjFuYWpxSFZnSXZBWm9HVSsrTGc4QjA1?=
 =?utf-8?B?T1AzUDg0QUhackxqK3hOTEZtQ21RajNDL2trck9iSkJrK1A3NWZmU0hBdDZ1?=
 =?utf-8?B?Zmhxby9nNkpBMlBYL3dHeWpFSmJibW1iTGRaYlRXMWxuL0ZTTzREUGE1RG91?=
 =?utf-8?Q?LWZxXF/CgPJX5hlO/0nbGM8GH36l/QEpI88LWoTXfWzO?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b4b847-83a2-4e0e-6af0-08db77a35841
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2023 06:46:05.5757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6DWp3ogmkJSFzDe95hEjkghDRS/g882ozp7q/AUyqeYH64IR3sZ1J5cQEnN3B6e3+T0u5FN95gLmAwWjyV0fgvHHWdiR0yJfi5+3oNQQXvwxinRofETqbxrlm+1JOBzp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR01MB6708
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Marc,


On 15-05-2023 11:00 pm, Marc Zyngier wrote:
> This is the 4th drop of NV support on arm64 for this year.
> 
> For the previous episodes, see [1].
> 
> What's changed:
> 
> - New framework to track system register traps that are reinjected in
>    guest EL2. It is expected to replace the discrete handling we have
>    enjoyed so far, which didn't scale at all. This has already fixed a
>    number of bugs that were hidden (a bunch of traps were never
>    forwarded...). Still a work in progress, but this is going in the
>    right direction.
> 
> - Allow the L1 hypervisor to have a S2 that has an input larger than
>    the L0 IPA space. This fixes a number of subtle issues, depending on
>    how the initial guest was created.
> 
> - Consequently, the patch series has gone longer again. Boo. But
>    hopefully some of it is easier to review...
> 

I am facing issue in booting NestedVM with V9 as well with 10 patchset.

I have tried V9/V10 on Ampere platform using kvmtool and I could boot
Guest-Hypervisor and then NestedVM without any issue.
However when I try to boot using QEMU(not using EDK2/EFI), 
Guest-Hypervisor is booted with Fedora 37 using virtio disk. From 
Guest-Hypervisor console(or ssh shell), If I try to boot NestedVM, boot 
hangs very early stage of the boot.

I did some debug using ftrace and it seems the Guest-Hypervisor is
getting very high rate of arch-timer interrupts,
due to that all CPU time is going on in serving the Guest-Hypervisor
and it is never going back to NestedVM.

I am using QEMU vanilla version v7.2.0 with top-up patches for NV [1]

[1] 
https://lore.kernel.org/all/20230227163718.62003-1-miguel.luis@oracle.com/

> [1] https://lore.kernel.org/r/20230405154008.3552854-1-maz@kernel.org
> 
> Andre Przywara (1):
>    KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ
> 
> Christoffer Dall (5):
>    KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2
>    KVM: arm64: nv: Implement nested Stage-2 page table walk logic
>    KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
>    KVM: arm64: nv: vgic: Emulate the HW bit in software
>    KVM: arm64: nv: Sync nested timer state with FEAT_NV2
> 
> Jintack Lim (7):
>    KVM: arm64: nv: Trap CPACR_EL1 access in virtual EL2
>    KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
>    KVM: arm64: nv: Respect virtual CPTR_EL2.{TFP,FPEN} settings
>    KVM: arm64: nv: Respect virtual HCR_EL2.{NV,TSC) settings
>    KVM: arm64: nv: Configure HCR_EL2 for nested virtualization
>    KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
>    KVM: arm64: nv: Nested GICv3 Support
> 
> Marc Zyngier (46):
>    KVM: arm64: Move VTCR_EL2 into struct s2_mmu
>    arm64: Add missing Set/Way CMO encodings
>    arm64: Add missing VA CMO encodings
>    arm64: Add missing ERXMISCx_EL1 encodings
>    arm64: Add missing DC ZVA/GVA/GZVA encodings
>    arm64: Add TLBI operation encodings
>    arm64: Add AT operation encodings
>    KVM: arm64: Add missing HCR_EL2 trap bits
>    KVM: arm64: nv: Add trap forwarding infrastructure
>    KVM: arm64: nv: Add trap forwarding for HCR_EL2
>    KVM: arm64: nv: Expose FEAT_EVT to nested guests
>    KVM: arm64: nv: Add trap forwarding for MDCR_EL2
>    KVM: arm64: nv: Add trap forwarding for CNTHCTL_EL2
>    KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
>    KVM: arm64: nv: Handle virtual EL2 registers in
>      vcpu_read/write_sys_reg()
>    KVM: arm64: nv: Handle SPSR_EL2 specially
>    KVM: arm64: nv: Handle HCR_EL2.E2H specially
>    KVM: arm64: nv: Save/Restore vEL2 sysregs
>    KVM: arm64: nv: Support multiple nested Stage-2 mmu structures
>    KVM: arm64: nv: Handle shadow stage 2 page faults
>    KVM: arm64: nv: Restrict S2 RD/WR permissions to match the guest's
>    KVM: arm64: nv: Set a handler for the system instruction traps
>    KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
>    KVM: arm64: nv: Fold guest's HCR_EL2 configuration into the host's
>    KVM: arm64: nv: Hide RAS from nested guests
>    KVM: arm64: nv: Add handling of EL2-specific timer registers
>    KVM: arm64: nv: Load timer before the GIC
>    KVM: arm64: nv: Don't load the GICv4 context on entering a nested
>      guest
>    KVM: arm64: nv: Implement maintenance interrupt forwarding
>    KVM: arm64: nv: Deal with broken VGIC on maintenance interrupt
>      delivery
>    KVM: arm64: nv: Allow userspace to request KVM_ARM_VCPU_NESTED_VIRT
>    KVM: arm64: nv: Add handling of FEAT_TTL TLB invalidation
>    KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like
>      information
>    KVM: arm64: nv: Tag shadow S2 entries with nested level
>    KVM: arm64: nv: Add include containing the VNCR_EL2 offsets
>    KVM: arm64: nv: Map VNCR-capable registers to a separate page
>    KVM: arm64: nv: Move nested vgic state into the sysreg file
>    KVM: arm64: Add FEAT_NV2 cpu feature
>    KVM: arm64: nv: Fold GICv3 host trapping requirements into guest setup
>    KVM: arm64: nv: Publish emulated timer interrupt state in the
>      in-memory state
>    KVM: arm64: nv: Allocate VNCR page when required
>    KVM: arm64: nv: Enable ARMv8.4-NV support
>    KVM: arm64: nv: Fast-track 'InHost' exception returns
>    KVM: arm64: nv: Fast-track EL1 TLBIs for VHE guests
>    KVM: arm64: nv: Use FEAT_ECV to trap access to EL0 timers
>    KVM: arm64: nv: Accelerate EL0 timer read accesses when FEAT_ECV is on
> 
>   .../virt/kvm/devices/arm-vgic-v3.rst          |  12 +-
>   arch/arm64/include/asm/esr.h                  |   1 +
>   arch/arm64/include/asm/kvm_arm.h              |  14 +
>   arch/arm64/include/asm/kvm_asm.h              |   4 +
>   arch/arm64/include/asm/kvm_emulate.h          |  93 +-
>   arch/arm64/include/asm/kvm_host.h             | 181 +++-
>   arch/arm64/include/asm/kvm_hyp.h              |   2 +
>   arch/arm64/include/asm/kvm_mmu.h              |  20 +-
>   arch/arm64/include/asm/kvm_nested.h           | 133 +++
>   arch/arm64/include/asm/stage2_pgtable.h       |   4 +-
>   arch/arm64/include/asm/sysreg.h               | 196 ++++
>   arch/arm64/include/asm/vncr_mapping.h         |  74 ++
>   arch/arm64/include/uapi/asm/kvm.h             |   1 +
>   arch/arm64/kernel/cpufeature.c                |  11 +
>   arch/arm64/kvm/Makefile                       |   4 +-
>   arch/arm64/kvm/arch_timer.c                   |  98 +-
>   arch/arm64/kvm/arm.c                          |  33 +-
>   arch/arm64/kvm/at.c                           | 219 ++++
>   arch/arm64/kvm/emulate-nested.c               | 934 ++++++++++++++++-
>   arch/arm64/kvm/handle_exit.c                  |  29 +-
>   arch/arm64/kvm/hyp/include/hyp/switch.h       |   8 +-
>   arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h    |   5 +-
>   arch/arm64/kvm/hyp/nvhe/mem_protect.c         |   8 +-
>   arch/arm64/kvm/hyp/nvhe/pkvm.c                |   4 +-
>   arch/arm64/kvm/hyp/nvhe/switch.c              |   2 +-
>   arch/arm64/kvm/hyp/nvhe/sysreg-sr.c           |   2 +-
>   arch/arm64/kvm/hyp/pgtable.c                  |   2 +-
>   arch/arm64/kvm/hyp/vgic-v3-sr.c               |   6 +-
>   arch/arm64/kvm/hyp/vhe/switch.c               | 206 +++-
>   arch/arm64/kvm/hyp/vhe/sysreg-sr.c            | 124 ++-
>   arch/arm64/kvm/hyp/vhe/tlb.c                  |  83 ++
>   arch/arm64/kvm/mmu.c                          | 255 ++++-
>   arch/arm64/kvm/nested.c                       | 799 ++++++++++++++-
>   arch/arm64/kvm/pkvm.c                         |   2 +-
>   arch/arm64/kvm/reset.c                        |   7 +
>   arch/arm64/kvm/sys_regs.c                     | 958 +++++++++++++++++-
>   arch/arm64/kvm/trace_arm.h                    |  19 +
>   arch/arm64/kvm/vgic/vgic-init.c               |  33 +
>   arch/arm64/kvm/vgic/vgic-kvm-device.c         |  32 +-
>   arch/arm64/kvm/vgic/vgic-v3-nested.c          | 248 +++++
>   arch/arm64/kvm/vgic/vgic-v3.c                 |  43 +-
>   arch/arm64/kvm/vgic/vgic.c                    |  29 +
>   arch/arm64/kvm/vgic/vgic.h                    |  10 +
>   arch/arm64/tools/cpucaps                      |   1 +
>   include/clocksource/arm_arch_timer.h          |   4 +
>   include/kvm/arm_arch_timer.h                  |   1 +
>   include/kvm/arm_vgic.h                        |  17 +
>   include/uapi/linux/kvm.h                      |   1 +
>   tools/arch/arm/include/uapi/asm/kvm.h         |   1 +
>   49 files changed, 4790 insertions(+), 183 deletions(-)
>   create mode 100644 arch/arm64/include/asm/vncr_mapping.h
>   create mode 100644 arch/arm64/kvm/at.c
>   create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c
> 

Thanks,
Ganapat
