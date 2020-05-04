Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3F61C4A6E
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 01:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgEDXhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 19:37:55 -0400
Received: from mail-bn7nam10on2053.outbound.protection.outlook.com ([40.107.92.53]:48577
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728340AbgEDXhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 19:37:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYCHzLdxz11VAQSMom39hHjpAMITgParpA2Y8Pt77OQbjDMDSAI6frCPr/HcCJr9CWYq9lU7PDGZGenNJfTBCSBlR8LyT+GuX/zOBjGP8IxmFTho4+ObO9+c/NdsIQ8jqjmwKoy1b/ji/ZLti/MC6N291w1ne0sStfJqnbfmdL1gbynwqdhP6l1l8h4J3F6Uj60wJnrhQRNgeNdKEoq1dLJHlVfH4JB2c8/9Bywjce4S7DxnEfS6vBPgr4UF0L/wM91pGdNwRp1q8K6bnS0z33CJfwIgE52pOyMI0ZMo6JbuZr8e2LnQwyTnYLGLkSydmcraNkUWFSMwOrc5vHUGmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cKrIEGMysnJg9JL3Qd9XWFZ5ejANFFwysBAZZeA3I4=;
 b=aXuolSDLR3TFgdyUhXD3lUmo8tLoP3XCyca1Viafxk1yvg2A2CDBjRO8hnDc2fPjwnEYxReh+3sW6Rw6Y3anwsMHwFYakJHD9cH/x6leZmHOuAD3oCKdl/NkJ9KH2Nq27ht2U85n6ziAirx2s1uGgJo0ubWF6V4+WFij8dC6JRaWC6qYYRuLALn66Zu2g79lcdoJuR5GP80m8grkWjprtVBYRvZqfSOwxJti7hiVuOdzMEFbKodIQcb+vqoyGE2ZKZXi+tJszjbAc8H9Tw8DogLudmZfXUdmfQwSj+LcxSeQEM73fgzTRA1oKMiMUwaTVxfFxyy+yb3QIl3GtSUqbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cKrIEGMysnJg9JL3Qd9XWFZ5ejANFFwysBAZZeA3I4=;
 b=lCDzLgr5nU5I6iER1lFDZqPZF0TgmEO1a3wpLBtFf9KNc8D4HTp/Y8YXJP+Jd6xfS5Bg0CRKWImyVOhBU2c3makaZb4rgC5NGnJzskPPsjKvXoP2lipWlDg86nhECvDzKcbo8AeHBUXDKMqzJTG5/7c2jPYjccxb6T1yvRAkd/4=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1577.namprd12.prod.outlook.com (2603:10b6:4:f::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.29; Mon, 4 May 2020 23:37:50 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.029; Mon, 4 May 2020
 23:37:50 +0000
Date:   Mon, 4 May 2020 23:37:47 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Venu Busireddy <venu.busireddy@oracle.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        rientjes@google.com, brijesh.singh@amd.com
Subject: Re: [PATCH v7 01/18] KVM: SVM: Add KVM_SEV SEND_START command
Message-ID: <20200504233747.GB3615@ashkalra_ubuntu_server>
References: <cover.1588234824.git.ashish.kalra@amd.com>
 <6473e5803d8c47d9b207810e8015c3066c39f17d.1588234824.git.ashish.kalra@amd.com>
 <20200504210717.GA1699387@vbusired-dt>
 <20200504223637.GA3615@ashkalra_ubuntu_server>
 <20200504231050.GA1701627@vbusired-dt>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200504231050.GA1701627@vbusired-dt>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM5PR07CA0117.namprd07.prod.outlook.com
 (2603:10b6:4:ae::46) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM5PR07CA0117.namprd07.prod.outlook.com (2603:10b6:4:ae::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Mon, 4 May 2020 23:37:49 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5b276b94-4fb6-4086-a5e2-08d7f084286c
X-MS-TrafficTypeDiagnostic: DM5PR12MB1577:|DM5PR12MB1577:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1577D6C24AD3D58EFEE42A9D8EA60@DM5PR12MB1577.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03932714EB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KmOUcL4DVqapsDyEWtqgjR2iGXqWqOtnXRRNEh0eP4VJQlpvHshMmIkAoHQlGUmXW98e6bN3R5vS5lRZ5kMjvpRo4tha431g7hIsyvx2BX8z68L/S/8MjNbPJArbN10FaZAhxNszkhuW57xluoHhQFoErWLXdB8+vaJ5RX5SuTvYW9pgHhzDtATKJQdFwb42q5gGxJ2draimmpVve7bbpUQf8uyjLTCFDuxyV+AlYCAGx+4QpxmtI7tLTtddu7dl/p+9bUdV2DqVwEY+GLF7Awa7za7NfUOK61Qddqwrqs78rIZoaaYGAcLAHdVmicmv1G2IFdic6ZLa8J/xi2JfE2uOw+a8kKATlGdFl93Srj8lRbWBS8nv31rDDIobIBJaV14STlG2w6L+kf9mkoW5XsWusRPXE9MPS+YNi3et8ONrQlAXZTYp8DrL3bj2SBOfF1dNX3n38RVbx6W6lfwxkbnWTDhjZ+vdSQGaMcr5xsaM9JqK0seDJrLft2akCIoL4c2rg4sYKNHi5vMwfkrtVQRPHVA67EtLYY4opGZ1EAaJHLaWoa66oqImxKOM4EmyfVh5jrncHfxpSRXxagl0pShOXq62/jGl93YUii9GvSY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(33430700001)(9686003)(33656002)(316002)(52116002)(44832011)(7416002)(45080400002)(966005)(33716001)(86362001)(478600001)(2906002)(66574012)(1076003)(66476007)(30864003)(66556008)(55016002)(66946007)(6916009)(4326008)(5660300002)(6496006)(956004)(8676002)(186003)(16526019)(8936002)(53546011)(26005)(33440700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cY0Jc2MaI3mL02n8QYeya4gPv29hA1Mg0h4a+wXFpgbXY6qj5klKSgEf5blrG30jWZgXKd7w3S2rfjr6669MpBGZPVcZ4zdP/JhyLHcOFZzKK6i6y55HNluR+RTLDy3iIcki8V7ow+VLo3IonVvWZOZ7ZmSkK6EDpVV4AY9glK31r7N9xnWns7kCYPrhcoh5EQLbLBwsBiURze4xYmPDRMMKgDU0C8FeFqNJJwBc1OAGFjhbVT4ambhPqg6r5TGN3MYO+4pI34+eqRK+a3nNaALr3Huu/sbdzLel5eaSmMkGRIdMaEuM5PzhRjhrGMsxsX/pa6Q9sUSKu0S+oHfeRf4TnH2ZqARU6Bv/8lIrz3AmlZ8qYa2G1ZIw3lJPYAWDIPV90coSi4cnYXLzFwEPMQdjKdlui6Lm2qqgKULEXYvT58+att2cb5Z82cY3mUZMW8jkoCz2oulAjsbJel589IBpyTl68KiKAR2dArCbipxD0HX+OX50E8HIWf0YuXfp6QNNGmCEeDHxEBYiXF3RQEJx+ezttE9brXXt7P7zJFtmc3KdCNeLwuW7hBl/6t9j8BkC2sh/GRRq4xHnNz2X/+Hl7Cm2c7aT+m6I/csFEJ+tKIiytwPqfJBYGvgrbQrvfdsmbK29uVpo3CJzizqhV626H0BaQKV85wUoBAGwphxExC7kjZ62D0lVyruaEl4MVCEHL8U/mmDMa7LqBkKmCa/OuaiptoQnE/0+UIfJowitiAL6bv6H0aQf5rszRa71/5z6H77cSJ60h7l29WF2dCsy0Vpyl59zllCI9ycroX0=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b276b94-4fb6-4086-a5e2-08d7f084286c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2020 23:37:50.2901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1nDLvbJXInLE94kRnaO20it22aBEh/J41YhU15688dLKV8cmrUKoxCbxILp0gaqSj+tKjRRLUdQGZlMTgNcZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1577
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 04, 2020 at 06:10:50PM -0500, Venu Busireddy wrote:
> On 2020-05-04 22:36:37 +0000, Ashish Kalra wrote:
> > On Mon, May 04, 2020 at 04:07:17PM -0500, Venu Busireddy wrote:
> > > On 2020-04-30 08:40:34 +0000, Ashish Kalra wrote:
> > > > From: Brijesh Singh <Brijesh.Singh@amd.com>
> > > > 
> > > > The command is used to create an outgoing SEV guest encryption context.
> > > > 
> > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > Cc: Ingo Molnar <mingo@redhat.com>
> > > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> > > > Cc: Joerg Roedel <joro@8bytes.org>
> > > > Cc: Borislav Petkov <bp@suse.de>
> > > > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > > > Cc: x86@kernel.org
> > > > Cc: kvm@vger.kernel.org
> > > > Cc: linux-kernel@vger.kernel.org
> > > > Reviewed-by: Steve Rutherford <srutherford@google.com>
> > > > Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
> > > > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > > ---
> > > >  .../virt/kvm/amd-memory-encryption.rst        |  27 ++++
> > > >  arch/x86/kvm/svm/sev.c                        | 125 ++++++++++++++++++
> > > >  include/linux/psp-sev.h                       |   8 +-
> > > >  include/uapi/linux/kvm.h                      |  12 ++
> > > >  4 files changed, 168 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/Documentation/virt/kvm/amd-memory-encryption.rst b/Documentation/virt/kvm/amd-memory-encryption.rst
> > > > index c3129b9ba5cb..4fd34fc5c7a7 100644
> > > > --- a/Documentation/virt/kvm/amd-memory-encryption.rst
> > > > +++ b/Documentation/virt/kvm/amd-memory-encryption.rst
> > > > @@ -263,6 +263,33 @@ Returns: 0 on success, -negative on error
> > > >                  __u32 trans_len;
> > > >          };
> > > >  
> > > > +10. KVM_SEV_SEND_START
> > > > +----------------------
> > > > +
> > > > +The KVM_SEV_SEND_START command can be used by the hypervisor to create an
> > > > +outgoing guest encryption context.
> > > > +
> > > > +Parameters (in): struct kvm_sev_send_start
> > > > +
> > > > +Returns: 0 on success, -negative on error
> > > > +
> > > > +::
> > > > +        struct kvm_sev_send_start {
> > > > +                __u32 policy;                 /* guest policy */
> > > > +
> > > > +                __u64 pdh_cert_uaddr;         /* platform Diffie-Hellman certificate */
> > > > +                __u32 pdh_cert_len;
> > > > +
> > > > +                __u64 plat_certs_uadr;        /* platform certificate chain */
> > > 
> > > Can this be changed as mentioned in the previous review
> > > (https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F20200402062726.GA647295%40vbusired-dt%2F&amp;data=02%7C01%7Cashish.kalra%40amd.com%7Cf8d037dd37224ed4a33608d7f08067f5%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637242306610788233&amp;sdata=eu1SgC6ukawOuxTeAoA3mzKiMNWlPCCa5lGEVs9D1s0%3D&amp;reserved=0)?
> > > 
> > > > +                __u32 plat_certs_len;
> > > > +
> > > > +                __u64 amd_certs_uaddr;        /* AMD certificate */
> > > > +                __u32 amd_cert_len;
> > > 
> > > Can this be changed as mentioned in the previous review
> > > (https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F20200402062726.GA647295%40vbusired-dt%2F&amp;data=02%7C01%7Cashish.kalra%40amd.com%7Cf8d037dd37224ed4a33608d7f08067f5%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637242306610798235&amp;sdata=7xgp4ko8VGokGGQz1X1yPhz1ZXY9R501YginoDcen90%3D&amp;reserved=0)?
> > > 
> > > > +
> > > > +                __u64 session_uaddr;          /* Guest session information */
> > > > +                __u32 session_len;
> > > > +        };
> > > > +
> > > >  References
> > > >  ==========
> > > >  
> > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > index cf912b4aaba8..5a15b43b4349 100644
> > > > --- a/arch/x86/kvm/svm/sev.c
> > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > @@ -913,6 +913,128 @@ static int sev_launch_secret(struct kvm *kvm, struct kvm_sev_cmd *argp)
> > > >  	return ret;
> > > >  }
> > > >  
> > > > +/* Userspace wants to query session length. */
> > > > +static int
> > > > +__sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
> > > > +				      struct kvm_sev_send_start *params)
> > > > +{
> > > > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > > +	struct sev_data_send_start *data;
> > > > +	int ret;
> > > > +
> > > > +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> > > > +	if (data == NULL)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	data->handle = sev->handle;
> > > > +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
> > > > +
> > > > +	params->session_len = data->session_len;
> > > > +	if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
> > > > +				sizeof(struct kvm_sev_send_start)))
> > > > +		ret = -EFAULT;
> > > > +
> > > > +	kfree(data);
> > > > +	return ret;
> > > > +}
> > > > +
> > > > +static int sev_send_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> > > > +{
> > > > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > > > +	struct sev_data_send_start *data;
> > > > +	struct kvm_sev_send_start params;
> > > > +	void *amd_certs, *session_data;
> > > > +	void *pdh_cert, *plat_certs;
> > > > +	int ret;
> > > > +
> > > > +	if (!sev_guest(kvm))
> > > > +		return -ENOTTY;
> > > > +
> > > > +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> > > > +				sizeof(struct kvm_sev_send_start)))
> > > > +		return -EFAULT;
> > > > +
> > > > +	/* if session_len is zero, userspace wants to query the session length */
> > > > +	if (!params.session_len)
> > > > +		return __sev_send_start_query_session_length(kvm, argp,
> > > > +				&params);
> > > > +
> > > > +	/* some sanity checks */
> > > > +	if (!params.pdh_cert_uaddr || !params.pdh_cert_len ||
> > > > +	    !params.session_uaddr || params.session_len > SEV_FW_BLOB_MAX_SIZE)
> > > > +		return -EINVAL;
> > > > +
> > > > +	/* allocate the memory to hold the session data blob */
> > > > +	session_data = kmalloc(params.session_len, GFP_KERNEL_ACCOUNT);
> > > > +	if (!session_data)
> > > > +		return -ENOMEM;
> > > > +
> > > > +	/* copy the certificate blobs from userspace */
> > > > +	pdh_cert = psp_copy_user_blob(params.pdh_cert_uaddr,
> > > > +				params.pdh_cert_len);
> > > > +	if (IS_ERR(pdh_cert)) {
> > > > +		ret = PTR_ERR(pdh_cert);
> > > > +		goto e_free_session;
> > > > +	}
> > > > +
> > > > +	plat_certs = psp_copy_user_blob(params.plat_certs_uaddr,
> > > > +				params.plat_certs_len);
> > > > +	if (IS_ERR(plat_certs)) {
> > > > +		ret = PTR_ERR(plat_certs);
> > > > +		goto e_free_pdh;
> > > > +	}
> > > > +
> > > > +	amd_certs = psp_copy_user_blob(params.amd_certs_uaddr,
> > > > +				params.amd_certs_len);
> > > > +	if (IS_ERR(amd_certs)) {
> > > > +		ret = PTR_ERR(amd_certs);
> > > > +		goto e_free_plat_cert;
> > > > +	}
> > > > +
> > > > +	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
> > > > +	if (data == NULL) {
> > > > +		ret = -ENOMEM;
> > > > +		goto e_free_amd_cert;
> > > > +	}
> > > > +
> > > > +	/* populate the FW SEND_START field with system physical address */
> > > > +	data->pdh_cert_address = __psp_pa(pdh_cert);
> > > > +	data->pdh_cert_len = params.pdh_cert_len;
> > > > +	data->plat_certs_address = __psp_pa(plat_certs);
> > > > +	data->plat_certs_len = params.plat_certs_len;
> > > > +	data->amd_certs_address = __psp_pa(amd_certs);
> > > > +	data->amd_certs_len = params.amd_certs_len;
> > > > +	data->session_address = __psp_pa(session_data);
> > > > +	data->session_len = params.session_len;
> > > > +	data->handle = sev->handle;
> > > > +
> > > 
> > > Can the following code be changed as acknowledged in
> > > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2Ff715bf99-0158-4d5f-77f3-b27743db3c59%40amd.com%2F&amp;data=02%7C01%7Cashish.kalra%40amd.com%7Cf8d037dd37224ed4a33608d7f08067f5%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637242306610798235&amp;sdata=s3ZwfpCm94x2LCNN8I1jjcWcrkj3Nrw5PnOvxdDxSCs%3D&amp;reserved=0?
> > > 
> > 
> > I believe that this has been already addressed as discussed :
> > 
> > Ah, so the main issue is we should not be going to e_free on error. If
> > session_len is less than the expected len then FW will return an error.
> > In the case of an error we can skip copying the session_data into
> > userspace buffer but we still need to pass the session_len and policy
> > back to the userspace.
> > 
> > So this patch is still returning session_len and policy back to user
> > in case of error : ( as the code below shows )
> > 
> > if (!ret && copy_to_user((void
> > __user*)(uintptr_t)params.session_uaddr,...
> 
> This fix addresses only one part of the problem. I am referring to the
> other suggestion about avoiding copying the entire kvm_sev_send_start
> structure back to the user. As I was mentioning in the discussion,
> the only fields that changed are the policy and session_len fields. So,
> why copy back the entire structure? Why not just those two fields?
> 
> > 

Both policy and session_len are two different fields in the
kvm_sev_send_start structure, why to complicate it by using two
different copy_to_user()'s here, to send two 32-bit words back to user,
it's much simpler to copy the whole structure back in one copy_to_user() 
(makes it less complicated with no additional address computations),
also this is just a session start code, so it is invoked once at
the beginning of the migration process and it is not a performance
critical path such that saving few bytes of copy_to_user() wil affect it.

Thanks,
Ashish

> > 
> > > > +	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, data, &argp->error);
> > > > +
> > > > +	if (!ret && copy_to_user((void __user *)(uintptr_t)params.session_uaddr,
> > > > +			session_data, params.session_len)) {
> > > > +		ret = -EFAULT;
> > > > +		goto e_free;
> > > > +	}
> > > > +
> > > > +	params.policy = data->policy;
> > > > +	params.session_len = data->session_len;
> > > > +	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
> > > > +				sizeof(struct kvm_sev_send_start)))
> > > > +		ret = -EFAULT;
> > > > +
> > > > +e_free:
> > > > +	kfree(data);
> > > > +e_free_amd_cert:
> > > > +	kfree(amd_certs);
> > > > +e_free_plat_cert:
> > > > +	kfree(plat_certs);
> > > > +e_free_pdh:
> > > > +	kfree(pdh_cert);
> > > > +e_free_session:
> > > > +	kfree(session_data);
> > > > +	return ret;
> > > > +}
> > > > +
> > > >  int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> > > >  {
> > > >  	struct kvm_sev_cmd sev_cmd;
> > > > @@ -957,6 +1079,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
> > > >  	case KVM_SEV_LAUNCH_SECRET:
> > > >  		r = sev_launch_secret(kvm, &sev_cmd);
> > > >  		break;
> > > > +	case KVM_SEV_SEND_START:
> > > > +		r = sev_send_start(kvm, &sev_cmd);
> > > > +		break;
> > > >  	default:
> > > >  		r = -EINVAL;
> > > >  		goto out;
> > > > diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> > > > index 5167bf2bfc75..9f63b9d48b63 100644
> > > > --- a/include/linux/psp-sev.h
> > > > +++ b/include/linux/psp-sev.h
> > > > @@ -323,11 +323,11 @@ struct sev_data_send_start {
> > > >  	u64 pdh_cert_address;			/* In */
> > > >  	u32 pdh_cert_len;			/* In */
> > > >  	u32 reserved1;
> > > > -	u64 plat_cert_address;			/* In */
> > > > -	u32 plat_cert_len;			/* In */
> > > > +	u64 plat_certs_address;			/* In */
> > > > +	u32 plat_certs_len;			/* In */
> > > >  	u32 reserved2;
> > > > -	u64 amd_cert_address;			/* In */
> > > > -	u32 amd_cert_len;			/* In */
> > > > +	u64 amd_certs_address;			/* In */
> > > > +	u32 amd_certs_len;			/* In */
> > > >  	u32 reserved3;
> > > >  	u64 session_address;			/* In */
> > > >  	u32 session_len;			/* In/Out */
> > > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > > index 428c7dde6b4b..8827d43e2684 100644
> > > > --- a/include/uapi/linux/kvm.h
> > > > +++ b/include/uapi/linux/kvm.h
> > > > @@ -1598,6 +1598,18 @@ struct kvm_sev_dbg {
> > > >  	__u32 len;
> > > >  };
> > > >  
> > > > +struct kvm_sev_send_start {
> > > > +	__u32 policy;
> > > > +	__u64 pdh_cert_uaddr;
> > > > +	__u32 pdh_cert_len;
> > > > +	__u64 plat_certs_uaddr;
> > > > +	__u32 plat_certs_len;
> > > > +	__u64 amd_certs_uaddr;
> > > > +	__u32 amd_certs_len;
> > > > +	__u64 session_uaddr;
> > > > +	__u32 session_len;
> > > > +};
> > > > +
> > > >  #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
> > > >  #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
> > > >  #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
> > > > -- 
> > > > 2.17.1
> > > > 
