Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7495A26ED
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 13:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbiHZLfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 07:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiHZLfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 07:35:42 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F397EBBA7F
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 04:35:41 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27QANCOG010591
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 11:35:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 subject : cc : from : message-id : date; s=pp1;
 bh=bJ4tQoFLP3xuniQZorF/y/GBbHrNY95/Je2jfikrZ7U=;
 b=YFd0Df1YG8hpGQuLwHXSIJyEjZcGejyDqMPtgww2hkMF8FHI4Dy5xtLW1mkF4eMJv4Ry
 s0Fib/shOzKWvybLh+UiUJmu+lU/eQ8Lwy9GHru1ZCBYge+Mta3a7IYrrPy6WADwloM0
 OZCEQp3H3UotHc5E+y7wj7OL7o6kCkrlqmkbAQZ5/AA173YWT2Fo1qYK+Zkb2F4SKpEx
 jdYLIyxVx6QajIJvvDeheZ9SO4WaJjMtSg4BOR/Y3i5FdrIivNJW0G0or8NEZ0JRQ9G2
 Z5Za/fP/kmL/ljmmp1HJ632r1fDMKW8zI4LMM16df2lFE5Z8ZaZ36YvXnifPvh+yeVKZ FA== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j6vchhxmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 11:35:41 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27QBLHR0006185
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 11:35:39 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3j2q895m31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 11:35:39 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27QBZaHg40173868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 11:35:36 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2014EAE04D;
        Fri, 26 Aug 2022 11:35:36 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FD67AE045;
        Fri, 26 Aug 2022 11:35:35 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.38.107])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 26 Aug 2022 11:35:35 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220825115015.45545-2-nrb@linux.ibm.com>
References: <20220825115015.45545-1-nrb@linux.ibm.com> <20220825115015.45545-2-nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/1] KVM: s390: pv: don't allow userspace to set the clock under PV
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <166151373444.13152.2751784315193991827@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 26 Aug 2022 13:35:34 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZkCUxmbJybHq2mzegOqEsPcM_I5HPjCE
X-Proofpoint-GUID: ZkCUxmbJybHq2mzegOqEsPcM_I5HPjCE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_04,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=438 clxscore=1015 adultscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208260046
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nico Boehr (2022-08-25 13:50:15)
> When running under PV, the guest's TOD clock is under control of the
> ultravisor and the hypervisor isn't allowed to change it. Hence, don't
> allow userspace to change the guest's TOD clock by returning
> -EOPNOTSUPP.
>=20
> When userspace changes the guest's TOD clock, KVM updates its
> kvm.arch.epoch field and, in addition, the epoch field in all state
> descriptions of all VCPUs.
>=20
> But, under PV, the ultravisor will ignore the epoch field in the state
> description and simply overwrite it on next SIE exit with the actual
> guest epoch. This leads to KVM having an incorrect view of the guest's
> TOD clock: it has updated its internal kvm.arch.epoch field, but the
> ultravisor ignores the field in the state description.
>=20
> Whenever a guest is now waiting for a clock comparator, KVM will
> incorrectly calculate the time when the guest should wake up, possibly
> causing the guest to sleep for much longer than expected.
>=20
> Fixes: 0f3035047140 ("KVM: s390: protvirt: Do only reset registers that a=
re accessible")
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

This patch seems to break migration (QEMU gets stuck). Possibly a locking i=
ssue, I will investigate.
