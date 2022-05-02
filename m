Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009E9516F8C
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 14:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384878AbiEBM2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 08:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385032AbiEBM2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 08:28:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3AABC1E
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 05:25:04 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2428g1Q6026132;
        Mon, 2 May 2022 12:24:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ZCTV8G5N56d9YV9A7rDIMK0rlH0/Z9Ug1kEumDaM2xg=;
 b=R70osldoA3PnfjMgCuSvzfi36KDxsWf8cknd4eQ47HJ20T9xNlnpfcKWw7uNJZtmyDqP
 sm5moitRjdcpqXRQC+g62vsdmG0tv1llKm8yrvZMo3zJu+rWteCeGujHMPnYTQfraozU
 C5ZgD6w7g1yt/Xatxfu+zrHzqrAPKWWgeaKohv5hch3YvMnEomWc04snfVS906you683
 DNy+aOolP73MKB7GWpiT4p+SR5uyaziQY4cxQkq8lHZDY0sSEDTBtYV8bHSB6bleHEaf
 Z4rIR/hSBXEkm6wR+MShjPNjsxf3uUBZspeISSYnmtWZdApoPmIrI7kl6kRhKFB4Fz0f 3g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fruhc32j3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 12:24:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 242CKnt3011682;
        Mon, 2 May 2022 12:24:36 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj7heks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 May 2022 12:24:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=icYGeXboWmWEPGBvXrS/6ckcOA0owoQ9BMO/r7t9/hPUELDwEQVPJV4hjhUjjFzRfwq0auTe1PnMLprkxRiEBfTBk+ToiR4hvbusIFIyqpJQZ3LQuW5reB2qu9KDH/xtq5NTqKC7Zt94Guum9WepEkxUL+Ku5WAW7zjL93+hj0yPDVcAMUaQkFbouHXGDU9UsyTzqyQCKD2Ct1PM0tDzaPBduaUC27+OW4O5g21pjnv5hNGAHs5bpEyh5N58WEh/MVUDSEKKWxqZAbk2C/JCVwH+K8adOyPw2HFj75NHdKqAH9GOObKSAfMd/u51estnpUErxK26XjPqJTHl1pBELQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCTV8G5N56d9YV9A7rDIMK0rlH0/Z9Ug1kEumDaM2xg=;
 b=LZ5jQk0rmjZY9DffdvY2Jyt7lBNFVTRzD2RMdELRM9OMiCXRwjRaWqhGC6uw25f4RwGHQIaFcEV/hY7XeMgnSuAvMLLCc8+XdUTfe5TfGHjxf0gP+YyySPzx4XxO1NViBpQcGyLYILqSNcz/WimM46Lc0gcUfj6SVlbYImO0WSKoQDtOfhpWNblTv3ezk8qmGj+UCi4faTCGGfGazIPSQ39GGPS5Xqs/y2TL5OzuXtH8HCrId+VuqWJyXmKbcGb7mPYtVFX3T+l6TbARwuLjmGk6RcopyXADYQXXxiiP81ts+P+Nc1jQe7rZNfLReTOh+UB7IZsm2pulRnYIMlKKfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCTV8G5N56d9YV9A7rDIMK0rlH0/Z9Ug1kEumDaM2xg=;
 b=j+LL+bKPd9XmDGGllzfEB6YG/rGu9jiuNQuCjPvD+4FIeDpeL95rYDBlH7qVtpb8JtJ3G8qyJhb4u3/JHRE+PfLNrC8aH0Jbp+WXeZNVm1RiRs4QDMNWQ+AuCGZkMgyuq0RT21bgFtP6ChSnEjmfwXL+MC+bupbe+v8NqLbykeM=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MWHPR10MB1469.namprd10.prod.outlook.com (2603:10b6:300:1f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Mon, 2 May
 2022 12:24:34 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Mon, 2 May 2022
 12:24:34 +0000
Message-ID: <4682fb6b-14c5-6047-ef1b-e11204657672@oracle.com>
Date:   Mon, 2 May 2022 13:24:24 +0100
Subject: Re: [PATCH RFC 18/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        iommu@lists.linux-foundation.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-19-joao.m.martins@oracle.com>
 <b214e55d-a1aa-4681-22fe-8f4fc03ca8df@linux.intel.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <b214e55d-a1aa-4681-22fe-8f4fc03ca8df@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0099.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::20) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7052a757-1be7-499d-e679-08da2c36b73f
X-MS-TrafficTypeDiagnostic: MWHPR10MB1469:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB14696B6498C7F0ED72F29361BBC19@MWHPR10MB1469.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jufEt0hVgd4yT+NFVaRwwbOy2Lb/Iu6BCfxLdOGkvo3IIMYvIwk/L/ib0uuLOPwqF6+xSTX4bNgh5seg1pPNZMr/9WIH2rMDtNNxAWbM7T8dfkF9HZm+4keSDkFWsc/kWBTgnWDiNhWoSsqkGysLT5wGqMnytVtWukafgyOmpR6Y0taHOtQIJEqf6rISFOs91jacIvzYTLEKEguu6GHDIc7YMO4dDyU0l5BXogCEQ4xXQOeK02pY0Juj1INsKm5EmqkrlRATGXvouclMxKhhNMHaupvOqWzhBzQ4YoVaTZy1dOlDQ4vpbKAIEPOqySmRbxgZXLdZFfgN1H0kN7rGUUslpjVilrMeUR4icq8ShrzGm4fhHq9WZv5XoBScSEz3F5xBuv0VzsJk0QmYYB+G2rYElmJ6Sf+remWGz7k0DrVo5/SGSuKj2PmU3iTmtwIlTKwZijPgtlv3NGRL9yMRcoVyNPlF9D5i77/91OqUdtRN2y+WiHOSutBsLEO7zG30ZCIrUAC5BtEEtLGExrT40qhPddH4rMW5GKtFApEIv+j64bvgCKW5BXlTgF8LXXj5aWXEn4WoxyP/G4r9Xwyd/woOCDbW81/R04HU0R6Z8AHq+vCMzyh51unTalqYWEccMZGktsy5/Zo+BjxMsWWhs3TQKjRvnj345SSIP3MUQuqCSNU/i0IXBw3GH64bOr8hmi7xm/v8ey42keRwSt8KSqDomnMx47/zxYHcU8XLJX0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(8676002)(86362001)(66556008)(4326008)(66946007)(508600001)(66476007)(6486002)(54906003)(316002)(38100700002)(36756003)(2906002)(83380400001)(31686004)(2616005)(186003)(7416002)(8936002)(5660300002)(6512007)(6666004)(6506007)(26005)(53546011)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnMxVEZIS3p2eVNlL1YzdmJRVkUveXNpWUxybzhHWUlCcHlRTm9nRFJtTXVk?=
 =?utf-8?B?aXg5ZGQwdExmdmQ2c0ZuOG10SGpKdnd1WFJlVGVtNmFjSlJoaGkxdEJzZmxT?=
 =?utf-8?B?UkRUeHZOWnF4bGhXQnRFWnRBZUNtTzJRT1kzNlRnS2YwMWd5aGZka2w3LytJ?=
 =?utf-8?B?bDNkZVFoMFFBWTR3K3FIZU5sZkJIZ0RmNFhHa1VaeWZBZTJwZkMxODNxVVUz?=
 =?utf-8?B?aktob3Q5N1VGVVZ6dEpZQ3FVcEdrSEt6T0F3TFJTNHp0OUNrOTh4OE5ZZkpJ?=
 =?utf-8?B?bFBUUUhNTFhKT3dSOHpJT0d6Q3hTUUxQQTBVaGs2SjF2eXJ3Z2NCdSt0dFkz?=
 =?utf-8?B?eXZyTW9ZMTdyQTl2Y3c0eHB3dU5IZTRCRUp4V0h0TmxPRDd3T1kwZW00aTNM?=
 =?utf-8?B?UkwwRU45RmFraXpqQ0E5UEdUWjdtbDZaYUVZWDgxRkF5YUxXV1RNQzNhSWFE?=
 =?utf-8?B?Mm9ycjlnL3RsU0JySm81M1VQUkZjS2c2MHdCNGJGZ2dkRGVVVzR6dGlvYnY3?=
 =?utf-8?B?UHRkM2VWN3VNRHIyU052blBTRDFaTmxTcjA4U05HRDZqTUJLMjNXY3p4dXFo?=
 =?utf-8?B?elo4THVBdllITW5UeURyZkY1OVBMTDhReG1aVVNDRzhqbVVaWHFIOFc1eHpG?=
 =?utf-8?B?ekhkNU1IOUU1TjFPOUFNSG9wS3ZZL2VtTXkxSTJVcTJsdXRjSW5wVmR4UEkx?=
 =?utf-8?B?UUVCdWUrdFFLUjJFdVFlYXRQZDVrQSttU0hFeEJiYWROSTdiU25DbzRMTzR4?=
 =?utf-8?B?aEhDQkpDZjlGWnM3RTBrQzJMaDg4M1g2U1p1TzFhblZ6U2pjdFdJUGs0Si9W?=
 =?utf-8?B?U0UrTENvRCtXL1kwdmo3UUtNRTBNYmIrNkFLQ0FlcVQ4VlBJZks3R0ljSWRu?=
 =?utf-8?B?L2JOeTMrRmNEZWdnRTUwb0FQaWdvbW43eHZGcFJPL1JiMW5VRjZ0N1NmcVdQ?=
 =?utf-8?B?TEl6ZGg4UUI2dndkYTVPQkR4YW4xMWZtUGdnRUttT0ZKQnNsNG11QWdncmZv?=
 =?utf-8?B?ZFlSekdzZ1orMEt2T2NONHpuckdFNEVvZVpzV1kvdWVnZlljUUdBcVBTVlNw?=
 =?utf-8?B?ZkxKbG5hNFo3YU8xTm5DM1FwMFRYTW5FK0hvVHlLVXB0KzdINmt4VXhDMlov?=
 =?utf-8?B?Q1N1cDY1MlozVTZ0T2V1aWZtWStaOTh5ZEZaTlpiQ2RDME9zMFM3WXZGdDN3?=
 =?utf-8?B?enp3cFhWUmNwMC9pTWJMWlNsT0UwbEZGK1RseWM2eEhjZEcrNkQ3NW9yTTkw?=
 =?utf-8?B?NS8yVUtSRFY1bU43V2lUaXFUdlNzQmV5YkFrTEJMODkrN1V0eGlMQVpKSVdB?=
 =?utf-8?B?SkdPZGp6ZWVGcEF5aHFSM0FrZWZQTnR4UDhsMHBjNDBqbGNtUVNUaG1KYlVl?=
 =?utf-8?B?dDNFOUZpN3lMSVpkekw4NGlUVWNRSjJCYWVnWk02MHFhT2dVK05xcEpBL3Fj?=
 =?utf-8?B?QTNidEhJWlIrdkVGYUFXTzJBNFd2YWdoV1BZUzh2ZkRnVXpCdmlTc3dsMzYz?=
 =?utf-8?B?UUcrL3JlRXFzdDhTWGlWK0lXRFhFaDh6dy9iOEc4aHNjZmlYYVNwQ1Q3WWhY?=
 =?utf-8?B?TXdmSENPRUFhMitBekJRbWZiVHZaNFlqTGtreFIzVy9tTDNKTTJHNXZhK0Js?=
 =?utf-8?B?WlhWYnZ1L3hsZG5nZVcyVDJkY2hDQTkyQ3p2YVFNV1RCOXdnMm9nOWUzdE92?=
 =?utf-8?B?ZGh0SzBHOVVkaXJlTzNoamFHdmt0NGV3MjZNZHR0SzF6ZzFQWk9WN3ZqWXNO?=
 =?utf-8?B?SCttbnY4VkNjQUxkVVpBdFpXOHpjZVNQZEhqV0RTOWo3VUJPdERpejkzalZK?=
 =?utf-8?B?Zk1CQ3FPN1MwOTJlNzBmQTdUTzdKOHQzcDlleEhwOGdHNHRsaEs5Q3AwY0Jn?=
 =?utf-8?B?azQ2RUNJMFNNWXl3Z2NUaDlFamtOSEFzNXE5SVo5NEpZaldSZ2JITzMvb2ZK?=
 =?utf-8?B?dXgvTFRSU1NZQ2NpUXJJNE5IR1Z2ZHpjcXpIWjFaOGdZTVhCVGdrbE9BcFUr?=
 =?utf-8?B?OUt2WjExZ2dVYWpvSmEyWHFVT1doQ09XdEp4dTY1djllVGlIZVZEWks3aDd0?=
 =?utf-8?B?SmdwNm9Yd244VHlPbEY4Zys1SjJ5Q2ZlR25jRUlPQkRja2lmYzdCeVhhZVd1?=
 =?utf-8?B?ZWdyRThNMk9IK1FKeUtUUkJJclNubEk0ckhzYWtqU29OdWxLbC9JTWc3L1lJ?=
 =?utf-8?B?eU9qRDF1aHR5WE4yUk95UWxYUjhKMjNvQm1TQ3kvOHdTWkdWb0Z0TzNNdWVV?=
 =?utf-8?B?TFg4RjM4bWFkeXNMYVdIc3Jxcm9vUzMwSG0vL3VqZ0IwSDk3VUw0a21iRVJX?=
 =?utf-8?B?UGsvejdueit6anVSdFZBeGMzTTJiNnIvT2IzaXJOaTVCdnU3QmlCNHVXODV1?=
 =?utf-8?Q?+5s5IhvZdVVtm5lk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7052a757-1be7-499d-e679-08da2c36b73f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2022 12:24:34.3901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cd8C7wcKY+aCUq9DWKUQQyVFD2k9qYNh1IWu+jbvYXyRmU51dpibS44/YFf3kFArHr24S5+8Aduz+6ARM/G5j9zI6a3/7kX6lC5NpD1Be5M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1469
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-02_04:2022-05-02,2022-05-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205020097
X-Proofpoint-GUID: zHXuNzYpTJgd9sZAbIH2EPOxGOsWhmbC
X-Proofpoint-ORIG-GUID: zHXuNzYpTJgd9sZAbIH2EPOxGOsWhmbC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/30/22 07:12, Baolu Lu wrote:
> On 2022/4/29 05:09, Joao Martins wrote:
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -5089,6 +5089,113 @@ static void intel_iommu_iotlb_sync_map(struct iommu_domain *domain,
>>   	}
>>   }
>>   
>> +static int intel_iommu_set_dirty_tracking(struct iommu_domain *domain,
>> +					  bool enable)
>> +{
>> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>> +	struct device_domain_info *info;
>> +	unsigned long flags;
>> +	int ret = -EINVAL;
> 
> 	if (domain_use_first_level(dmar_domain))
> 		return -EOPNOTSUPP;
> 
Will add.

>> +
>> +	spin_lock_irqsave(&device_domain_lock, flags);
>> +	if (list_empty(&dmar_domain->devices)) {
>> +		spin_unlock_irqrestore(&device_domain_lock, flags);
>> +		return ret;
>> +	}
> 
> I agreed with Kevin's suggestion in his reply.
> 
/me nods

>> +
>> +	list_for_each_entry(info, &dmar_domain->devices, link) {
>> +		if (!info->dev || (info->domain != dmar_domain))
>> +			continue;
> 
> This check is redundant.
> 

I'll drop it.

>> +
>> +		/* Dirty tracking is second-stage level SM only */
>> +		if ((info->domain && domain_use_first_level(info->domain)) ||
>> +		    !ecap_slads(info->iommu->ecap) ||
>> +		    !sm_supported(info->iommu) || !intel_iommu_sm) {
>> +			ret = -EOPNOTSUPP;
>> +			continue;
> 
> Perhaps break and return -EOPNOTSUPP directly here? We are not able to
> support a mixed mode, right?
> 
Correct, I should return early here.

>> +		}
>> +
>> +		ret = intel_pasid_setup_dirty_tracking(info->iommu, info->domain,
>> +						     info->dev, PASID_RID2PASID,
>> +						     enable);
>> +		if (ret)
>> +			break;
>> +	}
>> +	spin_unlock_irqrestore(&device_domain_lock, flags);
>> +
>> +	/*
>> +	 * We need to flush context TLB and IOTLB with any cached translations
>> +	 * to force the incoming DMA requests for have its IOTLB entries tagged
>> +	 * with A/D bits
>> +	 */
>> +	intel_flush_iotlb_all(domain);
>> +	return ret;
>> +}
> 
> Best regards,
> baolu
