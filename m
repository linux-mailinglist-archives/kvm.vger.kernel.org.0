Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32F22D69F1
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 22:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393714AbgLJVdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 16:33:07 -0500
Received: from mail-co1nam11on2080.outbound.protection.outlook.com ([40.107.220.80]:9057
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404938AbgLJVcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 16:32:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEcrrDRLC/OfFJWLagXdopk2nFYGg1aTepmS797TbVcWSJm6gj+58B+T01BvqJNqaMCDtDh+fkm+OuPgcowwU8SeC5O3NVa33KRjC7pkd0Xnerh34ygli3hOuwesp+RnO1GNNeiNYWXs8PWkWKmaE0cfbNMoaYfCbNV8fzm0ykYePZieHdnvGHSpvlcPvqqJaFavUS0Rp3be8ijhnEYUSJozIiFZWA0e9zZpTWqOH1ph+0tubVViXDdkXq8qB2cD0SFayMCegI75dRqu27U5cN10y3pfWu7zekzFhL4dZCmQ5X38Do2oLVohB/uGQDvsLczSV3FtMqlC1oon6oHHPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwBqQkpbvthLvRUvbBRNsp8KNJ7D4CaawKp8E75aRKI=;
 b=iczkp+SMKlxtMahRx0koXVLb745ym67gqR1gOW9D+RWkKG9edgzQh33bqKnXk/+pNB38Wtj30K3nmYznwlXthEfGTYRomq7mDbsAbZZ1BHRyDJEwIjd6jGkED0OkEcSVwvwuFm6Q9/0H6njujLF9TiTkqGHWWJlsh79EK5w8JHszcG1SZvrwqTb79kURiU4nwVSXEZNkFrn3/EYVFsE0J5A7Lr5aXBTUQ0D994RIHsc4VhLArETt5rgQsPT5i/e5cNbCS0j6bzlF4onkknv18cq2oXsgaFDwXCKBMQnEVfipVgNTTk0+FCs40j1wonDxsq3wgvhsIjlW6kYeOL0vyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwBqQkpbvthLvRUvbBRNsp8KNJ7D4CaawKp8E75aRKI=;
 b=onDdPFDWdKCPxKqJyQK0I7/q2/BjKGj/PpxCCKA/6gHzmYeudfcN59WU88bB/Sx51pTN6kic0j1QIleC/vAOXMZ47bwpI30g+WRksXJwcHS6Zmx7Dz7vdUgDwn4xKnQA0q3ZgHJqZXioyPVeVfSrvX9kCaPigqM+RzE8CINaYoQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4558.namprd12.prod.outlook.com (2603:10b6:806:72::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.15; Thu, 10 Dec
 2020 21:32:01 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece%3]) with mapi id 15.20.3654.017; Thu, 10 Dec 2020
 21:32:01 +0000
From:   Babu Moger <babu.moger@amd.com>
To:     seanjc@google.com
Cc:     babu.moger@amd.com, bp@alien8.de, fenghua.yu@intel.com,
        hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kim.phillips@amd.com, krish.sadhukhan@oracle.com,
        kvm@vger.kernel.org, kyung.min.park@intel.com,
        linux-kernel@vger.kernel.org, mgross@linux.intel.com,
        mingo@redhat.com, pbonzini@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, thomas.lendacky@amd.com, tony.luck@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, wei.huang2@amd.com,
        x86@kernel.org
