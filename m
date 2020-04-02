Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8403619CDB1
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 01:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390297AbgDBX5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 19:57:10 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43900 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390235AbgDBX5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 19:57:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032NrkxL177890;
        Thu, 2 Apr 2020 23:56:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Lkjj8e4/gu85bLAPJaAJv8bq0O6ffAUvmzCSEpub7TI=;
 b=uUlpho8Cfd/ew+XXDJslFYIcoK5eAGAq8UMvpGl7Yk7T3Gf6Q9poazK7dvDBmpMZfljg
 qLsZTd99vUD5pgSzsyNzzEQ3dnsY48NKksVRc6WRqjkmQdSQK1Cxp8mWKTl5hwqkpFh4
 /zEZ5R5J31I9fK2AfAU7GbLerNSQReZkVVoTiKuwiPeD3fKnX91eWpKJN5urENyTlWSD
 +F/D3qb/Q1sfrba3L/jLKtMOMy4UP9S59FT/yXK2TyxhMBcGJ0uw0/Z69cp5nHcLuBYV
 pnpi1Zrd3hx4IuVfFzK0lr/BGP88ycN5z8wwpx0y7+KS3e4IRYifz90CLTdRnPCo3Lka CA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 303yungyje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 23:56:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032NqMrW079109;
        Thu, 2 Apr 2020 23:54:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 302g4wcye0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 23:54:41 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 032NscTl008584;
        Thu, 2 Apr 2020 23:54:39 GMT
Received: from localhost.localdomain (/10.159.142.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 16:54:38 -0700
Subject: Re: [PATCH v6 07/14] KVM: x86: Add AMD SEV specific Hypercall3
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <6dda7016ab64490ac3d8e74f461f9f3d0ee3fc88.1585548051.git.ashish.kalra@amd.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <9d1f29da-2d63-dfed-228f-b82b3cc2b777@oracle.com>
Date:   Thu, 2 Apr 2020 16:54:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <6dda7016ab64490ac3d8e74f461f9f3d0ee3fc88.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020176
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/29/20 11:21 PM, Ashish Kalra wrote:
> From: Brijesh Singh <Brijesh.Singh@amd.com>
>
> KVM hypercall framework relies on alternative framework to patch the
> VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> apply_alternative()

s/apply_alternative/apply_alternatives/
> is called then it defaults to VMCALL. The approach
> works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
> will be able to decode the instruction and do the right things. But
> when SEV is active, guest memory is encrypted with guest key and
> hypervisor will not be able to decode the instruction bytes.
>
> Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
> will be used by the SEV guest to notify encrypted pages to the hypervisor.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   arch/x86/include/asm/kvm_para.h | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 9b4df6eaa11a..6c09255633a4 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -84,6 +84,18 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
>   	return ret;
>   }
>   
> +static inline long kvm_sev_hypercall3(unsigned int nr, unsigned long p1,
> +				      unsigned long p2, unsigned long p3)
> +{
> +	long ret;
> +
> +	asm volatile("vmmcall"
> +		     : "=a"(ret)
> +		     : "a"(nr), "b"(p1), "c"(p2), "d"(p3)
> +		     : "memory");
> +	return ret;
> +}
> +
>   #ifdef CONFIG_KVM_GUEST
>   bool kvm_para_available(void);
>   unsigned int kvm_arch_para_features(void);
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
