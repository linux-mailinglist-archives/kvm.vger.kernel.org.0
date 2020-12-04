Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DB12CF666
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 22:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgLDVrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 16:47:53 -0500
Received: from mail-bn7nam10on2066.outbound.protection.outlook.com ([40.107.92.66]:54241
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbgLDVrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 16:47:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8UeieoL1g5zTvtjm0WThHcx7ahUMtZgmngts8m/wt1ISQqyWtMh91ffAjig5kJRNWxrYFTxP9OVjKNlkKjuQNcZgBc8V50qcYp+1KnLsx5LL7D6MsF/G2ZT7sKpXKhA4HSwbQoDeBAjm3FYYlCJeGIL4+/8XwMcgaQxmSgikaJRtqSHYFLC4PF1/O4JwWkmC5y2+gSeTVynL/M3vjp4ZAVKiQhIHhAkqtSoLQWzFRSdAoDfwKGFCaJFQ09VDCX2N09XfGzYU16SF5eiy7Sa5xxYbmdTobPmYI8H4UItvZ4vatlO8ppAh2RATUVS5uQ8lwM4YSTvZaRRpGIGElLKiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIS/XuBtnNajztP6lsKvp1S1cA3sjSm0YqFIqffCUpc=;
 b=M65yr00MoVCcCvEKNjSzKV993AKq5GQl1lTbNY/ak9vkJbuUS8XczjhJlcXY1SLSd/bxWcFmcwEFO7wxqJF3a7P/CjRL/q3jntUNwU956CCQBS/2LzIRJ0frdTvbd5P8Z9ScIA/4r0E7GWN5yzs9cS2t+YnHmEI0n2coNDj9QWgb848Btc5Ge9Gc7tulhF6ovJ8mOlUfWfx4nUwj3dbqLqiI+XV8EL5YcoIs1bK0EWG0FvPkKq/GvM+cd7divcJV/E20rFg8VRrcfdfOrsrUGe5RXmmn4ANFrfAPjcqMkLna6/HhWd5KzvBrZQwgXoOZpzAPs7+5tKCYUDyIcEC9CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIS/XuBtnNajztP6lsKvp1S1cA3sjSm0YqFIqffCUpc=;
 b=q+5gqQbWKqaxFK6kC7iafJEf5A8yLZvhqHEWxHnzF9jthc9dw79/vFW7F7t1QTrdIirIeKCgk+Dmp5gtqIViOm+eaYIOvLJuZrOS04X+OWmDRvpuL2vPllpzW/i7QO0BkbQOPQ38uHCFgYbTXjfvqg75Dr7fh+qPWywDRKx6kCc=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2446.namprd12.prod.outlook.com (2603:10b6:802:26::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Fri, 4 Dec
 2020 21:46:59 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Fri, 4 Dec 2020
 21:46:59 +0000
Date:   Fri, 4 Dec 2020 21:46:56 +0000
From:   Ashish Kalra <ashish.kalra@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
Subject: Re: [PATCH v8 18/18] KVM: SVM: Enable SEV live migration feature
 implicitly on Incoming VM(s).
Message-ID: <20201204214656.GC1424@ashkalra_ubuntu_server>
References: <cover.1588711355.git.ashish.kalra@amd.com>
 <a70e7ea40c47116339f968b7d2d2bf120f452c1e.1588711355.git.ashish.kalra@amd.com>
 <7a3e57c5-8a8c-30dc-4414-cd46b201eed3@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a3e57c5-8a8c-30dc-4414-cd46b201eed3@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN2PR01CA0075.prod.exchangelabs.com (2603:10b6:800::43) To
 SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server (165.204.77.1) by SN2PR01CA0075.prod.exchangelabs.com (2603:10b6:800::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 21:46:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e36521a0-6a42-493f-70b9-08d8989e2053
X-MS-TrafficTypeDiagnostic: SN1PR12MB2446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB24465F764549002FBDF02C5A8EF10@SN1PR12MB2446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w9bQnxvzeR8dZSGYS+squLqsO2KNEwrN8ZFeMepo4lOTx7D5JlnXWD9q6bYXtd2jB8VK0z2oWnDxNBengRvatIJFDd5eSKNCUhccsUCWyyZN6DvqBh00KPDcanOR22ztN9k/u26dp1IXjY6fQ0CvPNSrvFVC3oXSu6sd6LUiU6z7vBJDyxXzj90PCqVTtRJQBH1CMUIHdwv9zwsHc2DV4TwKFAhnDu1NrMPZqVM4oXC+TZRcfRAK465hKvJ0tP50T0IPTTyLOO2bpju5UBAAzEJ6vdslnKrRc6XIOX8JbydXHrl2jtxfw7VaXGjHFO8MwbHhQFsHbz0vIBhgqEDiEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(9686003)(956004)(8676002)(8936002)(55016002)(4326008)(316002)(53546011)(6496006)(33716001)(66946007)(16526019)(7416002)(44832011)(186003)(478600001)(2906002)(86362001)(52116002)(5660300002)(6916009)(1076003)(33656002)(66476007)(66556008)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?g09HWZyhbT7ml0M4aWT8fABUD2kEjdUA7a4NaMyKLyWZVrebImNkve5ljNpG?=
 =?us-ascii?Q?Ie4saYSW4Y4s2LkndCyhPO95JMGaiRWcQTslNJ8Fpid2Iwee7tZ9SinMTY1u?=
 =?us-ascii?Q?C+szd41oJ9Kg4mecnkFrJpDiSJ3DKVQxcz8zjOgPAZCgx1RHmsjf+SUeXhTT?=
 =?us-ascii?Q?SCk+975rI5txL5vDf7glLZUi0h1zO4LcMxGtWbFPoy7UEFdDkRNtqn5R8OAN?=
 =?us-ascii?Q?l9iZtsa7RGkS6W8uMXXRa1WbrYc64Gtx3wka9IfP/TIRcZjlEuEcFLAvuZHz?=
 =?us-ascii?Q?i6Ofkr+wLecJWscp6FF1z4HTkhmmhjBd93N9qfuyLSkZXC5SHEzE0BUuBBPK?=
 =?us-ascii?Q?OCUvigII+4hgeM1DeeyNZjdi4fXaxaQtlKJRy/7pSf3tt0dbpH7E6IA27xbV?=
 =?us-ascii?Q?vqXtfYtnmi/FzGcZaJhi8Pn7NmfaSYt2HzsynQlMU8qTdapFyUJmn2H/PR0Z?=
 =?us-ascii?Q?FnSu+4mxZf8YifzYoGTzTqaAsp9LV72T4B29eyKymEXFCtTM4QxzJsU/o6HY?=
 =?us-ascii?Q?kMFAq0E/BMjGMlARBkDIH3WqUlVlGDLLQwUl1/IVpCMEeQyTHk9XG/Woxfcf?=
 =?us-ascii?Q?pCQIVlbW4T/YHmjkGsXbd/MtUbenHTxoB2uGwskPskBkXqY/uPaklE2Zgrb3?=
 =?us-ascii?Q?u0gIOlkwnrpdgVMEznvlhxj4NKgLZlSy/1Kg3t7hlZxVg+hl5ggjjhOTs4pl?=
 =?us-ascii?Q?0pJ3nSsoEEkQxM5f3xhKYr0CopuYzpVUazoOSMlmRsK+wmAVyX/hvBDsebqp?=
 =?us-ascii?Q?gnN3njrdS74D6bWMhMDhcRVldr5eueBtg2wK72Ms1061+aJlShqJeDwXuXt2?=
 =?us-ascii?Q?vKgEKjaDCQFs9VJuhjCcS987gE0Et6LrUc18ZGVJyQ7XoLk4MkJu55HJ2F44?=
 =?us-ascii?Q?UGchlzNBRSRAiMsHshO5DcvQU3qrFYO2a21IvcuQJPLLJI0cLA+/2BQLGW6l?=
 =?us-ascii?Q?fKO2fI3LxyT41qMv7kHTLc8KnvIXjb4Jikr6xB6tPNmHkoj5BF5AGM+P90pw?=
 =?us-ascii?Q?Napf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e36521a0-6a42-493f-70b9-08d8989e2053
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 21:46:59.1706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BhOql5Ryo9sh7iJVSLHNLH0UUij1p5OfQzlmIKo0p0fcObnTzAxHI1boqfnZXAZy2OCDLdoFwXYUNitK3Dy55A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2446
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Paolo,

On Fri, Dec 04, 2020 at 12:22:48PM +0100, Paolo Bonzini wrote:
> On 05/05/20 23:22, Ashish Kalra wrote:
> > From: Ashish Kalra <ashish.kalra@amd.com>
> > 
> > For source VM, live migration feature is enabled explicitly
> > when the guest is booting, for the incoming VM(s) it is implied.
> > This is required for handling A->B->C->... VM migrations case.
> > 
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > ---
> >   arch/x86/kvm/svm/sev.c | 7 +++++++
> >   1 file changed, 7 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 6f69c3a47583..ba7c0ebfa1f3 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -1592,6 +1592,13 @@ int svm_set_page_enc_bitmap(struct kvm *kvm,
> >   	if (ret)
> >   		goto unlock;
> > +	/*
> > +	 * For source VM, live migration feature is enabled
> > +	 * explicitly when the guest is booting, for the
> > +	 * incoming VM(s) it is implied.
> > +	 */
> > +	sev_update_migration_flags(kvm, KVM_SEV_LIVE_MIGRATION_ENABLED);
> > +
> >   	bitmap_copy(sev->page_enc_bmap + BIT_WORD(gfn_start), bitmap,
> >   		    (gfn_end - gfn_start));
> > 
> 
> I would prefer that userspace does this using KVM_SET_MSR instead.
> 
> 

Ok.

But, this is for a VM which has already been migrated based on feature
support on host and guest and host negotation and enablement of the live
migration support, so i am assuming that a VM which has already been
migrated can have this support enabled implicitly for further migration.

Thanks,
Ashish
