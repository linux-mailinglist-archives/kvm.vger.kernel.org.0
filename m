Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA62C19CD7E
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 01:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390201AbgDBXa2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 19:30:28 -0400
Received: from mail-dm6nam10on2075.outbound.protection.outlook.com ([40.107.93.75]:51809
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390120AbgDBXa1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 19:30:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6dUHD0ZkwlCTIodLG1DZYCXn3Yhe8V2b/IAef+EDLez8wQYwpbkAijp+DXH0mzvDacIW9KiKXdKCMNZcnTfvMQkdQ4SiNgecT62KBo5rzXPMj1zmtc0awQUwptjCeJtM4LPIpqZDyZAP7kk8SxHREIhuA9eL6rNn6RSYDNng04fgcxYQNyHc24B7TbQnRZ0Zh/ogM/X4tcIkITFu6xXG3demX0lHh9AcL27vcisjgIKPt94bFpeRPJHpr5aAmdtgmfvSztjsNl2wViR+VqngTQegR3DAY8InmCiy6UI0HmW1sUxtVl0qz5sJXXiSbGnGQ/2NCNfn82ayXebdpWPhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qe5mG64s3VRIxXRhggt54Vjby30jaD5ho5+jhKOYyNo=;
 b=lrokFs7aLIeg9wuMgFbOds8K6qFpOJb/orjsTLe9WcHhLH4R01In9TpSGTWcGf4zm7Fx0Scq2dzT0jGNisVELEjZBHt5Oy4x9pH1SvMHCAbZHkQUwl0fO6dc++errHacYRMn0aAGiHENefc0b1timmHKsUOYvI/7DNUUGuMk5IyCqbXQJtJNDGby46jPbydq7Z+evSfVKgco9qCSeGZizzerfUzi5roUtHoYYsjQ1TgooDfHBd3oZ2F7+T03K1yErsUvdf4mHU/pOusUmTM3V2bPlKJkTgI3XY/hhBsK4oiSQDdh8yaB/1V7vrOsGGpqmZOLu7vZtidOGOhzSIsXlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qe5mG64s3VRIxXRhggt54Vjby30jaD5ho5+jhKOYyNo=;
 b=APLbIsJvwbCK4g8/tfcfqgp/Oq5ngGjAlYh18Jc1zD/FOmYlg7qIe82hi+VS81dWKhcPVvvk5ANxMBAX0XR/L48edaEmiaZY97jprHHfkLSfF59DNRSw9MfW6d/DbgP8CSLlbHgFXVVJbdBMoIeKYwXwUhWJEVanUJKUXKbkqRg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.19; Thu, 2 Apr 2020 23:29:48 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.017; Thu, 2 Apr 2020
 23:29:48 +0000
Date:   Thu, 2 Apr 2020 23:29:45 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        Thomas <Thomas.Lendacky@amd.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org
Subject: Re: [PATCH v6 13/14] KVM: x86: Introduce new
 KVM_FEATURE_SEV_LIVE_MIGRATION feature & Custom MSR.
Message-ID: <20200402232627.GA25831@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <21b2119906f4cce10b4133107ece3dab0957c07c.1585548051.git.ashish.kalra@amd.com>
 <9ab53cb5-5cfd-ee63-74ae-0a3188adffcc@amd.com>
 <20200330162730.GA21567@ashkalra_ubuntu_server>
 <1de5e95f-4485-f2ff-aba8-aa8b15564796@amd.com>
 <20200331171336.GA24050@ashkalra_ubuntu_server>
 <20200401070931.GA8562@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200401070931.GA8562@ashkalra_ubuntu_server>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SN6PR04CA0078.namprd04.prod.outlook.com
 (2603:10b6:805:f2::19) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN6PR04CA0078.namprd04.prod.outlook.com (2603:10b6:805:f2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Thu, 2 Apr 2020 23:29:47 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 38a722c6-ab39-4da0-d49b-08d7d75dbc1b
X-MS-TrafficTypeDiagnostic: DM5PR12MB1356:|DM5PR12MB1356:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1356EF659E595B3457291F208EC60@DM5PR12MB1356.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0361212EA8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(9686003)(66556008)(2906002)(66946007)(5660300002)(33716001)(52116002)(6862004)(7416002)(66476007)(6496006)(44832011)(55016002)(33656002)(6636002)(8936002)(16526019)(8676002)(956004)(1076003)(478600001)(81156014)(26005)(186003)(316002)(4326008)(81166006)(86362001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u1lsiqAi38oosjEfjUiiU/CpL51JrRU/f4elKYkqf35o/hyxK/Yw9DLCmhqEKmfo/RsxL7WWjUNfk+pdlBynhOxozE9PU4l9Jr4GNbknj6LaNGa/fvbRL9yRabPvB00aRzSx2wlHc0hmEMlugXPTEQ7dYL0PGdjbLRe6u7k4pDJtzsjA78N6Ow3zCku9ADlajAVo0hGP+G6t+iSNC6QsKoIzY2XmfgI2++Q03NalkExvGLLI0sPjsRAUndC0yZSdOAEhxY8x0Zw18w1k6EQr/jGQa/jYVC7Q1MmENCxGdh3yBk8frTXMg7uEo445Y9DrHqhP4D327IUSCYdjGu4eTUct1NPCBXSa8U0E5Agk0sjB2j8tnnN1uFbLIlRc7thUmqn+C/xgjF+ug0eTWq3V6oOewSSiqaI57ZmdN1g2iGpepEC9uKmbt9H7mENnA0XD
X-MS-Exchange-AntiSpam-MessageData: oPITh1aOJB82tkqIhLpGw70Ci+JZBmAt8ttcy9llGB49e4n9LiSdVy7cnjO/ef5pOuvfv0Dr0lUWZA9o9n47UzgMvdi8Pezn1CzBGZm3gXfkxamaMks4oncNnAOsvD9nloO5KKE8FPuCeSjoKEN9Hg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a722c6-ab39-4da0-d49b-08d7d75dbc1b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2020 23:29:48.6234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XhknfioN3235ehq0FRBvsjEG+xu6VfPxe3nxEAsD0DxjrdMCZ3G5J0lqQZP4ut4d4PVkYf/deBcCMtRiqNt0Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1356
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Brijesh,
> 
> On Tue, Mar 31, 2020 at 05:13:36PM +0000, Ashish Kalra wrote:
> > Hello Brijesh,
> > 
> > > > Actually this is being done somewhat lazily, after the guest
> > > > enables/activates the live migration feature, it should be fine to do it
> > > > here or it can be moved into sev_map_percpu_data() where the first
> > > > hypercalls are done, in both cases the __bss_decrypted section will be
> > > > marked before the live migration process is initiated.
> > > 
> > > 
> > > IMO, its not okay to do it here or inside sev_map_percpu_data(). So far,
> > > as soon as C-bit state is changed in page table we make a hypercall. It
> > > will be good idea to stick to that approach. I don't see any reason why
> > > we need to make an exception for the __bss_decrypted unless I am missing
> > > something. What will happen if VMM initiate the migration while guest
> > > BIOS is booting?  Are you saying its not supported ?
> > > 
> > 
> > The one thing this will require is checking for KVM para capability 
> > KVM_FEATURE_SEV_LIVE_MIGRATION as part of this code in startup_64(), i 
> > need to verify if i can check for this feature so early in startup code.
> > 
> > I need to check for this capability and do the wrmsrl() here as this
> > will be the 1st hypercall in the guest kernel and i will need to
> > enable live migration feature and hypercall support on the host
> > before making the hypercall.
> > 
 
I added the KVM para feature capability check here in startup_64(), and
as i thought this does "not" work and also as a side effect disables 
the KVM paravirtualization check and so KVM paravirtualization is not
detected later during kernel boot and all KVM paravirt features remain
disabled.
 
Digged deeper into this and here's what happens ...

kvm_para_has_feature() calls kvm_arch_para_feature() which in turn calls
kvm_cpuid_base() and this invokes __kvm_cpuid_base(). As the 
"boot_cpu_data" is still not populated/setup, therefore, 
__kvm_cpuid_base() does not detect X86_FEATURE_HYPERVISOR and
also as a side effect sets the variable kvm_cpuid_base == 0.

So as the kvm_para_feature() is not detected in startup_64(), therefore 
the hypercall does not get invoked and also as the side effect of calling
kvm_para_feature() in startup_64(), the static variable "kvm_cpuid_base"
gets set to 0, and later during hypervisor detection (kvm_detect), this
variable's setting causes kvm_detect() to return failure and hence
KVM paravirtualization features don't get enabled for the guest kernel.

So, calling kvm_para_has_feature() so early in startup_64() code is 
not going to work, hence, it is probably best to do the hypercall to mark
__bss_decrypted section as decrypted (lazily) as part of sev_map_percpu_data()
as per my original thought.

Thanks,
Ashish
