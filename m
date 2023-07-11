Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278F774E58A
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 05:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbjGKDzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 23:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjGKDzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 23:55:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AF2E55
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 20:55:08 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36B3lJqi021585;
        Tue, 11 Jul 2023 03:54:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=pp1;
 bh=RwCO+2bmBWnvFOWtZ+uBFn/VKgVsxYa70c97zzbGSUQ=;
 b=O5MkhUOCNCd1klcuCM19HjOkCVXASr5KaUMCZszKKY0KUEeui7ssZlZqw/S/QVs5IGaD
 X70OCwB6UcExBtiM9O0Rm2XE+Q324MvLiCNgvJ9UWILjWO0JOL+hsIehefQWKxbBuRsM
 8/JXmuf+crjvrLZnwzQhpMMHdrTWbGkqTOwpfwXG10Bx0UowVqYPtdqIeCfE52DTwFYM
 AEEaftvxAXWDx447rIbg/xQwL8HcsDT3Me+UQ9mQT7zU82cd1w9/q8qYnISitqrmzTe1
 XdFFLGXmRjCJ0UrVDAnTSuGX1kCRzvgcFVOTZKbOQeSkOLIE/kMLEqxwawuSY7DMUxnM sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rryfu039c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 03:54:52 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36B3rGqS005096;
        Tue, 11 Jul 2023 03:54:51 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rryfu038x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 03:54:51 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B3S4mw011446;
        Tue, 11 Jul 2023 03:54:49 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3rpye5163x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 03:54:48 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36B3sk9E27198132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 03:54:46 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 578D02004B;
        Tue, 11 Jul 2023 03:54:46 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D51C120040;
        Tue, 11 Jul 2023 03:54:42 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 11 Jul 2023 03:54:42 +0000 (GMT)
Date:   Tue, 11 Jul 2023 09:24:39 +0530
From:   Kautuk Consul <kconsul@linux.vnet.ibm.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        maz@kernel.org, robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Subject: Re: [PATCH v4 03/16] KVM: Add KVM_CAP_MEMORY_FAULT_INFO
Message-ID: <ZKzSf82kuik7wYkA@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20230602161921.208564-1-amoorthy@google.com>
 <20230602161921.208564-4-amoorthy@google.com>
 <ZIn6VQSebTRN1jtX@google.com>
 <ZKf7+D474ESdNP3D@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <CAF7b7mr7BZayOxE2y8K87+AfYuGoDc7_kA2ouA3kBuhSgDiomg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAF7b7mr7BZayOxE2y8K87+AfYuGoDc7_kA2ouA3kBuhSgDiomg@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zqeUP3KPyL2ytxwyzGGJ8LPyUyHSPe0b
X-Proofpoint-ORIG-GUID: e1LTHjhHKowPrJB5hpHp2zzubW8LwU8K
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-10_18,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0 impostorscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110031
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > >
> > I think that this check is needed but without the WARN_ON_ONCE as per my
> > other comment.
> > Reason is that we really need to insulate the code against preemption
> > kicking in before the call to preempt_disable() as the logic seems to
> > need this check to avoid concurrency problems.
> > (I don't think Anish simply copied this if-check from mark_page_dirty_in_slot)
> 
> Heh, you're giving me too much credit here. I did copy-paste this
> check, not from from mark_page_dirty_in_slot() but from one of Sean's
> old responses [1]
Oh, I see.
> 
> > That said, I agree that there's a risk that KVM could clobber vcpu->run_run by
> > hitting an -EFAULT without the vCPU loaded, but that's a solvable problem, e.g.
> > the helper to fill KVM_EXIT_MEMORY_FAULT could be hardened to yell if called
> > without the target vCPU being loaded:
> >
> >     int kvm_handle_efault(struct kvm_vcpu *vcpu, ...)
> >     {
> >         preempt_disable();
> >         if (WARN_ON_ONCE(vcpu != __this_cpu_read(kvm_running_vcpu)))
> >             goto out;
> >
> >         vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
> >         ...
> >     out:
> >         preempt_enable();
> >         return -EFAULT;
> >     }
> 
> Ancient history aside, let's figure out what's really needed here.
> 
> > Why use WARN_ON_ONCE when there is a clear possiblity of preemption
> > kicking in (with the possibility of vcpu_load/vcpu_put being called
> > in the new task) before preempt_disable() is called in this function ?
> > I think you should use WARN_ON_ONCE only where there is some impossible
> > or unhandled situation happening, not when there is a possibility of that
> > situation clearly happening as per the kernel code.
> 
> I did some mucking around to try and understand the kvm_running_vcpu
> variable, and I don't think preemption/rescheduling actually trips the
> WARN here? From my (limited) understanding, it seems that the
> thread being preempted will cause a vcpu_put() via kvm_sched_out().
> But when the thread is eventually scheduled back in onto whatever
> core, it'll vcpu_load() via kvm_sched_in(), and the docstring for
> kvm_get_running_vcpu() seems to imply the thing that vcpu_load()
> stores into the per-cpu "kvm_running_vcpu" variable will be the same
> thing which would have been observed before preemption.
> 
> All that's to say: I wouldn't expect the value of
> "__this_cpu_read(kvm_running_vcpu)" to change in any given thread. If
> that's true, then the things I would expect this WARN to catch are (a)
> bugs where somehow the thread gets scheduled without calling
> vcpu_load() or (b) bizarre situations (probably all bugs?) where some
> vcpu thread has a hold of some _other_ kvm_vcpu* and is trying to do
> something with it.
Oh I completely missed the scheduling path for KVM.
But since vcpu_put and vcpu_load are exported symbols, I wonder what'll
happen when there are calls to these functions from places other
than kvm_sched_in() and kvm_sched_out() ? Just thinking out loud.
> 
> 
> On Wed, Jun 14, 2023 at 10:35 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > Meh, this is overkill IMO.  The check in mark_page_dirty_in_slot() is an
> > abomination that I wish didn't exist, not a pattern that should be copied.  If
> > we do keep this sanity check, it can simply be
> >
> >         if (WARN_ON_ONCE(vcpu != kvm_get_running_vcpu()))
> >                 return;
> >
> > because as the comment for kvm_get_running_vcpu() explains, the returned vCPU
> > pointer won't change even if this task gets migrated to a different pCPU.  If
> > this code were doing something with vcpu->cpu then preemption would need to be
> > disabled throughout, but that's not the case.
> 
> Oh, looks like Sean said the same thing. Guess I probably should have
> read that reply more closely first :/
I too get less time to completely read through emails and
associated code between my work assignments. :-).
> 
> 
> [1] https://lore.kernel.org/kvm/ZBnLaidtZEM20jMp@google.com/