Subject: Re: [PATCH 2/2] KVM: SVM: Add support for Virtual SPEC_CTRL
Date:   Thu, 10 Dec 2020 15:31:48 -0600
Message-Id: <20201210213148.18996-1-babu.moger@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <X863C6ikshtMHemk@google.com>
References: <X863C6ikshtMHemk@google.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR07CA0087.namprd07.prod.outlook.com
 (2603:10b6:4:ae::16) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from bmoger-ubuntu.amd.com (165.204.77.1) by DM5PR07CA0087.namprd07.prod.outlook.com (2603:10b6:4:ae::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 21:31:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3d6beeb9-dabc-4db0-5c53-08d89d53083a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4558:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4558C7C8AC90B49538F9F7F695CB0@SA0PR12MB4558.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n7I3Sfxf6JNi4WFidP6IqNqC/1vGQmCZLEn5YtUx5tsEjRzP4Cb5SspJugsrza7sckuwdyv6NwnSDDevU6KYPEMHqy+/mwZwruDdD8SwCCjZAHdZug+VVSEGBqNHUg0t/Wht/GovaLHfLCJV7XPGfYAn4mDSPuyIiTDshQ91Tx4zVaa0DH1JA30IJfaNeVdvOLe6AGaRcC8e1BDRC1+9/olxiCdGr5zsYxGclcG86WqYuHY6S5Q964cUPBFRMKCiioXmvs92msbWIfB+shV/Qe1DiHqnkxswI8wFlu1fBEcNYxp5KUwZVP5TJuAGPWyGnjILBftg5df/FKZFzsqdvMvpBKuQMaeSkn0izLvvdX/WpgQBb0ALDc4WWULhG7eN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(52116002)(36756003)(5660300002)(16526019)(6666004)(508600001)(44832011)(66946007)(66556008)(6916009)(186003)(956004)(2616005)(26005)(7696005)(8676002)(66476007)(2906002)(1076003)(4326008)(34490700003)(7416002)(86362001)(6486002)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?c4Vy0w2oULXQMhE2yn+RJ+oIDiFH7hKZZKkrb6qPSOkg4yvX2AqNhQfqDixB?=
 =?us-ascii?Q?cAM1DWPocFYjLIucgagT2EF6f6OEXmEYI3CQfD6dhurkclT5KzQALlBI5oQH?=
 =?us-ascii?Q?+1I7a+ogrmFi5bu8P/IFEifyMLAuCfrldny7nDkIGiyxPD7pf36nztfegHRu?=
 =?us-ascii?Q?iS29+um5hfOgZKH3p9KRHhfHXLcTKucm+RzMsnV+7DyPkRKkdwrB1k83XEWa?=
 =?us-ascii?Q?n0+W5jv6U4nH2LdwqtcvpN2aVFqItO5OsR0dWyzA46WCyIyXRhVQ/7sYZksZ?=
 =?us-ascii?Q?tyzRU1QNgUeNQCHfMjge2Vw4bGEb6GKOMRnGkSQ41JAyk26J2edpwrVC7iDX?=
 =?us-ascii?Q?DEbIgLgPVuuPmms4TNKDVBAmGH2GR27wMIZQTJpnzZQteGxz/IZg239cBYn/?=
 =?us-ascii?Q?Wk8jyqaxt2O1DPw4nk0CVrnhD3Sc2cvflgdKVEnoWwmyaQV5EvbbiViCIZTe?=
 =?us-ascii?Q?Ndp8V1qWwGjkV29kx6Ip7zrAHcb1DjCOTk6UzQ/XR4b3dzwW0rPW6ITbFQ86?=
 =?us-ascii?Q?8xhuDM9yl4Ktm/PpyI5G/NcnBe4ftBm3Fv8YwuPOtWlwHMckoZG9VYH9hHap?=
 =?us-ascii?Q?S122+fXfsj5L2qAqlH/2g8egxFtryrQztwpwY3evUNAAUke7w/y0Wd+Sh6sg?=
 =?us-ascii?Q?C7dqGokoWmQaMKuShWt/5jzxZwIB5e0U4MDQ6HAtwGe2UpQ5c8fGwu5pbqxM?=
 =?us-ascii?Q?cG8nNDsFNgwQrfd7s2DdyeHFE+4jjwjVxkFWH3cmE3ngXUz4IwUyYmck48S2?=
 =?us-ascii?Q?+NueN/25FhCzNQTobwgkr77u9FOnOLQQmif+zjk82npXYB7w9qL1IEZR5dIL?=
 =?us-ascii?Q?gh5ZK2fX7qcZddC75Y2Lt/188C0tRmwMTDNI/UWVF8kF1Cq3GmHCtxdegW28?=
 =?us-ascii?Q?vGPUlDZWp8gSNRYfeZdZxdOUpXpRMPcEURoc7YRfPr9Ntoip/D+VxO+p4oR8?=
 =?us-ascii?Q?buiqQaTCGMCty29/UgyNEserIHHiLEYKdkCX7BnKNHtF8dj4Mju04PQYlNxH?=
 =?us-ascii?Q?KwaI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 21:32:01.7494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6beeb9-dabc-4db0-5c53-08d89d53083a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4CbY9qJAigXLJIvG/sGU8riFbWN1HBlP/LqkWR9h2Olme1RL5LvYOce+xU4VYgCQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4558
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean, Your response did not land in my mailbox for some reason.
 Replying using In-reply-to option.

>Hrm, is MSR_AMD64_VIRT_SPEC_CTRL only for SSBD?  Should that MSR be renamed to
>avoid confusion with the new form of VIRT_SPEC_CTRL?

We can rename it to MSR_AMD64_VIRT_SSBD_SPEC_CTRL if that is any better.

>Well, it's still required if the hypervisor wanted to allow the guest to turn
>off mitigations that are enabled in the host.  I'd omit this entirely and focus
>on what hardware does and how Linux/KVM utilize the new feature.

Ok. Sure.

>This line needs to be higher in the changelog, it's easily the most relevant
>info for understanding the mechanics.  Please also explicitly state the context
>switching mechanics, e.g. is it tracked in the VMCB, loaded on VMRUN, saved on
>VM-Exit, etc...

Will add more details.

>This will break migration, or maybe just cause wierdness, as userspace will
>always see '0' when reading SPEC_CTRL and its writes will be ignored.  Is there
>a VMCB field that holds the guest's value?  If so, this read can be skipped, and
>instead the MSR set/get flows probably need to poke into the VMCB.

Yes. The guest SEPC_CTRL value is saved in VMCB save area(i.e. 0x400 + 0x2E0).
Yes, will look into setting VMCB with the desired values in msr set/get if 
that helps.
Thanks
Babu
