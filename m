Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEB7318264B
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 01:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387518AbgCLAjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 20:39:40 -0400
Received: from mail-dm6nam11on2048.outbound.protection.outlook.com ([40.107.223.48]:32833
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387486AbgCLAjk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 20:39:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fgeMUgBYqk7R2GtLiMxiMe2SKcffVYei2Rk4+Q/kquwqT3luf/hYoxliNpbd8+qTDBBS1Zdnu2UgNtQiKB9qVQ07ULLUnyigJUz+EtkXUwb2RoeFuSY16ly+bB8hhmlc4zViZdiR6UyGSOA37gSwMtOCgVp8Y1e8r7VqDyrfoV6sqj8jafbxIwi3QFumkxubA8uELYMorK7HTh+riad/m2ptkas3NVlgeFO+NQjPGRkZAG9aUBi5nm267O2Y1eosqYctC4CG4PIJkCNAnRRy0LjhCI3OXlFgBR2YmuPrZ8yrHVMxPhE9PVHDzrZdh85v2MUSlpgVXsSJJ0/XElq6GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mtblxdy2aDMSi+orff0eKuWX1MniM94QBDKkbCP98W8=;
 b=RJ5Zui7SiyTWn0o7SfP2wTCClL6HSxt+bQ2VWys6386hlfnNHNoogFcz5ca86LW7Pu90rI1L1Yi1//b72WZjfTJ6aQhJGFhn1XEfrjRBEIz4jn0QQnMiVaaeAE0Bb7PCMS7RhGYLOcy+eiHygs2/0YfsD0wrTYWwqzx/nx6hICtVypZfR5CajFskicKZwWwZgvjaEcBYMgAe/aktlccL45s2MnOk5LQ2Dgrj8hY951TINDqdDKTyvT9AsTo1Z1YWLY+rgg5eaTdIq3NMi0FzG00OrAm/kLfPHbwtqR+FuZiVexKlA6M3pzxFXa1blRRYz3FtqzZFOQ1yzgVR/CLq1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mtblxdy2aDMSi+orff0eKuWX1MniM94QBDKkbCP98W8=;
 b=oBo3+263j2XoUjnC4u9E1qkLzWCc6qf/KwiDUoAwYLmE7bVGbKiQPqA48C6+F93A7AuOA49iP3GhIPQZc7M86C/Mzy38zIHDvdTUUEBOPFnvTCnfQRZJF6Mp+rrVFBzhEd2nASGrPbq6cidvq6hC84OLYwyq2kHQ2nvjQzLlxuE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1148.namprd12.prod.outlook.com (2603:10b6:3:74::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 00:39:01 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 00:39:01 +0000
Date:   Thu, 12 Mar 2020 00:38:55 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>, X86 ML <x86@kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, brijesh.singh@amd.com
Subject: Re: [PATCH 04/12] KVM: SVM: Add support for KVM_SEV_RECEIVE_START
 command
Message-ID: <20200312003855.GA26448@ashkalra_ubuntu_server>
References: <cover.1581555616.git.ashish.kalra@amd.com>
 <0a0b3815e03dcee47ca0fbf4813821877b4c2ea0.1581555616.git.ashish.kalra@amd.com>
 <CABayD+ciJiF8gf+s6d57vENcnSQPQGzTTwdo0TLBsNLdoy0tWw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABayD+ciJiF8gf+s6d57vENcnSQPQGzTTwdo0TLBsNLdoy0tWw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: DM6PR13CA0048.namprd13.prod.outlook.com
 (2603:10b6:5:134::25) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by DM6PR13CA0048.namprd13.prod.outlook.com (2603:10b6:5:134::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.8 via Frontend Transport; Thu, 12 Mar 2020 00:38:59 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 398d0955-4e9e-4b0c-4a92-08d7c61dc1dd
X-MS-TrafficTypeDiagnostic: DM5PR12MB1148:|DM5PR12MB1148:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1148941169809A6F8D153B638EFD0@DM5PR12MB1148.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(199004)(7416002)(86362001)(6496006)(52116002)(6916009)(33656002)(2906002)(33716001)(6666004)(8676002)(5660300002)(66476007)(9686003)(55016002)(8936002)(81166006)(81156014)(1076003)(44832011)(478600001)(186003)(316002)(16526019)(26005)(66556008)(54906003)(956004)(66946007)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1148;H:DM5PR12MB1386.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rt633aPsVroUTIoxhbpI4sU2MkDN8EN5/K7OdHCuxBQ19Q7Z2Fi/r75dYav2C+t/cuFnk5WXQgHrlqqQqkk098MsNTXPg4e+R+rPDeiYhh83cSKeGsdI3jAiy6SX+wSf/cJjbMLbaVq7XDm8pnRd1f3fhpD8FLPrQk8hpzDdOukZXpL5+qjOl8+K7m75pL4gZ1zzsWtTE1lafzGkMWKq2rXBw2kDssWaHr+Yi4uFDnF4kVvKLOBmbNVWZeXxTeSRADguFd7v/ZM9g2b4xUKkDR3uzguMJjZk+qSxxH3WlFC6k+rA6aSSBiMQy8wjUbiOubL/P6HQFSW0QKNmHFfn5nsKA8Y3ZtN3ZXhn2ejTNKGg1/ynz2rwLXEPLQS8L5vfLSFOyNXhwlN4NtpIht72qzpQLI5XiHS+YhcEckACs3pGJ0+VAB9bKfLpc4rvuE8v
X-MS-Exchange-AntiSpam-MessageData: ZNZHbomLObZQ8S+9w7+sfDJaArOBAbVQKArVKAmWV51BdtJpTvfcmh759HEhzQprpUnz36LU2jOOXwhTRgy7O/SPCKTatvBUi25VfmlrfqBoJrKt0cZCcUVSK6F4kLs9VD5cnPefxtwodFrWiCiC6w==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 398d0955-4e9e-4b0c-4a92-08d7c61dc1dd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 00:39:01.0208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AdhwcqbM2WjTm5aISMvFh/wBX1osy8MEUNVSUcILx0lkjbrv8OvR2eGrA4HS/A+t8pXHcLSerTY/tXtuSg44eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1148
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 09, 2020 at 06:41:02PM -0700, Steve Rutherford wrote:
> > +static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> > +{
> > +       struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +       struct sev_data_receive_start *start;
> > +       struct kvm_sev_receive_start params;
> > +       int *error = &argp->error;
> > +       void *session_data;
> > +       void *pdh_data;
> > +       int ret;
> > +
> > +       if (!sev_guest(kvm))
> > +               return -ENOTTY;
> > +
> > +       /* Get parameter from the userspace */
> > +       if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> > +                       sizeof(struct kvm_sev_receive_start)))
> > +               return -EFAULT;
> > +
> > +       /* some sanity checks */
> > +       if (!params.pdh_uaddr || !params.pdh_len ||
> > +           !params.session_uaddr || !params.session_len)
> > +               return -EINVAL;
> > +
> > +       pdh_data = psp_copy_user_blob(params.pdh_uaddr, params.pdh_len);
> > +       if (IS_ERR(pdh_data))
> > +               return PTR_ERR(pdh_data);
> > +
> > +       session_data = psp_copy_user_blob(params.session_uaddr,
> > +                       params.session_len);
> > +       if (IS_ERR(session_data)) {
> > +               ret = PTR_ERR(session_data);
> > +               goto e_free_pdh;
> > +       }
> > +
> > +       ret = -ENOMEM;
> > +       start = kzalloc(sizeof(*start), GFP_KERNEL);
> > +       if (!start)
> > +               goto e_free_session;
> > +
> > +       start->handle = params.handle;
> > +       start->policy = params.policy;
> > +       start->pdh_cert_address = __psp_pa(pdh_data);
> > +       start->pdh_cert_len = params.pdh_len;
> > +       start->session_address = __psp_pa(session_data);
> > +       start->session_len = params.session_len;
> > +
> > +       /* create memory encryption context */
> 
> Set ret to a different value here, since otherwise this will look like -ENOMEM.

But, ret will be the value returned by __sev_issue_cmd(), so why will it
look like -ENOMEM ?

> 
> > +       ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_RECEIVE_START, start,
> > +                               error);
> > +       if (ret)
> > +               goto e_free;
> > +
> > +       /* Bind ASID to this guest */
> 
> Ideally, set ret to another distinct value, since the error spaces for
> these commands overlap, so you won't be sure which had the problem.
> You also wouldn't be sure if one succeeded and the other failed vs
> both failing.

Both commands "may" return the same error code as set by sev_do_cmd(), but
then we need that very specific error code, sev_do_cmd() can't return
different error codes for each command it is issuing ?

> 
> > +       ret = sev_bind_asid(kvm, start->handle, error);
> > +       if (ret)
> > +               goto e_free;
> > +

Thanks,
Ashish

