Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFC6755AC6
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 07:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjGQFJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 01:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbjGQFJe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 01:09:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E553E56;
        Sun, 16 Jul 2023 22:09:33 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36H4bhda003688;
        Mon, 17 Jul 2023 05:09:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=djYQ1lJBn0LukPc9XaG8yrilkPySwBvGSjdkQoCHC3Y=;
 b=C+cpcHguWeG/1UiS8xCI37nsvopu925w8G9gzMIuMQ2AFy8alUcNmdNESwA0uhoPOcSg
 tvRQyBGhCJXUdm2nJ7T6jRuRUXtAS77Ltq/7F5+XZ+M6EBdZIbKhbQGCc+EiNbLhvAEm
 1byzXgEUp/CnK0yZS9/GCjv/asXuHBy3iLn8hqghR+PSG46fpAwekoG6QiUmC7I6ieiY
 sBTMO4wElmbsgOxIFw1Jk4PTu+WnsMGv2wXyj30LQU3lhJZsuW6uDaErm8Ler/dZEq15
 xrhKJHdCjqnkaxdfku4h9tjtx26N1fd7SKWIjBQZtd8V690HdRZ+OcDPBljxg3jwCIyK fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rvxfvgtud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jul 2023 05:09:24 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36H4qabW013023;
        Mon, 17 Jul 2023 05:09:24 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rvxfvgttq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jul 2023 05:09:23 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36H3qg2p023422;
        Mon, 17 Jul 2023 05:09:21 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rujqe0ycj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Jul 2023 05:09:21 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36H59JaP25231664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 05:09:19 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53B7020043;
        Mon, 17 Jul 2023 05:09:19 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F27502004B;
        Mon, 17 Jul 2023 05:09:16 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Mon, 17 Jul 2023 05:09:16 +0000 (GMT)
Date:   Mon, 17 Jul 2023 10:39:14 +0530
From:   Kautuk Consul <kconsul@linux.vnet.ibm.com>
To:     Jordan Niethe <jniethe5@gmail.com>
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>, jpn@linux.vnet.ibm.com,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] KVM: ppc64: Enable ring-based dirty memory tracking
Message-ID: <ZLTM+kyIGYVX7rG7@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20230608123448.71861-1-kconsul@linux.vnet.ibm.com>
 <266701ad-90df-e4c8-bbf7-c6411b759c5f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <266701ad-90df-e4c8-bbf7-c6411b759c5f@gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1ppIkR7FTQy7ja3SY_JxBjMnnReMPURX
X-Proofpoint-GUID: fvxbgi9YedCm6ixdZ-qsjXhE7i_dPGmC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_03,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 impostorscore=0 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=426 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307170046
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jordan,

On 2023-07-06 14:15:13, Jordan Niethe wrote:
> 
> 
> On 8/6/23 10:34 pm, Kautuk Consul wrote:
> 
> Need at least a little context in the commit message itself:
> 
> "Enable ring-based dirty memory tracking on ppc64:"
Sure will take this in the v2 patch.
> 
> > - Enable CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL as ppc64 is weakly
> >    ordered.
> > - Enable CONFIG_NEED_KVM_DIRTY_RING_WITH_BITMAP because the
> >    kvmppc_xive_native_set_attr is called in the context of an ioctl
> >    syscall and will call kvmppc_xive_native_eq_sync for setting the
> >    KVM_DEV_XIVE_EQ_SYNC attribute which will call mark_dirty_page()
> >    when there isn't a running vcpu. Implemented the
> >    kvm_arch_allow_write_without_running_vcpu to always return true
> >    to allow mark_page_dirty_in_slot to mark the page dirty in the
> >    memslot->dirty_bitmap in this case.
> 
> Should kvm_arch_allow_write_without_running_vcpu() only return true in the
> context of kvmppc_xive_native_eq_sync()?
Not required. Reason is: kvm_arch_allow_write_without_running_vcpu() is
anyway used only for avoiding the WARN_ON_ONCE in
mark_page_dirty_in_slot(). The memslot->dirty_bitmap in mark_page_dirty_in_slot()
will be anyway used only when the KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP is
set and the vcpu returned by kvm_get_running_vcpu() is NULL which is
what happens only when kvmppc_xive_native_eq_sync is called via the
ioctl syscall I mentioned.

> > +		*ptep = __pte(pte_val(*ptep) & ~(_PAGE_WRITE));
> On rpt I think you'd need to use kvmppc_radix_update_pte()?
Sure. I'll add a check for radix_enabled() and call
kvmppc_radix_update_pte() or a similar function in the v2 patch for this.
