Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6B07C8B35
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbjJMQU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbjJMQUP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:20:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3271861A8
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:16:02 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DE0fG2011190;
        Fri, 13 Oct 2023 16:14:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=+20JPyzaFsM26eOkCBgpSN51cGY2ijTql7/G68M5lXg=;
 b=1YCbLVDVg1anzJdZ7+bbYTmKyWepx0fYKu/FRgwgh/U2l9tQOvClQejxdIloJ2C23ZQw
 lzKQv+HzwtccxPET7ZAJ215I5KCS6Tr0rnoxjjK7lISUwg1WXSz92dTluMbR1AOkaD8G
 fA3K8ChLcAbIrsz+kQCNNou49MuOuvaJ90vMY5I2CJRI0bgQ/9fO0Wi24FeN1iJimp9X
 vsh510p/wXEAaQl+eo5onqfStdh5nORZovY95iiV1xkUaBmQw7F/+fsuFjdONiYAC1P5
 UdSXms7X5lVSo0ziwcJedxUtb7DX4Z+SdR/GRGtnsUE6EbzD6q9UC3bhk1KAYE2lF5/5 pw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjycdwftb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:14:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DExmaf037584;
        Fri, 13 Oct 2023 16:14:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tpt0uk16e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:14:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DTpZZJ6ahUqAWWpYguGvFMw2eqyrVXDPvYzqfcxqNY4+Au/DDzZ70xMh2LOdI/6ep8Yw0jbjP4891HJxULw04fwZs+OM+064Kh5cBM8WVCQ4L46Yi1vcg8nD1uK3YtfhFFbNP+6h1R1ArMnlvlo9/HT4tWAfLWUGl3CL9PD62vUqDl6qAQiPbgPCNzmO5WBVmmAccjNQJEPzWv10KA0YGtH5koUFYzTjKwL9kYBIcRIlwEHOynokMPUCOtJvGkED4m2XTFut+LBWjHRM2AYSGKAhPV46s+WJ2ehe72xgxjSD/QRpbwnC5Kd6FuhJAuXx/uLZoalyph0DmEqKdamn8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+20JPyzaFsM26eOkCBgpSN51cGY2ijTql7/G68M5lXg=;
 b=iFArGE3zvNWDO8ffcUuAT/pXi1JAfCqZY933raQRtfflJrklNtkzbiGfUjVVCBlLCSfgUF4wAVLeF6Cax4Gpc5UuNLki95EOccGqzc856Q/TRTOmEV7H2H51ngl7mIB7Rr+u+7nCPNYioChRD2Lqbg/YirgGd39VOFbNLqX8HpUD+W/tx+LGeNCU0f2DRpaN0MYUEHpUZGJkzGt8HIrGyTYKmr1FUCl9kuWajp84xeliyKcZkvTN2cNa2fV7iJGgbGKpkoimsNku05RuAk15QbfN0TtQSV5Py+tHoXXcSCBh5vSePfiBa0xffoA4valWgV67csgbUnGk+psBh26Rng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+20JPyzaFsM26eOkCBgpSN51cGY2ijTql7/G68M5lXg=;
 b=zDOlox7dzFEZ5EXGACbxjSx7esaILaSDPwsyQHZrpP0c0eF/cIFDy4uT4oOET0ZcIkOJ8+YAd27QFiybtMk4zb1RFQhkmsBSQ8kPjiHf1LSdFaim1GsAtDIuSqcNq2iDJo1ZDlLokWPy9Vh3pUXXOIgUnAsA4EYOMzyn7+IgvOE=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DS0PR10MB7456.namprd10.prod.outlook.com (2603:10b6:8:160::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 16:14:32 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6863.047; Fri, 13 Oct 2023
 16:14:32 +0000
Message-ID: <fb94b003-f810-4192-8101-beef9fafc842@oracle.com>
Date:   Fri, 13 Oct 2023 17:14:26 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/19] iommufd: Add a flag to enforce dirty tracking on
 attach
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
 <20230923012511.10379-5-joao.m.martins@oracle.com>
 <20231013155208.GY3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231013155208.GY3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0650.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DS0PR10MB7456:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c06f8a0-3d52-4032-5b02-08dbcc077be7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +yzijBJnzxg8LpOsp58GF/aIire0pIdirYOysJ4b/iqjVZmCnEN/zVAlxXV3CjTVzNnQkprbLdx32iQXES4k8ysp2YpUywzouf1YWjON7LmoSg1INZbBKZ5WUpI7G5a4/05xyZcdhrf2pWQj4EfHGavnZOJGxmT6m9ojABPywOQmu4UYe6u6MaG1uvsVLxBGo0OJTn/AG7Yn0KzGBECUCQYn98Mul9vkL8tSIsZF+y135/iqKqbjEqlfN6x+6KxxsviHPV6KZyHwO7USejFx3nRVZUtYnsLmFLhbBD7evgMChoAB46x5UB7Ka9E02daaAdeSZzOT9uzZiI5GIBpK4FaPRcnbtUXs1yFvXdwk8fT7FdkV0A20ESAi2Oo4YFaKKXFlSqbhQR0pHlkbzQag5mFvbetSmVp6LdLYx3JDzk/Mh/5xSQmKwbA7okuSPOAvzfSgeoE+9ItwFWAi23ZjTvX7x5gGEcv9XYhqSB/8PInxEJ9xRQCXKNcizsY8bI0VBzMpExMRaeFIOlBqtl9pFxfLB+QHfbOq4V47OomO2uHJwkuNmCVsyz6xDZOQxq3g3PF/bbOBMhcX4ZkSQmINTXTqH1KHVxh4pnabK7AjofqhVKXpZaYmOB51iWlBeGkY0QN3KyIMjWGTLbEIdnqu6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(376002)(346002)(39860400002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(6506007)(53546011)(83380400001)(31686004)(38100700002)(6512007)(7416002)(31696002)(316002)(2906002)(6666004)(5660300002)(26005)(4326008)(86362001)(8936002)(8676002)(6486002)(66556008)(66476007)(36756003)(41300700001)(6916009)(966005)(66946007)(54906003)(2616005)(478600001)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTZzUUkxQ1NQQ3hmZUVWNndTeUJsMDFqdlFicndaWkxIQmwrOXlmN2NNaWZl?=
 =?utf-8?B?UWNqV1pHUzhDK0xwWXducFVYUEZPcHdjVEt2dVRCZUxxOFFTMlMvYmJjeXpv?=
 =?utf-8?B?dXU5YVlRWU1QVHlJR29xcnNRM1dpdGMvVGZHRzVVdXcwNEIyRG0xbWJBRCs1?=
 =?utf-8?B?WEZwNzdLNFpFdzQ5dmJQK2xOaG83YnphOFpnMDgrcU80RUIwRXhpZ2VXaUpE?=
 =?utf-8?B?WVI0ZG1UVlVjRGg5bUZXVkpGaTlEa2NqWlZ1MUIzazRHMWpjd01UNGdqZjNS?=
 =?utf-8?B?MXFESTVuNFNlcitlSFFzcC9nekdkVWFtVGE5K3g2NUZhdjg0ZHZscjdlNW9N?=
 =?utf-8?B?Zk1BQ0ExK0toL29PYnU0T2xOQmhUTjZDeUR2c3B2VFNYT21QYk51bzVzSENF?=
 =?utf-8?B?Wi84cGdySFJDdDBzK3g2NWNFQ1cvdERVWm1uQkhzM3dFSjh3Sm1RRFRYV0lm?=
 =?utf-8?B?K2V0Zmplc3NsdW5LN3R2OUNLZk9nWUtxUDNOOVhTUS96c0hId1JKa2JjVXla?=
 =?utf-8?B?Q3Jwd2JNQ1NqUTFsb1J0UFlEMnR6MENZMHdCdWhOTTJLdzFFUDlnTmo5ZG5y?=
 =?utf-8?B?elUzdG1GT0lqVDh1b0U1bUhlbmE1QytjYktSM0FXUzlKL3M2SVJXeE5YSkpn?=
 =?utf-8?B?R3p6NkttcC8wMFR2L29GSk9JeXdsdHlrNnNWem9wZ0t5YmVKcDhRRWluMjcy?=
 =?utf-8?B?elBRbXZZMU1NRkFMZTB6djFSRjVrYVYrS2pOM2NKU1BiZDlqNmhxVzVIc2F6?=
 =?utf-8?B?SXZzcTU3OXpmdEt3U05MQzZSc0FkaHdoMUk2Q2JhM2xHVU1LUDFYR0I0TnF6?=
 =?utf-8?B?VzVuTFBSWSsrOUsxQTZsbzV5SXNuWmR4MVRoRVBXdDBoczA5VnQvWGthTGpM?=
 =?utf-8?B?Y0lvSU9WWmk0S1g4ZkxENmYrbm1paWVFMlZGRmRYZzh0eFBEMTVGdVhKVnZr?=
 =?utf-8?B?V2xDLzZWcFlkbExPeVE4T1ZTSnA5SGtIVVVRNFVhTUdRRnZnZXlpV2MzdU9E?=
 =?utf-8?B?QjNKbXRSbHRDODZpSDF4OEVLQVlQM1g0R0tsVytMcWtnSHRvVENselMvNUpp?=
 =?utf-8?B?NmFNSitNaWV2TzJPSzdrWmc0eWdlOTVuNEovZEhmNmRkcldvTHRySHgxT212?=
 =?utf-8?B?K2YycnVYRStyMlhBNjJCejBtZmtQKyt4d3BLZGhvYkYySk5FeWV3VTJlNm9k?=
 =?utf-8?B?MW02L3o5NHY0RUZwanhKL0I5SURoNFJBMFJHdk94aEorUzJRckZtQU9sU2tx?=
 =?utf-8?B?V3lBSkx3cW5TdFJFUFUvR3psdVZHazJoV2paZ21zcEJZTGFZeG5KbEJmaGhB?=
 =?utf-8?B?YXhuNnZ5bW1oNlJmb3VqbFlmVW5URkhtRDB6WUNyUTlZekxqT0FVemxtYUpm?=
 =?utf-8?B?N0ZTODJ6NzZJdk42NjNCTERXVHhFek91YW96L2dLN2NrMDhEMTB3SW42TWJE?=
 =?utf-8?B?eHV1WVM0cjdtcy9KSVBIR2YwMXFGb1NGMEhidUdyUmZpdG55QndHMktGVUts?=
 =?utf-8?B?VERLU0tFOFBRRE9qLzFhT3NqYnE5SEJvUW9qTVcwOU5xSjdybThhaUtjblRV?=
 =?utf-8?B?Z1ZTKzMyYklhYzFPL0RCejhSeldvUnQwQ2ZSSEFMYWZpbnVxSVp0TkJ1NEVO?=
 =?utf-8?B?WmdaZ3g4TElGMmRwWWRjR09sd296Rk93UUNrWWwvNU1sZUdPQUpscE5NZEs4?=
 =?utf-8?B?citqWWMzQXJDeEM0RE9zNHRoRktBMzBWSy90ZnUyN1JHbjY2VDNldlJheXBn?=
 =?utf-8?B?N3NzeXlFNEU1NkFtOFlZb0tZQjZ5OFY5Y01UZndsd3duY1dhK0J3WFZTMlYw?=
 =?utf-8?B?Q3hFLzJhbUwyTGViSytLZHgwYVRaOUpXYkdZallyaEduZzVNZFIwYTczeWp0?=
 =?utf-8?B?eVBESTVZQ0xxcEttK0t6bTJ3OHJOQk9sY09MSFR4ZFVjcTI2YnUzREo3Y0dr?=
 =?utf-8?B?bnNxNTM3RjVrZFpDb0srV1VLUFFOMVo4VldiSC8yMGpXNWJuQmZaTUJVb0Mw?=
 =?utf-8?B?NnFjSkIzclJmY1FVOTg4MXJRblQ4YUZwcFdxTUdFaXp4bVNLdlk1YUMvelUx?=
 =?utf-8?B?QU9ISWgvUUVQbjA4aFFKL2M1S3Q2WEo2VUFrb25iSUpMdkZmOEk2QUtHZ1d0?=
 =?utf-8?B?VkpFeGlPaXk0TEgyYlQxQjNyakNrQzJxZWZyNFBvVzJpUzI3M1VkUVZ6V2Nk?=
 =?utf-8?B?OWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?aklmSEhRWnFtSnJCQkx0MHoxNUx3NFJhcHR2clpZcHhDenAzQlZYT1lHYk1p?=
 =?utf-8?B?N2hKUlhGdEs5YjVQWEhKUHpnMitxQVBWZ0dXQmt3OWw5aEhzMU5zTjVqZWJs?=
 =?utf-8?B?aHZRRjZQMWJnWWkxenJiNVc4djlaWm1mTnpwZ2FrNGpkVFNYcHk0Tis5S3U3?=
 =?utf-8?B?TDh6LzMwQWNNZmlmWnJGOElTOVdtczduWjAyckl1bS9EVDN3dTVOSGxTYjBv?=
 =?utf-8?B?eDZUbXlhK0EzZGZkQzRnbmhVa2xBbGZudmFuMEI3eWpQaWtNNmRiTjU3UkdD?=
 =?utf-8?B?VTFvSm9zcENqNUQ3OTFCdTFDajlDd29ZelNSejZQc3RqYkJLaGVEWGpDVTJN?=
 =?utf-8?B?b3NnYkdhT3dGUWxoc3RmSC9KSG9reDd5d0RVaDV2dWk4N05HaGw0MU1WZ3NX?=
 =?utf-8?B?bHVoNjgrbGZITklqVGh0dldPYmNLZnpSMHAwdyt2UGF0YTd3WnR1SGc2MUJu?=
 =?utf-8?B?aktZSXdMUWRiMUJuRHNjeC9nR2RaWkUwbzJnZVB2SW9TTHhjRkhtdjd5UlZU?=
 =?utf-8?B?SGtUUHVodXE5ZXh5ay9RRTdlcHk3SWFONzR5c3lISXE2UnZlcmVhOXpRZGxm?=
 =?utf-8?B?RTRYRUZhVjFaUXpiUmh4SXIzTmRFRDZxdE5OUmRnK2laRjFlSy9LVkEyVCtk?=
 =?utf-8?B?YlM4Qm1yOHI3ai9mb3dBcS9RWVBaejFZdzJubnZIMXVSK0lrZmNsZXpPQmlW?=
 =?utf-8?B?ZGpuaDlWN2VxUHQ0RnhNZ2t6ZlZtN1l4elVwd0xQbTNyMW9zRUdSL3lCbTBP?=
 =?utf-8?B?UFdqN1VYZGpxZWE5QjV1YUZ4RlljbTd6cDZXV1NxRVRvV2I3QTZZcEtOcjlT?=
 =?utf-8?B?bjhReVBndWErTVhudncrTXp1KzhYYkc1Z1hWbFlPUTkySmxIak1QYWhxdGla?=
 =?utf-8?B?UjMvRkkvSW1ZblZjVFREc0xDd2haMCt4RTBSa3MvM3ZiRmluR3NJTXVzWEg3?=
 =?utf-8?B?aDY0bmprQ2JQUWY4VmFzOUdlc2w4RmNWeC9QWmhQZFVOcmQySmZwL3hyN2JY?=
 =?utf-8?B?VDNHSHJSNENWTmN5MEhtbytzNE9kSG14YjZuRjVpMHVCYmVyeDhhMlQvaWxK?=
 =?utf-8?B?WWJ6RG1NSXRoemdkNUM5alp3R25Xd2tDR2RpNzBnYWl6ZTk3SzRnYjROTHRV?=
 =?utf-8?B?bElaOFZacTZGM3VWdXY3cmkvUnFyRHNVVUhjejNmUjFRSVNRa3VWcW5tbHM0?=
 =?utf-8?B?bE55b0Njb3RKcUNpbHVna3BmcDZpQWhsZTFsUVZFWTdTbE02RVhhdVhXYUpa?=
 =?utf-8?B?b1kwSy8zNGl5TFlXd3VVNURzaHpoQVd0OXZBSzhWZy9jSHIxbkZCNnZTVE4y?=
 =?utf-8?B?R2REUzZsbzVUYzFTVjczTHM0emozbUJrZEdwenp3YWI2cXBtZkFxVnVHT2c1?=
 =?utf-8?B?eWVDQTEzS0xaTCtlbWh5cWdNZDdGM0VpY1crTWZVK0RManZZVG1HcWpVNDNZ?=
 =?utf-8?Q?Xzy1d2ed?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c06f8a0-3d52-4032-5b02-08dbcc077be7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 16:14:32.0269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1DEJTBJyRFQuzgp+5F+kNaZ8MErly/I/io/s24gUcI7858OiRWhg8AGI3efZkLBFwdl9WLcBGSWwGI9olQBCvgVsta27Gt8OitKZ/zEVyBk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_07,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310130138
X-Proofpoint-ORIG-GUID: MXK1ngnTjEbvGXBXIaofvL8mck6XFu93
X-Proofpoint-GUID: MXK1ngnTjEbvGXBXIaofvL8mck6XFu93
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13/10/2023 16:52, Jason Gunthorpe wrote:
> On Sat, Sep 23, 2023 at 02:24:56AM +0100, Joao Martins wrote:
>> Throughout IOMMU domain lifetime that wants to use dirty tracking, some
>> guarantees are needed such that any device attached to the iommu_domain
>> supports dirty tracking.
>>
>> The idea is to handle a case where IOMMU in the system are assymetric
>> feature-wise and thus the capability may not be supported for all devices.
>> The enforcement is done by adding a flag into HWPT_ALLOC namely:
>>
>> 	IOMMUFD_HWPT_ALLOC_ENFORCE_DIRTY
>>
>> .. Passed in HWPT_ALLOC ioctl() flags. The enforcement is done by creating
>> a iommu_domain via domain_alloc_user() and validating the requested flags
>> with what the device IOMMU supports (and failing accordingly) advertised).
>> Advertising the new IOMMU domain feature flag requires that the individual
>> iommu driver capability is supported when a future device attachment
>> happens.
>>
>> Link: https://lore.kernel.org/kvm/20220721142421.GB4609@nvidia.com/
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  drivers/iommu/iommufd/hw_pagetable.c | 8 ++++++--
>>  include/uapi/linux/iommufd.h         | 3 +++
>>  2 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
>> index 26a8a818ffa3..32e259245314 100644
>> --- a/drivers/iommu/iommufd/hw_pagetable.c
>> +++ b/drivers/iommu/iommufd/hw_pagetable.c
>> @@ -83,7 +83,9 @@ iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
>>  
>>  	lockdep_assert_held(&ioas->mutex);
>>  
>> -	if ((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) && !ops->domain_alloc_user)
>> +	if ((flags & (IOMMU_HWPT_ALLOC_NEST_PARENT|
>> +		      IOMMU_HWPT_ALLOC_ENFORCE_DIRTY)) &&
>> +	    !ops->domain_alloc_user)
>>  		return ERR_PTR(-EOPNOTSUPP);
> 
> This seems strange, why are we testing flags here? shouldn't this just
> be 
> 
>  if (flags && !ops->domain_alloc_user)
>   		return ERR_PTR(-EOPNOTSUPP);
> 
> ?

