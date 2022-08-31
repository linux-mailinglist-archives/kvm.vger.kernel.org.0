Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF725A78F7
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbiHaIXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbiHaIXE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:23:04 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B658C277B
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 01:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661934152; x=1693470152;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yr3ezrbL7nD6+JpTIg+RavDaEkgIFqw0/FwjM4FaR/M=;
  b=fonfuyYGqtEXERqNprhLAq8PBjCT9lBP/CE5tbE1ZM+mwtKrUQ9JJxiX
   xuprnzjvIiKla9OOReglPK9wLenJfW4Z4wlKAtvFf0ssqm3YxF22r+eZo
   p0gG8PVYLCZG3ikHlkL3WCRTNSMJPB5rtWDAQ9r7SZVgf6htW06/f3BKd
   gfr8fNvt3KlSX81gXUsVP3WEALejAiMcHJiBmxX4nMay2xaPbdvRH3nOn
   kGXQhyOgGFOYZE2fIXhidlMzG6vq4GbvK9HJIYK4PRzmb3f8x+aW87/YG
   0fXaJgrVgNLx20che7mPZh4PiI35n0R632A9eBx9OrWT/p3roOdw9kP2W
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="278418085"
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="278418085"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 01:22:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="641762975"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 31 Aug 2022 01:22:08 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 31 Aug 2022 01:22:08 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 31 Aug 2022 01:22:08 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 31 Aug 2022 01:22:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixncSy7rZ9uJngrVkYbjo0sfQjSIwMlowkqaaiojhHqcEHfnY+G5qNUIMhIXpTG7RPYULX4ZtHOU+OAUup2Fqt5932EYfF7kLj8znDzKr93+LWCK1zl1CzPt+Rg6zQHTg5dtMVYxbucvXumV7nVTXaYAl98OHJVfPfx96gGQvuKpky6fFe9IpzoouCqBlCNJM314zFy/o020awBJqPvrqafG48TmsZHK7GRwem5aZL6Nscl4KlvGYUKwCNVb06PlvAxz6diA39DQtlTvuFGuQno5wcc2/bJGqW0iaE8QYkEj+rPbJ2M9gg2/4R4ShdVmQ2qxnAKE6q4lpjEoILhT6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yr3ezrbL7nD6+JpTIg+RavDaEkgIFqw0/FwjM4FaR/M=;
 b=cIYikgvIMfruXHRxkvG5pmJd4CfCH+RwwhGZsPjneaLPXCsb1arCbIM3ninohS3541olwAPfuiedeumGRtbvhnn5oM3ZN5mWpINRDXazKLL28E32f6qVXH09tPFL8I2frbyfAtYE1vfNyLeo3VsmM5wbmC8LBTJxW/rmyvKjpCJO3/Nt7iQ7+iLKzbF6UKCzkIi27MYeUDN3uA4bCtti/WNL9gNptCIomKgs95NhkhBbGZq5L33S8S7prYe6iL+KsRfu7g1PUHZEYnfeRdhwHvGM9tM6U4Y+Brw7st6iNd3S68J1IRx4kxFiikajFix1vR9WY+gYDIVyKY4GywyfBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by PH7PR11MB6793.namprd11.prod.outlook.com
 (2603:10b6:510:1b7::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 08:22:06 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::e9a3:201:f95c:891e%7]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 08:22:06 +0000
Date:   Wed, 31 Aug 2022 16:22:03 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Jim Mattson <jmattson@google.com>, <pawan.kumar.gupta@intel.com>,
        <chen.zhang@intel.com>
