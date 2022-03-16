Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CB44DB651
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 17:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238933AbiCPQjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 12:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349863AbiCPQjg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 12:39:36 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32999DF95;
        Wed, 16 Mar 2022 09:38:22 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22GFHaip008288;
        Wed, 16 Mar 2022 16:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9STGMDKPMnLNWdJxf0GEE1tML/6VyF6aU871DWWRWzQ=;
 b=iD+xo9zDtPPKr8woZ3pnF7KAef4D2Nh3yFwQ74Onu4lIH7L0k+SmfRHKntY2fg/5hBpV
 QhQ9nIkI0GDBWwODdLf70l90LvrFt+l/Cqxl1cZ7mUeadkuHyJ4oEpS5nVJov2jA9y0L
 KEunLYRoFhTw6KJRBVTL/M3WkhlYRHGIZiqHDTKYPUyEuHOXcpQ08bpha8m5up4bpuUB
 zp/bYLuVKLTM41FmAv3AaKpDfDyKKE7B2jrYJtzzuReRO8PkjRTDs193QjWpkDZa1aPA
 f1EYAxJW0jJzCzWYQWbE7Ub8CxEVrBsMTApcyZ8JlpYgTBWrXSK7MCWOZleWOgd+cSI6 /A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et60remuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 16:36:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22GGGEnm106818;
        Wed, 16 Mar 2022 16:36:57 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by userp3020.oracle.com with ESMTP id 3et658svu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Mar 2022 16:36:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UnRRKpFM+uLqAf/59rn2/Rb9twpZx5rZjRj4t0HYJO0XWHWq7nDW451TkuHHn126eGded3FzhUCuEU2RXFOnc+87eWGVUX3kDM7YCDs+CODyOpC78/1GjyuCax25ngFi9qzdjV9KiBUKfODNbdvwwcojmiZayLDZBhFCrYJFvrKnW30h4rEaKXIEhoQJW30HtMWDduw7ld5j18ZV5Z2Bu83qs403SSrGQteOuU37+WlNJFSdMWeE9ixjNrGbmP7VVgUk2ZSE3A1Mwd/Qf8mcmYA/v4y1sHn7KVQn9A3XkzcKJ2jtJA592Mhh4qtFTMWRk0siCs3DRU7EU+ZN4nPxtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9STGMDKPMnLNWdJxf0GEE1tML/6VyF6aU871DWWRWzQ=;
 b=oZ59mM6zbQOIGG0cezNKj9b35HofeUUC79ZvfA41REubfJC9ivHOZm++ZkcE3tX+oVruUDKGJCbXpNelMhotM6/kGVXGo7nrx4OVrYyObMBcPz2P+vOymRtNXRafCP1BrrnJ3T4pz5IEwCQ76ciEQuN0DQ5AsvlOHOSQRW0I3YJmwBdTNtCJhfLFC/ZEy1rqc4Y67jtLNGwtbBO0r/noaqnL9K/NmrTZBQIIzfTVrysZPpW1pVRGVVKen41theK4vRFsq6wZEy26yF4dcfwMrxqlimYts+JhJTrl8v9R8JLzuHDA2BFfMz1Z4GvROtR8Z8qrjffnK453xt7kpzcaDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9STGMDKPMnLNWdJxf0GEE1tML/6VyF6aU871DWWRWzQ=;
 b=DrDDHAlAxldFV8CPZeRhGZU+kyHyXHWbpYtDkmDMOojWMiNBWpkhyP+vHH4x6S+m0t5EMSfpI+3Zu/zuLqIEdLumA7qBIqCnlqWH9xi22QlPWgG248Lab02nLIBP/VMXRDjiW5wpag2/oqXv99oglnv1ZudOrcUEnWcSmY2Kb40=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SJ0PR10MB4655.namprd10.prod.outlook.com (2603:10b6:a03:2df::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Wed, 16 Mar
 2022 16:36:54 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5cee:6897:b292:12d0]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5cee:6897:b292:12d0%7]) with mapi id 15.20.5081.014; Wed, 16 Mar 2022
 16:36:54 +0000
