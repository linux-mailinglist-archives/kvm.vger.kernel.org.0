Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCB051850F
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 15:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbiECNJN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 09:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236066AbiECNJF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 09:09:05 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD185FB3
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 06:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651583130; x=1683119130;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Saq5D1l9gBId2QBRG/UpLWop+i7Xw659RDgA3kUNp7E=;
  b=HzBFb6Nhds0YT9Yq1i0uYjvOTzkbFBAxWpxtN3P/EXOE4YSEChAKReoN
   J1tsoWexppgx7YOVk6LIhEVDDkb49CrI1w0Y9JXGXY7JZ5HovHT/6tbkT
   5Ab9GAVSmDcBqwTa5m/vAV3k5JnkgjF0qVu7+LCLaOoj93yA6jjdUzUIM
   Gqdea0oR08dTCSz4Ccffs7i43ZfZ4zKnnG+i9+3KrEcQKyOZOk3HS9h/Q
   UOF1tgmEn8BWAj56YVYYneSXH0bv2DhcRzZRIKhXEWguSDXEgniHy6Ngl
   5F9eXJ6pGQ+8lW7sx4HvmWc9BqRnoDcT3Tlfeyi7lMgPqx2Nx45hzAtFr
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="249450590"
X-IronPort-AV: E=Sophos;i="5.91,195,1647327600"; 
   d="scan'208";a="249450590"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 06:05:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,195,1647327600"; 
   d="scan'208";a="708019376"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga001.fm.intel.com with ESMTP; 03 May 2022 06:05:28 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 3 May 2022 06:05:28 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 3 May 2022 06:05:28 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 3 May 2022 06:05:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JiY+jHgiKXHgfW0jkcTH80OczqP71r/fXjD4qlG3kMRhMDUJr/g7N0iRrN9LB9VQEI3lyPLhj0XOQnyDbuKt57GFbGTimZTQ1SpD3SW+Ujr7LUJPe3lcKIvbEKQf7fL5UZM3yfV1IdeTEWDkPYqJ4Yzt03Kwq4o6WbpQThErJN96/BtN0Xs/h63j9lrWhU/D8/DUWb1Kagvwo+4TZAfZIGSGgYOsWWpL7Y9717PvJnwXIVuN3WeZ+9gcPaUuD5WSlzsGvfBodpfNwKbTLJmE4VtSpkGDrI/B5pOmUp/SOk4HjvWxfoaOVNzp4+iHvS8ax3lBoftH+tgKo3MKfc+0uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R6TpQXQXxzwnszupnvgkxIcqO8UXdNAai7Ga2atZtrA=;
 b=XcQejtbp4LW5JIA6CTnxmEZVfv/5De6ktJ6BimsnCZwEbunqDS3+sqjTy/uGUg5wwl3FZScGvv6b8Z92Ut5XcZMoLyEe4W5FoIoM/iQB8/w34wtfSYX/kv+Df8+chhw0xBW6U7gogPFlGF0arfsHSCj9ZBMVTLLvAU/HG6nY1qPZ5qdbAHErrhDguFXCSfnv6ARNTNE91Bk0XUq65XYC1TOY9Q1Fe6rwGkATaIazJgcHT03kz6ORvipwUsLqTFD376g4ARii98jHSA67ie4NjqVb5WGJGSHboko5j0oNAyTTYbhZ7kR8epe/w/ypCaFC4p7Ay8duGyzuhVAHidIrIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by SN6PR11MB3216.namprd11.prod.outlook.com (2603:10b6:805:c1::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12; Tue, 3 May
 2022 13:05:24 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::71d2:84f6:64e1:4024%7]) with mapi id 15.20.5186.028; Tue, 3 May 2022
 13:05:24 +0000
Message-ID: <561d4aa3-533b-4ac7-cca1-4c27923be4c2@intel.com>
Date:   Tue, 3 May 2022 21:05:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [RFC 07/18] vfio: Add base object for VFIOContainer
Content-Language: en-US
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <qemu-devel@nongnu.org>, <thuth@redhat.com>,
        <farman@linux.ibm.com>, <mjrosato@linux.ibm.com>,
        <akrowiak@linux.ibm.com>, <pasic@linux.ibm.com>,
        <jjherne@linux.ibm.com>, <jasowang@redhat.com>,
        <kvm@vger.kernel.org>, <jgg@nvidia.com>, <nicolinc@nvidia.com>,
        <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <kevin.tian@intel.com>, <chao.p.peng@intel.com>,
        <yi.y.sun@intel.com>, <peterx@redhat.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <20220414104710.28534-8-yi.l.liu@intel.com> <YmuFv2s5TPuw7K/u@yekko>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <YmuFv2s5TPuw7K/u@yekko>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR0302CA0014.apcprd03.prod.outlook.com
 (2603:1096:202::24) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26c432c8-49ea-4a80-2dce-08da2d0595fd
