Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EABB21E3463
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 03:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgE0BFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 21:05:18 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36878 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727897AbgE0BFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 21:05:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R0xDgx055249;
        Wed, 27 May 2020 01:03:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=85pK4/81/vdgWfeIJ9uroYFrDxnQQi6IhHVRzvciCac=;
 b=AW8Ue0LA7LdmoDkdjWSZjA5spDniRFTQgW4ssrBQgJDwI8YIY2i1Y8PXWqEUsHlVjJwS
 nqYYyyhHmpoxXnqQOhdyAphWhvDOmWeQS67kKlZzMpDzWR4/c9Cui0h4ZA7jhZI6f4aU
 YbFwKxtwcg7oM6nKdKsBAaB2b44yW6d0bXBZ0jxQXj6B8yk25mu0I+6PS5a3WbetQ1MG
 CZAvuCZjaXHrtvKQH9MXiLkQ069OcqTZdJPEZJo5FulJpiTIlPvumEUI/jU3YOQGOtu1
 TWA6LmUxsd2s+4/l0FGWKsg/9B0hCDc+1vfcLpxLjQ1ncgC4eeJAH/Xe/xHuJrP0uS1N Yg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 318xe1cskk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 27 May 2020 01:03:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04R0vXX6129965;
        Wed, 27 May 2020 01:03:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 317dktf6jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 May 2020 01:03:48 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04R13eJA007736;
        Wed, 27 May 2020 01:03:40 GMT
Received: from localhost.localdomain (/10.159.156.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 May 2020 18:03:40 -0700
Subject: Re: [PATCH 0/2] Fix issue with not starting nesting guests on my
 system
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Tao Xu <tao3.xu@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jingqi Liu <jingqi.liu@intel.com>
References: <20200523161455.3940-1-mlevitsk@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <d80609d2-ca7b-feea-cb5e-6e45d2116eae@oracle.com>
Date:   Tue, 26 May 2020 18:03:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200523161455.3940-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=984
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9633 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 cotscore=-2147483648 mlxscore=0 bulkscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1011 impostorscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005270002
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/23/20 9:14 AM, Maxim Levitsky wrote:
> On my AMD machine I noticed that I can't start any nested guests,
> because nested KVM (everything from master git branches) complains
> that it can't find msr MSR_IA32_UMWAIT_CONTROL which my system doesn't support
> at all anyway.
>
> I traced it to the recently added UMWAIT support to qemu and kvm.
> The kvm portion exposed the new MSR in KVM_GET_MSR_INDEX_LIST without
> checking that it the underlying feature is supported in CPUID.
> It happened to work when non nested because as a precation kvm,
> tries to read each MSR on host before adding it to that list,
> and when read gets a #GP it ignores it.
>
> When running nested, the L1 hypervisor can be set to ignore unknown
> msr read/writes (I need this for some other guests), thus this safety
> check doesn't work anymore.
>
> V2: * added a patch to setup correctly the X86_FEATURE_WAITPKG kvm capability
>      * dropped the cosmetic fix patch as it is now fixed in kvm/queue
>
> Best regards,
> 	Maxim Levitsky
>
> Maxim Levitsky (2):
>    kvm/x86/vmx: enable X86_FEATURE_WAITPKG in KVM capabilities
>    kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL unconditionally
>
>   arch/x86/kvm/vmx/vmx.c | 3 +++
>   arch/x86/kvm/x86.c     | 4 ++++
>   2 files changed, 7 insertions(+)
>
Nit: The added 'break' statement in patch# 2 is not required.

Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
