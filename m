Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EC0529D0B
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 10:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244419AbiEQI4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 04:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244159AbiEQI4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 04:56:09 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFDB10FEB
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 01:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652777757; x=1684313757;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RNGgDgoHaOlLfpdGrySB/M8ZXTOwvV6DE2JEZhfJBv4=;
  b=FkzXkdJJSjYFvUNXClldHdzjmRoF58erPPzqPkixn1kdtflh061YgH3c
   VyKX8NCNyuZm5Y4S577J5Xlf0JebnerAkAZMAB+x8faVu1CYcPaDuXQ78
   veZ46GJgc9GSnJZClN6u6nIftWHMDGL6xD4lFsjmEu2u2+kZkO9aCVqQw
   170Zvo+vLRmuNm8cNVT15pOeDIH05u5jfCkarT01IFE5rKKMyysm4/cZy
   9Ka2F/rgrwQ/vL4t/q8VDlSCk6KTpJP7GQRUGo3LWA8EgTiZN8sdH1KBe
   J7HZzRG97py4rYZzMZ7jGCgw60qRFWnf/KA7s3OfM62l/6CwEj+X+YoIc
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="296392089"
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="296392089"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 01:55:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,232,1647327600"; 
   d="scan'208";a="522869186"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 17 May 2022 01:55:56 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 17 May 2022 01:55:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 17 May 2022 01:55:55 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 17 May 2022 01:55:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0LA+sE2JZJKTJOV7Gq0QD39kWr/OiLiPwXmmdax0TcPeFviNYzwISZaYOLeYbHhjVmeAfsK53RsLDAFJKj4GzYp84OxJ2Qz2u9/DpVaeWZtskuBxAzZOk7GJ9yHZi6vzocU4Kv9lAiKilEtLTJPIqbcn7I5Q09xpLMe4w0kqW+Zcbc9VBLYXS/lxSAAllrrkRUPl+KUCiSHym+myqNER2t7+zqAdjHui5OxR4rr4i7fFjs6upXw3MfupjGXDnhlnI9R5+hQMjulkLPVOwKvZ7IMW9TH4lGcuvZMg0lU749KukAYqJvTVC4q/rgBCYhnWdjB2fLVyvnEkG+w0+QZKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kjQntK5emRePxRtWOHiw9xyFwAy7TdxjWIdsoGPDOI4=;
 b=Rumam5/wAw4WkGYUg8KO3Nd+m3J7bhb5sNtEcqVG/Cqhk7mOiHKlvmaZ8YvoLuYPN7rjOOdbEN9+DlTf446qAAOvHZsrszhDr3CyL8cPj/9L2u5HCRo4qA3jy8YFu3IrTpTNU03bf0S0QIUyx/N/ac1ojO0G7t6+EfwXLv0hkhyXHb3GKZxC9wILALnFELK+G4HGml6yO2uwKI2w5R6Ts7B1YPPyqqIThGaVX/FEgkrrxj6p4rX/LPMjZUS2uAJjQbEEZL8cQ6W2LEsYB+vdnmK20Tq109kQjctKpR/FDOT9CSGnjKyFtu6PE0a01Jx5bQoZdCu60sHP7YcaUn/lZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by MN2PR11MB3613.namprd11.prod.outlook.com (2603:10b6:208:ee::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 08:55:51 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::21cf:c26f:8d40:6b5f]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::21cf:c26f:8d40:6b5f%5]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 08:55:51 +0000
Message-ID: <faff3515-896c-a445-ebbe-f7077cb52dd4@intel.com>
Date:   Tue, 17 May 2022 16:55:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Content-Language: en-US
To:     "zhangfei.gao@foxmail.com" <zhangfei.gao@foxmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
CC:     <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "chao.p.peng@intel.com" <chao.p.peng@intel.com>,
        "yi.y.sun@intel.com" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <4f920d463ebf414caa96419b625632d5@huawei.com>
 <be8aa86a-25d1-d034-5e3b-6406aa7ff897@redhat.com>
 <4ac4956cfe344326a805966535c1dc43@huawei.com>
 <20220426103507.5693a0ca.alex.williamson@redhat.com>
 <66f4af24-b76e-9f9a-a86d-565c0453053d@linaro.org>
 <0d9bd05e-d82b-e390-5763-52995bfb0b16@intel.com>
 <720d56c8-da84-5e4d-f1f8-0e1878473b93@redhat.com>
 <29475423-33ad-bdd2-2d6a-dcd484d257a7@linaro.org>
 <20220510124554.GY49344@nvidia.com>
 <637b3992-45d9-f472-b160-208849d3d27a@intel.com>
 <tencent_5823CCB7CFD4C49A90D3CC1A183AB406EB09@qq.com>
 <tencent_B5689033C2703B476DA909302DA141A0A305@qq.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <tencent_B5689033C2703B476DA909302DA141A0A305@qq.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0109.apcprd02.prod.outlook.com
 (2603:1096:4:92::25) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dde24e6-3702-475f-598c-08da37e30aec
