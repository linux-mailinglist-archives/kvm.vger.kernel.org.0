Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08D26F11BB
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 08:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345372AbjD1GUG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 02:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjD1GUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 02:20:05 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C743819B0;
        Thu, 27 Apr 2023 23:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682662802; x=1714198802;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5j1PMTrfWA0/rwt7TJgscy1W6Lm+e1gkL9DGMmsVKVY=;
  b=AJ/pHJocAoHGr5c5q5qSFsv/RDOhidghFT8x+U6aY0ZIncbwHj4ckuyX
   zLXIKNSsD4DHGdT0iaohhBZWvpzz0ZzFqo3Z5nj+YEVoSbTqz72vK9nLV
   fupHmN5AzVTuI2afdXhBZqtiRQbin7LZsN91zdlA2OuPj6/9XCOL1Z+pE
   SouA/DYwYhDUKzDH8gIminP5wvSyCPQO4bXlQEhHYU6OLCIvd1J5sWoqM
   NIeIcLEg2MtA/H7/diVFGY9OOaYnM5GVM89UvpfK+F5G+9FRY9B9Ih+zQ
   8N/Qst3Bblsy7CWSj3l10YnFIVzAx4uL72ZyvpIHFPDPPkuZzma5fypUS
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="433952036"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="433952036"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 23:20:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="727422313"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="727422313"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 27 Apr 2023 23:20:01 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:20:01 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:20:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 23:20:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 23:20:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5tWLR+k8HmjvowjHu6x4GgkWLGKiMc5e/MqquajyjDOYx4QGevUgq1nc/YHTy+gArjYMPc0Av3E8jepLN6+i7gQSEx/w6uVClEFwzbEg2T9nuFsxauNkNnM/VGFMxwzAXjN+HYVlGCQ17ydbHLov+5hCtEmtsX+nKuSwi5J2YQG10mljuaWkMN5Z6lTy7+alK4ypNJMaa5uqMDCsju2ZwxXmhI48VvC3wZRPjsbUn+4hILrzYiCupt9XfxoNfJy3E5j5d/GBMTK/A8AvidutLbt6aU+ciirr5BwCU+gQ1wj3F+i96cG8x+rbgpnrXTn0NhGRRWG66SM7ay7sfGQdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AnjkZe6TuNvcsuzEfT5b6pIXN90W7j2P/dJH/fSvAi4=;
 b=gr5Ec9buQqX/CBjeGmi/gz80fy7YItVoQcAe/Up4sbPN/UwtXWXETMRxTMJrOb6SmmtnyA589cLwdzL56h7ZwK8pO4VVLE9ISYeaWeCyE8td6WNvJ8uPk2qR+/YOdz4FqRSYG+Eyh/TYyk7Z8rcNhPYtEZA/JyAmuex2PsyLsr/adPZpxd28Qeo44JwSgKAgLtd7ksntHSRMdt0upg42mpb2phrJKtE0Goua1jxiRnV19W4EVpV5bWqR/SAELgxmP0BNdhHuPfZmEwZXEFN9XFBrt2RLZdhmfe6a+VcSMHJ2kHAS0H6MGw57pEm3+0YbBDhziZP4kOJOEaI4AIfBVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM6PR11MB4754.namprd11.prod.outlook.com (2603:10b6:5:2ad::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Fri, 28 Apr
 2023 06:19:58 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%3]) with mapi id 15.20.6340.021; Fri, 28 Apr 2023
 06:19:58 +0000
Message-ID: <a6b77884-1678-b17c-f6a4-28d56e6c366b@intel.com>
Date:   Fri, 28 Apr 2023 14:21:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-3-yi.l.liu@intel.com>
 <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230427123203.22307c4f.alex.williamson@redhat.com>
