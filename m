Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2CD6821FF
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 03:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbjAaCXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 21:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbjAaCXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 21:23:01 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E15E4682;
        Mon, 30 Jan 2023 18:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675131775; x=1706667775;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WL9TNAspjBrvOU9vUCph4KAscKgJG6ObhpypPu0762s=;
  b=b2/v80xJtzcihOed5HZh7EP8P2GqIukjONdLcikLgF1kLzA3uUB2ywhG
   Etna5tmmeGqlyu1SnMRoD1A63qiwU/GfRELTi/lNLz1FLY77J1CoGeqk8
   xrHg1eilES5DAa5ggXHMzjFP2dFWoizUwndSre3TQeCI/zoA8DxwVIML5
   o3l4I0OzgI3XelbfIpx8tHXr/tsVIbodzjnyPluSkXHTu/rh5DGVbjdgG
   +D8yRl7ri/Q+L9954fFSQU5ue/c94bt/xaM95RATSuWqkc198rO030B10
   gZXpN+VySuhHO3VZnzswhzEK7zBa4BVrYKqK7UfTkf0QRJG9ug7lk7NWo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="392280399"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="392280399"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 18:22:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10606"; a="641791394"
X-IronPort-AV: E=Sophos;i="5.97,259,1669104000"; 
   d="scan'208";a="641791394"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 30 Jan 2023 18:22:52 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 18:22:51 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 18:22:51 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 18:22:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bne8LdPZwAfABkBC5lQvYSn0KROfg6wXMIOlOq0Wfd4TMdI4SvyLtXES0KNZE/NAYqESn+fM2lqt6IO+JbCeCCC8qyXxJr+BMQgND2iWN18kaAv4OkaLI7pwEMwl3zswNrpNWDrB91CUf6w48esvzQjT0u2dBY6shj+Rlon7y4Cbdi7IKRJTtdJUj03uhWfdiElln6jokM1zdkv3inAIaNyXcIFdCGzWyHUQusQX2zHGWKk1BDFUF2EqBWZUORt10xG4l5l/3tZbW6Ojdw0Kf9o36NIl3iX9KRBx9HCPq2oHVdJF2iXk7oXuGwe2V6LromeE+ZLGTCZDl+EjWoWalg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paZ5gMNBv6BOoAnnhfoY/0s3T3pEkt/RJ/LA9sqq1Os=;
 b=QVKckY/vAMj2kVpwWdG8EZOO3UNJWTJ9glcgDHJ3sLa4+HkCvbs+iPwOYOVvSDBm6uxzAZDV/KwUOEvdOchWwPNDkleYDP3hqcldkYsD5ZH0mgf1McvOdvqiHHeiHJrY92hqEeifmw7dhPyw+hZec/1ZfjRI03dXRQPz2XN5gvYqDqBQ91nWCOiHoaZ8jWOLBIr/VV0NLVyaTuiP1yrDa0oUVm7MUrPjhIYrjWTrYNKV5Y8hZuWcUNO+ZAsNddU5+ZHFFK4Z2nfnukaNyMUHklBxSFpdpckYdOjaiAjKVb+pp4yviJdYWBrMBsdWq8gi6JeYNveQimc1ap5H9ltBug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CH0PR11MB5707.namprd11.prod.outlook.com (2603:10b6:610:110::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 02:22:49 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::ba40:b444:6a6c:38ee]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::ba40:b444:6a6c:38ee%2]) with mapi id 15.20.6043.033; Tue, 31 Jan 2023
 02:22:49 +0000
Date:   Tue, 31 Jan 2023 10:23:04 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Kechen Lu <kechenl@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>,
        "shaoqin.huang@intel.com" <shaoqin.huang@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v6 5/6] KVM: x86: add vCPU scoped toggling for
 disabled exits
Message-ID: <Y9h7iB0bD8yoFeXZ@gao-cwp>
References: <20230121020738.2973-1-kechenl@nvidia.com>
 <20230121020738.2973-6-kechenl@nvidia.com>
 <Y9dmwQNS1qufVwYZ@gao-cwp>
 <DM6PR12MB3500C858997C08CDDC956933CAD39@DM6PR12MB3500.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <DM6PR12MB3500C858997C08CDDC956933CAD39@DM6PR12MB3500.namprd12.prod.outlook.com>