X-MS-TrafficTypeDiagnostic: MN2PR11MB3613:EE_
X-Microsoft-Antispam-PRVS: <MN2PR11MB3613179C07F9E220069CF8A9C3CE9@MN2PR11MB3613.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r/yUALAln5jMvFzRxj5nTe7fyOydPCYDr1JD1z+7cc3rcVc+rxaIc0jfcV0w4Tuiqf+HuRvTbISZtBGWLrwUv8et+jAveTSR5VzbpHet3x9CpWcNvaGw9Em6kSiA5WJntZDfy+vR3RJG5X6nUX3bspGgRZFaxVHFBAtC1IYY6xlqtGIgHwVQrzvN0WzfSzLRv7ETSnVb3TIFjaV0AKmwuopGpLl6/CA7ZtyPANRePt93rOBan+H4/WBtnAndjwMLmhJYftokPGNHLLOsnhav96YxLPpKsKIXj1+PH3s8N2lu/DU2fYOsZ3XZSLYVFAn+3RHr+v0uGKyxjXWwwqxuEFvtKdMyp6w1BjEZsVmzRw7Aeym9lk2avHKNpvYgoGMe0yv4qa4AIytkxxFt5OrIPVIZ7ofchWYbO/+a5FSNSc6Q7NcTN3wLHR/aLeX5Za2JnSgV6Ti0g1JLooG8tec8M+Pw16dPkTSF8a8lcJf4l4yray3fJE8kwrsvxDuGDhyGmOt6Cu8z+ZhRd63K/xcSYbIoZC+BTZsEfurAaLJfgRs9vngvO6wHFlHUN5WNylByOzzPXbGi9QJpzBMoZTibbEK0GU6smWzL1j5M/uqlBlPUZnqVKA8DckJRF+Qtwk5bZlpz7fCCDVZWNHx+CxyDPIITIUBdRmt/SkEEBrmspvs3uG2nmyN8CFWSgKz4XVB5xZmS8HpUgdMgJMFaHYaOpOD89fbxlp8mp/pK6/64TPmdJKfnssKZgtCW0GW61yFPw23D43NR3oivzliSUM+J+Wdxejvfzb07Ay7DVTbH51WOW/cP0lqd83YeyzCYNvZgKCncVo7kP9krqj+UxSvIcL07h2N7tyK+QT0EMoQAnqI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(8676002)(66476007)(4326008)(66946007)(86362001)(31696002)(26005)(966005)(8936002)(53546011)(508600001)(110136005)(5660300002)(7416002)(6486002)(38100700002)(54906003)(82960400001)(186003)(2906002)(83380400001)(6666004)(6512007)(2616005)(316002)(36756003)(31686004)(6506007)(48020200002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEp0Z1hScTNpYjM5RTIwc1B4NmwxL2JrMlV1bjA3d0tMdlo2RzROaFR5NlBI?=
 =?utf-8?B?RGZoZVB4SGVrQTJaR2VWY1lGbHREOUZXR3BIR0hrN1ViMnh4RmZuNUJlZmww?=
 =?utf-8?B?SHc3eVlVcEdjVFVhZzlnTWNwUmVJNGpqWGI0Z09jWU5RaWJMOTlFVUhQWktW?=
 =?utf-8?B?dWs5UmJvb1oxVVZwK0xkWE9FR1duUjgxcVVMS2RlRzEzQ0NXckNDQnF0Vjcx?=
 =?utf-8?B?aVlKcWxlc1pBSXNMRmo2K3hXNnRaMHQrNUxkTGoxZHpDenNmbmg5T2JGa0Jw?=
 =?utf-8?B?VmhaWEVBOGlKQmpZVkd3S0xWTTIvbkRQcVl5V055S0YzV0l3MUJuNWJ2aXZN?=
 =?utf-8?B?ZnplVDNkYzE2SWo5dk1XaVdhSTZNTXN1ei91YmI3TUlrVjlXL0NSd0RTR0F5?=
 =?utf-8?B?eklOUHptTFR0dHpWYnNMOTFsUU9iK1RmbVZiMXlqczBGbnpQSTNQbENjajdX?=
 =?utf-8?B?RXNwNHUzOXFGdnorZ25LTVZ6alV5MTR1T3BmbWRQMFkwc0RsSFBDc3c2ay9W?=
 =?utf-8?B?d3lDZytTOXd1UU9URW9RS3NQUXh3aUdPUENJODYzT05yMmM0S0FIRnRpbWo1?=
 =?utf-8?B?THBXRVNIaDMyZ1J4R1ZpcDl1bzhVYjJ0UXprZ0k3VE9zaC9jNUFQbU1GMXJX?=
 =?utf-8?B?V1N2d1J6UGlMQWoxM2JBZzVoS1ArZ3hUeGJ3Q1hCNEFUaW5MVFhObEpJZzI1?=
 =?utf-8?B?bVZvemVENXRXcFdWVDVTaW1JSkdzNmxIcnhFVHQ4SHlJcXAxekJIUXU4ZG1p?=
 =?utf-8?B?ekJzMDFYWlVJNUtxeWd4TVU0UThTSm5oUTJVbXJNUkxyR24yU25pNDhpMEo1?=
 =?utf-8?B?R1Rhc2tKRUc0V3I5RGN4dzFkWVpHZW42dWNyaVYxYk5ZN2Nya0U2Sjd3V2VP?=
 =?utf-8?B?ZkkxZjF3elRJZ1JTcVZuRGJSTFpjTTl5eHhPck1lOGJNQU53VE9KdDRCQm9t?=
 =?utf-8?B?eWR2NjRUekFwN1ZvUWpvN2xnc29MbjFXVHg0Z0xZZHQ2OVNMcm1hV1Mxc05l?=
 =?utf-8?B?TzRSYXYzVmZUcE5wZnpPSTZmMGZtNmVvZld0RzA5YldITjdYclBhRGV6YmZz?=
 =?utf-8?B?TmVheEFvQUxjbzJuZW5obGlsRFltcTQyakxuanhhWUhZaGMxRHZVU1Rtc0pO?=
 =?utf-8?B?ZFhTa21BSVkrU0FURjRtUkJxVTUxaEtKUkUyQ2RuS0JBSlJCRXUrb0FWMWxs?=
 =?utf-8?B?eGJ1WjlxY3FaN09uVytkYjYyNGlTM0RWZXBmTk51YUIrWUhWSEs4aUZqV0d0?=
 =?utf-8?B?NGdLcnFraVl3UFczNEcvUUdWZUlVMmtvZS92aVB4YkVVRGt5NTRnbjZxY043?=
 =?utf-8?B?RFhSL3ptS2xFTk9lY2xqbE5wUlFFRGtpMnd0UndERGhtN1ovUkRaaGFTVTNm?=
 =?utf-8?B?VDFST3ZqcXpLWkUyL2RTOXdtZEVIdE1DUDJtdjJhNE1FR0xhcldIemU4Tlhz?=
 =?utf-8?B?MFVmYWR6ZHVYVXNUenZsdHN4bDg3U1gwRGJEMjVwNEFoZi96MjhRbVJLQ0Rs?=
 =?utf-8?B?OFo2NG5XZUVFSnZId09rVE5WWkg5Y3pua3hXV1dkTHYyZTRnanFrSGVTdlBF?=
 =?utf-8?B?MGFqQ0FidTI0QXpHdGFlZ3pyQ3E3bGM0eEJoeTBESncweFhkSjlwZ0RwL3hl?=
 =?utf-8?B?WCtzQkxZdWlPWFBaWkdYUCtOaDNSVytFd0wvVXdQYVlUejhhQ0N5L0IrY25a?=
 =?utf-8?B?bktZMmgzMzdUZDFRSXV1THNWeVhaQm5ndDhiSHBIWHFadHV0UExxcW0xNFpT?=
 =?utf-8?B?SUNVeUZaRFJBRlBYc212bDNkaXM4UTVmNDU3SGkzN2tFWEFnUWphTlZKa3Bh?=
 =?utf-8?B?YTVjbTJtR2lENU1rWHFJWXR1TGxzdEN3bXFIenMvb1pOMkxqeE4rWlQ1K3FQ?=
 =?utf-8?B?cUJ1Mk1XSGQ5dXlxVURTVjdkWTVkMWc0cG9Udk1uVFVtM2RISDBoZU1UV1ZO?=
 =?utf-8?B?KzcyMzl4R0w2ZXFadnYvd1MzSThkcHZVd0kyVk5Kdm9TbW5mdnNOMGhOUDNE?=
 =?utf-8?B?clFTdzQ2eHp1QnpQdG5DTGVlb1FIY2toMTBIdFhuOGdTZmNwZU10TmJGd2t4?=
 =?utf-8?B?MHREZVdWd0pGM1BtRE9sK0VadUJDc0ZuOUpadU4wK2xmeVljaXBjV3pISWVo?=
 =?utf-8?B?M2hGVTl6OHNhaVlTTUxncjkxRW00RFFKaHZ0S3EwTHdSU3NxcHZKeHFHSGIv?=
 =?utf-8?B?QnFRekhSR1JQbk94enQvdThKdTNGVmlUZkFHY0FMc1Rzc2FBWnpmR3VQU1Jv?=
 =?utf-8?B?S2cvajcvbzYrM0xydjI0YjhyOTRNUldQdDRya09ZM1I0UDdaajhYL3BPR01B?=
 =?utf-8?B?aXZLYW9mRnRHRXltV0JCQURJeHUzUnViVFdLYU42bUIvcE1OZ3FiTjFoOThM?=
 =?utf-8?Q?PLAYgmsjoB002jnY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dde24e6-3702-475f-598c-08da37e30aec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 08:55:51.0475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EcWtR9XwYNJFU3BRWUO0xsmmhTlfDd4eTmJi6Cty13z8nMWfldkIrbWV0BFCiwU6IiHRjckibcIkZgGJMtjKxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3613
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-9.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zhangfei,

On 2022/5/12 17:01, zhangfei.gao@foxmail.com wrote:
> 
> Hi, Yi
> 
> On 2022/5/11 下午10:17, zhangfei.gao@foxmail.com wrote:
>>
>>
>> On 2022/5/10 下午10:08, Yi Liu wrote:
>>> On 2022/5/10 20:45, Jason Gunthorpe wrote:
>>>> On Tue, May 10, 2022 at 08:35:00PM +0800, Zhangfei Gao wrote:
>>>>> Thanks Yi and Eric,
>>>>> Then will wait for the updated iommufd kernel for the PCI MMIO region.
>>>>>
>>>>> Another question,
>>>>> How to get the iommu_domain in the ioctl.
>>>>
>>>> The ID of the iommu_domain (called the hwpt) it should be returned by
>>>> the vfio attach ioctl.
>>>
>>> yes, hwpt_id is returned by the vfio attach ioctl and recorded in
>>> qemu. You can query page table related capabilities with this id.
>>>
>>> https://lore.kernel.org/kvm/20220414104710.28534-16-yi.l.liu@intel.com/
>>>
>> Thanks Yi,
>>
>> Do we use iommufd_hw_pagetable_from_id in kernel?
>>
>> The qemu send hwpt_id via ioctl.
>> Currently VFIOIOMMUFDContainer has hwpt_list,
>> Which member is good to save hwpt_id, IOMMUTLBEntry?
> 
> Can VFIOIOMMUFDContainer  have multi hwpt?

yes, it is possible

> Since VFIOIOMMUFDContainer has hwpt_list now.
> If so, how to get specific hwpt from map/unmap_notify in hw/vfio/as.c, 
> where no vbasedev can be used for compare.
> 
> I am testing with a workaround, adding VFIOIOASHwpt *hwpt in 
> VFIOIOMMUFDContainer.
> And save hwpt when vfio_device_attach_container.
> 
>>
>> In kernel ioctl: iommufd_vfio_ioctl
>> @dev: Device to get an iommu_domain for
>> iommufd_hw_pagetable_from_id(struct iommufd_ctx *ictx, u32 pt_id, struct 
>> device *dev)
>> But iommufd_vfio_ioctl seems no para dev?
> 
> We can set dev=Null since IOMMUFD_OBJ_HW_PAGETABLE does not need dev.
> iommufd_hw_pagetable_from_id(ictx, hwpt_id, NULL)

this is not good. dev is passed in to this function to allocate domain
and also check sw_msi things. If you pass in a NULL, it may even unable
to get a domain for the hwpt. It won't work I guess.

> Thanks
>>
> 

-- 
Regards,
Yi Liu
