Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDB25A8DCF
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 07:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbiIAF4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 01:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbiIAF4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 01:56:43 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520FC118221;
        Wed, 31 Aug 2022 22:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662011802; x=1693547802;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+BpETqHGgPQW2AD7Cw9SWMQlD0iJvz8O9dJ/60yXeu0=;
  b=b5jjVkgfGb3XE5Ds/VJrtEgKInQfjMUtzzDiA+A3OYIKGw4VtRCnlHps
   KbT9aoTukRnPiI0slVwgkVDTzY5hXv48mIuWgXpDtLmLSmBpPfP/QLBd+
   6FNnDqzSR9RgvxcD7x593eRmyNxmE/KS730B4lsOIp9VZ2wXNsltFfOeT
   kgtEZw+cYuRKvv5LfFIyi3HC/t4m+tJJ3V/WHmvPfRFmxS6b/ISngsbAZ
   VRjufM1i1yV5xjcBn++hv1GCM2OSCzhKz3e0+8TCQ95yWlYomjSHM6dSf
   QQUZqJZld041NoJmz6bsqjdT4E+ZF5I3jQJ2NLl6ais587EF6+SL3FFKA
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="359584310"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="359584310"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 22:56:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="940714575"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 31 Aug 2022 22:56:41 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 22:56:40 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 22:56:40 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 22:56:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZGSjLemAql/E/r6yBJjc+3S9YGmxStwPBYqX4LqVzg5AHeO33WmsxVEsHpkl5CUNE2NP8uS3C3/StaB02xR6gjIwCXFK0IF0Vj2bC0cdYYLo/V3CFqPnDxE8paZLT3BgpbP2v9V6crmtZxZp5uRPCnn5YP+SfUPqdge/QzN5eBFKcwJHIexHWSA3fyYsOvdBEsZab7/0nAsUpeplclRidmW3vvND6JMXBvV6gbQ+QYQGHXUUjgGnX7U3x55ZR0wkKdd2eLz7jFvf4Ndc4Nggp0CHb8bw4wUuZSeZUwwQTKEc6LdwA+dFZWA1IKNRte0bPcwYO1hpc+N6/E+ddVm0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qJWvkdIvW576eZYPcvkG3EJMTlhty24ScTzxneOsHCg=;
 b=BQOuk6zSQv9Q0a/mIQkq03F3BugaI8PQ1NhjtP3/vg2J8dMm2wCFG7xc53/1pCkw9KJVf2X5kAyvxOYeLG5gqOEyO1SH0Cxuq44+0Rvfl2F2Xyp8y5VSQ9ASR7kmPBKsBq4YyUWSsRr0pJa7zGmpEDdpuDHg20VHhjkzDG521JjjIyh211gN0sfYbwpcdORxH6xVBnAFVu9BOom89jygPRoiTu+1SokKa0ZRC1SD6wbYTl2gTGwejmSQ3JeZ/Sp2rlbbsksTtAQlnpHyUdor64kkSkoTvCe4yl/IWq4UR3M9R64cKVCVc17ZHdkre7BlBtpXkT6gzVahfYzVNzmaaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by BN6PR1101MB2082.namprd11.prod.outlook.com
 (2603:10b6:405:51::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 05:56:33 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%7]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 05:56:31 +0000
Date:   Thu, 1 Sep 2022 13:56:26 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     <isaku.yamahata@intel.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>,
        "Will Deacon" <will@kernel.org>
Subject: Re: [PATCH v2 02/19] KVM: x86: Use this_cpu_ptr() instead of
 per_cpu_ptr(smp_processor_id())
