Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E4015215B
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 20:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgBDT7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 14:59:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:44236 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727385AbgBDT7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 14:59:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014JrICc081459;
        Tue, 4 Feb 2020 19:57:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=0INpg/Hj1QddaeE9Yvl2yxKNQKLHtaJEwGKy7Tyco0U=;
 b=GQZmYL+yR/ltnneW8n9lk5qDTNZvvS0UN8v9V3KNedxvCKp2iHYml59CK7t5nYIo+5UF
 44Yg3sYJIE7Gwi6DT336UjElBxPmqL6Bp59SVHremdVsXfAouUl1BqiwXfBprC2IrqvK
 hDc7hyGTUxlQaX/5PsxNU/n6QVH5OZfRd73D0BVDQqfcRQsf/FfGQAqSQVsP2kTmYP4C
 wS/5IkSpvXgzJy+Pl+qRVE8SnEprGTBwlvTT0XcOb4XgMGsS54dQCEN0WGK58AAN4vJe
 o/zOVL+B+WQD81DuyqXlljbjv9pa8USpZyZO9/XHj2DTHlQoFKZcPJut+LV+uFg324B8 6Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xw19qh4vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 19:57:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 014JrYt6063307;
        Tue, 4 Feb 2020 19:57:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xxsbr9ytx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Feb 2020 19:57:44 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 014Jveoe012599;
        Tue, 4 Feb 2020 19:57:40 GMT
Received: from localhost.localdomain (/10.159.243.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 11:57:40 -0800
Subject: Re: [PATCH] KVM: nVMX: Remove stale comment from
 nested_vmx_load_cr3()
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200204153259.16318-1-sean.j.christopherson@intel.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <dcee13f5-f447-9ab4-4803-e3c4f42fb011@oracle.com>
Date:   Tue, 4 Feb 2020 11:57:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200204153259.16318-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002040134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002040134
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/4/20 7:32 AM, Sean Christopherson wrote:
> The blurb pertaining to the return value of nested_vmx_load_cr3() no
> longer matches reality, remove it entirely as the behavior it is
> attempting to document is quite obvious when reading the actual code.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/kvm/vmx/nested.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 7608924ee8c1..0c9b847f7a25 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1076,8 +1076,6 @@ static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
>   /*
>    * Load guest's/host's cr3 at nested entry/exit. nested_ept is true if we are
>    * emulating VM entry into a guest with EPT enabled.
> - * Returns 0 on success, 1 on failure. Invalid state exit qualification code
> - * is assigned to entry_failure_code on failure.
>    */
>   static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool nested_ept,
>   			       u32 *entry_failure_code)

I think it's worth keeping the last part which is " Exit qualification 
code is assigned to entry_failure_code on failure." because "Entry 
Failure" and "Exit Qualification" might sound bit confusing until you 
actually look at the caller nested_vmx_enter_non_root_mode().

