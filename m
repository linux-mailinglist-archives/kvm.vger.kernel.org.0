Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA19126E36
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 20:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfLSTt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 14:49:58 -0500
Received: from mail-bn8nam11on2047.outbound.protection.outlook.com ([40.107.236.47]:14657
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726840AbfLSTt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 14:49:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JE6XeACfa8P6hc8ZMuZ3DSQ6mVh9Ejgle94Y8s3tqbns1gn/1H2i4+DOQe/XNX/spquAg7txotdpfiKa7X6uCJ2HsJa6HtEHXLy5ZFIcxxSaoTDo4scCFbqmZvLoQpWeYYZvnAPKKQ+IOO/2Nm+pEMrAJbNsNOHuB96bZAgTbOs3DIPuWSDaFamY1vXQsjYTjuzSomcsLWCrBgH4lmB3u7VQGm+hA0qzOT2ubAT/VdeMpZ7p6FSkyObfv/4eJckXL7LcnjjpGIMFmdbQKKGaypFIomImBMNiKBm5MMUwRLrdoftI/ncjYtGrj6rQYefdIIJaqRk/JHNQWDrZYi4aOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCpz7GqwUgGd6g9PS8p3oOM7Bc3gp3y402tqVGFgOaU=;
 b=iJlQQpX0cHZne9OQyGlESlNGqbH5NcmJKqOfjMwOkrXzg5wZ01nkkXj/kKBNsRdlAJlvCxcyQ/IRA2pLOEnbn7M9kDCpMzVD24eDtJZ+PPVdyS3yCsLwYXpH71WPAeq3i43eLIxIfFwYWRyibYN8/77xnpquibSsStVn2BhqNXv9FYjnr6vJ0TO9kJwNXCO2pl561Ye6N3bP/4d5tEsjIEYhjqe3Qn8/ZlmOWK+RAr3a4thYFh4h4l9tf2w7/BLHOXwnV2VVwhyQziPVKd/r/eDLgG/ukL38n/fsNQhtQBDO/DDODluBc4+mvvqs+PPQvCcAriM50rnnuOXqUvxLWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fCpz7GqwUgGd6g9PS8p3oOM7Bc3gp3y402tqVGFgOaU=;
 b=ASTxwckP5g0aIGjztkGzciVRJ28edyafGAbT962MTs//7ChkwpUgJ6fMzBxcYBmQ0nZhTu51zJ+f9m6aBx9TrM7L43HOdguq+HxN3TF5ZIORbU9e22x2ukrdJvFykHDZUP6RG2ia4fQaQtuNQBe0M67+VYrL4SNaHkXvo8jWsls=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=John.Allen@amd.com; 
Received: from DM5PR12MB2423.namprd12.prod.outlook.com (52.132.140.158) by
 DM5PR12MB1596.namprd12.prod.outlook.com (10.172.38.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Thu, 19 Dec 2019 19:49:54 +0000
Received: from DM5PR12MB2423.namprd12.prod.outlook.com
 ([fe80::84ad:4e59:7686:d79c]) by DM5PR12MB2423.namprd12.prod.outlook.com
 ([fe80::84ad:4e59:7686:d79c%3]) with mapi id 15.20.2538.019; Thu, 19 Dec 2019
 19:49:54 +0000
Date:   Thu, 19 Dec 2019 13:49:48 -0600
From:   John Allen <john.allen@amd.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com
Subject: Re: [PATCH] kvm/svm: PKU not currently supported
Message-ID: <20191219194948.adug277luzjdu3qv@mojo.amd.com>
References: <20191219152332.28857-1-john.allen@amd.com>
 <87immc873u.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87immc873u.fsf@vitty.brq.redhat.com>
X-ClientProxiedBy: SN4PR0501CA0101.namprd05.prod.outlook.com
 (2603:10b6:803:42::18) To DM5PR12MB2423.namprd12.prod.outlook.com
 (2603:10b6:4:b3::30)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f531fd1-14e4-4bbf-62e3-08d784bc9e53
X-MS-TrafficTypeDiagnostic: DM5PR12MB1596:
X-Microsoft-Antispam-PRVS: <DM5PR12MB15967D32CFF0BCF4802E1DDE9A520@DM5PR12MB1596.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0256C18696
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(189003)(199004)(66476007)(8936002)(81156014)(81166006)(8676002)(6506007)(66556008)(86362001)(66946007)(316002)(6512007)(52116002)(2906002)(44832011)(1076003)(26005)(186003)(4326008)(6916009)(5660300002)(478600001)(6666004)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1596;H:DM5PR12MB2423.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qGjzNbAe4kMAZzz2NnArgPjAPhh10VYD8s6SuppqQIpo84ISO8sIF77xyCynvkfvcS3TYUu3nGMknSXplly/hFu59MOFIlPvMB9UIRe+/PWnt7wvNzrh/cJh9QWjhYrl0cT4UWmcvm62L+uebwyfTjKZXIqRiXpBl0Ca56xVsVMc9pPPIp60mvlw/2YS6jX3F+FeyuifYC/qTkEltoJc0B0v0rImQWSXc0bCs7YZ4Wi2yA2YQrmOM0L7VnnlweXFMOsslO2WT/ThgnHIJj8dSwUirfGbdHQVRYWejkdB3pG/cA4uE9OPBSPGRSNS9gcM3Nmdv4PnjIPYfQ9CUYVm+fe8lkx/3dzQNU3iO9l7HWJwYLM2dxEA0I5VpO/yCtbPyPJS31655WKjoLCc0x9RHtoE0K26f3nnyFnlddNA/jWFfkZOs0YfMUTNITo1KOX4
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f531fd1-14e4-4bbf-62e3-08d784bc9e53
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2019 19:49:54.4955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x/sRurtDKoLeDJYn/WMxOgWclijHLqDNrG7sKAexzPPN0FBSYB/Xov350pjyxzOoSdZz1m2TimKqBxPIhcWSPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1596
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 19, 2019 at 08:09:57PM +0100, Vitaly Kuznetsov wrote:
> John Allen <john.allen@amd.com> writes:
> 
> > Current SVM implementation does not have support for handling PKU. Guests
> > running on a host with future AMD cpus that support the feature will read
> > garbage from the PKRU register and will hit segmentation faults on boot as
> > memory is getting marked as protected that should not be. Ensure that cpuid
> > from SVM does not advertise the feature.
> >
> > Signed-off-by: John Allen <john.allen@amd.com>
> > ---
> >  arch/x86/kvm/svm.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> > index 122d4ce3b1ab..f911aa1b41c8 100644
> > --- a/arch/x86/kvm/svm.c
> > +++ b/arch/x86/kvm/svm.c
> > @@ -5933,6 +5933,8 @@ static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> >  		if (avic)
> >  			entry->ecx &= ~bit(X86_FEATURE_X2APIC);
> >  		break;
> > +	case 0x7:
> > +		entry->ecx &= ~bit(X86_FEATURE_PKU);
> 
> Would it make more sense to introduce kvm_x86_ops->pku_supported() (and
> return false for SVM and boot_cpu_has(X86_FEATURE_PKU) for vmx) so we
> don't set the bit in the first place?

Yes, I think you're right. I had initially planned to do it that way so I
already have a patch ready. I'll send it up pronto.

> 
> >  	case 0x80000001:
> >  		if (nested)
> >  			entry->ecx |= (1 << 2); /* Set SVM bit */
> 
> -- 
> Vitaly
> 
