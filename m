Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADBD7D40AB
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 22:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjJWUQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 16:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjJWUQM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 16:16:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D181A4
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 13:16:10 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39NK8Mpt025435;
        Mon, 23 Oct 2023 20:15:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ElNpz2CDdx8/dK/t97l21qLKLnY7nYUz0MNcWSpkXhA=;
 b=DUFZWqZrBRqrssUZIO1UxWo/YR8ef6Ow47VkQ7QCgN+01gSgH8q8ABfTwXoBi2X0cAhT
 xm7mh3HdXRCn1rEUh04bNoL+TjCagPe1RXGaOimhwcu5Z+q3UsTPIqYTkOZ2oqU8GIhQ
 oVakXGZ7BuxtQr8JpXrO6AYtL4hrb074QiTIFt9hhCCzeZsZP3oIkiomBA7oZmymhMtQ
 B8uicxH7SadUVHhpJZjcmCEYkM4WY5faHVcjYvBxhLXkrCAa3t5mNdVrMnVGqSfX9P9l
 QOAdXpNGMwyY6LwsKanFpkoVd1Iu5IyhYxErGuAgsQvffewFPSQel04VoOUXRIUsYOTV rA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv68tc17h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 20:15:45 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39NK2DXC014193;
        Mon, 23 Oct 2023 20:15:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tvbfhqt33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Oct 2023 20:15:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnlnhMDIpV42Sq+z6PPCbpNGcp1CditM7jIAfcY3u370Ji0ZBvY1Z8vnGDJc7duI5esLnktkRyceUTgPgsOlizyldFI+nDrnzBWBhHoHlHmX3wy9gZqCxI8HJ+rGxpayhqbT6H9Lzs8LH5p6DDjK5/28bXB3I0HPRq+sZjmgcat77VkE0j28c3v0LvOmGG4nSbySq5ugHNClD+xsDshcWKhCSaPA+x54NHpJDSOcI73N7je3cNIDBH0iKn1ko7wV9c6f+VToiny5m7uF3BajMmO9Z+cQWVRISY04KKoQEcEmmY/eBoAXpLxvbLFNzUx/CaHH1EQ29TCsAL35vSQi+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElNpz2CDdx8/dK/t97l21qLKLnY7nYUz0MNcWSpkXhA=;
 b=NtMjXqFH8VOowzr+KZojh0i6LvOllJe69SakMPK/k+xS3+c4iTRIbCAMf6faCCeOXYoo/gvVJfO3z7lrwSfn3GGeuVXuF5KpVY4lH+pyDyjTIuM/dKDnWFmCtr4sLMG0C3Tb5OzB1Ie3Ch0IeBPr1gunyyEkmJuWGbny8QdYQQbYc+IrNRGjPTqvHbQ7cU1Rsn8Tj6JWude5Q7Z2G5sIIwKZC25W3UiwdtpJTQAkFE9Lq79CZQ1Yxy2FweVJid2C9k+Yz2rkSz/a86uDfTmQs1h7/U8Mx7MdmuMXjCZp1cILu+R1iOQXkTey7ljII1UM6ATYmXZvREZN+vCItB+nTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElNpz2CDdx8/dK/t97l21qLKLnY7nYUz0MNcWSpkXhA=;
 b=urlFOU/XDJoyikGebOq6E1h/xEbYdhGuebyEwaHcwoDrSnWi30I33kvnkC9P3clnkcHyqXYg3zjtPkJUdPzz6evYlVN7wO+Ry5pNraAfQ/gNsg1HSgqqlJDOxxPOixeIlYWRLOexgJRI87BNdca7e+H5GHCgY8f8D3dBMOukuBo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA2PR10MB4588.namprd10.prod.outlook.com (2603:10b6:806:f8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Mon, 23 Oct
 2023 20:15:37 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::c8c3:56ba:38d5:21ac%3]) with mapi id 15.20.6907.032; Mon, 23 Oct 2023
 20:15:37 +0000