Message-ID: <6fd0bfdc-0918-e191-0170-abce6178ddaa@oracle.com>
Date:   Wed, 16 Mar 2022 16:36:46 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
Subject: Re: iommufd(+vfio-compat) dirty tracking
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
References: <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
 <20220214140649.GC4160@nvidia.com>
 <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
 <20220215162133.GV4160@nvidia.com>
 <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
 <20220223010303.GK10061@nvidia.com>
 <e4dba6f8-7f5b-e0d5-8ea8-5588459816f7@oracle.com>
 <20220225204424.GA219866@nvidia.com>
 <30066724-b100-a14e-e3d8-092645298d8a@oracle.com>
 <8448d7fb-3808-c4e8-66cf-4a3184c24ec0@oracle.com>
 <20220315192952.GN11336@nvidia.com>
Content-Language: en-US
In-Reply-To: <20220315192952.GN11336@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0470.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::7) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfa974a8-7aba-4800-31ff-08da076b2dc7
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4655:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4655467E8A9AADBC6AE8B53CBB119@SJ0PR10MB4655.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uo83iW7luhfwqTXOk07xkIPPYDWpGhAWNyRRYqfvWq7+bj9V2SxOJ8A0jS+9EUeqoKM4Kms82esy7FXwBNQ5O0FrXS5b3hxNx0vhVxtfA0F0+iShwEdFDGXDJRLASm/kYU1seP4cNuErnIg37oHj1nHrhl8uRbBs/n7DlEqXFoLd1Ya4t63AqH3/jrFdGPNiJciFI8zHiRMvg/BO/W77A3nQiWyxrLXtC225FEwJfvY1uhGhlz+RwOhiJT0uwZaakR19tHiJpAtVmVZTkTzB7RG2EIt3xAAcI6BN+eghhpzpNb34HplttgNPBr8Cn7l9yS2AV2oZLSNXqbcbwWEes4KWTojXpzkRAyO52hLGQmtOHv4hn0PFr7hc0yL5RhpGM5I9Km+HG9yx9es92+AFi2nrzGJeF4ix1GTtfh0CNNaXNtr5c9pDpHrHbHxdjpaKNSNpP1+OayduDYlrNXZx45RLV02C2dtK4Sz7dj0dEGrMmY9btU1wLZdmwM7LLOamNDwjTVmPgI5XD15fse6WGQfklKslqnVkkAtsDjfzI3ILm29wwEebpN+TKsye1ShOGJckNvrm8Vb71RmuamhkBWr1KITkkNDp2pES4fh8zJRqzqb4JAWIhkiubppwM/rGG4OxP05tm15cl5ylyiP9ZV8Y88fl6ULBsQ+KJ+RMyH58+A0wyVsiDPnol8o8eRmR44M7jph4dR8yIt7NxGDcORdyufKHZ8NWoecdOnQslx4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(6666004)(7416002)(86362001)(6512007)(31696002)(83380400001)(53546011)(6506007)(4326008)(26005)(186003)(8676002)(66946007)(8936002)(316002)(66476007)(66556008)(508600001)(38100700002)(36756003)(31686004)(6486002)(54906003)(6916009)(2906002)(2616005)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWJtZTh6WEUzc1RxVU9sVTdjTTdsV0hHeHJWajI3Q1R3TWdhTXc5L01iZmcy?=
 =?utf-8?B?UjdzQUhzZU13SjdaNnprc0hhR0JHblJ2SnRSVUV6Qkl4cnhWVUZjdE1CZnd1?=
 =?utf-8?B?SXkxbGtQLzhtSTJLUDBmVytzRUZObStrdGlJN3BjM2UvU3dFK1FncVRCSHRw?=
 =?utf-8?B?NkxxN0lycWMrN0ZPTEFQZkZma2dzN3FXVkhlcHJFQVIxWjhwcVh4NzRPOHdH?=
 =?utf-8?B?UU9sM3ZOYkpsQ1d6djJWSWVwanlUbjlycE9MZmVSUjBSbmFFUTlXYVJ2OFRM?=
 =?utf-8?B?ZGdPaVRkdTNGb3hJR1paK0Z2ZVJFTGJaemUvcExoemVlWGU0a2xWNGk5NmhU?=
 =?utf-8?B?Zzc0WE4vZUxkdUNOU1c0b1V0N0FodXRuVFpRaGQzMnVPZkxQbHBkZUgwMmVU?=
 =?utf-8?B?a0s5VmRZTDBFQUdjWDR6S1NyaDViYnloOWI4R3ZPWnNMSURPbEhkVGRTNDB0?=
 =?utf-8?B?QnUrZGFXbVRERkFPNEs3ekh6NXRyS1hQRHBmdUUxYklSeHZrQUVOS0Yyb1BU?=
 =?utf-8?B?MUZwMytRWXFVc0lFY09nNzFtUytCREM5NExLMnJ6bGtGaWFnVGpLQ3ZEanJJ?=
 =?utf-8?B?NkhnZDB5dHJtTm84Qkg4SVdQYXFGWDk5QmtpKzNYQS9kd0ZHUVZJZ21SS3FT?=
 =?utf-8?B?Z051eXQ1QXJtZnp4N2hUamF6QXQzd2s5ZjJqM3pMS0lLYmV3akFrQkJWU3Rr?=
 =?utf-8?B?MExSak9mdFA1UEpLcC9EWklHZlFoTjNOQWVEWHY0VDFwaGErY2M4bUhZZU1Z?=
 =?utf-8?B?dWNmRzFhK1lDSXIrWER5cXQvVE9OMS9CcnZpTE1kRHFRc0sweUxiS3NEeUYw?=
 =?utf-8?B?eGYvdzg2eUk0b1pjZHcvSkdyellKR3RxSTdtL29qVUVsOElwa1o2ZTY1eXA5?=
 =?utf-8?B?NzQxbEV3NU5SS2V6ZU1CMXIvblo4ZEVlelFWaFB1RjllK0h6T1lHWmtKR2h3?=
 =?utf-8?B?Nzc0cExrS0VxUzFrdzJXTDlsWWxWM3E1R0E0YmZkUURGY3FpNE9HZVpjb3do?=
 =?utf-8?B?V0Y3YUVkcTFYaTFaYVRVb0ZzU04rU29uTXVKbVcvdmkwcm1DeEdWcElFbE9n?=
 =?utf-8?B?VTN4YmZoUUpJWVZCV1FpS21JQkdEZDduRCs4elZXaE83SmhmWmNzcmVoYXdK?=
 =?utf-8?B?YjVxQWJYQ3k4T1MvWTFUUnc5Zi9ZT2RjN0RudmYyVlZPamxWRTc1dmhvYnEz?=
 =?utf-8?B?Y1UxckttOWpnanBNWkkzZHJ0SXA2ekQ4U3ZidmVzL0MwWHZzSytrMW14THFv?=
 =?utf-8?B?MG54VW5WVElRRHRMQVVNWjlCVTV3VDN6YkU0WjFjNTdUTFowbktTOVJERU53?=
 =?utf-8?B?UlZpa3NmV29ONkJsS3Z4WWRycWVLQ29qandaRXFSN3NaQk95NnFPeHl3U1dk?=
 =?utf-8?B?UmFnVEpkSWlGTWdTK3l6b1lUdnZpM2FNMVQ3K24vbzRmUjRlZmRXb1BoYWlG?=
 =?utf-8?B?NDVLenZhN2YrYU9jRjJGU0dnOHVuckFoY3lnNXpvVkxkanYrSzJ1cWtIZU5o?=
 =?utf-8?B?Z3VZMm1wcnpIWU1pRE1ZdE5URUpLWUxXaEFyUVJSQ0dyT1NsRDNQd1o5NG9K?=
 =?utf-8?B?U0tncEVXY28yZVBsSHBsY2dZOVdGVEExVlR0VzFncTJXS0tXWEF5Um5DRXZa?=
 =?utf-8?B?aktyYmZVMHFvWjY0VzVJR2JBYzBXVDZ5eFVMcVNkQTcrYnpjSmVhcU9XQUJy?=
 =?utf-8?B?d1ROb1NKemN1a21EZEludlRhMUgxSmlqREJnS0J3OVRzVGFTWkhOSUxlMDBw?=
 =?utf-8?B?T21rdFNFYWZubWJSaVQxYm1qR3hRNVVZMkNoQmZRalp1dEkxSTc1YisxTTRQ?=
 =?utf-8?B?RGJWODlIak9ocnBXQnp2T2RRKzc0TTVwL0hWTjdzU3dXdXpGcmJLNGRmQmxR?=
 =?utf-8?B?OXNYQTVYNmhITXJCdW9DVzZISVk5dVRQR21RM09ReGpWaHRDQ2pRKzBoQjA4?=
 =?utf-8?B?cG5qMm0vUVZwNTRseS9WWkRGK2c4cGNrUlg2N2g1R0JUc25pTXJLWjFEOU1n?=
 =?utf-8?B?ZDFLcFo2MllRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfa974a8-7aba-4800-31ff-08da076b2dc7
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 16:36:54.3329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PX7L9M/JaABNyhqBwzDdUYSep9agot6K9ui6YrTEiklJHjOHXMbQaYm6hoaNqw2XU899J4VdbPN1rIO9a4j4qcKIRyJPSMES00zV/abs8E8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4655
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10288 signatures=693715
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203160099
X-Proofpoint-GUID: C6Tm4wr2dHXcjSTON80i9oogZfcQyRdj
X-Proofpoint-ORIG-GUID: C6Tm4wr2dHXcjSTON80i9oogZfcQyRdj
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/15/22 19:29, Jason Gunthorpe wrote:
> On Fri, Mar 11, 2022 at 01:51:32PM +0000, Joao Martins wrote:
>> On 2/28/22 13:01, Joao Martins wrote:
>>> On 2/25/22 20:44, Jason Gunthorpe wrote:
>>>> On Fri, Feb 25, 2022 at 07:18:37PM +0000, Joao Martins wrote:
>>>>> On 2/23/22 01:03, Jason Gunthorpe wrote:
>>>>>> On Tue, Feb 22, 2022 at 11:55:55AM +0000, Joao Martins wrote:
>>>>> I'll be simplifying the interface in the other type1 series I had and making it
>>>>> a simple iommu_set_feature(domain, flag, value) behind an ioctl for iommufd that can
>>>>> enable/disable over a domain. Perhaps same trick could be expanded to other
>>>>> features to have a bit more control on what userspace is allowed to use. I think
>>>>> this just needs to set/clear a feature bit in the domain, for VFIO or userspace
>>>>> to have full control during the different stages of migration of dirty tracking.
>>>>> In all of the IOMMU implementations/manuals I read it means setting a protection
>>>>> domain descriptor flag: AMD is a 2-bit field in the DTE, on Intel likewise but on
>>>>> the PASID table only for scalable-mode PTEs, on SMMUv3.2 there's an equivalent
>>>>> (albeit past work had also it always-on).
>>>>>
>>>>> Provided the iommufd does /separately/ more finer granularity on what we can
>>>>> do with page tables. Thus the VMM can demote/promote the ioptes to a lower page size
>>>>> at will as separate operations, before and after migration respectivally. That logic
>>>>> would probably be better to be in separate iommufd ioctls(), as that it's going to be
>>>>> expensive.
>>>>
>>>> This all sounds right to me
>>>>
>>>> Questions I have:
>>>>  - Do we need ranges for some reason? You mentioned ARM SMMU wants
>>>>    ranges? how/what/why?
>>>>
>>> Ignore that. I got mislead by the implementation and when I read the SDM
>>> I realized that the implementation was doing the same thing I was doing
>>> i.e. enabling dirty-bit in the protection domain at start rather than
>>> dynamic toggling. So ARM is similar to Intel/AMD in which you set CD.HD
>>> bit in the context descriptor to enable dirty bits or the STE.S2HD in the
>>> stream table entry for the stage2 equivalent. Nothing here is per-range
>>> basis. And the ranges was only used by the implementation for the eager
>>> splitting/merging of IO page table levels.
>>>
>>>>  - What about the unmap and read dirty without races operation that
>>>>    vfio has?
>>>>
>>> I am afraid that might need a new unmap iommu op that reads the dirty bit
>>> after clearing the page table entry. It's marshalling the bits from
>>> iopte into a bitmap as opposed to some logic added on top. As far as I
>>> looked for AMD this isn't difficult to add, (same for Intel) it can
>>> *I think* reuse all of the unmap code.
>>>
>>
>> OK, made some progress.
> 
> Nice!
> 
>  
>> It's a WIP (here be dragons!) and still missing things e.g. iommufd selftests,
>> revising locking, bugs, and more -- works with my emulated qemu patches which
>> is a good sign. But hopefully starts some sort of skeleton of what we were
>> talking about in the above thread.
> 
> I'm a bit bogged with the coming merge window right now, but will have
> more to say in a bit
> 

