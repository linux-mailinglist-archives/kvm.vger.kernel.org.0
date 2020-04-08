Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B69651A19B6
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 03:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgDHBxC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 21:53:02 -0400
Received: from mail-mw2nam10on2079.outbound.protection.outlook.com ([40.107.94.79]:6217
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726406AbgDHBxC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 21:53:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPmiBHt3RjV3P+SgFoPG12KUgxEKuuYDA9l9bf1+VpvI+hEqTkqMrOspoIKj0zMqWhLXfvDIOjSZoxWI8KlP1Y9QbONK2dnAdMs06+6gV3fLolEzKu67rR4IKjIfunM9RhOIaWhwlLZsjPCtVfC3849bh2hIRNBMaCzMVdjZ4+Rqv0ofYx0gNZE+SGgRygNbrKoe7Xh7VA0ObNQmX62E3KCGwd/CskI9PImHOgDTSxtQHfwKZWzGHlLbmhPME6S6Chee229y2J32ClUXshi116knEsEtRPaRUiQUfPD+arKh7k47Lm+Wnbek3NFhj2R7SE58KjSb2g+ZJlWg5SE9ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8O12SHGRArPUa36GNUaIVf170QbD8DxkR5+EV1EZKQ4=;
 b=H1FkHzcrcHRVUpuvRTLPPrICtz16BH4Z9NG0L9fb4ef1i3fgIdmNRNxYC95eGMlh7RPrK/Wdqel35Vv3hmOPkdfCQXywyJrS6gsi7XxknPin59XJwPQ15dp39d4R91aAncC8Ai4KrosG/DXJXO7qwj83SoHHCVWtUEVlmGjtgMVOYxmWj7uLQHni+QCWXLocag9GzWI2xaaT/VPOeRtZa0NIIsimQ4vaj8ZtHXnph1w0ac/BjwogfnXd/s1XjLR/z4m7ssrzATFsi1w4mLe8YfpR/2wmY8u/5k27gD/LW972KPplfmLbkRP1xNtgDMVzx0TR4doccyMMNl0MHpJ3KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8O12SHGRArPUa36GNUaIVf170QbD8DxkR5+EV1EZKQ4=;
 b=SVS3YywOdezbVW1u8eqt4myIRmrzKVsodWDNNSK40TNtB5KP8eCJeWC/rij/TGHV5GUPBNd1/BA2e1P4g0BDO0BXMvPZeVGjsxaOImE8T+Q3wfJRuw9d+9sEBNwew+qL5EVzhxnITHquYfDWuSpT9LDjEv/AROfKs6IPcVltNHM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1481.namprd12.prod.outlook.com (2603:10b6:4:e::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.20; Wed, 8 Apr 2020 01:52:24 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.022; Wed, 8 Apr 2020
 01:52:24 +0000
Date:   Wed, 8 Apr 2020 01:52:21 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v6 12/14] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET
 ioctl
Message-ID: <20200408015221.GB27608@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <9e959ee134ad77f62c9881b8c54cd27e35055072.1585548051.git.ashish.kalra@amd.com>
 <b77a4a1e-b8ca-57a2-d849-adda91bfeac7@oracle.com>
 <20200403214559.GB28747@ashkalra_ubuntu_server>
 <65c09963-2027-22c1-e04d-4c8c3658b2c3@oracle.com>
 <CABayD+cf=Po-k7jqUQjq3AGopxk86d6bTcBhQxijnzpcUh90GA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+cf=Po-k7jqUQjq3AGopxk86d6bTcBhQxijnzpcUh90GA@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR21CA0052.namprd21.prod.outlook.com
 (2603:10b6:3:129::14) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR21CA0052.namprd21.prod.outlook.com (2603:10b6:3:129::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.9 via Frontend Transport; Wed, 8 Apr 2020 01:52:23 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: da63d478-5d18-4726-6e42-08d7db5f7b88
X-MS-TrafficTypeDiagnostic: DM5PR12MB1481:|DM5PR12MB1481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB14812B169444EE6C2B7E4C968EC00@DM5PR12MB1481.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(33656002)(53546011)(66946007)(66476007)(66556008)(2906002)(316002)(1076003)(478600001)(4326008)(33716001)(54906003)(9686003)(6916009)(55016002)(7416002)(81166006)(26005)(8676002)(81156014)(86362001)(5660300002)(186003)(16526019)(52116002)(44832011)(956004)(6496006)(8936002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rUiW+YAu/Czpc6N6+Qi8jeqaH+9TLhx+bokwgZVJGocEQ8eXNFkDN44qbZEGIXVkWqmh4C2QyGmBv3Xpof2UaqpFZAZtAyXhZ3UbZxfSdWQflYkNXHikm6opI6KeR7jdUwUUoCq1tnGvdp6MGBMt+en/OinZllKUqsxsX4+yw8gv2mHDYdmLvChgEsPteEvTBjH9qO0r367VTUCVw5B5iRJ+hdNi+Sstwk+n69X1wep67YfvoeJAIkLX1lPNxIUdeNksdt9EiaW+Y5aQHrHQv+OQk1+9VOLNEEC4+BaykEvt2yRdk27D/FfPSW0Tc5uLKhHqYNKB+k+yzS2w0vADtYGEwvfa8nZlY8wJZYF/vhdxDGyowzNnJPEhUR0xoNoW8OPEl3JXDU9yVD+223NXQW577civyz9iqgeTPeh65F7JOm3Cr6YwYtzQ/6V2cHOB
X-MS-Exchange-AntiSpam-MessageData: ZI6cZrLi3VAh0jqddn1U7XgzTftUNwFq0Pm4IuVqYxuC04q5a6IzqRx/5nZOE0mH3ssn9HP7+e1W5i6jsmaZpKLo1zJ/0pK7aQIeb54W42L1PQ61PsRDqjfT55Z/PbJTHhCwaZaqL4SHwsnJEy8U0w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da63d478-5d18-4726-6e42-08d7db5f7b88
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 01:52:23.9098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8AU918nwZ9eyFUTrxogmeLdTpy1sKEkxaF1LoJpj53p3EIthYi+xX5HLvGgoPn7tEgT5lxuLepR+sZ08fTsr4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1481
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Tue, Apr 07, 2020 at 06:25:51PM -0700, Steve Rutherford wrote:
> On Mon, Apr 6, 2020 at 11:53 AM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
> >
> >
> > On 4/3/20 2:45 PM, Ashish Kalra wrote:
> > > On Fri, Apr 03, 2020 at 02:14:23PM -0700, Krish Sadhukhan wrote:
> > >> On 3/29/20 11:23 PM, Ashish Kalra wrote:
> > >>> From: Ashish Kalra <ashish.kalra@amd.com>
> > >>>
> > >>> This ioctl can be used by the application to reset the page
> > >>> encryption bitmap managed by the KVM driver. A typical usage
> > >>> for this ioctl is on VM reboot, on reboot, we must reinitialize
> > >>> the bitmap.
> > >>>
> > >>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > >>> ---
> > >>>    Documentation/virt/kvm/api.rst  | 13 +++++++++++++
> > >>>    arch/x86/include/asm/kvm_host.h |  1 +
> > >>>    arch/x86/kvm/svm.c              | 16 ++++++++++++++++
> > >>>    arch/x86/kvm/x86.c              |  6 ++++++
> > >>>    include/uapi/linux/kvm.h        |  1 +
> > >>>    5 files changed, 37 insertions(+)
> > >>>
> > >>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > >>> index 4d1004a154f6..a11326ccc51d 100644
> > >>> --- a/Documentation/virt/kvm/api.rst
> > >>> +++ b/Documentation/virt/kvm/api.rst
> > >>> @@ -4698,6 +4698,19 @@ During the guest live migration the outgoing guest exports its page encryption
> > >>>    bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
> > >>>    bitmap for an incoming guest.
> > >>> +4.127 KVM_PAGE_ENC_BITMAP_RESET (vm ioctl)
> > >>> +-----------------------------------------
> > >>> +
> > >>> +:Capability: basic
> > >>> +:Architectures: x86
> > >>> +:Type: vm ioctl
> > >>> +:Parameters: none
> > >>> +:Returns: 0 on success, -1 on error
> > >>> +
> > >>> +The KVM_PAGE_ENC_BITMAP_RESET is used to reset the guest's page encryption
> > >>> +bitmap during guest reboot and this is only done on the guest's boot vCPU.
> > >>> +
> > >>> +
> > >>>    5. The kvm_run structure
> > >>>    ========================
> > >>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > >>> index d30f770aaaea..a96ef6338cd2 100644
> > >>> --- a/arch/x86/include/asm/kvm_host.h
> > >>> +++ b/arch/x86/include/asm/kvm_host.h
> > >>> @@ -1273,6 +1273,7 @@ struct kvm_x86_ops {
> > >>>                             struct kvm_page_enc_bitmap *bmap);
> > >>>     int (*set_page_enc_bitmap)(struct kvm *kvm,
> > >>>                             struct kvm_page_enc_bitmap *bmap);
> > >>> +   int (*reset_page_enc_bitmap)(struct kvm *kvm);
> > >>>    };
> > >>>    struct kvm_arch_async_pf {
> > >>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > >>> index 313343a43045..c99b0207a443 100644
> > >>> --- a/arch/x86/kvm/svm.c
> > >>> +++ b/arch/x86/kvm/svm.c
> > >>> @@ -7797,6 +7797,21 @@ static int svm_set_page_enc_bitmap(struct kvm *kvm,
> > >>>     return ret;
> > >>>    }
> > >>> +static int svm_reset_page_enc_bitmap(struct kvm *kvm)
> > >>> +{
> > >>> +   struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > >>> +
> > >>> +   if (!sev_guest(kvm))
> > >>> +           return -ENOTTY;
> > >>> +
> > >>> +   mutex_lock(&kvm->lock);
> > >>> +   /* by default all pages should be marked encrypted */
> > >>> +   if (sev->page_enc_bmap_size)
> > >>> +           bitmap_fill(sev->page_enc_bmap, sev->page_enc_bmap_size);
> > >>> +   mutex_unlock(&kvm->lock);
> > >>> +   return 0;
> > >>> +}
> > >>> +
> > >>>    static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> > >>>    {
> > >>>     struct kvm_sev_cmd sev_cmd;
> > >>> @@ -8203,6 +8218,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> > >>>     .page_enc_status_hc = svm_page_enc_status_hc,
> > >>>     .get_page_enc_bitmap = svm_get_page_enc_bitmap,
> > >>>     .set_page_enc_bitmap = svm_set_page_enc_bitmap,
> > >>> +   .reset_page_enc_bitmap = svm_reset_page_enc_bitmap,
> > >>
> > >> We don't need to initialize the intel ops to NULL ? It's not initialized in
> > >> the previous patch either.
> > >>
> > >>>    };
> > > This struct is declared as "static storage", so won't the non-initialized
> > > members be 0 ?
> >
> >
> > Correct. Although, I see that 'nested_enable_evmcs' is explicitly
> > initialized. We should maintain the convention, perhaps.
> >
> > >
> > >>>    static int __init svm_init(void)
> > >>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > >>> index 05e953b2ec61..2127ed937f53 100644
> > >>> --- a/arch/x86/kvm/x86.c
> > >>> +++ b/arch/x86/kvm/x86.c
> > >>> @@ -5250,6 +5250,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
> > >>>                     r = kvm_x86_ops->set_page_enc_bitmap(kvm, &bitmap);
> > >>>             break;
> > >>>     }
> > >>> +   case KVM_PAGE_ENC_BITMAP_RESET: {
> > >>> +           r = -ENOTTY;
> > >>> +           if (kvm_x86_ops->reset_page_enc_bitmap)
> > >>> +                   r = kvm_x86_ops->reset_page_enc_bitmap(kvm);
> > >>> +           break;
> > >>> +   }
> > >>>     default:
> > >>>             r = -ENOTTY;
> > >>>     }
> > >>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > >>> index b4b01d47e568..0884a581fc37 100644
> > >>> --- a/include/uapi/linux/kvm.h
> > >>> +++ b/include/uapi/linux/kvm.h
> > >>> @@ -1490,6 +1490,7 @@ struct kvm_enc_region {
> > >>>    #define KVM_GET_PAGE_ENC_BITMAP  _IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
> > >>>    #define KVM_SET_PAGE_ENC_BITMAP  _IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
> > >>> +#define KVM_PAGE_ENC_BITMAP_RESET  _IO(KVMIO, 0xc7)
> > >>>    /* Secure Encrypted Virtualization command */
> > >>>    enum sev_cmd_id {
> > >> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> 
> 
> Doesn't this overlap with the set ioctl? Yes, obviously, you have to
> copy the new value down and do a bit more work, but I don't think
> resetting the bitmap is going to be the bottleneck on reboot. Seems
> excessive to add another ioctl for this.

The set ioctl is generally available/provided for the incoming VM to setup
the page encryption bitmap, this reset ioctl is meant for the source VM
as a simple interface to reset the whole page encryption bitmap.

Thanks,
Ashish
