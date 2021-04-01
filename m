Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D956351B56
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbhDASHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:07:40 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24491 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237448AbhDASDn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:03:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617300224; x=1648836224;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=sA1ughufXpbJdzaXPt3yH7aX7ApdfSdtZkFyizG84Rk=;
  b=LjzAMu99Di2L98KwdSQSz5O3RFKhNpZaDTT+24RcSDeDlW2o5S9FVsjx
   tSwl+V/P+oTZmMmu2G58RsWLcfT6GHfZUy4F0S2RbB+7gDd9aA72uF0lX
   Xf5QzJWAv5+CheQXTxyjLzCzQZZgUJLwIFLSR9zcf5p5N0Lf/sHlry2y6
   UunoFvl4mQZHQdyzvAGeUBv+gA49i3YrlpJ/bZqPXHPYrp6qBSm6SJTvN
   kwNLPY5UhjZSi3mYSq5yozWZRmTORN2hcZ5f3C8WYHfeyOWM6Ens9JB2G
   ymAO8pWteOX356yFsEJ6F/ql5NReAJrJEAUIg7a2atxmr8UCpYkCrbgOF
   g==;
IronPort-SDR: +BS3lNSk5rjtMJIbxTcs1ejFgzmeDogzL4+qQmKxFs0Twwh+jjCQ4Nirp61OYBdoS+viPH42IP
 /P9+QqgUBjDNeNXKi8di0DIU2bpLAlNH9KJwZ/VM2M8XmdMqmqD72qxZRFHJIHmeR6eQ7GwA+g
 EUrR0MD4tYEEKALqOBMNUxuiXfLVL2h4BHADXoGtIA2qjtNjRtYH+8PX8At5b93i177x2++b7o
 wOH42sQvtBoXnkIk6OfIW3nEotepuyRs72DrtubXRovHrB0/+Z2/jEQT7RGEr7+TWkz406gtdZ
 soE=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="168041685"
Received: from mail-bl2nam02lp2050.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.50])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:39:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Luhrfh5h2hGeaw3HSks3jQaGPeD7Te1ZCe3REoUSw+k8BdHotqBq2Q6+e/rA2QJogNpgOmyyDBgqbLGpeuHelYMu4d21tyBZ19q8mWLsSKGf6wgh14hZ4TECwUVRYmzZNxqZeTLcGPHJaPhQZCJqKDRUlC/Pfx01uED2BsCFFKfXdJKCxvlmDNbygb/yOGle5yrNmgQrkzYtqMUsieFA4jKiU5gyC8T9hjUd7esVQGmEEWt3OqXFtxP5X5fR/4bVQ26QeNVRmZHzTbsfPw0rHhQF5DW2E+GPO28aJUPs2IJ8LS0YmMEEdNT6zhbnQOhAqBmogq60+jcrDEu1MHKrKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UD33KHr8BvOZN1T/ciBZGUqifZQcPygEsChKZaEvbc=;
 b=fZtTt1CSnE3+iui6QwqaIgrcDB27YsULBJksJrtIA27hZnwmmHzWMugyHV64h4GgXIByr/bhlQWZ+zQECot4IvF1j2zFW51j+9mkjNUibdj8WR5CbbO0wf6ss5payqbqttyom1DunDIN0BtXvUkCFHW7pLPwmoQs8ajPTLMrlb2Hmi+9cVFFMAFhfZ0+DvdU5jGAhBlQReQelGl8FgWEG7kEsY/ZF3jURkncY3+QaSRLB6eRBp7m2jxWf51JOiwh7JxzkSIwNwsqaxocRU6biQYg/VUQI8abUXMc8JUWyeoE6czmErpw41Ae4XtyXrAWU3TIzPRa3p1fiXcUHC3jug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UD33KHr8BvOZN1T/ciBZGUqifZQcPygEsChKZaEvbc=;
 b=uh0bYghlbY/THWnuimmslwdKtsAPqv5EIcmblux5i81wdRgmMBEK/ovhHiRaKv24EkkfpA0oFN4qD6GYEBQW54JkjB0Y0mV8xIOnlkXhOApvM0aUKoNOmfCl7wPhNUYlho7y9i2bInwt4dnDglb0EgH36B39AJW3YAbEFCTNBdE=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR0401MB3624.namprd04.prod.outlook.com (2603:10b6:4:78::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.30; Thu, 1 Apr
 2021 13:39:23 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:39:23 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH v17 16/17] RISC-V: KVM: Document RISC-V specific parts of KVM API