X-ClientProxiedBy: SG2PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:3:17::36) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CH0PR11MB5707:EE_
X-MS-Office365-Filtering-Correlation-Id: bb8ec79d-4d0b-4602-b027-08db03320c0e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oCORWqiYmQr16OKYf0jf3SIf8TaLwoNo0OLmNELQYINJHzr5trExYWFF1UwLCiF3hID/rEFrS9pVMqW3paYm+rI9DmdwCsoSWPWn+9/Ecb9f4US0+ItEUPmorsd2PrzDTAfw6VoKmBhpC2NSUHckpSajd0V/g02lbadefz8BFt0t+zt2V4+cdvJSnDmgYe7TEeCawQ5WyceLwhXfER63pXnKLZoBnYduBM2QOt00shaRJ2XGaY2iRW1pcGVNt+ZWRZpTNKeYnjkb53JDPDds10Yzk2BhoWPucMJBemjULCtY7IEQ2xBhR5OcAzPfpVwoNh3h4wU7ymVrQFVi+lgR+0AZ3Rxnz5Ur9Gx0j4of2Qobz2tpkrmF2m67gUHfhwL8owv+0hDMhZcwsTfIpJyoKoRuhWdx1QoItmjtWK4YSo+q+HCG9FrOyD1KTI4s4R9LX20d4OATYiubkhcQvAyvByOONXfxEIgAPcryRGn+vQ1hVK7kfCwbT8rSPKvVHqxGcmAjMz+OsrMiIEpkv1/7UnNUMbUyWCJdMT0ylXgUUznTpFTQFRNW0OEsdqQWtHK66hVhN151SC2W/tk26q5oNq8I7o+S4D3g9ytY5TOkjIU7ideYVJB7zdnvuc2WhpZ7ngr0jPaJWjP2q3rmEcHjLgGVu0RYi8h/kOH9F4YrRYBPUjQIFpOEQX6PBrMVbwKe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199018)(186003)(9686003)(26005)(6512007)(6666004)(54906003)(4744005)(5660300002)(2906002)(86362001)(478600001)(44832011)(6486002)(316002)(6506007)(66946007)(6916009)(66476007)(66556008)(4326008)(82960400001)(8676002)(38100700002)(41300700001)(83380400001)(33716001)(8936002)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I9XY0NKq/dG+Ph4BXzUokQ+Bw6ZIzkN/iIn3Y2pVWe3w6yHxGfI7O3qxsRlZ?=
 =?us-ascii?Q?7raXFJ4rSxobskjiOGDd685PUvZ8t0UZmAiMDtQgk24Q8Mc6+EsLFFlR4JbU?=
 =?us-ascii?Q?3h0faA2GrHN2pRJAgb5SyARFZfdJGfQDxBQTz1jObAbI3/RqEW4qS66iyVUR?=
 =?us-ascii?Q?QWBeae10yixfwxBddn8A+4jM1FxW5yOiuV5zTnSW/p6ycGU9GcQ29mq+aT6L?=
 =?us-ascii?Q?slG9wcCi8kpr9CRY6LpwMxfvH1DACZFNf5Dmqb0W8C01vYkK0zHCMQQEKvyG?=
 =?us-ascii?Q?8NCx0Zmn0Hc/h4yhgZo6CioTocw2a8fwzcK14P2GIcrcCgOEJMxBOlAh+p6+?=
 =?us-ascii?Q?YhsRtx6vw3XIYxaYL/3XyXxW8NvxGYeCp7oGb5nNmSyg2rLtR12VfXTgVyc2?=
 =?us-ascii?Q?6iRcE+JqymPwu7FBrDRje91ZHPusbMBesZCPHfTIUomh1FZ0f31aVpN/6Olm?=
 =?us-ascii?Q?RPS3DcXYvYOQIaUwK4GczsC0ATIel8NUsoAL6dKHCJoZKRpa+BvZpSpoQSN9?=
 =?us-ascii?Q?8S6pyHsnBPZwXpnHKXhhq0cAahlQqhdmleURqwXI80QUPTU6Q40bQR7WKxRq?=
 =?us-ascii?Q?B+acBdPX/G/09l7KjDf+GeQxAezBxsg1rSn2zLSQyFylmC0py78zPfKie2FV?=
 =?us-ascii?Q?OaEqGdUcede0Dwl9Ka2Iz2ed/7sWKNVpDjxwtMo9Ttd+DPKx1uGvw+YKaDox?=
 =?us-ascii?Q?e+XOifHyXs3qOroB+5v7q/45Kdgvp1LuKvyTIHGrYP7rBcdId7mjRBkCln9a?=
 =?us-ascii?Q?tinoDaJEjSx6nSvdflGEepF4bOC58r3jH/9W8uOY+/vD4rZTqxSFbdijN9AG?=
 =?us-ascii?Q?h3Mk1yoOaCNjxd/4YSXEsFYD4rmlN63fjlJifU05+DZzOUQDyIma6UcDPfLo?=
 =?us-ascii?Q?XjviLul3RNGYgGKqmw1Foxo7YD1cAPkcPFiI8cflvDIpBPhc/UFHO1ISdsXF?=
 =?us-ascii?Q?icYpUF87sZFxHbB6id1V2aNQZqmsSDzC6M1zyLDQflvU79x7Dav9CyCOCbnB?=
 =?us-ascii?Q?gnWLD3kBegQgcLLbdRZQxHi+pNFCc/dThL5koZaR6BYJWBrF5hksaBCt1imi?=
 =?us-ascii?Q?lz/jAIpiB9J2ovId2XgTfA5QuAJP1aZoo7pJQeHOYW/wSOHAOAOvHOdyNhOg?=
 =?us-ascii?Q?OS7gNH5ytVEHP9+OAvSL3mf1z1F5iM9IWYsujILBg5+msB7/w3WJ8NVyxiQT?=
 =?us-ascii?Q?cfz94BwmC25U1S3Nd96mZW0KC4GW9iWki5Eihfmve7+QgV3rLiEV2EwofIFK?=
 =?us-ascii?Q?qDV6xYP63XEr2AVEeVTXnjMgAvO59RHMlKWX/8kbyauSulFvwaof0UyqFOTX?=
 =?us-ascii?Q?RSVr/AFnVF/aWu/x/+L46VAdSSOp/dycluGAasK/tSZ597q13pY0SEbKDN0Y?=
 =?us-ascii?Q?f0R9d7yNiXu8FDat6/LWbpHbjoQqMIcAbJ85ju2ekzwajsjgpp2J1OQsgh3F?=
 =?us-ascii?Q?TNDJBCq25Ytz69buknOeRkWYl89f0jDFdcrTIuV1Ygp/UTzRaopAFYcLhpOO?=
 =?us-ascii?Q?ODX/ZkbWcPJGRYzYflY8rKZEwduEYPQncgAjslfSHsIhQiVIinL7U1aVTCyb?=
 =?us-ascii?Q?nieUZ91YoQlaUtqaHmlf+lUk3gmFT0nM3ju41X6D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8ec79d-4d0b-4602-b027-08db03320c0e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 02:22:49.0290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: trY19FPlKYr+Cl7qXQwUYxSsQxJ0WChU6hknO7mfu3J7orUaxcTNDqVUvr05PLpisuVvvkOTiI3Fq2uQdmwH8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5707
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 30, 2023 at 08:57:16PM +0000, Kechen Lu wrote:
>> On Sat, Jan 21, 2023 at 02:07:37AM +0000, Kechen Lu wrote:
>> >+static void svm_update_disabled_exits(struct kvm_vcpu *vcpu)
>> 
>> Is it possible to call this function on vCPU creation, i.e., consolidate
>> initialization and runtime toggling?
>> 
>
>Chao, can you elaborate on this? If I understand correctly, 
>you mean replacing the current redundant code on vCPU creation 
>for checking the xxx_in_guest and set intercept, while instead, calling this 
>svm/vmx_update_disabled_exits()?

That's exactly what I mean.
 
>Yeah, I think this makes sense to
>me. 
