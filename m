Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B196EBD5
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 23:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388408AbfGSVDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 17:03:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33524 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727972AbfGSVDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 17:03:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6JKwpL0180570;
        Fri, 19 Jul 2019 21:02:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=H+36a0KOvrCAcVsUljEVtm5NcGWsJpTDvkc+zfvNyLQ=;
 b=mLz1hqm9FSCIq5zL08B1t/Z2Y1agR5y7YqkZtAGfOpvP+66LAC6D7uPUbVoZLIpRHRoO
 mBVx/5YJqPmXLnllgWyh+0LIqDo40/VY/4LLvnITet8x6g9N+alRteVFW8OgV0sgGUZC
 /qSGWAOBST0krNJ8FdD8yf02jglReHnFFy8SIalv/Y520uhr81WhPj3aEF12H3TQPMMb
 RRZD3TYNGAHlvO4g88CEPjSG8pxSVo1lmaoC/4KACPvDKKNNKNCX2pwRMxLxJMMN9aag
 S7J3skuMjyJ8goywSpKsjZ/+CPYctT4N8+jjK4yTSl6p9mcSbwGeIX/C5x5nD89718zX dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2tq78q8n8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jul 2019 21:02:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6JL2TI1031338;
        Fri, 19 Jul 2019 21:02:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ttc8gcdae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jul 2019 21:02:51 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6JL2pKV027695;
        Fri, 19 Jul 2019 21:02:51 GMT
Received: from [10.0.0.13] (/79.182.108.162)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 19 Jul 2019 21:02:51 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: VMX: dump VMCS on failed entry
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1563554534-46556-1-git-send-email-pbonzini@redhat.com>
Date:   Sat, 20 Jul 2019 00:02:48 +0300
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <07996D9B-D060-4FC2-ADCA-1E2B17D6FF08@oracle.com>
References: <1563554534-46556-1-git-send-email-pbonzini@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9323 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=949
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907190222
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9323 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907190221
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 19 Jul 2019, at 19:42, Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> This is useful for debugging, and is ratelimited nowadays.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Liran Alon <liran.alon@oracle.com>

> ---
> arch/x86/kvm/vmx/vmx.c | 1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 69536553446d..c7ee5ead1565 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5829,6 +5829,7 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
> 	}
> 
> 	if (unlikely(vmx->fail)) {
> +		dump_vmcs();
> 		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
> 		vcpu->run->fail_entry.hardware_entry_failure_reason
> 			= vmcs_read32(VM_INSTRUCTION_ERROR);
> -- 
> 1.8.3.1
> 

