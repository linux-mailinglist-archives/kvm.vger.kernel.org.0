Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EFC63BEF3
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 12:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiK2L3Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 06:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiK2L3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 06:29:24 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4696142F7E
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 03:29:22 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATAeL55030884;
        Tue, 29 Nov 2022 11:29:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=05mwdskYg6VDiT2hmsV6WRYSD4nqAbJ0oD79VfkBY7Q=;
 b=NA8JMs8ea6/q3YKSIMaC9YGXgzrPRYNM8l6iLO6FGT0E2YlLgflVhHQC9DjwFcx0utWQ
 spd3us9Svhmw1PX+a0CxlvK+vbh921kX4ntycW0y0N/y9Pq5yfK4QL0LsLTY5Y/MDnBC
 SRkARNIj7Ejz9DkaGWFnBnxM1Oa54zYC6b579lSsua9nOvcXARIKgg2TZZd8aXRcv0m7
 qxxfm/qvHiABb0+nCLrgi2EbMzs1KaV6UD9YsnEJ9nyk7CmmPxx+JPfRg5syUuBiGMZ3
 4vdNl9Xybpba0rWJMTyYxwfnZnbePaUviibWJ+geTOSSWQLeR1E/i2ueGHzerCrce09g nQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m39k2pfwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 11:29:19 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATA91TQ011407;
        Tue, 29 Nov 2022 11:29:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m398d83jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 11:29:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlhawYaGTZBqt/8wqtm2JW5lw7VI/1yVBIkm4VeY/184ufBINEBQ0H3Q24V+JkhKwU4lf3zhFolaTHRy97ClIl0UX55G+smo6dcs4TAPHARR8NqXyFsl8+nGT8YZ/HiWCtfTCZIWuKalth+y/NL+PgLAQKMusS7b5fNoOELxLeJRVB2zwDOzzCkazwpiXnKG0ele2tJ5YfEmN23OvMOrx/0TYaukcHr2KXmwfcDF8tOsUUwcBJA3tvEefrVQSqpJnpeKGlmt2eKh0/1Q0liJKGPFz1HFH81X8hYeMNABJ+Sl+YXiIJNFXby8PvbG7A5nS7f7gs5qz1yqzN2X85iiRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05mwdskYg6VDiT2hmsV6WRYSD4nqAbJ0oD79VfkBY7Q=;
 b=XbTp95ao6MFiiTqfinINXtyZesR1w4THBEwF6KYgO+k4ewHRWsGgbJVoX788vSmc4LAVxmjMunqm7wtcv3OTVbOGI4GJ8IH0sQ5aAIvKGyMY7BsVr0Dc7Z+Vr7ygz6JThZgIKduOChm5AVJymEjC5TxOfqG+bX+9SceC5SZ3T5pnW6JHJY5sOiZcEOeGyJBiBp9d2IW1CIT4j0WIf1xPn0E4fUZZvfGN3X7pIOeF30pe53Z60MxesxC6nAOqQVXs8zwgDOQRn+lTi7fAl17wD5vz3ifjDEmvHjfQxVlz94BnH7FCVvQmLFyhwWp0JR4n0cCRdd0CbEHWsJo87Sx5PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05mwdskYg6VDiT2hmsV6WRYSD4nqAbJ0oD79VfkBY7Q=;
 b=ZULKF28ZmZQh2n+j3PKghrUdz5iZgJMyCJFat4xiBegq9aGURcr1FQapNmtFL31GUBU39j6g+opr0P8Nkn1yIsgBjN++P3GfLis70ktD1hU6f2obUEcDomt5KiIDGUaHTYhaC0DMjNU/TsuTeJP77DOz6tXIECTHRZ9BkuJnCB0=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by SJ0PR10MB4446.namprd10.prod.outlook.com (2603:10b6:a03:2d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 11:28:48 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d5e6:f75a:58a4:2e40]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d5e6:f75a:58a4:2e40%9]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 11:28:47 +0000
Message-ID: <bdee988b-4191-20d2-b0f1-46a70389064f@oracle.com>
Date:   Tue, 29 Nov 2022 11:28:41 +0000
Subject: Re: [PATCH] vfio/iova_bitmap: refactor iova_bitmap_set() to better
 handle page boundaries
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20221125172956.19975-1-joao.m.martins@oracle.com>
 <20221128121240.333d679d.alex.williamson@redhat.com>
 <77c2ba5a-2b5c-9a47-32ae-13e5a6960d05@oracle.com>
 <20221128154812.48061660.alex.williamson@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20221128154812.48061660.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0028.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c1::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|SJ0PR10MB4446:EE_
