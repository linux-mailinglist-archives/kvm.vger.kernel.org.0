Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5620046D70C
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 16:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbhLHPhF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 10:37:05 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8632 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233264AbhLHPhD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 10:37:03 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8FH3vD028982;
        Wed, 8 Dec 2021 15:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=V2VRIpvkWBSP0VtVBM+6GjbvhHXu5sGQr8AsovCkyag=;
 b=bF2GheikoaJE2Dt1lfQt0Gqk6rXEV2uSJbMrrclcPOJ6OK+lz2uo5xVBbQYRVOBLjoQE
 ThKWjaA7n21c7Hgp/qyPmWUwI4n+F8uEcB2voqFGCZE4/IG+Uyw5Mi5UQt0Q/SOAOGCS
 Vx3kTl2dgaYH+AgK3XYRdBBgIQ8giD8oquC3b+Ztss73Z1Lslg1/fYwBQEj4wjRsUdnx
 VqWAOGY4KC0TtB7vF0+52EgBK+4YRosafDNROdKXYDtJrxUQr8hc5Qkxgb7P//WmBBc/
 FI45A2b/boU/OJYwg03g03ok2yhkIvI6gzdp2WwaaKt6u2qlgAUdi+HQDKpsWpMA/x8L tA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cty7b0c5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 15:33:31 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8FImil003159;
        Wed, 8 Dec 2021 15:33:30 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cty7b0c54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 15:33:30 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8FC5Cl022506;
        Wed, 8 Dec 2021 15:33:30 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 3cqyybey1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 15:33:29 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8FXRqr26870050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 15:33:27 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44B1EB2074;
        Wed,  8 Dec 2021 15:33:27 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63D42B2066;
        Wed,  8 Dec 2021 15:33:22 +0000 (GMT)
Received: from [9.211.152.43] (unknown [9.211.152.43])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 15:33:22 +0000 (GMT)
Message-ID: <eea46eb2-c14e-3bc1-d8e4-b6b28c677fe2@linux.ibm.com>
Date:   Wed, 8 Dec 2021 10:33:21 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 07/32] s390/pci: externalize the SIC operation controls
 and routine
Content-Language: en-US
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-8-mjrosato@linux.ibm.com>
 <bc3b60f7-833d-6d50-dcd0-b102a190c69d@linux.ibm.com>
 <614215b5aa14102c7b43913b234463199401a156.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <614215b5aa14102c7b43913b234463199401a156.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CYlP2S5gBapAhXyb7K4DolSQznReAFq7
X-Proofpoint-GUID: zpzF22JlwlZbhJt3vgTZvhGETEtbOuvZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_06,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 mlxlogscore=999 spamscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 phishscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 8:53 AM, Niklas Schnelle wrote:
> On Wed, 2021-12-08 at 14:09 +0100, Christian Borntraeger wrote:
>> Am 07.12.21 um 21:57 schrieb Matthew Rosato:
>>> A subsequent patch will be issuing SIC from KVM -- export the necessary
>>> routine and make the operation control definitions available from a header.
>>> Because the routine will now be exported, let's swap the purpose of
>>> zpci_set_irq_ctrl and __zpci_set_irq_ctrl, leaving the latter as a static
>>> within pci_irq.c only for SIC calls that don't specify an iib.
>>
>> Maybe it would be simpler to export the __ version instead of renaming everything.
>> Whatever Niklas prefers.
> 
> See below I think it's just not worth it having both variants at all.
> 
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>    arch/s390/include/asm/pci_insn.h | 17 +++++++++--------
>>>    arch/s390/pci/pci_insn.c         |  3 ++-
>>>    arch/s390/pci/pci_irq.c          | 28 ++++++++++++++--------------
>>>    3 files changed, 25 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
>>> index 61cf9531f68f..5331082fa516 100644
>>> --- a/arch/s390/include/asm/pci_insn.h
>>> +++ b/arch/s390/include/asm/pci_insn.h
>>> @@ -98,6 +98,14 @@ struct zpci_fib {
>>>    	u32 gd;
>>>    } __packed __aligned(8);
>>>    
>>> +/* Set Interruption Controls Operation Controls  */
>>> +#define	SIC_IRQ_MODE_ALL		0
>>> +#define	SIC_IRQ_MODE_SINGLE		1
>>> +#define	SIC_IRQ_MODE_DIRECT		4
>>> +#define	SIC_IRQ_MODE_D_ALL		16
>>> +#define	SIC_IRQ_MODE_D_SINGLE		17
>>> +#define	SIC_IRQ_MODE_SET_CPU		18
>>> +
>>>    /* directed interruption information block */
>>>    struct zpci_diib {
>>>    	u32 : 1;
>>> @@ -134,13 +142,6 @@ int __zpci_store(u64 data, u64 req, u64 offset);
>>>    int zpci_store(const volatile void __iomem *addr, u64 data, unsigned long len);
>>>    int __zpci_store_block(const u64 *data, u64 req, u64 offset);
>>>    void zpci_barrier(void);
>>> -int __zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib);
>>> -
>>> -static inline int zpci_set_irq_ctrl(u16 ctl, u8 isc)
>>> -{
>>> -	union zpci_sic_iib iib = {{0}};
>>> -
>>> -	return __zpci_set_irq_ctrl(ctl, isc, &iib);
>>> -}
>>> +int zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib);
> 
> Since the __zpci_set_irq_ctrl() was already non static/inline the above
> inline to non-inline change shouldn't make a performance difference.
> 
> Looking at this makes me wonder though. Wouldn't it make sense to just
> have the zpci_set_irq_ctrl() function inline in the header. Its body is
> a single instruction inline asm plus a test_facility(). The latter by
> the way I think also looks rather out of place there considering we
> call zpci_set_irq_ctrl() in the interrupt handler and facilities can't
> go away so it's pretty silly to check for it on every single
> interrupt.. unless I'm totally missing something.

