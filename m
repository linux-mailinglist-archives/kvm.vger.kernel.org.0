Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657DF514CE0
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 16:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377307AbiD2OcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 10:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377332AbiD2Ob5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 10:31:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDA9A1477
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 07:28:38 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TBOUkv015530;
        Fri, 29 Apr 2022 14:28:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=XEQ9SLGD3Fz/NFwsMn6nNX3Tj6Rh2e0to4od30uP578=;
 b=mUT1JEP3+V8IOyIQuW1vvCQbbBIi7xdqj2QulI0mxNVk4SKOKnvMuHXAHSxSzAHJXFpQ
 sPPtf4fWkazMVQTlFZ/aHuGaT+xL4vxAaXNjUTV4vrM1N31YOzSuK4472CNEaEIRnESx
 CEvn4j+1ANueahpk4jqtbv6DCqoFstXyX3oS5ti9kHG2sSoI8CwV69APYu8FdPsfCkDq
 gs2DYC96m9Wmhd+nAqjsWza89+cVRT/1Lg0udbIRqjPE1lrFCLAhxKXTFexpOQKzrifA
 x9fMsupoj1I9Mtvo1n8qGh11p5CwOo+88bL39bLM4wLBe2GSB7lm2I4P78nMciEvCf+G YA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb9axv4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 14:28:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23TEGfX7026889;
        Fri, 29 Apr 2022 14:28:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yq85h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 14:28:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HnWzamCeC2tRcpp28uYOP0nvUZ7y7AdcONfZSKouLnkIGichleJYG6eS0OKEuWvA2I/sCurUU/KwNWCysFRbSh/zt4KehIQfJfRqR+FfguuA+pdXsZfKcDnu8sGicYP/8MG3yzWngRnL4txn/zMOefY+JIjrnl7eCY6JXg9k18O1oBUPDjqklilwOhTJcT8MXG/46IAHzNZdGVAF/QCzIjgRMB2FN08xlS7Ot8qovJd77M44GS23e98DAY3Vc/xwXAqM40lyJjsG17nXjlwiU7hG9fZtj9/Npfkb0EaG8bzl/JQH71IuM6KwUikmROEmEVla+FhT9j4LR7d9hcoPDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEQ9SLGD3Fz/NFwsMn6nNX3Tj6Rh2e0to4od30uP578=;
 b=bZ7yoYyGmoYUXR03uYKjYNzT8phxY3WFtmtrW7CMpnHxoQ0/CwMCpM0LmlDeRZeQOuw1IXe3Q0jTyGqKUql+qinB5WCf8xCG11UdRAwH8iFD9o36QKbxF2FXgECVwHfHMEdbTcNA25a/1YdFo2oct+gRpEFNh1YgOSi558lMGlmPkUz1BkOUFAKFriAArj7/zaUpKwp31V7MxfOJAXiIwlMlN/XEBCyz+LTyQi0U1BOcYtnbHQmHDne0fNE8ar1rK1ypW3LIZTNtq8+u9O9Eup2xTBxa6dXA1ShGJiZZDf6X3I6V3EbcsuVlohxzE4LENwMVUwBy5yUBa4UCjrc0RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEQ9SLGD3Fz/NFwsMn6nNX3Tj6Rh2e0to4od30uP578=;
 b=vVSX7K5wt2nM3wHGAErZOmPohltG3Y4YM2L/m0EGgvvRW9r71yRozDMqU2+YNLaAY8CesrIn/4gF14NTcnf5tbvMNtc9d/PlIDdh4rlVKJ2SiQA7E9QQOIf46kOEhM2NmqQfCb8kLypc0inn2hKQ5AuK7iSIyTzXutsvKfbD43w=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM6PR10MB2428.namprd10.prod.outlook.com (2603:10b6:5:b0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 29 Apr
 2022 14:28:13 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 14:28:13 +0000
Message-ID: <3fae7334-df70-183f-6629-9aad704b54fb@oracle.com>
Date:   Fri, 29 Apr 2022 15:28:06 +0100
Subject: Re: [PATCH RFC 02/19] iommufd: Dirty tracking for io_pagetable
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-3-joao.m.martins@oracle.com>
 <BN9PR11MB5276338CA4ABF4934BF851358CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220429115616.GP8364@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220429115616.GP8364@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::29) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37c5e4b9-aa44-409c-d45a-08da29ec7e41
