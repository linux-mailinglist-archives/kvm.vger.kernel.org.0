Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC285FA69B
	for <lists+kvm@lfdr.de>; Mon, 10 Oct 2022 22:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbiJJUzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 16:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiJJUze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 16:55:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A17D1F2C4
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 13:55:33 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29AJXlh6032036;
        Mon, 10 Oct 2022 20:55:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jBS2aQ5W5Y9YH8crlXT+IvqxsGLia90T/Ye8FWQxrSI=;
 b=KdlbtXAA/PDL0MV5Runueuyr/tgJGrhsjyVO2HlHTUh2e7fiRAedtusPIN9jV1uz/6lQ
 7au2gIITVjPiq3JUXu6mo4hZ3jDZWJAZyjgQuzPU3CKK4YDZz35HF/SdKKWjKY9qOJTM
 OVnTM8n/qAebIzQs934OQ/mAMSV+GHDzDPUBqjFc73D/MlC+2LBPuS3H4c16WOZKsd29
 o2vrtMSw2qBsZtef2Z/iFU0PGOz++Z4JhTXNpjuAqKGpZpfo/9QQuRHNt3AfecD4GWnU
 ewr8yAVevtKViR9hCesejP3pWJpHXyYFsQ8h4SXXBNDjMmVP9ZgV5jo6p2R05g8mPtS1 0A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k30tt4svv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Oct 2022 20:55:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29AIHFgr003011;
        Mon, 10 Oct 2022 20:54:59 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn30y0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Oct 2022 20:54:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1fOzCEqcRq3sq2/0trb4isteF8ctTZ4z+PZGd59pTTD+d/CSRE7CwCkXTYbuN3W4WmTsX9FObQyiW94mKx6xe4yJ7S9VnhEGqQkQeVlL1jElKc3qYEiJtGzAFe9FXhK8kQ7vvJd7iYiOYXlO+dVpp0LFuiONUNEmUuiHeEO7/RnAVGfkOWaGo68virZ4XDE8yWUgpneokj7wqxmxevqNC6GWf1wcKzaMd37WIcjSgR+XiQAMQVrX5HnwL5MV99UB4KP2+rEFKzecJjjt5ZlaaGiBfz+tX5jWstCwZo1FAHiSRhPVmLKCjdLcRc2mvIS7YHcVy6Z4Nns9sNFuIKpAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBS2aQ5W5Y9YH8crlXT+IvqxsGLia90T/Ye8FWQxrSI=;
 b=Hb6YAy1pRc+ICUvpuFaYxfKS1rpnDnqq5hiqsIrYgVdSH+4NWOGl6LlFGCHGJRgyB8hB4Szqbb7JnnKMUVoaczf9k3wKP4H5Qt+ftU63tH8+qrgFIS+GKBy+2hWDvJ4LS+lioqjjumPQByF2QzemhIGDrxUCZcIcfu7fLacXxoISpuWfIyU7ntjvJaVPsLLx2IFgh0jIwfy1LC/H81zsyo8yAlekrqJ3xyWdmD4GNTgzUqNCxX7iR716eEMEnjx2w0lB6O2cbX6I8DHDXLXo5cUY8ptKzrPUGsjkILNIbjOiLTdzaVe8bQQAVY1GCrLzLhxDdqPEh0xUbvtkaqa6Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jBS2aQ5W5Y9YH8crlXT+IvqxsGLia90T/Ye8FWQxrSI=;
 b=ZTwnDU4QD8xkPDwkBctj2rPox38ZiSAYMWmTFoWWy7NBwvuDYeosRB8g2MKT/weijVcJxgxvoQDNO21SwU4yit9mOqW4uxWaeaxgs/liSYnqDXaMAWsYxV+plg/s/JHoPLf43ETg0SMOU9o2q6kczdTHwCjShQdkshIl7ec/sVs=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by PH0PR10MB4407.namprd10.prod.outlook.com (2603:10b6:510:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 10 Oct
 2022 20:54:56 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::8cbc:1639:7698:1528]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::8cbc:1639:7698:1528%4]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 20:54:56 +0000
