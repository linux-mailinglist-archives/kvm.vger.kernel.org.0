Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355FF7D1601
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 20:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjJTS61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 14:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJTS60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 14:58:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63C2114
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 11:58:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39KD7f06013033;
        Fri, 20 Oct 2023 18:57:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=whJ/AkYnZWDRNhTPn9t8KbcFYWS89ZpU9RbSJU54rwo=;
 b=4NeSdB0u7gFK9L1UVOKk4ad3+oHKdRtYYAywK2bklFODmokK8mnlh3h5xea1H7YoIIZV
 paM/Yv5yJPFuepcO1EKPUxs+CnxPR1dnGmYze13rX/rKI/w8BVDq5YawxQzm0UOmYEfZ
 seg6Uet1GzFioQBbMLYfs0+Axo1icA7OpBZ2K/CQm5F+IO9NY9b5GHrEXAylwjRzeGnU
 dcCrWH20ViwvTItAZvFrQRETO3RqY7BaSLCLjPaZbwBpe93AMbj7kQjEyX99rfvHUK6A
 eSBqw3FDImk/6hYBghPt6UU+2BDHfJWBWs7MJH/758YKvvx2uVDo2F2YtXOH3cUnnuU9 Bg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tubwbah17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 18:57:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39KIK46P031769;
        Fri, 20 Oct 2023 18:57:48 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tubwe5m5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Oct 2023 18:57:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5FYk/vm+jvFPI6fniM1N3jqFzpTcUNY18M15bj/+2Ktfkg8vRgcBd1fMgDAFAV/4PJvOK7ConzSbA324wAUjnglYPJcLjhbR7st/E1W1wEd0Zi1cAxpnFsPsNHC3Nmkctau1tm3+0nnxx8DAoPI1sGcWZHvVWu7u5aVVy+TzD5uTlX+1O5LwKLAfKgDEFKYAjs/q3804loUcQJNNVJKUyBk0nWOsLbI2kPs128LwJur2nmHpRYSvLAoFbkWzU+cY5dd2sPN0uh1TgXtr2T595ca/O/kXCTn0/hEujnKsmGJz4CPP6Ht3FsDQvjQGXtYDAZhEybZo6G43xaMmODunQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whJ/AkYnZWDRNhTPn9t8KbcFYWS89ZpU9RbSJU54rwo=;
 b=AxzeQ4+cCc6ApfdeiZGnk4vSY8Oilv0LZQYo3VzlziLFu8SmJw7HRtMv8Ksj9TwgPsXETI5DrlIue0Qon9cj1sc5v65Bl0orCD84E0UVRVF4wDKbQK2uBUHFaIlB5gAJihhvThnn1BHmrtAWczESKn6/rv5APBj6o4gB7qi+N4TOD1/8esRzlWEURmQrXteuVAE1ng7i2hvs7S4eG0D4cSbbpwlVWnhyTqndm2E1poxSTGeIY7C91OzAjrmkyUOT10lhtEduCskrh5mzehEDVyGIga67XwN1pZ+270z1twDHTule+RAzcUlEdmjD46Vmu37FJUtiWag0LirUHsFFJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whJ/AkYnZWDRNhTPn9t8KbcFYWS89ZpU9RbSJU54rwo=;
 b=xxoQArXSI0csTaz8MNlI0H883laXaOyXT95dTADN+qSWy2Pi9u/CGO3pzFjjj7IDXYs6yH/UToQnH8X15UeZJUjayCJKYETyucpyp9Lk8X/E/rc6Zsmj7HD+BT6RDEGgsie7iaxZw4qo/klSaHkkHBlxWZnIM2oAPG5ZAESG3HA=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by IA0PR10MB7578.namprd10.prod.outlook.com (2603:10b6:208:491::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Fri, 20 Oct
 2023 18:57:46 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Fri, 20 Oct 2023
 18:57:46 +0000
Message-ID: <0896d2dd-416a-4121-adda-cb589815f19d@oracle.com>
Date:   Fri, 20 Oct 2023 19:57:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/18] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-12-joao.m.martins@oracle.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231018202715.69734-12-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0074.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::14) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|IA0PR10MB7578:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ce767aa-9241-4974-7a98-08dbd19e72b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: drGASFiRvA03sexjnhGvyTkZjVXym1UQ3O6h0Tqg1VmFFvq9LSL074iXUVMy//HSJGwcI7b0KM/6oXYH3bIiaLzHBGPM/JzaA13H2azXq05Snz/7baAUszroXycL3rSgY/Pq/5Mv6wV35vw22eYIUHn9nUNxJIlfRDM88j24NTXw06DBUnD+4cZBjqKGraKc4iYGM1pqy1l/LYAIm3hGj7JZ76bYz2kcJNlayXcML1JVPM9PhpISw/8xyhX9VNQbaWVF0UYUU/vcRBo5VxRLkV/iFPfVPGWVwyiUD7GdIFGvbDseYkYykY4NRpktJgChYBIuPs0wkAQgDbyGj7n/v782oszQCHFRk0r3Y/H8rlAZkSNdBDJ+8lMxGKVl17CPGaDpphZepn9abirYaIL+SyeU/BVBkL1cZnw3V/sUB2LViL0Npd4uelNMYDgRKw09VIUCGdSL7Mog/5pRCra/8L0GTyJQphASXMUCBN0Dz+aOiLSUtd3uP2Roc4oYflXkzw4tNA8s+lO3ZqDFzxrhHGXg4VZX9OXHGTO/ksZsHzwGZOW+vDNdnMEfbkYXL9MZMr6xNmfatEbMXaBb3uic/2kuIs6vw+X1Wr2o/t70p9ldHRRZSsuEv7ElVjp31/sb1YyqIJlWkvVQ377L75pvTd44RYbUBvBeduYJbYEqhco=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(376002)(39860400002)(136003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(31686004)(86362001)(7416002)(38100700002)(6506007)(41300700001)(36756003)(31696002)(4326008)(83380400001)(26005)(6512007)(2616005)(53546011)(8676002)(5660300002)(2906002)(6666004)(478600001)(8936002)(6486002)(66556008)(66946007)(66476007)(54906003)(316002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVRDNnlkNEFUcnVWT0NEaFJxM1lIcG1ZM3p2SFZ0RVluMWt6RlFZR2d4a01E?=
 =?utf-8?B?WHh0MG42RVVnVkNpbTlEeXM2aFZvV3VkTW05cW00TktzU096eE5mYXpHWVpR?=
 =?utf-8?B?Y0kxRGtYZmlPL3RzUE1sTFhVR1FxVHpOWStERGFHditQcUlnb0lpdHhJS2F0?=
 =?utf-8?B?YVlWUVFmUlJySkNCWkVqdGVGeUJVMFVEV2J5VDBmUHkwWlBtdjlTU1VMands?=
 =?utf-8?B?dWNjQ0JFVWtpeTFVbXkwdzZHcTAwZWdtWTZNMDZBaHJXWW1UZ2N0Y3pBTGVi?=
 =?utf-8?B?SjkxYzFXQkpZQlVHaFZOalBSSllVOVlWcmRka0t4UGwvNlc1Y0NLLzNLYS92?=
 =?utf-8?B?bStWMGdSZGFBYlp5WWFnTDF5KytXQkttOThOQUhkUnFpdDloaEVoNXNmRFNU?=
 =?utf-8?B?Z0cySjhteXcwbktEalRzUVlLUE5YOXNKSjV5UGJPNHhSOUIyT3BraGtUemVK?=
 =?utf-8?B?eEcyK1FsZTE5cURyelIyZlBuZU1CWjdMelY0WXhaZWg1cFJBMjl0RWxPTjBX?=
 =?utf-8?B?bmZpaTh1RnhWbnNQSTYwNmE5VGM1aXRJM2NYa1RYbzFJWjRGZ2VHTitQSC83?=
 =?utf-8?B?eUtGWHhJZnpHVXNOWENTM1FGYnRySXcxVVVCeFdIYWFIZkhxK0IwcGpkWVp5?=
 =?utf-8?B?YWY4QWt0RkJLWXBmZXVWU3ZlVVlQcFk2M09xeXltczMwWENVL0Zma0JPdk5m?=
 =?utf-8?B?ekpUMGFvQll2dzVoU2VWSzB1aW5FZ0J0TnptdGJsMTlycnZ6ZXNMQTZHQkJC?=
 =?utf-8?B?L2JsN20wdmVjV20ycHE3QXY1V24xNkFFdi82THpMeXlVcnJZSVRIVEgzN0E1?=
 =?utf-8?B?REwwUFBwQ3lzZVAzQUQ2RjlqSG9pSHkwQmh5MG5RWE1lTU9iNUpQQ29vdml1?=
 =?utf-8?B?dGVWWFE4UDM3QzI3b3lyT043UXM3SzVnRG9UMVd3Z0JzYytlVE14QWk5TitB?=
 =?utf-8?B?SkZ6OWhPR0hpSHFvWlZ6cUR5d0FkUDVmaWpBYWROWmZ2Y1BERTlDOU9UZ0FE?=
 =?utf-8?B?WkNpalgvL0lScnYrOEFyQXdwaEVoakdzTXlOdHRnVVlydExqTzArY2FGbFNF?=
 =?utf-8?B?REVFb1lpbnhwaFU4WEFwRG96eC9UVUpxT2dBeFB4TUtrZnFHeGR1a3NuZUx2?=
 =?utf-8?B?bzZ3bVNyR2pGMWcvOURMUkR0RTlYdUNQY2xWMWk4enVncUtoS0p5a1N0eVlk?=
 =?utf-8?B?SGRVVGNpSE1aWjV4MEppbTQvRU9JY0tnRnEyUTFnQmZURWtoTkw4YThPWHRL?=
 =?utf-8?B?b0kvWTA4ajRCWDRaNVJ1N1VIVEZ0T1RhM0hJN01lN3k3blpndHZKOGNvK0lh?=
 =?utf-8?B?OERyK0xrMkcxaG9GQzZHVXJkeHoyTjBpamtja3dwSk9DQmhzRUZzUWJaeGxT?=
 =?utf-8?B?YzV5MFdSVnJwMGt6VDZzbjNRM1EwczF2TzVxZCtMeDltNlFoWkN4YW1rdnUz?=
 =?utf-8?B?RnloQzZGUGZoZlA5QXBGYjJMNnoxUjBSVHdyK2N6UndqeWR4Y1ZTMzJoUmZw?=
 =?utf-8?B?ckVYMEtZWXhoR1UvcnJ6Z21NeUxFeGF5cFkzNmtFa251OUJMdGlVaGk5cDJU?=
 =?utf-8?B?SCsrdnVSRWRTaWt5YitRcWhNZWlWd1MvanRCeS8raHlzMHpYeU54dU91V29k?=
 =?utf-8?B?TWNFU2pTQ3ZES3Z1L0gwWUlHK0l3aGM3R1dNQVZkcW1mODdsZWZETGhMUzFY?=
 =?utf-8?B?YTlrR0hBdXdMVytTMHAwcHhWZ2tsMURrb0huTks5ZGV2YW5kekp6cUdrb0xR?=
 =?utf-8?B?eGNsamZxZGVRbXlyY2RGQlM4aitqN200RG9Md3cwZkRQUXdqY3lTdWU1T25W?=
 =?utf-8?B?TE9veFdiblh5QWIweG94aUhXNHJJYk9jK1JWS0JFT2NsVmkvd0JlV2d3ZjJt?=
 =?utf-8?B?c2FoT2Nrc1lTZU1YR09HcjJCNkhIK1ljYnJUbGo3MHNKNWc2Z25ZMVJZWGQy?=
 =?utf-8?B?ZS9YZGd4aFRCb3dlRzFuY3BEaGh0clNvZXBkYmNNa3Y2dFV3eks0QlZ3M0hm?=
 =?utf-8?B?VTJGTmZ4SkUxR2dGNWFmZlYwNER3WWhWOXIwRHc1ZXlXNEdhak90VkNwNHFr?=
 =?utf-8?B?RjBFd3lqaksxTi9veU5lSWFTakRxM2wrUGZLL05QLzVTTEVWNlhzemFrTExR?=
 =?utf-8?B?TEpaT05yZjk5Y2VlMnR3ckFrajFUMXZpL04zM29ncTlqSGdrckozWGlvRUV6?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YTU5ZHlydkhXaVNkOVg1djhocWkrTkQ2M3dzNklRYkczaVh2UStrUGRvYmov?=
 =?utf-8?B?UWdySEdYNkZYYWdIbCs3T1BEVFJ3a3htQk5MQ3dFSWprVU9jSHdCbzRieHdp?=
 =?utf-8?B?dFNoRlNBQnhiOU9lb05wS1duYk01NjRvemxqVlh3TG9Sa0NROEE4Kzl1dXcx?=
 =?utf-8?B?dEV4VVBldWczTGJNQ1NydjJuMHVQVXphdUc4dExKMExxUU0yWjVmU1NpV21v?=
 =?utf-8?B?UFRHWmJ5OE1tdDJwdkNtU0tjUElhejQxWXBaTStGbHpUTGtMd2dwTE1sNERm?=
 =?utf-8?B?UFpZVHY5NzVpSjBWcHlPSzliUHFZWllUZWR6cnpmdjNRdUwrTTVxMVRLZU83?=
 =?utf-8?B?RHQyMVkwbWJ5bEg2TmEvd2dtM0M0aFNkUFY5Q1RPaEFzRnRaRTdJZm5Ycjl0?=
 =?utf-8?B?bVN2MHdnOGRPZmNCT0xBMEdVWDV1aTY2MktNRTEwMmllMk5OY0draVpoRGFU?=
 =?utf-8?B?bUhFN1c5em1DWTFySUdqSzk4N3hvaFJURzBKMXZlOXpobHkxNFBrcDJ6dXA3?=
 =?utf-8?B?WUN5d24vRzlUZzZtOU96dVZQTE5tc0E4N05HQXBSNjM3Z2JXL08zQUJVcXRU?=
 =?utf-8?B?eWZCRzY2Y0hVZ1BkZWpkdkpFeHVMY0dJVngxMDRwZEZSVlhqWitubkREYXdZ?=
 =?utf-8?B?TGpIczhXUVFXb293NXhNaHZnMEtrR1hwZUVZWjhYQ1FwUDdoTU5yZDhRaUJ0?=
 =?utf-8?B?SDVHUVl6clVnYk9Sa0pXY2tCbytFNm1YNlRsZk1BcmRsU0VaNjlLdDBrSFFC?=
 =?utf-8?B?Y05tWmxDamwrZTk0Sld4SExMVWdVY1g0ZXFmWkpwUFhGTjljaEE5NTVjTmxq?=
 =?utf-8?B?SzBZVzIra2UrKzBUbWp5OFF3eWtvSWE0UmMzempxTUpQUER1Z2liaWtZVkhu?=
 =?utf-8?B?bHM3QXg4L2hScG85ZThlYmQxcEZMM3RHRUt6dGN6ZHlBZ09remQ2WTZkUFlr?=
 =?utf-8?B?K1NjTjRCa0x6ZXRyVE5aNytWWDg2LzJtQWw3ZkVGWGhMc1JoMWU5Y3JTdWxT?=
 =?utf-8?B?WXl1QndWZEhiMlYzTk5TdWpnN21MYUhJWXp5djBJakIvUmtnRjlTOFFaTERL?=
 =?utf-8?B?eE5Kb0Ryb2FaaTA4Y240R01QYkxJbC9zWGM3VVUrK0JDRnpYVUI1Q3R5eWxj?=
 =?utf-8?B?bVJ3a0QwM2hOaUo5SlZmNGc1ZmV3RkpUMGdneHNWSXI1M3MrTzRjNXVJbmFm?=
 =?utf-8?B?dzFDYlNSMWtvNU1QWENmUHpGaThSaDVjZ0NUR0k4blN4WTQzejkxOCtzUTYz?=
 =?utf-8?B?UWVUb1hGWSsvOW1qTkxDMVhyczRUZkhpU1EyYUpKOTZDbi9vWUZnM091Yjh2?=
 =?utf-8?B?cDJhY0VZc3RSUDFPMEtVeDZFMjkwT1UxV3M1YzVVZGVJUjVXYW1BZWV5L1Rj?=
 =?utf-8?B?anQ4QmNjVkM4anplbEpjbzNyVGlQYmR5RE96KytoQUVjRk5TSWJGOFhpMjNp?=
 =?utf-8?Q?v5CCNzOu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ce767aa-9241-4974-7a98-08dbd19e72b9
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2023 18:57:46.5308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B7x97uktQHT58DD0BS0mibI9/0M4Ap1jC583RW8+Wx5YsATYt072e0SxibeXY0wXMzftnDqXX+KiE0Kd91/eaNbp60hUaR0hW/VKeTx+KLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7578
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-20_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310200159
X-Proofpoint-GUID: P8tK2BMepg6_C4OAds-GPBXL-fyFPpEL
X-Proofpoint-ORIG-GUID: P8tK2BMepg6_C4OAds-GPBXL-fyFPpEL
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suravee,

