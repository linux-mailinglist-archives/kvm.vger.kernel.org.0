Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBEE493BAB
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 15:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355017AbiASOFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 09:05:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21910 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1350177AbiASOFF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 09:05:05 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20JDXUji014693;
        Wed, 19 Jan 2022 14:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=o9CQMpaJnZqvK3R8V42BAt85drqoIwZy3maZORN92Dc=;
 b=Uf7agktaYCT8UgRb1P8e2weSANk7YjRHk+lXTr6ffdVkzUXT1l7tC5BO1xDkf36MEh8/
 WDMZ+8In1b/tn267G6k4rBnjspoYQRUedDA/2uc9cFHf15BUJ9zWSqB9dHHWQMecXADH
 zmz0VyvlmNZdxaEYF0b3jGMpq4vc9UOPE1EpkGXFD6JgcwS2PGufddec04+VzgZlCPUQ
 Qkus7WPEpjc/neCMfskYAZO2v1oR9gt4MelFMZms3muKG8Anxxge16wCAXooTcdm3mYN
 n39VVDLPZwrnOPSSE10tplU/qo7Sdq4Q+M03LTCue97W8hISKgXZMM1v6MrTJVNWUUGn NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dpkmsgtpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 14:05:03 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20JDbZ02028035;
        Wed, 19 Jan 2022 14:05:03 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dpkmsgtny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 14:05:03 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20JDw0pQ029012;
        Wed, 19 Jan 2022 14:05:01 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3dknw9xj9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jan 2022 14:05:01 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20JE4wjE15466834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 14:04:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D5121A406D;
        Wed, 19 Jan 2022 14:04:57 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC4AEA406B;
        Wed, 19 Jan 2022 14:04:56 +0000 (GMT)
Received: from [9.171.7.240] (unknown [9.171.7.240])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 19 Jan 2022 14:04:56 +0000 (GMT)
Message-ID: <2aa80655-f02f-1af9-c9b9-84f9633a7ed0@linux.ibm.com>
Date:   Wed, 19 Jan 2022 15:06:40 +0100
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
X-Proofpoint-GUID: _mqBAvUVIgunIckkTajWwAp5-KD0XdTf
X-Proofpoint-ORIG-GUID: bydUnRCsR4Pbe1XJuSKJJvqeJDTgbsEi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-19_08,2022-01-19_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 clxscore=1015 spamscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201190082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/14/22 21:31, Matthew Rosato wrote:
> For faster handling of PCI translation refreshes, intercept in KVM
> and call the associated handler.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>


Aside our previous discussion, 2 small codingstyle to fix
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

Here, spaces around "+"

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

Here no blank after cast.

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
