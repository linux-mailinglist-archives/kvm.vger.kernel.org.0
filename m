Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAE019E07B
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 23:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgDCVqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 17:46:06 -0400
Received: from mail-dm6nam12on2043.outbound.protection.outlook.com ([40.107.243.43]:6168
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726460AbgDCVqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 17:46:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VXZSKB0pzJU6uHbNBPTACXPrvFLY4jf+o64lV9cwSVy4y8qU5lPFV7MlnZUbqJEFb6uapOKehZbGe6O7BXnth63vj5PygsWk/Xl+tfBCnxBiuztHLE4JuW5vACpWnPmY0EmhW35PKoEIpVneWP+f3LbJqH9f40CPYBQrSazK0qXfBYZLBoSilLxYfQhFRsfoOyXYrUbcANMLt3ZvhqHmu+bOHWHmEESMw1xfmSS1N9F2vuCaNfp4UrfkMx21GAmxg9OqlfJNoowfVzZEaHuulVgAPN3Ux0gshK/fT+OP4XOInvMCQpyV9ddsjRrz3j3rDsMLJVM666cIadYMNwiZ5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dqt+cOw/NNk8PMZok7O6ak7zpWkv3tw34fVZ7tA9cuc=;
 b=Cn5SIJ5TjNV5R5Nld5aBbtOjzT7yrsHU35UcNmCVXXM/5pcJtivWDwqqq/VHluA1vm0lUzt0H/YlT9SR/tIVztjmc4+hghlfAkersMR8hjUitCKV3sLw35YpVDQAk4w2DyWb8WO15RwWmot3rWfSX2sgeyfu7glU83dYu/IEQTlVojri9lVWkF5RNrEWHWkDvHulvU7VH+Qf9n4Ys1pe+9Pe9KqG26coR++bP0AXVe9ZH4OrhI0Wq8byT9S5KtOsEUApVfPU9E5bvV9aD/+yKD9El1NQy95JbDA4FnY3//2drvpiHPKDUudcG8/WEejLc/Dv5LhEFnMaC89hTEiAqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dqt+cOw/NNk8PMZok7O6ak7zpWkv3tw34fVZ7tA9cuc=;
 b=x7JxCfa9kfz2+lavsDLwWxvOGa5rVWf7nP0G7jp0ZvYzmSr6DARp5h0U7tuAq5Nmq/GkdO86BqvZyrJhH0+lxFRqTkWHlSH7xXXYrkeJ0f0or6Ubpu0yYZFjYEFOLGfjRkPbWdJRPzbO+wU4Y0naXdtLCjJ9ZiOug6zx2aOmRlY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1465.namprd12.prod.outlook.com (2603:10b6:4:7::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Fri, 3 Apr 2020 21:46:01 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2878.017; Fri, 3 Apr 2020
 21:46:01 +0000
Date:   Fri, 3 Apr 2020 21:45:59 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
Subject: Re: [PATCH v6 12/14] KVM: x86: Introduce KVM_PAGE_ENC_BITMAP_RESET
 ioctl
Message-ID: <20200403214559.GB28747@ashkalra_ubuntu_server>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <9e959ee134ad77f62c9881b8c54cd27e35055072.1585548051.git.ashish.kalra@amd.com>
 <b77a4a1e-b8ca-57a2-d849-adda91bfeac7@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b77a4a1e-b8ca-57a2-d849-adda91bfeac7@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM6PR02CA0067.namprd02.prod.outlook.com
 (2603:10b6:5:177::44) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM6PR02CA0067.namprd02.prod.outlook.com (2603:10b6:5:177::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Fri, 3 Apr 2020 21:46:00 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3d04e49e-e1ad-403d-bb07-08d7d81866fe
X-MS-TrafficTypeDiagnostic: DM5PR12MB1465:|DM5PR12MB1465:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1465DF326DE8701B42DB57988EC70@DM5PR12MB1465.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0362BF9FDB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(86362001)(1076003)(5660300002)(44832011)(4326008)(478600001)(6496006)(52116002)(33656002)(16526019)(186003)(53546011)(6916009)(7416002)(8676002)(55016002)(81156014)(33716001)(956004)(81166006)(66946007)(9686003)(8936002)(316002)(26005)(66556008)(66476007)(2906002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zee9q4eATn2oYzAF+wgtHlydIHeBY2WwsISd9evmkDwIp0QuMm3vEoj6FRzb+C5T1u6qPMJT7tlXvaoueKI+ImqJG8/3SahsS6wJYr4//jxYdNicb2tAMIPbe6cXGFYkhqlDvI/ACOo4hM3rXyefOud/3GLSB4UhgP81hbXg71s6T+Nqc21lbk4aTKPr2Tv5TbmvQxvE9Cp0zLiLAnolOpe7y20ZWXWWQ2ArNyHfeaAWEmBVWwcr2M3iISg3RcyyE1+RMLexML+ltxXWJueqBTunUdZyyvJHnpPlDmGpNFhYcLlwGL2xeh9V2b4UttwW9SRduMqz1uDddJl1w/2Vp3vAGVKaLTqlsnDhjdc6Lu5FhPSV96SXFs1RgROyHMHB4/tI7bxEpT49uyXE2lewVaqkPwPwydUDEANcAIBIzu1Osg7GVdlBQe+AroBvp8qB
X-MS-Exchange-AntiSpam-MessageData: eXoImM4QSph/5eebXFgnBJACeEuFabpx245UkHeRTwxyIBq3omh5ZC/lB65c5op0paHRSTNtNzkx0sSLMxKwJ5juwqRjuJ9Uwu+L+fdIahcKiz3b6oN+K4+aKsYK/N6UHqZKZ6oN3tuhQRbEXbIsbA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d04e49e-e1ad-403d-bb07-08d7d81866fe
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2020 21:46:01.7138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B8q3srQ8GLTtK3MAO2fmssiIhJKAAU47CmbRdVaWIzqSviWFjEPsACgg5zy4e/Wus1IcM3zx0FKp+DCkgwwaYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1465
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 03, 2020 at 02:14:23PM -0700, Krish Sadhukhan wrote:
> 
> On 3/29/20 11:23 PM, Ashish Kalra wrote:
> > From: Ashish Kalra <ashish.kalra@amd.com>
> > 
> > This ioctl can be used by the application to reset the page
> > encryption bitmap managed by the KVM driver. A typical usage
> > for this ioctl is on VM reboot, on reboot, we must reinitialize
> > the bitmap.
> > 
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >   Documentation/virt/kvm/api.rst  | 13 +++++++++++++
> >   arch/x86/include/asm/kvm_host.h |  1 +
> >   arch/x86/kvm/svm.c              | 16 ++++++++++++++++
> >   arch/x86/kvm/x86.c              |  6 ++++++
> >   include/uapi/linux/kvm.h        |  1 +
> >   5 files changed, 37 insertions(+)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 4d1004a154f6..a11326ccc51d 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -4698,6 +4698,19 @@ During the guest live migration the outgoing guest exports its page encryption
> >   bitmap, the KVM_SET_PAGE_ENC_BITMAP can be used to build the page encryption
> >   bitmap for an incoming guest.
> > +4.127 KVM_PAGE_ENC_BITMAP_RESET (vm ioctl)
> > +-----------------------------------------
> > +
> > +:Capability: basic
> > +:Architectures: x86
> > +:Type: vm ioctl
> > +:Parameters: none
> > +:Returns: 0 on success, -1 on error
> > +
> > +The KVM_PAGE_ENC_BITMAP_RESET is used to reset the guest's page encryption
> > +bitmap during guest reboot and this is only done on the guest's boot vCPU.
> > +
> > +
> >   5. The kvm_run structure
> >   ========================
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index d30f770aaaea..a96ef6338cd2 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1273,6 +1273,7 @@ struct kvm_x86_ops {
> >   				struct kvm_page_enc_bitmap *bmap);
> >   	int (*set_page_enc_bitmap)(struct kvm *kvm,
> >   				struct kvm_page_enc_bitmap *bmap);
> > +	int (*reset_page_enc_bitmap)(struct kvm *kvm);
> >   };
> >   struct kvm_arch_async_pf {
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 313343a43045..c99b0207a443 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -7797,6 +7797,21 @@ static int svm_set_page_enc_bitmap(struct kvm *kvm,
> >   	return ret;
> >   }
> > +static int svm_reset_page_enc_bitmap(struct kvm *kvm)
> > +{
> > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +
> > +	if (!sev_guest(kvm))
> > +		return -ENOTTY;
> > +
> > +	mutex_lock(&kvm->lock);
> > +	/* by default all pages should be marked encrypted */
> > +	if (sev->page_enc_bmap_size)
> > +		bitmap_fill(sev->page_enc_bmap, sev->page_enc_bmap_size);
> > +	mutex_unlock(&kvm->lock);
> > +	return 0;
> > +}
> > +
> >   static int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> >   {
> >   	struct kvm_sev_cmd sev_cmd;
> > @@ -8203,6 +8218,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
> >   	.page_enc_status_hc = svm_page_enc_status_hc,
> >   	.get_page_enc_bitmap = svm_get_page_enc_bitmap,
> >   	.set_page_enc_bitmap = svm_set_page_enc_bitmap,
> > +	.reset_page_enc_bitmap = svm_reset_page_enc_bitmap,
> 
> 
> We don't need to initialize the intel ops to NULL ? It's not initialized in
> the previous patch either.
> 
> >   };

This struct is declared as "static storage", so won't the non-initialized
members be 0 ?

> >   static int __init svm_init(void)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 05e953b2ec61..2127ed937f53 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5250,6 +5250,12 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >   			r = kvm_x86_ops->set_page_enc_bitmap(kvm, &bitmap);
> >   		break;
> >   	}
> > +	case KVM_PAGE_ENC_BITMAP_RESET: {
> > +		r = -ENOTTY;
> > +		if (kvm_x86_ops->reset_page_enc_bitmap)
> > +			r = kvm_x86_ops->reset_page_enc_bitmap(kvm);
> > +		break;
> > +	}
> >   	default:
> >   		r = -ENOTTY;
> >   	}
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index b4b01d47e568..0884a581fc37 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1490,6 +1490,7 @@ struct kvm_enc_region {
> >   #define KVM_GET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc5, struct kvm_page_enc_bitmap)
> >   #define KVM_SET_PAGE_ENC_BITMAP	_IOW(KVMIO, 0xc6, struct kvm_page_enc_bitmap)
> > +#define KVM_PAGE_ENC_BITMAP_RESET	_IO(KVMIO, 0xc7)
> >   /* Secure Encrypted Virtualization command */
> >   enum sev_cmd_id {
> Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
