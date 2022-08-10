Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D7458EC02
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 14:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiHJMaC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 08:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232308AbiHJM3f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 08:29:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0FA74DF5
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 05:29:34 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AAYxKh019200
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:29:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=k8bpOkvzOdmnuG8Cr7xgO7pc0Xa712G4ywGxD0GTha0=;
 b=fEdyHtCbI4N61NGyQVfi8EN+Q+SM7cRMFhOUkz1w2+thNCXyTVhhqJxqBrI9pIrIljHN
 BL+P55aUSHgkx7xgrioGHFFKK+14lljG/7gvzgYFZUWB0XR/CoGqF+AdqWBruArB9f+i
 KqEBKe21dzHLzwKdLEWyi0y8l1RudZFoBdWJkSGKnjXcKxbxGxELf0FF6VIC1sX63/jh
 ehzKwQCoJ7eqE1QsmES6ikdrekm/lKUWRK6eTbru3OQtdWqDyC1E29ru4hwiVubEkj2e
 xZgg3u220kTNSw9q2O9JifZAujCaZlKYw0IMCudvjelI8jnb3+ROSKYf3QUCi5DjoNZD jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv5r6d614-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:29:33 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27AC8Cq4010617
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 12:29:32 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv5r6d60a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:29:32 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27ACRL2n014892;
        Wed, 10 Aug 2022 12:29:31 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3huwvg0tpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:29:30 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27ACTRpu29098338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 12:29:27 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C83DB42047;
        Wed, 10 Aug 2022 12:29:27 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC57942045;
        Wed, 10 Aug 2022 12:29:27 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.57.169])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Aug 2022 12:29:27 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220810120822.51ead12d@p-imbrenda>
References: <20220722060043.733796-1-nrb@linux.ibm.com> <20220722060043.733796-4-nrb@linux.ibm.com> <20220810120822.51ead12d@p-imbrenda>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/4] s390x: add extint loop test
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Message-ID: <166013456744.24812.12686537606143025741@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Wed, 10 Aug 2022 14:29:27 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vZIoibSbQVWrrHdQSiKy5_hBpLgFX5v8
X-Proofpoint-ORIG-GUID: QJ_X_tgWUA1yfjFgQlhurECGTJhe9Et0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_06,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 spamscore=0 phishscore=0
 mlxlogscore=732 suspectscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-08-10 12:08:22)
> > diff --git a/s390x/panic-loop-extint.c b/s390x/panic-loop-extint.c
> > new file mode 100644
> > index 000000000000..d3a3f06d9a34
> > --- /dev/null
> > +++ b/s390x/panic-loop-extint.c
[...]
> > +static void ext_int_handler(void)
> > +{
> > +     /*
> > +      * return to ext_old_psw. This gives us the chance to print the r=
eturn_fail
> > +      * in case something goes wrong.
> > +      */
> > +     asm volatile (
> > +             "lpswe %[ext_old_psw]\n"
> > +             :
> > +             : [ext_old_psw] "Q"(lowcore.ext_old_psw)
> > +             : "memory"
> > +     );
> > +}
>=20
> why should ext_old_psw contain a good PSW? wouldn't it contain the
> PSW at the time of the interrupt? (which in this case is the new PSW)

That's right in case the interrupt loop occurs, it doesn't make much sense =
to return to ext_old_psw. But in this case lpswe will never be executed any=
ways.

> but this should never happen anyway, right?

Exactly, this is just supposed to be a safety net in case the interrupt loo=
p doesn't happen. If you want, we could remove it and just leave an empty f=
unction here. Then, we will just run into the kvm-unit-tests timeout and fa=
il as well, but I prefer the fail fast.