X-MS-Office365-Filtering-Correlation-Id: e5b5f64b-b2b9-4882-aa9f-08dad1fce1c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qt/dUVrRr0jO2Ja3DweGY6YQPN2buvZudneoYTEzbQ6Rz/Q6sefhAX+TqvvBvDrFtjpOkahtQSkANjoE67judBN3CqJv2FWsR0/tTjCdBlYQnbnvJJlG8d+QL0u/cKmoNO4uQlTESS1VKMnQYFuGBsmOyjclzBlU8P33T3P5S5ZONzf0yO1iRA+rYTASi0N1zeqBLTjsCVEkayatvG2wR7b0zuNLn2fqMoUsP2z+tCsBuNNZrP7xPqLvJzK8r9WzyHVMnrdTuttlhdZUomtEQiXtiezljxRC58tX1AshfigUT1CD/TZ1ClPOrLynobDAx3vf0se/ODrfIPUlq/guKoXEMd6paZOvl6btdQHFVGRbsZuJ2pqPSPGx4O6DivTDNusw7/mYX1p8xM4KrtPuuV9TpwIlQ92YNJ8ltirQrSf8vZA+v+rDAVk0Mm6bpxTAGFOkmcOhhM9vvFRfHGko4NMptqPk43NspxPwtZplkuXw+Z5V8Y164f3I+hEcht0Mj1n4puqdEJ2FqBY+98sZWuw2WajtN8K1AvjfhJqkWWhX+WvZnTClUZcQoVYIXHh3248QjpT9o3nVKnZQmwAeXhaeoLOaY7PRy2/NwM+sUKoYSX3MroaStoL6glh1xdFiGEdeSRIJuLKhf0NmzMxH5rW2YtllXqTSsJRTrb8lRq6fXBP1LinqBfIpiCfkVIHh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(366004)(136003)(39860400002)(451199015)(31686004)(86362001)(6666004)(31696002)(478600001)(6486002)(36756003)(2906002)(186003)(2616005)(6512007)(83380400001)(53546011)(38100700002)(66946007)(41300700001)(6506007)(316002)(26005)(66556008)(8936002)(4326008)(54906003)(8676002)(66476007)(6916009)(5660300002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZitLWmVzeTNwQmZqNEsrL0NqM3gydzlKSWEvV3dqL01IN0VWeW5ldUxuZXBq?=
 =?utf-8?B?VjJNSGd5SDRqUXdEc2t2YWh3MUVEb0hJR25Oa1BZeUhKWXJ0V1RiUTJyMjZq?=
 =?utf-8?B?MTBtTU85MTlwSnJGYkFaTThId0FWWmZ1aWJKN0NGamsvbWN1VVdrZGxDa25S?=
 =?utf-8?B?WWhJN01pZ1V1bmxuWXJzb09PU3pLeElKSGhUN1hacG9JbzFHcnJsa0NMSVVo?=
 =?utf-8?B?eVAvbWdPNzVLU0t4ZzNiS3gxTDRBcWRYRXVGUkx4U3ZBQXVuaWhRU0tmL3dS?=
 =?utf-8?B?eCtZTzJOLzY1TDgraDM3UDF6cG1mNWdOY3lmYzEzeUduVjMvbTNNbktCODBL?=
 =?utf-8?B?UG1vb1B1ZU00WDBQRERVcVRkMHo0aTl4VmRzQUU3aVI3VjVFWWh3U2hFSE1K?=
 =?utf-8?B?clR6enVHU3Z0aENyM05IRlRpaDFkcEZYbk02cnFac2JWMk42NXlnMnhHWXJm?=
 =?utf-8?B?QVFTT1hoc2YrSVI3ZDRFbC9QRDUzOGpadUEzK2QyWGJlSXoxN0N6cm1BRG1W?=
 =?utf-8?B?ZVdkNHhkM2xhY3hkTDdUd2cxandXa0NNcktEamRWZnZCSWdUNHJQOTYvNS93?=
 =?utf-8?B?UXErUHBUeDJXR1RlWEcxWTRhL3dWR3hVaEZDSXpPR0JuaUhzR2RQM0dVZnR0?=
 =?utf-8?B?T1BYMCtrZ2VDVTRJRnpjZkllN3hWVmZCb2tHMFZZekp0OEJlT2ZzdTVjdnZx?=
 =?utf-8?B?d2NoamlOZEg5LzByMXlMemlXbUdac3Z4OG9hMFlXVkhjdVNNNUZHTXEwRVZy?=
 =?utf-8?B?dGlEUkhxZXRwcFViU0JiOWMvM2lmbFBCWGZlNE9PcjRtcmc5dEZXdW10RFpM?=
 =?utf-8?B?bnVsT290ZWQyRFQ4b3ZZV0JGMGkyY0tEN1VLTE1Wbkx4YUFzRk1lL251d3ZE?=
 =?utf-8?B?aTc2VHRWN09oMVh6aVQrNVlTNVByMTNkOS83VDF6VFZzZHViakJ5VlhrUC9h?=
 =?utf-8?B?V3BKaUZwYzV5WnZSRCsrdC9CSjVlbHQ5QmpPY1VZdzhLN0d2ODdZK2ZpWVha?=
 =?utf-8?B?N2JJRmowNEFUa2dobWEzdkhub3YydWFGaG1CaUMwelkycjVadkg1SjRVVG5x?=
 =?utf-8?B?Y2MvbUVMU0tOQzYwa1kwcnYvNWo1VFdZMDBmNGNmU3hjYnZHMkNJSHBIaXND?=
 =?utf-8?B?YVl1bnNmL0xXRWd1V1RPZ3ZaTDR3VW9TdldweVQ4U3M4cGFSR0RHWmlZdnVV?=
 =?utf-8?B?UXlTdWloZkxHMlNPYU5MeFRDaUozNlZDUlM5Y0thMldycWlMYitTYlp4K0pN?=
 =?utf-8?B?bjdwbXJQY3lxd0x0VS9lSVZMY3lKNVd1V1dPYjVDV29OUFVoenUySjg3L1Y0?=
 =?utf-8?B?Nm01a0xBWlhPSldvbHFaMHRQMW9TejRqRG1JSUxYQjE2Z3ZraGgvTHpUUmdC?=
 =?utf-8?B?eFpoSHhmUDJ1UnRudXM5WkRXc09iSHJUM3BLRVZFOFdVUXF4c1pJUjFnQUdN?=
 =?utf-8?B?R1VrRXdSeXE2OU5PRnBMMTVRQkJCRmY0NlE4Z3QrUDVrNGtxNG1JeCtndmht?=
 =?utf-8?B?bGkrSWFYZUJLZjViQ3htNCs5Wnl2M1V0bFZySlZNSjQ3TG1oelFnemFxK3Z0?=
 =?utf-8?B?eC9tMU9ZK0pqRzVaWnRvSmpYVGt4aytiRDEzWkdCSGtTRk8zZGhiUDBRZlFM?=
 =?utf-8?B?M2xaNXVaUUM0OFR4ZWg5cFVNNTVyN0FKcnNkQ01nNml2cjVneGVhZk5xeHpk?=
 =?utf-8?B?bDNNN0t6WnlrUC9oZ0ZDV0k1OEZXZ1k4SFpvOGRjUHlsRHoxU1JmbVUzR0hs?=
 =?utf-8?B?cTJ5OEVPWTF4MWVhZ1gwb1duTmt1ejRxT3JTc0VZQjNZQ3FZTU1GaytEeXlt?=
 =?utf-8?B?WjdtR09BZFhTQk9sZjBUeExUd3Yyc0VzOWlUL2dteXpVV1ozdFY1dUVhSHMy?=
 =?utf-8?B?UDduVFA0Y0JNbXB3UDR2YkZwZVRtTlNYWXVKcmJ6cHpxVlpPVUppS0FmVU52?=
 =?utf-8?B?bGkvZWtEYi9vcUUzdjZWUFAxa0VhbDJBTWNMQnJLUzA2aUU3MTFUK1d0bHNE?=
 =?utf-8?B?UWVQZ043NktDdW9vaUZ0a0pSNzJIcFZiZ3EwM2c5TmErRFFyZ0w3KytSaFE2?=
 =?utf-8?B?WkpZZTlMTlhXNnY3aXozSUR4a1UrWURrSEJwSUJ5SVA2KzVvbkp4Yzhtc0tL?=
 =?utf-8?B?R0tyQXpka3VOeHFmYWxHNE1ONk8rdUx1V1JvZkFpb1hjOTZqUkhkYU9ZcVIr?=
 =?utf-8?B?Q1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: uCW4hyETwAnjlPntggpTvJsjmaS8in5rM1TBZSvkPq9FfBwBy/FHE9Ylnof2PwNA+33BrM48CCo++x+iIr3TOrdeWaCfn2Ov9LJFPZ+BhbFbse+U2ufMagWlz9W2xGylQyL0LgpffF27p0yqymB3ln47QEeiPrVgArj5HIoQl/LtZNFk2xWKLPLU1Zs5xKC6PDNPXtvktVWYmw7chz707cSlfL3jneWYYS8KtLxaSsULEL7/Yz48E9i2V2G++H0W+C5z5v6hWG8mufxZtZE5oXK8DpSfnPT93iKg+Z3a+tkQapH5mdiOcbS0OEDRoRF1kvQ8IwqUPXXQwLcI/QRHAJyAer0X/tCnI4NAufJClhiI/pEwS34bf7Ve8T8bo3YQ5YeDAAJcQiwVetKQQ0xZEqkDOmwvVbvnD+J+OMjI/IdqNq3XzdnhzsjxySlw1ZNI44hJYE/RQAn9FgTTU7iiGMght7nBwLg1w/WJ73XrohVBrkPuq4KTAMZXLl9Eh6TjouyQSElGw/exJXP7gxIdsoj0dZJmcaMWmRtKce8cy5orsZwxwy+/3aDuN/LiXiXSXhoZdCPlNgoVdCihsUZdWNgX516HfMURHrjfWI4Jlmb80D2ZCodKB7zE8TTh7qnHMR9WwkJAb8QsQSXeNXxyIByFAB9YJ8Gk75wIjMv10XcsQpemtIn1XgTK7/+ZeJ2SQbzI5zX3KxUKAwNcVSA6BPBB2QtgmdKcNqPykzqMOQzJTdjAILgXObTzd8+1bltwg0L7yH2/absShlP2SFrrMkGvupJnqboZ7A//WPa/Le8rEpwQCKA1+1PfS7B7yU55KsqToUwJeHCxNTAVpE+snSkbiBamoDNNqXa82BGL7wP8Y3IGbWfLouurNk05akmw
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5b5f64b-b2b9-4882-aa9f-08dad1fce1c4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 11:28:47.8259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lciw1sExH4xUPT4mEXHKO9evfmHzEkyGz9aueeR5hKpe/5WIHlPkgP9VVZbfrGH/O9f0AXzMA4X0mURWhHukR5D7vK3t16Q+PRHWbwWYHag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4446
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_07,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290069
X-Proofpoint-GUID: vJFfkBX8-tr_7KLHtQtK_9i8UkZZtKto
X-Proofpoint-ORIG-GUID: vJFfkBX8-tr_7KLHtQtK_9i8UkZZtKto
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/11/2022 22:48, Alex Williamson wrote:
> On Mon, 28 Nov 2022 19:22:10 +0000
> Joao Martins <joao.m.martins@oracle.com> wrote:
> 
>> On 28/11/2022 19:12, Alex Williamson wrote:
>>> On Fri, 25 Nov 2022 17:29:56 +0000
>>> Joao Martins <joao.m.martins@oracle.com> wrote:
>>>   
>>>> Commit f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
>>>> had fixed the unaligned bitmaps by capping the remaining iterable set at
>>>> the start of the bitmap. Although, that mistakenly worked around
>                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>> iova_bitmap_set() incorrectly setting bits across page boundary.
>      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>>
>>>> Fix this by reworking the loop inside iova_bitmap_set() to iterate over a
>      ^^^^^^^^^^^...
>>>> range of bits to set (cur_bit .. last_bit) which may span different pinned
>>>> pages, thus updating @page_idx and @offset as it sets the bits. The
>>>> previous cap to the first page is now adjusted to be always accounted
>>>> rather than when there's only a non-zero pgoff.
>>>>
>>>> While at it, make @page_idx , @offset and @nbits to be unsigned int given
>>>> that it won't be more than 512 and 4096 respectively (even a bigger
>>>> PAGE_SIZE or a smaller struct page size won't make this bigger than the
>>>> above 32-bit max). Also, delete the stale kdoc on Return type.
>>>>
>>>> Cc: Avihai Horon <avihaih@nvidia.com>
>>>> Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
>>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>  
>>>
>>> Should this have:
>>>
>>> Fixes: f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
>>>
>>> ?  
>>
>> I was at two minds with the Fixes tag.
>>
>> The commit you referenced above is still a fix (or workaround), this patch is a
>> better fix that superseeds as opposed to fixing a bug that commit f38044e5ef58
>> introduced. So perhaps the right one ought to be:
>>
>> Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
> 
> The above highlighted text certainly suggests that there's a fix to
> f38044e5ef58 here.  We might still be iterating on a problem that was
> originally introduced in 58ccf0190d19, but this more directly addresses
> the version of that problem that exists after f38044e5ef58.  I think
> it's more helpful for backporters to see this progression rather than
> two patches claiming to fix the same commit with one depending on
> another.  If you'd rather that stable have a different backport that
> short circuits the interim fix in f38044e5ef58, that could be posted
> separately, but imo it's better to follow the mainline progression.

OK, thanks for the explanation -- lets then use f38044e5ef58 as the Fixes tag.
