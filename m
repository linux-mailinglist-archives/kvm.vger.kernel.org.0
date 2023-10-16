Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7DE17CB090
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbjJPQz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234404AbjJPQzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:55:37 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6338695
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 09:25:49 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GCd8qd019507;
        Mon, 16 Oct 2023 16:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=7/1aOsVF8d3SzlBueK96WXKVLQxFhSqMQT1tPNjaLGQ=;
 b=LHYSzUpSv+OetTvB446O/kS5MgQ8Ifk2N6HefTM3ptJMAK7DET1P9uQDPkdozufZaLVa
 /qysXmJk0USI4nAEPoUvZSAjkFiJSi1eKRp3y02p5gZd4mRiQ8CNi4pisbll27hLJcal
 3I/UZFNHURo1AbPM0clByCElrIFCQcs2p73d5o4EDAaJt1zhy4g7CWP4rgM7Z2oRM8/z
 jUOyLB6lio/sXKza2DU/LMD6uUZSIeKjD3JW8ks6F5A3rwxjJ/5Z2mLBsXz+8TDnXSzd
 uVN7bSqsoGbZr+QrBMJMKGPzjtIlTLwKjib+dGIjn74sMGd3yLl5hP1tmsIcFw3f7h/4 6Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1bk664-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 16:25:25 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GFEBwg021681;
        Mon, 16 Oct 2023 16:25:24 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg4ytym7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 16:25:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3CyNy64Y/3R64AZgzVWy5fDICGhZsLm66vKByokRIdc6SCZ8AAwtrNzpOgdWlyvHKpTaLYcrKDf44Bv16lwFbwPKfxSdUiGsVPnfnfUP9mACVeAo+khvlwgKEKXl0YA0qo0WvriofdPCGTnfe7XPBB8/Oj9Rmk4ZwvfDLX6mnw68F5+wFZvKf5Xe8dTpe47jRMMq06R05BAQPoPjs6pO/TEtyQyQkCZqbPe41xHpSh5puNaezThphhdW4FTJhqGWVPCw8Lrxr5oOwfd8jyvGZ39WUjHFU77qdLuGCriAXYETnk+qNAR2Ui0Xbip5qKujGoXeBbA7hhaX9HRrApL3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7/1aOsVF8d3SzlBueK96WXKVLQxFhSqMQT1tPNjaLGQ=;
 b=Tck/ZLkSszpU9RKhEu50oZcC3TqFSFnfzhZR3g4Fq6RhDkF+btFvNd9T7P7/pK+AR50mw+ZQIbnbAFwOO5CDXH8+8kB0evE5rPlcuRu3iLn0+mCcNoWHjcZGtKnVu/PtimQfbKHLFToSysqewnYJDv6w0QGR5L0byic5BwfcSPx6jqWC8b9r8TWEfjre6rHpe4L9aW9mFhdAbOmfiPoVUvGKIj3HHmt7TeMLoQOhMC6vqkJVNmc83EJgwkXu1uWh+sEXkfsjP7bsLB0NNZr3WomOsWh0BNVbVAd4R1F3UK2esVCW7nd4IIYC8OIVAa+V48+95VmzPHcSFTf5161uWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/1aOsVF8d3SzlBueK96WXKVLQxFhSqMQT1tPNjaLGQ=;
 b=kmAQaVZpIZ6fuE/uojMO0bjGRI5UD2LvKiMc9I0+FQizKxg3CSe7ZXqJyBKGPc+jSLrgN326JRGQgWZYq0qtWMcgBIruCwxvn7d04MMdMvszL96qPBf4qi6DZO6IzgEj7CZnFNlFkVwp8zRoVxi3dZxPFryn2BfGn8LpDejYhxk=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4914.namprd10.prod.outlook.com (2603:10b6:208:30d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Mon, 16 Oct
 2023 16:25:22 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 16:25:22 +0000
Message-ID: <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
Date:   Mon, 16 Oct 2023 17:25:16 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-3-joao.m.martins@oracle.com>
 <20231013154821.GX3952@nvidia.com>
 <8a70e930-b0ef-4495-9c02-8235bf025f05@oracle.com>
 <11453aad-5263-4cd2-ac03-97d85b06b68d@oracle.com>
 <20231013171628.GI3952@nvidia.com>
 <77579409-c318-4bba-8503-637f4653c220@oracle.com>
 <20231013144116.32c2c101.alex.williamson@redhat.com>
 <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
 <20231013155134.6180386e.alex.williamson@redhat.com>
 <20231014000220.GK3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231014000220.GK3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0083.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::24) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BLAPR10MB4914:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f0e0890-cd76-4ccb-ac42-08dbce647e39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GVQorKXjZbQhFogNsYBzAyiRcy3xBujKZFSRrH4Dp2HnNOrGT8L79b3gmhBVV1vHPbKRIMCItaasRynEY1XmPWkI9sBk7PA1ygLz9t7twf7Qk678LQbNWcGQY+PeMnnHVI95gXIXiY7ND6UCDxCculwF9h7j/pZ4jbXHuogbfTB/pkbv0+zXF3ToX9la4qHnaq8y36D9LLVxwn3BBZ216iYBdLDhfDdeh4zYThykb1HQpVjNhcKa3aQHtWkfC2LtgGruK0j6lJ4CL1PZYRA5M0K3yM5ZM33be/ww9Gfd2NYBVQjRyByQhuE5CNk17VtUEUJ/Es55fZN0ShUDJv793UnPx/rCZennOF6MtEqlIgLYo9gPjXT4Lvhc1A5Izd9VMdoX5AEVPPZkpknXAHUtcQbaOCQYUQ2MKAXczHl+7tlj2bdsCRgIKSTg+HqnMJcbMK9KUo6LySRc6FWwKjgdonWCZJWyRBxAyg8aUPbyOwvp6pRxoHEBMZHz6+vslw7yk7gKKCfdOvl0c6Xol2/qvOxxKDz/w/TqvKjD5IHlRta+aHXW3qztTnmPM5ijlrqC4A7yQ9GRfVvWBEP6ywKcc3um1SLd5YG2CPrXfqrAi3222aXOUVmeR3XcS14wAD00ba8ghgRVE6roLzwsV2g14Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(396003)(346002)(39860400002)(136003)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(53546011)(83380400001)(26005)(110136005)(5660300002)(41300700001)(4326008)(8936002)(8676002)(2616005)(36756003)(86362001)(31696002)(31686004)(6486002)(2906002)(478600001)(316002)(7416002)(66556008)(54906003)(66946007)(66476007)(6506007)(6512007)(6666004)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEZTMGZqV1dTQ1F6ZExtWEFORWZsdlpLU25mbDJOaUovNkVDL2J3bFVQL3Jo?=
 =?utf-8?B?NFE3Z3llVkw2c3N3dkQzNDNWUFNWZ21OSHNuL292clFlN0ZzSG5sQlBUTzVh?=
 =?utf-8?B?TENyUGN2cWk3Z2dCdHVpN0JZeTZtcCsvamFQRGFGdHhMMWhPdDRjSDY3UEN4?=
 =?utf-8?B?MElNNG1GcnhJYkNGcTMzZ2YwOG55YzdkU09GQ0RXY09ncWpweVNZa0h6Q0Yv?=
 =?utf-8?B?c1VkVWFsODd4VzFaNk5odnczTmdJd0tLKzNxV3ZJMTVid05rcS8rU1pycU82?=
 =?utf-8?B?OE42S1FKMTBha3NoQndXQ1VycGlQcWdWdkpEWFl6QWtJZ21hUmNCUnVtT0JY?=
 =?utf-8?B?cG5helVnclJveHl3NkROZ2g3K2JJSHBDcWM2Z0orNTVGeEYwekdpZWNLUGpF?=
 =?utf-8?B?MFhaWk1OSDc4d3FaUFp2SW9oNHJWVzU4cWxBZWsvNWM1ZTl4eFpiT3k2K2h6?=
 =?utf-8?B?YUl6RndpcDBrUHI3R1BJQ0I5SnZnV1ljdU1IdnptcktaTTZlTjYrRlI4N013?=
 =?utf-8?B?cGVhRk0rVWFGMjQ4cWFYZjJqazB5czR3azNGRXhtNk1Xek0xWG91UEFwQThF?=
 =?utf-8?B?dHZyaFlGN1RQeGlmUWRPMXJCK0MrOTZMc0c1TnN0WHZqZFpXZGhiMjkxQ25C?=
 =?utf-8?B?NzBSWVB1MHRpR1g3T1NkWGVLSVJtVHFaSkhCYlYrTUJMY3ZNUE1KcC94ZWtk?=
 =?utf-8?B?dHlza3Ztb3hpaHZyU2FYcmNYTWpKZlFpSnVHRXNiL0pDOVQxNDdaWHpTV25L?=
 =?utf-8?B?WTZzZDJrSzZBVTU0bG9JZkliakhrMVZMMDJHNElWdmxibkRTNlk3UE1zWVN3?=
 =?utf-8?B?Z1YyK2h5TFNoV2lWMDhweWhHK0JXUjFDM3JWM0JZN2pGVE9VcFU1ZGZXS3dC?=
 =?utf-8?B?cUJJZWR5dGt4a3FjMUxVRjVId2NTaUNqRjZrYThVUDJWZS83OGFBMUhCSld3?=
 =?utf-8?B?aG1UM0dlY0ZpMDkyTFpRaFNPeXNhdURlR01hMndsdm1jVTIzamwwQldoRGh6?=
 =?utf-8?B?NVJzQjk4bExTNTl1eGVRMituM09ycUZycER6SjhiRnl6L2xGa1JoSDVPZkcy?=
 =?utf-8?B?ZldlU0JmbitvWVJJZWtaWkVRc2pVQzRQTG9yM1JOVUVNdDRGM3RHYUtjYWZi?=
 =?utf-8?B?c0Rxc08rV1B1UnRyWTQzdkVtczRtVE1oL0djc0g3Uk90SHJ3bi9ESGhUNGt3?=
 =?utf-8?B?d0FFQTNCWVhPQXgyYzVac3QyRFBPa1ZRQ3RVVDAzbTczR2cvZWlzNlN0cXVo?=
 =?utf-8?B?aW5uR0k4eE1VTGhpS1J6NWoxcUtRcVdXbHozaG4wZFQyVC80blYzaytuOVFH?=
 =?utf-8?B?SGZReDVSKzNURDFvTGxTTnlkZ2hoT0RIUERkK2M5VXgwM1ZxZVJSN2xQVEZG?=
 =?utf-8?B?dkUyUlhQajVMU29uY1hxTExmSUtmc01hRFIzWkZWcUdOVnEwNnNlUTc4NlRO?=
 =?utf-8?B?cXpIVkVDOXlrVlNOZExmaDBDcVJQVkRodzc0U0lST1lyVlNWNTNMN0tNK1Ry?=
 =?utf-8?B?cjQ2eDhFeit2WTVyRW1xTk1FK0dYbjh0UkVNWjhIeXNlTTByMkEyNFBROUxa?=
 =?utf-8?B?U1BaWFRROHVJQ2tGb3Bva2dhRy8yT01vcGlQOFcxUVM3dEpoa0RaVTAyK2tD?=
 =?utf-8?B?aHh6eGJkZEYyakpnQlVBOGNPZyt0RTRCU1lUcVJ0cCtrTjYvV3hyQW5JNjlr?=
 =?utf-8?B?Q2pscDMwbFhYK0g3YnBEZW04bHdLTmZNR1RQZTZ4Uy9QaStxNmRxNVpEUkUz?=
 =?utf-8?B?WWNDWi9lY2x6bEROb3pmUWxxTmVqMzJCRUwzMnp2N3JHY3IvYjZEb0pxdzl1?=
 =?utf-8?B?dUU2dkhKaWlSWE1TcmJUSUpFaGxwRGp2UG5VdGZKdGJON0JJZDYwMEw4MEpY?=
 =?utf-8?B?cTdHWERHOUdFUlg5NG4rU1BkdUsxYUJpMmFiZlRhQi9Cd0RVTlI2Z1ZnQjQ3?=
 =?utf-8?B?Q3NMWmlEM0F1MENtKzhrem82UWN1NlgvVVdVTE80NEpBaUhVekduaHJyN0tk?=
 =?utf-8?B?MVRhN0pMMnZ1NTdJMEswMHdkYVZIcXZRTURPb1Q0a0dxTnlTbUlDd1B2c3VC?=
 =?utf-8?B?WXR2TWErSUtRYXZzSzRQQnZsUFRGbEt2czVwUzIzeDFZeGRlNHZvaXk2MWs2?=
 =?utf-8?B?Mjk2UzB3Z0hXOHljYVE5ZU0wUUdBU2NBdys0MUlya3BhbzBkVE41STZQZTl4?=
 =?utf-8?B?dkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?UU92VE5XY2Zod0szWm8rNUFMVEZGbTJiQUI3SE9jSkhjNTV5dDlrK3g2TlFQ?=
 =?utf-8?B?MGhIclRwdmtQL0JFalVKK2F2SCtmODJ0c05RdGlQT3FrOEQxa0xyTjRBcnNz?=
 =?utf-8?B?MHVYSk5MeE1hWXdISGpsR0h3NmN5cDkzRXJnakVQdmFvejFrY1A4RzRHamYz?=
 =?utf-8?B?NWZlN255TFF3YjhtNEU1Yjc4OStIYlZGNzNNSkFQZnZxVWMrcWVNNDVVRXBy?=
 =?utf-8?B?QW0rNXk3RGlOSmxaOXlONE51dmViNDJYeHRtVjV1RFJPbzJkdEcycW9SazVM?=
 =?utf-8?B?cGg5enNmUlRnTDVzS1c2TjhiOWl4dUhuTi9RUTdZakFXc1lXMzBRVE9nZHgw?=
 =?utf-8?B?cWdxenBCTC84SXR0ZUUxUWR5enR0djVmQi9GK2ZDeEdsUWpoNGZ1cmRJRGVx?=
 =?utf-8?B?VzlYdXJzZGx2WEVkYlE3MUNScjAzRGFMQVJZZmdodTdKVS81QlRCMFdXcG9m?=
 =?utf-8?B?eUhGcjJQdEplcHVDbWlXWmlDZjlWbnlySFM0MjQ0N0srMXhiMERtUVc0Vm1a?=
 =?utf-8?B?blpjMHJIVVFPVXMxcDJvMmpxR01SSkFBYkFEUWhVNE5QYWdpa1Qyc1JOM2hw?=
 =?utf-8?B?YzM5Ykx4Nmw2R0ZrOWxyRXhkVWpURk1qbkhmcnY5MDZuZkxvSXgvZDZDd2lP?=
 =?utf-8?B?UmZzeHJPREw3Q2FzSWFSbDdqaS9OR1JxZmVCdmtuc0p5STlqMUNCRi83RGZH?=
 =?utf-8?B?RzBTUU00d0k1SGlNYlhvWUp4dll1ekk4TDBkdGhCRWQ0Q3J3YnNpYmxtazBv?=
 =?utf-8?B?V0RIKzVHYUdWRVp6Z2UxU3E3N3dMM2lCSWZISjRGYXkxRjNkNWRZazBRZFFr?=
 =?utf-8?B?YXR5TElTRTU1aHhhaVNVdkFvcWIvSnRlQkhsb25TdmhONHlNOTNYbzN5am5S?=
 =?utf-8?B?OUdKa0FUU21RQ2h3Zm01NUlsbXA1QW15TmN4aVl2L1h3L01WNzQ1U2MxT1FH?=
 =?utf-8?B?RmJJMElhWjRRc1I1Q2dmS1ovbFRvRnEza0wrT0V2WW91WnVnd3oxZlpQdzNX?=
 =?utf-8?B?MmJ6YStHaVFFQ3lENVoyeGJ4WThBV3l1TTdKdys0SFpEcSt6cEIrblMvMzkz?=
 =?utf-8?B?c1d5a1gxY1BrMWVDbmtIbWRVdTkrNnFmQUk4c0o1eXEyOFBQUG1kTDFoR0xl?=
 =?utf-8?B?L01tNXd6OXhjMmpNdVhhY1VDS0MrVEdWcUdxOEIranFLdktvNGozVGo2NC9K?=
 =?utf-8?B?MEVUOFgyU0VzLzk4b1VuTHoyUlhiQXdLZVNhU0RWOWg3L0d1VWZnWEtDeVNo?=
 =?utf-8?B?RUFxZlgzMmNna3VyU29Wc0x2dmVmMWhBRW5DdThNR2RCK2E4R1VEVm5zaWVq?=
 =?utf-8?B?R3FWTHMwVWErbGVqcnNuMnZ0OXlFWUg3M09XdWlVYVpBYjVrN01ZYzRUNFN6?=
 =?utf-8?B?UGtwczQ1cFRUZWdhR3ZxZVN3UXJZNXlCdXpWQWZvU3BwMi9DUWhCT3hFV2Rt?=
 =?utf-8?Q?hHD7kFBB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f0e0890-cd76-4ccb-ac42-08dbce647e39
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 16:25:21.9591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jOcBEsrtK208DEe2EQ6DwRUHiYqHkoQJp9lrw/L0j/KC2zADW2x+6lfC3qWwwYJ1W4oJP6JbYswzX7LhiFW00/DrUpVw7XBXjY58hXvqoEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4914
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_10,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310160142
X-Proofpoint-GUID: Us6GQkfppzrOZX4vTaAK-JVl2qqvhfxl
X-Proofpoint-ORIG-GUID: Us6GQkfppzrOZX4vTaAK-JVl2qqvhfxl
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14/10/2023 01:02, Jason Gunthorpe wrote:
> On Fri, Oct 13, 2023 at 03:51:34PM -0600, Alex Williamson wrote:
> 
>> I think Jason is describing this would eventually be in a built-in
>> portion of IOMMUFD, but I think currently that built-in portion is
>> IOMMU.  So until we have this IOMMUFD_DRIVER that enables that built-in
>> portion, it seems unnecessarily disruptive to make VFIO select IOMMUFD
>> to get this iova bitmap support.  Thanks,
> 
> Right, I'm saying Joao may as well make IOMMUFD_DRIVER right now for
> this