Message-ID: <YxBJiquDmmdfD1fu@gao-cwp>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
 <920dfe48e7255c2224a799386d720f34b4479e1a.1661860550.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <920dfe48e7255c2224a799386d720f34b4479e1a.1661860550.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SG2PR02CA0125.apcprd02.prod.outlook.com
 (2603:1096:4:188::13) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 765ff163-586f-482f-378b-08da8bdeb83e
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2082:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NjC03APYzBm1Lod94iQ/5zhUWjTIIlMhxz+2Dr5GG6vhNJ83LBpQ4EurJ3voMenDDJ81ekeek5c+OWWPTkECFoSMLBflK8UeUUniesqIGYGkHpL9LP/oei9WtMJPr1b1lYfR0LKtw9vtqBY/tcDLhfR9vX/cckTXwVbhKZP5r4e0tBncW/Hu61dso2Ls2KlO/r7mmQECVb0+MpbfrCjQSF370cfDvqdOPmWg88Gz2rc5xPG3GXe6dXeAaJUfm9q90QsGcthkt7jqV8b6e4u4d9+byH/RniuPkbNk6QSFUJr6H/aHz7Oh/X5eo6iVYXtB4wxKJaemzVSraXLJTG0PglbMNabZ4qOIKQ0WKfmdFqWtBDRXtG5Qtl8Yr0S7Wchtx04ekYF3JGn0HJyTkSufSfPKPBxYr2q0LOsYn9kZZ6DsasYShWwS3NSyo/ljHF6tQuZkxEEnBeQKd1oNTu0TEEIy/QCYGnp1qx7TEx0T5ZgM/4tRDELoyWWxum/jpsuhpce3PFOR37/nGz8f8e+8W8jgjtbDLWBxBy+xwNmAmd4mnS9HnsJsaPFiqIFOCd8ZnyeyJvxmCAR/9ZKP1zv92p6K5+FaxFk7lbpu4p5NU/mdNXa+KNRd0Twpffw9dsb+SNEroDBu0TYTzjQff3GnDaS944wJyAMSRuZ2mWPWazmclFaxb3EJReOdfCfcgk70dFcJAs+w1wh2S5MxGLk43g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(366004)(39860400002)(376002)(396003)(136003)(66556008)(66476007)(4326008)(8676002)(66946007)(2906002)(44832011)(316002)(6636002)(34206002)(8936002)(82960400001)(38100700002)(5660300002)(9686003)(186003)(6506007)(6512007)(6666004)(6486002)(54906003)(26005)(478600001)(41300700001)(33716001)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VPIGwVlzZRN77MbQzPonIMJ68ELrofSRWykDEUuRwD4+Fs/1EGIG/SWFQ7rS?=
 =?us-ascii?Q?OPxtC8+8vkUq1MLRFjIcDkEbIYmTzwSGTIuAa+HRk3fWbRgwK+18SXF3I+4N?=
 =?us-ascii?Q?jmSD0lOJMnLG5EHbje8Rs5c6oIbi4zEj8lTHUDX+wpiPlNB80kFUOZIkiHv8?=
 =?us-ascii?Q?dsW/ETloppJwYAH7v1HEX7el03rOvigtmdEp7UxhZ4nuAwZsvHfb9Lf/Ougl?=
 =?us-ascii?Q?GceIy3yrULH29MM9rcihvOyN1XahRYpYffZmtgR6t+EtD3XXspStuUAYv6nI?=
 =?us-ascii?Q?txhNHArE+r1DlMbCpmGTG0LxO4MPBY7//ay6vaSjt4+SFrRldyVYXoh/eBr5?=
 =?us-ascii?Q?+DbB83zyXu09d4abt5+XXrqsBiH6B8OZbYE1UfrVCIse+NZP7pHBpsqzeliK?=
 =?us-ascii?Q?hllrnSS9+yJYQnvuOeWn4u6Es3o3HhXgiD24Ys7VM+cxQ1gmqnjt8iJxChxj?=
 =?us-ascii?Q?BT5Jfl+oA+EiLEOu/RsIcBi8yG48x5E6jNaaqFFDvxZGfsa6jJrcOSZYeLle?=
 =?us-ascii?Q?hvwYru17n0K3JyC0kocNYrzsQ4xiCFOes/aYUnLhXnIf+WGRDj/ZiWogdjMu?=
 =?us-ascii?Q?Q/5K2ueHxHY+z/Y/KrREktYG4CFQaKEoLcQ2WAA77wQhrPkC3u1yxGO8Nlut?=
 =?us-ascii?Q?zNcSy11u5+m74HR2vcCRStXjziSNjMZkT3PfA7xpQDAde4pVnMmIFKtqMke8?=
 =?us-ascii?Q?DwAnLvk+1fwr/gXJqMDRbHBTyO6DFYMSOGGZZw/1AdMZE5xAPRBCSaWz4IQX?=
 =?us-ascii?Q?MuQM86AVPYQjyTwV5DWK3KFoiPjSygR+jQO/PCCUpK2a7pLt0lyG1jYBLaKu?=
 =?us-ascii?Q?bKyxBIPTwxphHusSHK9pZwduv7pCrlbGn2swCJZ1Eaa+GIPWdRwqL1JAvUt9?=
 =?us-ascii?Q?Ly/vZFpFc7f4WR+dJX6eDppaYsgUqzcr/Fs3QMHXrJJuf+lH4xhcMVziA8x4?=
 =?us-ascii?Q?/VmH+gW/doLvbQtTBIP/F0ezg3P3iQUYNP3bMabfQJcfX/TTEQFtw0DQ7r3O?=
 =?us-ascii?Q?89LzwUAK0K4jCcagCndAs1VbgfiToXGW6GhgJm7eEIvBPw3O/a5vX8mzk6YS?=
 =?us-ascii?Q?6C3c2p23cr9e+qA++lGGe+670C2j9yR1wXzvXjqook6AlKtKPbIrgwf8rC0k?=
 =?us-ascii?Q?OcB7prs+AKmhf3RgLENnymmcx9O2Gbtf1fcBs0zsa3xxGObi4BUXASnsbB31?=
 =?us-ascii?Q?Z0JzQUOuCspGclmM7A/iQBkXTaIDI7b8X9QyjuAyWdu2higcCvaZAt5V9yqi?=
 =?us-ascii?Q?EFCCWabTDtVMCTkwqnQKJibBq6HlAgCBoZuGGkRdSUtRquXvSW0nD/BVSe0K?=
 =?us-ascii?Q?sDOellPK+ZBOwpTzRDivvCqsZ9q6g4aOnW2CiboxFnO6xNap/zfq/USj9yR/?=
 =?us-ascii?Q?MOa8FSLmvn0UCJNTkXJ8qNsuk/GT+vfORPuBvQy22nWyBaY/+I2VSeMHyHOs?=
 =?us-ascii?Q?20AkAa/0hLVoJDFISMhe+iBx4z8Z6hQjOqFJVb+/j2wyXRuBDB5fdfGG2zsz?=
 =?us-ascii?Q?cvNNjSJABEKFtSEYwM//qxFAfjyse3BJxVEilBRDCWbPthRO4N5aYB3BVaUM?=
 =?us-ascii?Q?h/tPNJkF80dtEdzT9E4aWwixKg8rZSSongj3mgJA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 765ff163-586f-482f-378b-08da8bdeb83e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 05:56:31.7838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r2U3WTvrh4ZzDWUOXagahxJ55Jy/saSHp7OxOB+asBqcDqjQxHWSXsjMlaN8SVY9/qqyKHeMae9vzA7CbSvSIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2082
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 05:01:17AM -0700, isaku.yamahata@intel.com wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>convert per_cpu_ptr(smp_processor_id()) to this_cpu_ptr() as trivial
>cleanup.
>
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

>---
> arch/x86/kvm/x86.c | 6 ++----
> 1 file changed, 2 insertions(+), 4 deletions(-)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 16104a2f7d8e..7d5fff68befe 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -416,8 +416,7 @@ EXPORT_SYMBOL_GPL(kvm_find_user_return_msr);
> 
> int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
> {
>-	unsigned int cpu = smp_processor_id();
>-	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
>+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
> 	struct kvm_user_return_msr_values *values = &msrs->values[slot];
> 	int err;
> 
>@@ -449,8 +448,7 @@ EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
> 
> static void drop_user_return_notifiers(void)
> {
>-	unsigned int cpu = smp_processor_id();
>-	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
>+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
> 
> 	if (msrs->registered)
> 		kvm_on_user_return(&msrs->urn);
>-- 
>2.25.1
>
