Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5FF0650DBD
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 15:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiLSOr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 09:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbiLSOq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 09:46:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DBE60F1
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 06:46:34 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJDxVdD020276;
        Mon, 19 Dec 2022 14:45:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=yL/O8SEZAJ7UHdn1C5A80lUDhzeaePoElGl7I0HIyCM=;
 b=EwieMGVJrBbJe/RzRy9dXhsavaY8WCQaf2LIfhzg3EdihLQdXsEdSZwXb2P/KX/Ead8J
 S1Mqw4TZS+iBxXIdqA1GIMd5+VHEU53fQHeCpd7xySnFtiXslhQ4b4E4j+0iVLUxmp9L
 mYI+6h5Ct4cUZwJOVGIUlUN8xca6vg+tU3ESnN9QL5WtGuicLXtQkEtKM7ZmDjCTt4s5
 Adu7mB8RoeauVCGltiE4sDItvm4JPVCKEGOuOy41iWDZcIijQx2KWPHnezPVC0v1c+MO
 YC3fQzJYJ2e0nlU6OlBL34rVHonvODdI2X+Ktet2IpdoGrsf+87XiXBET4Ev4zDEGlPI EA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tnb167-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 14:45:46 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BJDSvHW006839;
        Mon, 19 Dec 2022 14:45:45 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh479w344-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Dec 2022 14:45:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZJLDKxtChWmbUBIP9rKjXO1H3a2ksxei36XTKpJT33szUGinX413XT+MrAMK8Lu9ICruJEjo0o59jvUEKxfiH/Vz2rBUJ9HN8JPKMXUupMwEKQPE3dUuLGajR6K5Ad+McQeujcCmFmWAcJ/zG7mLKwJfT2qAH5/1LQwpNQw89HARD/oYbLqabYoA5CMBNX5y77VfkE7MzavTzckStEDQmtBkjyZoay16sGGM+IRMrfQnLu65eTq7apUYAICUWk7HQl6qUL2p5MIP5KBzhWHimzRnulQQCEwv2qTwy4FeOSIuco5k7+t3ORIEyCwhZ+kvviR+u96hgpNcj2OU5Wabg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yL/O8SEZAJ7UHdn1C5A80lUDhzeaePoElGl7I0HIyCM=;
 b=c4W4fmsU2QCg2MpbCugwNx1bf/vR60kY3mxpr+AaElW8OF5cMUx//c12JuzD9RgK7vKGGyArEWofO5wlNB1reWlB+8aWHUgLagKzKRgmT7+m9IHrGgK+EhJGiu0DqaJFtpNOb2R+VZxqZVnoStoEOPST/Pk8+ZAOYeVQlEnAhFRvOUP3rnf1+VGwXdxsIXihEhPKesYUA3a2I+xV1jPDpglYxh8IAy5UY0xFw9Oykrj/LBsSn2NGews0aPEL1rkfcf212/QknkVbWJdkVS6zXWMK3o6JlzR1l1u/62n7RGH/oAp4jOZWZf9cg099k/HwHWE8oXByBhpEUDIe/MJVCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yL/O8SEZAJ7UHdn1C5A80lUDhzeaePoElGl7I0HIyCM=;
 b=sGeUb7+x4xlf5ebEDae4LQ937ZJmITb9zz6hsvX3iY6QATuPBssIA+27wg3IbkC1lXHiBTN316VKNk2T3s/VMAm1Uxz0rg4PdGjby8aoevtTD1slmgmqKX7yj/5d2sL4FrIr2yxx4pOXPZ0SESmtcdbIxlsHsyVODrcESblypOc=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB4880.namprd10.prod.outlook.com (2603:10b6:5:3ac::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 14:45:43 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::d868:78cd:33d4:ec7]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::d868:78cd:33d4:ec7%7]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 14:45:42 +0000
Message-ID: <895f5505-db8c-afa4-bfb1-26ecbe27690a@oracle.com>
Date:   Mon, 19 Dec 2022 06:45:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 0/2] target/i386/kvm: fix two svm pmu virtualization
 bugs
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, joe.jin@oracle.com,
        likexu@tencent.com, groug@kaod.org, lyan@digitalocean.com
