Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1CF63C0D2
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 14:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbiK2NRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 08:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbiK2NQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 08:16:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D7063BA4
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 05:16:32 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATB3p35002125;
        Tue, 29 Nov 2022 13:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=YXaly4lZBpgOUz031I6A0tO0N/Kq3CMff80gDGtTHIw=;
 b=htVfs70NLSPVNLL7uKEyIW/QHJzpbJN7P+5lLXTNbvZychPsBFIE1yG1XURP4AA5ETJy
 /kKNrpTt4i830VpmecWa5/XMlWv5NBR1VUT1dsXfWsLuGp/CJTwIL8m7eDU3OO2LAEX4
 Fwk3xIUFQ14RGHT7e4kt7VrTsEOJW/3zsRiqeof8ailn+29OZooJCjWOwO6jLpVeIB0b
 JfIA4KCrOfMw19ekw73uiCL6nN/exyCBOn/T5yPCa/E/K7omCLS0An2TKtYZpIERqE2u
 VAK/eRP9SrRy4NwQhcMRXAW3dYQ9Af6yOYxmVqx308M+51VFp7FEHp7k5RbKgvnJo9iX Ig== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m40y3wk77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 13:16:28 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATC7sxq030984;
        Tue, 29 Nov 2022 13:16:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m3986uap1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 13:16:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFraVcrIlftnTc+90f+sWe1x6kwT2d9vV/zIzvr3O70TFmUrNS8lh6J1JSIRA9ynL9k0jj8ylPYQ8qx+/A8Dg0r9uOanqOY/7eEoYM2VcWq9In7iYzvG1m+zAp5PGaJVnfESlhJLT7YYuSRl9rMP7FIH+mnebGMojsYkqADh84PlUH6NncMrMO+NyQYepXCgBLrhJB+xDgoJhNGh1zBX+XUGtbUAY1L4X4lstT/mecy96CIIDh6phWfTBuzvXzQF+MXSaMmvXZvKyRrWUzYX/KSTC7ypZ6nTw9zuvFwuZXmLlIVBZTm+ntBqEAwTcMeRpiCVq9e/s+OxUsr0VJC1xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YXaly4lZBpgOUz031I6A0tO0N/Kq3CMff80gDGtTHIw=;
 b=f3r0Ik6TtKQ62I18kDk5bFxO5ifraxePaQucbqvktnHLIHCcib4W2WDcuj6gnX1Pd/6Nht+7Uuww/pp/CLEpudBc75NygkpflFJ8xtY++6DLo6G5VK5YO2YCzNiCwH0Aw2R2YbtBA5Y77zRmEabyRr6lvq4MXcHoRllVnwNEgGHvxbdmStJX8YnCbeyAdBXmcOk+XzoGq7QxbE4vu/cAtU+NamFbmU6jFUkd+4ciDWJCCRpNxldxGbqrgRvhnZw1vLktl66SrQQolz/KVedt2q/9suIVbFwrNs/yKQbXqhnZqSSD73T0RjTEqEh6OGQ5U8EYfQcqBemlL0N+IB+WKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YXaly4lZBpgOUz031I6A0tO0N/Kq3CMff80gDGtTHIw=;
 b=zx+vtjbNsw2uDKt2Yz4lh/0BgIQJvnp6sX5QzMc/l187Ye0C6a3IxXww9SRFPElfnYh6ZwQWPc7ZwwhaaquJ9inEzfxqhWEwcCaJBTKrYk8piBsyGrKyhmH2iWDtLbOo+UacyHXavY5Pm/un552hlAttguAJIrEQUIB+1rpnGTY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SA1PR10MB6366.namprd10.prod.outlook.com (2603:10b6:806:256::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 13:16:20 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d5e6:f75a:58a4:2e40]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d5e6:f75a:58a4:2e40%9]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 13:16:20 +0000
Message-ID: <f69c2729-8bf9-6921-14f7-3f9a887506f6@oracle.com>
Date:   Tue, 29 Nov 2022 13:16:14 +0000
Subject: Re: [PATCH] vfio/iova_bitmap: refactor iova_bitmap_set() to better
 handle page boundaries
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20221125172956.19975-1-joao.m.martins@oracle.com>
 <20221128121240.333d679d.alex.williamson@redhat.com>
 <77c2ba5a-2b5c-9a47-32ae-13e5a6960d05@oracle.com>
 <20221128154812.48061660.alex.williamson@redhat.com>
 <bdee988b-4191-20d2-b0f1-46a70389064f@oracle.com>
