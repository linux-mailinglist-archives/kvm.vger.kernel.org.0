Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E7A2D911D
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 00:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgLMXOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 18:14:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725874AbgLMXOA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 13 Dec 2020 18:14:00 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BDN2Oee181123;
        Sun, 13 Dec 2020 18:13:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=9NT1XXYa5wl70p6HiLU6THBshqdAzNi8Zkj2uMWS2zk=;
 b=ke1LRtflBMoE0uW00iX/TKszmRaXuAK+7JG2qlV8Poy71vKPqjpZqn13LQTvFNINFBXG
 SSm/MHkwnUcsBdMN5NbxkvLqodDlHyZtN7zGssmo6MYV89QJJFraod0zWWy2dTigBvYi
 v0UKLpBmefbDq4X242R2kfh1eVA/XafadhIQHO7bTO9l///D1OWTElE6Z2fzInFuxAg5
 lZs8dV2Eq7hlVSZ2NAbNsEBmjoMv18ftPnxfNEJhfCNCHn4oUChpqp0oMEoaoMUoffb1
 Uzr3Rn16aOHYhOHUKdgtBdQ+Nwk+VwFn/TJASxTQRotXuvP+9XZAAubhNGaVZo1ei65y yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35du45he5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Dec 2020 18:13:18 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BDNAoBu010826;
        Sun, 13 Dec 2020 18:13:17 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35du45he5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Dec 2020 18:13:17 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BDNDFaD009621;
        Sun, 13 Dec 2020 23:13:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 35cng88ste-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Dec 2020 23:13:15 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BDNDCU728639512
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 23:13:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 759305204E;
        Sun, 13 Dec 2020 23:13:12 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.55.88])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with SMTP id EC61D52051;
        Sun, 13 Dec 2020 23:13:11 +0000 (GMT)
Date:   Mon, 14 Dec 2020 00:13:10 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com, david@redhat.com
Subject: Re: [PATCH] s390/vfio-ap: Clean up vfio_ap resources when KVM
 pointer invalidated
Message-ID: <20201214001310.2cb6f1ff.pasic@linux.ibm.com>
In-Reply-To: <ff21dd8e-9ac7-8625-5c77-4705e1344477@linux.ibm.com>
References: <20201202234101.32169-1-akrowiak@linux.ibm.com>
        <ab3f1948-bb23-c0d0-7205-f46cd6dbe99d@linux.ibm.com>
        <20201208014018.3f89527f.pasic@linux.ibm.com>
        <ff21dd8e-9ac7-8625-5c77-4705e1344477@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-13_06:2020-12-11,2020-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 adultscore=0 mlxlogscore=907
 priorityscore=1501 malwarescore=0 spamscore=0 mlxscore=0 impostorscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012130177
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Dec 2020 16:08:53 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> >>> +static void vfio_ap_mdev_put_kvm(struct ap_matrix_mdev *matrix_mdev)
> >>> +{
> >>> +	if (matrix_mdev->kvm) {
> >>> +		kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
> >>> +		matrix_mdev->kvm->arch.crypto.pqap_hook = NULL;
> >>> +		vfio_ap_mdev_reset_queues(matrix_mdev->mdev);  
> >> This reset probably does not belong here since there is no
> >> reason to reset the queues in the group notifier (see below).  
> > What about kvm_s390_gisc_unregister()? That needs a valid kvm
> > pointer, or? Or is it OK to not pair a kvm_s390_gisc_register()
> > with an kvm_s390_gisc_unregister()?  
> 
> I probably should have been more specific about what I meant.
> I was thinking that the reset should not be dependent upon
> whether there is a KVM pointer or not since this function is
> also called from the release callback. On the other hand,
> the vfio_ap_mdev_reset_queues function calls the
> vfio_ap_irq_disable (AQIC) function after each queue is reset.
> The vfio_ap_irq_disable function also cleans up the AQIC
> resources which requires that the KVM point is valid, so if
> the vfio_ap_reset_queues function is not called with a
> valid KVM pointer, that could result in an exception.
> 
> The thing is, it is unnecessary to disable interrupts after
> resetting a queue because the reset disables interrupts,
> so I think I should include a patch for this fix that does the
> following:
> 
> 1. Removes the disabling of interrupts subsequent to resetting
>      a queue.
> 2. Includes the cleanup of AQIC resources when a queue is
>      reset if a KVM pointer is present.

Sounds like a plan. I see, in your v2 vfio_ap_mdev_unset_kvm()
does call vfio_ap_mdev_reset_queues() even when called from the
group notifier. I also like that the cleanup of AQIC resources is
a part of queue_reset. In fact I asked a while ago (Message-ID:
<20201027074846.30ee0ddc.pasic@linux.ibm.com> in October) to make
vfio_ap_mdev_reset_queue() call vfio_ap_free_aqic_resources(q).

Regards,
Halil 

