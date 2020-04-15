Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9711A9CE4
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 13:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897356AbgDOLka convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 15 Apr 2020 07:40:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53656 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2408904AbgDOLhl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Apr 2020 07:37:41 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FBb6Rq044106
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 07:37:32 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30dnmtadwy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 07:37:31 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <imbrenda@linux.ibm.com>;
        Wed, 15 Apr 2020 12:37:02 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 Apr 2020 12:36:56 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03FBbMGa54264042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 11:37:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25EB911C054;
        Wed, 15 Apr 2020 11:37:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29D7C11C04C;
        Wed, 15 Apr 2020 11:37:21 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.12.13])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 15 Apr 2020 11:37:21 +0000 (GMT)
Date:   Wed, 15 Apr 2020 13:37:18 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <f4bug@amsat.org>,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2] kvm_host: unify VM_STAT and VCPU_STAT definitions in
 a single place
In-Reply-To: <992ede27-3eae-f2da-ad38-1d3498853ad2@redhat.com>
References: <20200414155625.20559-1-eesposit@redhat.com>
        <b479e7ff-4534-5ced-e19b-2a2914905a8b@amsat.org>
        <992ede27-3eae-f2da-ad38-1d3498853ad2@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
x-cbid: 20041511-0008-0000-0000-00000371193C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041511-0009-0000-0000-00004A92CCDF
Message-Id: <20200415133718.2db57666@p-imbrenda>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_03:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 phishscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150087
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Apr 2020 10:30:06 +0200
Emanuele Giuseppe Esposito <eesposit@redhat.com> wrote:

> On 4/15/20 8:36 AM, Philippe Mathieu-Daudé wrote:
> > On 4/14/20 5:56 PM, Emanuele Giuseppe Esposito wrote:  
> >> The macros VM_STAT and VCPU_STAT are redundantly implemented in
> >> multiple files, each used by a different architecure to initialize
> >> the debugfs entries for statistics. Since they all have the same
> >> purpose, they can be unified in a single common definition in
> >> include/linux/kvm_host.h
> >>
> >> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> >> ---
> >>   arch/arm64/kvm/guest.c    |  23 ++---
> >>   arch/mips/kvm/mips.c      |  61 ++++++------
> >>   arch/powerpc/kvm/book3s.c |  61 ++++++------
> >>   arch/powerpc/kvm/booke.c  |  41 ++++----
> >>   arch/s390/kvm/kvm-s390.c  | 203
> >> +++++++++++++++++++------------------- arch/x86/kvm/x86.c        |
> >>  80 +++++++-------- include/linux/kvm_host.h  |   5 +
> >>   7 files changed, 231 insertions(+), 243 deletions(-)
> >>
> >> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> >> index 23ebe51410f0..8417b200bec9 100644
> >> --- a/arch/arm64/kvm/guest.c
> >> +++ b/arch/arm64/kvm/guest.c
> >> @@ -29,20 +29,17 @@
> >>   
> >>   #include "trace.h"
> >>   
> >> -#define VM_STAT(x) { #x, offsetof(struct kvm, stat.x),
> >> KVM_STAT_VM } -#define VCPU_STAT(x) { #x, offsetof(struct
> >> kvm_vcpu, stat.x), KVM_STAT_VCPU } -
> >>   struct kvm_stats_debugfs_item debugfs_entries[] = {
> >> -	VCPU_STAT(halt_successful_poll),
> >> -	VCPU_STAT(halt_attempted_poll),
> >> -	VCPU_STAT(halt_poll_invalid),
> >> -	VCPU_STAT(halt_wakeup),
> >> -	VCPU_STAT(hvc_exit_stat),
> >> -	VCPU_STAT(wfe_exit_stat),
> >> -	VCPU_STAT(wfi_exit_stat),
> >> -	VCPU_STAT(mmio_exit_user),
> >> -	VCPU_STAT(mmio_exit_kernel),
> >> -	VCPU_STAT(exits),
> >> +	VCPU_STAT("halt_successful_poll", halt_successful_poll),
> >> +	VCPU_STAT("halt_attempted_poll", halt_attempted_poll),
> >> +	VCPU_STAT("halt_poll_invalid", halt_poll_invalid),
> >> +	VCPU_STAT("halt_wakeup", halt_wakeup),
> >> +	VCPU_STAT("hvc_exit_stat", hvc_exit_stat),
> >> +	VCPU_STAT("wfe_exit_stat", wfe_exit_stat),
> >> +	VCPU_STAT("wfi_exit_stat", wfi_exit_stat),
> >> +	VCPU_STAT("mmio_exit_user", mmio_exit_user),
> >> +	VCPU_STAT("mmio_exit_kernel", mmio_exit_kernel),
> >> +	VCPU_STAT("exits", exits),
> >>   	{ NULL }
> >>   };  
> > 
> > Patch easily reviewed with --word-diff.
> > 
> > [...]  
> >> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >> index 6d58beb65454..2e6ead872957 100644
> >> --- a/include/linux/kvm_host.h
> >> +++ b/include/linux/kvm_host.h
> >> @@ -1130,6 +1130,11 @@ struct kvm_stats_debugfs_item {
> >>   #define KVM_DBGFS_GET_MODE(dbgfs_item)
> >>               \ ((dbgfs_item)->mode ? (dbgfs_item)->mode : 0644)
> >>   
> >> +#define VM_STAT(n, x, ...)
> >> 									   \
> >> +	{ n, offsetof(struct kvm, stat.x), KVM_STAT_VM, ##
> >> __VA_ARGS__ } +#define VCPU_STAT(n, x, ...)
> >> 									   \
> >>  
> > 
> > Not sure while you use so many whitespaces here... (maybe Paolo can
> > strip some when applying?).  
> 
> I honestly am not sure why it added few more spaces than I wanted,
> but the idea was to follow the KVM_DBGFS_GET_MODE macro above and put
> the backslash at the end of the line (80th char).

once the whitespace issues are fixed, you can also add

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
 
> > 
> > Otherwise it looks nicer that v1, thanks.
> > 
> > Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> >   
> >> +	{ n, offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU, ##
> >> __VA_ARGS__ } +
> >>   extern struct kvm_stats_debugfs_item debugfs_entries[];
> >>   extern struct dentry *kvm_debugfs_dir;
> >>   
> >>  
> >   
> 

