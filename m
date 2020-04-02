Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 275C819CCF0
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 00:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387919AbgDBWhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 18:37:25 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59854 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgDBWhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 18:37:25 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032MXwxV073343;
        Thu, 2 Apr 2020 22:37:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=/6uoxnnJoOeGgVzkYhxiBt1cqT19bh9GMo8CCS7Cf88=;
 b=Rg65ilh6HaH+PTMWhVr2RMU7pbQK8WXAbA7A5u4K/XbzKnrfRYD9wJEU10ghh5Y5neza
 S840DHxwbCY0gIpxb4oLB+TyTBRT3b16gUxtJMTliZ1bYZrzqy66W+hdKXcrco1MPwI7
 cZc+HiYuECVBulcSjZg/dPEdyIn6eigXSIpQw7tPGdpjQKP5dQHOY2qSq0Xj4EFz3sKA
 fImlRwt1Sh2NV9q5C5bq9Z/PSRq6ADM4QZYgHp3nO317JYLUMoa/hGfRB9C4CCpv5pBu
 eIrdZrJi5gMskcVOBW/qTlhPiI4Yt2S1ubHRUIbtI+7mGLIWQSr20xqcszRPuwWF7pXJ hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 303yungsjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 22:37:01 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032MX9GN050436;
        Thu, 2 Apr 2020 22:37:01 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 304sjqsam6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 22:37:01 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 032MawlW015810;
        Thu, 2 Apr 2020 22:36:59 GMT
Received: from vbusired-dt (/10.154.166.66)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 15:36:58 -0700
Date:   Thu, 2 Apr 2020 17:36:53 -0500
From:   Venu Busireddy <venu.busireddy@oracle.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@suse.de,
        thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        srutherford@google.com, luto@kernel.org, brijesh.singh@amd.com
Subject: Re: [PATCH v6 07/14] KVM: x86: Add AMD SEV specific Hypercall3
Message-ID: <20200402223653.GA659595@vbusired-dt>
References: <cover.1585548051.git.ashish.kalra@amd.com>
 <6dda7016ab64490ac3d8e74f461f9f3d0ee3fc88.1585548051.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6dda7016ab64490ac3d8e74f461f9f3d0ee3fc88.1585548051.git.ashish.kalra@amd.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=1 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020166
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=1 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020166
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-30 06:21:52 +0000, Ashish Kalra wrote:
> From: Brijesh Singh <Brijesh.Singh@amd.com>
> 
> KVM hypercall framework relies on alternative framework to patch the
> VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> apply_alternative() is called then it defaults to VMCALL. The approach
> works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
                                              ^^^^^^
					      cause
> will be able to decode the instruction and do the right things. But
> when SEV is active, guest memory is encrypted with guest key and
> hypervisor will not be able to decode the instruction bytes.
> 
> Add SEV specific hypercall3, it unconditionally uses VMMCALL. The hypercall
                               ^^
			       which
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

Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>

> ---
>  arch/x86/include/asm/kvm_para.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 9b4df6eaa11a..6c09255633a4 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -84,6 +84,18 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
>  	return ret;
>  }
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
>  #ifdef CONFIG_KVM_GUEST
>  bool kvm_para_available(void);
>  unsigned int kvm_arch_para_features(void);
> -- 
> 2.17.1
> 
