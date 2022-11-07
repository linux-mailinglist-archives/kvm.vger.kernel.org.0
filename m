Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC9161FC89
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 19:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbiKGSCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 13:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbiKGSB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 13:01:58 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2129155BA;
        Mon,  7 Nov 2022 09:57:59 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7GWJ3q025033;
        Mon, 7 Nov 2022 17:56:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=f/VyMxldYSSF3j2oK7NPGa3PSNeBgbkNFvcSuG+2vx0=;
 b=S/OmHIKl6xk3e5DTWJwBRHY4lzU49Rc8ZGVwoj57UADrowOK07/esILhX51XvfJdOMXr
 mGyQ+AfwLDXvZLh6Y9AXiwN7sJ7f03jvlfn8cP2lyWNruJtWNqei483yk5/BJuN/WUE4
 +gww4sppA6zPjXCHUAJaLGlfBRtvSFJfa/dLDmf24cRnkgeaih1LzugmsJlZ7fMHhd5A
 ac8WW8nmTO1n8QaI/YhrR898ZaXXwP3xILX1k0Zz4zJaLt+cgarxEXI7olJSehWyz89k
 7VgnIOaxNZTBYMVZSWT0rjhsgcdrdPWr4gKgulZ3e0kr7jg6dJBNUiMelAsjUsixhgYP XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1gmcfya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 17:56:58 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A7GfRN3013181;
        Mon, 7 Nov 2022 17:56:57 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp1gmcfxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 17:56:57 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7Hpg97017981;
        Mon, 7 Nov 2022 17:56:56 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03wdc.us.ibm.com with ESMTP id 3kngs717x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 17:56:56 +0000
Received: from smtpav02.dal12v.mail.ibm.com ([9.208.128.128])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A7Huq9X25494124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 17:56:53 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC5055805E;
        Mon,  7 Nov 2022 17:56:54 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B470A5805F;
        Mon,  7 Nov 2022 17:56:51 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.65.225.56])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 17:56:51 +0000 (GMT)
Message-ID: <5e44854b2781a0be6fae5c82645ac64ef9b5dccf.camel@linux.ibm.com>
Subject: Re: [PATCH 04/44] KVM: Teardown VFIO ops earlier in kvm_exit()
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
Date:   Mon, 07 Nov 2022 12:56:51 -0500
In-Reply-To: <20221102231911.3107438-5-seanjc@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
         <20221102231911.3107438-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lZlTwgd7mrqbECRxIjDdrL-RNnawny2B
X-Proofpoint-GUID: bMDCUJB8k6cbTpkwMsak__06bTu4RXWC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_08,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 clxscore=1011
 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
> Move the call to kvm_vfio_ops_exit() further up kvm_exit() to try and
> bring some amount of symmetry to the setup order in kvm_init(), and
> more
> importantly so that the arch hooks are invoked dead last by
> kvm_exit().
> This will allow arch code to move away from the arch hooks without
> any
> change in ordering between arch code and common code in kvm_exit().
>=20
> That kvm_vfio_ops_exit() is called last appears to be 100%
> arbitrary.=C2=A0 It
> was bolted on after the fact by commit 571ee1b68598 ("kvm: vfio: fix
> unregister kvm_device_ops of vfio").=C2=A0 The nullified
> kvm_device_ops_table
> is also local to kvm_main.c and is used only when there are active
> VMs,
> so unless arch code is doing something truly bizarre, nullifying the
> table earlier in kvm_exit() is little more than a nop.
>=20
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> =C2=A0virt/kvm/kvm_main.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Eric Farman <farman@linux.ibm.com>
