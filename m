Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 649A05F55E0
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 15:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiJENzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 09:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJENzK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 09:55:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CEE5F20E
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 06:55:09 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 295DAfCh019356
        for <kvm@vger.kernel.org>; Wed, 5 Oct 2022 13:55:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : to : from : message-id : date; s=pp1;
 bh=p3Sahpz7+FGt8SimC4zBHMVSu/0xsdsyQjNY4+XtB3Q=;
 b=Qaih70VSkw3iRgY1sWVkVdJky4lhTkgUKjKmgzFo0TSaGWgjZ1LfrC52O4B7QNKbSQmn
 HitAJ2fpNfazYFOV01Muwl7LCnaN4KkbMrEqAihejSOpXvVObng0xyLos0iZIae17dMh
 JP2/N9Azx0PsZIRWT8B9BW5Sbx86BqmhkY655GWMeHPDU79CkHCnPPHVwFnqce6rZsSX
 fMzdkPWCfGqX5U4nK6hvHE2dkhdIBcQnRcW7m/i695gLXPnWhtLRYoEyyXMVr7jSyTTo
 Vlys36ZlxojtpEo5I14RJ4IFDhnygUpcpkzHkD/wOUM2QHlhtSBS3K231JkpxLp4IIiJ 0Q== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3k14xjahuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 13:55:08 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 295DpbtD031855
        for <kvm@vger.kernel.org>; Wed, 5 Oct 2022 13:55:07 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3jxd68m58g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 13:55:06 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 295Dt2ng66650606
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 5 Oct 2022 13:55:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A227AE051;
        Wed,  5 Oct 2022 13:55:02 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D302AE045;
        Wed,  5 Oct 2022 13:55:02 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.203.253])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  5 Oct 2022 13:55:02 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <e0f29156-6862-478b-4918-583cbe6adaeb@linux.ibm.com>
References: <20220829075602.6611-1-nrb@linux.ibm.com> <20220829075602.6611-2-nrb@linux.ibm.com> <e0f29156-6862-478b-4918-583cbe6adaeb@linux.ibm.com>
Subject: Re: [RFC PATCH v2 1/1] KVM: s390: pv: don't allow userspace to set the clock under PV
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <166497810230.75085.16107504083701986630@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 05 Oct 2022 15:55:02 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ehieybFz8ZeuZP-DuZSvPIg_az5Ib7ah
X-Proofpoint-ORIG-GUID: ehieybFz8ZeuZP-DuZSvPIg_az5Ib7ah
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-05_01,2022-10-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 mlxlogscore=832 mlxscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 malwarescore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210050085
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Christian Borntraeger (2022-09-20 13:07:58)
> Am 29.08.22 um 09:56 schrieb Nico Boehr:
> > When running under PV, the guest's TOD clock is under control of the
> > ultravisor and the hypervisor isn't allowed to change it. Hence, don't
> > allow userspace to change the guest's TOD clock by returning
> > -EOPNOTSUPP.
> >=20
> > When userspace changes the guest's TOD clock, KVM updates its
> > kvm.arch.epoch field and, in addition, the epoch field in all state
> > descriptions of all VCPUs.
> >=20
> > But, under PV, the ultravisor will ignore the epoch field in the state
> > description and simply overwrite it on next SIE exit with the actual
> > guest epoch. This leads to KVM having an incorrect view of the guest's
> > TOD clock: it has updated its internal kvm.arch.epoch field, but the
> > ultravisor ignores the field in the state description.
> >=20
> > Whenever a guest is now waiting for a clock comparator, KVM will
> > incorrectly calculate the time when the guest should wake up, possibly
> > causing the guest to sleep for much longer than expected.
> >=20
> > With this change, kvm_s390_set_tod() will now take the kvm->lock to be
> > able to call kvm_s390_pv_is_protected(). Since kvm_s390_set_tod_clock()
> > also takes kvm->lock, use __kvm_s390_set_tod_clock() instead.
> >=20
> > Fixes: 0f3035047140 ("KVM: s390: protvirt: Do only reset registers that=
 are accessible")
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>=20
> Has this patch already been sent to the upstream list yet and have we sol=
ved all existing problems of the previous version?

Yes, the patch works and the issues I identified should be fixed now. I can=
 resend as a non-RFC if you like.

Note that a QEMU change is also needed to silence this message:

warning: Unable to set KVM guest TOD clock: Operation not supported

But I wanted to get the kernel side done first.
