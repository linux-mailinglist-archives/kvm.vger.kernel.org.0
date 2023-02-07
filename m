Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3BC568D53C
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 12:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjBGLP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 06:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjBGLPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 06:15:53 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DED22022;
        Tue,  7 Feb 2023 03:15:52 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3177nQAO029452;
        Tue, 7 Feb 2023 11:15:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=pw1RVatOn7/v1fCWpVtBlJ83m1LvcI1uTL4M6SA4MdI=;
 b=uCzqGBKPiRKVd8lVjitCgApE0tAL/jd0wxwqADikTgF/Q5HhM/eobRM5FAnz8zbPSZwe
 nyFhEAUUoYsYwvX0LAdVWkCtsCaBzmZ9vlABNR0gYDWmmuEIvdhBkFZmiDNxDAdP+UGS
 l5FaPT9Q++aRAqftbgTOjLv7GlBFs9lRgg4WpwQeMopMCfO19QXih+56WoAgQrKrzJPK
 YreAEbtfGfRj5vpA/+55G/oSa19nvsW8rbJjc6r+Kcw1IPnLT/Bz2wzRx9G+kRS+fDbZ
 /Sxov6FM+v3+dxHVS+9sCwPAwNQHW+4vDvxKNJp7RIRa71V1iY+Rk+GA3sO4QGlv/Hxt LA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhe9nd7fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Feb 2023 11:15:46 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 317AUhM8040850;
        Tue, 7 Feb 2023 11:15:45 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtbr6yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Feb 2023 11:15:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkyF/wzrn18tq1k0yliNr9G5P1UOgPefHSPaUqA6K/b+8GovJ8v7yqeo6i1+66cZeb9OAi1axGbB/gSNjvrqroW4oZlx5Nx9I0shMWBDpleXbXBFnzIc9LnQwV0Ev66oq4tiRMaZ2LRRMIYIra3TVv7qf/e+ESf4dgc6COMPfV/A/InPfKb+q5AexdvnOyxo+W08/5q3fPzTopmBOdM7htaFKP2oJQ3nT1uCRbIxNC85aJTmFlPr+X1haDGA1dn2iVDfIzP5dawtZkLejAFnW2Pblk2rtfyVmfNjrtgA6krAiaDZymmGiQp3cFdXJ8RDQ3jAVB7TtYe4XmVbK8zk4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pw1RVatOn7/v1fCWpVtBlJ83m1LvcI1uTL4M6SA4MdI=;
 b=nceewzeljMjs56OA8fW1ii/T6PONVeWfuaD6p1VCRS3J6ADhAKM4mQMv4vKtaT9G/DEblLO6lUMO2LXY37i5CUT5EvqD4ABhS1ELarfKYZjfZl1+nr/bjOL+eCSN8vfjyLLPonmJvB1VQxzJ6LW8YRPlNMjWnherxEcqJChN2ybbZRewZGBZGgHKbNfejVSWbVE2QL102gRKTiEYMG3M0bugb5rKgiFum98TRNcnQxdWyNZON1lYlaYXXyVhy4zdjF73Ccd4Eimpia9Sjzrc5AyoazXR5SQ70MsS0AAdyQV23NgV7WZLTBFD/N0yPpmCaFltScNZJ8DR96/bskYAuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pw1RVatOn7/v1fCWpVtBlJ83m1LvcI1uTL4M6SA4MdI=;
 b=J+1e7EWTowhKUY6yP/vZdW5jCZ4ssyOGLhUnRdR7maLHlwu40wf4sivRuQl73DuBIZRe2anVPxOaECI8tzAqbAkxnF6diZiHW+bGhK7Y/eff/rfNSSR0PuFnnVUCKL8e+X5m8XTiGBmHDmDLvionhuuPM08LZIw29H4drw/ZJ8c=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH0PR10MB4792.namprd10.prod.outlook.com (2603:10b6:510:3d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.16; Tue, 7 Feb
 2023 11:15:43 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::9b30:898b:e552:8823]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::9b30:898b:e552:8823%3]) with mapi id 15.20.6086.016; Tue, 7 Feb 2023
 11:15:43 +0000
Message-ID: <0e12d654-d388-a0f9-e7f9-7e96921786b7@oracle.com>
Date:   Tue, 7 Feb 2023 11:15:38 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v2 2/3] KVM: SVM: Modify AVIC GATag to support max number
 of 512 vCPUs
