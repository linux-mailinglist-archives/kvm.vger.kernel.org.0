Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3227CC10F
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 12:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbjJQKv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 06:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbjJQKv4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 06:51:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE77EA
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 03:51:54 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39H9hctL014534;
        Tue, 17 Oct 2023 10:51:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=MGLQsMS55NIi7ugc7SDFVbyDQy8ZQxA4AYS6heIoWBg=;
 b=UOpgZDbYRW6yydcyTdSRbu9DoYVPnCbt0usMVdMnpFlrV3UqNqieEYXHAV7dT7HJVe38
 FXCkFyFk++i/Snv6Kh7+sOA3wkVdxsJ9sdP4B8OJqV7T4cogIT24IMqKlkAL6RPZZc1O
 WKIwfwyOY2mnDi8xGuFTHL6sffCV1JrJoBDq5jbrucps9bwDV2BY/ynLSvcf+l4qnX3P
 61ODP9jIG+6Zynl7KUdqh+WQ3oxEjxGSfG7LblIU8o8d8YpS8jptVDKN2zsdtQzR7oMz
 eUvP+PJXSpGBJGI76ADa/QVbzQmvWE2tfRsOjD2cEiESdhdcLOGZF+B/Umox/fi0g0aR sg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqkhu4ujg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 10:51:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39H9s7fS040509;
        Tue, 17 Oct 2023 10:51:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trfym4as3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 10:51:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LS7LFd6PN7nVhOgC9pVjPPUoAzb8gWaiE30l+2VlkVl2DhmCXYbDHhCgAFufCf/fpMlY1Uac7FbMkQlLT8CZcZ7uM3HVWX3xKt5hadyI0C2xXVpM3mugMap7uqfuFsiJuDkkckgbIx7tUGz8KXlXPR2Bq45bgdypMNIaYNPPXgCyoVx6k+s5RpRS3sI/ZPtymleYY+kwAxn0BVMC4HCbtRofOxtT6wnVnaLFBw4vKliWcKx4Cb2esgPYGhAdVUrsMS8tAvuI+kcU9M4PaxHn67lXmAm0KOOEu5BI11s07WCqSg4+lelgNsDBchAhvNj1gNVOJAMY3sqHRs2EkflZ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGLQsMS55NIi7ugc7SDFVbyDQy8ZQxA4AYS6heIoWBg=;
 b=Z8s9HfO+L9eFtTZshGMciTDevhNUv+5mLwd8YcvqELkNV7et2vUkOAzmMj9nxELiJsJ9NUkLtXM7DgBz486pkNxrMiFTRxk9h99lQ27LlZG96eNF3pDKp8OYs04IYvuDRkR3bsXb0z1QU5+2nKFsTUCTrw6Ivujnraf+f1LCSTwvTiLdmw6jDvX1Iv4XQPNiy2uWB1p3RdKi/QNHVchhDLtU7W1o3O0cdiGA3Jut5epgORQSu2IASW634D5Y09d1Zs3UB6ENIBPWz0P/+p/dRC7mvXiPO4qEpv8ye9bJuEvTwB4ZO2gUSRd1/YY166v7PpxnyW1jstjRbfu7vmAysw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGLQsMS55NIi7ugc7SDFVbyDQy8ZQxA4AYS6heIoWBg=;
 b=gXm66MOW8NzgOKRmLO1xwMNklDCIFX3yQHJHRzkXxA8WLwf8jK3UPO63jy7rcjPpeqoEhUIsqTAJM50yg8Y900uupdja7v5lZDwGW/3A4aNrkNeiehZHR2ib/mGNrlgPaz+HUaHmr/ZH3xP9UWvVZqCfZAnt+8vPHFpOGFqEjr4=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SJ0PR10MB6350.namprd10.prod.outlook.com (2603:10b6:a03:478::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.46; Tue, 17 Oct
 2023 10:51:19 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 10:51:19 +0000
Message-ID: <4cc0c4a0-3c00-4b29-a43b-ddfc57f2e4c0@oracle.com>
Date:   Tue, 17 Oct 2023 11:51:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
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
 <c4816f4b-3fde-4adb-901f-4d568a4fd95a@linux.intel.com>
 <764f159d-a19c-4a1d-86a6-a2791ff21e10@oracle.com>
 <20231016114210.GM3952@nvidia.com>
 <037d2917-51a2-acae-dc06-65940a054880@linux.intel.com>
 <20231016125941.GT3952@nvidia.com>
 <3e30e72a-c1c6-55a6-8e52-6a6250d2d8de@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <3e30e72a-c1c6-55a6-8e52-6a6250d2d8de@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0213.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::33) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SJ0PR10MB6350:EE_
