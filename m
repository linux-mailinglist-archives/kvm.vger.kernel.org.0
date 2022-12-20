Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB15F652584
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbiLTRY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLTRYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:24:25 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB931869E;
        Tue, 20 Dec 2022 09:24:25 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKHBXOX026866;
        Tue, 20 Dec 2022 17:24:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=aiH0PO5eCp70Y1allX9v3AQ7ZXTE1QRbTnrXA7+6sOI=;
 b=BQ9N3AEUmcYnt9CLdANwCb0QtZe849M1l7uGJi06yRs6e6YNXlmvYvtGr6Pi/ekm0sN8
 dWyJSVTFCtuJhTDD7QYzqAdJpAv9jM9QLE0NUPJ3y1skGqiaLAk8Ml1lo82Gy3UCGMym
 kEXN5poy9GWwWJCeF9cT0NVNZ+tjduOW8lvwFoPTDHbBAdm69VKQ1wsUiG1kUJHq4mtb
 pHPZMGF2lM6axWZulj8PFB162UWZ4pepnczujq66r1YjFhfCTG3Px/zP3Z1UFKu6O8Em
 UFFI1amQ/bGcAksydceC8FLS/7hMbEPBIEfFEdk5JY9rN/doKQrKt5EcHQvibCKOfceS +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkh7w8cg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:24:23 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BKHCtg3001391;
        Tue, 20 Dec 2022 17:24:23 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkh7w8cf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:24:23 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK6LH1M019071;
        Tue, 20 Dec 2022 17:24:20 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3mh6yw4bep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:24:20 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHOHnZ29295052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:24:17 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F69820043;
        Tue, 20 Dec 2022 17:24:17 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EB5E20040;
        Tue, 20 Dec 2022 17:24:12 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.163.32.224])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
        Tue, 20 Dec 2022 17:24:12 +0000 (GMT)
Date:   Tue, 20 Dec 2022 18:24:07 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Anthony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 7/7] s390/vfio_ap: always clean up IRQ resources
Message-ID: <20221220182407.5959a4b6.pasic@linux.ibm.com>
In-Reply-To: <7b6d7e91-ba00-6486-39ae-91fca30b2cfb@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
        <20221213154437.15480-8-akrowiak@linux.ibm.com>
        <20221219151007.639dff5f.pasic@linux.ibm.com>
        <7b6d7e91-ba00-6486-39ae-91fca30b2cfb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LCojPCoC4Vc8zDT39bI9snV0u-Day-8t
X-Proofpoint-ORIG-GUID: gaMcQtHj1rBFy2jwTyFrYpjd2Wtwo9m4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 spamscore=0 clxscore=1015
 mlxlogscore=999 adultscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2212200141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 20 Dec 2022 09:33:03 -0500
Anthony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 12/19/22 9:10 AM, Halil Pasic wrote:
> > On Tue, 13 Dec 2022 10:44:37 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> Clean up IRQ resources even when a PQAP(ZAPQ) function fails with an error
> >> not handled by a case statement.  
> > Why?  
> 
> 
> If the ZAPQ failed, then instructions submitted to the same queue will 
> likewise fail. Are you saying it's not safe to assume, therefore, that 
> interrupts will not be occurring?

Right. We are talking about the default branch here, and I suppose, the
codes where we know that it is safe to assume that no reset is needed
handled separately (AP_RESPONSE_DECONFIGURED).

I'm not convinced that if we take the default branch we can safely
assume, that we won't see any interrupts.

For example consider hot-unplug as done by KVM. We modify the
CRYCB/APCB with all vCPUS take out of SIE, but we don't keep
the vCPUs out of SIE until the resets of the unpugged queues
are done, and we don't do any extra interrupt disablement
with all vCPUs keept out of SIE. So I believe currently there
may be a window where the guest can observe a 01 but the
interrupts are still live. That may be a bug, but IMHO it ain't clear
cut.

But it is not just about interrupts. Before we returned an error
code, which gets propagated to the userspace if this reset was
triggered via the ioctl.

With this change, ret seems to be uninitialized when returned 
if we take the code path which you change here. So we would
end up logging a warning and returning garbage?

One could also debate, whether RCs introduced down the road
can affect the logic here (even if the statement "if we
see an RC other that 00 and 02, we don't need to pursue a
reset any further, and interrpts are disabled" were to be
guaranteed to be true now, new RCs could theoretically mess
this up).

 
> 
> 
> >
> > I'm afraid this is a step in the wrong direction...  
> 
> 
> Please explain why.
> 

Sorry, I kept this brief because IMHO it is your job to tell us why
this needs to be changed. But I gave in, as you see.

Regards,
Halil
