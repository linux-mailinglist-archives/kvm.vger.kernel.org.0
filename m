Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32B73D3E9E
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 19:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhGWQpV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 12:45:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9690 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231696AbhGWQpR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Jul 2021 12:45:17 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NH4954171595;
        Fri, 23 Jul 2021 13:25:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=RDwa7RLYZVX2NFHPuUDzfT/PvsTIs9K+t1zBdNQ7xQU=;
 b=NSAsWFr5bv2PFfiOaNxI8kjnz8qHS3QGN+5MTi2vIKrrNYg9YwmPW3KRlKu3P2jO0ZxF
 FcuIl+/fyotf81RU2ZVvhs/cptMa3Jm/Ppzm2k5vwAnbWI8M19A2E5p3IHpkMaXQyO1L
 Nl4UFHAiXmcsyET2LT82K5Qd0H+IVh/Yt0J1nIDC6EsDu7le+MRyJBbO+016AjD4ZrnH
 l7UqF3/oH/Ek1IGNqg/qbBuIjCFdk5TGT8WPV0zI8osW7Qi/VV2SYx1riWEjG5BsHIO5
 YxWpwXp/zg6cK0M096BX0Zhrm7uI18uFcxEnR+DreUyM2Eu//XzGay/EO7CjjzbAPsLE OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a00h3k9vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 13:25:50 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16NH4vpV175091;
        Fri, 23 Jul 2021 13:25:50 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a00h3k9uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 13:25:50 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16NHJJsW002726;
        Fri, 23 Jul 2021 17:25:47 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 39upu8b5sb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 17:25:47 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16NHPjNf35455440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 17:25:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20A9F52059;
        Fri, 23 Jul 2021 17:25:45 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.87])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id CA77852050;
        Fri, 23 Jul 2021 17:25:44 +0000 (GMT)
Date:   Fri, 23 Jul 2021 19:15:52 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 3/5] lib: s390x: uv: Int type cleanup
Message-ID: <20210723191552.66fd67c9@p-imbrenda>
In-Reply-To: <b06633be-3832-7a07-37c3-1beaecd2202a@redhat.com>
References: <20210629133322.19193-1-frankja@linux.ibm.com>
        <20210629133322.19193-4-frankja@linux.ibm.com>
        <d2798bf7-3018-e311-1dfb-120144fb343d@redhat.com>
        <3876955c-24bd-2052-e634-8436f7558df4@linux.ibm.com>
        <b06633be-3832-7a07-37c3-1beaecd2202a@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: l9ojKsFiZTO6BmBoD9jQhdzOdlSRYiki
X-Proofpoint-GUID: dIlncc5ZqeSejpWC_5tigwy958xEvCij
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_09:2021-07-23,2021-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 bulkscore=0 clxscore=1015 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107230102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Jul 2021 11:41:57 +0200
Thomas Huth <thuth@redhat.com> wrote:

[snip]

> 
> Completely inaccurate checks with the lib directory of the
> kvm-unit-tests:
> 
> $ grep -r u64 lib/ | wc -l
> 234
> $ grep -r uint64 lib/ | wc -l
> 245
> 
> $ grep -r u8 lib/ | wc -l
> 137
> $ grep -r uint8 lib/ | wc -l
> 193
> 
> ... I guess that's an indication that we do not really have a
> prevailing style here?
> I personally prefer the stdint.h types, I'm just not sure whether it
> makes sense to keep some headers close to the kernel or not...?
> 
>   Thomas
> 

I agree, the project as a whole needs to decide the policy regarding
stdint.h types. Do we want them always? only for stuff that doesn't
need synchronization with the kernel? or maybe we just don't care?

I don't care which way we go, but I think we need to decide on one way
to go.

