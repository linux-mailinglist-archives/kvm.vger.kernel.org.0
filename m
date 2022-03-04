Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312FE4CD689
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 15:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238107AbiCDOj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 09:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbiCDOj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 09:39:28 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B86D19BE;
        Fri,  4 Mar 2022 06:38:40 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 224CsojJ011127;
        Fri, 4 Mar 2022 14:38:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=ldUQFnRKDVMp9QpsjcP9Q7G86YNmkZFa99VvTcZbteU=;
 b=EUbIUZmQeykVLFoVY1PIRnjIYAeHbXzEgMkgsj9A+owEEPdICzYit5jMd4yroJOL3KvD
 mK4vpd86jGVgCIILOUvwzg9JrWxJpXPmoP/yewLJEfPXRlfem9+VM0Un8C3wAe9VHJMQ
 J1cwmXuIvznv+yArP7CWoMS865Dnfv4ltbrUkyEJhWNPWSzSJAkedXHeDLEkENT3dTIG
 FEE8A9n3N1NmQVWSehk/UxFFzvMODZl+uV3QLb0CusI8rBGg/zBhl6c+KMcIFg37r+DF
 V4TDi3Ff/id1ZGyExgrSSPu7qQioELYpYenN95HJNueBVI9yaro5Zn/9N0Ufst37x1Mk Bw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekk6m22qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 14:38:40 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 224EMvKF022071;
        Fri, 4 Mar 2022 14:38:39 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ekk6m22q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 14:38:39 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 224EbvaR009210;
        Fri, 4 Mar 2022 14:38:38 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 3ek4kaxmbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 14:38:38 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 224EcarA45285808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Mar 2022 14:38:36 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D56A7112064;
        Fri,  4 Mar 2022 14:38:36 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE7D4112063;
        Fri,  4 Mar 2022 14:38:34 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.148.123])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  4 Mar 2022 14:38:34 +0000 (GMT)
Message-ID: <911551ce6154655dc3257aec307ccbd3a3843d0b.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v1 3/6] s390x: smp: Fix checks for SIGP
 STOP STORE STATUS
From:   Eric Farman <farman@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Fri, 04 Mar 2022 09:38:33 -0500
In-Reply-To: <fcacf11f-6469-8c70-9db5-0bb55e77fcdf@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
         <20220303210425.1693486-4-farman@linux.ibm.com>
         <fcacf11f-6469-8c70-9db5-0bb55e77fcdf@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -EuJ5SYUSq6nJpVTp4HzCGyHdEmuBqTf
X-Proofpoint-ORIG-GUID: auWNeoVW4_2USMKjJxBTRmZB3Lng2o7F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_06,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:40 +0100, Janosch Frank wrote:
> On 3/3/22 22:04, Eric Farman wrote:
> > In the routine test_stop_store_status(), the "running" part of
> > the test checks a few of the fields in lowcore (to verify the
> > "STORE STATUS" part of the SIGP order), and then ensures that
> > the CPU has stopped. But this is backwards, and leads to false
> > errors.
> > 
> > According to the Principles of Operation:
> >    The addressed CPU performs the stop function, fol-
> >    lowed by the store-status operation (see “Store Sta-
> >    tus” on page 4-82).
> > 
> > By checking the results how they are today, the contents of
> > the lowcore fields are unreliable until the CPU is stopped.
> > Thus, check that the CPU is stopped first, before ensuring
> > that the STORE STATUS was performed correctly.
> 
> The results are undefined until the cpu is not busy via SIGP sense,
> no?
> You cover that via doing the smp_cpu_stopped() check since that does
> a 
> sigp sense.
> 
> Where the stop check is located doesn't really matter since the
> library 
> waits until the cpu is stopped and it does that via smp_cpu_stopped()
> 
> 
> So:
> Are we really fixing something here?

Hrm, I thought so, but I got focused on the order of these checks and
overlooked the point that the library already does this looping. I do
trip up on these checks; let me revisit them.

> 
> Please improve the commit description.
> For me this looks more like making checks more explicit and
> symmetrical 
> which I'm generally ok with. We just need to specify correctly why
> we're 
> doing that.
> 
> > While here, add the same check to the second part of the test,
> > even though the CPU is explicitly stopped prior to the SIGP.
> > 
> > Fixes: fc67b07a4 ("s390x: smp: Test stop and store status on a
> > running and stopped cpu")
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
> > ---
> >   s390x/smp.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/s390x/smp.c b/s390x/smp.c
> > index 2f4af820..50811bd0 100644
> > --- a/s390x/smp.c
> > +++ b/s390x/smp.c
> > @@ -98,9 +98,9 @@ static void test_stop_store_status(void)
> >   	lc->grs_sa[15] = 0;
> >   	smp_cpu_stop_store_status(1);
> >   	mb();
> > +	report(smp_cpu_stopped(1), "cpu stopped");
> >   	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore,
> > "prefix");
> >   	report(lc->grs_sa[15], "stack");
> > -	report(smp_cpu_stopped(1), "cpu stopped");
> >   	report_prefix_pop();
> >   
> >   	report_prefix_push("stopped");
> > @@ -108,6 +108,7 @@ static void test_stop_store_status(void)
> >   	lc->grs_sa[15] = 0;
> >   	smp_cpu_stop_store_status(1);
> >   	mb();
> > +	report(smp_cpu_stopped(1), "cpu stopped");
> >   	report(lc->prefix_sa == (uint32_t)(uintptr_t)cpu->lowcore,
> > "prefix");
> >   	report(lc->grs_sa[15], "stack");
> >   	report_prefix_pop();