X-MS-Office365-Filtering-Correlation-Id: 45d4c5f0-a382-41de-b9a5-08dbcefefe7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MvmUQrsDMm1tzoBJPZnTw12GBzXuqAGmqtY/SO/J1nc5dKbWpiwLQRWjHlalIVsNJSlBTx0MpOMreR/dE8rkjI9NF2AZ6U7c/651sg0mY6sxLXiBH9CHr1AOYh2BUsgTeK7KHBEBTPmP4dhhPBnktTBYJa/byBeubLESulw1P4K4D2WZHcmPHFTC/s1gPjU8FIxULIuDnJTa2Kk4+9JKe83+0ZFoHIdWUgTlzG9HxajaZwyH5zI/7siqqqWcJtiFsc/hrr28DnlehxOtfetJJwfRzGCvc423g59zCk5QE8VbIm10aUM/KD123q9MVbusavIHsQKs0o9tcfmofzD920BQWKaSSq3EYU3D8rIWczsuTsaeuGeF5VrvbMgJekgC4spdB3kr5hJ8RsZceo4cSjY6ZjgyE7bK+j7OLRIo9kLVGK/aS7F5C6MX0Dz6SbBCuh6Nrc8eiVCHQLRpuqZqJ6I8uXwuoTS59EUrfIs+hOCimG7NyRAssS41lIazcAuvcEj49ecQ/SC3uWN9Dk+5aCcAz6PcWrXg1Yca8Y9HWQ19cRGtd5A8T5npgQfEtg+pLp+Y7bD/vWao7bksIjcng9t0R4NdIv2CuJ8ng5nEVWyD30Sz6Ue+1JDF4DoVs2If4XX/NzDZuWON7ckvZiOKxWT2xwPX9u/fzg56swtRkug=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(39860400002)(346002)(376002)(136003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(6486002)(53546011)(478600001)(6512007)(6666004)(6506007)(83380400001)(26005)(7416002)(2906002)(54906003)(2616005)(41300700001)(4326008)(110136005)(5660300002)(8936002)(8676002)(66476007)(316002)(66946007)(86362001)(31696002)(36756003)(38100700002)(66556008)(31686004)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cS8yMW1xOUJ6R1JQSkFMbWxSQWpQTXZGOHBmeUpSQXVtRVZtWlQrbVc0MnFS?=
 =?utf-8?B?aUREak96blhabG9nRXhzajh0Sk1pNHhJSVFTNlFQOXJMNWo3MEhmdnJub0hP?=
 =?utf-8?B?MWg2cktxQzZkY3lpdHBuMGZhL25qSEhpb0szRS93OUlmVUxKQjkwME0yVGFp?=
 =?utf-8?B?YTNSWkU1SWJYc1MxY0lKOW1ER004RnlPY0JpcmJ0dVdPeGFvcmJXQ3Y4V1Av?=
 =?utf-8?B?YThJeDdzclBab1BkTmc2RDNFaktPbzdpZXBMUTRLd2RYdVVsSXFmMTdHbUZ6?=
 =?utf-8?B?RTRub2VjWGM2RXg5NGtGTmE4aUZDaC9LNG96ays5Nkl0QjZMWDkza0xoZmRD?=
 =?utf-8?B?YUJnUVR3ZE9oanFuV0RnUFBjUUZJdnhLNEs0eFJZbGFiUWRWUEhVQ3FPMkVU?=
 =?utf-8?B?blZ4RDUwdTdDQWhhOTF6UUNTMm5VOGx2MjJEYStnSE9ubSthSUF1aHlMS3hx?=
 =?utf-8?B?YkllUTRMbExoYnRpM0NraEZEK0JuM0ZBS21XNlg4a3F5RTNQRDE5MEYya3lE?=
 =?utf-8?B?MndXaGd1T2h6Y2FheXViTDlXV0FWOXo3RzQ0T2JFUkZkbWg4Zy9PUDdka2Rq?=
 =?utf-8?B?N2dMOGVkeEpIMWM5Nnpsc3hOMHRObmE3aDdGb1RTRzI3dFpWZzFIdWh2eW9L?=
 =?utf-8?B?Vnhya25JaFhBUGRzT1Q2TmoxKzJKWng2bjdZZDBnckRwZjlYeXRJc2FJWFdt?=
 =?utf-8?B?TW5MNHhNcUZSYWFEbjg0TGh0b3Rhc1lHRU44MWMwdFBZYlp6UjMrUTJyVnMz?=
 =?utf-8?B?bzhHbGh1ZCtEYkpQWlZqVEdrOVMxY2Y5Y3g2c3pXOE5HSUswdStveGZKNW5Y?=
 =?utf-8?B?YjNkUTBuWExFVS9oL05XTU5TSDc2Q0VKVVZhWnY3Y3VOdGpsak1XUC9wUUFx?=
 =?utf-8?B?UCttcmxIVm5wNFh4SGVsa0dFSkIvcTRQWlhqaGtyMCsrZjlmMmxYVVh6VzA5?=
 =?utf-8?B?YytCVEJNNDN6OFlGaGo0MUdqK1RZem03YU9kRWxXcFNycjZaRUlZYlh6NUM5?=
 =?utf-8?B?Z0pBNVBCcDcxWjJtMUNjdlR3aFpVaFZmandqcE5aTlFIcTlKWFVBaHJkWnRt?=
 =?utf-8?B?Y3BaditxOUNlWW40MG9RWlhVUWhWd21DUUdMZmkvVWF2UnFucVpDS1NTT2th?=
 =?utf-8?B?SDh4N0x4YktpQWlkVVZKaloxN29NMUMydjlZanZXejczN24zNnpnSzVzZzVk?=
 =?utf-8?B?RXNjclJVZUkvOWNvaHFxekVCR2U0WnhpUlh0bnc0a2hXNGdKYjBsY0JWc3RB?=
 =?utf-8?B?Vm8rdWJ1dlNQZmFMRmpHQlVyTCtIbEd4KzJ4ZG5LVmd4U3ZTTGtiL1RYMGZX?=
 =?utf-8?B?S21NWXdhRHlVcDUvelJmR2xrelUveDFlaFZHRXU4d3dwak9tVEhTcFU1Rnpn?=
 =?utf-8?B?L3VJSlVYbnRneWY4Y2NoYlhPSnVTZEhTWDVWQ1FZMG5UWk13OFBxenFFYkZL?=
 =?utf-8?B?WWFKWEpyTEdlcmlUUDNlRUlzcW5iUHNMWGxCdi9GWkd1T3IrYVRaWXJmL2Mx?=
 =?utf-8?B?THM1R2w4dzAvQTgyeFo1SkFJa1ZhRlhvSVZPRXJ0U3RYc3ZLVWRibGFmTm9R?=
 =?utf-8?B?NEZCTVgxelNLeDZHSDd1bWRlQXFPUEdjeTNrMkJ0R2xwTTJ1NnlRa1pFYzNh?=
 =?utf-8?B?RnhOR3NGdjdpZlNncFVSMmUvMno2cEN1S0N2VEVyVGtYcDJVR2gwSlF2c2kz?=
 =?utf-8?B?Z0ZOUHBybDY3TGNYcDJ5OVVEUFhROWFWRGtESUNCV3daOWJYM0RCbGt2ZXlS?=
 =?utf-8?B?eTV6WkMwcUF3RVBnUmtYYlBWS2IxRWxWd09RSFNHVzIvblh3VGRPQ0FHUEtW?=
 =?utf-8?B?YXRKNXBPQVRISTE3eU9XcHhsVTZoQTdLd0FnQk9aR2JLZVFRUWpKNFh1eU8y?=
 =?utf-8?B?MS81bitraVgxb243eE1sZnE0OUFNcmFXZlNPbGYzMm5TeEZsNG5yYTgwMk52?=
 =?utf-8?B?ejRhbE1PL1ZRWituSDBPLzQxOHlrQUQwZGFLNS83d2tPSm1tbmdhME1WS05P?=
 =?utf-8?B?V09wN2NYNVo2NmhST094L3haQ2xDcVBpbklwY2FHTFI2d0t6Ty9pYkswOTBl?=
 =?utf-8?B?SHVzLzdLQTU0MlVIdVRLY3o3MktwZ0hjU1ZRaktKek5PMkpVYTB6bTMydjZO?=
 =?utf-8?B?RVhqWDZhNDFtazN1SUxFZmN6cTVrQXZkOTVFMWRPcHMzN1dVeFNKczZ4Rmtn?=
 =?utf-8?B?WVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Y2d4UUNUZzJYd3NzQjN3WVhWdVJiRjIrekZOR1R6dFk1WmtFTVJETXZSN0o1?=
 =?utf-8?B?YXJLSjR3RllmZ1dyeDl1ZUp5Y2xuZUJLU1lCSk9SaXpURnZkZDNRVC96U29R?=
 =?utf-8?B?a0VEajVKT1gySzl4UktNT3pxSXFxRzFqc2dWcVE0c1cwU3hSenJUamYxa0I3?=
 =?utf-8?B?ZURYb1pRRDZ0Z1l6MDBKUksxTVoxZVU2bWkyTXNOVHhxdHZ3NnpTeTYvQWh0?=
 =?utf-8?B?eUpNdE9NclJiaDE3aVY5aGtIaGlRRE5ib2QxdkhUcE1udjM3QmtVMUFTN1VM?=
 =?utf-8?B?TlVrQ2Z2Uk4wR25ScnNSeS83WnlybGJZOUtFb0ViVndKS01tOCtiQVpyQndK?=
 =?utf-8?B?WlJoa21uUWNEQU90ekMwQlo4ZUUzVFNCRVFSNExjbDFPd1hiVHROUVhJaWNp?=
 =?utf-8?B?R2Z1aVUveDA3K1ZPRFpWcVNnSEh4c0tzQnZ6NFcxbDg3UGVUYXlKSkpqWUtp?=
 =?utf-8?B?ZUdxTFBGUHF3dVZWU1VNWS84dFpwQUV1d2xaYm9iOHJaT3owWkQrWUU1Tjlr?=
 =?utf-8?B?YUU1MTF3UmlGbXQ5TTNHZlBNNTJCYURwellrazdCVGdmZGZrU08wT1VXMzlJ?=
 =?utf-8?B?TFdSenEzdTM0L3lKZ1pBaEUvTDdma2Mwd2tFbU52d0JrWkJZSFVRSjhaYnQz?=
 =?utf-8?B?QWthenZXTmwxQ1lYcDB2YjlZWFVBSFk3Yjg5VVhaRGV5azVTa243T1NBdXZw?=
 =?utf-8?B?aGNnQkk4NStOdWRlTU9aZkRJczZ2b1J2MFJndDYrVHZFdXl1Q21nS0dUcFE4?=
 =?utf-8?B?RS81aUhaQWFCS1VQQnhremJUQjNFZy9BWjBHckxrNy9weXBYYUxqOEc3N2Ny?=
 =?utf-8?B?aWUvTGtkMTVpc201YUJmSFJyNDA0ZkNSd1Y5bUplZFh5R0VRRjZsTEo4WnZQ?=
 =?utf-8?B?aVFKZjNxUm5sSTlHUFlKTllWL0p1WkhDUmdmWmR5aS9wYlhCcEpuMTlzUDhB?=
 =?utf-8?B?RWFVSlpJTjFHNUtYOEFnaGxWdUhDN1V5NFJZRExSNkNFS1NCYXBHL3NBUWhC?=
 =?utf-8?B?SWszQ3h2ZVcwSDlrdHUrNjVkL3plM2NYdDlwbGx2UldsaE1jREhoa0FGVFJB?=
 =?utf-8?B?dlpBRU1OUUtjSlhiVzNmZGxmSUJFekh0ZWUvaTlSVS9LTEU0NG1uL3RBU3JH?=
 =?utf-8?B?aGg4U21iWDRtcU9LMll1NTc4ZXpWSW0wdEZoKzhlU1FlOGRPT1pSTWFyNkZH?=
 =?utf-8?B?SGVzbFV0ZUFBSG81UGc0NFQxOUhyZklDN1lqY3p4Z0F4REFjcjNsZzd5VDJi?=
 =?utf-8?B?a0hMbVRoMEpZQVo3eUdlTTkvRjNoL2ROcmJtYzVuKy9hdmh1em5BamVWOWZE?=
 =?utf-8?B?bjBrTFNESWVMa29sTEN4bWQ5Q3NDak5kOWFNUWNqbjJST1N3RTd2c0xkb04r?=
 =?utf-8?B?VEdtdmRYd2VlS0dGYmU4bW16Z0l5Tzh2THMrNVhubnlPMWVlZ0lsSDdseS9N?=
 =?utf-8?Q?kxkFwSFR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d4c5f0-a382-41de-b9a5-08dbcefefe7f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 10:51:19.2480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZDPJaS2egpYil904vxIfX/Jb+amg5oZ22Wmk7YJkNTGlpYXDYD6F3jmRFRjLL1W/ubsRjE4GYrw3pQ2sCgEkQ5LwhlxVCyEKmcvFfmGgvzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6350
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310170090
X-Proofpoint-GUID: SBSHD-FAOX-qn9hqhQypvXVrNNvelzpF
X-Proofpoint-ORIG-GUID: SBSHD-FAOX-qn9hqhQypvXVrNNvelzpF
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2023 14:01, Baolu Lu wrote:
> On 2023/10/16 20:59, Jason Gunthorpe wrote:
>> On Mon, Oct 16, 2023 at 08:58:42PM +0800, Baolu Lu wrote:
>>> On 2023/10/16 19:42, Jason Gunthorpe wrote:
>>>> On Mon, Oct 16, 2023 at 11:57:34AM +0100, Joao Martins wrote:
>>>>
>>>>> True. But to be honest, I thought we weren't quite there yet in PASID support
>>>>> from IOMMUFD perspective; hence why I didn't aim at it. Or do I have the wrong
>>>>> impression? From the code below, it clearly looks the driver does.
>>>> I think we should plan that this series will go before the PASID
>>>> series
>>> I know that PASID support in IOMMUFD is not yet available, but the VT-d
>>> driver already supports attaching a domain to a PASID, as required by
>>> the idxd driver for kernel DMA with PASID. Therefore, from the driver's
>>> perspective, dirty tracking should also be enabled for PASIDs.
>> As long as the driver refuses to attach a dirty track enabled domain
>> to PASID it would be fine for now.
> 
> Yes. This works.

Baolu Lu, I am blocking PASID attachment this way; let me know if this matches
how would you have the driver refuse dirty tracking on PASID.

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 66b0e1d5a98c..d33df02f0f2d 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4123,7 +4123,7 @@ static void intel_iommu_domain_free(struct iommu_domain
*domain)
 }

 static int prepare_domain_attach_device(struct iommu_domain *domain,
-                                       struct device *dev)
+                                       struct device *dev, ioasid_t pasid)
 {
        struct dmar_domain *dmar_domain = to_dmar_domain(domain);
        struct intel_iommu *iommu;
@@ -4136,7 +4136,8 @@ static int prepare_domain_attach_device(struct
iommu_domain *domain,
        if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
                return -EINVAL;

-       if (domain->dirty_ops && !slads_supported(iommu))
+       if (domain->dirty_ops &&
+           (!slads_supported(iommu) || pasid != IOMMU_NO_PASID))
                return -EINVAL;

        /* check if this iommu agaw is sufficient for max mapped address */
@@ -4174,7 +4175,7 @@ static int intel_iommu_attach_device(struct iommu_domain
*domain,
        if (info->domain)
                device_block_translation(dev);

-       ret = prepare_domain_attach_device(domain, dev);
+       ret = prepare_domain_attach_device(domain, dev, IOMMU_NO_PASID);
        if (ret)
                return ret;

@@ -4795,7 +4796,7 @@ static int intel_iommu_set_dev_pasid(struct iommu_domain
*domain,
        if (context_copied(iommu, info->bus, info->devfn))
                return -EBUSY;

-       ret = prepare_domain_attach_device(domain, dev);
+       ret = prepare_domain_attach_device(domain, dev, pasid);
        if (ret)
                return ret;
