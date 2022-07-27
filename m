Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA588581DDC
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 05:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240211AbiG0DCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 23:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiG0DCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 23:02:22 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7445260E7;
        Tue, 26 Jul 2022 20:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658890941; x=1690426941;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=kE8wnv1wwTnBfKh36tM5FQD5l9zPL1YRi6wsH4p8ER8=;
  b=U6hNedNJhKeyurwaA5MDUqZsQbiDhZwsoJ/NjGmAaVA31/+xy/TyWPiB
   YhPLG9NYPppLtc2FRi36nvFoOPQrEPSObHtTO/0qS0yKVZ5zZM7NS3AsX
   Kwq4oi19dFNpLd4C8Vmh7Ru6yJmdvQLzI5EBLlCR5hTytFCC/0HAABL3Z
   tnVVZ0EJVFN/1AER/UQq8ZE5hqOhAp5koyXoYAn7we7FXE3RXz5hv1HdC
   4pERvwtO3c83xlJBMUF0xvuxh6XF4RvBE3FL1tJG8WbyqadlTrsESuOQg
   E26VppNDOCx5o54fyBXO3yegk2y0U8kzvrrQEDnfYcOjvPPKKFgD7wJH4
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="271170441"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="271170441"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 20:02:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="927617242"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga005.fm.intel.com with ESMTP; 26 Jul 2022 20:02:20 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 20:02:20 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 20:02:20 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 26 Jul 2022 20:02:20 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 26 Jul 2022 20:02:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5gJC4F9RjbxuRw6eiY9JSGAZ40cDtoyISygE/1UTuNDifPGI9D81Sgdbf7dVW++ZJtRBJSgghZER3xJUZ3QMNlQ8yu1/yO/xUeCONlcWMQ/AbT+tjhQAuvlz5LlFOekGGD2QpOs2R8++bs0m7lCqai+I4ig5J+Bxb3XZGpUu+Ug8jeHMP6bwXXkzuuibtnPVNH/vBkrx4buB4/svQR4WbzrGRQG/WZxxnPAgWa9HSNjHzkmCKR+kEBreDulOyZz2OcBXuziwh5c48dfJSGcBBVxueGqywUktcfA9FclN7Olywp9SJ4Nb8u+1KIMQXWG4oCEdmOkhwalT+wGMkQynQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPC2kqK3lBT6ByHMRXZqmsOhS9vehDoh6VUm0PkcEUM=;
 b=GXXN7FzufgIRDva+rqZgxkTUHVhH30i2ypJTgLETsfy0TINAabkkuknjsjj5kNtyns+GB8EtzlvdC0AJMtRfcDjy1bfDxkracBO2I2hip8Rn7j0oxzOSXqcigHXdfIeYyjfc8RHnixXXeu4oYk9CB2EBSswhPzD80VqBu6nbOauBhS1FWE3KFQFnwb5veKbga78ZP0aZ5yJiEcOyIJ84taSnw72fQNT53S3wLkUc+AUfj+2Jt3ooMjXm6xPO4GKdrlUyC41q1b460TcN9Gt//IZru2SxdsBupl9B9qCcSJDSk7ENMMaF8NSRh7SZmGJ4+0TytWWpMH8G1/hS3hD+uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BYAPR11MB3623.namprd11.prod.outlook.com (2603:10b6:a03:b5::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.21; Wed, 27 Jul 2022 03:02:16 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::74e8:3af5:24cb:4545]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::74e8:3af5:24cb:4545%6]) with mapi id 15.20.5458.023; Wed, 27 Jul 2022
 03:02:16 +0000
Date:   Wed, 27 Jul 2022 10:41:39 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Yosry Ahmed <yosryahmed@google.com>,
        "Mingwei Zhang" <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: Track the number of TDP MMU pages,
 but not the actual pages
Message-ID: <YuCl48wyA1XkqMan@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <20220723012325.1715714-5-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220723012325.1715714-5-seanjc@google.com>
X-ClientProxiedBy: SG2PR06CA0227.apcprd06.prod.outlook.com
 (2603:1096:4:68::35) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac079255-96e6-40df-ec34-08da6f7c694b
