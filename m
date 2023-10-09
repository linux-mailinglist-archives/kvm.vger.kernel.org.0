Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 950417BE049
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 15:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377317AbjJINia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 09:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377287AbjJINiX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 09:38:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1CEDE;
        Mon,  9 Oct 2023 06:38:17 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 399DZtdG004749;
        Mon, 9 Oct 2023 13:38:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=yRW3b8iNxgabpFMvNzovKBsuGJaKa5vXiWQvBQwnn7M=;
 b=m1ZMcdjz/y0D8PL2z3MUJkZJsvkBGEWlaPOFK/1J2fJCIerUUq8+9SP8eAmreE5Bcv3y
 x29LiDW1gVh6zPFT5AbOI4OOWxcaAWE6wwMPj3vHpPTP65VGh3TosaTyizJsI1GITCMt
 9CSg26rBRSKcwvU4VhGP0q19JtSIgKbSZkoqzIFkdcAowDF4UzBpscPUjzF8bKsYYJst
 bzofp5Q2FWjGdOjwo+Oh6DVx+0IiPi1wR9Py3Zv5/7vTvevTqMyySKa0J8iVc+06vcP+
 Ejjk1s6jfmwE7jecXKp1SgZe6oEwti0NHwNEAOklYWm1G0xJ2hPaqRQJr8tGTW3KZn6Z 5A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tmjbhgd71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Oct 2023 13:38:17 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 399Damel010451;
        Mon, 9 Oct 2023 13:38:16 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tmjbhgd2c-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Oct 2023 13:38:16 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 399BQB8D028633;
        Mon, 9 Oct 2023 13:21:57 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tkj1xsajj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 Oct 2023 13:21:57 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 399DLsCl11076228
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Oct 2023 13:21:54 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45C8F2004B;
        Mon,  9 Oct 2023 13:21:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F31A20043;
        Mon,  9 Oct 2023 13:21:54 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  9 Oct 2023 13:21:54 +0000 (GMT)
Date:   Mon, 9 Oct 2023 15:20:24 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v4 2/2] KVM: s390: add tracepoint in gmap notifier
Message-ID: <20231009152024.3bbf3b14@p-imbrenda>
In-Reply-To: <20231009093304.2555344-3-nrb@linux.ibm.com>
References: <20231009093304.2555344-1-nrb@linux.ibm.com>
        <20231009093304.2555344-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Qp1ubwx_6YczAzqIzQBZzDNdOLmbmWdt
X-Proofpoint-GUID: ZMnjeyYi5MIMMuiDmRh721vZbozvdgat
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-09_11,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0
 mlxscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310090112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  9 Oct 2023 11:32:53 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> The gmap notifier is called for changes in table entries with the
> notifier bit set. To diagnose performance issues, it can be useful to
> see what causes certain changes in the gmap.
> 
> Hence, add a tracepoint in the gmap notifier.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Acked-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/kvm-s390.c   |  2 ++
>  arch/s390/kvm/trace-s390.h | 23 +++++++++++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index b42493110d76..11676b81e6bf 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4060,6 +4060,8 @@ static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
>  	unsigned long prefix;
>  	unsigned long i;
>  
> +	trace_kvm_s390_gmap_notifier(start, end, gmap_is_shadow(gmap));
> +
>  	if (gmap_is_shadow(gmap))
>  		return;
>  	if (start >= 1UL << 31)
> diff --git a/arch/s390/kvm/trace-s390.h b/arch/s390/kvm/trace-s390.h
> index 6f0209d45164..9ac92dbf680d 100644
> --- a/arch/s390/kvm/trace-s390.h
> +++ b/arch/s390/kvm/trace-s390.h
> @@ -333,6 +333,29 @@ TRACE_EVENT(kvm_s390_airq_suppressed,
>  		      __entry->id, __entry->isc)
>  	);
>  
> +/*
> + * Trace point for gmap notifier calls.
> + */
> +TRACE_EVENT(kvm_s390_gmap_notifier,
> +	    TP_PROTO(unsigned long start, unsigned long end, unsigned int shadow),
> +	    TP_ARGS(start, end, shadow),
> +
> +	    TP_STRUCT__entry(
> +		    __field(unsigned long, start)
> +		    __field(unsigned long, end)
> +		    __field(unsigned int, shadow)
> +		    ),
> +
> +	    TP_fast_assign(
> +		    __entry->start = start;
> +		    __entry->end = end;
> +		    __entry->shadow = shadow;
> +		    ),
> +
> +	    TP_printk("gmap notified (start:0x%lx end:0x%lx shadow:%d)",
> +		      __entry->start, __entry->end, __entry->shadow)
> +	);
> +
>  
>  #endif /* _TRACE_KVMS390_H */
>  

