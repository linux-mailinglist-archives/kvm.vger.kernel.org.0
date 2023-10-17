Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A04A7CC808
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 17:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343893AbjJQPwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 11:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbjJQPwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 11:52:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBBB95
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 08:51:59 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HFi5hD007835;
        Tue, 17 Oct 2023 15:51:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=UrTq/g1hThIQmISb+4gIlZK94xKwCVALBTW06oxjRQo=;
 b=IFLfEr4AF8Z/3UTnAy6B9GpDXute/vmmRUEZvH9gq7ps5g6AI96gr2DtjXNVBHtN9H+5
 9ay+1s2XWl38Tlhb44F391sBGoJzTHuUHBInyR3DF7U9YiG2Z7R4TN2w31SN2GEbdUa5
 cu0GopCmRZmBlNyzGDt5kzqV9mzInBgAuqS8vG3PSgZQlUcvLjOspPoglgWsukLriK1N
 uaaExl8YV0CO1c5eCc88YO+pCujkX4cRY57m/w3lOqv66ecwn+EsV+s6yXJBDNRYUA4e
 OyjxVnL2XJStvjcwAiH/M7kUxpW78fqHYJEvUOcfhbYSgNaL9OR6uXTgC22gHQjkz32X /w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cwgy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 15:51:34 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HFG2SB009770;
        Tue, 17 Oct 2023 15:51:33 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0n08yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 15:51:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IbMmTtx5UNhDIVoBv8vg2nqxCxbugIjrcGCkvwxd/fRj0xwG6IWqCM5Ah7Afvimkg14skxEC0QKZ0wAgCFJF3ErDJIOZddCvRV6NsiyWoeyM+t/FONCSL968pZP4RRzzXMMrUgPJEGoDdBRsO/nrfK41eJK6A2+mytnfBbxN0DJJzqD0JJMuWt+xeXQHy54bsr42jnDeqAaOe36kufbsyOxiVwAzb8xr1/R+IX74lZyUW5bFy9e7BXQfTVF8c083sz1Xt0A7yxw1sAduYvDj2SwOYvQtOXorSK/puSsOtowlzFDFoYwP/UBpvb6jHcRKHozkulCCRlFx19twYO4Y9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UrTq/g1hThIQmISb+4gIlZK94xKwCVALBTW06oxjRQo=;
 b=BQ8B6vOUFrVQ0qAup7vNHaxUegE178hXTpI0K8SCaWmtMNwbTHwoNh+4m545F47vIiMTUbI8vcv+axAv9qpQggEzR1T+ZV8WUXShUJoB5Js0DFWNQF9711WdCOXQOoLkpprUdHgAksciz93QnKiD+TcfVIDMpEZ9stuFLh/bpKGhOd+M6qVEXPPzCcnMiXd974OS+22fq0CSaIkrZmSUREvn0t87qyO8Jelk0kakhKE2dmY5hDlD253FPtbnlkMOVAEwr6Om/QSbJQ+M+gFaJYizvsPbGsO6XeQAPtgAN/L2kHkib4qagvqBl7KtEmPBn23TJ0dZbafe9RIsktDQ4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UrTq/g1hThIQmISb+4gIlZK94xKwCVALBTW06oxjRQo=;
 b=ff6iir65VA2DJhZ8EcYTqHJM29ZaePNOXM/UC7QwPFr7WwkpspYqac4VfJ/5/hGpcJsuiRg39m7f6eInuqkHKmqtQEJPJskxOGK+W9qaoI/nnnsrlC3MBZ+ycQpgfp8tfrDTHwRBVsbf50w7HkbCt3sICa35VIPCfYlQrfr/h14=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH7PR10MB7009.namprd10.prod.outlook.com (2603:10b6:510:270::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Tue, 17 Oct
 2023 15:51:31 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 15:51:31 +0000
Message-ID: <df105d06-e21b-4472-ba1e-49e79f2c0fd4@oracle.com>
Date:   Tue, 17 Oct 2023 16:51:25 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/19] iommufd: Dirty tracking data support
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-8-joao.m.martins@oracle.com>
 <f7487df9-4e5e-4063-a9e4-7139de63718e@oracle.com>
 <8688b543-6214-4c55-a0c6-6ecab06179c6@oracle.com>
 <20231017152924.GD3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231017152924.GD3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0119.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::24) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH7PR10MB7009:EE_