On 18/10/2023 21:27, Joao Martins wrote:
> @@ -2379,6 +2407,69 @@ static bool amd_iommu_capable(struct device *dev, enum iommu_cap cap)
>  	return false;
>  }
>  
> +static int amd_iommu_set_dirty_tracking(struct iommu_domain *domain,
> +					bool enable)
> +{
> +	struct protection_domain *pdomain = to_pdomain(domain);
> +	struct dev_table_entry *dev_table;
> +	struct iommu_dev_data *dev_data;
> +	struct amd_iommu *iommu;
> +	unsigned long flags;
> +	u64 pte_root;
> +
> +	spin_lock_irqsave(&pdomain->lock, flags);
> +	if (!(pdomain->dirty_tracking ^ enable)) {
> +		spin_unlock_irqrestore(&pdomain->lock, flags);
> +		return 0;
> +	}
> +
> +	list_for_each_entry(dev_data, &pdomain->dev_list, list) {
> +		iommu = rlookup_amd_iommu(dev_data->dev);
> +		if (!iommu)
> +			continue;
> +
> +		dev_table = get_dev_table(iommu);
> +		pte_root = dev_table[dev_data->devid].data[0];
> +
> +		pte_root = (enable ?
> +			pte_root | DTE_FLAG_HAD : pte_root & ~DTE_FLAG_HAD);
> +
> +		/* Flush device DTE */
> +		dev_table[dev_data->devid].data[0] = pte_root;
> +		device_flush_dte(dev_data);
> +	}
> +
> +	/* Flush IOTLB to mark IOPTE dirty on the next translation(s) */
> +	amd_iommu_domain_flush_tlb_pde(pdomain);
> +	amd_iommu_domain_flush_complete(pdomain);
> +	pdomain->dirty_tracking = enable;
> +	spin_unlock_irqrestore(&pdomain->lock, flags);
> +
> +	return 0;
> +}
> +

