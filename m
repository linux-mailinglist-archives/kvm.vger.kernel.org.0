Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D08061FC8B
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbiKGSCb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbiKGSCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:02:08 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA686120B3;
        Mon,  7 Nov 2022 09:58:34 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7GwDic011947;
        Mon, 7 Nov 2022 17:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=YihfQm6JRpW3FFMAWPS/MkEOkqiW/lbLXXaGSks5I5Y=;
 b=RmD9JtKvUg9mHfb6CMoDoiJwC4LwdRkwwMPnUP0+ML3lsvjLRm5m1SxYiMb3WRhYQFk0
 VVTpLv10dzML14PzTxA17a+meZi9SVZlmkNg/nNXWorX1oVwSU05SmVRYjq76jbrEwe7
 ix+v4arhKFwHnLT5ZzI7WGnJm5nL1eaZZIYSXxqgmKN3lhZIF5Aez2YyK2FLT2o3PvCa
 P4/4GWhyQ1jb6gNiyeSCtYeSAXD38BT8KoUps434p/v3mRFsfpmY4GruA8/z9GDigjvt
 JesjjGdkEkLL7eNvk3XJ78eYdrhitHcx3p7SiQxW6u1SuwPxBdPqwR1FSz3X1CM/pw/Z ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp14xc29y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 17:57:25 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A7GAU5a024872;
        Mon, 7 Nov 2022 17:57:24 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp14xc296-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 17:57:24 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7Hotxo017059;
        Mon, 7 Nov 2022 17:57:23 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03dal.us.ibm.com with ESMTP id 3kngphwhp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 17:57:23 +0000
Received: from smtpav01.dal12v.mail.ibm.com ([9.208.128.133])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A7HvI5v35914384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 17:57:18 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38E3658062;
        Mon,  7 Nov 2022 17:57:21 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1971F58059;
        Mon,  7 Nov 2022 17:57:18 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.65.225.56])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 17:57:17 +0000 (GMT)
Message-ID: <1386ccd1ff60cb8e4af80fbb294160a8d7cc3b5b.camel@linux.ibm.com>
Subject: Re: [PATCH 05/44] KVM: s390: Unwind kvm_arch_init()
 piece-by-piece() if a step fails
From:   Eric Farman <farman@linux.ibm.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Date:   Mon, 07 Nov 2022 12:57:17 -0500
In-Reply-To: <20221102231911.3107438-6-seanjc@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
         <20221102231911.3107438-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: x0CFSwe6XYz-Xhj4j-0SH7l6f0V92YqI
X-Proofpoint-GUID: 6DNbjcvPaQN4ZD-vbbGxEV1nmcCcrdiP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070140
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-11-02 at 23:18 +0000, Sean Christopherson wrote:
> In preparation for folding kvm_arch_hardware_setup() into
> kvm_arch_init(),
> unwind initialization one step at a time instead of simply calling
> kvm_arch_exit().=C2=A0 Using kvm_arch_exit() regardless of which
> initialization
> step failed relies on all affected state playing nice with being
> undone
> even if said state wasn't first setup.=C2=A0 That holds true for state
> that is
> currently configured by kvm_arch_init(), but not for state that's
> handled
> by kvm_arch_hardware_setup(), e.g. calling
> gmap_unregister_pte_notifier()
> without first registering a notifier would result in list corruption
> due
> to attempting to delete an entry that was never added to the list.
>=20
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> =C2=A0arch/s390/kvm/kvm-s390.c | 21 ++++++++++++++-------
> =C2=A01 file changed, 14 insertions(+), 7 deletions(-)

Reviewed-by: Eric Farman <farman@linux.ibm.com>
