Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C815E792751
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbjIEQEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353757AbjIEHxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 03:53:50 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E1ACC;
        Tue,  5 Sep 2023 00:53:46 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3857f9vf008655;
        Tue, 5 Sep 2023 07:53:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=CEey4NOw8CyFoWJQ/QsYr7gCNQBj9M8Cu2SA8pT2jRw=;
 b=Gix6XRPoqbYr0PKZGD24FMPhkS5LXV2wIoLmkd1uiixTOOlSVfD2zGQXssHGRJg8GTeL
 smUhuCbst95NvXGDroZmnuFu4eEnQSwNdYYMK2A47P6boAYl729Ddc5Y0Yl9LSS3quCD
 1sLIQwLkGD7+WQB0d66im3iOO12ZHZxfUw6WRwA2zwxOApLuZIwMmSpjByI870xoBysU
 aAR14hiWF/0uPH/7EVXDb3c4mTEDT69EqNbtdOqwPHooemGNAebn8HxsuqebjXvMLMxy
 ROExc+lg7rKb7heAoZ/XC/Wl62WBuyjpny1/AKD3v8c8wB1BXsT7fZsvT7+L44Ap+wqM RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3swxq4jfa0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Sep 2023 07:53:45 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3857fbkZ011824;
        Tue, 5 Sep 2023 07:53:44 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3swxq4jf9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Sep 2023 07:53:44 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38564J8e012246;
        Tue, 5 Sep 2023 07:53:43 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3svhkjreyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Sep 2023 07:53:43 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3857reA145547890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Sep 2023 07:53:41 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DECF520043;
        Tue,  5 Sep 2023 07:53:40 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6EA5A20040;
        Tue,  5 Sep 2023 07:53:40 +0000 (GMT)
Received: from [9.171.89.182] (unknown [9.171.89.182])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  5 Sep 2023 07:53:40 +0000 (GMT)
Message-ID: <a41f6fc29032d345b3c2f24e19f32282dd627e5c.camel@linux.ibm.com>
Subject: Re: [PATCH v3 0/2] KVM: s390: add counters for vsie performance
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Date:   Tue, 05 Sep 2023 09:53:40 +0200
In-Reply-To: <20230904130140.22006-1-nrb@linux.ibm.com>
References: <20230904130140.22006-1-nrb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ePed56pXwCPGEPmRxmfMflF7Di0FJh9a
X-Proofpoint-GUID: Rozh9ujNAOJ-jYoMQdh08DdvCHridU_4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_06,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1011 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309050067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2023-09-04 at 15:01 +0200, Nico Boehr wrote:
> v3:
> ---
> * rename te -> entry (David)
> * add counters for gmap reuse and gmap create (David)
>=20
> v2:
> ---
> * also count shadowing of pages (Janosch)
> * fix naming of counters (Janosch)
> * mention shadowing of multiple levels is counted in each level (Claudio)
> * fix inaccuate commit description regarding gmap notifier (Claudio)
>=20
> When running a guest-3 via VSIE, guest-1 needs to shadow the page table
> structures of guest-2.
>=20
> To reflect changes of the guest-2 in the _shadowed_ page table structures=
,
> the _shadowing_ sturctures sometimes need to be rebuilt. Since this is a
> costly operation, it should be avoided whenever possible.
>=20
> This series adds kvm stat counters to count the number of shadow gmaps
> created and a tracepoint whenever something is unshadowed. This is a firs=
t
> step to try and improve VSIE performance.
>=20
> Please note that "KVM: s390: add tracepoint in gmap notifier" has some
> checkpatch --strict findings. I did not fix these since the tracepoint
> definition would then look completely different from all the other
> tracepoints in arch/s390/kvm/trace-s390.h. If you want me to fix that,
> please let me know.
>=20
> While developing this, a question regarding the stat counters came up:
> there's usually no locking involved when the stat counters are incremente=
d.
> On s390, GCC accidentally seems to do the right thing(TM) most of the tim=
e
> by generating a agsi instruction (which should be atomic given proper
> alignment). However, it's not guaranteed, so would we rather want to go
> with an atomic for the stat counters to avoid losing events? Or do we jus=
t
> accept the fact that we might loose events sometimes? Is there anything
> that speaks against having an atomic in kvm_stat?
>=20

FWIW the PCI counters (/sys/kernel/debug/pci/<dev>/statistics) use
atomic64_add(). Also, s390's memory model is strong enough that these
are actually just normal loads/stores/adds (see
arch/s390/include/asm/atomic_ops.h) with the generic atomic64_xx()
adding debug instrumentation.
