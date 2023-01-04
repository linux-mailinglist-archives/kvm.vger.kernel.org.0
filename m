Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014DD65E31D
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 03:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjAEC6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 21:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbjAEC6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 21:58:12 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E02B8479E3;
        Wed,  4 Jan 2023 18:58:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NlONjvqkKQv8XY1CPN1tTyIyKagmniPof2bd78su6R5nDUxjqTz1QnTlU5O/4Mv7ziskgwnaf2LyUxrAJFAl4Am04I3q8zOyMJwyxzIahdAKc7xzx5ZdB4zqE/06Glwx1wQgR0NqblLJ48qc0rK75d+OPeVI6BGtPtLB/Ds0JScTsObhaxU4T7CrajMjboe0/SpnvCAMsdBlOzITGMGktOh4e8OLVJRlgfwet5g42rXA4HWGM8ZzKH4ZTedrOGGhiMPKFPKa+kb58f6Z+z28zhiTbhDs/kfqzXzdlLroJdvOrs0Q5YoUvKagRox0CSwRZ0Bvwyj4TETbZmS6xpD/WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQIF1KE6BTUaMiGdzQysclvaDfnDaICkGTBIQBKa5ho=;
 b=WHGDx12VvoXNXSjrmpyiG0t/dtETe6Za1ZOJrg34BR42iC+XU0JEGFLIj8BEkC/GT/KaI4C14hRdcxnTUFqStOAkAAfLJJ1NYDQobym0RSsbCMPdv11dsGBXopclY/MsrrQq81Y7mNuIOImtRU/Z1zkWUcW8RVicOz+j77g3lr4uUmLmoUCtRL2TB7+dUCcMuPN+pTm4l++LHZc/kDffxK1xN5NpPgg6njcYHSDv4YZaKG5elUOQCwEc1SqBV4tM+agtt+3jbWJyMbun0Us+ProjtIIxRbRwE5ZH07KLrNjqQgJy0885CzO1W0T7o8hWXJGIvk1ud1YoH7Kvjt6u/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=alien8.de smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQIF1KE6BTUaMiGdzQysclvaDfnDaICkGTBIQBKa5ho=;
 b=NJvKOGGNQKUqx1E1tDfRYxr1OwJViEU9rLWd5lE9+IEpoU4TUY9PujFsNq2XwP6Vm3C0U0IsOApscrPaIZ32H66p9vPYmXAgQKdmcMND8SCphRfuMNRI8ZrIB+jPLMabcVyW9fnWICRt4M+iTsjTlv8XuQhIaPR8j8w8MZJJNtY=
