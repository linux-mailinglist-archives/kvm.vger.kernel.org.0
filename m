Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADC497CA6D7
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 13:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbjJPLkd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 07:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbjJPLkb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 07:40:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BA4E5
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 04:40:27 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39G6n1Jh020635;
        Mon, 16 Oct 2023 11:40:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=EJOc1ZFNqLpd9xzSeJe9RUVtNANLLuifAtx2l5k978Y=;
 b=y4+iRgtVImibSVeLkAFqhcdsTY+ZKCSRuVtE1cPXJlCRpINA5KHNdz4mqOYlXkRRxlwb
 aoEByrcXwDquu++cOm2++oivEGNI007Dl86WcGkS22HfrkEb9irTXFgC9gOTggZV2g/i
 N682d8wZ8fJmosNcamuPhibfylKWiy4GCNXdIh1Svg86lR/HRZ7dKdBAVCAiIvSC+Avf
 BNJx2X17YSvf7ZpVOnYeF8FhUZJK3BwtXRtvMDEnrYzsNUVFQynqFRztf6kuiV9Hien6
 jzQs2iS88GT2T2yQjSvUtb/wTOiEPIciVZuGPYq/ZktAHLXnLvMtfbskogZCTf1OADct vA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqkhu2fh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 11:40:01 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39G9UADI040635;
        Mon, 16 Oct 2023 11:40:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trfyjrhnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 11:39:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGq1h434deNTUW/9jk/6nOCz2iEoi+SGcpGQ2qRJzgZzN+Zl3BBf+eO4ZaWpg/vQiOQSA1y2GHgT843XbEQC+IpsYIFSY7IYUXE0h38zp0eoXkaKELWEkHPkoGNyWZ7NpYQkWBMG1sHrVjJsUJ0/kJTUR4k76jeGzN1eoR29rfrSVqymgx95rH0X6RXaCUtCz1Ie16ZjCMLfUQ1eYg80/3sqacfE8+6haBp7tsxwCRg7NrUhv6p93jbMehqRO3gHR228y2NAZYtj1JXbXxZxsE2/ZsyKkxzqckT3bP3MKz5fZYYlID6qFIpfaT6NHmQ9j/ZjRf9YJI1HninwdgSdfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJOc1ZFNqLpd9xzSeJe9RUVtNANLLuifAtx2l5k978Y=;
 b=HDCK64pfkR1Yns4hMyYimIR77LVWvixIzjeGhiB+n8BC/X8xhSKx8mDwdyjkxSIP9H+VnAn4QqbIQ5ut/kHC/5EhAG/jSpdIeqhCzxmfFPUqYrz+yP/9nMspGFtF9+l+Bmu611m+L4VMO1SQWxyxGzJBUhVsQkvrN2nIYLQ5IdgUuDS7PDg0oiw7o/fYDA/YSJJMTKK9pfNp1REYUyK5dKJFNkyBJdjt6lfrIo4WGDm0Eood8fhuR+FmQV0onYsNpBUXR/XeU9J6DZSzB/VvtgIy/XV82lq8CLkpSfJScuGcsUMC0zxbysq91HFX8LyVjfKnuHAht46LsWg4wvnJ/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJOc1ZFNqLpd9xzSeJe9RUVtNANLLuifAtx2l5k978Y=;
 b=FWRknECjVPGtfw3laNBOIXSBBzKTDf+sfXzGC0Yik25hmbrB5hrUQ3lu4TipkWRQce0t01DkhubqRBCX8AV/DEuKYFFA22TvkM1/aQS+8jhQfdCczhW8Z99skwdG1yw1NbafM9SyCClan6zOgCun485234r4+JH4Q9VjLif3f4g=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH7PR10MB6404.namprd10.prod.outlook.com (2603:10b6:510:1ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Mon, 16 Oct
 2023 11:39:58 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 11:39:57 +0000
Message-ID: <e7354a51-4b9e-411c-b6ff-b39a14061b9c@oracle.com>
Date:   Mon, 16 Oct 2023 12:39:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <6859c129-7366-423c-9348-96c5fff0d3a0@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <6859c129-7366-423c-9348-96c5fff0d3a0@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P265CA0004.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH7PR10MB6404:EE_
X-MS-Office365-Filtering-Correlation-Id: 851307ad-c716-4531-0984-08dbce3c9fc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nu5eEmAHU/db8o+wE2RTY2NyzQuBisD3PHm4wqBqa2VyAQfctiCfQzeIGOA3FPmzO378c06wJ3UdDH20dwKaKOEk4Mgc8m7aaItENJ9gczWnbQYU3fLeFpK5lVECbnZ1H5u6ZK8PF/FiVaJk79b9AS7EANfaD5AP+oNs/D6qmqTnJb3nzooIrNFgMbeEdrMNFndfk7ZGnwBw+o0fKOs2A2GnNAeJnqADgmmcG+42kGID/3UoCKMHh3YDJF7Fi91r0qn2qcSB45oZfW8B/JrWrJE7knXfagvHMot+A4/rShoU5NNQEqzXQVxmQybO76j/fSLKkREG8795Az1ZS9oX4jr4OYTf8uXE2ke/MEznOOojE4tWezI2kKO+4+jl5A+ZnyY1LmZx3ZqYQOkzI+YfHt5FLOgDYl2JaICtBeUH/Oed9eqibeTOBbTHVuyegE4gAbkDxyk6FL9VsZzuROAk5L73ikP9LAV0NMIvszHQbrVP9JmZJR13kMUuTkqDPVVYjbEqTBuTD4WuamfJajjUN6Xrm2KYeXAfSCdFGkq0vfvX2ejXvk9OwMaWwN99u8erltuodlMEoLBAEXkF/E9eRg8sfBu/PLAxc8/JuNTvB5W2PeOXsuDXfbC+kQnuzPdIbMWHZ/BpywIv/J4qnQ08fo19+MttJ18KuFx3OvAxlFU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(346002)(396003)(39860400002)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(41300700001)(8676002)(8936002)(4326008)(5660300002)(2906002)(31696002)(7416002)(86362001)(36756003)(38100700002)(6506007)(26005)(2616005)(6512007)(6666004)(83380400001)(478600001)(6486002)(31686004)(53546011)(66946007)(66476007)(66556008)(54906003)(316002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1VNMlMzYWRFMzBUWDFYZmwwdUdEdXRGYWtKd2FXeW9mZUptbWJpcUJqUno2?=
 =?utf-8?B?cmkzUHhCWFNzcTN5VzlXOG02dlUvYmFIU2l3L2ZJUmg0Tm9CMWpQeHR5cFdO?=
 =?utf-8?B?dGtsZVc4UUswK3A5WFJzRTM5VWhBMzRKclQ1NnoySCs5S1lOMWVrakJiallt?=
 =?utf-8?B?cjU2VWpiNEZlVlJlRmdqSVZyelQxUG5CZVByRG1SZmovSUl3NXc0QVNNNGpC?=
 =?utf-8?B?UjZvVEFhYXdSUlF3ZG83aitvV0NXS1AzbEF0VlpVK04zM3BWNUlaR2hubWpZ?=
 =?utf-8?B?alRFTEtCOWJWM2poOVRkTWVDTlJDK3NkRFFrMUx5dFJqWTFTNW95Ny9KS2Yx?=
 =?utf-8?B?T0lyMGdvSnV3QjFqU2xDVjB5Vk1DYUpaNEYxdTJYVjdZSWsvRlI3RlM2bjVR?=
 =?utf-8?B?TEtJeUltMGZkM0RsM3ljT3NET2JxOU5ZcG9kL3h5d0R4Qno0YzFvZGFsSEJK?=
 =?utf-8?B?NU5HODJxTisxZGhxVXN2dFNYVE44RWIxb0JzK0ZaSXIxOTlGZ1draUFKeWRQ?=
 =?utf-8?B?dXJFYlQyMzBMS3pNOFBKYUNtWk5CTzJpRTdYcyt1ZjJTaHdxbkpOcHJlOXBO?=
 =?utf-8?B?QkhhTkVSdU9IcFhPNDNaM0FqZkFibTVCTUhHNi9BWUhqVkVIcW55Ynp2VGFx?=
 =?utf-8?B?MDc2VHhTS3hhc2JsOU5VWklod1J0ZW5hdWFyazluQXFJTlNrSEFJWWpqeWF5?=
 =?utf-8?B?VTlxMUQ5UXlMKzB4RUFSOGp4bXp0ZzhQbmdVRjRac1FwK3Zrb0ZRbTNQeTNw?=
 =?utf-8?B?cmxpMEFRRDBLY3hESVprdnpDOWxBVllyejJPQ0lWQThETHdsWHhaWTdpY2FO?=
 =?utf-8?B?N2FHMGI4LzdJZmh3UGQ5MTRXeU9VMG5OdjNuaVJpSm53UkNYQ3NxQkc3UXhG?=
 =?utf-8?B?VjR4R1pjYWNsd3lIOXVXK3JKSDV3dktUYlhwdVZuejE1aXRkUFVYbmtmZnpu?=
 =?utf-8?B?bDZINDkvYmVKdVlmbzI3V1pXRXlXQlU0M0hHK3BCK0tacXB2NFVGTXRUaElH?=
 =?utf-8?B?aHlVQnBIVkEwbW50a3d3blExWVZoK1d1UDBYWGllN05yTVpjTVZjMVVFOHA2?=
 =?utf-8?B?TEtCdExFTW5mcUVVWFJEajB6QzN3NTVzVHdVSVRaRzl3eE0wZ2VQam5LZW5R?=
 =?utf-8?B?UVJ0REdzZmRIYnRjUTVBZ1JzV28xQzVPMTl6aDRNeGlaMG9XTnNDd3Z1cGlJ?=
 =?utf-8?B?Z0ZlWC9aNVZjRW8yQm40RnpHcDRQcWp6VzJRS3hHcFVwcmNjWmk2bkhiMHpq?=
 =?utf-8?B?TkFJQ3Q5N1RDZFFJMFVqQ3JzeUtRcmo4RnFyVHFqSEtxNVVkRFF5ajZHUllq?=
 =?utf-8?B?RlA0ME1jQS9WSEtVYlBBT2FIb2p6dVk3TUU0bnljaWVYSEROeU9IU2JLT0pD?=
 =?utf-8?B?ald6YWxqQUxqMThhVTdoQXRtTVVRMU53ajh6b3FnMENNMUp1WVRXVy8wTmxW?=
 =?utf-8?B?UXhqeTZYMXY5Q0ViOVhuUU1tazd4M2tsaitaNXpTd3d5cnJsMTlEQVZpSS9H?=
 =?utf-8?B?YU1jZjdCS0dlbWdvdkFxUnk0WFRsYW5aL0RkMzlnNTJFUFhzbEJnVnNuckpO?=
 =?utf-8?B?ZTJNeCtLZkIvOUQ2Y2xwOFo3aWxiZ0UyQndBcS80a2F3V1g0LzBKRnZGL0RL?=
 =?utf-8?B?bE42dUZ4VitGS2dmU003KyttOFFXMWk1MXNoNVczdG1iWEV4UU90QW8zdGhV?=
 =?utf-8?B?N3RWQVFWeHJEQ2pQYjlFME9BSHp1ZXB2ZWlsOVpzLytmcWJuMVN0UWpBK0Zt?=
 =?utf-8?B?cE1GYlVkV2d5ZkRvUGUyODRvWURRZ1hvQVBVQnhLREtNUTVEMjYxOGVMWFNK?=
 =?utf-8?B?enBnKzkyYm90NE1aRVhOZTFXR2VvMkt6dkNtQUFDWllkNXkvT0xrWmxPYjdG?=
 =?utf-8?B?RVVWOVBSNHlyRHhXSUNDbllDTVRDZTR6YzVidlFIRWlYN0xYNjRBdEQ5OXJh?=
 =?utf-8?B?UjNaeHFZczM3OGZTNndoU2haTUhTMGI1TjBUcXVBekhMZGRCTUlXK0lZWUtM?=
 =?utf-8?B?UnNmb0JReXFHUllGU0w1b1p5LzZzY0NWS2g4UnV0K3dnMXFGSlNJT1EwNzlX?=
 =?utf-8?B?SXEvZUR5bE54TDdUekliU3AzbVhUVVVlVzRIUUNzWFRyNUpTR0lIWkRTNU1B?=
 =?utf-8?B?YkI0aDZReE9EWVB5MUVTZ1BCSnVRMno3Z3lRYmNFYkFWVzN5ZWlkeTh2YWVH?=
 =?utf-8?B?dmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZmFZUWRoNTJ5VmhhU3BtNDhHWk5vcEhydzcwTS9LdWVuRko0MEZ6ZU5MeE9R?=
 =?utf-8?B?QU5iNFNXNzlBSGtGOWJzUWRuNmp2eEhGUnZkMUFIZVBQWmFycWU3VWNCN2dk?=
 =?utf-8?B?bHIyeFF2ZVhNU2dWcGoybkgybXRXeTZ6by81N1Z6dXZiQ2JFaFlnaVhRZ1BC?=
 =?utf-8?B?c005SjMzck5ZVUE3U0p3bnl3bFZwWVBaMlRmOWhFdnk3dDlMN096cWhkZDhW?=
 =?utf-8?B?QnNKR1kyN2ExejVTOHZGVGxxWnd4YVJQZ3NTaEZmT3gzT082Vk9mbk9IaU9q?=
 =?utf-8?B?TWttU1E1UEVsS205VGFtY0lkZTBoTm8wTzd6UUlMdEVkOWY3eTlGaVFUSlNa?=
 =?utf-8?B?MlJ6eTU2amhYZHVGaVU3U1J1WUFGeVJlSkxBbjVDdHNFVG95bFdIV01GK3ky?=
 =?utf-8?B?K1pMS0Jkc0Z6dmZGV2FFdGJ3akdUS3BxQm4rUisvRGZPMWMvY3hpU3Jacmdp?=
 =?utf-8?B?bm1Ld1pKTWxFOWxVUUUzbGxOWDVVYm9oZHQ0bEdpT05xakhCbHp4RUpEOEFZ?=
 =?utf-8?B?azBWLzg0bk5udUxrZUl4OGJjaWQra2FJaUhRRWFaUnpHTHlONWdQbjJpQW81?=
 =?utf-8?B?MFRwVEN6Tmk2YXR3U3FCVlpta2pVbEEybldCay9nT25XMXp6bzVTSFhTOGVn?=
 =?utf-8?B?Y29wejFlUzJwS2gwMmlOa2ZzVDJUSFAxK1IvY0VkNVBFb0E5dE5ibFBoNldZ?=
 =?utf-8?B?RTZrQW9Pa2dsYzMzcDdjaUR5MXBaQi9OQkk5VWs5cmhZR3FIUjBFTVJCaDk5?=
 =?utf-8?B?T2htOVc5cDZHRTdmcGJEbWtpWEVuOW5VWXo1WnJYcVgyemhQT3A2SzVkRGJ6?=
 =?utf-8?B?cHpiQVZGV2hQRkd1UmprdnMwVW95NlZwdDJHS3lzOUppMzRxRXVSMXR0UWVl?=
 =?utf-8?B?bUZyQ3V6ZWVwU1A2eFlIOE5XS1NoZXJkNW9UVmRDRG96eGhWejdSN1NpZExy?=
 =?utf-8?B?OVVZQ2UwSStkWENGUE80MHo0a1RwUThHVUFYbW5Fc250U2FHbWZrN3NMU2dT?=
 =?utf-8?B?dzFzM3c1VGJldzVmK1dvVlFzU1hUMVozU1J0Qy91M1JHSllBUk82S0FxdTZ2?=
 =?utf-8?B?eGRNQ3Mxc1EzVXlMOXRKWEc0VUFNNTdKMmJEcWZnRzZIdVZxM2pUMVZxMjlU?=
 =?utf-8?B?bEZFbnZwcnpCTFhMMWRDc1U0eG8wcU1vS3BJSDl2Y3ZXakczRGFGZ0tiekxj?=
 =?utf-8?B?TnNIZUpnWC84WkQ5YXJWYnJzR0EyNHFjMGQydU9kSWVpTzFZRkZRRXg0bFRD?=
 =?utf-8?B?U0pzeXJwUVp0VDg0ejlXaVp0cHBVaThoOXVYVHh6aFJFdlpCdHh0djdiZlU5?=
 =?utf-8?B?dWh3K2dkVzAzUlcxenpkM3VxUUFxSWh0SkpTYmNrMnhlNDBibmVBVFJrRXQz?=
 =?utf-8?B?WlgwaUx1LzJtZ05DZGMrbFg3RklzM2p2dWhFUkg3UU1EanVFQkxjSElSM2Fz?=
 =?utf-8?Q?SPf95LjX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 851307ad-c716-4531-0984-08dbce3c9fc8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 11:39:57.8746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zGuZ8q7MvQHGPFyANNOokDlYxzbQC0lXlhZjsnfHj0wIzoT3DRuVrnli/wNBRqeErRBEz2JtnmB4JTIiuJhqUbpEBOsG7bKCzPTIetWSWA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6404
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_04,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310160102
X-Proofpoint-GUID: DiTCnlixHMZGeRawH1gkr9P6_7qr8D0c
X-Proofpoint-ORIG-GUID: DiTCnlixHMZGeRawH1gkr9P6_7qr8D0c
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2023 03:21, Baolu Lu wrote:
> On 9/23/23 9:25 AM, Joao Martins wrote:
> [...]
>> +/*
>> + * Set up dirty tracking on a second only translation type.
> 
> Set up dirty tracking on a second only or nested translation type.
> 
>> + */
>> +int intel_pasid_setup_dirty_tracking(struct intel_iommu *iommu,
>> +                     struct dmar_domain *domain,
>> +                     struct device *dev, u32 pasid,
>> +                     bool enabled)
>> +{
>> +    struct pasid_entry *pte;
>> +    u16 did, pgtt;
>> +
>> +    spin_lock(&iommu->lock);
>> +
>> +    did = domain_id_iommu(domain, iommu);
>> +    pte = intel_pasid_get_entry(dev, pasid);
>> +    if (!pte) {
>> +        spin_unlock(&iommu->lock);
>> +        dev_err(dev, "Failed to get pasid entry of PASID %d\n", pasid);
> 
> Use dev_err_ratelimited() to avoid user DOS attack.
> 
OK

>> +        return -ENODEV;
>> +    }
> 
> Can we add a check to limit this interface to second-only and nested
> translation types? These are the only valid use cases currently and for
> the foreseeable future.
> 
OK.

> And, return directly if the pasid bit matches the target state.
> 

OK

> [...]
>         spin_lock(&iommu->lock);
>         pte = intel_pasid_get_entry(dev, pasid);
>         if (!pte) {
>                 spin_unlock(&iommu->lock);
>                 dev_err_ratelimited(dev, "Failed to get pasid entry of PASID
> %d\n", pasid);
>                 return -ENODEV;
>         }
> 
>         did = domain_id_iommu(domain, iommu);
>         pgtt = pasid_pte_get_pgtt(pte);
> 
>         if (pgtt != PASID_ENTRY_PGTT_SL_ONLY && pgtt != PASID_ENTRY_PGTT_NESTED) {
>                 spin_unlock(&iommu->lock);
>                 dev_err_ratelimited(dev,
>                                     "Dirty tracking not supported on translation
> type %d\n",
>                                     pgtt);
>                 return -EOPNOTSUPP;
>         }
> 
>         if (pasid_get_ssade(pte) == enabled) {
>                 spin_unlock(&iommu->lock);
>                 return 0;
>         }
> 
>         if (enabled)
>                 pasid_set_ssade(pte);
>         else
>                 pasid_clear_ssade(pte);
>         spin_unlock(&iommu->lock);
> [...]
> 

OK

>> +
>> +    pgtt = pasid_pte_get_pgtt(pte);
>> +
>> +    if (enabled)
>> +        pasid_set_ssade(pte);
>> +    else
>> +        pasid_clear_ssade(pte);
>> +    spin_unlock(&iommu->lock);
> 
> 
> Add below here:
> 
>         if (!ecap_coherent(iommu->ecap))
>                 clflush_cache_range(pte, sizeof(*pte));
> 
Got it

>> +
>> +    /*
>> +     * From VT-d spec table 25 "Guidance to Software for Invalidations":
>> +     *
>> +     * - PASID-selective-within-Domain PASID-cache invalidation
>> +     *   If (PGTT=SS or Nested)
>> +     *    - Domain-selective IOTLB invalidation
>> +     *   Else
>> +     *    - PASID-selective PASID-based IOTLB invalidation
>> +     * - If (pasid is RID_PASID)
>> +     *    - Global Device-TLB invalidation to affected functions
>> +     *   Else
>> +     *    - PASID-based Device-TLB invalidation (with S=1 and
>> +     *      Addr[63:12]=0x7FFFFFFF_FFFFF) to affected functions
>> +     */
>> +    pasid_cache_invalidation_with_pasid(iommu, did, pasid);
>> +
>> +    if (pgtt == PASID_ENTRY_PGTT_SL_ONLY || pgtt == PASID_ENTRY_PGTT_NESTED)
>> +        iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
>> +    else
>> +        qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
> 
> Only "Domain-selective IOTLB invalidation" is needed here.
> 
Will delete the qi_flush_piotlb() then.

>> +
>> +    /* Device IOTLB doesn't need to be flushed in caching mode. */
>> +    if (!cap_caching_mode(iommu->cap))
>> +        devtlb_invalidation_with_pasid(iommu, dev, pasid);
> 
> For the device IOTLB invalidation, need to follow what spec requires.
> 
>   If (pasid is RID_PASID)
>    - Global Device-TLB invalidation to affected functions
>   Else
>    - PASID-based Device-TLB invalidation (with S=1 and
>      Addr[63:12]=0x7FFFFFFF_FFFFF) to affected functions
> 
devtlb_invalidation_with_pasid() underneath does:

	if (pasid == PASID_RID2PASID)
		qi_flush_dev_iotlb(iommu, sid, pfsid, qdep, 0, 64 - VTD_PAGE_SHIFT);
	else
		qi_flush_dev_iotlb_pasid(iommu, sid, pfsid, pasid, qdep, 0, 64 - VTD_PAGE_SHIFT);

... Which is what the spec suggests (IIUC).
Should I read your comment above as to drop the cap_caching_mode(iommu->cap) ?
