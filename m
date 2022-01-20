Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7D84952C4
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 17:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377193AbiATQ6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 11:58:43 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:7734 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377136AbiATQ6m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 11:58:42 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20KFgf5u014584;
        Thu, 20 Jan 2022 16:58:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=gLQvumxv686sCKl8t8DgMI2bkxPAFQtaF1hwZa0mktc=;
 b=W94baaD++tumLclm88GLLQvmyQrPFL19+hY8tDLlzMOBD09J9tWs7NDJeK0gQ1mNyX8V
 j3y0BbKn8+GvPfCV93tXD3VfYh2rnyCEFrLJ3eU7275U32Jh6NJEjiD93/oG2tJPILZQ
 OesaStk7M885ttIGqasAkgNi7SmhaYWH2OPSKNNgFYRvwW7ODzfZTfJwqDfxneUPT6Lo
 hFtqfT45UgumFOzcqm9mCC014js7BFC3HzET7xrLR9lARrqPyD4LuEhmUhrbwVYzhOdZ
 43nNorjT4FNVx9SF0e3nb63fY09WpIUNVZa0JedT5Gol+LDEuAI9ZZG25uoQG5IIq8Tu fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqam9r7km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 16:58:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20KGuBrm150770;
        Thu, 20 Jan 2022 16:58:16 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by userp3020.oracle.com with ESMTP id 3dkqqsr996-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 16:58:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lrC6wOoH5TGUdW+33D0R628VwYxqbvcEWYLdY9dQUguwE+PeuR0AaMMcmiOGdX1VIACMxX0CEE0i0NZ9A6/YXvJASMhRTjTb4raGlqx6nWQy/d3w4m2tT10nVcpGtxAWHFoa8MSM3eDivf+k841+Q+RHKqTTlWagdwqDD5lBaMogZcFeVFwy2D+7dw+Gnc1f2/07IdRgNKPc7m1iWokK9saGmUqsu33dDoUt6XWyOgysvlqdFBwgAwLHPlNUbXzsB5zGyR1TDUelT64foQjfLPw30/qG+z9YNoInOh75pI2XMZNIgPkqqfSmj9ogC97fzO7LhrQ59x2fjbvJl7BOjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLQvumxv686sCKl8t8DgMI2bkxPAFQtaF1hwZa0mktc=;
 b=ArK395szIOpcwXbacJ/thYAHHYAKB2+gNyRKIBLpiEdpeEOKFbeOLTpqyc/L8EyEScMD4p082LFV1g4hM7rXO9nl8DbfHNblgXk7zlcKKB0Kre+mWXDi4f25PzlH8lwGTxPBXML/KI7tbBsNe1DQ7JUHmhsk7+BX+3aSsYSuDmswbsnVJavH2JHbeNxcqEoylWGutpwph8FgTAzNThbusTyvtw5y8D8XDfUFAKmyc9IpFMeavXu92Lb8P26qPzjzUpVPG9Lh1PANQR9984drzxhWbGKBnQokr5yIpxlFSk2xtKVIfimoIR2VfQR11zEfId6ViCPMIg4dCuGOtm4f8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLQvumxv686sCKl8t8DgMI2bkxPAFQtaF1hwZa0mktc=;
 b=NYC8X6Wv+yohAd9W03Gq1LtDhmQLU3pCPBvqQ2D0wlwcpB19FB6Yr7LJAqMtHNEQuTA1guMBKHdcHFeMF5jqoyogXhaFoctBkal9Xl4niHmVlZD8QJ1MDR8tJViq6chp26gf8e1UC4X8712G4YypT0MsKumVMbXyx1i9pePnP5c=
