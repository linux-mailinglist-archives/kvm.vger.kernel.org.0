Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 876491A4CF6
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 02:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgDKAfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 20:35:30 -0400
Received: from mail-bn8nam11on2089.outbound.protection.outlook.com ([40.107.236.89]:6209
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726735AbgDKAfa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 20:35:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2FbYJ5vhWdWXTz2kbKfbFM+WZIY6fVHczd7F6ZNlnwOaG2DkkHZ98cHjWiJKl1DkY/2BJtlruLWS/u5tFjrB/SurHIZ1JWT9Fate9XI5vhq8p5a2DHB84L3nkDg2rV4gBWmGqOV+G0Ug/coyjhmh1nzfCarsWWk1PfBv83BaZMSVicrm6kqGpnWiKFSInU2pjDxFo1nU2c3Li00CkSdkfCCRqyogALfpt3WQqrQoloon65oJbT+yp/t3oTyu0pkn5jx/P4OJ+c9jz1id7vxRGH50JkEdFdD32lSB21HGv5gDzfY5AB+FCU+lREZ4erGwVRMQ0AH1bVvsbhR8I3jzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VI2nWEqCR1NdmbE3W6tlPZhu/aJgoWyJCHklRfuQsSM=;
 b=nBFdULS/ds6lFqlmmDnLICZ60+5jzI5jrGcQMY1vD8Cr6yCb4nJgL3K9364QSOxd0PUoN/uU03H/Y5Lka/qBhiJeLKGClKxrtLugnyr+dJfyvJXeNST/1Dnkd2hDfue76V0vEljzTk+N8Kju2JoVeWz+wOkZYud6NYRcjXypML1s8KFIFYD5FiAniyGLAcD+v2OhST6owWm6rMYDePpRIumdR9iUwtjNd/6Vi04+Dnlj1fTn5jt8vdSGqNd1ZWB6IXs9cMdiFCrdnQaD9z52qXUm+GLVXCk6iXIalIrqHEgupinNp4rsKrVDz7hcXIn8oMylg5OEC3IJGqXpWLTvqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VI2nWEqCR1NdmbE3W6tlPZhu/aJgoWyJCHklRfuQsSM=;
 b=guNzXEeubE8zbeFaV346GJxAAz066Ay6w5bT5hIsXOJBtXvGQzA5bYlbT35BkbKKFR1sLTgIIePRF6qCCD8ZkIcoaNrdqT5xUr67GKM8YC3fNq5Z7HhQUPszOzKQgS3pnLOwNtzRxWLVfP5P0KTTO5tWVN3RhlqZz5sgLglVbyo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2469.namprd12.prod.outlook.com (2603:10b6:4:af::38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.17; Sat, 11 Apr 2020 00:35:26 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.022; Sat, 11 Apr 2020
 00:35:26 +0000
Date:   Sat, 11 Apr 2020 00:35:20 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Steve Rutherford <srutherford@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v6 12/14] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET
 ioctl
Message-ID: <20200411003520.GA20760@ashkalra_ubuntu_server>
References: <65c09963-2027-22c1-e04d-4c8c3658b2c3@oracle.com>
 <CABayD+cf=Po-k7jqUQjq3AGopxk86d6bTcBhQxijnzpcUh90GA@mail.gmail.com>
 <20200408015221.GB27608@ashkalra_ubuntu_server>
 <CABayD+f0qdS5akac8JiB_HU_pWefHDsF=xRNhzSv42w-PTXnyg@mail.gmail.com>
 <20200410013418.GB19168@ashkalra_ubuntu_server>
 <CABayD+dDtjz7rJe1ujQ_sq88JRUzHaXXNP_hQVhD1vkXkPsXCw@mail.gmail.com>
 <CABayD+dwJeu+o+TG843XX1nWHWMz=iwW0uWBKPaG0uJEsxCYGw@mail.gmail.com>
 <CABayD+cuHv6chBT5wWHqaZWXSHaOtaOQyBrxgRj2Y=q_fOheuA@mail.gmail.com>
 <DM5PR12MB1386C01E72A71F3AB6EB1F068EDE0@DM5PR12MB1386.namprd12.prod.outlook.com>
 <984e3ba6-ec8e-d331-92b3-7984d90aa516@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <984e3ba6-ec8e-d331-92b3-7984d90aa516@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR20CA0018.namprd20.prod.outlook.com
 (2603:10b6:3:93::28) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR20CA0018.namprd20.prod.outlook.com (2603:10b6:3:93::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.16 via Frontend Transport; Sat, 11 Apr 2020 00:35:24 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8d21e07c-085f-4d03-f9b1-08d7ddb03a2e
X-MS-TrafficTypeDiagnostic: DM5PR12MB2469:|DM5PR12MB2469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2469225D662EAFA83745AD3E8EDF0@DM5PR12MB2469.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-Forefront-PRVS: 03706074BC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(86362001)(66946007)(8936002)(53546011)(52116002)(55016002)(6496006)(316002)(2906002)(33656002)(30864003)(54906003)(33716001)(956004)(9686003)(6666004)(1076003)(7416002)(6636002)(478600001)(26005)(8676002)(186003)(6862004)(44832011)(81156014)(66476007)(4326008)(66556008)(5660300002)(16526019);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rXfH6S4BoHZFG5z7QuJrj+Cr7K6U1NqJKQnPQbGtR6qqQZHVK4gc57sauBZ7A3GDFz5wrrynBivyATFL16XEpx8RjyqwGeqT3nDMphxraJD8J2oF8uNmt7uJ3X9XIq4qPvYT2r2M6uMF09COT2C7Y8E/zZOZ2AcXnsMtk+sJshkODWgiH+HAvmSBu8cciRb+IlUUMaTL5hdeUxLzOXVfTj/euor8L4ukYsEjCtgkpkMq8QABKG1vmVLXStyr4sUtv3gT9N3JY39RMYSRY+rffv3Km5Ik0+35F8eyJI3HIPcTJzD8rk6ePl4GZAiiq5MXGS9fZWzC4bgwAsQ9noXHZ0jIgVxIAS1CHHxPVWS/5ctjQoZWyo5nz8faXD+ocjzSYz9ND/Bb570H+qUDCiSJer9mXAAEZ0kWq6fbv9AJyISgPIC6ZdmiYuGWS4KqtRhD
X-MS-Exchange-AntiSpam-MessageData: w5rpg/K/X7XhOyut1I7n469ATEqhNCE1ZNxJPAbb6ORhY/mgDQD9ivlCYF26L/ttppRdIbpwJ3ehDckno12PRLGotAvd2Y+BH2hUoV0u+Xo/vn7Z2Pa8/8qtw/2fPZ2pxLIkCaRdougTQQbRwKq4IA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d21e07c-085f-4d03-f9b1-08d7ddb03a2e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2020 00:35:26.0082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZYDzH6GXgGThl6nUA97sO1tNaKFlJpMx5ZU4ZuKQrYAMZFSDr9FtamlDZt1y4A8E4v2wpgfdiTbfcj8TOFjqzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2469
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Brijesh,

On Fri, Apr 10, 2020 at 05:02:46PM -0500, Brijesh Singh wrote:
> resend with internal distribution tag removed.
> 
> 
> On 4/10/20 3:55 PM, Kalra, Ashish wrote:
> [snip]
> ..
> >
> > Hello Steve,
> >
> > -----Original Message-----
> > From: Steve Rutherford <srutherford@google.com> 
> > Sent: Friday, April 10, 2020 3:19 PM
> > To: Kalra, Ashish <Ashish.Kalra@amd.com>
> > Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>; Paolo Bonzini <pbonzini@redhat.com>; Thomas Gleixner <tglx@linutronix.de>; Ingo Molnar <mingo@redhat.com>; H. Peter Anvin <hpa@zytor.com>; Joerg Roedel <joro@8bytes.org>; Borislav Petkov <bp@suse.de>; Lendacky, Thomas <Thomas.Lendacky@amd.com>; X86 ML <x86@kernel.org>; KVM list <kvm@vger.kernel.org>; LKML <linux-kernel@vger.kernel.org>; David Rientjes <rientjes@google.com>; Andy Lutomirski <luto@kernel.org>; Singh, Brijesh <brijesh.singh@amd.com>
> > Subject: Re: [PATCH v6 12/14] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET ioctl
> >
> > On Fri, Apr 10, 2020 at 1:16 PM Steve Rutherford <srutherford@google.com> wrote:
> >> On Fri, Apr 10, 2020 at 11:14 AM Steve Rutherford 
> >> <srutherford@google.com> wrote:
> >>> On Thu, Apr 9, 2020 at 6:34 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >>>> Hello Steve,
> >>>>
> >>>> On Thu, Apr 09, 2020 at 05:59:56PM -0700, Steve Rutherford wrote:
> >>>>> On Tue, Apr 7, 2020 at 6:52 PM Ashish Kalra <ashish.kalra@amd.com> wrote:
> >>>>>> Hello Steve,
> >>>>>>
> >>>>>> On Tue, Apr 07, 2020 at 06:25:51PM -0700, Steve Rutherford wrote:
> >>>>>>> On Mon, Apr 6, 2020 at 11:53 AM Krish Sadhukhan 
> >>>>>>> <krish.sadhukhan@oracle.com> wrote:
> >>>>>>>>
> >>>>>>>> On 4/3/20 2:45 PM, Ashish Kalra wrote:
> >>>>>>>>> On Fri, Apr 03, 2020 at 02:14:23PM -0700, Krish Sadhukhan wrote:
> >>>>>>>>>> On 3/29/20 11:23 PM, Ashish Kalra wrote:
> >>>>>>>>>>> From: Ashish Kalra <ashish.kalra@amd.com>
> >>>>>>>>>>>
> >>>>>>>>>>> This ioctl can be used by the application to reset the 
> >>>>>>>>>>> page encryption bitmap managed by the KVM driver. A 
> >>>>>>>>>>> typical usage for this ioctl is on VM reboot, on 
> >>>>>>>>>>> reboot, we must reinitialize the bitmap.
> >>>>>>>>>>>
> >>>>>>>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> >>>>>>>>>>> ---
> >>>>>>>>>>>    Documentation/virt/kvm/api.rst  | 13 +++++++++++++
> >>>>>>>>>>>    arch/x86/include/asm/kvm_host.h |  1 +
> >>>>>>>>>>>    arch/x86/kvm/svm.c              | 16 ++++++++++++++++
> >>>>>>>>>>>    arch/x86/kvm/x86.c              |  6 ++++++
> >>>>>>>>>>>    include/uapi/linux/kvm.h        |  1 +
> >>>>>>>>>>>    5 files changed, 37 insertions(+)
> >>>>>>>>>>>
> >>>>>>>>>>> diff --git a/Documentation/virt/kvm/api.rst 
> >>>>>>>>>>> b/Documentation/virt/kvm/api.rst index 
> >>>>>>>>>>> 4d1004a154f6..a11326ccc51d 100644
> >>>>>>>>>>> --- a/Documentation/virt/kvm/api.rst
> >>>>>>>>>>> +++ b/Documentation/virt/kvm/api.rst
> >>>>>>>>>>> @@ -4698,6 +4698,19 @@ During the guest live migration the outgoing guest exports its page encryption
> >>>>>>>>>>>    bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
> >>>>>>>>>>>    bitmap for an incoming guest.
> >>>>>>>>>>> +4.127 KVM_PAGE_ENC_BITMAP_RESET (vm ioctl)
> >>>>>>>>>>> +-----------------------------------------
> >>>>>>>>>>> +
> >>>>>>>>>>> +:Capability: basic
> >>>>>>>>>>> +:Architectures: x86
> >>>>>>>>>>> +:Type: vm ioctl
> >>>>>>>>>>> +:Parameters: none
> >>>>>>>>>>> +:Returns: 0 on success, -1 on error
> >>>>>>>>>>> +
> >>>>>>>>>>> +The KVM_PAGE_ENC_BITMAP_RESET is used to reset the 
> >>>>>>>>>>> +guest's page encryption bitmap during guest reboot and this is only done on the guest's boot vCPU.
> >>>>>>>>>>> +
> >>>>>>>>>>> +
> >>>>>>>>>>>    5. The kvm_run structure
> >>>>>>>>>>>    ======================== diff --git 
> >>>>>>>>>>> a/arch/x86/include/asm/kvm_host.h 
> >>>>>>>>>>> b/arch/x86/include/asm/kvm_host.h index 
> >>>>>>>>>>> d30f770aaaea..a96ef6338cd2 100644
> >>>>>>>>>>> --- a/arch/x86/include/asm/kvm_host.h
> >>>>>>>>>>> +++ b/arch/x86/include/asm/kvm_host.h
> >>>>>>>>>>> @@ -1273,6 +1273,7 @@ struct kvm_x86_ops {
> >>>>>>>>>>>                             struct kvm_page_enc_bitmap *bmap);
> >>>>>>>>>>>     int (*set_page_enc_bitmap)(struct kvm *kvm,
> >>>>>>>>>>>                             struct kvm_page_enc_bitmap 
> >>>>>>>>>>> *bmap);
> >>>>>>>>>>> +   int (*reset_page_enc_bitmap)(struct kvm *kvm);
> >>>>>>>>>>>    };
> >>>>>>>>>>>    struct kvm_arch_async_pf { diff --git 
> >>>>>>>>>>> a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c index 
> >>>>>>>>>>> 313343a43045..c99b0207a443 100644
> >>>>>>>>>>> --- a/arch/x86/kvm/svm.c
> >>>>>>>>>>> +++ b/arch/x86/kvm/svm.c
> >>>>>>>>>>> @@ -7797,6 +7797,21 @@ static int svm_set_page_enc_bitmap(struct kvm *kvm,
> >>>>>>>>>>>     return ret;
> >>>>>>>>>>>    }
> >>>>>>>>>>> +static int svm_reset_page_enc_bitmap(struct kvm *kvm) 
> >>>>>>>>>>> +{
> >>>>>>>>>>> +   struct kvm_sev_info *sev = 
> >>>>>>>>>>> +&to_kvm_svm(kvm)->sev_info;
> >>>>>>>>>>> +
> >>>>>>>>>>> +   if (!sev_guest(kvm))
> >>>>>>>>>>> +           return -ENOTTY;
> >>>>>>>>>>> +
> >>>>>>>>>>> +   mutex_lock(&kvm->lock);
> >>>>>>>>>>> +   /* by default all pages should be marked encrypted */
> >>>>>>>>>>> +   if (sev->page_enc_bmap_size)
> >>>>>>>>>>> +           bitmap_fill(sev->page_enc_bmap, sev->page_enc_bmap_size);
> >>>>>>>>>>> +   mutex_unlock(&kvm->lock);
> >>>>>>>>>>> +   return 0;
> >>>>>>>>>>> +}
> >>>>>>>>>>> +
> >>>>>>>>>>>    static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >>>>>>>>>>>    {
> >>>>>>>>>>>     struct kvm_sev_cmd sev_cmd; @@ -8203,6 +8218,7 @@ 
> >>>>>>>>>>> static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> >>>>>>>>>>>     .page_enc_status_hc = svm_page_enc_status_hc,
> >>>>>>>>>>>     .get_page_enc_bitmap = svm_get_page_enc_bitmap,
> >>>>>>>>>>>     .set_page_enc_bitmap = svm_set_page_enc_bitmap,
> >>>>>>>>>>> +   .reset_page_enc_bitmap = 
> >>>>>>>>>>> + svm_reset_page_enc_bitmap,
> >>>>>>>>>> We don't need to initialize the intel ops to NULL ? 
> >>>>>>>>>> It's not initialized in the previous patch either.
> >>>>>>>>>>
> >>>>>>>>>>>    };
> >>>>>>>>> This struct is declared as "static storage", so won't 
> >>>>>>>>> the non-initialized members be 0 ?
> >>>>>>>>
> >>>>>>>> Correct. Although, I see that 'nested_enable_evmcs' is 
> >>>>>>>> explicitly initialized. We should maintain the convention, perhaps.
> >>>>>>>>
> >>>>>>>>>>>    static int __init svm_init(void) diff --git 
> >>>>>>>>>>> a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index 
> >>>>>>>>>>> 05e953b2ec61..2127ed937f53 100644
> >>>>>>>>>>> --- a/arch/x86/kvm/x86.c
> >>>>>>>>>>> +++ b/arch/x86/kvm/x86.c
> >>>>>>>>>>> @@ -5250,6 +5250,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >>>>>>>>>>>                     r = kvm_x86_ops->set_page_enc_bitmap(kvm, &bitmap);
> >>>>>>>>>>>             break;
> >>>>>>>>>>>     }
> >>>>>>>>>>> +   case KVM_PAGE_ENC_BITMAP_RESET: {
> >>>>>>>>>>> +           r = -ENOTTY;
> >>>>>>>>>>> +           if (kvm_x86_ops->reset_page_enc_bitmap)
> >>>>>>>>>>> +                   r = kvm_x86_ops->reset_page_enc_bitmap(kvm);
> >>>>>>>>>>> +           break;
> >>>>>>>>>>> +   }
> >>>>>>>>>>>     default:
> >>>>>>>>>>>             r = -ENOTTY;
> >>>>>>>>>>>     }
> >>>>>>>>>>> diff --git a/include/uapi/linux/kvm.h 
> >>>>>>>>>>> b/include/uapi/linux/kvm.h index 
> >>>>>>>>>>> b4b01d47e568..0884a581fc37 100644
> >>>>>>>>>>> --- a/include/uapi/linux/kvm.h
> >>>>>>>>>>> +++ b/include/uapi/linux/kvm.h
> >>>>>>>>>>> @@ -1490,6 +1490,7 @@ struct kvm_enc_region {
> >>>>>>>>>>>    #define KVM_GET_PAGE_ENC_BITMAP  _IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
> >>>>>>>>>>>    #define KVM_SET_PAGE_ENC_BITMAP  _IOW(KVMIO, 0xc6, 
> >>>>>>>>>>> struct kvm_page_enc_bitmap)
> >>>>>>>>>>> +#define KVM_PAGE_ENC_BITMAP_RESET  _IO(KVMIO, 0xc7)
> >>>>>>>>>>>    /* Secure Encrypted Virtualization command */
> >>>>>>>>>>>    enum sev_cmd_id {
> >>>>>>>>>> Reviewed-by: Krish Sadhukhan 
> >>>>>>>>>> <krish.sadhukhan@oracle.com>
> >>>>>>>
> >>>>>>> Doesn't this overlap with the set ioctl? Yes, obviously, you 
> >>>>>>> have to copy the new value down and do a bit more work, but 
> >>>>>>> I don't think resetting the bitmap is going to be the 
> >>>>>>> bottleneck on reboot. Seems excessive to add another ioctl for this.
> >>>>>> The set ioctl is generally available/provided for the incoming 
> >>>>>> VM to setup the page encryption bitmap, this reset ioctl is 
> >>>>>> meant for the source VM as a simple interface to reset the whole page encryption bitmap.
> >>>>>>
> >>>>>> Thanks,
> >>>>>> Ashish
> >>>>>
> >>>>> Hey Ashish,
> >>>>>
> >>>>> These seem very overlapping. I think this API should be refactored a bit.
> >>>>>
> >>>>> 1) Use kvm_vm_ioctl_enable_cap to control whether or not this 
> >>>>> hypercall (and related feature bit) is offered to the VM, and 
> >>>>> also the size of the buffer.
> >>>> If you look at patch 13/14, i have added a new kvm para feature 
> >>>> called "KVM_FEATURE_SEV_LIVE_MIGRATION" which indicates host 
> >>>> support for SEV Live Migration and a new Custom MSR which the 
> >>>> guest does a wrmsr to enable the Live Migration feature, so this 
> >>>> is like the enable cap support.
> >>>>
> >>>> There are further extensions to this support i am adding, so patch 
> >>>> 13/14 of this patch-set is still being enhanced and will have full 
> >>>> support when i repost next.
> >>>>
> >>>>> 2) Use set for manipulating values in the bitmap, including 
> >>>>> resetting the bitmap. Set the bitmap pointer to null if you want 
> >>>>> to reset to all 0xFFs. When the bitmap pointer is set, it should 
> >>>>> set the values to exactly what is pointed at, instead of only 
> >>>>> clearing bits, as is done currently.
> >>>> As i mentioned in my earlier email, the set api is supposed to be 
> >>>> for the incoming VM, but if you really need to use it for the 
> >>>> outgoing VM then it can be modified.
> >>>>
> >>>>> 3) Use get for fetching values from the kernel. Personally, I'd 
> >>>>> require alignment of the base GFN to a multiple of 8 (but the 
> >>>>> number of pages could be whatever), so you can just use a 
> >>>>> memcpy. Optionally, you may want some way to tell userspace the 
> >>>>> size of the existing buffer, so it can ensure that it can ask 
> >>>>> for the entire buffer without having to track the size in 
> >>>>> usermode (not strictly necessary, but nice to have since it 
> >>>>> ensures that there is only one place that has to manage this value).
> >>>>>
> >>>>> If you want to expand or contract the bitmap, you can use enable 
> >>>>> cap to adjust the size.
> >>>> As being discussed on the earlier mail thread, we are doing this 
> >>>> dynamically now by computing the guest RAM size when the 
> >>>> set_user_memory_region ioctl is invoked. I believe that should 
> >>>> handle the hot-plug and hot-unplug events too, as any hot memory 
> >>>> updates will need KVM memslots to be updated.
> >>> Ahh, sorry, forgot you mentioned this: yes this can work. Host needs 
> >>> to be able to decide not to allocate, but this should be workable.
> >>>>> If you don't want to offer the hypercall to the guest, don't 
> >>>>> call the enable cap.
> >>>>> This API avoids using up another ioctl. Ioctl space is somewhat 
> >>>>> scarce. It also gives userspace fine grained control over the 
> >>>>> buffer, so it can support both hot-plug and hot-unplug (or at 
> >>>>> the very least it is not obviously incompatible with those). It 
> >>>>> also gives userspace control over whether or not the feature is 
> >>>>> offered. The hypercall isn't free, and being able to tell guests 
> >>>>> to not call when the host wasn't going to migrate it anyway will be useful.
> >>>>>
> >>>> As i mentioned above, now the host indicates if it supports the 
> >>>> Live Migration feature and the feature and the hypercall are only 
> >>>> enabled on the host when the guest checks for this support and 
> >>>> does a wrmsr() to enable the feature. Also the guest will not make 
> >>>> the hypercall if the host does not indicate support for it.
> >>> If my read of those patches was correct, the host will always 
> >>> advertise support for the hypercall. And the only bit controlling 
> >>> whether or not the hypercall is advertised is essentially the kernel 
> >>> version. You need to rollout a new kernel to disable the hypercall.
> >> Ahh, awesome, I see I misunderstood how the CPUID bits get passed
> >> through: usermode can still override them. Forgot about the back and 
> >> forth for CPUID with usermode. My point about informing the guest 
> >> kernel is clearly moot. The host still needs the ability to prevent 
> >> allocations, but that is more minor. Maybe use a flag on the memslots 
> >> directly?
> >> On second thought: burning the memslot flag for 30mb per tb of VM seems like a waste.
> > Currently, I am still using the approach of a "unified" page encryption bitmap instead of a 
> > bitmap per memslot, with the main change being that the resizing is only done whenever
> > there are any updates in memslots, when memslots are updated using the
> > kvm_arch_commit_memory_region() interface.  
> 
> 
> Just a note, I believe kvm_arch_commit_memory_region() maybe getting
> called every time there is a change in the memory region (e.g add,
> update, delete etc). So your architecture specific hook now need to be
> well aware of all those changes and act accordingly. This basically
> means that the svm.c will probably need to understand all those memory
> slot flags etc. IMO, having a separate ioctl to hint the size makes more
> sense if you are doing a unified bitmap but if the bitmap is per memslot
> then calculating the size based on the memslot information makes more sense.
> 

If instead of unified bitmap, i use a bitmap per memslot approach, even
then the svm/sev code will still need to to have knowledge of memslot flags
etc., that information will be required as svm/sev code will be
responsible for syncing the page encryption bitmap to userspace and not
the generic KVM x86 code which gets invoked for the dirty page bitmap sync.

Currently, the architecture hooks need to be aware of
KVM_MR_ADD/KVM_MR_DELETE flags and the resize will only happen
if the highest guest PA that is mapped by a memslot gets modified,
otherwise, typically, there will mainly one resize at the initial guest
launch.

Thanks,
Ashish
