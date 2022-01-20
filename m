Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE625495024
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 15:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347215AbiATOaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 09:30:55 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61490 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345897AbiATOay (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Jan 2022 09:30:54 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20KDgfTh001404;
        Thu, 20 Jan 2022 14:30:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=yYFKag2zRAvkI96dR7KFzWg8JwGUhELAwTsxXO2Vvu4=;
 b=xvwZa2+6JdOiMTjI9wwXqta55hlRTSj67j8kiKyeItcucZijObFezFy9yprULD0jBlt9
 z7AwNaD3iUpPaf2QkWcYrtwpgKV55AdOE7ZZShNJSs5Xe76Rl2gjJC6ryBmwe2Iqc5Ha
 tKTo3ojJvz0pV1HhR2MEJK6wS70cTUZZ8bSkjAUhTi0iM5cUteiew/+mrmlePiO5/JaP
 zSKik1n9scgNQD603BSzNPXvjmSPEwlcVwSzY5RuTw4aMsMA15UWbcnDD6Eyto+tA/C3
 rS/4eKkzAOPq8ZR0bLUZyS0MtNRtzH3xbaV1qJVTe/vFco6rgzGonf2vsdpo+ioSUZn+ dg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc5f8b52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 14:30:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20KEUB90098575;
        Thu, 20 Jan 2022 14:30:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3020.oracle.com with ESMTP id 3dkqqsg8ua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Jan 2022 14:30:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FHPFjZBkOPQbCQNSow91tbO+ofS1a5Sy2EcOjLdvCeJTfeU94ubnbcgrH3ixw2dvbgVZ3Z4f/2QOI0KsyXZOg74R1OZyV3zta0c/vM4xzx7k3g6K5QYCwT82tkMo8rPjacRTppnGONixKB1lYAhBPbt/yt87fU7JRYDgrRYNSPWaSnaPQ4142bqya0g1WvY+2CIQwxhZUzul9gKrm+e5PtHSBf+p5mARmsPisaJCy5ypi1gJ6sOIDlI9PUzCT3uHOntlDevEAKCoQYYQft2ftlxK6Yt7pmUvdE8haadJzs+/GBucZzVIkbKtcdcb99cRM8dzO26eHePhRSt5nVNCzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yYFKag2zRAvkI96dR7KFzWg8JwGUhELAwTsxXO2Vvu4=;
 b=XwLZkb3CKLrucn7UQtvpFEKiYabNgo4kleDn0pG4dfFkPaf3ICpRJjewZ5gXVGMPklBU3RFfB3qM0egPljFzdsGC389bhYVHYQqsVMJO2VAuhS2h5v26wcXVXH0zP1NyrUeI7QpJMoSWbWc8TADCXel2bF1rvIzV6GdomZBkhzXgsiPXJC4lpYoJWPuDYqfR/TOXc85hMgPjMnMG0VtxHOboch2xQNyF0ilcW3KEItB5PSuDlab0r5LRcYUA1UkNbHAnAtSWr1bk8ipx2eW0dnQ1mtWq2jjk3RZaJ9zuzoHsaxVX96Yosk7QL0PLYgIFlxafQpq5z+f3V1ijMKYw4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYFKag2zRAvkI96dR7KFzWg8JwGUhELAwTsxXO2Vvu4=;
 b=yLLWy++D94hyQF3eT8XiJXolmwn+NuD2Xwyhe/Zs7VstI1Hzcz1hN6JTqxGWasqdEq6g5kqqoOrZ2kNbQ4Hv4R3wUujymOKnuATl/EH/iPTgFPvlBrr0amO6XVq8IuwxnCAuuDXzlPbtGPQMuMeRnQeXnuMQOlf5Wa2HjzDZxLI=
Received: from DS7PR10MB5038.namprd10.prod.outlook.com (2603:10b6:5:38c::5) by
 PH0PR10MB4789.namprd10.prod.outlook.com (2603:10b6:510:3c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.11; Thu, 20 Jan 2022 14:30:19 +0000
Received: from DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677]) by DS7PR10MB5038.namprd10.prod.outlook.com
 ([fe80::e01a:f38f:1282:5677%3]) with mapi id 15.20.4909.008; Thu, 20 Jan 2022
 14:30:19 +0000