Thanks! Take your time :)

>> The bigger TODO, though is the equivalent UAPI for IOMMUFD; I started with
>> the vfio-compat one as it was easier provided there's existing userspace to work
>> with (Qemu). To be fair the API is not that "far" from what would be IOMMUFD onto
>> steering the dirty tracking, read-clear the dirty bits, unmap and
>> get dirty. 
> 
> I think this is fine to start experimenting with
> 
>> But as we discussed earlier, the one gap of VFIO dirty API is that
>> it lacks controls for upgrading/downgrading area/IOPTE sizes which
>> is where IOMMUFD would most likely shine. When that latter part is
>> done we can probably adopt an eager-split approach inside
>> vfio-compat.
> 
> I think the native API should be new ioctls that operate on the
> hw_pagetable object to:
>   - enable/disable dirty tracking 
>   - read&clear a bitmap from a range
>   - read&unmap a bitmap from a range
>   - Manipulate IOPTE sizes
> 
Yeap -- heh nice, it is roughly what I was into already. I will take the
opportunity of doing the zerocopy/gup of the bitmap when writing the
iommufd native ioctls. The vfio-compat is still copying.

other things on my mind for iommufd native interface are:

1) The iopte split *could* be while we read the
dirty bits of a pgsize != than the args pgsize. The
read_and_clear_dirty() is already expensive, but I wonder about the idea
to take advantage of the dirty-clearing needed IOTLB flush, to also also
update the IOPTEs on the next memory-request/translation-request. Albeit
iopte collpase still needs to be routed via a specific ioctl() to promote
to a higher page size (should the migration fail or something).

