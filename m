Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288EF4577AA
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 21:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbhKSUXp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 15:23:45 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:55514 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230474AbhKSUXo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 15:23:44 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AJJiGP3015415;
        Fri, 19 Nov 2021 20:20:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=BtB+qZSV4tF1z3EjQQN1P+BdhpW/UZe1Ndn4JleH048=;
 b=HlmqKET7/4NaU1xE2cMW1WswQj48l4ZqFxeN4cxTz8CO3pJSPgmdOfTFLqwG/QDv5Wf+
 WTwTqk34yPX9ODskcnGVFtIzgCe8b5IrglNngLahoGoVF1qTey/Az3HwGuaWNdTsNyU8
 dKHkvOgfCLbyX0uALLTo2Xge7TxosxOy//PM4B3AKYF2w1btgU4s6Y2/hJg3HRMkwLKk
 nD4p8sT9wTEMF2Vo87jImfTPZE7O6JJ9bG3CYcT4pmPdo/m3HMCDCuXbEIHr7aGg+POu
 N5ZPNOAJOlBT8Infvk9YEobtfuYh3rWiyLkbW6WmjyrDvDjypxdkbWRBfBdyCxq4NaLf Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cejbb8nqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 20:20:42 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AJJjJod018712;
        Fri, 19 Nov 2021 20:20:42 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cejbb8nqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 20:20:42 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AJKBwBd016745;
        Fri, 19 Nov 2021 20:20:40 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02wdc.us.ibm.com with ESMTP id 3cd81es9gb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 20:20:40 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AJKKdjb29098562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Nov 2021 20:20:39 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9F2296A04D;
        Fri, 19 Nov 2021 20:20:39 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4D006A057;
        Fri, 19 Nov 2021 20:20:38 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.117.31])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 19 Nov 2021 20:20:38 +0000 (GMT)
Message-ID: <cd1c11a05cc13fb8c70ce3644dcf823a840872b5.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v3 2/2] KVM: s390: Extend the USER_SIGP capability
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Fri, 19 Nov 2021 15:20:37 -0500
In-Reply-To: <9c9bbf66-54c9-3d02-6d9f-1e147945abe8@de.ibm.com>
References: <20211110203322.1374925-1-farman@linux.ibm.com>
         <20211110203322.1374925-3-farman@linux.ibm.com>
         <dd8a8b49-da6d-0ab8-dc47-b24f5604767f@redhat.com>
         <ab82e68051674ea771e2cb5371ca2a204effab40.camel@linux.ibm.com>
         <32836eb5-532f-962d-161a-faa2213a0691@linux.ibm.com>
         <b116e738d8f9b185867ab28395012aaddd58af31.camel@linux.ibm.com>
         <85ba9fa3-ca25-b598-aecd-5e0c6a0308f2@redhat.com>
         <19a2543b24015873db736bddb14d0e4d97712086.camel@linux.ibm.com>
         <9c9bbf66-54c9-3d02-6d9f-1e147945abe8@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-16.el8) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IzA7vE_QigE291u-n3EDW2emQSpeTOzB
X-Proofpoint-ORIG-GUID: jUKVzFCZftM6lZDE5nfVMNmNcZia1Ays
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_15,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111190108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-11-17 at 08:54 +0100, Christian Borntraeger wrote:
> Am 11.11.21 um 20:05 schrieb Eric Farman:
> > On Thu, 2021-11-11 at 19:29 +0100, David Hildenbrand wrote:
> > > On 11.11.21 18:48, Eric Farman wrote:
> > > > On Thu, 2021-11-11 at 17:13 +0100, Janosch Frank wrote:
> > > > > 
> > > > > Looking at the API I'd like to avoid having two IOCTLs
> > > > 
> > > > Since the order is a single byte, we could have the payload of
> > > > an
> > > > ioctl
> > > > say "0-255 is an order that we're busy processing, anything
> > > > higher
> > > > than
> > > > that resets the busy" or something. That would remove the need
> > > > for
> > > > a
> > > > second IOCTL.
> > > 
> > > Maybe just pass an int and treat a negative (or just -1) value as
> > > clearing the order.
> > > 
> > 
> > Right, that's exactly what I had at one point. I thought it was too
> > cumbersome, but maybe not. Will dust it off, pending my question to
> > Janosch about 0-vs-1 IOCTLs.
> 
> As a totally different idea. Would a sync_reg value called SIGP_BUSY
> work as well?
> 

Hrm... I'm not sure. I played with it a bit, and it's not looking
great. I'm almost certainly missing some serialization, because I was
frequently "losing" one of the toggles (busy/not-busy) when hammering
CPUs with various SIGP orders on this interface and thus getting
incorrect responses from the in-kernel orders.

I also took a stab at David's idea of tying it to KVM_MP_STATE [1]. I
still think it's a little odd, considering the existing states are all
z/Arch-defined CPU states, but it does sound like the sort of thing
we're trying to do (letting userspace announce what the CPU is up to).
One flaw is that most of the rest of QEMU uses s390_cpu_set_state() for
this, which returns the number of running CPUs instead of the return
code from the MP_STATE ioctl (via kvm_s390_set_cpu_state()) that SIGP
would be interested in. Even if I made the ioctl call directly, I still
encounter some system problems that smell like ones I've addressed in
v2 and v3. Possibly fixable, but I didn't pursue them far enough to be
certain.

I ALSO took a stab at folding this into the S390 IRQ paths [2], similar
to what was done with kvm_s390_stop_info. This worked reasonably well,
except the QEMU interface kvm_s390_vcpu_interrupt() returns a void, and
so wouldn't notice an error sent back by KVM. Not a deal breaker, but
having not heard anything to this idea, I didn't go much farther.

Next week is a short week due to the US holiday, so rather than flesh
out any of the above possibilities, I'm going to send a new RFC as v4.
This will be back to a single IOCTL, with a small payload, per Janosch'
feedback. We can have a discussion on that, but if any of the above
alternatives sound more appealing I can try getting one of them working
with more consistency.

[1] 
https://lore.kernel.org/r/ff344676-0c37-610b-eafb-b1477db0f6a1@redhat.com/
[2] 
https://lore.kernel.org/all/b206e7b73696907328bc4338664dea1ef572e8aa.camel@linux.ibm.com/

