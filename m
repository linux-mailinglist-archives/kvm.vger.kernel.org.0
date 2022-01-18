Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B78492439
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 12:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238419AbiARLEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 06:04:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231758AbiARLEN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 06:04:13 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20IARPUf013977;
        Tue, 18 Jan 2022 11:04:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OjDVnGmEocH6YDQ2+l1VP/U/gCFVo2WBnHZ1QWnFcG8=;
 b=mEVb31kZw7FglXbHkznxWtpeNLwmt2STryfrwA7TBYFeMMm16KSRkJFOxo79A+XxLcXc
 X5/yoEspJq3nv5K9PzBkxda0wbAEbC88IJVwRZESgehQagXyxZCq5S4RfU1XBUOLGv4b
 GfsYPuyR1+iBiIkHRC44emqn9aTiQY12dBRr16dkaqeC2JFI34cX80rMV6GaRc/24lKI
 dr4py44E1FOBtBEvM/fAL2MLQ9TtTdU9Pzbs63s0JX5Lf3Te/i+rKS/nOStlBZvXtlif
 pOq5DkXFcAVf2WDRyZrHmRTBOURbDtGQBx4uVzy5kNhmA2tUpYYDPv8yxGDqj5gNTVnd JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnutjrnwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 11:04:13 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20IASq1A021522;
        Tue, 18 Jan 2022 11:04:12 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnutjrnvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 11:04:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20IB4298021895;
        Tue, 18 Jan 2022 11:04:10 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3dknw9k7r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 11:04:10 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20IB43fe18547076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 11:04:03 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAA65AE053;
        Tue, 18 Jan 2022 11:04:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D14DCAE04D;
        Tue, 18 Jan 2022 11:04:02 +0000 (GMT)
Received: from [9.171.70.230] (unknown [9.171.70.230])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 11:04:02 +0000 (GMT)
Message-ID: <6eb0b596-c8b7-3529-55af-f3101821c74b@linux.ibm.com>
Date:   Tue, 18 Jan 2022 12:05:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 22/30] KVM: s390: intercept the rpcit instruction
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-23-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220114203145.242984-23-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xJAv0UuB43DesG_btEXQitJ4Mlyb0gxl
X-Proofpoint-ORIG-GUID: jk4H-WF8MInGKElj71OKEfNlelt_9gIH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> For faster handling of PCI translation refreshes, intercept in KVM
> and call the associated handler.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   arch/s390/kvm/priv.c | 46 ++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 46 insertions(+)
> 
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 417154b314a6..5b65c1830de2 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -29,6 +29,7 @@
>   #include <asm/ap.h>
>   #include "gaccess.h"
>   #include "kvm-s390.h"
> +#include "pci.h"
>   #include "trace.h"
>   
>   static int handle_ri(struct kvm_vcpu *vcpu)
> @@ -335,6 +336,49 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
>   	return 0;
>   }
>   
> +static int handle_rpcit(struct kvm_vcpu *vcpu)
> +{
> +	int reg1, reg2;
> +	u8 status;
> +	int rc;
> +
> +	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
> +		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
> +
> +	/* If the host doesn't support PCI, it must be an emulated device */
> +	if (!IS_ENABLED(CONFIG_PCI))
> +		return -EOPNOTSUPP;

AFAIU this makes also sure that the following code is not compiled in 
case PCI is not supported.

I am not very used to compilation options, is it true with all our 
compilers and options?
Or do we have to specify a compiler version?

Another concern is, shouldn't we use IS_ENABLED(CONFIG_VFIO_PCI) ?



> +
> +	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
> +
> +	/* If the device has a SHM bit on, let userspace take care of this */
> +	if (((vcpu->run->s.regs.gprs[reg1] >> 32) & aift->mdd) != 0)
> +		return -EOPNOTSUPP;
> +
> +	rc = kvm_s390_pci_refresh_trans(vcpu, vcpu->run->s.regs.gprs[reg1],
> +					vcpu->run->s.regs.gprs[reg2],
> +					vcpu->run->s.regs.gprs[reg2+1],
> +					&status);
> +
> +	switch (rc) {
> +	case 0:
> +		kvm_s390_set_psw_cc(vcpu, 0);
> +		break;
> +	case -EOPNOTSUPP:
> +		return -EOPNOTSUPP;
> +	default:
> +		vcpu->run->s.regs.gprs[reg1] &= 0xffffffff00ffffffUL;
> +		vcpu->run->s.regs.gprs[reg1] |= (u64) status << 24;
> +		if (status != 0)
> +			kvm_s390_set_psw_cc(vcpu, 1);
> +		else
> +			kvm_s390_set_psw_cc(vcpu, 3);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
>   #define SSKE_NQ 0x8
>   #define SSKE_MR 0x4
>   #define SSKE_MC 0x2
> @@ -1275,6 +1319,8 @@ int kvm_s390_handle_b9(struct kvm_vcpu *vcpu)
>   		return handle_essa(vcpu);
>   	case 0xaf:
>   		return handle_pfmf(vcpu);
> +	case 0xd3:
> +		return handle_rpcit(vcpu);
>   	default:
>   		return -EOPNOTSUPP;
>   	}
> 

-- 
Pierre Morel
IBM Lab Boeblingen
