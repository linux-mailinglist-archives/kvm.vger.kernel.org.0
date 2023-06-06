Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DD4723855
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 09:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbjFFHDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 03:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbjFFHDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 03:03:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77560E53
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 00:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686034988; x=1717570988;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=uxrkiZpe64GX33xZSgQy/qV8xI3GpJzZfAX0RQ7VK2Y=;
  b=JzL7rbtT4VHpIhh81+QKWJUZ4foHMHxaDEY2r+GU9ppMvr1YPQgDONSQ
   ObN6kCkRLbGOdzgfPxiYORwttol4Qj2s6TxF4iaFYKTcAm5y1JaL+2mCM
   HjCtQt9d64q1CPRTzX++vrH5Nihuw66knvIhDyDAX37fyYrHo1uJg368j
   AxPJCJ6p6AVPtpRqGtTwoIl189w2CIMZ2XJ1YMnkm+OqBTZ7O2QKDZPXX
   SeB5N1b8GVk9BJAVOKtvKp2eUQmg2t/GsHgSg/UaCUxHsyyURqnQXKI53
   TaWYkJkq15eNh9xrMFiJfhMrnRJoe27OzF56UvBksIwvU1wA3uOWCUK4B
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="359901294"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="359901294"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 00:03:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="703049332"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="703049332"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 06 Jun 2023 00:03:03 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 00:03:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 00:03:02 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 00:03:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVY5F1+b94/SDlPThw1nzhC6Uzj8F58YdMwFC/8H9CQI6Ib8iSkieDdr8hr94VNjFzMNb3A1pdwabJpXF5FixJPnUdrjKpN5HyaBFsBtA2K5STC33ZIoOXF4WqoG0tV7InHVwajoQ04AGhqCdByDUVRV/4/bN2kS9SJJZpGArp6b7QYWK5A67bP3DE06tpcun9CQdT42QJa4dAMcnMZHN6nU8qoa6SSfllX+Y8lMfx5W+d+OYAQAx8e6lJLeoBR71DFLCBNTXRSOqMzLCASsuhuvWXxR3SjLQRvLSh1rbioNZBeY/JtrpaIIrgAXkzW43imkFhuL2/fHDlBQrIg4ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/+9I03JlA8N12eYX1TiYT9dW9lBDcmgEiyhV/Mz2sv8=;
 b=Cqzf7nG98Xl3VAtnp4cMP/V4GsM721Db89PSMmAmkVwNqnUY+uroLUXq6wGYdpXFaDioLIwtHMP/7sSV0qQnEO4qvWLxNA5UOmKkvUYw29rPI0qYe14McywdCgDphqYLAyYShvvJa2+5IVgTo47/WQMQNDit5qGbt4zOqoY/rCcc++3jJGXbxqgPH6/ccTj4YtPqTYO3XAQJ+Y7s9woalMnRSD52vK2OOfFBQ3eLUkwmCaEZ5Ga0EUvtwDdlBcUSq6YJY8lrChiMIN5XgEZ4dxQ1xrmWMPHU1/HzkcQ9ixNZdVjI5a0hcHTy9ZRILhfFaVc0Lwgnzb5OAzQAfieoWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SA0PR11MB4575.namprd11.prod.outlook.com (2603:10b6:806:9b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 07:03:00 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6455.028; Tue, 6 Jun 2023
 07:02:59 +0000
Date:   Tue, 6 Jun 2023 15:02:51 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v5 4/4] x86: Add test case for INVVPID with LAM
Message-ID: <ZH7aGywSih+TcFyu@chao-email>
References: <20230530024356.24870-1-binbin.wu@linux.intel.com>
 <20230530024356.24870-5-binbin.wu@linux.intel.com>
 <ZH3hqvoaQkQ8qK/n@chao-email>
 <fa4a405f-0ee6-c6de-7947-e56c4ee22734@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa4a405f-0ee6-c6de-7947-e56c4ee22734@linux.intel.com>
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SA0PR11MB4575:EE_
X-MS-Office365-Filtering-Correlation-Id: e21d7902-ddf6-4fca-2a48-08db665c0ff8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZKyk9UoGmu4y0rzJ+7tLmLJPW5W4eIp8bG2WYNkdfrTupqlWpxs/eGzOYUFf0vaDBFvUfRRlHqBn1ZmquUYj23JUafbXLTFj8HfuVjMoPX9FavJHzUq5Cuq/k5w/NOaimZY+EENaIaPCluN7y1Q76anW/TwUc/p4uBplQm9SdEhhzMBZarln3lw2/DO79ocRyFDWNNXYwuR5DiB8+FWwMlUsHduIuZAGvXrMsYu/VckMoo8eohqD0+YNUhSOILDCVFhh7cZLuuhY/MbRuH28Ssn7yjcYrjpi0a8KTRHRfqII8LCVkrBSeBOsLBshzPeNyXEWKRI1xKdcxajW1SSZSc6r7AVrdE/WCpExQ+W65UUwQ3C/9C9RESY42pAELMHaKvDt6D/KRD3U3HbqA4T650Z3YveOlD0unNXGdP2zBRS28nRP13oxX95HussHO1U2re3Hu+xsk89yTC/zXNBT/qQDb4COXsiqzEZ3xGr8MhyWGTsxeXiiUaBoUy+hPQaSUiXcWj292M4KcCdrV1bYcfF/9iu+FtXs2T7TBRNJNTRNh2OeJNrZmuUE9juiAagHeOU6AsOrfhLP5qBQVXG/Os+atseaYm7YRCWkXPZzQ3c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199021)(82960400001)(44832011)(478600001)(8676002)(8936002)(66476007)(41300700001)(4326008)(316002)(66556008)(66946007)(86362001)(5660300002)(6916009)(38100700002)(6666004)(6486002)(2906002)(4744005)(6512007)(26005)(33716001)(9686003)(186003)(6506007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?HDjTq1k0NJuDvhobJvUr5eB/DrukXNHwXKd27+9fhl3Wmxwflv/PAV/P1Z?=
 =?iso-8859-1?Q?9Mo0TGOA9rXlSaJqIVIkHP+cUfW4xXS6Ae8XuJDxgq7Q6LQaYbcR5yFqkh?=
 =?iso-8859-1?Q?NZ6iTs26EY7RrO6TqJPx5L22EBBS7Jx56jw1FMogpmL9EVUwXDbZ/2a8jx?=
 =?iso-8859-1?Q?C6UfBMJ5ww7aLQ5vrTyhu0Km3xoBgT4hCVntM5ilOlkW5sYJ/i39t73TJZ?=
 =?iso-8859-1?Q?iUbqvKYo9pRd4H7YNpGXhRmXGRiAo+nhk7VHlpG3L1ZJCX0H6Tmm7cvrLD?=
 =?iso-8859-1?Q?IZMDkpwfNbPaccoGYTWnedMx9Q+DUHjB0Fevj2Y9P9wtAm68gxR9cXPkYG?=
 =?iso-8859-1?Q?udW+5pq8xoB3twusoy05iToe6Urw9rLVDQUZcsPlrX8MWSd89He3LjSJ3S?=
 =?iso-8859-1?Q?j+NK9L6yfKyzyX3oubPyeWQOKsxBwNF86XemUbJvI+ZVmfF4qQBFgZJ46z?=
 =?iso-8859-1?Q?WoWSugpjsq9wSkLcYjUjo+KB8FWc/qEYu9fWNdOmnY6GLP+a7y2I5Ch5+F?=
 =?iso-8859-1?Q?vDMia+VuKyu5i/RsS3Ag2jJFjLAwRy5o1YzOGROUBkeTHgQ6ByKms4JDDe?=
 =?iso-8859-1?Q?g5/qeULuD5TCH/xsmEFAPBA3ghNeMhIozu8ZIjqPjFpwcWMHxbI1b4QPaJ?=
 =?iso-8859-1?Q?uiq2/cks9jVmZHRGgvZT4Svm2mPE8tFBzshZFSVSQb5ivwDQ6Z7G8xAwkQ?=
 =?iso-8859-1?Q?RAmbvsURm+J4qBFNhUpWOTLUMphYVs982ZFgHf8MbMhgeASZNRTY6ZVGx1?=
 =?iso-8859-1?Q?SXhtHNjHFYpa67HbGzPQ4r5mgtpe/s9cOxTE8eE3rRC51YymqcwP3OTGhX?=
 =?iso-8859-1?Q?dySmajT6TG4GyjTH7AeQjJ+8wxoPDsRllIMlqEmxf+fubGQ5BAUaeq/DVl?=
 =?iso-8859-1?Q?irMMNbO4RDdCT6orVqnx2m3Y6Yr+jn37P9H1Ef3dDAMxOcxyEqZImemuCk?=
 =?iso-8859-1?Q?GmWNAYlDFhiJKyluDD+1HDbn6noLUp3qi4iHXIt+4K2jtAWLYYDB6kGSHD?=
 =?iso-8859-1?Q?FVJl0cm+xZn/S4PA4DAL6c9qIcSay1jRPNhqB1/dtdhqjVDCI2dalaC5f+?=
 =?iso-8859-1?Q?xefkcOoJmYdiRBg3FVgeiel+GwwdyD1Xj8hogPclt6Ju6CqrFw+CgVO1lO?=
 =?iso-8859-1?Q?pg4bBqyguzz9pJVqnh1TPQgkXPJVzTeCn1zdqrCnpJg6aXyU2IHYoixXmK?=
 =?iso-8859-1?Q?zRZAtsS+WIdXxiXBPkGsKbvHiduDgAEKdu5dE7OgcfoOUUW+z4gAisGDCT?=
 =?iso-8859-1?Q?jwzRj7PPUeWAaPYf8qtHFycQi3jBAiBcSkLJOxZE0BBVYZ0fUfmeV7zxU+?=
 =?iso-8859-1?Q?pILdmBIWs/MkZ5+atYZPtO1+4NLxlMRRJe9ngowni2YR3caODLLaATWi6Y?=
 =?iso-8859-1?Q?dGNnMs1XFvBa7tBQYjMO+QG9k2l6uGzwSI+Q0C3wnNFYloFNoWwdFI3fhq?=
 =?iso-8859-1?Q?+UPournxSLhPn7A38lNZSFb2kNMsganw5mXco/EDvybWa5fDAd0YSwx8nw?=
 =?iso-8859-1?Q?t+ySqPy1yHIcHv+CohzdTcaj6xhb2hY6/1Iq481GhSNy8JXtrK4XlN9gfn?=
 =?iso-8859-1?Q?TAfWs9xNGYH1fA9yYTxoaGA2m7cMJX9kE8Nr+/cgi5FVsk9Hkz2AuiXOdK?=
 =?iso-8859-1?Q?//0/GfA9SKi7OfQRJb82CRasMDhcBPljvS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e21d7902-ddf6-4fca-2a48-08db665c0ff8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 07:02:59.5952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8+SvBBoctnaUwcRCC7Qp1qxMaMZ+TSVYDEqsX7gOOsXQUOeTQKXgdmXdC3cViHmogKLKgQI47GiNd5sd3js7sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4575
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 01:47:07PM +0800, Binbin Wu wrote:
>> > +	try_invvpid(INVVPID_ADDR, 0xffff, NONCANONICAL);
>> shouldn't we use a kernel address here? e.g., vaddr. otherwise, we
>> cannot tell if there is an error in KVM's emulation because in this
>> test, LAM is enabled only for kernel address while INVVPID_ADDR is a
>> userspace address.
>
>INVVPID_ADDR is the invalidation type, not the address.
>The address used  here is NONCANONICAL, which is 0xaaaaaaaaaaaaaaaaull and
>is considered as kernel address.

Yes. Sorry about this misunderstanding.

Do you need the address to be canonical after masking metadata?
