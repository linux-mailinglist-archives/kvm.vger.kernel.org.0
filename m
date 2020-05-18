Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0511D88DD
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 22:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgERUHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 16:07:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51138 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgERUHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 16:07:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04IK764u085239;
        Mon, 18 May 2020 20:07:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=WbuNkJM/yx6OUy86ccwTxQwFAWolA1yJS4SlSBW0iVI=;
 b=OWE5M8baMSxLadkHPIDA1fFulA0kt6ZrWUNADTSOouokIQOCf2UcqSa9ATiL1D/ndlQ2
 zW8oiXV4YUEP626zXyG//3/JEvyWCseS0dXwfkyH2K4eItlCOibAJu/O9xLPaGrFRKh9
 BL3RWI926GmO7ZTplFs6RvBUqWFScTuVjlzRW7jBLUZbHkkb3jbiXrsdzsJkAAql4O4D
 Npp58qoH39XT5HFKoWIIkFkw77SAE0GgMiFWMVrrFZ+pAEqr6AcvRW/ijDQ/D75WfvLt
 2iYnij3DIZbKE3fmnAlws947YoWwQYiTNrmXgzEQ56CCqwNyLZIfO9b+MCnGocKQe5at Lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127kr1axb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 18 May 2020 20:07:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04IJwwUl037826;
        Mon, 18 May 2020 20:07:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 312t31y9q9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 May 2020 20:07:35 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04IK7XTR009061;
        Mon, 18 May 2020 20:07:33 GMT
Received: from localhost.localdomain (/10.159.148.153)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 May 2020 13:07:33 -0700
Subject: Re: [PATCH 0/7] KVM: SVM: baby steps towards nested state migration
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Cathy Avery <cavery@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Jim Mattson <jmattson@google.com>
References: <20200515174144.1727-1-pbonzini@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <27c7526c-4d02-c9ba-7d3b-7416dbe4cdbb@oracle.com>
Date:   Mon, 18 May 2020 13:07:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200515174144.1727-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9625 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005180171
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/15/20 10:41 AM, Paolo Bonzini wrote:
> Here are some refactorings to prepare for an SVM implementation of
> KVM_SET_NESTED_STATE.  It's a prerequisite for that to eliminate
> exit_required, moving exceptions to svm_check_nested_events.  However:
>
> - I might work on that soon, because it's needed to handle RSM when
> the L1 hypervisor wants to get it from #UD rather than the specific
> RSM intercept
>
> - this should be enough to get a quick prototype, that I need in order to
> debug a particularly crazy bug and figure out its reproducibility.
>
> So, I am getting these patches out of my todo list for now.
>
> Thanks,
>
> Paolo
>
> Paolo Bonzini (7):
>    KVM: SVM: move map argument out of enter_svm_guest_mode
>    KVM: SVM: extract load_nested_vmcb_control
>    KVM: SVM: extract preparation of VMCB for nested run
>    KVM: SVM: save all control fields in svm->nested
>    KVM: nSVM: remove HF_VINTR_MASK
>    KVM: nSVM: do not reload pause filter fields from VMCB
>    KVM: SVM: introduce data structures for nested virt state
>
>   arch/x86/include/asm/kvm_host.h |   1 -
>   arch/x86/include/uapi/asm/kvm.h |  26 +++++++-
>   arch/x86/kvm/svm/nested.c       | 115 +++++++++++++++++---------------
>   arch/x86/kvm/svm/svm.c          |  11 ++-
>   arch/x86/kvm/svm/svm.h          |  28 +++++---
>   5 files changed, 116 insertions(+), 65 deletions(-)
>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
