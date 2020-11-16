Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28052B501D
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgKPSsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:48:41 -0500
Received: from mail-dm6nam08on2055.outbound.protection.outlook.com ([40.107.102.55]:32128
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727852AbgKPSsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:48:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lioW1Kctv0pULbwXVjxWcRMCyFL6Wfm3C5oxokdwniTK9gDNevTcBtFtejZCgXQ7CoozcPAXpfrW/1QLbmSyV5UF1BxSxAm3LCV74iy9YIhbCn+vSOPXZZMMxR4cfDpzk2JSzrMgIStpmN1rfQ/drYg8S3Ha1EOgZ0ZdYDZntm+WGsyB3IKrQ3ZR3D9i4tGNdnyP3xF9hwOU4Cuz+Rm5pqU4U3df1Tv9i3KL8WifAQKgENZtRZQhxqnngVFE91U6IWckYKGfxveDhb80VmUDOrBEygYeccaa9u/ZNE53i8fUjYMPgs8nlV9tIGhq/WY/xkFKrl1q+dxfoPR4pD+Gbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKE/Uoe+YycYp4dENPgGTLg3L4L3gwfpPsOFlfdazJs=;
 b=d6zD01R+NMFxUVq2PLwX0Kmr0vXAyrM4a6bO1qWuCWg2aKNBhaW4zciyPqs/TxGde4AIyB4C8KjWJo+ZVUuQYL2MC93v3sDAQ4WLJEMDI1zH9biGJM4kMehRd0PfHF1c50Ft8QQ36loXFcczwsu2vR6Q7Ruwy0EhTXW0NWcVL7dVavE2ZlZcbjdTkWCmpJNc7WM7JTXH2ChWt4jbjW9SEslqNMAKCKcHp2DlKL7RxWzXAufrdo7eD2OMja18qNNQgB/D2hMkIhgCeZinIw2ZLXDA6GTdlTn45VyN8ZzCoiB9fEpDGYsRXThcKF5WJhmufYnkx4Sfmlbi246lTfFDBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKE/Uoe+YycYp4dENPgGTLg3L4L3gwfpPsOFlfdazJs=;
 b=uhuj9bCjZD+LOwsMiAlLTdJIksoT9zwrl93fn8Mg1y5MXEZkYP4Ke6wEKJzD3GsQMA66dqmpJOPwDxjplpO5E1lA9Tfeg3PZyk+s4E7dr9CZLcRWjz0R0WvLM0FZjB54kNLMPgOxUCTDNiNdqjQg44l6O6OHA3bnut5A58EqFHI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2782.namprd12.prod.outlook.com (2603:10b6:805:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19; Mon, 16 Nov
 2020 18:48:35 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3541.025; Mon, 16 Nov 2020
 18:48:35 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, rth@twiddle.net, armbru@redhat.com,
        dgilbert@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, marcel.apfelbaum@gmail.com, mtosatti@redhat.com,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        ssg.sos.patches@amd.com
Subject: [PATCH 00/11] Add QEMU debug support for SEV guests
Date:   Mon, 16 Nov 2020 18:48:24 +0000
Message-Id: <cover.1605316268.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR07CA0112.namprd07.prod.outlook.com
 (2603:10b6:4:ae::41) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR07CA0112.namprd07.prod.outlook.com (2603:10b6:4:ae::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Mon, 16 Nov 2020 18:48:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0e6c01e9-f661-4db3-76e8-08d88a60394a
X-MS-TrafficTypeDiagnostic: SN6PR12MB2782:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27824E23E9AAD2623E47C47B8EE30@SN6PR12MB2782.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2IWaVGE5KqNBfjjnO+SAwdpMLaFv7c8u0U3RXbPk5SBcxVtn+fkdBtfkuullMDz1r1RSSSvrYpomnSbp4G2wu22ZIR2mjeN+9ULTNW68vXubc1Kbu9tHQmIzjuQU3RS3lPcJKjAHgHVC1nEsDONzZKn1v/RJgGvrdIOnoaPE12Rz/sYxnIQHYlkSnHsIjlUVqoCRN1yo0HJWtFB95EWp7tNlj9CAGxMzi/SD5NlLoOxvVQ+LqNMdSK8UylH7CtlWyi9J62+C+VfZ2Rv6byuNb1WCywh06+1ISAF+EDhXXiWzFo2zSdMOf4rLbBmQhKg6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(7416002)(6666004)(186003)(83380400001)(478600001)(4326008)(5660300002)(8936002)(2616005)(66556008)(8676002)(66476007)(6916009)(16526019)(66946007)(86362001)(316002)(7696005)(36756003)(52116002)(2906002)(26005)(6486002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FCUO8amu29drj4ZAY9teRNEjKR0QsmLPL8Fwp3Upl8w404zv+V9/Q+eaIb7yewra6KuuvAGTyVFUu0PSM7WsfZuH7MEA3O2TKgklBO6DPrQ6mv/7YET8cqX+ZQwd0/LcsMQteJZ4u+wBG16HLc1aQBb1DvS9fMBCmtqFjZ9GkRSw6yK42FCWsvVW50FFJu21H6VZxiY68dMVKwXi/clyIDdzq0vTFRyMGlPSheZhJQhDhhUsI1LsuTmGUrmS9NGgSF5DpNFC1XHowHytNpdB+kNPiWBwXka0zHl89xUkqQ2vV9kgL984C45bqxVUTljYybjacQafFbH1hIakCv66E2f1Q52Xc3XYAK5yeJXHGHGmAldhAQwvdTc7P8TUxPBMReVh2Z3v4UJzZW0xfDCluZjQEr4WGx4MWFw7HyDUhLAZFa18sRs5sfgeEEnzdB+N5WX4IEvvGgHxvkpRwi0H3Urwi10GJSW4B+NhItYBvCblFpBDvdhwyXYzyxDLqiZM0yCHJPpWWgpbKkAGL10Oz011hm2Bgi9pGORU9NUSIl5BRaZEhTO7akfa5uOj8138+colPGzYVdaJs60lp3Nf9ie43PKxTIPUlGRsmaxuLBCKNACbcMCFFx3Gh5wUdD0R86LiZwbGAeH71n/l4Xoilq/hBfIWdijxa8E7dWZhKtdSEcFIduyzuMf1dn15n0/5ubE2GNWueqV3YKRbw/dg8ff5wgK5mgyxLJ50ODLMNTt9iNsbrov+mEG7/ZLICuWDPpfg8a+pCumfdMPUTPI7Ylnn4dIeFbIq8dcDsH17WP72xUnfy4lmn7djnkCvxH2v1MG5G+L3y4R+umCIWw6V+oeCE3clRAfs/Q+pfKsRh89+thn1d2ukpluBTip7//SoMSAHxkmS7IJk54TFDpyGVw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e6c01e9-f661-4db3-76e8-08d88a60394a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 18:48:35.7099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mNFKoiplmUI1+A+qBTwC67OVJTheV75xXRfnyJEExvjXqBy/2sB0LcXdp0y/Hcw1Mdsl8Cu2TCfN8bTzhgAT0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2782
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

This patchset adds QEMU debug support for SEV guests. Debug requires access to the guest pages, which is encrypted when SEV is enabled.

KVM_SEV_DBG_DECRYPT and KVM_SEV_DBG_ENCRYPT commands are available to decrypt/encrypt the guest pages, if the guest policy allows for debugging.

Changes are made to the guest page table walker since SEV guest pte entries will have the C-bit set.

Also introduces new MemoryDebugOps which hook into guest virtual and physical memory debug interfaces such as cpu_memory_rw_debug,
to allow vendor specific assist/hooks for debugging and delegating accessing the guest memory.  This is used for example in case of
AMD SEV platform where the guest memory is encrypted and a SEV specific debug assist/hook will be required to access the guest memory.

The MemoryDebugOps are used by cpu_memory_rw_debug() and default to address_space_read and address_space_write_rom as described below.

typedef struct MemoryDebugOps {
    MemTxResult (*read)(AddressSpace *as, hwaddr phys_addr,
                        MemTxAttrs attrs, void *buf,
                        hwaddr len);
    MemTxResult (*write)(AddressSpace *as, hwaddr phys_addr,
                         MemTxAttrs attrs, const void *buf,
                         hwaddr len);
} MemoryDebugOps;

These ops would be used only by cpu_memory_rw_debug and would default to

static const MemoryDebugOps default_debug_ops = {
    .translate = cpu_get_phys_page_attrs_debug,
    .read = address_space_read,
    .write = address_space_write_rom
};

static const MemoryDebugOps *debug_ops = &default_debug_ops;

Ashish Kalra (3):
  exec: Add new MemoryDebugOps.
  exec: Add address_space_read and address_space_write debug helpers.
  sev/i386: add SEV specific MemoryDebugOps.

Brijesh Singh (8):
  memattrs: add debug attribute
  exec: add ram_debug_ops support
  exec: add debug version of physical memory read and write API
  monitor/i386: use debug APIs when accessing guest memory
  kvm: introduce debug memory encryption API
  sev/i386: add debug encrypt and decrypt commands
  hw/i386: set ram_debug_ops when memory encryption is enabled
  target/i386: clear C-bit when walking SEV guest page table

 accel/kvm/kvm-all.c       |  22 ++++
 accel/kvm/sev-stub.c      |   8 ++
 accel/stubs/kvm-stub.c    |   8 ++
 hw/i386/pc.c              |   9 ++
 hw/i386/pc_sysfw.c        |   6 +
 include/exec/cpu-common.h |  18 +++
 include/exec/memattrs.h   |   2 +
 include/exec/memory.h     |  49 ++++++++
 include/sysemu/kvm.h      |  15 +++
 include/sysemu/sev.h      |  12 ++
 monitor/misc.c            |   4 +-
 softmmu/cpus.c            |   2 +-
 softmmu/physmem.c         | 170 +++++++++++++++++++++++++-
 target/i386/kvm.c         |   4 +
 target/i386/monitor.c     | 124 +++++++++++--------
 target/i386/sev.c         | 244 ++++++++++++++++++++++++++++++++++++++
 target/i386/trace-events  |   1 +
 17 files changed, 642 insertions(+), 56 deletions(-)

-- 
2.17.1