Message-ID: <0a641e15-a6e4-4113-932d-ba2caa236653@oracle.com>
Date:   Mon, 23 Oct 2023 21:15:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 16/18] iommufd/selftest: Test
 IOMMU_HWPT_GET_DIRTY_BITMAP
Content-Language: en-US
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     iommu@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231020222804.21850-17-joao.m.martins@oracle.com>
 <ZTbSx9mDWf7QwgjF@Asurada-Nvidia>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZTbSx9mDWf7QwgjF@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P265CA0003.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::10) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SA2PR10MB4588:EE_
X-MS-Office365-Filtering-Correlation-Id: 64720538-eec6-4c45-4517-08dbd404d1e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5h+YCeCKZRZOjv7PahH8k37pHJZFu+PYlE5yMRJgabBASUHWRlrWNjxPrauw1zk5RTIxS5i8WYppn3DMctJCm05bVgTWsfgVYs9Ir5aaw/LR4NgF9GOCzILJf1q1tet5Jw1EMMwyZ7eHAViBGVYLvyzBVuWDQKs4J/irW3dCn8BM0xBdHfAfSlpxdARo6iMp3PCfOVS3T5TjmYdA2/LlYrBif8LkfXoDqgsQJ0cv1D64aZ74kNygky6ELseThrciAXxQCkFKiJUPlQdfnEpEUbw10IpW2/WbsqOJMmbZzVWL6rITtYATOHbPDNjKEZa4WwcEBT5racGbmPv5ky/joaJCxtjWFLhLQWzDOq8h+iQ0rC21dknpcBAr9OEGVdkV/4DNuynEE1ua0T2dsfQORDp2pdxpJzbegF5nG+y2EkzXpk+Rg/1ngqOFvQME7tZEY+lphAJj3yD3w50PS/7/QNedqFeUwWLSJwUDe7Hv2GF8P7k1kRMN51eMkTzD3A+2i4qoUgDAncbB/eZ1NlHEojXBe5ppi3ozNQeLfPCKkL39a17P6jS2voCMfhcYA356sg5qlAxhVwLxortsgLUQAVVCPVo8ij9oxS7XMFOkpL3/DqcnOOwSC5+bdS9OiXefEfZMdDvvihAwGi3RrUif3alMlzNxVH6XgaYOEfd3WNM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(366004)(376002)(136003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(8936002)(36756003)(66556008)(54906003)(8676002)(316002)(4326008)(5660300002)(41300700001)(66476007)(6916009)(66946007)(2906002)(7416002)(31696002)(86362001)(31686004)(6486002)(478600001)(26005)(6506007)(38100700002)(6666004)(53546011)(6512007)(2616005)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2tTVE5PUjFMcUFvaUp0MG83K1lwYjFrRjVNempiY05oQUJ4QWpnMFArWFFp?=
 =?utf-8?B?QXgrbmlYeVE5TGtldFlseWFlTjlOSlhUeTR4by9Tb1kzd0RkQjZMTU1mdi8v?=
 =?utf-8?B?d0xPT0RtUC9rNFYwdnlmSDZkN2ZzVXpkdTU0NlVLNEx4eU42T0VlM0lNRmVL?=
 =?utf-8?B?UWxmK2xwY3E3RTNGckdWTG9sL1BvUWpYb1dyWUNWeE9MMU9nZUE3N21Ud04v?=
 =?utf-8?B?SDNXaVM4NHZzWU0rZlFhWXpqcWRhbGlKbWVwTXA3N1FQdHd4Y1JmVzVkWU1E?=
 =?utf-8?B?WWIyaTFQcXZrcndYaVo0Nkk0U25paC95OEoxblkwWlNrZStjYnZMSlQzM3Ux?=
 =?utf-8?B?R1M5Q3VxTEtBL212QlNYWiszSnI4QzJGaVdjd3MwWTY1eXR5WXJrek5pYzZq?=
 =?utf-8?B?VmJuMzg0QnZvU2Q1b2xsZmNwYUd0ekVOaTBjVmJBUGptekhtY0ZrRmNFRzdo?=
 =?utf-8?B?NGNYQmNrNG00Tk13aEtQUERZYmM3OEVDa3Z3QnJEQllaWElGdHVLbGd1aXVX?=
 =?utf-8?B?YTVaVlM4THFPZ09jdVFnamFQUFhKZ0p4WlZTTVlQNHEzVjRPTWIvc0ZvMit0?=
 =?utf-8?B?UlNIOHkyTHBKMmE1em5JaWJNVUJqMURZTmNrMnpBTC9PS0dIS3JMTlZkVFp1?=
 =?utf-8?B?T2hZWnUwOXlERkdZeThOY3VEazZGSHRVc2trZXJuRWJLenYyRVFXNTdldXY1?=
 =?utf-8?B?dDdoUkxkZllMSTFncEpEczBOOEJjOGpwY0xXZlhLdHVhUXVzSHB2Wmp3Z045?=
 =?utf-8?B?dktscTBnTnNyemxvNHdzUTVIODgxSHVaZnM1cno0OWdIM0ZzTEx6MjRheU4z?=
 =?utf-8?B?aEFUeUZBY1NoVWxzcXQwcVFWU1g5UHlxaGpLRXlVN01mUTFXM2VyazNsekVz?=
 =?utf-8?B?L3VWQUVaaXFZK0RZY1BSQk1vZHRacXRpN1hLNTZkZUJKcEg4a0ZNU3VpMlAy?=
 =?utf-8?B?eVg2bm9MQkhMNUhVSlBEVnFnb3NKc1hBVmllZFlFbUhWZ2pDTXdtbWpDOVY2?=
 =?utf-8?B?TFA1dTQ2Tk5BeFhLUW1FMGtLMGRHK08zOE5mRTh5Y2FKdDhuclBFZEFtdjZh?=
 =?utf-8?B?cWdibXZ5WFd0c3NTdjBjZTNJb2RTNUorQVBMQzR5b0piL3ZwQXdROWV4SHdk?=
 =?utf-8?B?WjZxb1BJV1dRWmVRMEFKblVVRkkyZlgrb2R2QkJ4V3cxYlRXNnA1dFFRZlcy?=
 =?utf-8?B?Q2FudUF2R3R3V21nQUtNRHlqc1JhbmU5emRZdjNvS1VmT3dMVFFlNVpYbjlK?=
 =?utf-8?B?cGR5S2lDWEJ2ZVFZa2VxZ2pyU2tvTFJpNFc2SU90L2lEZXVpN0dHSjZzSFhh?=
 =?utf-8?B?RVkyMHBoQkEwTS95bEpZMFc1bktaRU91a2VMaGk5TUhBVkNBT3V4WWhCMEth?=
 =?utf-8?B?MEJwU3RaeGdxMnM5TU9pdGJRMDY4YXhDcjIyY3YxM0tQSWpRS2s4dURlaytJ?=
 =?utf-8?B?bU1vZmF0MklFVmc2cnEycHdFWERHWjY1SE9FaEdaOTE4ZFR1bkVWbjl5aG1X?=
 =?utf-8?B?enl0endNNm9kSERMeGkvTjAxK0RjRktlS05IOXFrd041dTVOT3hLR1NxQW1q?=
 =?utf-8?B?cHQ5UVh4TGZkZTBYUS9yTnJsQVRueFkrMkxZN0VSelVnOFh4K3NKVDVPQk9N?=
 =?utf-8?B?WDErV3doTWJqZHBwUHlwdytuN3BqTi9LeG9tYnoreUxyZjB1T2pGMGNqNEhV?=
 =?utf-8?B?VGZxUloxeGJkclZhTEl1dE11QVh1djdUb09UdGVvUWVlaERGL2Vvd0VUdWRE?=
 =?utf-8?B?TjBxUW5DRk9XZWU4R01IVnhMNFl3TllQeFJRV3Fyb3BOK0JhcHk2SGNiWTMy?=
 =?utf-8?B?T1kzQ0RsNGtSd2xJbU5kRGxjVHNmb3lYVGM4Ym54cS9ObjdxSDZBTkNkczRU?=
 =?utf-8?B?WkpIV25Fc0NwemNzeUw5R21yWFp5dmYwUUlnKzBKdmRRMDZ5dGdxMk5hT1Nw?=
 =?utf-8?B?M3JRTEZiamZwWHI3WlJJOC9aL0JHQjFmV2FoMmdMbmIrSEZ2TTFZYm1BOG51?=
 =?utf-8?B?aHZ1N1JwQ3RDbEgvVXE3aFQ1RkZ2bGVMK01keDllbHVGZGF6b0RGblo0TVBl?=
 =?utf-8?B?THdBWm9kdDMrVFE2eHA1ZVd3SmhsSmlIOVFmL3lSd1RidmsyM2VYcm1JTFQ3?=
 =?utf-8?B?NFI5R29QaXFRUkFZUDQyYXlMbHp1TGdYQTRqV3NoNUJpNFVYcUgrUjdpSHRN?=
 =?utf-8?B?cEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MU5WY0NlUTZzVUYzSE51N01Dd0FKL1RSaHBhSTJ0UnZPU0VIajlocG5ERVVq?=
 =?utf-8?B?NysvOExNSGh3blpmRWJqaHNtRVRBeDhscTdJR3lqdEcxVUpGbzFYYllJUDJE?=
 =?utf-8?B?QkFuQ3FOb1NrZWxtYmI3QjZnMDJSQTBpMWE0R3pvb2hIZGhub0VPTjBheTVt?=
 =?utf-8?B?R1N6cjZnL3dqOFo3c1F3TGEyVDBOc1lzTi9kNGdiclY3eEdyelpNYllCMjU1?=
 =?utf-8?B?M2VtclFmWnJWRGUrOVFWSG1UVmIrS0JiSTZNeDMzMk9ZOTkzZVlXRmZRazdz?=
 =?utf-8?B?VVhSV25Kd1NlWmN2YTVSdGpsbWZKdldSWWpUSXRmZWVSdk8vQ1lDbVovYU1S?=
 =?utf-8?B?WXFicVo4aFJ0U1Fud0w4cUt3aEZNaFdIN2JUZ0Z3NXBkQ1BkRklsK3Q0MENm?=
 =?utf-8?B?ZEtFNXdzNXRxMW4wbHc3WFBGb3RGbXpDcHJSSVFLRGY3OG8vSmdMVFNkS0Zq?=
 =?utf-8?B?b3pPM1VHcXg2SUNPZ1l4Z1pLcGVBSEJ0R3lZcGQzTzZSaW5UUG5BZmYwS0hS?=
 =?utf-8?B?enB3NHNUNWljVmc0TURWVE9xeXl6U2lTbVRGdXBkZ09ENGkwZzB2blp0aGor?=
 =?utf-8?B?bDJBeEI5UUxwL3lGRFg3QldTVWU2eWlnakt3VkJMaXVEMTlleGJhMDdXSkFx?=
 =?utf-8?B?L2pOZVNSekhSK0FHSmtiRzgrTm9kTEVtUTRuYklZdHMrRHpyVjBHTWVtTllo?=
 =?utf-8?B?eEZnaHZ5bGp5KzB2VmhhQjVzdVlQUXlvM3lvRWpGTCtXUzAweEhpcHlpcytX?=
 =?utf-8?B?MEZrRG9aK2diTllGTGpDVk81VGFGd1U2RW9BNmxuZWZLa1JIZWsyZTcwYUtq?=
 =?utf-8?B?emJiUnN2YTB5bk9sdEVYNFV4eU5BLzN3NmRScjloeWcxcWNyQW9nbUdiSjA1?=
 =?utf-8?B?ZG5WQ1pvNEc5L2ZkRkhKdFRGYlBmTk5aRGJNRFhMS3dWWlpTWGNLQXVVdUJ0?=
 =?utf-8?B?NWpIblRyQ1B2em1HUDZ2Ymh4QnNiaEJHd3puQjRUVnNlZVdoL1hNVVJqNm14?=
 =?utf-8?B?ZmtWSmZjWXdsbXMzeHBEUkdUNkNzdmtSZUxGZFIzZ25kZ21IZ1NOT2lTZGxu?=
 =?utf-8?B?eVptU2hSVTlMNDNzQW5XRVZ3THBxRFovT1FxVld4bXExR3h5YnAzU3ozU1ZG?=
 =?utf-8?B?RFdqVW1XR1dQRTFETmtRZU5USWwxSWZTb2dtVExESkplKzNkakxlNW1JVkt2?=
 =?utf-8?B?bkhuaXp2bDhZTks3NGVMdXcrMHVNMk9rOCt5R1FCcVQ1N21HQ3hUNEZ5T1R6?=
 =?utf-8?B?U2tpQTJjWmo0QTRCT211eDIyK3F3bkRrL0ZQSGV3TEx0NlRMZ0J1YVVlWHNL?=
 =?utf-8?B?NmxOdFdsNlhIOTNmYjMvc1NJVDl5SG8yRmdBREhLR0NGK2lsUzg1YWh0YVZB?=
 =?utf-8?B?RDBzQ2w3V3ZKK3JpdGZITGEzN0tXK0RCWjgyaG8yaUx6V1kzSUJzNmQwZXZZ?=
 =?utf-8?Q?Cy3MzAeS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64720538-eec6-4c45-4517-08dbd404d1e4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 20:15:37.1140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kF1z2M3Hs/OjRz1P1W5KmHeQ3bBHJso/W4t9z88Be8ZYtn8QDObf/oG4AMLGKphSe7kgMARxB9qx62v9ls8QfU0ekOOtJmD3dKgIPmW4s4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4588
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-23_19,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=989 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310230177
X-Proofpoint-ORIG-GUID: YCGf0u_6QirXSm55uWaf19-7fHQSUJ3h
X-Proofpoint-GUID: YCGf0u_6QirXSm55uWaf19-7fHQSUJ3h
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/10/2023 21:08, Nicolin Chen wrote:
> On Fri, Oct 20, 2023 at 11:28:02PM +0100, Joao Martins wrote:
>  
>> +static int iommufd_test_dirty(struct iommufd_ucmd *ucmd,
>> +                             unsigned int mockpt_id, unsigned long iova,
>> +                             size_t length, unsigned long page_size,
>> +                             void __user *uptr, u32 flags)
>> +{
>> +       unsigned long i, max = length / page_size;
>> +       struct iommu_test_cmd *cmd = ucmd->cmd;
>> +       struct iommufd_hw_pagetable *hwpt;
>> +       struct mock_iommu_domain *mock;
>> +       int rc, count = 0;
>> +
>> +       if (iova % page_size || length % page_size ||
>> +           (uintptr_t)uptr % page_size)
>> +               return -EINVAL;
>> +
>> +       hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
>> +       if (IS_ERR(hwpt))
>> +               return PTR_ERR(hwpt);
>> +
>> +       if (!(mock->flags & MOCK_DIRTY_TRACK)) {
>> +               rc = -EINVAL;
>> +               goto out_put;
>> +       }
>> +
>> +       for (i = 0; i < max; i++) {
>> +               unsigned long cur = iova + i * page_size;
>> +               void *ent, *old;
>> +
>> +               if (!test_bit(i, (unsigned long *) uptr))
>> +                       continue;
> 
> Is it okay to test_bit on a user pointer/page? Should we call
> get_user_pages or so?
> 
Arggh, let me fix that.

This is where it is failing the selftest for you?

If so, I should paste a snippet for you to test.
