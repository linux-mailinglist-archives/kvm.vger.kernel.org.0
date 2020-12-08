Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60012D1EBE
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgLHACR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:02:17 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:54824 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726207AbgLHACQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 19:02:16 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B7NWYHC086651;
        Mon, 7 Dec 2020 19:01:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=C7ZENVW1dr4uhcX3MvbQ3d8uls/tihQUr88RU0IrEus=;
 b=q81G/1vzAZ8DL5fchF19kT+aZy3wHw13dGYLSna4AaLOILAGa2FgEGFFpw/NeBrvOyeb
 NZPjE+2uba899ND+qOtlq20TaBtFMnf60vR8NBxQQgyR2gAHQZSJp3qzEsONZn2jnN0b
 Qu+JusCaFneQLF3J03eyDNY8oqFoyfSZh3bN8TA/rU+P+9t/vVcTU11RUqWJNs4Bf00o
 T4q46KZiaWI16kWpY/Y8Hy1E+MHhOCWuK5oeBpUrKmq0jPuRNwvkkUeLYsQy+yZ65Pc7
 TNWvYxmUlkWfhczpYil0sV1+bYWMmSjU074ZiMphxu07vQIeQXAGk3rpmnt07hT4o+2V 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359wwjryq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 19:01:33 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B7NsJCP155829;
        Mon, 7 Dec 2020 19:01:33 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359wwjrypg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 19:01:33 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B7NqphK018707;
        Tue, 8 Dec 2020 00:01:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3581u83030-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 00:01:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B801Sdw52429124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Dec 2020 00:01:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2FD564C058;
        Tue,  8 Dec 2020 00:01:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9036D4C050;
        Tue,  8 Dec 2020 00:01:27 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.6.119])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue,  8 Dec 2020 00:01:27 +0000 (GMT)
Date:   Tue, 8 Dec 2020 01:01:25 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <20201208010125.209883f5.pasic@linux.ibm.com>
In-Reply-To: <683dd341-f047-0447-1ee8-c126c305b6c2@linux.ibm.com>
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
        <20201203185514.54060568.pasic@linux.ibm.com>
        <a8a90aed-97df-6f10-85c2-8e18dba8f085@linux.ibm.com>
        <20201204200502.1c34ae58.pasic@linux.ibm.com>
        <683dd341-f047-0447-1ee8-c126c305b6c2@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-07_16:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070152
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Dec 2020 13:50:36 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 12/4/20 2:05 PM, Halil Pasic wrote:
> > On Fri, 4 Dec 2020 09:43:59 -0500
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >>>> +{
> >>>> +	if (matrix_mdev->kvm) {
> >>>> +		(matrix_mdev->kvm);
> >>>> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;  
> >>> Is a plain assignment to arch.crypto.pqap_hook apropriate, or do we need
> >>> to take more care?
> >>>
> >>> For instance kvm_arch_crypto_set_masks() takes kvm->lock before poking
> >>> kvm->arch.crypto.crycb.  
> >> I do not think so. The CRYCB is used by KVM to provide crypto resources
> >> to the guest so it makes sense to protect it from changes to it while
> >> passing
> >> the AP devices through to the guest. The hook is used only when an AQIC
> >> executed on the guest is intercepted by KVM. If the notifier
> >> is being invoked to notify vfio_ap that KVM has been set to NULL, this means
> >> the guest is gone in which case there will be no AP instructions to
> >> intercept.  
> > If the update to pqap_hook isn't observed as atomic we still have a
> > problem. With torn writes or reads we would try to use a corrupt function
> > pointer. While the compiler probably ain't likely to generate silly code
> > for the above assignment (multiple write instructions less then
> > quadword wide), I know of nothing that would prohibit the compiler to do
> > so.  
> 
> I'm sorry, but I still don't understand why you tkvm_vfio_group_set_kvmhink this is a problem
> given what I stated above.

I assume you are specifically referring to 'the guest is gone in which
case there will be no AP instructions to intercept'.  I assume by 'guest
is gone' you mean that the VM is being destroyed, and the vcpus are out
of SIE. You are probably right for the invocation of
kvm_vfio_group_set_kvm() in kvm_vfio_destroy(), but is that true for
the invocation in the KVM_DEV_VFIO_GROUP_DEL case in
kvm_vfio_set_group()? I.e. can't we get the notifier called when the
qemu device is hot unplugged (modulo remove which unregisters the
notifier and usually precludes the notifier being with NULL called at
all)?

Regards,
Halil
