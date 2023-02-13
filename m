Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D56693D29
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 04:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjBMDxa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 22:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBMDx3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 22:53:29 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E680CD500
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 19:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676260407; x=1707796407;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=upHF+LYcPhcL0GYssf5ddsL8UQ5LLKyeiM4pkXAIWkA=;
  b=I0Qzd0walZGfoBiX0jiCCXwyFNrqOsBHyh93H1C3UD7gsZVi0j+VKF1T
   /LrKTCnglNoZg44+Dw6t0UqlT5bbFhp2282Zg5pocD+P1Y6RgfCpJwE6A
   PbDTdT9jHGC4gP9p/EYnHDHWeHghWgb6HMnyNSs1bzt+zYf20GFi3qtZG
   x6lcCsgJGBGZNV4Dj7RwYPIOf8T3Y/VhR4P2B1yCuk3LXXngNqZ1hneHH
   RkDL0EASnFUYroQyLrKyItzhBAUJwifLRdMfVRGW9XzBeTi/97Vf2JdJX
   7LRR6FJ1MgFKDXlsUsQ5Yev73h7cjDCSzHNZXtlhCnhm6nrvrL+7kKgsr
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="332108485"
X-IronPort-AV: E=Sophos;i="5.97,291,1669104000"; 
   d="scan'208";a="332108485"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2023 19:53:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10619"; a="757413150"
X-IronPort-AV: E=Sophos;i="5.97,291,1669104000"; 
   d="scan'208";a="757413150"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Feb 2023 19:53:25 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 12 Feb 2023 19:53:25 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 12 Feb 2023 19:53:25 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 12 Feb 2023 19:53:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMCUr4Pxs0HGMP+ZgeBFAcpb0YW7BvlU9j7cj/KOsb8hppetSuuKOcKme8BWYdPCsc9dbadBXf4s23ndjuxw+HnJTq8Fda5yIrn2fnpt9wS8IYgfEiHiuI2pgoT7vz8Efxr+XPB0qblOL93oysDoTUBaXU6jNdzhvTD8lSLEemDuLYy1dKpFYi8N33dOILGM4NjDDqer17giCcJczdSDlDr3DNQ9cMs00xTIf9qjGqWinrisOs1mRNNp/H8O2N9uMQsOqxe7419yU3K/+nQ3TBvlCXySt7TcFxiZeRPSQR+0ySMHhQ7PEjmFPhifN4n3fCsn3zLZD4bDEI8WKvE6hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hB/cna09+DSQgfd1KUVCUXvInIEKXQCzlmavzhUVTOc=;
 b=BzMyvrJGh3b8u4x1pRcE1xO/z9lmXDsMgo+mkNzpJoKGhXkSBt/va6kA+hgXe16qFsqiaUqnONdOvSzwJflLq9zxmYtsPO90dfJbP4/VxxRPNmIfy7mAs5Dr+Ut3YuCoUq7u7bb9i3wfK7erHZ+h6myVqBYpnv53oZOM2Jtkd3/29xkISyG0IWxbLN0xNvdi3XJ42+E0Z96QfwC656WRiIyeqnqJ7Jb+8h482t25YUglElIbvqZrltDkUrI7a52qduCJN/2D4blbsjp45iUVIvwhpA8CVHYW7yXieqoYBR6Xxgv8VilxLwrnSKqeWxbgmdjrG+4RagxJ+vKrU4ZNNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 13 Feb
 2023 03:53:21 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5cb1:c8ce:6f60:4e09%8]) with mapi id 15.20.6086.022; Mon, 13 Feb 2023
 03:53:20 +0000
Date:   Mon, 13 Feb 2023 11:53:37 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>,
        <yu.c.zhang@linux.intel.com>, <yuan.yao@linux.intel.com>,
        <jingqi.liu@intel.com>, <weijiang.yang@intel.com>,
        <isaku.yamahata@intel.com>, <kirill.shutemov@linux.intel.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 8/9] KVM: x86: emulation: Apply LAM when emulating
 data access
Message-ID: <Y+m0QToEqlqQz/ba@gao-cwp>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
 <20230209024022.3371768-9-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230209024022.3371768-9-robert.hu@linux.intel.com>
X-ClientProxiedBy: SG2P153CA0012.APCP153.PROD.OUTLOOK.COM (2603:1096::22) To
 PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|MW5PR11MB5811:EE_
