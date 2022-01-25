Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7EF49B47C
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 14:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384527AbiAYNAh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 08:00:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62988 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1384528AbiAYM5i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 07:57:38 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PCK2wM003850;
        Tue, 25 Jan 2022 12:57:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=bnV43IDhnbn73XgH66pXLzvQyc/EZwGHvfAzRO6+zAs=;
 b=oXPZI5QqC/xF9TZ4fkwMwC+vNTR94kr7ZRAZT73H8yrVm8JYS2wZ09wCPmqFYm2nh/lw
 wuWwc/B1KtGwWMUGqIGyCkF/qy+mkjbyl8ZOIwZnt6aXgJxNZ34tmAMxoSLEgVgcBNxG
 HdRAK2xnH8dtdOHA0cVB3GEgloQHrgU8U0b+qiZjZnK/4BQJhucMCKcZY4y9otXPOt+I
 oBvkyXRaY0XX8GRcH/KA5E975igCaZ/CvBgj7A54pc4liuBd49qgxOTd8MKr81v/FZY7
 DIHF7fmsv5oQJlj8KhNsaWWzyKclOi+yd5HDcAnzlOlvdomfFb2Im+7sysDF+uSfdCsz vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dth2r0uy7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:57:33 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PCkbpo007644;
        Tue, 25 Jan 2022 12:57:33 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dth2r0uxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:57:33 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PCvOKK003847;
        Tue, 25 Jan 2022 12:57:31 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3dr9j964vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 12:57:31 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PClsjV49152436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 12:47:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D688AAE04D;
        Tue, 25 Jan 2022 12:57:26 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 72F90AE051;
        Tue, 25 Jan 2022 12:57:26 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.50.253])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 12:57:26 +0000 (GMT)
Message-ID: <c49a6f09765b4228097a5946bb805eb8d6a873e0.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v1 1/8] s390x: Add more tests for MSCH
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com
Date:   Tue, 25 Jan 2022 13:57:26 +0100
In-Reply-To: <aa2f0f15-56d3-5009-1741-5d3664286c46@redhat.com>
References: <20220121150931.371720-1-nrb@linux.ibm.com>
         <20220121150931.371720-2-nrb@linux.ibm.com>
         <aa2f0f15-56d3-5009-1741-5d3664286c46@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NpaxQ-sJioG4gPJ5Sbsi5isijGSzgFsA
X-Proofpoint-GUID: HCuIExmVZYa-eRyEMaKkbcvcyAfIaleB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_02,2022-01-25_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 spamscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-01-25 at 12:54 +0100, Thomas Huth wrote:
> On 21/01/2022 16.09, Nico Boehr wrote:
> 
[...]
> > diff --git a/s390x/css.c b/s390x/css.c
> > index 881206ba1cef..afe1f71bb576 100644
> > --- a/s390x/css.c
> > +++ b/s390x/css.c
> > @@ -27,6 +27,8 @@ static int test_device_sid;
> >   static struct senseid *senseid;
> >   struct ccw1 *ccw;
> >   
> > +char alignment_test_page[PAGE_SIZE]
> > __attribute__((aligned(PAGE_SIZE)));
> 
> Alternatively, you could also use alloc_page() in that new
> function... not 
> sure what's nicer, though.

I don't have a strong opinion. Happy to change to whatever you or the
others prefer.


> >   
> > +static void test_msch(void)
> > +{
[...]
> > +
> > +       report_prefix_push("Invalid SCHIB");
> > +       old_pmcw_flags = schib.pmcw.flags;
> > +       for (int i = 0; i < ARRAY_SIZE(invalid_pmcw_flags); i++) {
> > +               invalid_flag = invalid_pmcw_flags[i];
> > +
> > +               report_prefix_pushf("PMCW flag bit %d set",
> > invalid_flag);
> > +
> > +               schib.pmcw.flags = old_pmcw_flags | BIT(15 -
> > invalid_flag);
> > +               expect_pgm_int();
> > +               msch(test_device_sid, &schib);
> > +               check_pgm_int_code(PGM_INT_CODE_OPERAND);
> > +
> > +               report_prefix_pop();
> > +       }
> 
> Maybe restore schib.pmcw.flags = old_pmcw_flags at the end, in case
> someone 
> wants to add more tests later?

Yes, awesome idea, will do.

> 
> > +       report_prefix_pop();
> > +}
> > +
> >   static struct {
> >         const char *name;
> >         void (*func)(void);
> > @@ -343,6 +393,7 @@ static struct {
> >         { "measurement block (schm)", test_schm },
> >         { "measurement block format0", test_schm_fmt0 },
> >         { "measurement block format1", test_schm_fmt1 },
> > +       { "msch", test_msch },
> >         { NULL, NULL }
> >   };
> >   
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 

Thanks.

Nico