(I referred to this in the past as lazy-split contrast to explicit IOPTE
size manipulation iommufd ioctls i.e. {manual,eager}-split)

2) I was thinking io_pagetable new APIs instead of hw_pagetable, but if you're
sort of seeing this as a hw_pagetable object primitive, then I am
wondering why? Albeit at the end of the day we operate on the iopt inside the hw_pagetable.

Note: IIUC that hw_pagetable is supposed to model a iommu_domain
direct manipulation which dirty fits in, but wouldn't that be applicable
to _MAP and _UNMAP too maybe?

> As you say it should not be much distance from the VFIO compat stuff
> 
> Most probably I would say to leave dirty tracking out of the type1 api
> and compat for it. Maybe we can make some limited cases work back
> compat, like the whole ioas supports iommu dirty tracking or
> something..
> 
> Need to understand if it is wortwhile - remember to use any of this
> you need a qemu that is updated to the v2 migration interface,
> so there is little practical value in back compat to old qemu if we
> expect qemu will use the native interface anyhow.
> 

Perhaps the value is really just *how much* applications need to get rewritten
to adjust to iommufd versus iteratively adding small (new) parts of it .
migration-v2 didn't turn into a complete rewrite of the vfio initial part iiuc.
Albeit I suspect keeping the compat was perhaps a struggle to keep, which we
might not what we desire if the semantics diverge too much.