Content-Language: en-US
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20230427123203.22307c4f.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0179.apcprd04.prod.outlook.com
 (2603:1096:4:14::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DM6PR11MB4754:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f4044fa-74ce-4763-6a82-08db47b096af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hG2eIcF7Fg3W38dHbOV2urrFt7ci7wIIli5jck4aUJlFzqhWtLNfkPJ6OWell3KywZ+ZThOz2augyJNcvYkUjbafUvwF2HvojpYXe/MMD0gAb+q3leCwzPnOZlRqMTS3Jh09rU9A6MitMUN5yT08bPkCB3JMmlVIkmQyQOiH74ssuGNZvb2WH+YPv/2gMI3NqiJEFMP7wsVnHV/nYBIJpZ5RAFjMH4FuyoolqSJLvMkGULazjUmzgCRiKwFz7ph/62bmZUeDRnGIdndVYgEywZyytLkZCi6QBK5FRZ5ANtuyby7/luzoKMEXUTEYvUn4R2DWTDQJX5IGHkDlrDj3P8RC5+ftDy7uq6FWm5GeSINkfyrKxAhNIuzrJVtAivIgrEXP9BIb8Ox0ndUgBtcvUMuLKkrjuvHK4BOC0szNTBKqOXG3ZSPl69A8TIXKr/sd+IC0u4tyAMD4VOFMQfZ3YrvVZn7hMPPjyQ4NzLeeF9pkHvgHuP+A8fahi6UI/vjxc+3WLxp1z/rXL7rn0uCr+9solhjm7BGNMnQR4oU3FoXVvBM+dLIDyLIZejlspHaWD3VKaanYIEOlJbcdxmh2Vlhgf94I1i4eajqMXfOzpxfNoHHSxfQ28AHMI1UJQyEwrol3Db3YrEx45jI6bPRLEg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(136003)(39860400002)(366004)(451199021)(8676002)(8936002)(41300700001)(7416002)(82960400001)(316002)(2906002)(66476007)(38100700002)(66556008)(31686004)(5660300002)(6916009)(4326008)(66946007)(83380400001)(2616005)(6486002)(54906003)(186003)(31696002)(86362001)(36756003)(966005)(6666004)(53546011)(6512007)(6506007)(478600001)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MkVVcXNDZG5mSVAxVTdFdjdVcnhVNkxPb256OUlhQVpTSXA2YzNKSlhlMjg2?=
 =?utf-8?B?NlpyUVArQmc3aWwyZ2IrbkFOQUpHVGo4RDJoZXlTVGhEeUtYdlV0UGdzbTd2?=
 =?utf-8?B?clp5Z0ZnSk53dHlWWU9ycDRhV2grZUVicStuRUs0UWF3TTFZTllDZUttL3My?=
 =?utf-8?B?M2xQWXdiLzhZeks4a2VTeTdGOEhxNzJ0NGlJS2dYSjBYMzNJWjl3eGp2MTho?=
 =?utf-8?B?eERPL0dzNXhUNnR1RlhJMFNFcm1YTXhzcHRoZW1jK0JUdWhFNVA4aFpNSlFF?=
 =?utf-8?B?L1pzZFo0WS93SnpMSmt0c09wYmN6T0VYYkhhWnZpMTJYUXUveWFmNWlNbFR1?=
 =?utf-8?B?aFEwTnUxOG53ZnZwZ2xqY094dzMvV2RvckxqNGFBS1NCR1M2MHFvNVZ5cFNr?=
 =?utf-8?B?VHNPT1lRcUVJcUY1eEMzQ0xxV2hXNmRDY2toQUFoRjJhTCs0TVkvT0hwUHQ2?=
 =?utf-8?B?OUdDcVd3UU9ybis0MVYwTHBacUxqNTlhZTZ5UUFSSElYQ3NQbStmMEJLcC9s?=
 =?utf-8?B?Z0NUL3h2OHNqQjV0R1FiZXdCUU1SaUZycmljcmtQM2o5M0g2YmUxTzNsNWZK?=
 =?utf-8?B?TDV0M3JHVDdXT2IzS2IwVVVHcStxS0o4RnpqTVZKMHlLMGFoZ1A2WGZ4TjZD?=
 =?utf-8?B?T1Q2WmFacWRNV2xyR0VxQzhwY2lycUo1NnErQnJITG9NTk9yR3R5aXlqWXNa?=
 =?utf-8?B?WjlYa3E4Yzc1RTZCcnpOaXdPYmQ4TDROakVIRWwxZzJBcVM5SXhFcEg3OElK?=
 =?utf-8?B?M0tFSmRjZmd5QVNNNXJQL1ZXMXNvaXYvdlM1N2pUTytiRUcxTVJCV2Y3UmhQ?=
 =?utf-8?B?UkFCMEVjTHVaam1ITm1CSDY0T2ludDRVRnRTZmxPeGtZZHlNMEZPa2RIY2pM?=
 =?utf-8?B?ZzRzb0NGa2RCOFRaeDMyYkNNOXJiMit1QjJWbnZpTXJJWUc2eURXTmMwc2NG?=
 =?utf-8?B?YVNuQXF3b2tWelc5UHZianFEanJ1Lzd1bThhYUpuc00zUFhoQ2pCYnZZVURN?=
 =?utf-8?B?Q3YyYTRCMnhJNEVYcVJwWSs3YVo1aVpjV0ZWQUMxWGRuTndPaUxLcDFMWk9W?=
 =?utf-8?B?VWp5SlFVN2x0a1RNZHJRNm03OFlST0kvczdBb2ZhK0x0d2UvbHpDM05jNlhk?=
 =?utf-8?B?cjAyV3BiTUFFMnhiWUM0TEFQa1dVbzN1UmZLSjlwdzlTYTVCQ3dwU0VFMDJ3?=
 =?utf-8?B?RUVhc1owcXB2U1NZNW9mb2taczhxNUcxc1F4Wm9CcHVKa21NWnFvL0Vyb3Qw?=
 =?utf-8?B?cjhxVHJIU1pjUWROSEZDbmtQN2FWVnd2ZnUvbnpNS3lINHdSaTlwTTIrOVRC?=
 =?utf-8?B?M1pKRDVBYkxOMnZpcHhROE81Ull2WnBMQTIwNVFiQ1RzQlM2dkZVU2szMTIx?=
 =?utf-8?B?QmErWCs2aVV5RDhuT3U4VUowelYrL1pKQWh0a2MzVEhVTGRTaHVWM1krQlI3?=
 =?utf-8?B?bThIcDBQcGJ0dlZMeVhNZWNKcDlPaExyaGtRK2lreFU1R1c3aHM2K2VtTXRN?=
 =?utf-8?B?R1BramtMMWI2d1RNNVpVMUtUUm45OWtPSkFRc3dpUDZLTG85VHM4azVnM2M4?=
 =?utf-8?B?NlZVRGc1OVB2Nlo4YXFUVDF0SVJzanFiOUR0NzloeFlBSmQ4YkVBQitoTVBD?=
 =?utf-8?B?Mzk5eUhlSkNQRm9UM056MHdheHpsWFNZRmVtTWdQcU9Ja0NwNHlsT2hSbUVk?=
 =?utf-8?B?bDU1Q2ZoRzVsbXNWd2U3WDI2S1RZc1BQaERFZ25wKzYrZXNDTUdzL3dPYk1Z?=
 =?utf-8?B?dFpBTHBpRUJ4U25jWVJLdGdGSXFQVU9uME04U1JPcGw0NG5FeXB0UGhBazdK?=
 =?utf-8?B?d2VqNkgrMzZnVDlqRUh3dVByZlZYT0gzTHVCTHhuMUtGRjY4V3lEVzAzdDk3?=
 =?utf-8?B?TjJKZFJqTytKTk1wWlBEcUhHUStITWdlVzhVUEZhaDQzRWMrM1g5RGtVTjhy?=
 =?utf-8?B?dDNpUDRrVm9sams2bm5vN2QzMGQvOTBvWGRXMFZjRDVjNmRhS0NoT1FxSTI5?=
 =?utf-8?B?YTJ3SWpWeXZrVjZ1dzV2VUwyZDFhSEd3SE1oZGdUZkl1dWlJZUpPS0pqREpL?=
 =?utf-8?B?VVM5U1hoK2ZHSnlKZkxWcmFnaVpwdXV5VTN4S2hqc09RS1MrUW53Y3h2SEVP?=
 =?utf-8?Q?tKbKVx9uIUWmXN+XSfb9bZLv4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f4044fa-74ce-4763-6a82-08db47b096af
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 06:19:57.5885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W8DE5+AeCgCDTJFGYpyUIymu797/St1J4CmzLZnhZ2giyelB4/Srfs/JWzYgoDLOnT75LdokkzsUIxUR9qUOuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4754
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/4/28 02:32, Alex Williamson wrote:
> On Thu, 27 Apr 2023 06:59:17 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
>>> From: Tian, Kevin <kevin.tian@intel.com>
>>> Sent: Thursday, April 27, 2023 2:39 PM
>>>    
>>>> From: Liu, Yi L <yi.l.liu@intel.com>
>>>> Sent: Wednesday, April 26, 2023 10:54 PM
>>>> @@ -121,7 +128,8 @@ static void vfio_emulated_unmap(void *data,
>>>> unsigned long iova,
>>>>   {
>>>>   	struct vfio_device *vdev = data;
>>>>
>>>> -	if (vdev->ops->dma_unmap)
>>>> +	/* noiommu devices cannot do map/unmap */
>>>> +	if (vdev->noiommu && vdev->ops->dma_unmap)
>>>>   		vdev->ops->dma_unmap(vdev, iova, length);
>>>
>>> Is it necessary? All mdev devices implementing @dma_unmap won't
>>> set noiommu flag.
>>
>> Hmmm. Yes, and all the devices set noiommu is not implementing @dma_unmap
>> as far as I see. Maybe this noiommu check can be removed.
> 
> Not to mention that the polarity of the noiommu test is backwards here!
> This also seems to be the only performance path where noiommu is tested
> and therefore I believe the only actual justification of the previous
> patch.

but this patch needs to use vfio_iommufd_emulated_bind() and
vfio_iommufd_emulated_unbind() for the noiommu devices when binding
to iommufd. So needs to check noiommu in the vfio_iommufd_bind()
and vfio_iommu_unbind() as well.

>>> Instead in the future if we allow noiommu userspace to pin pages
>>> we'd need similar logic too.
>>
>> I'm not quite sure about it so far. For mdev devices, the device driver
>> may use vfio_pin_pages/vfio_dma_rw () to pin page. Hence such drivers
>> need to listen to dma_unmap() event. But for noiommu users, does the
>> device driver also participate in the page pin? At least for vfio-pci driver,
>> it does not, or maybe it will in the future when enabling noiommu
>> userspace to pin pages. It looks to me such userspace should order
>> the DMA before calling ioctl to unpin page instead of letting device
>> driver listen to unmap.
> 
> Whoa, noiommu is inherently unsafe an only meant to expose the vfio
> device interface for userspace drivers that are going to do unsafe
> things regardless.  Enabling noiommu to work with mdev, pin pages, or
> anything else should not be on our agenda.

One clarification. I think the idea from Jason is to make noiommu
userspace to be able to pin page. [1]. But this is just a potential
benefit of creating iommufd_access for noiommu devices. There is no
intention to make noiommu devices to work with mdev.

[1] https://lore.kernel.org/kvm/ZD1MCc6fD+oisjki@nvidia.com/#t

> Userspaces relying on niommu
> get the minimum viable interface and must impose a minuscule
> incremental maintenance burden.  The only reason we're spending so much
> effort on it here is to make iommufd noiommu support equivalent to
> group/container noiommu support.  We should stop at that.  Thanks,

yes. This is why this patch is to bind noiommu devices to iommufd
and create iommufd_access. Otherwise, noiommu devices would have
trouble in the hot-reset path when iommufd-based ownership check
model is applied, and this is the only model for cdev. So binding
noiommu devices to iommufd is necessary for support noiommu in the
cdev interface.

If this above makes sense. Then back to the question of noiommu
check in vfio_emulated_unmap(). At first, I intend to have such
a check to avoid calling dma_unmap callback for noiommu devices.
But per Kevin's comment and your above statement on mdev and noiommu,
so in reality, noiommu device drivers won't implement dma_unmap
callback. So it is probably fine to remove the noiommu check in
vfio_emulated_unmap().

-- 
Regards,
Yi Liu
