Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B63481853
	for <lists+kvm@lfdr.de>; Thu, 30 Dec 2021 03:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbhL3CEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Dec 2021 21:04:30 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230043AbhL3CE3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Dec 2021 21:04:29 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BU1dvH4011546;
        Thu, 30 Dec 2021 02:04:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=lHE1RB2R9/RlgxwtpoTDHyyYbEarMLCUwPUBx1uJ5Xg=;
 b=RQC9fciUnBZl0N2sESxaKRTOZSpaz52ZVjAxgKxJFiSWvMMxOb4HbadTSaW0xB/ZpnuW
 CP3MSAYnzCupQgENPczMjiXqS8AuXqD2IPfjj9wgtfAWZ7k2+ZFlDLo1/xNlpC1f666s
 dn6P04iEK5WuqsERUY+LuzHJSx8m+7cw9WlILpaOLPEbp8AvbFJ1k1+B571sL65jP9NX
 R/VYjmspel9iNgIGm6R85bkmFxfHy+qWzH08zd+YmPPBLbljoHhzVsS8C+bFeA92cLAl
 eGy9Ksm0b8vBgjrvWrn1nPWji8kzwidT3CCo5VHUSTUjQAAAfYk0ja0Qwjb9LVlI8k+Z Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d82th90px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Dec 2021 02:04:28 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BU24Rpt018868;
        Thu, 30 Dec 2021 02:04:27 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d82th90pb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Dec 2021 02:04:27 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BU23HEb023340;
        Thu, 30 Dec 2021 02:04:25 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3d5tx9rmtq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Dec 2021 02:04:25 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BU24L7D45875464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Dec 2021 02:04:21 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C71724C04E;
        Thu, 30 Dec 2021 02:04:21 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 226E44C040;
        Thu, 30 Dec 2021 02:04:21 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.80.242])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 30 Dec 2021 02:04:21 +0000 (GMT)
Date:   Thu, 30 Dec 2021 03:04:19 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v17 08/15] s390/vfio-ap: keep track of active guests
Message-ID: <20211230030419.2f3e5bda.pasic@linux.ibm.com>
In-Reply-To: <20211021152332.70455-9-akrowiak@linux.ibm.com>
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
        <20211021152332.70455-9-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pgTrHNRkLvxIdTZ4r9c0h6lRd0oYQyw6
X-Proofpoint-ORIG-GUID: X4uAX6bHd6Z9a4fSrK5naWFAH0D6jWcY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-29_07,2021-12-29_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112300007
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Oct 2021 11:23:25 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The reason a lockdep splat can occur has to do with the fact that the
> kvm->lock has to be taken before the vcpu->lock; so, for example, when a
> secure execution guest is started, you may end up with the following
> scenario:
> 
>         Interception of PQAP(AQIC) instruction executed on the guest:
>         ------------------------------------------------------------
>         handle_pqap:                    matrix_dev->lock                
>         kvm_vcpu_ioctl:                 vcpu_mutex                      
> 
>         Start of secure execution guest:
>         -------------------------------
>         kvm_s390_cpus_to_pv:            vcpu->mutex                     
>         kvm_arch_vm_ioctl:              kvm->lock                    
> 
>         Queue is unbound from vfio_ap device driver:
>         -------------------------------------------
>                                         kvm->lock
>         vfio_ap_mdev_remove_queue:      matrix_dev->lock

The way you describe your scenario is a little ambiguous. It
seems you choose a stack-trace like description, in a sense that for
example for PQAP: first vcpu->mutex is taken and then matrix_dev->lock
but you write the latter first and the former second. I think it is more
usual to describe such stuff a a sequence of event in a sense that
if A precedes B in the text (from the top towards the bottom), then
execution of a A precedes the execution of B in time.

Also you are inconsistent with vcpu_mutex vs vcpu->mutex.

I can't say I understand the need for this yet. I have been starring
at the end result for a while. Let me see if I can come up with an
alternate proposal for some things.

Regards,
Halil


