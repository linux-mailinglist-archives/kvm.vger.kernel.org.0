Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08DB15A93D9
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 12:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiIAKDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 06:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbiIAKC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 06:02:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33073137D98
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 03:02:53 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2819MeHj014565
        for <kvm@vger.kernel.org>; Thu, 1 Sep 2022 10:02:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 subject : from : cc : message-id : date; s=pp1;
 bh=OQTZ7VzrEDxPzTzuol1FZh81Qdz4V4L4XytRzWEbgbI=;
 b=BxBoULbhHmphTa2dcjNGLc7wkgP2dncEUoYJt4VIuucLvJ6cHPzsu8uFzTxD5AyBQkgb
 dFyft4aNEhxhf1ewiU9mK9wXewGkNukw5nHXqMhjKD6Ek3DeP+2eNHz2PU8c9zNU2dDd
 Z1uu3g3tarl0oEEejM9r4BLYjdMBI2H9NhSecAlSeej7he7kjgOiWMm/oASFsipQFmtA
 liRyDIj35hM52pVwwKxqAdRB/hoUI+QE6h6KhXFq3AJcdEzp7Mj+wkRPoWQw5IORDC8N
 x9hUmx8v33RSKZA+509DKkQiXOEbBC6CLDODBwxChwkmUW+UIoLpCsT9GZoOtXtkPIbX Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jat26h89g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 10:02:52 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2819NDYM015344
        for <kvm@vger.kernel.org>; Thu, 1 Sep 2022 10:02:51 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jat26h885-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 10:02:51 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2819pamh028551;
        Thu, 1 Sep 2022 10:02:49 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3j7ahj6kvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 10:02:49 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 281A2kDi38863298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Sep 2022 10:02:46 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E3425205F;
        Thu,  1 Sep 2022 10:02:46 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.70.78])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 234EF52050;
        Thu,  1 Sep 2022 10:01:25 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <2867caf0-b944-6cf5-f0f5-2af5706feb49@redhat.com>
References: <20220830115623.515981-1-nrb@linux.ibm.com> <20220830115623.515981-2-nrb@linux.ibm.com> <2867caf0-b944-6cf5-f0f5-2af5706feb49@redhat.com>
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 1/2] lib/s390x: time: add wrapper for stckf
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
Message-ID: <166202646835.25136.2404033507305609692@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 01 Sep 2022 12:01:08 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -uiC02kvvPJ53QUucKg3rbWH8ZDvukrL
X-Proofpoint-ORIG-GUID: TL2KWN2JW__Y91cpVp3hKDuIMQrP3RFH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_06,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2209010045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2022-08-30 14:27:30)
[...]
> > diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
> > index 7652a151e87a..d7c2bcb4f306 100644
> > --- a/lib/s390x/asm/time.h
> > +++ b/lib/s390x/asm/time.h
> > @@ -14,6 +14,15 @@
> >   #define STCK_SHIFT_US       (63 - 51)
> >   #define STCK_MAX    ((1UL << 52) - 1)
> >  =20
> > +static inline uint64_t get_clock_fast(void)
> > +{
> > +     uint64_t clk;
> > +
> > +     asm volatile(" stckf %0 " : : "Q"(clk) : "memory");
> > +
> > +     return clk;
> > +}
>=20
> Using clk as input parameter together with memory clobbing sounds like a =
bad=20
> solution to me here. The Linux kernel properly uses it as output paramete=
r=20
> instead:
>=20
> static inline unsigned long get_tod_clock_fast(void)
> {
>          unsigned long clk;
>=20
>          asm volatile("stckf %0" : "=3DQ" (clk) : : "cc");
>          return clk;
> }

Yes, thanks, it is a better solution. get_clock_us() also does it this way,=
 so while at it let's fix that, too...
