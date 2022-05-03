Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728B1518294
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 12:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbiECKwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 06:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbiECKwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 06:52:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12351CFE7
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 03:49:07 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2437p46c018740;
        Tue, 3 May 2022 10:48:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8gLwTxftMLEHLr9lzsbfC3ukznumHUVaBrl6BqfI98s=;
 b=PwFkUPTYRnGl1mCGtxl8vAY+7+DI9FOb0ZCjB4P9MKhKxFEgAojApRPOeZ7UQovjknQU
 9LuRFbBLbGm4oIiRs55FaYGkH8cgq4oY/wtn6gRsoLFeXaFtXsFQA1JQ6yr714o+DFjk
 e2uxNCoqw13GAUnqNQndwoYYy/V6dBlRtHn+Vu9BtHPJ4ulpP6ydjLb2FjLcMe2XjyRN
 njbDbPSHd3t78Sk7aeoQqsriTtOpc07IYDC8N1ZOyJCcRN9Aqw8nFbF6C3coHSnwRXNb
 fXuEjQIb5/sd659oiwZiNWqUQ2duWSlcwYwBgwdsAzckgeJXDf+zDX5+6WGU12TrZKXg 7Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frwnt5c0q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 10:48:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 243AjQu6005638;
        Tue, 3 May 2022 10:48:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fsvbm8hqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 10:48:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HyiqsmbX6ypmFJwK+IrfHL2QI0IZz13DAyDneTWnSmliCa4+aaEqu+epzbm5vGuy+W5ftRhivH5HTvyb9XcG8xuKRCpTUyY1i9syTBgsBzRw+pXQuzAqFcQFqhm9k59uK8kEKEghrgFpjJuGOl9jy0VBaZJNglO4d1BRcQvn/SEYGTCwq5YJ2AMcG1O0Pi+xF6ukfkcPbAWSbJvHRu8qCr3pw+TVMnwH9lPVRadzurdoq/541xgHktVeo+QZzg7xwGkMJ4RrSRSt3GlDUYulM2wy1Z1JJg0gWIywQEwqwYVplDNxkKT7VKYKvA7aQhWO77hZ3JP+VwHpC4HE+24kVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8gLwTxftMLEHLr9lzsbfC3ukznumHUVaBrl6BqfI98s=;
 b=VNqlxmNJG21dGzcZGVrLlp/1RHM64Bgl+b7Q6M/xBDV+4UcXJ5Pjljj9lwIXLQcbqbmrhi48OsnhZMS8psIS3eUzzEenD0SzuZ4BxbcvmULZz1qR57k0Idzn0klrujEwaTjPWMYvpbyk+HeXuD139Uij4a6R/0ucDcDpMquw4xPSpcWDvQb4pxSV8FnhdkGr/pD3Vne6GLpSmZS/61ecGrJJBci+AKpbY+1MCY7UlJhdg+ioTNMREvvwQ78y4A60t2cqZNkjHSc5BePfjww9N49y6tIc+8gwejAqBakmEy+2ogsYp4tuZUlUDvMplUntnc1jGYEHiIiiAFoa+rH0Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8gLwTxftMLEHLr9lzsbfC3ukznumHUVaBrl6BqfI98s=;
 b=FZEMi/L2oaMDKr5nEV3Lp87htAtyzWrg3g/kGtGW8JvlniwvDpabeoaBIjkbxLawyrU7qDyFHNBv78rwB9ElAhj6jtmiubAfQM+IbTVvkTYzTNkSk2ORrRyQPBzqthxJcwyYM3jxpM30YN9cu2HHRHfgO5VgNTcx/IklUHHEId8=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN7PR10MB2707.namprd10.prod.outlook.com (2603:10b6:406:c9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Tue, 3 May
 2022 10:48:20 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Tue, 3 May 2022
 10:48:20 +0000
Message-ID: <75bf94fe-7047-574d-e132-303b316e6b22@oracle.com>
Date:   Tue, 3 May 2022 11:48:11 +0100
From:   Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
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
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <BN9PR11MB5276F104A27ACD5F20BABC7F8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220502121107.653ac0c5.alex.williamson@redhat.com>
 <20220502185239.GR8364@nvidia.com>
Content-Language: en-US
In-Reply-To: <20220502185239.GR8364@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P190CA0024.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::29) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83ae894a-a03d-4b27-22b3-08da2cf27002
X-MS-TrafficTypeDiagnostic: BN7PR10MB2707:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB2707EC54E2656A37CE33F2B1BBC09@BN7PR10MB2707.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eoP675cvd0hG1ZI8hjK81ibePFAssL19FWTET8dCfBrs2GgrNuvFFCPbPAISSoSyDwZVPhrJfVsyqtZ7vQ9licI9Y3WGeAvWxmVeMsscAKeRPlca93rISHvjdAwGLZfPS0+o8xMj8qS38IYuzga29+gnv5tycc021hem/cLlZ4SRrs/1MLFUoOT6ybPwh3Lk3f1e9Xfs7jN+v6iWO15HN3vwuWTl1jgpE+dE/QCpoqQRAbPpNX/KJK3HXkSLvZrV3eM67cOmVsUAHaEhPtUXzVrjxRNYqLHOaUx1k7mnkZo5l9z8yhA2m58G2KNaYXOiMCtn1Mg0lX3fz36bdGw6al+ignAOevmWxIfanBWoVaddhCLoWgSd7KBB+Z600few0X1Ve3I8ydESCWEqQwzQLoAT3fp3+z8GwKlcwg2Bv5kt1mBz1IW8/96etARdxzPc5ptsonZ15xrV7gsRFleMFBrBtlNvkBKLxWzNXIWZR3bfCghyLEIKivg1n8pSlwkKXPTRQQIVah/KKX9XLMq4kSKfqgUO2owDABpeVaHmCEDFu4TwNUNwu+qC+F8KBWCgQZ+6azbXNZVnaWxN2+8d1JsLnXc4tHPjLP+h0NZ6Wy4Xq1AzbSOMP7EfsuNMcrJvWQ0xs60HpMx18cWUYEK5B627Dcs7X4zW1fLHcEJDrdyzsN54vv1qQRxe9k7HvmaxzM4Uj+QLuFgDWShehiA1OSo1c6DyBojxUiPJwM6fx6s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31686004)(7416002)(2906002)(83380400001)(5660300002)(36756003)(8936002)(316002)(38100700002)(54906003)(110136005)(186003)(2616005)(4326008)(66476007)(8676002)(66556008)(6666004)(26005)(53546011)(6506007)(6512007)(508600001)(31696002)(66946007)(86362001)(6486002)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVd0bllHZnRaNXltUmo5NU9yQVBMVVhwYVYyaUNGT21xbGF4SGh2Yk5Tb1ZN?=
 =?utf-8?B?czJFa0pENThwckU2NjdHdVNaOFV6YjJjTmNuckZ1ZDFabXExRE5hY2Z1Zkdj?=
 =?utf-8?B?em9peGxmUDAwSE1MZC9SYzRRdlRqVFZXQUxtUFdpM3BXVEE5RlYrV0tJeTN6?=
 =?utf-8?B?MDVSQ2g1dTlvakRHNWwvU05GMWxnR0diWnVCVWoxV3NkT3ZUNm9sSkN0bHh4?=
 =?utf-8?B?Nm5ZUDN0M3ZadWlFQklnQ3orMytZa00vdkdtb2w4KzhNb2JNQnBBQzhJOGxS?=
 =?utf-8?B?VFgyNTZoeWRLa1FaN0RYUWxETDB2WUdDNTNSeGNGRlJXZTBRNXFIank1VkJi?=
 =?utf-8?B?NU13WDVnREVpNncvUloyS3VodUowSGhtcmdBdkk4M3ZSd1JOQ2pvU3kweWZu?=
 =?utf-8?B?ZE4xcnZhMlRXRjBMNnI5TVhjTjhtU212K05NWktjbkpGeSt2bnZvYzBxOU9Y?=
 =?utf-8?B?LzhxRUhtWkhYanZZM2cvdmFsK0tWeEdCdkh5Ukc0UU9VU3o2Umh5WVZUbFpw?=
 =?utf-8?B?b2dXdlZZdkN6L0xhQ2c2MzRCcmhzQXdjOVNJU0FtWWdEZXY1RmJGTTJ2YUdE?=
 =?utf-8?B?bUs4eU5tVFFzU2RSQ1BaWG5WZ0JCTTE0cm1DdVk3eWVjVlhNZzJ4QXBUSkhQ?=
 =?utf-8?B?em9mL29iZ2tmdVFFanBhdy9yRTdkQUlHWFYvS0Y1QjhDTG1TUUEwRDRXUnZ0?=
 =?utf-8?B?OXJ1SVBoSDZRN3BNSjhNUlM0ZlZVYkF4MW5zd0ZscHVadTJtZlhzNUF5bzlh?=
 =?utf-8?B?L1dCeWdwWExINzRrdkhHUnlZMUk2QVkrbE0zT051MnptSVpVOHc2cUN2YS9s?=
 =?utf-8?B?RDlUWVAzckU3QmtTai9QMzZXbC9TTElTRVdvN1RqTklHRWZkeG8xcFNYdkgy?=
 =?utf-8?B?d3hBTGdldWxiYWFHMmVGVzdaWEQrOTlrbE9DQVpLeDBiYXRBbXNjYkJMU2FR?=
 =?utf-8?B?U01DTGtBc0RzOXJpY1JWdzlOc2lWMjdKY0lsbkd5SDhNaVNhNWU4RmhMTmFt?=
 =?utf-8?B?Q2F5TkJiRUE1cUhMUDRPUU02cUNBR25pakt2S1E5NlgrcTY4YVUydHVRaXRm?=
 =?utf-8?B?ZmcrQVlYdVBxOVMvNVF2eWVhblNORTJmOXlxek55TnkzUHRlWGpwOFJSRkNZ?=
 =?utf-8?B?MkEyMUFmZ0hQTmg1WXJBdlRxNFpGWGsvcW1WaHp1ejJyRWhteXFtR1U1ZFhh?=
 =?utf-8?B?TFRRQThSRFMyWmplRGVudzVLTnB6VFlqZVVpbHJJU0Jpdy9EL0gxK25meXVK?=
 =?utf-8?B?VTI5N1UyQk91T0JYQjNYVFJ4ZUdVejgzWHBjMVV0bFpUbFNnWnZhZDIvWFNK?=
 =?utf-8?B?UkVWeWEwd2F4aTFmR2RRalJTenFDU1cveUtjS0VKS0g2K0pWeTV4MmNkU0JJ?=
 =?utf-8?B?K2lmOW5GMmV1am5xMkpjc3NSaHRkYzRyaWpSV1RoM1JKbXAvUHd4TmNCdWs3?=
 =?utf-8?B?OGM4a0ViajMyT1Q2YWxoRVN5TWJlNGRkWm9Ed2h3bUtDNml6bndPaDlFTFZa?=
 =?utf-8?B?b2Y4VmJEdkc4T05KdzdoYWZlblpXNVdoTy9aZHJGOVlTSXdFNUk3U3JWeXV5?=
 =?utf-8?B?cktEMHVNY24xckJ2SXU0ZXdpZWZiMmhRVjJTaEVpckdrNGZxVENGb3ByWFBI?=
 =?utf-8?B?TDVRcXBremlxeE5wUWVZR0trbXlheUcrV0RLcUdwOHI4UFlncncwMlViTVFC?=
 =?utf-8?B?MEtSK043MU1KRlN3Y2xKSm8vVkhYRlg3UW1zTnA2Q1BmUFY0VHl5MzlBc2JH?=
 =?utf-8?B?dXRReVdxUFZIUUVzOXRabnB1aUFvMzVVam5mbW96dVIvZGx5S2tWUUJWaFFH?=
 =?utf-8?B?K2Vsekt5Sy9JbkVIMEdPeEJMOEgxMHRQbDlzY1JUdVFsbkRqUkVXeWtiazFH?=
 =?utf-8?B?SFpKTkxheVovWSt6RWpsZzRQbWFiQjNlVjJjNmtKMGdyajBFdXF6ZkcrSWp6?=
 =?utf-8?B?Y3hoRjBpK3FWOFJDUmhvd2oyWVRVUGx0aHQwMFpma3J4Ykk2UDkzKzF4Q1RD?=
 =?utf-8?B?a0Z4bGZHTlVmOWhxTUpHWExVUVM3c2pLSjloVkFMb0dOTkRMZkYyMG5kRmJK?=
 =?utf-8?B?TFdMckVwdC9veERGcE1yOFUzdm1ybDZNREpyMkZHTnB4WlZzSGdaNmRKNzJV?=
 =?utf-8?B?czRER2x5aEdRRVR5K3lYZTNCTTB2RlpyOXg0SEVibzYrTGJxWUdjSnpiekpw?=
 =?utf-8?B?THRhNkV0OU9SMmpsTlZwRUN3SjJ1cFZrb2Z3aHBSV3k3SmFpTU45Tld1Y2Jx?=
 =?utf-8?B?Mk1mRDFrUmk3aGl3NGlZSDg0QjVWQjlESnRvMHhNcEdCQWtuVXVEcXdESkVo?=
 =?utf-8?B?NVlMZXUycDdWTEt3N2JMRHBaVmZQWEJaK3FkQUlaMmw1WFZ1NzJ3U3NGTFd2?=
 =?utf-8?Q?1iObCNiXLzp7JgxM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ae894a-a03d-4b27-22b3-08da2cf27002
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 10:48:20.1429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /QUIzYDtMgywycnec8xOpe5Z5MuSVUHRphvAB5wRwUIsr15WD0ROOxmJ/hF2xjed4TvpAl62ul4Vlt85clzuWTtKut8BS7NP+/xM/LdOo+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2707
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-03_03:2022-05-02,2022-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=779
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205030081
X-Proofpoint-ORIG-GUID: A78z5C3ABV5hWtG2gDiaFWuUIcXfyQyp
X-Proofpoint-GUID: A78z5C3ABV5hWtG2gDiaFWuUIcXfyQyp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/2/22 19:52, Jason Gunthorpe wrote:
> On Mon, May 02, 2022 at 12:11:07PM -0600, Alex Williamson wrote:
>> On Fri, 29 Apr 2022 05:45:20 +0000
>> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>>>> From: Joao Martins <joao.m.martins@oracle.com>
>>>>  3) Unmapping an IOVA range while returning its dirty bit prior to
>>>> unmap. This case is specific for non-nested vIOMMU case where an
>>>> erronous guest (or device) DMAing to an address being unmapped at the
>>>> same time.  
>>>
>>> an erroneous attempt like above cannot anticipate which DMAs can
>>> succeed in that window thus the end behavior is undefined. For an
>>> undefined behavior nothing will be broken by losing some bits dirtied
>>> in the window between reading back dirty bits of the range and
>>> actually calling unmap. From guest p.o.v. all those are black-box
>>> hardware logic to serve a virtual iotlb invalidation request which just
>>> cannot be completed in one cycle.
>>>
>>> Hence in reality probably this is not required except to meet vfio
>>> compat requirement. Just in concept returning dirty bits at unmap
>>> is more accurate.
>>>
>>> I'm slightly inclined to abandon it in iommufd uAPI.
>>
>> Sorry, I'm not following why an unmap with returned dirty bitmap
>> operation is specific to a vIOMMU case, or in fact indicative of some
>> sort of erroneous, racy behavior of guest or device.
> 
> It is being compared against the alternative which is to explicitly
> query dirty then do a normal unmap as two system calls and permit a
> race.
> 
> The only case with any difference is if the guest is racing DMA with
> the unmap - in which case it is already indeterminate for the guest if
> the DMA will be completed or not. 
> 
> eg on the vIOMMU case if the guest races DMA with unmap then we are
> already fine with throwing away that DMA because that is how the race
> resolves during non-migration situations, so resovling it as throwing
> away the DMA during migration is OK too.
> 