Date:   Thu,  1 Apr 2021 19:04:34 +0530
Message-Id: <20210401133435.383959-17-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401133435.383959-1-anup.patel@wdc.com>
References: <20210401133435.383959-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.112.210]
X-ClientProxiedBy: MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::20) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.112.210) by MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 13:39:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40f7b1c8-91cf-4467-8b6d-08d8f5138f21
X-MS-TrafficTypeDiagnostic: DM5PR0401MB3624:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR0401MB3624F14DD308577E76DB21018D7B9@DM5PR0401MB3624.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rbnuElSB2nt+WrBcvK+G7aixYnRFQoUshkqLCnAefxUcbj77fbDhcGhDrhkFBn8bjADDiU43GGAjojThN5kTvpNHQGRJPZ6iqOmWEgndWmIuvn+2acvzNjt82J/3CMbjiWG/DPxXWmfPX5SWlx9FlrKsk6MaVKoGWEg62C2AXny/EkiY2z9Kpdz6lt2KAt/+vexGPDHXOcrt0g0pe+pXoQUfSd137kpNIRCnEUX9y99XiVuDc5XzFGX34h5VD4uZ+EgyM8QeYn6UNXnpXnmTRnhaerHlriAyxEiw3bpk5ta47CNDHKz+5NCdGrcO9inkOUZ1Q4W0L5d/KLmd4L7e98tufCDp8KrLuccBB1pCvqMXL1BD3eteFu8Qr5xZDrDqkl95iKkHHiMc1MPkdVSQozNPb6qetySmI77VmCVg9jmOlgOFjhO+hya94knCtUHWAe23LZSmwVoVBtEvTesX57xrxDTLHwxaK6nMdsmHzQSrF/tNb1EeXL8Mz2EaXsZT+ihaVjL0Ht21uqY6tF/Y4evWh8TKlDRV/+XWtvnuIEMm8PnP6fNkv4W0Xuktc0rFSGeOfOYXjbagSWrOKe+QpoPz+AYdgfpGXrcn8ur9JwuhvqwINgLi2wbfsoiifyemxpjnkrncw5/ALxaQOTva1L4iSvhuh0jzDoe5/h1ZdKVLQ1tgqGZLE2rd09WKxugOlnHLccai5EhUCL4iuarqUGQAllaix4B4S0/nkhzUYDQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(5660300002)(55016002)(956004)(2616005)(7696005)(83380400001)(8886007)(38100700001)(86362001)(26005)(44832011)(30864003)(4326008)(7416002)(8676002)(66476007)(966005)(66946007)(478600001)(36756003)(1076003)(316002)(54906003)(110136005)(186003)(16526019)(8936002)(6666004)(52116002)(66556008)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?D+5j+M9Mx2hiOKdeLKE3blQgFr9GuSvVKwKpQnteXiS4iy9I0axIWOFyddZ7?=
 =?us-ascii?Q?jgV4BHn3QZ0Z63IW2AvQMgG19DeuYJdXTv5YM+c0dftXmTONWHGH/pHbRxMF?=
 =?us-ascii?Q?4xmtR4oL+UWVfP0K7K5Th515FwybFF8psQUNlfIlmmdX9tdCk31jRERGReC7?=
 =?us-ascii?Q?jr2/YSSh/u0AreUWw8ckrEaDM+OUy/G4z+tLzr5VNmwUkMPASmMOfNXdGFyk?=
 =?us-ascii?Q?fIWNPoOPavF1MLehcgBq18KH/a9RamqW8jEG7dQdnJetsA/hlKnxB9hvwpee?=
 =?us-ascii?Q?7u3uGH+80jwoC5Zxs8iUuXTB+nWFlJqmKB2jNwn2U7ZIO9VgXGp/6gW3O0/e?=
 =?us-ascii?Q?hmuQOLV3MsRumgJ3P1xzFVNzPqlaAFHBfe4WCHSiBhtB5D2H1yNFn6G+06cd?=
 =?us-ascii?Q?x+dsaI+2+vxxAePq3DurU1lIIaRX8RRadURsKVfi15JY/lbtUFCOpFZkVE4B?=
 =?us-ascii?Q?oDTnAhyRdIA7DGZenvWrnhyRSP7y7Y7hPMzywCIdRfB9h14aAZ7mxPD9ds+L?=
 =?us-ascii?Q?WrimG3Nf+EYSUvRl4Ei30Sywb6+tpmm6H2+1wAIY0GN3iDgfWmCKNiiTc64l?=
 =?us-ascii?Q?R4o14qqHKq9SleKx/7Llz9y+ixa0tcY4nR1pkq0pYef685OGn1FHPWgkGIXa?=
 =?us-ascii?Q?NyF2b0ismeMK3yHBUytKiPBcTq6m0HtM/lc1DjU4dILFnElE8gZQ0WJ8kUFz?=
 =?us-ascii?Q?2JM/V2JVoIdldqTzvNW3fTJaQ0rg4Ps8JMK8+EC/khihvkfoW7U0odsDl55a?=
 =?us-ascii?Q?k7hr8z4s16nqAvvkMli7I/IEonCAKaMC5Y9tsAEEndVzmkLYavRD2ADES0EO?=
 =?us-ascii?Q?UCOxF7y40jV/1EKLdzxzwybiX+WTrYT9hwbFQ0R/QPEbfP14QtadNwv7V7FE?=
 =?us-ascii?Q?zYp5mEUeP0SEQVPPu8AB7U0rZczdrlF5IldKLrW86P81U6aCFAEf9oxZb6jP?=
 =?us-ascii?Q?zZdxrMzfWL0iwVa9rB/0PptLGEZd22pXwNfOv8WJeYHfZU9Wr20TiTiSn+Ct?=
 =?us-ascii?Q?7Tg9v1JteHo4hJPenl53WdzAS4eR6NId6Z5Jd2SWbmpSV9y1M9DzGxfcYL1E?=
 =?us-ascii?Q?dpjzHyLsSpve4gXeJJ88pmJ+o+qQkkXTX0l39sUlSlZW6BG/sctGe+S7+MDG?=
 =?us-ascii?Q?YtPxXQ602VWi27RuYLIP18Pt0eywxBQ4DfG/8njA59dNZ5ftSoOZr5CpSZRE?=
 =?us-ascii?Q?r03SCSTviACB0rnsWDwIlCIfv/teCgD9AeBsGk5UyeaQdQk9CpPikjZcMvNR?=
 =?us-ascii?Q?k7XTDn9I+hikBZB8wIYf68jWAAUpPkV9Edr0HZm55Wr6tk7YBTPErrkBg9Y3?=
 =?us-ascii?Q?LyBTvz+akALi5//KoW4KdclY?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40f7b1c8-91cf-4467-8b6d-08d8f5138f21
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:39:23.0087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: posvN4D04IwHiTLgJRBXuCKsDBNSyu8wG+n9lzkuyJ8Ow04gka8YbLAvUsLhrVOtt+UvLp7R4FRVg6zxjqR7Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3624
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document RISC-V specific parts of the KVM API, such as:
 - The interrupt numbers passed to the KVM_INTERRUPT ioctl.
 - The states supported by the KVM_{GET,SET}_MP_STATE ioctls.
 - The registers supported by the KVM_{GET,SET}_ONE_REG interface
   and the encoding of those register ids.
 - The exit reason KVM_EXIT_RISCV_SBI for SBI calls forwarded to
   userspace tool.