I'm adding this snippet below considering some earlier discussion on Intel
driver. This only skips the domain flush when the domain has no devices (or
rlookup didnt give an iommu). Technically this was code that mistakenly deleted
from rfcv1->rfcv2 after your first review, so still retaining your Reviewed-by;
let me know if that's wrong.

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 6b4768ff66e1..c5be76e019bf 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2413,6 +2413,7 @@ static int amd_iommu_set_dirty_tracking(struct
iommu_domain *domain,
        struct protection_domain *pdomain = to_pdomain(domain);
        struct dev_table_entry *dev_table;
        struct iommu_dev_data *dev_data;
+       bool domain_flush = false;
        struct amd_iommu *iommu;
        unsigned long flags;
        u64 pte_root;
@@ -2437,11 +2438,14 @@ static int amd_iommu_set_dirty_tracking(struct
iommu_domain *domain,
                /* Flush device DTE */
                dev_table[dev_data->devid].data[0] = pte_root;
                device_flush_dte(dev_data);
+               domain_flush = true;
        }

        /* Flush IOTLB to mark IOPTE dirty on the next translation(s) */
-       amd_iommu_domain_flush_tlb_pde(pdomain);
-       amd_iommu_domain_flush_complete(pdomain);
+       if (domain_flush) {
+               amd_iommu_domain_flush_tlb_pde(pdomain);
+               amd_iommu_domain_flush_complete(pdomain);
+       }
        pdomain->dirty_tracking = enable;
        spin_unlock_irqrestore(&pdomain->lock, flags);
