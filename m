Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42866508E0
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 09:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiLSIwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 03:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbiLSIvh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 03:51:37 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC8DA44A
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 00:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671439866; x=1702975866;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rICZQzkdOHoBMbpVRZJy4ZbMF/rYzrEfH6QdnceElYQ=;
  b=n37x7HivINxBQtOkSZMw1gcCA4nc9yGbJiYJzWObgt9XzI40WUYSZUeZ
   YptAyEjpZnWPzR79/zyM1cq7db2MQqcKbuG5AqaqFJlGg9qVbrUugLm4i
   kq6ea+ecfeh6AMeUQ5XJvTGBeXertIVUNxSGhZfkRu3AalONncQr55d4S
   NN1VS/ay5FmJolPTSOZwLpapbPqpnD846bbSQN3VhDSxN+RKuxFohZGFh
   0Ri25DQYGNZX26eSmByNqEHGQ5y/AOjSb7hByblfvvugFq5o/9Xq2plTv
   j8tV7bOoaAfqCS/yMw8DUH73HhaxoI/cW9Q5rU+1wotrik4Ycp9tbnIny
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="306977930"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="306977930"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 00:51:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="713941874"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="713941874"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 19 Dec 2022 00:51:04 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 00:51:04 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 00:51:04 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 00:51:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVYfx3TIvkIUVPxHXe4jqWcqQZ/p1zI1ZVPDip/0dXM7Hj0MiN5X8Lki/RiF0L3IccanBj4iBYFnMyrnnOojGoUsPxyMV01y7qH3yw5i3kFMpWzEpUBa1H0ed3JUFqQCz70y/NOertQqN3TXDUF8PCcUZI6P1NBa8Oh/eSfyYMQLMxxcdqcE4RdQfOP3I+Kmw+N7TfatAMv72n/y0P/qsSrCcfc/rcUArOoxWqk2FRGYihKU4zGc89+htZIBw2v526beO2PCeqzt8211AjdFNA1oHD+nVLGFFLICsHfzg3mP28Otc6sqGzpGVi6teNCMh9td45U5j6G4d5WT177z1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLk3E5xoKCSJO+e57f3sNRk2p97hS+xSUYjqNoUjdXE=;
 b=EQRIpFwMEMcwbudeBRvk8VIuVHMC8qIVV7SiVB2VonqEvdp93o07TXhvt8mrGUuWkD8ImNWkVUFW6S8x3ppd/ZfYXCxNE6BtwROTpAVEIHg3+PhWTDEpwZnSdG+tj7367+mSmdudt7tV+bqsgSihWkNofk5cN/3vMXHiLPt5kUgrfDRR/AwAb/h4322tBC1W8utguseKJ4dau/k8Ndu1vELHaCJp5Z6htKMXBYx1N9gvg0KeJt3c7lhL2Jh8rb0co34iDo/+4J8fjf+zxAXT38pDajKOLKOcw5NJzIqWT2DTRo5Hi+QOdbAIglVhAVCSnrW83eTAHa6BlCa7iwkO+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ2PR11MB7475.namprd11.prod.outlook.com (2603:10b6:a03:4c9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Mon, 19 Dec
 2022 08:51:02 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::991e:f94d:f7ac:4f8%8]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 08:51:02 +0000
