Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49002353C4C
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 10:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbhDEIPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 04:15:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32200 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232041AbhDEIPR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Apr 2021 04:15:17 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13582swZ022575;
        Mon, 5 Apr 2021 04:15:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ZRGqmVuj4xVP6vbmS1MFIgNsltpr0gTSaiA/Tf6tNh4=;
 b=WleZ1lj85f2yXddG57yHAV5SXEhzI/CurtRXR/APJMT7D1VonmAL5sPLujl8E6SowIiY
 nyusNIGTdT9ksUxOCvhHCmUOKWTksobVExkorh7fnyDqZ4kOFlIhST9uGwjMXPx2MNro
 F/n3OWxjN3N/zA6H6HzMNdpkUyTB3yT19vCuoPxiR5iF/QisOkw3AESmoHs3s7RweIxc
 /uo+Dehy0VlHMM+9yOJbEvwJHEZ62sU9PRLIJfeu7MbGEmx/yuemIxolwEK3cSB0blWE
 s77skG/XMX5eyEzbqt2q8njwPpnYfUJIJdVUf9yM2KEWqYWDyyp4WG5+azb7gAyEM3Qk Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5naub2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Apr 2021 04:15:01 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1358F1xs065046;
        Mon, 5 Apr 2021 04:15:01 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37q5naub20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Apr 2021 04:15:01 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 1358CB15003038;
        Mon, 5 Apr 2021 08:14:59 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 37q2n2s410-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Apr 2021 08:14:59 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1358Eveg57016710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Apr 2021 08:14:57 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F60AA405F;
        Mon,  5 Apr 2021 08:14:57 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18CE6A4054;
        Mon,  5 Apr 2021 08:14:57 +0000 (GMT)
Received: from [9.171.48.123] (unknown [9.171.48.123])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  5 Apr 2021 08:14:57 +0000 (GMT)
Subject: Re: [PATCH] tools/kvm_stat: fix out of date aarch64 kvm_exit reason
 definations
To:     Zeng Tao <prime.zeng@hisilicon.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, raspl@de.ibm.com, linuxarm@huawei.com,
        linux-kernel@vger.kernel.org
References: <1617441453-15560-1-git-send-email-prime.zeng@hisilicon.com>
From:   Stefan Raspl <raspl@linux.ibm.com>
Message-ID: <43db8147-d1c3-4c42-f9cf-a5ab5dd6a808@linux.ibm.com>
Date:   Mon, 5 Apr 2021 10:14:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1617441453-15560-1-git-send-email-prime.zeng@hisilicon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: L_K2CPq23TO4PJqNlNSkguxwSc3KDuov
X-Proofpoint-ORIG-GUID: Ojh2RFMnxgJugyQJ3lp38CeqbmxEpy2d
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-04-05_04:2021-04-01,2021-04-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1011
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104050053
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/3/21 11:17 AM, Zeng Tao wrote:
> Aarch64 kvm exit reason defination is out of date for some time, so in
> this patch:
> 1. Sync some newly introduced or missing EC definations.
> 2. Change the WFI to WFx.
> 3. Fix the comment.
> 
> Not all the definations are used or usable for aarch64 kvm, but it's
> better to keep align across the whole kernel.
> 
> Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>
> ---
>   tools/kvm/kvm_stat/kvm_stat | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
> index b0bf56c..63d87fd 100755
> --- a/tools/kvm/kvm_stat/kvm_stat
> +++ b/tools/kvm/kvm_stat/kvm_stat
> @@ -154,17 +154,19 @@ SVM_EXIT_REASONS = {
>       'NPF':            0x400,
>   }
>   
> -# EC definition of HSR (from arch/arm64/include/asm/kvm_arm.h)
> +# EC definition of HSR (from arch/arm64/include/asm/esr.h)
>   AARCH64_EXIT_REASONS = {
>       'UNKNOWN':      0x00,
> -    'WFI':          0x01,
> +    'WFx':          0x01,
>       'CP15_32':      0x03,
>       'CP15_64':      0x04,
>       'CP14_MR':      0x05,
>       'CP14_LS':      0x06,
>       'FP_ASIMD':     0x07,
>       'CP10_ID':      0x08,
> +    'PAC':          0x09,
>       'CP14_64':      0x0C,
> +    'BTI':          0x0D,
>       'ILL_ISS':      0x0E,
>       'SVC32':        0x11,
>       'HVC32':        0x12,
> @@ -173,6 +175,10 @@ AARCH64_EXIT_REASONS = {
>       'HVC64':        0x16,
>       'SMC64':        0x17,
>       'SYS64':        0x18,
> +    'SVE':          0x19,
> +    'ERET':         0x1a,
> +    'FPAC':         0x1c,
> +    'IMP_DEF':      0x1f,
>       'IABT':         0x20,
>       'IABT_HYP':     0x21,
>       'PC_ALIGN':     0x22,
> 

Reviewed-by: Stefan Raspl <raspl@linux.ibm.com>


-- 

Mit freundlichen Grüßen / Kind regards

Stefan Raspl


Linux on Z
-------------------------------------------------------------------------------------------------------------------------------------------
IBM Deutschland
Schoenaicher Str. 220
71032 Boeblingen
Phone: +49-7031-16-2177
E-Mail: stefan.raspl@de.ibm.com
-------------------------------------------------------------------------------------------------------------------------------------------
IBM Deutschland Research & Development GmbH / Vorsitzender des Aufsichtsrats: 
Gregor Pillen
Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: Amtsgericht Stuttgart, HRB 
243294
