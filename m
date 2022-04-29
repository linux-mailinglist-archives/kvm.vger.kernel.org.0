Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13905148AB
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 13:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344315AbiD2L7G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 07:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358828AbiD2L7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 07:59:05 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21989C74B4
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 04:55:47 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TBCEA8032179;
        Fri, 29 Apr 2022 11:55:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=o4evdhwa0jSd/LybcIozIAVMLVcxZqA6vST9/+yV7bY=;
 b=yj7q24Q3VIEtw1t9huBYZV93dyMOHGEeTGy6okbQNPGRF+oE4T4MhPH25mpQBZiW59nN
 Yzz1iGXViASez9msf0DmaXYRUdgsaYeiscRQaVG52aDppZ/GYJ4mTgi0EaQaQnKzFltB
 gtPgr/BH34xVgMUnlz+V0Qcs9s2EGhYVhEmCYpjdCydKFEp9rAPQYNFez9eRojX0u2Pf
 7hqc3bYt5Qza4GzqklsKkPdEmaTIw06POK3sXp9UtNIFOociGcmIGs+InHY4Yrlc8cTe
 AQf1fIhI2Xj5exkFg6m8N2a4zbuq9JFbKOWTDT/6568Xz0PKR/BT7acSrp5JUjz07smB 5Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb105x3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 11:55:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TBkETp021162;
        Fri, 29 Apr 2022 11:55:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w7xbm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 11:55:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5HQM7cvPe2u0khn/uJh/7wuLt4k+o4W8l32ND/L6a5vlWYgj8LXNKLBvRsvaZJKn4jK1QS00fuRYEUZ5pueMNFteRwcEBKekgJF5F9CMISgSf4ZzY7f+HO8pZcxv9oAP8rE9xod5i4ilxJXeu/MQGlUwE2iPxdpiL3VcIRGhan4ukmlBDLm82wjuVH6ppPH9IA7geuVJSNbgQvh9V1kGFL26PJIL4TZy/8keJER1+a+zHjdM36aEYr2ILZ3dcbQIUQXA9yZTZ30q3CxQAujy+I3A01fuBju+Ply1Yo655akzw2AcDERz9ITWHrwR82nyN6Uh69PlV+FQqojcz1SKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4evdhwa0jSd/LybcIozIAVMLVcxZqA6vST9/+yV7bY=;
 b=C5rQ+vM9WhR1iY5MxsVqecNfujsoVvcVOCgYjbnga9n5nmjUoxIcSOYOj4+MKwGNcXpLwDTa9G71EaIodbcvk09vRRDTx1SVf3OwljVBBlb0i4kruMj8pvFu+YeVjaUT/vTIGFMgV2ytd4JRytt6/kKBKKozDHg+TRrHYeArtfkaDhzQLH3HcdohaVKS6kHTBQ+KGekThi7WRleUbtg//hqDWWn/yete086/tmwPXGTGpGc07buSXWG4sSxiBndujOjHhOE/GXBjZMET2mFdV8+svFUkDqm49cK9IX6vmuOwP4flszju9Vez7HipVKCRemKc4l+jBz0hRrPhnc+hYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4evdhwa0jSd/LybcIozIAVMLVcxZqA6vST9/+yV7bY=;
 b=TrGn7uGVombyw83pmIhIQwRvVH0o4/cqzI7DSN0GTHZpBCtGavONaVDWHoA7vz9dbOQZp82bpWVhjymwOfWWgj4JiDwU7d+1S3FBrHZGN5jhdvFQCAzZV0iNMlo+tAeny+8zNNR0opoS2lWIXUpCbgAdCrfJjhGF1T+iRzFhIfs=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1258.namprd10.prod.outlook.com (2603:10b6:4:4::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.13; Fri, 29 Apr 2022 11:55:06 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 11:55:06 +0000
Message-ID: <fdb44064-c4ab-9bd1-f984-e3772b539c13@oracle.com>
Date:   Fri, 29 Apr 2022 12:54:58 +0100
Subject: Re: [PATCH RFC 13/19] iommu/arm-smmu-v3: Add feature detection for
 BBML
Content-Language: en-US
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kunkun Jiang <jiangkunkun@huawei.com>,
        iommu@lists.linux-foundation.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-14-joao.m.martins@oracle.com>
 <8e897628-61fa-b3fb-b609-44eeda11b45e@arm.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <8e897628-61fa-b3fb-b609-44eeda11b45e@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P193CA0029.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::34) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b74e41cc-e750-4b9b-59f2-08da29d71a43