In-Reply-To: <bdee988b-4191-20d2-b0f1-46a70389064f@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0010.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::14) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SA1PR10MB6366:EE_
X-MS-Office365-Filtering-Correlation-Id: 6461dcba-7ae7-438d-9710-08dad20be798
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OdknMhP0FXb/cINSgO8rKXYsk9jWcg8YCK9nhg2BxWiqNDkNZjBj0IA9zLRynr4PwfB06mc0XVh0Qfz052NEzdsPWzosOIBLDUf8tY39/22qv1ANJq6YJp3c3e+m2Vsoi8ZWzH8fkEp7pfStCCCT+oiYGc6+hWgCbGTZ4uqKhcTpF+LQKuOwi/4KvL4j/DYNT3LonwfUSY+aB8ZzM/EYFODfPt8qm5NGEihzB/tqswt8r3Zo4k3nJluP6LJGsqOi+5gMQcm53mQmV5ZRQUdX1HLvjklcJR4WONK/zK/BKSjGRuwbwnB2HYb8fXVCyFpc7IT4ApcV4XoCT6Kkj9F+cpFzYxNwgvh54MixKiNrD0Wc1/ceg9dbzxEg5AOChDOKEpsAuwbhlb21Hdq3NJo18JsQA/ZK754419Thc/0vmBQTk2FE9G4UcLL6mpHKBZZKTd5qc0KCBYUT75/fpEMRTzx25RwStmAssT7ZUJ/XIsck/4T5jmTU7fPdyoHA7tBthjyX4Uz+RCX3i0seDIc/6Fo42upMjfXwTYlZQylDQ8dHgtdHdJ1Jop4fLGZTBrLx5wCBY/7pcMxGQGK5xwwQHj3ZLq1yKqpRV1lrj2y8TTEBTQXFqWqkVfoWmpJ0kreMXZEXmweW5jN7ff0hZe7ZTtYcj3pB5YRlx1AwwYqX55FhxzWHzaKqMgwXouC9JXXv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(366004)(376002)(346002)(451199015)(66556008)(66476007)(26005)(66946007)(8676002)(4326008)(8936002)(36756003)(6506007)(53546011)(6666004)(316002)(54906003)(6512007)(86362001)(31696002)(6916009)(83380400001)(186003)(2906002)(2616005)(5660300002)(478600001)(6486002)(31686004)(41300700001)(38100700002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y09Xdm1Fa002WEFic1BNbWZUNGRiMzByb09ZTEUwRE5BNTlYYUdXNzNoY2NU?=
 =?utf-8?B?em9oUVB6dmpFRGRhTS8zdUVHRGNrdFpJa21UTlBzYzdyeEdsbG1MSDdjNFRq?=
 =?utf-8?B?azVYQWErNEZSV2UwNTlDYzlZN1Z4NjN6d1hwUyswNHlHczdvOXZFNzA5MVZ6?=
 =?utf-8?B?THdSODQzcHkvaHViNW8vOS9tbnczWnF5d0VSdENLTzlISmVBb1dCWmxKV0tv?=
 =?utf-8?B?bUFsK2loTjAwaC9kb3VmWW0wb1dNdFJtanRjek44dk4zbTZ4QUtjVVhrQ3Ja?=
 =?utf-8?B?Zk5vaDFSUDlzWEZkTXk2VGVXY05mNHZFVjNFZTd3KzRqcGRIYXBYbGhCK3NC?=
 =?utf-8?B?SGhGSWl6ZVZyVE9GSHprNTNMbVBjV25yNks4RzBQbHRvNm42enp4MmdlV2x6?=
 =?utf-8?B?R2Z4STBlYVNNM1NPWTZTNmIwdnFDdWdtQ0RGeDdONFZkZDVURUJ3MFVrWmE5?=
 =?utf-8?B?OGF5dkIvVHVwNGtJZTB5eURYMHc1aHNyaXdCNlIreXZFNDJtN1dtZzFQYS81?=
 =?utf-8?B?THJrd2Rydnk3UDBtNkI1SFZHSzBjQ2Zxd3VycTVtUXlXMWwvWGt3MUhEQksy?=
 =?utf-8?B?YWtnLzEvZkR6L2hwYVFFbGJzZGtXYWxKRzBQY0poSVpSYjFUN2prVHViQVRO?=
 =?utf-8?B?R2ZvQWVHdFNiNGJJMDVlTWNrR0ZhNUs2VEs4NkttWGQ1cDR5U2dkRTl3OUlw?=
 =?utf-8?B?QjF6TFNVZHExMXZrS2dYeXB5dGZTQzZhTzVDOUxKT2FxMFdUWGJxRW5ROGNV?=
 =?utf-8?B?RWZJUDdyMitobWY5eE1meFQxN3JEamJWR0VxODFqdDhtMjdBcUtmNHVKRWhN?=
 =?utf-8?B?bmw1Q1hKRmsxNlJVZmtvZHN2eWZvQkVKR3N6Qno0ZlFCbHdYa05rTDhjczMw?=
 =?utf-8?B?ekZrRjd5OVZHTnhWU21xNHlYK3RwRlFHRkE1RlRQbTFmWjZkTGc0Z2ZnZjNh?=
 =?utf-8?B?SjFHeXRLYU5NQ3ZiZytLNkl1bmxmZXZwRE9jVWhYdkFxSHJGbGhUUzFtN085?=
 =?utf-8?B?ckRRWmx4d2QrYisvUDBqUkZMUmtaQ0R2TlQ0c0owZGZaS0JYS1IrYmRMUlJw?=
 =?utf-8?B?Y3NWN05VRmJuY0lub25QdWNhbWJEcGQ0NDVwUklWc2crYzk0TFM5U0Z5YmxT?=
 =?utf-8?B?disrNzFzR3RWUTVXamVtTHlLVEFsN0J0Z0greGM0TGFlL0pIbENZK2dMTnV1?=
 =?utf-8?B?ZER6Y2UzK1pxazZpSUxQVG9VaTdlSFJNb0RKdnVNMWZIdERlR3Y0alhPR0ZJ?=
 =?utf-8?B?TkJ5Y1BXeVBVUlppZ3loN2RkdlQ3cUx5cUVOTVkzdHd1a1FIU0JkdXlPNjdV?=
 =?utf-8?B?TTJZVzQ0OVNpbWc3YTFja05rbXJLamVQQVVTbjVBeUhaejVBcDU3dEZXbFZQ?=
 =?utf-8?B?eEYzQndqREp6d2ZueGViT0xXRVhiR1FIQmFWaTdUTDAwMEg3YVAxakhxOHVO?=
 =?utf-8?B?cDlTZWJVQ1BIM0JTbHJ2VWtKSWFRV0l4OERmNW94QzhLWGRiejJMelhCMG9q?=
 =?utf-8?B?WVV0ZThCQ2E5ZjN1K25rMGxjMlZ4L1Z6d0tPaWY3emJPUnR5WTYvekROelZu?=
 =?utf-8?B?dm1QZUh0MlhWdXhnbUxyS0IvNy9XSTF6eWxDcWlBVzd5QVE2YUFrcHpzTm9S?=
 =?utf-8?B?dS9tbnFRTklSRklVTktWT24zbExDSCt0QXBTcVl3M240MkxTSUZDeW15M1BQ?=
 =?utf-8?B?Qnk0TVozSjlrcFA4a1FObEJkR0k2RlllRjFoUFdacllvbkxlMVZLSHFlejVs?=
 =?utf-8?B?WG5yUjdBcjEyZTNhQkVVbUVlUTRDQWNQNGVmR2F0ZHBORFgzR0RzdjJCTVBB?=
 =?utf-8?B?NXgxd3g2RllmN2E2YUlwOTN1SXo3SG4vVFdsZlQ2bU1DTytEanVpMVZoQVZC?=
 =?utf-8?B?MTlTR2tJMnhiTW9iRkNpNUN4RmxlRkNEQlMrZ2dMSndDWGxONmM0N0tEYy9Z?=
 =?utf-8?B?RE42UWNES0dLUXpkUzBjSFA2MmNJdWxZaEhnM2VLVWdsUUxoQi9HMGJtQVJn?=
 =?utf-8?B?YmtKZGR3NkQrRWE0MmpXcklGV3p0aklUaXFCT2xXT2p2a0FZWCszUzFjSnNm?=
 =?utf-8?B?c2tOdjFsdXlocTVyQmdFUjB1ZlFhaGRTUzVyNEg4bG5DYmVRUHNDY0V4c1Vs?=
 =?utf-8?B?VG5WNjE1bzVhNVRreGpGYXlOMW5McDh2K3JiWldPR0xESm5BcEJydS8wOE15?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xGOUT7rR3Msocb06fMUyXVoyPPTP4tOm3hWCYIaY5nGsq1CvEzhrbMd7NFTJEldkMFeZlYUxJ7eW2pGrH1N0UuBrlObJr6JX1U8GTj9oworJezbbI7R7fGDbdzcvOKsL56G3iGZmqe8QdkUk0i3BixSOs41Rw2YQOgV4dyDGQtOTe5ct+LhaNeuq5w8Jemg8XVREg1C4eAX8YcqVmSyyUr4/1nZF/mKwQxBYiqRynvZ451jZCNphnrJZGru4rapXww3fvJkqNFP8qRFEXLApA5mF9iquWURE4zQIX3jypsWOFOGCmjgHh3OdaYNGl+E62p58HuUCTaDyl3BOjdi9QK0yHNyn40BIQ249CKsFIZC92KB7q5C06a7bo0SEiVwJFWQuXjiGxYoXLPIqRIKBdm6pazdOb4Z7kFtsi6HkMjvlCaERyVOMXiSj2issi7GgEpkLL0t49XT7+5By8xXXFhhTrH93LRjPwiysJHwK8Jh4bLtq2xHfTAsNWZ7N1ITBR4RNyrwFOe1nXCx1n9zYLPv/cB2Tl8sIbbaGD/hmjElggBKShKFf+v4pEPrJdmWZzhQZf7HT5jDfkAq+7MnPIcwPbj21+zWjIwYsnvNcAIEQJeC2GKDp585h1gcSpOsMabgl2pf6oo8anSnzaEgVc9aZhR27pQam7EMF0f0jaDGJ06IHuR1E1u53mUQr48qcSrjPyGbDpd+KQL1jQNrqF7quIvSj4u44qMkW4a9Wfw9I9nO/9Qv3RhPEfChSEKK+UUJ58S9M2OPhpK1VKwVnwHThbx/LXLv8oJOKteKOXtyzgG+j8XYK3XTmMnt1pF9J9BezN7wbWo7iym+5sNzWHipTJ8R2juKQ/xcmT8ZvM/sO/tPdfiaIGOJcw52SfcGt
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6461dcba-7ae7-438d-9710-08dad20be798
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 13:16:20.0387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kzci+0Wom9vmE93/eWgJGHCbofrQVnGmijNR/5hvGgR9kC9MyiuK5bH3xFHaihW/qZgyYKIlncts+vhd0PpPajGLIDdgmcyCv98Lgq0e/a8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6366
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_08,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290077
X-Proofpoint-GUID: JXPISVitgv7oLH5OWOGdtInU14SV24eg
X-Proofpoint-ORIG-GUID: JXPISVitgv7oLH5OWOGdtInU14SV24eg
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/11/2022 11:28, Joao Martins wrote:
> On 28/11/2022 22:48, Alex Williamson wrote:
>> On Mon, 28 Nov 2022 19:22:10 +0000
>> Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>>> On 28/11/2022 19:12, Alex Williamson wrote:
>>>> On Fri, 25 Nov 2022 17:29:56 +0000
>>>> Joao Martins <joao.m.martins@oracle.com> wrote:
>>>>   
>>>>> Commit f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
>>>>> had fixed the unaligned bitmaps by capping the remaining iterable set at
>>>>> the start of the bitmap. Although, that mistakenly worked around
>>                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>>> iova_bitmap_set() incorrectly setting bits across page boundary.
>>      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>>>
>>>>> Fix this by reworking the loop inside iova_bitmap_set() to iterate over a
>>      ^^^^^^^^^^^...
>>>>> range of bits to set (cur_bit .. last_bit) which may span different pinned
>>>>> pages, thus updating @page_idx and @offset as it sets the bits. The
>>>>> previous cap to the first page is now adjusted to be always accounted
>>>>> rather than when there's only a non-zero pgoff.
>>>>>
>>>>> While at it, make @page_idx , @offset and @nbits to be unsigned int given
>>>>> that it won't be more than 512 and 4096 respectively (even a bigger
>>>>> PAGE_SIZE or a smaller struct page size won't make this bigger than the
>>>>> above 32-bit max). Also, delete the stale kdoc on Return type.
>>>>>
>>>>> Cc: Avihai Horon <avihaih@nvidia.com>
>>>>> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
>>>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>  
>>>>
>>>> Should this have:
>>>>
>>>> Fixes: f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
>>>>
>>>> ?  
>>>
>>> I was at two minds with the Fixes tag.
>>>
>>> The commit you referenced above is still a fix (or workaround), this patch is a
>>> better fix that superseeds as opposed to fixing a bug that commit f38044e5ef58
>>> introduced. So perhaps the right one ought to be:
>>>
>>> Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
>>
>> The above highlighted text certainly suggests that there's a fix to
>> f38044e5ef58 here.  We might still be iterating on a problem that was
>> originally introduced in 58ccf0190d19, but this more directly addresses
>> the version of that problem that exists after f38044e5ef58.  I think
>> it's more helpful for backporters to see this progression rather than
>> two patches claiming to fix the same commit with one depending on
>> another.  If you'd rather that stable have a different backport that
>> short circuits the interim fix in f38044e5ef58, that could be posted
>> separately, but imo it's better to follow the mainline progression.
> 
> OK, thanks for the explanation -- lets then use f38044e5ef58 as the Fixes tag.

Meanwhile I've sent v2 with the tags I got here, as I'm going to be out the rest
of the week.
