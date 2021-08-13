Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6504B3EB2ED
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 10:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239436AbhHMIvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 04:51:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20540 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239792AbhHMIvU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 04:51:20 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D8WkC9047819;
        Fri, 13 Aug 2021 04:50:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=+Urm3Is/4Ou/5N7yUqneNQe+0HamVQ+ri2PWI9Frd5I=;
 b=nu4TJHb2lNPaBV/vs56hl+TMeHCRaZ94NGkycSZRLW9Nxn2FmobOgsc2BjpdLMoO8dQu
 OO/jZwjq+4P/HA5yydDAI0JJNtGnge4sUsIxER/Y3/QmSULn+qiyKfdXS+7q3kPInISj
 WS2OqMQtsuRscimk3QyE+8JM6LRQYHoJsYM1CtQP0LeFILyIKrVI7ZmjlUy+IeEeVTBe
 w/yRGIj95aLQebH+lJvOoWC2yBFCofZWIepctWwp0UU7nj2P/JlhCNXiZzFp8iquzdkS
 mIcdiixDCyv9KT+oDf7h2hlEigkYvjiv/eq6lzVXaZrlUtZ703JjXVx8xUtoyDDTplHp fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3achs80qj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 04:50:53 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D8aKrZ060187;
        Fri, 13 Aug 2021 04:50:53 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3achs80qhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 04:50:53 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D8m6wf025490;
        Fri, 13 Aug 2021 08:50:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3acn76bat3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 08:50:50 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D8omGX51446024
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 08:50:48 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50E7252063;
        Fri, 13 Aug 2021 08:50:48 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.9.6])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id F3FAF52071;
        Fri, 13 Aug 2021 08:50:47 +0000 (GMT)
Date:   Fri, 13 Aug 2021 10:45:44 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 5/8] s390x: uv-host: Explain why we set
 up the home space and remove the space change
Message-ID: <20210813104544.17cbbb94@p-imbrenda>
In-Reply-To: <20210813073615.32837-6-frankja@linux.ibm.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
        <20210813073615.32837-6-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n6p6POiE2r9eJneuqIa4aNRmuAS6k2zy
X-Proofpoint-ORIG-GUID: HZ_vFIZsFDNMSRlbv880G5RnDCon9SQm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_01:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 mlxscore=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Aug 2021 07:36:12 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> UV home addresses don't require us to be in home space but we need to
> have it set up so hw/fw can use the home asce to translate home
> virtual addresses.
> 
> Hence we add a comment why we're setting up the home asce and remove
> the address space since it's unneeded.

oh, we actually never use it?

> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/uv-host.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 426a67f6..28035707 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -444,13 +444,18 @@ static void test_clear(void)
>  
>  static void setup_vmem(void)
>  {
> -	uint64_t asce, mask;
> +	uint64_t asce;
>  
>  	setup_mmu(get_max_ram_size(), NULL);
> +	/*
> +	 * setup_mmu() will enable DAT and set the primary address
> +	 * space but we need to have a valid home space since UV
> calls
> +	 * take home space virtual addresses.
> +	 *
> +	 * Hence we just copy the primary asce into the home space.
> +	 */
>  	asce = stctg(1);
>  	lctlg(13, asce);
> -	mask = extract_psw_mask() | 0x0000C00000000000UL;
> -	load_psw_mask(mask);
>  }
>  
>  int main(void)

