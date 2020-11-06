Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14E02A968E
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 13:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgKFM6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 07:58:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53924 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727383AbgKFM6i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 07:58:38 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6CXwu0006826
        for <kvm@vger.kernel.org>; Fri, 6 Nov 2020 07:58:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=QwUdF02VgFC3vwxTGPJuIgFxdK9zF8DsUrJRIO1uzQc=;
 b=H+Luxwuu+AJ/hDolMYf5CYLGs3K/LSKh1ra+uomj/V+kQCv7UNmRMTLv88+UEPMFilCE
 6kRx+KFtqSTqjmy/fF5cqOB4Wxr3UlrxLvuhOE/DY8VLpHvhaLdNqsRRSCusLgexg1su
 ugkDqpdMKj4A0jO5FK+SfbFv9lahRPeNWFoj2x49YCf1O8RMWXKclfDjlfNWBIOjCqU9
 uLsQ0qUcQx5McYKm99BiF1Y13y5znbxj4ZJGaBU743vRxyPbX71tKkg71U4s6D+Te6va
 RcPlQI5sb3rc9QR1iZm8XZluV/4pFsdJDldKj9wBGtXjPTLG/5Eo/JwVUdmrnJ0HFw7z aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ms00f8bc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 07:58:37 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0A6CtW0M102721
        for <kvm@vger.kernel.org>; Fri, 6 Nov 2020 07:58:37 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34ms00f8at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 07:58:37 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A6CqAgE026067;
        Fri, 6 Nov 2020 12:58:35 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 34h0f6ubdf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 06 Nov 2020 12:58:35 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A6CwW6g1770222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Nov 2020 12:58:33 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C473211C058;
        Fri,  6 Nov 2020 12:58:32 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 666CE11C04A;
        Fri,  6 Nov 2020 12:58:32 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.1.188])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  6 Nov 2020 12:58:32 +0000 (GMT)
Date:   Fri, 6 Nov 2020 13:58:30 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com, lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 3/7] lib/asm: Add definitions of
 memory areas
Message-ID: <20201106135830.53f027b5@ibm-vm>
In-Reply-To: <1429868e-2348-e7a3-0668-4fc2439052f2@redhat.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
        <20201002154420.292134-4-imbrenda@linux.ibm.com>
        <1429868e-2348-e7a3-0668-4fc2439052f2@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_04:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 6 Nov 2020 12:34:10 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 02/10/20 17:44, Claudio Imbrenda wrote:
> > x86 gets
> > * lowest area (24-bit addresses)
> > * low area (32-bit addresses)
> > * the rest  
> 
> x86 if anything could use a 36-bit area; the 24-bit one is out of
> scope for what kvm-unit-tests does.

sure... I went with what I remembered about the x86 architecture, but
I'm not an expert

my patch was meant to be some "sensible defaults" that people with
more knowledge should override anyway :)

> So something like this:
> 
> diff --git a/lib/x86/asm/memory_areas.h b/lib/x86/asm/memory_areas.h
> index d704df3..952f5bd 100644
> --- a/lib/x86/asm/memory_areas.h
> +++ b/lib/x86/asm/memory_areas.h
> @@ -1,20 +1,19 @@
>   #ifndef MEMORY_AREAS_H
>   #define MEMORY_AREAS_H
> 
> -#define AREA_NORMAL_PFN BIT(32-12)
> +#define AREA_NORMAL_PFN BIT(36-12)
>   #define AREA_NORMAL_NUMBER 0
>   #define AREA_NORMAL 1
> 
> -#define AREA_LOW_PFN BIT(24-12)
> -#define AREA_LOW_NUMBER 1
> -#define AREA_LOW 2
> +#define AREA_PAE_HIGH_PFN BIT(32-12)
> +#define AREA_PAE_HIGH_NUMBER 1
> +#define AREA_PAE_HIGH 2
> 
> -#define AREA_LOWEST_PFN 0
> -#define AREA_LOWEST_NUMBER 2
> -#define AREA_LOWEST 4
> +#define AREA_LOW_PFN 0
> +#define AREA_LOW_NUMBER 2
> +#define AREA_LOW 4
> 
> -#define AREA_DMA24 AREA_LOWEST
> -#define AREA_DMA32 (AREA_LOWEST | AREA_LOW)
> +#define AREA_PAE (AREA_PAE | AREA_LOW)
> 
>   #define AREA_ANY -1
>   #define AREA_ANY_NUMBER 0xff
> 
> Paolo
> 