Message-ID: <0745238e-a006-0f9c-a7f2-f120e4df3530@oracle.com>
Date:   Mon, 10 Oct 2022 16:54:50 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Laine Stump <laine@redhat.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <2be93527-d71f-9370-2a68-fac0215d4cd4@oracle.com>
 <YyuZwnksf70lj84L@nvidia.com> <Yz777bJZjTyLrHEQ@nvidia.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Yz777bJZjTyLrHEQ@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0160.namprd02.prod.outlook.com
 (2603:10b6:5:332::27) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3240:EE_|PH0PR10MB4407:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b1582fb-d966-4153-01a0-08daab01afb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E6maBCYHaozrF23oExPSzx2Tujvet10xwcWbvInof/kD1DhxQdoAleHHVwmclzBrJsWjZfOSZDWgC7TnqL3RNobcwnUd6/vzlfL1riqihq+hvrSexng+4RCAJiSZnfat/5ToBMU2htu/4ouza6aOyE79GQomOAhNZPaFV0n6wH8Pn5f/EJXCxLrHCcfZ9RSE50710BsTioq836xCDce/QtlhfIBjiRc43Z4gXz/pS5kJqnS7SthPnZ0PwVo3DjnqRYHJGGqxmn3pgNAMkwT3+WGkgvo6jtZOWVczRObl4MRMfe5zxhfjhuJpnDkA8iDEmDTUCOtRaeNrqN9LXPlbD4zGt4FF3gMkx3zXQiEEMfKQK8ugWmc6y7WVytDhz761DpyxnIXD+Hdx5E5bafizTwgqxR1ismUlIqlR+/P3UzQbn/Z5Us2YdwHXbHm+8fKxOW0I2XmEkKvsHwqjRWD7mVsooS+rRAmNhYWrqRtRVhGX2VZ99JpymqHTyvPtoD9B27TPwPHoGoq+gScJKZjIG07CXAQ2AvzcfLa50WxBqbTDap9r5loyRebPSJVWS0pUPREKfaeaoZUuzJRuUiHqWhl+uP8pIguR4VWB6uRecopBBiNB/RsYRaLn4Vis5W/UnP27cYdwRC70eYc/9B3DufaGyatxAgjeZmXnm7YHE8WRlv5m89T52G1VKtk0d5j/YcJhZu5Lbe7Zvw5xtOwJw5nzt54IB6S8aBaBNy7o0GFnIklEsR6wN94gfjkL4lQ7T5ODd6u5PVh8la9NqESVOLVbnExLlZF6ILnFtYb0d1bI4/OblOXJwMY5SeAS8iRqZhDibWO2nAf7saqQ5jzb/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199015)(186003)(2906002)(2616005)(83380400001)(86362001)(36756003)(31696002)(38100700002)(478600001)(316002)(36916002)(54906003)(6916009)(8936002)(31686004)(53546011)(7416002)(26005)(6512007)(5660300002)(6486002)(66946007)(4326008)(8676002)(66476007)(66556008)(44832011)(6506007)(41300700001)(6666004)(41533002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHNvbjlQejZNdEZCWkMyYkVtSHFTMktFVGxQaGlvZUExMll1NVNZZytkVkdX?=
 =?utf-8?B?emlnVUxJWmU1Z1IrYnM4Zk5BeXhTeHY2cUx6NWg5QXYvRzVQU2JHUlhCUEJr?=
 =?utf-8?B?Wkl2VjZINXJjbDhFdU80Wjgvc3dqdHgxek10RWpUN2o5TEZ5bjRpeDJpOFBw?=
 =?utf-8?B?c1BDa0VtQ05CVTBORGxlb0pqWXVsR0JFSTBPeE5SY044dDNyalpjWXFXMWhW?=
 =?utf-8?B?RjdSeExDQUJiMExpQU5uMkp0UUNjdVpVVy8wTUl1MmRZQVN3cWJ5WWoweGww?=
 =?utf-8?B?ZFdsSmtpOWU1cVRzV2VFUWVHN3pZWkwybldZUUgveWRIYTBVWU5OSEJZaVN0?=
 =?utf-8?B?N1NudHNnQXo2aFIvL2ZLdGpPckpvbzFmUlJQUC9uMEZlenBpMXpYeUtUQnFn?=
 =?utf-8?B?WXhlbElERVpncU9KbG4rRzVYQzA4TmdwTjdwWG1IaFFxYVpGMWtnRjNrSnBp?=
 =?utf-8?B?REZYUEFvb2NTa3VjR1haajM3TFJJSlNBdnR4WkR5R2M4dTNjYTB5M1dRaThs?=
 =?utf-8?B?WmF3MGFreVJoTXBGSE1SQ2UvRDdNS1p6OGRpbXlLbnRuUU14S0grc3JndHY0?=
 =?utf-8?B?Y2NVL2dJRUp2U1lXR1dPVEpoSGtOakNDMTJ5UUVYREp0WU8rTE56ZGtiUFU2?=
 =?utf-8?B?UVAyK256WkFXSlUxMmZBTkxnMkRQRDB5dm50bWtXeDc0N1A1Z1ZKY1hsZENa?=
 =?utf-8?B?dFdScjdOSGV1WlIrOVpNZVRvNWwrNmp2a2s2SXh0OVdPUnpTZDYzbjBLa1Ar?=
 =?utf-8?B?M09Zd0NMMmZQS0NzVER4ZTdXRHlXNEJTL1ZVWEd4ajdJaDZQUGIyR0lKdXRs?=
 =?utf-8?B?TmpzL3h0ajhZRlFFSWRXSGk0WDBYMGVnOUI0TGFVUnJUbVp3WnFSSkRMTHZx?=
 =?utf-8?B?N1JjTzNZOVp6ZjlaY0ZEWmhPTEw3eFJqNmRDQlN1Rm9YT1ltUEp3UkRESU9q?=
 =?utf-8?B?THIyeGlqMitOelNBWC9jY2JaN3J0RTZjVmVqVVJpQm0zR2RKcG5RWFJicElS?=
 =?utf-8?B?SDR3WWxDTnhXS21wN2dBSmJid3NLT1ZWQkptZW9VcXF5dlBHdFJLM01DOTR2?=
 =?utf-8?B?RW5yaVJranZGUHQvR1FTb09raW5YWDE2Q2U1MmNpeE1MTnMzb2N6Vys1RW9C?=
 =?utf-8?B?bDZkK0FrRSs5Q2o5SlM4dDZpelhsbXJHUThvcFFMOU8rbExmMm1paUhqMHFU?=
 =?utf-8?B?TXpEbHNPRmRxR1ZXYVpDSzVjcTFUajNuSEVtWk9GWW9oNU96N25Bc2dXVUFI?=
 =?utf-8?B?b3RhMkVxbnRhQkZacnBnTHFNWm9XOFdRTU9VUjRjbG5jcTFWcFM4eXd0bXMz?=
 =?utf-8?B?RXBRWU03TmxabTZ3dU8zWjRCeGxVaGs5eW1jaHNHbXorbE5DWEpSZ3JhRWlr?=
 =?utf-8?B?YUh3U3ArZCtPM09Hd0pObktFS3FzTkU2WmZXRzNTL28vOEdRNGdtS29SaHRH?=
 =?utf-8?B?MC9JQ1YyVVVsdzhiT3ZqRURIZ0xLdUdnYjA0bDZUcStML2JIbnlZdTNxd2V2?=
 =?utf-8?B?dFY5WnFxdVYwdlUweERTT010bHk5TEZWRWliK012eUpyQjc5VkdobkVtV01j?=
 =?utf-8?B?UytwTUVQR2JHWWcza2oycWdVUkh1Q1lpQVduT2x3UndVMEE4RkwrQ1lEc01y?=
 =?utf-8?B?cGFEc214YUJsQk1tWnhvbThRajV0NUt1NTB0RmoydnJ5L2g3MXh3S3hrUC9E?=
 =?utf-8?B?UzBXMXkyeFNtRGJ5cmxUQ05JM1RzRUNTdUtuRDA0WDFrV29nUlVoRW1Uc29V?=
 =?utf-8?B?RDZmL0RjeVljY1FQdXJjTzBBMUhIZkYxZVJkcjQyb25LVDNMNkJLRFpPbUZq?=
 =?utf-8?B?NjZIbERURWtRdFNSVkljVTNLcERxbzdBYUxnRjBmYkFVa21DaUNia1AzWGpr?=
 =?utf-8?B?amFhYlUxUlRVb3RZWFBUMGlQVkxadFduK3JCSWZLOWlXdXhxVFg4RnAyOVNZ?=
 =?utf-8?B?aWdNdFJKN080ODZBZjFkZE45bnk5K0lqUVFhVHZTQ0d2SVNic1pxNm1SK1lZ?=
 =?utf-8?B?ZTIyOFByUFUwWjMrYlhzb1g5V3BzdkJqZFlHcTkrR1MzVGhIWHJkOVhaVTlU?=
 =?utf-8?B?aUVZcm92TjU0c25EYk1jUWxHdjdUY3QvSy9Cb1pDNTdqL2lJSWY2ZEJVZC9F?=
 =?utf-8?B?K1lTOE9EbW8zeDZrZ3Q3RkJlY3ZiQkJvTFdBa0NCcFZoaHpoMDBVS2pDbkJ6?=
 =?utf-8?B?akE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b1582fb-d966-4153-01a0-08daab01afb3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 20:54:56.2094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EZl9a5u3uW2wBEDp9JWGpEf6lKE0is8csZ9Nfg1MPyeKXLunUlDiH8pWAqKvb5hj/C9lRzKMqhsYWfGRACdqfKJUkGQFFgmnd4XATMaVszQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4407
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-10_12,2022-10-10_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210100124
X-Proofpoint-GUID: 912s96sp8nj59LcmAVd_AWBCTftWLRrd
X-Proofpoint-ORIG-GUID: 912s96sp8nj59LcmAVd_AWBCTftWLRrd
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/6/2022 12:01 PM, Jason Gunthorpe wrote:
> On Wed, Sep 21, 2022 at 08:09:54PM -0300, Jason Gunthorpe wrote:
>> On Wed, Sep 21, 2022 at 03:30:55PM -0400, Steven Sistare wrote:
>>
>>>> If Steve wants to keep it then someone needs to fix the deadlock in
>>>> the vfio implementation before any userspace starts to appear. 
>>>
>>> The only VFIO_DMA_UNMAP_FLAG_VADDR issue I am aware of is broken pinned accounting
>>> across exec, which can result in mm->locked_vm becoming negative. I have several 
>>> fixes, but none result in limits being reached at exactly the same time as before --
>>> the same general issue being discussed for iommufd.  I am still thinking about it.
>>
>> Oh, yeah, I noticed this was all busted up too.
>>
>>> I am not aware of a deadlock problem.  Please elaborate or point me to an
>>> email thread.
>>
>> VFIO_DMA_UNMAP_FLAG_VADDR open codes a lock in the kernel where
>> userspace can tigger the lock to be taken and then returns to
>> userspace with the lock held.
>>
>> Any scenario where a kernel thread hits that open-coded lock and then
>> userspace does-the-wrong-thing will deadlock the kernel.
>>
>> For instance consider a mdev driver. We assert
>> VFIO_DMA_UNMAP_FLAG_VADDR, the mdev driver does a DMA in a workqueue
>> and becomes blocked on the now locked lock. Userspace then tries to
>> close the device FD.
>>
>> FD closure will trigger device close and the VFIO core code
>> requirement is that mdev driver device teardown must halt all
>> concurrent threads touching vfio_device. Thus the mdev will try to
>> fence its workqeue and then deadlock - unable to flush/cancel a work
>> that is currently blocked on a lock held by userspace that will never
>> be unlocked.
>>
>> This is just the first scenario that comes to mind. The approach to
>> give userspace control of a lock that kernel threads can become
>> blocked on is so completely sketchy it is a complete no-go in my
>> opinion. If I had seen it when it was posted I would have hard NAK'd
>> it.
>>
>> My "full" solution in mind for iommufd is to pin all the memory upon
>> VFIO_DMA_UNMAP_FLAG_VADDR, so we can continue satisfy DMA requests
>> while the mm_struct is not available. But IMHO this is basically
>> useless for any actual user of mdevs.
>>
>> The other option is to just exclude mdevs and fail the
>> VFIO_DMA_UNMAP_FLAG_VADDR if any are present, then prevent them from
>> becoming present while it is asserted. In this way we don't need to do
>> anything beyond a simple check as the iommu_domain is already fully
>> populated and pinned.
> 
> Do we have a solution to this?
> 
> If not I would like to make a patch removing VFIO_DMA_UNMAP_FLAG_VADDR
> 
> Aside from the approach to use the FD, another idea is to just use
> fork.
> 
> qemu would do something like
> 
>  .. stop all container ioctl activity ..
>  fork()
>     ioctl(CHANGE_MM) // switch all maps to this mm
>     .. signal parent.. 
>     .. wait parent..
>     exit(0)
>  .. wait child ..
>  exec()
>  ioctl(CHANGE_MM) // switch all maps to this mm
>  ..signal child..
>  waitpid(childpid)
> 
> This way the kernel is never left without a page provider for the
> maps, the dummy mm_struct belonging to the fork will serve that role
> for the gap.
> 
> And the above is only required if we have mdevs, so we could imagine
> userspace optimizing it away for, eg vfio-pci only cases.
> 
> It is not as efficient as using a FD backing, but this is super easy
> to implement in the kernel.

I propose to avoid deadlock for mediated devices as follows.  Currently, an
mdev calling vfio_pin_pages blocks in vfio_wait while VFIO_DMA_UNMAP_FLAG_VADDR
is asserted.

  * In vfio_wait, I will maintain a list of waiters, each list element
    consisting of (task, mdev, close_flag=false).

  * When the vfio device descriptor is closed, vfio_device_fops_release
    will notify the vfio_iommu driver, which will find the mdev on the waiters
    list, set elem->close_flag=true, and call wake_up_process for the task.

  * The task will wake in vfio_wait, see close_flag=true, and return EFAULT
    to the mdev caller.

This requires a little new plumbing.  I will work out the details, but if you
see a problem with the overall approach, please let me know.

- Steve