X-MS-TrafficTypeDiagnostic: SN6PR11MB3216:EE_
X-Microsoft-Antispam-PRVS: <SN6PR11MB3216D597C85CF0F7CB03DB27C3C09@SN6PR11MB3216.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4JU8O+MSEPJ82y8xg5kJSLrREQ6fYyrbDQnd4nfqFp6eTYwIzWx7l76uh10t+wa1G3CQOQhWbR7ANwNd1porly2bml/8VWhk5sg+Yt1vb9bVRt7s7uBpp8wqnhW9q4G0Iz6bfPKSqoJ6L+XB+1E9X5jKk71DHhtZugAzpx3/SirZJjhynaMzDm92Gfa+8Xuw/LdO3ZwLU8HvqZeWJMWh7e4ilDvnCRhAucbGtAmD41UHy5Dc946LrcvfAXV9qXfPmxjGHhaFQt3QyVMbATfk+TnUcbiwpiSfqsICPtuphDb4ypBkhvnpdB7SqxS+Eu25G8JGucYUJND/vTF8VyNdcMR8KDBLlXHQqFtXbIRSX46/OG3bljEOZPbRV193FMt1UVujw6aPP7MDSQ2qTVv4w5jwEqBB/+Xywe12/WLERBFnp6Z9KFaC7Om8jR12lTgHVnJNjeupfJdL5ItAonB9DqLgSL/tgoiyTiLAP3p3O3ckFtLbO+qsAnJHccBsnuHVwNp/77Jjf9DE0BJwsjZez2oa4fypjDt5i+Xj0V4A7yU98uIqE8tWCWlZ/ed2LxjVjkimL/8T4nDuIgmJ+k0GFYR2Vz3i/m3JjlYVwiwmkowQaNMUg7QxfyBflQDVy+AgiFv4JWUAJNkRw39srqU+5cLIl/9/OqdKnC2kOTcKmrRRg5Z5uItr1jBqNLuPoV1cfKgB79BXwqfMIvINcFzacNTSTmnLQdDTuHkcOcD/brdAXy02jvdJiVite7p1OPVV8MbWzE3BBjAIjn+pDn29OrybMEtYKBqgLGrrZ+n3gBYlHVL03Ld+JF9pWWZvQWsnm/GtZy5TkGPV0Wi8TrR5KTM2mSp91YFXQWtTGTRLV6FhKEstzBfs/p2rDjuAzqIy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(66476007)(36756003)(8676002)(31696002)(4326008)(66946007)(86362001)(82960400001)(6666004)(508600001)(38100700002)(6486002)(966005)(53546011)(6512007)(6916009)(26005)(2616005)(6506007)(316002)(31686004)(186003)(5660300002)(2906002)(7416002)(8936002)(30864003)(83380400001)(2004002)(43740500002)(45980500001)(559001)(579004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aU9zbTZnd0VBcjZNL0J2Ymd3RU0xTGNqcGl5cUlWdHd0ZU14ZUFleWxYcXBD?=
 =?utf-8?B?STl3V1pOeFRDQmNjZzZKdVpkRE0rZk40S285Zlh0cUE2ZGlQOFVWMnRjZlUy?=
 =?utf-8?B?SlJ1YmN1U1pPZUpiMUVEekg2SGhZR2lhbzkxWW4zYUN5TmhOM0JrM0dtWjVO?=
 =?utf-8?B?UkxuLzQ3NDVLZWI5Ym5MY2pxZkxFbGlhWFNXZStjaytzUm1GUXVjenRYbHZm?=
 =?utf-8?B?SDZRcUJrbElzTkZpKzJSbGpzeTdQM2R0WC9mQS9SU2tnM0VwNkZFR3NWVkdB?=
 =?utf-8?B?RTY2WXpIT1gwWkRQKzZDckF5Ui83NzgzOEZuUm55RFA5eEhFd0syanJtb0Z6?=
 =?utf-8?B?NnFJYXNYdGprcXp0QXg2ODloZDJyMUU1R1MyaVZtd05oZ3Q5L1hPL0pURDNU?=
 =?utf-8?B?cU5USEllQ3BFZlB5cC9hM2hscWw2L2xjcExlM2JUZnAzS1BVMjljQmhZN2dD?=
 =?utf-8?B?UE5GQWV2YUJLRkxtVVh1ZzNPWDBsUWc4WklzSVY0Wk9UbFI0Qk5TM2F0Mkwv?=
 =?utf-8?B?cmUxOUJUT0lqVlNiZ2IzcG9NMi9WemdUbTlCendiVlQ5T0ZaRVhMTHFxWi8x?=
 =?utf-8?B?ZnhKOFVPVHdrTlVvRnVXK1RObUpLUkJNYUh4T3QzV296aXhrTGwxNW9VR2to?=
 =?utf-8?B?RU1KOU50QXA5cmZVU09hejg1UWp4aHRLbVk0NHlMczVXSnM1aERIU25xVEV5?=
 =?utf-8?B?V2o1WU54RGFmZ0xscHVnYTEyMUVPRjlkVzlwSDNTbklLMnh1cXBrVHN0b0Nt?=
 =?utf-8?B?bk1qQkdxd0JrWGlHTzlLbzI3SVpUQnJpcm9SRXZycDVXSW0zRTRGOFRab0d6?=
 =?utf-8?B?SVRBRUl3YkFHN0x3ZWFkNEgvdllJMVRqWlNtZ2xRL296OG1IU2phOWlvY1NO?=
 =?utf-8?B?d041S216aXUxVExieUdhWnQ4N1pPMW1mWDdYVHBlaXdXaFdHYkYyeWozS3RD?=
 =?utf-8?B?RitzeHFJMzBXWnhqa1RuVlA1dXJ1VGNpY1pUeHh0cDVtdHpEdmE1R1VVeHM3?=
 =?utf-8?B?VzZmYzNidW0zcC83MWxQaUI5SjVWR0xJaGMwUGtiSkxqVWd1b25md3NEVGVo?=
 =?utf-8?B?ejhxdFppa2doUlFvVFV0SmVmMXhkZUthVGtqd1BjSmlqaW02TzUybEZKVHh2?=
 =?utf-8?B?Snc1NWdpTGM1V1k4aHFVR0d1VEZnZnJkYkdMaEV3N3JDdGZIU0R6a2RDRDZ6?=
 =?utf-8?B?cCtOem9ESjBzZURZU3lwZW04M2c3VjMrWmRNV2JQNVc1SVYreEY4aUkwRkRH?=
 =?utf-8?B?eEZMeXdPT0V5RkhjOHB3SnFmYTlQSlo3Y3I4MVBIcnRYdjREcUJQYmRSeXph?=
 =?utf-8?B?b2VNanpTNFo2SnhURnVBanBNYng3ZG8zMkxjdFpzdDBlVXJYQU9xZXErL0Yv?=
 =?utf-8?B?cTllc0Y1RTdmQktiNG82S1NVcjhYTUUxbXM0eEdiQzh3M0p1dnZuS3UzVlhQ?=
 =?utf-8?B?YStUSUdEYVpLcy9wUlhrWVJUL2JBZ1lmbm9qWGNYYzByUFJFM1o0WWNVc255?=
 =?utf-8?B?NlBMc251NmtxRXZSMHBkaTg4MVVCaTZ3OENDTGxkMXdXaTZrY0lSdEtueCtQ?=
 =?utf-8?B?d1dNM1ZCcFVpTWJySDFSekNVMXB1eVZSb2I4U1EvWjNFRTdLRFpNOCthd25Z?=
 =?utf-8?B?S3lmdzEyZitvWjM2TE9ZQWtyaGVNamJXNnpkUUxCNXJOUmRDdUtWcGMxVEZk?=
 =?utf-8?B?ZXh1dVZkaTl0TGVzRm9KMW15SnVraTMyQUg0cXJ0a1cyRkNSdFV0czVUOXB3?=
 =?utf-8?B?RnprOC83dnFydzdCdnZ1UGRTMUpkYzl6MFRkTksrMTdKZzhhVkE0UE1zZXFm?=
 =?utf-8?B?blpsRjMrd3dsdDhCeCtHRmkzR0JPSG5KaTZoUkJLT3JzNnoyeGFNRVNCQzhE?=
 =?utf-8?B?QXFqUXczNFNQTDUyMmVMcWtvTGxLTDRtbzYzTlh2UENWWTgzclJhZ2w2aS9K?=
 =?utf-8?B?TDV4ZjJHcHYyYjhWOEtpZlNNczR5dlN1cFRoeU0vSHM2ODY2U2wyOUJIdmly?=
 =?utf-8?B?MmFzN3AzbE9HTlJpWkZPdWVHSXBDamxiS2IzTUIzaTZZd3ovamdpUDNlM01U?=
 =?utf-8?B?dzJsT1ZPeDhDNDl3eHZlZlNsRmllL1RyWXgrcnJHaml0U2c2YXhlMlJUZU9B?=
 =?utf-8?B?RlpaeEtXZHZ1VjdqV1RidExET2IwK3JLK3ZwSWRoQlAwblV0RFVQRTRMVnhI?=
 =?utf-8?B?N3k0TkR5QmpOZDg3Y3o1TUdtOCtYTitOV1Q4OXFYQU9ac2duSFRqOUR3UmdO?=
 =?utf-8?B?cXFrZlgyU2pXb2g0SmpvUVc5UktZSEJYeE5aUjF1dXhTdzRyZFd3NGtKeGgr?=
 =?utf-8?B?K3FVeDl0eDFZREt4MURVR3E1UWpsVjRxYkJMYURuVUtleDVHV3krZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c432c8-49ea-4a80-2dce-08da2d0595fd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 13:05:24.4451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HQmcG5NR3Wc12ySjkhFtF62puzjlUGI3ydyGxS4TO4c3Z/pqUaNIdaUxist4cAzcj7JdnfhyWY4kfXrxOGW3mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3216
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/4/29 14:29, David Gibson wrote:
> On Thu, Apr 14, 2022 at 03:46:59AM -0700, Yi Liu wrote:
>> Qomify the VFIOContainer object which acts as a base class for a
>> container. This base class is derived into the legacy VFIO container
>> and later on, into the new iommufd based container.
> 
> You certainly need the abstraction, but I'm not sure QOM is the right
> way to accomplish it in this case.  The QOM class of things is visible
> to the user/config layer via QMP (and sometimes command line).  It
> doesn't necessarily correspond to guest visible differences, but it
> often does.
got it. btw. this series adds an iommufd option in below. do you think
it can suit the notion that QOM class mostly be visible to user/config?

https://lore.kernel.org/kvm/20220414104710.28534-19-yi.l.liu@intel.com/

> AIUI, the idea here is that the back end in use should be an
> implementation detail which doesn't affect the interfaces outside the
> vfio subsystem itself.  If that's the case QOM may not be a great
> fit, even though you can probably make it work.

yes, currently, the implementation detail is just for vfio subsystem. so
if iommufd option doesn't make too much sense to have QOM for the
abstraciton, I may just add an abstraction within vfio as you suggested.

>> The base class implements generic code such as code related to
>> memory_listener and address space management whereas the derived
>> class implements callbacks that depend on the kernel user space
>> being used.
>>
>> 'as.c' only manipulates the base class object with wrapper functions
>> that call the right class functions. Existing 'container.c' code is
>> converted to implement the legacy container class functions.
>>
>> Existing migration code only works with the legacy container.
>> Also 'spapr.c' isn't BE agnostic.
>>
>> Below is the object. It's named as VFIOContainer, old VFIOContainer
>> is replaced with VFIOLegacyContainer.
>>
>> struct VFIOContainer {
>>      /* private */
>>      Object parent_obj;
>>
>>      VFIOAddressSpace *space;
>>      MemoryListener listener;
>>      Error *error;
>>      bool initialized;
>>      bool dirty_pages_supported;
>>      uint64_t dirty_pgsizes;
>>      uint64_t max_dirty_bitmap_size;
>>      unsigned long pgsizes;
>>      unsigned int dma_max_mappings;
>>      QLIST_HEAD(, VFIOGuestIOMMU) giommu_list;
>>      QLIST_HEAD(, VFIOHostDMAWindow) hostwin_list;
>>      QLIST_HEAD(, VFIORamDiscardListener) vrdl_list;
>>      QLIST_ENTRY(VFIOContainer) next;
>> };
>>
>> struct VFIOLegacyContainer {
>>      VFIOContainer obj;
>>      int fd; /* /dev/vfio/vfio, empowered by the attached groups */
>>      MemoryListener prereg_listener;
>>      unsigned iommu_type;
>>      QLIST_HEAD(, VFIOGroup) group_list;
>> };
>>
>> Co-authored-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   hw/vfio/as.c                         |  48 +++---
>>   hw/vfio/container-obj.c              | 195 +++++++++++++++++++++++
>>   hw/vfio/container.c                  | 224 ++++++++++++++++-----------
>>   hw/vfio/meson.build                  |   1 +
>>   hw/vfio/migration.c                  |   4 +-
>>   hw/vfio/pci.c                        |   4 +-
>>   hw/vfio/spapr.c                      |  22 +--
>>   include/hw/vfio/vfio-common.h        |  78 ++--------
>>   include/hw/vfio/vfio-container-obj.h | 154 ++++++++++++++++++
>>   9 files changed, 540 insertions(+), 190 deletions(-)
>>   create mode 100644 hw/vfio/container-obj.c
>>   create mode 100644 include/hw/vfio/vfio-container-obj.h
>>
>> diff --git a/hw/vfio/as.c b/hw/vfio/as.c
>> index 4181182808..37423d2c89 100644
>> --- a/hw/vfio/as.c
>> +++ b/hw/vfio/as.c
>> @@ -215,9 +215,9 @@ static void vfio_iommu_map_notify(IOMMUNotifier *n, IOMMUTLBEntry *iotlb)
>>            * of vaddr will always be there, even if the memory object is
>>            * destroyed and its backing memory munmap-ed.
>>            */
>> -        ret = vfio_dma_map(container, iova,
>> -                           iotlb->addr_mask + 1, vaddr,
>> -                           read_only);
>> +        ret = vfio_container_dma_map(container, iova,
>> +                                     iotlb->addr_mask + 1, vaddr,
>> +                                     read_only);
>>           if (ret) {
>>               error_report("vfio_dma_map(%p, 0x%"HWADDR_PRIx", "
>>                            "0x%"HWADDR_PRIx", %p) = %d (%m)",
>> @@ -225,7 +225,8 @@ static void vfio_iommu_map_notify(IOMMUNotifier *n, IOMMUTLBEntry *iotlb)
>>                            iotlb->addr_mask + 1, vaddr, ret);
>>           }
>>       } else {
>> -        ret = vfio_dma_unmap(container, iova, iotlb->addr_mask + 1, iotlb);
>> +        ret = vfio_container_dma_unmap(container, iova,
>> +                                       iotlb->addr_mask + 1, iotlb);
>>           if (ret) {
>>               error_report("vfio_dma_unmap(%p, 0x%"HWADDR_PRIx", "
>>                            "0x%"HWADDR_PRIx") = %d (%m)",
>> @@ -242,12 +243,13 @@ static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
>>   {
>>       VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
>>                                                   listener);
>> +    VFIOContainer *container = vrdl->container;
>>       const hwaddr size = int128_get64(section->size);
>>       const hwaddr iova = section->offset_within_address_space;
>>       int ret;
>>   
>>       /* Unmap with a single call. */
>> -    ret = vfio_dma_unmap(vrdl->container, iova, size , NULL);
>> +    ret = vfio_container_dma_unmap(container, iova, size , NULL);
>>       if (ret) {
>>           error_report("%s: vfio_dma_unmap() failed: %s", __func__,
>>                        strerror(-ret));
>> @@ -259,6 +261,7 @@ static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
>>   {
>>       VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
>>                                                   listener);
>> +    VFIOContainer *container = vrdl->container;
>>       const hwaddr end = section->offset_within_region +
>>                          int128_get64(section->size);
>>       hwaddr start, next, iova;
>> @@ -277,8 +280,8 @@ static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
>>                  section->offset_within_address_space;
>>           vaddr = memory_region_get_ram_ptr(section->mr) + start;
>>   
>> -        ret = vfio_dma_map(vrdl->container, iova, next - start,
>> -                           vaddr, section->readonly);
>> +        ret = vfio_container_dma_map(container, iova, next - start,
>> +                                     vaddr, section->readonly);
>>           if (ret) {
>>               /* Rollback */
>>               vfio_ram_discard_notify_discard(rdl, section);
>> @@ -530,8 +533,8 @@ static void vfio_listener_region_add(MemoryListener *listener,
>>           }
>>       }
>>   
>> -    ret = vfio_dma_map(container, iova, int128_get64(llsize),
>> -                       vaddr, section->readonly);
>> +    ret = vfio_container_dma_map(container, iova, int128_get64(llsize),
>> +                                 vaddr, section->readonly);
>>       if (ret) {
>>           error_setg(&err, "vfio_dma_map(%p, 0x%"HWADDR_PRIx", "
>>                      "0x%"HWADDR_PRIx", %p) = %d (%m)",
>> @@ -656,7 +659,8 @@ static void vfio_listener_region_del(MemoryListener *listener,
>>           if (int128_eq(llsize, int128_2_64())) {
>>               /* The unmap ioctl doesn't accept a full 64-bit span. */
>>               llsize = int128_rshift(llsize, 1);
>> -            ret = vfio_dma_unmap(container, iova, int128_get64(llsize), NULL);
>> +            ret = vfio_container_dma_unmap(container, iova,
>> +                                           int128_get64(llsize), NULL);
>>               if (ret) {
>>                   error_report("vfio_dma_unmap(%p, 0x%"HWADDR_PRIx", "
>>                                "0x%"HWADDR_PRIx") = %d (%m)",
>> @@ -664,7 +668,8 @@ static void vfio_listener_region_del(MemoryListener *listener,
>>               }
>>               iova += int128_get64(llsize);
>>           }
>> -        ret = vfio_dma_unmap(container, iova, int128_get64(llsize), NULL);
>> +        ret = vfio_container_dma_unmap(container, iova,
>> +                                       int128_get64(llsize), NULL);
>>           if (ret) {
>>               error_report("vfio_dma_unmap(%p, 0x%"HWADDR_PRIx", "
>>                            "0x%"HWADDR_PRIx") = %d (%m)",
>> @@ -681,14 +686,14 @@ static void vfio_listener_log_global_start(MemoryListener *listener)
>>   {
>>       VFIOContainer *container = container_of(listener, VFIOContainer, listener);
>>   
>> -    vfio_set_dirty_page_tracking(container, true);
>> +    vfio_container_set_dirty_page_tracking(container, true);
>>   }
>>   
>>   static void vfio_listener_log_global_stop(MemoryListener *listener)
>>   {
>>       VFIOContainer *container = container_of(listener, VFIOContainer, listener);
>>   
>> -    vfio_set_dirty_page_tracking(container, false);
>> +    vfio_container_set_dirty_page_tracking(container, false);
>>   }
>>   
>>   typedef struct {
>> @@ -717,8 +722,9 @@ static void vfio_iommu_map_dirty_notify(IOMMUNotifier *n, IOMMUTLBEntry *iotlb)
>>       if (vfio_get_xlat_addr(iotlb, NULL, &translated_addr, NULL)) {
>>           int ret;
>>   
>> -        ret = vfio_get_dirty_bitmap(container, iova, iotlb->addr_mask + 1,
>> -                                    translated_addr);
>> +        ret = vfio_container_get_dirty_bitmap(container, iova,
>> +                                              iotlb->addr_mask + 1,
>> +                                              translated_addr);
>>           if (ret) {
>>               error_report("vfio_iommu_map_dirty_notify(%p, 0x%"HWADDR_PRIx", "
>>                            "0x%"HWADDR_PRIx") = %d (%m)",
>> @@ -742,11 +748,13 @@ static int vfio_ram_discard_get_dirty_bitmap(MemoryRegionSection *section,
>>        * Sync the whole mapped region (spanning multiple individual mappings)
>>        * in one go.
>>        */
>> -    return vfio_get_dirty_bitmap(vrdl->container, iova, size, ram_addr);
>> +    return vfio_container_get_dirty_bitmap(vrdl->container, iova,
>> +                                           size, ram_addr);
>>   }
>>   
>> -static int vfio_sync_ram_discard_listener_dirty_bitmap(VFIOContainer *container,
>> -                                                   MemoryRegionSection *section)
>> +static int
>> +vfio_sync_ram_discard_listener_dirty_bitmap(VFIOContainer *container,
>> +                                            MemoryRegionSection *section)
>>   {
>>       RamDiscardManager *rdm = memory_region_get_ram_discard_manager(section->mr);
>>       VFIORamDiscardListener *vrdl = NULL;
>> @@ -810,7 +818,7 @@ static int vfio_sync_dirty_bitmap(VFIOContainer *container,
>>       ram_addr = memory_region_get_ram_addr(section->mr) +
>>                  section->offset_within_region;
>>   
>> -    return vfio_get_dirty_bitmap(container,
>> +    return vfio_container_get_dirty_bitmap(container,
>>                      REAL_HOST_PAGE_ALIGN(section->offset_within_address_space),
>>                      int128_get64(section->size), ram_addr);
>>   }
>> @@ -825,7 +833,7 @@ static void vfio_listener_log_sync(MemoryListener *listener,
>>           return;
>>       }
>>   
>> -    if (vfio_devices_all_dirty_tracking(container)) {
>> +    if (vfio_container_devices_all_dirty_tracking(container)) {
>>           vfio_sync_dirty_bitmap(container, section);
>>       }
>>   }
>> diff --git a/hw/vfio/container-obj.c b/hw/vfio/container-obj.c
>> new file mode 100644
>> index 0000000000..40c1e2a2b5
>> --- /dev/null
>> +++ b/hw/vfio/container-obj.c
>> @@ -0,0 +1,195 @@
>> +/*
>> + * VFIO CONTAINER BASE OBJECT
>> + *
>> + * Copyright (C) 2022 Intel Corporation.
>> + * Copyright Red Hat, Inc. 2022
>> + *
>> + * Authors: Yi Liu <yi.l.liu@intel.com>
>> + *          Eric Auger <eric.auger@redhat.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> +
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> +
>> + * You should have received a copy of the GNU General Public License along
>> + * with this program; if not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#include "qemu/osdep.h"
>> +#include "qapi/error.h"
>> +#include "qemu/error-report.h"
>> +#include "qom/object.h"
>> +#include "qapi/visitor.h"
>> +#include "hw/vfio/vfio-container-obj.h"
>> +
>> +bool vfio_container_check_extension(VFIOContainer *container,
>> +                                    VFIOContainerFeature feat)
>> +{
>> +    VFIOContainerClass *vccs = VFIO_CONTAINER_OBJ_GET_CLASS(container);
>> +
>> +    if (!vccs->check_extension) {
>> +        return false;
>> +    }
>> +
>> +    return vccs->check_extension(container, feat);
>> +}
>> +
>> +int vfio_container_dma_map(VFIOContainer *container,
>> +                           hwaddr iova, ram_addr_t size,
>> +                           void *vaddr, bool readonly)
>> +{
>> +    VFIOContainerClass *vccs = VFIO_CONTAINER_OBJ_GET_CLASS(container);
>> +
>> +    if (!vccs->dma_map) {
>> +        return -EINVAL;
>> +    }
>> +
>> +    return vccs->dma_map(container, iova, size, vaddr, readonly);
>> +}
>> +
>> +int vfio_container_dma_unmap(VFIOContainer *container,
>> +                             hwaddr iova, ram_addr_t size,
>> +                             IOMMUTLBEntry *iotlb)
>> +{
>> +    VFIOContainerClass *vccs = VFIO_CONTAINER_OBJ_GET_CLASS(container);
>> +
>> +    vccs = VFIO_CONTAINER_OBJ_GET_CLASS(container);
>> +
>> +    if (!vccs->dma_unmap) {
>> +        return -EINVAL;
>> +    }
>> +
>> +    return vccs->dma_unmap(container, iova, size, iotlb);
>> +}
>> +
>> +void vfio_container_set_dirty_page_tracking(VFIOContainer *container,
>> +                                            bool start)
>> +{
>> +    VFIOContainerClass *vccs = VFIO_CONTAINER_OBJ_GET_CLASS(container);
>> +
>> +    if (!vccs->set_dirty_page_tracking) {
>> +        return;
>> +    }
>> +
>> +    vccs->set_dirty_page_tracking(container, start);
>> +}
>> +
>> +bool vfio_container_devices_all_dirty_tracking(VFIOContainer *container)
>> +{
>> +    VFIOContainerClass *vccs = VFIO_CONTAINER_OBJ_GET_CLASS(container);
>> +
>> +    if (!vccs->devices_all_dirty_tracking) {
>> +        return false;
>> +    }
>> +
>> +    return vccs->devices_all_dirty_tracking(container);
>> +}
>> +
>> +int vfio_container_get_dirty_bitmap(VFIOContainer *container, uint64_t iova,
>> +                                    uint64_t size, ram_addr_t ram_addr)
>> +{
>> +    VFIOContainerClass *vccs = VFIO_CONTAINER_OBJ_GET_CLASS(container);
>> +
>> +    if (!vccs->get_dirty_bitmap) {
>> +        return -EINVAL;
>> +    }
>> +
>> +    return vccs->get_dirty_bitmap(container, iova, size, ram_addr);
>> +}
>> +
>> +int vfio_container_add_section_window(VFIOContainer *container,
>> +                                      MemoryRegionSection *section,
>> +                                      Error **errp)
>> +{
>> +    VFIOContainerClass *vccs = VFIO_CONTAINER_OBJ_GET_CLASS(container);
>> +
>> +    if (!vccs->add_window) {
>> +        return 0;
>> +    }
>> +
>> +    return vccs->add_window(container, section, errp);
>> +}
>> +
>> +void vfio_container_del_section_window(VFIOContainer *container,
>> +                                       MemoryRegionSection *section)
>> +{
>> +    VFIOContainerClass *vccs = VFIO_CONTAINER_OBJ_GET_CLASS(container);
>> +
>> +    if (!vccs->del_window) {
>> +        return;
>> +    }
>> +
>> +    return vccs->del_window(container, section);
>> +}
>> +
>> +void vfio_container_init(void *_container, size_t instance_size,
>> +                         const char *mrtypename,
>> +                         VFIOAddressSpace *space)
>> +{
>> +    VFIOContainer *container;
>> +
>> +    object_initialize(_container, instance_size, mrtypename);
>> +    container = VFIO_CONTAINER_OBJ(_container);
>> +
>> +    container->space = space;
>> +    container->error = NULL;
>> +    container->dirty_pages_supported = false;
>> +    container->dma_max_mappings = 0;
>> +    QLIST_INIT(&container->giommu_list);
>> +    QLIST_INIT(&container->hostwin_list);
>> +    QLIST_INIT(&container->vrdl_list);
>> +}
>> +
>> +void vfio_container_destroy(VFIOContainer *container)
>> +{
>> +    VFIORamDiscardListener *vrdl, *vrdl_tmp;
>> +    VFIOGuestIOMMU *giommu, *tmp;
>> +    VFIOHostDMAWindow *hostwin, *next;
>> +
>> +    QLIST_SAFE_REMOVE(container, next);
>> +
>> +    QLIST_FOREACH_SAFE(vrdl, &container->vrdl_list, next, vrdl_tmp) {
>> +        RamDiscardManager *rdm;
>> +
>> +        rdm = memory_region_get_ram_discard_manager(vrdl->mr);
>> +        ram_discard_manager_unregister_listener(rdm, &vrdl->listener);
>> +        QLIST_REMOVE(vrdl, next);
>> +        g_free(vrdl);
>> +    }
>> +
>> +    QLIST_FOREACH_SAFE(giommu, &container->giommu_list, giommu_next, tmp) {
>> +        memory_region_unregister_iommu_notifier(
>> +                MEMORY_REGION(giommu->iommu_mr), &giommu->n);
>> +        QLIST_REMOVE(giommu, giommu_next);
>> +        g_free(giommu);
>> +    }
>> +
>> +    QLIST_FOREACH_SAFE(hostwin, &container->hostwin_list, hostwin_next,
>> +                       next) {
>> +        QLIST_REMOVE(hostwin, hostwin_next);
>> +        g_free(hostwin);
>> +    }
>> +
>> +    object_unref(&container->parent_obj);
>> +}
>> +
>> +static const TypeInfo vfio_container_info = {
>> +    .parent             = TYPE_OBJECT,
>> +    .name               = TYPE_VFIO_CONTAINER_OBJ,
>> +    .class_size         = sizeof(VFIOContainerClass),
>> +    .instance_size      = sizeof(VFIOContainer),
>> +    .abstract           = true,
>> +};
>> +
>> +static void vfio_container_register_types(void)
>> +{
>> +    type_register_static(&vfio_container_info);
>> +}
>> +
>> +type_init(vfio_container_register_types)
>> diff --git a/hw/vfio/container.c b/hw/vfio/container.c
>> index 9c665c1720..79972064d3 100644
>> --- a/hw/vfio/container.c
>> +++ b/hw/vfio/container.c
>> @@ -50,6 +50,8 @@
>>   static int vfio_kvm_device_fd = -1;
>>   #endif
>>   
>> +#define TYPE_VFIO_LEGACY_CONTAINER "qemu:vfio-legacy-container"
>> +
>>   VFIOGroupList vfio_group_list =
>>       QLIST_HEAD_INITIALIZER(vfio_group_list);
>>   
>> @@ -76,8 +78,10 @@ bool vfio_mig_active(void)
>>       return true;
>>   }
>>   
>> -bool vfio_devices_all_dirty_tracking(VFIOContainer *container)
>> +static bool vfio_devices_all_dirty_tracking(VFIOContainer *bcontainer)
>>   {
>> +    VFIOLegacyContainer *container = container_of(bcontainer,
>> +                                                  VFIOLegacyContainer, obj);
>>       VFIOGroup *group;
>>       VFIODevice *vbasedev;
>>       MigrationState *ms = migrate_get_current();
>> @@ -103,7 +107,7 @@ bool vfio_devices_all_dirty_tracking(VFIOContainer *container)
>>       return true;
>>   }
>>   
>> -bool vfio_devices_all_running_and_saving(VFIOContainer *container)
>> +static bool vfio_devices_all_running_and_saving(VFIOLegacyContainer *container)
>>   {
>>       VFIOGroup *group;
>>       VFIODevice *vbasedev;
>> @@ -132,10 +136,11 @@ bool vfio_devices_all_running_and_saving(VFIOContainer *container)
>>       return true;
>>   }
>>   
>> -static int vfio_dma_unmap_bitmap(VFIOContainer *container,
>> +static int vfio_dma_unmap_bitmap(VFIOLegacyContainer *container,
>>                                    hwaddr iova, ram_addr_t size,
>>                                    IOMMUTLBEntry *iotlb)
>>   {
>> +    VFIOContainer *bcontainer = &container->obj;
>>       struct vfio_iommu_type1_dma_unmap *unmap;
>>       struct vfio_bitmap *bitmap;
>>       uint64_t pages = REAL_HOST_PAGE_ALIGN(size) / qemu_real_host_page_size;
>> @@ -159,7 +164,7 @@ static int vfio_dma_unmap_bitmap(VFIOContainer *container,
>>       bitmap->size = ROUND_UP(pages, sizeof(__u64) * BITS_PER_BYTE) /
>>                      BITS_PER_BYTE;
>>   
>> -    if (bitmap->size > container->max_dirty_bitmap_size) {
>> +    if (bitmap->size > bcontainer->max_dirty_bitmap_size) {
>>           error_report("UNMAP: Size of bitmap too big 0x%"PRIx64,
>>                        (uint64_t)bitmap->size);
>>           ret = -E2BIG;
>> @@ -189,10 +194,12 @@ unmap_exit:
>>   /*
>>    * DMA - Mapping and unmapping for the "type1" IOMMU interface used on x86
>>    */
>> -int vfio_dma_unmap(VFIOContainer *container,
>> -                   hwaddr iova, ram_addr_t size,
>> -                   IOMMUTLBEntry *iotlb)
>> +static int vfio_dma_unmap(VFIOContainer *bcontainer,
>> +                          hwaddr iova, ram_addr_t size,
>> +                          IOMMUTLBEntry *iotlb)
>>   {
>> +    VFIOLegacyContainer *container = container_of(bcontainer,
>> +                                                  VFIOLegacyContainer, obj);
>>       struct vfio_iommu_type1_dma_unmap unmap = {
>>           .argsz = sizeof(unmap),
>>           .flags = 0,
>> @@ -200,7 +207,7 @@ int vfio_dma_unmap(VFIOContainer *container,
>>           .size = size,
>>       };
>>   
>> -    if (iotlb && container->dirty_pages_supported &&
>> +    if (iotlb && bcontainer->dirty_pages_supported &&
>>           vfio_devices_all_running_and_saving(container)) {
>>           return vfio_dma_unmap_bitmap(container, iova, size, iotlb);
>>       }
>> @@ -221,7 +228,7 @@ int vfio_dma_unmap(VFIOContainer *container,
>>           if (errno == EINVAL && unmap.size && !(unmap.iova + unmap.size) &&
>>               container->iommu_type == VFIO_TYPE1v2_IOMMU) {
>>               trace_vfio_dma_unmap_overflow_workaround();
>> -            unmap.size -= 1ULL << ctz64(container->pgsizes);
>> +            unmap.size -= 1ULL << ctz64(bcontainer->pgsizes);
>>               continue;
>>           }
>>           error_report("VFIO_UNMAP_DMA failed: %s", strerror(errno));
>> @@ -231,9 +238,22 @@ int vfio_dma_unmap(VFIOContainer *container,
>>       return 0;
>>   }
>>   
>> -int vfio_dma_map(VFIOContainer *container, hwaddr iova,
>> -                 ram_addr_t size, void *vaddr, bool readonly)
>> +static bool vfio_legacy_container_check_extension(VFIOContainer *bcontainer,
>> +                                                  VFIOContainerFeature feat)
>>   {
>> +    switch (feat) {
>> +    case VFIO_FEAT_LIVE_MIGRATION:
>> +        return true;
>> +    default:
>> +        return false;
>> +    };
>> +}
>> +
>> +static int vfio_dma_map(VFIOContainer *bcontainer, hwaddr iova,
>> +                       ram_addr_t size, void *vaddr, bool readonly)
>> +{
>> +    VFIOLegacyContainer *container = container_of(bcontainer,
>> +                                                  VFIOLegacyContainer, obj);
>>       struct vfio_iommu_type1_dma_map map = {
>>           .argsz = sizeof(map),
>>           .flags = VFIO_DMA_MAP_FLAG_READ,
>> @@ -252,7 +272,7 @@ int vfio_dma_map(VFIOContainer *container, hwaddr iova,
>>        * the VGA ROM space.
>>        */
>>       if (ioctl(container->fd, VFIO_IOMMU_MAP_DMA, &map) == 0 ||
>> -        (errno == EBUSY && vfio_dma_unmap(container, iova, size, NULL) == 0 &&
>> +        (errno == EBUSY && vfio_dma_unmap(bcontainer, iova, size, NULL) == 0 &&
>>            ioctl(container->fd, VFIO_IOMMU_MAP_DMA, &map) == 0)) {
>>           return 0;
>>       }
>> @@ -261,8 +281,10 @@ int vfio_dma_map(VFIOContainer *container, hwaddr iova,
>>       return -errno;
>>   }
>>   
>> -void vfio_set_dirty_page_tracking(VFIOContainer *container, bool start)
>> +static void vfio_set_dirty_page_tracking(VFIOContainer *bcontainer, bool start)
>>   {
>> +    VFIOLegacyContainer *container = container_of(bcontainer,
>> +                                                  VFIOLegacyContainer, obj);
>>       int ret;
>>       struct vfio_iommu_type1_dirty_bitmap dirty = {
>>           .argsz = sizeof(dirty),
>> @@ -281,9 +303,11 @@ void vfio_set_dirty_page_tracking(VFIOContainer *container, bool start)
>>       }
>>   }
>>   
>> -int vfio_get_dirty_bitmap(VFIOContainer *container, uint64_t iova,
>> -                          uint64_t size, ram_addr_t ram_addr)
>> +static int vfio_get_dirty_bitmap(VFIOContainer *bcontainer, uint64_t iova,
>> +                                 uint64_t size, ram_addr_t ram_addr)
>>   {
>> +    VFIOLegacyContainer *container = container_of(bcontainer,
>> +                                                  VFIOLegacyContainer, obj);
>>       struct vfio_iommu_type1_dirty_bitmap *dbitmap;
>>       struct vfio_iommu_type1_dirty_bitmap_get *range;
>>       uint64_t pages;
>> @@ -333,18 +357,23 @@ err_out:
>>       return ret;
>>   }
>>   
>> -static void vfio_listener_release(VFIOContainer *container)
>> +static void vfio_listener_release(VFIOLegacyContainer *container)
>>   {
>> -    memory_listener_unregister(&container->listener);
>> +    VFIOContainer *bcontainer = &container->obj;
>> +
>> +    memory_listener_unregister(&bcontainer->listener);
>>       if (container->iommu_type == VFIO_SPAPR_TCE_v2_IOMMU) {
>>           memory_listener_unregister(&container->prereg_listener);
>>       }
>>   }
>>   
>> -int vfio_container_add_section_window(VFIOContainer *container,
>> -                                      MemoryRegionSection *section,
>> -                                      Error **errp)
>> +static int
>> +vfio_legacy_container_add_section_window(VFIOContainer *bcontainer,
>> +                                         MemoryRegionSection *section,
>> +                                         Error **errp)
>>   {
>> +    VFIOLegacyContainer *container = container_of(bcontainer,
>> +                                                  VFIOLegacyContainer, obj);
>>       VFIOHostDMAWindow *hostwin;
>>       hwaddr pgsize = 0;
>>       int ret;
>> @@ -354,7 +383,7 @@ int vfio_container_add_section_window(VFIOContainer *container,
>>       }
>>   
>>       /* For now intersections are not allowed, we may relax this later */
>> -    QLIST_FOREACH(hostwin, &container->hostwin_list, hostwin_next) {
>> +    QLIST_FOREACH(hostwin, &bcontainer->hostwin_list, hostwin_next) {
>>           if (ranges_overlap(hostwin->min_iova,
>>                              hostwin->max_iova - hostwin->min_iova + 1,
>>                              section->offset_within_address_space,
>> @@ -376,7 +405,7 @@ int vfio_container_add_section_window(VFIOContainer *container,
>>           return ret;
>>       }
>>   
>> -    vfio_host_win_add(container, section->offset_within_address_space,
>> +    vfio_host_win_add(bcontainer, section->offset_within_address_space,
>>                         section->offset_within_address_space +
>>                         int128_get64(section->size) - 1, pgsize);
>>   #ifdef CONFIG_KVM
>> @@ -409,16 +438,20 @@ int vfio_container_add_section_window(VFIOContainer *container,
>>       return 0;
>>   }
>>   
>> -void vfio_container_del_section_window(VFIOContainer *container,
>> -                                       MemoryRegionSection *section)
>> +static void
>> +vfio_legacy_container_del_section_window(VFIOContainer *bcontainer,
>> +                                         MemoryRegionSection *section)
>>   {
>> +    VFIOLegacyContainer *container = container_of(bcontainer,
>> +                                                  VFIOLegacyContainer, obj);
>> +
>>       if (container->iommu_type != VFIO_SPAPR_TCE_v2_IOMMU) {
>>           return;
>>       }
>>   
>>       vfio_spapr_remove_window(container,
>>                                section->offset_within_address_space);
>> -    if (vfio_host_win_del(container,
>> +    if (vfio_host_win_del(bcontainer,
>>                             section->offset_within_address_space,
>>                             section->offset_within_address_space +
>>                             int128_get64(section->size) - 1) < 0) {
>> @@ -505,7 +538,7 @@ static void vfio_kvm_device_del_group(VFIOGroup *group)
>>   /*
>>    * vfio_get_iommu_type - selects the richest iommu_type (v2 first)
>>    */
>> -static int vfio_get_iommu_type(VFIOContainer *container,
>> +static int vfio_get_iommu_type(VFIOLegacyContainer *container,
>>                                  Error **errp)
>>   {
>>       int iommu_types[] = { VFIO_TYPE1v2_IOMMU, VFIO_TYPE1_IOMMU,
>> @@ -521,7 +554,7 @@ static int vfio_get_iommu_type(VFIOContainer *container,
>>       return -EINVAL;
>>   }
>>   
>> -static int vfio_init_container(VFIOContainer *container, int group_fd,
>> +static int vfio_init_container(VFIOLegacyContainer *container, int group_fd,
>>                                  Error **errp)
>>   {
>>       int iommu_type, ret;
>> @@ -556,7 +589,7 @@ static int vfio_init_container(VFIOContainer *container, int group_fd,
>>       return 0;
>>   }
>>   
>> -static int vfio_get_iommu_info(VFIOContainer *container,
>> +static int vfio_get_iommu_info(VFIOLegacyContainer *container,
>>                                  struct vfio_iommu_type1_info **info)
>>   {
>>   
>> @@ -600,11 +633,12 @@ vfio_get_iommu_info_cap(struct vfio_iommu_type1_info *info, uint16_t id)
>>       return NULL;
>>   }
>>   
>> -static void vfio_get_iommu_info_migration(VFIOContainer *container,
>> -                                         struct vfio_iommu_type1_info *info)
>> +static void vfio_get_iommu_info_migration(VFIOLegacyContainer *container,
>> +                                          struct vfio_iommu_type1_info *info)
>>   {
>>       struct vfio_info_cap_header *hdr;
>>       struct vfio_iommu_type1_info_cap_migration *cap_mig;
>> +    VFIOContainer *bcontainer = &container->obj;
>>   
>>       hdr = vfio_get_iommu_info_cap(info, VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION);
>>       if (!hdr) {
>> @@ -619,13 +653,14 @@ static void vfio_get_iommu_info_migration(VFIOContainer *container,
>>        * qemu_real_host_page_size to mark those dirty.
>>        */
>>       if (cap_mig->pgsize_bitmap & qemu_real_host_page_size) {
>> -        container->dirty_pages_supported = true;
>> -        container->max_dirty_bitmap_size = cap_mig->max_dirty_bitmap_size;
>> -        container->dirty_pgsizes = cap_mig->pgsize_bitmap;
>> +        bcontainer->dirty_pages_supported = true;
>> +        bcontainer->max_dirty_bitmap_size = cap_mig->max_dirty_bitmap_size;
>> +        bcontainer->dirty_pgsizes = cap_mig->pgsize_bitmap;
>>       }
>>   }
>>   
>> -static int vfio_ram_block_discard_disable(VFIOContainer *container, bool state)
>> +static int
>> +vfio_ram_block_discard_disable(VFIOLegacyContainer *container, bool state)
>>   {
>>       switch (container->iommu_type) {
>>       case VFIO_TYPE1v2_IOMMU:
>> @@ -651,7 +686,8 @@ static int vfio_ram_block_discard_disable(VFIOContainer *container, bool state)
>>   static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
>>                                     Error **errp)
>>   {
>> -    VFIOContainer *container;
>> +    VFIOContainer *bcontainer;
>> +    VFIOLegacyContainer *container;
>>       int ret, fd;
>>       VFIOAddressSpace *space;
>>   
>> @@ -688,7 +724,8 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
>>        * details once we know which type of IOMMU we are using.
>>        */
>>   
>> -    QLIST_FOREACH(container, &space->containers, next) {
>> +    QLIST_FOREACH(bcontainer, &space->containers, next) {
>> +        container = container_of(bcontainer, VFIOLegacyContainer, obj);
>>           if (!ioctl(group->fd, VFIO_GROUP_SET_CONTAINER, &container->fd)) {
>>               ret = vfio_ram_block_discard_disable(container, true);
>>               if (ret) {
>> @@ -724,14 +761,10 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
>>       }
>>   
>>       container = g_malloc0(sizeof(*container));
>> -    container->space = space;
>>       container->fd = fd;
>> -    container->error = NULL;
>> -    container->dirty_pages_supported = false;
>> -    container->dma_max_mappings = 0;
>> -    QLIST_INIT(&container->giommu_list);
>> -    QLIST_INIT(&container->hostwin_list);
>> -    QLIST_INIT(&container->vrdl_list);
>> +    bcontainer = &container->obj;
>> +    vfio_container_init(bcontainer, sizeof(*bcontainer),
>> +                        TYPE_VFIO_LEGACY_CONTAINER, space);
>>   
>>       ret = vfio_init_container(container, group->fd, errp);
>>       if (ret) {
>> @@ -763,13 +796,13 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
>>               /* Assume 4k IOVA page size */
>>               info->iova_pgsizes = 4096;
>>           }
>> -        vfio_host_win_add(container, 0, (hwaddr)-1, info->iova_pgsizes);
>> -        container->pgsizes = info->iova_pgsizes;
>> +        vfio_host_win_add(bcontainer, 0, (hwaddr)-1, info->iova_pgsizes);
>> +        bcontainer->pgsizes = info->iova_pgsizes;
>>   
>>           /* The default in the kernel ("dma_entry_limit") is 65535. */
>> -        container->dma_max_mappings = 65535;
>> +        bcontainer->dma_max_mappings = 65535;
>>           if (!ret) {
>> -            vfio_get_info_dma_avail(info, &container->dma_max_mappings);
>> +            vfio_get_info_dma_avail(info, &bcontainer->dma_max_mappings);
>>               vfio_get_iommu_info_migration(container, info);
>>           }
>>           g_free(info);
>> @@ -798,10 +831,10 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
>>   
>>               memory_listener_register(&container->prereg_listener,
>>                                        &address_space_memory);
>> -            if (container->error) {
>> +            if (bcontainer->error) {
>>                   memory_listener_unregister(&container->prereg_listener);
>>                   ret = -1;
>> -                error_propagate_prepend(errp, container->error,
>> +                error_propagate_prepend(errp, bcontainer->error,
>>                       "RAM memory listener initialization failed: ");
>>                   goto enable_discards_exit;
>>               }
>> @@ -820,7 +853,7 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
>>           }
>>   
>>           if (v2) {
>> -            container->pgsizes = info.ddw.pgsizes;
>> +            bcontainer->pgsizes = info.ddw.pgsizes;
>>               /*
>>                * There is a default window in just created container.
>>                * To make region_add/del simpler, we better remove this
>> @@ -835,8 +868,8 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
>>               }
>>           } else {
>>               /* The default table uses 4K pages */
>> -            container->pgsizes = 0x1000;
>> -            vfio_host_win_add(container, info.dma32_window_start,
>> +            bcontainer->pgsizes = 0x1000;
>> +            vfio_host_win_add(bcontainer, info.dma32_window_start,
>>                                 info.dma32_window_start +
>>                                 info.dma32_window_size - 1,
>>                                 0x1000);
>> @@ -847,28 +880,28 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
>>       vfio_kvm_device_add_group(group);
>>   
>>       QLIST_INIT(&container->group_list);
>> -    QLIST_INSERT_HEAD(&space->containers, container, next);
>> +    QLIST_INSERT_HEAD(&space->containers, bcontainer, next);
>>   
>>       group->container = container;
>>       QLIST_INSERT_HEAD(&container->group_list, group, container_next);
>>   
>> -    container->listener = vfio_memory_listener;
>> +    bcontainer->listener = vfio_memory_listener;
>>   
>> -    memory_listener_register(&container->listener, container->space->as);
>> +    memory_listener_register(&bcontainer->listener, bcontainer->space->as);
>>   
>> -    if (container->error) {
>> +    if (bcontainer->error) {
>>           ret = -1;
>> -        error_propagate_prepend(errp, container->error,
>> +        error_propagate_prepend(errp, bcontainer->error,
>>               "memory listener initialization failed: ");
>>           goto listener_release_exit;
>>       }
>>   
>> -    container->initialized = true;
>> +    bcontainer->initialized = true;
>>   
>>       return 0;
>>   listener_release_exit:
>>       QLIST_REMOVE(group, container_next);
>> -    QLIST_REMOVE(container, next);
>> +    QLIST_REMOVE(bcontainer, next);
>>       vfio_kvm_device_del_group(group);
>>       vfio_listener_release(container);
>>   
>> @@ -889,7 +922,8 @@ put_space_exit:
>>   
>>   static void vfio_disconnect_container(VFIOGroup *group)
>>   {
>> -    VFIOContainer *container = group->container;
>> +    VFIOLegacyContainer *container = group->container;
>> +    VFIOContainer *bcontainer = &container->obj;
>>   
>>       QLIST_REMOVE(group, container_next);
>>       group->container = NULL;
>> @@ -909,25 +943,9 @@ static void vfio_disconnect_container(VFIOGroup *group)
>>       }
>>   
>>       if (QLIST_EMPTY(&container->group_list)) {
>> -        VFIOAddressSpace *space = container->space;
>> -        VFIOGuestIOMMU *giommu, *tmp;
>> -        VFIOHostDMAWindow *hostwin, *next;
>> -
>> -        QLIST_REMOVE(container, next);
>> -
>> -        QLIST_FOREACH_SAFE(giommu, &container->giommu_list, giommu_next, tmp) {
>> -            memory_region_unregister_iommu_notifier(
>> -                    MEMORY_REGION(giommu->iommu_mr), &giommu->n);
>> -            QLIST_REMOVE(giommu, giommu_next);
>> -            g_free(giommu);
>> -        }
>> -
>> -        QLIST_FOREACH_SAFE(hostwin, &container->hostwin_list, hostwin_next,
>> -                           next) {
>> -            QLIST_REMOVE(hostwin, hostwin_next);
>> -            g_free(hostwin);
>> -        }
>> +        VFIOAddressSpace *space = bcontainer->space;
>>   
>> +        vfio_container_destroy(bcontainer);
>>           trace_vfio_disconnect_container(container->fd);
>>           close(container->fd);
>>           g_free(container);
>> @@ -939,13 +957,15 @@ static void vfio_disconnect_container(VFIOGroup *group)
>>   VFIOGroup *vfio_get_group(int groupid, AddressSpace *as, Error **errp)
>>   {
>>       VFIOGroup *group;
>> +    VFIOContainer *bcontainer;
>>       char path[32];
>>       struct vfio_group_status status = { .argsz = sizeof(status) };
>>   
>>       QLIST_FOREACH(group, &vfio_group_list, next) {
>>           if (group->groupid == groupid) {
>>               /* Found it.  Now is it already in the right context? */
>> -            if (group->container->space->as == as) {
>> +            bcontainer = &group->container->obj;
>> +            if (bcontainer->space->as == as) {
>>                   return group;
>>               } else {
>>                   error_setg(errp, "group %d used in multiple address spaces",
>> @@ -1098,7 +1118,7 @@ void vfio_put_base_device(VFIODevice *vbasedev)
>>   /*
>>    * Interfaces for IBM EEH (Enhanced Error Handling)
>>    */
>> -static bool vfio_eeh_container_ok(VFIOContainer *container)
>> +static bool vfio_eeh_container_ok(VFIOLegacyContainer *container)
>>   {
>>       /*
>>        * As of 2016-03-04 (linux-4.5) the host kernel EEH/VFIO
>> @@ -1126,7 +1146,7 @@ static bool vfio_eeh_container_ok(VFIOContainer *container)
>>       return true;
>>   }
>>   
>> -static int vfio_eeh_container_op(VFIOContainer *container, uint32_t op)
>> +static int vfio_eeh_container_op(VFIOLegacyContainer *container, uint32_t op)
>>   {
>>       struct vfio_eeh_pe_op pe_op = {
>>           .argsz = sizeof(pe_op),
>> @@ -1149,19 +1169,21 @@ static int vfio_eeh_container_op(VFIOContainer *container, uint32_t op)
>>       return ret;
>>   }
>>   
>> -static VFIOContainer *vfio_eeh_as_container(AddressSpace *as)
>> +static VFIOLegacyContainer *vfio_eeh_as_container(AddressSpace *as)
>>   {
>>       VFIOAddressSpace *space = vfio_get_address_space(as);
>> -    VFIOContainer *container = NULL;
>> +    VFIOLegacyContainer *container = NULL;
>> +    VFIOContainer *bcontainer = NULL;
>>   
>>       if (QLIST_EMPTY(&space->containers)) {
>>           /* No containers to act on */
>>           goto out;
>>       }
>>   
>> -    container = QLIST_FIRST(&space->containers);
>> +    bcontainer = QLIST_FIRST(&space->containers);
>> +    container = container_of(bcontainer, VFIOLegacyContainer, obj);
>>   
>> -    if (QLIST_NEXT(container, next)) {
>> +    if (QLIST_NEXT(bcontainer, next)) {
>>           /*
>>            * We don't yet have logic to synchronize EEH state across
>>            * multiple containers.
>> @@ -1177,17 +1199,45 @@ out:
>>   
>>   bool vfio_eeh_as_ok(AddressSpace *as)
>>   {
>> -    VFIOContainer *container = vfio_eeh_as_container(as);
>> +    VFIOLegacyContainer *container = vfio_eeh_as_container(as);
>>   
>>       return (container != NULL) && vfio_eeh_container_ok(container);
>>   }
>>   
>>   int vfio_eeh_as_op(AddressSpace *as, uint32_t op)
>>   {
>> -    VFIOContainer *container = vfio_eeh_as_container(as);
>> +    VFIOLegacyContainer *container = vfio_eeh_as_container(as);
>>   
>>       if (!container) {
>>           return -ENODEV;
>>       }
>>       return vfio_eeh_container_op(container, op);
>>   }
>> +
>> +static void vfio_legacy_container_class_init(ObjectClass *klass,
>> +                                             void *data)
>> +{
>> +    VFIOContainerClass *vccs = VFIO_CONTAINER_OBJ_CLASS(klass);
>> +
>> +    vccs->dma_map = vfio_dma_map;
>> +    vccs->dma_unmap = vfio_dma_unmap;
>> +    vccs->devices_all_dirty_tracking = vfio_devices_all_dirty_tracking;
>> +    vccs->set_dirty_page_tracking = vfio_set_dirty_page_tracking;
>> +    vccs->get_dirty_bitmap = vfio_get_dirty_bitmap;
>> +    vccs->add_window = vfio_legacy_container_add_section_window;
>> +    vccs->del_window = vfio_legacy_container_del_section_window;
>> +    vccs->check_extension = vfio_legacy_container_check_extension;
>> +}
>> +
>> +static const TypeInfo vfio_legacy_container_info = {
>> +    .parent = TYPE_VFIO_CONTAINER_OBJ,
>> +    .name = TYPE_VFIO_LEGACY_CONTAINER,
>> +    .class_init = vfio_legacy_container_class_init,
>> +};
>> +
>> +static void vfio_register_types(void)
>> +{
>> +    type_register_static(&vfio_legacy_container_info);
>> +}
>> +
>> +type_init(vfio_register_types)
>> diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
>> index e3b6d6e2cb..df4fa2b695 100644
>> --- a/hw/vfio/meson.build
>> +++ b/hw/vfio/meson.build
>> @@ -2,6 +2,7 @@ vfio_ss = ss.source_set()
>>   vfio_ss.add(files(
>>     'common.c',
>>     'as.c',
>> +  'container-obj.c',
>>     'container.c',
>>     'spapr.c',
>>     'migration.c',
>> diff --git a/hw/vfio/migration.c b/hw/vfio/migration.c
>> index ff6b45de6b..cbbde177c3 100644
>> --- a/hw/vfio/migration.c
>> +++ b/hw/vfio/migration.c
>> @@ -856,11 +856,11 @@ int64_t vfio_mig_bytes_transferred(void)
>>   
>>   int vfio_migration_probe(VFIODevice *vbasedev, Error **errp)
>>   {
>> -    VFIOContainer *container = vbasedev->group->container;
>> +    VFIOLegacyContainer *container = vbasedev->group->container;
>>       struct vfio_region_info *info = NULL;
>>       int ret = -ENOTSUP;
>>   
>> -    if (!vbasedev->enable_migration || !container->dirty_pages_supported) {
>> +    if (!vbasedev->enable_migration || !container->obj.dirty_pages_supported) {
>>           goto add_blocker;
>>       }
>>   
>> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
>> index e707329394..a00a485e46 100644
>> --- a/hw/vfio/pci.c
>> +++ b/hw/vfio/pci.c
>> @@ -3101,7 +3101,9 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
>>           }
>>       }
>>   
>> -    if (!pdev->failover_pair_id) {
>> +    if (!pdev->failover_pair_id &&
>> +        vfio_container_check_extension(&vbasedev->group->container->obj,
>> +                                       VFIO_FEAT_LIVE_MIGRATION)) {
>>           ret = vfio_migration_probe(vbasedev, errp);
>>           if (ret) {
>>               error_report("%s: Migration disabled", vbasedev->name);
>> diff --git a/hw/vfio/spapr.c b/hw/vfio/spapr.c
>> index 04c6e67f8f..cdcd9e05ba 100644
>> --- a/hw/vfio/spapr.c
>> +++ b/hw/vfio/spapr.c
>> @@ -39,8 +39,8 @@ static void *vfio_prereg_gpa_to_vaddr(MemoryRegionSection *section, hwaddr gpa)
>>   static void vfio_prereg_listener_region_add(MemoryListener *listener,
>>                                               MemoryRegionSection *section)
>>   {
>> -    VFIOContainer *container = container_of(listener, VFIOContainer,
>> -                                            prereg_listener);
>> +    VFIOLegacyContainer *container = container_of(listener, VFIOLegacyContainer,
>> +                                                  prereg_listener);
>>       const hwaddr gpa = section->offset_within_address_space;
>>       hwaddr end;
>>       int ret;
>> @@ -83,9 +83,9 @@ static void vfio_prereg_listener_region_add(MemoryListener *listener,
>>            * can gracefully fail.  Runtime, there's not much we can do other
>>            * than throw a hardware error.
>>            */
>> -        if (!container->initialized) {
>> -            if (!container->error) {
>> -                error_setg_errno(&container->error, -ret,
>> +        if (!container->obj.initialized) {
>> +            if (!container->obj.error) {
>> +                error_setg_errno(&container->obj.error, -ret,
>>                                    "Memory registering failed");
>>               }
>>           } else {
>> @@ -97,8 +97,8 @@ static void vfio_prereg_listener_region_add(MemoryListener *listener,
>>   static void vfio_prereg_listener_region_del(MemoryListener *listener,
>>                                               MemoryRegionSection *section)
>>   {
>> -    VFIOContainer *container = container_of(listener, VFIOContainer,
>> -                                            prereg_listener);
>> +    VFIOLegacyContainer *container = container_of(listener, VFIOLegacyContainer,
>> +                                                  prereg_listener);
>>       const hwaddr gpa = section->offset_within_address_space;
>>       hwaddr end;
>>       int ret;
>> @@ -141,7 +141,7 @@ const MemoryListener vfio_prereg_listener = {
>>       .region_del = vfio_prereg_listener_region_del,
>>   };
>>   
>> -int vfio_spapr_create_window(VFIOContainer *container,
>> +int vfio_spapr_create_window(VFIOLegacyContainer *container,
>>                                MemoryRegionSection *section,
>>                                hwaddr *pgsize)
>>   {
>> @@ -159,13 +159,13 @@ int vfio_spapr_create_window(VFIOContainer *container,
>>       if (pagesize > rampagesize) {
>>           pagesize = rampagesize;
>>       }
>> -    pgmask = container->pgsizes & (pagesize | (pagesize - 1));
>> +    pgmask = container->obj.pgsizes & (pagesize | (pagesize - 1));
>>       pagesize = pgmask ? (1ULL << (63 - clz64(pgmask))) : 0;
>>       if (!pagesize) {
>>           error_report("Host doesn't support page size 0x%"PRIx64
>>                        ", the supported mask is 0x%lx",
>>                        memory_region_iommu_get_min_page_size(iommu_mr),
>> -                     container->pgsizes);
>> +                     container->obj.pgsizes);
>>           return -EINVAL;
>>       }
>>   
>> @@ -233,7 +233,7 @@ int vfio_spapr_create_window(VFIOContainer *container,
>>       return 0;
>>   }
>>   
>> -int vfio_spapr_remove_window(VFIOContainer *container,
>> +int vfio_spapr_remove_window(VFIOLegacyContainer *container,
>>                                hwaddr offset_within_address_space)
>>   {
>>       struct vfio_iommu_spapr_tce_remove remove = {
>> diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
>> index 03ff7944cb..02a6f36a9e 100644
>> --- a/include/hw/vfio/vfio-common.h
>> +++ b/include/hw/vfio/vfio-common.h
>> @@ -30,6 +30,7 @@
>>   #include <linux/vfio.h>
>>   #endif
>>   #include "sysemu/sysemu.h"
>> +#include "hw/vfio/vfio-container-obj.h"
>>   
>>   #define VFIO_MSG_PREFIX "vfio %s: "
>>   
>> @@ -70,58 +71,15 @@ typedef struct VFIOMigration {
>>       uint64_t pending_bytes;
>>   } VFIOMigration;
>>   
>> -typedef struct VFIOAddressSpace {
>> -    AddressSpace *as;
>> -    QLIST_HEAD(, VFIOContainer) containers;
>> -    QLIST_ENTRY(VFIOAddressSpace) list;
>> -} VFIOAddressSpace;
>> -
>>   struct VFIOGroup;
>>   
>> -typedef struct VFIOContainer {
>> -    VFIOAddressSpace *space;
>> +typedef struct VFIOLegacyContainer {
>> +    VFIOContainer obj;
>>       int fd; /* /dev/vfio/vfio, empowered by the attached groups */
>> -    MemoryListener listener;
>>       MemoryListener prereg_listener;
>>       unsigned iommu_type;
>> -    Error *error;
>> -    bool initialized;
>> -    bool dirty_pages_supported;
>> -    uint64_t dirty_pgsizes;
>> -    uint64_t max_dirty_bitmap_size;
>> -    unsigned long pgsizes;
>> -    unsigned int dma_max_mappings;
>> -    QLIST_HEAD(, VFIOGuestIOMMU) giommu_list;
>> -    QLIST_HEAD(, VFIOHostDMAWindow) hostwin_list;
>>       QLIST_HEAD(, VFIOGroup) group_list;
>> -    QLIST_HEAD(, VFIORamDiscardListener) vrdl_list;
>> -    QLIST_ENTRY(VFIOContainer) next;
>> -} VFIOContainer;
>> -
>> -typedef struct VFIOGuestIOMMU {
>> -    VFIOContainer *container;
>> -    IOMMUMemoryRegion *iommu_mr;
>> -    hwaddr iommu_offset;
>> -    IOMMUNotifier n;
>> -    QLIST_ENTRY(VFIOGuestIOMMU) giommu_next;
>> -} VFIOGuestIOMMU;
>> -
>> -typedef struct VFIORamDiscardListener {
>> -    VFIOContainer *container;
>> -    MemoryRegion *mr;
>> -    hwaddr offset_within_address_space;
>> -    hwaddr size;
>> -    uint64_t granularity;
>> -    RamDiscardListener listener;
>> -    QLIST_ENTRY(VFIORamDiscardListener) next;
>> -} VFIORamDiscardListener;
>> -
>> -typedef struct VFIOHostDMAWindow {
>> -    hwaddr min_iova;
>> -    hwaddr max_iova;
>> -    uint64_t iova_pgsizes;
>> -    QLIST_ENTRY(VFIOHostDMAWindow) hostwin_next;
>> -} VFIOHostDMAWindow;
>> +} VFIOLegacyContainer;
>>   
>>   typedef struct VFIODeviceOps VFIODeviceOps;
>>   
>> @@ -159,7 +117,7 @@ struct VFIODeviceOps {
>>   typedef struct VFIOGroup {
>>       int fd;
>>       int groupid;
>> -    VFIOContainer *container;
>> +    VFIOLegacyContainer *container;
>>       QLIST_HEAD(, VFIODevice) device_list;
>>       QLIST_ENTRY(VFIOGroup) next;
>>       QLIST_ENTRY(VFIOGroup) container_next;
>> @@ -192,31 +150,13 @@ typedef struct VFIODisplay {
>>       } dmabuf;
>>   } VFIODisplay;
>>   
>> -void vfio_host_win_add(VFIOContainer *container,
>> +void vfio_host_win_add(VFIOContainer *bcontainer,
>>                          hwaddr min_iova, hwaddr max_iova,
>>                          uint64_t iova_pgsizes);
>> -int vfio_host_win_del(VFIOContainer *container, hwaddr min_iova,
>> +int vfio_host_win_del(VFIOContainer *bcontainer, hwaddr min_iova,
>>                         hwaddr max_iova);
>>   VFIOAddressSpace *vfio_get_address_space(AddressSpace *as);
>>   void vfio_put_address_space(VFIOAddressSpace *space);
>> -bool vfio_devices_all_running_and_saving(VFIOContainer *container);
>> -bool vfio_devices_all_dirty_tracking(VFIOContainer *container);
>> -
>> -/* container->fd */
>> -int vfio_dma_unmap(VFIOContainer *container,
>> -                   hwaddr iova, ram_addr_t size,
>> -                   IOMMUTLBEntry *iotlb);
>> -int vfio_dma_map(VFIOContainer *container, hwaddr iova,
>> -                 ram_addr_t size, void *vaddr, bool readonly);
>> -void vfio_set_dirty_page_tracking(VFIOContainer *container, bool start);
>> -int vfio_get_dirty_bitmap(VFIOContainer *container, uint64_t iova,
>> -                          uint64_t size, ram_addr_t ram_addr);
>> -
>> -int vfio_container_add_section_window(VFIOContainer *container,
>> -                                      MemoryRegionSection *section,
>> -                                      Error **errp);
>> -void vfio_container_del_section_window(VFIOContainer *container,
>> -                                       MemoryRegionSection *section);
>>   
>>   void vfio_put_base_device(VFIODevice *vbasedev);
>>   void vfio_disable_irqindex(VFIODevice *vbasedev, int index);
>> @@ -263,10 +203,10 @@ vfio_get_device_info_cap(struct vfio_device_info *info, uint16_t id);
>>   #endif
>>   extern const MemoryListener vfio_prereg_listener;
>>   
>> -int vfio_spapr_create_window(VFIOContainer *container,
>> +int vfio_spapr_create_window(VFIOLegacyContainer *container,
>>                                MemoryRegionSection *section,
>>                                hwaddr *pgsize);
>> -int vfio_spapr_remove_window(VFIOContainer *container,
>> +int vfio_spapr_remove_window(VFIOLegacyContainer *container,
>>                                hwaddr offset_within_address_space);
>>   
>>   int vfio_migration_probe(VFIODevice *vbasedev, Error **errp);
>> diff --git a/include/hw/vfio/vfio-container-obj.h b/include/hw/vfio/vfio-container-obj.h
>> new file mode 100644
>> index 0000000000..7ffbbb299f
>> --- /dev/null
>> +++ b/include/hw/vfio/vfio-container-obj.h
>> @@ -0,0 +1,154 @@
>> +/*
>> + * VFIO CONTAINER BASE OBJECT
>> + *
>> + * Copyright (C) 2022 Intel Corporation.
>> + * Copyright Red Hat, Inc. 2022
>> + *
>> + * Authors: Yi Liu <yi.l.liu@intel.com>
>> + *          Eric Auger <eric.auger@redhat.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> +
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> +
>> + * You should have received a copy of the GNU General Public License along
>> + * with this program; if not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#ifndef HW_VFIO_VFIO_CONTAINER_OBJ_H
>> +#define HW_VFIO_VFIO_CONTAINER_OBJ_H
>> +
>> +#include "qom/object.h"
>> +#include "exec/memory.h"
>> +#include "qemu/queue.h"
>> +#include "qemu/thread.h"
>> +#ifndef CONFIG_USER_ONLY
>> +#include "exec/hwaddr.h"
>> +#endif
>> +
>> +#define TYPE_VFIO_CONTAINER_OBJ "qemu:vfio-base-container-obj"
>> +#define VFIO_CONTAINER_OBJ(obj) \
>> +        OBJECT_CHECK(VFIOContainer, (obj), TYPE_VFIO_CONTAINER_OBJ)
>> +#define VFIO_CONTAINER_OBJ_CLASS(klass) \
>> +        OBJECT_CLASS_CHECK(VFIOContainerClass, (klass), \
>> +                         TYPE_VFIO_CONTAINER_OBJ)
>> +#define VFIO_CONTAINER_OBJ_GET_CLASS(obj) \
>> +        OBJECT_GET_CLASS(VFIOContainerClass, (obj), \
>> +                         TYPE_VFIO_CONTAINER_OBJ)
>> +
>> +typedef enum VFIOContainerFeature {
>> +    VFIO_FEAT_LIVE_MIGRATION,
>> +} VFIOContainerFeature;
>> +
>> +typedef struct VFIOContainer VFIOContainer;
>> +
>> +typedef struct VFIOAddressSpace {
>> +    AddressSpace *as;
>> +    QLIST_HEAD(, VFIOContainer) containers;
>> +    QLIST_ENTRY(VFIOAddressSpace) list;
>> +} VFIOAddressSpace;
>> +
>> +typedef struct VFIOGuestIOMMU {
>> +    VFIOContainer *container;
>> +    IOMMUMemoryRegion *iommu_mr;
>> +    hwaddr iommu_offset;
>> +    IOMMUNotifier n;
>> +    QLIST_ENTRY(VFIOGuestIOMMU) giommu_next;
>> +} VFIOGuestIOMMU;
>> +
>> +typedef struct VFIORamDiscardListener {
>> +    VFIOContainer *container;
>> +    MemoryRegion *mr;
>> +    hwaddr offset_within_address_space;
>> +    hwaddr size;
>> +    uint64_t granularity;
>> +    RamDiscardListener listener;
>> +    QLIST_ENTRY(VFIORamDiscardListener) next;
>> +} VFIORamDiscardListener;
>> +
>> +typedef struct VFIOHostDMAWindow {
>> +    hwaddr min_iova;
>> +    hwaddr max_iova;
>> +    uint64_t iova_pgsizes;
>> +    QLIST_ENTRY(VFIOHostDMAWindow) hostwin_next;
>> +} VFIOHostDMAWindow;
>> +
>> +/*
>> + * This is the base object for vfio container backends
>> + */
>> +struct VFIOContainer {
>> +    /* private */
>> +    Object parent_obj;
>> +
>> +    VFIOAddressSpace *space;
>> +    MemoryListener listener;
>> +    Error *error;
>> +    bool initialized;
>> +    bool dirty_pages_supported;
>> +    uint64_t dirty_pgsizes;
>> +    uint64_t max_dirty_bitmap_size;
>> +    unsigned long pgsizes;
>> +    unsigned int dma_max_mappings;
>> +    QLIST_HEAD(, VFIOGuestIOMMU) giommu_list;
>> +    QLIST_HEAD(, VFIOHostDMAWindow) hostwin_list;
>> +    QLIST_HEAD(, VFIORamDiscardListener) vrdl_list;
>> +    QLIST_ENTRY(VFIOContainer) next;
>> +};
>> +
>> +typedef struct VFIOContainerClass {
>> +    /* private */
>> +    ObjectClass parent_class;
>> +
>> +    /* required */
>> +    bool (*check_extension)(VFIOContainer *container,
>> +                            VFIOContainerFeature feat);
>> +    int (*dma_map)(VFIOContainer *container,
>> +                   hwaddr iova, ram_addr_t size,
>> +                   void *vaddr, bool readonly);
>> +    int (*dma_unmap)(VFIOContainer *container,
>> +                     hwaddr iova, ram_addr_t size,
>> +                     IOMMUTLBEntry *iotlb);
>> +    /* migration feature */
>> +    bool (*devices_all_dirty_tracking)(VFIOContainer *container);
>> +    void (*set_dirty_page_tracking)(VFIOContainer *container, bool start);
>> +    int (*get_dirty_bitmap)(VFIOContainer *container, uint64_t iova,
>> +                            uint64_t size, ram_addr_t ram_addr);
>> +
>> +    /* SPAPR specific */
>> +    int (*add_window)(VFIOContainer *container,
>> +                      MemoryRegionSection *section,
>> +                      Error **errp);
>> +    void (*del_window)(VFIOContainer *container,
>> +                       MemoryRegionSection *section);
>> +} VFIOContainerClass;
>> +
>> +bool vfio_container_check_extension(VFIOContainer *container,
>> +                                    VFIOContainerFeature feat);
>> +int vfio_container_dma_map(VFIOContainer *container,
>> +                           hwaddr iova, ram_addr_t size,
>> +                           void *vaddr, bool readonly);
>> +int vfio_container_dma_unmap(VFIOContainer *container,
>> +                             hwaddr iova, ram_addr_t size,
>> +                             IOMMUTLBEntry *iotlb);
>> +bool vfio_container_devices_all_dirty_tracking(VFIOContainer *container);
>> +void vfio_container_set_dirty_page_tracking(VFIOContainer *container,
>> +                                            bool start);
>> +int vfio_container_get_dirty_bitmap(VFIOContainer *container, uint64_t iova,
>> +                                    uint64_t size, ram_addr_t ram_addr);
>> +int vfio_container_add_section_window(VFIOContainer *container,
>> +                                      MemoryRegionSection *section,
>> +                                      Error **errp);
>> +void vfio_container_del_section_window(VFIOContainer *container,
>> +                                       MemoryRegionSection *section);
>> +
>> +void vfio_container_init(void *_container, size_t instance_size,
>> +                         const char *mrtypename,
>> +                         VFIOAddressSpace *space);
>> +void vfio_container_destroy(VFIOContainer *container);
>> +#endif /* HW_VFIO_VFIO_CONTAINER_OBJ_H */
> 

-- 
Regards,
Yi Liu