Exactly.

Even current unmap (ignoring dirties) isn't race-free and DMA could still be
happening between clearing PTE until the IOTLB flush.

The code in this series *attempted* at tackling races against hw IOMMU updates
to the A/D bits at the same time we are clearing the IOPTEs. But it didn't fully
addressed the race with DMA.

The current code (IIUC) just assumes it is dirty if it as pinned and DMA mapped,
so maybe it avoided some of these fundamental questions...

So really the comparison is whether we care of fixing the race *during unmap* --
which really device shouldn't be DMA-ing to in the first place -- that we need
to go out of our way to block DMA writes from happening then fetch dirties and
then unmap. Or can we fetch dirties and then unmap as two separate operations.

>> We need the flexibility to support memory hot-unplug operations
>> during migration,
> 
> I would have thought that hotplug during migration would simply
> discard all the data - how does it use the dirty bitmap?
> 

hmmm I don't follow either -- why one would we care about hot-unplugged
memory being dirty? Unless Alex is thinking that the guest would take
initiative in hotunplugging+hotplugging and expecting the same data to
be there, like pmem style...?

>> This was implemented as a single operation specifically to avoid
>> races where ongoing access may be available after retrieving a
>> snapshot of the bitmap.  Thanks,
> 
> The issue is the cost.
> 
> On a real iommu elminating the race is expensive as we have to write
> protect the pages before query dirty, which seems to be an extra IOTLB
> flush.
> 