Message-ID: <61dcbb64-2f2a-175a-e207-79398e80184c@oracle.com>
Date:   Thu, 20 Jan 2022 14:30:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 3/9] KVM: SVM: Don't intercept #GP for SEV guests
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
 <20220120010719.711476-4-seanjc@google.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20220120010719.711476-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0016.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::28) To DS7PR10MB5038.namprd10.prod.outlook.com
 (2603:10b6:5:38c::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c20773c-bf9d-4a27-3994-08d9dc21628d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4789:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB47893D3EA9DA307CDE48AB1EE85A9@PH0PR10MB4789.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UwoLaIoGF+GOSa1+TQjl6h5fOxBvudPAL7h1FvJA5KS4xn5nFMm+cKKlN4XyFO9KWzlgC392gWG43FaKsK0aJOpS7TwTbJydxoQnCn4vdIlTfcBUg/UMhYcWYMex2sSvTZM4U8lITQZCjVhWCQ3xHIp/16OJ7MwnzkwyHdWF/6BxoZ/+6V2Iio6Y5qFqIyJT99DNmVA1/fk34ZqzSSrM/NUepDWpZHMvcJFx+GqhxTVhgxnk1Cbw5P+dl1hSD1u7TH4yjfExxkKvaVMacuoj4IT/uGM/eMoR52Rp6by+vyJfgE4zZa+Nftt9sdDZnbyNxRuTs9ogN6QrTIfox6bVWEhsVpzZftxGqDJL5xMuQPJJWkC+yVgRPyIG+Y8qVkdToZdUdcemzRgBS7k/RWvY8LhvXAmy3xdARVM9qOYqiyWsQo2riO0166ZjdoR1BH5L0hHoRzfIREikVa0W6hJiyWNmsaUApLbBV+9hE21bT5ObNstQfGrdXECln/pWQVu7r6T6xIEp/QCFW4qJr4mct2JgxP2vSlvNaNFL+DrEEpzyprka3pEo6DS0IIpMsJkNNjwpuwWI7QVLXV7PcUUXgL0Mi69Zqj/cisuz33zOeCvHod3UKzJ+Xzh26WZ7Yv3d3/f95xGtjXIg/ub/oZNHCJML5QqQTlDXhWM68jU6OFbfDe3FMrC+tPB8gaOMIEJ3Gq4WzuUw4si4tBQWbb9DGhAqD6B9J74EnHzbYXNtzLMBg0G7jGAnB21YH7T5TYLj/YJVOIHwZ8VINYfyysgkdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5038.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(31686004)(6506007)(4326008)(83380400001)(36756003)(186003)(8676002)(86362001)(316002)(38350700002)(508600001)(6486002)(2616005)(26005)(2906002)(54906003)(44832011)(53546011)(66556008)(66476007)(5660300002)(31696002)(110136005)(8936002)(107886003)(66946007)(38100700002)(6666004)(6512007)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1ZYZnF4T2o3NTRSQW0vTXNZREQ3a3VmVXlmYk8xdElUYkh6R245VkNpTldY?=
 =?utf-8?B?cGJjTXhoQWVrSTlzY1piZkxlV3FFYkZiVU55dVkyUjFFWlRILzhQaHNsTHBS?=
 =?utf-8?B?cG9vT0MxMmYxSHppeVRuck05R1JmSHVMWXR6MVlVb2pSY2dTSWwwNlZvMyt0?=
 =?utf-8?B?MGlXZmJzZjRBVE9zcEFXUmlaYTBEU2lKZWpwSk90QkVReDF4bjZaWWwzRThK?=
 =?utf-8?B?bHhqSEczQnMwckFTeWswaUxwWDc0M1hpUXJuRVd4WWNBUldSL21aODAvUXdw?=
 =?utf-8?B?T1AvOFpoQmxHNG15WXVWTmlCL09rY3oxRFNuSVV1ZzFsd3ZDenBUcVJvTnVO?=
 =?utf-8?B?STZkZW02NmJVTmJUaWJZTTlnbnJESUlaWWliblVmeEIzOXNTTFllZWpXK1lx?=
 =?utf-8?B?dWhsekNpKzRsZnp3NlY0b1VjaWtMR2FmaGRkUzk2SnZWTnVCZEk4eGFyWjAz?=
 =?utf-8?B?aEJqRkZGYmJIV0ZwU0hKRHhwRWZkOUpLc1Rqc2JrN0ZKOWNFNHdMc3pPcVVI?=
 =?utf-8?B?MnJISHpQSFJKeVcvN2hzOFppODJndFdwNTdBWklEejY3amhUNTFLMFpZZHRh?=
 =?utf-8?B?Q3dlY3V1TmdFTWRJMW5UNTRoYkpuNTM2VTUxU0pUSXJWN0dLWU5uV3dsYVhp?=
 =?utf-8?B?bTFNSUl6NmlScTJNZ0luM2RQZFJYZE96aE9ENHBqWXdnS0hqNUExaWs3SjhP?=
 =?utf-8?B?WHArNll0Ym4wV1B5dWo1Zll2dSt3UDdzS1hXemRpQ3R6S1VKR0JHNkt6RSsr?=
 =?utf-8?B?NytMa0FpbDVHN3VDRmxBZHh2TzhZSjZSc3FzRzRHSk1CUFBRMGJab1pqOEFs?=
 =?utf-8?B?OFJlV3FKNTNRNDNjQlJtcllZdWU5NStZTjBNdXZVUTdOQXJFb21lZi9vVkJ5?=
 =?utf-8?B?WVNuRVZOWlc2NXpPVS9UVzFOcGorRSsrdG9XRXFHei9Vam9VM0ZFaGQyQ3ls?=
 =?utf-8?B?R2tVbXMwZEhuREgySXE3aldlQ1BHWWpVOGdVUEliM2JLSWlGY3M2dGRGeTFu?=
 =?utf-8?B?SWNnMnpJeWw1L0VrT09odUpNaWpQbTluY0dRT1VXTUNuTVRyQXR6UHZPYUdm?=
 =?utf-8?B?RGNCcXFZVHcxOEltMWRrOGRrVmw5U09OVU9wYXcvMkFjOVcyY3FLL1QwODlX?=
 =?utf-8?B?V2JUODJXTi9ORkZVKzI3Y2hRczdlV1AyaVpwaHJPeVluT1Zxa25OZE43NVlV?=
 =?utf-8?B?M0trT2VXdk5LdWNXYko4aFd0RnBBbnhqaThZeXJJeXdMUTJmY0JQSUdZMUtj?=
 =?utf-8?B?OEczUnFTVHNJRCtxYjc2SU1PWUs2WGdmaHkrV1Y1OEQ5L2NiZmdWanoyN25n?=
 =?utf-8?B?YTlLMnNUK0tIYzc2WVY0VG0wQUtydlBhWC82dnFuSUp5V3pJK2NSZzNWR2pR?=
 =?utf-8?B?ZlA4QnRRRk5qc3B5bEg5bnptc2RTK05zUWRabUpMNDAzWS9UbHVkOG9RUEU5?=
 =?utf-8?B?RGlIdFcrK0xWNUdDcVNwVkU3d3pvZzgwQUhSUVZUTWdrS3kyT2ZIQU1PaGRM?=
 =?utf-8?B?bzVQMGYrS21GR3puaGIzUndVUWpkSGFZb2laSHMvRHZDOXQwVG9EcUp3ei94?=
 =?utf-8?B?eTJtRFdKRzNWMExSVVJaQVpDZ1FBdlpYaTduOHhxeGVyV3NYMGdlWkFwbklN?=
 =?utf-8?B?bzdlaTJDSHV5Q1piNDFPRFpzWHdidmlWK0dZZzA0VXBSeC84ZmhJUnI2U2hs?=
 =?utf-8?B?NDFBSlNEV1lGaXRoRTFZMjM3Vml2Vy9wbXI2NHVPLzY1TnpERVpibFlYeUhC?=
 =?utf-8?B?dUZVaklweFlTNVl5Wk5mTG5XVVhQRVNpQmg1TVBZdUpJWFBEVW8zM3ZPa2NZ?=
 =?utf-8?B?OGZzcUZ5QnFUcTd3Y0VDWkVoMWJLbEk2dU1pQ1U5dVdRUTZoejd4N1dNTVow?=
 =?utf-8?B?a04xeEl6b2pKanE2Z1RLQTVVQXRjenlrM056ZXFpbTFRUDJRNDZYZWpDcUoy?=
 =?utf-8?B?WHU5VzhUekgzcEIxck8wT25Ba3J1VUh4RXJQbHpWRXdDME5TaHdUTjJzcjU3?=
 =?utf-8?B?L2V2YjdzeUh0T1M3dXFuTG41dDlZOFBXRU1Nb0luVmh3YkV4WFpFbW5pbnVL?=
 =?utf-8?B?bGZ4UllRNXRhMkJaM0M0Q2FLTmZyMldyY2FnL0R5ME1mV2psVE5ndExIUWFZ?=
 =?utf-8?B?aWgvbW5VMmdtdzJXSkpEczYyVGdwd2ZJOWVjZkxVUDZncEZRRHh6Z0tOMWNE?=
 =?utf-8?Q?AnvNSbNsyMf5mckTyEupLxQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c20773c-bf9d-4a27-3994-08d9dc21628d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5038.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 14:30:19.7120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ibGBEJ49qcQbWLYnrkBGPrv93wwvKSeZy1chpNyYCvN3/dQwn6i88ewg9WicXz/sIiPbQM1qAxgyAfaH1gVxow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4789
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10232 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200076
X-Proofpoint-GUID: 70mWdYLY_j8fJeGCJwRKcTVyG6FV4pP2
X-Proofpoint-ORIG-GUID: 70mWdYLY_j8fJeGCJwRKcTVyG6FV4pP2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2022 01:07, Sean Christopherson wrote:
> Never intercept #GP for SEV guests as reading SEV guest private memory
> will return cyphertext, i.e. emulating on #GP can't work as intended.
> 

"ciphertext" seems to be the convention.


> Cc: stable@vger.kernel.org
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>

> ---
>   arch/x86/kvm/svm/svm.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 85703145eb0a..edea52be6c01 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -312,7 +312,11 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>   				return ret;
>   			}
>   
> -			if (svm_gp_erratum_intercept)
> +			/*
> +			 * Never intercept #GP for SEV guests, KVM can't
> +			 * decrypt guest memory to workaround the erratum.
> +			 */
> +			if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
>   				set_exception_intercept(svm, GP_VECTOR);
>   		}
>   	}
> @@ -1010,9 +1014,10 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>   	 * Guest access to VMware backdoor ports could legitimately
>   	 * trigger #GP because of TSS I/O permission bitmap.
>   	 * We intercept those #GP and allow access to them anyway
> -	 * as VMware does.
> +	 * as VMware does.  Don't intercept #GP for SEV guests as KVM can't
> +	 * decrypt guest memory to decode the faulting instruction.
>   	 */
> -	if (enable_vmware_backdoor)
> +	if (enable_vmware_backdoor && !sev_guest(vcpu->kvm))
>   		set_exception_intercept(svm, GP_VECTOR);
>   
>   	svm_set_intercept(svm, INTERCEPT_INTR);

