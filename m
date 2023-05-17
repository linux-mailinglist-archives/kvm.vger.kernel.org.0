Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615EE706CE6
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 17:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjEQPeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 11:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjEQPd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 11:33:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDA4AD3B;
        Wed, 17 May 2023 08:33:33 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HE4f9P014551;
        Wed, 17 May 2023 15:32:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=MGC725wFGV+LRKeBSE0VZqDAwNTUQBSmaEipysj3IRk=;
 b=uI6Hv7070yAzLe08YFqfyUgeVb4XUdhd6S2iVMGTXER/1ckNHzDSHiVFA5y+Jq/yn4pW
 bZPgw8oPdrVRzeF6grOrFvzFCpzFiOSXWVGJzF7QEiFC5aGM2HAQeuPILX/o1h5Sro+N
 gs7Hl2ZmDrVLS5I1xv0nwpRqixRni/RC2T3CLioBOWoeoPCU4CnDzZXIgc3+FL4wDaIZ
 kwGRlvWtKuUWD5+ApLK+Vtal4nqDJukswJ5/C0+7iJ6ayzPJwVEirU5JTLO0DM+0FL2B
 gGAtYBNL4gcbDDuiyE7S9jHsXxRjOACVvZ4ZMBuPiDH1qO8mDGHIDI0nJA0vkdOz2490 gQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmx8j0k25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 15:32:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34HDrwFF039976;
        Wed, 17 May 2023 15:32:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj105b6uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 15:32:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHMHmYQoXbOvnt8QmCzo4hCH33BIbjNOp+NkfvXD6Cp0xq2eJCfJhb3U0Xs6Nil3JpqVht6KyoDlMHkgRxWtn8rXSkKUPduGY3ROV6l6LYslMBUk7zy8Exu1i/Wwm589NcwefEUOHlfCuJTrjLz0M6Xe8mcgSvO6RDXU54/yAAC4G8zfPIZW++dYBBvkpDsryTB5Bk7g1A7E6jIosixNqK4G2QsEtVEVMGPVEDtlOvdManQfXJk5oG78WvCguDLOFeZZ+unvr4Fj28Z25ywoD52xqk//2Xq7UvagqH3Unv0ahTQZOpVZ12XTOYVSvMbV4uigBZRnsUsRdAB1RBUizg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MGC725wFGV+LRKeBSE0VZqDAwNTUQBSmaEipysj3IRk=;
 b=ZJHzR2i2cuZevHPzLOf+xEdwsiOlf3KmWG059QU776E00SGGPlvIgT9UXGW+WBdyk4x9nq7Bs41Yhd1oJTwyVYPabKy07lO2GRIZTt7isGfIhZAYV+08MGK4SmazD4dFA1Zcs/cafmUR3ORmgS0mXrC9KnlrUUqbe+U0PMqzRckLtUgaPzyhWykCWCmXeOKB1dtS+JSrIuEegUgQtxLVPSZZ7OrsaIHdPifrK6OjTf8wZ5mx1VjDkTY6BRrEunwnpnMeKKIgnYFvwid8foSaqkXy1AQ85NNoySOFSYqzfu1CQvoGFRYoQMZ96Um6AO/JzpoSyoVtkyjGw6hPK3o4WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MGC725wFGV+LRKeBSE0VZqDAwNTUQBSmaEipysj3IRk=;
 b=UYtxIdiE9rkIiaHX4Q8i2ps7Mb7MWvcUnuf6VkF5T6R4Bt6dcOBQXtyDudtwZzq7VImsQ6angvyEeA8Lj02IzoBGizL3RWKjVMaIIhWbbAQWDorLCGnpb2xuT7O1KSroaBj111YLZnCkwCn1Q+VG0/v3BqFv1MiRsZO8lDxpCGw=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DS0PR10MB6246.namprd10.prod.outlook.com (2603:10b6:8:d2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 15:32:32 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6411.018; Wed, 17 May 2023
 15:32:32 +0000
Message-ID: <3d05fcf1-dad3-826e-03e9-599ced7524b4@oracle.com>
Date:   Wed, 17 May 2023 16:32:26 +0100
Subject: Re: [PATCH] KVM: SVM: Update destination when updating pi irte
Content-Language: en-US
To:     "dengqiao.joey" <dengqiao.joey@bytedance.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com
References: <ZGOnPMTEKqRq89jt@google.com>
 <20230517120458.3761311-1-dengqiao.joey@bytedance.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20230517120458.3761311-1-dengqiao.joey@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0131.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::23) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DS0PR10MB6246:EE_