... and that is only the DMA performance part affecting the endpoint
device. In software, there's also the extra overhead of walking the IOMMU
pagetables twice. So it's like unmap being 2x more expensive.


> It is not clear if paying this cost to become atomic is actually
> something any use case needs.
> 
> So, I suggest we think about a 3rd op 'write protect and clear
> dirties' that will be followed by a normal unmap - the extra op will
> have the extra oveheard and userspace can decide if it wants to pay or
> not vs the non-atomic read dirties operation. And lets have a use case
> where this must be atomic before we implement it..
> 

Definitely, I am happy to implement it if there's a use-case. But
I am not sure there's one right now aside from theory only? Have we
see issues that would otherwise require this?

> The downside is we loose a little bit of efficiency by unbundling
> these steps, the upside is that it doesn't require quite as many
> special iommu_domain/etc paths.
> 
> (Also Joao, you should probably have a read and do not clear dirty
> operation with the idea that the next operation will be unmap - then
> maybe we can avoid IOTLB flushing..)

Yes, that's a great idea. I am thinking of adding a regular @flags field to
the GET_DIRTY_IOVA and iommu domain op argument counterpart.

Albeit, from iommu kAPI side at the end of the day this primitive is an IO
pagetable walker helper which lets it check/manipulate some of the IOPTE
special bits and marshal its state into a bitmap. Extra ::flags values could
be other access bits, avoiding clearing said bits or more should we want to
make it more future-proof to extensions.
