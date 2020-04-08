Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D813D1A19B4
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 03:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgDHBtC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Apr 2020 21:49:02 -0400
Received: from mail-mw2nam10on2067.outbound.protection.outlook.com ([40.107.94.67]:3552
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726406AbgDHBtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Apr 2020 21:49:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JC2SLhUGhVVa+rrToRW0p4Fv5Zat1+aDv8Vzb52z6VpKxK03yfgXeVYia6FIZ23eBtb2F2tbuvf0ZoEyxcruODXMQF3/lezUtuLEaPt3tgPHmj9jySLHRVoB01mMsVuXrvbvFVhlVqB9oBED3mnWC0vAiDB3DwUlTm4QzL+QctY661MlxozVhqX7iIBOt+oGpIu4O7Q89obi1GOy53tNDRNxYBDFf6nD/BBDBKj96fR6fZTTOamtd54ErJ85UUWVLxsBsnReyWklfmcxPpLIdxjB8Vggwahuudu0rImXov3XBG6riY6x2Ywbhes+0AnpVe31UMg8rC817ddTVkscNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7gJVccucub9vVqme0NC+HSZ6MsURWDxnQQIe8K+SZY=;
 b=FLYiP7HvUpuSwNnlwhYi/Kw91IlmXduHJvQN+1li0BE0UZ//XUD4c+ILiYjkJoZ4WIcqxp7JsVDTv5VGZp4PolIFkCZL29lEBP8UMg4e9SNH3GrzpX/DBff43bP/zITuScRb4h797XO4B5uMKNlrmFbN+kKeIzFwXu2YjLrIkkecChfBlNLbcW6bskWtl+NI5g+9RjU9CZcG6+yXdVmWgD4YYGwJ59pQRELRyUEYcUWIth6RcMfXv3f2DrkmDiDSSi9dyYRtgfwVEGn44Lhfl9Ay85j+oCM72WTloalBnn8KwgSUz+Fa//7sVJMpbNPSK+XdtYwIQnyScPhLChbsXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7gJVccucub9vVqme0NC+HSZ6MsURWDxnQQIe8K+SZY=;
 b=0h5/QRKNgSSlC5mk7wtxDT9C+QTShAo9LHqhrhQYnegQcPwCkVZPoKEGpeh+ybhPiOsmcNzyCMAIbdpBtCBjFo2ZXG8UGD0vzFaWrgK5GtLs+KDtMUFiWY1L+JlnCmpgZvM925kFngKW1g2gncguSLblP076EG/MxDugFTLa/iA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1481.namprd12.prod.outlook.com (2603:10b6:4:e::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.20; Wed, 8 Apr 2020 01:48:58 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.022; Wed, 8 Apr 2020
 01:48:58 +0000
Date:   Wed, 8 Apr 2020 01:48:52 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [PATCH v6 11/14] KVM: x86: Introduce KVM_SET_PAGE_ENC_BITMAP
 ioctl
Message-ID: <20200408014852.GA27608@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <4d4fbe2b9acda82c04834682900acf782182ec23.1585548051.git.ashish.kalra@amd.com>
 <CABayD+eOCpTGjvxwhtP85j98BKvCxtG8QDBYSC0E08GnaA12jw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABayD+eOCpTGjvxwhtP85j98BKvCxtG8QDBYSC0E08GnaA12jw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR16CA0020.namprd16.prod.outlook.com
 (2603:10b6:3:c0::30) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR16CA0020.namprd16.prod.outlook.com (2603:10b6:3:c0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Wed, 8 Apr 2020 01:48:56 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6833266f-c311-4202-a3a0-08d7db5f0094
X-MS-TrafficTypeDiagnostic: DM5PR12MB1481:|DM5PR12MB1481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1481A87CE202F0E44DF023B38EC00@DM5PR12MB1481.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(33656002)(53546011)(66946007)(66476007)(66556008)(2906002)(316002)(1076003)(478600001)(4326008)(33716001)(54906003)(66574012)(9686003)(6916009)(55016002)(7416002)(81166006)(26005)(8676002)(81156014)(86362001)(5660300002)(6666004)(186003)(16526019)(52116002)(44832011)(956004)(6496006)(8936002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sgjpl1jv/A1Z6UElf8TMfxvL541ggsttOGoHS15g2ebPR03k9Mq9L/2kkgrjiQxWzKcPmL8s0A9H1/zkhuArojuquFic0Tph5jArM+v0iR0FflY3VJERgbdB4DguCZZMUpTh60xdcmG6XC5E3IfTjAGeeyt70V8zabaXsGzUBJxl7xnrqiSKcZZUqnCrOTw8GWqLyRDxZdTFdNsHHh0LSIdr+SRou0RlPSg/42KmYXfMlUtQHFpPKFeu1fct5armSfuel5gxVbjY8k0CWMYCgoN23ABYXEmrRsemjpxn7fkUOUkUN22EYoQP79susuIPW7o2oUhTlyIu4f1Saj4ietzwyzw7JC0rw5KfOvzs2KyJ5t51+L76M1KgGWRgqrcaGvQI5zRaQB9GdWzAyPfRLEHlgcloYodEZSExD+rjHrBoJa24WITE065s1PKtke7x
X-MS-Exchange-AntiSpam-MessageData: uj3YFNntc8LClCN6rTFr1WuJp8CeFvVqfhlcNIdC6KuzBELICRYdlVG0fRMdxY5/sJ/NHb2D+q/BYe/jsiY2EsiBoUutTkxImFI5UTXr9YNqqfRqtKye6en0tLcqzj9jKCw3Kl7qLlkPuE1nD4XCjA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6833266f-c311-4202-a3a0-08d7db5f0094
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 01:48:57.6530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sLDWH77Obs2NUHDdaUJmCAWMO/TcSd6NvHkgaiqsaCXG52UGf+Ynxn+qc+GP0+dxWnWinW113vZPfRiYJxZUlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1481
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Steve,

On Tue, Apr 07, 2020 at 05:26:33PM -0700, Steve Rutherford wrote:
> On Sun, Mar 29, 2020 at 11:23 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
> >
> > From: Brijesh Singh <Brijesh.Singh@amd.com>
> >
> > The ioctl can be used to set page encryption bitmap for an
> > incoming guest.
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: x86@kernel.org
> > Cc: kvm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >  Documentation/virt/kvm/api.rst  | 22 +++++++++++++++++
> >  arch/x86/include/asm/kvm_host.h |  2 ++
> >  arch/x86/kvm/svm.c              | 42 +++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/x86.c              | 12 ++++++++++
> >  include/uapi/linux/kvm.h        |  1 +
> >  5 files changed, 79 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 8ad800ebb54f..4d1004a154f6 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -4675,6 +4675,28 @@ or shared. The bitmap can be used during the guest migration, if the page
> >  is private then userspace need to use SEV migration commands to transmit
> >  the page.
> >
> > +4.126 KVM_SET_PAGE_ENC_BITMAP (vm ioctl)
> > +---------------------------------------
> > +
> > +:Capability: basic
> > +:Architectures: x86
> > +:Type: vm ioctl
> > +:Parameters: struct kvm_page_enc_bitmap (in/out)
> > +:Returns: 0 on success, -1 on error
> > +
> > +/* for KVM_SET_PAGE_ENC_BITMAP */
> > +struct kvm_page_enc_bitmap {
> > +       __u64 start_gfn;
> > +       __u64 num_pages;
> > +       union {
> > +               void __user *enc_bitmap; /* one bit per page */
> > +               __u64 padding2;
> > +       };
> > +};
> > +
> > +During the guest live migration the outgoing guest exports its page encryption
> > +bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
> > +bitmap for an incoming guest.
> >
> >  5. The kvm_run structure
> >  ========================
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 27e43e3ec9d8..d30f770aaaea 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1271,6 +1271,8 @@ struct kvm_x86_ops {
> >                                   unsigned long sz, unsigned long mode);
> >         int (*get_page_enc_bitmap)(struct kvm *kvm,
> >                                 struct kvm_page_enc_bitmap *bmap);
> > +       int (*set_page_enc_bitmap)(struct kvm *kvm,
> > +                               struct kvm_page_enc_bitmap *bmap);
> >  };
> >
> >  struct kvm_arch_async_pf {
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index bae783cd396a..313343a43045 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -7756,6 +7756,47 @@ static int svm_get_page_enc_bitmap(struct kvm *kvm,
> >         return ret;
> >  }
> >
> > +static int svm_set_page_enc_bitmap(struct kvm *kvm,
> > +                                  struct kvm_page_enc_bitmap *bmap)
> > +{
> > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +       unsigned long gfn_start, gfn_end;
> > +       unsigned long *bitmap;
> > +       unsigned long sz, i;
> > +       int ret;
> > +
> > +       if (!sev_guest(kvm))
> > +               return -ENOTTY;
> > +
> > +       gfn_start = bmap->start_gfn;
> > +       gfn_end = gfn_start + bmap->num_pages;
> > +
> > +       sz = ALIGN(bmap->num_pages, BITS_PER_LONG) / 8;
> > +       bitmap = kmalloc(sz, GFP_KERNEL);
> > +       if (!bitmap)
> > +               return -ENOMEM;
> > +
> > +       ret = -EFAULT;
> > +       if (copy_from_user(bitmap, bmap->enc_bitmap, sz))
> > +               goto out;
> > +
> > +       mutex_lock(&kvm->lock);
> > +       ret = sev_resize_page_enc_bitmap(kvm, gfn_end);
> I realize now that usermode could use this for initializing the
> minimum size of the enc bitmap, which probably solves my issue from
> the other thread.
> > +       if (ret)
> > +               goto unlock;
> > +
> > +       i = gfn_start;
> > +       for_each_clear_bit_from(i, bitmap, (gfn_end - gfn_start))
> > +               clear_bit(i + gfn_start, sev->page_enc_bmap);
> This API seems a bit strange, since it can only clear bits. I would
> expect "set" to force the values to match the values passed down,
> instead of only ensuring that cleared bits in the input are also
> cleared in the kernel.
>

The sev_resize_page_enc_bitmap() will allocate a new bitmap and
set it to all 0xFF's, therefore, the code here simply clears the bits
in the bitmap as per the cleared bits in the input.

Thanks,
Ashish

> This should copy the values from userspace (and fix up the ends since
> byte alignment makes that complicated), instead of iterating in this
> way.
> > +
> > +       ret = 0;
> > +unlock:
> > +       mutex_unlock(&kvm->lock);
> > +out:
> > +       kfree(bitmap);
> > +       return ret;
> > +}
> > +
> >  static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >  {
> >         struct kvm_sev_cmd sev_cmd;
> > @@ -8161,6 +8202,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> >
> >         .page_enc_status_hc = svm_page_enc_status_hc,
> >         .get_page_enc_bitmap = svm_get_page_enc_bitmap,
> > +       .set_page_enc_bitmap = svm_set_page_enc_bitmap,
> >  };
> >
> >  static int __init svm_init(void)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 3c3fea4e20b5..05e953b2ec61 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5238,6 +5238,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >                         r = kvm_x86_ops->get_page_enc_bitmap(kvm, &bitmap);
> >                 break;
> >         }
> > +       case KVM_SET_PAGE_ENC_BITMAP: {
> > +               struct kvm_page_enc_bitmap bitmap;
> > +
> > +               r = -EFAULT;
> > +               if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
> > +                       goto out;
> > +
> > +               r = -ENOTTY;
> > +               if (kvm_x86_ops->set_page_enc_bitmap)
> > +                       r = kvm_x86_ops->set_page_enc_bitmap(kvm, &bitmap);
> > +               break;
> > +       }
> >         default:
> >                 r = -ENOTTY;
> >         }
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index db1ebf85e177..b4b01d47e568 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1489,6 +1489,7 @@ struct kvm_enc_region {
> >  #define KVM_S390_CLEAR_RESET   _IO(KVMIO,   0xc4)
> >
> >  #define KVM_GET_PAGE_ENC_BITMAP        _IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
> > +#define KVM_SET_PAGE_ENC_BITMAP        _IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
> >
> >  /* Secure Encrypted Virtualization command */
> >  enum sev_cmd_id {
> > --
> > 2.17.1
> >