CC: Jonathan Corbet <corbet@lwn.net>
CC: linux-doc@vger.kernel.org
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 Documentation/virt/kvm/api.rst | 193 +++++++++++++++++++++++++++++++--
 1 file changed, 184 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 307f2fcf1b02..c8fe09a62690 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -532,7 +532,7 @@ translation mode.
 ------------------
 
 :Capability: basic
-:Architectures: x86, ppc, mips
+:Architectures: x86, ppc, mips, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_interrupt (in)
 :Returns: 0 on success, negative on failure.
@@ -601,6 +601,23 @@ interrupt number dequeues the interrupt.
 
 This is an asynchronous vcpu ioctl and can be invoked from any thread.
 
+RISC-V:
+^^^^^^^
+
+Queues an external interrupt to be injected into the virutal CPU. This ioctl
+is overloaded with 2 different irq values:
+
+a) KVM_INTERRUPT_SET
+
+   This sets external interrupt for a virtual CPU and it will receive
+   once it is ready.
+
+b) KVM_INTERRUPT_UNSET
+
+   This clears pending external interrupt for a virtual CPU.
+
+This is an asynchronous vcpu ioctl and can be invoked from any thread.
+
 
 4.17 KVM_DEBUG_GUEST
 --------------------
@@ -1394,7 +1411,7 @@ for vm-wide capabilities.
 ---------------------
 
 :Capability: KVM_CAP_MP_STATE