Received: from DM6PR02CA0161.namprd02.prod.outlook.com (2603:10b6:5:332::28)
 by BY5PR12MB4035.namprd12.prod.outlook.com (2603:10b6:a03:206::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 02:58:08 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::4b) by DM6PR02CA0161.outlook.office365.com
 (2603:10b6:5:332::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.14 via Frontend
 Transport; Thu, 5 Jan 2023 02:58:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5986.14 via Frontend Transport; Thu, 5 Jan 2023 02:58:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 4 Jan
 2023 20:58:04 -0600
Date:   Wed, 4 Jan 2023 11:47:21 -0600
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
        <ashish.kalra@amd.com>, <harald@profian.com>,
        <chao.p.peng@linux.intel.com>
Subject: Re: [PATCH RFC v7 02/64] KVM: x86: Add
 KVM_CAP_UNMAPPED_PRIVATE_MEMORY
Message-ID: <20230104174721.wa4detzppqzvsgsy@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-3-michael.roth@amd.com>
 <Y6RM8RRryLgK8KiB@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y6RM8RRryLgK8KiB@zn.tnic>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT015:EE_|BY5PR12MB4035:EE_
X-MS-Office365-Filtering-Correlation-Id: 47bdd82c-df2a-44f8-0a52-08daeec8ab2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kCOQgjZDnQhfuwNkG9++PRDW42pQR8R5M6oLrjdn6wUUVXZPy+Wa5xpDmVXSwwNHBjbvv14drlr2kzFnUCYGSuv8aDik239qJ/OFxjCsCcrDq89bY5sGR3XlddI1DfsvTbGGFXeMsf93UacvBETQnKBBA3rhOS/+RuCd896tWg4FATLOUbSRgj8UFixu0GpU8jhFdMk1fjZM67HpLA00DbY7mBKbd7exz5SwSEm586bsSCbGFeIm5ltYQixirx55BUkIH3Z0X5zbgL/U1m9xf7oxfArL6dmu5XyJ+ds0HwU7T0B+gKYMXAMVsyWWu/0Xymt58+dhHSKeo0EAaUmeW4kEV3iQmNpkleCYMrTvAWzt4/UeHXIiSIc1Xz/+HIGUDnrZqQiYlu3lPqEMcgLzfzqNRDU+lWhdoaEuTtfKbOVKt1LTjsBlHa+PNwJD67P06tMUeLQheQJKRfm+qslz7T9PFKBS9Y/2EIwMG3KkJZE0cbPMrq5k1gqKscHpY84m8DeM/k8bjSNWLNdxRw6AV606kMkKBGW6P1essMFkM7t7LS6hgTi8HAhKJVziQ/ClZ0tXRKcy03NVZ2CbYXqznDO8xwLCOJeTNrQDbpfknuC7uS7SoDzlI1FJivMjF2Oh5JS4cdEyeJSwwA/+ZnGH8Ow0S83eySWY3kV7f61eyBdxLQjq1wOxEAnbZdcMpK54wN/E+PKk7SUwGAyOASVn4V8aRnzdwAm+02NCBzFL7cpYadI5jn+nCsVKMJYZXUDshdDYksKulhrpBN656cu8Zw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(7416002)(5660300002)(2906002)(7406005)(44832011)(8936002)(41300700001)(478600001)(4326008)(316002)(8676002)(66899015)(70206006)(6916009)(54906003)(70586007)(45080400002)(966005)(26005)(16526019)(6666004)(40480700001)(336012)(82310400005)(426003)(47076005)(1076003)(2616005)(82740400003)(356005)(186003)(81166007)(86362001)(40460700003)(36860700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 02:58:05.8381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47bdd82c-df2a-44f8-0a52-08daeec8ab2c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4035
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 22, 2022 at 01:26:25PM +0100, Borislav Petkov wrote:
> On Wed, Dec 14, 2022 at 01:39:54PM -0600, Michael Roth wrote:
> > This mainly indicates to KVM that it should expect all private guest
> > memory to be backed by private memslots. Ideally this would work
> > similarly for others archs, give or take a few additional flags, but
> > for now it's a simple boolean indicator for x86.
> 
> ...
> 
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index c7e9d375a902..cc9424ccf9b2 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1219,6 +1219,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
> >  #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
> >  #define KVM_CAP_MEMORY_ATTRIBUTES 225
> > +#define KVM_CAP_UNMAPPED_PRIVATE_MEM 240
> 
> Isn't this new cap supposed to be documented somewhere in
> Documentation/virt/kvm/api.rst ?

It should, but this is sort of a placeholder for now. Ideally we'd
re-use the capabilities introduced by UPM patchset rather than introduce
a new one. Originally the UPM patchset had a KVM_CAP_PRIVATE_MEM which
we planned to use to switch between legacy SEV and UPM-based SEV (for
lazy-pinning support) by making it writeable, but that was removed in v10
in favor of KVM_CAP_MEMORY_ATTRIBUTES, which is tied to the new
KVM_GET_SUPPORTED_MEMORY_ATTRIBUTES/KVM_SET_MEMORY_ATTRIBUTES ioctls:

  https://lore.kernel.org/lkml/CA+EHjTxXOdzcP25F57Mtmnb1NWyG5DcyqeDPqzjEOzRUrqH8FQ@mail.gmail.com/

It wasn't clear at the time if that was the right interface to use for
this particular case, so we stuck with the more general
'use-upm/dont-use-upm' semantics originally provided by making
KVM_CAP_UNMAPPED_PRIVATE_MEM/KVM_CAP_PRIVATE_MEM writeable.

But maybe it's okay to just make KVM_CAP_MEMORY_ATTRIBUTES writeable and
require userspace to negotiate it rather than just tying it to
CONFIG_HAVE_KVM_MEMORY_ATTRIBUTES. Or maybe introducing a new
KVM_SET_SUPPORTED_MEMORY_ATTRIBUTES ioctl to pair with
KVM_GET_SUPPORTED_MEMORY_ATTRIBUTES. It sort of makes sense, since userspace
needs to be prepared to deal with KVM_EXIT_MEMORY_FAULTs relating to these
attributes.

-Mike

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fpeople.kernel.org%2Ftglx%2Fnotes-about-netiquette&data=05%7C01%7Cmichael.roth%40amd.com%7Cb019ddcb34a74fae1e3e08dae417c322%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C638073087997837943%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=QRyV96y3drt%2BqwxfifWzJ6UF6te8NOKWAFuGAYOdKcg%3D&reserved=0
