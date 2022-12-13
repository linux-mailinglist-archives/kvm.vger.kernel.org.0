Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEAF864B899
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 16:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235931AbiLMPgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 10:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236231AbiLMPgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 10:36:42 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0F9220D8
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 07:36:41 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDE9gQA011420;
        Tue, 13 Dec 2022 15:36:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=f91gEfcYD5YktjbaAZkyiznSMnXuxRR6hxj8Af9DuxI=;
 b=F8XJk0uzXX7J+t8NkeY/CB6aDb/QavEqlSK329D+ugV5u6ZWGkvVRW5nxeqSrlyKlkZQ
 iNgnos2m0t1gN53QU+uW//Vt4+kWLhBxbpOUy8xV0vw0jHrZsy8BwtoRldQBwh/BOtqc
 Jculc9ohNysJhuWGKv6MYDL7iyKzYFOls0YBl4kQrdpvsU+4RcJ6sLvW4iaOb7XfF4Uh
 OMzX7/oUMxz0ZAy92Gmk3Y7tYUxjTDNQDnkq+v/P41o3uaX0CtdMrZDKe1wMyi8T8WWh
 khU1narqNeyudGD3tzA9lddXnJI0bkDt2yZuTcusQzuIzJ7Sp7+DaD84/Q6gPS8/X2Gf 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mejre787y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:36:38 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDE9mqr011878;
        Tue, 13 Dec 2022 15:36:38 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mejre786n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:36:38 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BD4xh4B007765;
        Tue, 13 Dec 2022 15:36:36 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3mchcf4dfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:36:36 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDFaWaq50069850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:36:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 711C020049;
        Tue, 13 Dec 2022 15:36:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 346F620040;
        Tue, 13 Dec 2022 15:36:32 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 15:36:32 +0000 (GMT)
Date:   Tue, 13 Dec 2022 16:36:30 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, thuth@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/4] lib: add function to request
 migration
Message-ID: <20221213163630.1d9233b9@p-imbrenda>
In-Reply-To: <20221212111731.292942-1-nrb@linux.ibm.com>
References: <20221212111731.292942-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Hvs09yStpL9uo5XBXkyMyC-U11bzo-mu
X-Proofpoint-ORIG-GUID: r5OB7cFvtwmIxg3tVW5lHb8qxirNMXwW
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1015 mlxscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130137
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Paolo and/or Thomas: if you do not have objections, could you pick this
series?

every affected architecture has been reviewed :)


On Mon, 12 Dec 2022 12:17:27 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> v2->v3:
> ---
> * s390x: remove unneeded parenthesis (thanks Claudio)
> 
> v1->v2:
> ---
> * arm: commit message gib->gic (thanks Andrew)
> * arm: remove unneeded {} (thanks Andrew)
> * s390x: make patch less intrusive (thanks Claudio)
> 
> With this series, I pick up a suggestion Claudio has brought up in my
> CMM-migration series[1].
> 
> Migration tests can ask migrate_cmd to migrate them to a new QEMU
> process. Requesting migration and waiting for completion is hence a
> common pattern which is repeated all over the code base. Add a function
> which does all of that to avoid repetition.
> 
> Since migrate_cmd currently can only migrate exactly once, this function
> is called migrate_once() and is a no-op when it has been called before.
> This can simplify the control flow, especially when tests are skipped.
> 
> [1] https://lore.kernel.org/kvm/20221125154646.5974cb52@p-imbrenda/
> 
> Nico Boehr (4):
>   lib: add function to request migration
>   powerpc: use migrate_once() in migration tests
>   s390x: use migrate_once() in migration tests
>   arm: use migrate_once() in migration tests
> 
>  arm/Makefile.common     |  1 +
>  powerpc/Makefile.common |  1 +
>  s390x/Makefile          |  1 +
>  lib/migrate.h           |  9 ++++++++
>  lib/migrate.c           | 34 ++++++++++++++++++++++++++++
>  arm/debug.c             | 17 +++++---------
>  arm/gic.c               | 49 ++++++++++++-----------------------------
>  powerpc/sprs.c          |  4 ++--
>  s390x/migration-cmm.c   | 24 ++++++--------------
>  s390x/migration-sck.c   |  4 ++--
>  s390x/migration-skey.c  | 20 ++++++-----------
>  s390x/migration.c       |  7 ++----
>  12 files changed, 85 insertions(+), 86 deletions(-)
>  create mode 100644 lib/migrate.h
>  create mode 100644 lib/migrate.c
> 

