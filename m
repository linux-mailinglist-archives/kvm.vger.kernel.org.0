Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA4C13D058
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 23:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbgAOWuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 17:50:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48728 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729281AbgAOWuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 17:50:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FMhEMA093593;
        Wed, 15 Jan 2020 22:50:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=Z8XbGOdAL/yCYqgIiW2n0rpRH9zb3x7gh518pm9fA5s=;
 b=m4EZqvqqEKuYbk/bvk9fULyZO0ZbAoAPbVlIOtZWN8rd2uVRkxTaMoRxrOoYR6LSgP3N
 ADR18ltbGcZWeuQo4SYseX4wMiuwP2W3zsJPxFPDLi91vBU4/kNIzADvPBlT42gRAVSN
 ABCaxLiJUTjxr7FlRvdbQoKU6U/NeTYw02Wpywswfcck5WexLZTqkU6PBoOBFVPS9pPu
 +cnMLV9sKiZS+IcBrqR+2PX1qo3EcsBtT2fhozIg5aX+2zt4oKmHgyvX5o8vi0twY9Li
 7IeoFwwQ2+p3/OEGs4IhBuI8zy8yx6JMEJI6BQ8ypQ+wCgRLFFk8PoQbN4mkQ2hMzvPB +Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xf73ty4y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 22:50:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00FMiEiB101932;
        Wed, 15 Jan 2020 22:50:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xj1arhd4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 22:50:45 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00FMoiD5031448;
        Wed, 15 Jan 2020 22:50:44 GMT
Received: from [192.168.14.112] (/109.66.225.253)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jan 2020 14:50:44 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH RFC 1/3] x86/kvm/hyper-v: remove stale
 evmcs_already_enabled check from nested_enable_evmcs()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20200115171014.56405-2-vkuznets@redhat.com>
Date:   Thu, 16 Jan 2020 00:50:39 +0200
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Roman Kagan <rkagan@virtuozzo.com>
Content-Transfer-Encoding: 7bit
Message-Id: <7CBE44B7-E554-480D-9280-E29247C70178@oracle.com>
References: <20200115171014.56405-1-vkuznets@redhat.com>
 <20200115171014.56405-2-vkuznets@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9501 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150171
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 15 Jan 2020, at 19:10, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> 
> In nested_enable_evmcs() evmcs_already_enabled check doesn't really do
> anything: controls are already sanitized and we return '0' regardless.
> Just drop the check.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Reviewed-by: Liran Alon <liran.alon@oracle.com>

-Liran

> ---
> arch/x86/kvm/vmx/evmcs.c | 5 -----
> 1 file changed, 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 72359709cdc1..89c3e0caf39f 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -350,17 +350,12 @@ int nested_enable_evmcs(struct kvm_vcpu *vcpu,
> 			uint16_t *vmcs_version)
> {
> 	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	bool evmcs_already_enabled = vmx->nested.enlightened_vmcs_enabled;
> 
> 	vmx->nested.enlightened_vmcs_enabled = true;
> 
> 	if (vmcs_version)
> 		*vmcs_version = nested_get_evmcs_version(vcpu);
> 
> -	/* We don't support disabling the feature for simplicity. */
> -	if (evmcs_already_enabled)
> -		return 0;
> -
> 	vmx->nested.msrs.pinbased_ctls_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
> 	vmx->nested.msrs.entry_ctls_high &= ~EVMCS1_UNSUPPORTED_VMENTRY_CTRL;
> 	vmx->nested.msrs.exit_ctls_high &= ~EVMCS1_UNSUPPORTED_VMEXIT_CTRL;
> -- 
> 2.24.1
> 

