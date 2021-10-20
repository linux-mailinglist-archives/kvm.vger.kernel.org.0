Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B4543493B
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 12:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhJTKrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 06:47:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52834 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230029AbhJTKrM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Oct 2021 06:47:12 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19K7uu7C018987;
        Wed, 20 Oct 2021 06:44:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=n0IrrZKNjCDXk6a+AwzD8OCz2d7pc+LYHjYo6lmqRDY=;
 b=bYD9Gvf5F4qFuHKQPMblULptCO5Q5C7L8/PQdpnwnliy4eIWPmJs609aT4YCkpateG+1
 IH+AtLZUUUoyvAAJK52s8F/BW0PR7lfsjv/giKgCaQy51xqptZameiPpFlqE598jg6/0
 TW58EStVgQrIbOdxlYJcc0/noLVA+Fmd7PHEXEwDNPrm5IdqXuMvzV6En8Q8DcpKFrrS
 v4mKoXJ2bDztSPFFdlUn7qsSJXj/r/Tu8vVS8N7eFiOtXhR3d35G95JYmRGL8yjuxYSS
 0kol2cESBaexj4K7yIL39IerKJOlDU/5H5T7W/Nr3boVrkJ1OWx1U8vO/+0eTEEHeQjj Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btca9y0uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 06:44:58 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19KAhxom012174;
        Wed, 20 Oct 2021 06:44:57 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3btca9y0u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 06:44:57 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19KAhZgv026541;
        Wed, 20 Oct 2021 10:44:55 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3bqpc9s0dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Oct 2021 10:44:55 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19KAipk558524118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Oct 2021 10:44:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD637A407E;
        Wed, 20 Oct 2021 10:44:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5AD9A4071;
        Wed, 20 Oct 2021 10:44:50 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.4.68])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Oct 2021 10:44:50 +0000 (GMT)
Date:   Wed, 20 Oct 2021 12:44:03 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>, farman@linux.ibm.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: s390: clear kicked_mask before sleeping again
Message-ID: <20211020124403.624753ca@p-imbrenda>
In-Reply-To: <20211019175401.3757927-2-pasic@linux.ibm.com>
References: <20211019175401.3757927-1-pasic@linux.ibm.com>
        <20211019175401.3757927-2-pasic@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: km7k9fbmgnRrSUh1mUZlHTBOC4E3Krqk
X-Proofpoint-ORIG-GUID: r5ZYcTj7kceLbxwK6XkjapUkVxlgAxuU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-20_04,2021-10-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 adultscore=0 clxscore=1015 mlxlogscore=999 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110200060
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 19 Oct 2021 19:53:59 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> The idea behind kicked mask is that we should not re-kick a vcpu that
> is already in the "kick" process, i.e. that was kicked and is
> is about to be dispatched if certain conditions are met.
> 
> The problem with the current implementation is, that it assumes the
> kicked vcpu is going to enter SIE shortly. But under certain
> circumstances, the vcpu we just kicked will be deemed non-runnable and
> will remain in wait state. This can happen, if the interrupt(s) this
> vcpu got kicked to deal with got already cleared (because the interrupts
> got delivered to another vcpu). In this case kvm_arch_vcpu_runnable()
> would return false, and the vcpu would remain in kvm_vcpu_block(),
> but this time with its kicked_mask bit set. So next time around we
> wouldn't kick the vcpu form __airqs_kick_single_vcpu(), but would assume
> that we just kicked it.
> 
> Let us make sure the kicked_mask is cleared before we give up on
> re-dispatching the vcpu.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Fixes: 9f30f6216378 ("KVM: s390: add gib_alert_irq_handler()")

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 6a6dd5e1daf6..1c97493d21e1 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -3363,6 +3363,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
>  {
> +	clear_bit(vcpu->vcpu_idx, vcpu->kvm->arch.gisa_int.kicked_mask);
>  	return kvm_s390_vcpu_has_irq(vcpu, 0);
>  }
>  