Received: from DS7PR10MB5038.namprd10.prod.outlook.com (2603:10b6:5:38c::5) by
 BN6PR10MB1249.namprd10.prod.outlook.com (2603:10b6:405:c::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.8; Thu, 20 Jan 2022 16:58:14 +0000
Received: from DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677]) by DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677%3]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 16:58:13 +0000
Message-ID: <d02e3982-b34c-c529-11b5-4c788af480d2@oracle.com>
Date:   Thu, 20 Jan 2022 16:58:07 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 0/9] KVM: SVM: Fix and clean up "can emulate" mess
Content-Language: en-GB
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Liam Merwick <liam.merwick@oracle.com>
References: <20220120010719.711476-1-seanjc@google.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20220120010719.711476-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0001.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::6) To DS7PR10MB5038.namprd10.prod.outlook.com
 (2603:10b6:5:38c::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c886bba8-fa18-42c1-a6de-08d9dc360bef
X-MS-TrafficTypeDiagnostic: BN6PR10MB1249:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12495D76B1B07A4AA6F8F7EDE85A9@BN6PR10MB1249.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zTWuuvclN5C9ed+scosafdwFBwLQUDJjVEVaCOJfSsjSpfgTlqhA/VChSWe/z75im7wiOYH3ikO6WEyLP8DtanVwKY6/2g00vK2+dR6N+CVIXo2KbM+bgGzz2qQnInP0MmyI4yh8L1aD4mBROixvsYDHPNJr+xr6KgBRW4xmoYBCJqMqPTCA/z9DQWDhRxk36krNt8o+eC/XELfdG7d9SIvxtxmtdoSr8/0nzLeXUVVkowr/pMcbLiuhwURRVrXDYC00LBXc/HalVqSAR7vxnmXj8Z3VHImt0r4MG1mCOJKS5InPf/Ff2Nbp3ksTMf6nOJnrgoMd13s2uXMHlle8rjyix4gPY1LkLRE1V2cMTkBsKDOSoXyZY9baTzHmBnOMEN9U+aZAZxDeK8j5Jve/yD8DJZyBR/Hr/mkcispVghiQTsyLlpVRg0o1cCHKTTzDjtFSJzhhxj0GyclZLV7nGB+klcxB3EXwJohvxRamRtYHxOEBcpaWSGAes4iNYKc7nqOXKi4ZDKv53rOXahltIttJoVhHV3EZ/wK40BO4zSZ3fLbJubFyujMitqXLJuLLLCb9Axfa/h2+/kCmSOdWcWkTRx7av4RbVFUJRIHQHNHZbCR5+EutE4usZc3nknhsMTLXjAnur6SzaggNR8MoRpYF2lFFUecEP5mFdM70LDG7OVSw9ISyFs1AcNTuikFm5JrwkMT42XtPi/8OFRkEVf1LH//LFPpB2PISZoyiOuaM2osrxwqPKZ0Xp6mppsxJi/wfxZJBCf8dpDkMvLZ/+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5038.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(52116002)(86362001)(38100700002)(38350700002)(36756003)(31686004)(54906003)(8676002)(66476007)(6486002)(6506007)(53546011)(66556008)(31696002)(66946007)(186003)(26005)(508600001)(2616005)(107886003)(8936002)(7416002)(316002)(110136005)(4326008)(5660300002)(44832011)(6512007)(83380400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUhWeFJhNVhHZUQvWndteWdzamdJWC9hYmd4NzNVSUlLK21NUDNLazBFWElQ?=
 =?utf-8?B?cHFjOExrbjlGTHZQTkVvbC9YNXhkclprSEJzODRPemkvUHFWQWNoMWNUY212?=
 =?utf-8?B?YkY5MW1tMVhYMzdRUjVTRVYxendoOWdTS0tZU1RJY2Z0NVRrZkNSUUJyUVRW?=
 =?utf-8?B?WGppUmQzb1BFcWVPVEF6OFBsWmdmMGN1OFBpMEFaSCs4empuZEVvb0FTdjNa?=
 =?utf-8?B?NUNYR0M2alhlMlh6ZzN3ajlLM2l3cnBWOW9ERzhPTlRrbnYvMk1WN3dndzRo?=
 =?utf-8?B?L1JPaHNJTFphVFNoZExFSkswNG5NM3pHVVJVRldLb3QwMnhjMkhBelNPcis5?=
 =?utf-8?B?dzJHYWQyLzZScU0vZG82a0pzaGpxbDZCdFRHZ0xnODIzWXBLS0lyT3d2OGNR?=
 =?utf-8?B?RXlZSndtalZQNzdPbWVlYlZiMmZaU2lpU0loQkd0bmY4VEFERTlqbzJ5L1Q1?=
 =?utf-8?B?a1U1dUpyRGhBTE5yOGhvRW5ZTHlITUlYcElRQ08zVFIwMmViVVpHYkZHUGdH?=
 =?utf-8?B?UFV1dXdBUGVwL0E2NEtma3hnT3lSYUZZS1N2dktjZkt2ZzJZL3V0OGxzM2Qy?=
 =?utf-8?B?UWxzOFJEazdPcFYwOGdqdExjSVVvYkpEdWZzWGZwazRkYzlBUzVxdHhxT2V2?=
 =?utf-8?B?eFJXa2MvdFRQc2UyYkxheUpkbmZnSTZ2RjViRWlkZndNOTdsaXFiR3YwZ0FE?=
 =?utf-8?B?YWZ6OEdtOTR1b2Njd0pLOXh4MHhieTA4WnlXMWkzOW1QNSsvUDlnb3o0ZWZC?=
 =?utf-8?B?SkhjTkJ2NytscGdObmJQdjZHdzhzS3VGdTJaZlQveFZQTGx3TTU1TUNzRzFI?=
 =?utf-8?B?UFFXOXFRSXpZckpwdHpEd0pFTWNIdWdocCtIMkZZT29IU2VFdnBjanNUZGNa?=
 =?utf-8?B?enZoYkUvVCtFT0syM0lnUzFqWEVJNmZoTXVyZVFPd25wY0lTU1N6aXNtUy8x?=
 =?utf-8?B?RHl0TnpQUVhtSlJ3TlpyRzVFWG9JR29jdXBVeERCcEdMMlZJa1hFak53RTZR?=
 =?utf-8?B?YUxEYldraWpwYnMwdkNSSEU4M2R3WkE3cVFvSjdwS2RTNDB3ZUV3enBab1Fa?=
 =?utf-8?B?MDRZWC9uMHFTNkx6enpCejIwMGh4YmZtd1g3YnNHTzRxYWs3aXhhNlhUUlBi?=
 =?utf-8?B?N1pETmd2a0dLK3FOVlJIWmlMbHF3MDF1OVQ3blVGSVVTYmx1Q2FtbS96VVUv?=
 =?utf-8?B?M2VGb2VRUlRQK3pRYW5BNktULzJCcSthZWxmczcwRmUwTU5iYmdoOTAvNGM1?=
 =?utf-8?B?dzNyQkl1Y2JFY3FpODBjekVYSmFnR0svdFVBUW1FM3NwRytFR0hkK1orQ29O?=
 =?utf-8?B?dmhHVUt6NTloRzMzZ1E1Z0lJTEVONXM3ZHFjbVNPc1Q4ZjFlTFlOUmN1alkz?=
 =?utf-8?B?dzEvQXVkaTgvbVJtSzNKRStHZ0lMd3UzOCt5dzMzRGwvSWptR1RQZnZULzgw?=
 =?utf-8?B?OGtNTFlKaHgvZnZRbjZKT2trQzJBeTN2eTlPcW5MamRmQjEyaXhNQVhhbGxK?=
 =?utf-8?B?VENTcDVoNUVhVWk3OGhJWXRhSDZyVVdRUmRQeVJDa1JmSTA2VUxNOEFxS2dY?=
 =?utf-8?B?QWppRkwxL05lTjVTcStjcFAzRVpVRHZxQXpqYmtSczh5T0I5L1MwQ3pTYXdR?=
 =?utf-8?B?VWFqTFIzaVJPT3NDNjFwTnNPdVpUZDlxL1hLT0NvenBkNmhmQmR2ME52STdC?=
 =?utf-8?B?dDB3d1JyUVkxeXVZUEJ3TjE4NjNEdGlNMEx6ZE1ON0tlMm5haHhwalFvRzU2?=
 =?utf-8?B?Q3NGSE44M3ZPZWxGcCtsQlNKMkE0akFPWWUyKzkydDJKb0RkcXhkdjdRTXZa?=
 =?utf-8?B?OXhnUXlEMDFxczVjak5NSmtxVDMxdkFkSmxtRlVuNVZnVlpSanRTM3BoN0Zi?=
 =?utf-8?B?SFhPRTBlZW1obFJaVVhXcWVHdWgvTlg1VE9Na0VTNHdFUUwwY0NvOVVKdVp6?=
 =?utf-8?B?TUxscXFKYit2bjd3a0lPY05TcXBDZlJJTTVjWUhjMFJaNW4vVFdaK2JJNksv?=
 =?utf-8?B?ZUFyTkxSL2w4WkFDMlpjNEUzdzlpb1h5MnNTbWc2U1g0d0wrRG9hZlRQeGlM?=
 =?utf-8?B?SmZscTR4NXhMZ00vcW1WV0h1K3pLQUM5dENPM0pGT0ZIUDBwUHpHS2JzdXFD?=
 =?utf-8?B?QlZCTGd4a1RITFVJcEY3NmJ1NFE3Mk1ramlPd2FMWEpaQXdwZ0VTUXhDbkNj?=
 =?utf-8?Q?/5NIfr43o2hdGN+xBWCT554=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c886bba8-fa18-42c1-a6de-08d9dc360bef
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5038.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 16:58:13.8579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jxp9KsrgwOcbwE9zcf4x8fFkEU8A9lsNuWxcP5aOISWdda8qAiW3EsU9wPmDiqsoOozDn2+90q5JCmscKaBqVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1249
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200087
X-Proofpoint-GUID: 37knbwBVK8n_ruZm_SaBT3Mpf9sFsp0-
X-Proofpoint-ORIG-GUID: 37knbwBVK8n_ruZm_SaBT3Mpf9sFsp0-
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2022 01:07, Sean Christopherson wrote:
> Revert an amusing/embarassing goof reported by Liam Merwick, where KVM
> attempts to determine if RIP is backed by a valid memslot without first
> translating RIP to its associated GPA/GFN.  Fix the underlying bug that
> was "fixed" by the misguided memslots check by (a) never rejecting
> emulation for !SEV guests and (b) using the #NPF error code to determine
> if the fault happened on the code fetch or on guest page tables, which is
> effectively what the memslots check attempted to do.
> 
> Further clean up, harden, and document SVM's "can emulate" helper, and
> fix a #GP interception SEV bug found in the process of doing so.


FYI: I've applied all 9 commits to a 5.15 based branch (applied cleanly)
and the 3 stable candidates to a 5.4 based branch (applied with minor
contextual conflicts) and have been running my SEV test case (sysbench)
and kvm-unit-tests without issues for a number of hours now.

Regards,
Liam


> 
> Sean Christopherson (9):
>    KVM: SVM: Never reject emulation due to SMAP errata for !SEV guests
>    Revert "KVM: SVM: avoid infinite loop on NPF from bad address"
>    KVM: SVM: Don't intercept #GP for SEV guests
>    KVM: SVM: Explicitly require DECODEASSISTS to enable SEV support
>    KVM: x86: Pass emulation type to can_emulate_instruction()
>    KVM: SVM: WARN if KVM attempts emulation on #UD or #GP for SEV guests
>    KVM: SVM: Inject #UD on attempted emulation for SEV guest w/o insn
>      buffer
>    KVM: SVM: Don't apply SEV+SMAP workaround on code fetch or PT access
>    KVM: SVM: Don't kill SEV guest if SMAP erratum triggers in usermode
> 
>   arch/x86/include/asm/kvm_host.h |   3 +-
>   arch/x86/kvm/svm/sev.c          |   9 +-
>   arch/x86/kvm/svm/svm.c          | 162 ++++++++++++++++++++++----------
>   arch/x86/kvm/vmx/vmx.c          |   7 +-
>   arch/x86/kvm/x86.c              |  11 ++-
>   virt/kvm/kvm_main.c             |   1 -
>   6 files changed, 135 insertions(+), 58 deletions(-)
> 
> 
> base-commit: edb9e50dbe18394d0fc9d0494f5b6046fc912d33