X-MS-Office365-Filtering-Correlation-Id: bfa9ba93-0160-428c-ed2e-08db56ebee7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qDQFbV4Hl+2DD2vqjSu7+yh0x9r0GBVAIQk5qeSvL30zMgaXQ9ZKSq3w8J84/NhovFTtR2ifWgz/jP8ES/NSvkBZ7p4qKYlyXnW2vV9fzezwwZ1RqgwjwFM8xmSq2tLt2luUk27HuuhuEhtEtEwi9ozIe4MXY5cQxzCrM8858nfuyHmEBrzLZiVMSDU2PaSMCKR+CVprGCBzy/bUaBgdcyW68Rv5XfMzSg9qUzTTD4aOqmfrWQzEunbZBYVg4oQpYpZyVVQAT8fMdPT0kCgJVh8ZNDTmxnfipeBLMYlbepyazXnwrtWPQHtx+4a3U1GOhmalEXOMOrx2cQywwfxq4KDXlyDn7icP5K8sUTfOOyYWyt/9FD1rbdRzNaH/A+GdXoykVjYQ2dv6V2yxueZxx7dkWp3m+PY1rfNBqXduQb2pAD0e69syncUHZ9G2vkcAJgzQ8jKdvcnbD3eZ3Sr1D0ZB6JmeoUEtJFe36OrPtW1q1iPxgUza4vRc3DmzVxajYO3Cm5ybzzSGgL/kEe3xQed4UGxp3iIR7Uutg3q0a1j4Imvx6bDx10/e04g8hoK4B+534rs7o5EQ4Gap1DcUApiFAqJjVOxg1sf3vRglIf408lCP4QmogWIUjr4MXJ2F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(31696002)(53546011)(31686004)(86362001)(8936002)(5660300002)(41300700001)(15650500001)(38100700002)(316002)(4326008)(66946007)(8676002)(66476007)(66556008)(2906002)(6916009)(83380400001)(2616005)(478600001)(36756003)(6486002)(6666004)(186003)(6512007)(26005)(6506007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZG9PWkpIUlI3SitpL2s5MW5XMlplV1l5OGhQVU9NYUVTZkpFRXRyempkYndC?=
 =?utf-8?B?NVB4eHBqbXhpWWFKVUZzRWQ2UnFvcHFHMEd2QzRFNGtuN1NzY0JMenYwM2E3?=
 =?utf-8?B?R0R4ZHcvR2tTeGtGaytJS3BMdHlyZ2ViL2p6UDBXc01ES0JpNmNiTmMxNEhB?=
 =?utf-8?B?TmdpemxxQzlTT1I1VjdsclI4YjlHVkVWOHhkQWlER3NZZUx5dVlscTZnSjZu?=
 =?utf-8?B?L2o5Q3QzRHFJRXdDZllqbFVBRTVYQzdXczZsd0J1cWp6RlZpdys2c1hHSk9D?=
 =?utf-8?B?RmJBTzk0blBsZW8wdDNOVUFydFh3UzN6TS8rS2twRjVtZFpIR3JOWWFiTFBV?=
 =?utf-8?B?Y25TSVZmVm9KakhiM0ozMmJOSjVxQ2JQa0s3aGxkdFhMUTdZTW1wMS9HL2Mz?=
 =?utf-8?B?bTl4S1ZjZlZDbjc1ZndoSzhlR2dpNmtmRjZkelFUYlIxSTFmaWFzVkkyY2R6?=
 =?utf-8?B?RVlIY1ZQMG9IS0U2ZS9KQk8vc1V3Q09PUTcreSsyNEVSTWNWeEZxNkQ2d2Na?=
 =?utf-8?B?dGRWaFlLNnMzR0tTZUp5alZFNmFUSzYrazRxNEduWTQxUUthL1ZDVXlmSE9S?=
 =?utf-8?B?R2VRY25ydzlqV3ZTU3VUL1ZZZzlSalQyTWd0dk5qanU0MHdNYWZDdXBrWDNL?=
 =?utf-8?B?VmVzckJ1U1JqeU5oTzM5SkhJT2prTVNmVzBXcWpXTWxwN2xlVDVqV3ZrRm5L?=
 =?utf-8?B?WU1WWDBLV3ZlOUJCdUU2alYzOHg0MmR5T1MzdUpPbDNWU0NaQThobmlQWXI1?=
 =?utf-8?B?SHd4T1BNbnNiM08yalI3dkM1LzhOQkkvM1lQT1FIYlJvNXY4bzBIamI3V2w1?=
 =?utf-8?B?QXNoRUsxRkdCbE1qeVRobWs3NDBTakZXcm9wVXpzaEUwTktaREc3cDR1cHNm?=
 =?utf-8?B?RXYzLzltZVkvRmNXRVZ0NDNOdEE0OXhLcWZhbVdoR21sT1dPdUwxMnNBOERS?=
 =?utf-8?B?QUl6SGEvR0gyRmRja0NNVUFKdnBHZHVWLzByS2hidDNCT1dPMVJJZ0ZOZkhV?=
 =?utf-8?B?ZlVuTkhMY2YxdkhsR1lsMTFDRlVPWFY2TGtycGJ6dzgvTElRazBkWnE0RElW?=
 =?utf-8?B?dUk0WUZVTkVHQTBYNUZWVGExVllsZDFRNWNURXJtaGRlNkVnaGRHL2t3NDVF?=
 =?utf-8?B?N2xkU2t1eWlXbSttY2lhNXNEQ1Q4T3NwZVVxM055cUp3TEpEWE1qU0JiWW9K?=
 =?utf-8?B?Mmx5T0RoSVF4OU1Ua2gybTlsNmF2bXVyZUlYZXdaNDBnVjZGZFE2OTdoZDFW?=
 =?utf-8?B?ajBWcTZDUEdNSVRXdmtqckkyZmRhOGl4VTJjM2pCTzhaYnAxNmJYME1JWTlr?=
 =?utf-8?B?VGhKTlNiQ2ZkMHFmM1NYMkNCZjE0dXFWTFpXc0J6d0Jrdm12VFJlTjZWODJs?=
 =?utf-8?B?eFc3VFUvSnZtWG93eWcrekI5R2R0cmR1blBPN2VIQ3UrWU5mSCtrcUZCS1ZB?=
 =?utf-8?B?N1NYU2dXK2xGelJnRVhEYnViVWdadVpmOUtyaEVNK1NBZGlkcGYwNUh2NHhF?=
 =?utf-8?B?d3BuTWtlQ0pvMHZVaDFaV3Y5Y2liZkc4Vk1KZEt5K0U5cThIZVlmUmkrdGl0?=
 =?utf-8?B?Q2pjeGU5eTZSYWJ2Tmc5OFIybkI0UkFrc3FUcmFrY0NRU2orM08yUUpjTm94?=
 =?utf-8?B?R20zSEN3NGo3bVpLSVVxSzRHTnBYeUcwYlp0dlI1WHpIWUc4UjBFY1BZMDVN?=
 =?utf-8?B?WlU1SmRsQW54eEFuU1BsaUIvY0RMVFgrWTJnY3RpYUF3U1A4ZnFJUDBpTG9N?=
 =?utf-8?B?c09uelNGTFBDQ0tQZ3VtT1djSnBBejV4eTdnYzhkWVFWZnZrRGNtaUdITTh2?=
 =?utf-8?B?Nll4Nm44bDc3ckZ1Vm1JaGljbkM3L2RLSGI2UnFVUnFxWFJDb2krMTJLRjFk?=
 =?utf-8?B?Y09BWEN3cmEydVpENDdlRUEycU0vckd6cGhOOXRDNnNxa1RZa0FlOHVWdVhW?=
 =?utf-8?B?alJZOGorRnlJM1FVSFlqZHN2T1EvdGN5WUVHNFN1d3Q2N2hXbTZJTk5kRERq?=
 =?utf-8?B?VXlBcjlkenJod3RvcFlsSHRHOW9WVjl4OHNvSzh3bHo4aldmODJYajcySVNr?=
 =?utf-8?B?ZUZMVWY0K000NU1UY3dzcHNvcFlTRVZFOUNRSytIWG55K0VodzVZWHlkQUJp?=
 =?utf-8?B?cWlmMURZU3EvLzlYZzljS1IwKzlpNWVEc21ocDhQSnpqZWoxb01QYi9kMVUx?=
 =?utf-8?B?YlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gm1ANUXLfT0g6FAxfbOfVZn4ggbknMSDQJXFDz/GUmmtZT5N8dGTeKuOd9cEZ8ns/0J6W5QhjHdqSWpDbe3OXN2XY7b9XydIr3gOACj0HGKtala8+HAL4J+k7UeDnJ3LYyIlyEAbh2UaKO7MTcQMXbjK81RVBAdYEHioBa8F26ebEO0Pg1LNvMAW0f4U0SkunbJRfn5e72trRIkdtvC73VV91A198JMIAI3eXxEceQW0CQxCC35vF8wwGe+VTTYVMM91+myrnSc7yXl3QCbILl/LAgsYOagaMDzY9fpG72EWfBF/ZjpgN4DY1RJMJKUYIaezijAwIbU2I5Nugfo/6wIla1MRFz55fsQlCKv0ahXQU/77uUD/dEk+nanka+b3jf/u9kIKsk4dGPaBlFiW6n2KSabjkD2PRlY7tIvH6hkJAZYQb75Ka8GSCnSP9W49Y2X57ZNAG9OGjCuES07dp7oJp5qNFPci6MS28DQKs3FpsqEdT/jI0zDhP5zRz722h/nQb5Z4TU9BnVm8h8/1vXVZmE0Cu5OXG1V/crFYIpuu3CqxYmYOpm86q4fYuYoXF6DKp2V0csVybySxNhJAE7CLMDhxWTX0eyBwXuVWh12YHtKlef3wuRvb9IuaOHx9sglSOGpx/+x9DaZzTnaFQTk2b3JQV7vRBut1QUgtDwxZO/wlEwkifwBEYyExlmCcya737/ddg8neVuEJ6XsG6pQb0Ve8/8OGB7/D1n/fmClwXh55nyuAANgt1pK6wnaG0XITHH0wln+VEhdgBRbqJsHKGVCX3u+KRW/FoRKX/E2rZSRkyrcapEr1+26WCjCNo3jcoCJmV5WBFlnasycraie7XRnd7UoYnbW7Ru6IXwg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfa9ba93-0160-428c-ed2e-08db56ebee7d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 15:32:32.3653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DxusfpI8hn6fsbeBbCw/ZxksBk6gfBWlDnKHaPe3OnziAEUoWWmbgUZ+QLI5f6sIxkMJYQzEQNQnwCZPbZRKFYaVB2E4YNKfuph+AESD0tU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6246
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_02,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=750
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305170125
X-Proofpoint-GUID: rxH0MPrvEsMoz9wjsc_qaAf9ATlwVPRg
X-Proofpoint-ORIG-GUID: rxH0MPrvEsMoz9wjsc_qaAf9ATlwVPRg
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/05/2023 13:04, dengqiao.joey wrote:
> This seems to be a different issue. Joao's patch tries to fix the issue
> that IRTE is not changed. The problem I encountered is that IRTE does
> get changed, thus the destination field is also cleared by
> amd_iommu_activate_guest_mode(). 

Whether the amd_iommu_activate_guest_mode() clears the destination field or not
doesn't change the situation I think. So I don't think that is the problem
you're having. amd_iommu_activate_guest_mode() will always make IRTEs with
isRun=0. Which means your VF interrupts get injected via GALog events and the
DestID is meaningless there :/ Even if you leave the old affinity there with
isRun=1 bit it's still wrong as by the time you run the vcpu, the wrong affinity
will be used by the VF. More fundamentally I am not sure that on IRTE routing
updates in the VM that you can look on vcpu->cpu the way you are using it could
be potentially invalid when vcpus are blocked/preempted. You're changing IRTEs
in the whole VM in pi_update_irte()

My changes essentially handle the fact where IRTEs will be always updated with
the right GATag set in the IRTE ... and then when the vCPU migrates, wakes or
block+unblocks it will change IRTE[DestID] with the new pcpu (which the vcpu is
running on) via amd_iommu_update_ga(). So there's a good chance my changes fixes
your affinity issue.

	Joao
