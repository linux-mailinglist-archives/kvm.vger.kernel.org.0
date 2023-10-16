Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105A27CA5F2
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 12:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjJPKo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 06:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbjJPKor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 06:44:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E401713
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 03:43:49 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39G6mwrI017407;
        Mon, 16 Oct 2023 10:43:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=QPQalPx8dvanKQ5q19O7znR5FxTsSLKoFe0QyS0JQ6c=;
 b=Gpt1EO/FjQa8NycWn3BsJIehOis7VEAaHtz29ItWjNxqugOxqV6OpbaNZj4kMk3GMiS4
 +PSH96kLrCgr8n3YHPS6HZHP8wo3jZb7V7rw4YT4x+uk+z4JZxQme1snH/k8V9eWep6W
 OhEo3xxQGgVfokQFzWthKsTE+Lbn/HVHcjEOaqVlvz84Ug6ImcEl3DNAL/k9s/Zz5pxe
 CT50xu4rJCXqAlWrmYHWYCNkZmsYZqhWFum8lkrugpe44dnVTC8JzGlZCe+VYIO04v2O
 U1oxq0VJswcY8/xBXrdtlpwA2KP+mQfBDEBOgqb+K+7XAWwMIzjKIX69ec29lux7nVP7 sg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk28jeke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 10:43:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39G9OHdU021602;
        Mon, 16 Oct 2023 10:43:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg4yds1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 10:43:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eKH7S98+w6jj1jF+XnSISPhoWqEFWiLKezpJkA1uUQ34RjRaUBDyIf7BA4q8uMnLoZK9WE1XRcUUk+dMaJvj+DvpdAjGhTaJP+sOFfu2tLtiOsRAtDWEazj6mO54XkEbTqe9nTDdW8g0/bDt3+D8ZetaTRU7xcmVc6h4SmSnO0odw+y8fZawH/+vB+xVeJ3zLx9wqthsFOHSYz+JlnN4qA0BkBtL+kGrcZFkUSYDTCzyfY9NXz9yM+FO30Mlo8OdsCRhps0w6cSEOOjJGlvMITStX5fp41DjiawFZ6YVKJPl6rXz/kVDJbqWoc+mCouDJZJPMPm1jKItu8gmT/OGjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QPQalPx8dvanKQ5q19O7znR5FxTsSLKoFe0QyS0JQ6c=;
 b=lLX6/CjPpNA28QXl+2SdSB6oaSBUlR7HuPURDCfgmS7gEN3/0tQe2ay8NxMgsacf+t6W7/nN6G8To38s6/eXX0KxvNvsYz7NC3onu8z7j2apNE39ti5r31LqMOWrBjOA9DBCvWIQLJyrL1ZeIoW80sk6rPvrMhiim7xXoGCetdz6EqrpXJMB8UI58dZsACV0BlfD/LJufLQ9NJ/sbQHIpe4VJqVAAWgacmMA0dV+pyXmgXcVsLV4Bb8lzeSPqR2t2jaVO9yoF9LdV8yoEukpX96oxWUecapeem7KezrPwzPsaFybvzYAxF6o8KEjOPvyCJGaFqelmdpmxOCbCo8GUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QPQalPx8dvanKQ5q19O7znR5FxTsSLKoFe0QyS0JQ6c=;
 b=eMBfb5C6ebbgnrVz7BpjEcfjDMFUKJ8XXL6AGQAurfmBnHxM4jjm3ktILcBBwljJ6yV18da2hAq+z5qwQ0bxhpXv9oRgM0lfbXgyG1tQ1EuMFa2pDuEaas7kXxvSqqNyuuWPhiCl3hMVRb5uKOmnf2ZsuzyqYCr254raadjW0Nw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by LV3PR10MB7981.namprd10.prod.outlook.com (2603:10b6:408:21e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Mon, 16 Oct
 2023 10:43:01 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 10:43:00 +0000
Message-ID: <5adefd4e-d388-4c89-851b-a37f92d68e06@oracle.com>
Date:   Mon, 16 Oct 2023 11:42:54 +0100
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
 <046e8881-2fe4-45db-846e-99122d4dce86@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <046e8881-2fe4-45db-846e-99122d4dce86@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR06CA0140.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::45) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|LV3PR10MB7981:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f3e9254-7a23-44c5-441e-08dbce34aad5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HEhVaCaHjXhDoVb41AB04klvQuOYcSQKMpVDROTNG+S+xWkrgeyDbCm2IJC5XD8nmf47IiznLMMW610tZUxQEXhIuSPzD5VRO7hFZLMHa7AvWhakUaWj6OLCFPAcyoU7JDpciyun5lroGHdavR+G3/l9TBcTIwdEC8+9V8RrMjjIT+ilAREOpe2DXJccHcAyACuqQV5PEFFu5zpIf8xW2IS3ueiU8b3GZKfm//SPzc82fSDtlg0RvkWCNhB3xRFBA8S6lBTZqOqUvnOr9OagieO4j80BRw1+HtTgIDXh3zlrg7Qa0+RsO9aRxjzmgJDsZTW+58IbAh8vZNWaz4fkvj3Q4HwwzKufclOBgxupoYOan+88f5MnE+VpajS0fudNdwSjdMBA5GFwZzJeC4rhS37f6Pj9UZuE6dXU06OsJxSZBMuFAJjjLCcDvMVtmrQ0dlCg8ft9iE+ynPoUE4dOWBVEDkx57+2rF6eJpp6A9L1G8a8S8CxmAe+meBoqrQPPl+5penK8xlCIuUcoo1dNOxPiu4L9oWmrxp2gRccR7N7pZ0LNgBkduyWn8f8IE5up77YOMqz8kMotzQf15OTUf+2Pq6GvHvnTHdg+netR/4ot73RFPeuh58Q1mu1KtI97Y92q0ybSSms+xVRHvV0Q9MtQMtp1HzB5dmdBtiXaj4A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(396003)(376002)(346002)(366004)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(316002)(66946007)(54906003)(66476007)(66556008)(26005)(36756003)(53546011)(83380400001)(2616005)(6512007)(38100700002)(86362001)(31696002)(478600001)(6486002)(6666004)(6506007)(41300700001)(5660300002)(7416002)(31686004)(2906002)(8676002)(4326008)(8936002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0Faa05aRFkrSTdraFFyTzd1cDRhbHpjRUd3OEd0TWdrKzJjVGgwUVZ5ZTNQ?=
 =?utf-8?B?ekk3ZHVidDZqQWZ1RlJpbGpEUjkySGR3Z3NtZEFJbFNvU3JvRFlwY2FqMTBR?=
 =?utf-8?B?UDR3cHhUZmljTGozbHNUVnJFaFVkWHdkQ3lWMmhsK3VNUU9tcWROQmRsWGJ5?=
 =?utf-8?B?TzBzOGVjRHFXR01NQ0RDVkozYzRtZ0ppOUxYZ0o1SzJpVTR5SVNQSHhFNmFn?=
 =?utf-8?B?bEVmNmlVZW1wd3dBMCtKZVg2R0U0a1hhbjB5WjFpNlRDTlkxZWx1NzcydElO?=
 =?utf-8?B?TWZmOEtrc3NRdnhrYXZwc2QrcjBDSDNaZlVtYW95YTU0bGJCekwyM1d0Q1Yr?=
 =?utf-8?B?Z01xVkN4TDlid2ZOc3NDb05aamxDWmtrM0k2NHovSGJhZTcyanpTbHUxUENy?=
 =?utf-8?B?VHNITjViUjdTeXVIcnRwRnVDQkFJclBrR0ViVWpXcnBJTVNFcEJrUVZlUVBh?=
 =?utf-8?B?QktvNW55ZWFubm9paWxCOEZ2SWVGb2dzQWVyZ1VTUnJlaU5SRWo5aUJlcUt2?=
 =?utf-8?B?VkExVnpwMk9NdFIvZWZCWUx3VzE0ZkRYU0FTbFFFcThJdUV3TnhmaU1nQnYy?=
 =?utf-8?B?OGV5Um5WY0NpaDE2TmRyYWVJdzQ0dHFiR3FxRndvb3NKSXRtNU1IdW9uMXdW?=
 =?utf-8?B?ZnNVOEhKYkRaaXFQV0lHaEpkTzlmN0l2Q0hVSjVydy9sWWxxY0NxeDhndUlE?=
 =?utf-8?B?Y2dBbjZzaWlsN0Z3RnVZalVtRTJiSnlBdGlpcng0NEgwT05Tb0QyUi9BbDE2?=
 =?utf-8?B?VEN5SkxUOVhjRXRUbjhGOGNrdWZER2pBMzdacStKUytLdVJ4NXBZSnp3KzAy?=
 =?utf-8?B?ZnJaMURCa3pTWTViOVhXMUl5SHc1QlRiMUxqSE14N3B4V3N3YU50Y1VjeTA2?=
 =?utf-8?B?VFpDRGkzMnBOdkhWTmV0ckNJakRSTmVIYW5zY01PSmVzeHhGSUd5dmZjeUhm?=
 =?utf-8?B?bHJDcVpqSGMxZkpEWUphNU9CenNHTTBOVEliWkptaVhvZ0JNNzRMcXdZbmpG?=
 =?utf-8?B?bkVnVEE5UGdjdGVMeTZKelFycnBDeWNIM0llYkNrbnRQYUxvKzBJbXRncW1y?=
 =?utf-8?B?SXZwUkNnbFBpSEUxTW1MU3JjbGNBYkhyT3VsTldtQlRIR2E2cVFpUGh3ZEIz?=
 =?utf-8?B?cDJxcm1KQjFncXVUaUZhWDVXYVZyN1ZuNUtJYWRxdkg2RnRPWGIzb3MySUw2?=
 =?utf-8?B?SFZkUVhIczVZTkMwL1hmaGJLbGJ1SWk4T2drdXRKdFY3b25MTGR1MzdwT0xL?=
 =?utf-8?B?T1BhZjdkODdDWFJnUXhlaG0zd1ZnSDhYbEV0aHA0S2lNSEtFT2kxOWhrb2Mw?=
 =?utf-8?B?SXVvVGY4OVU4U1JFdW1rOURFcDVRMGlEMXg0MmxCOHBXaGkwOTVGNDhmR3Vk?=
 =?utf-8?B?MUJtOGN0emZKSGVYV2xkdjRlSk8wZlk3SEt3YjdhSVZiR1hBYnNaWVJDckYy?=
 =?utf-8?B?OUpITktMMnhwd012d203TDQrdS96KzA1OXVRWWgxWEVqci80WXBrZUNjamU1?=
 =?utf-8?B?TW1DU21TQ2ROa0l6bTJWYmZzMUQ2blhDSkJQa0dKL0VlNjNlNGNpb214Z3M5?=
 =?utf-8?B?amgvVnZsUEU1K0xxSDVpZmVraC8wbUxpOXpLMW9DdUJDRXVkeVRqb0wyQms1?=
 =?utf-8?B?S01TM2wwWERXeC84aEFDU21zTGNsWGRwVG1rOEJkK0tneUgrUnpwbTdBb3Jo?=
 =?utf-8?B?eU5ucFB0UEtlVHRtdjI3UHZ5bDV1VEJtd0IvajdidVFlMFdmczdLa2N3TjFh?=
 =?utf-8?B?ZHVVbFBSNnpKT3FrSkFuVUZMN25PTkVOdGtEL0lsWUhuR0RJVkRrU0dmOG9W?=
 =?utf-8?B?N1pXdVhFRjhqMjZtUU9UYkNJeXpYa2F1aDN2RWR3ZG96QnBwa3hBRkNneXRY?=
 =?utf-8?B?WUNrR1gxVG5ZSWZBLy9Kb0RScUwrZHhaUlB2TFFaNHNISGFxQUhkRjZSaUNo?=
 =?utf-8?B?eUpnNEhKV1NFRlNDT0JnaGtMYkd4WHdIbUl5czZsalBiMU00Mk1iNzZqdDEy?=
 =?utf-8?B?MzdtOWUrZU5qcTRLUGhGT0x3anlXdG1nQWFIN1VZYndZb0gxMGZWZ1RJL29y?=
 =?utf-8?B?Sk1VSlQybURtenhReUxBeGoxMXNib1U5ZWpTUVZrNm04WFdTbEVweHdEWEFZ?=
 =?utf-8?B?bW9qd1E3d0NPZko1SW9uL0kvai9uR0FkT2lKREwyOEx2akd5WkJET3RlMGRi?=
 =?utf-8?B?Q2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?OTkrcVZnTjgyc3JDWHlLMnZkRlRrZlRLaG5rQjJKNzhlRGpqRHoxUk9WNHZz?=
 =?utf-8?B?QkhySy9RT3NKd2YxVU9hTHhiaHFmbUtaejVTamtXKzAvNDc0eWNic1Q4T2J0?=
 =?utf-8?B?VlVBU3JUUTJ6V0xkWDJza2hjMWVTeFlrVi9tYWZubUZNaDRERzN6M2pQR0Iv?=
 =?utf-8?B?by9ISTY0YzRPMlhSVUFPdDBiZmx1cnBnWHpDaXZITVZGbDNVYVlHSDdMRnRv?=
 =?utf-8?B?ZWwyTFB0QmhCdk9qbks4VFl4Y0VUY3ozYnFzVi9kSWsrM3NEZUlHREtITVlM?=
 =?utf-8?B?eGFsV2ptYW9ubDNlcmswMDhTQmE2OWJ5OUpWa04wWFdqR2tBQUQrOExlVHd2?=
 =?utf-8?B?bVlHNnk3SHFUTEFXenY4clppNGhzeExETndqNERId1dDV255TTJrZkhzUlFP?=
 =?utf-8?B?eHVYdnNWRkV6cEd4c2lGWjNkd1dnd1RkTnAzSFNGRHVNdm41WUVVWVpWeGxR?=
 =?utf-8?B?L2pGTjhyZUtCeFhUQUpRNHR4MXBCVTBlS1FIWVJoK2cvMTlNZ3ZKd0ZtU0VF?=
 =?utf-8?B?WXZCbE9DaTBsQzBpYU8zRHNMY0R2R3R2bWljNEE3cjV1Q0dheC92d3ZnRTNr?=
 =?utf-8?B?MnpyQm80OWJ5QmFwZENvN1N5dTNEL21GUVhIaDFXeDI0NUdnME5RWWo3c0R4?=
 =?utf-8?B?YTg2UDkvQUJibFZGM3QvSXIwQ25naTZUQ1R6OGNodkdsbHFBRzVtc3pybjM0?=
 =?utf-8?B?ODBoVWI4MUNxMG9WbEVzLy9vNFVzanVSemJpejIxUGZZWFpvRUJZZ0dsN0tD?=
 =?utf-8?B?YXV4Z1VVeVR1d2JycTNzY096VEN1ZnFmdGIrUUlyc2NIN1ZTelFJVGllWVNh?=
 =?utf-8?B?cm4wSEZYajJkMjd5ZkFqc3hsNUUzSmQ1ZkdrUlFHZDdMQnRNUWlNUWI3THlS?=
 =?utf-8?B?UitpV1dNaHdaYWF1R0FXcUVjSnZDRDNkdlg5Mkl1QkpXa2JTSzQ4b1IyekNU?=
 =?utf-8?B?b0tHVWEzbHF0NUo1L1NOWnRZNm52a0hJM0c1WnIwbEx2QWhNMnJjQktadVE5?=
 =?utf-8?B?cDk4dFEreEpFVGtTUHAycGlwOVk2WjFCdmxLWWRCN2U5T2QzbmNVdmk5Zmkw?=
 =?utf-8?B?alQ2NUpnckcwMHZkendiQ3dPczNEa2FvY0YwTWZzcWRxMnp3c2FwSktoNjBS?=
 =?utf-8?B?bys4eUZITFFXZ2djUFgyWFNHZk50OVF0R014c2paWHFTcWs4QUNjRHhSQ3By?=
 =?utf-8?B?WDdTM25udUc5VE84S2JFTzBXZmx3dEh6bDJVd1pLVVRsalBjb0FvQVlIVGls?=
 =?utf-8?B?NEt0S0ZBeGxpZy9pWnNLZFZtazRMRWNPT0J5NGY4WHdQQ1h5OEorMXJ1TC9p?=
 =?utf-8?B?NFJwS2dUYllVckgvK2p6MHBDTDJtM2d3N3YyQkN1ZVNKQm5XUk9zYlM3K05m?=
 =?utf-8?B?NmtMU2ZobVVNN3dRZzMyWjVTL0NnVWNlOHFuYnMzNmZONk1oeVpvUUpFeUdv?=
 =?utf-8?Q?pYy47gNR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f3e9254-7a23-44c5-441e-08dbce34aad5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 10:43:00.4824
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ob8klmAKFuTu+V++g4vCxz+9oAvzr2+/FoZ+I+rVkPeAq3xMc+k0nvY6MoOz1nCkXksFI2LyPZGRFDG4bxyhs4vjp1BUnijv38muPvh/Wr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7981
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_03,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310160094
X-Proofpoint-ORIG-GUID: dKmX3WwnydSJLoj7WT9yT4Z8MKYrB8vi
X-Proofpoint-GUID: dKmX3WwnydSJLoj7WT9yT4Z8MKYrB8vi
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16/10/2023 01:51, Baolu Lu wrote:
> On 9/23/23 9:25 AM, Joao Martins wrote:
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -300,6 +300,7 @@ static int iommu_skip_te_disable;
>>   #define IDENTMAP_AZALIA        4
>>     const struct iommu_ops intel_iommu_ops;
>> +const struct iommu_dirty_ops intel_dirty_ops;
>>     static bool translation_pre_enabled(struct intel_iommu *iommu)
>>   {
>> @@ -4077,6 +4078,7 @@ static struct iommu_domain
>> *intel_iommu_domain_alloc(unsigned type)
>>   static struct iommu_domain *
>>   intel_iommu_domain_alloc_user(struct device *dev, u32 flags)
>>   {
>> +    bool enforce_dirty = (flags & IOMMU_HWPT_ALLOC_ENFORCE_DIRTY);
>>       struct iommu_domain *domain;
>>       struct intel_iommu *iommu;
>>   @@ -4087,9 +4089,15 @@ intel_iommu_domain_alloc_user(struct device *dev, u32
>> flags)
>>       if ((flags & IOMMU_HWPT_ALLOC_NEST_PARENT) && !ecap_nest(iommu->ecap))
>>           return ERR_PTR(-EOPNOTSUPP);
>>   +    if (enforce_dirty &&
>> +        !device_iommu_capable(dev, IOMMU_CAP_DIRTY))
>> +        return ERR_PTR(-EOPNOTSUPP);
>> +
>>       domain = iommu_domain_alloc(dev->bus);
>>       if (!domain)
>>           domain = ERR_PTR(-ENOMEM);
>> +    if (domain && enforce_dirty)
> 
> @domain can not be NULL here.
> 
True, it should be:

if (!IS_ERR(domain) && enforce_dirty)

>> +        domain->dirty_ops = &intel_dirty_ops;
>>       return domain;
>>   }
> 
> The VT-d driver always uses second level for a user domain translation.
> In order to avoid checks of "domain->use_first_level" in the callbacks,
> how about check it here and return failure if first level is used for
> user domain?
> 

I was told by Yi Y Sun offlist to have the first_level checked, because dirty
bit in first stage page table is always enabled (and cannot be toggled on/off).
I can remove it again; initially RFC didn't have it as it was failing in similar
way to how you suggest here. Not sure how to proceed?

> 
> [...]
>         domain = iommu_domain_alloc(dev->bus);
>         if (!domain)
>                 return ERR_PTR(-ENOMEM);
> 
>         if (enforce_dirty) {
>                 if (to_dmar_domain(domain)->use_first_level) {
>                         iommu_domain_free(domain);
>                         return ERR_PTR(-EOPNOTSUPP);
>                 }
>                 domain->dirty_ops = &intel_dirty_ops;
>         }
> 
>         return domain;
> 

Should I fail on first level pagetable dirty enforcement, certainly will adopt
the above (and remove the sucessfully return on first_level set_dirty_tracking)

>>   @@ -4367,6 +4375,9 @@ static bool intel_iommu_capable(struct device *dev,
>> enum iommu_cap cap)
>>           return dmar_platform_optin();
>>       case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
>>           return ecap_sc_support(info->iommu->ecap);
>> +    case IOMMU_CAP_DIRTY:
>> +        return sm_supported(info->iommu) &&
>> +            ecap_slads(info->iommu->ecap);
> 
> Above appears several times in this patch. Is it possible to define it
> as a macro?
> 
Yeap, for sure much cleaner indeed.

> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
> index bccd44db3316..379e141bbb28 100644
> --- a/drivers/iommu/intel/iommu.h
> +++ b/drivers/iommu/intel/iommu.h
> @@ -542,6 +542,8 @@ enum {
>  #define sm_supported(iommu)    (intel_iommu_sm && ecap_smts((iommu)->ecap))
>  #define pasid_supported(iommu) (sm_supported(iommu) &&                 \
>                                  ecap_pasid((iommu)->ecap))
> +#define slads_supported(iommu) (sm_supported(iommu) &&                 \
> +                                ecap_slads((iommu)->ecap))
> 
Yeap.

>>       default:
>>           return false;
>>       }
> 
> Best regards,
> baolu
