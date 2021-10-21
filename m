Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E897E436506
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhJUPH1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:07:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44970 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231644AbhJUPHZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:07:25 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LEqZS5020148;
        Thu, 21 Oct 2021 11:05:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=mNslIDvjZx+hYK0WtNNIotwDc9g/ceymFcAYyFOPu1A=;
 b=KHS/ZEvts96Pl5Jv8SMRQltcmyjyA/UwL+8ZvpocIN5YoqxV6115mM0vtEeKfzEhY0Jx
 DPSpMJ8s7jeAjhZrQY3L58BP6jOmAzK0Otyq9kxLEVPecXqjTA0ELHPKOuyleJ2deZlK
 g/RfBsvbzTjcQUNShKVQe+hUB//18eoqz+1dt8gjszZjNTioqCDHmXR4NXhrFe0lMPms
 filUBPobWz0mwsPgN6tmIRfbss6OpChpl8lCx0JRqo3Du7xPSt7wuh/EPf7Ymp/rT2F9
 S1gk6CulcmhHwnZoCGdxImpkjEqj2x/O0dR+DarPyHiEUQyyv0wA5bc9b6vd/mUsef+9 fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3buabv8b1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:05:08 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19LErKEO022920;
        Thu, 21 Oct 2021 11:05:07 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3buabv8b0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 11:05:07 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19LF4K4k017946;
        Thu, 21 Oct 2021 15:05:05 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3bqpcan4nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 15:05:05 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19LEx8WC57737542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:59:08 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A89042042;
        Thu, 21 Oct 2021 15:05:02 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C536542059;
        Thu, 21 Oct 2021 15:05:01 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.13.107])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Oct 2021 15:05:01 +0000 (GMT)
Date:   Thu, 21 Oct 2021 17:05:00 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, borntraeger@de.ibm.com, pbonzini@redhat.com,
        drjones@redhat.com
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: Add Claudio as s390x
 maintainer
Message-ID: <20211021170500.0538a857@p-imbrenda>
In-Reply-To: <20211021145912.79225-1-frankja@linux.ibm.com>
References: <20211021145912.79225-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WnBTv8LdrFI3rgmrHNIp3tnkg_B_hspk
X-Proofpoint-GUID: v-pAzu4WxknF_ccNPvNHQcE-ekN2dBaG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_04,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 mlxlogscore=999
 impostorscore=0 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110210079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 Oct 2021 14:59:12 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Claudio has added his own tests, reviewed the tests of others and
> added to the common as well as the s390x library with excellent
> results. So it's time to make him a s390x maintainer.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2d4a0872..bab08e74 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -86,8 +86,8 @@ F: lib/ppc64/
>  S390X
>  M: Thomas Huth <thuth@redhat.com>
>  M: Janosch Frank <frankja@linux.ibm.com>
> +M: Claudio Imbrenda <imbrenda@linux.ibm.com>
>  S: Supported
> -R: Claudio Imbrenda <imbrenda@linux.ibm.com>
>  R: David Hildenbrand <david@redhat.com>
>  L: kvm@vger.kernel.org
>  L: linux-s390@vger.kernel.org

