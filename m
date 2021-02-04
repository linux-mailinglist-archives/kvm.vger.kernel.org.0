Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454F930F81D
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 17:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbhBDQgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 11:36:21 -0500
Received: from mail-bn8nam08on2046.outbound.protection.outlook.com ([40.107.100.46]:20477
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237132AbhBDQfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 11:35:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiBGSLgmkZ2cX7P4VRp4hnMp35it87QZjWJ6DA1VgAYWA3TaytSwdZ63F9vRODWI6HiCNDvhgQyLxuJ63dkmHWA8sDc4c9LfOQw3EAkhElTdKjeoX1QUPmFXj49QdIwJJVcVIDgacuQeG+CgZ9Y2plU+gx8jWO9kw6wSOUCOmuJEV21vuxqyL3pTiZ4zVNY4dJFBMu0GKgEg2A53qnTky4wSNceBZGWtxChZkC/9RmfjGdsHzUSpEfFCcnF4Fl0fNo7X081HS9Lj8Ts274wJ6TCPRxSmlLBIL4owMJQZq8nm04jdT3Ec3dY5M02WOUCXBPWQJ0JymXErcWv1JU+0iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHJPc4i00w+01gfYAK/kCc6REsG+oObSPEPyzJeD9Ts=;
 b=AS06HRAHBmNieT548ZHyj3Nnyg4RWnh1hJdHFiWQ/Ab/PWkyEEmUlWaDZaWxQEJNFKiamSTtpivFVfy51UTmDK8alstaQgGwV3h+nRCWE48oyZeBTn/mzoOkDBQ6aewAzSAn+AbCxGWzY7R7JRpqhs3m4gm45itH5ACluvL435HEs4hgGOcT8ZzTNfZI7nhCYiyD+e1K70bhIqxlp5gznz1NItJkpRjSGjP0FiLTulvOmv+NzhgjhOnPr+56+ZhFY81GD3gfExMFBUx3jselZpaIL1dFPqT/JaX9ttp1qqtLnvD2r7wcz3HtVES4frG6a3OHnMFwPobsL4R+ZJP/8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHJPc4i00w+01gfYAK/kCc6REsG+oObSPEPyzJeD9Ts=;
 b=xVXkE3Tig/Nt/DAufsHDuIcpoKubG2f5jM3W2WO3bro4lrXLULuKcDl15LvFAlW39FQ6dt1IgPoB97kmh2T+oQh8RRXN46gMZkVF5W0LDg2+xYy7q0BzHOWvVfvn1YLyjmpexE3EUSgvE8xBxVa2FwUOQ2dQMJts85YBMA1NokI=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2416.namprd12.prod.outlook.com (2603:10b6:802:2f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Thu, 4 Feb
 2021 16:34:58 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::24bb:3e53:c95e:cb8e%7]) with mapi id 15.20.3805.028; Thu, 4 Feb 2021
 16:34:58 +0000