So far I have this snip at the end.

Though given that there are struct iommu_domain changes that set a dirty_ops
(which require iova-bitmap). Do we just ifdef around IOMMUFD_DRIVER or we always
include it if CONFIG_IOMMU_API=y ? Thus far I'm going towards the latter

diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
index 99d4b075df49..96ec013d1192 100644
--- a/drivers/iommu/iommufd/Kconfig
+++ b/drivers/iommu/iommufd/Kconfig
@@ -11,6 +11,13 @@ config IOMMUFD

          If you don't know what to do here, say N.

+config IOMMUFD_DRIVER
+       bool "IOMMUFD provides iommu drivers supporting functions"
+       default IOMMU_API
+       help
+         IOMMUFD will provides supporting data structures and helpers to IOMMU
+         drivers.
+
 if IOMMUFD
 config IOMMUFD_VFIO_CONTAINER
        bool "IOMMUFD provides the VFIO container /dev/vfio/vfio"
diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index 8aeba81800c5..34b446146961 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -11,3 +11,4 @@ iommufd-y := \
 iommufd-$(CONFIG_IOMMUFD_TEST) += selftest.o

 obj-$(CONFIG_IOMMUFD) += iommufd.o
+obj-$(CONFIG_IOMMUFD_DRIVER) += iova_bitmap.o
diff --git a/drivers/vfio/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
similarity index 100%
rename from drivers/vfio/iova_bitmap.c
rename to drivers/iommu/iommufd/iova_bitmap.c
diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 6bda6dbb4878..1db519cce815 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -7,6 +7,7 @@ menuconfig VFIO
        select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=n
        select VFIO_DEVICE_CDEV if !VFIO_GROUP
        select VFIO_CONTAINER if IOMMUFD=n
+       select IOMMUFD_DRIVER
        help
          VFIO provides a framework for secure userspace device drivers.
          See Documentation/driver-api/vfio.rst for more details.
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index c82ea032d352..68c05705200f 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -1,8 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_VFIO) += vfio.o

-vfio-y += vfio_main.o \
-         iova_bitmap.o
+vfio-y += vfio_main.o
 vfio-$(CONFIG_VFIO_DEVICE_CDEV) += device_cdev.o
 vfio-$(CONFIG_VFIO_GROUP) += group.o