-:Architectures: x86, s390, arm, arm64
+:Architectures: x86, s390, arm, arm64, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_mp_state (out)
 :Returns: 0 on success; -1 on error
@@ -1411,7 +1428,8 @@ uniprocessor guests).
 Possible values are:
 
    ==========================    ===============================================
-   KVM_MP_STATE_RUNNABLE         the vcpu is currently running [x86,arm/arm64]
+   KVM_MP_STATE_RUNNABLE         the vcpu is currently running
+                                 [x86,arm/arm64,riscv]
    KVM_MP_STATE_UNINITIALIZED    the vcpu is an application processor (AP)
                                  which has not yet received an INIT signal [x86]
    KVM_MP_STATE_INIT_RECEIVED    the vcpu has received an INIT signal, and is
@@ -1420,7 +1438,7 @@ Possible values are:
                                  is waiting for an interrupt [x86]
    KVM_MP_STATE_SIPI_RECEIVED    the vcpu has just received a SIPI (vector
                                  accessible via KVM_GET_VCPU_EVENTS) [x86]
-   KVM_MP_STATE_STOPPED          the vcpu is stopped [s390,arm/arm64]
+   KVM_MP_STATE_STOPPED          the vcpu is stopped [s390,arm/arm64,riscv]
    KVM_MP_STATE_CHECK_STOP       the vcpu is in a special error state [s390]
    KVM_MP_STATE_OPERATING        the vcpu is operating (running or halted)
                                  [s390]
@@ -1432,8 +1450,8 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm/arm64:
-^^^^^^^^^^^^^^
+For arm/arm64/riscv:
+^^^^^^^^^^^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
@@ -1442,7 +1460,7 @@ KVM_MP_STATE_RUNNABLE which reflect if the vcpu is paused or not.
 ---------------------
 
 :Capability: KVM_CAP_MP_STATE
-:Architectures: x86, s390, arm, arm64
+:Architectures: x86, s390, arm, arm64, riscv
 :Type: vcpu ioctl
 :Parameters: struct kvm_mp_state (in)
 :Returns: 0 on success; -1 on error
@@ -1454,8 +1472,8 @@ On x86, this ioctl is only useful after KVM_CREATE_IRQCHIP. Without an
 in-kernel irqchip, the multiprocessing state must be maintained by userspace on
 these architectures.
 
-For arm/arm64:
-^^^^^^^^^^^^^^
+For arm/arm64/riscv:
+^^^^^^^^^^^^^^^^^^^^
 
 The only states that are valid are KVM_MP_STATE_STOPPED and
 KVM_MP_STATE_RUNNABLE which reflect if the vcpu should be paused or not.
