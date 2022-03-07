Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8294D071F
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 20:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240129AbiCGTCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 14:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbiCGTCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 14:02:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A611D6D4E5;
        Mon,  7 Mar 2022 11:01:14 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227ItBC4005092;
        Mon, 7 Mar 2022 19:01:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=m4QikFF/CS6vrmKPYQS/PhKIDMuc2NEU9wg9EdzSYMI=;
 b=iGTaatq+wDiB3iEhV8cQ4hxlgWbL3ehmQzr+Ie5whir+ySZblE88ceQDrQlXmiJ/y7O0
 2VagFSlKch/xHoUfIwb32bfJAuSjQ4FiNcejiKdjVLL5lVknsBnI7GcR+dR1zqkigf+8
 L1Bt9Bitznjk4y+WMJlNdT+dx6Ri8DsWnfIvPUhisX3XfmBYs3u6CCyYNTCA/JZ+4Dy4
 iwFuUrmfKYfoYToppD38nKmtY8UUfp03Le9zP0cyRx7phzE14jKSDoqfJtl9Vcuz+pGg
 etZ3wK+y0apFLxUIh6WmFvbfQf3iTOoW3ZDMtDjAPkKV68sVQx+6fywUT7RbkkDMOPXD kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enq8v0qga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 19:01:14 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227J1D6C013439;
        Mon, 7 Mar 2022 19:01:13 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enq8v0qg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 19:01:13 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227IgORr028260;
        Mon, 7 Mar 2022 19:01:12 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 3ekyg97u8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 19:01:12 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227J1Ahj37224868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 19:01:11 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD357BE051;
        Mon,  7 Mar 2022 19:01:10 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A542BE058;
        Mon,  7 Mar 2022 19:01:10 +0000 (GMT)
Received: from farman-thinkpad-t470p (unknown [9.211.148.123])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  7 Mar 2022 19:01:10 +0000 (GMT)
Message-ID: <1d5dcce5a5b1716089f627fce9794341c55fb06e.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v1 4/6] s390x: smp: Create and use a
 non-waiting CPU stop
From:   Eric Farman <farman@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Mon, 07 Mar 2022 14:01:09 -0500
In-Reply-To: <1342ba11026d58fecf4e596a0e3942076ef53051.camel@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
         <20220303210425.1693486-5-farman@linux.ibm.com>
         <1342ba11026d58fecf4e596a0e3942076ef53051.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: k8BQIZ2N8UFvvKf6aSO9SA5QXN36xUmF
X-Proofpoint-GUID: XeOkNGajanudSDyIPr4GfYwtAJ82InRQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_10,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 mlxlogscore=932 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070106
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-03-07 at 14:31 +0100, Nico Boehr wrote:
> On Thu, 2022-03-03 at 22:04 +0100, Eric Farman wrote:
> [...]
> 
> > --- a/s390x/smp.c
> > +++ b/s390x/smp.c
> > @@ -76,14 +76,8 @@ static void test_restart(void)
> >  
> >  static void test_stop(void)
> >  {
> > -       smp_cpu_stop(1);
> > -       /*
> > -        * The smp library waits for the CPU to shut down, but
> > let's
> > -        * also do it here, so we don't rely on the library
> > -        * implementation
> > -        */
> > -       while (!smp_cpu_stopped(1)) {}
> > -       report_pass("stop");
> > +       smp_cpu_stop_nowait(1);
> 
> Now that this can fail because of CC=2, should we check the return
> value here?

Ah, yes it should. Thanks,

Eric

