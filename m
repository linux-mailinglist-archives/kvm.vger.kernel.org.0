Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F1E7927D5
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjIEQDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353916AbjIEIhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 04:37:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220CBCC7;
        Tue,  5 Sep 2023 01:37:32 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3858bKZI009860;
        Tue, 5 Sep 2023 08:37:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=PftVLyxWaT5nKTiMLWpPAX2kgsuGTFwBaIE8EbFXHeY=;
 b=fNFujD3vYYzCuLtossVjwddcDwHhpcoynQm3BEWPdeELcldjjEoLxJ9sm8ZMoDiX9i4A
 dbDUCVjGKjNm1pLcbPXFd8x6w4ZHqwA0yXY8Sg79qahQSpCnk+hv1tbh+6n5e7dKMX0K
 /tyf3PVOyrXnsYpENAOek4UtzfYJ/o3bJjb6tf65bC7AbDAlZQAcuZiStKUNtQW5x5Iz
 vfGjOSF2hPmgSXaaXRL4+7iDYxldIoLRHtDvOcJA9Jk5He0KNakeBJYE6TNmph8DO66/
 O8yH3XwFNkh8CK0DzN3BD/GUiHyHlFGzRblzWzig3zrQYmU6hcQt6AWrH8JgUWQKz6nr sA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3swxq4kbpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Sep 2023 08:37:30 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3858bRJx010429;
        Tue, 5 Sep 2023 08:37:27 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3swxq4kbj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Sep 2023 08:37:27 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3856U7TC011138;
        Tue, 5 Sep 2023 08:33:27 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3svj31gj2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Sep 2023 08:33:27 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3858XOdN19857932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Sep 2023 08:33:24 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FD7C20043;
        Tue,  5 Sep 2023 08:33:24 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41ACF20040;
        Tue,  5 Sep 2023 08:33:24 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.21.157])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  5 Sep 2023 08:33:24 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <a41f6fc29032d345b3c2f24e19f32282dd627e5c.camel@linux.ibm.com>
References: <20230904130140.22006-1-nrb@linux.ibm.com> <a41f6fc29032d345b3c2f24e19f32282dd627e5c.camel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        borntraeger@linux.ibm.com, david@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: Re: [PATCH v3 0/2] KVM: s390: add counters for vsie performance
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <169390280362.97137.14761686200997364254@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 05 Sep 2023 10:33:23 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eFhMuOZ_4TVoN-a1nn2y-R_wCh0ncEMp
X-Proofpoint-GUID: qkQFMT3OknUv3qlTW9fU39LqWPOCUC3k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-05_07,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309050076
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Niklas Schnelle (2023-09-05 09:53:40)
> On Mon, 2023-09-04 at 15:01 +0200, Nico Boehr wrote:
> > v3:
> > ---
> > * rename te -> entry (David)
> > * add counters for gmap reuse and gmap create (David)
> >=20
> > v2:
> > ---
> > * also count shadowing of pages (Janosch)
> > * fix naming of counters (Janosch)
> > * mention shadowing of multiple levels is counted in each level (Claudi=
o)
> > * fix inaccuate commit description regarding gmap notifier (Claudio)
> >=20
> > When running a guest-3 via VSIE, guest-1 needs to shadow the page table
> > structures of guest-2.
> >=20
> > To reflect changes of the guest-2 in the _shadowed_ page table structur=
es,
> > the _shadowing_ sturctures sometimes need to be rebuilt. Since this is a
> > costly operation, it should be avoided whenever possible.
> >=20
> > This series adds kvm stat counters to count the number of shadow gmaps
> > created and a tracepoint whenever something is unshadowed. This is a fi=
rst
> > step to try and improve VSIE performance.
> >=20
> > Please note that "KVM: s390: add tracepoint in gmap notifier" has some
> > checkpatch --strict findings. I did not fix these since the tracepoint
> > definition would then look completely different from all the other
> > tracepoints in arch/s390/kvm/trace-s390.h. If you want me to fix that,
> > please let me know.
> >=20
> > While developing this, a question regarding the stat counters came up:
> > there's usually no locking involved when the stat counters are incremen=
ted.
> > On s390, GCC accidentally seems to do the right thing(TM) most of the t=
ime
> > by generating a agsi instruction (which should be atomic given proper
> > alignment). However, it's not guaranteed, so would we rather want to go
> > with an atomic for the stat counters to avoid losing events? Or do we j=
ust
> > accept the fact that we might loose events sometimes? Is there anything
> > that speaks against having an atomic in kvm_stat?
> >=20
>=20
> FWIW the PCI counters (/sys/kernel/debug/pci/<dev>/statistics) use
> atomic64_add(). Also, s390's memory model is strong enough that these
> are actually just normal loads/stores/adds (see
> arch/s390/include/asm/atomic_ops.h) with the generic atomic64_xx()
> adding debug instrumentation.

In KVM I am mostly concerned about the compiler since we just do counter++
- right now this always seems to result in an agsi instruction, but that's
of course not guaranteed.
