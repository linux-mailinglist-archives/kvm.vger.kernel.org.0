Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC741129802
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 16:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfLWPVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 10:21:12 -0500
Received: from mail-bn8nam11on2042.outbound.protection.outlook.com ([40.107.236.42]:12768
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726756AbfLWPVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 10:21:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHAqdQcuHicAY+KtxbTq3SrCeZq8T3+HobN8hWxj0vDac2MbRvJkQVFbZiCwQRw8WEBvXp6vQnd5zIOz0kygZdxhMLJrEF7RJfL1o9e9/zKhZIcZhzF6jW2/nsvUzaRDM2bcYkVcKUi/0Y3Y7rpGsGM82iCo/x3hRu4/T+MkkxvTkvqIJpXU/PTH7PyHsoM9M22g0BbcCwgQjNAZaAsZ0vCwPpnZ6BM0dIIiYfz4VVgBMsVwnDFFUM/Gac1SYImuq/Cu99WOoym4jIYk+6jaAPmF6mZeLOS52uHT23A71N72li1uFCAVZpbhoLpBje++QuOkDIgYRdiUAqFUCbuARA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywsaGFQA2l+JgPu9IxjrMFuQJlwSywu92r2Xka+v0Jg=;
 b=gMG8V1ef2VjXQTSPKqi+Pa+5Pd/H3qMRVtIWoVQciIZyFxpenSC4WQm/jULHesh6gmX801eFxHvG0iqCdeiNQD8+/40uDFanOEBVg6bN0E0UXSw5onbg0FQ202BQD1FIzEqvWc+hHrkEucDVkbN7M299w/M504iZNCAcYA698l12FGFkHqn0xtxpsPcSWfScZfIfM3TJFlfTdtsd2qAlFtZMGHFM29VSut0VImmm9ZhfsvMjA2Zy+jO+wv7wsRQK/JJSwRSTXLmbAlhumjn1rB++LlGKEMf4FwEAxMiToTHqNJ9WD2hD8DgKH6RTTG9CgkNDqNA+Fy410kPliw2Vzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ywsaGFQA2l+JgPu9IxjrMFuQJlwSywu92r2Xka+v0Jg=;
 b=1cOJA4IJTWwBvWahlS2aWIVvrScxzTDawyh9tOcscixceg2vVNCKAH+EprL+ZXh7e8G2ytYdgR7lc8/ndXQJeutYTscfllZbCVGMZScTuvVn2wkRuu7dqwCajkGyWq/0JSYLUQTTgtR5QpDla71URNWUThdJ5yIVTlVwJ7xj2Gw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=John.Allen@amd.com; 
Received: from MN2PR12MB3136.namprd12.prod.outlook.com (20.178.244.89) by
 MN2PR12MB3823.namprd12.prod.outlook.com (10.255.237.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.17; Mon, 23 Dec 2019 15:21:09 +0000
Received: from MN2PR12MB3136.namprd12.prod.outlook.com
 ([fe80::24f3:323d:e57a:1f76]) by MN2PR12MB3136.namprd12.prod.outlook.com
 ([fe80::24f3:323d:e57a:1f76%3]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 15:21:09 +0000
Date:   Mon, 23 Dec 2019 09:21:02 -0600
From:   John Allen <john.allen@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rkrcmar@redhat.com, vkuznets@redhat.com
Subject: Re: [PATCH v2] kvm/svm: PKU not currently supported
Message-ID: <20191223152102.7wy5fxmxhkpooa7y@mojo.amd.com>
References: <20191219201759.21860-1-john.allen@amd.com>
 <20191219203214.GC6439@linux.intel.com>
 <8a77e3b9-049e-e622-9332-9bebb829bc3d@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8a77e3b9-049e-e622-9332-9bebb829bc3d@redhat.com>
X-ClientProxiedBy: SN4PR0201CA0040.namprd02.prod.outlook.com
 (2603:10b6:803:2e::26) To MN2PR12MB3136.namprd12.prod.outlook.com
 (2603:10b6:208:d1::25)
MIME-Version: 1.0
Received: from mojo.amd.com (165.204.77.1) by SN4PR0201CA0040.namprd02.prod.outlook.com (2603:10b6:803:2e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14 via Frontend Transport; Mon, 23 Dec 2019 15:21:08 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bcdc8f55-a699-401b-7b3d-08d787bbbcb8
X-MS-TrafficTypeDiagnostic: MN2PR12MB3823:
X-Microsoft-Antispam-PRVS: <MN2PR12MB382366EE8891ACCE8CE7D2A49A2E0@MN2PR12MB3823.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0260457E99
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(189003)(199004)(53546011)(6666004)(956004)(44832011)(478600001)(1076003)(55016002)(5660300002)(8936002)(6916009)(2906002)(26005)(16526019)(186003)(8676002)(66946007)(4326008)(316002)(66556008)(81166006)(81156014)(7696005)(52116002)(66476007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB3823;H:MN2PR12MB3136.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vl94IgEFEuhNwZAbVQ80LJWVcnTELOcGzuFDZvKs7gXRfhKVauhYL5nXQy6D4BIAVUT89Bw5y4RiAtZyz0XR7fDk6uaVodRo3Vlsqpc1m3q6i4Naafxa9HOBdUt/Jw7Q2wDQAsA9d1z9o9rV0P+IX590eAepqO3N+JfsAokUSyTj4cNJg4mRmtYPWQdqlFRH3A/bps+jRNkB6STi2v20fm1GyjdHKcZkBgk5wsFEGIHXFIKjOMwcb1ybnmBJoWZI0SU/JfZZs5bSgdCqU1SEuRAtzlZlsPzQz+0TcvXSyl9+5LIUdsOyj6xXgadkArKeAVU+fKypCWnSSg9uQ0K99PGIICGQ92Kyi88WCjDXPs4ArHbgMI+5UOXoCpsNO/MJdDs4wMYTdk2taXGVzWannqDUy9QtRdmx5zFDE2+2PSabEeYw8AIS5oftURVgFgox
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcdc8f55-a699-401b-7b3d-08d787bbbcb8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2019 15:21:09.3344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E2Hyz1a+qtWl7N2uEppM485QEoxuMOKqNx4SexsaSJB00Ln4Tgvxip+I6vjOuNvT9HdmjF1qKL5N0Llu1ZxRGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3823
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 20, 2019 at 10:25:16AM +0100, Paolo Bonzini wrote:
> On 19/12/19 21:32, Sean Christopherson wrote:
> > On Thu, Dec 19, 2019 at 02:17:59PM -0600, John Allen wrote:
> >> Current SVM implementation does not have support for handling PKU. Guests
> >> running on a host with future AMD cpus that support the feature will read
> >> garbage from the PKRU register and will hit segmentation faults on boot as
> >> memory is getting marked as protected that should not be. Ensure that cpuid
> >> from SVM does not advertise the feature.
> >>
> >> Signed-off-by: John Allen <john.allen@amd.com>
> >> ---
> >> v2:
> >>   -Introduce kvm_x86_ops->pku_supported()
> > 
> > I like the v1 approach better, it's less code to unwind when SVM gains
> > support for virtualizaing PKU.
> > 
> > The existing cases of kvm_x86_ops->*_supported() in __do_cpuid_func() are
> > necessary to handle cases where it may not be possible to expose a feature
> > even though it's supported in hardware, host and KVM, e.g. VMX's separate
> > MSR-based features and PT's software control to hide it from guest.  In
> > this case, hiding PKU is purely due to lack of support in KVM.  The SVM
> > series to enable PKU can then delete a single line of SVM code instead of
> > having to go back in and do surgery on x86 and VMX.
> > 
> 
> I sort of liked the V1 approach better, in that I liked using
> set_supported_cpuid but I didn't like *removing* features from it.
> 
> I think all *_supported() should be removed, and the code moved from
> __do_cpuid_func() to set_supported_cpuid.
> 
> For now, however, this one is consistent with other features so I am
> applying it.

Hey Paolo,

If you haven't already applied this, would it be too much trouble to add a
fixes tag? If it's already applied, don't worry about it.

...
Fixes: 0556cbdc2fbc ("x86/pkeys: Don't check if PKRU is zero before writing it")

Thanks,
John

> 
> Paolo
> 
