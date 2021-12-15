Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8287475B6E
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 16:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243682AbhLOPIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 10:08:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53726 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243550AbhLOPIi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 10:08:38 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BFDVXuF032162;
        Wed, 15 Dec 2021 15:08:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=R+2Lnyg06UvjZc0ErmOFPi35clRLyw31hm39yAiYPTU=;
 b=EDJjUHdQ74ixFn9sL4DraeMhQefWkfYGsx3SpsWJgio2mpmQudvOuKKJCS3ADlKTwb8A
 xVNreTovytYGWUD/Nucd6Z8FHZ/5F4vgp3k8Z6HVRPGaydDVGd1BAqtMM9fZ2qw8dzmM
 m3XXDLCpgQYKKfxosf8YG5auRi4avRN4tkcU5aowp2dfnLHQRbv8AxK1j7JI7hajPsVO
 nCpo6YXpUDkvRQd7WAPFYWwdCsA/DFlxL/B2iXD8MU2QcDwHpZo6VnYhkTB/0ktASr04
 VPN3JNXivR1NoLbQMRWf/rDX/DqqDdU5jjWD7xCRyJjabmJGQtYyqDfNha2mekQC/Msb Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cye11exjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 15:08:37 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BFEWWBq027136;
        Wed, 15 Dec 2021 15:08:37 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cye11exj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 15:08:37 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BFF35Rs027525;
        Wed, 15 Dec 2021 15:08:36 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3cy77xvnaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Dec 2021 15:08:36 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BFF8YUx31982054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Dec 2021 15:08:34 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE785BE058;
        Wed, 15 Dec 2021 15:08:34 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2EB2BE051;
        Wed, 15 Dec 2021 15:08:33 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.90.76])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 15 Dec 2021 15:08:33 +0000 (GMT)
Message-ID: <122386e335fc4a369f83f6c98926821a1e702eb4.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v5 1/1] KVM: s390: Clarify SIGP orders versus
 STOP/RESTART
From:   Eric Farman <farman@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Wed, 15 Dec 2021 10:08:33 -0500
In-Reply-To: <a7c7567d-9345-ea85-4866-c0de28decd29@redhat.com>
References: <20211213210550.856213-1-farman@linux.ibm.com>
         <20211213210550.856213-2-farman@linux.ibm.com>
         <3832e4ab-ffb7-3389-908d-99225ccea038@redhat.com>
         <28d795f7-e3f7-e64d-88eb-264a30167961@de.ibm.com>
         <a7c7567d-9345-ea85-4866-c0de28decd29@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9WGtXk2HrV06LvrJXbXekolbUqeUxpPI
X-Proofpoint-ORIG-GUID: c-MCUN404JvL0IcsgoKGxpYxKsFkfAJz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-15_09,2021-12-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 impostorscore=0 spamscore=0 clxscore=1015
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112150086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-12-15 at 15:02 +0100, David Hildenbrand wrote:
> On 15.12.21 14:57, Christian Borntraeger wrote:
> > 
> > Am 15.12.21 um 14:24 schrieb David Hildenbrand:
> > > On 13.12.21 22:05, Eric Farman wrote:
> > > > With KVM_CAP_S390_USER_SIGP, there are only five Signal
> > > > Processor
> > > > orders (CONDITIONAL EMERGENCY SIGNAL, EMERGENCY SIGNAL,
> > > > EXTERNAL CALL,
> > > > SENSE, and SENSE RUNNING STATUS) which are intended for
> > > > frequent use
> > > > and thus are processed in-kernel. The remainder are sent to
> > > > userspace
> > > > with the KVM_CAP_S390_USER_SIGP capability. Of those, three
> > > > orders
> > > > (RESTART, STOP, and STOP AND STORE STATUS) have the potential
> > > > to
> > > > inject work back into the kernel, and thus are asynchronous.
> > > > 
> > > > Let's look for those pending IRQs when processing one of the
> > > > in-kernel
> > > > SIGP orders, and return BUSY (CC2) if one is in process. This
> > > > is in
> > > > agreement with the Principles of Operation, which states that
> > > > only one
> > > > order can be "active" on a CPU at a time.
> > > > 
> > > > Suggested-by: David Hildenbrand <david@redhat.com>
> > > > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > > > ---
> > > 
> > > In general, LGTM. As raised, with SIGP RESTART there are other
> > > cases we
> > > could fix in the kernel, but they are of very low priority IMHO.
> > 
> > Does that qualify as an RB, assuming that we can fix the other
> > cases later on?
> > 
> 
> Certainly an Acked-by: David Hildenbrand <david@redhat.com> , to
> fully
> review I need some more time (maybe tomorrow)
> 

I have the list you'd provided for the other orders on my todo list;
wasn't having a lot of success building a testcase that would
prove/disprove the situation we were in, besides the orders described
here.

(I had previously mentioned the CPU RESET orders, but I'm worried that
that was an error in my setup based on debugging I have been doing
lately.)