X-MS-TrafficTypeDiagnostic: DM6PR10MB2428:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB2428CF4295060A53CC9BA699BBFC9@DM6PR10MB2428.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SHPNuanndEkOTlcMlQ7nq02dSrCdKkVrjuBOhE3yY9MtME55yRaDqjDv76U+dzpsqn3HktzIKdwDnmunmhd+j0grF9VsbTiF0Oa6WcU/wDzZolXuawKFCTLViSrepOj3famb47GWfxm5CwDN11dJBdQNjKm0eLrcomQP+Fz6lLonPcxKOjU1dBIsVdW69gXXwCmWU8FFzQBd69b+3f4mUMfqEOyOWjAn8se7ACOStVRH80InqTTSn3h2yiqYB1p1jNkOYBjkoYJrnZgkJCS9RPs4IdC8fR2wT3OooQJMOR+PGmhp11E62AwtZpttSvP7bDi4ZSKNKoTcz4lw43yB3FGiyDGBLDIcM+W2dRelfIK7CzdXA71RDggANAcvf9u/we2Qvy7UPxobSDBS2iObQHLOaIeO3RdMpucQoLM6H3F5A/Cm1vW2ScQfvwuRMYf4O0VXqgDpNcxSsCFWXDsmtrNoiZ2voioVKk9nsscaksmiT5V3aG/yysAnVtLfz1oM/3fAZ3fsUWgpeiq9hkKTzHFIDkgexEzYJVHfPENv49Yc734CscV2HUnWINPlcebmojjculYeplZeQ8fuWiCvLAVL0yJ32D5L5nyKOMrmZnvud6vLYkoRkFN0ag+85mKS5AMm+pMr8C/086L+z8pTMlh+bjz1T9HCmBKJEhyJPzTaJFp2G0UeXfgIXdwBtceJVzUoZ0AyRCCeFxt1bG/7ocYJw3QzT6QJKPEhBvOr+Uo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(8936002)(5660300002)(8676002)(7416002)(86362001)(2616005)(316002)(31686004)(54906003)(66556008)(110136005)(66476007)(66946007)(38100700002)(4326008)(31696002)(36756003)(83380400001)(53546011)(26005)(186003)(6486002)(6666004)(6506007)(6512007)(508600001)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzJ5OTl1N3o3MGJNdFNPQ3pvVUNEcm85VzRqOEc5NnN2RnRQWDA3VC9YdWdG?=
 =?utf-8?B?STZyeEp5TDZDR1ltU1kxMHdhVXZncDkxSDlhOC81YkJaOFNHajdrVG5mM0pX?=
 =?utf-8?B?dmdDNFZVSGpYdkxSRWdaSDc3cmdvcjBiS1NXYi9jYWR0Z3FMRlRtN2lxN0ln?=
 =?utf-8?B?VVFwWE9iYnZDWFZNNlRBOXBhVWZrUUJVaFZzVmYwZ0VmTTBtYy84YWlZUHYw?=
 =?utf-8?B?dTkyUkY3MmxJOW1NTWVwWGRTb2hBRVNGd2I3a2pzcmw4NkNpdXBYbC9GMENM?=
 =?utf-8?B?UVZkNW5aUlBnblkxVkJURks4V3d6VUMwajdYb0xGaElaVnRIM3dPdUlEaGlq?=
 =?utf-8?B?a0Z1cVhxTWh2S0Y3VDNBakwrbTcyc2tuNmM5bFdhOXZ0OEdsdnJoMGVXUWpn?=
 =?utf-8?B?NVFicitSREZFbGEvK2M4WnRiTjhOQ0hsZlQvbzFMN3haVUlkNHg3aFc4Y2E4?=
 =?utf-8?B?cUlDNU1iSmthQlNta0I5anQvZnY4VjY3dDU5YVEyK3A0WS9oSjgwZzN2Zzdp?=
 =?utf-8?B?OFozR2s4dUZJbDNhT3NkQ21qbDNoK2I3ODl6dTU4TUZPTjY1YWt4cVFDREdy?=
 =?utf-8?B?WDYwQXVQOXRPS3hsNEw2dXdHOHhuMC8vK3NBcjZ5eU5IK2tibmtvT1NURWU2?=
 =?utf-8?B?ckVVM1lFNXc1SW40bEx1WThHdWxKUTE2UFFBK2M1ckNDMzdnY0dORnVEbVlX?=
 =?utf-8?B?NlNiS3NYY1cwdytMejBIdzNOT2dxZ3dEcWlCTll4ZW5oMmpXc1o3UjI2NDFK?=
 =?utf-8?B?d0pLNnFtZGVwSmpvRmxTL01XRzczR3FQcGxJT3NkVTNwSFRsL2srVUdBR0I4?=
 =?utf-8?B?NVpEMlI2RFo3SnViQjgvdEthdnplcGpibWNwcHpJcUdaSW5rVUdiaGsycUJQ?=
 =?utf-8?B?T2dpK0tLdEFrTWhLeWZ2Q0lCSTczN1hJYUdxTlZDV0thWHBVaDJSZmhkNlVa?=
 =?utf-8?B?bnhKcUFkMU1DTG1aSDhlTXBhQ28rUitZNHZZTXV2N3V0cFFwOUFCOU5VdVB6?=
 =?utf-8?B?L1RQOHZmOVloK0dybkFLazV0VWNWY05RakdLNzB1OGVPcjlBYWYxN2l6NkFT?=
 =?utf-8?B?TzNUb3NOeGN3NkYzVWQxTDE1WDFaRzFodkNSV0hLdjRDOXMxSjdlMnduTEpY?=
 =?utf-8?B?U3JRazM2dXdNdEZOOXVXVm5mcTFHek9DcElXL1JsSzlBMU43NUdmS3N2YTkw?=
 =?utf-8?B?cWhyMDVFSFhqL0FzdjBUNklncmxsMnY4SEI3V0F5amF5b3FSTzNxcjFieUMy?=
 =?utf-8?B?aFJTOUpvSjRPU2FTTUlIeUtjRkdhYldUNGxTYnNzRjZsdlZiUHp0amFkcUdS?=
 =?utf-8?B?S1NBMXJLWkpWdHhidG1yWER4N1VLYldkYUpCMHdjU1NSYVBLU1dPWnJGOVdN?=
 =?utf-8?B?VDc0WkZiMG9UWGRPZVd2S3IwalJTdHRydUpMbnJyVUU4NkcvdytTWS90VXli?=
 =?utf-8?B?c0xaMUh0UDlvTFU5Z0toSFBTalY5OFM0L1Z0czlPRTlLVUZBREwvKysvaVN6?=
 =?utf-8?B?N3JUQnNPN3h0RU4wVlZGUTJHUHlUVmlOWEJZR3EzUlMxTVIwYVZDTWJTTjE1?=
 =?utf-8?B?ZFpjdGV1eUoxOWpPSDlBR2dqa2JNN3Bub0ZJMFpqWGZkWFZKSUdvdXZ4UW9D?=
 =?utf-8?B?ZVMrVkdBa3NRMloyR3RZRHY0akpDbjMxNVlCNW0rQ2tMTEJqL3JvbUphd1dI?=
 =?utf-8?B?WVpLZFh3TVN3bGtUbTNFaHdscGFpUks5QXcrRGtRUHpkOXhTYW82eW83b0Jm?=
 =?utf-8?B?YVVFL2Fiemo5NHVNUVIvVnJudHBPYlpVTzFDd3BETkFSR3RNWkNDQjYyYkZI?=
 =?utf-8?B?bkNVSjZzazZTWE0wUy83RWpkdjVGc1FyYnZ5VFhZNTdQY0ZnbjZPSU14MTFh?=
 =?utf-8?B?enFlNWhxbzdlMnQ0bHBXdlFnV2RQWGM0TkY3emtCaHJUVHJVVmF2TkllVGRj?=
 =?utf-8?B?QVVLdXh6bXozc0FxcXA2RVhucEozdnE2VlNTT283R0I0MDFVWjMrcEpiZlRZ?=
 =?utf-8?B?NytFempxTmliWWJ6aFZRNW5VMEJiT2xZbnR6TjBPVEJLeW8xSEJKcmJxVnNr?=
 =?utf-8?B?SVRBenJnUGpXdDhuYm05V2htNW5UZi9UQWZUQWtjMXU3cUlzSWpiSzVXWUdu?=
 =?utf-8?B?TExnaTNxa2g2VXhwaERPZmdIdG1SNFJTdU42WHRIbXkrWDZaanlvZXBEUWlu?=
 =?utf-8?B?dVFCYXpiczB1d3JTaTN1ME1QZC85VmYzKytTZ016eUNHazJVNGVpcGk0eCtr?=
 =?utf-8?B?QWZMM1RuQmpibFBiNlNUSWU2RitCejdNS1NlVXcvaW0wNnk4MFhlZnBZajNo?=
 =?utf-8?B?dkZKYjhVdTJvZUU5M0ZsUHZxbWRzY0Y1MEozM29leUhZSldZWGsvM20vcjZn?=
 =?utf-8?Q?x4YeVrkDxURav6gg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37c5e4b9-aa44-409c-d45a-08da29ec7e41
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 14:28:13.5641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BdOW/bepHNgHXYFP0t/+Vpbhnuc7vWSUabe9O0cuB/+dJGHfqZ2t+iwTRBA6oyMZ33at05ADgZpQYCveiZtMXhMNRQS7bS8JYJbvHC3khas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2428
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_05:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290080
X-Proofpoint-ORIG-GUID: o0rVcS7L5jiso9U3LIlcyCVzUc5E50TY
X-Proofpoint-GUID: o0rVcS7L5jiso9U3LIlcyCVzUc5E50TY
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 12:56, Jason Gunthorpe wrote:
> On Fri, Apr 29, 2022 at 08:07:14AM +0000, Tian, Kevin wrote:
>>> From: Joao Martins <joao.m.martins@oracle.com>
>>> Sent: Friday, April 29, 2022 5:09 AM
>>>
>>> +static int __set_dirty_tracking_range_locked(struct iommu_domain
>>> *domain,
>>
>> suppose anything using iommu_domain as the first argument should
>> be put in the iommu layer. Here it's more reasonable to use iopt
>> as the first argument or simply merge with the next function.
>>
>>> +					     struct io_pagetable *iopt,
>>> +					     bool enable)
>>> +{
>>> +	const struct iommu_domain_ops *ops = domain->ops;
>>> +	struct iommu_iotlb_gather gather;
>>> +	struct iopt_area *area;
>>> +	int ret = -EOPNOTSUPP;
>>> +	unsigned long iova;
>>> +	size_t size;
>>> +
>>> +	iommu_iotlb_gather_init(&gather);
>>> +
>>> +	for (area = iopt_area_iter_first(iopt, 0, ULONG_MAX); area;
>>> +	     area = iopt_area_iter_next(area, 0, ULONG_MAX)) {
>>
>> how is this different from leaving iommu driver to walk the page table
>> and the poke the modifier bit for all present PTEs? As commented in last
>> patch this may allow removing the range op completely.
> 
> Yea, I'm not super keen on the two ops either, especially since they
> are so wildly different.
> 
/me ack

> I would expect that set_dirty_tracking turns on tracking for the
> entire iommu domain, for all present and future maps
> 
Yes.

I didn't do that correctly on ARM, neither on device-attach
(for x86 e.g. on hotplug).

> While set_dirty_tracking_range - I guess it only does the range, so if
> we make a new map then the new range will be untracked? But that is
> now racy, we have to map and then call set_dirty_tracking_range
> 
> It seems better for the iommu driver to deal with this and ARM should
> atomically make the new maps dirty tracking..
> 

Next iteration I'll need to fix the way IOMMUs handle dirty-tracking
probing and tracking in its private intermediate structures.

But yes, I was trying to transfer this to the iommu driver (perhaps in a
convoluted way).

>>> +int iopt_set_dirty_tracking(struct io_pagetable *iopt,
>>> +			    struct iommu_domain *domain, bool enable)
>>> +{
>>> +	struct iommu_domain *dom;
>>> +	unsigned long index;
>>> +	int ret = -EOPNOTSUPP;
> 
> Returns EOPNOTSUPP if the xarray is empty?
> 
Argh no. Maybe -EINVAL is better here.
