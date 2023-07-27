Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7CD17648C6
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 09:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbjG0Hft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 03:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjG0HfN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 03:35:13 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF6AA5E9;
        Thu, 27 Jul 2023 00:24:44 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36R7APZx007561;
        Thu, 27 Jul 2023 07:24:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : subject : to : cc : message-id : date; s=pp1;
 bh=Syi5jBoXcb9YXp+eHyUzRZXgvE/m85VcKLJywa3mzu8=;
 b=d1L3zhj/+34J46kgXFfmrRH6zRRL1ZpskCY3H3kfOdcRUq2pEU/hCzFGftuZbJ4LKLx6
 CxXHo/zx/3SsoupBDsdfrSi85G8bi0zp0uO/p+uaZkDFjWpClhDvSSXa7gpguTBYPLsH
 rHqX7OH7Xpl2ETV+yOo2X0f1isGxf8FJVqnRN1BlHJPpjHzOOr9HyR/Yj5WKHbQNXCxD
 0NTomZd+wv+tO1xZaSWCKKtxQgRljPil5pseRVK+WS55mdFuoBBsKDLdY7toPtCJyTLp
 aBhZ4+hI1zrr6labR9TEY+YvhYIRB6SsrMY6hvgnNJBkbZpGxtB2WVcFy2dIz4CWirfB xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s3jpka22d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 07:24:41 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36R7D1rk015222;
        Thu, 27 Jul 2023 07:24:40 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s3jpka222-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 07:24:40 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36R57cbE002281;
        Thu, 27 Jul 2023 07:24:40 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3s0unju60h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jul 2023 07:24:39 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36R7ObBZ48955712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jul 2023 07:24:37 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E81D12004F;
        Thu, 27 Jul 2023 07:24:36 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7DBB2004E;
        Thu, 27 Jul 2023 07:24:36 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.9.47])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jul 2023 07:24:36 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230510121822.546629-1-nrb@linux.ibm.com>
References: <20230510121822.546629-1-nrb@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [PATCH v2 0/2] KVM: s390: add counters for vsie performance
To:     borntraeger@linux.ibm.com, david@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Message-ID: <169044267639.15205.14663488561772041796@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 27 Jul 2023 09:24:36 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rLKIgydkaAYbDFq2D_v00iGJD1Sr36er
X-Proofpoint-ORIG-GUID: mquAV01ivDqx_LajCgOR_ZOlD69pQn2X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-26_08,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307270062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Polite ping.

Quoting Nico Boehr (2023-05-10 14:18:20)
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
> To reflect changes of the guest-2 in the _shadowed_ page table structures,
> the _shadowing_ sturctures sometimes need to be rebuilt. Since this is a
> costly operation, it should be avoided whenever possible.
>=20
> This series adds kvm stat counters to count the number of shadow gmaps
> created and a tracepoint whenever something is unshadowed. This is a first
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
> On s390, GCC accidentally seems to do the right thing(TM) most of the time
> by generating a agsi instruction (which should be atomic given proper
> alignment). However, it's not guaranteed, so would we rather want to go
> with an atomic for the stat counters to avoid losing events? Or do we just
> accept the fact that we might loose events sometimes? Is there anything
> that speaks against having an atomic in kvm_stat?
>=20
> Nico Boehr (2):
>   KVM: s390: add stat counter for shadow gmap events
>   KVM: s390: add tracepoint in gmap notifier
>=20
>  arch/s390/include/asm/kvm_host.h |  6 ++++++
>  arch/s390/kvm/gaccess.c          |  7 +++++++
>  arch/s390/kvm/kvm-s390.c         | 10 +++++++++-
>  arch/s390/kvm/trace-s390.h       | 23 +++++++++++++++++++++++
>  arch/s390/kvm/vsie.c             |  1 +
>  5 files changed, 46 insertions(+), 1 deletion(-)
>=20
> --=20
> 2.39.1
>=20