References: <20221202002256.39243-1-dongli.zhang@oracle.com>
Content-Language: en-US
In-Reply-To: <20221202002256.39243-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:334::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DS7PR10MB4880:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ec110a8-4d81-4ccb-27bb-08dae1cfb46f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u7VDOGFhOc0gmhmiz8RE0b/2SJ5i8TERznUUoevisZ5QCskjMRBovrEH7Tk0MLpwT1j+4DugJf10PU86TwKtLRgPphaB8DE+UHMMpL9iTwrAQdCe1QoP1Sv8Cm6FthHo+Hgi/le0MdBIamsSpSSZTsMWPoPlULj1UdQauFIC8q98wNUuJgifAfuuXjooBAt6+BMM3DLnJtAU8RNM2ZbDWd+K8al4aCHuCAO+OgAsG6sp4MuExMi7d12CIu7kr6y/Qg2kmqTSsi1895kZ/fjIelnM67LNoGhkrwQrIJA3R6ZJautm3mmUvjwt8vjhaynWIB3bGKLnavfeOPzBubMPw+YGn66Go29/aLtRGjPz2O40Ld8z4pAXQVLkRtACJ6ggHzD1FPoVEx5RU7AkQ5ts5cnJtTeIRcO96KrAyJ35gbc3kjzQPrKwxVcTYhygh2s2L3w6xVlH5OmFYEuZDIWWiPs1hMxPb4zOQtw0MBzLEOWbgywjG61SC5WoyD6QJ/6yGd6mwWX+TbiuFBfueK6364/dvp1oQdnYUf4ShSgrglyLUSB6n/Xagy0CkqAtb+c87vNtLQsxLEDkAiTb0ugf8KIkXUCchOKJznzwXOZBgM/gohjdaOP5n5MEIRnwkd+PYgXQhytt64lL/TPgOFA2wnJF2Wta/+nZa39gR5+nS4P6L6M68AisT3jirS9sytkV0WH7JJtuQG6P+8C91xZd9Msq6sAGpw2EdCM7NK3sk9nBz7BWMdy4kWXDRkWj8lzyT62mknPd6U/oaJ0Cbk4qkzqPMKNtOWHrBmoF+wpyibZ4rXFzlF5nUbxTrS35zuzw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199015)(31686004)(2906002)(38100700002)(8936002)(2616005)(66476007)(66946007)(66556008)(44832011)(8676002)(4326008)(5660300002)(186003)(6512007)(316002)(83380400001)(478600001)(966005)(36756003)(86362001)(31696002)(53546011)(6486002)(41300700001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2pldGdUNzU0Tk0xL0lnNUloeGhVOXQrQmxFbkpDUzVTWGxuRmZMeHFRMTRT?=
 =?utf-8?B?cno1UU92dlIwb2IzengyV3RoMzB1VGNrV3FXZ3ZpeSsyMURoTFB2NXVGQVJ0?=
 =?utf-8?B?NmxyRzgxTWlIak16UnJsUjByT3VESEFSRTRkUDRHUUpiWWo3Rm05QThTVHlZ?=
 =?utf-8?B?MVFiUmhkSUtJOFRiMDJIaDJnaXI3cGF5Z1B5aFVOOFIyRWU5NkFBNytGSExn?=
 =?utf-8?B?cVNtNkE4bU9QUHhQYkc2eW9kZHAyME8vckN5L3FLZ0ZVT2tlNE9BTHdrUWhr?=
 =?utf-8?B?V3FMWTdUbmFZQXZTYTNYSm1INlR5MDVCVVVmSDhCcjdYT1lldzVLWDQ0cUZ3?=
 =?utf-8?B?dk02bVpPKy9Rckx1ekdEOUdvdG1vQi9oa1BITDVBUjNMTXJTNWdhVVRpMU9O?=
 =?utf-8?B?UEw0bU96N3dvQjdjb0tIMGt2QUNIOUJPVmZkd1FLNTYvRDl2Qk1VNGIrOTlw?=
 =?utf-8?B?bzN2dXNHcm55VDJXeGhOcUg3UE5OSTJsamNRNDFMcWZBd3hQS3JqMG0xSXlt?=
 =?utf-8?B?bEltaWw2dk1yRGRZU0NNaHVCQ3FIaTc2ZlFpUG5rQll1aGVueTQ3QUxNdXcy?=
 =?utf-8?B?eW56ZWhleEhnVjE4UW9BS0hjS1BkL1BSSElXTk4wTm0xK3Q3aWZHa3Y0Q0Iw?=
 =?utf-8?B?elpnS2dWQXV0UkF1b0pxZzVBTWdyU3psVllrelMrYkRBeUlweCthZ3JWWkJI?=
 =?utf-8?B?ZjhQN0I4bzJZVmdaNXlJb2hHbFVUNDhySEtYTTRab1Evck9YbVcydjdYb1pC?=
 =?utf-8?B?SFJmR3VoaXNyZm9CMGRIc2NHTFFTWjVVaVRsaXJBR0lpTXEzeU1vUGllZXdn?=
 =?utf-8?B?NW01WllHbHgwRjVYWkFoVTRBaUpHSXo4bng1NlIzNXM3d09QUHZwQ2QzY0lk?=
 =?utf-8?B?VzF5eHNlQ3VubFJxR296NjBSUllGVHRVd085cnFmUHpLTjJ3QlVEVzFXc29a?=
 =?utf-8?B?QXlqRkdxTWJoQitiVk1PMzZzU2dUWDQ1QnhWWmNybVdZcXM5NWRLMjkvL0hU?=
 =?utf-8?B?VWVsZ0lwQVROQmN1Tm5kb3JtY0hxS1pWYkZFeHFDZDdwV3UwMk5EWlZlVWVE?=
 =?utf-8?B?bHA0OW5nazVKOUJObnBOQ3kwbFhZbWlsQjg4R0EwR29GZk5YU1dvcE5VOThW?=
 =?utf-8?B?RjdoSUJ0eHRHREdrMzFCZmNQM01VRy81SFI2TmZhR1FzaUlZajZXUFpBS1I5?=
 =?utf-8?B?cXpHNEFnQTlROWVmbG5BRG5vY3hQZldPTDJsd25TKzd0T3k1eklhVVdWV3Q4?=
 =?utf-8?B?MVh2OTFvZWdlaFcwK0V2VjZ6TEJaQ2k0WkZxT1JkUEFwdWQ3T1JodW5MUTkz?=
 =?utf-8?B?NnBYQU1WS1lNY2VISHY1NHM5dXJZbW9td2RZUDRnQkxXeHVBMkdzWTRHdEpO?=
 =?utf-8?B?aS80aEpLYjFScHZxM2hEdmZNR3lHN0k0TmtCeENnTDd3KzI5NGl6d3NuYk9y?=
 =?utf-8?B?UHdrYjB3TzhIclRhZXlXL1hwVW1wRmtUWDU0OUxhSHp0WGJQWko5cW0yWmJq?=
 =?utf-8?B?SGFNcFFlUmw1NmVjN25JUUZGamxGNVAzM2ZoT3RiM0dNR0p5UjAxUXVnVVda?=
 =?utf-8?B?NVRjQ2s0SVlIMk9YejI2bEtSdmN2UXlzVzNLMUJkMUU3RTlTV202eFEwNWJV?=
 =?utf-8?B?NUlPUDJVdWRreUhCS2xTUXpoOFE3eE51ZXRGWENVeVV6RUZZa1NzUmwwZXFj?=
 =?utf-8?B?RzNKVkgvc1daQVoycS92NURQUEwvRW9OZ0JwbzlDR0EvTDBGWWlLai91TUxD?=
 =?utf-8?B?WHBJK3BnUEcxTHhFWXhEenNBNFVRcStyMTNyMzdkZld2dHJzZWlZc2NlTFhQ?=
 =?utf-8?B?b2xIY1FHcTc0bHpac0lSOEx2b0F2YW5ZV2lodFZnV2FoUjBhN1VhbUtWblQz?=
 =?utf-8?B?amEydGFWYjN5SGM5ZytaWHNKMHQwcW5HU01uMnRuUTRKYkZrSGV2bWN1amlz?=
 =?utf-8?B?S0syS2dKd00ydFVVWHk0NnViSVl1REMyL3B6TytrSmI3ZmovSndoRW94ZjAy?=
 =?utf-8?B?N3FOOS9rY2ZObHpMVjNOUGhkL2JFUEhWL1A2S0pyRS94VUdqOFRYNkJPMU1q?=
 =?utf-8?B?UEppNXZWTnM5aDIyZUJvWlBDcHUvR1hiUS9YWjJpVDg0aHFPc3d4eWJ5ZElK?=
 =?utf-8?B?NGZ0WDZNRnJabFV0Sk90RWJjamw3QWVuay9CbmFlcStCcVREUTlXYURoeUli?=
 =?utf-8?Q?vW4Gq4R1pJ/7esSry8JfQzQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec110a8-4d81-4ccb-27bb-08dae1cfb46f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 14:45:42.9259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iSpv1fyNBo44pLknpMA34YTbOnVclvUuIMf1RC7bnHllIIEQhWXNSpEZeptm2CKtpF0mTpTh6kpZpIb8aseOrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4880
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212190131
X-Proofpoint-ORIG-GUID: IMdtFaKJicTjzuPVmPzYXKh7opaTKivS
X-Proofpoint-GUID: IMdtFaKJicTjzuPVmPzYXKh7opaTKivS
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Can I get feedback for this patchset, especially the [PATCH v2 2/2]?

About the [PATCH v2 2/2], currently the issue impacts the usage of PMUs on AMD
VM, especially the below case:

1. Enable panic on nmi.
2. Use perf to monitor the performance of VM. Although without a test, I think
the nmi watchdog has the same effect.
3. A sudden system reset, or a kernel panic (kdump/kexec).
4. After reboot, there will be random unknown NMI.
5. Unfortunately, the "panic on nmi" may panic the VM randomly at any time.

Thank you very much!

Dongli Zhang

On 12/1/22 16:22, Dongli Zhang wrote:
> This patchset is to fix two svm pmu virtualization bugs, x86 only.
> 
> version 1:
> https://lore.kernel.org/all/20221119122901.2469-1-dongli.zhang@oracle.com/
> 
> 1. The 1st bug is that "-cpu,-pmu" cannot disable svm pmu virtualization.
> 
> To use "-cpu EPYC" or "-cpu host,-pmu" cannot disable the pmu
> virtualization. There is still below at the VM linux side ...
> 
> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
> 
> ... although we expect something like below.
> 
> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
> 
> The 1st patch has introduced a new x86 only accel/kvm property
> "pmu-cap-disabled=true" to disable the pmu virtualization via
> KVM_PMU_CAP_DISABLE.
> 
> I considered 'KVM_X86_SET_MSR_FILTER' initially before patchset v1.
> Since both KVM_X86_SET_MSR_FILTER and KVM_PMU_CAP_DISABLE are VM ioctl. I
> finally used the latter because it is easier to use.
> 
> 
> 2. The 2nd bug is that un-reclaimed perf events (after QEMU system_reset)
> at the KVM side may inject random unwanted/unknown NMIs to the VM.
> 
> The svm pmu registers are not reset during QEMU system_reset.
> 
> (1). The VM resets (e.g., via QEMU system_reset or VM kdump/kexec) while it
> is running "perf top". The pmu registers are not disabled gracefully.
> 
> (2). Although the x86_cpu_reset() resets many registers to zero, the
> kvm_put_msrs() does not puts AMD pmu registers to KVM side. As a result,
> some pmu events are still enabled at the KVM side.
> 
> (3). The KVM pmc_speculative_in_use() always returns true so that the events
> will not be reclaimed. The kvm_pmc->perf_event is still active.
> 
> (4). After the reboot, the VM kernel reports below error:
> 
> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)
> 
> (5). In a worse case, the active kvm_pmc->perf_event is still able to
> inject unknown NMIs randomly to the VM kernel.
> 
> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
> 
> The 2nd patch is to fix the issue by resetting AMD pmu registers as well as
> Intel registers.
> 
> 
> This patchset does not cover PerfMonV2, until the below patchset is merged
> into the KVM side.
> 
> [PATCH v3 0/8] KVM: x86: Add AMD Guest PerfMonV2 PMU support
> https://lore.kernel.org/all/20221111102645.82001-1-likexu@tencent.com/
> 
> 
> Dongli Zhang (2):
>       target/i386/kvm: introduce 'pmu-cap-disabled' to set KVM_PMU_CAP_DISABLE
>       target/i386/kvm: get and put AMD pmu registers
> 
>  accel/kvm/kvm-all.c      |   1 +
>  include/sysemu/kvm_int.h |   1 +
>  qemu-options.hx          |   7 +++
>  target/i386/cpu.h        |   5 ++
>  target/i386/kvm/kvm.c    | 129 +++++++++++++++++++++++++++++++++++++++++-
>  5 files changed, 141 insertions(+), 2 deletions(-)
> 
> Thank you very much!
> 
> Dongli Zhang
> 
> 
