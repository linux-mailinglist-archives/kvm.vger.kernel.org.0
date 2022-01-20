Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D101495215
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 17:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346641AbiATQLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 11:11:48 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:10510 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233045AbiATQLr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 11:11:47 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20KFhRob018332;
        Thu, 20 Jan 2022 16:11:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6Ox8eyWrLwQAtzexuRRN3SRkI2nODJsGswFIkHW/wl4=;
 b=XYZfOQrTydseA8YT/xQzJvaG0Cp1otfVVN7XLaY26P5XE6GAhk3lUSs71huKjxGeeezu
 FJ5QcDEW9pPiPhgSuk7A52lBUBIiBqIUE/8VhuKJisCMxq69aYN16gn3EyZ3fiVDU16A
 MsYoARx4MiTbgFcqujKA0IercbsLsBb71LknA/LHf3/Kt5HuhwzbbKcm4HTvMea2kHKj
 HmONdCk4TZvRqAhVnrDD2Ta1JA/pE9OYvk+zJp1kteYw3cZE+OW25/HmLchZ2gnSvYO/
 Xm6UJcfajBeD/xAueJ1WPAQfppbSMKNwKLU0qD5dTVHSoRy11pY88hNWQIM5RfxOp39k Qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dqamq82j9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 16:11:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20KFug7w089783;
        Thu, 20 Jan 2022 16:11:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by userp3030.oracle.com with ESMTP id 3dkkd2hd9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 16:11:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRftiK0jMWjKWBnPq4YeD6QlgPT5yGz50Jc65lSGuVnbQenXoD78A2jNhA0AfpuRLTGbFUNXOLbFk4Cgk6EHfiD+M8mz+s4qr6OffaygNMsRhojVziJAd+JIr/lPTSp1yz9v9jKQfh+AGMSJpsm2lVIkiXAgGxsoMvokCwWTD6Raol+gdhfRI7mihLsNZIxUpzv65/8tSvxuUmlXe1kOC0P8GOZPtkpbMfhW0xDqpv6M1vIAFs60P6SX+ZjkaDwpN3+x1gxs8O+W0dk2gf6wGYTjXtM8MGJ5ewnn5crxYAuLF2JGrfsVWz6lJL607sD12lcjA8hCM9+D26IMfvpB9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Ox8eyWrLwQAtzexuRRN3SRkI2nODJsGswFIkHW/wl4=;
 b=hxuCq/tv+2vhx6zIQQSRhkigcb8iloCEWwqz5XBV0luGzYaTOZMUaswWbsDhbEnWML3zJcnhmT+zGRPMGzN2CmeyYgKuMu1doJN7iRsJg9liajGb9I9M4xjm+8V9D0OQcgpF8bF2dVUjpse4twjSoGDxb+8j6h28BSxcu9l4k69oSEbQp46bZFTMEbor+Sdr+6WRt9iECXD3cbQT+QzTwVfEUa+28iqTbW1oParepmBbf9PX3nPDlT6CwND4bnfarlViM+eQcE5VM9Ikpr+l74pnjO4NyVb4aNbUBNA3YLAKVJ4Y5Uy6hPGPE4nO//egA3vhEIwdAxU0GaPmchMObg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Ox8eyWrLwQAtzexuRRN3SRkI2nODJsGswFIkHW/wl4=;
 b=gQ+KR54vdMPC6SeQgRwqsf925gTA5J+B10DJ+pgb+0NpenhYHo9QfUEwpmk+rdLECy43t8KCM3heXq5abtueUlXFfwgCLEYrpektwvLrtU1pss7bOE+tsOyD8kM7NHzs0jrkTHWelWbl23nOMcw9cimpFBPXDqKoD7WVR4wbvvs=