To:     Igor Mammedov <imammedo@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sean Christopherson <seanjc@google.com>
References: <20230207002156.521736-1-seanjc@google.com>
 <20230207002156.521736-3-seanjc@google.com>
 <20230207093350.5db155ca@imammedo.users.ipa.redhat.com>
Content-Language: en-US
In-Reply-To: <20230207093350.5db155ca@imammedo.users.ipa.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0068.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH0PR10MB4792:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ad80a3f-c2f4-4e9d-bfe9-08db08fca70d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5j+pcvu2vZccem0VnofpCiAgdCc0u8mu2g2wbtifDhZy7rbDLjp6e6hKnR1o5tlYtZlAb6gSRcdcKKHd2PjCfTDKdM2D4EvuRlPQ4ETS8fb5TcXGhLJoAtCMh8tnim6Po+p3RZpNyRNYmbPw7ZON1RrSDVQArz5emGpFrN0fq4ytbAfUIsOzJcPc/OnaalJxYxEsaY4Jsf+iY8GnxEwvynEnQN+T3DXFMu6lU8JzuRQS0xcdSRw5h6iXE3OgXkXIchTyR/X3FNpGzsziEtpiDUeWYO7fJoXYtYsk8SojRvVotZXVrbesxn8b5Hk4YEaumxVjtltAch0fYymuw/DrrMaRExQnR8hKmXSDAKB/Wy0NpDyQi2Bk1kqyrTPPIwF1Lq5DJd3U2gujsDeJl0McIndRy6GcxYX+jsbqG/070PG7q3MolKRKQK1wOjdCXngOKuE6gbsLfs60d67+sPmUUb9dZYAO+YL76w8sYa0FKNI+1gyahYgaYdc2wBM58SsKxqX405ujcGNItl91U4cwyncVumoM+jfSAtzgA5EQIpqCSoYWC6LaEqvG5p+aSYDWjuwZNv0slrxfoyRI7OogE+Si4ICqoLAxgHLYLIvEf3IOAHD74Xp9k6A70Q0XSWkJ+i1I7urtvx4NIrTmp0hEFF4W4W5gaTMJBiqHYC7LO0j8mX8DquDl9exr8C3m5XoIPRmNzzZJWH91U9Xx3VB6og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199018)(31696002)(86362001)(36756003)(38100700002)(41300700001)(6916009)(8676002)(5660300002)(316002)(8936002)(4326008)(54906003)(66556008)(66946007)(66476007)(2906002)(2616005)(83380400001)(6486002)(478600001)(26005)(186003)(6512007)(53546011)(6666004)(6506007)(31686004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWdNZ0RGdG1weDlBRDJGc3BaaCtFdDBhRytXeGhQcVNBd3p5N0ZVbVU0QkN3?=
 =?utf-8?B?WTVDYml0Ly8wSDhOcVRlNzNzVWF1TXF6VHM3bXpUbWI4TkNmMm13REZIakNK?=
 =?utf-8?B?SGR1a0hmQjBMZEEwL25tWjlaeHFMM29ldG1iOFJHMWI3SWhkV3MxcmJRZXdH?=
 =?utf-8?B?WDlOWW5PRVBJUDRldW4zbEZ2SzVhTzNmQkpUYkdjVlRRZ1VWQWcwNGJYM3Rq?=
 =?utf-8?B?RkQ0cllVMlRxZERKMDgxQ0o5WVBjeEdKR1Z0VWlvMWQxOThKRFphYzBrL1pS?=
 =?utf-8?B?R1lYREhoa0V5RmR3WGlLS2lwa0tsMldUOGJTMmVEa21ESloyZi9aWENJNWNP?=
 =?utf-8?B?VmFWbCt6SWtuNnR1SVFjbkRzK1FkK01BajY3Z0VkQ05oNlJrMjdwWSs4WlhT?=
 =?utf-8?B?czNGZHMzdE1zMGcvQmFGWCs1QjNINHAvQloxQW43cUR0MWxwSm80cGRFeU1i?=
 =?utf-8?B?b1BydzU5N3NOVkM5VzlvSTBNcHJtR2VXcHpOT2dEbkdKUEE3K0lVYXVyUm9B?=
 =?utf-8?B?YnhVTjB3c0dSQmttUUpRQXoyM2lWNDJpejBidXMralVGdjhucHdDUmMrOXg5?=
 =?utf-8?B?VWJ6RUdXcEszSUJ4QzhHY0t3ZTYyUzBsUE4yM05oN0JKWXhjK1RjUzFvRFFF?=
 =?utf-8?B?czU4OXZtNHpJNFNNZnQyVTdYaUxpcnBSOGZSTFVrbUkwNW93ZWc4WW95dGJv?=
 =?utf-8?B?RytyVDRuMzR1WWlGQkdFZVlzVFR4RlFhZm1LUzdSVHQ3UWYyNFFROWJQRHJF?=
 =?utf-8?B?T1BFMWJvVVM0dHQ5Z0Yyem83TVVIYll4Ti9GQlpzM3VoRTRNZjhFcjA3QTBF?=
 =?utf-8?B?V2xjZ29PMzFMdnl4OE5nbjVIZmcvSXdGR3Fwd2haYjhYaHRvQkpnQnd5TTJj?=
 =?utf-8?B?L0dFcG5Cdlp2NFdvcVNIY01pQ0xQV2Z6c0ExQWV4WHZhbnFpL1ZvM1FjRFVR?=
 =?utf-8?B?MkpWeG1vZ3RsTjVZMStmK0xuSksvckdRY1ZOdTk5ZDZTODJkN3ZNbEVLMjk2?=
 =?utf-8?B?V3dTQTBmYW52Mlk0WklGNWlOUzkxZXMveU1yaG54Tk9KbmhVd1BhZzVOZGdI?=
 =?utf-8?B?QSsrYkV0b3NxSnNLczFLZnh4Wk1iZ0JjNUc0bGIyWlRCUEo1UkIyZ0JndGNS?=
 =?utf-8?B?MkgvOGp2Mm96VWEwdStVYjVyMHBxY1FIcW9rT2J4NWhseS9DNm1DeStvK2lk?=
 =?utf-8?B?T01QSUQ2dkY3M0pHTXJHd3ZZUHNudWswL2ZGMlJ0UHVXSzIzSkJGN3VjcTYr?=
 =?utf-8?B?UVlCbU1RV2lvK2kxeW1JaTRyS3JFa0ZlNGdvMjVOUkVGbkdMRkNsaVU4SEpQ?=
 =?utf-8?B?dkpTVTlKNmNjYTBEVlFtdStGMGJVeEd6SlpvaWx0d2xBbzFUdmhsNlN5NHJi?=
 =?utf-8?B?K1VYUlJ5TmorUDI1TDRzd3UyeWxQdkFpcWhGZXhiK2IzREpoS3poZTZrMVZw?=
 =?utf-8?B?TGxTUXJRZG9yUmpDVk9iNlZleUtoeG9QeGp4N2dCKzBPaUhBOVd0OWFQWFNT?=
 =?utf-8?B?RzBIem04cUZ6RW8vclErdDNIUFp4MFM0L2pMem9Jd01IakJZYlA2NHZKMXhI?=
 =?utf-8?B?YzZWOVljeWRRZlhLMFJVWjIxbExEbTlUVTlzWENoZ1FLcUJ1MWdjRlV0aUJU?=
 =?utf-8?B?U0FJNFQwY0xZS0lNL01vSzlKMGN1aXJCenV4SWNweHB4Vis5VnhycmRJcnJ5?=
 =?utf-8?B?Y05XOGcvR2ZiUDRPSnIwNUJSYTV3MWFJVHdlL3Z5anI0UDlHaFBEL2o1RUc4?=
 =?utf-8?B?Qjh4OVBJS1czQmRCSnRJK3FmdllhblhEd0RQYWlEeEVhNFg4MUVuVEpWbFE5?=
 =?utf-8?B?RUFIajY4N2JnOFlxZ1RNUjhUOUFXSS9NUFpzdDB0ZlpwY3FVMkpVbWczZjRO?=
 =?utf-8?B?QlFHemlrY0Y2QVA5amQvMlpEemNuV1QxV3NPTDRjRFRYY0Y2YmlzcmtldUtw?=
 =?utf-8?B?SHdaWmw1YkNZWU5PMW5UamlieW55NThkVHBpNkxodnBLaHc1bTk4NnhZdUtT?=
 =?utf-8?B?RGw2Ykh4Unc2c09GVDljRDdZOTJiV2sweWMwMmVsc1lUblZzMFU0MzRvTE5y?=
 =?utf-8?B?MytSbVByYXozZnVwdEI5c1FoT295aHFQczgzSFhwN1BBemY1MUk3VVZvV2p5?=
 =?utf-8?B?amR0RUNla2FBa3Mvc1BKdTJsQ3Q2QndqZ2kvK01IL01iT3ZnbEpaVkh3d2h0?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: A7xtPMz4K6ZAn4wypX2YfJ1eRN4JVPItTBx25iW/6tsKLCvdl2HJVeNt2yzQNIyzkHdnmT8V5AWGyneUoUkVyd8630lGWhkU5/GHdDXpqeEI/8Z7hRkJw7OjvzmnBRF6IQxsegCBsVohr6vBZolWO7MKVOzqKPM4fIWyw6gyG9gqjbXy91rHym9GLx0HckbdmoTiUm103qegp+jZdUArRMvPB3frYMJ5dsyNGjS6aeHFev13tGqPCX0jbGxU9o8VkjM2Y2xYoeegMyMJSve8TOJUzshjq4Rvu/yHV5r51LLgfEb1VJqcZHrfjvLHi4GfOv7aZF665PrGgUSE3HnwYFjjisHpjgxjfP5yApECFDu7yHwelnqYF26/vwriWmX0q+lHJ0wcGNaX8zw7LjYqPUwYQNG9auIOGAAtPSe8Caai5sH+P9Di1VEhFXEUQPmW9Ebdg05gEFn9GoWSw3tPnJQBiHlzsS9/u4b840vbU6J48JgzcpoEpXdHvDFtTJjLgO9oCjsazw7bKLqWk2Tc+vdhmBD96Tzib1az4QDkGDc2EdgmpNb2hcjrEuUnTPI6HtdSCxIEl7Q9D0uTQqi2+/Drfefsw51Hcy3aU3wPcD97AbfrcB9QtlhLM9BDKh2xoZtxBnWreU0qyloMcmlkTQ/H8ixwx9ZQsWmrgV1EiNweJqwx9TxwNHQyDZsFg62421yYKENK98dtaej0lfhBlVspJO3+rBYJaYgkQD8jy6Lklr8J3cce81Q0Sa+ewhS3wgUaMeqegV1ivmSuywZlPWnXbXicc3+jp7b8s1xK8m1gfb24QH/2FvxKNcth2IC06GbbuxlcJJ3C1+Z1m3/xIQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ad80a3f-c2f4-4e9d-bfe9-08db08fca70d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 11:15:43.2408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RITL2k13MGSAFa7a129awFeg4gctM+eOy7KTT5R997JjWH+s2xoikt/+hET3AOwrkolTF2oRZ2pM68pBlTamgLOOPn7ndj3tUjzjAFZcdSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4792
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_03,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302070101
X-Proofpoint-ORIG-GUID: PwxsWX-1P1ViAUv8jvDnh312C0tk12Gy
X-Proofpoint-GUID: PwxsWX-1P1ViAUv8jvDnh312C0tk12Gy
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/02/2023 08:33, Igor Mammedov wrote:
> On Tue,  7 Feb 2023 00:21:55 +0000
> Sean Christopherson <seanjc@google.com> wrote:
> 
>> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>
>> Define AVIC_VCPU_ID_MASK based on AVIC_PHYSICAL_MAX_INDEX, i.e. the mask
>> that effectively controls the largest guest physical APIC ID supported by
>> x2AVIC, instead of hardcoding the number of bits to 8 (and the number of
>> VM bits to 24).
> 
> Is there any particular reason not to tie it to max supported by KVM
> KVM_MAX_VCPU_IDS?
> 
> Another question:
>  will guest fail to start when configured with more than 512 vCPUs
>  or it will start broken?
> 

I think the problem is not so much the GATag (which can really be anything at
the resolution you want). It's more of an SVM limit AIUI. Provided you can't
have GATAgs if you don't have guest-mode/AVIC active, then makes sense have the
same limit on both.

SVM seems to be limited to 256 vcpus in xAPIC mode or 512 vcpus in x2APIC
mode[0]. IIUC You actually won't be able to create guests with more than
512vcpus as KVM bound checks those max limits very early in the vCPU init (see
avic_init_vcpu()). I guess the alternative would an AVIC inhibit if vCPU count
goes beyond those limits -- probably a must have once avic flips to 1 by default
like Intel.

[0] in APM Volume 2 15.29.4.3 Physical Address Pointer Restrictions,

* All the addresses point to 4-Kbyte aligned data structures. Bits 11:0 are
reserved (except for offset 0F8h) and should be set to zero. The lower 8 bits of
offset 0F8h are used for the field AVIC_PHYSICAL_MAX_INDEX. VMRUN fails with
#VMEXIT(VMEXIT_INVALID) if AVIC_PHYSICAL_MAX_INDEX is greater than 255 in xAVIC
mode or greater than 511 in x2AVIC mode.
