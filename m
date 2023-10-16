Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4097CB2FE
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 20:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbjJPSu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 14:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbjJPSu4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 14:50:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5412AEB
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 11:50:54 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GIECIT006708;
        Mon, 16 Oct 2023 18:50:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=tS5fFVWZBY+RjXSBDhGtg0Lj2m5Lvtt3auon5A7wvGw=;
 b=qD3g/stW4ZD1OIg+RYAIpxIYIg8RsudNk2ZHFp3opoaijTijWIHuN1b39v/i3Shzhnsw
 qRCvV4hhDXBkq1tWn3TOkaB/TllWqQqYyDJN4L0Gtu9jJIoDC087CUm4hQMAvwiPC8bK
 pdrV4t/xgJjYQNnbwUu2nOIkBimdqFcvxLk0L9rClf4kLx6Au/xyFCxsCCVDvjVnKeo4
 mMFaJokEWz8ypnLNNe912pkeB61Yz+mVRx4kBk0fhpsBnAWP2A22AaavITQd/JDuTZG0
 NqmxY6xByYiTFXMH82PM5tWCCRNhYXmujCGa+Gt3gzYQQ3xWHMDCbKQeUVjuWLGtWBzC sQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjynbgey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 18:50:34 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GIOF36009572;
        Mon, 16 Oct 2023 18:50:33 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0ksdc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 18:50:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xbu7rqjDf9dqiCWdtq/xc+5VuB/gWPYGIt0n4ruEWv7WzzB7FHiPqm80ZUBjWfCIkT0X8fxr+mBP8hymhG89vGCq5gGg/myBaJ+G+5+X1oEm4wBcCoh3eA+vJNgBvUQs3wmoIGxBrYyikZQ+1L7sx7sTAKoM9vPcUysdiwbVpm3fTIHHDHHxrlGmHVdEjKPyWZBN2l96Zs3TdMmMze9Npt6MVdb74hzlifjexcUfsApMxK8pVoF22j3JgFEdfQmutJY9iClbwKCsFDB+fT6tDl8KHK3iQrEYQ2dqbsp4gQ6WsnyrlSFotAtMn7bZeCvUVcVtq0YEkHHRbu0CBmGnyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tS5fFVWZBY+RjXSBDhGtg0Lj2m5Lvtt3auon5A7wvGw=;
 b=jxg7JPMJVGX7RDWfe/BeJjDxgGjC2JUEXaUPLvvuref3a4L1z21SGkJw+IdXPq/FHeh9l2lZtT+hAu+4LWM/JP8x65/kcdJbZykeksdI6tHHAy+jCV5IluIVRKLjscuployGvvtnd6Bqz5moRqdUlbLghuTXnImQARVte0zub/nhYfWeJjGkiiwbqD+9zuvY/LxZT+xNDHLiHNxgwj8tPZhdysJ4EJe1h1AdWCcOXZ3Vnhk3WTTarGAT8dW5e02Zj8aFdjmVIh0EFIsrweFKIEtY6+IX6qqntfYzDSO4FM9BDoMIfa3x18o8GVxRYdr0teH+DJmAHqARXojaZ4EW4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tS5fFVWZBY+RjXSBDhGtg0Lj2m5Lvtt3auon5A7wvGw=;
 b=aS6CrWQ0009AzCy3A6k2UH+JctY7dJWNJXlRYuG4aWeAbGEQhmJqCwlW5E19nHS/SwupFZ2pCX7jvMP1sMQTQCVt0odbZ+YDaP4EsOCwrk0aJ730frfyW9vhgQ7i/U+4GmwUnnmxqf5Ev4l7YuqKygDYptszsQWo8RXPvhurKoo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BY5PR10MB4195.namprd10.prod.outlook.com (2603:10b6:a03:201::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Mon, 16 Oct
 2023 18:50:31 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 18:50:30 +0000
Message-ID: <8b1ff738-6b0d-4095-82a8-206dcaba9ea4@oracle.com>
Date:   Mon, 16 Oct 2023 19:50:25 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
References: <77579409-c318-4bba-8503-637f4653c220@oracle.com>
 <20231013144116.32c2c101.alex.williamson@redhat.com>
 <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
 <20231013155134.6180386e.alex.williamson@redhat.com>
 <20231014000220.GK3952@nvidia.com>
 <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
 <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
 <20231016180556.GW3952@nvidia.com>
 <97718661-c892-4cbf-b998-cadd393bdf47@oracle.com>
 <20231016182049.GX3952@nvidia.com>
 <6cd99e9b-46d9-47ce-a5d2-d5808b38d946@oracle.com>
In-Reply-To: <6cd99e9b-46d9-47ce-a5d2-d5808b38d946@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0245.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::16) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BY5PR10MB4195:EE_
X-MS-Office365-Filtering-Correlation-Id: 295894e4-a78c-427d-81e2-08dbce78c563
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mao/Hhg7BRdlr24XTwlgmMnCXnq9Zix9MAXafZjpKDELfbN+2DQdEUanYIEHeWo4IrhveVAW3WQ2M+SxlamTDYwYkdhzY/h7MaYLzK7P2+NfGANKigGET7L8hbt6n3ymKqQnZjYna00cr4WfeANQc9FZIcshnyOX1IoX7CaDuvzB5w3HJDIthRHNmpNrtkVRLQaXmuw2l5841eCoXWKiD9MpYgBRalLCHOm845RAmbSjmhb4C+XUL4E7AfjPiPHyvIDKIl3Cx72CMsQSWsqYB/W4sM7OK3NhRIwwq/QDQdfoYZpA4noLzbIkw433aETV/PSupE/eFp6IxphZwxoztFnZtqUqQ89C7YoFqD6Cd0p/PPc78G6ybuUYPdfUvtm2ZKspD+cpKy9sXww1GcJzamNORhGx6lsVl12I13zGW23vbr6ow9keIOci6Nk80FNGz5Aex0eVOEELj8GT5BpLcSKPgyNtcbKjDQPmIgY77Tu22Kj0qSboKuSHoM1HoZgeE23/7VRnKrdiF/Drvshcmj5OQAU/agTeqHClAA4PYv1ssAYeC8lfS/3ObdxGEam5xUoAYj0wHmbI3Ej9teQLnmtJXUR66l23EpIDXoloWaKz28VV/GubQiSSpuHBOqxSUcGs5Uiv3YnR7yl80PEtJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(39860400002)(136003)(366004)(346002)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(6506007)(2616005)(53546011)(26005)(6666004)(6512007)(83380400001)(5660300002)(4744005)(8936002)(316002)(66946007)(7416002)(478600001)(8676002)(4326008)(54906003)(66476007)(6916009)(6486002)(41300700001)(66556008)(36756003)(86362001)(38100700002)(2906002)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlVtcU44NXpodWZZd2F4YkZPVmV3RGdEWHM0TFQvbU9GcUFJS21obHkvSjUr?=
 =?utf-8?B?UnRvVlNQU1VJdkx4bWpFQ2FSZ3RqczEzaW5QWlo3WUZXQjlDbTVFclh5RUwx?=
 =?utf-8?B?eXFkSUV1NHo1c283V2RzTDZITFFrQ2lqQnJ0STlFTmpYKzRwYkhQTHJmV1kr?=
 =?utf-8?B?OGwxV2ZYeE9MSVFWdzlNYTJra1FCL2Y2dWpjaDRNU280dGMrSm04d0NrYURs?=
 =?utf-8?B?QmtLcDJZK2lqOGFpRFQ2ZStJQU5xWksxNmoyWm1RaFlNQ0RpMEpVOUhZYVds?=
 =?utf-8?B?QTBqMGJ2cldYNk1QYXNUTFlBSVVQVDBJaS8xMllwWVN1aE1pcWVzNDRMdFdn?=
 =?utf-8?B?dmJ4ckpyd0ZEVmlpQldMNW9pLzlHWG10QjdRMUJ6aW90S3dtTjVXT3N5S1RH?=
 =?utf-8?B?ODRZYVVZOWoxOVdWeUdSK2Z5d3F2QUtneUNrUkFPKzVBODY2YVJuaEsxOU5O?=
 =?utf-8?B?RE40YXZzbVNqU0E1ZnRObFBnNjBiam5MazNLU1VBTlY4bGQ2Tmx3ZGhsOW8r?=
 =?utf-8?B?bVVCdTZmVjVlaUhVckxmcGRXVEhPamV3M3FSSWxEbm1RV0lTbnc2WXlIdE05?=
 =?utf-8?B?endEcmJaN3dLVlJWQjYrNEE0OVZyYndNOXpyamw3bTBRanFpcG9JRUplNVdN?=
 =?utf-8?B?WC9PSm4wSEhZamFVMDhOSzM3ZWtTNmlOOTRaaXo1NFhqNE1pTmd4YVpRZHdE?=
 =?utf-8?B?SnJRM0xnTU42bjM2QnR3UmlEZWYvbmNoS1k4N2wrc2g0bTZrVW41MzQ4cHdm?=
 =?utf-8?B?TUxnZDNISjQ0QS9ncWwwR09qdHpRTUtsNEtsNHJKNzNIL1dZM3hqajQ5Uk1T?=
 =?utf-8?B?cFVWL1hUcWtOODBaV05CMjk5WkxLenhRL2RUbHJGUmM4cHo1eEJuZW5MOGF5?=
 =?utf-8?B?dW0rWTNlZXZRWlQ2SDNQRTVVdG1TVmY0ZGtnVThwbXc4WDV1NnNXTGN5ZERx?=
 =?utf-8?B?RmcwYm5aKzNKUTllejY4MXlrTndaRUljY3FGT1NlWlRKNk81Q2xXU2VmMDNM?=
 =?utf-8?B?c0J1eWtzYTN5dFI5ZTE2VHk2SVBKV0hMcmZVUmwvdGg4WU9MQ2xsMURaYU5s?=
 =?utf-8?B?K3VGOVVCN1BaTk9BOWkvbFNvMlJFMmo5cFpJazgwTFkzb1BpTU1VSVNZcDBs?=
 =?utf-8?B?RGU5QndmbWVUNFlwcnlFOW5JeitOM09ENlIzenZLZkhvRGZvWlhLS3JrRkxx?=
 =?utf-8?B?TkErc2h6b1U0UTRxK05wRkhVVjNOVFE1a2kybzdUeEhLbmw2WWhYNStuZ1dT?=
 =?utf-8?B?djdULzRWZTZHdjU1Vm5UTmRjaEwyZzlCMTVtZ1duZGxpNGlJQkNlWXpoTFR0?=
 =?utf-8?B?NXF6TFdTa3d0Ti9NSnR3TU83ZitZUndKdVEvWjJzR2IyVjNpWmMvanFobDE4?=
 =?utf-8?B?LzRvd2N3VTgyMXNMOFNvdnZtZXB1eUdIbnR0eStKOTJLaXhpOHNzRXFxNmRl?=
 =?utf-8?B?MC9PeXJhYlFDSjFQbHlObUcxa2d3MHR4MUxmN3hqZzl6Tnl1Ym9nRXNYUWJ6?=
 =?utf-8?B?VXZ1anA1MGpNMHFybFBFNk5pWGM3OGdkS0g1L0lRMGsxcUpkVHQyR2JCNTdt?=
 =?utf-8?B?MUdqV2xFOElHazFhSFc2azBWZ2VXSTZJUHhOUWJjeldtS2RsLzBObnM2ZUYv?=
 =?utf-8?B?K2R6OGNmbWJPZjhZczFSM2d4MXF5MFJnVDlueFZLdnk1V2Z0eTNSVENaSmNV?=
 =?utf-8?B?UG5PUXdFRlJCbnlOQXROT1NiOE9KcE5sR3poUlVvbkF2VVlGeUo4ZnZvdmRL?=
 =?utf-8?B?NUtJVXNFc3U2QzFDSmZNeG43bXdGMnpCQU5UOUp6UlRQa1Vqem50bWp4Z2pj?=
 =?utf-8?B?MmNrdW4yclYzVzJyajJTR1B3NmRMNXBIVjF2VCtkcWhHZTB5ZDB2dForbDgw?=
 =?utf-8?B?OWRTeFBPL2k1SWtzR3VIWHpzdkJ1Y1JWT3lqRWIrZGJsTWd4YjcyRG9xem1p?=
 =?utf-8?B?bXJqUjM3WWxpSHJvR0QxSmppRWZ0bC94TWlkQTNWUnZHQVdieTJvcCtqMFdn?=
 =?utf-8?B?VzFiMWlLZTU4Wms1am5MRGEzSzQxN2VzdFN2VklFbktrQ1NRT09KdXozWEs0?=
 =?utf-8?B?T1pLdlF5VHIrOVdLZzA3dk9EanBaUEduY3FkckJESjhmQUZEeHpCU2FYemtr?=
 =?utf-8?B?dFYzcXBkNmRvS2xVUVRhMURsQWFMWVVLaHZjQVI2L1lhUm44cU9pdkE0dk9k?=
 =?utf-8?B?TGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RFlTcGVIbFgyZnJwb1pSMnZSZ2kvb25ockkwOGR5ckNxVklJdCtxbllQOC9Q?=
 =?utf-8?B?RkRjVzhiNGl6bE16SlpSZ3RQdGtUR09MTEpIdFpBcmU2RjJPcDF3YkJIaFA2?=
 =?utf-8?B?UlczT256bjNsci82OUQ3ZUFLNWVMNk83NFVjZVRpK0NqWUVEK1VaVk15eWVr?=
 =?utf-8?B?bXFZZjRMaHd1QVBQem1OS2N3djN0M0hzRE45QmwyV0toQkYzVEhIbjB5bUI4?=
 =?utf-8?B?V0lxcFNUbzBMcVZ1N3NucDROaWVTSHlXM1ZhOW9DYjZjU0k3ZDFERXdhajNK?=
 =?utf-8?B?MEZRSnZ6cWNrdlFFTnhIOUgyRm5BWGR0QkRDSTZueGxOSHJKTzdRaXVQbmI2?=
 =?utf-8?B?akhKcXR6MFJzbmJYSzVWNGYvWTRneGwydHZNaXc5S1l5VVNZNUhzS1BmOXRi?=
 =?utf-8?B?bXZYNEEvbkNQdkVibXlhTGFQR0JxWC9TYUE4bXo4Rms1SzFSa0o3T2FhbVQz?=
 =?utf-8?B?cjFqaEhvYm1DdjdaYklYVFJuR0tja3pHM0duRXhZV1J0YTdJSHFCZXhVV3k1?=
 =?utf-8?B?N3d5TU4zTmQxMXo0M1Y4Y1dYazdRbkVsakQwTkczMmx6d2tKSkNnSXp3ZUhD?=
 =?utf-8?B?Yzl1U2RwbEp4MjdwV1VsZDFJQ3NEZ1lPVUt3eFM3MWpRMUNxaGFwMVI1T1pL?=
 =?utf-8?B?czBqVGp4bXdBTVNhOUlDeSsvdnllemVCKzZDdkhURjZFc1lsckUvVUtBYk1V?=
 =?utf-8?B?MVI2MUcxMVZCMklGQnFWcjN2N042VWFacWVlV3AyNzRhYUF6R214S21xdGtY?=
 =?utf-8?B?anNOdGNhenVGY21hZHRRaWZYbkpSTHFIR3g5d1FCV3p0QS9HQWpoaDZtVUs4?=
 =?utf-8?B?bW55WGNYNVBnSzhxSFVsNWcza2tkdjRZZVpmcWdNd08vSEFNcG80aDBrOFZv?=
 =?utf-8?B?bXB3ZGVjd0M5ODQ4amRNaENlaDN6WloxaFN2S3JCQnVJbXlqUEFRR2xmUS9L?=
 =?utf-8?B?MUFPWXNVRVUrSEFncFZRRVo1bnNWaGEvQk9zUzl4YlhBcEg5ZlI0ZnowdGpw?=
 =?utf-8?B?SDVlQnBRRTJhQnBoQU5qbGpaMEprMXZUZDdHdjFqTldMQUk2UTdGK1YzRUpX?=
 =?utf-8?B?cUhPZU1vTktjSFdDMnlnNXBDRHR4a21kMFQ5TjU1UG5STzZOcFpRMVRvZnRi?=
 =?utf-8?B?N3F6am4xTDRzd3h4Q2xFRHZDd3djbGMxcW8ya3M4WGdxTklvSW1SNW5aRGlq?=
 =?utf-8?B?cVV2WWRVREMwWkliKzZUVms2Q2Z2cy81dSt3aWNzK0hQVW9CendRUDlYOHpN?=
 =?utf-8?B?Y3BzdUNYWDZZKytHYmNUWERBc0NpRDNJL1NFYmdUTXpIaGt1WGxPYkxSZklH?=
 =?utf-8?B?STdLcjhrbCtvVGw3ZmpldkdJNitFajIvZXRyOVFCTGV0UnVRMC9uanZORjJI?=
 =?utf-8?B?N1pFRjYzb2doR2QyWjFLelR4MVEwTnRJNUFoWGdmQW1jNUlrdWwzaGVQQ1Mr?=
 =?utf-8?Q?NG5CEcDX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 295894e4-a78c-427d-81e2-08dbce78c563
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 18:50:30.8682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c029Dn2VkG8ldpmNgX+SqwIr6Aakd6haDSP4iTdB+Tr0k/wPK6UvKW2zFms+FhFOxLCJ94U3HErae+Z2ik5RtrpLLJsL2ClM/hs93VAqXkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4195
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_10,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310160164
X-Proofpoint-GUID: PwkyHMcZvMg78VAfYSV9zaX55RT25Cqe
X-Proofpoint-ORIG-GUID: PwkyHMcZvMg78VAfYSV9zaX55RT25Cqe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2023 19:37, Joao Martins wrote:
> On 16/10/2023 19:20, Jason Gunthorpe wrote:
>> On Mon, Oct 16, 2023 at 07:15:10PM +0100, Joao Martins wrote:
>>
>>> Here's a diff, naturally AMD/Intel kconfigs would get a select IOMMUFD_DRIVER as
>>> well later in the series
>>
>> It looks OK, the IS_ENABLES are probably overkill once you have
>> changed the .h file, just saves a few code bytes, not sure we care?
> 
> I can remove them

Additionally, I don't think I can use the symbol namespace for IOMMUFD, as
iova-bitmap can be build builtin with a module iommufd, otherwise we get into
errors like this:

ERROR: modpost: module iommufd uses symbol iova_bitmap_for_each from namespace
IOMMUFD, but does not import it.
ERROR: modpost: module iommufd uses symbol iova_bitmap_free from namespace
IOMMUFD, but does not import it.
ERROR: modpost: module iommufd uses symbol iova_bitmap_alloc from namespace
IOMMUFD, but does not import it.