X-MS-Office365-Filtering-Correlation-Id: 87126e28-c29a-4c9d-5247-08db0d75d8a6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qPlNcLTKX58UUcnHSJmAyIkpjWTvsZM9745Zpjt5MukZTmVVAZKBw3M44QnwpiK8/MYpHLVWQsAvq8nvUCHUgcgVJoOltiWbciO5/2FJ1aXncwUKfmDeVrbN69EgUSzUudHoGBzYpqxfXc98O5ad9FgHVP1MOQpBGHJnF1r+Ub0TdQFaxgF7GuZ5ZStIdKJ4wilxFbjFAaapQpZBku98XQfHve6aNHl6/mOHlrCMnPitHUau3fpdirdvNhY7qfJJy77T4exx1bsKa7L/iNOmOSC6/GMfVAMK404SCim64PNP6oZGoMSrl+/Oh2Xi5z6lqUV6RArYN10fApXxZAxAsFlGO0neTtW9Y9PBUw9AWMf4ANr00X5KeVGwjl2dVIB5ny1xu491ARy0P8wpsamWyxKw0ow8CZd1aLP1WV0ALou8wrqecVP++yg859GXSYrJOOMxpN1Mfq1dwsBLbQq57LYAh/CI8IB0SpgPNr3X+blUYCh2rp5xV5OHvNZnkJGle4skMOcPpzTWbl9tCv/5aNbMhy05hVX/ZKCkVc+86eXOJekt6kp4CoeF4m6JyJ40D2J3tlkPu2XRiwJqSizl2kWFT758S9isy5t4a3+tNbtqt7pPoYryeSlA1y66SmHMb2AtbuOlPWXDGxF7O26AcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(366004)(136003)(376002)(396003)(346002)(451199018)(9686003)(6512007)(26005)(186003)(8936002)(316002)(2906002)(38100700002)(5660300002)(82960400001)(6506007)(86362001)(66476007)(478600001)(6666004)(4326008)(66946007)(6486002)(41300700001)(44832011)(66556008)(8676002)(6916009)(83380400001)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A07Gh4fJIt6MjUuyHuafhQIpef9bgGkNpryjNJ5sLKk7cIo7zywUrUCQRDC+?=
 =?us-ascii?Q?YwcvoxDirCMsji62rdP//ONliOotp+JqngE1acThhcLIA0xDVD/E8hMWxMMd?=
 =?us-ascii?Q?GHcoY3jiqe4XbjQDeEilOtLJTqpE1XA80bPvClt8rugSKVrTZTDCmJdyFYpo?=
 =?us-ascii?Q?dDvtsqk0hyD7fawN5qOoIWkXlVQa4bsAhGpQIxR4m5j5zFIwd42CyZFNakMS?=
 =?us-ascii?Q?YJ0CjRmbV475X22y0DuZHarSDk81Mf8dXUI1iAIcci0k9aLE7fNjsABlv5Am?=
 =?us-ascii?Q?B2R6qeQ9Qm3VZfhcxo0qCyKChxa7/rib7EdMB9hMLJdYAZBI5MXWUN2ng0Y9?=
 =?us-ascii?Q?7V0Xobh9TtGSiASGgfDHuUqx/pdcahBTepwFi+BEutFNacHJ0JIMZ795wuC+?=
 =?us-ascii?Q?OQFr4NcLxGpMmqNJJbha9KiiQyNxH5V7IcyeYVh7fYTHze44Tls7pZg2iHkL?=
 =?us-ascii?Q?4Kc6PwkUVFDhb8VIH0bd6Yxby6LT6M2DkNhfV43aVtCZW4V6ENuehdw1uAzK?=
 =?us-ascii?Q?jipuUGGG6/CNvNUO4BjOqmwBATjxeFP+mzTr9VnoPHEZJQfRiN1NZPTVwJ7o?=
 =?us-ascii?Q?VuhpTONUxZ+ZoZyIsL1H+x9lh6H9YgyAgusIfa6vgvDR3tFfoZzzs5HwGIbA?=
 =?us-ascii?Q?yNRpAH2jhKdXwd+nn04tukFyyKhcv2xDbV6asEBLoKNLcbr0Tg+X5Q4buhZ8?=
 =?us-ascii?Q?EFH0kO8sfk/RmSv87FhQjlzPnihDDdw+Y2fLFWLzRAeQ+q55fGcpXmlzeu2b?=
 =?us-ascii?Q?afuB3W8aIcYOwWrwp+ehQHvuMnsFcuZ3WFwpPksorOWehEP2SbTpsV+AOQ7I?=
 =?us-ascii?Q?QnPlT8cG0ODTHLsVngMy5gYCSXIZFZeJpLd1A4vPoardHdEsu3ajrZwfjRaz?=
 =?us-ascii?Q?T1/XELlifxTn2MNEn7X82Et4CnLC+YSrd9blE9RSV1KKo0roLCCJM5zVA6pG?=
 =?us-ascii?Q?Zd39x5L7lQPS16Bag4p0DWvylsw5T2pdZO4KT3huU3vWETDrKtJQqx6WftyA?=
 =?us-ascii?Q?Ns3PMRJqxDQ4/T9Gn2QL6D/Q8lQGo0B5rLHMYohdrahLsbmdBWx6W+/3irGP?=
 =?us-ascii?Q?nwcCrlNnfNoi27xArppEvxBDIdJnqxBgnyE2w2OffVp6k3OmSRQT7pPOQGIh?=
 =?us-ascii?Q?ZJmmqyldKmtKl8fgHGHPvtAnZjE1sGzwZUfhuPRtKIVILtAQvufIXEQE73tw?=
 =?us-ascii?Q?xc+LEjnTJCojXYtQnde5s3PNmKFCx81GpB8hpVkSGKE4DQeHxgDLI+ghLRLl?=
 =?us-ascii?Q?Zq4swMPtfaUbB5XioPg3kuQfupCds5pSYkzxV5kw/WC5ACCTPSDJUvwJ1mRo?=
 =?us-ascii?Q?rZctTv961SuWS8hgo6t6zKL0/OftcgY1PuUNZH7hcFwMay+Zl88r0Jf4E3wL?=
 =?us-ascii?Q?IsBRjFo1+0kPUETiU/iVXzX6fgCR5aS9t3KH++y5sc4yzjx6f1vfCesQ+H2e?=
 =?us-ascii?Q?0l9sILm9+KO5JpA1V50sD2k998VY5gXzq8p/soK9syshjC/0XigBpFUeUYdk?=
 =?us-ascii?Q?Z1uguc+imHbbPVZ5Q8AN5sI+OIWzwRUuXMZzNdMzqfLrwL6YRpfH7s2KNU76?=
 =?us-ascii?Q?BF7HI8/3/fpoOUaSoGK+MusOE079g7LIC16MpbTH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 87126e28-c29a-4c9d-5247-08db0d75d8a6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 03:53:20.1576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O7iWVtqcwAy8Mc16ECrOpYsu04JcZyZvHWHme1sbE9b1OWqbXAU9C5VLjhv1MSl7CC4e4m+st/FWNKvkNDkjQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5811
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 09, 2023 at 10:40:21AM +0800, Robert Hoo wrote:
>When in KVM emulation, calculated a LA for data access, apply LAM if
>guest is at that moment LAM active, so that the following canonical check
>can pass.

