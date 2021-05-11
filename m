Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1DD37A9C2
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 16:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhEKOng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 10:43:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33904 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231681AbhEKOnd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 10:43:33 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BEZLXk181942;
        Tue, 11 May 2021 10:42:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=fJv9vggYsg3sydHxRnceIagbtZal6zDnl97tU05/eak=;
 b=H/QXNKN+U3iObFicEEy8dJ9kg7TF+7I/kJOHdHYX7ws/BncjoYic1zeTDLZUO/kBRz/P
 /o0GvWtptw+3tijKhwgJqcaQS2OZSeTTGxkw6X0BnM+tvdDxJwhdCIwSAm/4h1z7Afj4
 xQVXTYeSmJlv0L9gP3xoQFWzTNY/GpKG8LWL2iCOkP10ygs+ARHKHRE43AReqo4PraRz
 WcGa/2G1lkcX7SDLa3+bruYLPeKJZs1OqrRPkaEePGfFSNcxlrJTUrcC5vqhXIbApMhb
 sxkoMN6LAdu6U/vwy1c4oqlcEOiKS/o8hzX4+nzoo2cxogFv1izJHX8vVs8DhoNE+GEh Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ftarbqq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 10:42:26 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14BEZlsm184021;
        Tue, 11 May 2021 10:42:26 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ftarbqp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 10:42:26 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14BEdDUM024747;
        Tue, 11 May 2021 14:42:23 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 38dj988xd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 14:42:23 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14BEgLwZ30998950
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 14:42:21 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E360111C050;
        Tue, 11 May 2021 14:42:20 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A63D11C04A;
        Tue, 11 May 2021 14:42:20 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.13.244])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 May 2021 14:42:20 +0000 (GMT)
Date:   Tue, 11 May 2021 16:36:59 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 4/4] s390x: cpumodel: FMT2 SCLP implies
 test
Message-ID: <20210511163659.16329e3b@ibm-vm>
In-Reply-To: <20210510150015.11119-5-frankja@linux.ibm.com>
References: <20210510150015.11119-1-frankja@linux.ibm.com>
        <20210510150015.11119-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wlsIgwPlPvaCSvpaLFtW2jJIVsmVof3w
X-Proofpoint-ORIG-GUID: yYwQNuK4xM-fe9m0-dbE5iWkz5r4YoMh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_02:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 May 2021 15:00:15 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The sie facilities require sief2 to also be enabled, so lets check if
> that's the case.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

I agree with David, you can fold this in the previous patch

> ---
>  s390x/cpumodel.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
> index 619c3dc7..67bb6543 100644
> --- a/s390x/cpumodel.c
> +++ b/s390x/cpumodel.c
> @@ -56,12 +56,24 @@ static void test_sclp_features_fmt4(void)
>  	report_prefix_pop();
>  }
>  
> +static void test_sclp_features_fmt2(void)
> +{
> +	if (sclp_facilities.has_sief2)
> +		return;
> +
> +	report_prefix_push("!sief2 implies");
> +	test_sclp_missing_sief2_implications();
> +	report_prefix_pop();
> +}
> +
>  static void test_sclp_features(void)
>  {
>  	report_prefix_push("sclp");
>  
>  	if (uv_os_is_guest())
>  		test_sclp_features_fmt4();
> +	else
> +		test_sclp_features_fmt2();
>  
>  	report_prefix_pop();
>  }