X-MS-Office365-Filtering-Correlation-Id: 13240698-eaaf-4b7c-c36f-08dbcf28eeb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qPkMkxqJKc3gUdjcvPHyzyF330u8UUv4DLUQSrRYkV9pkDMwTMKT0P3FZhselPV21sdyenb6w71E/7UlEUVUsa1ptulxxh2gHR5H+TezAG9vQa+l2vEQlVSSZWKauH7BUPN2T9ixmzdrWbQXxb11trTdjr3pkq3gFiH9JIUx1jxBSy5GFmDClccbCcZC2TdYOVAp9bWi7u+MFWBw+saGBHw4FrrN83+Synkni43IIUEkOjAPfpgRSKiC9hPAV3rOpo1GxrLZQ6BJxS6fuR2LkZYsb3wdXjcVB+7aEFxWF2OrkDfYZL+OXY13QLHHAZD2IfnVZ986QpVKuMuDBOzs2vSwOAJefyE/XZF2j4LOMsecprb0aJZxDFnHbSUE+NFFsJO3BqiMeZXzkaGrai8FBFVIO4Cvb2/AHCqSfRsyjA4JEnUpQMghv5Lol73yIK0jgxhC5eFjNkPs4sy4Y5jG0Dc8cYZOd1M2MH3A9U13hRvHmdbzve6Wx+wSsI6sLaAX8Kbtpy9ukjPy8gz5eDtvv7GTyFEt90e5rJgZlHWB5b6HF5ziI6bZU37Ng1WCQUAj6+H6xep9KEM+4UXCAa1aqhIBZMip6AgZeCbb7TY2ytcP9+oeLq5JxE+YOeUD2qwhjSGS9mkmuez6dqyA+yZgQJxG58iTtDQp3nkh/JnJN+A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(366004)(136003)(346002)(39860400002)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(478600001)(6486002)(6666004)(316002)(54906003)(6916009)(66476007)(66946007)(66556008)(7416002)(38100700002)(86362001)(31696002)(36756003)(2906002)(41300700001)(8676002)(4326008)(5660300002)(8936002)(83380400001)(26005)(31686004)(6512007)(2616005)(53546011)(6506007)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmJQTGtyTVNMNUJSRWh6RXp2aVRmenBxZVkyOGRMdXBCdUw5VGhweEEvR0Zi?=
 =?utf-8?B?dWFGSDRqZUtEbjVxQ1A3Sy83Wm5qaXlXcHlIc09LQnlEV0htV2FhSXhURzFi?=
 =?utf-8?B?VXF5ZVUwWThaalBDZlJrdGZka3Vpa2hxSEhiT2o4QlN5aU1nUWlFeUpRSVBY?=
 =?utf-8?B?UDJxZEhId2Nod1VTejMyenN5YTExd0FucnAxNTFGTW1weHRRSWk3dXhsS0ds?=
 =?utf-8?B?SmoySEpjdjJnMmRSTkxKT2p2YlM1akttdUI5NGx4V0x4OStFQVZhY0Z5VktM?=
 =?utf-8?B?WEQrVmd0K00xTlM3NFZzcDhZRTVqd1g1WmtvSkFqQXZWNGRaYk8yNDZpQzRn?=
 =?utf-8?B?ekxnZE1GVG1hUzd0WUEycFc3S1lYa2dDYmV2aHFWbU8wekhEeGloMU0vM0Vv?=
 =?utf-8?B?L2xCc2l3NWlyQXdqcjRsKzVLL3ZleGx3cHM4ZGhSU2xGelBvQjgrWVNUZ0tv?=
 =?utf-8?B?TktPQ0JsQnRBaXJYUlZIaThiQ1dSNWM1cGs2Z3JlRzJzTU5HUjJiME9rUnpm?=
 =?utf-8?B?WkhnblZxR2VsUS9xcHVXM1VKck9QcXEzWDZ0dEpkdXJJSVlKTER0L0ZUa2hu?=
 =?utf-8?B?WG53Tm8xdmtPUHJnZTJNVWVtb3YyVGF1cC9tdGxGMVVVRnpqTmM0czY1d0pC?=
 =?utf-8?B?RXhRaWZ4Z1YrcnNibUlJWmo5bE1lR3VrbWIyY0R6YVBWZHdRcENzWmxkOTNw?=
 =?utf-8?B?d2VSV0tNUStJTzEySWlHK0RxaFlMdjEwV1RWbnpzV2N6MnJCa1A4TmNqVGZ2?=
 =?utf-8?B?K3FWNXZYQytOblgwT3JibXpRY2ZRWHUxZDAzQzZVSk1ydWVFSmlZU0NZemxl?=
 =?utf-8?B?aE5iQ0JXZkt3OWVkWWdYVEx4WG00N1dhaHFCbVczYnNscFBGdldISVlmSUxF?=
 =?utf-8?B?S01Za2U3M2s1NGp6N21lZU5oa0lIRzdSS3VQZjJSV2pkSlN4QytPQk5ZcDFs?=
 =?utf-8?B?Qk5OZDczUEh0Z1I4OWF5ejJ4R2wvd25laGl2RWUvRUMzM3JCN2NRM3dnZysy?=
 =?utf-8?B?VEhUeWRJQlVSQUFWYzJjVWNZQTRjNk56cjEydGliRjFXalRCRXVIa21KaWRJ?=
 =?utf-8?B?K2JLdlBMNDhuQktCT3gwWWd2ZUNHdTQ2R0dycUdRcElMbVpOZEZnampwWXUr?=
 =?utf-8?B?N0lUeTQwaTBwcDJDNld4WlFHcUR5bkRrc1grbHVYRk5FTmFTeCt5YzdTMkda?=
 =?utf-8?B?QkVTL3NZdXAzQmh1dDJLTWk2Rk1oei9KZTNQSVFXd3VRd0lESXN1VEJDN3Bz?=
 =?utf-8?B?OTEwVjBJVmxUVkVvSklJNk8vQSsxVVpodmY0aURiaHBkUTdqamNJYWxveFJG?=
 =?utf-8?B?N0FWWjZaUVZwOFNXM0lKd09iVkoxSmhIVmphN09BcXlIUjJiWWdGMFZNa21p?=
 =?utf-8?B?ODN3aStNODRPcGNMNlpkcXc4dkMyTVhQeUdieE9KZ3Y4Y25sZUI1ejY1WEc4?=
 =?utf-8?B?WmU3ME5XVm5NajM1OG55YStSczJUMVRiejZSZThvVmZqUERWT3VzZlVpVmRw?=
 =?utf-8?B?SnNVeHZvdXY0MG9LRVVEbE5kQ0cxQ2tidThTaVZhc05MdGdzTnh4OHl1MlN0?=
 =?utf-8?B?TzJzTm9JYlowcFBXMmZEeFUweVlJYUpxdzV2ZTltS0pKLzlwbjlwVTVXUlJk?=
 =?utf-8?B?S0NhcVMvUlIvRmIzK0ZoQVZtbHNGZG13Qm1hRlQ2elNZLzNTRmtSR2V1Zk4v?=
 =?utf-8?B?Q1JONmpaWEQ3dlJXZWNSOWMrcEJ4RXZhbG9waXhoWXVPQUF5eDhVOEc3anpq?=
 =?utf-8?B?NDZNVnZtUFZrZ0ZYdFF0VlNEZ2lYb2FadzRWU0FJWkc0SVgybG45VnM1UGpI?=
 =?utf-8?B?bzZEbWE3SDVDS0wrWm1PNzdhVW43a0x2cmxLT0hZNlcxamFaWUtZWlE3U2dM?=
 =?utf-8?B?VzQwTlczbmRGUFM0OUVwbm1LREFobkRMY1JOYStiZTJZa2FlOUM0Z1RLM080?=
 =?utf-8?B?UDJBSnNPcWNBREtoNzg0bUk5ZVMzQmh3aFdQT1VYTzVxYU12d0Y2eTlvd1NY?=
 =?utf-8?B?RWNYejNZcTQwTjRTQ3Z1Z1NDWFdvN1JTOW5yeXBXdnRFK01iZ2RzcjNLQy81?=
 =?utf-8?B?OVhzZmJKWURJbmZzcFpYWU5UMUZ6VjZpb3hJVExaaklKQ0Y1SFV1bVpBcG96?=
 =?utf-8?B?UjFUcGdIenVKUUt6clFWQXdCbWFXYWtsNkV2dURRN3RJVEhKTG9PYkp2Uk1l?=
 =?utf-8?B?Q2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Uk4rZVVHOG0vMWhTSDFpRlBIaEJRRERBckF4ZDlnbm8yditMdWgrMG9qVzkv?=
 =?utf-8?B?bEZ5VUpmaU1mMzdoYVJlOUp6dnJ5R3R3SUNhSk9EODhqMGcvR1VhMUhBTUZx?=
 =?utf-8?B?Tk9HSDV2UTQ0ZlAzOVhNNHdVUVAwU2ZFVUZiV2ZYOG9BenRLNGFnSFNWRjBs?=
 =?utf-8?B?dFJ0MGo5UExWWit4U0RWNWpERHlYbU92NXFvZjZsU2svcnZ2Q2JvOTJPSXlu?=
 =?utf-8?B?aTk4TFV6SEU0aE05SzNqSkoxaGo3Rkt6M1ZxcElVOEw1WFJZeDA5YXF5QXBL?=
 =?utf-8?B?UitaRVBJOTNOUTFZUTY0bWZKV1cya3VSbVdpbjZQVzlyZHYwZGlsWUVPdmVk?=
 =?utf-8?B?VEUrT1QrbGZLZ3p0clE0cGZVWlZwU3VPdmN6MEhYbjlOTmJUZGRva2wyT2RW?=
 =?utf-8?B?QXdBcHhwREFyaFZrUkw3bzJpUkFGUVh4dlJCall2ait5b1hQOVVjd3dPc3Bl?=
 =?utf-8?B?M0Q1QXFzY3JFSTBjamhJdi9RZmlMRURIRmFDQm0zVUllVHJ5N2Y2VkUrTURz?=
 =?utf-8?B?OFJBMkR2eVFSUmZ6RVpDeU5PMlFsbllvWG5va1BNaU4vd1lFakZkRlJoRjYy?=
 =?utf-8?B?M2pnVGVtbGVtWlRYT3U1cjMvRUNTZXFOMkcrNTFHRE9Ncm8vV0szcFFrL2E0?=
 =?utf-8?B?Q1ZTVWY4YS8zR0VjZzFwVTVuNUlFQUlhUU5Bc3FBWnNLNkRTQzNTRVVZWWF4?=
 =?utf-8?B?SEdyeE12SDJ3SkpUSGxNREFydWRMbUtMSlVLdm5pakJ1TDlQUjdPZWdJTndy?=
 =?utf-8?B?SFJ4cENORUJFZnVMWjd4cytIcDU4djB1TjRsM0dROGtaU2VJV2g5MEw1NHRC?=
 =?utf-8?B?MGtyTEFRYzJuN1VGaGpTOXJkbjVRWW1hNE9CUlRkRi9wZ00vMElWUTZsOHpz?=
 =?utf-8?B?ZlZKQmZvZkNyTTdGTDlrU1pvMUd2MDBFdjZLaXVhTmVZaDE1L3hPbEFQaEx4?=
 =?utf-8?B?ZFJhc2Qxb2NsOUZ1VVFKK3A1WE93NGZJTjlLRnZjM0JyRy9wajZVSFM1aVkv?=
 =?utf-8?B?ODd4S0hZdks2WjNnc0FEZXlLMXFPVjNySlRHcUFxSm9QamZueHhKaENDelFT?=
 =?utf-8?B?VStoRXdqdGFwN0JDYVR5bnhldVJyL3JWM2RSSEY3YW9tb3p1eTF5SXNIS015?=
 =?utf-8?B?ek5JQWI5U3hQcHdoYWtqWWl5VzFrWklCYlAyRXBYenIrWDd6QkV4NEJnaElo?=
 =?utf-8?B?aUI1V2hEUmZ1ZFh3RTRSV01HT1NqS2E4WWdZeDQ4ai9Ud2w4eHl0YjBjdkJH?=
 =?utf-8?B?L0JhR0ZzNURqd2hjbXhzZmdMV2h1b3JsVW9IbDNZR3Bvb1h5RlBNcUhBUWZ0?=
 =?utf-8?B?SWVRaElncHZDeXJPcGNKcjRBWE1oSzRpWnY0WXU1UzBlbjFqU2szajdTM2Vw?=
 =?utf-8?B?ZFpmcnlVQmFOZ2cxd2trWFlrajY5SklIRllRc2xzU0NLR2N5bEZURnN0bEg4?=
 =?utf-8?Q?l4SbrmAT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13240698-eaaf-4b7c-c36f-08dbcf28eeb2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 15:51:31.5131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ULJUp+E9lzUZtpL2L8q9D6xmJijhNWNQnIJgPu2smIB6S9vLbtTKkTAkvGI578aWs/vrjC8uLYREUjrW3+E5l5u5OY074vhNbSS1RNeoy1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7009
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=787 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170133
X-Proofpoint-GUID: tjANSOn2AquQd2NjIiQHOD9YyggSCArh
X-Proofpoint-ORIG-GUID: tjANSOn2AquQd2NjIiQHOD9YyggSCArh
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 17/10/2023 16:29, Jason Gunthorpe wrote:
> On Tue, Oct 17, 2023 at 01:06:12PM +0100, Joao Martins wrote:
>> On 23/09/2023 02:40, Joao Martins wrote:
>>> On 23/09/2023 02:24, Joao Martins wrote:
>>>> +int iopt_read_and_clear_dirty_data(struct io_pagetable *iopt,
>>>> +				   struct iommu_domain *domain,
>>>> +				   unsigned long flags,
>>>> +				   struct iommufd_dirty_data *bitmap)
>>>> +{
>>>> +	unsigned long last_iova, iova = bitmap->iova;
>>>> +	unsigned long length = bitmap->length;
>>>> +	int ret = -EOPNOTSUPP;
>>>> +
>>>> +	if ((iova & (iopt->iova_alignment - 1)))
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (check_add_overflow(iova, length - 1, &last_iova))
>>>> +		return -EOVERFLOW;
>>>> +
>>>> +	down_read(&iopt->iova_rwsem);
>>>> +	ret = iommu_read_and_clear_dirty(domain, flags, bitmap);
>>>> +	up_read(&iopt->iova_rwsem);
>>>> +	return ret;
>>>> +}
>>>
>>> I need to call out that a mistake I made, noticed while submitting. I should be
>>> walk over iopt_areas here (or in iommu_read_and_clear_dirty()) to check
>>> area::pages. So this is a comment I have to fix for next version. 
>>
>> Below is how I fixed it.
>>
>> Essentially the thinking being that the user passes either an mapped IOVA area
>> it mapped *or* a subset of a mapped IOVA area. This should also allow the
>> possibility of having multiple threads read dirties from huge IOVA area splitted
>> in different chunks (in the case it gets splitted into lowest level).
> 
> What happens if the iommu_read_and_clear_dirty is done on unmapped
> PTEs? It fails?

If there's no IOPTE or the IOPTE is non-present, it keeps walking to the next
base page (or level-0 IOVA range). For both drivers in this series.

	Joao
