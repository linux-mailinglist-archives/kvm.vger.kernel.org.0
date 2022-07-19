Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A11D579350
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 08:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbiGSGfj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 02:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234732AbiGSGfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 02:35:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8440E64E3;
        Mon, 18 Jul 2022 23:35:36 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26J6KYjf001622;
        Tue, 19 Jul 2022 06:35:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : to : from : message-id : date; s=pp1;
 bh=6y8Zz1RWIdIfH6tVgX35u4FKFu5yOxuCBQAlC9WQuvM=;
 b=bafd8+kztTugDjVZSacoab1mPy3vgzuhjnm/fmNXlna9rwJlKFsmsqTfle9oaPx/hucx
 dDtY8qiilvDvQu3plyH3c4UgWFI0vaUMXUMNPAd52qpiauz0zXnSpGOQOUiKLu81biUT
 1z4NJde2I0T7M/34JMwgcxjx8GePnyTgwjlC2IREPAsD7huTYt/PvLLDfT2R3AjSuFcX
 w+FBJqBcIFQnl14odD3kFs03Q0qraKDDpKK+d6Yx51kikDPKtDhnuewr0NzX/CsKUAnb
 uTEE9kXoicNX3vpXgCAa+QqqfvGyU2FYVdxtByxHzApFccqiS5Uzbk3Bwako1IXvMapo ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdq8ugcn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 06:35:36 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26J6LKKL004546;
        Tue, 19 Jul 2022 06:35:35 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hdq8ugck8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 06:35:35 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26J6KcVu029499;
        Tue, 19 Jul 2022 06:35:33 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3hbmy8up31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jul 2022 06:35:33 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26J6ZUBC20119872
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 06:35:30 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6967A4057;
        Tue, 19 Jul 2022 06:35:30 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEF7DA4051;
        Tue, 19 Jul 2022 06:35:30 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.10.188])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jul 2022 06:35:30 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220705102011.1cf2237e@p-imbrenda>
References: <20220704121328.721841-1-nrb@linux.ibm.com> <20220704121328.721841-3-nrb@linux.ibm.com> <20220705102011.1cf2237e@p-imbrenda>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/4] lib: s390x: add CPU timer functions to time.h
To:     kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <165821253050.15145.12865499120775236740@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Tue, 19 Jul 2022 08:35:30 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wWtlrosKt1ru8q5gdSHM6-Bp7D-b0ETp
X-Proofpoint-ORIG-GUID: _8KVtseP6p1adF6yK6dGvLcTUKxeiKyO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 spamscore=0 impostorscore=0 suspectscore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207190027
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-07-05 10:20:11)

Sorry Claudio, missed your mail as well...

> > diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> > index 7652a151e87a..9ae364afb8a3 100644
> > --- a/lib/s390x/asm/time.h
> > +++ b/lib/s390x/asm/time.h
> > @@ -11,9 +11,13 @@
[...]
> > +#define TIMING_S390_SHIFT_US (63 - 51)
>=20
> I would call it S390_CLOCK_SHIFT_US

Will do.

[...]
> > +static inline void cpu_timer_set(int64_t timeout_ms)
>=20
> I would call the function cpu_timer_set_ms
>=20
> so that it's clear what unit goes in, and it makes things easier if in
> the future someone needs a _us version

Makes sense, that's also how the other functions are, so it is more consist=
ent.
