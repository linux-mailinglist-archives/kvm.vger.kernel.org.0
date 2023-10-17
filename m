Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95F97CC606
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 16:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbjJQOic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 10:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235022AbjJQOia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 10:38:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125E3114
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 07:38:27 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HEE2co026115;
        Tue, 17 Oct 2023 14:37:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=UTL94copdzA0m6CzdbfAKfb7XR1heAcWTiAdZoVWn7g=;
 b=zAPDgftOtAstRFRrxC/XE1g50b4cnAZitAyEMNEAcCtFPo8HElC4jUpYLfZ3468aHUha
 54xyt65VdHSSAui2uzGR+iVYWx1vsLeARKrffawJB4mzAr94szgKnyhNaNzSs8/YFhA3
 Bw+HMRrCpU0+FNp/a8SE4WF7s+RZC5s9rzB/Lr+1zTUMrvqNKoLjkunxwN1kLqDCyBEb
 qHoPHN1ndpoxJSfYFbUe00vj9lXuNSgQwnCjcc0n4TsxGAa6Qm3gfAVkV4b4V3wrV/LY
 SZaf6vGytJYXpuyis5JEaIVB1nqy3lDq8uzbf7XAfMWhueCDlc9TtcwWBJiJI6eCqPX0 Gg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cdcm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 14:37:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HE7gB8015185;
        Tue, 17 Oct 2023 14:37:56 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg1f4s11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 14:37:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ic3ZD7NDlZvhFqePgCRY/B5xg5AQkLtX0KRkspTPI2Ihz00EQLbUl7SYdYKbMKcnVsWQ5b1TZXYyCuv9J0xErDm13DWNAGHHPVIHaPEj8R+P/VNSAqxRUzUisezlDPkyXIX1dw2eTncTd6XR9gK628HY/QMhMR0vYTWatWoo1F2hTz11JJ51SEEGpvgv5Qqbe0dvUo90od6HAMcqRIsvYGRAaGOCyUWnEgo4dukenOeMkCvqhbjF8hjMZJqYHGoAXXVcz887FHY+/9qmPqawNVI4PJN6fsJULTMPaFEaPahsUN6rrZu2Id8VAn8Udh/f8IuuupZcvFPPJKLby5mDmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UTL94copdzA0m6CzdbfAKfb7XR1heAcWTiAdZoVWn7g=;
 b=OSHuerWh6F7SqYH+SvfrrTErqdBIpbKDELyyl/oTuSgsHRxg9aD9Fe/ONNmJy1kKM2gnKZXQS+TAZLh2Ir92xvPhInwRowvMMO2l/JzXs2AkLsg8Z1aY5F1FUlsG+TPdnSiCDWqILx62mqqD2/dd/bNc1UINCxBvXheABOVwKoh9AlnqYCpx7eVSMsqH4G8jyRm3FVJ/PlM4xDyXmlzKF5dlfyaVqvbvXF2AWapN1RFpeGAAFbygP5M9j3w+BrBJod7S+zMUm2eLlrdCbLV4aAj0wVtUiFcQUSYtq661ti6pZT13j8Y0alAe28rybuarbZttk6Fyz8XxRGenJvsLQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UTL94copdzA0m6CzdbfAKfb7XR1heAcWTiAdZoVWn7g=;
 b=ObzvaGwAcm6chqm8R25HXqK4vyzTYXM4/CoFMPS8JmiknjyPVnv5EyuIHLYi5NIB52lVy73tgIl9qIEyyXlablU8DbDqVEt11ToAivLmS+bymYnWJXoEQ1iDi2yO061PFH4hyE9EGnaXmhGc0IvIHW4zJjcIPn/D3LHuNZ9+EZU=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH0PR10MB4807.namprd10.prod.outlook.com (2603:10b6:510:3f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 14:37:54 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 14:37:54 +0000
Message-ID: <b9e0a47c-b860-48dd-b6d4-b59838046c9e@oracle.com>
Date:   Tue, 17 Oct 2023 15:37:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/19] iommu/amd: Add domain_alloc_user based domain
 allocation
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-17-joao.m.martins@oracle.com>
 <6c1a0f25-f701-8448-d46c-15c9848f90a3@amd.com>
 <401bae66-b1b4-4d02-b50b-ab2e4e2f4e2d@oracle.com>
 <20231017131045.GA3952@nvidia.com>
 <8f34e144-0ec1-4ca0-9e41-29da90aa7aef@oracle.com>