Date:   Thu, 4 Feb 2021 16:34:52 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rkrcmar@redhat.com, joro@8bytes.org, bp@suse.de,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <20210204163452.GA25878@ashkalra_ubuntu_server>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <6cb9bd69-6217-9923-3161-b4163646c1e2@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cb9bd69-6217-9923-3161-b4163646c1e2@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0051.namprd11.prod.outlook.com
 (2603:10b6:806:d0::26) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SA0PR11CA0051.namprd11.prod.outlook.com (2603:10b6:806:d0::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 16:34:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 17f96608-6910-4988-3f8c-08d8c92acfd2
X-MS-TrafficTypeDiagnostic: SN1PR12MB2416:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB24164E7B1E5B70C4AF9823298EB39@SN1PR12MB2416.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TIXHykGu5leJSAe4rWSAG2R6ZUHeUgT/aa2cusRIB9FnjYpyLo0sR9FOkNh1ACLWnvcWL9VDUy9xSj0T0ZgfGFi3CnJlFYWE9qydKf3v+Da/D9Qg/6qCSwTjxiY/SgSypnVmUFaBMLK98D8BW+D//IZAZmZuMO9JNmFrB11ffJDNg1/+WvxOXuZXYULEbFZ+QTA4OPCiHEP2hqvnL9QhbkWmCavwOe0ARHelZO73j9yXg8wfGVa6ux9v6SCGt1+bSDHjtJaxqkgRoudvbNGiqh1KrNP5v6Pa5dO2w5t3iKM1VX45ZNOWzc0x950thmWMEs2yQMo+3Wnuk9ApL1rnVRH3Dp1KeYnrw7bDSruY3mEVOYW9jnGkWLhK7WOQ5O1xxwJLIKRFknLtpcQZkWKoacCVPcKATC9ktwVFuKdWmy62qyQf2wCMjLrE6p+sEUUiE7rmEOwyV5OQCJr4CGjH0nvvG7q++w8hyfYJ0+7A2unZT1p1JSc5zIs59xqWDNHVR+KaYySkNZI5Ud35RUI5Gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(53546011)(316002)(5660300002)(186003)(55016002)(26005)(83380400001)(44832011)(86362001)(66946007)(66476007)(1076003)(8936002)(956004)(8676002)(6636002)(7416002)(2906002)(9686003)(6496006)(52116002)(478600001)(4326008)(66556008)(16526019)(33656002)(33716001)(6666004)(6862004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9aU4TEASyuzxhWjU20W2mm60Dk7AcO71N/7YXi8aGctMGZa9rPSeO2tKak/m?=
 =?us-ascii?Q?ba7FKNiMOdjIn81KpPGHtU38CIA7S8rF6GyDcXim0U6suX6UsyJay1FBAE3a?=
 =?us-ascii?Q?Yg+zV4/ZlzM8K9F9sooCzKRWloxUPJUXzbsUWTknTukOGcff+R4Q82QVd28W?=
 =?us-ascii?Q?pUxiC71kGNHYf/ZiMIVmC3YHBY/oSN09tNM8j5U2TkFRQtPYoSmfh5BA+Feo?=
 =?us-ascii?Q?YjTGTDlZsgwJChiUS24DTl/dsL7jul8DPsqni0xKinjp0riQEdyCiJgMoPA8?=
 =?us-ascii?Q?AOVoYEiM2+yuK+PSpmSiBWUuwDH4oaQC+6FvOyR7nU6a5/LVVUwuLRhd6+Gr?=
 =?us-ascii?Q?bidgUIQ3wM6VpE1Tqc1hIWfsq1sxf2AqoaELJiAYU97Bl0OouOgyUohW76F/?=
 =?us-ascii?Q?NlIOcfipntc+jqFCX0p5+dp6wRbCjkwrG7oZa6omUyiDTiN/QZBBCOrq7GvF?=
 =?us-ascii?Q?34jU7dm66hfYOTTNaa4obUn0m9XG/Jy0M1RkSgCU0MYIA/oONHVpwhDTDbgs?=
 =?us-ascii?Q?OzvylW1KSj7KHr6MzRSCFuncYLubiRmEh8xiD6BDui7pt4HtkSV1VnoTfZFc?=
 =?us-ascii?Q?9A2giHPniNSy77RH94MuwYWDWl+jVX46MQ+Xq4SUKP4qu9ntQzq9EZJBwU+O?=
 =?us-ascii?Q?I8JmASXu4QnNj7keSFn0D7Mo8GftngI+zkd74d55TRR/Emy0AvfMj7ZbS77H?=
 =?us-ascii?Q?f70VbN4JMXk/Y7/6H2yhoz7l0YLcNYOIfUTQ2NpiFbkaSBv0mNapMZ0w06UT?=
 =?us-ascii?Q?TMJ+sZPZorjBi5O41+olJpyjCnFSc7Y8BOxc3kE14x/j94lkbKGRveGc4/oH?=
 =?us-ascii?Q?Cb8t/1m5OORHe8rjidk/cyVOVlutbZv1w+f7UxglflEUGLETe+VpjMpEtO0Q?=
 =?us-ascii?Q?Z8Qb/77qPEW3QDpGPOF3orKzXO6HPo15cMgIBykKXUCmFgZDqg25ShK/utkC?=
 =?us-ascii?Q?nTP70KR4RqZOVZANXe7IX+xzzOgfH6J2LG1RLXAjn9i1Box/OM3Qoqtn9KEz?=
 =?us-ascii?Q?UkjCQoSWNKfEuZel/rvJy7wL2l5myNzH9eT70ofXefTVMs+/b6PZS74QDD9H?=
 =?us-ascii?Q?JwzgxkheW3pjpQ6TXkq5bv2ZcFEfSe2lkoQCceN/bgEzA8qTvNpUy0/YtUaP?=
 =?us-ascii?Q?QOPus87aOQwbpKmhHL6EJnypVg9nuRBb+WcmD8B6/Gvkk1cZOXcGf5lJxm1E?=
 =?us-ascii?Q?h7FJ+a3gDcjpLusAI/+er4OiIxX/XHXpe7kBTrpKQ9I193LavtQe44soB7Rp?=
 =?us-ascii?Q?9APGezSMtp92Skg441FILpNuUkjoDNHw9zJOwWobSRbUwt2Pb50OzeCqplVU?=
 =?us-ascii?Q?g0CGz+2tnEWerHOXB0J7KCen?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17f96608-6910-4988-3f8c-08d8c92acfd2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 16:34:58.7366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VPpT8FvpmWnbLxYF04Gu9EEYqcteBMpZ51PVUbwQA+cezUZwzHU2PvUGiynTHgOMje5HqIk1/lM0dMezLj28Kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2416
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Tom,

On Thu, Feb 04, 2021 at 10:14:37AM -0600, Tom Lendacky wrote:
> On 2/3/21 6:39 PM, Ashish Kalra wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > The ioctl is used to retrieve a guest's shared pages list.
> > 
> 
> ...
> 
> > +int svm_get_shared_pages_list(struct kvm *kvm,
> > +			      struct kvm_shared_pages_list *list)
> > +{
> > +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> > +	struct shared_region_array_entry *array;
> > +	struct shared_region *pos;
> > +	int ret, nents = 0;
> > +	unsigned long sz;
> > +
> > +	if (!sev_guest(kvm))
> > +		return -ENOTTY;
> > +
> > +	if (!list->size)
> > +		return -EINVAL;
> > +
> > +	if (!sev->shared_pages_list_count)
> > +		return put_user(0, list->pnents);
> > +
> > +	sz = sev->shared_pages_list_count * sizeof(struct shared_region_array_entry);
> > +	if (sz > list->size)
> > +		return -E2BIG;
> > +
> > +	array = kmalloc(sz, GFP_KERNEL);
> > +	if (!array)
> > +		return -ENOMEM;
> > +
> > +	mutex_lock(&kvm->lock);
> 
> I think this lock needs to be taken before the memory size is calculated. If
> the list is expanded after obtaining the size and before taking the lock,
> you will run off the end of the array.
> 

Yes, as the page encryption status hcalls can happen simultaneously to
this ioctl, therefore this is an issue, so i will take the lock before
the memory size is calculated.

Thanks,
Ashish

> 
> > +	list_for_each_entry(pos, &sev->shared_pages_list, list) {
> > +		array[nents].gfn_start = pos->gfn_start;
> > +		array[nents++].gfn_end = pos->gfn_end;
> > +	}
> > +	mutex_unlock(&kvm->lock);
> > +
> > +	ret = -EFAULT;
> > +	if (copy_to_user(list->buffer, array, sz))
> > +		goto out;
> > +	if (put_user(nents, list->pnents))
> > +		goto out;
> > +	ret = 0;
> > +out:
> > +	kfree(array);
> > +	return ret;
> > +}
> > +
