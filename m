Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43AC3EB2E4
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 10:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239737AbhHMIvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 04:51:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42182 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239436AbhHMIvJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 04:51:09 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D8XEOW167332;
        Fri, 13 Aug 2021 04:50:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=JpFcudson4eYOZEAC47jTRXdDonszFVlR6giId63ims=;
 b=Oq3a2b1jPFV0zA4l6pHjQ/UwhbhKAUSCMMLpI3w/Q2CG2QuQK5vDIJop0KD0UXYnHx6s
 t7IYUebGbvYU8pBZvbUOsEX8qkvXzYkZKNsLXyrQE2AhPmkTovWTnLr8I+/LnvuZG/Sc
 GQc05u5ExjzkohBVktdpaaNbT5sYPfKESwAkL2bZHQ71YH9ioL9hNfvZOBfcALVKV8gI
 NUZ6fjcOadP4zmu4dU1UCZs7TXp60P89E9BtzETw9Ny0BOS3sbaL6a8uFW92AwZU4FtJ
 k1J6Lv+44For0yfe+Scwj4KuMuBMerg+y6iyXdB+2yKx/aeernVtfM9E0kJ9M3BP16kX 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3addp5ujmj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 04:50:42 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D8Y0iU169835;
        Fri, 13 Aug 2021 04:50:42 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3addp5ujm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 04:50:42 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D8lcGX021271;
        Fri, 13 Aug 2021 08:50:40 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3a9ht8t99s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 08:50:40 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D8lJfo55902464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 08:47:20 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F09152051;
        Fri, 13 Aug 2021 08:50:38 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.9.6])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DA0FC5206B;
        Fri, 13 Aug 2021 08:50:37 +0000 (GMT)
Date:   Fri, 13 Aug 2021 10:32:40 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 1/8] s390x: lib: Extend bitops
Message-ID: <20210813103240.33710ea6@p-imbrenda>
In-Reply-To: <20210813073615.32837-2-frankja@linux.ibm.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
        <20210813073615.32837-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LxEYX4PvykBAPZ75n-OtDL5wFdr51zhK
X-Proofpoint-GUID: jeS_KxMRYh1S7WigUE5lFb69kEwz8VzO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_03:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108130050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Aug 2021 07:36:08 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Bit setting and clearing is never bad to have.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/bitops.h | 102
> +++++++++++++++++++++++++++++++++++++++++ 1 file changed, 102
> insertions(+)
> 
> diff --git a/lib/s390x/asm/bitops.h b/lib/s390x/asm/bitops.h
> index 792881ec..f5612855 100644
> --- a/lib/s390x/asm/bitops.h
> +++ b/lib/s390x/asm/bitops.h
> @@ -17,6 +17,78 @@
>  
>  #define BITS_PER_LONG	64
>  
> +static inline unsigned long *bitops_word(unsigned long nr,
> +					 const volatile unsigned
> long *ptr) +{
> +	unsigned long addr;
> +
> +	addr = (unsigned long)ptr + ((nr ^ (nr & (BITS_PER_LONG -
> 1))) >> 3);
> +	return (unsigned long *)addr;

why not just 

return ptr + (nr / BITS_PER_LONG);

> +}
> +
> +static inline unsigned long bitops_mask(unsigned long nr)
> +{
> +	return 1UL << (nr & (BITS_PER_LONG - 1));
> +}
> +
> +static inline uint64_t laog(volatile unsigned long *ptr, uint64_t
> mask) +{
> +	uint64_t old;
> +
> +	/* load and or 64bit concurrent and interlocked */
> +	asm volatile(
> +		"	laog	%[old],%[mask],%[ptr]\n"
> +		: [old] "=d" (old), [ptr] "+Q" (*ptr)
> +		: [mask] "d" (mask)
> +		: "memory", "cc" );
> +	return old;
> +}

do we really need the artillery (asm) here?
is there a reason why we can't do this in C?

> +static inline uint64_t lang(volatile unsigned long *ptr, uint64_t
> mask) +{
> +	uint64_t old;
> +
> +	/* load and and 64bit concurrent and interlocked */
> +	asm volatile(
> +		"	lang	%[old],%[mask],%[ptr]\n"
> +		: [old] "=d" (old), [ptr] "+Q" (*ptr)
> +		: [mask] "d" (mask)
> +		: "memory", "cc" );
> +	return old;
> +}

(same here as above)

> +
> +static inline void set_bit(unsigned long nr,
> +			   const volatile unsigned long *ptr)
> +{
> +	uint64_t mask = bitops_mask(nr);
> +	uint64_t *addr = bitops_word(nr, ptr);
> +
> +	laog(addr, mask);
> +}
> +
> +static inline void set_bit_inv(unsigned long nr,
> +			       const volatile unsigned long *ptr)
> +{
> +	return set_bit(nr ^ (BITS_PER_LONG - 1), ptr);
> +}
> +
> +static inline void clear_bit(unsigned long nr,
> +			     const volatile unsigned long *ptr)
> +{
> +	uint64_t mask = bitops_mask(nr);
> +	uint64_t *addr = bitops_word(nr, ptr);
> +
> +	lang(addr, ~mask);
> +}
> +
> +static inline void clear_bit_inv(unsigned long nr,
> +				 const volatile unsigned long *ptr)
> +{
> +	return clear_bit(nr ^ (BITS_PER_LONG - 1), ptr);
> +}
> +
> +/* non-atomic bit manipulation functions */
> +
>  static inline bool test_bit(unsigned long nr,
>  			    const volatile unsigned long *ptr)
>  {
> @@ -33,4 +105,34 @@ static inline bool test_bit_inv(unsigned long nr,
>  	return test_bit(nr ^ (BITS_PER_LONG - 1), ptr);
>  }
>  
> +static inline void __set_bit(unsigned long nr,
> +			     const volatile unsigned long *ptr)
> +{
> +	uint64_t mask = bitops_mask(nr);
> +	uint64_t *addr = bitops_word(nr, ptr);
> +
> +	*addr |= mask;
> +}
> +
> +static inline void __set_bit_inv(unsigned long nr,
> +				 const volatile unsigned long *ptr)
> +{
> +	return __set_bit(nr ^ (BITS_PER_LONG - 1), ptr);
> +}
> +
> +static inline void __clear_bit(unsigned long nr,
> +			       const volatile unsigned long *ptr)
> +{
> +	uint64_t mask = bitops_mask(nr);
> +	uint64_t *addr = bitops_word(nr, ptr);
> +
> +	*addr &= ~mask;
> +}
> +
> +static inline void __clear_bit_inv(unsigned long nr,
> +				   const volatile unsigned long *ptr)
> +{
> +	return __clear_bit(nr ^ (BITS_PER_LONG - 1), ptr);
> +}
> +
>  #endif

