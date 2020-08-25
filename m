Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CE2251F7D
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 21:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgHYTGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 15:06:04 -0400
Received: from mail-bn7nam10on2082.outbound.protection.outlook.com ([40.107.92.82]:26557
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726066AbgHYTGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 15:06:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjcS1jxPIa9Sjv+RLknuqoEcedZ6peZlKEQoRItHlIsfCmrVjZYo2P6WcLehn9uIpv4IyJAMe3ub7c8ai8Mg/eu8Zm2WG6qvHGDaHPLNVk7f1XrWpY7PQLMWqyM+mIkr5xkJuqxQnh3F/bl/xgMd8s7JHKedciRpId8ZybLSQB6r0Ge1w29otIbDwXuyIHwWwe4mrHTZTZUcy/vkPfhaSidjGmZbuuSozBABLKshNze23s+0fFgVaO7PI4cueT6BFdXVgJGuMkBcvUHSor5K2etHxFVXjFCCK+izH8u77zAnSuYDah+ofzheAQEc+A46nHjZbeQXTIqSWCRG3Ri92Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGjpO7WPS2TOt2AVoJ9MRAr5ib2VtjdjGHv0KEkusoA=;
 b=TwIgbYlDnEGRLoCmp4HQ+fIkZhI/drhc5YJNOCdKq3EYTP50Y9fZuaXOOcfSZDwZupj7Kc1Nj4lyxGr/d105HEsIZtWzeb26l7oHv4CbVngxcYRfDnzJNCfsl8HIE/nMYCoKTr8uSaSqMsMc+BJj9NzZvSIbs0DFV3Ep6h+JC6sw1Ln885HfJs6kA/o2HJU+REPeHJJAogeOsNFxidxYxHPvzrxHBFjUmpzyafb9seh6u5IUOEqW0QIS46LfS1vxWLA7qjxLEa26dtWJszYVZ/vpHH4KQIoyt7nirj4b5ugxlYKFBUBkupSvnBHHv14CzJ99lseqELi9FSh7NAFcQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGjpO7WPS2TOt2AVoJ9MRAr5ib2VtjdjGHv0KEkusoA=;
 b=YMiEhbxqi/fZgyeCNvQTL2pIDtMRspBi8woIDmffDWg2ajz6wz+e6yTONkaLrJdvYCzFg9q9xNWZOSlRTNM39RkuOPDQx8lMuMXusxsHZ4hPxtzZPmoyTw6Wmpr7Wwi5CXHzjWKC3GesG6hIbaTb7rCCRrbCDUZpTJZVVJnNXhA=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0219.namprd12.prod.outlook.com (2603:10b6:4:56::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.25; Tue, 25 Aug 2020 19:05:58 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 19:05:58 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH 0/4] SEV-ES guest support
Date:   Tue, 25 Aug 2020 14:05:39 -0500
Message-Id: <cover.1598382343.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR16CA0014.namprd16.prod.outlook.com
 (2603:10b6:3:c0::24) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM5PR16CA0014.namprd16.prod.outlook.com (2603:10b6:3:c0::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Tue, 25 Aug 2020 19:05:57 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 26119b52-ccb2-4ed2-a4cd-08d84929e67a
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0219:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB02199A83C0CE0192448BA694EC570@DM5PR1201MB0219.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kskI6cGeRdN6L0P3nuHwQcaoRD4NPPH+cydlJTQJRDdsQQtZe9Npc02/Miiv4ONOIAknk6l+m0bByWtZiVPGw67hKL+fqn9HfOzOZfbLe3jgyn6Ygmo9W/Wjnewk3CpvP/tuwiaspYx/Z65keFJHsijTo4i46L51GvY7vwJnF5LYBygItGi1rdEVUJ3wxpG60nIEbf37RijE/nJAzJNxP8/vq5cD0SsasaVB8BVmKM8tsHEniipBORFmTqXSoLSDoaJ+oT2agPK3cKWawPRF6QnbWM/u+4hWAtuFQYZzJESEBnrWAK2Y/3S//aEX9x1cPWTzT7jjZx6vrMHhnCyNo1RgYi95bs712Qwvmxf9CmqnPq4HX9HNdLI4535bfQEndFOhvknlDriRZcJm+Llta2NmnVzo1PWeS2FYSnTVBOMgf9iNy7k6Qmmu/h06a5T2ueVBzpFf/RYuwa7OhodvsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(4326008)(186003)(86362001)(8676002)(83380400001)(54906003)(16576012)(966005)(8936002)(6486002)(316002)(478600001)(36756003)(52116002)(26005)(6666004)(66556008)(2616005)(66476007)(66946007)(956004)(2906002)(5660300002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: J7IxsZWr3Qh9e5ChUgW8YnEArYmJrU471ZP2hgQc6vuU8RiAdS6Gz7Yxe+/GIMR/reFzOYwb2I6Y8KcoCkkUyH0CWVs5kmjPYuX9Cy4XaszeQksGg90iOpwPVrF+7BOyUau3+DCBIQTSe1DsZ0P2hC8aHspekHDAzn+cbwNVJ4up+RtR1+kJHQR+KwPKPMSZj8FcwT8ms7qGMG3wB4dQ+1haw3osWvZmRiJvYRk2Y03qy1KqAM6/jIcRXW+W1JwzNFPuKX5w6MqeqU6bUudOdKpvJ+ic8TRi5mGYuNNP5wxMSi7gHA08/44mLPc1JaJhdcfPOkT6jQfBkWboSqzyakkb796B4jslR4QI3CgkySq4tGvQDbZZlCn+H63Z+KMtvqaBwsj5E1oEtBfBJJrS5hjKAo12ayR37Us2TMf3/Y93Nd8BBn8F7E0FbLkVgPGfwGBoISjpgcSDRIDiOkTSMVCXC3Ej2ckNhJSCPtyW1XVolZWSrQ37XgVgZX2FqfRe2CH5hOZlSbSDLYHxz3pjo1JoEWteyG7FmK9KLaRtRxYCP24iph2Rw9joOSeLWckK61yyP6nkpQwhGu9OZJFX97lj/CESmNMslC+by6waw7PMKihby4qAo+4gcfbKyWzfWTndOB9BRih374TV/BvhMQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26119b52-ccb2-4ed2-a4cd-08d84929e67a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 19:05:58.5117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pi+ZesfZSkg4JcuBXXHw6a8d4ao/qW5u3ox1hJ8tQfPXhFN2aFnsXXNYVu6VfPDEwtg04p87UPTI2wCU7kf1qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0219
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

This patch series provides support for launching an SEV-ES guest.

Secure Encrypted Virtualization - Encrypted State (SEV-ES) expands on the
SEV support to protect the guest register state from the hypervisor. See
"AMD64 Architecture Programmer's Manual Volume 2: System Programming",
section "15.35 Encrypted State (SEV-ES)" [1].

In order to allow a hypervisor to perform functions on behalf of a guest,
there is architectural support for notifying a guest's operating system
when certain types of VMEXITs are about to occur. This allows the guest to
selectively share information with the hypervisor to satisfy the requested
function. The notification is performed using a new exception, the VMM
Communication exception (#VC). The information is shared through the
Guest-Hypervisor Communication Block (GHCB) using the VMGEXIT instruction.
The GHCB format and the protocol for using it is documented in "SEV-ES
Guest-Hypervisor Communication Block Standardization" [2].

The main areas of the Qemu code that are updated to support SEV-ES are
around the SEV guest launch process and AP booting in order to support
booting multiple vCPUs.

There are no new command line switches required. Instead, the desire for
SEV-ES is presented using the SEV policy object. Bit 2 of the SEV policy
object indicates that SEV-ES is required.

The SEV launch process is updated in two ways. The first is that a the
KVM_SEV_ES_INIT ioctl is used to initialize the guest instead of the
standard KVM_SEV_INIT ioctl. The second is that before the SEV launch
measurement is calculated, the LAUNCH_UPDATE_VMSA SEV API is invoked for
each vCPU that Qemu has created. Once the LAUNCH_UPDATE_VMSA API has been
invoked, no direct changes to the guest register state can be made.

AP booting poses some interesting challenges. The INIT-SIPI-SIPI sequence
is typically used to boot the APs. However, the hypervisor is not allowed
to update the guest registers. For the APs, the reset vector must be known
in advance. An OVMF method to provide a known reset vector address exists
by providing an SEV information block, identified by UUID, near the end of
the firmware [3]. OVMF will program the jump to the actual reset vector in
this area of memory. Since the memory location is known in advance, an AP
can be created with the known reset vector address as its starting CS:IP.
The GHCB document [2] talks about how SMP booting under SEV-ES is
performed.

[1] https://www.amd.com/system/files/TechDocs/24593.pdf
[2] https://developer.amd.com/wp-content/resources/56421.pdf
[3] 30937f2f98c4 ("OvmfPkg: Use the SEV-ES work area for the SEV-ES AP reset vector")
    https://github.com/tianocore/edk2/commit/30937f2f98c42496f2f143fe8374ae7f7e684847

---

These patches are based on commit:
d0ed6a69d3 ("Update version for v5.1.0 release")

(I tried basing on the latest Qemu commit, but I was having build issues
that level)

A version of the tree can be found at:
https://github.com/AMDESE/qemu/tree/sev-es-v9

Tom Lendacky (4):
  sev/i386: Add initial support for SEV-ES
  sev/i386: Allow AP booting under SEV-ES
  sev/i386: Don't allow a system reset under an SEV-ES guest
  sev/i386: Enable an SEV-ES guest based on SEV policy

 accel/kvm/kvm-all.c       | 68 ++++++++++++++++++++++++++++
 accel/stubs/kvm-stub.c    |  5 +++
 hw/i386/pc_sysfw.c        | 10 ++++-
 include/sysemu/cpus.h     |  2 +
 include/sysemu/hw_accel.h |  4 ++
 include/sysemu/kvm.h      | 18 ++++++++
 include/sysemu/sev.h      |  2 +
 softmmu/cpus.c            |  5 +++
 softmmu/vl.c              |  5 ++-
 target/i386/cpu.c         |  1 +
 target/i386/kvm.c         |  2 +
 target/i386/sev-stub.c    |  5 +++
 target/i386/sev.c         | 95 ++++++++++++++++++++++++++++++++++++++-
 target/i386/sev_i386.h    |  1 +
 14 files changed, 219 insertions(+), 4 deletions(-)

-- 
2.28.0

