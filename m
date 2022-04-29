Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC52F514520
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 11:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356214AbiD2JPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 05:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346139AbiD2JPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 05:15:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8AD49F0D
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 02:12:27 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23T7w5mj018603;
        Fri, 29 Apr 2022 09:12:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=HMgXUiBhMw7uzckXIdY83CtHkSQeE4m/FKIeHL1mx0k=;
 b=tXiNJUaMpRhlCTwva6P8gDCiz+YhGA3G9MrBRYmpGqY7M2MD9IRXIGuLTZ2hiCYRAkQx
 dZWL7/Kabe662Lorcs+mxk266F3Rxz9a0ZKD2RcOzyEiG4htEh9EmWTfClsDsNxV9vEK
 oBLuIQrzOpGPm7cbeM0L424zzqRzhnmGGMwWsc39DhQxBoTifUNBqrJtxS2A7Xw/ktTw
 eh4jYUr1mClDFxPtZSeDYyvS0HCevWjz3lV7KlihyhU1GM0upPneLT5UYjnnxdQpuF/0
 bRHxX4HBCufw7XYVnx/x2HJ4qE905sZ+HddAocxVKdbSpearis2y2R7pkVxs7Qq/UE9C 9Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb5k69jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 09:12:12 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23T9ADcR028464;
        Fri, 29 Apr 2022 09:12:12 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w7swdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 09:12:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdDf+FY+LKYD3Yq5CWcMkNLBRMSTyDmJfxvDFH3llbS82zaM6rI6ME7k+cRUDcXs44pLf9dzVWn5+H9Tb/VpFLmKKIvLcX6yOP040yHSJjAtI02srwshIjB1c5KCrw1jrzAI3PID8XkazqaotgehX/6YvVkVsjrmYvHH9kPtOkCGJRtYJ2VmHEETZ5TnXI4/DOCkrpd15iVyejodOwN3wAGeyVMSAizNRahMMSf8JgEbOzsYOVgWc74fR61D4djmUU0xM45Z8AWvJMGa5mfYKi+7I0SBUZfehI+4m2Vt7kDSxadnUqnF1B/tHIXZZkl98rcmBJdMgRgVCpvlgu534w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HMgXUiBhMw7uzckXIdY83CtHkSQeE4m/FKIeHL1mx0k=;
 b=YMDUhnqNajfAPEK5hvvGOXHP3CCvYZgZtIoeqCobyK5TksjszXea0rZy1d1ZBq5BivXmDSeYJM0Z9QXQ51fTGhNAwgzsv5hJ8FI/Mqe3m/Rr6NIRKlaiVaOy+jgLx8RMVfk3LKZRTAbtnvWiDU83KfQFvS1+LFwpdaNykJQr+oBB2NRKDD+to/BIMgYJif6RIkISu4IXKrj4whaGR39P2WlR7h31uR7Wdc5ZF88WS9SeDsU2BAtZiy3INOLpb/1s1sZE4WuW8XzKVok2nik7tzoh6xZnfWxb17EPKfltNd36/O+7g56qpGVpA5A+pGa2MmOmKGfcRBdduzHZzOBDmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HMgXUiBhMw7uzckXIdY83CtHkSQeE4m/FKIeHL1mx0k=;
 b=Z9+zFNY3NrSa8XaL2e57epX22akDpVjx/tL/7+AxBU7ls7qztTsf5IVmZTsOAI4VKAujhO3ieATEmzqe3Ybmf2funOSD7KlpakylQxArUKTZVaZhetWjOCeDkjrsFKJ2wvf6BZObPUmdRwh6ebodRbH+CmPQ9wH4fFbDMWrfwuE=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DM5PR10MB1419.namprd10.prod.outlook.com (2603:10b6:3:8::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Fri, 29 Apr 2022 09:12:09 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 09:12:09 +0000
Message-ID: <f90a8126-7805-be8d-e378-f129196e753d@oracle.com>
Date:   Fri, 29 Apr 2022 10:12:01 +0100
Subject: Re: [PATCH RFC 04/10] intel_iommu: Second Stage Access Dirty bit
 support
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Xu <peterx@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G . Johnson" <john.g.johnson@oracle.com>,
        kvm <kvm@vger.kernel.org>
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
 <20220428211351.3897-5-joao.m.martins@oracle.com>
 <CACGkMEug0zW0pWCSEtHQ5KE5KRpXyWvgJmPZm-yvJnCLmocAYg@mail.gmail.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CACGkMEug0zW0pWCSEtHQ5KE5KRpXyWvgJmPZm-yvJnCLmocAYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0165.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::33) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31605aa7-bcef-4fd3-fabb-08da29c0568e