e.g. If the semantics are about the same, for example, new VMMs could use the
iommufd new features using IOPTE size change ioctls() via the VFIO_IOAS (if available)
while leaving vfio-compat somewhat usable on the existent dirty ioctls. While slowly
moving to newer iommufd (and less vfio-iommu-type1) until the point you totally deprecate
it. Even without IOPTE size modification in vfio-compat you would still mark as dirty
a lot less than the current logic would (which really represents the whole bitmap).

I guess at the end of the day it is the maintenance cost -- Fortunately
APIs are looking similar and most of vfio-compat is dealing with userspace
args/validation.

Anyhow just some thoughts, open to anything really :)

>> Additionally I also sort of want to skeleton ARM and Intel to see how it looks.
>> Some of the commits made notes of some of research I made, so *I think* the APIs
>> introduced capture h/w semantics for all the three IOMMUs supporting dirty
>> tracking.
> 
> I think the primitives are pretty basic, I'd be surprised if there is
> something different :)
> 
Yeah, they are very basic.

My main unknown in the rework was how the hw protection domain context can deal with
dynamically switching dirty on and off. But I think I answered myself that restriction at
least from groking into specs and experimentation.

> Though things to be thinking about are how does this work with nested
> translation and other advanced features
/me nods

There's usually some flags/bits on the 'stage 2' domain, at least ARM (S2CD) and Intel
(second-level table). But for AMD, you usually control via the vIOMMU what features the hw
exposes[*], and I think there's an extra bit to set to disable vIOMMU dirty tracking from
VMM. But I think still the only thing needed is first-stage tracking, as that's what
matters for L0 live migration.

[*] AMD vIOMMU also offloads some of the command processing, not just the pagetables. Not
sure if ARM/Intel has the equivalent.