@@ -2572,6 +2590,144 @@ following id bit patterns::
 
   0x7020 0000 0003 02 <0:3> <reg:5>
 
+RISC-V registers are mapped using the lower 32 bits. The upper 8 bits of
+that is the register group type.
+
+RISC-V config registers are meant for configuring a Guest VCPU and it has
+the following id bit patterns::
+
+  0x8020 0000 01 <index into the kvm_riscv_config struct:24> (32bit Host)
+  0x8030 0000 01 <index into the kvm_riscv_config struct:24> (64bit Host)
+
+Following are the RISC-V config registers:
+
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
+  0x80x0 0000 0100 0000 isa       ISA feature bitmap of Guest VCPU
+======================= ========= =============================================
+
+The isa config register can be read anytime but can only be written before
+a Guest VCPU runs. It will have ISA feature bits matching underlying host
+set by default.
+
+RISC-V core registers represent the general excution state of a Guest VCPU
+and it has the following id bit patterns::
+
+  0x8020 0000 02 <index into the kvm_riscv_core struct:24> (32bit Host)
+  0x8030 0000 02 <index into the kvm_riscv_core struct:24> (64bit Host)
+
+Following are the RISC-V core registers:
+
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
+  0x80x0 0000 0200 0000 regs.pc   Program counter
+  0x80x0 0000 0200 0001 regs.ra   Return address
+  0x80x0 0000 0200 0002 regs.sp   Stack pointer
+  0x80x0 0000 0200 0003 regs.gp   Global pointer
+  0x80x0 0000 0200 0004 regs.tp   Task pointer
+  0x80x0 0000 0200 0005 regs.t0   Caller saved register 0
+  0x80x0 0000 0200 0006 regs.t1   Caller saved register 1
+  0x80x0 0000 0200 0007 regs.t2   Caller saved register 2
+  0x80x0 0000 0200 0008 regs.s0   Callee saved register 0
+  0x80x0 0000 0200 0009 regs.s1   Callee saved register 1
+  0x80x0 0000 0200 000a regs.a0   Function argument (or return value) 0
+  0x80x0 0000 0200 000b regs.a1   Function argument (or return value) 1
+  0x80x0 0000 0200 000c regs.a2   Function argument 2
+  0x80x0 0000 0200 000d regs.a3   Function argument 3
+  0x80x0 0000 0200 000e regs.a4   Function argument 4
+  0x80x0 0000 0200 000f regs.a5   Function argument 5
+  0x80x0 0000 0200 0010 regs.a6   Function argument 6
+  0x80x0 0000 0200 0011 regs.a7   Function argument 7
+  0x80x0 0000 0200 0012 regs.s2   Callee saved register 2
+  0x80x0 0000 0200 0013 regs.s3   Callee saved register 3
+  0x80x0 0000 0200 0014 regs.s4   Callee saved register 4
+  0x80x0 0000 0200 0015 regs.s5   Callee saved register 5
+  0x80x0 0000 0200 0016 regs.s6   Callee saved register 6
+  0x80x0 0000 0200 0017 regs.s7   Callee saved register 7
+  0x80x0 0000 0200 0018 regs.s8   Callee saved register 8
+  0x80x0 0000 0200 0019 regs.s9   Callee saved register 9
+  0x80x0 0000 0200 001a regs.s10  Callee saved register 10
+  0x80x0 0000 0200 001b regs.s11  Callee saved register 11
+  0x80x0 0000 0200 001c regs.t3   Caller saved register 3
+  0x80x0 0000 0200 001d regs.t4   Caller saved register 4
+  0x80x0 0000 0200 001e regs.t5   Caller saved register 5
+  0x80x0 0000 0200 001f regs.t6   Caller saved register 6
+  0x80x0 0000 0200 0020 mode      Privilege mode (1 = S-mode or 0 = U-mode)
+======================= ========= =============================================
+
+RISC-V csr registers represent the supervisor mode control/status registers
+of a Guest VCPU and it has the following id bit patterns::
+
+  0x8020 0000 03 <index into the kvm_riscv_csr struct:24> (32bit Host)
+  0x8030 0000 03 <index into the kvm_riscv_csr struct:24> (64bit Host)
+
+Following are the RISC-V csr registers:
+
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
+  0x80x0 0000 0300 0000 sstatus   Supervisor status
+  0x80x0 0000 0300 0001 sie       Supervisor interrupt enable
+  0x80x0 0000 0300 0002 stvec     Supervisor trap vector base
+  0x80x0 0000 0300 0003 sscratch  Supervisor scratch register
+  0x80x0 0000 0300 0004 sepc      Supervisor exception program counter
+  0x80x0 0000 0300 0005 scause    Supervisor trap cause
+  0x80x0 0000 0300 0006 stval     Supervisor bad address or instruction
+  0x80x0 0000 0300 0007 sip       Supervisor interrupt pending
+  0x80x0 0000 0300 0008 satp      Supervisor address translation and protection
+======================= ========= =============================================
+
+RISC-V timer registers represent the timer state of a Guest VCPU and it has
+the following id bit patterns::
+
+  0x8030 0000 04 <index into the kvm_riscv_timer struct:24>
+
+Following are the RISC-V timer registers:
+
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
+  0x8030 0000 0400 0000 frequency Time base frequency (read-only)
+  0x8030 0000 0400 0001 time      Time value visible to Guest
+  0x8030 0000 0400 0002 compare   Time compare programmed by Guest
+  0x8030 0000 0400 0003 state     Time compare state (1 = ON or 0 = OFF)
+======================= ========= =============================================
+
+RISC-V F-extension registers represent the single precision floating point
+state of a Guest VCPU and it has the following id bit patterns::
+
+  0x8020 0000 05 <index into the __riscv_f_ext_state struct:24>
+
+Following are the RISC-V F-extension registers:
+
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
+  0x8020 0000 0500 0000 f[0]      Floating point register 0
+  ...
+  0x8020 0000 0500 001f f[31]     Floating point register 31
+  0x8020 0000 0500 0020 fcsr      Floating point control and status register
+======================= ========= =============================================
+
+RISC-V D-extension registers represent the double precision floating point
+state of a Guest VCPU and it has the following id bit patterns::
+
+  0x8020 0000 06 <index into the __riscv_d_ext_state struct:24> (fcsr)
+  0x8030 0000 06 <index into the __riscv_d_ext_state struct:24> (non-fcsr)
+
+Following are the RISC-V D-extension registers:
+
+======================= ========= =============================================
+    Encoding            Register  Description
+======================= ========= =============================================
+  0x8030 0000 0600 0000 f[0]      Floating point register 0
+  ...
+  0x8030 0000 0600 001f f[31]     Floating point register 31
+  0x8020 0000 0600 0020 fcsr      Floating point control and status register
+======================= ========= =============================================
+
 
 4.69 KVM_GET_ONE_REG
 --------------------
@@ -5475,6 +5631,25 @@ Valid values for 'type' are:
     Userspace is expected to place the hypercall result into the appropriate
     field before invoking KVM_RUN again.
 
+::
+
+		/* KVM_EXIT_RISCV_SBI */
+		struct {
+			unsigned long extension_id;
+			unsigned long function_id;
+			unsigned long args[6];
+			unsigned long ret[2];
+		} riscv_sbi;
+If exit reason is KVM_EXIT_RISCV_SBI then it indicates that the VCPU has
+done a SBI call which is not handled by KVM RISC-V kernel module. The details
+of the SBI call are available in 'riscv_sbi' member of kvm_run structure. The
+'extension_id' field of 'riscv_sbi' represents SBI extension ID whereas the
+'function_id' field represents function ID of given SBI extension. The 'args'
+array field of 'riscv_sbi' represents parameters for the SBI call and 'ret'
+array field represents return values. The userspace should update the return
+values of SBI call before resuming the VCPU. For more details on RISC-V SBI
+spec refer, https://github.com/riscv/riscv-sbi-doc.
+
 ::
 
 		/* Fix the size of the union. */
-- 
2.25.1