Message-ID: <ae215589-46c1-bac5-aa48-13ec4bb274a8@intel.com>
Date:   Mon, 19 Dec 2022 16:51:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC 00/12] Add vfio_device cdev for iommufd support
Content-Language: en-US
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kevin.tian@intel.com>, <cohuck@redhat.com>,
        <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
        <kvm@vger.kernel.org>, <mjrosato@linux.ibm.com>,
        <chao.p.peng@linux.intel.com>, <yi.y.sun@linux.intel.com>,
        <peterx@redhat.com>, <jasowang@redhat.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20221219084718.9342-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0023.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SJ2PR11MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: c638539c-d33c-4e5e-1a14-08dae19e2833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TtaJnjKus1hNOHhJ5fWH/nG+5Py4dvbu6AzF4PlbHMWQ/o6pLC5pI/XRxrA8nDmBH0GNGn34ycDmHXR+vDSyiVZHiE+vrCxVq96vgk9M35pvCvTLwmyda+QNa2bIFklDL8gAVY1mt4HrAocFrVxTGVvIAzYGRBDYG3AU2Kg1aYJUw/09Yp1DswoXaaor0XW7cO1Dz0W5d1d3+f1fDtPVAXpdI9uAF5EE9sgIRzUEeydYqLD9+IRs9Q1lxL3YKx5PmZTvSy9lVI42ubbtaa96b7LMybFlj+UvJCD7UU2L5Tiutpr2tua+Tdy0tgEWpSK4hg4JzOoaVs1qJE909nf8Tp8RSXNwi8S++2i4qLyG6Zck3fOUFq8jAQAxa1XUasDBCJaCfWw87yIwOTCDciZDafBJZdsS6LHPKJVttDZ2eS3J28fRk2PnkCgQsaRwytlYMRJWim6RwHcJZ30XUD0sC8Zpcs2HBnnt7fqirSbpx8f859mOKEEfAWEyF5ShmWmLpH3quoSUbzGKSWBLQZyxKAVDvWRwaIIYD7/xmHb6uk793r2lAtAXm0fddtHUgbAk6y4Saho5pgVf6u5hNqgrKbj0ym6F4lyySSb5gxTwQ1XrQ6p8WeKIqM3dx3L4KIoE0YAPk1bMxFiG/nckzpkWsXoiY0kvbcdWD6Hir/cM2I6ymR1qqDDbIx0as7La0tgJC7kkRnp4PRtpQDjMAfSGPyy80SI0ROWLlDQtMomIqbgRyzNcosOon4ftOhuLV3Bas8RNYK+2SeBgUMshpDSB9+D+E995wM0KrdB/SKJj/co=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(7416002)(2906002)(31686004)(5660300002)(31696002)(8676002)(45080400002)(4326008)(66946007)(6512007)(66556008)(66476007)(41300700001)(36756003)(478600001)(966005)(6486002)(6506007)(8936002)(86362001)(186003)(2616005)(26005)(316002)(53546011)(6666004)(82960400001)(83380400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjM0Tk5KOERuVmdOOWZ5c0N5ZHpndjQrUmhVRzBaM2JVdTZWZnpCWlU1eGFM?=
 =?utf-8?B?Zm5UOWwybGNJcEhBL2FTa253MEVsRzk1ZkJndHRVWnZhUzBpUUxmVGh1QWpR?=
 =?utf-8?B?cUhUSURqN2g2Zi8yczVsTTQ1UFBpcUMwdmFBWGY0Rzl3eTBDcERvRzBjOFV0?=
 =?utf-8?B?Nk0vZEMxUWpockRxeDI5MGUxSFgwSVEyN2Y0QXd1Y3Y0dVp6ZlU0dHM2cW9Z?=
 =?utf-8?B?WXhPN1F1RzdsRFBOZHZ3YWpFU05jVEZZVzR0aEIwZkNEMnhMVXQ1QU5KaUR4?=
 =?utf-8?B?VnVBbFplVlhYQytZQ3F4cVZHaVlkNFMxT3RDK3VDcFpiUmgyZGxBeUJ6dmo4?=
 =?utf-8?B?WUJHaC9MUkY5MUtKS3l1RDdPZHEwWGZoYUFSTXg3eEtqWmh5eXE3N1dVYVJa?=
 =?utf-8?B?TTRVREZQUVl1akd6L2xreHRQTElkUERhUkxaajhZcDBGR1VjSmRJeGp2U0Zo?=
 =?utf-8?B?SU5pQ1dHTDJIZnMrYTFUcjRRK3diTnAxa3pybC91ZkZvUzBlVytkTytDWjBX?=
 =?utf-8?B?dUx6QnBmWXMzZjREcFQ3TzMvdHNMejNPZnFXcEpoazAxa09NNW1VZ1E4Tk1a?=
 =?utf-8?B?OXliS2FMeHBrUExmSVFjYWF6M1RlOTluM1RLb1Q5NWNNTGh0UEUxV3pCVFNL?=
 =?utf-8?B?QjNRZVVJSURqREROYkZIQ2RyazZXU2J1ZDhFU0N0MWVTQklnV1NrclZ3dFZW?=
 =?utf-8?B?L2tGZmNkREdCL0JXbGlQcHZPRmw3azNJSUdqZ095T0dIWFJCL2xZSWtlT3hJ?=
 =?utf-8?B?SDN3QjVicGhVaGRoZGZzSitCc25lWFdjZnRsbExBU1ZzNy9pNFBJSTF5bW5M?=
 =?utf-8?B?ZkdHZmc0Z0d1ZzNrTGZjaW84SzAzMzhFWmNOYTI3Q1lxQk5GbXVITjQxYWc1?=
 =?utf-8?B?bDRFTE5LVmFVN3pOZEppdjIwSUkrdStKczZadVZvVURyeGhra0pIOExFTmkx?=
 =?utf-8?B?aGlkU1N6RDUwcEw1eFVkV1ZZUTRSMXR3YlBRU1RBeWNtYy96RnNYTlhVVUJR?=
 =?utf-8?B?VGlWSXlsdnFJUFE1ZlAxODFwRCtiRGR5WmMrWGR3dVNsRVR2d3N5dldxSXJz?=
 =?utf-8?B?a1k0UmdOaHJ5ZFRWeWlSWkx3endJVlhRSUppR3VvUXhaWkovR0Mxc0R1clhP?=
 =?utf-8?B?S3R2RWx5TC9tTko5dlZ6TDAzMDdMT0lDT0thSGRDNlhITDB6RWloc0Q3a2Yz?=
 =?utf-8?B?SFVYT0NuNVB1SzVLY0NGdEhyV3gvcXJUdm5KM0pkK3poM0N6VGFVcCtEZGJm?=
 =?utf-8?B?Z25BYnIybTQ1Q3dIZzRsQTI0a3NydkFJV0NJNnNNbHY4UHpwSzBoVFIzRDZ0?=
 =?utf-8?B?cUtrZ2lESFBNSG5rVFJCb3VwbDlpcUhjZEdoQnhkMGxYUlY2QU1DT3dnUjly?=
 =?utf-8?B?R0VWcUJpRDkrWi83YlhEa0dJY1lpc3dDSVgxZ0pFeUNhN1VtUGV0cDRaalBV?=
 =?utf-8?B?MlBjSHl6dWhpa1Myc1pVTjcwRkR0TS9Zb1F4UG1XblgwanJGblNCMjJVVExX?=
 =?utf-8?B?Wm56NE1iNEgwMEdZWXJzREJnNk5Vc1A1UVo3NzVJaXoyeUx3V0tzT1ArRmoz?=
 =?utf-8?B?anNETDVYRS9DTy8vS0crdnN6UVJJaXZlMzRKTmRwdUthbGlWNmduNFR5R0tR?=
 =?utf-8?B?OFg0eDZ0Z2hiSmp4QVhsYncxZXJkcmNxRkN3YUpiVXBkOGVZcXdHRGl4ZVM2?=
 =?utf-8?B?UnlQRkpKMHAxTkFoMVlHYUJWWXYrZWIza2hOU0RiMS9yWWpNeExJMUJnVnll?=
 =?utf-8?B?UzFzTFBjbTFYK0J4UTh5eWs4NCtqaWZxSE1laVNFSXJXYTI1UlhUV3duUzl4?=
 =?utf-8?B?VU9ZM2RZWVVWeW9Sc2o4TzhPcVVtQ3VFWjRTaVY4RWkxRWd6Q0lESmRscmRt?=
 =?utf-8?B?VFRkV3dNRlpUL1VBR1BlT21QVC9lR0t0V0p4QWVPRjhTMDRRZGlvVFVUSFRh?=
 =?utf-8?B?NHB6VFV4WkNOaWd5YWdnUHdIQVMwVTBLelZyUWYra1JEQ2xoL2hLdTlwS3Zl?=
 =?utf-8?B?VjMvQmMraWJoaVR0c01QKzhoWE9EZ0ozQmhsakJzeXN6NE85bmg2QmhHOWpm?=
 =?utf-8?B?WHc1R3FHS2dCMnJyelZkMm1Ua0tSWlRuQkRLeTArcUZ0TGdKdjNqV0NRMVdt?=
 =?utf-8?Q?OAMwAHv1o4oYrg391avoBbHr6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c638539c-d33c-4e5e-1a14-08dae19e2833
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 08:51:02.2959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5xG3z1bI9Iii0iMPCH8NNzKGJ/OTOcePlQvwphcyekt3pebECee6vqpbPvU5/4dFnC43ELalftQ1ebiCEXcx2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7475
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/12/19 16:47, Yi Liu wrote:
> Existing VFIO provides group-centric user APIs for userspace. Userspace
> opens the /dev/vfio/$group_id first before getting device fd and hence
> getting access to device. This is not the desired model for iommufd. Per
> the conclusion of community discussion[1], iommufd provides device-centric
> kAPIs and requires its consumer (like VFIO) to be device-centric user
> APIs. Such user APIs are used to associate device with iommufd and also
> the I/O address spaces managed by the iommufd.
> 
> This series first introduces a per device file structure to be prepared
> for further enhancement and refactors the kvm-vfio code to be prepared
> for accepting device file from userspace. Then refactors the vfio to be
> able to handle iommufd binding. This refactor includes the mechanism of
> blocking device access before iommufd bind, making vfio_device_open() be
> exclusive between the group path and the cdev path. Eventually, adds the
> cdev support for vfio device, and makes group infrastructure optional as
> it is not needed when vfio device cdev is compiled.
> 
> This is also a base for further support iommu nesting for vfio device[2].
> 
> The complete code can be found in below branch, simple test done with the
> legacy group path and the cdev path. Draft QEMU branch can be found at[3]
> 
> https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_rfcv1
> (config CONFIG_IOMMUFD=y)
> 
> [1] https://lore.kernel.org/kvm/BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com/
> [2] https://github.com/yiliu1765/iommufd/tree/wip/iommufd-v6.1-rc3-nesting
> [3] https://github.com/yiliu1765/qemu/tree/wip/qemu-iommufd-6.1-rc3

this is targeting for 6.3. So would appreciate early comments if bandwidth
allows. Otherwise, I can wait after merge window. :-)


-- 
Thanks,
Yi Liu