Yeah makes sense, let me switch to that.

It achieves the same without into the weeds of missing a flag update. And any
flag essentially requires alloc_user regardless.

> 
>>  	hwpt = iommufd_object_alloc(ictx, hwpt, IOMMUFD_OBJ_HW_PAGETABLE);
>> @@ -157,7 +159,9 @@ int iommufd_hwpt_alloc(struct iommufd_ucmd *ucmd)
>>  	struct iommufd_ioas *ioas;
>>  	int rc;
>>  
>> -	if (cmd->flags & ~IOMMU_HWPT_ALLOC_NEST_PARENT || cmd->__reserved)
>> +	if ((cmd->flags &
>> +	    ~(IOMMU_HWPT_ALLOC_NEST_PARENT|IOMMU_HWPT_ALLOC_ENFORCE_DIRTY)) ||
>> +	    cmd->__reserved)
>>  		return -EOPNOTSUPP;
> 
> Please checkpatch your stuff, 

I always do this, and there was no issues reported on this patch.

Sometimes there's one or another I ignore albeit very rarely (e.g. passing 1
character post 80 column gap and which fixing makes the code uglier).

> and even better feed the patches to
> clang-format and do most of what it says.
> 

This one I don't (but I wasn't aware either that it's a thing)

> Otherwise seems like the right thing to do
> 
> Jason
