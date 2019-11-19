Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E089210229F
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 12:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfKSLJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 06:09:37 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37688 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfKSLJh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 06:09:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJB91xe006850;
        Tue, 19 Nov 2019 11:09:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=+LudNtyX4Erl79mhNu0hhJPpKxMnYeH2eWFQ1JlktzU=;
 b=fSmYs4hW/5MztNVxGTRQPMiBmB/51N8yChcgsYCOk6sEURBJnfrlt3sfu4qisDDr5MK2
 t/VTFb+6R7aAvjC0lZ4zXE0rPyELsaBVGhAlHBSY8kdUcV9tRWcePoXV/8ox2cZg+zQ1
 Db2B6oFA+gR8x56JkM3z6msbdlq82gMDT7O4tQFdGgCSA9B1RcYrPnfNXD9qFVJKAKNB
 WUergQHpnbErJtRdSJ74UC840znf4H6vawWf61mGbEzmtTCArnj7X0j8+MVSvpn0XMK+
 TYrzltYoC460e6cJGzNmPwX/t6C4oEpWOFi1gglAqwTtFjMq5eCCUlzN3VvGIQTL1cvw 7g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2wa92pp49c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 11:09:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJB94vF130106;
        Tue, 19 Nov 2019 11:09:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2wc09x753n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 11:09:28 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAJB9Qh9002160;
        Tue, 19 Nov 2019 11:09:26 GMT
Received: from [192.168.14.112] (/79.181.226.113)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Nov 2019 03:09:25 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: nVMX: add CR4_LA57 bit to nested CR4_FIXED1
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <20191119083359.15319-1-chenyi.qiang@intel.com>
Date:   Tue, 19 Nov 2019 13:09:21 +0200
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <348B5C47-7AA0-4DAC-91A7-8FB0D0205EF6@oracle.com>
References: <20191119083359.15319-1-chenyi.qiang@intel.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 19 Nov 2019, at 10:33, Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>=20
> When L1 guest uses 5-level paging, it fails vm-entry to L2 due to
> invalid host-state. It needs to add CR4_LA57 bit to nested CR4_FIXED1
> MSR.
>=20
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

Reviewed-by: Liran Alon <liran.alon@oracle.com>

> ---
> arch/x86/kvm/vmx/vmx.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 621142e55e28..89253d60e23a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6962,6 +6962,7 @@ static void =
nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
> 	cr4_fixed1_update(X86_CR4_SMAP,       ebx, =
bit(X86_FEATURE_SMAP));
> 	cr4_fixed1_update(X86_CR4_PKE,        ecx, =
bit(X86_FEATURE_PKU));
> 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, =
bit(X86_FEATURE_UMIP));
> +	cr4_fixed1_update(X86_CR4_LA57,       ecx, =
bit(X86_FEATURE_LA57));
>=20
> #undef cr4_fixed1_update
> }
> --=20
> 2.17.1
>=20

