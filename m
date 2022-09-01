Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6EF5A9C9C
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 18:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbiIAQIe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 12:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbiIAQI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 12:08:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3737390C61;
        Thu,  1 Sep 2022 09:08:26 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281FQRHG027904;
        Thu, 1 Sep 2022 16:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=Dils1zlfD+18lr9a0ceKjhxPZS6LnPxli3egH1u8tC8=;
 b=NxuPGOzytuh/a2WjV6Z2eliW5DxwzqgLRvw6iNdfVUazysV/2IVfZjnpRhXLqfRVPx++
 R2b+XpTJdTwyq5ZYHQpdvNtqoOvMJcFwJsXYwiQatcqF9Sv95AvmVabxEr5xcBnPCIEz
 xPdzn+M84Q3G7DD7uQbnte2TtDDivCnEXAsEbEehNURISD1wKZbNHT/uw9wy16QkBxTg
 aEeb/Ec3ROtul0MAaYjK8HfZ6qTAP0LO1NdE5CYZt4i7MScHjGMrFhd7RSFiEJoxnjp2
 sSVBiyfJ0VUsymnyFqRgxCqDeEz64Qb0KhWZUXuu69LSG46gUpXq12gxRoZR8JQ5PPw1 rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jax0meurq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 16:08:25 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 281FwOMj002484;
        Thu, 1 Sep 2022 16:08:24 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jax0meupw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 16:08:24 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 281Fp7o0026195;
        Thu, 1 Sep 2022 16:08:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3j7aw8w46t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Sep 2022 16:08:21 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 281G50Uf38732110
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Sep 2022 16:05:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE4D54203F;
        Thu,  1 Sep 2022 16:08:17 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D3D442041;
        Thu,  1 Sep 2022 16:08:17 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.52.204])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Sep 2022 16:08:17 +0000 (GMT)
Message-ID: <03cdbf24b5c5d7024b1108d65c2c478073dab515.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v6 2/2] s390x: Test specification
 exceptions during transaction
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Date:   Thu, 01 Sep 2022 18:08:17 +0200
In-Reply-To: <166204436392.25136.10832970166586747913@t14-nrb>
References: <20220826161112.3786131-1-scgl@linux.ibm.com>
         <20220826161112.3786131-3-scgl@linux.ibm.com>
         <166204436392.25136.10832970166586747913@t14-nrb>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6RsK7vaNDnRLhDhyPv5cAPdePiVUqFvC
X-Proofpoint-ORIG-GUID: futAFD7VXT72iFjEfSQnozRRg_K1pebi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_10,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 adultscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010071
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-09-01 at 16:59 +0200, Nico Boehr wrote:
> Quoting Janis Schoetterl-Glausch (2022-08-26 18:11:12)
> > diff --git a/s390x/spec_ex.c b/s390x/spec_ex.c
> > index 68469e4b..56f26564 100644
> [...]
> > +#define TRANSACTION_COMPLETED 4
> > +#define TRANSACTION_MAX_RETRIES 5
> > +
> > +/*
> > + * NULL must be passed to __builtin_tbegin via constant, forbid diagnose from
> > + * being NULL to keep things simple
> > + */
> 
> For some reason, it took me a while to get this, because the context was not clear to me. Maybe rephrase it a tiny bit:
> 
> If diagnose should be NULL, it must be passed to __builtin_tbegin via constant, so forbid NULL to keep things simple
> 
> [...]
> > +static void test_spec_ex_trans(struct args *args, const struct spec_ex_trigger *trigger)
> > +{
> [...]
> > +       case TRANSACTION_MAX_RETRIES:
> > +               report_skip("Transaction retried %lu times with transient failures, giving up",
> > +                           args->max_retries);
> 
> Hmhm, I am unsure whether a skip is the right thing here. On one hand, it might hide bugs, on the other hand, it might cause spurious failures. Why did you decide for the skip?

Yeah, it's a toss-up. Claudio asked me to change it in v4.