This sounds weird. Passing the canonical checking isn't the goal. Emulating
the behavior of a LAM-capable processor on memory accesses is.

>
>Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
>---
> arch/x86/kvm/emulate.c |  6 ++++++
> arch/x86/kvm/x86.h     | 13 +++++++++++++
> 2 files changed, 19 insertions(+)
>
>diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>index 5cc3efa0e21c..d52037151133 100644
>--- a/arch/x86/kvm/emulate.c
>+++ b/arch/x86/kvm/emulate.c
>@@ -700,6 +700,12 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
> 	*max_size = 0;
> 	switch (mode) {
> 	case X86EMUL_MODE_PROT64:
>+		/*
>+		 * LAM applies only on data access
>+		 */

one-line comments look like /* Bla bla bla */

>+		if (!fetch && is_lam_active(ctxt->vcpu))
>+			la = kvm_untagged_addr(la, ctxt->vcpu);
>+
> 		*linear = la;
> 		va_bits = ctxt_virt_addr_bits(ctxt);
> 		if (!__is_canonical_address(la, va_bits))
>diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>index 7228895d4a6f..9397e9f4e061 100644
>--- a/arch/x86/kvm/x86.h
>+++ b/arch/x86/kvm/x86.h
>@@ -135,6 +135,19 @@ static inline int is_long_mode(struct kvm_vcpu *vcpu)
> #endif
> }
> 
>+#ifdef CONFIG_X86_64
>+static inline bool is_lam_active(struct kvm_vcpu *vcpu)

Drop this function because kvm_untagged_addr() already does these checks
(and taking user/supervisor pointers into consideration).

>+{
>+	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57) ||
>+	       kvm_read_cr4_bits(vcpu, X86_CR4_LAM_SUP);
>+}
>+#else
>+static inline bool is_lam_active(struct kvm_vcpu *vcpu)
>+{
>+	return false;
>+}
>+#endif
>+
> static inline bool is_64_bit_mode(struct kvm_vcpu *vcpu)
> {
> 	int cs_db, cs_l;
>-- 
>2.31.1
>