X-MS-TrafficTypeDiagnostic: DM5PR10MB1258:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB1258356960D059BDAACFED1ABBFC9@DM5PR10MB1258.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qFzwlt8jWHpjWa03yCYwjBfx4xqSpe3DkrQDGRL5IOfhWKChT9c5qY/kBtic7+O1gyy6epN+Ssh/c/c6YYW/Qxd1+JnvFJrLuTVPbZjWf5q5lwlIjuMaR5005SliukpXgUhv/JSsg/Kr6FPzUGyDhpRzzuLesMgZrScmMCv38cQvmXv7dwe2j8aVFmn9CI8CuFxma8qMQScsUWY8q/Wg++W2VfgwkbASdDfP4mX9nwXiGy7r1qBa/262ma80we0jFzIjd7Pjpey5dAzmpld4q1LblniKlM33wiDrdZblJXZfVqvRzuZhQeu10jQP/WAdcWHmN+67Nucxc+oI1H0MIBMHpAX7anaZTDO4USnU/E9k/GQv1VCcTt7MrMiT5ePtHi2+qysS52Kp57v+/+XDNA96I+z63jO9Bcwdl62q2eUArv0tecP5wc5BwBUvSLrCmpP/vRPGnrlGjsZzKcSFBMxckR4N4n6YTFJ87BCCKOqnykELL9bNbEAaaX7l3pCAjRovkT+FHUPI7ZhJ/OXYkmucXiHgaJ0o2YAAjiETpJLgaMSkNxm/gUr7elXXwyymuWMR+QeCeX503zXHX0bSZBXemgIV6KMiWDhVjKabHUy1B/hQxFmWK8jEBg240BpfVNEfsvi6AQELWCpZ/OCQq8vFUBORhKogbyHzfcOBgLlnY8vggEcmVaTFISK9JaeCguhQ2/xodUNSjMENyH4F467ccjY/2y7WFwoiZrTSaZng0z2gfP0nR7tfZFFbGpiX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(6666004)(53546011)(83380400001)(8936002)(186003)(6486002)(31696002)(5660300002)(508600001)(86362001)(26005)(2616005)(6512007)(2906002)(36756003)(54906003)(7416002)(316002)(6916009)(66556008)(8676002)(4326008)(66476007)(66946007)(38100700002)(31686004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WCtGOGxXRHd2c3M4WkNIYVk0alpDZ0gzMUVtdHc3UnZDTDQwM3kzL2FLS1J0?=
 =?utf-8?B?RmpYTUZSdm5QbGlZM0IxVVFvdVhHOVhQZmFMeUlnU1l0by9OaU04YzBGYTEz?=
 =?utf-8?B?dXNmNFlITS91R1pzeGdKeVRTRTEvVWVkcWhZMkhVSFVtZnJ6dHd3dHN2Z3Z6?=
 =?utf-8?B?aU1Vc2lxQi83RmN1WGxnMHZWdzkwUEhJSWVTVlVLclhSd1A3K1h4cGdJcUlj?=
 =?utf-8?B?VXVVRnQzSFdmTm5jaDFsZzV0b3V5ZlEwb21NenRocWp2ZmZZS3VMckEvNU1F?=
 =?utf-8?B?YkhOeHRqYi9DazllWTMxOWtQV1ZlWmJmZGluUGVIeDN6MHJFakFFaGZqSVdk?=
 =?utf-8?B?dVdyZ3JONUpISVhnUDY3V3Buc1FrVUE1NzIwOU1tcmtSSjR6aEduUzkzL0Vn?=
 =?utf-8?B?Tk5PMmJYM3grRFFFVXp1QWhJSnJQR0xpTm90S0NzLzE1TjBUQytOTlpMRUlS?=
 =?utf-8?B?NFcrcEtMZ3hQUW1WdHM5enpaVnlYend4S0ZReDllWVk4eWg1OHVqelByRmFL?=
 =?utf-8?B?OFoxRWcwVHVrYzZvU2M5WU8rNWY5YzRlaVpaTkl5Y0RSZnUwTHlZS1E3ZmFH?=
 =?utf-8?B?VVhWWjhpRkhpVENZb1VSSFo3aFh1ZEpwY2tMT24wajBRbEFHUVRVRU9Od3Y1?=
 =?utf-8?B?a005QXhBS2lXUjM2T0Qzem5KN09wbDJIWHNWejl4eURYL2xqVjVwRG9qcVlU?=
 =?utf-8?B?VnBQSXJ1NU9HanY2cSswSThwQUZZRTFzMXV5MEJMa2E1QTM0WHNlWWpNMUts?=
 =?utf-8?B?RGdyWTdtSVFLd29vOWE5UW5ONXRheVdZMGt5WldSYkNBTGx6MW9neWxHWnJh?=
 =?utf-8?B?Rlo1NWk4M2g4cE9HWmVacm4xbGV0Tm9JdzA0aWM4ZUlBZkdFbnVhbjkxTUNa?=
 =?utf-8?B?MkVJUnpieDRyVW5YWHdGM2ZiM2RtRXRwTDd2MXRNRTRmWXkrVzFlNURUV0NI?=
 =?utf-8?B?VS9LczBvbUpZcEY4SDF0bjZQUmNjd2hnN0VvTDEwdUdEY1BiZGVZQkVUOTFm?=
 =?utf-8?B?bUVtOUpxZHJ3SmdYVU5CbVFVUFprNURRanJYZEFqV0lGcEpYTm5iWmFsU3d5?=
 =?utf-8?B?cjBCYmlZYUdZaWVoRyttQ0tXRFhwRzJHb25NNG4vQWRBSUtVc282emorMm1n?=
 =?utf-8?B?UzcrNTJsR3lDSWRoTlhyeElXNEloN2ZOc3BKV3dTZkViOXhKWnBMVmZCaGF5?=
 =?utf-8?B?VldnVklOenp3Q2VPNjZyb0xzT2dqeHd3RldGbklzNDNobkFZN3hJQlhPaG1n?=
 =?utf-8?B?OEh2dDdRUTFyMEFpekphRlcxdVYwQXgybTlUdGpoZ2JKemtOb2xreWNkQUZw?=
 =?utf-8?B?QkNJUHJSS2hlQjZXMVZJQWwweFVPZ2lRMmNWaFpyTGVMeE9vTHo5VmtVbWxN?=
 =?utf-8?B?TllZUFRXMEs0cStBYWh1a2Y1ZzBXNENKMFdiT3ZTOWNObk1FV2Y2Q0F2WlJu?=
 =?utf-8?B?dVp1YkNJMFd0NXVSdkthZjZJSEh4Yjd6MFd1WWFGWHIzSllvT1EzWTdqeVo1?=
 =?utf-8?B?U2hFcHVCQm1sN3hCTy9rWHhBak5tTHgxYlBQT1BrZGluWXE0K1pnbi9ORGVY?=
 =?utf-8?B?NUZhNFByZTI4ejl6K0FKSVIvOFZoanFnME43OHdETWZlRlZnYS9abXJoQTZX?=
 =?utf-8?B?RGRKbGF1V1k4d0pDb2tGSkNJMWxWdlFaeGdUVnN1bXVzREROVnFCdmw0aFZ1?=
 =?utf-8?B?QnEyWVlXZWRhK0QyUmpIZnNvQnhseTljRVM4OHBvR1IwK2RicTAzanBHbmY4?=
 =?utf-8?B?QXJGankzRkRiakZTWE85Yi9KemNESTA0cGZPaDRMUDdITG1kaXNNWVptN25D?=
 =?utf-8?B?bnE3U2VKdkoyWUN6Tk5pWGdHbFo3SGh4K1B3d0diN1QzMDQyaEdRMTN5TDU0?=
 =?utf-8?B?eHFnV3FVY3dqM3ZQb0EwVzVtUEVGUmZUL0YyMnNvYjcycUIzTnpMUi91d1VH?=
 =?utf-8?B?ZVhXUFRhSmNwZzF4VXhabEFFempUY0ZtMEF6eFNoNHYrR21OaXprRUlxM1Vn?=
 =?utf-8?B?QVJZcDBoZlpkNDhYS1FlU3lJR2tsalcwd3U2M29iTG9QZXJQUUNtcVNwQ2lY?=
 =?utf-8?B?WXd1UjNDN05VTnR3Rncvcmd2MTJYOTg5aTNNc3NnVkJJaWJEQXAzNGVpUVRw?=
 =?utf-8?B?aHRWQnVTck9sbFF6TUpmZzlEMU5JSCtBL1Q1YjVkYUxOTzBLd3FRNnZHUXBu?=
 =?utf-8?B?L2lIMDNNbVlCQ0MxQS9UZkdwUk50NVRHYnp3MndIakJQc2FhdHoyUjFsUkd1?=
 =?utf-8?B?ZE9xYVE5ZzVIakpzWG9DY0JTR0c0cTAyNDN3ZkIxc2piWjRBTFg1NnNJdWRS?=
 =?utf-8?B?NHlPZFcrVkkzTnEwb0NURjIyNUNVMUl2TUJ6djJHc3cyMnVTR0paSUVFajhz?=
 =?utf-8?Q?ltLywyoL4bmK5y3o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74e41cc-e750-4b9b-59f2-08da29d71a43
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 11:55:06.3550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x6oSx+ZjfxUm8sbxggtO9iSGRfIKxqkB69JiPMG7xgBGpi6Fd13r5t0OScAKEVcsNo/2rSgrNGJ3y8xRkLtyKSAjHnBvCUgVWu1MBHqsDJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1258
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_04:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=871
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290068
X-Proofpoint-ORIG-GUID: 2rCXigazvxU1TgnD-jqWAfZ5CGbaYJ6n
X-Proofpoint-GUID: 2rCXigazvxU1TgnD-jqWAfZ5CGbaYJ6n
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 12:11, Robin Murphy wrote:
> On 2022-04-28 22:09, Joao Martins wrote:
>> From: Kunkun Jiang <jiangkunkun@huawei.com>
>>
>> This detects BBML feature and if SMMU supports it, transfer BBMLx
>> quirk to io-pgtable.
>>
>> BBML1 requires still marking PTE nT prior to performing a
>> translation table update, while BBML2 requires neither break-before-make
>> nor PTE nT bit being set. For dirty tracking it needs to clear
>> the dirty bit so checking BBML2 tells us the prerequisite. See SMMUv3.2
>> manual, section "3.21.1.3 When SMMU_IDR3.BBML == 2 (Level 2)" and
>> "3.21.1.2 When SMMU_IDR3.BBML == 1 (Level 1)"
> 
> You can drop this, and the dependencies on BBML elsewhere, until you get 
> round to the future large-page-splitting work, since that's the only 
> thing this represents. Not much point having the feature flags without 
> an actual implementation, or any users.
> 
OK.

My thinking was that the BBML2 meant *also* that we don't need that break-before-make
thingie upon switching translation table entries. It seems that from what you
say, BBML2 then just refers to this but only on the context of switching between
hugepages/normal pages (?), not in general on all bits of the PTE (which we woud .. upon
switching from writeable-dirty to writeable-clean with DBM-set).