This test_facility isn't new to this patch, it was added via

commit 48070c73058be6de9c0d754d441ed7092dfc8f12
Author: Christian Borntraeger <borntraeger@de.ibm.com>
Date:   Mon Oct 30 14:38:58 2017 +0100

     s390/pci: do not require AIS facility

It looks like in the past, we would not even initialize zpci at all if 
AIS wasn't available.  With this, we initialize PCI but only do the SIC 
when we have AIS, which makes sense.

So for this patch, the sane thing to do is probably just keep the 
test_facility() in place and move to header, inline.

Maybe there's a subsequent optimization to be made (setup a static key 
like have_mio vs doing test_facility all the time?)

> 
>>>    
>>>    #endif
>>> diff --git a/arch/s390/pci/pci_insn.c b/arch/s390/pci/pci_insn.c
>>> index 28d863aaafea..d1a8bd43ce26 100644
>>> --- a/arch/s390/pci/pci_insn.c
>>> +++ b/arch/s390/pci/pci_insn.c
>>> @@ -97,7 +97,7 @@ int zpci_refresh_trans(u64 fn, u64 addr, u64 range)
>>>    }
>>>    
>>>    /* Set Interruption Controls */
>>> -int __zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
>>> +int zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
>>>    {
>>>    	if (!test_facility(72))
>>>    		return -EIO;
>>> @@ -108,6 +108,7 @@ int __zpci_set_irq_ctrl(u16 ctl, u8 isc, union zpci_sic_iib *iib)
>>>    
>>>    	return 0;
>>>    }
>>> +EXPORT_SYMBOL_GPL(zpci_set_irq_ctrl);
>>>    
>>>    /* PCI Load */
>>>    static inline int ____pcilg(u64 *data, u64 req, u64 offset, u8 *status)
>>> diff --git a/arch/s390/pci/pci_irq.c b/arch/s390/pci/pci_irq.c
>>> index dfd4f3276a6d..6b29e39496d1 100644
>>> --- a/arch/s390/pci/pci_irq.c
>>> +++ b/arch/s390/pci/pci_irq.c
>>> @@ -15,13 +15,6 @@
>>>    
>>>    static enum {FLOATING, DIRECTED} irq_delivery;
>>>    
>>> -#define	SIC_IRQ_MODE_ALL		0
>>> -#define	SIC_IRQ_MODE_SINGLE		1
>>> -#define	SIC_IRQ_MODE_DIRECT		4
>>> -#define	SIC_IRQ_MODE_D_ALL		16
>>> -#define	SIC_IRQ_MODE_D_SINGLE		17
>>> -#define	SIC_IRQ_MODE_SET_CPU		18
>>> -
>>>    /*
>>>     * summary bit vector
>>>     * FLOATING - summary bit per function
>>> @@ -145,6 +138,13 @@ static int zpci_set_irq_affinity(struct irq_data *data, const struct cpumask *de
>>>    	return IRQ_SET_MASK_OK;
>>>    }
>>>    
>>> +static inline int __zpci_set_irq_ctrl(u16 ctl, u8 isc)
>>> +{
>>> +	union zpci_sic_iib iib = {{0}};
>>> +
>>> +	return zpci_set_irq_ctrl(ctl, isc, &iib);
>>> +}
>>> +
> 
> I would be totally fine and slighlt prefer to have the 0 iib repeated
> at those 3 call sites that don't need it. On first glance that should
> come out to pretty much the same number of lines of code and it removes
> the potential confusion of swapping the __ prefixed and non-prefixed
> variants. What do you think?

Sure, I can do that.

> 
>>>    static struct irq_chip zpci_irq_chip = {
>>>    	.name = "PCI-MSI",
>>>    	.irq_unmask = pci_msi_unmask_irq,
>>> @@ -165,7 +165,7 @@ static void zpci_handle_cpu_local_irq(bool rescan)
>>>
> ---8<---
> 

