Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAA626A260
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 11:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgIOJiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 05:38:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58040 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726102AbgIOJiP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 05:38:15 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08F9V8DN078082
        for <kvm@vger.kernel.org>; Tue, 15 Sep 2020 05:38:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=gB69IllkKxGIkisaICkNb7Vyio5d6xAjFt+SsmQWeNE=;
 b=Ft2RoYs/kiLGIq+g0rKE8eZwwxJsmKqCtkfsFBhCjNEt99GFMEiV3M9vAUBoua1pdZ4j
 0UeEq8VefgpWMjkBT9MCHwdL1hmGBD9hylnfHe5VfoAmf4i8v/SOn1GPXYl2qxXncALT
 QJ+uk/wflfT4binWPZbHWHkgEXwE4p3svTb6RUHX851bLzf2vWh/0gbJu1qyFoiaMnQS
 PMXXk/rUwkRoPpOLY3CVxHCV2uhxTDg+X9sy6ehzPv/DZQYzyqn4FIlVwD5TN2PRy8CK
 xkJaTgRlD05f29UNBazPBMZ59tbUlaiB4QF50vTKsDnB1+8UyCrap++Ua7X8DCcbZPos mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33jttagjdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 15 Sep 2020 05:38:13 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08F9V33H077474
        for <kvm@vger.kernel.org>; Tue, 15 Sep 2020 05:38:13 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33jttagjd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 05:38:13 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08F9YUF0013503;
        Tue, 15 Sep 2020 09:38:11 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 33gny81rrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 09:38:11 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08F9c8VR13566268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 09:38:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50C28AE053;
        Tue, 15 Sep 2020 09:38:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E1463AE058;
        Tue, 15 Sep 2020 09:38:07 +0000 (GMT)
Received: from marcibm (unknown [9.145.87.76])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 15 Sep 2020 09:38:07 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v2 0/2] Use same test names in the
 default and the TAP13 output format
In-Reply-To: <20200825102036.17232-1-mhartmay@linux.ibm.com>
References: <20200825102036.17232-1-mhartmay@linux.ibm.com>
Date:   Tue, 15 Sep 2020 11:38:07 +0200
Message-ID: <87bli7tm68.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_05:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 spamscore=0 priorityscore=1501 mlxscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 25, 2020 at 12:20 PM +0200, Marc Hartmayer <mhartmay@linux.ibm.=
com> wrote:
> For everybody's convenience there is a branch:
> https://gitlab.com/mhartmay/kvm-unit-tests/-/tree/tap_v2
>
> Changelog:
> v1 -> v2:
>  + added r-b's to patch 1
>  + patch 2:
>   - I've not added Andrew's r-b since I've worked in the comment from
>     Janosch (don't drop the first prefix)
>
> Marc Hartmayer (2):
>   runtime.bash: remove outdated comment
>   Use same test names in the default and the TAP13 output format
>
>  run_tests.sh         | 15 +++++++++------
>  scripts/runtime.bash |  9 +++------
>  2 files changed, 12 insertions(+), 12 deletions(-)
>
> --=20
> 2.25.4
>

Polite ping :) How should we proceed further?

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