Received: from DS7PR10MB5038.namprd10.prod.outlook.com (2603:10b6:5:38c::5) by
 BN8PR10MB3123.namprd10.prod.outlook.com (2603:10b6:408:c7::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.7; Thu, 20 Jan 2022 16:11:09 +0000
Received: from DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677]) by DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677%3]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 16:11:09 +0000
Message-ID: <ac496e47-c949-0e9d-4735-d51a7c9c0f62@oracle.com>
Date:   Thu, 20 Jan 2022 16:11:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 7/9] KVM: SVM: Inject #UD on attempted emulation for SEV
 guest w/o insn buffer
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
 <20220120010719.711476-8-seanjc@google.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20220120010719.711476-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0059.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::23) To DS7PR10MB5038.namprd10.prod.outlook.com
 (2603:10b6:5:38c::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1365683a-ccd0-435b-1958-08d9dc2f782b
X-MS-TrafficTypeDiagnostic: BN8PR10MB3123:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3123DA5B891233AB69349007E85A9@BN8PR10MB3123.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6YKVhBByct1EMoin0bBI8nAbNarYrk+6c0op7pYov3XFzzXCvXcIVbQUxgImZsqcitojIUbmcwKqoPjp8jKdxqqv6PVYtAZKznjpo0X3ZZiNfNI7PMFvHdI/pBqeqpEYS8/u+Iy3bw9mJzCmT3wjGqH4UhwcHCxqgAHQFqugsB8Oa9fz2PuRf0Zy76cH4FGZ6WtyrbVipknUFZtfgUKfk4uvZAzabNqREY/T6n+j0wpmZ2e65KbOfAuza53qcJak/U+w6cs/i8JBqLLA4BDv5wQPJ8nCOmaufosy4YasHI0zuxR9txudD8LnMNBgvcFOKmOFFNlXFas3PkQ6H1adJlYEqlT/Bpzles/mAR51SAmYEIi0xjmAbJYkLS1iXpCVjwplANTg36rbBug3urOoQ2ra8ONWYEdsVjFm+WUpi6eROIctOuX1UBWDmiNTe00FTSwdPf1F5RphLGMaVIYnlY2SLRlsh8xJPmhtLR8FBn/MYKxBT7fNo1TFP+ksuwKGz5qygfruhslm3C29DkRI13TX1vzKMuNoVZl4cDwGT8+owXjU5+Qv/nQIxbE85r/1x9v9D4wX34taCbgqSsxybVjsG59rD01XonmjXPhnlgquenvmg17jt0bpDmSVZ4WOvdW2Is/D13ectybvagyHY8sqv+14phwOxqQ4+jBbC7Z9MN/7x0KaBqkKyQLKaiKC4WgsxH0h6x8zM9k4ZblldmF5GPf374SAyPw2gXPW1DibCLul4Aa3fx2k46/P9uau62zekV6QIOjNvbx15q+3VA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5038.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31696002)(52116002)(6506007)(107886003)(6486002)(83380400001)(6666004)(5660300002)(186003)(2616005)(2906002)(7416002)(53546011)(66556008)(66476007)(54906003)(86362001)(8936002)(26005)(8676002)(38100700002)(38350700002)(44832011)(66946007)(110136005)(4326008)(31686004)(316002)(508600001)(6512007)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDZvY1lybiswMmVXOEkxMExra1VsZ3JjdVZYNi9YOWsvOWpwVjRaT1h3eitV?=
 =?utf-8?B?U2IzR1dmcEFWVmpqV3pONXJ2TURxWVFQeHF2TWZuMGFtd3h1MzFrcFFCWG4z?=
 =?utf-8?B?ODV1cHg1RGl6aE1zZXg0UkIwOEFlcGlqOENYMjdVdzhzTHRmMExreWZEOUxO?=
 =?utf-8?B?bFZ3UUs5QjdmTlJwOThNcG9oVkd2VDErU0FDRU9JaEJQL3NibEc1SGV0aVI5?=
 =?utf-8?B?WmJZMkx0T1NRQ0p6b3FhTXRmeHVDd0JSK2IzakY0d0RWeUZxNzVNTnBSdExL?=
 =?utf-8?B?eFd5TXYwK0lWRnAzTkhyZTcxTEgyVU9tNmJRU1BmWWNLTzJlUlh5TTloT1BR?=
 =?utf-8?B?SkMxdnFKK3FOZG9VNjRVWGtpemdOSmxjQVUwZVFlS29rSjNOMDU5ak1ub1Ry?=
 =?utf-8?B?eVB4N1YwVDZoMWZRYTU1ZENtYlVEblM5RWVib3Fid1E5aXQxQnU2OUhvbDk5?=
 =?utf-8?B?WXRBVzA3ajNYeHBLUFV0dEpMaDNjTEVaYWNiRTNqRjJrYXMrY2hrR1J6dThE?=
 =?utf-8?B?bXY5ZUc0c3IvQTBtNytxeCtST3Jjd3VGQitES3g2NXBPOVhCR3pocEpwai9q?=
 =?utf-8?B?RTJHWUxUUWprU3NEOFU4ek9yZEJEZGxnQkp3QlJQY3NTcHBvOTNGVFRaaUo2?=
 =?utf-8?B?WnN4cDIzRlZBZ0sweDcxcWc0cTcxcktFV3hHRitLd09WcXRXdFZnQ0l4SjZB?=
 =?utf-8?B?a1lyYXFVd29zRDVKVDhYVGV4cUNiSEVReEtkNjVNYVlWKzkveXhhMDVpdjV4?=
 =?utf-8?B?STIzVGZmcEpMYU5jMHY3blYzaFF1WnJLYlRzREIwSy9GTTB6aFRYSUYvTngy?=
 =?utf-8?B?bmhvUnNpZVFMTkttZUtYZTY3djMxMkREVi93YVBLZWRTMjRkQWRJU0tzRWdn?=
 =?utf-8?B?RGllcVp2aStWeExQWmhFQWt1cXlUQnZOTlR4dS9TY2FzY2t3LzFsTHFTWTht?=
 =?utf-8?B?Q0JvZjI2L2I2Zkl3amJqRHkrWUVyanUrQXpQWnR1eTZCSjdmSmxQNW5iZHhV?=
 =?utf-8?B?TDNEUW1jTFhieGpJRGdodEQ0UGE0TFNOUHdXeURxWFJNNHc1S21CTzNCSVdF?=
 =?utf-8?B?MlV0bzNRVlRKbE12UmNsODl4cGJPTEVDUk5NMjVmYUtKRkphQktwdktsYWI3?=
 =?utf-8?B?aElBYVlnU1RrNzN5Ky9Dc1Y2ZTZRZVNsVG9qN1JxbHRNTlVyaGVaWVBjRllk?=
 =?utf-8?B?MENOMHd4VGhsUlluS2licnpaY2JSTXBrZ0xNOUgvekx0ekE1RGhScVRDVktY?=
 =?utf-8?B?TVNrcU16T2kzVVNwZzdhRmlUS2E0QUVYc05LNkhoejJPdTA4cng3ZzNXcUpp?=
 =?utf-8?B?elM1VEt1MXU1RUR5UGZWcjB3Q0hMbmEzYmxCSVcxL2FNZnFaT1U0UUR6N0RL?=
 =?utf-8?B?T2VJNll6cTRvZlZzYXBiSUdFVzgwTzJtSUdGeEd6TjY2L3ptMUtKWXR4aDBM?=
 =?utf-8?B?R3Z1eVcxdW5JZ3QrUzVsY2xvSVZpeC8yQlJBTER2RkQzejkxRTBKcXJCMitQ?=
 =?utf-8?B?Y2s2Ukh1UnVmNkdYbWlyRUZ1YXZwVzJoZXlPbCtiLzNTSGJIbkQzallLaVhE?=
 =?utf-8?B?b2RpWHhEVStITXNHK1FOYWx2WEJDM25WRENpdlBpaVhabWllakJyTWFuK3Q5?=
 =?utf-8?B?c09sVjdzakZDNFhzVThaaGNpcGtDUUVGblMzSXpzVnM5TFVoMGZPZVhZNWdM?=
 =?utf-8?B?Vlkxb2xpQlF4SlRMdE9mb0pYQ3VjQVYyZ1JTQmE5b2UxTzBWdnhHa2x3TUYz?=
 =?utf-8?B?MjVNMWZNYW5EWnFHa292V2JpMXFCRFNRUjVkdHZBOVI1NGZ1L1hKUDNhSWNj?=
 =?utf-8?B?WnpEK2hxMkNrd1ptK3dMUFQ3dGV0UU9RYTVESVhTTy9zR2pmNGVnMUtSYkxy?=
 =?utf-8?B?QzQ4K3dtQXVQcUNYZlVFYjh2ZWg0TFhWRGFBVDQrTjVEWGp6L3pWRE5Xd2pX?=
 =?utf-8?B?K0s2Y0ZKZkxFeVMyc3lsZ2F2K21WL0lxSHJ2d0xZckthWGh6RWtKWW8wUjhW?=
 =?utf-8?B?TUd4L2sxbllwcmdjb0U4eE5NZmdJdlZPTk0xNWttWWhqd1JmcXJLWTQ0cDlM?=
 =?utf-8?B?dkk0Q09LMy9GUTMwWFYzTE1nYmRmakNIcmZnVzdxekRPalY2b0dqeXEvN2tm?=
 =?utf-8?B?RlNkNnVoNjFzRnV2UEtzWUIzRFh2UmtpcFFZSVk3aXNKRnZROXFrbWdYZnNL?=
 =?utf-8?Q?rRtuOmZcV21atz/x8sdKbUw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1365683a-ccd0-435b-1958-08d9dc2f782b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5038.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 16:11:08.9799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C+CK4N+UOaG0T9n7ym2VM4jwuPLSaYDtGn/VcHvBoFWnigbl4VwpNxQJzg1e1ddm7BA1O2aVuzRLA2uWzbgwDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3123
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10233 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200083
X-Proofpoint-GUID: vXNG9d46771HpImfWZDTqw6zQpupjTo3
X-Proofpoint-ORIG-GUID: vXNG9d46771HpImfWZDTqw6zQpupjTo3
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2022 01:07, Sean Christopherson wrote:
> Inject #UD if KVM attempts emulation for an SEV guests without an insn
> buffer and instruction decoding is required.  The previous behavior of
> allowing emulation if there is no insn buffer is undesirable as doing so
> means KVM is reading guest private memory and thus decoding cyphertext,
> i.e. is emulating garbage.  The check was previously necessary as the
> emulation type was not provided, i.e. SVM needed to allow emulation to
> handle completion of emulation after exiting to userspace to handle I/O.
> 

