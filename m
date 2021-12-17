Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28CB547920C
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 17:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239448AbhLQQ4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 11:56:45 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46822 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239432AbhLQQ4o (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Dec 2021 11:56:44 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BHEv9cX012350;
        Fri, 17 Dec 2021 16:56:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : from : subject : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0XD/vtL483isNss4obzyKTuT7wofEadAVeqdqgwgClU=;
 b=fnCB3ThxZY7oCpw0DsrEZrcmKRk5be0c/GHK9RMmE14RfRxpNy6hp26UsSONEilTv5rN
 N67MCY2GFva02XVUPnqAPvaeu0YlsEMBbQG6jeNTKxKOT8W7LArwW+JlTvRMN2vqF5aG
 CqSOXYsrvKX9PEn0ORIuaUDzrXSyM2BUxzF5Keg5jENnt6aMWTSvEAXbMsDEbbdX7Pat
 xStu8hGzRSG7kZErGELewRyX5zhzyvlLjF83yndpifjCSCmFdlH/q89uNgpSA87YQlu9
 /7sSkhu8c0g3VIqIIiDhS8+oTX1jxtosdEoloQ9wqbQ/i9FLpLy/srQ5KnX1Kdb6cin9 ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d0vrrjrd8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 16:56:44 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1BHGcGhN008942;
        Fri, 17 Dec 2021 16:56:43 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3d0vrrjrch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 16:56:43 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1BHGf229023172;
        Fri, 17 Dec 2021 16:56:41 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3cy7k3t9yb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Dec 2021 16:56:41 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1BHGmXF641943536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Dec 2021 16:48:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E06B011C05B;
        Fri, 17 Dec 2021 16:56:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1329511C04C;
        Fri, 17 Dec 2021 16:56:37 +0000 (GMT)
Received: from [9.171.54.231] (unknown [9.171.54.231])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Dec 2021 16:56:37 +0000 (GMT)
Message-ID: <8fdf9da0-8213-f116-5e2f-5767e1d9b80e@linux.ibm.com>
Date:   Fri, 17 Dec 2021 17:56:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH 15/32] KVM: s390: pci: enable host forwarding of Adapter
 Event Notifications
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-16-mjrosato@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20211207205743.150299-16-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RiUAl5Cem-7B0AlG8CEeFnNIlg6k2AiG
X-Proofpoint-ORIG-GUID: jg8bmnVjpv1N5SLf0tOgRgQ4GFIYEUC0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-17_06,2021-12-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 phishscore=0 adultscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 impostorscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112170095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 07.12.21 um 21:57 schrieb Matthew Rosato:
> In cases where interrupts are not forwarded to the guest via firmware,
> KVM is responsible for ensuring delivery.  When an interrupt presents
> with the forwarding bit, we must process the forwarding tables until
> all interrupts are delivered.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
[...]

> +static void aen_host_forward(struct zpci_aift *aift, unsigned long si)
> +{
> +	struct kvm_s390_gisa_interrupt *gi;
> +	struct zpci_gaite *gaite;
> +	struct kvm *kvm;
> +
> +	gaite = (struct zpci_gaite *)aift->gait +
> +		(si * sizeof(struct zpci_gaite));
> +	if (gaite->count == 0)
> +		return;
> +	if (gaite->aisb != 0)
> +		set_bit_inv(gaite->aisbo, (unsigned long *)gaite->aisb);
> +
> +	kvm = kvm_s390_pci_si_to_kvm(aift, si);
> +	if (kvm == 0)
> +		return;
> +	gi = &kvm->arch.gisa_int;
> +
> +	if (!(gi->origin->g1.simm & AIS_MODE_MASK(gaite->gisc)) ||
> +	    !(gi->origin->g1.nimm & AIS_MODE_MASK(gaite->gisc))) {
> +		gisa_set_ipm_gisc(gi->origin, gaite->gisc);
> +		if (hrtimer_active(&gi->timer))
> +			hrtimer_cancel(&gi->timer);
> +		hrtimer_start(&gi->timer, 0, HRTIMER_MODE_REL);
> +		kvm->stat.aen_forward++;
> +	}
> +}
> +
> +static void aen_process_gait(u8 isc)
> +{
> +	bool found = false, first = true;
> +	union zpci_sic_iib iib = {{0}};
> +	unsigned long si, flags;
> +	struct zpci_aift *aift;
> +
> +	aift = kvm_s390_pci_get_aift();
> +	spin_lock_irqsave(&aift->gait_lock, flags);
> +
> +	if (!aift->gait) {
> +		spin_unlock_irqrestore(&aift->gait_lock, flags);
> +		return;
> +	}
> +
> +	for (si = 0;;) {
> +		/* Scan adapter summary indicator bit vector */
> +		si = airq_iv_scan(aift->sbv, si, airq_iv_end(aift->sbv));
> +		if (si == -1UL) {
> +			if (first || found) {
> +				/* Reenable interrupts. */
> +				if (zpci_set_irq_ctrl(SIC_IRQ_MODE_SINGLE, isc,
> +						      &iib))
> +					break;
> +				first = found = false;
> +			} else {
> +				/* Interrupts on and all bits processed */
> +				break;
> +			}
> +			found = false;
> +			si = 0;
> +			continue;
> +		}
> +		found = true;
> +		aen_host_forward(aift, si);
> +	}
> +
> +	spin_unlock_irqrestore(&aift->gait_lock, flags);
> +}
> +
>   static void gib_alert_irq_handler(struct airq_struct *airq,
>   				  struct tpi_info *tpi_info)
>   {
> +	struct tpi_adapter_info *info = (struct tpi_adapter_info *)tpi_info;
> +
>   	inc_irq_stat(IRQIO_GAL);
> -	process_gib_alert_list();
> +
> +	if (info->forward || info->error)
> +		aen_process_gait(info->isc);
> +	else
> +		process_gib_alert_list();
>   }

Not sure, would it make sense to actually do both after an alert interrupt or do we always get a separate interrupt for event vs. irq?
[..]