CC:     kvm list <kvm@vger.kernel.org>
Subject: Re: BHB-clearing on VM-exit
Message-ID: <Yw8aK9O2C+38ShCC@gao-cwp>
References: <CALMp9eRp-cH6=trNby3EY6+ynD6F-AWiThBHiSF8_sgL2UWnkA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CALMp9eRp-cH6=trNby3EY6+ynD6F-AWiThBHiSF8_sgL2UWnkA@mail.gmail.com>
X-ClientProxiedBy: SG2P153CA0018.APCP153.PROD.OUTLOOK.COM (2603:1096::28) To
 MWHPR1101MB2221.namprd11.prod.outlook.com (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06bb5f45-d8fc-4231-4d0d-08da8b29e44c
X-MS-TrafficTypeDiagnostic: PH7PR11MB6793:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8oZVaQUfo6UPshj5VZ7eP92H7wu9tgC1okfYPzBK1DZ75s1Cv26sv2UPKNWwxlofOC8IKCX1mtuUQHLuYpo+K7xjwBM41M/MsYuISQ9tY2f+LVJp3iAu82aZjqis6tEBmWIqGpoCZH/d5Y5NSnJGErNTEAyi8qM2pjzvOccKBnDY6YxdsNPVUqSP9FIng0HB1aFAYY1immM0nG7rtU8XzT6NMmyUuxwA1FPdSfgPCt+sNjqaKIDrZv47jcDPn7x3oBIMBdpcF1+J36al/8dhnKREy7YM0WERMrjo7xLZJbxdWJiSdfNmdRLIskkYJjzpwKAGq/ZMrukk0g2FwtCQNtyCPHDmg3rjwqUvT6cUeXbdB7vSbhLM0QuccC/Fn0boGBXKtU6q5bRaHGSlRluQd4iCN2XNVslDkGshsHUMWE5T1cNhU4Pg+oNc+kiu044O2UBQwaJ9KdWKx0CWdLtWqFgY+0cyxerEN7YNO0M4XBVZyjDMFc0IeiFsTGttJ9ebj/33QOfkQDF5ueCXLj8oa3ulD44RMuLFk0vrElM8+ck6CeH7EVjTh5a4bgcx0kpZTbOCd4znNn1q3uaQZuWeaelBTgSHikRmyAdOVP0MBpc76i+qe0oYej7FJqTTeHXyZ3VPUyeCUX5wSA6hnh4LWYS4YuC6Q8D5iZsdMHVrZknSnXuZpLFppJWe3+tHhqbUkHg+VRt0feuPxPTUz+uGTW0ZaY45/WDG5BDDHso9lQB2YWFk2CuX3xKZZIaMBwpyQMvNYbnx3O9Q3eIPF5zYltwyZWgFFC2d9PkvOf/+ymQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(346002)(136003)(366004)(396003)(39860400002)(33716001)(82960400001)(2906002)(83380400001)(26005)(9686003)(6512007)(86362001)(8676002)(186003)(4326008)(66946007)(66556008)(66476007)(4744005)(478600001)(38100700002)(44832011)(6486002)(8936002)(5660300002)(41300700001)(6666004)(6636002)(6506007)(316002)(3480700007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?19VNTG3binRTyCx6jPewZpWy0uoPf9biaXNrvpP4I7dxL/u263JkiTzAfXRU?=
 =?us-ascii?Q?DyMudkv/RqdtNhOqeET0qBI9NnGoluJwuMB6TK9kXk4EDA3Argz0NgSecc+t?=
 =?us-ascii?Q?e33Vt0kWmiBKhVki8iucXDWNg1XQz2GVGO0C3BTR+NvZa69fU4WtB8gwpg7r?=
 =?us-ascii?Q?6FH+rxwluSlDWF+PwwkrPJbx7RdiRhp6vq2J5yyZ4AwpFOIn8OMCBXcr18fo?=
 =?us-ascii?Q?vAxnRnstHLYHvKGumRA6aO/lUXxeN/9OGvWlSTfWn+xw2zguMT1rLhKInKpQ?=
 =?us-ascii?Q?2ZOUAEB0hnhvXgm0iDQ3HrGy7xRN6nWVbwPiHrx3I03mKFTur/ztC2EWTgn7?=
 =?us-ascii?Q?IGnZ1Gc6LCQSmoQzCVBkE1zsDjiheQvlW6f2z6c22O8gsV9+0yRmojjaJzsz?=
 =?us-ascii?Q?hnVHZ4uw8sH7hZjQm0gmiVVe355j+hemKG1GA9pb90RpyzJlufat4e232pSG?=
 =?us-ascii?Q?PRPVaY2UZOIY7KldNlxfyzGAiBEla23SHSO2Wq8diumb7VYkQvJmt6mqdE+X?=
 =?us-ascii?Q?nU1wJ6akNIQE94954VRZv08vSlJTyjIGBIP8XPVkDRcv99LzBjyRNeQYwvxQ?=
 =?us-ascii?Q?ibwcHrAYq9WgMNTo4rvy5WhZd2twIYMb5ENrszDRhXie0VpasB1FoeQONeba?=
 =?us-ascii?Q?c40rHctXMC22N7PobBwykPxO+GpVbutxgdxlMIQ6xO+77JXQR9vqudp0P2JR?=
 =?us-ascii?Q?E7Vm6Jxp+EiTp+W8q2Txumogmx8KJ4ucc9C1LkKsy7+QYQFprXUqHowySUar?=
 =?us-ascii?Q?Pnw+fu6MyM5G77HhR9qbolSY470iGzCuAqCBLvfmTrHwE8ovGsd2VEbDLBep?=
 =?us-ascii?Q?sL0OFu3gTcn4/2y+Oqwm1OkcAHzmKcXZWowqGISgDe0jcj0XTR2IatfUDUk+?=
 =?us-ascii?Q?uaVnfWXb6VFJoPX8D7WjQYJ0dk+blqUt+B6DaUdkYaZx27APbDu/dyQfoZ0K?=
 =?us-ascii?Q?Mbr27acLvUoc0l4jH0oPwgEh/WgVQ5EgYjsht1NSQWN7RJ7GEQeDlAvUGYWy?=
 =?us-ascii?Q?H0iqJSyBf5b7Wa74WWjRORYjDZe+sXgMix/t7O6hVKjLujJyAqaG9QdYUDeJ?=
 =?us-ascii?Q?WhKFDo5W6J2txOUS+NG40hs/98ZsoLhdbzVv6CNyz99tyzWSKm06OP9VZFnw?=
 =?us-ascii?Q?WF06GPT2GXnw2eddXQ2SY5KGQ1PN80uies/2mxjcLkltvEC5HFyUXNnlw3Ou?=
 =?us-ascii?Q?jk1jtG5rQHaOimWw8vePEs84bVrZ4kVhcbAM4xvN99AiHHE5/09gg/CHPs6V?=
 =?us-ascii?Q?t6hbeXUo7vpCl9HzcrtH5hEfGO9Vc3H+IkNzq7uapkt2VGCrIMwwMPWSJv8r?=
 =?us-ascii?Q?BRexHuTkTCB7EOZQNB1MrPlyI3cPSETw/KN4ah7pJOS9o9nobyPRDBsFkO4D?=
 =?us-ascii?Q?gY6Lyz8doPwUzXnwdBGwttYTQMvBdtNW0pdV8fU0inxnEFMQgBhMIynWXylG?=
 =?us-ascii?Q?jedrSqeV570lNTurZRc5Dll1Bv7hWzjD1l6dMnQmjXpY7jy7e2ethCzzIsnW?=
 =?us-ascii?Q?1roeagh6kHMuVBmOtWS/PYrCyMpOlbIxE0L/nVumN79Zf0wVgsaFyapi7cCV?=
 =?us-ascii?Q?1J88rx2K3g2EwssfsJOvw4SqijVvw9BXWzYX0IpW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06bb5f45-d8fc-4231-4d0d-08da8b29e44c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 08:22:06.7722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 46RBauaYJHOJr/RhPPJaGQZTCApZVROppL937o45if58egkjlwYl9lWmlG3RqZQXz7z99Cq3jgEVawKCvzF2Zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6793
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 04:42:19PM -0700, Jim Mattson wrote:
>Don't we need a software BHB-clearing sequence on VM-exit for Intel
>parts that don't report IA32_ARCH_CAPABILITIES.BHI_NO? What am I
>missing?

I think we need the software mitigation on parts that don't support/enable
BHI_DIS_S of IA32_SPEC_CTRL MSR and don't enumerate BHI_NO.

Pawan, any idea?

>
>https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html
