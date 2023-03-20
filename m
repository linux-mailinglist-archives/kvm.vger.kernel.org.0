Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76C16C1F4E
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 19:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbjCTSQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 14:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjCTSPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 14:15:53 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C479029;
        Mon, 20 Mar 2023 11:09:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDaZYYZ9D8A8XMznK7rgomK0Ol3F1v8yKPtHL8cq+Lyypk8LTLAp1hlDc09j2ZHQpPGmjTWs9+lRlSoECduGj68jw/mTPAeSyynh08IktIEQG5hjYchroB4tn1WjhhXlfM+LDNT/yiQzZ5WmUDyH14TRxfLRMmtv2vqLtQv91J/aWrOQyb/cBE9/zBbet0Dn/5S13SIhlF4emHgJwavcxR3uO/oeYDFuicnaxkXYKMkEo3IKsuMjNP583qiRAsfpn3ixJrZMHtKQGKdtuhAn8I0epJJrXHCflyVVwJEPmq+2zaEvXQQgeCTKh1yNInw3GRKc7tg0kNgNECP+Zu5EFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBqqtCCyNrjVVfmw0bqz563/qEySO7Z84R6+44BArg4=;
 b=F/7qs86ON1ljUD6X+T0MPAZZufBRzwzdlHTa4k7W1MurxF5UwSPb8tP9/20v4zW6Cq1j+QXWjqp7b/6r1leEzdCo9thaVRVfFfylywFZSukLU4R1Z29wxzBYofoT8+V715YRsQC1uBhoZ6VpU/KP9slsxQfm3iKsvFv5BdC07nYG13+lhY+ArG0Iz2PK5KSNw/2c5ASwTZDQYcAwgSRgiHpN0aafupOnjsD/eAfEpABsJx1p0pWrzQOrSe+ixktnzfLmz7xMqvQwYrFQHIc9LyXARZUP/MBtq32S+iTfnPR6rx8mYpTy2HSpvV0mYFA8zd2weCtnfplWbJ/NnTHpRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBqqtCCyNrjVVfmw0bqz563/qEySO7Z84R6+44BArg4=;
 b=vxnpdECUpxjXKP7tFcv/8b9VZnSQoVzHMyh0HDNlx5np3wxSihkqmtnlWvMgnpPhKqvSO7yGsIdxwOw6OwQIVPWW0FhEMLsR+oPJ2sARP1WeT9LFmIFVytsTcD//gqFsTc1pO45YT4biVqNQo5NEGs3WN8jpf9ev4h93xQ+Bx6s=
Received: from BN9PR03CA0739.namprd03.prod.outlook.com (2603:10b6:408:110::24)
 by CY5PR12MB6202.namprd12.prod.outlook.com (2603:10b6:930:25::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 18:09:25 +0000
Received: from BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::a8) by BN9PR03CA0739.outlook.office365.com
 (2603:10b6:408:110::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Mon, 20 Mar 2023 18:09:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT110.mail.protection.outlook.com (10.13.176.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.15 via Frontend Transport; Mon, 20 Mar 2023 18:09:25 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 20 Mar
 2023 13:09:24 -0500
Date:   Mon, 20 Mar 2023 13:09:09 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
CC:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>
Subject: Re: [PATCH RFC v8 03/56] KVM: x86: Add platform hooks for private
 memory invalidations
Message-ID: <20230320180909.gsffri3fdfdleewc@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-4-michael.roth@amd.com>
 <20230318051322.GF408922@ls.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230318051322.GF408922@ls.amr.corp.intel.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT110:EE_|CY5PR12MB6202:EE_
X-MS-Office365-Filtering-Correlation-Id: 10fa67c9-8272-414d-2135-08db296e3d0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CAjiZp2+DdMErGjMGhW9oxqU39Qp8byZzx/+/ys8LIeIvgff6+5PyrJmaIO4CD0T7ue3UV0cUFr/ViRraB/yY8UQO1Ys7fNh/f/iADG/KMZ/4CryAQPkCF4IhC6+HNpkC2Zq9+KnamlhHpvQXYZ1RpKV52U350pQphuRZpm1aiu0zdyR0ux4I10gyzS+0uXy99zz4xTrGgjYRG5Lv/pLOFIaAzfwTU9vFlzU+PPAgeYPtIabtF9GHDETax204wN9BiimD/yVwgAP3lOiPsSeo3FbKlJFDiZV+xWwuRliy44iGKh2mHy7Lh/fuEsYCjmc3boSRar/WHrU6cBtgQuZiuKtnOBTsFmxvTbOfAnWhZpGonqImoN1hYIuXAVjciWyqHD4vH+Yd2NCq37NmSBDHEyUbj2njWIg0lj0tb/q+ueZ1eGNiSJaZHEcqcA4rp8hMq0T60/yY+iYT6zxwbpvgXpEdlNEALUSNmAYzfTXFthlPZAKN7WRHdmZ0JszRhn/vb3OBx374z+1m8i/gWFknHqIQPk+M5SoyrfMT5wEpNJ8MHzp2gODzUDWc8iVY9YoNsPjZCE4yPcKBuHCAFPIZzD88/z5n9jrdixPX5HfiBJdHBgFXWyRmqIiq7XqIwmSK1myy40Xa0c0a6A7ZsEE055bVHB5v8qij+NnA36NgNOIIjqZpFHkWmxxU/BE58Tniw2X4sa3LWhQxorYc1q2UblYRt6lM99c2sdF2QFWBMU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199018)(36840700001)(40470700004)(46966006)(426003)(316002)(40480700001)(47076005)(44832011)(54906003)(70586007)(36860700001)(70206006)(36756003)(8936002)(8676002)(6916009)(4326008)(7416002)(7406005)(41300700001)(5660300002)(2906002)(478600001)(86362001)(40460700003)(81166007)(82740400003)(83380400001)(82310400005)(356005)(336012)(6666004)(2616005)(186003)(16526019)(1076003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 18:09:25.0065
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10fa67c9-8272-414d-2135-08db296e3d0e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6202
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 10:13:22PM -0700, Isaku Yamahata wrote:
> On Mon, Feb 20, 2023 at 12:37:54PM -0600,
> Michael Roth <michael.roth@amd.com> wrote:
> 
> > In some cases, like with SEV-SNP, guest memory needs to be updated in a
> > platform-specific manner before it can be safely freed back to the host.
> > Add hooks to wire up handling of this sort to the invalidation notifiers
> > for restricted memory.
> > 
> > Also issue invalidations of all allocated pages during notifier/memslot
> > unbinding so that the pages are not left in an unusable state when
> > they eventually get freed back to the host upon FD release.
> 
> I'm just curios. Could you please elaborate?
> Unbind is happen only when memory slot is delete or vm is destroyed.  In the
> case of memory slot deletion, the gpa region is zapped via
> kvm_arch_commit_memory_region().  In the case of VM destroy, we have
> kvm_flush_shadow_all() which calls
> kvm_arch_flush_shadow_all() =>kvm_mmu_zap_all().  Doesn't it work?

The main thing here is unbind happens right before the restrictedmem
pages are released back to the host, and for SNP we need to clear the
associated RMP table entries to switch them from guest-owned to
hypervisor-owned. It doesn't necessarily need to be a separate callback,
but I'm not sure if it makes sense to squash that down into the various
MMU zapping helpers.

-Mike

> 
> Thanks,
> -- 
> Isaku Yamahata <isaku.yamahata@gmail.com>
