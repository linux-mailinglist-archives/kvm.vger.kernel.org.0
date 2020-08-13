Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9151924396B
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 13:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHMLh7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 07:37:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61482 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726100AbgHMLh6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 07:37:58 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07DBWOJA023758;
        Thu, 13 Aug 2020 07:37:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=pd6SAGeoE53YwR14OlYzUFs6bwrO5/qxPbt5UZS/3Zc=;
 b=maBpY8F5tyCgnk/WtKuv8ckhXVyv5+h+Pssf/TNZSDBqIqbA0ICL8buXS+BruluQM6dh
 vG91pTPIh/4du/2KPcdlm0moKuXqL3QipanwG7Uqi2Z3hVkENpcB3BUZIeEVmFw+iLGH
 6gNHmnkZefD2v4l2Jko358X26kWq8gcsabHIoXzWcxKwAdK6vnQYts2VduKTd4RNZlM2
 Rr0Y1sWWpeyKHwID+VH0gvapsIlWJS3L/pX0a4bTNZt05ny3BjppFdM4MSayBF01pD21
 zq6Hnp7skW1GnOkg5NNTsMnNtIm0zYq7MTyCx34o0HWji/3N9RQ2FDnjL+dTv9OCaWY8 fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w4b58u05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 07:37:57 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07DBWOoM023863;
        Thu, 13 Aug 2020 07:37:57 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32w4b58tyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 07:37:57 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07DBUsf8006581;
        Thu, 13 Aug 2020 11:37:55 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 32skp8dfy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 11:37:54 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07DBbqIr22282734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 11:37:52 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B81F911C054;
        Thu, 13 Aug 2020 11:37:52 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7B99511C04C;
        Thu, 13 Aug 2020 11:37:52 +0000 (GMT)
Received: from marcibm (unknown [9.145.178.142])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 13 Aug 2020 11:37:52 +0000 (GMT)
From:   Marc Hartmayer <mhartmay@linux.ibm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests RFC v2 1/4] common.bash: run `cmd` only if a test case was found
In-Reply-To: <20200813074059.y4qvrne5thm2olf2@kamzik.brq.redhat.com>
References: <20200812092705.17774-1-mhartmay@linux.ibm.com> <20200812092705.17774-2-mhartmay@linux.ibm.com> <20200813074059.y4qvrne5thm2olf2@kamzik.brq.redhat.com>
Date:   Thu, 13 Aug 2020 13:37:50 +0200
Message-ID: <87o8nehj3l.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_10:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 adultscore=0 suspectscore=2 phishscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 13, 2020 at 09:40 AM +0200, Andrew Jones <drjones@redhat.com> w=
rote:
> On Wed, Aug 12, 2020 at 11:27:02AM +0200, Marc Hartmayer wrote:
>> It's only useful to run `cmd` in `for_each_unittest` if a test case
>> was found. This change allows us to remove the guards from the
>> functions `run_task` and `mkstandalone`.
>>=20
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>>  run_tests.sh            | 3 ---
>>  scripts/common.bash     | 8 ++++++--
>>  scripts/mkstandalone.sh | 4 ----
>>  3 files changed, 6 insertions(+), 9 deletions(-)
>>
>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
>

Thanks.

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen=20
Gesch=C3=A4ftsf=C3=BChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
