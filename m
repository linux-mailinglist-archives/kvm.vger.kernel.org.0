Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A2D3F06C3
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 16:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238995AbhHROdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 10:33:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44514 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238896AbhHROdG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 10:33:06 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17IE3Od0152425;
        Wed, 18 Aug 2021 10:31:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=hINMW+W/5Ot3YR26bfaimyZQXNFx6687q4snjOgYREg=;
 b=NupYUEPg4k+woLQOQ6I9th5QpKHGlbN6WzpbJ2E59ZJrJAzu4vv3xD7XKgT5JIXDGNm1
 Z2kBvwVpN/FuANZ824Qqvs8XgqgdYkxEekWxhG+tNMEhRqUmlnGsWClyNiRPfFTTfz1z
 mPBZxKm+OgIq10wN2cXDd97X3zktPlul0PElmyOEtlFS7xocoD4V4eum3yfO9K3HFM7h
 HF3EfK2i90w/u97kIOrotKfIzqRuUKD4L7IjUkcD8YpVPnoEIoTl4jCnkeVBWQW08oE6
 c28GpOWkwEDhWAZV8tcOfIO0IW6nc8cOL7HZhtKeiPk4nu3G/7/2HEAdBPeWatTFgKXb tQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcvs7h6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 10:31:51 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17IE3QpR152705;
        Wed, 18 Aug 2021 10:31:50 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcvs7h42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 10:31:50 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IEEK9h013108;
        Wed, 18 Aug 2021 14:31:47 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3ae5f8era4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 14:31:47 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IEViFj49676594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 14:31:44 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E35C911C04A;
        Wed, 18 Aug 2021 14:31:43 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C845F11C05B;
        Wed, 18 Aug 2021 14:31:42 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.14.177])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 14:31:42 +0000 (GMT)
Date:   Wed, 18 Aug 2021 16:29:53 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 06/13] KVM: Move WARN on invalid memslot index to
 update_memslots()
Message-ID: <20210818162953.225d6977@p-imbrenda>
In-Reply-To: <8db0f1d1901768b5de1417caa425e62d1118e5e8.1628871413.git.maciej.szmigiero@oracle.com>
References: <cover.1628871411.git.maciej.szmigiero@oracle.com>
        <8db0f1d1901768b5de1417caa425e62d1118e5e8.1628871413.git.maciej.szmigiero@oracle.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U3AdZ2vbFuvAj4jcJM1-s4IDztzLUZTv
X-Proofpoint-GUID: 6hKUBKCcraXfYRKOa55yL0hGF64P5AsR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_04:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Aug 2021 21:33:19 +0200
"Maciej S. Szmigiero" <mail@maciej.szmigiero.name> wrote:

> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Since kvm_memslot_move_forward() can theoretically return a negative
> memslot index even when kvm_memslot_move_backward() returned a positive one
> (and so did not WARN) let's just move the warning to the common code.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  virt/kvm/kvm_main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 03ef42d2e421..7000efff1425 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1293,8 +1293,7 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
>  	struct kvm_memory_slot *mslots = slots->memslots;
>  	int i;
>  
> -	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
> -	    WARN_ON_ONCE(!slots->used_slots))
> +	if (slots->id_to_index[memslot->id] == -1 || !slots->used_slots)
>  		return -1;
>  
>  	/*
> @@ -1398,6 +1397,9 @@ static void update_memslots(struct kvm_memslots *slots,
>  			i = kvm_memslot_move_backward(slots, memslot);
>  		i = kvm_memslot_move_forward(slots, memslot, i);
>  
> +		if (WARN_ON_ONCE(i < 0))
> +			return;
> +
>  		/*
>  		 * Copy the memslot to its new position in memslots and update
>  		 * its index accordingly.