X-MS-TrafficTypeDiagnostic: BYAPR11MB3623:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ertGKVUaodj6k9kYVs1ql9kmbl7vIypveVk2cUDGEXMezkgqFvEZeFSxZ9HcBLWf38HC7Cpr5mfTovz1Q02MPHIPcf44ygaz68zgB52Olud64a4meQQ7k2LiISXon2me0ducJ4aAOUbUi3yea3bQhoepmo8PlSp6gc5JwddFMNQVKlQjG96K7+jk4ZSCZCr8B5fejkg1P5tbFW97mfqy20m9TTNatZ1oFyPVR1LZL0jE0genU6DJqp+NR+jpw6jEsJR56u6+uwnKfkkJ6OtPYXBRQ7NyaXUU/HCNFZoO0icHVt5BywvOibn9exw6fOWShE4Ves/EYSkpA4ckHAHKNeOfqquzX/q2X2S5o7YSP9G/cHsaSL62Fcq3ZMBTmwk4+JoXrjFQbC6qUmbHJBLmWzZ1ldL/e/SC1SRn8VyvUyAdcJQGAzkOSULm3kQRieO5tDmk1T/HkqW0ykeuqRCWqv16dJtBeL1qVFnJhTclWRwWRg6Ctb8lzOCDOJxJe1ISWDyco81KMCHwWW/Z859u26iTn2WTO7+2ZoeD/r9mEDR3+L5EnDBUPrU6ES2FImXOHHDfB7ARNsONJCRIyKBqOaUkhZ1q2rXLWkGNa0fOzTw7+KxE6qgQ03nU2ns+u2oBTHSBDJJ9Y2T8JpVr9F7WRB6MKlKSakn99Dpr/Tdodl5hgNZKsRMOua0jRf4pv6aCue2QrvSBbrafMy7K2TDootTYlDd8QalGHlEqzYtaCOFLHNjYOuH2OBk71VhA/nue
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(39860400002)(376002)(346002)(366004)(38100700002)(66476007)(54906003)(6916009)(2906002)(316002)(66556008)(66946007)(4326008)(86362001)(41300700001)(8676002)(82960400001)(5660300002)(6506007)(8936002)(478600001)(26005)(6486002)(83380400001)(3450700001)(6666004)(186003)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MMk7N254fBKT7Cr4S8hxGGwlCBKOSgQmvtLjxBDR5esBWmzYOmnGgNjhr+Db?=
 =?us-ascii?Q?uHGQkWeh5xnoxL3Z4qEmjLX6hmEo/cKOr4Nv30xQzWWHJUwIK0ipqZVyJWna?=
 =?us-ascii?Q?5fIUooAE2x+Tkbjv+BNZPId1GPYR4JvxijjPJYIPQUKA7uh2PazAGz/5RH2Z?=
 =?us-ascii?Q?6ChQZu/clYEwpJ5zSPbD+mF89XxKhS9AVL16Co/CFC5ve2UKPY+8hqcRykz/?=
 =?us-ascii?Q?JLt3zuab5wsjLOB/MkqHraFt6cXvPscNjTqFqp1kwiOzYNk/6V2sqY7Iwrkd?=
 =?us-ascii?Q?nr1G9WQJzFNXJnhPydwG52gGoR9OIEs0cQZlyIt5snx7ZX54O2xMR7sbI3s2?=
 =?us-ascii?Q?B75sbb3n2j4I70YWBl5+GyLmU7tSOe4RJCvWwNAnawhAbQ7h7GR+VDdtDfBa?=
 =?us-ascii?Q?K3P0pJV0FBrndCzw/xVRx0c3Psua3jWT/4/MJyQYBklfRNbTEl8dk420jNPg?=
 =?us-ascii?Q?LPM+G7MMBcE90XCvYiu9MimOgk9t3HuUccYzhwpYTA8IJKKHHc99qVvR8mKz?=
 =?us-ascii?Q?huf4R0zXVP4UCBh6F4UHvok4Ycu8UwhafqArZuM7HAvTU2q/7d852wVCk5G3?=
 =?us-ascii?Q?bASXtmCAXPJfkwvR0tLjj95WlXnkgj8xNmman9GAVs4aWxPkZP8EQU2nR3Ko?=
 =?us-ascii?Q?4zmGGZKrIq6JaubZMNv0gYQFY4+Gs2u79GFJw4btWrmhRnyTMjvRuo+xr+kg?=
 =?us-ascii?Q?UiKtyvqed2DhH8H9OxyTNnWq5CVII960NUVTqXAF4v5Ss0+AimcP9RYiSJUW?=
 =?us-ascii?Q?P0WBh20A5tiXpKGLiPGTsnKVB36CWQQT1jZChPGIUN/jD2onHrRpCGm0tn8/?=
 =?us-ascii?Q?VnnhOcB0HcmsrkeEkNvDzdVDNb4QcIWtG6FXS488qK47juyJNrSUaPlyeHil?=
 =?us-ascii?Q?9U8XAtATLaXMBdKYBdLzVIB0c8Eles8HDN8iMoyR5AeIH1irs44yFU9iEfUj?=
 =?us-ascii?Q?0GsNpBgbTefeHHJZoX6skpzxjt+a61fAPhT11BAVNnlu6mAhdWadE5w4ADZe?=
 =?us-ascii?Q?FpM6iOXXFG+PofioszwUuv5nDx0VhwR4wDE6tSdJxtX4HghwotszmKAYCjV3?=
 =?us-ascii?Q?F+HRWYTfmiYL7NUHwuKbokeylvdV+pas9yiyGqBuPKzEeuxl/ajHUCOR1HdZ?=
 =?us-ascii?Q?IVWUZETTRnxAbvGxpVXBsgWHEBG3gfK99nK+ToPhT8xGnWp6ca83O0J+weHl?=
 =?us-ascii?Q?grJJxMDajxD5jN8z/kV0CATBYesIQV3n+PIRWCrBw5NLvpsrX6j3Dp7+YJpK?=
 =?us-ascii?Q?xIzE8FzeLx7EAiB9sfuuX7PsrBab9jH7z7Qv8U3xyT3uFIoLs7QFEz5OrmKv?=
 =?us-ascii?Q?igFjDepEjr/PcYr+z+0ameQRRTlBj712guOIV9DgLSWmreJ2H3+hGMfiM4ob?=
 =?us-ascii?Q?+lWrT18FH7nnQsxBOFN1TzT4lQ2C3BeQjC++FK+cM3CKI2L1P7Z2EbP2IH9F?=
 =?us-ascii?Q?GvWw3JlXA+qgSUhlBzeS/33rttgJJDRml+AJ1EEK8xqI/Y4igr6aJAGHGeyV?=
 =?us-ascii?Q?zxmmjA4l6xhy3i9sErdloZ6FZ2b6O8XETF0zsIdgvDCpiS/2fE3XIumNd4st?=
 =?us-ascii?Q?9pVguW2vsz3FyDGHxSJMGcpZziwZkjzVPVbKcqcI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ac079255-96e6-40df-ec34-08da6f7c694b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 03:02:16.4257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bGOoyuKb0pjlnmob3F7/49XZrR73D1LUW9cJQkrGmmtER+3gyvmfBOgtSUHy8JKNDGv7JtttOi5tZHlc9q83gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3623
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 23, 2022 at 01:23:23AM +0000, Sean Christopherson wrote:

<snip>

> @@ -386,16 +385,18 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
>  static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
>  			      bool shared)
>  {
> +	atomic64_dec(&kvm->arch.tdp_mmu_pages);
> +
> +	if (!sp->nx_huge_page_disallowed)
> +		return;
> +
Does this read of sp->nx_huge_page_disallowed also need to be protected by
tdp_mmu_pages_lock in shared path?

Thanks
Yan

>  	if (shared)
>  		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>  	else
>  		lockdep_assert_held_write(&kvm->mmu_lock);
>  
> -	list_del(&sp->link);
> -	if (sp->nx_huge_page_disallowed) {
> -		sp->nx_huge_page_disallowed = false;
> -		untrack_possible_nx_huge_page(kvm, sp);
> -	}
> +	sp->nx_huge_page_disallowed = false;
> +	untrack_possible_nx_huge_page(kvm, sp);
>  
>  	if (shared)
>  		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> @@ -1132,9 +1133,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  		tdp_mmu_set_spte(kvm, iter, spte);
>  	}
>  
> -	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> -	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
> -	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +	atomic64_inc(&kvm->arch.tdp_mmu_pages);
>  
>  	return 0;
>  }
> -- 
> 2.37.1.359.gd136c6c3e2-goog
> 