In-Reply-To: <8f34e144-0ec1-4ca0-9e41-29da90aa7aef@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0055.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH0PR10MB4807:EE_
X-MS-Office365-Filtering-Correlation-Id: 35903491-72c3-453a-1c33-08dbcf1ea592
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cm9wYKHMq8thYkWJhTmSk8UtapSNbyzAN6g3mT/mnq8dcj5VHAS9gwAkx6YrxlNiksCWxECDnY3ZolN7W+kQU8OiFxhsMIi5itKMY6VUqbSnpjGm9Rn5NWXLTXYogIQMibGnsxuuDYjSjOl2/XLr4L8j4UnREtKNlJz8qqq+kP6eRNiJYKKPmXAySP4c22JBUV1vxaOylARZTqzeWN7W165xO33O5bTPIksCDAoWVxAPM4zXsLY3COMpx7XgvCyfwXbzrDwOnbbH8SWP3vY32K/xevhd3Dn9DEBBWR0tahO1ZiWUxG3lL9VwYNBRipej8T/mmYGso77BBUEz4ESgSCb+eGeelJVkebyPl/ZRWBSUgaL9LauNNOTMv4EIQQ2B04ZdBc21wbZ5d5VVQxeIaemJUl5cSYZXAJDk2qOAdYFctkE4NWdQfZuJgTRPG49hQgUZPV3otjsyM8Zcz0vVRSJZPK3gLlZtlGNucsOJsR5CfusDBtvTdi2sV+NXGWerOHY3vVtdMn8KXeT+fj7xe+yeJZ36joAAy6Wd3jxPi5Ol1yYBNehmxyJ1qiUYcV8s24KQccczcC2D6bAEkyXkkN7m72YSJj3onDZ3YxMkJlsWsKkJfIqCA/e2Pdn80KXd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(366004)(346002)(39860400002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(316002)(8936002)(2616005)(4744005)(6512007)(7416002)(8676002)(6916009)(66556008)(66476007)(4326008)(54906003)(66946007)(6506007)(53546011)(41300700001)(5660300002)(478600001)(2906002)(6486002)(6666004)(966005)(38100700002)(31696002)(86362001)(36756003)(31686004)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVNZT3E5WEs1K2w0ZE4wOStJdWlqMHBMa0hjVTFURHZMYjRrSTliT0Vjd2VK?=
 =?utf-8?B?SkdnekROSmwxZUN4cXFPVXhYQnFJbnJEYk1TdUxHQXZ3YnBFWmNoeTMrZkZl?=
 =?utf-8?B?Z3Q1VXMvbWV0cHRiR1paRmxmZS9SQmNkc2tQbnZ1S3JmdzZCangzSVRJVUQv?=
 =?utf-8?B?TGd0djA5bVZKVlRCdnlTOUwyVXVpUXExc0lTL1N6VzVSdUxIdTdYcXFXYmVO?=
 =?utf-8?B?Z2FnMy9YaTBzYStRbXdqYUVldlRYN05hUDhidXkxeDFLOHlnMG0vc3pYaWp1?=
 =?utf-8?B?bWNkM1QvNGQ1RzYyYlhBME1BTTlUS2RYZUNQM3ZrZjVrcW9ubVNINTA2Nk5G?=
 =?utf-8?B?cGs0bjVVL2hHYjVuYWZzaUg1N2lvdmJQcGV0THIzcjYrQml1QlgvNUZsc0Y2?=
 =?utf-8?B?VjFCT1U0UTl0NmgzM0lNZ1l6VUh0WmZCTkFwREw4QXhSR2VuZ3lpSjU2eFNU?=
 =?utf-8?B?dWdrc0tGK2dmMDhDWjQ0dVV1ak0xQU41TlNhcTIzT0NwYWEyU3I0MUYyZHky?=
 =?utf-8?B?QjNNb2dvNTRoaG9KN3JWeWhwc2RpUno3Q1REaCt3b1A0WStQa1VnQ2RkaDYx?=
 =?utf-8?B?Z3dGbDRPZ1BOaFVFcjUwemxwb2J6cmE4RWV6bTFneEhJZEJib3hrU09xTFgw?=
 =?utf-8?B?SWgxUTlOQVY4aTB6VTNjbkJ5eTg0bGVibnZvWHBlem1WZG5CUURrcnVEQmNv?=
 =?utf-8?B?TkE2NXJ2RlBPV1dKUXVybldXVkFTWGlhcnp5SGZ0cGJEeWlNQjg3OTJkL1NR?=
 =?utf-8?B?RFAzYzIvTVRES3UxcllMZnZmbW03SHkxUEF3MDBxOU5qbDhGZkxRWGN5dWht?=
 =?utf-8?B?bTBsRnJGMTdoY3lMc0xNWUdKd2s4eVFOampZTGFzZFNlWkhKeWJjTDlJVkpv?=
 =?utf-8?B?VEdaUXlIQXYrWlQxNjJsMEx1dDdWS1c2QW1vc2JQRGVUT25OaUVNeGFmVmMr?=
 =?utf-8?B?SERsNlBDRnc2TnFnMkhtTGRKVWRKNFBoZHJ1NmZZelFJUG1yaWhuUUVQRnkv?=
 =?utf-8?B?NWgwOEdkQWZlWlh0UjhjWFZ0ZzljVWloaWtRa2p2cDVXcnNId0F0RXdKRkNq?=
 =?utf-8?B?NGgzYUkzMlRKMEQ1Z0FQYWdnNE51d0pOU0xwbEpuZ3c2QmFFc1k2RDJpa1hG?=
 =?utf-8?B?US9EQ0hhaUJYOG1LMUI3YnJES1RwbTZkVWpKRTJXOXVURnVoM0hTdE9WQklw?=
 =?utf-8?B?ZS9BVkoxZm1sR0pWQVFFQjdjQnZEOWxOTS91T2NQWTFUTTIzUE8xK0k2RlFn?=
 =?utf-8?B?RlJDZFZFcnJkTUZUbW9MSCtNVGlVQnY5OUphMWEzY25oN2RSUXhMZEtVQUtx?=
 =?utf-8?B?R0ljTzhRNjN4Rm5NSDk3T3VFOGFpT1UvRVFrU3FSbzhTTGo2amhySGV2SEpZ?=
 =?utf-8?B?VTJ1TjJES1pZNU1UclAyZktOMTl4VjNxKzdIYWw0RWdldHdQSmpxcy9rTnBF?=
 =?utf-8?B?MzRyOStCc3dsTTNNSUhtay96M0xGQXJVajdJZGJzR2dvK1JWY2hWb1BhM0o4?=
 =?utf-8?B?OXZXS0RMbC9IV1hVbmd2QVQ3aDNzQTBZMkxPUHZPWHozelZMeUVyTktBaENJ?=
 =?utf-8?B?d09KMy9PNkFHelFlSXhrbGluTFpScWhWdmJOM2hrZERDbTl3bFhRTm5PK3d5?=
 =?utf-8?B?K3RBRjJLMU5vZ0ZXTzNtY0VJRURNSUVZTEU5SnhWaWtiWUF0NmRRa1Q4dUhX?=
 =?utf-8?B?UStlcWFBZnRnbmlTNlJSZCtabmFCUG1vWXJyZ1RaN1NZYkxBWXZDOWJqV09N?=
 =?utf-8?B?c0huVm9JU2g2Tm1Hd2lyd3RZNDN5NkRHL1dDV3p2RlVCZmZQaFIzZHQyMUtP?=
 =?utf-8?B?UTZaaFBYcHM0aWlkZytRbmxxb01uRFZJaU1ra0dYbjU4ZFpJWE52L200YjRL?=
 =?utf-8?B?bHlISmlsQ3hHQzk5OVlRZmtvVU5vTkpiUy8xWXlGQ1Q3VDFnVW1aVktKZnV5?=
 =?utf-8?B?cmF2RzhkSG5MczFLaVdYYktCdGMwMlVtYWoyNEJ2YXY5am5aS0IzL2E2Smtt?=
 =?utf-8?B?VWpXMVF4dWVKNjJpdzhMVThvU1ZHUTFMRDNJVENTMlJIT0RHaTNod2xmbndn?=
 =?utf-8?B?MSttUGY3RWh2Zy9rY3Rncy9tZ0tLcjh0b0crNWRtRUo5RHY5NWdRalh4NFl2?=
 =?utf-8?B?Z3FJVFdUL0l6RktjN1dXa21WOFp3a09HaFByRVBxY3l4ZDFQc2xCTmpCNmlI?=
 =?utf-8?B?WWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MlhFWmFnUmsyNktRQThvdnhHK01rK3lmYlA0em5rQ0cwWmc0Qjc3VHFyU0hx?=
 =?utf-8?B?eXNualp2cjVWWStWOGduNFhKTWFSVUtubFlFbFBObW80ZXhSVVNEVFZaMmN2?=
 =?utf-8?B?eGo3RkplQXVmcG1xNkZ6WTZ1bGNyL2dRWW96Sk9rK1A3K1ZMTFd2dDBKSTFr?=
 =?utf-8?B?WW5sQW1BZFFySkhOWTVVeTBzMWRLVU1GTnhjbjFjR2hlcW1GTmhqcUVZT0JC?=
 =?utf-8?B?L1pCbk4rd2NISitDMFZKY0wzMFN2ZUZPOXNBQ1V1QWtlT21TU21Fd3QrMy9k?=
 =?utf-8?B?ellLRTZ4YllxUzdXd1VGYzh0RFo0cExnQlRoZUZOZkg0RlFVcktxcjlMc0NY?=
 =?utf-8?B?VWdHbFlFVlQyTnova1YwUFRuRHRrd2dzSzZ2UExWb3F6S0o0VSt0Y1ZFVmNG?=
 =?utf-8?B?QnlLVENhQ051ZjBQcW9OVjZCOWlZcDQ0VHFzeFplbVBqaW1hVklacHJNam84?=
 =?utf-8?B?M1VXelBWcG1LVzRuM2lXY0wxQlhzckVnR2tQVG1jaDk1cXZLaWFLcGlzL2lX?=
 =?utf-8?B?ekZZM1l0NjRGMTV4RGpLV3JZaUdnd20xbFBkY0lrWXpmSlRraXVjMUhlYzBT?=
 =?utf-8?B?MzdQcXM2UjhXSnBPQkpEODA3OGVlK3BDUTFZOVpIRzFyWUxZalpZbmwwTHFm?=
 =?utf-8?B?aFpzYVc0QjA0OTU1SWt0L2x5L3lQUDdIMVVSS0ZMQlQxbmpLQm5RRXJRcVZi?=
 =?utf-8?B?Q2JXTkxoS1laeHExRENOTlY2UjRGTm9tbERSSThSVGVJL3JzUnZKdTFtWi93?=
 =?utf-8?B?R3h5TUtnSmZGR1lydVRUbHNaNVZFWDdTOTVpRkVqcCtjOURPanJWSXlYTE9E?=
 =?utf-8?B?ajQ0Mnh4VTB1b0MxZTM0dWk4aGxwVjZVM1FPbjFLV05uYmpYRWdTUUEvcDJo?=
 =?utf-8?B?TkYrMGlyVU9MTmV6Vi9pNTByM2JWMmhVeHZhRytCQ05HZ0JkdVFNUnFTRzNv?=
 =?utf-8?B?cTlrVlVHa2NrUkVWaTk1WHV4dmhiWFdaaTVsWjhWaXFnMlIyMTArQ3B5ejcz?=
 =?utf-8?B?Q3dJcDhXOHI3cTdCOTU0enEwMldaL1NIYXRuY3JnTzdSV21vV3hxRGFXRnNG?=
 =?utf-8?B?YjhkVHB0amtERjYzYjRLa09LSFJ5eEQramhaTU9uZU1tRTNrMjc1UkNRMStK?=
 =?utf-8?B?R1I0ZklJNnNZaDI4RzFmaHJYQS9BaWlhbGtvY2Z4cSt4NEYzMkNIMHZlRk9x?=
 =?utf-8?B?b0ZoRzM3NEhVZ1dkWnlFVGlNWkZWM2tuUGNMUDRBdzZNb25pZGdvMitDZHpw?=
 =?utf-8?B?bVZHbm11UDVxdnc3ZzR0YjFNMnEwMUw2T2cvREgwN0lOTURZcFV1N1RwSWNu?=
 =?utf-8?B?RURoWjZpSzN4TkJZcGV1TXhLVWVjL05uVENJdUVlcXZtWU1aVWxmRnpETFk0?=
 =?utf-8?B?di9VSE1jeU1zMDZrWmUrNnZ4Qk1iclJuTWhEZktHOFMvK3p2K2o4L0l5bzJX?=
 =?utf-8?Q?/Ilvzem0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35903491-72c3-453a-1c33-08dbcf1ea592
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 14:37:54.1710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3SiYNpt7g/91ePZr275Qx+UImM3Jn6HbtPoniwq6rsnMOG7j4+PXzTa2DuDV4QhPoPcAE+8+Dpmccc8xedoGpHURItBqbRsJDTK1IFd8lrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4807
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=890 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170124
X-Proofpoint-ORIG-GUID: gWF0DMz5eF8Yz_u7mAVAkJl_QCbO1_pf
X-Proofpoint-GUID: gWF0DMz5eF8Yz_u7mAVAkJl_QCbO1_pf
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 15:14, Joao Martins wrote:
> On 17/10/2023 14:10, Jason Gunthorpe wrote:
>> On Tue, Oct 17, 2023 at 10:07:11AM +0100, Joao Martins wrote:
>>>
>>>  static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
>>> -                                                 struct amd_iommu *iommu,
>>>                                                   struct device *dev,
>>>                                                   u32 flags)
>>>  {
>>>         struct protection_domain *domain;
>>> +       struct amd_iommu *iommu = NULL;
>>> +
>>> +       if (dev) {
>>> +               iommu = rlookup_amd_iommu(dev);
>>> +               if (!iommu)
>>
>> This really shouldn't be rlookup_amd_iommu, didn't the series fixing
>> this get merged?
> 
> From the latest linux-next, it's still there.
> 
I'm assuming you refer to this new helper:

https://lore.kernel.org/linux-iommu/20231013151652.6008-3-vasant.hegde@amd.com/

But it's part 3 out of a 4-part multi-series; and only the first part has been
merged.

	Joao
