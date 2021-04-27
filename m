Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7C336C6E0
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 15:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235489AbhD0NTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 09:19:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236185AbhD0NTL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Apr 2021 09:19:11 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13RD3ILN060209
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 09:18:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mIse0MZaj/ojLK5nNY3e1n47N8nhmAliMlJBWv+8f6A=;
 b=JoJDcJkrIgRJxXFNTa9n+swww20G4iWyQUwTtcm8w8x219iY7Zr6OfKhbYRT6ZiA7Wxq
 X6P0YlNI52bsWPzOGTz8ZJFVFWvODvMXRFdpTnMFEWm7aBFHwV6vbBCMs42RnBIWObKl
 mh4z33BzM2kFjeyBXlgi8MWPgbZhbUmSuH4qbmst0YLWk6lwAkTgQAQVyK2Zg3rNkcYu
 l/KcOx7SVqAnQMxqAHWVoRyXa5kRNLSglhat2julKqX/zbS/uf5BNlMaq7vCLjr3rgk+
 rprKfH1kaVfGstazvVngZQzekk9zvCrMixyoSz1DmDhCZOR1/1B8jsPQ5fgePscevvQ8 dw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 386gvx55tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 09:18:26 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13RD3SVo061295
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 09:18:26 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 386gvx55t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 09:18:26 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13RDIOGg021768;
        Tue, 27 Apr 2021 13:18:24 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 384ay8hc4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 13:18:24 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13RDILo744433760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 13:18:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30A485204E;
        Tue, 27 Apr 2021 13:18:21 +0000 (GMT)
Received: from linux.fritz.box (unknown [9.145.60.47])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id C37D552052;
        Tue, 27 Apr 2021 13:18:20 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     thuth@redhat.com, cohuck@redhat.com, david@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20210427121608.157783-1-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/1] MAINTAINERS: s390x: add myself as
 reviewer
Message-ID: <79941660-77f8-e243-80b4-be5754f5bafb@linux.ibm.com>
Date:   Tue, 27 Apr 2021 15:18:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210427121608.157783-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jxredzkwhjgLPe0G1JhMrpL9ERpGb-ll
X-Proofpoint-GUID: C6FyBY5EyIt8DChCPJcg9WbItn-hUyIC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-27_06:2021-04-27,2021-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxscore=0 clxscore=1015 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/21 2:16 PM, Claudio Imbrenda wrote:
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e2505985..aaa404cf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -85,6 +85,7 @@ M: Thomas Huth <thuth@redhat.com>
>  M: David Hildenbrand <david@redhat.com>
>  M: Janosch Frank <frankja@linux.ibm.com>
>  R: Cornelia Huck <cohuck@redhat.com>
> +R: Claudio Imbrenda <imbrenda@linux.ibm.com>

Currently we are very limited by review, so I appreciate more
reviewers/reviews very much.

>  L: kvm@vger.kernel.org
>  L: linux-s390@vger.kernel.org
>  F: s390x/*
> 

Acked-by: Janosch Frank <frankja@linux.ibm.com>

@Paolo: Do you want to pick this or should I put it in my next pull request?
