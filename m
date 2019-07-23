Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 418FB721C4
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 23:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392120AbfGWVm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 17:42:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52540 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731707AbfGWVm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 17:42:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6NLdDFf042571;
        Tue, 23 Jul 2019 21:42:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=wYntv4n+4p/Yolp6n9pjkXrq1pe8qYSecC1zTbanCkY=;
 b=1KnVg8MyEvwg40vIY8uETC+raBib1uco3j7tbp0SwarejxEu3KmY6FaB3GUp4nKvfFrE
 Pmclrf1BW8hwmECxEG82wNJN8cn1BWeonClBXzJfHumWyBHbPIBrOFW729zWRJ/NjOCU
 TyoukKinRZlr2WsT8gLQ/m+umZtfJzz5bkzCgRDUN8cn+tzF93ysS7GYCa933TKeCnRQ
 8Aai9acl36Fjlor75OaorP+1zerIP0pw5d7JqVZCIhVJFLMRttRRfDxR/Ar5SDhYl/cW
 fkF31uU8FzlOVskHJR4Z1/c8FZpwpk6seQu0CKFilbhkECP6Ux71dFFPBlGHrz/kbuJ7 lQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tx61bsdde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jul 2019 21:42:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6NLc4qE094669;
        Tue, 23 Jul 2019 21:42:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tx60x7t6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jul 2019 21:42:25 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6NLgOnI007608;
        Tue, 23 Jul 2019 21:42:24 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jul 2019 14:42:24 -0700
Subject: Re: [PATCH] KVM: CPUID: Add new features to the guest's CPUID
To:     Aaron Lewis <aaronlewis@google.com>, jmattson@google.com,
        kvm@vger.kernel.org
References: <20190715210316.25569-1-aaronlewis@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <87d3c508-31be-1264-e168-c72b6857d000@oracle.com>
Date:   Tue, 23 Jul 2019 14:42:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190715210316.25569-1-aaronlewis@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907230218
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907230219
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/15/2019 02:03 PM, Aaron Lewis wrote:
> Add features X86_FEATURE_FDP_EXCPTN_ONLY and X86_FEATURE_ZERO_FCS_FDS to the
> mask for CPUID.(EAX=07H,ECX=0H):EBX.  Doing this will ensure the guest's CPUID
> for these bits match the host, rather than the guest being blindly set to 0.
>
> This is important as these are actually defeature bits, which means that
> a 0 indicates the presence of a feature and a 1 indicates the absence of
> a feature.  since these features cannot be emulated, kvm should not
> claim the existence of a feature that isn't present on the host.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>   arch/x86/kvm/cpuid.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index ead681210306..64c3fad068e1 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -353,7 +353,8 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
>   		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
>   		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
>   		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
> -		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
> +		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt |
> +		F(FDP_EXCPTN_ONLY) | F(ZERO_FCS_FDS);
>   
>   	/* cpuid 7.0.ecx*/
>   	const u32 kvm_cpuid_7_0_ecx_x86_features =

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
