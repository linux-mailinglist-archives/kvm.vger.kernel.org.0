Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A54665E325
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 04:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjAEC7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 21:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjAEC7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 21:59:24 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2074.outbound.protection.outlook.com [40.107.100.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A1D48592;
        Wed,  4 Jan 2023 18:59:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W7oiJ+WKU50PVygZq2ClcEPqweeC0z5objF2qLn3hXp0PshdZouaT5JVukdzyvgmCHVY13bHWWzhizDbaYv0+IyTBXmmU8btB0QmZ/vrS/Ff+7Hf2sbVh5Fo3KpEIV1Yx8wbHGmHCdJDgk4hhoaOmfQTJIyBFLe+OaBFxVUN2mFJ5C+hUwTEzK7LPqifTR5Pv9XnqEAXCClJWAcfrgjAxCtLLpibYp+bWsXrEHSUQNPonFTUjZUXdFWPfs21e/KJlxdP3HqWrwtb+G9PzZZkhEELcisy/6xRpXr4RyrqdwMhW2hq16WuzBmvmkR95s8qf56QA3ZrO0a0bso/6OxXCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7y3u4FaSuWfbEjaZTQrA2ZIs7oP8Hf+prsDxnArvWw=;
 b=FnR+kC5W+pvWgzBNaImWghCUEJ58xDU1zDw7soWo6D61E8AA+RQGcukaVIPK21w0e3iRoeZdwIPmX0FX2QNDoJOZWpj2kcc/AL4mSenn+8h/si+KWwPtGpYK+xhH53UTJMBeyjnxuYPhjj1Bn3Si/DvkydBWp/WnkeFFlOy4H1EQSmpYWFw/Cz/dKsbX0vxdoqwYyYHlgM4++9JHkWwirXKSvp1mep/MX7CcIv4zdvp9tUeijZ8wwEVOdaVmdXINuZr16q9uW6L6F6jOPQWTRF5UT0/U3lE5DlziziRWRN/l6il2t/bOFOGtQnRhdjUBIgtovwdLFOMES6iQCtyKNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f7y3u4FaSuWfbEjaZTQrA2ZIs7oP8Hf+prsDxnArvWw=;
 b=lnk9Kw3hpWWEH7CCNNoT3j+dVP5BndeOFgz1NIVfiUYQsPf1n4tb1HSiNyXXopEu3JK96GjYLWs18u9ut/gcIMugXUfZB+auieRg30EBt0Zzezk2h3MAi4mbsD8X9lNGwUCUQMEOUJkaSK3M4kp7s8EwfZ9Fe7/VytBb37gIGHQ=
Received: from DS7PR03CA0107.namprd03.prod.outlook.com (2603:10b6:5:3b7::22)
 by DS7PR12MB8348.namprd12.prod.outlook.com (2603:10b6:8:e5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 02:59:10 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::53) by DS7PR03CA0107.outlook.office365.com
 (2603:10b6:5:3b7::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.14 via Frontend
 Transport; Thu, 5 Jan 2023 02:59:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5966.17 via Frontend Transport; Thu, 5 Jan 2023 02:59:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 4 Jan
 2023 20:59:09 -0600
Date:   Wed, 4 Jan 2023 20:27:14 -0600
From:   Michael Roth <michael.roth@amd.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <vbabka@suse.cz>,
        <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <harald@profian.com>
Subject: Re: [PATCH RFC v7 06/64] KVM: x86: Add platform hooks for private
 memory invalidations
Message-ID: <20230105022714.kdpybcse24xi2lq6@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-7-michael.roth@amd.com>
 <Y67RO+YnQYSX4mvN@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y67RO+YnQYSX4mvN@zn.tnic>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT053:EE_|DS7PR12MB8348:EE_
X-MS-Office365-Filtering-Correlation-Id: de074cc5-1f10-4934-8336-08daeec8d13a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 22mSseEs/AJTIcy/oUab6p5YwlO0w4LKCZNgsYBTImhEj6Q5oTxVW95CN/Qar5vpfOGUWgiIJrM819W/NSBLHpStUf1SCdo5BbmbldgOutXkzNykZMxbFv6pFWQ3Iiq5iNcJA9jdFzg4G2hCXtlcZV0li1u+td8e8WZbUYMEdTLCeZY5o+GHabtD72D1tzcMTkWNFCb4O5T3R1NMTh11WC55DQQKx/PIk99hhy8FeUEj1JM5rEXFNEERfpah+lbyrv3JOQoeJfZUt9ujam+WBL2k4IcXYLg8WKGgZsp+4yaLNcTOU8qdDbIhLjSD8B/By/ENx6NGRSVq8GsXNhW9oalsMTbU3HcI4Aup1+XEUvGwO49dk7bWcomKcpayygBie2zqc+XdW83w6VkcOTJl23p0N7wgF9zMtourk5GTKuLODPEavzj1xWlQUGpGozlXFuR419DHTVx3dpvP0qwIxRttLDVT63k6CuTV854/S32a4hy/MEj3BFHmjnJVwoM+Oy/JHUxKBxlLfYkZgg7Na3Ol7sSn35A1h9Nhhyl1SgpV6ZvzKu8a0O8zu/6cjFHs+evrOUyclyRGDVEeZ+wjDNpl5t8wNIzsogGe5EJD0rdEszi0r90PG65Cb9+Lpt0WmNNy6ton11d04yBqhGktDawnVEoWF/dfAJ0D1T5P8zP7PspfQ2hWKefJ/Y/fYWlBVQNVajOVvdi9A4aiZeRMWlt5Ciu/oK0FuW8oFeX/MSiBESsz/suQ/QGStsnY7fRX6PbTUGDR4ib8Q6tL/KhZQg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199015)(40470700004)(46966006)(36840700001)(47076005)(426003)(83380400001)(40480700001)(26005)(16526019)(2616005)(1076003)(336012)(6666004)(82310400005)(186003)(40460700003)(36756003)(36860700001)(86362001)(82740400003)(81166007)(356005)(8676002)(41300700001)(4326008)(2906002)(5660300002)(7406005)(8936002)(44832011)(7416002)(478600001)(966005)(316002)(70586007)(70206006)(6916009)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 02:59:09.6708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de074cc5-1f10-4934-8336-08daeec8d13a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8348
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 30, 2022 at 12:53:31PM +0100, Borislav Petkov wrote:
> On Wed, Dec 14, 2022 at 01:39:58PM -0600, Michael Roth wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index a0c41d391547..2713632e5061 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -7183,3 +7183,8 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
> >  		kvm_update_lpage_private_shared_mixed(kvm, slot, attrs,
> >  						      start, end);
> >  }
> > +
> > +void kvm_arch_invalidate_restricted_mem(struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
> > +{
> > +	static_call_cond(kvm_x86_invalidate_restricted_mem)(slot, start, end);
> 
> Why _cond?

Since this hook is declared via KVM_X86_OP_OPTIONAL() (instead of
KVM_X86_OP_OPTIONAL_RET0 like the previous hooks), the comment in kvm-x86-ops.h
suggests this should be called via static_call_cond():

  /*
   * KVM_X86_OP() and KVM_X86_OP_OPTIONAL() are used to help generate
   * both DECLARE/DEFINE_STATIC_CALL() invocations and
   * "static_call_update()" calls.
   *
   * KVM_X86_OP_OPTIONAL() can be used for those functions that can have
   * a NULL definition, for example if "static_call_cond()" will be used
   * at the call sites.  KVM_X86_OP_OPTIONAL_RET0() can be used likewise
   * to make a definition optional, but in this case the default will
   * be __static_call_return0.
   */


> 
> > @@ -258,6 +263,17 @@ void restrictedmem_unregister_notifier(struct file *file,
> >  				       struct restrictedmem_notifier *notifier)
> >  {
> >  	struct restrictedmem_data *data = file->f_mapping->private_data;
> > +	struct inode *inode = file_inode(data->memfd);
> > +
> > +	/* TODO: this will issue notifications to all registered notifiers,
> 
> First of all:
> 
> verify_comment_style: WARNING: Multi-line comment needs to start text on the second line:
>  [+     /* TODO: this will issue notifications to all registered notifiers,]
> 
> Then, if you only want to run the callbacks for the one going away only,
> why don't you simply do:
> 
>         mutex_lock(&data->lock);
>         notifier->ops->invalidate_start(notifier, 0, inode->i_size >> PAGE_SHIFT);
>         notifier->ops->invalidate_end(notifier, 0, inode->i_size >> PAGE_SHIFT);
>         list_del(&notifier->list);
>         mutex_unlock(&data->lock);
> 
> here?

That should do the trick. Thanks for the suggestion.

-Mike

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