X-MS-TrafficTypeDiagnostic: DM5PR10MB1419:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB14194A9B67AE4D183FC10E79BBFC9@DM5PR10MB1419.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VACJV51D0kykWqtEcIkYZ/LaLEKvz/SJ7KEVit3T9HbUcSDePyDL6Y3RHJqTRpP3NVqCH71Lwcz2D1Sg0gclHj9z3PtwNBPCTQqTrfEgSwsmp22ihcjI/JcOVJ5Ij7f1Aoqzh937fMHyOO7pe1vH61+z0Bo16/odNbMnYxkAf9pNJpMIIOCa9FNlq7JLYrZbCt6ic6wuhcHe91hXQ4fighZQm4FxgWCEVLcwSXR3vRUeA/twVYeG8amdCSURP+lzzREVEQkykH9WQTa5ClObA+qUtRga6BXSFJaTblKKR1/11I5mWXuLLWg+PPCr7eyDxRt/qyE6fPYrn1yNdh731auIzo/QJwmavJzPu9iGC9O1VmFdUlrXt7FCS+aTH+AaMwB0+G5aLhkGe8m6lASb0SEp+DkAJ6+gIRzoV9edATGpd5SgbX6543KfPwFbm/fAKp+QlqVKsjHh3AgoVN3bG/RbhZorqHizi1z+mfRWa2bswl3vTveJMDhuuftBBzD6/THLOc3MMgbpF7Q8LpNlGAITf5vqPccDtghPjFmz5X9MdbvYZ4OoYrY1v/W1/JxZ+0fo8eH+hT/a0GO9/eve9rCLTi31zGyUbiYZkHXC0YOkN5nMN56wpqZJhM/juqBNd/KZScSSavMi+itfIsmNeY8jMv1wJqO56QW+5I8zOl3W+pC8WVZP8jnW+wKKby19qsHeqr0d+nCawN/w5RWX/TyKI2UUn7YkDg4ouUqt3ww=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(6486002)(36756003)(38100700002)(6512007)(508600001)(26005)(31696002)(83380400001)(7416002)(66556008)(66946007)(54906003)(53546011)(5660300002)(6916009)(6666004)(31686004)(4326008)(8676002)(86362001)(2906002)(186003)(316002)(6506007)(4744005)(2616005)(8936002)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXllQTJCa2dZYm1kSzExMkxRaE9RUzBZNDU1M0h1Uk5YWGNrbFp5dzgzcytZ?=
 =?utf-8?B?cnNRU01XZHgvNmpwa21oQ3c3ejE5OEtBMVpOeTA5RHRNdnZUOEhmUTh1b1pz?=
 =?utf-8?B?aEdXbytHOVZlaHJKZkh2MTFrMCtBZGh6bkFEbDdXUmlidjNmaXhwb1IvQ3ZV?=
 =?utf-8?B?WXIzQXc3Y2UrZkY3OGlXdzQzTzhjN2hmK2FkdmJwazh0c3U5ZjNtQzlVYnAv?=
 =?utf-8?B?QXh0blpQaVhXZURQbEdkZG8reFlIV0E5MGlzbEJpSzlMbEtzRy9DUkIrSUkx?=
 =?utf-8?B?ajRycEpDWFMzWU9VdldpUitHN28rYVdZMFFuSzU1WXNIL21IMWt0d0I5WDRZ?=
 =?utf-8?B?UkljcHJQakR2VzhKR0xaSlZQa1RIV2pMKy95T1Z2S0J5ZmJlTGo2SGNIalJq?=
 =?utf-8?B?ZFBtclF2cTdzTXN0UCsyS0NuQ1NLU0ZlNlRWTnNlb1NBNFdQdWRrMlk1SHF5?=
 =?utf-8?B?RVR6NmhYZ01zeU9EOFBraDF1R0p1S09ySzE2WHlxWFNQd1JXcWlNM2lXeFdq?=
 =?utf-8?B?dC94MHp4OEdiT0ZLY21waXNrdktyQnd1cG5GVHFwNkM0OE1jNWg2N2MydzVH?=
 =?utf-8?B?KzRiNTg5VUU0bjZHMkxIdU5qNVpKRitYdTF4RFBXOGcrVG5FcGxwQmNtT2Qv?=
 =?utf-8?B?TUJMOURPbGxRUHFFZ01DZkMvc1Fubm9lejNFYXE0U3dwMkc4YSs1ZklTZm1X?=
 =?utf-8?B?RFhFUGIxdGJ5UStmMG1VWUpYemdEbVl3b1ZmTEU2amlPbHpaZVNrbWR6a3JX?=
 =?utf-8?B?UDhBMlRTMGNmT2JOVllwb1BuK0RFMUljby9LQ1kweVhmS3A5b1RNZjl1ZURt?=
 =?utf-8?B?MEI4a0lYcWpHT1djdmdKU05wTG02aE9ndEovZ1BCbExabTljaUNFd0s0NXc4?=
 =?utf-8?B?b3ZCeWJIbVFWYnhVN25GMEtvMjRmckR2WG45STVDUmoyM3J6ZDR0bHFvYXAx?=
 =?utf-8?B?ekdkc28xcjQxQ2tpTTNRUWw0WjM1OE1XYktkYnN2a3VLaEJRZFkyVzJJa0Va?=
 =?utf-8?B?MFR2TlZhd01wZXlVaFRNOTE3SWFmRENHN1lxQ3htdGs5d29ldmlUem5RZkEy?=
 =?utf-8?B?VFJkV21CUUd3NGkrMmRUSVN6U2JzSUg1U090NWl6R243cWNsOFVwaEs3K2V3?=
 =?utf-8?B?OXA2eWZPSHRISU9LY1VIUzZ2c0Z3UjgyTk5uODMyKzk1L2xSUm1lMkZnYUgz?=
 =?utf-8?B?YTJoQVZ2OXlTd2JjRU1uS1ljYmFEVXZ5bXdzc2ZRYTlpcEM2NXBoZG54a2dn?=
 =?utf-8?B?ZWw4UDNLaE9tUEpoNTBiM3ViTGtIeE4rZHEzMUc4OE01bW8xV2F4bzd4RlRy?=
 =?utf-8?B?b1NvTHM5UEN3NnJhbEk3Vm1IT3RVMWhVNFBXeG90aHliTzU5bUFNamJWOWYy?=
 =?utf-8?B?Z001eWxnY2NZcnpCNkNZUVUwTjgycGZjbEh0T29jSjFJdFZ4YnBmcEFJZ2Ur?=
 =?utf-8?B?a2pDTUNqMEtGalZKMzRHZnMremdHaDlLOFh3dHRQb1BRQUV6OTlIdnlVNHNN?=
 =?utf-8?B?ZVRUMTBCVkpKSkc0OWExOFN1UGRCQWtNUnlaK1VUc2RkajZ4bnprbzBxaFhh?=
 =?utf-8?B?b3dtdm5xdU1JY05lSXBCdjhLQmlzbERsVmQwSFFaQ29QVEdDVjFPak9HS1dD?=
 =?utf-8?B?VWc3L3dXa3VCYU9EWGFCaWQ5Q0ZSNVExQUUxZ1VOandkRjYwNE1xQzR3eHdW?=
 =?utf-8?B?bEdHYnFlMVRPOXFBZEFOcjRXakxVdHE2TlYrUEFRa2gzNFNUWXdGenF6L0ZM?=
 =?utf-8?B?cVRjcnMyS21pWngrN25hbDBqRFRzdTdPZmFySER0OXlNbkJaY3ovY0VQRFlE?=
 =?utf-8?B?bm9yYkJIZGZZSG9rUjI0NGtBNHZHRFduK1NDenh1YUpPeHUrYlNKTTJXN2dO?=
 =?utf-8?B?ZmtjWDJFMGhjLzEybHhHM1lUQlpmd3N5L2hiWTAwWlhjeVJSd3VlMGlmZVox?=
 =?utf-8?B?OGhaWTJuUTVUY0k5N01PWk12TmYxaHNQSGEyemVvRjRoZHNxV25iMnRId3ly?=
 =?utf-8?B?aEF3NVhvbWxjME1xS0ZoVlpuUkhhc1dFVjJKWldUVU1QQUVlYVRyWWhsS3c1?=
 =?utf-8?B?ZmExZUFDMWluUW9oM1lyTkEvUC9iUXUxZDViakl3RkpibE80ZWsrdHlEaTVC?=
 =?utf-8?B?NlJjM0pwYk1Vd3RIQU0zYXZSVEdDdEhsdVlHd2wzRHdsZUxKSnA1dFRiZHpO?=
 =?utf-8?B?Zk1WRjNVYjBWN3VPWHhsZmlnY3VnM1B5NlRGaUN2YTZlQnExZ2RxbjI1UWhP?=
 =?utf-8?B?eDJtbksyVlJCdFBEOXBGN0FpclZWd2hCUmdQN1RVQ01TZjdEVWYyc3RyUDlo?=
 =?utf-8?B?Vzg5UmlWZUIxS1prclZCSStqem9PazBQQi9oaG9vcGhRbXpUY2lHME1TWms1?=
 =?utf-8?Q?oWFRTEvK9Uuae/0o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31605aa7-bcef-4fd3-fabb-08da29c0568e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 09:12:09.3067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oI4i3EvS8OtfZunmd4tKVpzkRGQnQQAd+vW46En895h/ksK8cU8ABiIazAtyTsInmfOIBQLF4XG9NyNKpzIHR1G0ia34UmxHwDZb9+mPRdk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1419
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-29_03:2022-04-28,2022-04-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290053
X-Proofpoint-GUID: xQtVv5hmOWa6vEMZynQ-EPsmaSOR7fdE
X-Proofpoint-ORIG-GUID: xQtVv5hmOWa6vEMZynQ-EPsmaSOR7fdE
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 03:26, Jason Wang wrote:
> On Fri, Apr 29, 2022 at 5:14 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>> @@ -3693,7 +3759,8 @@ static void vtd_init(IntelIOMMUState *s)
>>
>>      /* TODO: read cap/ecap from host to decide which cap to be exposed. */
>>      if (s->scalable_mode) {
>> -        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
>> +        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS |
>> +                   VTD_ECAP_SLADS;
>>      }
> 
> We probably need a dedicated command line parameter and make it compat
> for pre 7.1 machines.
> 
> Otherwise we may break migration.

I can gate over an 'x-ssads' option (default disabled). Which reminds me that I probably
should rename to the most recent mnemonic (as SLADS no longer exists in manuals).

If we all want by default enabled I can add a separate patch to do so.

	Joao