A few cyphertext references...

> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>

> ---
>   arch/x86/kvm/svm/svm.c | 89 ++++++++++++++++++++++++++----------------
>   1 file changed, 55 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ed2ca875b84b..d324183fc596 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4277,49 +4277,70 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
>   	if (sev_es_guest(vcpu->kvm))
>   		return false;
>   
> +	/*
> +	 * Emulation is possible if the instruction is already decoded, e.g.
> +	 * when completing I/O after returning from userspace.
> +	 */
> +	if (emul_type & EMULTYPE_NO_DECODE)
> +		return true;
> +
> +	/*
> +	 * Emulation is possible for SEV guests if and only if a prefilled
> +	 * buffer containing the bytes of the intercepted instruction is
> +	 * available. SEV guest memory is encrypted with a guest specific key
> +	 * and cannot be decrypted by KVM, i.e. KVM would read cyphertext and
> +	 * decode garbage.
> +	 *
> +	 * Inject #UD if KVM reached this point without an instruction buffer.
> +	 * In practice, this path should never be hit by a well-behaved guest,
> +	 * e.g. KVM doesn't intercept #UD or #GP for SEV guests, but this path
> +	 * is still theoretically reachable, e.g. via unaccelerated fault-like
> +	 * AVIC access, and needs to be handled by KVM to avoid putting the
> +	 * guest into an infinite loop.   Injecting #UD is somewhat arbitrary,
> +	 * but its the least awful option given lack of insight into the guest.
> +	 */
> +	if (unlikely(!insn)) {
> +		kvm_queue_exception(vcpu, UD_VECTOR);
> +		return false;
> +	}
> +
> +	/*
> +	 * Emulate for SEV guests if the insn buffer is not empty.  The buffer
> +	 * will be empty if the DecodeAssist microcode cannot fetch bytes for
> +	 * the faulting instruction because the code fetch itself faulted, e.g.
> +	 * the guest attempted to fetch from emulated MMIO or a guest page
> +	 * table used to translate CS:RIP resides in emulated MMIO.
> +	 */
> +	if (likely(insn_len))
> +		return true;
> +
>   	/*
>   	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
>   	 *
>   	 * Errata:
> -	 * When CPU raise #NPF on guest data access and vCPU CR4.SMAP=1, it is
> -	 * possible that CPU microcode implementing DecodeAssist will fail
> -	 * to read bytes of instruction which caused #NPF. In this case,
> -	 * GuestIntrBytes field of the VMCB on a VMEXIT will incorrectly
> -	 * return 0 instead of the correct guest instruction bytes.
> -	 *
> -	 * This happens because CPU microcode reading instruction bytes
> -	 * uses a special opcode which attempts to read data using CPL=0
> -	 * privileges. The microcode reads CS:RIP and if it hits a SMAP
> -	 * fault, it gives up and returns no instruction bytes.
> +	 * When CPU raises #NPF on guest data access and vCPU CR4.SMAP=1, it is
> +	 * possible that CPU microcode implementing DecodeAssist will fail to
> +	 * read guest memory at CS:RIP and vmcb.GuestIntrBytes will incorrectly
> +	 * be '0'.  This happens because microcode reads CS:RIP using a _data_
> +	 * loap uop with CPL=0 privileges.  If the load hits a SMAP #PF, ucode
> +	 * gives up and does not fill the instruction bytes buffer.
>   	 *
>   	 * Detection:
> -	 * We reach here in case CPU supports DecodeAssist, raised #NPF and
> -	 * returned 0 in GuestIntrBytes field of the VMCB.
> -	 * First, errata can only be triggered in case vCPU CR4.SMAP=1.
> -	 * Second, if vCPU CR4.SMEP=1, errata could only be triggered
> -	 * in case vCPU CPL==3 (Because otherwise guest would have triggered
> -	 * a SMEP fault instead of #NPF).
> -	 * Otherwise, vCPU CR4.SMEP=0, errata could be triggered by any vCPU CPL.
> -	 * As most guests enable SMAP if they have also enabled SMEP, use above
> -	 * logic in order to attempt minimize false-positive of detecting errata
> -	 * while still preserving all cases semantic correctness.
> +	 * KVM reaches this point if the VM is an SEV guest, the CPU supports
> +	 * DecodeAssist, a #NPF was raised, KVM's page fault handler triggered
> +	 * emulation (e.g. for MMIO), and the CPU returned 0 in GuestIntrBytes
> +	 * field of the VMCB.
>   	 *
> -	 * Workaround:
> -	 * To determine what instruction the guest was executing, the hypervisor
> -	 * will have to decode the instruction at the instruction pointer.
> +	 * This does _not_ mean that the erratum has been encountered, as the
> +	 * DecodeAssist will also fail if the load for CS:RIP hits a legitimate
> +	 * #PF, e.g. if the guest attempt to execute from emulated MMIO and
> +	 * encountered a reserved/not-present #PF.
>   	 *
> -	 * In non SEV guest, hypervisor will be able to read the guest
> -	 * memory to decode the instruction pointer when insn_len is zero
> -	 * so we return true to indicate that decoding is possible.
> -	 *
> -	 * But in the SEV guest, the guest memory is encrypted with the
> -	 * guest specific key and hypervisor will not be able to decode the
> -	 * instruction pointer so we will not able to workaround it. Lets
> -	 * print the error and request to kill the guest.
> +	 * To reduce the likelihood of false positives, take action if and only
> +	 * if CR4.SMAP=1 (obviously required to hit the erratum) and CR4.SMEP=0
> +	 * or CPL=3.  If SMEP=1 and CPL!=3, the erratum cannot have been hit as
> +	 * the guest would have encountered a SMEP violation #PF, not a #NPF.
>   	 */
> -	if (likely(!insn || insn_len))
> -		return true;
> -
>   	cr4 = kvm_read_cr4(vcpu);
>   	smep = cr4 & X86_CR4_SMEP;
>   	smap = cr4 & X86_CR4_SMAP;

